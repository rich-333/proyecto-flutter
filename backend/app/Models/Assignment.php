<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Assignment extends Model
{
    protected $fillable = [
        'driver_profile_id',
        'vehicle_id',
        'is_owner',
        'schedule_start',
        'schedule_end',
        'week_days',
        'assignment_date',
        'end_date',
        'active'
    ];

    public function trip() {
        return $this->hasMany(Trip::class);
    }
}
