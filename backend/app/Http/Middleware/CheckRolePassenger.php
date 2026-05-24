<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRolePassenger
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if(!$request->user() || $request->user()->role !== 'pasajero') {
            return response()->json([
                'status' => false,
                'message' => 'Acceso denegado. No tienes permisos de pasajero.'
            ]);
        }
    
        return $next($request);
    }
}
