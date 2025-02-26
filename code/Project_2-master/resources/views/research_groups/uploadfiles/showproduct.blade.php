@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">

    <table border="1px">

    <tr>
        <th>{{ trans('research_g.Name') }}</th>
        <th>{{ trans('research_g.Description') }}</th>
        <th>{{ trans('research_g.Download') }}</th>
    </tr>

    @foreach($data as $data)
    <tr>
        <td>{{$data->name}}</td>
        <td>{{$data->description}}</td>
        <td><a href="{{url('/download',$data->file)}}">{{ trans('research_g.Download') }}</a></td>
    </tr>

    @endforeach

    </table>
</div>

	@endsection