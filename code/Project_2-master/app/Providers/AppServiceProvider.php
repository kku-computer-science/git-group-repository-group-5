<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\Facades\App; // เพิ่มการใช้งาน App
use Illuminate\Support\Facades\Session; // เพิ่มการใช้งาน Session

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Paginator::useBootstrap();

        view()->composer(
            'layouts.layout',
            function ($view) {
                $view->with('dn', \App\Models\Program::where('degree_id', '=', 1)->get());
            }
        );

        // ตั้งค่า locale จาก session หากมี ไม่เช่นนั้นใช้ค่า default เป็น 'th'
        $locale = Session::get('applocale', 'th');
        App::setLocale($locale);
    }
}
