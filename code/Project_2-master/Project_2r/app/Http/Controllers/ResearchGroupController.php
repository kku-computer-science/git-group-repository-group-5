<?php

namespace App\Http\Controllers;
use App\Models\ResearchGroup;
use Illuminate\Http\Request;
use App\Models\Fund;
use App\Models\User;
class ResearchGroupController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //$researchGroups = ResearchGroup::latest()->paginate(5);
        $researchGroups = ResearchGroup::with('User')->latest()->paginate(5);
        return view('research_groups.index',compact('researchGroups')) ->with('i', (request()->input('page', 1) - 1) * 5);
    }
     
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {   $users = User::get();
        $funds = Fund::get();
        return view('research_groups.create',compact('users','funds'));
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
            'Group_name_TH' => 'required',
            'Group_name_EN' => 'required',
            'Group_detail_TH' => 'required',
            'Group_detail_EN' => 'required',
            'Group_desc_TH' => 'required',
            'Group_desc_EN' => 'required',
        ]);
        
        $researchGroup = ResearchGroup::create($request->all());

        $head=$request->head;
        $fund=$request->fund;
        $researchGroup->user()->attach($head,['role' => 1]);
       

        
        foreach ($request->moreFields as $key => $value) {
           
            if ($value['userid'] != null){
                $researchGroup->user()->attach($value,['role' => 2]);
            }
        }
        return redirect()->route('researchGroups.index')->with('success','research group created successfully.');


    }
     
    /**
     * Display the specified resource.
     *
     * @param  \App\Fund  $researchGroup
     * @return \Illuminate\Http\Response
     */
    public function show(ResearchGroup $researchGroup)
    {
        return view('researchGroups.show',compact('researchGroup'));
    } 
     
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Fund  $researchGroup
     * @return \Illuminate\Http\Response
     */
    public function edit(ResearchGroup $researchGroup)
    {
        $researchGroup=ResearchGroup::find($researchGroup->id);
        $this->authorize('update', $researchGroup);
        $researchGroup=ResearchGroup::with(['user'])->where('id',$researchGroup->id)->first();
       
       
        $users = User::get();
        
        return view('research_groups.edit',compact('researchGroup','users'));
    }
    
    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\ResearchGroup  $researchGroup
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, ResearchGroup $researchGroup)
    {
        $request->validate([
            'name' => 'required',
            'detail' => 'required',
        ]);
    
        $researchGroup->update($request->all());
    
        return redirect()->route('researchGroups.index')
                        ->with('success','researchGroups updated successfully');
    }
    
    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Fund  $researchGroup
     * @return \Illuminate\Http\Response
     */
    public function destroy(ResearchGroup $researchGroup)
    {
        $researchGroup->delete();
    
        return redirect()->route('researchGroups.index')
                        ->with('success','researchGroups deleted successfully');
    }
}
