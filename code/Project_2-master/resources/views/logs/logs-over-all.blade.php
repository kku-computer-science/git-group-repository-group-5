@extends('logs.layout.logs-menu')
@section('title','Dashboard')

@section('content')

<h3 class="mt-3 text-xl font-semibold">Overall</h3>
<br>

<!-- ปุ่ม Export Logs -->
<div class="mb-4">
    <a href="{{ route('logs.export', ['format' => 'csv']) }}" class="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600">
        Export CSV
    </a>
    <a href="{{ route('logs.export', ['format' => 'json']) }}" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
        Export JSON
    </a>
</div>

<div class="table-responsive">
    <table class="min-w-full table-auto shadow-md rounded-lg overflow-hidden">
        <thead style="background-color:#000000;" class="text-white">
            <tr>
                <th style="border: 1px solid #000000;" class="py-3 px-4 text-left">No</th>
                <th class="py-3 px-4 text-left">User</th>
                <th class="py-3 px-4 text-left">Action</th>
                <th class="py-3 px-4 text-left">Description</th>
                <th class="py-3 px-4 text-left">IP Address</th>
                <th class="py-3 px-4 text-left">Created At</th>
            </tr>
        </thead>

        <tbody>
            @foreach ($logs as $log)
            <tr class="border-b hover:bg-gray-50">
                <td style="border: 1px solid rgb(185, 185, 185);" class="py-3 px-4">{{ ($logs->currentPage() - 1) * $logs->perPage() + $loop->iteration }}</td>
                <td style="border: 1px solid rgb(185, 185, 185)" class="py-3 px-4">{{ $log->user->email ?? 'N/A' }}</td>
                <td style="border: 1px solid rgb(185, 185, 185)" class="py-3 px-4">{{ $log->action }}</td>
                <td style="border: 1px solid rgb(185, 185, 185)" class="py-3 px-4">{{ $log->description }}</td>
                <td style="border: 1px solid rgb(185, 185, 185)" class="py-3 px-4">{{ $log->ip_address }}</td>
                <td style="border: 1px solid rgb(185, 185, 185)" class="py-3 px-4">{{ $log->created_at->format('Y-m-d H:i:s') }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>

    <div class="mt-4 text-black">
        {{ $logs->links() }} <!-- Pagination -->
    </div>
</div>

@endsection
