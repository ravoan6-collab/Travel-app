<?php

namespace App\Http\Controllers\Api;

use App\Models\Hotel;

class HotelController extends CatalogController
{
    protected function model(): string
    {
        return Hotel::class;
    }

    protected function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'city' => 'required|string|max:100',
            'address' => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'price_per_night' => 'required|numeric|min:0',
            'rating' => 'nullable|numeric|min:0|max:5',
            'image_url' => 'nullable|string|max:500',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ];
    }
}
