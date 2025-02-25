@extends('dashboards.users.layouts.user-dash-layout')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-left">
                <h2>{{ translateText('Research Project') }}</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-success" href="{{ route('researchProjects.create') }}">{{ translateText('Create New Research Project') }}</a>
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
            <th>{{ translateText('No') }}</th>
            <th>{{ translateText('Project_name_TH') }}</th>
            <th>{{ translateText('Project_name_EN') }}</th>
            <th>{{ translateText('Project_start') }}</th>
            <th>{{ translateText('Project_end') }}</th>
            <th>{{ translateText('Funder') }}</th>
            <th>{{ translateText('Budget') }}</th>
            <th>{{ translateText('Note') }}</th>
            <th>{{ translateText('Head') }}</th>
            <th>{{ translateText('Member') }}</th>
            <th width="280px">{{ translateText('Action') }}</th>
        </tr>
        @foreach ($researchProjects as $researchProject)
        <tr>
            <td>{{ ++$i }}</td>
            <td>{{ $researchProject->Project_name_TH }}</td>
            <td>{{ $researchProject->Project_name_EN }}</td>
            <td>{{ $researchProject->Project_start }}</td>
            <td>{{ $researchProject->Project_end }}</td>
            <td>{{ $researchProject->Funder }}</td>
            <td>{{ $researchProject->Budget }}</td>
            <td>{{ $researchProject->Note }}</td>
            <td>
                @foreach($researchProject->user as $user)
                @if ( $user->pivot->role == 1)
                    @if(app()->getLocale()=='th')
                    {{ $user->fname_th }}
                    @else
                    {{ $user->fname_en }}
                    @endif
                @endif
                @endforeach
            </td>
            <td>
                @foreach($researchProject->user as $user)
                @if ( $user->pivot->role == 2)
                    {{ $user->fname }}
                @endif
                @endforeach
            </td>
            <td>
                <form action="{{ route('researchProjects.destroy',$researchProject->id) }}" method="POST">

                    <a class="btn btn-info" href="{{ route('researchProjects.show',$researchProject->id) }}">{{ translateText('Show') }}</a>
                    @can('editResearchProject')
                    <a class="btn btn-primary" href="{{ route('researchProjects.edit',$researchProject->id) }}">{{ translateText('Edit') }}</a>
                    @endcan

                    @csrf
                    @method('DELETE')
                    @can('deleteResearchProject')
                    <button type="submit" class="btn btn-danger">{{ translateText('Delete') }}</button>
                    @endcan
                </form>
            </td>
        </tr>
        @endforeach
    </table>

    {!! $researchProjects->links() !!}

</div>
@stop
