var d=document;
var now = new Date();
var time = now.getTime();
// SECTION
$( d ).ready(function(){
    var location = $.cookie('LOCATION');
    // console.log(location);
    // alert(location);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'loadEventLocation','act':'print','location':location},
        success: function(str){
            $('#locationDiv').html(str);
        }
    });    
});
function expandInstructions(objName){
    $('#UPLOAD_INSTRUCTIONS').toggleClass('w3-hide');
    // alert("test");
}