<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\Fund;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\SystemLog;



class LogController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(){
    $id = auth()->user()->id;
    if (auth()->user()->hasRole('admin')) {
        $experts = Expertise::all();
    } else {
        $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
            $query->where('users.id', '=', $id);
        })->paginate(10);
    }

    return view('logs.index', compact('experts')); // ส่งข้อมูล $experts ไปยัง view
    }

    public function overall()
    {
        // ตัวอย่างการดึงข้อมูล logs
        $logs = SystemLog::with('user')->latest()->paginate(50);

        // ส่งตัวแปร $logs ไปยัง View 'logs.logs-over-all'
        return view('logs.logs-over-all', compact('logs'));
    }



    public function login()
    {
        $id = auth()->user()->id;
        if (auth()->user()->hasRole('admin')) {
            $experts = Expertise::all();
        } else {
            $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
                $query->where('users.id', '=', $id);
            })->paginate(10);
        }

        return view('logs.logs-login', compact('experts'));
    }
    public function error()
    {
        $id = auth()->user()->id;
        if (auth()->user()->hasRole('admin')) {
            $experts = Expertise::all();
        } else {
            $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
                $query->where('users.id', '=', $id);
            })->paginate(10);
        }

        return view('logs.logs-error', compact('experts'));
    }
}


    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    

