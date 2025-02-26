@extends('dashboards.users.layouts.user-dash-layout')

@section('title', __('patents.edit_title'))

@section('content')
<div class="container">
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <!-- Header หรือ breadcrumb (ถ้ามี) -->
        </div>
    </div>

    @if ($errors->any())
    <div class="alert alert-danger">
        <strong>{{ __('patents.error_title') }}</strong> {{ __('patents.error_text') }}<br><br>
        <ul>
            @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
    @endif

    <div class="col-md-8 grid-margin stretch-card">
        <div class="card" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{ __('patents.edit_title') }}</h4>
                <p class="card-description">{{ __('patents.card_description') }}</p>
                <form class="forms-sample" action="{{ route('patents.update', $patent->id) }}" method="POST">
                    @csrf
                    @method('PUT')
                    
                    <!-- ชื่อ (Name) -->
                    <div class="form-group row">
                        <label for="ac_name" class="col-sm-3 col-form-label">{{ __('patents.name') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_name" value="{{ $patent->ac_name }}" class="form-control" placeholder="{{ __('patents.name') }}">
                        </div>
                    </div>
                    
                    <!-- ประเภท (Type) -->
                    <div class="form-group row">
                        <label for="ac_type" class="col-sm-3 col-form-label">{{ __('patents.type') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_type" value="{{ $patent->ac_type }}" class="form-control" placeholder="{{ __('patents.type') }}">
                        </div>
                    </div>
                    
                    <!-- วันที่ได้รับลิขสิทธิ์ (Registration Date) -->
                    <div class="form-group row">
                        <label for="ac_year" class="col-sm-3 col-form-label">{{ __('patents.registration_date') }}</label>
                        <div class="col-sm-9">
                            <input type="date" name="ac_year" value="{{ $patent->ac_year }}" class="form-control" placeholder="{{ __('patents.registration_date') }}">
                        </div>
                    </div>
                    
                    <!-- เลขทะเบียน (Registration Number) -->
                    <div class="form-group row">
                        <label for="ac_refnumber" class="col-sm-3 col-form-label">{{ __('patents.ref_number') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_refnumber" value="{{ $patent->ac_refnumber }}" class="form-control" placeholder="{{ __('patents.ref_number') }}">
                        </div>
                    </div>
                    
                    <!-- Dynamic Field: อาจารย์ในสาขา (Internal Authors) -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.internal_authors') }}</label>
                        <div class="col-sm-9">
                            <table class="table table-bordered" id="dynamicAddRemove">
                                <tr>
                                    <th>
                                        <button type="button" name="add" id="add-btn2" class="btn btn-success btn-sm add">
                                            <i class="mdi mdi-plus"></i>
                                        </button>
                                    </th>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Dynamic Field: บุคลภายนอก (External Authors) -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.external_authors') }}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="dynamic_field">
                                    <tr>
                                        <td>
                                            <button type="button" name="add" id="add" class="btn btn-success btn-sm">
                                                <i class="mdi mdi-plus"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary me-2 mt-5">{{ __('patents.submit_button') }}</button>
                    <a class="btn btn-light mt-5" href="{{ route('patents.index') }}">{{ __('patents.cancel_button') }}</a>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript สำหรับ Dynamic Fields -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script>
    $(document).ready(function() {
        var patentInternal = <?php echo $patent->user; ?>;
        var i = 0;
        // สำหรับผู้เขียนภายใน (Internal Authors)
        for (i = 0; i < patentInternal.length; i++) {
            var obj = patentInternal[i];
            $("#dynamicAddRemove").append(
                '<tr><td><select id="selUser' + i + '" name="moreFields[' + i + '][userid]" style="width: 200px;">' +
                    '@foreach($users as $user)<option value="{{ $user->id }}">{{ app()->getLocale() == "th" ? $user->fname_th." ".$user->lname_th : $user->fname_en." ".$user->lname_en }}</option>@endforeach' +
                '</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
            );
            document.getElementById("selUser" + i).value = obj.id;
            $("#selUser" + i).select2();
        }
        $("#add-btn2").click(function() {
            ++i;
            $("#dynamicAddRemove").append(
                '<tr><td><select id="selUser' + i + '" name="moreFields[' + i + '][userid]" style="width: 200px;">' +
                    '<option value="">{{ __('patents.select_member') }}</option>' +
                    '@foreach($users as $user)<option value="{{ $user->id }}">{{ app()->getLocale() == "th" ? $user->fname_th." ".$user->lname_th : $user->fname_en." ".$user->lname_en }}</option>@endforeach' +
                '</select></td><td><button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button></td></tr>'
            );
            $("#selUser" + i).select2();
        });
        $(document).on('click', '.remove-tr', function() {
            $(this).closest('tr').remove();
        });
    });
</script>
<script>
    $(document).ready(function() {
        var ext_i = 0;
        $('#add').click(function() {
            ext_i++;
            $('#dynamic_field').append(
                '<tr id="row' + ext_i + '" class="dynamic-added">' +
                    '<td><input type="text" name="fname[]" placeholder="{{ __('patents.placeholder.author_fname') }}" style="width: 300px;" class="form-control name_list" /></td>' +
                    '<td><input type="text" name="lname[]" placeholder="{{ __('patents.placeholder.author_lname') }}" style="width: 300px;" class="form-control name_list" /></td>' +
                    '<td><select id="pos2" class="custom-select my-select" style="width: 200px;" name="pos2[]">' +
                        '<option value="1">{{ __('patents.pos.first_author') }}</option>' +
                        '<option value="2">{{ __('patents.pos.co_author') }}</option>' +
                        '<option value="3">{{ __('patents.pos.corresponding_author') }}</option>' +
                    '</select></td>' +
                    '<td><button type="button" class="btn btn-danger btn-sm btn_remove"><i class="mdi mdi-minus"></i></button></td>' +
                '</tr>'
            );
        });
        $(document).on('click', '.btn_remove', function() {
            $(this).closest('tr').remove();
        });
    });
</script>
@endsection