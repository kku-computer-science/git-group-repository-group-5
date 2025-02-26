@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (\Session::has('success'))
            <div class="alert alert-success">
                <p>{{ trans('permission.' . \Session::get('success')) }}</p>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('permission.permission') }}
                @can('role-create')
                    <span class="float-right">
                        <a class="btn btn-primary" href="{{ route('permissions.index') }}">{{ trans('permission.back') }}</a>
                    </span>
                @endcan
            </div>
            <div class="card-body">
                <div class="lead">
                    <strong>{{ trans('permission.name') }}:</strong>
                    {{ $permission->name }}
                </div>
            </div>
        </div>
    </div>
</div>


@endsection