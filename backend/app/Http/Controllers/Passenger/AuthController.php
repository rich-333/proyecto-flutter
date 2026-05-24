<?php

namespace App\Http\Controllers\Passenger;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\PassengerProfile;
use App\Models\Document;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'full_name' => 'required|string|max:255',
            'ci' => 'required|string|max:20|unique:users,ci',
            'phone' => 'required|string|max:20',
            'email' => 'required|string|email|max:255|unique:users,email',
            'password' => 'required|string|min:8',
            'birth_date' => 'required|date',
            'user_type' => 'required|in:estudiante_escolar,estudiante_universitario,adulto_mayor,discapacitado,general',
            'document_image' => 'required_unless:user_type,general|image|mimes:jpeg,png,jpg|max:5120',
        ]);

        try {
            DB::beginTransaction();

            $user = User::create([
                'role' => 'pasajero',
                'full_name' => $request->full_name,
                'ci' => $request->ci,
                'phone' => $request->phone,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'active' => true,
            ]);

            $verificationStatus = $request->user_type === 'general' ? 'verificado' : 'pendiente';

            $profile = PassengerProfile::create([
                'user_id' => $user->id,
                'user_type' => $request->user_type,
                'birth_date' => $request->birth_date,
                'verification_status' => $verificationStatus,
                'current_balance' => 0,
            ]);

            if ($request->user_type !== 'general' && $request->hasFile('document_image')) {
                $path = $request->file('document_image')->store('documents', 'public');
                
                $docType = match($request->user_type) {
                    'estudiante_universitario' => 'carnet_universitario',
                    'discapacitado' => 'carnet_de_discapacitado',
                    default => 'carnet_de_identidad'
                };

                Document::create([
                    'passenger_profile_id' => $profile->id,
                    'document_type' => $docType,
                    'image_url' => $path,
                    'status' => 'pendiente',
                ]);
            }

            DB::commit();

            $token = $user->createToken('passenger-token')->plainTextToken;

            return response()->json([
                'message' => 'Usuario registrado exitosamente',
                'user' => $user,
                'profile' => $profile,
                'token' => $token,
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Error al registrar al pasajero',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function login(Request $request) {
        $request->validate([
            'email' => 'required|email|max:255|string',
            'password' => 'required|string|min:8'
        ]);

        $credentials = [
            'email' => $request->email,
            'password' => $request->password,
            'role' => 'pasajero'
        ];

        if(!Auth::attempt($credentials)) {
            return response()->json([
                'status' => false,
                'message' => 'Email o contrasena incorrecta o no autorizado'
            ], 401);
        }

        /** @var \App\Models\User $user */
        $user = Auth::user();

        $token = $user->createToken('passenger_session_token')->plainTextToken;

        return response()->json([
            'status' => true,
            'message' => 'Inicio de sesion valido',
            'token' => $token,
            'data' =>$user->load('passengerProfile')
        ], 200);
    }

    public function logout(Request $request) {
        $user = $request->user();

        $user->currentAccessToken()->delete();

        return response()->json([
            'status' => true,
            'message' => 'Sesion cerrada correctamente'
        ], 200);
    }
}
