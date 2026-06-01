<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;

    protected $fillable = [
        'driver_profile_id',
        'trip_id',
        'message',
        'read',
        'type',
    ];

    public function driverProfile()
    {
        return $this->belongsTo(DriverProfile::class);
    }

    public function trip()
    {
        return $this->belongsTo(Trip::class);
    }
}
