@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="card col-md-10" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('research_g.details') }}</h4>
            <p class="card-description">{{ trans('research_g.group_details') }}</p>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.group_name_th') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchGroup->group_name_th }}</p>
            </div>
            <div class="row mt-1">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.group_name_en') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchGroup->group_name_en }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.group_desc_th') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchGroup->group_desc_th }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.group_desc_en') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchGroup->group_desc_en }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.group_detail_th') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchGroup->group_detail_th }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.group_detail_en') }}</b></p>
                <p class="card-text col-sm-9">{{ $researchGroup->group_detail_en }}</p>
            </div>
            <div class="row mt-3">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.head') }}</b></p>
                <p class="card-text col-sm-9">
                    @foreach($researchGroup->user as $user)
                    @if ( $user->pivot->role == 1)
                    @if(app()->getLocale() == 'th')
                    {{ $user->position_th }}{{ $user->fname_th }} {{ $user->lname_th }}
                    @else
                    {{ $user->position_en }}{{ $user->fname_en }} {{ $user->lname_en }}
                    @endif
                    @endif
                    @endforeach
                </p>
            </div>
            <div class="row mt-1">
                <p class="card-text col-sm-3"><b>{{ trans('research_g.members') }}</b></p>
                <p class="card-text col-sm-9">
                    @foreach($researchGroup->user as $user)
                    @if ($user->pivot->role == 2)
                    @if(app()->getLocale() == 'th')
                    {{ $user->position_th }}{{ $user->fname_th }} {{ $user->lname_th }},
                    @else
                    {{ $user->position_en }}{{ $user->fname_en }} {{ $user->lname_en }},
                    @endif
                    @endif
                    @endforeach

                </p>
            </div>
            <a class="btn btn-primary mt-5" href="{{ route('researchGroups.index') }}">{{ trans('research_g.back') }}</a>
        </div>
    </div>



    @stop
    @section('javascript')
    <script>
        $(document).ready(function() {

            /* When click New customer button */
            $('#new-customer').click(function() {
                $('#btn-save').val("create-customer");
                $('#customer').trigger("reset");
                $('#customerCrudModal').html(trans('research_g.add_new_customer'));
                $('#crud-modal').modal('show');
            });
            /* When click New customer button */
            $('#new-customer2').click(function() {
                $('#btn-save').val("create-customer");
                $('#customer').trigger("reset");
                $('#customerCrudModal').html(trans('research_g.add_new_customer'));
                $('#crud-modal').modal('show');
            });
        });
    </script>



    @stop