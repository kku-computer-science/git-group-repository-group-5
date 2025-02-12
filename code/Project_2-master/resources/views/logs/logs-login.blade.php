@extends('logs.layout.logs-menu')
@section('title', 'Dashboard')

@section('content')
<div class="container">
    <h3 class="mb-4">User Login Logs</h3>

    <div class="mb-6">
        <form action="{{ route('logs.login') }}" method="GET" class="space-y-4">
            <div class="flex flex-wrap gap-4">
                <div class="w-full md:w-1/3">
                    <label for="user_id" class="block text-gray-700 font-bold mb-2">User :</label>
                    <select name="user_id" id="user_id" class="mb-2 border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">All Users</option>
                        @foreach ($users as $user)
                        <option value="{{ $user->id }}" {{ request('user_id') == $user->id ? 'selected' : '' }}>
                            {{ $user->email }}
                        </option>
                        @endforeach
                    </select>
                </div>

                <div class="w-full md:w-1/3">
                    <label for="selected_date" class="block text-gray-700 font-bold mb-2">Select Date :</label>
                    <input type="date" id="selected_date" name="selected_date"
                        value="{{ request('selected_date', date('Y-m-d')) }}"
                        class="mb-2 border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="w-full md:w-1/3">
                    <label for="per_page" class="block text-gray-700 font-bold mb-3">Records per page:</label>
                    <select name="per_page" id="per_page" onchange="this.form.submit()"
                        class="mb-2 border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
                        @foreach ([10, 20, 50, 100] as $size)
                        <option value="{{ $size }}" {{ request('per_page', 50) == $size ? 'selected' : '' }}>
                            {{ $size }}
                        </option>
                        @endforeach
                    </select>
                </div>
            </div>

            <div class="flex space-x-2 justify-end mb-2">
                <button type="submit" style="text-decoration: none;" class="bg-blue-500 hover:bg-blue-700 text-black font-bold py-2 px-4 rounded">
                    Filter
                </button>
                <a href="{{ route('logs.login') }}" style="text-decoration: none;" class="bg-gray-500 hover:bg-gray-700 text-black font-bold py-2 px-4 rounded">
                    Reset
                </a>
            </div>
        </form>
    </div>

    @if($logs->count())
    <div class="table-container table-responsive">
        <table class="w-full">
            <thead style="background-color: black;" class="bg-black text-white">
                <tr>
                    <th class=" px-4 py-2">
                        <a style="color:white; text-decoration:none;" href="{{ route('logs.login', array_merge(request()->query(), ['sort_column' => 'id', 'sort_direction' => (request('sort_column') == 'id' && request('sort_direction') == 'asc') ? 'desc' : 'asc'])) }}" class="text-white">
                            No
                        </a>
                    </th>
                    <th class=" px-4 py-2">
                        <a style="color:white; text-decoration:none;" href="{{ route('logs.login', array_merge(request()->query(), ['sort_column' => 'user_id', 'sort_direction' => (request('sort_column') == 'user_id' && request('sort_direction') == 'asc') ? 'desc' : 'asc'])) }}" class="text-white">
                            User
                        </a>
                    </th>
                    <th class=" px-4 py-2">
                        <a style="color:white; text-decoration:none;" href="{{ route('logs.login', array_merge(request()->query(), ['sort_column' => 'action', 'sort_direction' => (request('sort_column') == 'action' && request('sort_direction') == 'asc') ? 'desc' : 'asc'])) }}" class="text-white">
                            Action
                        </a>
                    </th>
                    <th class=" px-4 py-2">
                        <a style="color:white; text-decoration:none;" href="{{ route('logs.login', array_merge(request()->query(), ['sort_column' => 'description', 'sort_direction' => (request('sort_column') == 'description' && request('sort_direction') == 'asc') ? 'desc' : 'asc'])) }}" class="text-white">
                            Description
                        </a>
                    </th>
                    <th class=" px-4 py-2">
                        <a style="color:white; text-decoration:none;" href="{{ route('logs.login', array_merge(request()->query(), ['sort_column' => 'ip_address', 'sort_direction' => (request('sort_column') == 'ip_address' && request('sort_direction') == 'asc') ? 'desc' : 'asc'])) }}" class="text-white">
                            IP Address
                        </a>
                    </th>
                    <th class=" px-4 py-2">
                        <a style="color:white; text-decoration:none;" href="{{ route('logs.login', array_merge(request()->query(), ['sort_column' => 'created_at', 'sort_direction' => (request('sort_column') == 'created_at' && request('sort_direction') == 'asc') ? 'desc' : 'asc'])) }}" class="text-white">
                            Date
                        </a>
                    </th>
                </tr>
            </thead>

            <tbody>
                @foreach($logs as $index => $log)
                <tr style="background-color:rgb(235, 235, 235);" class="hover:bg-gray-100">
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $loop->iteration }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->user->email }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->action }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->description }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->ip_address }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->created_at->format('Y-m-d H:i:s') }}</td>
                </tr>
                @endforeach
            </tbody>

        </table>
    </div>

    {{ $logs->appends(request()->query())->links() }}
    @else
    <p class="text-center">No logs found.</p>
    @endif
</div>
@endsection
