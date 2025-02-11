<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use App\Models\SystemLog; // ต้องใช้ Model นี้เพื่อบันทึกลงฐานข้อมูล

class ActivityLog
{
    public function handle(Request $request, Closure $next)
    {
        if (Auth::check()) {
            // บันทึกลงไฟล์ log
            Log::info('User Activity', [
                'user_id' => Auth::id(),
                'ip' => $request->ip(),
                'url' => $request->fullUrl(),
                'method' => $request->method(),
                'user_agent' => $request->header('User-Agent')
            ]);


            // บันทึกลง database (ตาราง system_logs)
            SystemLog::create([
                'user_id' => Auth::id(),
                'action' => 'User Activity',
                'description' => 'Accessed URL: ' . $request->fullUrl(),
                'ip_address' => $request->ip()
            ]);
        }

        return $next($request);
    }
}
