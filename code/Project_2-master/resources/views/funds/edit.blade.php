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
    <div class="col-md-8 grid-margin stretch-card">
        <div class="card" style="padding: 16px;">
            <div class="card-body">
                <h4 class="card-title">{{ trans('funds.EditFund') }}</h4>
                <p class="card-description">{{ trans('funds.EditFundDetail') }}</p>
                <form class="forms-sample" action="{{ route('funds.update',$fund->id) }}" method="POST">
                    @csrf
                    @method('PUT')
                    <div class="form-group row">
                        <p class="col-sm-3 "><b>{{ trans('funds.FundingType') }}</b></p>
                        <!-- <label for="exampleInputfund_type" class="col-sm-2 ">{{ translateText('ประเภททุนวิจัย') }}</label> -->
                        <div class="col-sm-4">
                            <select name="fund_type" class="custom-select my-select" id="fund_type" onchange='toggleDropdown(this);' required>
                                <option value="ทุนภายใน" {{ $fund->fund_type == 'ทุนภายใน' ? 'selected' : '' }}>{{ trans('funds.InternalCapital') }}</option>
                                <option value="ทุนภายนอก" {{ $fund->fund_type == 'ทุนภายนอก' ? 'selected' : '' }}>{{ trans('funds.ExternalCapital') }}</option>
                            </select>
                        </div>
                    </div>
                    <div id="fund_code">
                        <div class="form-group row">
                            <p class="col-sm-3"><b>{{ trans('funds.FunddingLevel') }}</b></p>
                            <div class="col-sm-4">
                                <select name="fund_level" class="custom-select my-select">
                                    <option value=""{{ $fund->fund_level == '' ? 'selected' : '' }}>{{ trans('funds.Unknown') }}</option>
                                    <option value="สูง" {{ $fund->fund_level == 'สูง' ? 'selected' : '' }}>{{ trans('funds.High') }}</option>
                                    <option value="กลาง" {{ $fund->fund_level == 'กลาง' ? 'selected' : '' }}>{{ trans('funds.Mid') }}</option>
                                    <option value="ล่าง" {{ $fund->fund_level == 'ล่าง' ? 'selected' : '' }}>{{ trans('funds.Low') }}</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group row">
                        <p class="col-sm-3 "><b>{{ trans('funds.FundName') }}</b></p>
                        <div class="col-sm-8">
                            <input type="text" name="fund_name" value="{{ $fund->fund_name }}" class="form-control" placeholder="{{ translateText('fund_name') }}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <p class="col-sm-3 "><b>{{ trans('funds.FundAgency') }}</b></p>
                        <div class="col-sm-8">
                            <input type="text" name="support_resource" value="{{ $fund->support_resource }}" class="form-control" placeholder="{{ translateText('Support Resource') }}">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary mt-5">{{ translateText('Submit') }}</button>
                    <a class="btn btn-light mt-5" href="{{ route('funds.index')}}">{{ translateText('Cancel') }}</a>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    const ac = document.getElementById("fund_code");
    const ab = document.getElementById("fund_type").value;
    //console.log(ab);
    if (ab === "ทุนภายนอก") {
        ac.style.display = "none";
    }
    //ac.style.display = "none";
    function toggleDropdown(selObj) {
        ac.style.display = selObj.value === "ทุนภายใน" ? "block" : "none";
    }
</script>
@endsection