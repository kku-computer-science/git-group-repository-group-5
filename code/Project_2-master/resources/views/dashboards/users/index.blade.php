@extends('dashboards.users.layouts.user-dash-layout')
@section('title','Dashboard')

@section('content')
<h3 style="padding-top: 10px;">{{ trans('dashboard.welcome_research_system') }}</h3>
<br>
<h4>{{ trans('dashboard.hello_user', ['position' => Auth::user()->position_th, 'fname' => Auth::user()->fname_th, 'lname' => Auth::user()->lname_th]) }}</h4>


@endsection
