@extends('dashboards.users.layouts.user-dash-layout')

<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">

@section('content')

<div class="container">
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ translateText($message) }}</p>
    </div>
    @endif
    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('funds.ResearchFund') }}</h4>
            <a class="btn btn-primary btn-menu btn-icon-text btn-sm mb-3" href="{{ route('funds.create') }}"><i class="mdi mdi-plus btn-icon-prepend"></i> {{ translateText('ADD') }}</a>
            <div class="table-responsive">
                <table id="example1" class="table table-striped">
                    <thead>
                        <tr>
                            <th>{{ trans('funds.No.') }}</th>
                            <th>{{ trans('funds.FundName') }}</th>
                            <th>{{ trans('funds.FundType') }}</th>
                            <th>{{ trans('funds.FunddingLevel') }}</th>
                            <th>{{ trans('funds.Action') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($funds as $i=>$fund)
                        <tr>
                            <td>{{ translateText($i+1) }}</td>
                            <td>{{ Str::limit($fund->fund_name,80) }}</td>
                            <td>
                                {{ $fund->fund_type == 'ทุนภายใน' ? trans('funds.InternalCapital') : trans('funds.ExternalCapital') }}
                            </td>

                            <td>
                                @if($fund->fund_level == 'สูง')
                                    {{ trans('funds.High') }}
                                @elseif($fund->fund_level == 'ต่ำ')
                                    {{ trans('funds.Low') }}
                                @else
                                    {{ trans('funds.Unknown') }}
                                @endif
                            </td>

                            <td>
                                @csrf
                                <form action="{{ route('funds.destroy',$fund->id) }}" method="POST">
                                    <li class="list-inline-item">
                                        <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ translateText('view') }}" href="{{ route('funds.show',$fund->id) }}"><i class="mdi mdi-eye"></i></a>
                                    </li>
                                    @if(Auth::user()->can('update',$fund))
                                    <li class="list-inline-item">
                                        <a class="btn btn-outline-success btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ translateText('Edit') }}" href="{{ route('funds.edit',Crypt::encrypt($fund->id)) }}"><i class="mdi mdi-pencil"></i></a>
                                    </li>
                                    @endif
                                    @if(Auth::user()->can('delete',$fund))
                                    @csrf
                                    @method('DELETE')
                                    <li class="list-inline-item">
                                        <input name="_method" type="hidden" value="DELETE">
                                        <button class="btn btn-outline-danger btn-sm show_confirm" type="submit" data-toggle="tooltip" title="{{ translateText('Delete') }}"><i class="mdi mdi-delete"></i></button>
                                    </li>
                                    @endcan
                                </form>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="http://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js" defer></script>
<script src="https://cdn.datatables.net/1.12.0/js/dataTables.bootstrap4.min.js" defer></script>
<script src="https://cdn.datatables.net/fixedheader/3.2.3/js/dataTables.fixedHeader.min.js" defer></script>
<script>
    $(document).ready(function() {
        var table = $('#example1').DataTable({
            fixedHeader: true
        });
    });
</script>
<script type="text/javascript">
    $('.show_confirm').click(function(event) {
        var form = $(this).closest("form");
        var name = $(this).data("name");
        event.preventDefault();
        swal({
                title: `{{ trans('funds.AreUSure') }}`,
                text: "{{ trans('funds.DeleteThis') }}",
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
