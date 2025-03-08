@extends('dashboards.users.layouts.user-dash-layout')
<!-- <link  rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css"> -->
@section('content')

<style>
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
    @if ($errors->any())
    <div class="alert alert-danger">
        <strong>{{ trans('re_project.Whoops') }}</strong>{{ trans('re_project.Thereweresomeproblemswithyourinput') }} <br><br>
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ trans('message.' . $error) }}</li>
            @endforeach
        </ul>
    </div>
    @endif
    <div class="col-md-12 grid-margin stretch-card">
        <div class="card" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{ trans('message.AddResearchproject') }}</h4>
                <p class="card-description">{{ trans('message.Fillresearchproject') }}</p>
                <form action="{{ route('researchProjects.store') }}" method="POST">
                    @csrf
                    <div class="form-group row mt-5">
                        <label for="exampleInputfund_name" class="col-sm-2 ">{{ trans('message.researchprojectName') }}</label>
                        <div class="col-sm-8">
                            <input type="text" name="project_name" class="form-control" placeholder="{{ trans('message.researchprojectName') }}" value="{{ old('project_name') }}">
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_name" class="col-sm-2 ">{{ trans('message.startDate') }}</label>
                        <div class="col-sm-4">
                            <input type="date" name="project_start" id="Project_start" class="form-control" value="{{ old('project_start') }}">
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_name" class="col-sm-2 ">{{ trans('message.endDate') }}</label>
                        <div class="col-sm-4">
                            <input type="date" name="project_end" id="Project_end" class="form-control" value="{{ old('project_end') }}">
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_details" class="col-sm-2 ">{{ trans('message.SelectFund') }}</label>
                        <div class="col-sm-4">
                            <select id='fund' style='width: 200px;' class="custom-select my-select" name="fund">
                                <option value='' disabled selected>{{ trans('message.SelectFund') }}</option>@foreach($funds as $fund)<option value="{{ $fund->id }}">{{ $fund->fund_name }}</option>@endforeach
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputproject_year" class="col-sm-2 ">{{ trans('message.Yearofsubmis') }}</label>
                        <div class="col-sm-4">
                            <input type="year" name="project_year" class="form-control" placeholder="{{ translateText('Year') }}">
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_name" class="col-sm-2 ">{{ trans('message.Budget') }}</label>
                        <div class="col-sm-4">
                            <input type="int" name="budget" class="form-control" placeholder="{{ trans('message.unitMoney') }}" value="{{ old('budget') }}">
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputresponsible_department" class="col-sm-2 ">{{ trans('message.ResponsibleAgency') }}</label>
                        <div class="col-sm-9">
                            <select id='dep' style='width: 200px;' class="custom-select my-select" name="responsible_department">
                                <option value='' disabled selected>{{ trans('message.SelectDept') }}</option>@foreach($deps as $dep)<option value="{{ $dep->department_name_th }}">{{ trans('message.' . $dep->department_name_en) }}</option>@endforeach
                            </select>
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_details" class="col-sm-2 ">{{ trans('message.Projectdetails') }}</label>
                        <div class="col-sm-9">
                            <textarea type="text" name="note" class="form-control form-control-lg" style="height:150px" placeholder="{{ trans('message.Note') }}" value="{{ old('note') }}"></textarea>
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputstatus" class="col-sm-2 ">{{ trans('message.status') }}</label>
                        <div class="col-sm-3">
                            <select id='status' class="custom-select my-select" name="status">
                                <option value="" disabled selected>{{ trans('message.specifystatusProject') }}</option>
                                <option value="1">{{ trans('message.Apply') }}</option>
                                <option value="2">{{ trans('message.Proceed') }}</option>
                                <option value="3">{{ trans('message.ProjectClosed') }}</option>
                            </select>
                        </div>
                    </div>
                    <!-- <div class="form-group row">
                        <label for="exampleInputstatus" class="col-sm-2 ">{{ trans('message.status') }}</label>
                        <div class="col-sm-8">
                            <select name="status" class="form-control" id="status">
                                <option value="1">{{ trans('message.Apply') }}</option>
                                <option value="2">{{ trans('message.Proceed') }}</option>
                                <option value="3">{{ trans('message.ProjectClosed') }}</option>
                            </select>
                        </div>
                    </div> -->

                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_details" class="col-sm-2 ">{{ trans('message.ProjectManager') }}</label>
                        <div class="col-sm-9">
                            <select id='head0' style='width: 200px;' name="head">
                                <option value=''>{{ trans('message.SelectUser') }}</option>
                                @foreach($users as $user)
                                    <option value="{{ $user->id }}">
                                        @if(app()->getLocale() == 'th')
                                            {{ $user->fname_th }} {{ $user->lname_th }}
                                        @else
                                            {{ $user->fname_en }} {{ $user->lname_en }}
                                        @endif
                                    </option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    <div class="form-group row mt-2">
                        <label for="exampleInputfund_details" class="col-sm-2 ">{{ trans('message.InCo') }}</label>
                        <div class="col-sm-9">
                            <table class="table" id="dynamicAddRemove">
                                <tr>
                                    <th><button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm add"><i class="mdi mdi-plus"></i></button></th>
                                </tr>
                                <tr>
                                    <!-- <td><input type="text" name="moreFields[0][Budget]" placeholder="{{ trans('message.Entertitle') }}" class="form-control" /></td> -->
                                    <td>
                                        <select id='selUser0' style='width: 200px;' name="moreFields[0][userid]">
                                            <option value=''>{{ trans('message.SelectUser') }}</option>
                                            @foreach($users as $user)
                                                <option value="{{ $user->id }}">
                                                    @if(app()->getLocale() == 'th')
                                                        {{ $user->fname_th }} {{ $user->lname_th }}
                                                    @else
                                                        {{ $user->fname_en }} {{ $user->lname_en }}
                                                    @endif
                                                </option>
                                            @endforeach
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <!-- <div class="form-group row mt-2">
                        <label for="exampleInputpaper_doi" class="col-sm-2 ">{{ trans('message.ExCo') }}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-bordered w-75" id="dynamic_field">
                                    <tr>
                                        <td>
                                            <p>{{ trans('message.title_name') }} :</p><input type="text" name="title_name[]" placeholder="{{ trans('message.title_name') }}" style='width: 200px;' class="form-control name_list" /><br>
                                            <p>{{ trans('message.fname') }} :</p><input type="text" name="fname[]" placeholder="{{ trans('message.fname') }}" style='width: 300px;' class="form-control name_list" /><br>
                                            <p>{{ trans('message.lname') }} :</p><input type="text" name="lname[]" placeholder="{{ trans('message.lname') }}" style='width: 300px;' class="form-control name_list" />
                                        </td>
                                        <td><button type="button" name="add" id="add" class="btn btn-success btn-sm"><i class="mdi mdi-plus"></i></button>
                                        </td>
                                    </tr>
                                </table>
                                <!-- <input type="button" name="submit" id="submit" class="btn btn-info" value="Submit" />
                            </div>
                        </div>
                    </div> -->
                    <div class="form-group row mt-2">
                        <label for="exampleInputpaper_doi" class="col-sm-2 ">{{ trans('message.ExCo') }}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-hover small-text" id="tb">
                                    <tr class="tr-header">
                                        <th>{{ trans('message.title_name') }}</th>
                                        <th>{{ trans('message.fname') }}</th>
                                        <th>{{ trans('message.lname') }}</th>
                                        <!-- <th>{{ translateText('Email Id') }}</th> -->
                                            <!-- <button type="button" name="add" id="add" class="btn btn-success btn-sm"><i class="mdi mdi-plus"></i></button> -->
                                        <th><a href="javascript:void(0);" style="font-size:18px;" id="addMore2" title="Add More Person"><i class="mdi mdi-plus"></i></span></a></th>
                                    <tr>
                                        <td><input type="text" name="title_name[]" class="form-control" placeholder="{{ trans('message.title_name') }}"></td>
                                        <td><input type="text" name="fname[]" class="form-control" placeholder="{{ trans('message.fname') }}" ></td>
                                        <td><input type="text" name="lname[]" class="form-control" placeholder="{{ trans('message.lname') }}" ></td>
                                        <!-- <td><input type="text" name="emailid[]" class="form-control"></td> -->
                                        <td><a href='javascript:void(0);' class='remove'><span><i class="mdi mdi-minus"></span></a></td>
                                    </tr>
                                </table>
                                <!-- <input type="button" name="submit" id="submit" class="btn btn-info" value="Submit" /> -->
                            </div>
                        </div>
                    </div>
                    <div class="pt-4">
                        <button type="submit" class="btn btn-primary me-2">{{ trans('message.Submit') }}</button>
                        <a class="btn btn-light" href="{{ route('researchProjects.index')}}">{{ trans('message.Cancel') }}</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    @stop
    @section('javascript')
    <script>
        $(document).ready(function() {
            $("#selUser0").select2()
            $("#head0").select2()
            //$("#fund").select2()
            //$("#dep").select2()
            var i = 0;

            $("#add-btn2").click(function() {

                ++i;
                $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i +
                    '" name="moreFields[' + i +
                    '][userid]"  style="width: 200px;"><option value="">{{ trans('message.SelectUser') }}</option>@foreach($users as $user)<option value="{{ $user->id }}">@if(app()->getLocale() == 'th'){{ $user->fname_th }} {{ $user->lname_th }}@else{{ $user->fname_en }} {{ $user->lname_en }}@endif</option>@endforeach</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
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
            var i = 0;


            $('#add').click(function() {
                i++;
                $('#dynamic_field').append('<tr id="row' + i +
                    '" class="dynamic-added"><td><p>{{ trans('message.title_name') }} :</p><input type="text" name="title_name[]" placeholder="{{ trans('message.title_name') }}" style="width: 200px;" class="form-control name_list" /><br><p>{{ trans('message.fname') }} :</p><input type="text" name="fname[]" placeholder="{{ trans('message.fname') }}" style="width: 300px;" class="form-control name_list" /><br><p>{{ trans('message.lname') }} :</p><input type="text" name="lname[]" placeholder="{{ trans('message.lname') }}" style="width: 300px;" class="form-control name_list" /></td><td><button type="button" name="remove" id="' +
                    i + '" class="btn btn-danger btn-sm btn_remove"><i class="mdi mdi-minus"></i></button></td></tr>');
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
                                '<li>{{ translateText('Record Inserted Successfully.') }}</li>');
                        }
                    }
                });
            });


            function printErrorMsg(msg) {
                $(".print-error-msg").find("ul").html('');
                $(".print-error-msg").css('display', 'block');
                $(".print-success-msg").css('display', 'none');
                $.each(msg, function(key, value) {
                    $(".print-error-msg").find("ul").append('<li>' + translateText(value) + '</li>');
                });
            }
        });
    </script>
    <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script> -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#addMore2').on('click', function() {
                var data = $("#tb tr:eq(1)").clone(true).appendTo("#tb");
                data.find("input").val('');
            });
            $(document).on('click', '.remove', function() {
                var trIndex = $(this).closest("tr").index();
                if (trIndex > 1) {
                    $(this).closest("tr").remove();
                } else {
                    alert(
                        @if(app()->getLocale() == 'en')
                        "Sorry!! Can't remove first row!"
                        @elseif(app()->getLocale() == 'th')
                        "ขออภัย!! ไม่สามารถลบแถวแรกได้!"
                        @else
                        "抱歉!! 无法删除第一行!"
                        @endif
                    );
                }
            });
        });
    </script>
    @stop
