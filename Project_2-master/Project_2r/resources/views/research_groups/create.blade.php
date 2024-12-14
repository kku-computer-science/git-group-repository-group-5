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
                <h2>Add New Research Group</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-primary" href="{{ route('researchGroups.index')}}"> Back</a>
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

    <form action="{{ route('researchGroups.store') }}" method="POST">
        @csrf

        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_name_TH:</strong>
                    <input type="text" name="Group_name_TH" class="form-control" placeholder="Group_name_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_name_EN:</strong>
                    <input type="text" name="Group_name_EN" class="form-control" placeholder="Group_name_EN">
                </div>
            </div>
            
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_detail_TH:</strong>
                    <input type="text" name="Group_detail_TH" class="form-control" placeholder="Group_detail_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_detail_EN:</strong>
                    <input type="text" name="Group_detail_EN" class="form-control" placeholder="Group_detail_EN">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_desc_TH:</strong>
                    <input type="text" name="Group_desc_TH" class="form-control" placeholder="Group_desc_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_desc_EN:</strong>
                    <input type="text" name="Group_desc_EN" class="form-control" placeholder="Group_desc_EN">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
            <table class="table table-bordered ">
                <tr>
                    <th>Head</th>
                <tr>
                   
                    <td><select id='head0' style='width: 200px;' name="head" >
                            <option value=''>Select User</option>@foreach($users as $user)<option value="{{ $user->id }}">{{ $user->fname }} {{ $user->lname }}</option>@endforeach
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
                <tr>
                   
                    <td><select id='selUser0' style='width: 200px;' name="moreFields[0][userid]" >
                            <option value=''>Select User</option>@foreach($users as $user)<option value="{{ $user->id }}">{{ $user->fname }} {{ $user->lname }}</option>@endforeach
                    </select></td>

                </tr>
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
    $(document).ready(function(){
        $("#selUser0").select2()
        $("#head0").select2()
        

        var i = 0;

        $("#add-btn2").click(function() {
            
            ++i;
            $("#dynamicAddRemove").append('<tr><td><select id="selUser'+i+'" name="moreFields[' + i + '][userid]"  style="width: 200px;"><option value="">Select User</option>@foreach($users as $user)<option value="{{ $user->id }}">{{ $user->fname }} {{ $user->lname }}</option>@endforeach</select></td><td><button type="button" class="btn btn-danger remove-tr"><i class="fas fa-minus"></i></button></td></tr>');
            $("#selUser"+i).select2()
        });
        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

    });

    
</script>
@stop