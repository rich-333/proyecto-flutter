<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Line extends Model
{
    protected $fillable = [
        'name',
        'description',
        'active'
    ];

    public function route() {
        return $this->hasMany(Route::class);
    }
}
