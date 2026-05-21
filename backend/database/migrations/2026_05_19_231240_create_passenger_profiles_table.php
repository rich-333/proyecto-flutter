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
        Schema::create('passenger_profiles', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->enum('user_type', [
                'estudiante_escolar',
                'estudiante_universitario',
                'adulto_mayor',
                'discapacitado',
                'general'
            ]);

            $table->decimal('current_balance', 10, 2)
                ->default(0);

            $table->enum('verification_status', [
                'pendiente',
                'verificado',
                'rechazado'
            ])->default('pendiente');

            $table->date('birth_date')->nullable();

            $table->string('institution')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('passenger_profiles');
    }
};
