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
        Schema::create('payments', function (Blueprint $table) {
            $table->id();

            $table->foreignId('passenger_profile_id')
                ->constrained('passenger_profiles')
                ->cascadeOnDelete();

            $table->decimal('amount', 10, 2);

            $table->enum('method', [
                'simulated',
                'witness'
            ])->default('simulated');

            $table->enum('status', [
                'completed',
                'pending',
                'failed'
            ])->default('completed');

            $table->string('reference')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
