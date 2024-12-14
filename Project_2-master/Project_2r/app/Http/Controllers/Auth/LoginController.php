<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use Illuminate\Foundation\Auth\ThrottlesLogins;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;
    use ThrottlesLogins;
    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = RouteServiceProvider::HOME;
    protected $maxAttempts = 3; // Default is 5
    protected $decayMinutes = 1; // Default is 1

    /**
     * Create a new controller instance.
     *
     * @return void
     */


    public function __construct()
    {

        $this->middleware(['guest'])->except('logout');
    }

    public function username()
    {
        return 'email';
    }

    public function logout(Request $request)
    {
        $request->session()->flush();
        $request->session()->regenerate();
        Auth::logout();
        return redirect('/login');
    }

    protected function redirectTo()
    {
        if (Auth::user()->hasRole('admin')) {
            return route('admin.dashboard');
        } elseif (Auth()->user()->role == 2) {
            return route('user.dashboard');
        } elseif (Auth()->user()->role == 3) {
            return route('user.dashboard');
            //return view('home');
        }
    }

    public function login(Request $request)
    {


        if (method_exists($this, 'hasTooManyLoginAttempts') &&
            $this->hasTooManyLoginAttempts($request)) {
            /*$this->fireLockoutEvent($request);
            return $this->sendLockoutResponse($request);*/
                /*$key = $this->throttleKey($request);
                $rateLimiter = $this->limiter();
                
                $limit = [3 => 1, 5 => 5];
                $attempts = $rateLimiter->attempts($key);  // return how attapts already yet
                if (array_key_exists($attempts, $limit)) {
                    $this->decayMinutes = $limit[$attempts];
                }
                $this->incrementLoginAttempts($request);*/ // login สำเร็จ

                $this->fireLockoutEvent($request);
                return $this->sendLockoutResponse($request);
            
        }


        $credentials = $request->only('email', 'password');
        $response = request('recaptcha');

        $data = [
            "email" => $credentials['email'],
            "password" => $credentials['password']
        ];

        $rules = [
            'email' => 'required',
            'password' => 'required'
        ];


        $validator = Validator::make($data, $rules);

        if (!$validator->fails()) {

            if (Auth::attempt($credentials) && $this->checkValidGoogleRecaptchaV3($response)) {
              //success
                if (Auth::user()->hasRole('admin')) {
                    return redirect()->route('admin.dashboard');

                } elseif (auth()->user()->role == 2) { //นักศึกษา
                    //$user=auth()->user();
                    //$user->assignRole('student');
                    return redirect()->route('user.dashboard');

                } elseif (auth()->user()->role == 3) { //อาจารย์
                    //$user=auth()->user();
                    //$user->assignRole('teacher');
                    //$user->givePermissionTo('addResearchProject','editResearchProject','deleteResearchProject');
                    //return redirect()->route('teacher.dashboard');
                    return redirect()->route('user.dashboard');
                }
            } else {
                //fail
                $this->incrementLoginAttempts($request);
                return redirect()->back()
                    ->withInput($request->all())
                    ->withErrors(['error' => 'Please check your username / password.']);

            }

        } else {
            return redirect('login')->withErrors($validator->errors())->withInput();
        }


    }


    public function checkValidGoogleRecaptchaV3($response)
    {
        $url = "https://www.google.com/recaptcha/api/siteverify";

        $data = [
            'secret' => "6Ldpye4ZAAAAAKwmjpgup8vWWRwzL9Sgx8mE782u",
            'response' => $response
        ];

        $options = [
            'http' => [
                'header' => 'Content-Type: application/x-www-form-urlencoded\r\n',
                'method' => 'POST',
                'content' => http_build_query($data)
            ]
        ];


        $context = stream_context_create($options);
        $result = file_get_contents($url, false, $context);
        $resultJson = json_decode($result);

        return $resultJson->success;
    }
}