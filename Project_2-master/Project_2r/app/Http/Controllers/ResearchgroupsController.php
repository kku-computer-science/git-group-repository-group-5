<?php

namespace App\Http\Controllers;
use App\Models\ResearchGroup;
use Illuminate\Http\Request;

class ResearchgroupsController extends Controller
{
    public function index()
    {
        $resg = ResearchGroup::with('User')->get();
        //return $resg;
        return view('research_g',compact('resg'));
    }
}
