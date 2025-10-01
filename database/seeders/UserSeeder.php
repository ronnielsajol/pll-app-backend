<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run()
    {
        User::create([
            'first_name' => 'Super',
            'last_name' => 'Admin',
            'email' => 'superadmin@test.com',
            'password' => Hash::make('12301230'),
            'contact_number' => '1234567890',
            'dob' => '1990-01-01',
            'role' => 'super_admin',
        ]);
    }
}
