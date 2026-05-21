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
        Schema::create('trips', function (Blueprint $table) {
            $table->id();

            $table->foreignId('passenger_profile_id')
                ->constrained('passenger_profiles')
                ->cascadeOnDelete();

            $table->foreignId('assignment_id')
                ->constrained('assignments')
                ->cascadeOnDelete();

            $table->foreignId('driver_profile_id')
                ->constrained('driver_profiles');

            $table->foreignId('vehicle_id')
                ->constrained('vehicles');

            $table->decimal('amount_paid', 10, 2);

            $table->enum('user_type_at_time', [
                'estudiante_escolar',
                'estudiante_universitario',
                'adulto_mayor',
                'discapacitado',
                'general'
            ]);

            $table->enum('payment_status', [
                'completado',
                'pendiente',
                'fallido',
                'reembolsado'
            ])->default('completado');

            $table->string('qr_used')->nullable();

            $table->decimal('latitude', 10, 8)->nullable();

            $table->decimal('longitude', 11, 8)->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('trips');
    }
};
