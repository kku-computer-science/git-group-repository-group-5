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
                <h2>Research Fund</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-success" href="{{ route('funds.create') }}"> Create New Fund</a>
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
            <th>fund_name</th>
            <th>fund_year</th>
            <th>fund_details</th>
            <th>fund_type</th>
            <th>fund_level</th>
            

            <th width="280px">Action</th>
        </tr>
        @foreach ($funds as $fund)
        <tr>
            <td>{{ ++$i }}</td>
            <td>{{ $fund->fund_name }}</td>
            <td>{{ $fund->fund_year }}</td>
            <td>{{ $fund->fund_details }}</td>
            <td>{{ $fund->fund_type }}</td>
            <td>{{ $fund->fund_level }}</td>
            
            <td>
                <form action="{{ route('funds.destroy',$fund->id) }}" method="POST">
   
                    <a class="btn btn-info" href="{{ route('funds.show',$fund->id) }}">Show</a>
    
                    <a class="btn btn-primary" href="{{ route('funds.edit',$fund->id) }}">Edit</a>
   
                    @csrf
                    @method('DELETE')
      
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </td>
        </tr>
        @endforeach
    </table>
  
    {!! $funds->links() !!}
</div>      
@endsection