<?php

namespace App\Http\Controllers\Driver;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Models\DriverProfile;
use App\Models\User;

class AuthController extends Controller
{
    public function Login(Request $request) 
    {
        $request->validate([
            'driver_code' => 'required|string|size:8'
        ]);

        $user = User::where('driver_code', $request->driver_code)
            ->whereHas('driverProfile')
            ->first();

        if (!$user) {
            return response()->json([
                'status' => false,
                'message' => 'Código de chofer incorrecto o no autorizado.'
            ], 401);
        }

        $driverProfile = $user->driverProfile;
        $driverProfile->active_session = true;
        $driverProfile->last_login = now();
        $driverProfile->save();

        $token = $user->createToken('driver_session_token')->plainTextToken;

        return response()->json([
            'status' => true,
            'message' => 'Jornada iniciada correctamente',
            'token' => $token,
            'data' => $user->load('driverProfile')
        ], 200);
    }

    public function logout(Request $request) {
        $user = $request->user();

        if($user->driverProfile) {
            $user->driverProfile->active_session = false;
            $user->driverProfile->save();
        }

        $user->currentAccessToken()->delete();

        return response()->json([
            'status' => true,
            'message' => 'Jornada finalizada y sesión cerrada correctamente.'
        ], 200);
    }
}
