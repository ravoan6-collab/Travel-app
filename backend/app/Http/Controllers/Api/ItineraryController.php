<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class ItineraryController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        return response()->json($request->user()->itineraries()->with('items')->latest()->get());
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate($this->rules(false));
        $items = $data['items'] ?? [];
        unset($data['items']);

        $itinerary = $request->user()->itineraries()->create($data);
        $itinerary->items()->createMany($items);

        return response()->json($itinerary->load('items'), 201);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        return response()->json($request->user()->itineraries()->with('items')->findOrFail($id));
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $itinerary = $request->user()->itineraries()->findOrFail($id);
        $data = $request->validate($this->rules(true));
        $items = $data['items'] ?? null;
        unset($data['items']);

        $itinerary->update($data);

        if ($items !== null) {
            $itinerary->items()->delete();
            $itinerary->items()->createMany($items);
        }

        return response()->json($itinerary->load('items'));
    }

    public function destroy(Request $request, int $id): Response
    {
        $request->user()->itineraries()->findOrFail($id)->delete();

        return response()->noContent();
    }

    private function rules(bool $partial): array
    {
        $s = $partial ? 'sometimes|' : '';

        return [
            'title' => $s . 'required|string|max:255',
            'destination' => $s . 'required|string|max:255',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'notes' => 'nullable|string',
            'items' => 'nullable|array',
            'items.*.day' => 'nullable|integer|min:1',
            'items.*.time' => 'nullable|string|max:20',
            'items.*.title' => 'required|string|max:255',
            'items.*.notes' => 'nullable|string',
        ];
    }
}
