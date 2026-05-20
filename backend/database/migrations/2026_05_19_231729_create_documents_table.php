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
        Schema::create('documents', function (Blueprint $table) {
            $table->id();

            $table->foreignId('passenger_profile_id')
                ->constrained('passenger_profiles')
                ->cascadeOnDelete();

            $table->enum('document_type', [
                'identity_card',
                'student_credential',
                'disability_card',
                'senior_card'
            ]);

            $table->text('image_url');

            $table->enum('status', [
                'pending',
                'validated',
                'rejected'
            ])->default('pending');

            $table->string('content_hash')->nullable();

            $table->text('rejection_comments')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('documents');
    }
};
