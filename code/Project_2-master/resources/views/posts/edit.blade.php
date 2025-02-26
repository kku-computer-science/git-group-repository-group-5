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
                <strong>{{ translateText('Opps!') }}</strong> {{ translateText('Something went wrong, please check below errors.') }}<br><br>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <div class="card">
            <div class="card-header">{{ translateText('Create post') }}
                <span class="float-right">
                    <a class="btn btn-primary" href="{{ route('posts.index') }}">{{ translateText('Posts') }}</a>
                </span>
            </div>
            <div class="card-body">
                {!! Form::model($post, ['route' => ['posts.update', $post->id], 'method'=>'PATCH']) !!}
                    <div class="form-group">
                        <strong>{{ translateText('Title:') }}</strong>
                        {!! Form::text('title', null, array('placeholder' => translateText('Title'),'class' => 'form-control')) !!}
                    </div>
                    <div class="form-group">
                        <strong>{{ translateText('Body:') }}</strong>
                        {!! Form::textarea('body', null, array('placeholder' => translateText('Body'),'class' => 'form-control')) !!}
                    </div>
                    <button type="submit" class="btn btn-primary">{{ translateText('Submit') }}</button>
                {!! Form::close() !!}
            </div>
        </div>
    </div>
</div>

@endsection