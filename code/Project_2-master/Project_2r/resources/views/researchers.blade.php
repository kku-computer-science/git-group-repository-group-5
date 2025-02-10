@extends('layouts.layout')
@section('content')
<div class="container card-2">
        <p> Researchers </p>
         <div class="row">
             @foreach($reshr as $r)
            <div class="col-xs-12 col-sm-6 col-md-2 p-4">
                <div class="card p-0">
                <div class="card-image"> <img src="{{ asset("images/imag_teacher/{$r->fname}.jpg") }}" alt=""> </div>
                <div class="card-content d-flex flex-column align-items-center">
                    <h5>{{$r->fname}} {{$r->lname}}</h5>
                </div>
                
            </div></a>
                <!-- <h6>{{$r->fname}} {{$r->lname}}</h6> -->
            </div>
            @endforeach
        </div>
      </div>

@stop