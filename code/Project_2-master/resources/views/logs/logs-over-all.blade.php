@extends('logs.layout.logs-menu')
@section('title','Dashboard')

@section('content')

<h3 class="mt-3 text-xl font-semibold">Overall</h3>
<br>

<div class="mb-6">
    <form action="{{ route('logs.overall') }}" method="GET" class="space-y-4">
        <div class="flex flex-wrap gap-4">
            <div class="w-full md:w-1/3">
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

            <div class="w-full md:w-1/3">
                <label for="start_date" class="block text-gray-700 font-bold mb-2">Start Date :</label>
                <input 
                    type="date" 
                    id="start_date" 
                    name="start_date" 
                    value="{{ request('start_date') }}"
                    class="shadow border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <div class="w-full md:w-1/3">
                <label for="end_date" class="block text-gray-700 font-bold mb-2">End Date :</label>
                <input 
                    type="date" 
                    id="end_date" 
                    name="end_date" 
                    value="{{ request('end_date') }}"
                    class="shadow border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
        </div>

        <div class="flex space-x-2 justify-end">
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                Filter
            </button>
            <a href="{{ route('logs.overall') }}" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-gray-500">
                Reset
            </a>
        </div>
    </form>
</div>

<div class="overflow-x-auto">
    <table class="w-full table-auto">  
        <thead style="background-color: black;" class="bg-black text-white">
            <tr>
                <th class="px-4 py-2">No</th>
                <th class="px-4 py-2">User</th>
                <th class="px-4 py-2">Action</th>
                <th class="px-4 py-2">Description</th>
                <th class="px-4 py-2">IP Address</th>
                <th class="px-4 py-2">Created At</th>
            </tr>
        </thead>
        <tbody>
            @foreach($logs as $index => $log)
            <tr style="background-color:rgb(235, 235, 235);" class="hover:bg-gray-100">
                <td style="border:1px solid black;" class="px-4 py-2">{{ $logs->firstItem() + $index }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->user->email ?? 'N/A' }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->action }}</td>
                <td style="border:1px solid black; word-break: break-word;" class="px-4 py-2">{{ $log->description }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->ip_address }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->created_at }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <div class="mt-4 text-black">
        {{ $logs->appends(request()->except('page'))->links() }}
    </div>
</div>

@endsection