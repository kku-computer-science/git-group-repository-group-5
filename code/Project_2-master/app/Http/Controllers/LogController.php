<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\SystemLog;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;

class LogController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $id = auth()->user()->id;
        if (auth()->user()->hasRole('admin')) {
            $experts = Expertise::all();
        } else {
            $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
                $query->where('users.id', '=', $id);
            })->paginate(10);
        }

        return view('logs.index', compact('experts'));
    }

    /**
     * Display overall system logs with filtering options.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function overall(Request $request)
    {
        $query = SystemLog::with('user')->latest();

        // Filter logs using selected user_id
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter by date range
        if ($request->filled('start_date')) {
            $start_date = Carbon::parse($request->start_date)->startOfDay();
            $query->where('created_at', '>=', $start_date);
        }

        if ($request->filled('end_date')) {
            $end_date = Carbon::parse($request->end_date)->endOfDay();
            $query->where('created_at', '<=', $end_date);
        }

        // Get users for filter dropdown
        $users = User::whereIn('id', SystemLog::select('user_id')->distinct())
                    ->select('id', 'email')
                    ->orderBy('email')
                    ->get();

        $logs = $query->paginate(50);

        return view('logs.logs-over-all', compact('logs', 'users'));
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