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
        Schema::create('fares', function (Blueprint $table) {
            $table->id();

            $table->enum('user_type', [
                'school_student',
                'university_student',
                'senior_citizen',
                'disability',
                'general'
            ]);

            $table->decimal('amount_bs', 10, 2);

            $table->date('valid_from');

            $table->date('valid_until')->nullable();

            $table->boolean('active')->default(true);

            $table->string('updated_by')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('fares');
    }
};
