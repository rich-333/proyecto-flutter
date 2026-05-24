<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\PassengerProfile;
use App\Models\Trip;
use App\Models\Assignment;
use App\Models\WalletTransaction;

class PassengerController extends Controller
{
    /**
     * Mostrar saldo disponible
     */
    public function getBalance(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'No autenticado'], 401);
        }

        $passengerProfile = $user->passengerProfile;

        if (!$passengerProfile) {
            return response()->json(['message' => 'Perfil de pasajero no encontrado'], 404);
        }

        return response()->json([
            'balance' => $passengerProfile->current_balance
        ]);
    }

    /**
     * Mostrar viajes recientes (con ruta, saldo descontado/aumentado, hora, fecha, tipo de usuario)
     */
    public function getRecentActivity(Request $request)
    {
        $user = $request->user();
        $passenger = $user->passengerProfile;

        if (!$passenger) {
            return response()->json(['message' => 'Perfil de pasajero no encontrado'], 404);
        }

        // Obtener últimos 10 viajes
        $trips = Trip::with(['assignment.route.line'])
            ->where('passenger_profile_id', $passenger->id)
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($trip) {
                return [
                    'type' => 'viaje',
                    'route' => $trip->assignment->route->origin . ' - ' . $trip->assignment->route->destination,
                    'line' => $trip->assignment->route->line->name ?? null,
                    'amount' => -$trip->amount_paid,
                    'user_type' => $trip->user_type_at_time,
                    'date' => $trip->created_at->format('Y-m-d'),
                    'time' => $trip->created_at->format('H:i:s'),
                ];
            });

        // Obtener últimas 10 recargas
        $recharges = WalletTransaction::where('passenger_profile_id', $passenger->id)
            ->where('type', 'recarga')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($tx) {
                return [
                    'type' => 'recarga',
                    'route' => null,
                    'line' => null,
                    'amount' => $tx->amount,
                    'user_type' => null,
                    'date' => $tx->created_at->format('Y-m-d'),
                    'time' => $tx->created_at->format('H:i:s'),
                ];
            });

        // Combinar, ordenar por fecha descendente y tomar los 10 más recientes globalmente
        $recent = $trips->merge($recharges)
            ->sortByDesc(function ($item) {
                return $item['date'] . ' ' . $item['time'];
            })
            ->values()
            ->take(10);

        return response()->json($recent);
    }

    /**
     * Mostrar historial de viajes (ruta, línea, pasaje pagado, tipo, fecha, hora),
     * recargas y saldo gastado en el mes.
     */
    public function getHistory(Request $request)
    {
        $user = $request->user();
        $passenger = $user->passengerProfile;

        if (!$passenger) {
            return response()->json(['message' => 'Perfil de pasajero no encontrado'], 404);
        }

        $month = $request->query('month', date('m'));
        $year = $request->query('year', date('Y'));

        $trips = Trip::with(['assignment.route.line'])
            ->where('passenger_profile_id', $passenger->id)
            ->whereMonth('created_at', $month)
            ->whereYear('created_at', $year)
            ->orderBy('created_at', 'desc')
            ->get();

        $recharges = WalletTransaction::where('passenger_profile_id', $passenger->id)
            ->where('type', 'recarga')
            ->whereMonth('created_at', $month)
            ->whereYear('created_at', $year)
            ->orderBy('created_at', 'desc')
            ->get();

        $totalSpent = $trips->sum('amount_paid');

        $history = [
            'trips' => $trips->map(function ($trip) {
                return [
                    'date' => $trip->created_at->format('Y-m-d'),
                    'time' => $trip->created_at->format('H:i:s'),
                    'route' => $trip->assignment->route->origin . ' - ' . $trip->assignment->route->destination,
                    'line' => $trip->assignment->route->line->name ?? null,
                    'amount_paid' => $trip->amount_paid,
                    'passenger_type' => $trip->user_type_at_time,
                ];
            }),
            'recharges' => $recharges->map(function ($tx) {
                return [
                    'date' => $tx->created_at->format('Y-m-d'),
                    'time' => $tx->created_at->format('H:i:s'),
                    'amount' => $tx->amount,
                    'description' => $tx->description,
                ];
            }),
            'total_spent_in_month' => $totalSpent,
        ];

        return response()->json($history);
    }

    /**
     * Recargar saldo (manualmente por el momento)
     */
    public function rechargeBalance(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0.1',
        ]);

        $user = $request->user();
        $passenger = $user->passengerProfile;

        if (!$passenger) {
            return response()->json(['message' => 'Perfil de pasajero no encontrado'], 404);
        }

        DB::transaction(function () use ($passenger, $request) {
            $balanceBefore = $passenger->current_balance;
            $passenger->current_balance += $request->amount;
            $passenger->save();

            WalletTransaction::create([
                'passenger_profile_id' => $passenger->id,
                'type' => 'recarga',
                'amount' => $request->amount,
                'balance_before' => $balanceBefore,
                'balance_after' => $passenger->current_balance,
                'description' => 'Recarga manual de saldo',
            ]);
        });

        return response()->json([
            'message' => 'Saldo recargado exitosamente',
            'new_balance' => $passenger->current_balance
        ]);
    }

    /**
     * Obtener la tarifa según el tipo de usuario
     */
    private function getFareForUserType($userType)
    {
        $fares = [
            'estudiante_escolar' => 0.50,
            'estudiante_universitario' => 1.00,
            'adulto_mayor' => 1.00,
            'discapacitado' => 0.00,
            'general' => 2.00,
        ];

        return $fares[$userType] ?? 2.00;
    }

    /**
     * Mostrar la ruta, línea, tipo de usuario, tarifa aplicada y saldo restante 
     * para mostrarlo en la pantalla confirmación de pago.
     */
    public function previewPayment(Request $request)
    {
        $request->validate([
            'qr_data' => 'required|string', 
        ]);

        $assignmentId = $this->parseQrData($request->qr_data);
        $assignment = Assignment::with('route.line')->find($assignmentId);

        if (!$assignment) {
            return response()->json(['message' => 'Código QR inválido o viaje no encontrado'], 404);
        }

        $user = $request->user();
        $passenger = $user->passengerProfile;

        if (!$passenger) {
            return response()->json(['message' => 'Perfil de pasajero no encontrado'], 404);
        }
        
        $fare = $this->getFareForUserType($passenger->user_type);
        $remainingBalance = $passenger->current_balance - $fare;

        return response()->json([
            'route' => $assignment->route->origin . ' - ' . $assignment->route->destination,
            'line' => $assignment->route->line->name ?? null,
            'user_type' => $passenger->user_type,
            'fare_applied' => $fare,
            'current_balance' => $passenger->current_balance,
            'remaining_balance_after_payment' => $remainingBalance,
            'can_pay' => $remainingBalance >= 0,
        ]);
    }

    /**
     * Hacer pagos mediante el qr y descontar saldo.
     * Mostrar el monto pagado, la hora, la ruta para la pantalla de "pago correctamente".
     */
    public function payTrip(Request $request)
    {
        $request->validate([
            'qr_data' => 'required|string',
        ]);

        $assignmentId = $this->parseQrData($request->qr_data);
        $assignment = Assignment::with('route.line')->find($assignmentId);

        if (!$assignment) {
            return response()->json(['message' => 'Código QR inválido o viaje no encontrado'], 404);
        }

        $user = $request->user();
        $passenger = $user->passengerProfile;

        if (!$passenger) {
            return response()->json(['message' => 'Perfil de pasajero no encontrado'], 404);
        }
        
        $fare = $this->getFareForUserType($passenger->user_type);

        if ($passenger->current_balance < $fare) {
            return response()->json(['message' => 'Saldo insuficiente'], 400);
        }

        $trip = DB::transaction(function () use ($passenger, $assignment, $fare, $request) {
            $balanceBefore = $passenger->current_balance;
            $passenger->current_balance -= $fare;
            $passenger->save();

            WalletTransaction::create([
                'passenger_profile_id' => $passenger->id,
                'type' => 'pago_viaje',
                'amount' => $fare,
                'balance_before' => $balanceBefore,
                'balance_after' => $passenger->current_balance,
                'description' => 'Pago de pasaje',
            ]);

            return Trip::create([
                'passenger_profile_id' => $passenger->id,
                'assignment_id' => $assignment->id,
                'amount_paid' => $fare,
                'user_type_at_time' => $passenger->user_type,
                'payment_status' => 'completado',
                'qr_used' => $request->qr_data,
            ]);
        });

        return response()->json([
            'message' => 'Pago realizado correctamente',
            'paid_amount' => $trip->amount_paid,
            'time' => $trip->created_at->format('H:i:s'),
            'date' => $trip->created_at->format('Y-m-d'),
            'route' => $assignment->route->origin . ' - ' . $assignment->route->destination,
        ]);
    }

    /**
     * Extraer ID del assignment desde el QR.
     */
    private function parseQrData($qrData)
    {
        $data = json_decode($qrData, true);
        return $data['assignment_id'] ?? $qrData;
    }
}

