<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ResearchGroup extends Model
{
    use HasFactory;
    protected $fillable = [
        'Group_name_TH', 'Group_name_EN','Group_detail_TH','Group_detail_En','Group_detail_EN','Group_detail_TH','Group_image'
    ];

    public function user()
    {
        return $this->belongsToMany(User::class,'work_of_research_groups')->withPivot('role');
        // OR return $this->hasOne('App\Phone');
    }
}
