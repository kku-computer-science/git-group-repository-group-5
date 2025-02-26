@extends('dashboards.users.layouts.user-dash-layout')
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
@section('content')
<style>
    .table-responsive {
        margin: 30px 0;
    }

    .table-wrapper {
        min-width: 1000px;
        background: #fff;
        padding: 20px 25px;
        border-radius: 3px;
        box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
    }


    .search-box {
        position: relative;
        float: right;
    }

    .search-box .input-group {
        min-width: 300px;
        position: absolute;
        right: 0;
    }

    .search-box .input-group-addon,
    .search-box input {
        border-color: #ddd;
        border-radius: 0;
    }

    .search-box input {
        height: 34px;
        padding-right: 35px;
        background: #0e393e;
        color: #ffffff;
        border: none;
        border-radius: 15px !important;
    }

    .search-box input:focus {
        background: #0e393e;
        color: #ffffff;
    }

    .search-box input::placeholder {
        font-style: italic;
    }

    .search-box .input-group-addon {
        min-width: 35px;
        border: none;
        background: transparent;
        position: absolute;
        right: 0;
        z-index: 9;
        padding: 6px 0;
    }

    .search-box i {
        color: #a0a5b1;
        font-size: 19px;
        position: relative;
        top: 2px;
    }
</style>
<script>
    $(document).ready(function() {
        // Activate tooltips
        $('[data-toggle="tooltip"]').tooltip();

        // Filter table rows based on searched term
        $("#search").on("keyup", function() {
            var term = $(this).val().toLowerCase();
            $("table tbody tr").each(function() {
                $row = $(this);
                var name = $row.find("td:nth-child(2)").text().toLowerCase();
                console.log(name);
                if (name.search(term) < 0) {
                    $row.hide();
                } else {
                    $row.show();
                }
            });
        });
    });
</script>
<div class="container">
    @if (\Session::has('success'))
    <div class="alert alert-success">
        <p>{{ \Session::get('success') }}</p>
    </div>
    @endif
    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('users.users') }}</h4>
            <a class="btn btn-primary btn-icon-text btn-sm" href="{{ route('users.create')}}"><i class="ti-plus btn-icon-prepend icon-sm"></i>{{ trans('users.new_user') }}</a>
            <a class="btn btn-primary btn-icon-text btn-sm" href="{{ route('importfiles')}}"><i class="ti-download btn-icon-prepend icon-sm"></i>{{ trans('users.import_new_user') }}</a>

            <div class="table-responsive">
                <table id="example1" class="table table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{ trans('users.name') }}</th>
                            <th>{{ trans('users.department') }}</th>
                            <th>{{ trans('users.email') }}</th>
                            <th>{{ trans('users.roles') }}</th>
                            <th width="280px">{{ trans('users.action') }}</th>
                        </tr>
                    </thead>

                    <tbody>
                        @foreach ($data as $key => $user)
                        <tr>
                            <td>{{ $key++ }}</td>
                            <td>{{ $user->fname_en }} {{ $user->lname_en }} </td>
                            <td>{{ Str::limit($user->program->program_name_en,20) }}</td>
                            <td>{{ $user->email }}</td>
                            <td>
                                @if(!empty($user->getRoleNames()))
                                @foreach($user->getRoleNames() as $val)
                                <label class="badge badge-dark">{{ $val }}</label>
                                @endforeach
                                @endif
                            </td>
                            <td>
                                <form action="{{ route('users.destroy',$user->id) }}" method="POST">
                                <li class="list-inline-item">
                                    <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ trans('users.view') }}" href="{{ route('users.show',$user->id) }}"><i class="mdi mdi-eye"></i></a>
                                </li>
                                    @can('user-edit')
                                    <li class="list-inline-item">
                                    <a class="btn btn-outline-success btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="{{ trans('users.edit') }}" href="{{ route('users.edit',$user->id) }}"><i class="mdi mdi-pencil"></i></a>
                                    </li>
                                    @endcan
                                    @can('user-delete')
                                    @csrf
                                    @method('DELETE')

                                    <li class="list-inline-item">
                                        <button class="btn btn-outline-danger btn-sm show_confirm" type="submit" data-toggle="tooltip" data-placement="top" title="{{ trans('users.delete') }}"><i class="mdi mdi-delete"></i></button>
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
    var lang = '{{ app()->getLocale() }}'; // Get current language

    var languageSettings = {
        "th": { // Thai Language settings
            "sProcessing": "กำลังประมวลผล...",
            "sLengthMenu": "แสดง _MENU_ รายการ",
            "sZeroRecords": "ไม่พบข้อมูล",
            "sInfo": "แสดง _START_ ถึง _END_ จาก _TOTAL_ รายการ",
            "sInfoEmpty": "แสดง 0 ถึง 0 จาก 0 รายการ",
            "sInfoFiltered": "(กรองจาก _MAX_ รายการทั้งหมด)",
            "sSearch": "ค้นหา:",
            "oPaginate": {
                "sFirst": "แรก",
                "sPrevious": "ก่อนหน้า",
                "sNext": "ถัดไป",
                "sLast": "สุดท้าย"
            }
        },
        "en": { // English Language settings
            "sProcessing": "Processing...",
            "sLengthMenu": "Show _MENU_ entries",
            "sZeroRecords": "No matching records found",
            "sInfo": "Showing _START_ to _END_ of _TOTAL_ entries",
            "sInfoEmpty": "Showing 0 to 0 of 0 entries",
            "sInfoFiltered": "(filtered from _MAX_ total entries)",
            "sSearch": "Search:",
            "oPaginate": {
                "sFirst": "First",
                "sPrevious": "Previous",
                "sNext": "Next",
                "sLast": "Last"
            }
        },
        "zn": { // Chinese (Simplified) Language settings
            "sProcessing": "处理中...",
            "sLengthMenu": "显示 _MENU_ 条目",
            "sZeroRecords": "没有匹配的记录",
            "sInfo": "显示 _START_ 到 _END_ ，共 _TOTAL_ 条",
            "sInfoEmpty": "显示 0 到 0 ，共 0 条",
            "sInfoFiltered": "(从 _MAX_ 条记录中筛选)",
            "sSearch": "搜索：",
            "oPaginate": {
                "sFirst": "首页",
                "sPrevious": "上一页",
                "sNext": "下一页",
                "sLast": "最后一页"
            }
        }
    };

    var table1 = $('#example1').DataTable({
        responsive: true,
        language: languageSettings[lang] // Set language dynamically
    });
});

</script>
<script type="text/javascript">
    $('.show_confirm').click(function(event) {
        var form = $(this).closest("form");
        var name = $(this).data("name");
        event.preventDefault();
        swal({
                title: "{{ trans('roles.Are you sure?') }}",
                text: "{{ trans('roles.If you delete this, it will be gone forever.') }}",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    swal("{{ trans('roles.Delete Successfully') }}", {
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