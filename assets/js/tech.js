    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-display-container"><center class="center-screen w3-display-center"><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Loading...</span></center></div>';


//------ 2023 ---------------------------------------------------
function reviewInspectionDetails (o, inspectIDX) {
    var eventIDX = $.cookie('FK_EVENT_IDX');
    var ajxData       = {};
    ajxData['do']     = 'reviewInspectionDetails';
    ajxData['act']    = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData.inspectIDX = inspectIDX;
    // ajxData.jsonData  = JSON.stringify(data);
    $.modal('Reinspection Details', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}

function reviewClearedInspectionDetails (o, inspectIDX) {
    // console.log(inspectIDX);
    var eventIDX = $.cookie('FK_EVENT_IDX');
    var ajxData       = {};
    ajxData['do']     = 'reviewClearedInspectionDetails';
    ajxData['act']    = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData.inspectIDX = inspectIDX;
    // ajxData.jsonData  = JSON.stringify(data);
    $.modal('Reinspection Details', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
function unclearReinpsectionByTech(o, inspectIDX) {
    
    // $(o).close();
    // reviewInspectionDetails
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'unclearReinpsectionByTech','act':'print','inspectIDX':inspectIDX,'userIDX':$.cookie('PK_USER_IDX')},
        success: function(str){
            $(o).close();
            channel.publish('sae_ps_unclearInspectionTicket', str);
        }
    });
}
function clearReinspectionByTech (o, inspectIDX) {
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'clearReinspectionByTech','act':'print','inspectIDX':inspectIDX,'userIDX':$.cookie('PK_USER_IDX')},
        success: function(str){
            $(o).close();
            // $('#REINSPECT_' + inspectIDX).removeClass('w3-white').addClass('w3-hide w3-green inspectionItemCleared');
            // $('#REINSPECT_' + inspectIDX).attr('onclick','reviewClearedInspectionDetails(this, '+inspectIDX+');');
            channel.publish('sae_ps_clearInspection', str);
        }
    });
}

function toggleShowAllReinspectionTasks(o){
    // console.log($(o).is(':checked'));
    if ($(o).is(':checked')){
        // $.cookie('showAllInspection', 1);
        $('.inspectionItem').removeClass('w3-hide');
    } else {
        // $.cookie('showAllInspection', 0);
        $('.inspectionItemCleared').addClass('w3-hide');
    }
}



//------ 2023 ---------------------------------------------------
function showListOfTeam_Tech(){
    $('#mainPageContent').html(loading);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'showListOfTeam_Tech','act':'print','location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function sae_showUpdateInspectionStatus(teamIDX){
    var divName = 'TEMP_DIV_EDIT_NEW_ECR';
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    createNewModalDiv('<b>Tech/Safety Inspections</b>',divName,500);
    // alert("Here");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_showUpdateInspectionStatus','act':'print','userIDX':userIDX,'location':location,'divName':divName,'teamIDX':teamIDX},
        success: function(str){
            // console.log(str);
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_submitInspectionStatus(teamIDX, status, classIDX, divName){
    var location = $.cookie('LOCATION');
    var inPipes = $('#IN_PIPES').val();
    var inWPipes = $('#IN_WPIPES').val();
    var inCargo = $('#REG_IN_LCARGO').val();   
    var inVideo = $('input[name="ADV_IN_VIDEO"]:checked').val();
    if (classIDX == 1){
        // var inCargo = $('#REG_IN_LCARGO').val();
        if ((status == 'Passed' && inCargo === '') || (status=='Passed' && inCargo==0)){
            $('#REG_IN_LCARGO').focus();
            alert("Team cannot pass inspection without Length of Cargo Bay (2020 Aero-Design Rules)");
            return;
        }
    }
    if (classIDX==3){
        // var inPipes = $('#IN_PIPES').val();
        // var inWPipes = $('#IN_WPIPES').val();
        if (status == 'Passed'){
            if (inPipes == 0 || inWPipes==0){
                alert("Team cannot pass inspection without proper pipe # and weight entry (2020 Aero-Design Rules)");
                return
            }
        }
    }
    if (classIDX == 2){
        if (status == 'Passed' && inVideo!=1){
            alert("Team cannot pass Tech Inspection without showing proof of flight via video");
            return;
        } else if (status == 'To Do') {
            inVideo = 0;
        } else {
            if (!inVideo){inVideo = 0};
            // $('input[name="ADV_IN_VIDEO"]').attr('checked',false);
        }
        
    }
    console.log("inVideo="+inVideo)
    // return;
    // console.log("teamIDX="+teamIDX+", status="+status+", divName="+divName+", inPipes="+inPipes+", inWPipes="+inWPipes);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_updateInspectionStatus','act':'print','inPipes':inPipes,'inWPipes':inWPipes,'inVideo':inVideo,'status':status,'inCargo':inCargo,'location':location,'teamIDX':teamIDX,'classIDX':classIDX},
        success: function(str){

            if (status=='Passed'){
                $('#LINK_INSPECTION_'+teamIDX).html('<i class="fa fa-check-square-o"></i> ' + status);
            } else {
                $('#LINK_INSPECTION_'+teamIDX).html(status);
            }
            // console.log(str);
            
            $('#'+divName).remove();
        }
    });
}
function sae_showImportTechSchedule(){
    var divName = 'TEMP_DIV_TEAM_SCHEUDLE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Import Tech Schedule</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_showImportTechSchedule','act':'print','location':location,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_importTechScheduleFile(divName){
    var formData = new FormData();
    var location = $.cookie('LOCATION');
    formData.append('csvFile', $('input[type=file]')[0].files[0]); 
    formData.append('location',location);
    formData.append('do','sae_importTechScheduleFile');
    formData.append('act','print');
    // formData.append('location',location);
    $.post({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: formData,
        contentType: false, // NEEDED, DON'T OMIT THIS (requires jQuery 1.6+)
        processData: false, // NEEDED, DON'T OMIT THIS
        success: function(str){
            // $('#sae_results').html(str);
            $('#'+divName).remove();
            alert("File Imported");
            showListOfTeam_Tech();
        }
    });
}
function sae_expandNotes(){
    $('.crash-notes').toggle(150);
}
function sae_openReinspectionDetails(todoIDX, teamIDX, flightIDX, color){
    // console.log('inStatus='+inStatus);
    $.modal('Reinspection Details','65%', color);
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    console.log('location='+location);
    console.log('teamIDX='+teamIDX);
    console.log('flightIDX='+flightIDX);
    console.log('todoIDX='+todoIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_openReinspectionDetails','act':'print','location':location,'teamIDX':teamIDX,'flightIDX':flightIDX,'todoIDX':todoIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}

function sae_showAll(o){
    // console.log($(o).is(':checked'));
    if ($(o).is(':checked')){
        // $.cookie('showAllInspection', 1);
        $('.sae-archive').removeClass('w3-hide');
    } else {
        // $.cookie('showAllInspection', 0);
        $('.sae-archive').addClass('w3-hide');
    }
}

function sae_clearReinspectionDetails(o, teamIDX, flightIDX, todoIDX, inStatus){
    var location = $.cookie('LOCATION');
    var team = {};
    team.PK_TEAM_IDX   = teamIDX;
    team.FK_FLIGHT_IDX = flightIDX;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_clearReinspectionDetails','act':'print','location':location,'teamIDX':teamIDX,'inStatus':inStatus,'todoIDX':todoIDX,'flightIDX':flightIDX},
        success: function(str){
            // console.log(str);
            if (inStatus>0){
                channel.publish('sae_flightLogs_crashFlight', str);
                channel.publish('sae_clearTeamToFly', team);
            } else {
                channel.publish('sae_alertStudentOfCrashReport', team);
            }
            $(o).close();
        }
    });
}

function sae_failedReinspectionDetails(o, teamIDX, todoIDX, inStatus){
    var location = $.cookie('LOCATION');
    // console.log('location='+location+' ,teamIDX = '+teamIDX+', flightIDX='+flightIDX);
    var team = {};
    team.PK_TEAM_IDX   = teamIDX;
    // team.FK_FLIGHT_IDX = flightIDX;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_failedReinspectionDetails','act':'print','location':location,'teamIDX':teamIDX,'inStatus':inStatus,'todoIDX':todoIDX},
        success: function(str){
            $(o).close();
            openCrashReinspection();
            channel.publish('sae_alertStudentOfCrashReport', team);
        }
    });
}
function sae_cancelReinspectionDetailsdivName(divName){
    $('#'+divName).remove();
}

