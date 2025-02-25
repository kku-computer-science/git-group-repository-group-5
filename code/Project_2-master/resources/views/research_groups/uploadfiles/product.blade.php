

@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <form action="{{url('uploadproduct')}}" method="post" enctype="multipart/form-data">
        @csrf
        <input type="text" name="name" placeholder="{{ translateText('Product Name') }}">
        <input type="text" name="description" placeholder="{{ translateText('Product description') }}">
        <input type="file" name="file">
        <input type="submit" value="{{ translateText('Upload Product') }}">
    </form>
</div>

@endsection