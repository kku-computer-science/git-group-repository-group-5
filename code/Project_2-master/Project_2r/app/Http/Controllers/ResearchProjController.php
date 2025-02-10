<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ResearchProjController extends Controller
{
    public function index()
    {
        return view('research_proj');
    }
}
