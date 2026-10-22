<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('hotels', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('city');
            $t->string('address')->nullable();
            $t->text('description')->nullable();
            $t->decimal('price_per_night', 8, 2);
            $t->decimal('rating', 2, 1)->default(0);
            $t->string('image_url', 500)->nullable();
            $t->decimal('latitude', 10, 7)->nullable();
            $t->decimal('longitude', 10, 7)->nullable();
            $t->timestamps();
        });

        Schema::create('places', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('city');
            $t->string('category')->nullable();
            $t->text('description')->nullable();
            $t->decimal('rating', 2, 1)->default(0);
            $t->string('image_url', 500)->nullable();
            $t->decimal('latitude', 10, 7)->nullable();
            $t->decimal('longitude', 10, 7)->nullable();
            $t->timestamps();
        });

        Schema::create('restaurants', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('city');
            $t->string('cuisine')->nullable();
            $t->string('address')->nullable();
            $t->text('description')->nullable();
            $t->string('price_range', 20)->nullable();
            $t->decimal('rating', 2, 1)->default(0);
            $t->string('image_url', 500)->nullable();
            $t->decimal('latitude', 10, 7)->nullable();
            $t->decimal('longitude', 10, 7)->nullable();
            $t->timestamps();
        });

        Schema::create('itineraries', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->string('title');
            $t->string('destination');
            $t->date('start_date')->nullable();
            $t->date('end_date')->nullable();
            $t->text('notes')->nullable();
            $t->timestamps();
        });

        Schema::create('itinerary_items', function (Blueprint $t) {
            $t->id();
            $t->foreignId('itinerary_id')->constrained()->cascadeOnDelete();
            $t->unsignedSmallInteger('day')->default(1);
            $t->string('time', 20)->nullable();
            $t->string('title');
            $t->text('notes')->nullable();
            $t->timestamps();
        });

        Schema::create('bookings', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->foreignId('hotel_id')->constrained()->cascadeOnDelete();
            $t->date('check_in');
            $t->date('check_out');
            $t->unsignedTinyInteger('guests')->default(1);
            $t->decimal('total_price', 10, 2);
            $t->string('status', 20)->default('confirmed');
            $t->timestamps();
        });

        Schema::create('reviews', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->morphs('reviewable');
            $t->unsignedTinyInteger('rating');
            $t->text('comment')->nullable();
            $t->timestamps();
            $t->unique(['user_id', 'reviewable_type', 'reviewable_id']);
        });
    }

    public function down(): void
    {
        foreach (['reviews', 'bookings', 'itinerary_items', 'itineraries', 'restaurants', 'places', 'hotels'] as $table) {
            Schema::dropIfExists($table);
        }
    }
};
