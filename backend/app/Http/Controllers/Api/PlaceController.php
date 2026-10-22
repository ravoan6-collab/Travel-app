<?php

namespace App\Http\Controllers\Api;

use App\Models\Place;

class PlaceController extends CatalogController
{
    protected function model(): string
    {
        return Place::class;
    }

    protected function searchable(): array
    {
        return ['name', 'city', 'category'];
    }

    protected function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'city' => 'required|string|max:100',
            'category' => 'nullable|string|max:100',
            'description' => 'nullable|string',
            'rating' => 'nullable|numeric|min:0|max:5',
            'image_url' => 'nullable|string|max:500',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ];
    }
}
