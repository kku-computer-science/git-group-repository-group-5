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
    <div class="justify-content-center">
        @if (\Session::has('success'))
            <div class="alert alert-success">
                <p>{{ \Session::get('success') }}</p>
            </div>
        @endif
        <div class="card">
            <div class="card-header">departments
                @can('departments-create')
                    <span class="float-right">
                        <a class="btn btn-primary" href="{{ route('departments.create') }}">New department</a>
                    </span>
                @endcan
            </div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th width="280px">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($data as $key => $department)
                            <tr>
                                <td>{{ $department->id }}</td>
                                <td>{{ $department->department_name_TH }}</td>
                                <td>
                                    <a class="btn btn-success" href="{{ route('departments.show',$department->id) }}">Show</a>
                                    @can('departments-edit')
                                        <a class="btn btn-primary" href="{{ route('departments.edit',$department->id) }}">Edit</a>
                                    @endcan
                                    @can('departments-delete')
                                        {!! Form::open(['method' => 'DELETE','route' => ['departments.destroy', $department->id],'style'=>'display:inline']) !!}
                                        {!! Form::submit('Delete', ['class' => 'btn btn-danger']) !!}
                                        {!! Form::close() !!}
                                    @endcan
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
                {{ $data->appends($_GET)->links() }}
            </div>
        </div>
    </div>
</div>
@endsection