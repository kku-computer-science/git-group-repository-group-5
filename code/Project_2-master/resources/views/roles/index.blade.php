@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (\Session::has('success'))
        <div class="alert alert-success">
            <p>{{ \Session::get('success') }}</p>
        </div>
        @endif
        <div class="card" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{ trans('roles.Roles') }}</h4>
                @can('role-create')
                <a class="btn btn-primary btn-menu btn-icon-text btn-sm mb-3" href="{{ route('roles.create') }}"><i class="mdi mdi-plus btn-icon-prepend"></i>{{ trans('roles.Add') }}</a>
                @endcan

                <table class="table table-striped">
                    <thead class="thead-dark">
                        <tr>
                            <th>#</th>
                            <th>{{ trans('roles.Name') }}</th>
                            <th width="280px">{{ trans('roles.Action') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $i = 1; ?>
                        @foreach ($data as $key => $role)
                        <tr>
                            <td>{{ $i++ }}</td>
                            <td>{{ $role->name }}</td>
                            <td>
                                <form action="{{ route('roles.destroy',$role->id) }}" method="POST">
                                    <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ trans('roles.view') }}" href="{{ route('roles.show',$role->id) }}"><i class="mdi mdi-eye"></i></a>
                                    @can('role-edit')
                                    <a class="btn btn-outline-success btn-sm " type="button" data-toggle="tooltip" data-placement="top" title="{{ trans('roles.Edit') }}" href="{{ route('roles.edit',$role->id) }}"><i class="mdi mdi-pencil"></i></a>
                                    @endcan

                                    @can('role-delete')
                                    @csrf
                                    @method('DELETE')
                                    <li class="list-inline-item">
                                        <input name="_method" type="hidden" value="DELETE">
                                        <button class="btn btn-outline-danger btn-sm show_confirm" type="submit" data-toggle="tooltip" title="{{ trans('roles.Delete') }}"><i class="mdi mdi-delete"></i></button>
                                    </li>
                                    @endcan
                                </form>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
                {{ $data->render() }}
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert@2/dist/sweetalert.min.js"></script>

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