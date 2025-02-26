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
                <strong>{{ trans('Opps!') }}</strong> {{ trans('Something went wrong, please check below errors.') }}<br><br>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('Create department') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('departments.index') }}">{{ trans('departments') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::open(['route' => 'departments.store', 'method' => 'post']) !!}
                    <div class="form-group">
                        <strong>{{ trans('department_name_TH') }}:</strong>
                        {!! Form::text('department_name_th', null, ['placeholder' => trans('Department Name TH'),'class' => 'form-control']) !!}
                    </div>
                    <div class="form-group">
                        <strong>{{ trans('department_name_EN') }}:</strong>
                        {!! Form::text('department_name_en', null, ['placeholder' => trans('Department Name EN'),'class' => 'form-control']) !!}
                    </div>
                    
                    <button type="submit" class="btn btn-primary">{{ trans('Submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>


@endsection