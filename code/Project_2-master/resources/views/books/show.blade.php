@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="card col-md-8" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('books.ADetail') }}</h4>
            <p class="card-description">{{ translateText('Book details information') }}</p>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Book name') }}</b></p>
                <p class="card-text col-sm-9">{{ $paper->ac_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Year') }}</b></p>
                <p class="card-text col-sm-9">{{ date('Y', strtotime($paper->ac_year))+543 }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('Publication source') }}</b></p>
                <p class="card-text col-sm-9">{{ translateText($paper->ac_sourcetitle) }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ translateText('page') }}</b></p>
                <p class="card-text col-sm-9">{{ $paper->ac_page }}</p>
            </div>

            <div class="pull-right mt-5">
                <a class="btn btn-primary btn-sm" href="{{ route('books.index') }}">{{ translateText('Back') }} </a>
            </div>
        </div>

    </div>


</div>
@endsection