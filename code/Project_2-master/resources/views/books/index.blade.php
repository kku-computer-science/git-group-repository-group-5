@extends('dashboards.users.layouts.user-dash-layout')
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
@section('title','Dashboard')

@section('content')

<div class="container">
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ $message }}</p>
    </div>
    @endif
    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ translateText('Book') }}
                <Book< /h4>
                    <a class="btn btn-primary btn-menu btn-icon-text btn-sm mb-3" href="{{ route('books.create') }}"><i class="mdi mdi-plus btn-icon-prepend"></i> {{ translateText('ADD ') }}</a>
                    <!-- <div class="table-responsive"> -->
                    <table id="example1" class="table table-striped">
                        <thead>
                            <tr>
                                <th>{{ translateText('No. ') }}</th>
                                <th>{{ translateText('name ') }}</th>
                                <th>{{ translateText('Year ') }}</th>
                                <th>{{ translateText('Publication source ') }}</th>
                                <th>{{ translateText('page ') }}</th>
                                <th width="280px">{{ translateText('Action ') }}</th>
                            </tr>
                            <thead>
                            <tbody>
                                @foreach ($books as $i=>$paper)
                                <tr>
                                    <td>{{ $i+1 }}</td>
                                    <td>{{ Str::limit($paper->ac_name,50) }}</td>
                                    <td>{{ date('Y', strtotime($paper->ac_year))+543 }}</td>
                                    <td>{{ translateText(Str::limit($paper->ac_sourcetitle, 50), 'th') }}</td>

                                    <td>{{ $paper->ac_page}}</td>
                                    <td>
                                        <form action="{{ route('books.destroy',$paper->id) }}" method="POST">

                                            <!-- <a class="btn btn-info" href="{{ route('books.show',$paper->id) }}">Show</a> -->
                                            <li class="list-inline-item">
                                                <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="view" href="{{ route('books.show',$paper->id) }}"><i class="mdi mdi-eye"></i></a>
                                            </li>
                                            <!-- <a class="btn btn-primary" href="{{ route('books.edit',$paper->id) }}">Edit</a> -->
                                            @if(Auth::user()->can('update',$paper))
                                            <li class="list-inline-item">
                                                <a class="btn btn-outline-success btn-sm" type="button" data-toggle="tooltip" data-placement="top" title="Edit" href="{{ route('books.edit',$paper->id) }}"><i class="mdi mdi-pencil"></i></a>
                                            </li>
                                            @endif

                                            @if(Auth::user()->can('delete',$paper))
                                            @csrf
                                            @method('DELETE')
                                            <li class="list-inline-item">
                                                <button class="btn btn-outline-danger btn-sm show_confirm" type="submit" data-toggle="tooltip" data-placement="top" title="Delete"><i class="mdi mdi-delete"></i></button>
                                            </li>
                                            @endif
                                            <!-- <button type="submit" class="btn btn-danger">Delete</button> -->
                                        </form>
                                    </td>
                                </tr>
                                @endforeach
                        <tbody>
                    </table>
                    <!-- </div> -->
                    <br>

        </div>
    </div>


</div>
<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="http://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js" defer></script>
<script src="https://cdn.datatables.net/1.12.0/js/dataTables.bootstrap4.min.js" defer></script>
<script src="https://cdn.datatables.net/fixedheader/3.2.3/js/dataTables.fixedHeader.min.js" defer></script>
<script>
    $(document).ready(function() {
        // ดึง locale จาก Blade
        let locale = "{{ app()->getLocale() }}";

        let languageSettings = {};

        if (locale === 'en') {
            languageSettings = {
                lengthMenu: "Show _MENU_ entries",
                zeroRecords: "No matching records found",
                info: "Showing _START_ to _END_ of _TOTAL_ entries",
                infoEmpty: "No records available",
                infoFiltered: "(filtered from _MAX_ total records)",
                search: "Search:",
                paginate: {
                    first: "First",
                    last: "Last",
                    next: "Next",
                    previous: "Previous"
                }
            };
        } else if (locale === 'zh') {
            languageSettings = {
                lengthMenu: "显示 _MENU_ 条目",
                zeroRecords: "未找到匹配的记录",
                info: "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
                infoEmpty: "没有可用记录",
                infoFiltered: "(从 _MAX_ 条记录中过滤)",
                search: "搜索:",
                paginate: {
                    first: "首页",
                    last: "末页",
                    next: "下页",
                    previous: "上页"
                }
            };
        } else {
            // สมมติว่าถ้าเป็น 'th' หรือภาษาอื่น ใช้ภาษาไทย
            languageSettings = {
                lengthMenu: "แสดง _MENU_ รายการ",
                zeroRecords: "ไม่พบข้อมูลที่ตรงกัน",
                info: "แสดง _START_ ถึง _END_ จากทั้งหมด _TOTAL_ รายการ",
                infoEmpty: "ไม่มีข้อมูล",
                infoFiltered: "(กรองจากทั้งหมด _MAX_ รายการ)",
                search: "ค้นหา:",
                paginate: {
                    first: "หน้าแรก",
                    last: "หน้าสุดท้าย",
                    next: "ถัดไป",
                    previous: "ก่อนหน้า"
                }
            };
        }

        var table1 = $('#example1').DataTable({
            responsive: true,
            language: languageSettings
        });
    });
</script>
<script type="text/javascript">
    $('.show_confirm').click(function(event) {
        var form = $(this).closest("form");
        var name = $(this).data("name");
        event.preventDefault();
        swal({
                title: `Are you sure?`,
                text: "If you delete this, it will be gone forever.",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    swal("Delete Successfully", {
                        icon: "success",
                    }).then(function() {
                        location.reload();
                        form.submit();
                    });
                }
            });
    });
</script>
@stop
