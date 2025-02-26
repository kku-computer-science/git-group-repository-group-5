

@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <form action="{{url('uploadproduct')}}" method="post" enctype="multipart/form-data">
        @csrf
        <input type="text" name="name" placeholder="{{ trans('research_g.Product Name') }}">
        <input type="text" name="description" placeholder="{{ trans('research_g.Product description') }}">
        <input type="file" name="file">
        <input type="submit" value="{{ trans('research_g.Upload Product') }}">
    </form>
</div>


@endsection