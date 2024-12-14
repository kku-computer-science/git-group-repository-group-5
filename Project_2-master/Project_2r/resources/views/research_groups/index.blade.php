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
                <h2>Research Group</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-success" href="{{ route('researchGroups.create') }}"> Create New Research Group</a>
            </div>
        </div>
    </div>
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ $message }}</p>
    </div>
    @endif

    <table class="table table-bordered">
        <tr>
            <th>No</th>
            <th>Group_name_TH</th>
            <th>Group_name_EN</th>
            <th>Group_detail_TH</th>
            <th>Group_detail_EN</th>
            <th>Group_desc_TH</th>
            <th>Group_desc_EN</th>
            <th>Head</th>
            <th>Member</th>
            <th width="280px">Action</th>
        </tr>
        @foreach ($researchGroups as $researchGroup)
        <tr>
            <td>{{ ++$i }}</td>
            <td>{{ $researchGroup->Group_name_TH }}</td>
            <td>{{ $researchGroup->Group_name_EN }}</td>
            <td>{{ $researchGroup->Group_detail_TH }}</td>
            <td>{{ $researchGroup->Group_detail_EN }}</td>
            <td>{{ $researchGroup->Group_desc_TH }}</td>
            <td>{{ $researchGroup->Group_desc_EN }}</td>
            <td>
                @foreach($researchGroup->user as $user)
                @if ( $user->pivot->role == 1)
                    {{ $user->fname}}
                @endif
                        
                @endforeach
            </td>
            <td>
                @foreach($researchGroup->user as $user)
                @if ( $user->pivot->role == 2)
                    {{ $user->fname}}
                @endif

                @endforeach
            </td>
            <td>
                <form action="{{ route('researchGroups.destroy',$researchGroup->id) }}" method="POST">

                    <a class="btn btn-info" href="{{ route('researchGroups.show',$researchGroup->id) }}">Show</a>
                    
                    @if(Auth::user()->can('update',$researchGroup))
                    <a class="btn btn-primary" href="{{ route('researchGroups.edit',$researchGroup->id) }}">Edit</a>
                    @endif

                    @csrf
                    @method('DELETE')
                    
                    <button type="submit" class="btn btn-danger">Delete</button>
                    
                </form>
            </td>
        </tr>
        @endforeach
    </table>

    {!! $researchGroups->links()!!}

</div>
@stop