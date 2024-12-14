<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Author extends Model
{
    use HasFactory;

    public function paper()
    {
        return $this->belongsToMany(Paper::class,'author_of_papers');
        // OR return $this->belongsTo('App\User');
    }
}
