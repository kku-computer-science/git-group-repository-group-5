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
        <strong>Whoops!</strong>{{ translateText('There were some problems with your input.') }} <br><br>
        <ul>
            @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
    @endif
    <div class="card col-md-12" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ translateText('Edit research project information') }}</h4>
            <p class="card-description">{{ translateText('Fill in the information to edit the research project details.') }}</p>
            <form action="{{ route('researchProjects.update',$researchProject->id) }}" method="POST">
                @csrf
                @method('PUT')
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ translateText('Project Name') }}</b></p>
                    <div class="col-sm-8">
                        <textarea name="project_name" value="{{ $researchProject->project_name }}" class="form-control" style="height:90px">{{ $researchProject->project_name }}</textarea>
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ translateText('Project start date') }}</b></p>
                    <div class="col-sm-4">
                        <input type="date" name="project_start" value="{{ $researchProject->project_start }}" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ translateText('Project end date') }}</b></p>
                    <div class="col-sm-4">
                        <input type="date" name="project_end" value="{{ $researchProject->project_end }}" class="form-control">
                    </div>
                </div>
                <div class="form-group row mt-2">
                    <p for="exampleInputfund_details" class="col-sm-3"><b>{{ translateText('Select a scholarship') }}</b></p>
                    <div class="col-sm-9">
                        <select id='fund' style='width: 200px;' class="custom-select my-select" name="fund">
                            <option value='' disabled selected>{{ translateText('Select research funds') }}</option>@foreach($funds as $f)<option value="{{ $f->id }}" {{ $f->fund_name == $researchProject->fund->fund_name ? 'selected' : '' }}>{{ $f->fund_name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="form-group row mt-2">
                    <p class="col-sm-3 "><b>{{ translateText('Year of submission (A.D.)') }}</b></p>
                    <div class="col-sm-8">
                        <input type="year" name="project_year" class="form-control" placeholder="{{ translateText('Year') }}" value="{{$researchProject->project_year}}">
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ translateText('Budget') }}</b></p>
                    <div class="col-sm-4">
                        <input type="number" name="budget" value="{{ $researchProject->budget }}" class="form-control">
                    </div>
                </div>
                <div class="form-group row mt-2">
                    <p class="col-sm-3 "><b>{{ translateText('Responsible agency') }}</b></p>
                    <div class="col-sm-3">
                        <select id='dep' style='width: 200px;' class="custom-select my-select"  name="responsible_department">
                            <option value=''>{{ translateText('Select a major') }}</option>@foreach($deps as $dep)<option value="{{ $dep->department_name_th }}" {{ $dep->department_name_th == $researchProject->responsible_department ? 'selected' : '' }}>{{ $dep->department_name_th }}</option>@endforeach
                        </select>
                    </div>
                </div>

                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ translateText('Research project details') }}</b></p>
                    <div class="col-sm-8">
                        <textarea name="note" class="form-control" style="height:90px">{{ $researchProject->note }}</textarea>
                    </div>
                </div>
                <div class="form-group row">
                    <p class="col-sm-3 "><b>{{ translateText('status') }}</b></p>
                    <div class="col-sm-8">
                        <select id='status' class="custom-select my-select" style='width: 200px;' name="status">
                            <option value="1" {{ 1 == $researchProject->status ? 'selected' : '' }}>{{ translateText('Apply for') }}</option>
                            <option value="2" {{ 2 == $researchProject->status ? 'selected' : '' }}>{{ translateText('Proceed') }}</option>
                            <option value="3" {{ 3 == $researchProject->status ? 'selected' : '' }}>{{ translateText('Project closed') }}</option>
                        </select>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-12">
                    <table class="table">
                        <tr>
                            <th>{{ translateText('Project Manager') }}</th>
                        <tr>
                            <td>
                                <select id='head0' style='width: 200px;' name="head">
                                    @foreach($researchProject->user as $u)
                                    @if($u->pivot->role == 1)
                                    @foreach($users as $user)
                                    <option value="{{ $user->id }}" @if($u->id == $user->id) selected @endif>
                                        {{ $user->fname_th }} {{ $user->lname_th }}
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
                    <table class="table " id="dynamicAddRemove">
                        <tr>
                            <th width="522.98px">{{ translateText('Internal Co-Project Responsible Person') }}</th>
                            <th><button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm add"><i class="mdi mdi-plus"></i></button></th>
                        </tr>
                    </table>
                </div>
                <div class="form-group row">
                        <label for="exampleInputpaper_author" class="col-sm-3 col-form-label">{{ translateText('External Co-Project Responsible Person') }}</label>
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
                <button type="submit" class="btn btn-primary mt-5">{{ translateText('Submit') }}</button>
                <a class="btn btn-light mt-5" href="{{ route('researchProjects.index') }}"> Back</a>
            </form>
        </div>
    </div>
</div>
@stop
@section('javascript')
<script>
    $(document).ready(function() {

        $("#head0").select2()
        //$("#fund").select2()

        //$("#dep").select2()
        var researchProject = <?php echo $researchProject['user']; ?>;
        var i = 0;

        for (i = 0; i < researchProject.length; i++) {
            var obj = researchProject[i];

            if (obj.pivot.role === 2) {
                $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i +
                    '][userid]"  style="width: 200px;">@foreach($users as $user)<option value="{{ $user->id }}" >{{ $user->fname_th }} {{ $user->lname_th }}</option>@endforeach</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
                );
                document.getElementById("selUser" + i).value = obj.id;
                $("#selUser" + i).select2()

            }
            //document.getElementById("#dynamicAddRemove").value = "10";
        }


        $("#add-btn2").click(function() {

            ++i;
            $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i +
                '][userid]"  style="width: 200px;"><option value="">{{ translateText('Select User')}}</option>@foreach($users as $user)<option value="{{ $user->id }}">{{ $user->fname_th }} {{ $user->lname_th }}</option>@endforeach</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
            );
            $("#selUser" + i).select2()
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
                '" class="dynamic-added"><td><p>{{ translateText('Position or title') }} :</p><input type="text" name="title_name[]" value="'+ obj.title_name +'" placeholder="{{ translateText('Position or title') }}" style="width: 200px;" class="form-control name_list" /><br><p>{{ translateText('Name') }} :</p><input type="text" name="fname[]" value="'+ obj.fname +'" placeholder="{{ translateText('Name') }}" style="width: 300px;" class="form-control name_list" /><br><p>{{ translateText('Surname') }} :</p><input type="text" name="lname[]" value="'+ obj.lname +'" placeholder="{{ translateText('Surname') }} " style="width: 300px;" class="form-control name_list" /></td><td><button type="button" name="remove" id="' +
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
                '" class="dynamic-added"><td><p>{{ translateText('Position or title') }} :</p><input type="text" name="title_name[]" placeholder="{{ translateText('Position or title') }}" style="width: 200px;" class="form-control name_list" /><br><p>{{ translateText('Name') }} :</p><input type="text" name="fname[]" placeholder="{{ translateText('Name') }} " style="width: 300px;" class="form-control name_list" /><br><p>{{ translateText('Surname') }} :</p><input type="text" name="lname[]" placeholder="{{ translateText('Surname') }}" style="width: 300px;" class="form-control name_list" /></td><td><button type="button" name="remove" id="' +
                i + '" class="btn btn-danger btn-sm btn_remove"><i class="mdi mdi-minus"></i></button></td></tr>');
        });

        $(document).on('click', '.btn_remove', function() {
            var button_id = $(this).attr("id");
            $('#row' + button_id + '').remove();
        });

    });
</script>
@stop
