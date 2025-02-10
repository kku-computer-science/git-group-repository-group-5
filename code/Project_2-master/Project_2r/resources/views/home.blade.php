@extends('layouts.layout')

@section('content')
<div class="container">
    <div class="container cards-1">
        <p>Announcement</p>
        <div class="row row-cols-1 row-cols-md-4 g-4">
        <div class="col">
            <div class="card">
                <img src="{{asset('img/img.jpg')}}" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">title</h5>
                    <p class="card-text">This is a longer card with supporting text below as a natural lead-in to
                        additional content. This content is a little bit longer.</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card">
                <img src="{{asset('img/img.jpg')}}" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">title</h5>
                    <p class="card-text">This is a longer card with supporting text below as a natural lead-in to
                        additional content. This content is a little bit longer.</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card">
                <img src="{{asset('img/img.jpg')}}" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">title</h5>
                    <p class="card-text">This is a longer card with supporting text below as a natural lead-in to
                        additional content.</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card">
                <img src="{{asset('img/img.jpg')}}" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">title</h5>
                    <p class="card-text">This is a longer card with supporting text below as a natural lead-in to
                        additional content. This content is a little bit longer.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mixpaper">
        <h3>ผลงานตีพิมพ์ (5 ปี ย้อนหลัง)</h3>
        <div class="row">
            <div class="col-lg-12">
                <div class="text-container">
                    <h4> 2021 </h4>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
