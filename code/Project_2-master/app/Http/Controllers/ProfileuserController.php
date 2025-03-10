<?php

namespace App\Http\Controllers;

use App\Models\Educaton;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class ProfileuserController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    function index()
    {
        $users = User::get();
        $user = auth()->user();
        return view('dashboards.users.index', compact('users'));
    }

    function profile()
    {
        return view('dashboards.users.profile');
    }
    function settings()
    {
        return view('dashboards.users.settings');
    }

    function updateInfo(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'fname_en' => 'required',
            'lname_en' => 'required',
            'fname_th' => 'required',
            'lname_th' => 'required',
            'email' => 'required|email|unique:users,email,' . Auth::user()->id,

        ]);

        if (!$validator->passes()) {
            return response()->json([
                'status' => 0,
                'error' => $validator->errors()->toArray()
            ]);
        } else {
            $id = Auth::user()->id;

            // ตัวอย่างการกำหนด title_name_th
            if ($request->title_name_en == "Mr.") {
                $title_name_th = 'นาย';
            } elseif ($request->title_name_en == "Miss") {
                $title_name_th = 'นางสาว';
            } elseif ($request->title_name_en == "Mrs.") {
                $title_name_th = 'นาง';
            } else {
                $title_name_th = null;
            }

            // ตัวอย่างการกำหนดค่า position/academic_ranks
            $pos_eng = null;
            $pos_thai = null;
            $doctoral = null;

            if (Auth::user()->hasRole('admin') or Auth::user()->hasRole('student')) {
                $request->academic_ranks_en = null;
                $request->academic_ranks_th = null;
            } else {
                // ตรวจสอบค่าที่ส่งมา
                if ($request->academic_ranks_en == "Professor") {
                    $pos_en = 'Prof.';
                    $pos_th = 'ศ.';
                } elseif ($request->academic_ranks_en == "Associate Professor") {
                    $pos_en = 'Assoc. Prof.';
                    $pos_th = 'รศ.';
                } elseif ($request->academic_ranks_en == "Assistant Professor") {
                    $pos_en = 'Asst. Prof.';
                    $pos_th = 'ผศ.';
                } elseif ($request->academic_ranks_en == "Lecturer") {
                    $pos_en = 'Lecturer';
                    $pos_th = 'อ.';
                } else {
                    $pos_en = null;
                    $pos_th = null;
                }

                // ถ้ามี checkbox pos
                if ($request->has('pos')) {
                    $pos_eng = $pos_en;
                    $pos_thai = $pos_th;
                } else {
                    // สมมติถ้า role เป็น Lecturer แล้วติดดร. อะไรประมาณนี้
                    if ($pos_en == "Lecturer") {
                        $pos_eng = $pos_en;
                        $pos_thai = $pos_th . 'ดร.';
                        $doctoral = 'Ph.D.';
                    } else {
                        $pos_eng = $pos_en . ' Dr.';
                        $pos_thai = $pos_th . 'ดร.';
                        $doctoral = 'Ph.D.';
                    }
                }
            }

            $query = User::find($id)->update([
                'fname_en' => $request->fname_en,
                'lname_en' => $request->lname_en,
                'fname_th' => $request->fname_th,
                'lname_th' => $request->lname_th,
                'email' => $request->email,
                'academic_ranks_en' => $request->academic_ranks_en,
                'academic_ranks_th' => $request->academic_ranks_th,
                'position_en' => $pos_eng,
                'position_th' => $pos_thai,
                'title_name_en' => $request->title_name_en,
                'title_name_th' => $title_name_th,
                'doctoral_degree' => $doctoral,
            ]);

            if (!$query) {
                return response()->json(['status' => 0, 'msg' => 'Something went wrong.']);
            } else {
                return response()->json(['status' => 1, 'msg' => 'success']);
            }
        }
    }

    function updatePicture(Request $request)
    {
        $path = 'images/imag_user/';
        $file = $request->file('admin_image');
        $new_name = 'UIMG_' . date('Ymd') . uniqid() . '.jpg';

        $upload = $file->move(public_path($path), $new_name);

        if (!$upload) {
            return response()->json(['status' => 0, 'msg' => 'Something went wrong, upload new picture failed.']);
        } else {
            //Get Old picture
            $oldPicture = User::find(Auth::user()->id)->getAttributes()['picture'];
            if ($oldPicture != '') {
                if (\File::exists(public_path($path . $oldPicture))) {
                    \File::delete(public_path($path . $oldPicture));
                }
            }

            //Update DB
            $update = User::find(Auth::user()->id)->update(['picture' => $new_name]);
            if (!$update) {
                return response()->json(['status' => 0, 'msg' => 'Something went wrong, updating picture in db failed.']);
            } else {
                return response()->json(['status' => 1, 'msg' => 'Your profile picture has been updated successfully']);
            }
        }
    }

    function changePassword(Request $request)
    {
        //Validate form
        $validator = \Validator::make($request->all(), [
            'oldpassword' => [
                'required',
                function ($attribute, $value, $fail) {
                    // ถ้าไม่ผ่านเงื่อนไข Hash::check() => ส่งข้อความ error จากไฟล์แปล
                    if (!\Hash::check($value, Auth::user()->password)) {
                        return $fail(trans('profile.current_password_incorrect'));
                    }
                },
                'min:8',
                'max:30'
            ],
            'newpassword' => 'required|min:8|max:30',
            'cnewpassword' => 'required|same:newpassword'
        ], [
            // ตรงนี้ก็เปลี่ยนเป็น trans() ได้เช่นกัน
            'oldpassword.required' => trans('profile.enter_current_password'),
            'oldpassword.min' => trans('profile.oldpassword_min'),
            'oldpassword.max' => trans('profile.oldpassword_max'),
            'newpassword.required' => trans('profile.enter_new_password'),
            'newpassword.min' => trans('profile.newpassword_min'),
            'newpassword.max' => trans('profile.newpassword_max'),
            'cnewpassword.required' => trans('profile.reenter_new_password'),
            'cnewpassword.same' => trans('profile.newpassword_confirm_not_match'),
        ]);

        if (!$validator->passes()) {
            return response()->json([
                'status' => 0,
                'error' => $validator->errors()->toArray()
            ]);
        } else {
            $update = User::find(Auth::user()->id)->update([
                'password' => \Hash::make($request->newpassword)
            ]);

            if (!$update) {
                return response()->json([
                    'status' => 0,
                    'msg' => trans('profile.password_update_failed')
                ]);
            } else {
                return response()->json([
                    'status' => 1,
                    'msg' => trans('profile.password_changed_successfully')
                ]);
            }
        }
    }
}
