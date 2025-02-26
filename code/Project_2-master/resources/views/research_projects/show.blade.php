@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="card col-md-8" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('re_project.ResearchProjectsDetail') }}</h4>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.projectName') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->project_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.startDate') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->project_start }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.endDate') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->project_end }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.Researchfundingsource') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->fund->fund_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.Amount') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->budget }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.ProjectDetails') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->note }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.ProjectStatus') }}</b></p>
                @if($researchProject->status == 1)
                <p class="card-text col-sm-9">{{ trans('re_project.ApplyFor') }}</p>
                @elseif($researchProject->status == 2)
                <p class="card-text col-sm-9">{{ trans('re_project.Proceed') }}</p>
                @else
                <p class="card-text col-sm-9">{{ trans('re_project.CloseTheProject') }}</p>
                @endif
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.ProjectManager') }}</b></p>
                @foreach($researchProject->user as $user)
                @if ( $user->pivot->role == 1)
                <p class="card-text col-sm-9">@if(app()->getLocale() == 'th'){{$user->position_th}} {{ $user->fname_th }} {{ $user->lname_th }}@else{{$user->position_en}} {{ $user->fname_en }} {{ $user->lname_en }}@endif</p>
                @endif
                @endforeach

            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('re_project.Member') }}</b></p>
                @foreach($researchProject->user as $user)
                @if ( $user->pivot->role == 2)
                <p class="card-text col-sm-9">@if(app()->getLocale() == 'th'){{$user->position_th}} {{ $user->fname_th }} {{ $user->lname_th }}@else{{$user->position_en}} {{ $user->fname_en }} {{ $user->lname_en }}@endif
				@if (!$loop->last),@endif
                @endif

                @endforeach

                @foreach($researchProject->outsider as $user)
                @if ( $user->pivot->role == 2)
                ,{{$user->title_name}}{{ $user->fname}} {{ $user->fname}}</p>
				@if (!$loop->last),@endif
                @endif

                @endforeach
            </div>
            <div class="pull-right mt-5">
                <a class="btn btn-primary" href="{{ route('researchProjects.index') }}">{{ trans('re_project.Back') }}</a>
            </div>

        </div>
    </div>
</div>
@endsection
