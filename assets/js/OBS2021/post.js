    var d=document;
    var sid = $.cookie('SID');

$( d ).ready(function(){
    var url_string = window.location.href;
    var url = new URL(url_string);
    var fileID = url.searchParams.get("fileID");
    viewPostResults(fileID);
});
function viewPostResults(fileID){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/post.pl',
        data: {'do':'viewPostResults','act':'print','fileID':fileID,'location':location},
        success: function(str){
            $('#main').html(str);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
    }
    });
}

function sae_toggleView(obj){
    $('.'+obj).toggleClass("w3-hide");
}