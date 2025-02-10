<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\PermissionController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\TeacherController;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\FundController;
use App\Http\Controllers\ResearchProjectController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\RunPythonController;
use App\Http\Controllers\PaperController;
use App\Http\Controllers\ResearchGroupController;
use App\Http\Controllers\DepartmentController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [HomeController::class, 'index'])->name('home');

/*Route::group(['middleware' => ['auth']], function() {
    Route::resource('users', UserController::class);
    Route::resource('roles', RoleController::class);
    Route::resource('permissions', PermissionController::class);
    Route::resource('posts', PostController::class);
});*/



Route::get('/', function () {
    return view('welcome');
});

Route::middleware(['middleware'=>'PreventBackHistory'])->group(function () {
    Auth::routes();
});

Route::group(['middleware'=>['isAdmin','auth','PreventBackHistory']], function(){
        Route::get('dashboard',[AdminController::class,'index'])->name('dashboard');
        Route::get('profile',[AdminController::class,'profile'])->name('profile');
        Route::get('settings',[AdminController::class,'settings'])->name('settings');

        Route::post('update-profile-info',[AdminController::class,'updateInfo'])->name('adminUpdateInfo');
        Route::post('change-profile-picture',[AdminController::class,'updatePicture'])->name('adminPictureUpdate');
        Route::post('change-password',[AdminController::class,'changePassword'])->name('adminChangePassword');
        
        Route::resource('departments', DepartmentController::class);
        Route::resource('users', UserController::class);
        Route::resource('roles', RoleController::class);
        Route::resource('permissions', PermissionController::class);
});

Route::group(['middleware'=>['auth','PreventBackHistory']], function(){
    
    Route::resource('funds', FundController::class);
    Route::resource('posts', PostController::class);
    Route::resource('funds', FundController::class);
    Route::resource('researchProjects', ResearchProjectController::class);
    Route::resource('researchGroups', ResearchGroupController::class);
    Route::resource('papers',PaperController::class);
    //Route::resource('posts', PostController::class);
    //Route::resource('funds', FundController::class);
    //Route::resource('researchProjects', ResearchProjectController::class);
   
});