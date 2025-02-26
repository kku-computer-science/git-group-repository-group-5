@extends('dashboards.users.layouts.user-dash-layout')
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<style type="text/css">
    .dropdown-toggle {
        height: 40px;
        width: 400px !important;
    }

    body label:not(.input-group-text) {
        margin-top: 10px;
    }

    body .my-select {
        background-color: #EFEFEF;
        color: #212529;
        border: 0 none;
        border-radius: 10px;
        padding: 6px 20px;
        width: 100%;
    }
</style>
@section('content')
<div class="container">
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ trans('programs.success') }}</p>
    </div>
    @endif
    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title" style="text-align: center;">{{ trans('programs.programs') }}</h4>
            <a class="btn btn-primary btn-menu btn-icon-text btn-sm mb-3" href="javascript:void(0)" id="new-program" data-toggle="modal">
                <i class="mdi mdi-plus btn-icon-prepend"></i> {{ trans('programs.ADD') }}
            </a>
            <table id="example1" class="table table-striped">
                <thead>
                    <tr>
                        <th>{{ trans('programs.id') }}</th>
                        <th>{{ trans('programs.Name (ไทย)') }}</th>
                        <th>{{ trans('programs.Degree') }}</th>
                        <th>{{ trans('programs.Action') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($programs as $i => $program)
                    <tr id="program_id_{{ $program->id }}">
                        <td>{{ $i+1 }}</td>
                        <td>{{($program->program_name_th) }}</td>
                        <!-- <td>{{ translateText($program->program_name_en) }}</td> -->
                        <td>{{ ($program->degree->degree_name_en) }}</td>
                        <td>
                            <form action="{{ route('programs.destroy',$program->id) }}" method="POST">
                                <li class="list-inline-item">
                                    <a class="btn btn-outline-success btn-sm" id="edit-program" type="button" data-toggle="modal" data-id="{{ $program->id }}" data-placement="top" title="{{ trans('programs.Edit') }}" href="javascript:void(0)">
                                        <i class="mdi mdi-pencil"></i>
                                    </a>
                                </li>
                                <meta name="csrf-token" content="{{ csrf_token() }}">
                                <li class="list-inline-item">
                                    <button class="btn btn-outline-danger btn-sm" id="delete-program" type="submit" data-id="{{ $program->id }}" data-toggle="tooltip" data-placement="top" title="{{ trans('programs.Delete') }}">
                                        <i class="mdi mdi-delete"></i>
                                    </button>
                                </li>
                            </form>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>




<!-- Add and Edit program modal -->
<div class="modal fade" id="crud-modal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="programCrudModal"></h4>
            </div>
            <div class="modal-body">
                <form name="proForm" action="{{ route('programs.store') }}" method="POST">
                    <input type="hidden" name="pro_id" id="pro_id">
                    @csrf
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12">
                            <div class="form-group">
                                <strong>{{ trans('programs.degree_level') }}</strong>
                                <div class="col-sm-8">
                                    <select id="degree" class="custom-select my-select" name="degree">
                                        @foreach($degree as $d)
                                        <option value="{{$d->id}}">{{ ( $d->degree_name_th) }}</option>
                                        @endforeach
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <strong>{{ trans('programs.department') }}</strong>
                                <div class="col-sm-8">
                                    <select id="department" class="custom-select my-select" name="department">
                                        @foreach($department as $d)
                                        <option value="{{$d->id}}">{{  ($d->department_name_th) }}</option>
                                        @endforeach
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <strong>{{ trans('programs.Name_TH') }}</strong>
                                <input type="text" name="program_name_th" id="program_name_th" class="form-control" placeholder="{{ trans('programs.program_name_th_placeholder') }}" onchange="validate()">
                            </div>
                            <div class="form-group">
                                <strong>{{ trans('programs.Name_EN') }}</strong>
                                <input type="text" name="program_name_en" id="program_name_en" class="form-control" placeholder="{{ trans('programs.program_name_en_placeholder') }}" onchange="validate()">
                            </div>
                        </div>

                        <div class="col-xs-12 col-sm-12 col-md-12 text-center">
                            <button type="submit" id="btn-save" name="btnsave" class="btn btn-primary" disabled>
                                {{ trans('programs.Submit') }}
                            </button>
                            <a href="{{ route('programs.index') }}" class="btn btn-danger">
                                {{ trans('programs.Cancel') }}
                            </a>
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
<script>
    $(document).ready(function() {

        /* When click New program button */
        $('#new-program').click(function() {
            $('#btn-save').val("create-program");
            $('#program').trigger("reset");
            $('#programCrudModal').html("{{ trans('programs.Add New program') }}");
            $('#crud-modal').modal('show');
        });

        /* Edit program */
        $('body').on('click', '#edit-program', function() {
            var program_id = $(this).data('id');
            $.get('programs/' + program_id + '/edit', function(data) {
                $('#programCrudModal').html("{{ trans('programs.Edit program') }}");
                $('#btn-update').val("Update");
                $('#btn-save').prop('disabled', false);
                $('#crud-modal').modal('show');
                $('#pro_id').val(data.id);
                $('#program_name_th').val(data.program_name_th);
                $('#program_name_en').val(data.program_name_en);
                //$('#degree').val(data.program_name_en);
                $('#degree').val(data.degree_id);
            })
        });

        /* Delete program */
        $('body').on('click', '.delete-program', function(e) {
    e.preventDefault();
    var program_id = $(this).data("id");
    var token = $("meta[name='csrf-token']").attr("content");

    Swal.fire({
        title: "{{ trans('research_g.Are you sure?') }}",
        text: "{{ trans('research_g.You will not be able to recover this imaginary file!') }}",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "{{ trans('research_g.Yes, delete it!') }}",
        cancelButtonText: "{{ trans('research_g.Cancel') }}"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type: "DELETE",
                url: "/programs/" + program_id,
                data: {
                    "_token": token
                },
                success: function(response) {
                    Swal.fire("{{ trans('research_g.Delete Successfully') }}", "", "success").then(() => {
                        $("#program_id_" + program_id).remove();
                    });
                },
                error: function(xhr) {
                    console.error(xhr.responseText);
                    Swal.fire("{{ trans('research_g.Error occurred') }}", "", "error");
                }
            });
        }
    });
});

</script>


<script>
    error = false

    function validate() {
        if (document.proForm.program_name_th.value != '' && document.proForm.program_name_en.value != '')
            document.proForm.btnsave.disabled = false
        else
            document.proForm.btnsave.disabled = true
    }
</script>
@stop