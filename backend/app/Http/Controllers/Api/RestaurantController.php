<?php

namespace App\Http\Controllers\Api;

use App\Models\Restaurant;

class RestaurantController extends CatalogController
{
    protected function model(): string
    {
        return Restaurant::class;
    }

    protected function searchable(): array
    {
        return ['name', 'city', 'cuisine'];
    }

    protected function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'city' => 'required|string|max:100',
            'cuisine' => 'nullable|string|max:100',
            'address' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'price_range' => 'nullable|string|max:20',
            'rating' => 'nullable|numeric|min:0|max:5',
            'image_url' => 'nullable|string|max:500',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ];
    }
}
