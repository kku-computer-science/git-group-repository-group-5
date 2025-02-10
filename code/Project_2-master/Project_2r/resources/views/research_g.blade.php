@extends('layouts.layout')
@section('content')
<div class="container card-3 ">
    <p>กลุ่มงานวิจัย</p>
    @foreach ($resg as $rg)
    <div class="card mb-4 ">
        <div class="row g-0">
            <div class="col-md-4">
                <img src="{{asset('img/img.jpg')}}" class="img-fluid rounded-start" alt="...">
                <h1 class="card-text-1"> Laboratory Supervisor </h1>
                <h2 class="card-text-2">@foreach ($rg->user as $user) {{$user->position}}{{$user->fname}} {{$user->lname}}
                @endforeach</h2>
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h5 class="card-title">{{$rg->Group_name_TH}}</h5>
                    <h3 class="card-text h-100">{{ Str::limit($rg->Group_detail_TH, 350) }}
                    {{ Str::limit($rg->Group_detail_EN, 350) }}
                    </h3>
                </div>
                <div><a :href="#" class="btn btn-outline-secondary">รายละเอียดเพิ่มเติม</a></div>
            </div>
        </div>
    </div>
    @endforeach
    <!-- <div class="card mb-4 ">
        <div class="row g-0">
            <div class="col-md-4">
                <img src="{{asset('img/img.jpg')}}" class="img-fluid rounded-start" alt="...">
                <h1 class="card-text-1"> Laboratory Supervisor </h1>
                <h2 class="card-text-2"> Assist. Prof. Pusadee Seresangtakul </h2>
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h5 class="card-title">ห้องปฎิบัติการประมวลผลภาษาธรรมชาติและการประมวลผลด้านเสียง (NLSP)</h5>
                    <h3 class="card-text-3">This laboratory aims to study and research on the smart
                        technology for high performance computing which imitates the nature-inspired behaviors.This
                        laboratory aims to study and research on the smart
                        technology for high performance computing which imitates
                        the nature-inspired behaviors</h3>
                    <a :href="'#'" class="btn btn-outline-secondary">รายละเอียดเพิ่มเติม</a>
                </div>
            </div>
        </div>
    </div> -->
</div>

@stop