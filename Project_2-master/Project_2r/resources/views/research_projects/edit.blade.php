@php
   if(Auth::user()->hasRole('admin')) {
      $layoutDirectory = 'dashboards.admins.layouts.admin-dash-layout';
   } else {
      $layoutDirectory = 'dashboards.users.layouts.user-dash-layout';
   }
@endphp

@extends($layoutDirectory)
@section('content')
<div class="container">
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-left">
                <h2>Edit Product</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-primary" href="{{ route('researchProjects.index') }}"> Back</a>
            </div>
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

    <form action="{{ route('researchProjects.update',$researchProject->id) }}" method="POST">
        @csrf
        @method('PUT')

        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Project_name_TH:</strong>
                    <input type="text" name="Project_name_TH" value="{{ $researchProject->Project_name_TH }}" class="form-control" placeholder="Project_name_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Project_name_EN:</strong>
                    <input type="text" name="Project_name_EN" value="{{ $researchProject->Project_name_EN }}" class="form-control" placeholder="Project_name_EN">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Project_start:</strong>
                    <input type="date" id="Project_start" name="Project_start" value="{{ $researchProject->Project_start }}" class="form-control" placeholder="Project_start">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Project_end:</strong>
                    <input type="date" id="Project_end" name="Project_end" value="{{ $researchProject->Project_end }}" class="form-control" placeholder="Project_end">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Funder:</strong>
                    <input type="text" name="Funder" value="{{ $researchProject->Funder }}" class="form-control" placeholder="Funder">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Budget:</strong>
                    <input type="text" name="Budget" value="{{ $researchProject->Budget }}" class="form-control" placeholder="Budget">
                </div>
            </div>

            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Note:</strong>
                    <textarea class="form-control" style="height:150px" name="Note" placeholder="Note">{{ $researchProject->Note }}</textarea>
                </div>
            </div>

            <div class="col-xs-12 col-sm-12 col-md-12">
                <table class="table table-bordered ">
                    <tr>
                        <th>Head</th>
                    <tr>
                        <td><select id='head0' style='width: 200px;' name="head">
                                @foreach($researchProject->user as $u)
                                @if($u->pivot->role == 1)
                                @foreach($users as $user)
                                <option value="{{ $user->id }}" @if($u->id == $user->id) selected @endif>
                                    {{ $user->fname }} {{ $user->lname }}
                                </option>
                                @endforeach
                                @endif
                                @endforeach
                            </select></td>

                    </tr>
                </table>
            </div>


            <div class="col-xs-12 col-sm-12 col-md-12">
                <table class="table table-bordered " id="dynamicAddRemove">
                    <tr>
                        <th>Member</th>
                        <th><button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm add"><i class="fas fa-plus"></i></button></th>
                    </tr>
                    @foreach($researchProject->user as $u)
                    <tr>
                                @if($u->pivot->role == 2)
                                    <td><select id='selUser0' style='width: 200px;' name="moreFields[0][userid]">
                                    @foreach($users as $user)
                                    <option value="{{ $user->id }}" @if($u->id == $user->id) selected @endif>
                                        {{ $user->fname }} {{ $user->lname }}
                                    </option>
                                    @endforeach
                               
                            </select></td>
                            @endif
                    </tr>
                    @endforeach
                </table>
            </div>


            <div class="col-xs-12 col-sm-12 col-md-12 text-center">
                <button type="submit" class="btn btn-primary">Submit</button>
            </div>
        </div>

    </form>
</div>
@stop
@section('javascript')
<script>
    $(document).ready(function() {

        $("#head0").select2()
        $("#fund").select2()
        //$("#selUser0").select2()
        var data = {!!$researchProject!!};
        
        var i = 0;
        $("#selUser" + i).select2()
        $("#add-btn2").click(function() {

            ++i;
            $("#dynamicAddRemove").append('<tr><td><select id="selUser' + i + '" name="moreFields[' + i + '][userid]"  style="width: 200px;"><option value="">Select User</option>@foreach($users as $user)<option value="{{ $user->id }}">{{ $user->fname }} {{ $user->lname }}</option>@endforeach</select></td><td><button type="button" class="btn btn-danger remove-tr"><i class="fas fa-minus"></i></button></td></tr>');
            $("#selUser" + i).select2()
        });
        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

    });
</script>
@stop