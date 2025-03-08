@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="row">
<div class="col-lg-12" style="text-align: center">
    <div>
        <h2>{{ trans('source_data.source_data') }}</h2>
    </div>
    <br />
</div>
</div>
<div class="row">
    <div class="col-lg-12 margin-tb">
        <div class="pull-right">
            <a href="javascript:void(0)" class="btn btn-success mb-2" id="new-source-data" data-toggle="modal">{{ trans('source_data.add_source_data') }}</a>
        </div>
    </div>
</div>
<br />
@if ($message = Session::get('success'))
<div class="alert alert-success">
    <p id="msg">{{ $message }}</p>
</div>
@endif
<table class="table table-bordered">
    <tr>
        <th>{{ trans('source_data.id') }}</th>
        <th>{{ trans('source_data.name') }}</th>
        <th width="280px">{{ trans('source_data.action') }}</th>
    </tr>

    @foreach ($sources as $source)
    <tr id="source_data_id_{{ $source->id }}">
        <td>{{ $source->id }}</td>
        <td>{{ $source->source_name }}</td>
        
        <td>
            <form action="{{ route('sources.destroy',$source->id) }}" method="POST">
                
                <a href="javascript:void(0)" class="btn btn-success" id="edit-source-data" data-toggle="modal" data-id="{{ $source->id }}">{{ trans('source_data.edit') }}</a>
                <meta name="csrf-token" content="{{ csrf_token() }}">
                <a id="delete-source-data" data-id="{{ $source->id }}" class="btn btn-danger delete-user">{{ trans('source_data.delete') }}</a>
            </form>
        </td>
    </tr>
    @endforeach

</table>


{!! $sources->links() !!}
<!-- Add and Edit source modal -->
<div class="modal fade" id="crud-modal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="sourceCrudModal">{{ trans('source_data.add_edit_source_data') }}</h4>
            </div>
            <div class="modal-body">
                <form name="expForm" action="{{ route('sources.store') }}" method="POST">
                    <input type="hidden" name="exp_id" id="exp_id">
                    @csrf
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12">
                            <div class="form-group">
                                <strong>{{ trans('source_data.name') }}:</strong>
                                <input type="text" name="source_name" id="source_name" class="form-control" placeholder="{{ trans('source_data.source_name') }}" onchange="validate()">
                            </div>
                        </div>
                        
                        <div class="col-xs-12 col-sm-12 col-md-12 text-center">
                            <button type="submit" id="btn-save" name="btnsave" class="btn btn-primary" disabled>{{ trans('source_data.submit') }}</button>
                            <a href="{{ route('sources.index') }}" class="btn btn-danger">{{ trans('source_data.cancel') }}</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@stop
@section('javascript')
<script>
    $(document).ready(function() {

        /* เมื่อคลิกปุ่ม New source data */
        $('#new-source').click(function() {
            $('#btn-save').val("create-source-data");
            $('#source_data').trigger("reset");
            $('#sourceCrudModal').html(trans('source_data.add_new', [], 'th')); // 'th' ใช้สำหรับภาษาไทย
            $('#crud-modal').modal('show');
        });

        /* แก้ไข source data */
        $('body').on('click', '#edit-source', function() {
            var source_id = $(this).data('id');
            $.get('source_data/' + source_id + '/edit', function(data) {
                $('#sourceCrudModal').html(trans('source_data.edit', [], 'th')); // 'th' ใช้สำหรับภาษาไทย
                $('#btn-update').val(trans('source_data.update', [], 'th')); // 'th' ใช้สำหรับภาษาไทย
                $('#btn-save').prop('disabled', false);
                $('#crud-modal').modal('show');
                $('#exp_id').val(data.id);
                $('#source_name').val(data.source_name);
            })
        });

        /* ลบ source data */
        $('body').on('click', '#delete-source', function() {
            var source_id = $(this).data("id");
            var token = $("meta[name='csrf-token']").attr("content");
            if(confirm(trans('source_data.delete_confirm', [], 'th'))) { // 'th' ใช้สำหรับภาษาไทย
                $.ajax({
                    type: "DELETE",
                    url: "source_data/" + source_id,
                    data: {
                        "id": source_id,
                        "_token": token,
                    },
                    success: function(data) {
                        $('#msg').html(trans('source_data.delete_success', [], 'th')); // 'th' ใช้สำหรับภาษาไทย
                        $("#source_data_id_" + source_id).remove();
                    },
                    error: function(data) {
                        console.log('Error:', data);
                    }
                });
            }
        });
    });
</script>



@stop
<script>
    error = false

    function validate() {
        if (document.expForm.source_name.value != '')
            document.expForm.btnsave.disabled = false
        else
            document.expForm.btnsave.disabled = true
    }
</script>
