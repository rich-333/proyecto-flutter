<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Driver\AuthController as DriverAuthController;
use App\Http\Controllers\Passenger\AuthController as PassengerAuthController;
use App\Http\Controllers\Passenger\PassengerController;
use App\Http\Controllers\Driver\TripController;
use App\Http\Controllers\Driver\NotificationController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Passenger Routes
Route::prefix('passenger')
    ->group(function () {
    Route::post('/register', [PassengerAuthController::class, 'register']);

    Route::post('/login', [PassengerAuthController::class, 'login']);
});

Route::middleware(['auth:sanctum', 'pasajero'])
    ->prefix('passenger')
    ->group(function () {

    Route::get('/balance', [PassengerController::class, 'getBalance']);
    Route::get('/recent-activity', [PassengerController::class, 'getRecentActivity']);
    Route::get('/history', [PassengerController::class, 'getHistory']);
    Route::post('/recharge-balance', [PassengerController::class, 'rechargeBalance']);
    Route::post('/preview-payment', [PassengerController::class, 'previewPayment']);
    Route::post('/pay-trip', [PassengerController::class, 'payTrip']);

    Route::post('logout', [PassengerAuthController::class, 'logout']);
});

// Driver Routes

Route::prefix('driver')
    ->group(function () {

    Route::post('/login', [DriverAuthController::class, 'login']);

});

Route::middleware(['auth:sanctum', 'conductor'])
    ->prefix('driver')
    ->group(function () {

    Route::get('/summary/passengers', [TripController::class, 'getDailyPassengers']);

    Route::get('/summary/collected', [TripController::class, 'getDailyCollectedMoney']);

    Route::get('/summary/breakdown', [TripController::class, 'getMoneyByTypeOfDailyPassenger']);
    
    Route::get('/payments/recent', [TripController::class, 'getRecentPayments']);

    Route::get('/notifications/unread', [NotificationController::class, 'getUnread']);
    Route::post('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);

    Route::post('/logout', [DriverAuthController::class, 'logout']);
});
