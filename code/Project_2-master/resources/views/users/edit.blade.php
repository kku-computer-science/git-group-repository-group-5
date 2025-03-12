@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (count($errors) > 0)
        <div class="alert alert-danger">
            <strong>{{ trans('users.opp') }}</strong> {{ trans('users.something_wrong') }}<br><br>
            <ul>
                @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
        @endif
        <div class="card col-8" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{ trans('users.edit_user') }}</h4>
                <p class="card-description">{{ trans('users.fill_user_details') }}</p>
                {!! Form::model($user, ['route' => ['users.update', $user->id], 'method'=>'PATCH']) !!}
                <div class="form-group row">
                    <div class="col-sm-6">
                        <p><b>{{ trans('users.fname_th') }}</b></p>
                        <input type="text" name="fname_th" value="{{ $user->fname_th }}" class="form-control" placeholder="{{ $user->fname_th }}">
                    </div>
                    <div class="col-sm-6">
                        <p><b>{{ trans('users.lname_th') }}</b></p>
                        <input type="text" name="lname_th" value="{{ $user->lname_th }}" class="form-control" placeholder="{{ $user->lname_th }}">
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-sm-6">
                        <p><b>{{ trans('users.fname_en') }}</b></p>
                        <input type="text" name="fname_en" value="{{ $user->fname_en }}" class="form-control" placeholder="{{ $user->fname_en }}">
                    </div>
                    <div class="col-sm-6">
                        <p><b>{{ trans('users.lname_en') }}</b></p>
                        <input type="text" name="lname_en" value="{{ $user->lname_en }}" class="form-control" placeholder="{{ $user->lname_en }}">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3"><b>{{ trans('users.email') }}</b></p>
                    <div class="col-sm-8">
                        <input type="text" name="email" value="{{ $user->email }}" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3"><b>{{ trans('users.password') }}</b></p>
                    <div class="col-sm-8">
                        <input type="password" name="password" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3"><b>{{ trans('users.confirm_password') }}</b></p>
                    <div class="col-sm-8">
                        <input type="password" name="password_confirmation" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3"><b>{{ trans('users.role') }}</b></p>
                    <div class="col-sm-8">
                        @php
                        // สร้างอาเรย์ใหม่สำหรับ roles ที่แปลภาษา
                        $localizedRoles = [];
                        foreach ($roles as $k => $v) {
                        // สมมติ $roles = ['admin' => 'admin', 'headproject' => 'headproject', ...]
                        // $k = 'admin', $v = 'admin'
                        // ให้ key = 'admin' เหมือนเดิม, แต่ value = trans('users.role_admin') (ถ้า $v == 'admin')
                        $localizedRoles[$k] = trans('users.role_'.$v);
                        }
                        @endphp

                        {!! Form::select('roles[]', $localizedRoles, [], [
                        'class' => 'selectpicker',
                        'multiple',
                        'data-none-selected-text' => trans('users.nothing_selected')
                        ]) !!}

                    </div>
                </div>

                <div class="form-group row">
                    <p class="col-sm-3"><b>{{ trans('users.status') }}</b></p>
                    <div class="col-sm-8">
                        <select id='status' class="form-control" style='width: 200px;' name="status">
                            <option value="1" {{ "1" == $user->status ? 'selected' : '' }}>{{ trans('users.studying') }}</option>
                            <option value="2" {{ "2" == $user->status ? 'selected' : '' }}>{{ trans('users.graduated') }}</option>
                        </select>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-6">
                        <p for="category"><b>{{ trans('users.department') }} <span class="text-danger">*</span></b></p>
                        <select class="form-control" name="cat" id="cat" style="width: 100%;" required>
                            <option>{{ trans('users.select_category') }}</option>
                            @foreach ($departments as $cat)
                            <option value="{{$cat->id}}" {{$user->program->department_id == $cat->id  ? 'selected' : ''}}>
                                {{ trans('message.' . $cat->department_name_en) }}
                            </option>
                            @endforeach
                        </select>
                    </div>
                    <div class="col-md-6">
                        <p for="category"><b>{{ trans('users.program') }} <span class="text-danger">*</span></b></p>
                        <select class="form-control select2" name="sub_cat" id="subcat" required>
                            <option>{{ trans('users.select_subcategory') }}</option>
                            @foreach ($programs as $cat)
                            <option value="{{$cat->id}}" {{$user->program->id == $cat->id  ? 'selected' : ''}}>
                                @if(app()->getLocale() == 'th')
                                {{ $cat->program_name_th }}
                                @elseif(app()->getLocale() == 'en')
                                {{ $cat->program_name_en }}
                                @else
                                {{ $cat->program_name_cn }}
                                @endif

                            </option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary mt-5">{{ trans('users.submit') }}</button>
                <a class="btn btn-light mt-5" href="{{ route('users.index') }}">{{ trans('users.cancel') }}</a>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<!-- <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script> -->
<script>
    $('#cat').on('change', function(e) {
        var cat_id = e.target.value;
        $.get('/ajax-get-subcat?cat_id=' + cat_id, function(data) {
            $('#subcat').empty();
            $.each(data, function(index, areaObj) {
                $('#subcat').append('<option value="' + areaObj.id + '" >' + areaObj
                    .program_name_en + '</option>');
            });
        });
    });
</script>
@endsection