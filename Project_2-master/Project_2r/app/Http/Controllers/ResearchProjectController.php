<?php

namespace App\Http\Controllers;

use App\Models\ResearchProject;
use App\Models\User;
use Illuminate\Http\Request;
use SebastianBergmann\Environment\Console;
use Illuminate\Support\Facades\Log;
use App\Models\Fund;

class ResearchProjectController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        
        $id=auth()->user()->id;
        /*if( auth()->user()->role == 1 ){
            $researchProjects = ResearchProject::with('User')->latest()->paginate(5);
        }
        elseif( auth()->user()->role == 2 ){
            $researchProjects=User::find($id)->researchProject()->latest()->paginate(5);
        }
        elseif( auth()->user()->role == 3 ){
            $researchProjects = ResearchProject::with('User')->latest()->paginate(5);
            //$researchProjects=User::find($id)->researchProject()->latest()->paginate(5);
            
            //$researchProjects = ResearchProject::with('User')->latest()->paginate(5);
        }*/
//dd($id);
       //$researchProjects = ResearchProject::latest()->paginate(5);
       $researchProjects=ResearchProject::with('User')->latest()->paginate(5);
       //return $researchProjects;
       
    return view('research_projects.index',compact('researchProjects')) ->with('i', (request()->input('page', 1) - 1) * 5);
        
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {   $users = User::get();
        $funds = Fund::get();
        return view('research_projects.create',compact('users','funds'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
            'Project_name_TH' => 'required',
            'Project_name_EN' => 'required',
            'Funder' => 'required',
            'Note' => 'required',
            //'moreFields.*.userid' => 'required'
        ]);
        
        $researchProject = ResearchProject::create($request->all());

        $head=$request->head;
        $fund=$request->fund;
        $researchProject->user()->attach($head,['role' => 1]);
        //$user=auth()->user();
        //$user=User::find($head);
        //$user->givePermissionTo('editResearchProject','deleteResearchProject');

        $researchProject->fund()->sync($fund);
        
        foreach ($request->moreFields as $key => $value) {
            //dd($value);
            if ($value['userid'] != null){
            $researchProject->user()->attach($value,['role' => 2]);
            }
            //$user->givePermissionTo('readResearchProject');
        }
       
        
        //$user = User::find(auth()->user()->id);
        //$user->researchProject()->attach(2);

        return redirect()->route('researchProjects.index')->with('success','research projects created successfully.');
    }
     

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ResearchProject  $researchProject
     * @return \Illuminate\Http\Response
     */
    public function show(ResearchProject $researchProject)
    {
        return view('research_projects.show',compact('researchProject'));
    }
   
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\ResearchProject  $researchProject
     * @return \Illuminate\Http\Response
     */
    public function edit(ResearchProject $researchProject)
    {
        
        $researchProject=ResearchProject::find($researchProject->id);
        $this->authorize('update', $researchProject);
        $researchProject=ResearchProject::with(['user'])->where('id',$researchProject->id)->first();
       
       
        $users = User::get();
        $funds = Fund::get();
        return view('research_projects.edit',compact('researchProject','users','funds'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\ResearchProject  $researchProject
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, ResearchProject $researchProject)
    {
        
        $request->validate([
            'Project_name_TH' => 'required',
            'Project_name_EN' => 'required',
            'Funder' => 'required',
            'Budget' => 'required',
            'Project_start' => 'required',
            'Project_end' => 'required',
            'Note' => 'required',
            
        ]);
        $researchProject=ResearchProject::find($researchProject->id);
        $this->authorize('update', $researchProject);
        $researchProject->update($request->all());
        $head=$request->head;
        $researchProject->user()->sync($head,['role' => 1]);
        //$researchProject->update($this->validatePost());
        
        return redirect()->route('researchProjects.index')
                        ->with('success','Research Project updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ResearchProject  $researchProject
     * @return \Illuminate\Http\Response
     */
    public function destroy(ResearchProject $researchProject)
    {
        $researchProject->delete();
        $this->authorize('delete', $researchProject);
        return redirect()->route('researchProjects.index')
                        ->with('success','Research Project deleted successfully');
    }
    
}
