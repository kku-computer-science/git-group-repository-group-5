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
                <strong>{{ translateText('Opps!') }}</strong> {{ translateText('Something went wrong, please check below errors.') }}<br><br>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ translateText('Create department') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('departments.index') }}">{{ translateText('departments') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::open(array('route' => 'departments.store', 'method'=>'department')) !!}
                    <div class="form-group">
                        <strong>{{ translateText('department_name_TH') }}:</strong>
                        {!! Form::text('department_name_th', null, array('placeholder' => translateText('Department Name TH'),'class' => 'form-control')) !!}
                    </div>
                    <div class="form-group">
                        <strong>{{ translateText('department_name_EN') }}:</strong>
                        {!! Form::text('department_name_en', null, array('placeholder' => translateText('Department Name EN'),'class' => 'form-control')) !!}
                    </div>
                    
                    <button type="submit" class="btn btn-primary">{{ translateText('Submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>

@endsection