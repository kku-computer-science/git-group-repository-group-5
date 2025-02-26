@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="card col-md-8" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">Fund Detail</h4>
            
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FundName') }}</b></p>
                <p class="card-text col-sm-9">{{ $fund->fund_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FundYear') }}</b></p>
                <p class="card-text col-sm-9">{{ $fund->fund_year }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FundDetails') }}</b></p>
                <p class="card-text col-sm-9">{{ $fund->fund_details }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FundName') }}</b></p>
                <p class="card-text col-sm-9">@if($fund->fund_type == 'ทุนภายใน')
                                                    {{ trans('funds.InternalCapital') }}
                                                @else
                                                    {{ trans('funds.ExternalCapital') }}
                                                @endif</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FundLevel') }}</b></p>
                <p class="card-text col-sm-9">{{ $fund->fund_level }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FundAgency') }}</b></p>
                <p class="card-text col-sm-9">{{ $fund->fund_name }}</p>
            </div>
            <div class="row">
                <p class="card-text col-sm-3"><b>{{ trans('funds.FillFundBy') }}</b></p>
                <p class="card-text col-sm-9">
                    @php
                        $locale = app()->getLocale(); // ดึงภาษาปัจจุบัน
                        $fname = $fund->user->{"fname_$locale"} ?? $fund->user->fname_en;
                        $lname = $fund->user->{"lname_$locale"} ?? $fund->user->lname_en;
                    @endphp
                    {{ $fname }} {{ $lname }}
                </p>

            </div>
            <div class="pull-right mt-5">
                <a class="btn btn-primary btn-sm" href="{{ route('funds.index') }}"> Back</a>
            </div>
        </div>

    </div>


</div>
@endsection