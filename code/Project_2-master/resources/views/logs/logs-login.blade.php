@extends('logs.layout.logs-menu')
@section('title','Dashboard')

@section('content')
<div class="container">
    <h2 class="mb-4">User Login Logs</h2>

    @if($logs->count())
        <div class="table-container table-responsive">
            <table class="table table-dark">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Action</th>
                        <th>Description</th>
                        <th>IP Address</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($logs as $log)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>{{ $log->user->email }}</td>
                        <td>{{ $log->action }}</td>
                        <td>{{ $log->description }}</td>
                        <td>{{ $log->ip_address }}</td>
                        <td>{{ $log->created_at }}</td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    @else
        <p class="text-center">No logs found.</p>
    @endif
</div>
@endsection
