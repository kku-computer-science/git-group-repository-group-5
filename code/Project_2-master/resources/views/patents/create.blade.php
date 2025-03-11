@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
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
                <h4 class="card-title">{{ __('patents.add_button') }}</h4>
                <p class="card-description">{{ __('patents.card_description') }}</p>

                <form class="forms-sample" action="{{ route('patents.store') }}" method="POST">
                    @csrf

                    <!-- ชื่อผลงาน -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.name') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_name" value="{{ old('ac_name') }}" class="form-control" placeholder="{{ __('patents.name') }}">
                        </div>
                    </div>

                    <!-- ประเภท -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.type') }}</label>
                        <div class="col-sm-9">
                        <select class="custom-select my-select" name="ac_type">
                            <option value="" disabled selected>{{ __('patents.select_type') }}</option>
                            <option value="สิทธิบัตร">{{ __('patents.types.patent') }}</option>
                            <option value="อนุสิทธิบัตร">{{ __('patents.types.utility_model') }}</option>
                            <option value="ลิขสิทธิ์">{{ __('patents.types.copyright') }}</option>
                        </select>

                        </div>
                    </div>

                    <!-- วันที่ได้รับลิขสิทธิ์ -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.registration_date') }}</label>
                        <div class="col-sm-9">
                            <input type="date" name="ac_year" value="{{ old('ac_year') }}" class="form-control">
                        </div>
                    </div>

                    <!-- เลขทะเบียน -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.ref_number') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_refnumber" value="{{ old('ac_refnumber') }}" class="form-control" placeholder="{{ __('patents.ref_number') }}">
                        </div>
                    </div>

                    <!-- อาจารย์ในสาขา -->
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

                    <!-- บุคคลภายนอก -->
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label">{{ __('patents.external_authors') }}</label>
                        <div class="col-sm-9">
                            <div class="table-responsive">
                                <table class="table table-hover small-text" id="tb">
                                    <tr class="tr-header">
                                        <th>{{ __('patents.placeholder.author_fname') }}</th>
                                        <th>{{ __('patents.placeholder.author_lname') }}</th>
                                        <th>
                                            <a href="javascript:void(0);" id="addMore2" title="Add More Person">
                                                <i class="mdi mdi-plus"></i>
                                            </a>
                                        </th>
                                    </tr>
                                    <tr>
                                        <td><input type="text" name="fname[]" class="form-control" placeholder="{{ __('patents.placeholder.author_fname') }}"></td>
                                        <td><input type="text" name="lname[]" class="form-control" placeholder="{{ __('patents.placeholder.author_lname') }}"></td>
                                        <td><a href='javascript:void(0);' class='remove'><i class="mdi mdi-minus"></i></a></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary me-2">{{ __('patents.submit_button') }}</button>
                    <a class="btn btn-light" href="{{ route('patents.index') }}">{{ __('patents.cancel_button') }}</a>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script>
    $(document).ready(function() {
        $("#add-btn2").click(function() {
            var i = $("#dynamicAddRemove tr").length;
            $("#dynamicAddRemove").append(
                `<tr>
                    <td>
                        <select id="selUser${i}" name="moreFields[${i}][userid]" class="form-control">
                            <option value="">{{ __('patents.select_member') }}</option>
                            @foreach($users as $user)
                                <option value="{{ $user->id }}">
                                    {{ app()->getLocale() == 'th' ? $user->fname_th . ' ' . $user->lname_th : $user->fname_en . ' ' . $user->lname_en }}
                                </option>
                            @endforeach
                        </select>
                    </td>
                    <td>
                        <button type="button" class="btn btn-danger btn-sm remove-tr"><i class="mdi mdi-minus"></i></button>
                    </td>
                </tr>`
            );
        });

        $(document).on('click', '.remove-tr', function() {
            $(this).parents('tr').remove();
        });

        $('#addMore2').on('click', function() {
            var data = $("#tb tr:eq(1)").clone(true).appendTo("#tb");
            data.find("input").val('');
        });

        $(document).on('click', '.remove', function() {
            var trIndex = $(this).closest("tr").index();
            if (trIndex > 1) {
                $(this).closest("tr").remove();
            } else {
                alert("Sorry!! Can't remove first row!");
            }
        });
    });
</script>

@endsection
