@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('papers.PaperDetail')}}</h4>
          
            <div class="row mt-3">
                <p class="card-text col-sm-3"><b>{{ trans('papers.PaperName')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_name }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.Abstract')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->abstract }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.Keyword')}}</b></p>
                <p class="card-text col-sm-9">
                    {{ $paper->keyword }}
                </p>


                <!-- <p class="card-text col-sm-9">{{ $paper->keyword }}</p> -->
            </div>
            <div class="row mt-2">
            <p class="card-text col-sm-3"><b>{{ trans('papers.PaperType') }}</b></p>
            <p class="card-text col-sm-9">
            {{ trans('papers.types.' . Str::studly(str_replace(' ', '', $paper->paper_type)), [], app()->getLocale()) }}
            </p>
        </div>


            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.DocumentType')}}</b></p>
                <p class="card-text col-sm-9">
                {{ trans('papers.subtypes.' . $paper->paper_subtype) }}
            </p>

            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.Publication')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->publication }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.Writer')}}</b></p>
                <p class="card-text col-sm-9">

                @foreach($paper->author as $teacher)
    @if($teacher->pivot->author_type == 1)
        <b>{{ trans('papers.FirstAuthor') }}:</b>
        @if(app()->getLocale() == 'th' && !empty($teacher->author_fname_th) && !empty($teacher->author_lname_th))
            {{ $teacher->author_fname_th }} {{ $teacher->author_lname_th }}
        @else
            {{ $teacher->author_fname }} {{ $teacher->author_lname }}
        @endif
        <br>
    @endif
@endforeach

            @foreach($paper->teacher as $teacher)
                @if($teacher->pivot->author_type == 1)
                    <b>{{ trans('papers.FirstAuthor') }}:</b>
                    @if(app()->getLocale() == 'th' && !empty($teacher->fname_th) && !empty($teacher->lname_th))
                        {{ $teacher->fname_th }} {{ $teacher->lname_th }}
                    @else
                        {{ $teacher->fname_en }} {{ $teacher->lname_en }}
                    @endif
                    <br>
                @endif
            @endforeach

            @foreach($paper->author as $teacher)
                @if($teacher->pivot->author_type == 2)
                    <b>{{ trans('papers.CoAuthor') }}:</b>
                    @if(app()->getLocale() == 'th' && !empty($teacher->author_fname_th) && !empty($teacher->author_lname_th))
                        {{ $teacher->author_fname_th }} {{ $teacher->author_lname_th }}
                    @else
                        {{ $teacher->author_fname }} {{ $teacher->author_lname }}
                    @endif
                    <br>
                @endif
            @endforeach

            @foreach($paper->teacher as $teacher)
                @if($teacher->pivot->author_type == 2)
                    <b>{{ trans('papers.CoAuthor') }}:</b>
                    @if(app()->getLocale() == 'th' && !empty($teacher->fname_th) && !empty($teacher->lname_th))
                        {{ $teacher->fname_th }} {{ $teacher->lname_th }}
                    @else
                        {{ $teacher->fname_en }} {{ $teacher->lname_en }}
                    @endif
                    <br>
                @endif
            @endforeach

            @foreach($paper->author as $teacher)
                @if($teacher->pivot->author_type == 3)
                    <b>{{ trans('papers.CorrespondingAuthor') }}:</b>
                    @if(app()->getLocale() == 'th' && !empty($teacher->author_fname_th) && !empty($teacher->author_lname_th))
                        {{ $teacher->author_fname_th }} {{ $teacher->author_lname_th }}
                    @else
                        {{ $teacher->author_fname }} {{ $teacher->author_lname }}
                    @endif
                    <br>
                @endif
            @endforeach

            @foreach($paper->teacher as $teacher)
                @if($teacher->pivot->author_type == 3)
                    <b>{{ trans('papers.CorrespondingAuthor') }}:</b>
                    @if(app()->getLocale() == 'th' && !empty($teacher->fname_th) && !empty($teacher->lname_th))
                        {{ $teacher->fname_th }} {{ $teacher->lname_th }}
                    @else
                        {{ $teacher->fname_en }} {{ $teacher->lname_en }}
                    @endif
                    <br>
                @endif
            @endforeach

                    



                </p>
            </div>

            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.SourceTitle')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_sourcetitle }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.PaperYearPublish')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_yearpub }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.Volume')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_volume }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.Issue')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_issue}}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>{{ trans('papers.PaperPage')}}</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_page }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>DOI</b></p>
                <p class="card-text col-sm-9">{{ $paper->paper_doi }}</p>
            </div>
            <div class="row mt-2">
                <p class="card-text col-sm-3"><b>URL</b></p>
                <a href="{{ $paper->paper_url }}" target="_blank" class="card-text col-sm-9">{{ $paper->paper_url }}</a>
            </div>

            <a class="btn btn-primary mt-5" href="{{ route('papers.index') }}">{{ trans('papers.Back')}}</a>
        </div>
    </div>

</div>
@endsection