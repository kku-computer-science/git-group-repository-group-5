@extends('logs.layout.logs-menu')
@section('title', 'Dashboard')

@section('content')
<div class="container">
    <h2 class="mb-4">User Login Logs</h2>

    <div class="mb-6">
        <form action="{{ route('logs.overall') }}" method="GET" class="space-y-4">
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
                    <label for="per_page" class="block text-gray-700 font-bold mb-2">Records per page:</label>
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
                <a href="{{ route('logs.overall') }}" style="text-decoration: none;" class="bg-gray-500 hover:bg-gray-700 text-black font-bold py-2 px-4 rounded">
                    Reset
                </a>
                <a href="{{ route('logs.export', ['format' => 'csv'] + request()->query()) }}" style="text-decoration: none;"
                    class="bg-green-500 hover:bg-green-700 text-black font-bold py-2 px-4 rounded">
                    Export CSV
                </a>
                <a href="{{ route('logs.export', ['format' => 'json'] + request()->query()) }}" style="text-decoration: none;"
                    class="bg-yellow-500 hover:bg-yellow-700 text-black font-bold py-2 px-4 rounded">
                    Export JSON
                </a>
            </div>
        </form>
    </div>

    @if($logs->count())
    <div class="table-container table-responsive">
        <table class="w-full">
            <thead style="background-color: black;" class="bg-black text-white">
                <tr>
                    <th class=" px-4 py-2">No</th>
                    <th class=" px-4 py-2">User</th>
                    <th class=" px-4 py-2">Action</th>
                    <th class=" px-4 py-2">Description</th>
                    <th class=" px-4 py-2">IP Address</th>
                    <th class=" px-4 py-2">Date</th>
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