<?php

namespace App\Http\Controllers;

use App\Models\Author;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Paper;
use App\Models\Source_data;
use App\Models\Teacher;
use Illuminate\Support\Facades\Http;
class ScopuscallController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $data=User::all();
        foreach($data as $name) {

            $fname = substr($name['fname'],0,1);
            $lname = $name['lname'];
            $id    = $name['id'];

            $url = Http::get('https://api.elsevier.com/content/search/scopus?', [
                'query' => "AUTHOR-NAME("."$lname".","."$fname".")",
                'apikey'=> '6ab3c2a01c29f0e36b00c8fa1d013f83',
            ])->json();


            //$check=$url["search-results"]["entry"];
            $content=$url["search-results"]["entry"];


            $links=$url["search-results"]["link"];
            //print_r($links);
            do {
                $ref='prev';
                foreach($links as $link){
                    if($link['@ref'] =='next'){
                        $link2 = $link['@href'];
                        $link2 = Http::get("$link2")->json();
                        $links=$link2["search-results"]["link"];
                        $nextcontent=$link2["search-results"]["entry"];
                        foreach($nextcontent as $item) {
                            array_push($content,$item);
                        }
                    }
                }
            }while ($ref != 'prev');

            foreach($content as $item) {
                if(array_key_exists('error', $item)){
                    continue;
                }
                else{
                    if (Paper::where('paper_name', '=', $item['dc:title'])->first()==null){ //เช็คว่ามี paper นี้ในฐานข้อมูลหรือยัง ถ้ามี
                        $scoid=$item['dc:identifier'];
                        $scoid=explode(":", $scoid);
                        $scoid=$scoid[1];

                        $all = Http::get("https://api.elsevier.com/content/abstract/scopus_id/". $scoid."?filed=authors&apiKey=6ab3c2a01c29f0e36b00c8fa1d013f83&httpAccept=application%2Fjson");
                        $paper = new Paper;
                        $paper->paper_name = $item['dc:title'];
                        $paper->paper_type = $item['subtypeDescription'];
                        $paper->paper_sourcetitle = $item['prism:publicationName'];
                        //$paper->paper_issue=$item['prism:issueIdentifier'];
                        $paper->paper_url = $item['link'][2]['@href'];
                        $paper->paper_yearpub = $item['prism:coverDate'];
                        if(array_key_exists('prism:volume', $item)){
                            $paper->paper_volume = $item['prism:volume'];
                        }
                        else{
                            $paper->paper_volume = null;
                        }
                        if(array_key_exists('prism:issueIdentifier', $item)){
                            $paper->paper_issue = $item['prism:issueIdentifier'];
                        }
                        else{
                            $paper->paper_issue = null;
                        }
                        $paper->paper_citation = $item['citedby-count'];
                        $paper->paper_page = $item['prism:pageRange'];

                        if(array_key_exists('prism:doi', $item)){
                            $paper->paper_doi = $item['prism:doi'];

                        }else{
                            $paper->paper_doi = null;
                        }
                        $paper->save();
                        //$user = User::findOrFail($id);
                        $paper->teacher()->sync($id);

                        $source = Source_data::findOrFail(1);
                        $paper->source()->sync($source);

                        $all=$all['abstracts-retrieval-response']['authors']['author'];
                        foreach($all as $i){
                            if(Author::where('author_name', '=', $i['ce:indexed-name'])->first()==null){ //เช็คว่ามีชื่อผู้แต่งคนนี้มีหรือยังในฐานข้อมูล ถ้ายังให้
                                $author = new Author;
                                $author->author_name = $i['ce:indexed-name'];
                                $author->save();
                                $paper->author()->attach($author);
                                //$paper = Paper::find($paper);
                                //$paperid=$paper->id;
                                //$author->paper()->attach($paper);*/
                                //print_r($i['ce:indexed-name']);
                                //break;
                            }
                            else{
                                //break;
                                //continue; //ถ้ามีแล้วให้
                                $author = Author::where('author_name', '=', $i['ce:indexed-name'])->first();
                                $authorid=$author->id;
                                $paper->author()->attach($authorid);
                                //$user = User::find($id);
                            }
                        }
                    }

                    else{ //ถ้าไม่มี ให้ทำต่อไปนี้
                        $paper = Paper::where('paper_name', '=', $item['dc:title'])->first();
                        $paperid=$paper->id;
                        $user = User::find($id);

                        $hasTask = $user->paper()->where('paper_id', $paperid)->exists();//เช็คว่า  user คนนี้มี paper นี้หรือยัง ถ้ายังให้
                        if ($hasTask!=$paperid){ //ถ้าไม่เท่าให้
                            /*$user = new User;
                            $paper = Paper::find($paperid);
                            $$user->paper()->sync($paper);*/
                            $paper = Paper::find($paperid);
                            $paper->teacher()->attach($id);
                        }
                        else{
                            continue;
                        }
                    }
                }
            }

    }
    return 'succes';

}

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        /*$item = User::with('Paper')->findOrFail($id);
        return $item;*/
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
