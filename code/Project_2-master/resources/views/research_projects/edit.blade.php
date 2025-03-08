@extends('dashboards.users.layouts.user-dash-layout')
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

    <div class="card col-md-12" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('re_project.Editresearchprojectinformation') }}</h4>
            <p class="card-description">{{ trans('re_project.Fillintheinformationtoedittheresearchprojectdetails') }}</p>
            <form action="{{ route('researchProjects.update',$researchProject->id) }}" method="POST">
                @csrf
                @method('PUT')
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('re_project.ProjectName') }}</b></p>
                    <div class="col-sm-8">
                        <textarea name="project_name" value="{{ $researchProject->project_name }}" class="form-control" style="height:90px">{{ $researchProject->project_name }}</textarea>
                    </div>
                </div>
                {{--  <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('Project start date') }}</b></p>
                    <div class="col-sm-4">
                        <input type="date" name="project_start" value="{{ $researchProject->project_start }}" class="form-control">
                    </div>
                </div>  --}}

                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('message.startDate') }}</b></p>
                    <div class="col-sm-8">
                        <input type="text" id="datepicker_start" name="project_start" value="{{ $researchProject->project_start }}" class="form-control" placeholder="{{ trans('message.startDate') }}">
                    </div>
                </div>

                {{--  <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('Project end date') }}</b></p>
                    <div class="col-sm-4">
                        <input type="date" name="project_end" value="{{ $researchProject->project_end }}" class="form-control">
                    </div>
                </div>  --}}

                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('message.endDate') }}</b></p>
                    <div class="col-sm-8">
                        <input type="text" id="datepicker_end" name="project_end" value="{{ $researchProject->project_end }}" class="form-control" placeholder="{{ trans('message.endDate') }}">
                    </div>
                </div>


                <div class="form-group row mt-2">
                    <p for="exampleInputfund_details" class="col-sm-3"><b>{{ trans('message.SelectFund') }}</b></p>
                    <div class="col-sm-9">
                        <select id='fund' style='width: 200px;' class="custom-select my-select" name="fund">
                            <option value='' disabled selected>{{ trans('message.SelectFund') }}</option>@foreach($funds as $f)<option value="{{ $f->id }}" {{ $f->fund_name == $researchProject->fund->fund_name ? 'selected' : '' }}>{{ $f->fund_name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="form-group row mt-2">
                    <p class="col-sm-3 "><b>{{ trans('message.Yearofsubmis') }}</b></p>
                    <div class="col-sm-8">
                        <input type="year" name="project_year" class="form-control" placeholder="{{ trans('Year') }}" value="{{$researchProject->project_year}}">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('message.Budget') }}</b></p>
                    <div class="col-sm-4">
                        <input type="number" name="budget" value="{{ $researchProject->budget }}" class="form-control">
                    </div>
                </div>
                <div class="form-group row mt-2">
                    <p class="col-sm-3 "><b>{{ trans('message.ResponsibleAgency') }}</b></p>
                    <div class="col-sm-3">
                        <select id='dep' style='width: 200px;' class="custom-select my-select" name="responsible_department">
                            <option value=''>{{ trans('message.SelectDept') }}</option>
                            @foreach($deps as $dep)
                                <option value="{{ $dep->department_name_th }}" {{ $dep->department_name_th == $researchProject->responsible_department ? 'selected' : '' }}>
                                    {{ trans('message.' . $dep->department_name_en) }}
                                </option>
                            @endforeach
                        </select>

                    </div>
                </div>

                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('message.Projectdetails') }}</b></p>
                    <div class="col-sm-8">
                        <textarea name="note" class="form-control" style="height:90px">{{ $researchProject->note }}</textarea>
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ trans('re_project.status') }}</b></p>
                    <div class="col-sm-8">
                        <select id='status' class="custom-select my-select" style='width: 200px;' name="status">
                            <option value="1" {{ 1 == $researchProject->status ? 'selected' : '' }}>{{ trans('re_project.ApplyFor') }}</option>
                            <option value="2" {{ 2 == $researchProject->status ? 'selected' : '' }}>{{ trans('re_project.Proceed') }}</option>
                            <option value="3" {{ 3 == $researchProject->status ? 'selected' : '' }}>{{ trans('re_project.CloseTheProject') }}</option>
                        </select>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-12">
                    <table class="table">
                        <tr>
                            <th>{{ trans('message.ProjectManager') }}</th>
                        <tr>
                            <td>
                                <select id='head0' style='width: 200px;' name="head">
                                    @foreach($researchProject->user as $u)
                                    @if($u->pivot->role == 1)
                                    @foreach($users as $user)
                                    <option value="{{ $user->id }}" @if($u->id == $user->id) selected @endif>
                                        @if(app()->getLocale() == 'th')
                                        {{ $user->fname_th }} {{ $user->lname_th }}
                                        @else
                                        {{ $user->fname_en }} {{ $user->lname_en }}
                                        @endif

                                    </option>
                                    @endforeach
                                    @endif
                                    @endforeach
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-12 mb-3">
                    <table class="table" id="dynamicAddRemove">
                        <tr>
                            <th width="522.98px">{{ trans('message.InCo') }}</th>
                            <th><button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm add"><i class="mdi mdi-plus"></i></button></th>
                        </tr>
                    </table>
                </div>
                <div class="form-group row">
                        <label for="exampleInputpaper_author" class="col-sm-3 col-form-label">{{ trans('message.ExCo') }}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-bordered w-75" id="dynamic_field">

                                    <tr>
                                        <td><button type="button" name="add" id="add" class="btn btn-success btn-sm"><i class="mdi mdi-plus"></i></button>
                                        </td>
                                    </tr>

                                </table>
                                <!-- <input type="button" name="submit" id="submit" class="btn btn-info" value="Submit" /> -->
                            </div>
                        </div>
                        </div>
                <button type="submit" class="btn btn-primary mt-5">{{ trans('message.Submit') }}</button>
                <a class="btn btn-light mt-5" href="{{ route('researchProjects.index') }}"> {{ trans('re_project.Back') }}</a>
            </form>
        </div>
    </div>
</div>
@stop
@section('javascript')
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/locales/bootstrap-datepicker.zh-CN.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        // กำหนดภาษาของ Datepicker ตามค่า locale ของแอป
        var currentLang = "{{ app()->getLocale() }}";
        // ถ้าเป็นภาษาจีน ใช้ 'zh-CN' แต่ถ้าไม่ใช่ให้ใช้ภาษาอื่น (ในตัวอย่างนี้ใช้ค่า currentLang)
        var dpLang = currentLang === 'zh' ? 'zh' : currentLang;
        $('#datepicker_start').datepicker({
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayHighlight: true,
            language: dpLang
        });
        $('#datepicker_end').datepicker({
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayHighlight: true,
            language: dpLang
        });
    });
</script>
<script>
    $(document).ready(function() {

        $("#head0").select2();

        var researchProject = <?php echo json_encode($researchProject['user']); ?>;
        var i = 0;

        for (i = 0; i < researchProject.length; i++) {
            var obj = researchProject[i];

            if (obj.pivot.role === 2) {
                $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i + '][userid]" style="width: 200px;">@foreach($users as $user)<option value="{{ $user->id }}" >@if(app()->getLocale() == 'th'){{ $user->fname_th }} {{ $user->lname_th }}@else{{ $user->fname_en }} {{ $user->lname_en }}@endif</option>@endforeach</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>');
                document.getElementById("selUser" + i).value = obj.id;
                $("#selUser" + i).select2();
            }
        }

        $("#add-btn2").click(function() {
            ++i;
            $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i + '][userid]" style="width: 200px;"><option value="">{{ trans('message.SelectUser')}}</option>@foreach($users as $user)<option value="{{ $user->id }}">@if(app()->getLocale() == 'th'){{ $user->fname_th }} {{ $user->lname_th }}@else{{ $user->fname_en }} {{ $user->lname_en }}@endif</option>@endforeach</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>');
            $("#selUser" + i).select2();
        });

        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

    });
</script>
<script>
    $(document).ready(function() {
        var outsider = <?php echo $researchProject->outsider; ?>;

        var postURL = "<?php echo url('addmore'); ?>";
        var i = 0;
        //console.log(patent)

        for (i = 0; i < outsider.length; i++) {value="'+ obj.title_name +'"
            //console.log(patent);
            var obj = outsider[i];
            $("#dynamic_field").append('<tr id="row' + i +
                '" class="dynamic-added"><td><p>{{ trans('message.title_name') }} :</p><input type="text" name="title_name[]" value="'+ obj.title_name +'" placeholder="{{ trans('message.title_name') }}" style="width: 200px;" class="form-control name_list" /><br><p>{{ trans('message.fname') }} :</p><input type="text" name="fname[]" value="'+ obj.fname +'" placeholder="{{ trans('message.fname') }}" style="width: 300px;" class="form-control name_list" /><br><p>{{ trans('message.lname') }} :</p><input type="text" name="lname[]" value="'+ obj.lname +'" placeholder="{{ trans('message.lname') }} " style="width: 300px;" class="form-control name_list" /></td><td><button type="button" name="remove" id="' +
                i + '" class="btn btn-danger btn-sm btn_remove"><i class="mdi mdi-minus"></i></button></td></tr>');
            //document.getElementById("selUser" + i).value = obj.id;
            //console.log(obj.author_fname)
            // let doc=document.getElementById("row" + i)
            // doc.setAttribute('fname','aaa');
            // doc.setAttribute('lname','bbb');
            //document.getElementById("row" + i).value = obj.author_lname;
            //document.getAttribute("lname").value = obj.author_lname;
            //$("#selUser" + i).select2()


            //document.getElementById("#dynamicAddRemove").value = "10";
        }

        $('#add').click(function() {
            i++;
            $('#dynamic_field').append('<tr id="row' + i +
                '" class="dynamic-added"><td><p>{{ trans('message.title_name') }} :</p><input type="text" name="title_name[]" placeholder="{{ trans('message.title_name') }}" style="width: 200px;" class="form-control name_list" /><br><p>{{ trans('message.fname') }} :</p><input type="text" name="fname[]" placeholder="{{ trans('message.fname') }} " style="width: 300px;" class="form-control name_list" /><br><p>{{ trans('message.lname') }} :</p><input type="text" name="lname[]" placeholder="{{ trans('message.lname') }}" style="width: 300px;" class="form-control name_list" /></td><td><button type="button" name="remove" id="' +
                i + '" class="btn btn-danger btn-sm btn_remove"><i class="mdi mdi-minus"></i></button></td></tr>');
        });

        $(document).on('click', '.btn_remove', function() {
            var button_id = $(this).attr("id");
            $('#row' + button_id + '').remove();
        });

    });
</script>
@stop
