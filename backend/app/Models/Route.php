<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Route extends Model
{
    protected $fillable = [
        'line_id',
        'origin',
        'destination',
        'direction',
        'active'
    ];
}
