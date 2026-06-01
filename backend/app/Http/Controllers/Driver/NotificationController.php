<?php

namespace App\Http\Controllers\Driver;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function getUnread(Request $request)
    {
        $driver = $request->user();
        
        $notifications = Notification::where('driver_profile_id', $driver->driverProfile->id)
            ->where('read', false)
            ->oldest()
            ->get();

        return response()->json([
            'status' => true,
            'message' => 'Notificaciones obtenidas correctamente',
            'data' => $notifications
        ], 200);
    }

    public function markAsRead(Request $request, $id)
    {
        $driver = $request->user();
        
        $notification = Notification::where('driver_profile_id', $driver->driverProfile->id)
            ->where('id', $id)
            ->first();

        if ($notification) {
            $notification->read = true;
            $notification->save();
            
            return response()->json([
                'status' => true,
                'message' => 'Notificación marcada como leída',
                'data' => $notification
            ], 200);
        }

        return response()->json([
            'status' => false,
            'message' => 'Notificación no encontrada'
        ], 404);
    }
}
