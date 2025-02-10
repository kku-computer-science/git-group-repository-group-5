<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;

class ActivityLog
{
    public function handle(Request $request, Closure $next)
    {
        if (Auth::check()) {
            Log::info('User Activity', [
                'user_id' => Auth::id(),
                'ip' => $request->ip(),
                'url' => $request->fullUrl(),
                'method' => $request->method(),
                'user_agent' => $request->header('User-Agent')
            ]);
        }

        return $next($request);
    }
}
