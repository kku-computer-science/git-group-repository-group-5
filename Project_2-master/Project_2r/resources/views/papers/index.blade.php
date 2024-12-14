@php
   if(Auth::user()->hasRole('admin')) {
      $layoutDirectory = 'dashboards.admins.layouts.admin-dash-layout';
   } else {
      $layoutDirectory = 'dashboards.users.layouts.user-dash-layout';
   }
@endphp

@extends($layoutDirectory)
@section('title','Dashboard')

@section('content')

<div class="container">
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-left">
                <h2>Paper</h2>
            </div>
            
        </div>
    </div>
    @if ($message = Session::get('success'))
    <div class="alert alert-success">
        <p>{{ $message }}</p>
    </div>
    @endif

    <table class="table table-bordered">
        <tr>
            <th>No</th>
            <th>paper_name</th>
            <th>paper_type</th>
            <th>paper_sourcetitle</th>
            <th>paper_url</th>
            <th>paper_yearpub</th>
            <th>paper_volume</th>
            <th>paper_issue</th>
            <th>paper_citation</th>
            <th>paper_page</th>
            <th>paper_doi</th>
            <th>author</th>
            
            
        </tr>
        @foreach ($papers as $paper)
        <tr>
            <td>{{ ++$i }}</td>
            <td>{{ $paper->paper_name }}</td>
            <td>{{ $paper->paper_type }}</td>
            <td>{{ $paper->paper_sourcetitle }}</td>
            <td>{{ $paper->paper_url }}</td>
            <td>{{ $paper->paper_yearpub }}</td>
            <td>{{ $paper->paper_volume }}</td>
            <td>{{ $paper->paper_issue }}</td>
            <td>{{ $paper->paper_citation }}</td>
            <td>{{ $paper->paper_page }}</td>
            <td>{{ $paper->paper_doi }}</td>
            <td>
                @foreach($paper->teacher as $teacher)      
                    {{ $teacher->fname}}  
                @endforeach
            </td>
        </tr>
        @endforeach
    </table>

    {!! $papers->links() !!}

</div>
@stop