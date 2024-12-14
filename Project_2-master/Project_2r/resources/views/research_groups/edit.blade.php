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
                <a class="btn btn-primary" href="{{ route('researchGroups.index') }}"> Back</a>
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
  
    <form action="{{ route('researchGroups.update',$researchGroup->id) }}" method="POST">
        @csrf
        @method('PUT')
   
         <div class="row">
         <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_name_TH:</strong>
                    <input type="text" name="Group_name_TH" value="{{ $researchGroup->Group_name_TH }}" class="form-control" placeholder="Group_name_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_name_EN:</strong>
                    <input type="text" name="Group_name_EN" value="{{ $researchGroup->Group_name_EN }}" class="form-control" placeholder="Group_name_EN">
                </div>
            </div>
            
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_detail_TH:</strong>
                    <input type="text" name="Group_detail_TH" value="{{ $researchGroup->Group_detail_TH }}" class="form-control" placeholder="Group_detail_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_detail_EN:</strong>
                    <input type="text" name="Group_detail_EN" value="{{ $researchGroup->Group_detail_EN }}" class="form-control" placeholder="Group_detail_EN">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_desc_TH:</strong>
                    <input type="text" name="Group_desc_TH" value="{{ $researchGroup->Group_desc_TH }}" class="form-control" placeholder="Group_desc_TH">
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <strong>Group_desc_EN:</strong>
                    <input type="text" name="Group_desc_EN" value="{{ $researchGroup->Group_desc_EN }}" class="form-control" placeholder="Group_desc_EN">
                </div>
</div>

            <div class="col-xs-12 col-sm-12 col-md-12">
            <table class="table table-bordered ">
                <tr>
                    <th>Head</th>
                <tr>
                    <!-- <td><input type="text" name="moreFields[0][Budget]" placeholder="Enter title" class="form-control" /></td> -->
                    <td><select id='head0' style='width: 200px;' name="head" >
                    
                   @foreach($researchGroup->user as $user)
                        <option value="{{ $user->id }}" @if($user->pivot->role == 1) selected @endif>
                            {{ $user->fname }} {{ $user->lname }}
                        </option>                   
                        
                    @endforeach
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
        
        $("#head0").select2()
        $("#fund").select2()

        var i = 0;

        $("#add-btn2").click(function() {
            
           
        });
        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

    });
    </script>
@stop