<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Hotel;
use App\Models\Place;
use App\Models\Restaurant;
use App\Models\Review;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class ReviewController extends Controller
{
    private function resolveType(?string $type): string
    {
        $class = ['hotel' => Hotel::class, 'place' => Place::class, 'restaurant' => Restaurant::class][$type] ?? null;
        abort_unless($class, 422, 'type must be hotel, place or restaurant.');

        return $class;
    }

    // GET /api/reviews?type=hotel&id=1
    public function index(Request $request): JsonResponse
    {
        $class = $this->resolveType($request->query('type'));

        $reviews = Review::with('user:id,name')
            ->where('reviewable_type', $class)
            ->where('reviewable_id', $request->integer('id'))
            ->latest()
            ->get();

        return response()->json($reviews);
    }

    // POST /api/reviews  (one review per user per item; posting again updates it)
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'type' => 'required|string',
            'id' => 'required|integer',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        $class = $this->resolveType($data['type']);
        $class::findOrFail($data['id']);

        $review = Review::updateOrCreate(
            ['user_id' => $request->user()->id, 'reviewable_type' => $class, 'reviewable_id' => $data['id']],
            ['rating' => $data['rating'], 'comment' => $data['comment'] ?? null]
        );

        return response()->json($review->load('user:id,name'), 201);
    }

    public function destroy(Request $request, int $id): Response
    {
        Review::where('user_id', $request->user()->id)->findOrFail($id)->delete();

        return response()->noContent();
    }
}
