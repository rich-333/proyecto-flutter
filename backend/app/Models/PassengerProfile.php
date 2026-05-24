<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PassengerProfile extends Model
{
    protected $fillable = [
        'user_id',
        'user_type',
        'current_balance',
        'verification_status',
        'birth_date',
        'institution'
    ];

    public function trip() {
        return $this->hasMany(Trip::class);
    }

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function documents() {
        return $this->hasMany(Document::class);
    }
}
