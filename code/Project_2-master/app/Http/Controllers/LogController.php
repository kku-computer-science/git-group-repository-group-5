<?php

namespace App\Http\Controllers;

use App\Models\Expertise;
use App\Models\User;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\Models\Log;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Illuminate\Support\Facades\Auth;


class LogController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    // old code
    // public function index()
    // {
    //     $id = auth()->user()->id;
    //     if (auth()->user()->hasRole('admin')) {
    //         $experts = Expertise::all();
    //     } else {
    //         $experts = Expertise::with('user')->whereHas('user', function ($query) use ($id) {
    //             $query->where('users.id', '=', $id);
    //         })->paginate(10);
    //     }

    //     return view('logs.index', compact('experts'));
    // }

    public function index(Request $request)
{
    $id = auth()->user()->id;

    // ดึงค่าการกรองจาก Request
    $user_id = $request->input('user_id');
    $selected_date = $request->input('selected_date');

    $query = Expertise::query();

    // เฉพาะ admin สามารถเห็นทุกข้อมูล
    if (!auth()->user()->hasRole('admin')) {
        $query->whereHas('user', function ($q) use ($id) {
            $q->where('users.id', $id);
        });
    }
}

    public function overall(Request $request)

    {
        // กำหนดคอลัมน์ที่สามารถเรียงลำดับได้
        $allowedSortColumns = [
            'id' => 'system_logs.id',
            'user' => 'users.email',
            'action' => 'system_logs.action',
            'description' => 'system_logs.description',
            'ip_address' => 'system_logs.ip_address',
            'created_at' => 'system_logs.created_at'
        ];

        // รับค่าการเรียงจากผู้ใช้ และตรวจสอบทิศทางการเรียง
        $sort = $request->input('sort', 'id'); // เริ่มต้นที่ 'id'
        $direction = in_array(strtolower($request->input('direction')), ['asc', 'desc'])
        ? strtolower($request->input('direction'))
        : 'asc'; // ค่าเริ่มต้นเป็น 'asc'

        // ค่าที่รับมาจากการกรอกจำนวนการแสดงข้อมูล (จำนวนบรรทัดต่อหน้า)
        $perPage = $request->input('per_page', 50);

        // สร้างคำสั่ง query หลัก
        $query = SystemLog::query()
            ->leftJoin('users', 'system_logs.user_id', '=', 'users.id')
            ->select('system_logs.*', 'users.email as user_email');

        // การกรองข้อมูลตามผู้ใช้
        if ($request->filled('user_id')) {
            $query->where('system_logs.user_id', $request->user_id);
        }

        // การกรองข้อมูลตามวันที่
        $selectedDate = $request->filled('selected_date')
        ? Carbon::parse($request->selected_date)
            : Carbon::today();

        $query->whereDate('system_logs.created_at', $selectedDate);

        // การจัดเรียงข้อมูลตามคอลัมน์ที่ผู้ใช้เลือก
        if (isset($allowedSortColumns[$sort])) {
            $query->orderBy($allowedSortColumns[$sort], $direction);
        }

        // รับข้อมูลผู้ใช้สำหรับเลือกใน dropdown filter
        $users = User::whereIn('id', SystemLog::select('user_id')->distinct())
            ->select('id', 'email')
            ->orderBy('email')
            ->get();
    }

        // Get paginated logs for table
        // $logs = $query->paginate(25);

        // รับข้อมูล logs ที่แสดงเป็น pagination
        $logs = $query->paginate($perPage)
            ->appends($request->except('page'));


        // สร้างข้อมูลสำหรับกราฟ (แบ่งตามชั่วโมง)
        $chartQuery = SystemLog::selectRaw('HOUR(created_at) as hour, COUNT(*) as count')
        ->whereDate('created_at', $selectedDate);

        // การกรองข้อมูลตามผู้ใช้สำหรับกราฟ
        if ($request->filled('user_id')) {
            $chartQuery->where('user_id', $request->user_id);
        }

        $logsData = $chartQuery->groupBy('hour')
        ->orderBy('hour')
        ->get()
            ->map(function ($item) {
                return [
                    'hour' => (int)$item->hour,
                    'count' => (int)$item->count
                ];
            });

        // เติมข้อมูลชั่วโมงที่ขาดหายด้วยค่า count เป็น 0
        $fullData = collect(range(0, 23))->map(function ($hour) use ($logsData) {
            $hourData = $logsData->firstWhere('hour', $hour);
            return [
                'hour' => $hour,
                'count' => $hourData ? $hourData['count'] : 0
            ];
        })->values();

        // ส่งข้อมูลทั้งหมดไปยัง view
        return view('logs.logs-over-all', [
            'logs' => $logs,
            'users' => $users,
            'logsData' => $fullData,
            'selectedDate' => $selectedDate,
            'perPage' => $perPage,
            'sort' => $sort,
            'direction' => $direction
        ]);
    }
    public function login(Request $request)
    {
        $id = auth()->id();
        $query = SystemLog::with('user')
            ->whereIn('action', ['Login', 'Logout']);

        // Apply user filter
        if (auth()->user()->hasRole('admin')) {
            if ($request->filled('user_id')) {
                $query->where('user_id', $request->user_id);
            }
        } else {
            $query->where('user_id', $id);
        }

        // Apply date filter
        if ($request->filled('selected_date')) {
            $selectedDate = Carbon::parse($request->selected_date);
            $query->whereDate('created_at', $selectedDate);
        } else {
            $selectedDate = Carbon::today();
            $query->whereDate('created_at', $selectedDate);
        }

        $sortColumn = $request->input('sort_column', 'created_at');
        $sortDirection = $request->input('sort_direction', 'desc');
        $query->orderBy($sortColumn, $sortDirection);

        $users = auth()->user()->hasRole('admin')
            ? User::whereIn('id', SystemLog::select('user_id')->distinct())
                ->select('id', 'email')
                ->orderBy('email')
                ->get()
            : collect();


        $perPage = $request->input('per_page', 50);
        $logs = $query->paginate($perPage)->appends($request->query());

        return view('logs.logs-login', [
            'logs' => $logs,
            'users' => $users,
            'selectedDate' => $selectedDate->toDateString(),
            'sortColumn' => $sortColumn,
            'sortDirection' => $sortDirection,
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

    public function export(Request $request)
    {
        $format = $request->query('format', 'csv'); // ค่าเริ่มต้นเป็น CSV

        // กรองข้อมูลตามที่ผู้ใช้เลือก
        $query = SystemLog::query();

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->filled('selected_date')) {
            $selectedDate = Carbon::parse($request->selected_date);
            $query->whereDate('created_at', $selectedDate);
        }

        // ถ้าเลือก JSON ให้ส่งออก JSON
        if ($format === 'json') {
            return response()->json($query->get());
        }

        // ถ้าเลือก CSV ให้ส่งออก CSV
        $response = new StreamedResponse(function () use ($query) {
            $handle = fopen('php://output', 'w');

            // เขียน Header ของไฟล์ CSV
            fputcsv($handle, ['NO', 'ID', 'User ID', 'Action', 'Description', 'IP Address', 'Created At']);

            $rowNumber = 1; // เริ่มจาก row 1

            // ดึงข้อมูลตามเงื่อนไขที่กำหนดและเขียนลงไฟล์ CSV
            $query->orderBy('created_at', 'desc')->chunk(100, function ($logs) use ($handle, &$rowNumber) {
                foreach ($logs as $log) {
                    fputcsv($handle, [
                        $rowNumber++, // เพิ่มลำดับ row
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
        $response->headers->set('Content-Disposition', 'attachment; filename="filtered_logs.csv"');

        return $response;
    }

