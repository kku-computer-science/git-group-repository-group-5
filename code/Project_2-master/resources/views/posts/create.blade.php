@php
   if(Auth::user()->hasRole('admin')) {
      $layoutDirectory = 'dashboards.admins.layouts.admin-dash-layout';
   } else {
      $layoutDirectory = 'dashboards.users.layouts.user-dash-layout';
   }
@endphp

@extends($layoutDirectory)
@section('content')
<div class="container">
    <div class="justify-content-center">
        @if (count($errors) > 0)
            <div class="alert alert-danger">
                <strong>{{ trans('post.Opps!') }}</strong> {{ trans('post.Something went wrong, please check below errors.') }}<br><br>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('post.Create post') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('posts.index') }}">{{ trans('post.Posts') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::open(array('route' => 'posts.store', 'method'=>'POST')) !!}
                    <div class="form-group">
                        <strong>{{ trans('post.Title:') }}</strong>
                        {!! Form::text('title', null, array('placeholder' => trans('post.Title'),'class' => 'form-control')) !!}
                    </div>
                    <div class="form-group">
                        <strong>{{ trans('post.Body:') }}</strong>
                        {!! Form::textarea('body', null, array('placeholder' => trans('post.Body'),'class' => 'form-control')) !!}
                    </div>
                    <button type="submit" class="btn btn-primary">{{ trans('post.Submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>



@endsection