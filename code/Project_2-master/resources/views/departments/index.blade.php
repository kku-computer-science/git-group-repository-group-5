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
            <div class="card-header">{{ trans('department.departments') }}
                @can('departments-create')
                <a class="btn btn-primary" href="{{ route('departments.create') }}">
                    {{ trans('department.new_department') }}
                </a>
                @endcan
            </div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>#</th>
                            <th>{{ trans('department.name') }}</th>
                            <th width="280px">{{ trans('department.action') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($data as $key => $department)
                        <tr>
                            <td>{{ $department->id }}</td>
                            <td>{{ trans($department->department_name_th) }}</td>
                            <td>
                                <form action="{{ route('departments.destroy', $department->id) }}" method="POST">
                                    <a class="btn btn-outline-primary btn-sm" type="button"
                                       data-toggle="tooltip" data-placement="top"
                                       title="{{ trans('department.view') }}"
                                       href="{{ route('departments.show', $department->id) }}">
                                       <i class="mdi mdi-eye"></i>
                                    </a>

                                    @can('departments-edit')
                                    <a class="btn btn-outline-primary btn-sm" type="button"
                                       data-toggle="tooltip" data-placement="top"
                                       title="{{ trans('department.edit') }}"
                                       href="{{ route('departments.edit', $department->id) }}">
                                       <i class="mdi mdi-pencil"></i>
                                    </a>
                                    @endcan

                                    @can('departments-delete')
                                    @csrf
                                    <button type="button" class="btn btn-outline-danger btn-sm show_confirm"
                                            data-toggle="tooltip" data-placement="top" title="{{ trans('department.delete') }}">
                                        <i class="mdi mdi-delete"></i>
                                    </button>
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
                title: `{{ trans('department.are_you_sure') }}`,
                text: "{{ trans('department.delete_forever') }}",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    swal("{{ trans('department.delete_success') }}", {
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
