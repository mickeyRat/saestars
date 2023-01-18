// {
//     var d=document;
//     var sid = $.cookie('SID');
//     var obj = new Object();
//     var emailFlag=0;
//     var menuData = new Object();
//     var now = new Date();
//     var time = now.getTime();
// }


function test(o){
    if(!event.detail || event.detail == 1){
        console.log("True");
        o.disabled = 'disabled';
        $(o).html('Submitting...')
        return true;
    }
    else { 
        console.log("False");
        return false;
    }

}
function sae_cancelChangeTemporaryPassword(o){
    signOutAdmin();
    $(o).close();
}
function showSetEventLocation(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showSetEventLocation','act':'print'},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function setEventLocation(){
    var eventIDX = $('#sae_eventSelection :selected').val();
    $.cookie('LOCATION',eventIDX);
    window.location.href="main.html";
}
function resetPassword(){
    var txEmail = $('#NewTxEmail').val();
    if (isEmpty(txEmail)){
        console.log("No Email Address Provided");
        alert("No Email Address Provided.  Your temporary password request was canceled.");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'resetPassword','act':'print','txEmail':txEmail},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}


