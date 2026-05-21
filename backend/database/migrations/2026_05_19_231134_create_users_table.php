<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();

            $table->enum('role', [
                'pasajero',
                'conductor'
            ]);

            // DATOS GENERALES
            $table->string('full_name');

            $table->string('ci', 20)
                ->unique();

            $table->string('phone', 20);

            // LOGIN PASAJEROS
            $table->string('email')
                ->nullable()
                ->unique();

            $table->string('password')
                ->nullable();

            // LOGIN CHOFERES
            $table->string('driver_code')
                ->nullable()
                ->unique();

            $table->string('pin')
                ->nullable();

            $table->boolean('active')
                ->default(true);

            $table->rememberToken();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
