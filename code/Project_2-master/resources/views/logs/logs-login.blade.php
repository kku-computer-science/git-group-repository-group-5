@extends('logs.layout.logs-menu')
@section('title', 'Dashboard')

@section('content')
<div class="container">
    <h2 class="mb-4">User Login Logs</h2>


    <div class="mb-6">
        <form action="{{ route('logs.login') }}" method="GET" class="space-y-4">
            <div class="flex flex-wrap gap-4">
                <div class="w-full md:w-1/2">
                    <label for="user_id" class="block text-gray-700 font-bold mb-2">User :</label>
                    <select name="user_id" id="user_id" class="shadow border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">All Users</option>
                        @foreach ($users as $user)
                            <option value="{{ $user->id }}" {{ request('user_id') == $user->id ? 'selected' : '' }}>
                                {{ $user->email }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <div class="w-full md:w-1/2">
                    <label for="selected_date" class="block text-gray-700 font-bold mb-2">Select Date :</label>
                    <input
                        type="date"
                        id="selected_date"
                        name="selected_date"
                        value="{{ request('selected_date', date('Y-m-d')) }}"
                        class="shadow border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>

            <div class="flex space-x-2 justify-end">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                    Filter
                </button>
                <a href="{{ route('logs.login') }}" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-gray-500">
                    Reset
                </a>
            </div>
        </form>
    </div>


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
                        <td>{{ $log->created_at->format('Y-m-d H:i:s') }}</td> <!-- แสดงวันที่ในรูปแบบที่เข้าใจง่าย -->
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
