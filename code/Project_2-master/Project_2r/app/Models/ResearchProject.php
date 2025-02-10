<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ResearchProject extends Model
{
    use HasFactory;
    protected $fillable = [
        'Project_name_TH', 'Project_name_EN','Project_start','Project_end','Funder','Budget','Note'
    ];

    public function user()
    {
        return $this->belongsToMany(User::class,'work_of_research_projects')->withPivot('role');
        // OR return $this->hasOne('App\Phone');
    }

    public function fund()
    {
        return $this->belongsToMany(Fund::class,'fund_of_research');
        // OR return $this->belongsTo('App\User');
    }
}
