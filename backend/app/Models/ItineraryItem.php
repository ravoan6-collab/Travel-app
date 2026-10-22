<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ItineraryItem extends Model
{
    protected $fillable = ['itinerary_id', 'day', 'time', 'title', 'notes'];
}
