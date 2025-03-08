@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (count($errors) > 0)
            <div class="alert alert-danger">
                <strong>{{ trans('permission.oops') }}</strong> {{ trans('permission.something_went_wrong') }}<br><br>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('permission.edit_permission') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('permissions.index') }}">{{ trans('permission.permissions') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::model($permission, ['route' => ['permissions.update', $permission->id], 'method'=>'PATCH']) !!}
                    <div class="form-group">
                        <strong>{{ trans('permission.name') }}:</strong>
                        {!! Form::text('name', null, array('placeholder' => trans('permission.name'),'class' => 'form-control')) !!}
                    </div>
                    <button type="submit" class="btn btn-primary">{{ trans('permission.submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>
@endsection