// $('#mainPageContent').html(loading);
//     var eventIDX = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/attend.pl',
//         // url: '../cgi-bin/main2.pl',
//         data: {'do':'attend_openTeamList','act':'print','eventIDX':eventIDX},
//         success: function(str){
//             $('#mainPageContent').html(str);
//         }
//     });    
    var d=document;
    var sid = $.cookie('SID');
    // var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';
    // var loading = '<i class="fa fa-refresh fa-spin fa-3x fa-fw"></i><span class="sr-only">Loading...</span>';
// 2022 -2023

// TAGS Group:
{
    

{
    var tagList   = [];
    var tags      = [];
    var noFlyList = [];
    var noFly     = [];
}

function flight_cancelConfirmDeleteAttempt(o, flightIDX) {
    $('#DELETE_ROW_'+flightIDX).hide(50);
}
function flight_showConfirmDeleteAttempt(o, flightIDX) {
    $('#DELETE_ROW_'+flightIDX).slideDown(350);
}
function flight_checkInspectOthers(o) {
    if ($(o).val() == ''){
        $('#INSPECT_OTHER_CHECKBOX').prop('checked', false);
    } else {
        $('#INSPECT_OTHER_CHECKBOX').prop('checked', true);
    }
}
function flight_openReinspection(o, inNumber, inRound, flightIDX) {
    if($(o).is(':checked')){;
        $.modal2('Open Reinspection Ticket for Team #:' + pad(inNumber,3) + ' - Att:' + pad(inRound,2),'50%');
        var ajxData = {};
        var data = {};
        ajxData['do']         = 'flight_openReinspection';
        ajxData['act']        = 'print';
        ajxData['eventIDX']   = $.cookie('FK_EVENT_IDX');
        ajxData['flightIDX']  = flightIDX;
        ajxData['inRound']    = inRound;
        ajxData['inNumber']   = inNumber;
        ajxData['jsonData']   = JSON.stringify(data);
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#modal2_content').html(str);
            }
            });
        }
    }


    function updateReasonNotToScore(flightIDX) {
        $('#savedMessage').show();
        var ajxData = {};
        var data = {};
        data['CL_REASON'] = noFly.join(";");
        // console.log(noFly.join(";"));
        ajxData['do'] = 'updateField';
        ajxData['act'] = 'print';
        ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
        // ajxData['flightIDX'] = flightIDX;
        ajxData.FIELD_IDX = 'PK_FLIGHT_IDX';
        ajxData.VALUE_IDX = flightIDX; 
        ajxData.TABLE     = 'TB_FLIGHT'; 
        ajxData['jsonData'] = JSON.stringify(data);
        // console.log(ajxData);
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
            }
        });
    }
    function updateInspectionTags(flightIDX) {
        $('#savedMessage').show();
        var ajxData = {};
        var data = {};
        data['CL_ITEMS']      = tags.join(";");
        ajxData['do']         = 'updateInspectionTags';
        ajxData['act']        = 'print';
        ajxData['eventIDX']   = $.cookie('FK_EVENT_IDX');
        ajxData['flightIDX']  = flightIDX;
        ajxData['inspectIDX'] = $('#Inspection').val();
        ajxData['jsonData']   = JSON.stringify(data);
        // console.log(ajxData);
        // return;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                // console.log(str); 
                setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
                // setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 750);
                // $('#modal_content').html(str);
            }
        });
    }
    function createTag(label, flightIDX, classType) {
        const div = d.createElement('div');
        div.setAttribute('class', classType);
        const span = d.createElement('span');
        span.innerHTML = label;
        const closeBtn = d.createElement('i');
        closeBtn.setAttribute('class','fa fa-close');
        if (classType == 'tag'){
            closeBtn.setAttribute('onclick','deleteReInspectionItem(this);');
        } else {
            closeBtn.setAttribute('onclick','deleteReasonItem(this);');
        }
        closeBtn.setAttribute('data-key',flightIDX);
        div.appendChild(span);
        div.appendChild(closeBtn);
        return div;
    }
    function deleteReInspectionItem(o) {
        const index = tags.indexOf($(o).prev().text());
        if (index > -1){
            tags.splice(index, 1);
            $(o).parent().remove();
            updateInspectionTags($(o).data('key'));
        }
    }
    function deleteReasonItem (o) {
        const index = noFly.indexOf($(o).prev().text());
        if (index > -1){
            noFly.splice(index, 1);
            $(o).parent().remove();
            updateReasonNotToScore($(o).data('key'));
        }
        console.log("No Fly after delete = " + noFly.length);
    }
    function resetTags(tagName) {
        $('.'+tagName).remove();
    }
    function addTags(flightIDX) {
        tags.slice().reverse().forEach(function(tag){
            const input = createTag(tag, flightIDX, 'tag' );
            $('.tag-container').prepend(input);
        });
        updateInspectionTags(flightIDX);
    }
    
    function inputTag (o) {
        resetTags('tag');
        if (tags.indexOf(o.value) == -1 && o.value !=''){
            tags.push(o.value);
        }
        addTags($(o).data('key'));
         $(o)[0].selectedIndex = 0;
    }
    function arrayContains(needle, arrhaystack){
        return (arrhaystack.indexOf(needle) > -1);
    }
    function addItemToInspectinList(flightIDX, value){
        var ajxData = {};
        var data = {};
        data.TX_ITEM = value;
        ajxData['do'] = 'addItemToInspectinList';
        ajxData['act'] = 'print';
        ajxData['flightIDX'] = 'flightIDX';
        ajxData['jsonData'] = JSON.stringify(data);
        // console.log(ajxData);
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#InspectionDiv_List').html(str);
            }
        });
    }
    function addItemToReasonList (flightIDX, value) {
        var ajxData = {};
        var data = {};
        data.TX_REASON = value;
        ajxData['do'] = 'addItemToReasonList';
        ajxData['act'] = 'print';
        ajxData['flightIDX'] = 'flightIDX';
        ajxData['jsonData'] = JSON.stringify(data);
        // console.log(ajxData);
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#reasonDiv_List').html(str);
            }
        });
    }
    function addClickedItem (flightIDX, txItem) {
        resetTags('tag');
        if (tags.indexOf(txItem) == -1 && txItem !=''){
            tags.push(txItem);
        }
        addTags(flightIDX);
        $('#InspectionItemInput').val('');
        $('.listItem').show();
    }
    function addClickedReason (flightIDX, txItem) {
        resetTags('item');
        if (noFly.indexOf(txItem) == -1 && txItem !=''){
            noFly.push(txItem);
        }
        addItems(flightIDX);
        $('#DNFItemInput').val('');
        $('.reasonlistItem').show();
    }
    function deleteInspectionItemFromDatabase(o, txItem){
        var ajxData = {};
        ajxData['do'] = 'deleteInspectionItemFromDatabase';
        ajxData['act'] = 'print';
        ajxData['txItem'] = txItem;
        // console.log(txItem)
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $(o).parent().remove();
            }
        });
    }
    function deleteReasonItemFromDatabase(o, txItem){
        var ajxData = {};
        ajxData['do'] = 'deleteReasonItemFromDatabase';
        ajxData['act'] = 'print';
        ajxData['txItem'] = txItem;
        // console.log(txItem)
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $(o).parent().remove();
            }
        });
    }
    function createInputTag (e, o) {
        var newItem = 0;
        var filter = $(o).val().toUpperCase();
        $('.listItem').each(function(){
            if ($(this).text().toUpperCase().indexOf(filter) > -1) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
        if (e.key == 'Enter'){
            if (!arrayContains($(o).val().toUpperCase(), tagList)){
                // console.log('New Value to be added to DB ' +$(o).val());
                tagList.push($(o).val());
                addItemToInspectinList($(o).data('key'), $(o).val());
            } 
            resetTags('tag');
            if (tags.indexOf(o.value) == -1 && o.value !=''){
                tags.push(o.value);
            }
            addTags($(o).data('key'));
            $(o).val(null);
            $('.listItem').show();
        }
    }
//Items
    function createItemTag(e,o) {
        var filter = $(o).val().toUpperCase();
        $('.reasonlistItem').each(function(){
            if ($(this).text().toUpperCase().indexOf(filter) > -1) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
        if (e.key == 'Enter'){
            // console.log('NNNOOO = ' + noFly.length);
            // console.log($(o).val().toUpperCase());
            if (!arrayContains($(o).val().toUpperCase(), noFlyList)){
                // console.log('New Value to be added to DB ' +$(o).val());
                noFlyList.push($(o).val());
                addItemToReasonList($(o).data('key'), $(o).val());
            } 
            resetTags('item');
            if (noFly.indexOf(o.value) == -1 && o.value !=''){
                noFly.push(o.value);
                // console.log('pushed');
            }
            addItems($(o).data('key'));
            $(o).val(null);
            // console.log(noFly);
        }
    }
    function addItems(flightIDX) {
        noFly.slice().reverse().forEach(function(tag){
            const input = createTag(tag, flightIDX, 'item' );
            $('.item-container').prepend(input);
        });
        updateReasonNotToScore(flightIDX);
    }

}
// END TAGS
// ======= Beginnning of Log Tabs
{ 
    function loadInspectionLog(tabName, teamIDX){
        // console.log(tabName);
        var ajxData = {};
        ajxData['do'] = 'loadInspectionLog';
        ajxData['act'] = 'print';
        ajxData.teamIDX = teamIDX;
        // ajxData['jsonData'] = jsonData;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#'+tabName+'_content').html(str);
                // channel.publish('sae_ps_addTicket', str);
            }
        });
    }
    function loadTeamData(tabName, teamIDX){
        console.log(tabName);
        var ajxData = {};
        ajxData['do'] = 'loadTeamData';
        ajxData['act'] = 'print';
        ajxData.teamIDX = teamIDX;
        // ajxData['jsonData'] = jsonData;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#'+tabName+'_content').html(str);
                // channel.publish('sae_ps_addTicket', str);
            }
        });
    }
    function loadTeamDocuments(tabName, teamIDX){
        var ajxData = {};
        ajxData['do'] = 'loadTeamDocuments';
        ajxData['act'] = 'print';
        ajxData.teamIDX = teamIDX;
        // ajxData['jsonData'] = jsonData;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#'+tabName+'_content').html(str);
                // channel.publish('sae_ps_addTicket', str);
            }
        });
    }
    function loadTeamScores(tabName, teamIDX, classIDX){
        var ajxData = {};
        if (classIDX == 3) {
            ajxData['do'] = 'loadTeamScores_Mic';
        } else if ( classIDX == 2) {
            ajxData['do'] = 'loadTeamScores_Adv';
        } else {
            ajxData['do'] = 'loadTeamScores_Reg';
        }
        ajxData['act'] = 'print';
        ajxData.teamIDX = teamIDX;
        // ajxData['jsonData'] = jsonData;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#'+tabName+'_content').html(str);
                // channel.publish('sae_ps_addTicket', str);
            }
        });
    }
    function loadTeamGTV(tabName, teamIDX) {
        var ajxData = {};
        ajxData['do'] = 'loadTeamGTV';
        ajxData['act'] = 'print';
        ajxData.teamIDX = teamIDX;
        // ajxData['jsonData'] = jsonData;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: ajxData,
            success: function(str){
                $('#'+tabName+'_content').html(str);
                // channel.publish('sae_ps_addTicket', str);
            }
        });
    }
    function openTab(o, tabName, teamIDX, classIDX){
        var activeTab = "w3-white w3-border-left w3-border-top w3-border-right";
        $('.tablink').removeClass('w3-white');
        $(o).addClass('w3-white');
        $('.tabContent').hide();
        $('#'+tabName).show();
        if (tabName == "inspectionLog"){
            loadInspectionLog(tabName, teamIDX);
        } else if (tabName == "teamData") {
            loadTeamData(tabName, teamIDX);
        } else if (tabName == "teamDocuments") {
            loadTeamDocuments(tabName, teamIDX);
        } else if (tabName == "teamScore") {
            loadTeamScores(tabName, teamIDX, classIDX);
        } else if (tabName == "advancedGTV") {
            loadTeamGTV(tabName, teamIDX);
        }

    }

} // END OF LOG TABS
function clearNFSCheckBoxes(){
    $(".NFS_status").prop('checked','');
}
function addTicket(o, teamIDX, inNumber, boReinspect, classIDX){
    // $(o).prop('disabled', true);
    var ticketNumber = 1;
    var tickets = [];
    // console.log(teamIDX);
    $('.team_'+teamIDX+'_Ticket').each(function(){
        // console.log($(this).data('round'));
        tickets.push($(this).data('round'));    
        tickets.sort(function(a, b){return b-a});
    });
    if (tickets.length>0){
        ticketNumber = tickets[0] + 1;
    }
    // console.log(ticketNumber);
    // return
    if (boReinspect==1){
        alert("Cannot Issue a ticket until team has cleared Re-Inspection");
        return;
        } else {
        var data = {};
            data.IN_ROUND = ticketNumber;
            data.FK_TEAM_IDX = teamIDX;
            data.IN_NUMBER = inNumber;
            data.FK_EVENT_IDX = $.cookie('FK_EVENT_IDX');
            data.IN_STATUS = 0;
            data.FK_CLASS_IDX = classIDX;
            jsonData = JSON.stringify(data);
        var ajxData = {};
            ajxData['do'] = 'addTicket';
            ajxData['act'] = 'print';
            ajxData['boReinspect'] = boReinspect;
            ajxData['jsonData'] = jsonData;
            $.ajax({
                type: 'POST',
                url: '../cgi-bin/flight.pl',
                data: ajxData,
                success: function(str){
                    // console.log(str);
                    channel.publish('sae_ps_addTicket', str);
                    $(o).prop('disabled', false);
                    }
                });
        }
}
function deleteFlightTicket(){
    $('#div_ticketDeleteConfirmation').slideToggle();
}
function flight_confirmFlightTicket(o, flightIDX, teamIDX, inNumber, classIDX){
    var ajxData = {};
    ajxData['do'] = 'flight_confirmFlightTicket';
    ajxData['act'] = 'print';
    ajxData['idx'] = flightIDX;
    ajxData['teamIDX'] = teamIDX;
    ajxData['inNumber'] = inNumber;
    ajxData['classIDX'] = classIDX;
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            channel.publish('sae_ps_deleteTicket', str);
            channel.publish('sae_ps_updateAddTicketButton', str);
            // $(o).close();
            $('.deleteContainer_'+flightIDX).remove();
        }
    });
} // Confirm to delete the Ticket
function btn_checkInTicket (inNumber, inRound, flightIDX, teamIDX, classIDX) {
    // if a modal window is needed, uncomment the line below.
    $.modal('Check-In Flight Ticket - Team #:' + pad(inNumber,3) + '-' + pad(inRound,2),'97%');
    var ajxData = {};
    ajxData['do'] = 'btn_checkInTicket';
    ajxData['act'] = 'print';
    ajxData['teamIDX'] = teamIDX;
    ajxData['flightIDX'] = flightIDX;
    ajxData['inRound'] = inRound;
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    ajxData['classIDX'] = classIDX;
    ajxData['inNumber'] = inNumber;
    // console.log(ajxData);
    // ajxData['jsonData'] = frm.getData();
    noFly = [];
    noFlyList = [];
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            var obj = JSON.parse(str);
            $('#modal_content').html(obj.html);
            tagList = obj.tagList.toUpperCase().split(";");
            noFlyList = obj.reasonList.toUpperCase().split(";");
            // console.log('obj.items = ' + obj.items);
            if (obj.items == null || obj.items == ''){
                tags = [];
            } else {
                if (obj.items == 0){
                    tags = [];
                } else {
                    tags = obj.items.split(';');
                }
                // console.log('length = ' + tags.length);
                if (tags.length>0){
                    tags.slice().reverse().forEach(function(tag){
                        const input = createTag(tag, flightIDX, 'tag');
                        $('.tag-container').prepend(input);
                    });
                }
            }  
            noFly=[];
            if (obj.flyStatus == 2){
                if (obj.reasons.length == 0){
                    noFly=[];
                } else {
                    noFly = obj.reasons.split(';');
                }
                if (noFly.length>0){
                    noFly.slice().reverse().forEach(function(tag){
                        if (tag != ''){
                            const input = createTag(tag, flightIDX, 'item');
                            $('.item-container').prepend(input);
                        }
                        });  
                    }    
            }       
            // console.log(noFlyList); 
        }
    });
}
function updateField(o){
    var maxDistance = 15;
    $('#savedMessage').fadeIn();
    var data = {};
    var field = $(o).data('field');
    if (field == 'IN_WATER'){
        var maxValue = parseFloat($(o).data('max'));
        var inWaterValue = parseFloat($(o).val());
        console.log("water Analysis");
        console.log('water = '+ $(o).val() +'; max=' + maxValue);
        if (inWaterValue > maxValue){
            alert("Warning\n\nThe value you've enter ["+inWaterValue+"]  exceeds the maximum ["+maxValue+"] effective water to transport.");
            $(o).val(maxValue);
        }
    }
    if (field == 'IN_DISTANCE'){
        var distance = $(o).val();
        if (distance > maxDistance){
            // console.log(distance + ' > ' + maxDistance);
            alert("Warning: The distance entered [ " + $(o).val() + " ] is greater than allowed.");
            $(o).val(15);
            // return
        }
    }
    // console.log($(o).data('field'));
    if ($(o).data('field') == 'TX_DATE_TIME'){
        data[$(o).data('field')] = $(o).val();
        data['IN_EPOCH'] = Date.parse($(o).val()).toString().slice(0,-3);

    } else {
        data[$(o).data('field')] = $(o).val();
    }
    var ajxData       = {};
    ajxData['do']     = 'updateField';
    ajxData['act']    = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData.FIELD_IDX = $(o).data('key');
    ajxData.VALUE_IDX = $(o).data('index'); 
    ajxData.TABLE     = $(o).data('table'); 
    // console.log(ajxData);
    ajxData.jsonData  = JSON.stringify(data);
    
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            console.log(str); 
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
            // $('#modal_content').html(str);
        }
    });
}
function updateTicketCheckinStatus(o, flightIDX){
    var elementID = $(o).attr('id');
    if (elementID.indexOf('FlightStatus_') == 0){
        // if ($(o).is(':checked')){
            $('#ForScore_'+flightIDX).prop('checked', 'checked');
            // console.log("For Score");
            // clearNFSCheckBoxes();
        // } else {
        //     $('#NotForScore_'+flightIDX).prop('checked', 'checked');
        //     // console.log("Not For Score");
        // }
    }
}
function updateCheckItems(o){
    $('#savedMessage').fadeIn();
    // var field = $(o).data('field');
    var ajxData = {};
    var data = {};
    var elementID = $(o).attr('id');
    var elementField = $(o).data('field');
    console.log('elementField  = ' + elementField );
    console.log('value  = ' + $(o).val() );
    // return;
    console.log('elementID  = ' + elementID );
    if (elementField == 'BO_STATIC'){
        var staticCount = 0;
        $('.inStaticCount').each(function(){
            if ($(this).is(':checked')){
                staticCount++;
                if (staticCount > 1){
                    $(this).prop('checked', false)
                    staticCount--;
                    alert("STOP: \n\nTeams are allowed to land in the Static Zone ONLY once.");
                }
            }
        });
    }
    if ($(o).is(':radio')) {
        data[$(o).data('field')] = $(o).val() ;
        // console.log("Radio");
    } else {
        if ($(o).is(':checked')){
            data[$(o).data('field')] = 1;
            if (elementField == 'BO_INZONE'){
                $('.inZoneEntry_'+$(o).data('index')).removeClass('w3-disabled');
            }
        } else {
            if (elementID.indexOf('FlightStatus_') == 0){
                data[$(o).data('field')] = 2;
            } else {
                data[$(o).data('field')] = 0;
            }
            if (elementField == 'BO_INZONE'){
                $('.inZoneEntry_'+$(o).data('index')).addClass('w3-disabled');
                $('.inZoneEntry_'+$(o).data('index')).prop('checked', false);
                $('.inZoneEntry_'+$(o).data('index')).val(0);
                data.BO_STATIC = 0;
                data.IN_DISTANCE = 0;
            }
        }
    }
    if (elementID.indexOf('DQ') == 0 || elementID.indexOf('SCRATCH') == 0 || elementID.indexOf('CRASH') == 0 ){
        $('#NotForScore_'+ $(o).data('index')).prop('checked',true);
        data.IN_STATUS = 2;
    }
    ajxData['do'] = 'updateField';
    ajxData['act'] = 'print';
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    ajxData['FIELD_IDX'] = $(o).data('key');
    ajxData['VALUE_IDX'] = $(o).data('index'); 
    ajxData['TABLE'] = $(o).data('table'); 
    ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            // console.log(str); 
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
            channel.publish('sae_ps_updateTicketStatus', JSON.stringify(ajxData));
        }
    });
    return;    
}
function updateAttemptStatus(e, o, flightIDX) {
    var value = $(o).val();
    $('.ticket_corridian').hide();
    $('#cor_'+value).show();
    if (value ==0 || value == 99){
        $('#Inspection').prop('disabled', 'disabled');
    } else {
        $('#Inspection').prop('disabled', '');
    }
    // if (value == 1){
    //     $('#FlightStatus_'+flightIDX).prop('checked','checked');
    // } else {
    //     $('#FlightStatus_'+flightIDX).prop('checked','');
    // }
    if (value !=2){
        noFly = [];
        resetTags('item');
    }
    $('#savedMessage').fadeIn();
    var ajxData = {};
    var data = {};
    data[$(o).data('field')] = $(o).val();
    ajxData['do'] = 'updateField';
    ajxData['act'] = 'print';
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    ajxData['FIELD_IDX'] = $(o).data('key');
    ajxData['VALUE_IDX'] = $(o).data('index'); 
    ajxData['TABLE'] = $(o).data('table'); 
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            // console.log(str); 
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
            channel.publish('sae_ps_updateTicketStatus', JSON.stringify(ajxData));
        }
    });
    // console.log(value);
    // console.log('#cor_'+value);
}

function updateRadiotems(e, o, flightIDX) {

    var item = $(o).attr('id');
    // var flightIDX = $(o).data('index');
    if(item.indexOf('checkedOut_') == 0){
        if ($('#Inspection').is(':checked')) {
            e.stopImmediatePropagation(); 
            alert ("This action is not allowed at this time.  This ticket has been flagged as reinspection required.\n\nYour options are:\n  1. Clear the inspection via the inspecion tab first\n. 2. Uncheck the Reinspectin first.")
            $(o).prop('checked', false);
            var prevValue = $('#radio-previous').val();
            if (prevValue == 1 ) {
                $('#ForScore_'+flightIDX).prop('checked', true);
            } else {
                $('#NotForScore_'+flightIDX).prop('checked', true);
            }
            return;   
        }
        $('#Inspection').prop('disabled', 'disabled');
    } else {
        $('#Inspection').prop('disabled', '');
    }
    $('#savedMessage').fadeIn();
    var ajxData = {};
    var data = {};
    data[$(o).data('field')] = $(o).val();
    if ($(o).val() == 2) {
        $('#FlightStatus_'+flightIDX).prop('checked','');
        console.log("update check item to false");
    } 
    if ($(o).val() == 0){
        $('#FlightStatus_'+flightIDX).prop('checked','');
        data.BO_SCRATCH = 0;
        data.BO_CRASH = 0;
        data.BO_DQ = 0;
        clearNFSCheckBoxes();
    }
    if ($(o).val() == 1){
        $('#FlightStatus_'+flightIDX).prop('checked','checked');
        data.BO_SCRATCH = 0;
        data.BO_CRASH = 0;
        data.BO_DQ = 0;
        clearNFSCheckBoxes();
    }
// FlightStatus_
    ajxData['do'] = 'updateField';
    ajxData['act'] = 'print';
    ajxData['eventIDX'] = $.cookie('FK_EVENT_IDX');
    ajxData['FIELD_IDX'] = $(o).data('key');
    ajxData['VALUE_IDX'] = $(o).data('index'); 
    ajxData['TABLE'] = $(o).data('table'); 
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            // console.log(str); 
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
        }
    });
    return;  
}
function clearReinspection(o, flightIDX, inNumber, inspectIDX) {
    var jsYes = confirm("Click [ OK ] to confirm the team has cleared Tech Re-Inspection.");
    if (!jsYes){return}
    $('#savedMessage').show();
    var data = {};
    var data2 = {};
    var ajxData = {};
    var notify = {};
    data.BO_REINSPECT        = 0;
    data2.BO_STATUS          = 0;
    data2.IN_CLEARED_BY      = $.cookie('PK_USER_IDX');;
    ajxData.do               = 'clearReinspection';
    ajxData.act              = 'print';
    ajxData.eventIDX         = $.cookie('FK_EVENT_IDX');
    ajxData.flightIDX        = flightIDX;
    ajxData.inNumber         = inNumber;
    ajxData.FK_TEAM_IDX      = $(o).data('fk_team_idx');
    ajxData.FK_FLIGHT_IDX    = flightIDX;
    ajxData.IN_NUMBER        = inNumber;
    ajxData.PK_REINSPECT_IDX = inspectIDX;
    ajxData.teamIDX          = $(o).data('fk_team_idx');
    ajxData.BO_REINSPECT     = JSON.stringify(data);
    ajxData.BO_STATUS        = JSON.stringify(data2);
    notify.FK_TEAM_IDX       = $(o).data('fk_team_idx');
    notify.NOTIFY            = 0;
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(str){
            // console.log($('#Inspection').prop()); 
            $('#reinspectionChecklist').slideUp();
            tags = [];
            resetTags('tag');
            $('#Inspection').prop("checked",false);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 400);
            channel.publish('sae_ps_clearInspection', JSON.stringify(ajxData));
            channel.publish('sae_ps_notifyTeamsOfReinspection', JSON.stringify(notify));
            $(o).replaceWith('<i class="fa fa-check-square-o w3-text-green" aria-hidden="true"></i>');
        }
    });
}
function openReInspectionStatus(o, flightIDX) {
    var data = {};
    var ajxData = {};
    var notify = {};
    // var obj = {};
    var addBtn = $('#TEAM_TICKET_ADDER_'+$(o).data('team'));
    data.FK_FLIGHT_IDX = flightIDX;
    data.IN_REQUEST_BY = $.cookie('PK_USER_IDX');
    data.FK_TEAM_IDX   = $(o).data('team');
    data.IN_ROUND      = $(o).data('round');
    data.IN_NUMBER     = $(o).data('number');
    data.FK_EVENT_IDX  = $.cookie('FK_EVENT_IDX');
    notify.FK_TEAM_IDX = $(o).data('team');
    // obj = {...data};
    if ($(o).is(':checked')){
        $('#reinspectionChecklist').slideDown();
        ajxData.do     = 'getRequestInspectionList';
        data['BO_STATUS'] = 1;
        tags = [];
        $('#checkedOut_'+flightIDX).prop('disabled','disabled');
        $('#checkedOut_'+flightIDX).prop('checked','');
        notify.NOTIFY = 1;
    } else {
        $('#reinspectionChecklist').slideUp();
        ajxData.do      = 'cancelReinspection';
        tags = [];
        resetTags('tag');
        data['BO_STATUS'] = 0;
        $('#checkedOut_'+flightIDX).prop('disabled','');
        notify.NOTIFY = 0;
    }
    var jsonData = JSON.stringify(data);
    ajxData.act       = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData.flightIDX = flightIDX;
    ajxData.jsonData  = jsonData;
    channel.publish('sae_ps_notifyTeamsOfReinspection', JSON.stringify(notify));
    // console.log(notify);
    // console.log("something");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: ajxData,
        success: function(inspectIDX){

            resetTags('tag');
            tags = [];
            if ($(o).is(':checked')){
                data.inspectIDX = inspectIDX;
                data.PK_REINSPECT_IDX = inspectIDX;
                $('#Inspection').val(inspectIDX);
                channel.publish('sae_ps_reinspectionRequired', JSON.stringify(data));
                
            } else {
                data.inspectIDX = $('#Inspection').val();
                data.PK_REINSPECT_IDX = $('#Inspection').val();
                channel.publish('sae_ps_cancelInspection', JSON.stringify(data));
                $('#Inspection').val('');
            }

        }
    });
}


// -- 2021 ---------------------------------------------------------------------------------------------
function sae_showUsedTicketCount(){
    var eventIDX = $.cookie('LOCATION');
    $.modal('Ticket Summary', '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_showUsedTicketCount','act':'print','eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
function sae_showSetFlightTicketLimits(){
        // console.log("flightIDX="+flightIDX+", teamIDX="+teamIDX);
    var eventIDX = $.cookie('LOCATION');
    $.modal('Event Attributes', '50%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_showSetFlightTicketLimits','act':'print','eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
function sae_showListOfMissingSlope(){
    // console.log("flightIDX="+flightIDX+", teamIDX="+teamIDX);
    var eventIDX = $.cookie('LOCATION');
    $.modal('Team\s Prediction Bonus', '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_showListOfMissingSlope','act':'print','eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
function sae_showListOfMissingStd(){
    // console.log("flightIDX="+flightIDX+", teamIDX="+teamIDX);
    var eventIDX = $.cookie('LOCATION');
    $.modal('Team\'s Standard Deviation', '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_showListOfMissingStd','act':'print','eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}    
function sae_openTab(o, tabName, teamIDX){
    var activeTab = "w3-white w3-border-left w3-border-top w3-border-right";
    $('.tablink').removeClass(activeTab);
    $(o).addClass(activeTab);
    $('.userTabs').each(function(){
        if (!$(this).hasClass('w3-hide')){
            $(this).addClass('w3-hide');
        }
        if (this.id == tabName){
            $(this).removeClass('w3-hide');
        }
    });
    $("#ScoreContainer").html('..Please Recalculate..');
    if (tabName == 'Gtv') {
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/flight.pl',
            data: {'do':'sae_getMaxEffectiveWater','act':'print', 'teamIDX':teamIDX},
            success: function(str){
                $('#Gtv').html(str);
            }
        });
    }
}
function showFlightTable(){
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'showFlightTable','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function sae_openCheckoutCard(teamIDX, inNumber, classIDX){
    var round = 1;
    var location = $.cookie('LOCATION');
    if (classIDX===1){round = $.cookie('RegClassRound');}
    if (classIDX===2){round = $.cookie('AdvClassRound');}
    if (classIDX===3){round = $.cookie('MicClassRound');}
    $.modal("Checkout Flight Log for Team #:"+inNumber, "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openCheckoutCard','act':'print','round':round,'teamIDX':teamIDX,'classIDX':classIDX,'inNumber':inNumber,'location':location},
        success: function(str){
            // alert(str);
            $('#modal_content').html(str);
        }
    });
}
function sae_checkoutFlightLog(obj, teamIDX, classIDX, inNumber){
    var round = $('#sae_roundSelection :selected').val();
    var location = $.cookie('LOCATION');
    if (classIDX===1){$.cookie('RegClassRound',round);}
    if (classIDX===2){$.cookie('AdvClassRound',round);}
    if (classIDX===3){$.cookie('MicClassRound',round);}
    // console.log('teamIDX='+teamIDX+', classIDX='+classIDX+', round='+round);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_checkoutFlightLog','act':'print','round':round,'teamIDX':teamIDX,'classIDX':classIDX,'location':location,'inNumber':inNumber},
        success: function(str){
            // var o = JSON.parse(str);
            // $('#TEAM_'+teamIDX).replaceWith(str);
            // $('#TEAM_'+teamIDX).replaceWith(o.btn);
            // console.log(str);
            // $('#STATUS_'+teamIDX).html(str);
            $(obj).close('sae-top');
            channel.publish('sae_flightLogs_checkoutCard', str);
            // channel.publish('saeFlightLogs', 'hello');
        }
    });
}
function sae_updateGTVWaterCarried(o, txField, teamIDX, maxLimit){
    $('#savedMessage').fadeIn(250);
    var inValue = $(o).val();
    if (inValue>maxLimit){
        inValue=maxLimit;
        alert("WARNING\n\nAs the result of Landing Penalties and/or Detached Item(s) Penalties, the effective water is less than the actual water delivered. \n\n An Effective Payload of "+maxLimit+"(lbs) will used instead.");
        $(o).val(inValue);
    }
    console.log(inValue);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateTeamInfo','act':'print','inValue':inValue,'txField':txField, 'teamIDX':teamIDX},
        success: function(str){
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 750);
        }
    });
}
function sae_updateEventInfo(o){
    $('#savedMessage').fadeIn(200);
    var inValue = $(o).val();
    var txField = $(o).data('key');
    var eventIDX = $.cookie('LOCATION');
    // console.log('inValue='+inValue);
    // console.log('txField='+txField);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateEventInfo','act':'print','inValue':inValue,'txField':txField, 'eventIDX':eventIDX},
        success: function(str){
            setTimeout(function(){ $('#savedMessage').fadeOut(375); }, 750);
        }
    });
}
function sae_updateTeamInfo(o, txField, teamIDX){
    $('#savedMessage').fadeIn(250);
    var inValue = $(o).val();
    console.log(inValue);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateTeamInfo','act':'print','inValue':inValue,'txField':txField, 'teamIDX':teamIDX},
        success: function(str){
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 750);
        }
    });
    
}
function sae_updateFlightCardField(flightIDX, inValue, txField, teamIDX){
    // console.log('txField='+txField);
    $('#savedMessage').fadeIn(250);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateFlightCardField','act':'print','flightIDX':flightIDX,'inValue':inValue,'txField':txField, 'teamIDX':teamIDX},
        success: function(str){
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 750);
        }
    });
}
function sae_updateTimeOfFlight(obj, flightIDX, teamIDX){
    // var weatherIDX = $(obj).val();
    var weatherIDX = $('#TX_TIME_'+flightIDX+' option:selected').val();
    var txTime = $('#TX_TIME_'+flightIDX+' option:selected').text();
    var inDensity = $('#TX_TIME_'+flightIDX+' option:selected').data("value");
    console.log (weatherIDX);
    sae_updateFlightCardField(flightIDX, weatherIDX, 'FK_WEATHER_IDX', teamIDX);
    sae_updateFlightCardField(flightIDX, txTime, 'TX_TIME', teamIDX);
    sae_updateFlightCardField(flightIDX, inDensity, 'IN_DENSITY', teamIDX);
}
function sae_deleteFlightLog(o, flightIDX, inType, teamIDX, inNumber, classIDX, inRound){
    var txt = "You are about to DELETE flight attempt #"+inRound+".  Click [OK] To confirm.";
    if (inType==1){
        txt = "You are about to CANCEL flight attempt #"+inRound+".  Click [OK] To confirm.";
    }
    var jsYes = confirm(txt);
    if (!jsYes) {return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_deleteFlightLog','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX,'inType':inType,'inNumber':inNumber,'classIDX':classIDX},
        success: function(str){
            if(inType == 1 ){
                $(o).close();
                // $('#TEAM_'+teamIDX).replaceWith(str);
                channel.publish('sae_flightLogs_cancelFlight', str);
            }
            $('#FlightRecord_'+flightIDX).remove();
            
        }
    });
}
function sae_cancelTicketEntry(obj){
    $(obj).close('sae-top');
}
function sae_saveAdvFlightTicket(obj, flightIDX, inValue, teamIDX, inNumber, classIDX, inRound){
    var jsYes = confirm("Click [ OK ] to save flight ticket data.");
    if (!jsYes){return}
    console.log("flight="+flightIDX + "\n inValu=" + inValue + "\n teamIDX=" + teamIDX + "\n inNumber=" + inNumber + "\n classIDX=" + classIDX + "\n inRound=" + inRound);
    var IN_AUTO = 0;
    var IN_MINOR = 0;
    var IN_MAJOR = 0;
    var IN_CRASH = 0;
    var IN_TOF = $('#IN_TOF').val();
    var IN_DISTANCE = $('#IN_DISTANCE').val();
    var IN_WATER_FLT = $('#IN_WATER_FLT').val();
    
    if ($("#AUTO ")[0].checked){IN_AUTO = 1}
    if ($("#MINOR ")[0].checked){IN_MINOR = 1}
    if ($("#MAJOR ")[0].checked){IN_MAJOR = 1}
    if ($("#CRASH ")[0].checked){IN_CRASH = 1}
    console.log ("IN_AUTO=" + IN_AUTO + "\n");
    console.log ("IN_MINOR=" + IN_MINOR + "\n");
    console.log ("IN_MAJOR=" + IN_MAJOR + "\n");
    console.log ("IN_CRASH=" + IN_CRASH + "\n");
    console.log ("IN_TOF=" + IN_TOF+ "\n");
    console.log ("IN_DISTANCE=" + IN_DISTANCE + "\n");
    console.log ("IN_WATER_FLT=" + IN_WATER_FLT + "\n");


}
function sae_updateFlightStatus(obj, flightIDX, inValue, teamIDX, inNumber, classIDX, inRound){
    var reInspection = 0;
    if (inValue==3){
        var jsYes = confirm("Will this aircraft require a re-inspection before the next flight?\n\nClick [ OK ] to generate a Crash Report.");
        if (jsYes){reInspection = 1;}
    } 
    // console.log('inRound='+inRound);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateFlightStatus','act':'print','flightIDX':flightIDX,'inValue':inValue,'teamIDX':teamIDX,'inNumber':inNumber,'classIDX':classIDX,'reInspection':reInspection,'inRound':inRound},
        success: function(str){
            $(obj).close('sae-top');
            // $('#TEAM_'+teamIDX).replaceWith(str);
            // console.log('str='+str);
            channel.publish('sae_flightLogs_crashFlight', str);
            if (reInspection==1){
                sae_createReinspection(flightIDX, teamIDX, inNumber);
            } else {
                $(obj).close('sae-top');
                // $('#TEAM_'+teamIDX).replaceWith(str);
               
            }
        }
    });
}
function sae_updateFlightState(o, flightIDX, teamIDX, inNumber, classIDX, inRound){
    var inState = $('#flightState_'+flightIDX+' option:selected').val();
    sae_updateFlightCardField(flightIDX, inState, 'IN_STATUS');
    if(inState == 3){
        sae_updateFlightStatus(o, flightIDX, 3, teamIDX, inNumber, classIDX, inRound);
    }
}
function sae_updateInZone(obj, flightIDX, txField){
    if ($(obj).is(':checked')){
        sae_updateFlightCardField(flightIDX, 1, txField);
        $('#IN_DISTANCE_'+flightIDX).removeClass('w3-disabled');
        $('#IN_DISTANCE_'+flightIDX).prop( "disabled", false );
    } else {
        sae_updateFlightCardField(flightIDX, 0, txField);
        $('#IN_DISTANCE_'+flightIDX).addClass('w3-disabled');
        $('#IN_DISTANCE_'+flightIDX).prop( "disabled", true );
    }
}
function sae_updateLandingPenalty(obj, flightIDX, txField){
    if (txField == 'BO_APADA') {
        if ($(obj).is(':checked')){
            sae_updateFlightCardField(flightIDX, 0, txField);
            // console.log(txField + "=0");
        } else {
            sae_updateFlightCardField(flightIDX, 1, txField);
            // console.log(txField + "=1");
        }
    } else {
        if ($(obj).is(':checked')){
            sae_updateFlightCardField(flightIDX, 1, txField);
        } else {
            sae_updateFlightCardField(flightIDX, 0, txField);
        }
    }
    
}
function sae_showFlightNotes(flightIDX, teamIDX){
    $.modal2("Notes", "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_showFlightNotes','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX},
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
}
function sae_saveFlightNotes(obj, flightIDX, teamIDX, newNote){
    var inValue = encodeURIComponent(escapeVal($('#NOTES_'+flightIDX).val(),"<br />"));
    var eventIDX = $.cookie('LOCATION');
    $(obj).close('sae-top2');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_saveFlightNotes','act':'print','flightIDX':flightIDX,'inValue':inValue,'eventIDX':eventIDX,'teamIDX':teamIDX,'newNote':newNote},
        success: function(str){
            // console.log(str);
        }
    });
}
function sae_recordFlightCard(obj, flightIDX, teamIDX, inNumber, round){
    // console.log("flightIDX="+flightIDX+", teamIDX="+teamIDX);
    var location = $.cookie('LOCATION');
    $.modal('Team#: '+inNumber+' - Record Flight Status', '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        // data: {'do':'sae_recordFlightCard','act':'print','round':round,'teamIDX':teamIDX},
        data: {'do':'sae_recordFlightCard','act':'print','round':round,'teamIDX':teamIDX,'location':location,'inNumber':inNumber,'flightIDX':flightIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
// ADVANCED CLASS
function sae_recordFlightCard_Adv(obj, flightIDX, teamIDX, inNumber, round){
    var location = $.cookie('LOCATION');
    $.modal('Team#: '+inNumber+' - Record Flight Status', '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_recordFlightCard_Adv','act':'print','round':round,'teamIDX':teamIDX,'location':location,'inNumber':inNumber,'flightIDX':flightIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}// MICRO CLASS
function sae_recordFlightCard_Mic(obj, flightIDX, teamIDX, inNumber, round){
    // console.log(obj, flightIDX, teamIDX, inNumber, round);
    var location = $.cookie('LOCATION');
    $.modal('Team#: '+inNumber+' - Record Flight Status', '90%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_recordFlightCard_Mic','act':'print','round':round,'teamIDX':teamIDX,'location':location,'inNumber':inNumber,'flightIDX':flightIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
// CALCULATORS   ===================================================
function sae_openTimeCalculator(flightIDX, txtID){
    var inValue = parseFloat($('#'+txtID).val());
    var minute = 0;
    var seconds = 0;
    if (inValue){
        minute = Math.trunc(inValue/60);
        seconds = (inValue - (minute*60));
    } 
    $.modal2('Time Calculator', '30%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openTimeCalculator','act':'print','flightIDX':flightIDX,'txtID':txtID,'minute':minute,'seconds':seconds},
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
}
function sae_convertTime(o, flightIDX, txtID){
    var m = 0;
    var s = 0;
    if ($('#IN_MINUTE').val()){m = parseFloat($('#IN_MINUTE').val())}
    if ($('#IN_SECOND').val()) {s = parseFloat($('#IN_SECOND').val())}
    var converted = (m * 60) + s;
    // console.log(converted);
    var txField = 'IN_TOF';
    sae_updateFlightCardField(flightIDX, converted, txField);
    $('#'+txtID).val(converted);
    console.log('#'+txtID);
    $(o).close('sae-top2');
} 
function sae_openSpanCalulator(flightIDX, txtID) {
    var inValue = parseFloat($('#'+txtID+flightIDX).val()).toFixed(3);
// console.log('inValue = ' + inValue);
    var feet = (inValue/12);
// console.log('feet = ' + feet);
    var inch = (feet % 1) * 12;
// console.log('inch = ' + inch);
    $.modal2('Wingspan Calculator', '30%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openSpanCalulator','act':'print','flightIDX':flightIDX,'txtID':txtID,'feet':feet,'inch':inch.toFixed(3)},
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
}
function sae_convertSpan(o, flightIDX, txtID) {
    var txField = 'IN_SPAN';
    var feet    = 0;
    var inch    = 0;
    if ($('#IN_FEET').val()){feet = parseFloat($('#IN_FEET').val())}
    if ($('#IN_INCH').val()) {inch = parseFloat($('#IN_INCH').val())}
    var converted = parseFloat((feet*12) + inch).toFixed(1);
    console.log('converted = '+ converted);
    sae_updateFlightCardField(flightIDX, converted, txField);
    $('#'+txtID+flightIDX).val(converted);
    $(o).close('sae-top2');
    // body...
}
function sae_openCalculator(flightIDX, txtID){
    var inValue = parseFloat($('#'+txtID+flightIDX).val());
    var lbs = Math.trunc(inValue);
    var ozs = (inValue % 1) * 16;
    $.modal2('Weight Calculator', '30%');
    // console.log(flightIDX);
    // console.log(txtID);
    // console.log(lbs);
    // console.log(ozs);
    // console.log('inValue' + inValue);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openCalculator','act':'print','flightIDX':flightIDX,'txtID':txtID,'lbs':lbs,'ozs':ozs},
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
}
function sae_convertWeight(o, flightIDX, txtID){
    var pound = 0;
    var ounce = 0;
    if ($('#IN_POUND').val()){pound = parseFloat($('#IN_POUND').val())}
    if ($('#IN_OUNCE').val()) {ounce = parseFloat($('#IN_OUNCE').val())}
    var converted = parseFloat(pound + (ounce/16)).toFixed(3);
    // console.log(converted);
    var txField = 'IN_WEIGHT';
    if (txtID == 'WATER_'){txField='IN_WATER'}
    sae_updateFlightCardField(flightIDX, converted, txField);
    $('#'+txtID+flightIDX).val(converted);
    $(o).close('sae-top2');
}
// CRASH REPORTS ===================================================
function sae_createReinspection(flightIDX, teamIDX, inNumber){
    var location = $.cookie('LOCATION');
    $.modal('<i class="fa fa-wrench f2-2x w3-margin-right" aria-hidden="true"></i>Re-Inspection Crash Checklist for Team #:'+inNumber,'65%', 'w3-red');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_createReinspection','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX, 'location':location},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
function sae_submitCrashReport(o, flightIDX, teamIDX){
    var obj = {};
    var team = {};
    var items = [];
    var location = $.cookie('LOCATION');
    // var others = $('#ITEM_OTHERS').val();
    $('.sae-inspection_item').each(function(i){ 
        if ($(this).is(":checked")){items.push($(this).val());}
    });
    // obj.LIST = items.join(";");
    obj.CL_DESCRIPTION = items.join(";");
    obj.FK_FLIGHT_IDX=flightIDX;
    obj.FK_EVENT_IDX=location;
    obj.FK_TODO_TYPE_IDX=4;
    obj.FK_TEAM_IDX=teamIDX;
    obj.TX_TIME='Before Next Flight';
    obj.TX_ROOM='Re-Inspection Table';
    obj.TX_STATUS='Crashed: Re-Inspection Required';
    $('.sae-input').each(function(i){
        if ($(this).data('key') =='CL_COMMENT'){
            obj[$(this).data('key')]= encodeURIComponent(escapeVal($(this).val(),"<br />"));
        } else {
            obj[$(this).data('key')]=$(this).val();
        }
    });
    team.PK_TEAM_IDX   = teamIDX;
    team.FK_FLIGHT_IDX = flightIDX;
    var jsonData = JSON.stringify( obj );
    // console.log (jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_submitCrashReport','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX,'eventIDX':location,'jsonData':jsonData},
        success: function(str){
            // console.log(str);
            channel.publish('sae_crashreport', str);
            channel.publish('sae_alertStudentOfCrashReport', team);
            $(o).close('sae-top');
        }
    });
}
function sae_openClearCrash(o, teamIDX, inNumber, classIDX, flightIDX){
    $.modal('<i class="fa fa-wrench f2-2x w3-margin-right" aria-hidden="true"></i>Clear Inspection','65%', 'w3-red');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openClearCrash','act':'print','flightIDX':flightIDX,'classIDX':classIDX,'teamIDX':teamIDX,'inNumber':inNumber },
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
function sae_deleteCrashReportCard(todoIDX, flightIDX){
    var jsYes = confirm("Deleting Crash Report Card...\n\nAre you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_deleteCrashReportCard','act':'print','todoIDX':todoIDX,'flightIDX':flightIDX},
        success: function(str){
            console.log('flightIDX='+ flightIDX + '\n');
            console.log('str='+str+'\n');
            $('#HISTORY_TODO_'+todoIDX).remove();
            // $(o).close('sae-top');
            channel.publish('sae_deletecrash', str);
            // $('#TEAM_'+teamIDX).replaceWith(str);
        }
    });
}
function sae_deleteCrashReport(o, flightIDX, teamIDX){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    var team = {};
    team.PK_TEAM_IDX   = teamIDX;
    team.FK_FLIGHT_IDX = flightIDX;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_deleteCrashReport','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX},
        success: function(str){
            $(o).close('sae-top');
            channel.publish('sae_flightLogs_crashFlight', str);
            channel.publish('sae_clearTeamToFly', team);
            // showFlightTable();
            // $('#TEAM_'+teamIDX).replaceWith(str);
        }
    });
}
function sae_clearReinspection(o, flightIDX, teamIDX, classIDX, txNumber){
    var jsYes = confirm("Click [ OK ] to clear the team for flight.");
    if (!jsYes){return}
    var team = {};
    team.PK_TEAM_IDX   = teamIDX;
    team.FK_FLIGHT_IDX = flightIDX;
    team.FK_CLASS_IDX  = classIDX;
    team.IN_NUMBER     = txNumber;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_clearReinspection','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX,'classIDX':classIDX,'txNumber':txNumber},
        success: function(str){
            $(o).close('sae-top');
            channel.publish('sae_flightLogs_crashFlight', str);
            channel.publish('sae_clearTeamToFly', team);
            // $('#TEAM_'+teamIDX).replaceWith(str);
        }
    });
}
// ===============================================
function sae_createFlightCard(obj, inRound, teamIDX, classIDX, teamTitle){
    var location = $.cookie('LOCATION');
    // console.log("inRound="+inRound+", teamIDX="+teamIDX+", classIDX="+classIDX+", teamTitle="+teamTitle+"\n");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_createFlightCard','act':'print','teamTitle':teamTitle,'classIDX':classIDX,'location':location,'teamIDX':teamIDX,'inRound':inRound},
        success: function(str){
            // console.log(str);
            $(obj).replaceWith(str);
        }
    });
}
function sae_showFlightStats(){
    var divName = 'TEMP_DIV_FLIGHT_STATS';
    var location = $.cookie('LOCATION');
    createNewModalDiv('Flight Operations Statistics',divName,650);
    

    
    var regGreen = $('.stats_1_w3-green').length;
    var regRed = $('.stats_1_w3-red').length;
    var regGrey = $('.stats_1_w3-grey').length;
    
    var advGreen = $('.stats_2_w3-green').length;
    var advRed = $('.stats_2_w3-red').length;
    var advGrey = $('.stats_2_w3-grey').length;
    
    var micGreen = $('.stats_3_w3-green').length;
    var micRed = $('.stats_3_w3-red').length;
    var micGrey = $('.stats_3_w3-grey').length;
    
    var totalAllGreen = regGreen + advGreen + micGreen;
    var totalAllRed   = regRed   + advRed   + micRed;
    var totalAllGrey  = regGrey  + advGrey  + micGrey;

    
    var str = '<table class="w3-table-all">';
    str += '<tr>';
    str += '<th style="text-align: right">Class</th>';
    str += '<th style="text-align: right">Successful</th>';
    str += '<th style="text-align: right">Unsuccessful</th>';
    str += '<th style="text-align: right">Crashed</th>';
    str += '<th style="text-align: right">Attempts</th>';
    str += '</tr>';
    str += '<tr>';
    str += '<td style="text-align: right">Regular</td>';
    str += '<td style="text-align: right">'+regGreen+'</td>';
    str += '<td style="text-align: right">'+regGrey+'</td>';
    str += '<td style="text-align: right">'+regRed+'</td>';
    str += '<td style="text-align: right">'+(regGreen+regGrey+regRed)+'</td>';
    str += '</tr>';
    str += '<tr>';
    str += '<td style="text-align: right">Advanced</td>';
    str += '<td style="text-align: right">'+advGreen+'</td>';
    str += '<td style="text-align: right">'+advGrey+'</td>';
    str += '<td style="text-align: right">'+advRed+'</td>';
    str += '<td style="text-align: right">'+(advGreen+advGrey+advRed)+'</td>';
    str += '</tr>';
    str += '<tr>';
    str += '<td style="text-align: right">Micro</td>';
    str += '<td style="text-align: right">'+micGreen+'</td>';
    str += '<td style="text-align: right">'+micGrey+'</td>';
    str += '<td style="text-align: right">'+micRed+'</td>';
    str += '<td style="text-align: right">'+(micGreen+micGrey+micRed)+'</td>';
    str += '</tr>';
    str += '<tr style="font-weight: bold;">';
    str += '<td style="text-align: right">Overall</td>';
    str += '<td style="text-align: right">'+totalAllGreen+'</td>';
    str += '<td style="text-align: right">'+totalAllGrey+'</td>';
    str += '<td style="text-align: right">'+totalAllRed+'</td>';
    str += '<td style="text-align: right">'+(totalAllGreen+totalAllGrey+totalAllRed)+'</td>';
    str += '</tr>';
    str += '</table>';
    $('#x_modal_Content').html(str);
    // console.log("total w3-green="+totalAllGreen);
    // console.log("total w3-red="+totalAllRed);
    // console.log("total w3-grey="+totalAllGrey);
    // console.log("Regular Class w3-green="+regGreen);
    // alert("done");
}
function sae_openFlightCard(teamIDX, classIDX, flightIDX, inRound, teamTitle){
    var divName = 'TEMP_DIV_FLIGHT_CARD';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Team #</b>'+teamTitle+' (Round '+inRound+' Flight Card)',divName,850);
    $('#x_modal_Content').html(loading);
    // console.log("teamIDX="+teamIDX+", classIDX="+classIDX+", flightIDX="+flightIDX+"\n");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openFlightCard','act':'print','flightIDX':flightIDX,'classIDX':classIDX, 'location':location,'teamIDX':teamIDX,'divName':divName,'inRound':inRound},
        success: function(str){
            $('#x_modal_Content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function sae_deleteFlightCard(flightIDX, divName){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    // console.log(divName);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_deleteFlightCard','act':'print','flightIDX':flightIDX},
        success: function(str){
            showFlightTable();
            $('#'+divName).remove();
        }
    });    
}
function sae_updateCrashStatus(flightIDX, teamIDX, divName, inRound){
    var jsYes = confirm("Click [ OK ] to send this aircraft for re-inspection.");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateCrashStatus','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX,'inRound':inRound},
        success: function(str){
            if (jsYes) {
                sae_createReinspection(flightIDX, teamIDX, inRound, divName);
            } else {
                showFlightTable();
                $('#'+divName).remove();
            }
        }
    }); 
}
function sae_updateDNFStatus(flightIDX, divName, inRound){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateDNFStatus','act':'print','flightIDX':flightIDX,'inRound':inRound},
        success: function(str){
            showFlightTable();
            $('#'+divName).remove();
        }
    }); 
}
// CRASH REPORTS ===================================================

// SUCCESS REPORTS ===================================================
function sae_updateSuccessStatus(flightIDX, divName, inRound){
    var obj = {};
    var items = new Array();

    $('.sae-flight-input').each(function(i){
        obj[$(this).data('key')]=$(this).val();
    });
    $('.sae-checked-item').each(function(i){ 
        if ($(this).is(":checked")){
            obj[$(this).data('key')]=$(this).val();
        }
    });
    
    obj['TX_STATUS'] = '<i class="fa fa-thumbs-o-up"></i> Good';
    obj['IN_STATUS'] = 1;
    obj['TX_COLOR'] = 'w3-green';
    var weatherIDX = $('#TX_TIME_2 option:selected').val(); 
    var textTime = $('#TX_TIME_2 option:selected').text();
    obj['FK_WEATHER_IDX'] = weatherIDX;
    obj['TX_TIME'] = textTime;

    var jsonData = JSON.stringify( obj );
    // console.log (jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateSuccessStatus','act':'print','flightIDX':flightIDX,'jsonData':jsonData},
        success: function(str){
            // console.log(str);
            showFlightTable();
            $('#'+divName).remove();            
        }
    });
    //  
}
function sae_openWeightCalculations(){
    $('#CALC').toggleClass('w3-hide');
}
function sae_applyto(target, limit){
    var lbs = parseInt($('#PAYLOAD_LB').val());
    var oz = $('#PAYLOAD_OZ').val()*1;
    // console.log (oz);
    var payload = (lbs + (oz/16)).toFixed(2);
    if (payload > limit){
        var response = confirm("The calculated weight you've entered ("+payload+") is more than the allowed of weight of "+limit+" lbs.  This max-weight was pre-determined at the weigh-in during Tech-Inspection.\n\nPress [ OK ] to use the allowable Max Weight.\nPress [ Cancel ] to reset and enter the payload weight again.");
        if (response){
            $('.'+target).val(limit);
        } else {
            $('#PAYLOAD_LB').val('');
            $('#PAYLOAD_OZ').val('');
            $('[tabindex=4]').focus();
        }
        // alert("The calculated weight you've entered ("+payload+") is more than the allowed of weight of "+limit+" lbs.  This max-weight was pre-determined at the weigh-in during Tech-Inspection.");
    } else {
        $('.'+target).val(payload);
    }
    return;
}
function sae_advancedClass_applyto(target){
    var no = parseInt($('#PAYLOAD_NO').val());
    var oz = $('#PAYLOAD_OZ').val()*1;
    // console.log (oz);
    var payload = (no*oz).toFixed(2);
    $('#'+target).val(payload);
    return;
}
// ============= MICRO CLASS ==================================
function sae_checkMaxWeight(obj, maxWeight){
    if ($(obj).val() > maxWeight){
        var response = confirm("The number you've entered ("+$(obj).val()+") is more than the allowed of weight of "+maxWeight+" lbs.  This max-weight was pre-determined at the weigh-in during Tech-Inspection.\n\nPress [ OK ] to use the allowable Max Weight.\nPress [ Cancel ] to reset and enter the payload weight again.");
        if (response){
            $(obj).val(maxWeight);
        } else {
            $(obj).val('');
            $('[tabindex=1]').focus();
        }
    }
}
// ============= METRICS ==================================
function sae_updateMetric(obj, flightIDX, inStatus, label, step){
    var location = $.cookie('LOCATION');
    var filter = $.cookie('FILTER');
    if (inStatus == 5 || inStatus == 6 || inStatus == 7 ){
        $('.sae-complete').hide();
        $(obj).show();
    } else {
        $('.sae-complete').show();
    }
    // console.log("flightIDX="+flightIDX+", inStatus="+inStatus+", label="+label+",location="+location+", step="+step);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateMetric','act':'print','location':location,'inStatus':inStatus,'filter':filter,'label':label,'flightIDX':flightIDX,'step':step},
        success: function(str){
            
            $(obj).replaceWith(str);
            sae_applyFlightOpsFilter();
        }
    });
}

function sae_applyFlightOpsFilter(){
    var filter = $('#FLIGHT_OPS_FILTER option:selected').val();
    var location = $.cookie('LOCATION');
    $.cookie('FILTER', filter);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_flightOperations', 'act':'print','location':location,'filter':filter},
        success: function(str){
            // console.log(str);
            $('#mainPageContent').html(str);
        }
    });
    // console.log(filter);
}
function sae_loadFlow(flightIDX, inNumber, inStatus){
    var divName = 'TEMP_DIV_FLIGHT_CARD';
    createNewModalDiv('<b>Team #'+inNumber+': Flight Ops</b>',divName,550);
    var filter = $('#FLIGHT_OPS_FILTER option:selected').val();
    var location = $.cookie('LOCATION');
    // console.log('location='+location+', filter='+filter+', inStatus='+inStatus+', flightIDX='+flightIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_loadFlow', 'act':'print','location':location,'filter':filter,'inStatus':inStatus,'flightIDX':flightIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });  
}
//calculating Advanced Flight Score in the Preview Tab: updated 2022
function sae_calcAdvanceScore(teamIDX){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_calcAdvanceScore', 'act':'print','teamIDX':teamIDX},
        success: function(str){
            $('#ScoreContainer').html(str);
        }
    });  
}
//calculating Regular Flight Score in the Preview Tab: updated 2022
function sae_calcRegularScore(teamIDX){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_calcRegularScore', 'act':'print','teamIDX':teamIDX},
        success: function(str){
            $('#ScoreContainer').html(str);
        }
    });  
}
//calculating Micro Flight Score in the Preview Tab: updated 2022
function sae_calcMicroScore(teamIDX){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_calcMicroScore', 'act':'print','teamIDX':teamIDX},
        success: function(str){
            $('#ScoreContainer').html(str);
        }
    });  
}

