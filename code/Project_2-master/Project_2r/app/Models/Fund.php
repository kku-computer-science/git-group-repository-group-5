<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Fund extends Model
{
    use HasFactory;
    protected $fillable = [
        'fund_name',
        'fund_year',
        'fund_details',
        'fund_type',
        'fund_level',
    ];

    public function researchProject()
    {
        return $this->belongsToMany(ResearchProject::class,'fund_of_research');
        // OR return $this->belongsTo('App\User');
    }
}
