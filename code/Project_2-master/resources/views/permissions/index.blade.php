@extends('dashboards.users.layouts.user-dash-layout')
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (\Session::has('success'))
        <div class="alert alert-success">
            <p>{{ \Session::get('success') }}</p>
        </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('permission.permissions') }}
                @can('permission-create')
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('permissions.create') }}">{{ trans('permission.new_permission') }}</a>
                </span>
                @endcan
            </div>
            <div class="card-body">
                <table id="example1" class="table table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>#</th>
                            <th>{{ trans('permission.name') }}</th>
                            <th width="280px">{{ trans('permission.action') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($data as $key => $permission)
                        <tr>
                            <td>{{ $permission->id }}</td>
                            <td>{{ $permission->name }}</td>
                            <td>
                                <form action="{{ route('permissions.destroy',$permission->id) }}" method="POST">
                                    <li class="list-inline-item">
                                        <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ trans('permission.view') }}" href="{{ route('permissions.show',$permission->id) }}"><i class="mdi mdi-eye"></i></a>
                                    </li>

                                    @can('permission-edit')
                                    <li class="list-inline-item">
                                        <a class="btn btn-outline-success btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ trans('permission.edit') }}" href="{{ route('permissions.edit',$permission->id) }}"><i class="mdi mdi-pencil"></i></a>
                                    </li>
                                    @endcan
                                    @can('permission-delete')
                                    @csrf
                                    @method('DELETE')

                                    <li class="list-inline-item">
                                        <button class="btn btn-outline-danger btn-sm show_confirm" type="submit" data-toggle="tooltip" data-placement="top" title="{{ trans('permission.delete') }}"><i class="mdi mdi-delete"></i></button>
                                    </li>

                                    @endcan
                                </form>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            <div class="justify-content-center">

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert@2/dist/sweetalert.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="http://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js" defer></script>
<script src="https://cdn.datatables.net/1.12.0/js/dataTables.bootstrap4.min.js" defer></script>
<script src="https://cdn.datatables.net/fixedheader/3.2.3/js/dataTables.fixedHeader.min.js" defer></script>

<script type="text/javascript">
    $('.show_confirm').click(function(event) {
        var form = $(this).closest("form");
        var name = $(this).data("name");
        event.preventDefault();
        swal({
                title: "{{ trans('roles.Are you sure?') }}",
                text: "{{ trans('roles.If you delete this, it will be gone forever.') }}",
                icon: "warning",
                buttons: {
                    cancel: "{{ trans('roles.cancel') }}",
                    confirm: "{{ trans('roles.ok') }}"
                },
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    swal("{{ trans('roles.Delete Successfully') }}", {
                        icon: "success",
                        buttons: {
                            confirm: "{{ trans('roles.ok') }}"
                        },
                    }).then(function() {
                        location.reload();
                        form.submit();
                    });
                }
            });
    });
</script>

@endsection