    var d=document;
    var sid = $.cookie('SID');

$( d ).ready(function(){
    var url_string = window.location.href;
    var url = new URL(url_string);
    var teamIDX = url.searchParams.get("teamIDX");
    var source = url.searchParams.get("source");
    // var doc = url.searchParams.get("doc");
    // var rnd = url.searchParams.get("rnd");
//    alert(rnd);
    viewMyScoreCard(teamIDX, source);
    // $('#main').html("Hello World for FileID = <u>"+fileID+"</u>");
});
function viewMyScoreCard(teamIDX, source){
    var location = $.cookie('LOCATION');
//     alert(doc);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/score.pl',
        data: {'do':'viewMyScoreCard','act':'print','teamIDX':teamIDX,'location':location,'source':source},
        success: function(str){
//             alert(str);
            $('#main').html(str);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
//         alert("Status: " + textStatus); alert("Error: " + errorThrown);
    }
    });
}

