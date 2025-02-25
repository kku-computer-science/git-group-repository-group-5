@extends('dashboards.users.layouts.user-dash-layout')
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
@section('content')
<style type="text/css">
    .dropdown-toggle {
        height: 40px;
        width: 400px !important;
    }
</style>
<div class="container">
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-right">
                <!-- สามารถเพิ่มปุ่มหรือข้อมูลเพิ่มเติมได้ที่นี่ -->
            </div>
        </div>
    </div>

    @if ($errors->any())
    <div class="alert alert-danger">
        <strong>{{ translateText('Whoops!') }}</strong> {{ translateText('There were some problems with your input.') }}<br><br>
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
                <h4 class="card-title">{{ translateText('Add a book') }}</h4>
                <p class="card-description">{{ translateText('Fill in book details') }}</p>
                <form class="forms-sample" action="{{ translateText('store') }}" method="POST">
                    @csrf

                    <div class="form-group row">
                        <label for="exampleInputac_name" class="col-sm-3 col-form-label">{{ translateText('Book name') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_name" class="form-control" placeholder="{{ translateText('Book name') }}">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="exampleInputac_sourcetitle" class="col-sm-3 col-form-label">{{ translateText('Place of publication') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_sourcetitle" class="form-control" placeholder="{{ translateText('Place of publication') }}">
                        </div>
                    </div>

                    <!-- เปลี่ยน input type="date" เป็น input type="text" สำหรับ Datepicker -->
                    <div class="form-group row">
                        <label for="exampleInputac_year" class="col-sm-3 col-form-label">{{ translateText('Year (AD)') }}</label>
                        <div class="col-sm-9">
                            <input type="text" id="datepicker" name="ac_year" class="form-control"
                                placeholder="{{ translateText('Year (AD)', 'en') }}">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="exampleInputac_page" class="col-sm-3 col-form-label">{{ translateText('Number of pages') }}</label>
                        <div class="col-sm-9">
                            <input type="text" name="ac_page" class="form-control" placeholder="{{ translateText('Number of pages') }}">
                        </div>
                    </div>

                    <button type="submit" name="submit" id="submit" class="btn btn-primary me-2">{{ translateText('Submit') }}</button>
                    <a class="btn btn-light" href="{{ route('books.index')}}">{{ translateText('Cancel') }}</a>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- เพิ่ม Bootstrap Datepicker CSS และ JS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
<!-- โหลด locale สำหรับ Bootstrap Datepicker ภาษา zh-CN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/locales/bootstrap-datepicker.zh-CN.min.js"></script>

<script type="text/javascript">
    $(document).ready(function() {
        // กำหนดภาษาของ Datepicker ตามค่า locale ของแอป
        var currentLang = "{{ app()->getLocale() }}";
        // ถ้าเป็นภาษาจีน ใช้ 'zh-CN' แต่ถ้าไม่ใช่ให้ใช้ภาษาอื่น (ในตัวอย่างนี้ใช้ค่า currentLang)
        var dpLang = currentLang === 'zh' ? 'zh' : currentLang;
        $('#datepicker').datepicker({
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayHighlight: true,
            language: dpLang
        });
    });
</script>

<script type="text/javascript">
    $(document).ready(function() {
        var postURL = "<?php echo url('addmore'); ?>";
        var i = 1;

        $('#add').click(function() {
            i++;
            $('#dynamic_field').append('<tr id="row' + i + '" class="dynamic-added"><td><input type="text" name="name[]" placeholder="Enter your Name" class="form-control name_list" /></td><td><button type="button" name="remove" id="' + i + '" class="btn btn-danger btn-sm btn_remove">X</button></td></tr>');
        });

        $(document).on('click', '.btn_remove', function() {
            var button_id = $(this).attr("id");
            $('#row' + button_id).remove();
        });

        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        $('#submit').click(function() {
            $.ajax({
                url: postURL,
                method: "POST",
                data: $('#add_name').serialize(),
                type: 'json',
                success: function(data) {
                    if (data.error) {
                        printErrorMsg(data.error);
                    } else {
                        i = 1;
                        $('.dynamic-added').remove();
                        $('#add_name')[0].reset();
                        $(".print-success-msg").find("ul").html('');
                        $(".print-success-msg").css('display', 'block');
                        $(".print-error-msg").css('display', 'none');
                        $(".print-success-msg").find("ul").append('<li>Record Inserted Successfully.</li>');
                    }
                }
            });
        });

        function printErrorMsg(msg) {
            $(".print-error-msg").find("ul").html('');
            $(".print-error-msg").css('display', 'block');
            $(".print-success-msg").css('display', 'none');
            $.each(msg, function(key, value) {
                $(".print-error-msg").find("ul").append('<li>' + value + '</li>');
            });
        }
    });
</script>
@endsection
