<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Restaurant extends Model
{
    protected $fillable = ['name','city','cuisine','address','description','price_range','rating','image_url','latitude','longitude'];

    protected $casts = ['rating' => 'float', 'latitude' => 'float', 'longitude' => 'float'];

    public function reviews()
    {
        return $this->morphMany(Review::class, 'reviewable');
    }
}
