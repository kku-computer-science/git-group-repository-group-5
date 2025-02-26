@extends('layouts.layout')
@section('content')
<div class="container card-3 ">
    <p>{{ trans('ResearchG') }}</p>
    @foreach ($resg as $rg)
    <div class="card mb-4">
        <div class="row g-0">
            <div class="col-md-4">
                <div class="card-body">
                    <img src="{{asset('img/'.$rg->group_image)}}" alt="...">
                    <h2 class="card-text-1"> {{ trans('books.Laboratory') }}</h2>

                    <h2 class="card-text-2">
                        @foreach ($rg->user as $r)
                        @if($r->hasRole('teacher'))
                        @if(app()->getLocale() == 'en' and $r->academic_ranks_en == 'Lecturer' and $r->doctoral_degree == 'Ph.D.')
                        {{ $r->{'fname_en'} }} {{ $r->{'lname_en'} }}, Ph.D.
                        <br>
                        @elseif(app()->getLocale() == 'en' and $r->academic_ranks_en == 'Lecturer')
                        {{ $r->{'fname_en'} }} {{ $r->{'lname_en'} }}
                        <br>
                        @elseif(app()->getLocale() == 'en' and $r->doctoral_degree == 'Ph.D.')
                        {{ str_replace('Dr.', ' ', $r->{'position_en'}) }} {{ $r->{'fname_en'} }} {{ $r->{'lname_en'} }}, Ph.D.
                        <br>
                        @elseif(app()->getLocale() == 'zh')
                        {{ $r->{'fname_en'} }} {{ $r->{'lname_en'} }}
                        @if($r->doctoral_degree == '博士')
                        , 博士
                        @endif
                        <br>
                        @else
                        {{ $r->{'position_'.app()->getLocale()} }} {{ $r->{'fname_'.app()->getLocale()} }} {{ $r->{'lname_'.app()->getLocale()} }}
                        <br>
                        @endif
                        @endif
                        @endforeach
                    </h2>
                </div>
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h5 class="card-title"> {{ $rg->{'group_name_'.(app()->getLocale() == 'zh' ? 'cn' : app()->getLocale())} }}</h5>
                    <h3 class="card-text">{{ Str::limit($rg->{'group_desc_'.(app()->getLocale() == 'zh' ? 'cn' : app()->getLocale())}, 350) }}</h3>
                </div>
                <div>
                    <a href="{{ route('researchgroupdetail',['id'=>$rg->id])}}" class="btn btn-outline-info">{{ trans('books.details') }}</a>
                </div>
            </div>
        </div>
    </div>
    @endforeach
</div>

@stop