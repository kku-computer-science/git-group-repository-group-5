@extends('dashboards.users.layouts.user-dash-layout')

<!-- Include DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.2.3/css/fixedHeader.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.12.0/css/dataTables.bootstrap4.min.css">

@section('title','Project')

@section('content')
<div class="container">
    @if ($message = Session::get('success'))
        <div class="alert alert-success">
            <p>{{ translateText($message) }}</p>
        </div>
    @endif

    <div class="card" style="padding: 16px;">
        <div class="card-body">
            <h4 class="card-title">{{ trans('message.ResearchProj') }}</h4>
            <a class="btn btn-primary btn-menu btn-icon-text btn-sm mb-3" href="{{ route('researchProjects.create') }}">
                <i class="mdi mdi-plus btn-icon-prepend"></i> {{ trans('research_g.add') }}
            </a>

            <table id="example1" class="table table-striped">
                <thead>
                    <tr>
                        <th>{{ trans('research_g.no') }}</th>
                        <th>{{ trans('research_g.year') }}</th>
                        <th>{{ trans('research_g.projectName') }}</th>
                        <th>{{ trans('research_g.research_group_head') }}</th>
                        <th>{{ trans('research_g.member') }}</th>
                        <th>{{ trans('research_g.action') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @if ($researchProjects->isEmpty())
                        <tr>
                            <td colspan="6" class="text-center">{{ trans('message.NoData') }}</td>
                        </tr>
                    @else
                        @foreach ($researchProjects as $i => $researchProject)
                            <tr>
                                <td>{{ $i + 1 }}</td>
                                <td>{{ $researchProject->project_year }}</td>
                                <td>{{ Str::limit($researchProject->project_name, 70) }}</td>
                                <td>
                                    @foreach($researchProject->user as $user)
                                        @if ($user->pivot->role == 1)
                                            @if (app()->getLocale() == 'th')
                                            {{ $user->fname_th }}
                                            @else
                                            {{ $user->fname_en }}
                                            @endif
                                        @endif
                                    @endforeach
                                </td>
                                <td>
                                    @foreach($researchProject->user as $user)
                                        @if ($user->pivot->role == 2)
                                            @if (app()->getLocale() == 'th')
                                            {{ $user->fname_th }}
                                            @else
                                            {{ $user->fname_en }}
                                            @endif
                                        @endif
                                    @endforeach
                                </td>
                                <td>
                                    <form action="{{ route('researchProjects.destroy', $researchProject->id) }}" method="POST">
                                        <li class="list-inline-item">
                                            <a class="btn btn-outline-primary btn-sm" type="button" data-toggle="tooltip"
                                               data-placement="top" title="{{ trans('research_g.view') }}"
                                               href="{{ route('researchProjects.show', $researchProject->id) }}">
                                                <i class="mdi mdi-eye"></i>
                                            </a>
                                        </li>

                                        @if (Auth::user()->can('update', $researchProject))
                                            <li class="list-inline-item">
                                                <a class="btn btn-outline-success btn-sm" type="button" data-toggle="tooltip"
                                                   data-placement="top" title="{{ trans('research_g.edit') }}"
                                                   href="{{ route('researchProjects.edit', $researchProject->id) }}">
                                                    <i class="mdi mdi-pencil"></i>
                                                </a>
                                            </li>
                                        @endif

                                        @if (Auth::user()->can('delete', $researchProject))
                                            @csrf
                                            @method('DELETE')
                                            <li class="list-inline-item">
                                                <button class="btn btn-outline-danger btn-sm show_confirm" type="submit"
                                                        data-toggle="tooltip" data-placement="top" title="{{ trans('research_g.delete') }}">
                                                    <i class="mdi mdi-delete"></i>
                                                </button>
                                            </li>
                                        @endif
                                    </form>
                                </td>
                            </tr>
                        @endforeach
                    @endif
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Include jQuery and DataTables Scripts -->
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
                title: `{{ trans('research_g.title') }}`,
                text: "{{ trans('research_g.text') }}",
                icon: "warning",
                buttons: {
                    cancel: "{{ trans('research_g.cancel') }}",
                    confirm: "{{ trans('research_g.ok') }}"
                },
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    swal("{{ trans('research_g.DeleteSuccessfully') }}", {
                        icon: "success",
                        buttons: {
                            confirm: "{{ trans('research_g.ok') }}"
                        },
                    }).then(function() {
                        location.reload();
                        form.submit();
                    });
                }
            });
    });
</script>
@stop
