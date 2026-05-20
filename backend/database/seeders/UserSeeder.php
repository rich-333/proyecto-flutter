<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

use App\Models\User;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'role' => 'driver',
            'full_name' => 'Juan Perez',
            'ci' => '12345678',
            'phone' => '77912729',
            'email' => 'juan@gmail.com',
            'password' => Hash::make('password123'),
            'driver_code' => 'DRIVER001',
            'pin' => Hash::make('1234'),
            'active' => true,
        ]);
    }
}
