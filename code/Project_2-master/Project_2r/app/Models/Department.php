<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    use HasFactory;
    protected $fillable = [
        'department_name_TH',
        'department_name_EN',
    ];
    public function user()
    {
        return $this->belongsToMany(User::class);
        
    }
}
