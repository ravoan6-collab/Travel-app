<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $fillable = ['user_id', 'hotel_id', 'check_in', 'check_out', 'guests', 'total_price', 'status'];

    protected $casts = [
        'check_in' => 'date:Y-m-d',
        'check_out' => 'date:Y-m-d',
        'total_price' => 'float',
    ];

    public function hotel()
    {
        return $this->belongsTo(Hotel::class);
    }
}
