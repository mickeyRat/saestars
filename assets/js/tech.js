    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-display-container"><center class="center-screen w3-display-center"><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Loading...</span></center></div>';


//------ 2023 ---------------------------------------------------
function tech_updateCheckItem(o) {
    var ajxData = {};
    var data = {};
        data[$(o).data('field')] = 0;
    if ($(o).is(':checked')){data[$(o).data('field')] = 1} 
    ajxData['do'] = 'tech_updateCheckItem';
    ajxData['act'] = 'print';
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    ajxData['FIELD_IDX'] = $(o).data('key');
    ajxData['FIELD'] = $(o).data('primekey');
    ajxData['TABLE'] = $(o).data('table'); 
    ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            // console.log('#TECH_ITEM_'+teamIDX+'_'+itemIDX);
            // console.log(str);
            // $('#TECH_ITEM_'+teamIDX+'_'+itemIDX).replaceWith(str);
            // $('#modal_content').html(str);

        }
    });
}
function tech_submitTechStatus (o, teamIDX, itemIDX, headingIDX, classIDX, inStatus) {
    if (inStatus ==0){
        var jsYes = confirm("Are you sure?");
        if (!jsYes){return}
    }
    $('#savedMessage').show();
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_submitTechStatus','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'itemIDX':itemIDX,'inStatus':inStatus,'headingIDX':headingIDX,'classIDX':classIDX},
        success: function(str){
            var obj = JSON.parse(str);
            // console.log(obj.TEAM_BAR);
            $('#TECH_ITEM_'+teamIDX+'_'+itemIDX).replaceWith(obj.ITEM);
            setTimeout(function(){ $('#savedMessage').fadeOut(150); }, 250);
            channel.publish('sae_ps_updateTeamInspectionStatus', str);
            channel.publish('sae_ps_alertTeamInspectionStatus', str);

        }
    });
}
function tech_openSafetyCheck (o, teamIDX, inNumber, classIDX) {
    var eventIDX = $.cookie('LOCATION');
    // ajxData.itemCount       ÷      = itemCount;
    $.modal('Team #:' + pad(inNumber,3), '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_openSafetyCheck','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'classIDX':classIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);

        }
    });
}
function tech_openRequirementsCheck (o, teamIDX, inNumber, classIDX) {
    // console.log('section number = ' + secNumber);
    // var itemCount = $('.itemGroup_'+sectionIDX).length + 1;

    var eventIDX = $.cookie('LOCATION');
    // ajxData.itemCount       ÷      = itemCount;
    $.modal('Team #:' + pad(inNumber,3), '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_openRequirementsCheck','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'classIDX':classIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);

        }
    });
}
function tech_openTechInspectionTeamList (o) {
    var eventIDX = $.cookie('LOCATION');
    // $.modal('Add Section', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_openTechInspectionTeamList','act':'print','eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            // $('#modal_content').html(str);
            $('#mainPageContent').html(str);

        }
    });
}
function tech_addCheckItem (o, sectionIDX, secNumber) {
    // console.log('section number = ' + secNumber);
    var itemCount = $('.itemGroup_'+sectionIDX).length + 1;

    var eventIDX = $.cookie('LOCATION');
    // ajxData.itemCount       ÷      = itemCount;
    $.modal('Add Check Item', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_addCheckItem','act':'print','eventIDX':eventIDX,'sectionIDX':sectionIDX,'secNumber':secNumber,'itemCount':itemCount},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);

        }
    });
    }
function tech_updateField(o){
    var maxDistance = 15;
    $('#savedMessage').show();
    var data          = {};
    var field         = $(o).data('field');
    data[field]       = $(o).val();
    var ajxData       = {};
    ajxData['do']     = 'tech_updateField';
    ajxData['act']    = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData.FIELD_IDX = $(o).data('key');
    ajxData.VALUE_IDX = $(o).data('index'); 
    ajxData.TABLE     = $(o).data('table'); 
    ajxData.jsonData  = JSON.stringify(data);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            // console.log(str); 
            setTimeout(function(){ $('#savedMessage').fadeOut(150); }, 500);
            // $('#modal_content').html(str);
        }
    });
    }
function tech_deleteItem (o, itemIDX, sectionIDX) {
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    var ajxData = {};
    ajxData['do'] = 'tech_deleteItem';
    ajxData['act'] = 'print';
    ajxData.itemIDX = itemIDX;
    $('#ITEM_'+itemIDX).remove();
    console.log(ajxData);
    // return    // console.log(txItem)
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            // $('#ITEM_'+itemIDX).remove();
        },
        complete: function(){
            var inPoints = 0;
            $('.pointsFor_'+sectionIDX).each(function(o) {
                    inPoints += parseFloat($(this).html());
                });
            $('.sectionPoints_'+sectionIDX).html(inPoints + ' Points');  
        }
    });   
    }
function tech_toggleSelectAll (argument) {
    const max = $('.sectionClass').length;
    var count = 0;
    $('.sectionClass').each(function(){
        if ($(this).is(':checked')) {
            count ++;
        }
    });
    // console.log('count = ' + count);
    // console.log('max = ' + max);
    if (count < max){
        $('#applicableToAll').prop('checked', false);
    } else {
        $('#applicableToAll').prop('checked', true);
    }
    }
function tech_toggleChecks (o) {
    if ($(o).is(':checked')){
        $('.sectionClass').prop('checked',true);
    } else {
        $('.sectionClass').prop('checked',false);
    }
    }
function tech_editItem (o, itemIDX, secNumber) {
    var eventIDX = $.cookie('LOCATION');
    // ajxData.itemCount       ÷      = itemCount;
    $.modal('Edit Check Item', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_editItem','act':'print','eventIDX':eventIDX,'itemIDX':itemIDX, 'secNumber':secNumber},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);

        }
    });
    }
function tech_updateItem (o, itemIDX, sectionIDX) {
    var ajxData       = {};
    var data          = {};
    // var itemCount = $('.itemGroup_'+sectionIDX).length + 1;

    if ($('#IN_SECTION').val() == '' || $('#IN_SECTION').val() == 0 || !$('#IN_SECTION').val()){
        data.IN_SECTION   = $('#IN_SECTION').prop('placeholder')
    } else {
        data.IN_SECTION   = $('#IN_SECTION').val();
    }
    data.TX_SECTION   = $('#TX_SECTION').val();
    data.FK_TECH_REQ_SECTION_IDX  = sectionIDX;
    data.TX_REQUIREMENT  = $('#TX_REQUIREMENT').val();;
    data.IN_POINTS  = $('#IN_POINTS').val();;
    $('.sectionClass').each(function(){
        if ($(this).is(':checked')){
            // console.log($(this).data('field'))
            data[$(this).data('field')] = 1;
        } else {
            data[$(this).data('field')] = 0;
        }
    });
    ajxData['do']                 = 'tech_updateItem';
    ajxData['act']                = 'print';
    ajxData.eventIDX              = $.cookie('FK_EVENT_IDX');
    ajxData.sectionIDX            = sectionIDX;
    ajxData.itemIDX               = itemIDX;
    ajxData.TABLE                 = 'TB_TECH_REQ';
    ajxData.jsonData              = JSON.stringify(data);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            console.log(str); 
            $(o).close();
            $('#ITEM_'+itemIDX).replaceWith(str);
        },
        complete: function(){
            // console.log('sectionIDX = ' + sectionIDX);
            var inPoints = 0;
            $('.pointsFor_'+sectionIDX).each(function(o) {
                    inPoints += parseFloat($(this).html());
                });
            $('.sectionPoints_'+sectionIDX).html(inPoints + ' Points');  
        }
    });
    }
function tech_addItem(o, sectionIDX) {
    var ajxData       = {};
    var data          = {};
    var itemCount = $('.itemGroup_'+sectionIDX).length + 1;

    if ($('#IN_SECTION').val() == '' || $('#IN_SECTION').val() == 0 || !$('#IN_SECTION').val()){
        data.IN_SECTION   = $('#IN_SECTION').prop('placeholder')
    } else {
        data.IN_SECTION   = $('#IN_SECTION').val();
    }
    data.TX_SECTION   = $('#TX_SECTION').val();
    data.FK_TECH_REQ_SECTION_IDX  = sectionIDX;
    data.TX_REQUIREMENT  = $('#TX_REQUIREMENT').val();;
    data.IN_POINTS  = $('#IN_POINTS').val();;
    // data.TX_TYPE      = txType;

    $('.sectionClass').each(function(){
        if ($(this).is(':checked')){
            // console.log($(this).data('field'))
            data[$(this).data('field')] = 1;
        } else {
            data[$(this).data('field')] = 0;
        }
    });
    ajxData['do']                 = 'tech_addItem';
    ajxData['act']                = 'print';
    ajxData.eventIDX              = $.cookie('FK_EVENT_IDX');
    ajxData.sectionIDX            = sectionIDX;
    ajxData.jsonData              = JSON.stringify(data);
    console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            // console.log(str); 
            $(o).close();
            $('#tableSection_'+sectionIDX).append(str);
        },
        complete: function(){
            var inPoints = 0;
            $('.pointsFor_'+sectionIDX).each(function(o) {
                    inPoints += parseFloat($(this).html());
                });
            $('.sectionPoints_'+sectionIDX).html(inPoints + ' Points');  
        }
    });
    }
function tech_addSection (o, txType) {
    var ajxData       = {};
    var data          = {};
    if ($('#IN_SECTION').val() == '' || $('#IN_SECTION').val() == 0 || !$('#IN_SECTION').val()){
        data.IN_SECTION   = $('#IN_SECTION').prop('placeholder')
    } else {
        data.IN_SECTION   = $('#IN_SECTION').val();
    }
    data.TX_SECTION   = $('#TX_SECTION').val();
    data.TX_TYPE      = txType;
    ajxData['do']     = 'tech_addSection';
    ajxData['act']    = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData.jsonData  = JSON.stringify(data);
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            $(o).close();
            $('#'+txType+'_content').append(str);
        }
    });
    }
function tech_openAddSection (txType) {
    var secCount = $('.'+txType).length + 1;
    var eventIDX = $.cookie('LOCATION');
    $.modal('Add Section', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_openAddSection','act':'print','eventIDX':eventIDX,'txType':txType,'secCount':secCount},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);

        }
    });
    }
function tech_openSetup () {
    var eventIDX = $.cookie('LOCATION');
    var obj = {};
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'tech_openSetup','act':'print','eventIDX':eventIDX},
        success: function(str){
            // var obj = 
            obj = JSON.parse(str);
            $('#mainPageContent').html(obj.html);
            // console.log(obj.REQ);
        },
        complete: function(){
            var section = obj.REQ.split(";");
            section.forEach(function(item, index) {
                var inPoints = 0;
                $('.pointsFor_'+item).each(function(o) {
                    inPoints += parseFloat($(this).html());
                });
                console.log('Total pts for this section is '+inPoints);
                $('.sectionPoints_'+item).html(inPoints + ' Points');            
            })

        }
    });
    }

function tech_deleteSection (o, sectionIDX) {
    var jsYes = confirm("are you sure?");
    if (!jsYes){return}
    var ajxData = {};
    ajxData['do'] = 'tech_deleteSection';
    ajxData['act'] = 'print';
    ajxData['sectionIDX'] = sectionIDX;
    // console.log(txItem)
    $(o).parent().remove();
    // return
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: ajxData,
        success: function(str){
            $(o).parent().remove();
        }
    });
    }
function tech_expandSection(obj, section){
    $('#'+section).toggleClass('w3-hide');
    $(obj).children('.fa').toggleClass('fa-chevron-right fa-chevron-down');
    }
// ------ TECH -
function viewTeamReinspection (o, inspectIDX) {
    var eventIDX = $.cookie('LOCATION');
    // console.log(inspectIDX);
    $.modal('Reinspection Summary', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'viewTeamReinspection','act':'print','eventIDX':eventIDX, 'inspectIDX':inspectIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);

        }
    });
    }
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
function unclearReinpsectionByTech(o, inspectIDX, teamIDX) {
    var notify = {};
    notify.NOTIFY            = 1;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'unclearReinpsectionByTech','act':'print','inspectIDX':inspectIDX,'userIDX':$.cookie('PK_USER_IDX')},
        success: function(str){
            var obj = JSON.parse(str);
            notify.FK_TEAM_IDX       = obj.FK_TEAM_IDX;
            $(o).close();
            channel.publish('sae_ps_unclearInspectionTicket', str);
            channel.publish('sae_ps_notifyTeamsOfReinspection', JSON.stringify(notify));
            console.log(notify);
        }
    });
    }
function clearReinspectionByTech (o, inspectIDX) {
    var notify = {};
    notify.NOTIFY            = 0;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'clearReinspectionByTech','act':'print','inspectIDX':inspectIDX,'userIDX':$.cookie('PK_USER_IDX')},
        success: function(str){
            var obj = JSON.parse(str);
            notify.FK_TEAM_IDX       = obj.FK_TEAM_IDX;
            $(o).close();
            // $('#REINSPECT_' + inspectIDX).removeClass('w3-white').addClass('w3-hide w3-green inspectionItemCleared');
            // $('#REINSPECT_' + inspectIDX).attr('onclick','reviewClearedInspectionDetails(this, '+inspectIDX+');');
            channel.publish('sae_ps_clearInspection', str);
            channel.publish('sae_ps_notifyTeamsOfReinspection', JSON.stringify(notify));
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

