@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="card col-md-8" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ translateText('Research Projects Detail') }}</h4>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Project Name') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->project_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Project start date') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->project_start }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Project end date') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->project_end }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Research funding sources') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->fund->fund_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Amount') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->budget }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Project details') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchProject->note }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Project status') }}</b></p>
                @if($researchProject->status == 1)
                <p class="card-text col-sm-9">{{ translateText('Apply for') }}</p>
                @elseif($researchProject->status == 2)
                <p class="card-text col-sm-9">{{ translateText('Proceed') }}</p>
                @else
                <p class="card-text col-sm-9">{{ translateText('Close the project') }}</p>
                @endif
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Project Manager') }}</b></p>
                @foreach($researchProject->user as $user)
                @if ( $user->pivot->role == 1)
                <p class="card-text col-sm-9">@if(app()->getLocale() == 'th'){{$user->position_th}} {{ $user->fname_th }} {{ $user->lname_th }}@else{{$user->position_en}} {{ $user->fname_en }} {{ $user->lname_en }}@endif</p>
                @endif
                @endforeach

            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Member') }}</b></p>
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
                <a class="btn btn-primary" href="{{ route('researchProjects.index') }}">{{ translateText('Back') }}</a>
            </div>

        </div>
    </div>
</div>
@endsection
