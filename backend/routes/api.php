<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\HotelController;
use App\Http\Controllers\Api\ItineraryController;
use App\Http\Controllers\Api\PlaceController;
use App\Http\Controllers\Api\RestaurantController;
use App\Http\Controllers\Api\ReviewController;
use Illuminate\Support\Facades\Route;

// ---- Public ----
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::apiResource('hotels', HotelController::class)->only(['index', 'show']);
Route::apiResource('places', PlaceController::class)->only(['index', 'show']);
Route::apiResource('restaurants', RestaurantController::class)->only(['index', 'show']);
Route::get('/reviews', [ReviewController::class, 'index']);

// ---- Needs a token (Authorization: Bearer <token>) ----
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::apiResource('hotels', HotelController::class)->except(['index', 'show']);
    Route::apiResource('places', PlaceController::class)->except(['index', 'show']);
    Route::apiResource('restaurants', RestaurantController::class)->except(['index', 'show']);

    Route::apiResource('itineraries', ItineraryController::class);
    Route::apiResource('bookings', BookingController::class)->only(['index', 'store', 'show', 'destroy']);

    Route::post('/reviews', [ReviewController::class, 'store']);
    Route::delete('/reviews/{id}', [ReviewController::class, 'destroy']);
});
