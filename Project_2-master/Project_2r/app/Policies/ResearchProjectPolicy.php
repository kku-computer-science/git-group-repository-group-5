<?php

namespace App\Policies;

use App\Models\ResearchProject;
use App\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class ResearchProjectPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can view any models.
     *
     * @param  \App\Models\User  $user
     * @return mixed
     */
    public function viewAny(User $user)
    {
        //
    }

    /**
     * Determine whether the user can view the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\ResearchProject  $researchProject
     * @return mixed
     */
    public function view(User $user, ResearchProject $researchProject)
    {
        //
    }

    /**
     * Determine whether the user can create models.
     *
     * @param  \App\Models\User  $user
     * @return mixed
     */
    public function create(User $user)
    {
        //
    }

    /**
     * Determine whether the user can update the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\ResearchProject  $researchProject
     * @return mixed
     */
    public function update(User $user, ResearchProject $researchProject)
    {
        //return $researchProject->user_id === $user->user_id;
        //$researchProject = $researchProject->user->where('id',auth()->user()->id)->first();
        //$researchProjects = ResearchProject::with('user')->where('id',$researchProject->id)->get();
        //$researchProject=$researchProject->where('id',auth()->user()->id)->get();
        /*foreach ($researchProjects as $user) {
            print($user->pivot->role);
        }*/

        $researchProject=ResearchProject::find($researchProject->id)->user()->where('user_id',$user->id)->get();
        //$researchProject = User::with(['researchProject'])->where('id',$user->id)->get();
        foreach ($researchProject as $res) {
            //print($res);
            if($user->id == $res->id and $res->pivot->role == '1' ){
                return true;
            }
            else{
                return false;
            }
        }
        /*print($researchProject);
        
        /*if($user->id == $researchProject->id){
            return true;
        }
        else{
            return false;
        }*/
    }

    /**
     * Determine whether the user can delete the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\ResearchProject  $researchProject
     * @return mixed
     */
    public function delete(User $user, ResearchProject $researchProject)
    {
        $researchProject=ResearchProject::find($researchProject->id)->user()->where('user_id',$user->id)->get();
        //$researchProject = User::with(['researchProject'])->where('id',$user->id)->get();
        foreach ($researchProject as $res) {
            //print($res);
            if($user->id == $res->id and $res->pivot->role == '1' ){
                return true;
            }
            else{
                return false;
            }
        }
    }

    /**
     * Determine whether the user can restore the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\ResearchProject  $researchProject
     * @return mixed
     */
    public function restore(User $user, ResearchProject $researchProject)
    {
        //
    }

    /**
     * Determine whether the user can permanently delete the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\ResearchProject  $researchProject
     * @return mixed
     */
    public function forceDelete(User $user, ResearchProject $researchProject)
    {
        //
    }
}
