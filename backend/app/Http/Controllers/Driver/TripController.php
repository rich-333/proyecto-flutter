<?php

namespace App\Http\Controllers\Driver;

use App\Http\Controllers\Controller;
use App\Models\Trip;
use Illuminate\Http\Request;

class TripController extends Controller
{
    public function getDailyPassengers(Request $request) {
        $driver = $request->user();

        $total_passengers = Trip::whereHas('assignment', function($query) use ($driver) {
                $query->where('driver_profile_id', $driver->driverProfile->id);
            })
            ->whereDate('created_at', today())
            ->where('payment_status', 'completado')
            ->count();

        return response()->json([
            'status' => true,
            'message' => 'Total de pasajeros obtenidos correctamente',
            'data' => $total_passengers
        ], 200);
    }

    public function getDailyCollectedMoney(Request $request) {
        $driver = $request->user();

        $total_earned = Trip::whereHas('assignment', function($query) use ($driver) {
                $query->where('driver_profile_id', $driver->driverProfile->id);
            })
            ->whereDate('created_at', today())
            ->where('payment_status', 'completado')
            ->sum('amount_paid');

        return response()->json([
            'status' => true,
            'message' => 'Total de dinero recaudado obtenido correctamente',
            'data' => $total_earned
        ], 200);
    }

    public function getRecentPayments(Request $request) {
        $driver = $request->user();

        $recent_payments = Trip::whereHas('assignment', function($query) use ($driver) {
                $query->where('driver_profile_id', $driver->driverProfile->id);
            })
            ->where('payment_status', 'completado')
            ->latest()
            ->take(25)
            // ->with('passengerProfile.user') mostrar quién pagó
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Total de pagos recientes obtenidos correctamente',
            'data' => $recent_payments
        ], 200);
    }

    public function getMoneyByTypeOfDailyPassenger(Request $request) {
        $driver = $request->user();

        $breakdown = Trip::whereHas('assignment', function($query) use($driver) {
                $query->where('driver_profile_id', $driver->driverProfile->id);
            })
            ->whereDate('created_at', today())
            ->where('payment_status', 'completado')
            ->selectRaw('user_type_at_time, count(*) as count, sum(amount_paid) as total')
            ->groupBy('user_type_at_time')
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Total de pagos por tipo de pasajero obtenidos correctamente',
            'data' => $breakdown
        ], 200);
    }
}
