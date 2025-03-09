@extends('dashboards.users.layouts.user-dash-layout')
@section('title', 'Dashboard')

@section('content')
<h3 style="padding-top: 10px;">{{ trans('dashboard.welcome_research_system') }}</h3>
<br>
<h4>
    @if(app()->getLocale() === 'zh')
        {{ trans('dashboard.hello_user', [
            'position' => Auth::user()->position_en,
            'fname' => (Auth::user()->fname_en === 'staff' ? '员工' : (Auth::user()->fname_en === 'admin' ? '管理员' : Auth::user()->fname_en)),
            'lname' => Auth::user()->lname_en
        ]) }}
    @else
        {{ trans('dashboard.hello_user', [
            'position' => Auth::user()->{'position_' . app()->getLocale()},
            'fname' => Auth::user()->{'fname_' . app()->getLocale()},
            'lname' => Auth::user()->{'lname_' . app()->getLocale()}
        ]) }}
    @endif
</h4>
@endsection
