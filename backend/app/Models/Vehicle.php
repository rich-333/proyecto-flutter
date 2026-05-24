<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{
    protected $fillable = [
        'route_id',
        'plate',
        'fixed_qr',
        'status',
        'capacity',
        'schedule_start',
        'schedule_end'
    ];

    public function assignment() {
        return $this->hasMany(Assignment::class);
    }
}
