<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Hotel;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        return response()->json($request->user()->bookings()->with('hotel')->latest()->get());
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'hotel_id' => 'required|exists:hotels,id',
            'check_in' => 'required|date|after_or_equal:today',
            'check_out' => 'required|date|after:check_in',
            'guests' => 'nullable|integer|min:1|max:20',
        ]);

        $hotel = Hotel::findOrFail($data['hotel_id']);
        $nights = max(1, (int) Carbon::parse($data['check_in'])->diffInDays(Carbon::parse($data['check_out'])));

        $booking = $request->user()->bookings()->create([
            'hotel_id' => $hotel->id,
            'check_in' => $data['check_in'],
            'check_out' => $data['check_out'],
            'guests' => $data['guests'] ?? 1,
            'total_price' => $hotel->price_per_night * $nights,
            'status' => 'confirmed',
        ]);

        return response()->json($booking->load('hotel'), 201);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        return response()->json($request->user()->bookings()->with('hotel')->findOrFail($id));
    }

    // DELETE = cancel (the booking stays in the database with status "cancelled")
    public function destroy(Request $request, int $id): JsonResponse
    {
        $booking = $request->user()->bookings()->findOrFail($id);
        $booking->update(['status' => 'cancelled']);

        return response()->json($booking);
    }
}
