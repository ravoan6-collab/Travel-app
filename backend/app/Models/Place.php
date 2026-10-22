<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Place extends Model
{
    protected $fillable = ['name','city','category','description','rating','image_url','latitude','longitude'];

    protected $casts = ['rating' => 'float', 'latitude' => 'float', 'longitude' => 'float'];

    public function reviews()
    {
        return $this->morphMany(Review::class, 'reviewable');
    }
}
