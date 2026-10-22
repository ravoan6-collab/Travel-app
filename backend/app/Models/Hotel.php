<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Hotel extends Model
{
    protected $fillable = ['name','city','address','description','price_per_night','rating','image_url','latitude','longitude'];

    protected $casts = ['price_per_night' => 'float', 'rating' => 'float', 'latitude' => 'float', 'longitude' => 'float'];

    public function reviews()
    {
        return $this->morphMany(Review::class, 'reviewable');
    }
}
