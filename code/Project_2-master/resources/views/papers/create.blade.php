@extends('dashboards.users.layouts.user-dash-layout')
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
@section('content')
<style type="text/css">
    .dropdown-toggle .filter-option {
        height: 40px;
        width: 400px !important;
        color: #212529;
        background-color: #fff;
        border-width: 0.2;
        border-style: solid;
        border-color: -internal-light-dark(rgb(118, 118, 118), rgb(133, 133, 133));
        border-radius: 5px;
        padding: 4px 10px;
    }

    .my-select {
        background-color: #fff;
        color: #212529;
        border: #000 0.2 solid;
        border-radius: 5px;
        padding: 4px 10px;
        width: 100%;
        font-size: 14px;
    }
</style>
<div class="container">
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-right">

            </div>
        </div>
    </div>

    @if ($errors->any())
    <div class="alert alert-danger">
        <strong>{{trans('papers.Whoops')}}</strong> {{trans('papers.ThereWas')}}<br><br>
        <ul>
            @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
    @endif

    @php
    $locale = app()->getLocale(); 
    @endphp
    <!-- <a class="btn btn-primary" href="{{ route('papers.index') }}"> Back </a> -->

    <div class="col-md-10 grid-margin stretch-card">
        <div class="card" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{ trans('papers.AddPublicationResearch')}}</h4>
                <p class="card-description">{{trans('papers.FillResearchDetail')}}</p>
                <form class="forms-sample" action="{{ route('papers.store') }}" method="POST">
                    @csrf
                    <div class="form-group row">
                        <label for="exampleInputpaper_name" class="col-sm-3 col-form-label"><b>{{trans('papers.PublicationSource')}}</b></label>
                        <div class="col-sm-9">
                        <select class="selectpicker" multiple data-live-search="true" name="cat[]" title="{{trans('papers.PleaseSelectSourceTitle')}}" data-width="50%" data-size="5">
                            @foreach( $source as $s)
                            <option value='{{ $s->id }}'>{{ $s->source_name }}</option>
                            @endforeach
                        </select>

                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="exampleInputpaper_name" class="col-sm-3 col-form-label"><b>{{trans('papers.ResearchName')}}</b></label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_name" class="form-control" placeholder="{{trans('papers.ResearchName')}}">
                        </div>
                    </div>
                    
                    <!-- <div class="form-group row">
                        <label for="exampleInputpaper_type" class="col-sm-3 col-form-label"><b>ประเภทของเอกสาร</b></label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_type" class="form-control" placeholder="paper_type">
                        </div>
                    </div> -->

                    <div class="form-group row">
                        <label for="exampleInputabstract" class="col-sm-3 col-form-label"><b>{{trans('papers.Abstract')}}</b></label>
                        <div class="col-sm-9">
                            <textarea type="text" name="abstract" class="form-control form-control-lg" style="height:150px" placeholder="{{trans('papers.Abstract')}}"></textarea>
                            <!-- <input type=" text" name="abstract" class="form-control" placeholder="abstract"> -->
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="exampleInputkeyword" class="col-sm-3 col-form-label"><b>{{trans('papers.Keyword')}}</b></label>
                        <!-- <div class="col-sm-9">
                            <p>แต่ละคําต้องคั่นด้วยเครื่องหมายเซมิโคลอน (;) แล้วเว้นวรรคหนึ่งครั้ง</p>
                        </div> -->
                        <div class="col-sm-9">
                            <input type="text" name="keyword" class="form-control" placeholder="{{trans('papers.Keyword')}}">
                            <p class="text-danger">{{trans('papers.RedWordWarning')}}</p>
                        </div>

                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_type" class="col-sm-3 col-form-label"><b>{{trans('papers.DocumentType')}}</b></label>
                        <div class="col-sm-9">
                            <select id='paper_type' class="custom-select my-select" style='width: 200px;' name="paper_type">
                                <option value="" disabled selected> {{trans('papers.PleaseSelectDocumentType')}} </option>
                                <option value="Journal">{{ trans('papers.types.Journal') }}</option>
                                <option value="Conference Proceeding">{{ trans('papers.types.ConferenceProceeding') }}</option>
                                <option value="Book Series">{{ trans('papers.types.BookSeries') }}</option>
                                <option value="Book">{{ trans('papers.types.Book') }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_subtype" class="col-sm-3 col-form-label"><b>{{trans('papers.SubType')}}</b></label>
                        <div class="col-sm-9">
                            <select id='paper_subtype' class="custom-select my-select" style='width: 200px;' name="paper_subtype">
                            <option value="" disabled selected>{{trans('papers.PleaseSelectSubType')}}</option>
                                <option value="Article">{{ trans('papers.subtypes.Article') }}</option>
                                <option value="Conference Paper">{{ trans('papers.subtypes.ConferencePaper') }}</option>
                                <option value="Editorial">{{ trans('papers.subtypes.Editorial') }}</option>
                                <option value="Review">{{ trans('papers.subtypes.Review') }}</option>
                                <option value="Erratum">{{ trans('papers.subtypes.Erratum') }}</option>
                                <option value="Book Chapter">{{ trans('papers.subtypes.BookChapter') }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpublicatione" class="col-sm-3 col-form-label"><b>{{trans('papers.Publication')}}
                                </b></label>
                        <div class="col-sm-9">
                        <select id='publication' class="custom-select my-select" style='width: 200px;' name="publication">
                            <option value="" disabled selected> {{ trans('papers.PleaseSelectType') }} </option>
                            <option value="InternationalJournal">{{ trans('papers.PublicationName.InternationalJournal') }}</option>
                            <option value="InternationalBook">{{ trans('papers.PublicationName.InternationalBook') }}</option>
                            <option value="InternationalConference">{{ trans('papers.PublicationName.InternationalConference') }}</option>
                            <option value="NationalConference">{{ trans('papers.PublicationName.NationalConference') }}</option>
                            <option value="NationalJournal">{{ trans('papers.PublicationName.NationalJournal') }}</option>
                            <option value="NationalBook">{{ trans('papers.PublicationName.NationalBook') }}</option>
                            <option value="NationalMagazine">{{ trans('papers.PublicationName.NationalMagazine') }}</option>
                            <option value="BookChapter">{{ trans('papers.PublicationName.BookChapter') }}</option>
                        </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_sourcetitle" class="col-sm-3 col-form-label"><b>{{trans('papers.SourceTitle')}}</b></label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_sourcetitle" class="form-control" placeholder="{{trans('papers.SourceTitle')}}">
                        </div>
                    </div>
            
                    <div class="form-group row">
                        <label for="exampleInputpaper_yearpub" class="col-sm-3 col-form-label"><b>{{trans('papers.PaperYearPublish')}}</b></label>
                        <div class="col-sm-4">
                            <input type="text" name="paper_yearpub" class="form-control" placeholder="{{trans('papers.PaperYearPublish')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_volume" class="col-sm-3 col-form-label"><b>{{trans('papers.Volume')}}</b></label>
                        <div class="col-sm-4">
                            <input type="text" name="paper_volume" class="form-control" placeholder="{{trans('papers.Volume')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_issue" class="col-sm-3 col-form-label"><b>{{trans('papers.Issue')}}</b></label>
                        <div class="col-sm-4">
                            <input type="text" name="paper_issue" class="form-control" placeholder="{{trans('papers.Issue')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_citation" class="col-sm-3 col-form-label"><b>{{trans('papers.Citation')}}</b></label>
                        <div class="col-sm-4">
                            <input type="text" name="paper_citation" class="form-control" placeholder="{{trans('papers.Citation')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_page" class="col-sm-3 col-form-label"><b>{{trans('papers.PaperPage')}}</b></label>
                        <div class="col-sm-4">
                            <input type="text" name="paper_page" class="form-control" placeholder="01-99">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_doi" class="col-sm-3 col-form-label"><b>DOI</b></label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_doi" class="form-control" placeholder="DOI">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_funder" class="col-sm-3 col-form-label"><b>{{ trans('papers.SupportFund')}}</b></label>
                        <div class="col-sm-9">
                            <input type="int" name="paper_funder" class="form-control" placeholder="{{ trans('papers.SupportFund')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_url" class="col-sm-3 col-form-label"><b>URL</b></label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_url" class="form-control" placeholder="url">
                        </div>
                    </div>
                    <div class="form-group row">
                    <label for="exampleInputpaper_doi" class="col-sm-3"><b>{{ trans('papers.AuthorNameInDepartment') }}</b></label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="dynamicAddRemove">
                                    <tr>
                                        <td>
                                            <select id='selUser0' style='width: 200px;' name="moreFields[0][userid]">
                                                <option value=''>{{__("papers.SelectUser")}}</option>
                                                @foreach($users as $user)
                                                    <option value="{{ $user->id }}">
                                                        @if(app()->getLocale() == 'th')
                                                            {{ $user->fname_th }} {{ $user->lname_th }}
                                                        @elseif(app()->getLocale() == 'en')
                                                            {{ $user->fname_en }} {{ $user->lname_en }}
                                                        @elseif(app()->getLocale() == 'zh')
                                                            {{ $user->fname_en }} {{ $user->lname_en }}
                                                        @endif
                                                    </option>
                                                @endforeach
                                            </select>
                                        </td>
                                        <td><select id='pos' class="custom-select my-select" style='width: 200px;' name="pos[]">
                                                <option value="1">{{trans('papers.FirstAuthor')}}</option>
                                                <option value="2">{{trans('papers.CoAuthor')}}</option>
                                                <option value="3">{{trans('papers.CorrespondingAuthor')}}</option>
                                            </select>
                                        </td>
                                        <td><button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm"><i class="fas fa-plus"></i></button>
                                        </td>
                                    </tr>
                                </table>
                                <!-- <input type="button" name="submit" id="submit" class="btn btn-info" value="Submit" />-->
                            </div>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_doi" class="col-sm-3 col-form-label"><b>{{trans('papers.AuthorNameOutDepartment')}}</b></label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="dynamic_field">
                                    <tr>
                                        <td><input type="text" name="fname[]" placeholder={{trans('papers.FirstName')}} class="form-control name_list" /></td>
                                        <td><input type="text" name="lname[]" placeholder={{trans('papers.LastName')}} class="form-control name_list" /></td>
                                        <td><select id='pos2' class="custom-select my-select" style='width: 200px;' name="pos2[]">
                                                <option value="1">{{__("papers.FirstAuthor")}}</option>
                                                <option value="2">{{__("papers.CoAuthor")}}</option>
                                                <option value="3">{{__("papers.CorrespondingAuthor")}}</option>
                                            </select>
                                        </td>
                                        <td><button type="button" name="add" id="add" class="btn btn-success btn-sm"><i class="fas fa-plus"></i></button>
                                        
                                    </tr>
                                </table>
                                <!-- <input type="button" name="submit" id="submit" class="btn btn-info" value="Submit" /> -->
                            </div>
                        </div>
                    </div>
                    <button type="submit" name="submit" id="submit" class="btn btn-primary me-2">{{__("papers.Submit")}}</button>
                    <a class="btn btn-light" href="{{ route('papers.index')}}">{{__("papers.Cancel")}}</a>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        $("#selUser0").select2()
        $("#head0").select2()

        var i = 0;

        $("#add-btn2").click(function() {

            ++i;
            $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i +
                '][userid]"  style="width: 200px;"><option value="">{{__("papers.SelectUser")}}</option>@foreach($users as $user)<option value="{{ $user->id }}">
                        @if($locale == 'th')
                            {{ $user->fname_th }} {{ $user->lname_th }}
                        @elseif($locale == 'en' || $locale == 'zh')
                            {{ $user->fname_en }} {{ $user->lname_en }}
                        @else
                            {{ $user->fname_en }} {{ $user->lname_en }}
                        @endif</option>@endforeach</select></td><td><select id="pos" class="custom-select my-select" style="width: 200px;" name="pos[]"><option value="1">{{__("papers.FirstAuthor")}}</option><option value="2">{{__("papers.CoAuthor")}}</option><option value="3">{{__("papers.CorrespondingAuthor")}}</option></select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr">X</i></button></td></tr>'
            );
            $("#selUser" + i).select2()
        });
        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

    });
</script>
<script type="text/javascript">
    $(document).ready(function() {
        var postURL = "<?php echo url('addmore'); ?>";
        var i = 1;


        $('#add').click(function() {
            i++;
            $('#dynamic_field').append('<tr id="row' + i +
                '" class="dynamic-added"><td><input type="text" name="fname[]" placeholder="@lang('papers.EnterYourName')" class="form-control name_list" /></td><td><input type="text" name="lname[]" placeholder="@lang('papers.EnterYourLastName')" class="form-control name_list" /></td><td><select id="pos2" class="custom-select my-select" style="width: 200px;" name="pos2[]"><option value="1">{{__("papers.FirstAuthor")}}</option><option value="2">{{__("papers.CoAuthor")}}</option><option value="3">{{__("papers.CorrespondingAuthor")}}</option></select></td><td><button type="button" name="remove" id="' +
                i + '" class="btn btn-danger btn-sm btn_remove">X</button></td></tr>');
        });


        $(document).on('click', '.btn_remove', function() {
            var button_id = $(this).attr("id");
            $('#row' + button_id + '').remove();
        });


        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });


        $('#submit').click(function() {
            $.ajax({
                url: postURL,
                method: "POST",
                data: $('#add_name').serialize(),
                type: 'json',
                success: function(data) {
                    if (data.error) {
                        printErrorMsg(data.error);
                    } else {
                        i = 1;
                        $('.dynamic-added').remove();
                        $('#add_name')[0].reset();
                        $(".print-success-msg").find("ul").html('');
                        $(".print-success-msg").css('display', 'block');
                        $(".print-error-msg").css('display', 'none');
                        $(".print-success-msg").find("ul").append(
                            '<li>Record Inserted Successfully.</li>');
                    }
                }
            });
        });


        function printErrorMsg(msg) {
            $(".print-error-msg").find("ul").html('');
            $(".print-error-msg").css('display', 'block');
            $(".print-success-msg").css('display', 'none');
            $.each(msg, function(key, value) {
                $(".print-error-msg").find("ul").append('<li>' + value + '</li>');
            });
        }
    });
</script>
@endsection
