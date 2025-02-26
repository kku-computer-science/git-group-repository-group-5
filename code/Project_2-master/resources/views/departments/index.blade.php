<!-- @php
   if(Auth::user()->hasRole('admin')) {
      $layoutDirectory = 'dashboards.admins.layouts.admin-dash-layout';
   } else {
      $layoutDirectory = 'dashboards.users.layouts.user-dash-layout';
   }
@endphp -->

@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (\Session::has('success'))
        <div class="alert alert-success">
            <p>{{ \Session::get('success') }}</p>
        </div>
        @endif
        <div class="card">
            <div class="card-header">{{ translateText('Departments') }}
                @can('departments-create')
                <a class="btn btn-primary" href="{{ route('departments.create') }}">{{ translateText('New department') }}</a>
                @endcan
            </div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>#</th>
                            <th>{{ translateText('Name') }}</th>
                            <th width="280px">{{ translateText('Action') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($data as $key => $department)
                        <tr>
                            <td>{{ $department->id }}</td>
                            <td>{{{ translateText($department->department_name_th) }}}</td>
                            <td>
                                <form action="{{ route('departments.destroy',$department->id) }}" method="POST">
                                    <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ translateText('view') }}" href="{{ route('departments.show',$department->id) }}"><i class="mdi mdi-eye"></i></a>

                                    @can('departments-edit')
                                    <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ translateText('Edit') }}" href="{{ route('departments.edit',$department->id) }}"><i class="mdi mdi-pencil"></i></a>
                                    @endcan

                                    @can('departments-delete')
                                    @csrf
                                    @method('DELETE')
                                    <li class="list-inline-item">
                                        <button class="btn btn-outline-danger btn-sm show_confirm" type="submit" data-toggle="tooltip" data-placement="top" title="{{ translateText('Delete') }}"><i class="mdi mdi-delete"></i></button>
                                    </li>
                                    @endcan
                                </form>
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

<script type="text/javascript">
    $('.show_confirm').click(function(event) {
        var form = $(this).closest("form");
        var name = $(this).data("name");
        event.preventDefault();
        swal({
                title: `{{ translateText('Are you sure?') }}`,
                text: "{{ translateText('If you delete this, it will be gone forever.') }}",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    swal("{{ translateText('Delete Successfully') }}", {
                        icon: "success",
                    }).then(function() {
                        location.reload();
                        form.submit();
                    });
                }
            });
    });
</script>

@endsection