<?php
  
namespace App\Http\Controllers;
   
use App\Models\Fund;
use Illuminate\Http\Request;
  
class FundController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $funds = Fund::latest()->paginate(5);
    
        return view('funds.index',compact('funds'))
            ->with('i', (request()->input('page', 1) - 1) * 5);
    }
     
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('funds.create');
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
            'fund_name' => 'required',
            'fund_year' => 'required',
            'fund_details' => 'required',
            'fund_type' => 'required',
            'fund_level' => 'required',

        ]);
    
        Fund::create($request->all());
     
        return redirect()->route('funds.index')
                        ->with('success','fund created successfully.');
    }
     
    /**
     * Display the specified resource.
     *
     * @param  \App\Fund  $fund
     * @return \Illuminate\Http\Response
     */
    public function show(Fund $fund)
    {
        return view('funds.show',compact('fund'));
    } 
     
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Fund  $fund
     * @return \Illuminate\Http\Response
     */
    public function edit(Fund $fund)
    {
        return view('funds.edit',compact('fund'));
    }
    
    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Fund  $fund
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Fund $fund)
    {
        $request->validate([
            'name' => 'required',
            'detail' => 'required',
        ]);
    
        $fund->update($request->all());
    
        return redirect()->route('funds.index')
                        ->with('success','Fund updated successfully');
    }
    
    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Fund  $fund
     * @return \Illuminate\Http\Response
     */
    public function destroy(Fund $fund)
    {
        $fund->delete();
    
        return redirect()->route('funds.index')
                        ->with('success','Fund deleted successfully');
    }
}