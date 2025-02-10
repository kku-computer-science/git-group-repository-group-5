@extends('layouts.layout')
@section('content')
<div class="container refund">
    <p>โครงการวิจัย</p>

    <div class="row height d-flex justify-content-center align-items-center">
        <div class="search col-md-8">
            <div class="input-group">
                <input type="search" class="form-control rounded" placeholder="Search" aria-label="Search"
                    aria-describedby="search-addon" />
                <button type="button" class="btn btn-outline-primary"><i class="fa fa-search"></i> search</button>
            </div>
        </div>
    </div>

    <div class="container table">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th scope="col">ลำดับ</th>
                    <th scope="col">ประจำปีงบประมาณ</th>
                    <th scope="col">ระยะเวลาโครงการ</th>
                    <th scope="col">ประเภทโครการ</th>
                    <th scope="col">ชื่อโครงการ</th>
                    <th scope="col">ผู้รับผิดชอบโครงการ</th>
                    <th scope="col">งบประมาณ</th>
                    <th scope="col">แหล่งทุนวิจัย</th>
                    <th scope="col">สถานะ</th>
                    <th scope="col">หมายเหตุ</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td scope="row">1</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td scope="row">2</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>
    </div>

</div>
@stop