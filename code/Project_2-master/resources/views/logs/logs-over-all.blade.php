@extends('logs.layout.logs-menu')
@section('title', 'Dashboard')

@section('content')
<div class="container mx-auto px-4">
    <h3 class="mt-3 text-xl font-semibold">Overall</h3>

    <!-- Chart Section -->
    <div class="mb-5 bg-white p-4 rounded-lg shadow">
        <canvas id="logChart" height="100"></canvas>
    </div>

    <!-- Table Section -->
    <div class="overflow-x-auto">
        <table class="w-full">
            <thead style="background-color: black;" class="bg-black text-white">
                <tr>
                    <th class=" px-4 py-2">No</th>
                    <th class=" px-4 py-2">User</th>
                    <th class=" px-4 py-2">Action</th>
                    <th class=" px-4 py-2">Description</th>
                    <th class=" px-4 py-2">IP Address</th>
                    <th class=" px-4 py-2">Created At</th>
                </tr>
            </thead>
            <tbody>
                @foreach($logs as $index => $log)
                <tr style="background-color:rgb(235, 235, 235);" class="hover:bg-gray-100">
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $logs->firstItem() + $index }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->user->email ?? 'N/A' }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->action }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->description }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->ip_address }}</td>
                    <td style="border:1px solid black;" class=" px-4 py-2">{{ $log->created_at }}</td>
                </tr>
                @endforeach
            </tbody>

        </table>
    </div>

    <!-- Pagination -->
    <div class="mt-4">
        {{ $logs->links() }}
    </div>
</div>

<!-- Chart Script -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const data = @json($logsData);

        new Chart(document.getElementById('logChart'), {
            type: 'line',
            data: {
                labels: data.map(item => `${String(item.hour).padStart(2, '0')}:00`),
                datasets: [{
                    label: 'จำนวนการเข้าใช้งานระบบ',
                    data: data.map(item => item.count),
                    fill: true,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'จำนวนการเข้าใช้งานระบบตามช่วงเวลา'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
    });
</script>
@endsection