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
            <div class="card-header">{{ translateText('Create permission') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('permissions.index') }}">{{ translateText('Permissions') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::open(array('route' => 'permissions.store','method'=>'POST')) !!}
                    <div class="form-group">
                        <strong>{{ translateText('Name:') }}</strong>
                        {!! Form::text('name', null, array('placeholder' => translateText('Name'),'class' => 'form-control')) !!}
                    </div>
                    <button type="submit" class="btn btn-primary">{{ translateText('Submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>

@endsection