<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Home</title>
    
    <link href="{{ asset('css/app.css') }}" rel="stylesheet">
    <script src="{{ asset('js/app.js') }}" defer></script>

    <link rel="stylesheet" href="{{asset('vendor/bootstrap/css/bootstrap.min.css')}}">
    <script src="{{asset('js/jquery-3.6.0.min.js')}}"></script>

    <link rel="stylesheet" href="{{asset('css/style.css')}}">
    <script src="{{asset('vendor/bootstrap/js/bootstrap.min.js')}}"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    

</head>

<body>


    <!-- Navigation -->
    <nav id="navbarExample" class="navbar navbar-expand-lg navbar-light" aria-label="Main navigation">
        <div class="container">
            <a class="navbar-brand logo-image" href="#"><img src="{{asset('img/logo.png')}}" alt="alternative"></a>
            <button class="navbar-toggler p-0 border-0" type="button" id="navbarSideCollapse"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="navbar-collapse offcanvas-collapse" id="navbarsExampleDefault">
                <ul class="navbar-nav ms-auto navbar-nav-scroll">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="/home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/researchers">Researchers</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/researchproject">Research Project</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/researchgroup">Research Group</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/reports">Reports</a>
                    </li>
                </ul>
                <span class="nav-item">
                    <a class="btn-solid-sm" href="/">Login</a>
                </span>
            </div> <!-- end of navbar-collapse -->
        </div> <!-- end of container -->
    </nav> <!-- end of navbar -->
    <!-- end of navigation -->
    @yield('content')

</body>

</html>