<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\SystemLog;
use App\Models\User;
use App\Models\SystemLog;
use Illuminate\Http\Request;

use Carbon\Carbon;

use Illuminate\Support\Facades\Auth;





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

public function overall(Request $request)
    {
        // Base query with user relationship
        $query = SystemLog::with('user')->latest();

        // Apply user filter
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Apply date filter
        if ($request->filled('selected_date')) {
            $selectedDate = Carbon::parse($request->selected_date);
            $query->whereDate('created_at', $selectedDate);
        } else {
            // Default to today if no date selected
            $query->whereDate('created_at', Carbon::today());
        }

        // Get users for filter dropdown
        $users = User::whereIn('id', SystemLog::select('user_id')->distinct())
                    ->select('id', 'email')
                    ->orderBy('email')
                    ->get();

        // Get paginated logs for table
        $logs = $query->paginate(50);

        // Create chart data - group by hour for the selected date
        $chartQuery = SystemLog::selectRaw('HOUR(created_at) as hour, COUNT(*) as count');
        
        // Apply user filter to chart data
        if ($request->filled('user_id')) {
            $chartQuery->where('user_id', $request->user_id);
        }

        // Use the selected date for the chart, default to today
        $chartDate = $request->filled('selected_date') 
            ? Carbon::parse($request->selected_date)->toDateString()
            : now()->toDateString();
        
        $chartQuery->whereDate('created_at', $chartDate);

        $logsData = $chartQuery->groupBy('hour')
            ->orderBy('hour')
            ->get()
            ->map(function ($item) {
                return [
                    'hour' => (int)$item->hour,
                    'count' => (int)$item->count
                ];
            });

        // Fill in missing hours with zero counts
        $fullData = collect(range(0, 23))->map(function ($hour) use ($logsData) {
            $hourData = $logsData->firstWhere('hour', $hour);
            return [
                'hour' => $hour,
                'count' => $hourData ? $hourData['count'] : 0
            ];
        })->values();

        return view('logs.logs-over-all', [
            'logs' => $logs,
            'users' => $users,
            'logsData' => $fullData,
            'selectedDate' => $chartDate
        ]);
    }


    public function login()
    {
        $id = auth()->id();

        if (auth()->user()->hasRole('admin')) {
            $experts = Expertise::all();
            $logs = SystemLog::with('user')
                ->whereIn('action', [
                    'Login',
                    'Logout'
                ])
                ->latest()
                ->get();
        } else {

            $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
                $query->where('users.id', $id);
            })->get();


            $logs = SystemLog::with('user')
                ->where('user_id', $id)
                ->whereIn('description', [
                    'Login',
                    'Logout'
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
