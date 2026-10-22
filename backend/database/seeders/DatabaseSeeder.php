<?php

namespace Database\Seeders;

use App\Models\Hotel;
use App\Models\Place;
use App\Models\Restaurant;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Demo login: test@example.com / password123
        User::updateOrCreate(
            ['email' => 'test@example.com'],
            ['name' => 'Test User', 'password' => 'password123']
        );

        $hotels = [
            ['Angkor Palace Resort', 'Siem Reap', 'Sivutha Blvd', 'Pool, spa and temple tours.', 220, 4.7, 13.3633, 103.8564],
            ['Koh Rong Beach Villa', 'Sihanoukville', 'Koh Rong Island', 'Beachfront villa with ocean view.', 180, 4.6, 10.7200, 103.2900],
            ['Riverside Boutique Hotel', 'Phnom Penh', 'Sisowath Quay', 'Boutique hotel on the Mekong riverside.', 150, 4.5, 11.5600, 104.9300],
            ['Kampot River Lodge', 'Kampot', 'River Road', 'Quiet lodge beside the river.', 95, 4.4, 10.6100, 104.1800],
            ['Kep Sunset Bungalows', 'Kep', 'Kep Beach Road', 'Bungalows with sunset sea view.', 120.5, 4.3, 10.4800, 104.3200],
        ];
        foreach ($hotels as [$name, $city, $address, $desc, $price, $rating, $lat, $lng]) {
            Hotel::create([
                'name' => $name, 'city' => $city, 'address' => $address, 'description' => $desc,
                'price_per_night' => $price, 'rating' => $rating, 'latitude' => $lat, 'longitude' => $lng,
            ]);
        }

        $places = [
            ['Angkor Wat', 'Siem Reap', 'Temple', 'The largest religious monument in the world.', 4.9, 13.4125, 103.8670],
            ['Bayon Temple', 'Siem Reap', 'Temple', 'Famous for its many smiling stone faces.', 4.8, 13.4412, 103.8590],
            ['Royal Palace', 'Phnom Penh', 'Landmark', 'Royal residence and Silver Pagoda.', 4.6, 11.5645, 104.9310],
            ['Koh Rong', 'Sihanoukville', 'Beach', 'Island with white sand beaches.', 4.7, 10.7200, 103.3000],
            ['Bokor Mountain', 'Kampot', 'Nature', 'National park with old hill station ruins.', 4.5, 10.6270, 104.0450],
        ];
        foreach ($places as [$name, $city, $cat, $desc, $rating, $lat, $lng]) {
            Place::create([
                'name' => $name, 'city' => $city, 'category' => $cat, 'description' => $desc,
                'rating' => $rating, 'latitude' => $lat, 'longitude' => $lng,
            ]);
        }

        $restaurants = [
            ['Khmer Kitchen', 'Siem Reap', 'Khmer', 'Fish amok and Khmer curry.', '$$', 4.6],
            ['Riverside Seafood', 'Kampot', 'Seafood', 'Fresh crab with Kampot pepper.', '$$', 4.5],
            ['Phnom Penh Noodle House', 'Phnom Penh', 'Noodles', 'Kuy teav and local breakfast.', '$', 4.4],
            ['Sunset Grill', 'Sihanoukville', 'International', 'Grill and drinks by the beach.', '$$$', 4.3],
        ];
        foreach ($restaurants as [$name, $city, $cuisine, $desc, $range, $rating]) {
            Restaurant::create([
                'name' => $name, 'city' => $city, 'cuisine' => $cuisine, 'description' => $desc,
                'price_range' => $range, 'rating' => $rating,
            ]);
        }
    }
}
