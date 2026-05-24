<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Document extends Model
{
    protected $fillable = [
        'passenger_profile_id',
        'document_type',
        'image_url',
        'status',
        'content_hash',
        'rejection_comments',
    ];

    public function passengerProfile()
    {
        return $this->belongsTo(PassengerProfile::class);
    }
}
