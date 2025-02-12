@extends('logs.layout.logs-menu')
@section('title', 'Dashboard')

@section('content')
<div class="container mx-auto px-4">
    <h3 class="mb-3 font-semibold">Over all</h3>

    <!-- Chart Section -->
    <div class="mb-5 bg-white p-4 rounded-lg shadow">
        <canvas id="logChart" height="100"></canvas>
    </div>

    <div class="mb-6">
        <form action="{{ route('logs.overall') }}" method="GET" class="space-y-4">
            <div class="flex flex-wrap gap-4">
                <div class="w-full md:w-1/2">
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

                <div class="w-full md:w-1/2">
                    <label for="selected_date" class="block text-gray-700 font-bold mb-2">Select Date :</label>
                    <input
                        type="date"
                        id="selected_date"
                        name="selected_date"
                        value="{{ request('selected_date', date('Y-m-d')) }}"
                        class="mb-2 border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="w-full md:w-1/2">
                    <label for="per_page" class="text-gray-700 font-bold mb-3">Records per page:</label>
                    <select name="per_page" id="per_page" class="border rounded py-1 px-3" onchange="this.form.submit()">
                        <option value="10" {{ request('per_page') == 10 ? 'selected' : '' }}>10</option>
                        <option value="25" {{ request('per_page') == 25 ? 'selected' : '' }}>25</option>
                        <option value="50" {{ request('per_page') == 50 ? 'selected' : '' }}>50</option>
                        <option value="100" {{ request('per_page') == 100 ? 'selected' : '' }}>100</option>
                    </select>
                </div>
            </div>

            <div class="flex space-x-2 justify-end mb-2">
                <button type="submit" style="text-decoration: none;" class="bg-blue-500 hover:bg-blue-700 text-black font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                    Filter
                </button>
                <a href="{{ route('logs.overall') }}" style="text-decoration: none;" class="bg-gray-500 hover:bg-gray-700 text-black font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-gray-500">
                    Reset
                </a>
                <a href="{{ route('logs.export', ['format' => 'csv'] + request()->query()) }}" style="text-decoration: none;" class="bg-green-500 hover:bg-green-700 text-black font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-green-500">
                    Export CSV
                </a>
                <a href="{{ route('logs.export', ['format' => 'json'] + request()->query()) }}" style="text-decoration: none;" class="bg-yellow-500 hover:bg-yellow-700 text-black font-bold py-2 px-4 rounded focus:outline-none focus:ring-2 focus:ring-yellow-500">
                    Export JSON
                </a>
            </div>
    </div>

    </form>
</div>

<!-- Table Section -->
<div class="overflow-x-auto fs-6">
    <table class="w-full ">
        <thead style="background-color: black;" class="bg-black text-white">
            <tr>
                <th class="px-4 py-2 w-1/2">
                    <a style="color:white; text-decoration:none;" href="{{ route('logs.overall', ['sort' => 'id', 'direction' => request('direction') === 'asc' ? 'desc' : 'asc'] + request()->query()) }}" class="hover:underline">
                        No @if(request('sort') === 'id') @endif
                    </a>
                </th>

                <th class="px-4 py-2">
                    <a style="color:white; text-decoration:none;" href="{{ route('logs.overall', ['sort' => 'user', 'direction' => request('direction') === 'asc' ? 'desc' : 'asc'] + request()->query()) }}" class="hover:underline">
                        User
                        <span>{{ request('sort') === 'user' ? '' : '' }}</span>

                    </a>
                </th>

                <th class="px-4 py-2">
                    <a style="color:white; text-decoration:none;" href="{{ route('logs.overall', ['sort' => 'action', 'direction' => request('direction') === 'asc' ? 'desc' : 'asc'] + request()->query()) }}" class="hover:underline">
                        Action
                        <span>{{ request('sort') === 'action' ? '' : ''}}</span>
                    </a>
                </th>

                <th class="px-4 py-2">
                    <a style="color:white; text-decoration:none;" href="{{ route('logs.overall', ['sort' => 'description', 'direction' => request('direction') === 'asc' ? 'desc' : 'asc'] + request()->query()) }}" class="hover:underline">
                        Description
                        <span>{{ request('sort') === 'description' ? '' : '' }}</span>
                    </a>
                </th>

                <th class="px-4 py-2">
                    <a style="color:white; text-decoration:none;" href="{{ route('logs.overall', ['sort' => 'ip_address', 'direction' => request('direction') === 'asc' ? 'desc' : 'asc'] + request()->query()) }}" class="hover:underline">
                        IP Address
                        <span>{{ request('sort') === 'ip_address' ? '' : ''}}</span>
                    </a>
                </th>

                <th class="px-4 py-2">
                    <a style="color:white; text-decoration:none;" href="{{ route('logs.overall', ['sort' => 'created_at', 'direction' => request('direction') === 'asc' ? 'desc' : 'asc'] + request()->query()) }}" class="hover:underline">
                        Date <span>{{ request('sort') === 'created_at' ? '' : ''}}</span>
                    </a>
                </th>
            </tr>
        </thead>

        <tbody>
            @foreach($logs as $index => $log)
            <tr style="background-color:rgb(235, 235, 235);" class="hover:bg-gray-100">
                <td style="border:1px solid black;" class="px-4 py-2">{{ $logs->firstItem() + $index }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->user->email ?? 'N/A' }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->action }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->description }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->ip_address }}</td>
                <td style="border:1px solid black;" class="px-4 py-2">{{ $log->created_at }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>


</div>

<div class="mt-4">
    {{ $logs->appends(['per_page' => request('per_page'), 'selected_date' => request('selected_date')])->links() }}
</div>



<br>


<!-- Chart Script -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const data = @json($logsData);

        new Chart(document.getElementById('logChart'), {
            type: 'line',
            data: {
                labels: data.map(item => `${String(item.hour).padStart(2, '0')}:00`),
                datasets: [{
                    label: 'จำนวนการเข้าใช้งานระบบ (รายชั่วโมง)',
                    data: data.map(item => item.count),
                    fill: true,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1,
                    datalabels: {
                        align: 'top',
                        color: 'black',
                        font: {
                            weight: 'bold',
                            size: 12
                        },
                        formatter: function(value) {
                            return value;
                        }
                    }
                }]
            },
            // ตัวอย่างการเพิ่มชื่อแกนในกราฟ
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            font: {
                                size: 14
                            }
                        }
                    },
                    title: {
                        display: true,
                        text: 'จำนวนการเข้าใช้งานระบบตามช่วงเวลา',
                        font: {
                            size: 16,
                            weight: 'bold'
                        },
                        padding: 20
                    },
                    datalabels: {
                        display: true,
                        color: 'black',
                        font: {
                            weight: 'bold',
                            size: 12
                        }
                    }
                },
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: 'เวลา (ชั่วโมง)', // เพิ่มชื่อแกน x ที่นี่
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            padding: {
                                top: 10
                            }
                        },
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            font: {
                                size: 12
                            }
                        }
                    },
                    y: {
                        title: {
                            display: true,
                            text: 'จำนวนครั้งที่เข้าใช้งาน', // เพิ่มชื่อแกน y ที่นี่
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            padding: {
                                bottom: 10
                            }
                        },
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1,
                            font: {
                                size: 12
                            }
                        },
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.1)'
                        }
                    }
                }
            }

        });
    });
</script>



@endsection