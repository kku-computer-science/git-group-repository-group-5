<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>@yield('title')</title>
  <base href="{{ \URL::to('/') }}">

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/adminlte.min.css">

  <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

</head>

<body class="sidebar-mini layout-fixed text-sm">
  <div class="wrapper">

    <!-- Navbar -->
    <nav class="main-header navbar navbar-expand navbar-dark navbar-light">
      <!-- Left navbar links -->
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
        </li>
        <li class="nav-item d-none d-sm-inline-block">
          <a class="nav-link" href="{{ route('logout') }}" onclick="event.preventDefault();
                            document.getElementById('logout-form').submit();">
            {{ __('Logout') }}
          </a>

          <form id="logout-form" action="{{ route('logout') }}" method="POST" class="d-none">
            @csrf
          </form>
        </li>
      </ul>


    </nav>
    <!-- /.navbar -->

    <!-- Main Sidebar Container -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
      <!-- Brand Logo -->
      <a href="{{ \URL::to('/')}}" class="brand-link">
        <img src="dist/img/AdminLTELogo.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
        <span class="brand-text font-weight-light">Your Site</span>
      </a>

      <!-- Sidebar -->
      <div class="sidebar">
        <!-- Sidebar user panel (optional) -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
          <div class="image">
            <img src="{{ Auth::user()->picture }}" class="img-circle elevation-2 admin_picture" alt="User Image">
          </div>
          <div class="info">
            <a href="#" class="d-block admin_name">{{ Auth::user()->name }}</a>
          </div>
        </div>



        <!-- Sidebar Menu -->
        <nav class="mt-2">
          <ul class="nav nav-pills nav-sidebar flex-column nav-legacy nav-compact nav-child-indent nav-collapse-hide-child nav-flat" data-widget="treeview" role="menu" data-accordion="false">
            <!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->
            <li class="nav-item">
              <a href="{{ route('dashboard')}}" class="nav-link {{ (request()->is('dashboard*')) ? 'active' : '' }}">
                <i class="nav-icon fas fa-home"></i>
                <p>
                  Dashboard
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="{{ route('profile')}}" class="nav-link {{ (request()->is('profile*')) ? 'active' : '' }}">
                <i class="nav-icon fas fa-user"></i>
                <p>
                  Profile
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="{{ route('settings')}}" class="nav-link {{ (request()->is('settings*')) ? 'active' : '' }}">
                <i class="nav-icon fas fa-cog"></i>
                <p>
                  Settings
                </p>
              </a>
            </li>

            <li class="nav-item has-treeview">
              <a href="#" class="nav-link">
                <i class="nav-icon fas fa-edit"></i>
                <p>
                  Option
                  <i class="right fas fa-angle-left"></i>
                </p>
              </a>
              <ul class="nav nav-treeview">
                <li class="nav-item">
                  <a href="{{ route('funds.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Manage Fund</p>
                  </a>
                </li>
                <li class="nav-item has-treeview">
                  <a href="#" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>
                      Level 2
                      <i class="right fas fa-angle-left"></i>
                    </p>
                  </a>
                  <ul class="nav nav-treeview">
                    <li class="nav-item">
                      <a href="#" class="nav-link">
                        <i class="far fa-dot-circle nav-icon"></i>
                        <p>Level 3</p>
                      </a>
                    </li>
                    <li class="nav-item">
                      <a href="#" class="nav-link">
                        <i class="far fa-dot-circle nav-icon"></i>
                        <p>Level 3</p>
                      </a>
                    </li>
                    <li class="nav-item">
                      <a href="#" class="nav-link">
                        <i class="far fa-dot-circle nav-icon"></i>
                        <p>Level 3</p>
                      </a>
                    </li>
                  </ul>
                </li>
                <li class="nav-item">
                  <a href="{{ route('researchProjects.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Research Project</p>
                  </a>
                </li>
                @can('user-list')
                <li class="nav-item">
                  <a href="{{ route('users.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Users</p>
                  </a>
                </li>
                @endcan
                @can('role-list')
                <li class="nav-item">
                  <a href="{{ route('roles.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Roles</p>
                  </a>
                </li>
                @endcan
                @can('permission-list')
                <li class="nav-item">
                  <a href="{{ route('permissions.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Permission</p>
                  </a>
                </li>
                @endcan
                @can('post-list')
                <li class="nav-item">
                  <a href="{{ route('posts.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Posts</p>
                  </a>
                </li>
                @endcan
                @can('departments-list')
                <li class="nav-item">
                  <a href="{{ route('departments.index')}}" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>Departments</p>
                  </a>
                </li>
                @endcan
              </ul>
            </li>
          </ul>
        </nav>
        <!-- /.sidebar-menu -->
      </div>
      <!-- /.sidebar -->
    </aside>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
      @yield('content')
    </div>
    <!-- /.content-wrapper -->

    <!-- Control Sidebar -->
    <aside class="control-sidebar control-sidebar-dark">
      <!-- Control sidebar content goes here -->
      <div class="p-3">
        <h5>Title</h5>
        <p>Sidebar content</p>
      </div>
    </aside>
    <!-- /.control-sidebar -->

    <!-- Main Footer -->
  <footer class="main-footer">
    <!-- To the right -->
    <div class="float-right d-none d-sm-inline">
      Anything you want
    </div>
    <!-- Default to the left -->
    <strong>Copyright &copy; 2014-2021 <a href="https://adminlte.io">AdminLTE.io</a>.</strong> All rights reserved.
  </footer>
</div>
<!-- ./wrapper -->

<!-- REQUIRED SCRIPTS -->

<!-- jQuery -->
<script src="plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="dist/js/adminlte.min.js"></script>


  
  <!-- Select2 JS -->
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>
  @yield('javascript')
</body>
</html>



  {{-- CUSTOM JS CODES --}}
  <script>
    $(function() {

          $.ajaxSetup({
            headers: {
              'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
          });

          $(function() {

            /* UPDATE ADMIN PERSONAL INFO */

            $('#AdminInfoForm').on('submit', function(e) {
              e.preventDefault();

              $.ajax({
                url: $(this).attr('action'),
                method: $(this).attr('method'),
                data: new FormData(this),
                processData: false,
                dataType: 'json',
                contentType: false,
                beforeSend: function() {
                  $(document).find('span.error-text').text('');
                },
                success: function(data) {
                  if (data.status == 0) {
                    $.each(data.error, function(prefix, val) {
                      $('span.' + prefix + '_error').text(val[0]);
                    });
                  } else {
                    $('.admin_name').each(function() {
                      $(this).html($('#AdminInfoForm').find($('input[name="name"]')).val());
                    });
                    alert(data.msg);
                  }
                }
              });
            });



            $(document).on('click', '#change_picture_btn', function() {
              $('#admin_image').click();
            });


            $('#admin_image').ijaboCropTool({
              preview: '.admin_picture',
              setRatio: 1,
              allowedExtensions: ['jpg', 'jpeg', 'png'],
              buttonsText: ['CROP', 'QUIT'],
              buttonsColor: ['#30bf7d', '#ee5155', -15],
              processUrl: '{{ route("adminPictureUpdate") }}',
              // withCSRF:['_token','{{ csrf_token() }}'],
              onSuccess: function(message, element, status) {
                alert(message);
              },
              onError: function(message, element, status) {
                alert(message);
              }
            });


            $('#changePasswordAdminForm').on('submit', function(e) {
              e.preventDefault();

              $.ajax({
                url: $(this).attr('action'),
                method: $(this).attr('method'),
                data: new FormData(this),
                processData: false,
                dataType: 'json',
                contentType: false,
                beforeSend: function() {
                  $(document).find('span.error-text').text('');
                },
                success: function(data) {
                  if (data.status == 0) {
                    $.each(data.error, function(prefix, val) {
                      $('span.' + prefix + '_error').text(val[0]);
                    });
                  } else {
                    $('#changePasswordAdminForm')[0].reset();
                    alert(data.msg);
                  }
                }
              });   
            });


          });
        });
  </script>
</body>

</html>