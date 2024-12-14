<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Paper extends Model
{
    use HasFactory;

    public function teacher()
    {
        return $this->belongsToMany(User::class,'teacher_papers');
    }

    public function source()
    {
        return $this->belongsToMany(Source_data::class,'source_papers');
    }
    public function author()
    {
        return $this->belongsToMany(Author::class,'author_of_papers');
        // OR return $this->hasOne('App\Phone');
    }
}
