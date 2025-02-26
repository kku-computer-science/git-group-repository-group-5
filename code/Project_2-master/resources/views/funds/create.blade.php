@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<style>
    .my-select {
        background-color: #fff;
        color: #212529;
        border: #000 0.2 solid;
        border-radius: 10px;
        padding: 4px 10px;
        width: 100%;
        font-size: 14px;
    }
</style>
<div class="container">
    @if ($errors->any())
    <div class="alert alert-danger">
        <strong>{{ translateText('Whoops!') }}</strong> {{ translateText('There were some problems with your input.') }}<br><br>
        <ul>
            @foreach ($errors->all() as $error)
            <li>{{ translateText($error) }}</li>
            @endforeach
        </ul>
    </div>
    @endif
    <!-- <a class="btn btn-primary" href="{{ route('funds.index') }}"> {{ translateText('Back') }} </a> -->
    <div class="col-md-8 grid-margin stretch-card">
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">{{ trans('funds.AddFund') }}</h4>
                <p class="card-description">{{ trans('funds.FillFund') }}</p>
                <form class="forms-sample" action="{{ route('funds.store') }}" method="POST">
                    @csrf
                    <div class="form-group row">
                        <label for="exampleInputfund_type" class="col-sm-2 ">{{ trans('funds.FundingType') }}</label>
                        <div class="col-sm-4">
                            <select name="fund_type" class="custom-select my-select" id="fund_type" onchange='toggleDropdown(this);' required>
                                <option value="" disabled selected >{{ trans('funds.DefindFundType') }}</option>
                                <option value="ทุนภายใน">{{ trans('funds.InternalCapital') }}</option>
                                <option value="ทุนภายนอก">{{ trans('funds.ExternalCapital') }}</option>
                            </select>
                        </div>
                    </div>
                    <div id="fund_code">
                        <div class="form-group row">
                            <label for="exampleInputfund_level" class="col-sm-2 ">{{ trans('funds.FunddingLevel') }}</label>
                            <div class="col-sm-4">
                                <select name="fund_level" class="custom-select my-select">
                                <option value="" disabled selected >{{ trans('funds.DefindFundLevel') }}</option>
                                    <option value="">{{ trans('funds.Unknown') }}</option>
                                    <option value="สูง">{{ trans('funds.High') }}</option>
                                    <option value="กลาง">{{ trans('funds.Mid') }}</option>
                                    <option value="ล่าง">{{ trans('funds.Low') }}</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="exampleInputfund_name" class="col-sm-2 ">{{ trans('funds.FundingName') }}</label>
                        <div class="col-sm-8">
                            <input type="text" name="fund_name" class="form-control" placeholder="{{ translateText('name') }}">
                        </div>
                    </div>
                    
                    <div class="form-group row">
                        <label for="exampleInputsupport_resource" class="col-sm-2 ">{{ trans('funds.FundingAgency') }}</label>
                        <div class="col-sm-8">
                            <input type="text" name="support_resource" class="form-control" placeholder="{{ translateText('Support Resource') }}">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary me-2">{{ translateText('Submit') }}</button>
                    <a class="btn btn-light" href="{{ route('funds.index')}}">{{ translateText('Cancel') }}</a>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    const ac = document.getElementById("fund_code");
    //ac.style.display = "none";

    function toggleDropdown(selObj) {
        ac.style.display = selObj.value === "{{ translateText('ทุนภายใน') }}" ? "block" : "none";
    }
</script>
@endsection