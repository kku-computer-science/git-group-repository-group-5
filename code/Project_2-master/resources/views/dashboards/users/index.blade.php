@extends('dashboards.users.layouts.user-dash-layout')
@section('title','Dashboard')

@section('content')
<h3 style="padding-top: 10px;">{{ trans('dashboard.welcome_research_system') }}</h3>
<br>
<h4>
    {{ trans('dashboard.hello_user', [
        'position' => Auth::user()->{'position_' . app()->getLocale()},
        'fname' => app()->getLocale() === 'zh' ? Auth::user()->fname_en : Auth::user()->{'fname_' . app()->getLocale()},
        'lname' => app()->getLocale() === 'zh' ? Auth::user()->lname_en : Auth::user()->{'lname_' . app()->getLocale()}
    ]) }}
</h4>



@endsection
