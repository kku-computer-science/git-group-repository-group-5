<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    use HasFactory, Notifiable,HasRoles;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'email',
        'role',
        'favoriteColor',
        'picture',
        'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];


    public function getPictureAttribute($value){
        if($value){
            return asset('users/images/'.$value);
        }else{
            return asset('users/images/no-image.png');
        }
    }
    public function researchProject()
    {
        return $this->belongsToMany(ResearchProject::class,'work_of_research_projects')->withPivot('role');
        // OR return $this->belongsTo('App\User');
    }
    public function researchGroup()
    {
        return $this->belongsToMany(ResearchGroup::class,'work_of_research_groups')->withPivot('role');
        // OR return $this->belongsTo('App\User');
    }

    public function paper()
    {
        return $this->belongsToMany(Paper::class,'teacher_papers');
        
    }
    public function department() {
        return $this->hasMany(Department::class);
   }
}
