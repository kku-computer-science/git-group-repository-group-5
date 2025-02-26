<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Dashboard</title>
    <base href="{{ \URL::to('/') }}">
    <link href="img/Newlogo.png" rel="shortcut icon" type="image/x-icon" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="{{ asset('plugins/ijaboCropTool/ijaboCropTool.min.css') }}">
    <!-- Theme style -->
    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

    <!-- plugins:css -->
    <link rel="stylesheet" href="{{asset('vendors/feather/feather.css')}}">
    <link rel="stylesheet" href="{{asset('vendors/mdi/css/materialdesignicons.min.css')}}">
    <link rel="stylesheet" href="{{asset('vendors/ti-icons/css/themify-icons.css')}}">
    <link rel="stylesheet" href="{{asset('vendors/typicons/typicons.css')}}">
    <link rel="stylesheet" href="{{asset('vendors/simple-line-icons/css/simple-line-icons.css')}}">
    <link rel="stylesheet" href="{{asset('vendors/css/vendor.bundle.base.css')}}">
    <!-- endinject -->
    <!-- Plugin css for this page -->
    <!-- <link rel="stylesheet" href="{{asset('vendors/datatables.net-bs4/dataTables.bootstrap4.css')}}"> -->
    <link rel="stylesheet" href="{{asset('js/select.dataTables.min.css')}}">
    <!-- End plugin css for this page -->
    <!-- inject:css -->
    <link rel="stylesheet" href="{{asset('css/styleadmin.css')}}">

    <!-- endinject -->
    <!-- <link rel="shortcut icon" href="images/favicon.png" /> -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"> </script> -->

    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.css" />
    <!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
</head>

<body>
    <div class="container-scroller sidebar-dark">
        <!-- navbar ข้างบน -->
        <nav class="navbar default-layout col-lg-12 col-12 p-0 fixed-top d-flex align-items-top flex-row">
            <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-start">
                <div class="me-3">
                    <button class="navbar-toggler navbar-toggler align-self-center" type="button" data-bs-toggle="minimize">
                        <span class="icon-menu"></span>
                    </button>
                </div>
            </div>
            <div class="navbar-menu-wrapper d-flex align-items-top">
                <ul class="navbar-nav">
                    <li class="nav-item font-weight-semibold d-none d-lg-block ms-0">
                        <h1 class="welcome-text">{{ trans('dashboard.welcome_text') }} <span class="text-black fw-bold"></span></h1>
                        <h3 class="welcome-sub-text">{{ trans('dashboard.welcome_subtext') }}</h3>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item d-none d-lg-block">
                        <div id="datepicker-popup" class="input-group date datepicker navbar-date-picker">
                            <span class="input-group-addon input-group-prepend border-right">
                                <span class="icon-calendar input-group-text calendar-icon"></span>
                            </span>
                            <input type="text" class="form-control">
                        </div>
                    </li>
                    <li class="nav-item">
                        <form class="search-form" action="#">
                            <i class="icon-search"></i>
                            <input type="search" class="form-control" placeholder="{{ trans('dashboard.search_here') }}" title="{{ trans('dashboard.search_here') }}">
                        </form>
                    </li>
                    <li class="nav-item d-none d-sm-inline-block">
                        <a class="nav-link" href="{{ route('logout') }}" onclick="event.preventDefault(); document.getElementById ('logout-form').submit();">
                            {{ trans('dashboard.logout') }} <i class="mdi mdi-logout"></i>
                        </a>
                        <form id="logout-form" action="{{ route('logout') }}" method="POST" class="d-none">
                            @csrf
                        </form>
                    </li>
                </ul>
            </div>
            <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-bs-toggle="offcanvas">
                <span class="mdi mdi-menu"></span>
            </button>
        </nav>
        <!-- navbar ข้างบน -->
        <div class="container-fluid page-body-wrapper">
            <nav class="sidebar sidebar-offcanvas" id="sidebar">
                <ul class="nav">
                    <li class="nav-item">
                        <a class="nav-link {{ (request()->is('dashboard*')) ? 'active' : '' }}" href="{{ route('dashboard')}}">
                            <i class="menu-icon mdi mdi-grid-large"></i>
                            <span class="menu-title">{{ trans('dashboard.dashboard') }}</span>
                        </a>
                    </li>
                    <li class="nav-item nav-category">{{ trans('dashboard.profile') }}</li>
                    <li class="nav-item">
                        <a class="nav-link {{ (request()->is('admin/profile*')) ? 'active' : '' }}" href="{{ route('profile')}}">
                            <i class="menu-icon mdi mdi-account-circle-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.user_profile') }}</span>
                        </a>
                    </li>
                    <li class="nav-item nav-category">{{ trans('dashboard.option') }}</li>
                    @can('funds-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('funds.index')}}">
                            <i class="menu-icon mdi mdi-file-document-box-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.manage_fund') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('projects-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('researchProjects.index')}}">
                            <i class="menu-icon mdi mdi-book-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.research_project') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('groups-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('researchGroups.index')}}">
                            <i class="menu-icon mdi mdi-view-dashboard-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.research_group') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('papers-list')
                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#ManagePublications" aria-expanded="false" aria-controls="ManagePublications">
                            <i class="menu-icon mdi mdi-book-open-page-variant"></i>
                            <span class="menu-title">{{ trans('dashboard.manage_publications') }}</span>
                            <i class="menu-arrow"></i>
                        </a>
                        <div class="collapse" id="ManagePublications">
                            <ul class="nav flex-column sub-menu">
                                <li class="nav-item"> <a class="nav-link" href="{{ route('papers.index')}}">{{ trans('dashboard.published_research') }}</a></li>
                                <li class="nav-item"> <a class="nav-link" href="/books">{{ trans('dashboard.book') }}</a></li>
                                <li class="nav-item"> <a class="nav-link" href="/patents">{{ trans('dashboard.patents') }}</a></li>
                            </ul>
                        </div>
                    </li>
                    @endcan
                    @can('export')
                    <li class="nav-item">
                        <a class="nav-link" href="{{route('exportfile')}}">
                            <i class="menu-icon mdi mdi-file-export"></i>
                            <span class="menu-title">{{ trans('dashboard.export') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('user-list')
                    <li class="nav-item nav-category">{{ trans('dashboard.admin') }}</li>
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('users.index')}}">
                            <i class="menu-icon mdi mdi-account-multiple-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.users') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('role-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('roles.index')}}">
                            <i class="menu-icon mdi mdi-chart-gantt"></i>
                            <span class="menu-title">{{ trans('dashboard.roles') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('permission-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('permissions.index')}}">
                            <i class="menu-icon mdi mdi-checkbox-marked-circle-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.permission') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('departments-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('departments.index')}}">
                            <i class="menu-icon mdi mdi-animation-outline"></i>
                            <span class="menu-title">{{ trans('dashboard.departments') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('programs-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('programs.index')}}">
                            <i class="menu-icon mdi mdi-format-list-bulleted"></i>
                            <span class="menu-title">{{ trans('dashboard.manage_programs') }}</span>
                        </a>
                    </li>
                    @endcan
                    @can('expertises-list')
                    <li class="nav-item">
                        <a class="nav-link" href="{{ route('experts.index')}}">
                            <i class="menu-icon mdi mdi-buffer"></i>
                            <span class="menu-title">{{ trans('dashboard.manage_expertise') }}</span>
                        </a>
                    </li>
                    @endcan
                    @role('admin')
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="{{ route('logs.overall') }}">
                            <i class="menu-icon mdi mdi-monitor-multiple"></i>
                            <span class="menu-title">{{ trans('dashboard.logs_system') }}</span>
                        </a>
                    </li>
                    @endrole
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
                </ul>
            </nav>

            <div class="main-panel">
                <div class="content-wrapper">
                    @yield('content')
                </div>
                <footer class="footer">
                    <div class="d-sm-flex justify-content-center justify-content-sm-between">
                    </div>
                </footer>
            </div>
        </div>
    </div>
    <!-- scripts -->
    <script src="{{asset('vendors/js/vendor.bundle.base.js')}}"></script>
    <script src="{{asset('js/dashboard.js')}}"></script>
    <script src="{{ asset('plugins/ijaboCropTool/ijaboCropTool.min.js') }}"></script>
</body>

</html>