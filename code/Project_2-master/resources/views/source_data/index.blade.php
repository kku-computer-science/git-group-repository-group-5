@extends('dashboards.users.layouts.user-dash-layout')
@section('content')
<div class="row">
    <div class="col-lg-12" style="text-align: center">
        <div>
            <h2>{{ translateText('source') }}</h2>
        </div>
        <br />
    </div>
</div>
<div class="row">
    <div class="col-lg-12 margin-tb">
        <div class="pull-right">
            <a href="javascript:void(0)" class="btn btn-success mb-2" id="new-source" data-toggle="modal">{{ translateText('Add Source Data') }}</a>
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
        <th>{{ translateText('ID') }}</th>
        <th>{{ translateText('Name') }}</th>
        <th width="280px">{{ translateText('Action') }}</th>
    </tr>

    @foreach ($sources as $source)
    <tr id="source_id_{{ $source->id }}">
        <td>{{ $source->id }}</td>
        <td>{{ $source->source_name }}</td>
        
        <td>
            <form action="{{ route('sources.destroy',$source->id) }}" method="POST">
                
                <a href="javascript:void(0)" class="btn btn-success" id="edit-source" data-toggle="modal" data-id="{{ $source->id }}">{{ translateText('Edit') }}</a>
                <meta name="csrf-token" content="{{ csrf_token() }}">
                <a id="delete-source" data-id="{{ $source->id }}" class="btn btn-danger delete-user">{{ translateText('Delete') }}</a>
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
                <h4 class="modal-title" id="sourceCrudModal">{{ translateText('Add/Edit Source Data') }}</h4>
            </div>
            <div class="modal-body">
                <form name="expForm" action="{{ route('sources.store') }}" method="POST">
                    <input type="hidden" name="exp_id" id="exp_id">
                    @csrf
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12">
                            <div class="form-group">
                                <strong>{{ translateText('Name') }}:</strong>
                                <input type="text" name="source_name" id="source_name" class="form-control" placeholder="{{ translateText('source_name') }}" onchange="validate()">
                            </div>
                        </div>
                        
                        <div class="col-xs-12 col-sm-12 col-md-12 text-center">
                            <button type="submit" id="btn-save" name="btnsave" class="btn btn-primary" disabled>{{ translateText('Submit') }}</button>
                            <a href="{{ route('sources.index') }}" class="btn btn-danger">{{ translateText('Cancel') }}</a>
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

        /* When click New source button */
        $('#new-source').click(function() {
            $('#btn-save').val("create-source");
            $('#source').trigger("reset");
            $('#sourceCrudModal').html(translateText('Add New Source'));
            $('#crud-modal').modal('show');
        });

        /* Edit source */
        $('body').on('click', '#edit-source', function() {
            var source_id = $(this).data('id');
            $.get('sources/' + source_id + '/edit', function(data) {
                $('#sourceCrudModal').html(translateText('Edit Source'));
                $('#btn-update').val(translateText('Update'));
                $('#btn-save').prop('disabled', false);
                $('#crud-modal').modal('show');
                $('#exp_id').val(data.id);
                $('#source_name').val(data.source_name);
            })
        });

        /* Delete source */
        $('body').on('click', '#delete-source', function() {
            var source_id = $(this).data("id");
            var token = $("meta[name='csrf-token']").attr("content");
            confirm(translateText('Are you sure you want to delete?'));

            $.ajax({
                type: "DELETE",
                url: "sources/" + source_id,
                data: {
                    "id": source_id,
                    "_token": token,
                },
                success: function(data) {
                    $('#msg').html(translateText('Source entry deleted successfully'));
                    $("#source_id_" + source_id).remove();
                },
                error: function(data) {
                    console.log('Error:', data);
                }
            });
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
