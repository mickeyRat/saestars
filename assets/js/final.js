    var d=document;
    var sid = $.cookie('SID');

$( d ).ready(function(){
    var url_string = window.location.href;
    var url = new URL(url_string);
    var PkClassIdx = url.searchParams.get("class");
    var PkClassIdx = url.searchParams.get("class");
    showPublishedResults(fileID);
//
