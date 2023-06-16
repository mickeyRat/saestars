var d=document;
var now = new Date();
var time = now.getTime();
var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';

// -----------------------------------------------------------------------------------------------------------
// 2023
function attend_viewSummary(o) {
	$.modal('Event Attendance Summary','50%');
    var ajxData = {};
    ajxData['do'] = 'attend_viewSummary';
    ajxData['act'] = 'print';
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/attend.pl',
        data: ajxData,
        success: function(str){
        	$('#modal_content').html(str);
        }
    });
}
function attend_saveCheckIn(o, teamIDX, boAttend) {
	var inCount = $('#IN_COUNT').val();

	var ajxData = {};
	var data = {};
	if (boAttend==1) {
		if (!inCount ||  inCount ==0){	
			alert("Please enter the number of team member(s) in Attendance");
			$('#IN_COUNT').focus();
			return;
		} else {
			data.IN_COUNT       = inCount;
		}
	} else {
		data.IN_COUNT       = 0;
	}
    data.BO_ATTEND      = boAttend;
	ajxData['do']       = 'attend_saveCheckIn';
    ajxData['act']      = 'print';
    ajxData['teamIDX']  = teamIDX;
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    ajxData['status']   = boAttend;
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/attend.pl',
        data: ajxData,
        success: function(str){
            // var obj = JSON.parse(str);
        	// $('#bar_'+teamIDX).replaceWith(obj.BAR);
        	channel.publish('sae_ps_checkInTeamStatus', str);
        	$(o).close();
        }
    });
}
function attend_CheckIn(o, teamIDX, inNumber) {
	    // if a modal window is needed, uncomment the line below.
    $.modal('Check-In - Team: #' + pad(inNumber,3),'50%');
    
    var ajxData = {};
    ajxData['do'] = 'attend_CheckIn';
    ajxData['act'] = 'print';
    ajxData['teamIDX'] = teamIDX;
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/attend.pl',
        data: ajxData,
        success: function(str){
        	$('#modal_content').html(str);
        },
        complete: function(){
        	$('#IN_COUNT').focus();
        }
    });
}
function attend_openTeamList(o) {
	$('#mainPageContent').html(loading);
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/attend.pl',
        // url: '../cgi-bin/main2.pl',
        data: {'do':'attend_openTeamList','act':'print','eventIDX':eventIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}