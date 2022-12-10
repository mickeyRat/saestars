    var d=document;
    var sid = $.cookie('SID');
    var loading = '<center class="center-screen "><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Loading...</span></center>';

$( d ).ready(function(){
    var url_string = window.location.href;
    var url = new URL(url_string);
    var fileID = url.searchParams.get("fileID");
    viewDocument(fileID);
});
function viewDocument(fileID){
    var eventIDX = $.cookie('LOCATION');
    console.log(fileID);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/read.pl',
        data: {'do':'viewDocument','act':'print','fileID':fileID,'eventIDX':eventIDX},
        success: function(str){
            bigFrame=$('#borderlessFrame');
            var obj = JSON.parse( str );
            console.log(obj.TX_FOLDER);
            bigFrame.attr('src', obj.TX_FOLDER);
            d.title=obj.IN_NUMBER + "-" + obj.TX_PAPER;
            // $('#main').html(str);
        }
        // error: function(XMLHttpRequest, textStatus, errorThrown) { console.log(XMLHttpRequest); }
    });
}

