@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">

    <table border="1px">

    <tr>
        <th>{{ translateText('Name') }}</th>
        <th>{{ translateText('Description') }}</th>
        <th>{{ translateText('Download') }}</th>
    </tr>

    @foreach($data as $data)
    <tr>
        <td>{{$data->name}}</td>
        <td>{{$data->description}}</td>
        <td><a href="{{url('/download',$data->file)}}">{{ translateText('Download') }}</a></td>
    </tr>

    @endforeach

    </table>
</div>

	@endsection