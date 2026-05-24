<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Trip extends Model
{
    protected $fillable = [
        'passenger_profile_id',
        'assignment_id',
        'amount_paid',
        'user_type_at_time',
        'payment_status',
        'qr_used'
    ];

    public function assignment() {
        return $this->belongsTo(Assignment::class);
    }

    public function passengerProfile() {
        return $this->belongsTo(PassengerProfile::class);
    }
}
