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
            <div class="card-header">{{ translateText('Posts') }}
                @can('post-create')
                    <span class="float-right">
                        <a class="btn btn-primary" href="{{ route('posts.create') }}">{{ translateText('New post') }}</a>
                    </span>
                @endcan
            </div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>#</th>
                            <th>{{ translateText('Name') }}</th>
                            <th width="280px">{{ translateText('Action') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($data as $key => $post)
                            <tr>
                                <td>{{ $post->id }}</td>
                                <td>{{ $post->title }}</td>
                                <td>
                                    <a class="btn btn-success" href="{{ route('posts.show',$post->id) }}">{{ translateText('Show') }}</a>
                                    @can('post-edit')
                                        <a class="btn btn-primary" href="{{ route('posts.edit',$post->id) }}">{{ translateText('Edit') }}</a>
                                    @endcan
                                    @can('post-delete')
                                        {!! Form::open(['method' => 'DELETE','route' => ['posts.destroy', $post->id],'style'=>'display:inline']) !!}
                                        {!! Form::submit(translateText('Delete'), ['class' => 'btn btn-danger']) !!}
                                        {!! Form::close() !!}
                                    @endcan
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
                {{ $data->appends($_GET)->links() }}
            </div>
        </div>
    </div>
</div>

@endsection