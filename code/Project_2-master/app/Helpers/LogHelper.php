<?php

namespace App\Helpers;

use App\Models\SystemLog;
use Illuminate\Support\Facades\Auth;

class LogHelper
{
    /**
     * บันทึก Log ลงฐานข้อมูล
     *
     * @param string $action - ประเภทของการกระทำ
     * @param string|null $description - คำอธิบายเพิ่มเติม
     */
    public static function log($action, $description = null)
    {
        SystemLog::create([
            'user_id' => Auth::id(),
            'action' => $action,
            'description' => $description,
            'ip_address' => request()->ip()
        ]);
    }
}
