<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Itinerary extends Model
{
    protected $fillable = ['user_id', 'title', 'destination', 'start_date', 'end_date', 'notes'];

    protected $casts = ['start_date' => 'date:Y-m-d', 'end_date' => 'date:Y-m-d'];

    public function items()
    {
        return $this->hasMany(ItineraryItem::class)->orderBy('day')->orderBy('time');
    }
}
