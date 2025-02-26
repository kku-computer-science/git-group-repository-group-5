@extends('dashboards.users.layouts.user-dash-layout')
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
@section('content')
<!-- <div class="row">
    <div class="col-lg-12" style="text-align: center">
        <div>
            <h2>ความเชี่ยวชาญ</h2>
        </div>
        <br />
    </div>
</div> -->
<!-- <div class="row">
    <div class="col-lg-12 margin-tb">
        <div class="pull-right">
            <a href="javascript:void(0)" class="btn btn-success mb-2" id="new-expertise" data-toggle="modal">Add
                Expertise</a>
        </div>
    </div>
</div> -->
<!-- <br />
@if ($message = Session::get('success'))
<div class="alert alert-success">
    <p id="msg">{{ $message }}</p>
</div>
@endif -->
<div class="container">
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ $message }}</p>
    </div>
    @endif
    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title" style="text-align: center;">{{ trans('expertise.ความเชี่ยวชาญของอาจารย์') }}</h4>
            <table id="example1" class="table table-striped">
                <thead>
                    <tr>
                        <th>{{ trans('expertise.ID') }}</th>
                        @if(Auth::user()->hasRole('admin'))
                        <th>{{ trans('expertise.Teacher Name') }}</th>
                        @endif
                        <th>{{ trans('expertise.Name') }}</th>

                        <th>{{ trans('expertise.Action') }}</th>

                    </tr>
                </thead>
                <tbody>
                    @foreach ($experts as $i => $expert)
                    <tr id="expert_id_{{ $expert->id }}">
                        <td>{{ $i+1 }}</td>
                        @if(Auth::user()->hasRole('admin'))
                        <td>{{ $expert->user->fname_en }} {{ $expert->user->lname_en }}</td>
                        @endif
                        <td>{{ $expert->expert_name }}</td>

                        <td>
                            <form action="{{ route('experts.destroy',$expert->id) }}" method="POST">
                                <!-- <a class="btn btn-info" id="show-expertise" data-toggle="modal" data-id="{{ $expert->id }}">Show</a> -->
                                <li class="list-inline-item">
                                    <!-- <a class="btn btn-success btn-sm rounded-0" href="javascript:void(0)" id="edit-expertise" type="button" data-toggle="modal" data-placement="top" data-id="{{ $expert->id }}" title="Edit"><i class="fa fa-edit"></i></a> -->
                                    <a class="btn btn-outline-success btn-sm" id="edit-expertise" type="button" data-toggle="modal" data-id="{{ $expert->id }}" data-placement="top" title="Edit" href="javascript:void(0)"><i class="mdi mdi-pencil"></i></a>

                                </li>

                                <!-- <a href="javascript:void(0)" class="btn btn-success" id="edit-expertise" data-toggle="modal" data-id="{{ $expert->id }}">Edit </a> -->
                                @csrf
                                <meta name="csrf-token" content="{{ csrf_token() }}">
                                <li class="list-inline-item">
                                    <button class="btn btn-outline-danger btn-sm show_confirm" id="delete-expertise" type="submit" data-id="{{ $expert->id }}" data-toggle="tooltip" data-placement="top" title="Delete"><i class="mdi mdi-delete"></i></button>

                                </li>
                                <!-- <a id="delete-expertise" data-id="{{ $expert->id }}" class="btn btn-danger delete-user">Delete</a> -->

                            </form>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Add and Edit expertise modal -->
<div class="modal fade" id="crud-modal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="expertiseCrudModal"></h4>
            </div>
            <div class="modal-body">
                <form name="expForm" action="{{ route('experts.store') }}" method="POST">
                    <input type="hidden" name="exp_id" id="exp_id">
                    @csrf
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12">
                            <div class="form-group">
                                <strong>{{ trans('expertise.Name:') }}</strong>
                                <input type="text" name="expert_name" id="expert_name" class="form-control" placeholder="{{ trans('expertise.Expert_name') }}" onchange="validate()">
                            </div>
                        </div>

                        <div class="col-xs-12 col-sm-12 col-md-12 text-center">
                            <button type="submit" id="btn-save" name="btnsave" class="btn btn-primary" disabled>{{ trans('expertise.Submit') }}</button>
                            <a href="{{ route('experts.index') }}" class="btn btn-danger">{{ trans('expertise.Cancel') }}</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="http://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js" defer></script>
<script src="https://cdn.datatables.net/1.12.0/js/dataTables.bootstrap4.min.js" defer></script>
<script src="https://cdn.datatables.net/fixedheader/3.2.3/js/dataTables.fixedHeader.min.js" defer></script>
<script src="https://cdn.datatables.net/rowgroup/1.2.0/js/dataTables.rowGroup.min.js" defer></script>
<script>
   
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

<script>
    $(document).ready(function() {
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        /* When click New expertise button */
        $('#new-expertise').click(function() {
            $('#btn-save').val("create-expertise");
            $('#expertise').trigger("reset");
            $('#expertiseCrudModal').html("{{ trans('expertise.Add New Expertise') }}");
            $('#crud-modal').modal('show');
        });

        /* Edit expertise */
        $('body').on('click', '#edit-expertise', function() {
            var expert_id = $(this).data('id');
            $.get('experts/' + expert_id + '/edit', function(data) {
                $('#expertiseCrudModal').html("{{ trans('expertise.Edit Expertise') }}");
                $('#btn-update').val("Update");
                $('#btn-save').prop('disabled', false);
                $('#crud-modal').modal('show');
                $('#exp_id').val(data.id);
                $('#expert_name').val(data.expert_name);
            })
        });

        /* Delete expertise */
        $('body').on('click', '#delete-expertise', function(e) {
            var expert_id = $(this).data("id");
            var token = $("meta[name='csrf-token']").attr("content");
            e.preventDefault();

            swal({
                title: "{{ trans('expertise.Are you sure?') }}",
                text: "{{ trans('expertise.You will not be able to recover this imaginary file!') }}",
                type: "warning",
                buttons: true,
                dangerMode: true,
            }).then((willDelete) => {
                if (willDelete) {
                    swal("{{ trans('expertise.Delete Successfully') }}", {
                        icon: "success",
                    }).then(function() {
                        $.ajax({
                            type: "DELETE",
                            url: "experts/" + expert_id,
                            data: {
                                "id": expert_id,
                                "_token": token,
                            },
                            success: function(data) {
                                $('#msg').html('{{ trans('expertise.program entry deleted successfully') }}');
                                $("#expert_id_" + expert_id).remove();
                            },
                            error: function(data) {
                                console.log('Error:', data);
                            }
                        });
                    });
                }
            });
        });
    });
</script>



<script>
    error = false

    function validate() {
        if (document.expForm.expert_name.value != '')
            document.expForm.btnsave.disabled = false
        else
            document.expForm.btnsave.disabled = true
    }
</script>
@stop