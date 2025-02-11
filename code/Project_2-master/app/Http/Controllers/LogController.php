<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\Fund;
use App\Models\User;
use App\Models\SystemLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

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

    public function overall(){
    $id = auth()->user()->id;
    if (auth()->user()->hasRole('admin')) {
        $experts = Expertise::all();
    } else {
        $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
            $query->where('users.id', '=', $id);
        })->paginate(10);
    }

    return view('logs.logs-over-all', compact('experts'));
    }

    public function login()
    {
        $id = auth()->id();

        if (auth()->user()->hasRole('admin')) {
            $experts = Expertise::all();

            // ใช้ whereIn แทน where เพื่อกรองค่า description ที่ตรงกับ URL 'login' และ 'logout'
            $logs = SystemLog::with('user')
                ->whereIn('description', [
                    'Accessed URL: http://127.0.0.1:8000/login',
                    'Accessed URL: http://127.0.0.1:8000/logout'
                ])
                ->latest()
                ->get();
        } else {
            // สำหรับกรณีที่ไม่ใช่ admin กรองตาม user_id
            $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
                $query->where('users.id', $id);
            })->get();

            // ดึง log ของ user นี้ และไม่กรองตาม action
            $logs = SystemLog::with('user')
                ->where('user_id', $id)
                ->whereIn('description', [
                    'Accessed URL: http://127.0.0.1:8000/login',
                    'Accessed URL: http://127.0.0.1:8000/logout'
                ])
                ->latest()
                ->get();
        }

        return view('logs.logs-login', compact('experts', 'logs'));
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


