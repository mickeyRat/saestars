// Development Code:  Need to refresh daily
// var ably = new Ably.Realtime('1WChTA.5TQf5A:v6P7xpRE_pR7SZSj');
// Production Code:
var ably = new Ably.Realtime('Nb0s7g.hR-IhA:KamYhyJ4pzpj1gUm');
var channel = ably.channels.get('saeaerodesign');

// Subscriptions
channel.subscribe('sae_flightLogs_checkoutCard', function(message) {ps_checkoutCard(message.data);});
channel.subscribe('sae_flightLogs_cancelFlight', function(message) {ps_cancel(message.data);});
channel.subscribe('sae_flightLogs_crashFlight', function(message) {ps_crash(message.data);});
channel.subscribe('sae_flightLogs_noFlight', function(message) {ps_noFly(message.data);});
channel.subscribe('sae_crashreport', function(message) {ps_add_crashReport(message.data);});
channel.subscribe('sae_deletecrash', function(message) {ps_deleteCrash(message.data);});
channel.subscribe('sae_alertStudentOfCrashReport', function(message) {ps_alertStudent(message.data);});
channel.subscribe('sae_clearTeamToFly', function(message) {ps_alertTeamClearToFly(message.data);});

// Ticket Subscriptions
channel.subscribe('sae_ps_addTicket', function(message) {sae_ps_addTicket(message.data);});
channel.subscribe('sae_ps_deleteTicket', function(message) {sae_ps_deleteTicket(message.data);});
channel.subscribe('sae_ps_reinspectionRequired', function(message) {sae_ps_reinspectionRequired(message.data);});
channel.subscribe('sae_ps_updateAddTicketButton', function(message) {sae_ps_updateAddTicketButton(message.data);});
channel.subscribe('sae_ps_cancelInspection', function(message) {sae_ps_cancelInspection(message.data);});
channel.subscribe('sae_ps_clearInspection', function(message) {sae_ps_clearInspection(message.data);});
channel.subscribe('sae_ps_updateTicketStatus', function(message) {sae_ps_updateTicketStatus(message.data);});
channel.subscribe('sae_ps_unclearInspectionTicket', function(message) {sae_ps_unclearInspectionTicket(message.data);});
channel.subscribe('sae_ps_notifyTeamsOfReinspection', function(message) {sae_ps_notifyTeamsOfReinspection(message.data);});

{
    
    function sae_ps_notifyTeamsOfReinspection (argument) {
        
        var o = JSON.parse(argument);
        if (o.NOTIFY == 0){
            $('#TeamReInspection_'+o.FK_TEAM_IDX).remove();
            return;
        }
        var ajxData = {};
        ajxData['do'] = 'sae_ps_notifyTeamsOfReinspection';
        ajxData['act'] = 'print';
        ajxData.FK_EVENT_IDX = $.cookie('FK_EVENT_IDX');
        ajxData.FK_TEAM_IDX = o.FK_TEAM_IDX;
        // ajxData['jsonData'] = argument;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){

                var obj = JSON.parse(str);
                $('#TeamReinspectionNotification_' + o.FK_TEAM_IDX).prepend(obj.NOTIFY_BUTTON);
                console.log(str);
                console.log(argument);
                console.log(obj.FK_TEAM_IDX);
            }
        });
        

    }
    function sae_ps_unclearInspectionTicket(argument) {
        var o = JSON.parse(argument);
        var ajxData = {};
        ajxData['do'] = 'sae_ps_unclearInspectionTicket';
        ajxData['act'] = 'print';
        ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
        ajxData['jsonData'] = argument;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                var obj = JSON.parse(str);
                $('#TEAM_TICKET_ADDER_'+o.FK_TEAM_IDX).replaceWith(obj.addButton);
                $('#ticketBucket_'+o.FK_TEAM_IDX).html(obj.tickets);
                $('button.team_'+ o.FK_TEAM_IDX+'_Ticket').attr("disabled", false);
                $('#REINSPECT_' + o.PK_REINSPECT_IDX).removeClass('w3-green inspectionItemCleared').addClass('w3-white');
                $('#REINSPECT_' + o.PK_REINSPECT_IDX).attr('onclick','reviewInspectionDetails(this, '+o.PK_REINSPECT_IDX+');');
            }
        });
    }
    function sae_ps_updateTicketStatus (argument) {
        var o = JSON.parse(argument);
        var flightIDX = o.VALUE_IDX;
        var ajxData = {};
        ajxData['do'] = 'sae_ps_updateTicketStatus';
        ajxData['act'] = 'print';
        ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
        ajxData['FK_FLIGHT_IDX'] = flightIDX;
        ajxData['jsonData'] = argument;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                var obj = JSON.parse(str);
                $('#TICKET_' + flightIDX).replaceWith(obj.TICKET);
            }
        });
    }
    function sae_ps_clearInspection (argument) {
        // console.log('clearedInspections = ' + argument);
        var o = JSON.parse(argument);
        $('button.team_'+o.teamIDX+'_Ticket').attr("disabled", false);
        $('button.team_'+o.teamIDX+'_Ticket').removeClass('w3-pale-red').addClass('w3-sand');
        var ajxData = {};
        ajxData['do'] = 'sae_ps_clearInspection';
        ajxData['act'] = 'print';
        ajxData.BO_STATUS = 0;
        ajxData.FK_TEAM_IDX = o.FK_TEAM_IDX;
        ajxData.FK_FLIGHT_IDX = o.FK_FLIGHT_IDX;
        ajxData.IN_NUMBER = o.IN_NUMBER;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                var obj = JSON.parse(str);
                // console.log(argument);
                // console.log(str);
                // $('#Inspection').attr('checked',false);
                $('#TEAM_TICKET_ADDER_'+o.FK_TEAM_IDX).replaceWith(obj.addButton);
                $('#ticketBucket_'+o.FK_TEAM_IDX).html(obj.tickets);
                $('button.team_'+o.FK_TEAM_IDX+'_Ticket').attr("disabled", false);
                if ($('#showAllReinspectionTasks').is(':checked')){
                    $('#REINSPECT_' + o.PK_REINSPECT_IDX).removeClass('w3-white').addClass('w3-green inspectionItemCleared');
                } else {
                    $('#REINSPECT_' + o.PK_REINSPECT_IDX).removeClass('w3-white').addClass('w3-hide w3-green inspectionItemCleared');
                }
                $('#REINSPECT_' + o.PK_REINSPECT_IDX).attr('onclick','reviewClearedInspectionDetails(this, '+o.PK_REINSPECT_IDX+');');
            }
        });
    }
    function sae_ps_cancelInspection(argument) {
        // console.log(argument);
        var o = JSON.parse(argument);
        // console.log('Deleting this Button #REINSPECT_' + o.inspectIDX)
        var ajxData = {};
        ajxData['do'] = 'updateAddTicketStatus';
        ajxData['act'] = 'print';
        ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
        ajxData['jsonData'] = argument;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                var obj = JSON.parse(str);
                $('#TEAM_TICKET_ADDER_'+obj.FK_TEAM_IDX).replaceWith(obj.BUTTON);
                $('#TICKET_' + obj.FK_FLIGHT_IDX).replaceWith(obj.TICKET);
                $('button.team_'+ o.FK_TEAM_IDX+'_Ticket').attr("disabled", false);
                $('#REINSPECT_' + o.PK_REINSPECT_IDX).removeClass('w3-green inspectionItemCleared').addClass('w3-white');
                $('#REINSPECT_' + o.PK_REINSPECT_IDX).attr('onclick','reviewInspectionDetails(this, '+o.PK_REINSPECT_IDX+');');
                $('#REINSPECT_' + o.PK_REINSPECT_IDX).remove();
            }
        });
    }
    function sae_ps_updateAddTicketButton(message) {
        var obj = JSON.parse(message);
        // console.log(obj);
        if (obj.REFRESH == "Yes") {
            $('#TEAM_TICKET_ADDER_'+obj.FK_TEAM_IDX).replaceWith(obj.BUTTON);
        }
    }
    function sae_ps_addTicket(message){
        // console.log(message);
        var obj = JSON.parse(message);
        $('#ticketBucket_'+obj.teamIDX).append(obj.tag);
    }
    function sae_ps_deleteTicket(message){
        // console.log(message);
        var obj = JSON.parse(message);
        // console.log('flight IDX='+obj.FK_TEAM_IDX);
        $('#TICKET_' + obj.FK_FLIGHT_IDX).remove();
    }
    function sae_ps_reinspectionRequired (message) {
        // console.log(message)
        var o = JSON.parse(message);
        // console.log('New reinspectIDX = ' + o.inspectIDX);
        var ajxData = {};
        ajxData['do'] = 'updateAddTicketStatus';
        ajxData['act'] = 'print';
        ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
        ajxData['jsonData'] = message;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                // console.log(str)
                var obj = JSON.parse(str);

                // console.log(obj.TICKET);
                $('#TEAM_TICKET_ADDER_'+obj.FK_TEAM_IDX).replaceWith(obj.BUTTON);
                $('button.team_'+obj.FK_TEAM_IDX+'_Ticket').attr("disabled", true);
                // $('#TICKET_' + obj.FK_FLIGHT_IDX).removeClass('w3-sand w3-disabled').addClass('w3-pale-red').attr("disabled", false);
                $('#TICKET_' + obj.FK_FLIGHT_IDX).replaceWith(obj.TICKET);
                $('#UL_ReinspectionList').prepend(obj.INSPECT_BUTTON);
                // console.log("Button for the Inspection Page = \n" + obj.INSPECT_BUTTON);
            }

        });
    }
}





function ps_alertTeamClearToFly(str){
    // console.log("ps_alertTeamClearToFly\n teamIDX="+str.PK_TEAM_IDX);
    // console.log("ps_alertTeamClearToFly\n flightIDX="+str.FK_FLIGHT_IDX);
    $('.sae_team_dashboard_'+str.PK_TEAM_IDX).removeClass("w3-red");
    $('.sae_team_dashboard_header_'+str.PK_TEAM_IDX).addClass("w3-hide");
}


function ps_alertStudent(str){
    console.log("ps_alertStudent\n"+str.PK_TEAM_IDX);
    console.log("ps_alertStudent\n"+str.FK_FLIGHT_IDX);
    $('.sae_team_dashboard_'+str.PK_TEAM_IDX).addClass("w3-red");
    $('.sae_team_dashboard_header_'+str.PK_TEAM_IDX).removeClass("w3-hide");
}


function ps_deleteCrash(str){
    // console.log("ps_deleteCrash\n"+str);
    var obj = JSON.parse(str);
    $('#TODO_IDX_'+obj.flightIDX).remove();
    
}
function ps_fail_crashReport(obj){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/pubsub.pl',
        data: obj,
        success: function(str){
            var btn = JSON.parse(str);
            $('#TODO_IDX_'+obj.flightIDX).replaceWith(btn.techBtn);
            $('#TEAM_'+obj.teamIDX).replaceWith(btn.logBtn);
        }
    });
}
function ps_checkoutCard(status) {
    var obj = JSON.parse(status);
    $('#TEAM_'+obj.idx).replaceWith(obj.btn);
}
function ps_cancel(status){
    var obj = JSON.parse(status);
    $('#TEAM_'+obj.idx).replaceWith(obj.btn);
}
function ps_crash(str){
    // console.log("ps_crash\n\n"+str);
    var obj = JSON.parse(str);
    // $('#TEAM_'+obj.idx).replaceWith(obj.btn);
    $('#TEAM_'+obj.idx).replaceWith(obj.logBtn);
    if (obj.techBtn === null){
        $('#TODO_IDX_'+obj.flightIDX).remove();
    } else {
        $('#TODO_IDX_'+obj.flightIDX).replaceWith(obj.techBtn);
    }
}
function ps_noFly(status){
    var obj = JSON.parse(status);
    $('#TEAM_'+obj.idx).replaceWith(obj.btn);
}
function ps_add_crashReport(str){
    // console.log("ps_add_crashReport\n"+str);
    var obj = JSON.parse(str);
    $('#UL_CRASH_REPORT_LIST').append(obj.btn);
}