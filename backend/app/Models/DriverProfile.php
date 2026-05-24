<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DriverProfile extends Model
{
    protected $fillable = [
        'user_id',
        'active_session',
        'last_login',
    ];

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function assignment() {
        return $this->hasMany(Assignment::class);
    }

    /*obtener los vehículos directo desde el driver
    public function vehicles() {
        return $this->belongsToMany(Vehicle::class, 'assignments') // Utilizas assignments como tabla pivote
                    ->withPivot('is_owner', 'schedule_start', 'schedule_end'); // Si necesitas datos extras
    }*/
}
