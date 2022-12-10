    var d=document;
    var sid = $.cookie('SID');

function showEventList(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/event.pl',
        data: {'do':'showEventList','act':'print','location':$.cookie('LOCATION')},
        success: function(str){
            $('#main').html(str);
            $('#pageTitle').html('STARS - Event Administration');
            $('#backButton').off('click').on('click', function(){
                window.location.href="admin.html";
            }).show();
        }
    });
}
function showAddNewEvent(){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/event.pl',
        data: {'do':'showAddNewEvent','act':'print'},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function addNewEvent(){
    var TxEventName = $('#TX_EVENT_NAME').val();
    var InYear = $('#IN_YEAR').val();
    var TxEventCity = $('#TX_EVENT_CITY').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/event.pl',
        data: {'do':'addNewEvent','act':'print','TxEventName':TxEventName,'InYear':InYear ,'TxEventCity':TxEventCity},
        success: function(str){
            $('#TABLE_EVENT').append(str);
            closeModal('id01');
        }
    });
}
function editEventDetails(PkEventIdx){
        $('#id01').show();
        $.ajax({
        type: 'POST',
        url: '../cgi-bin/event.pl',
        data: {'do':'editEventDetails','act':'print','PkEventIdx':PkEventIdx},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function deleteEvent(PkEventIdx){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/event.pl',
        data: {'do':'deleteEvent','act':'print','PkEventIdx':PkEventIdx},
        success: function(str){
            deleteDiv('DIV_EDIT_EVENT');
            $('#TR_EVENT_ROW_'+PkEventIdx).remove();
            deleteDiv('DIV_EDIT_EVENT');
        }
    });
}
function updateEventDetails(PkEventIdx){
    var TxEventName = $('#TX_EVENT_NAME').val();
    var InYear = $('#IN_YEAR').val();
    var TxEventCity = $('#TX_EVENT_CITY').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/event.pl',
        data: {'do':'updateEventDetails','act':'print','TxEventName':TxEventName,'InYear':InYear ,'TxEventCity':TxEventCity,'PkEventIdx':PkEventIdx},
        success: function(str){
            var obj = JSON.parse(str);
            $('#TD_TX_EVENT_NAME_'+PkEventIdx).html(obj.TX_EVENT_NAME);
            $('#TD_IN_YEAR_'+PkEventIdx).html(obj.IN_YEAR);
            $('#TD_TX_EVENT_CITY_'+PkEventIdx).html(obj.TX_EVENT_CITY);
            closeModal('id01');
        }
    });
}
function selectEvent(PkEventIdx, TxEventName, InYear){
    $('#CURRENT_LOCATION').html(TxEventName+' ('+InYear+')');
    $.cookie('LOCATION',PkEventIdx);
    alert("EVENT SET\n\n"+TxEventName+" ("+InYear+")");
}


