<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\SystemLog;
use App\Models\User;
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


    public function login(Request $request)
    {
        $id = auth()->id();
        $query = SystemLog::with('user')
            ->whereIn('action', ['Login', 'Logout'])
            ->latest();

        // Apply user filter (เฉพาะ admin เท่านั้นที่สามารถเลือก user อื่นได้)
        if (auth()->user()->hasRole('admin')) {
            if ($request->filled('user_id')) {
                $query->where('user_id', $request->user_id);
            }
        } else {
            // ผู้ใช้ทั่วไปเห็นเฉพาะของตัวเอง
            $query->where('user_id', $id);
        }

        // Apply date filter
        if ($request->filled('selected_date')) {
            $selectedDate = Carbon::parse($request->selected_date);
            $query->whereDate('created_at', $selectedDate);
        } else {
            $query->whereDate('created_at', Carbon::today());
        }

        // Get users list for dropdown (admin เท่านั้น)
        $users = auth()->user()->hasRole('admin')
            ? User::whereIn('id', SystemLog::select('user_id')->distinct())
                ->select('id', 'email')
                ->orderBy('email')
                ->get()
            : collect();

        // Get paginated logs
        $logs = $query->paginate(50);

        // Create chart data - group by hour
        $chartQuery = SystemLog::selectRaw('HOUR(created_at) as hour, COUNT(*) as count')
            ->whereIn('action', ['Login', 'Logout']);

        if (auth()->user()->hasRole('admin')) {
            if ($request->filled('user_id')) {
                $chartQuery->where('user_id', $request->user_id);
            }
        } else {
            $chartQuery->where('user_id', $id);
        }

        $chartDate = $request->filled('selected_date')
            ? Carbon::parse($request->selected_date)->toDateString()
            : now()->toDateString();

        $chartQuery->whereDate('created_at', $chartDate);

        $logsData = $chartQuery->groupBy('hour')
            ->orderBy('hour')
            ->get()
            ->map(function ($item) {
                return [
                    'hour' => (int) $item->hour,
                    'count' => (int) $item->count,
                ];
            });

        // Fill missing hours with zero counts
        $fullData = collect(range(0, 23))->map(function ($hour) use ($logsData) {
            $hourData = $logsData->firstWhere('hour', $hour);
            return [
                'hour' => $hour,
                'count' => $hourData ? $hourData['count'] : 0,
            ];
        })->values();

        return view('logs.logs-login', [
            'logs' => $logs,
            'users' => $users,
            'logsData' => $fullData,
            'selectedDate' => $chartDate,
        ]);
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
