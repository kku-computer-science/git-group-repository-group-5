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
        // ดึงข้อมูลสำหรับตาราง
        $logs = SystemLog::with('user')->latest()->paginate(perPage: 50);

        // สร้างข้อมูลสำหรับกราฟ - จัดกลุ่มตามชั่วโมง
        $logsData = SystemLog::selectRaw('HOUR(created_at) as hour, COUNT(*) as count')
        ->whereDate('created_at', now()->toDateString())
            ->groupBy('hour')
            ->orderBy('hour')
            ->get()
            ->map(function ($item) {
                return [
                    'hour' => (int)$item->hour,
                    'count' => (int)$item->count
                ];
            });

        // เติมชั่วโมงที่ไม่มีข้อมูล
        $fullData = collect(range(0, 23))->map(function ($hour) use ($logsData) {
            $hourData = $logsData->firstWhere('hour', $hour);
            return [
                'hour' => $hour,
                'count' => $hourData ? $hourData['count'] : 0
            ];
        })->values();

        return view('logs.logs-over-all', [
            'logs' => $logs,
            'logsData' => $fullData
        ]);
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
    

