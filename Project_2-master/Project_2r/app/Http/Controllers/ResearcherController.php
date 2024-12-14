<?php

namespace App\Http\Controllers;
use App\Models\User;
use Illuminate\Http\Request;

class ResearcherController extends Controller
{
    public function index(){
        $reshr = User::where('role','=',3)->get();
        
        return view('researchers',compact('reshr'));
    }

}
