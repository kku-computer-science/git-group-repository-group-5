@extends('dashboards.users.layouts.user-dash-layout')
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
        </div>
    </div>

    @if ($errors->any())
    <div class="alert alert-danger">
        <strong>Whoops!</strong> There were some problems with your input.<br><br>
        <ul>
            @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
    @endif
    <div class="col-md-10 grid-margin stretch-card">
        <div class="card" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{trans('papers.Editresearchpublication')}}</h4>
                <!-- <p class="card-description">กรอกข้อมูลรายละเอียดงานวิจัย</p> -->
                <form class="forms-sample" action="{{ route('papers.update',$paper->id) }}" method="POST">
                    @csrf
                    @method('PUT')
                    <div class="form-group row">
                        <p class="col-sm-3"><b>{{ trans('papers.PublicationSource')}}</b></p>
                        <div class="col-sm-8">
                            {!! Form::select('sources[]', $sources, $paperSource, array('class' => 'selectpicker','multiple data-live-search'=>"true")) !!}
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_name" class="col-sm-3 col-form-label">{{ trans('papers.ResearchName')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_name" value="{{ $paper->paper_name }}" class="form-control" placeholder="ชื่อเรื่อง">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputabstract" class="col-sm-3 col-form-label">{{ trans('papers.Abstract')}}</label>
                        <div class="col-sm-9">
                            <textarea type="text" name="abstract" placeholder="abstract" class="form-control form-control-lg" style="height:150px" >{{ $paper->abstract }}</textarea>
                        </div>
                    </div>
                    
                    <div class="form-group row">
                        <label for="exampleInputkeyword" class="col-sm-3 col-form-label">{{trans('papers.Keyword')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="keyword" value="{{ $paper->keyword }}" class="form-control" placeholder="keyword">
                            <p class="text-danger">{{ trans('papers.RedWordWarning')}}</p>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_sourcetitle" class="col-sm-3 col-form-label">{{ trans('papers.SourceTitle')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_sourcetitle" value="{{ $paper->paper_sourcetitle }}" class="form-control" placeholder="Sourcetitle">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_type" class="col-sm-3 col-form-label">{{ trans('papers.DocumentType')}}</label>
                        <div class="col-sm-9">
                            <select id='paper_type' class="custom-select my-select" style='width: 200px;' name="paper_type">
                                <option value="Journal" {{ "Journal" == $paper->paper_type ? 'selected' : '' }}>{{trans('papers.types.Journal')}}</option>
                                <option value="Conference Proceeding" {{ "Conference Proceeding" == $paper->paper_type ? 'selected' : '' }}>{{trans('papers.types.Conference')}}</option>
                                <option value="Book Series" {{ "Book Series" == $paper->paper_type ? 'selected' : '' }}>{{trans('papers.types.BookSeries')}}</option>
                                <option value="Book" {{ "Book" == $paper->paper_type ? 'selected' : '' }}>{{trans('papers.types.Book')}}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_subtype" class="col-sm-3 col-form-label">{{ trans('papers.SubType')}}</label>
                        <div class="col-sm-9">
                            <select id='paper_subtype' class="custom-select my-select" style='width: 200px;' name="paper_subtype">
                                <option value="Article" {{ "Article" == $paper->paper_subtype ? 'selected' : '' }}>{{trans('papers.subtypes.Article')}}</option>
                                <option value="Conference Paper" {{ "Conference Paper" == $paper->paper_subtype ? 'selected' : '' }}>{{trans('papers.subtypes.ConferencePaper')}}</option>
                                <option value="Editorial" {{ "Editorial" == $paper->paper_subtype ? 'selected' : '' }}>{{trans('papers.subtypes.Editorial')}}</option>
                                <option value="Book Chapter" {{ "Book Chapter" == $paper->paper_subtype ? 'selected' : '' }}>{{trans('papers.subtypes.BookChapter')}}</option>
                                <option value="Erratum" {{ "Erratum" == $paper->paper_subtype ? 'selected' : '' }}>{{trans('papers.subtypes.Erratum')}}</option>
                                <option value="Review" {{ "Review" == $paper->paper_subtype ? 'selected' : '' }}>{{trans('papers.subtypes.Review')}}</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpublication" class="col-sm-3 col-form-label">{{trans('papers.Publication')}}</label>
                        <div class="col-sm-9">
                            <select id='publication' class="custom-select my-select" style='width: 200px;' name="publication">
                                <option value="International Journal" {{ "International Journal" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.InternationalJournal')}}</option>
                                <option value="International Book" {{ "International Book" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.InternationalBook')}}</option>
                                <option value="International Conference" {{ "International Conference" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.InternationalConference')}}</option>
                                <option value="National Conference" {{ "National Conference" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.NationalConference')}}</option>
                                <option value="National Journal" {{ "National Journal" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.NationalJournal')}}</option>
                                <option value="National Book" {{ "National Book" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.NationalBook')}}</option>
                                <option value="National Magazine" {{ "National Magazine" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.NationalMagazine')}}</option>
                                <option value="Book Chapter" {{ "Book Chapter" == $paper->publication ? 'selected' : '' }}>{{trans('papers.PublicationName.BookChapter')}}</option>
                            </select>
                        </div>
                    </div>
                    <!-- <div class="form-group row">
                        <label for="exampleInputpaper_url" class="col-sm-3 col-form-label">Url</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_url" value="{{ $paper->paper_url }}" class="form-control" placeholder="paper_url">
                        </div>
                    </div> -->
                    <div class="form-group row">
                        <label for="exampleInputpaper_yearpub" class="col-sm-3 col-form-label">{{ trans('papers.PaperYearPublish')}}</label>
                        <div class="col-sm-9">
                            <input type="number" name="paper_yearpub" value="{{ $paper->paper_yearpub }}" class="form-control" placeholder="Year">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_volume" class="col-sm-3 col-form-label">{{ trans('papers.Volume')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_volume" value="{{ $paper->paper_volume }}" class="form-control" placeholder="Volume">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_issue" class="col-sm-3 col-form-label">{{ trans('papers.Issue')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_issue" value="{{ $paper->paper_issue }}" class="form-control" placeholder="Issue">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_citation" class="col-sm-3 col-form-label">{{ trans('papers.Citation')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_citation" value="{{ $paper->paper_citation }}" class="form-control" placeholder="Citation">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_page" class="col-sm-3 col-form-label">{{ trans('papers.PaperPage')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_page" value="{{ $paper->paper_page }}" class="form-control" placeholder="Page">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_doi" class="col-sm-3 col-form-label">DOI</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_doi" value="{{ $paper->paper_doi }}" class="form-control" placeholder="Doi">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_funder" class="col-sm-3 col-form-label">{{ trans('papers.SupportFund')}}</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_funder" value="{{ $paper->paper_funder }}" class="form-control" placeholder="Funder">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_url" class="col-sm-3 col-form-label">URL</label>
                        <div class="col-sm-9">
                            <input type="text" name="paper_url" value="{{ $paper->paper_url }}" class="form-control" placeholder="URL">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_doi" class="col-sm-3 ">{{ trans('papers.AuthorNameInDepartment')}}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table " id="dynamicAddRemove">
                                    <tr>
                                        <td><button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm "><i class="mdi mdi-plus"></i></button></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputpaper_author" class="col-sm-3 col-form-label">{{ trans('papers.AuthorNameOutDepartment')}}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="dynamic_field">

                                    <tr>
                                        <td><button type="button" name="add" id="add" class="btn btn-success btn-sm"><i class="fas fa-plus"></i></button>
                                        </td>
                                    </tr>

                                </table>
                                <!-- <input type="button" name="submit" id="submit" class="btn btn-info" value="Submit" /> -->
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary me-2">{{trans('papers.Submit')}}</button>
                    <a class="btn btn-light" href="{{ route('papers.index') }}">{{trans('papers.Cancel')}}</a>
                </form>
            </div>
        </div>
    </div>

</div>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script>
    $(document).ready(function() {
        // Internal Authors (teacher)
        var papers = <?php echo json_encode($paper->teacher ?? []); ?>;
        var i = 0;
        if (Array.isArray(papers)) {
            for (i = 0; i < papers.length; i++) {
                var obj = papers[i];
                $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i +
                    '][userid]" style="width: 200px;">@foreach($users as $user)<option value="{{ $user->id }}">{{ app()->getLocale() == "th" ? $user->fname_th . " " . $user->lname_th : $user->fname_en . " " . $user->lname_en }}</option>@endforeach</select></td><td><select id="pos' + i + '" class="custom-select my-select" style="width: 200px;" name="pos[]"><option value="1">{{ trans('papers.FirstAuthor') }}</option><option value="2">{{ trans('papers.CoAuthor') }}</option><option value="3">{{ trans('papers.CorrespondingAuthor') }}</option></select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
                );
                document.getElementById("selUser" + i).value = obj.id || '';
                document.getElementById("pos" + i).value = obj.pivot?.author_type || obj.author_type || '';
                $("#selUser" + i).select2();
            }
        }

        $("#add-btn2").click(function() {
            ++i;
            $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i +
                '][userid]" style="width: 200px;"><option value=""></option>@foreach($users as $user)<option value="{{ $user->id }}">{{ app()->getLocale() == "th" ? $user->fname_th . " " . $user->lname_th : $user->fname_en . " " . $user->lname_en }}</option>@endforeach</select></td><td><select id="pos' + i + '" class="custom-select my-select" style="width: 200px;" name="pos[]"><option value="1">{{ __("papers.FirstAuthor") }}</option><option value="2">{{ __("papers.CoAuthor") }}</option><option value="3">{{ __("papers.CorrespondingAuthor") }}</option></select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
            );
            $("#selUser" + i).select2();
        });

        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

        // External Authors (author)
        var patent = <?php echo json_encode($paper->author ?? []); ?>;
        var j = 0;
        if (Array.isArray(patent)) {
            for (j = 0; j < patent.length; j++) {
                var obj2 = patent[j];
                $("#dynamic_field").append('<tr id="row' + j +
                    '" class="dynamic-added"><td><input type="text" name="fname[]" value="' + (obj2.author_fname || '') + '" placeholder="{{ __("published_research.placeholder.author_fname") }}" class="form-control name_list" /></td><td><input type="text" name="lname[]" value="' + (obj2.author_lname || '') + '" placeholder="{{ __("published_research.placeholder.author_lname") }}" class="form-control name_list" /></td><td><select id="poss' + j + '" class="custom-select my-select" style="width: 200px;" name="pos2[]"><option value="1">{{ trans('papers.FirstAuthor') }}</option><option value="2">{{ trans('papers.CoAuthor') }}</option><option value="3">{{ trans('papers.CorrespondingAuthor') }}</option></select></td><td><button type="button" name="remove" id="' +
                    j + '" class="btn btn-danger btn-sm btn_remove">X</button></td></tr>');
                document.getElementById("poss" + j).value = obj2.pivot?.author_type || obj2.author_type || '';
            }
        }

        $('#add').click(function() {
            j++;
            $('#dynamic_field').append('<tr id="row' + j +
                '" class="dynamic-added"><td><input type="text" name="fname[]" placeholder="{{ __("published_research.placeholder.author_fname") }}" class="form-control name_list" /></td><td><input type="text" name="lname[]" placeholder="{{ __("published_research.placeholder.author_lname") }}" class="form-control name_list" /></td><td><select id="poss' + j + '" class="custom-select my-select" style="width: 200px;" name="pos2[]"><option value="1">{{ trans('papers.FirstAuthor') }}</option><option value="2">{{ trans('papers.CoAuthor') }}</option><option value="3">{{ trans('papers.CorrespondingAuthor') }}</option></select></td><td><button type="button" name="remove" id="' +
                j + '" class="btn btn-danger btn-sm btn_remove">X</button></td></tr>');
        });
                $(document).on('click', '.btn_remove', function() {
                    var button_id = $(this).attr("id");
                    $('#row' + button_id + '').remove();
                });
            });
        </script>

@endsection