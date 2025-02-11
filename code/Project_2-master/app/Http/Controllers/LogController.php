<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\Fund;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\SystemLog;
//add export
use Symfony\Component\HttpFoundation\StreamedResponse;



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
    //add function export


public function export(Request $request)
{
    $format = $request->query('format', 'csv'); // ค่าเริ่มต้นเป็น CSV

    if ($format === 'json') {
        return response()->json(SystemLog::all());
    }

    $response = new StreamedResponse(function () {
        $handle = fopen('php://output', 'w');

        // เขียน Header ของไฟล์ CSV
        fputcsv($handle, ['ID', 'User ID', 'Action', 'Description', 'IP Address', 'Created At']);

        // ดึงข้อมูลจากฐานข้อมูลทีละชุด
        SystemLog::orderBy('created_at', 'desc')->chunk(100, function ($logs) use ($handle) {
            foreach ($logs as $log) {
                fputcsv($handle, [
                    $log->id,
                    $log->user_id,
                    $log->action,
                    $log->description,
                    $log->ip_address,
                    $log->created_at,
                ]);
            }
        });

        fclose($handle);
    });

    $response->headers->set('Content-Type', 'text/csv');
    $response->headers->set('Content-Disposition', 'attachment; filename="system_logs.csv"');

    return $response;
}


}


    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    

