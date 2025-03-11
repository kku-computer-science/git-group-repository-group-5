<!-- @php
   if(Auth::user()->hasRole('admin')) {
      $layoutDirectory = 'dashboards.admins.layouts.admin-dash-layout';
   } else {
      $layoutDirectory = 'dashboards.users.layouts.user-dash-layout';
   }
@endphp -->

@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (count($errors) > 0)
            <div class="alert alert-danger">
                <strong>{{ trans('department.opps') }}</strong> {{ trans('department.error_message') }}<br><br>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('department.create_department') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('departments.index') }}">{{ trans('department.departments') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::open(['route' => 'departments.store', 'method' => 'post']) !!}
                    <div class="form-group">
                        <strong>{{ trans('department.department_name_th') }}:</strong>
                        {!! Form::text('department_name_th', null, ['placeholder' => trans('department.department_name_th_placeholder'),'class' => 'form-control']) !!}
                    </div>
                    <div class="form-group">
                        <strong>{{ trans('department.department_name_en') }}:</strong>
                        {!! Form::text('department_name_en', null, ['placeholder' => trans('department.department_name_en_placeholder'),'class' => 'form-control']) !!}
                    </div>

                    <button type="submit" class="btn btn-primary">{{ trans('department.submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>


@endsection