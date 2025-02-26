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
        @if (\Session::has('success'))
            <div class="alert alert-success">
                <p>{{ \Session::get('success') }}</p>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ trans('post.Post') }}
                @can('role-create')
                    <span class="float-right">
                        <a class="btn btn-primary" href="{{ route('posts.index') }}">{{ trans('post.Back') }}</a>
                    </span>
                @endcan
            </div>
            <div class="card-body">
                <div class="lead">
                    <strong>{{ trans('post.Title:') }}</strong>
                    {{ $post->title }}
                </div>
                <div class="lead">
                    <strong>{{ trans('post.Body:') }}</strong>
                    {{ $post->body }}
                </div>
            </div>
        </div>
    </div>
</div>


@endsection