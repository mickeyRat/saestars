var d=document;
var now = new Date();
var time = now.getTime();
var inLength = 23;
// var loading = '<center class="center-screen "><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Loading...</span></center>';
// var loading = '<div class="w3-display-container"><div class="w3-display-center"><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></br><span class="w3-xlarge">Loading...</span></i></div></div>';

$( d ).ready(function(){
    if ($.cookie('expire') < time || $.cookie('expire') === null) {
        window.location.href="index.html";
    } else {
        // console.log('eventIDX = '+$.cookie('eventIDX'));
        loadMenuItems();
        sae_loadHomePage();
        $('#userName_LoggedInAs').html($.cookie('TX_LAST_NAME')+', '+$.cookie('TX_FIRST_NAME'));
        // $('.DB_event').html('<span class="w3-small">DB: '+$.cookie('DATABASE').substring(0, inLength)+'...</span>');
    }
});
function sae_loadHomePage(){
    var userIDX    = $.cookie('userIDX');
    var location   = $.cookie('LOCATION');
    var inUserType = $.cookie('IN_USER_TYPE');
    var inProfile  = $.cookie('IN_PROFILE');
    $('#mainPageContent').html('<br><br><br><br><br><br><br><br>'+loading);
    $('.sae-menu_item').removeClass('w3-blue');
    $('#MENUITEM_0').addClass('w3-blue');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/home.pl',
        data: {'do':'sae_loadHomePage','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            // console.log(str);
            $('#mainPageContent').html(str);
            if (inUserType >= 1 && inProfile == 0){ openJudgesProfile(userIDX, inUserType) } 
        }
    });
    }
function openJudgesProfile ( userIDX, inUserType ) {
    // body...
    // console.log(userIDX);
    var eventIDX   = $.cookie('LOCATION');
    $.modal("Judge's Preferences" , "90%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/home.pl',
        data: {'do':'openJudgesProfile','act':'print','userIDX':userIDX,'inUserType':inUserType,'eventIDX':eventIDX},
        success: function(str){
            // alert(str);
            $('#modal_content').html(str);
            // $('[tabindex=1]').focus();
        }
    });
    }

// 2024 ---------------------------------------------------------------------------------------
function main2_updateInLimit(o, profileIDX) {
    var inLimit = $(o).val();
    $.ajax({
            type: 'POST',
            url: '../cgi-bin/main2.pl',
            data: {'do':'main2_updateInLimit','act':'print','profileIDX':profileIDX, 'inLimit':inLimit},
            success: function(str){
            }
        });
    }
function main2_addVolunteerPreference(o){
    var classIDX        = $('#CLASS_LIST').find(':selected').val();
    var eventIDX        = $('#EVENT_LIST').find(':selected').val();
    var userIDX         = $.cookie('userIDX');
    var inType          = $('#TYPE_LIST').find(':selected').val();
    var inLimit         = $('#IN_LIMIT').val();
    var row             = $(o).closest('tr');
    var ajxData         = {}; 
    var data            = {};
    ajxData.do          = 'main2_addVolunteerPreference';
    ajxData.act         = 'print';
    ajxData.eventIDX    = eventIDX;
    data.FK_CLASS_IDX   = classIDX;
    data.IN_TYPE        = inType;
    data.IN_LIMIT       = inLimit;
    data.FK_USER_IDX    = userIDX;
    data.FK_EVENT_IDX   = eventIDX;
    ajxData['jsonData'] = JSON.stringify(data);
    // // ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            $(str).insertBefore(row);
        },
    });
    }
function main2_reloadClassList(o) {
    var all = new Option("All", "0");
    var Reg = new Option("Regular", "1");
    var Adv = new Option("Advanced", "2");
    var Mic = new Option("Micro", "3");
    var value = $(o).val();
    if (value > 1){ 
        $("#CLASS_LIST").empty().append(all);
    } else {
        $("#CLASS_LIST").empty().append(Adv);
        $("#CLASS_LIST").append(Reg);
        $("#CLASS_LIST").append(Mic);
    }
    // console.log("value = " + value);
    }
function main2_updatePreference(o, userIDX) {
    var ajxData         = {}; 
    var data            = {};
    ajxData.do          = 'main2_updatePreference';
    ajxData.act         = 'print';
    data.FK_CLASS_IDX   = $(o).data('class');
    data.FK_EVENT_IDX   = $(o).data('event');
    data.IN_TYPE        = $(o).data('type');
    data.FK_USER_IDX    = userIDX;
    data.IN_LIMIT       = $('#IN_LIMIT_'+$(o).data('event')).val();
    ajxData.userIDX     = userIDX;
    ajxData.eventIDX    = $(o).data('event');
    ajxData.classIDX    = $(o).data('class');
    ajxData.inType      = $(o).data('type');
    if ($(o).is(':checked')){
        ajxData.inNew       = 1;
    } else {
        ajxData.inNew       = 0;
    }
    ajxData['jsonData'] = JSON.stringify(data);
    // ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/home.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
        },
    });
    }
function main2_delete(o, profileIDX) {
    var jsYes = confirm("Click [ OK ] to confirm your action to DELETE this event preference item.")
    if (!jsYes){return}
    // $(o).close();
    $.ajax({
            type: 'POST',
            url: '../cgi-bin/main2.pl',
            data: {'do':'main2_delete','act':'print','profileIDX':profileIDX},
            success: function(str){
                $(o).closest('tr').remove();
                // $('#EVENT_PROFILE_BAR_'+profileIDX).remove();
                // $.cookie('IN_PROFILE',0);

            }
        });
    }

// 2024 ---------------------------------------------------------------------------------------
function profile_openMyPreferences(o, profileIDX, inYear) {
    // body...
    console.log(profileIDX);
    var inUserType = $.cookie('IN_USER_TYPE');
    $.modal(inYear + " Event Preferences" , "75%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/home.pl',
        data: {'do':'profile_openMyPreferences','act':'print','profileIDX':profileIDX,'inUserType':inUserType},
        success: function(str){
            // alert(str);
            $('#modal_content').html(str);
            // $('[tabindex=1]').focus();
        }
    });
}
function profile_delete(o, profileIDX) {
    var jsYes = confirm("Click [ OK ] to Delete current Event Pereferences")
    if (!jsYes){return}
    $(o).close();
    $.ajax({
            type: 'POST',
            url: '../cgi-bin/home.pl',
            data: {'do':'profile_delete','act':'print','profileIDX':profileIDX},
            success: function(str){
                $('#EVENT_PROFILE_BAR_'+profileIDX).remove();
                $.cookie('IN_PROFILE',0);

            }
        });
    }
function profile_close(o, profileIDX) {
    // if ($('#BO_EAST').is(':checked') || $('#BO_WEST').is(':checked')){
    //     $.cookie('IN_PROFILE',1);
    // } else {
    //     $.cookie('IN_PROFILE',0);
    //     $('#Profile_'+profileIDX).remove();
    //     // ID="Profile_'.$profileIDX.'" 
    // }
    $.cookie('IN_PROFILE',1);
    $(o).close();
    // body...
}
function profile_save(userIDX, field, value, txYear) {
    $.ajax({
            type: 'POST',
            url: '../cgi-bin/home.pl',
            data: {'do':'profile_save','act':'print','userIDX':userIDX,'field':field,'value':value,'txYear':txYear},
            success: function(str){
            }
        });
    }
function profile_saveInput(o, txYear) {
    var userIDX  = $.cookie('userIDX');
    var field    = $(o).data('field');
    var value    = $(o).val();
    console.log(userIDX);
    console.log(field);
    console.log(value);
    profile_save(userIDX, field, value, txYear);
    
}
function profile_adminSaveCheck (o, txYear, userIDX) {
    var field    = $(o).data('field');
    var value    = 0;
    if ($(o).is(':checked')){value = 1}
    // console.log(field + "=" + value);
    if (field == 'BO_ALUMI' && value==1 ){
        // var dataValue = $(o).data('value');
        $('#IN_SINCE').prop('disabled', false).removeClass("w3-disabled");
        $('#IN_SINCE').val($(o).data('value'));
    } else if (field == 'BO_ALUMI' && value== 0)  {
        $('#IN_SINCE').val('');
        $('#IN_SINCE').prop('disabled', true).addClass("w3-disabled");
        $('#IN_SINCE').prop('placeholder','Volunteered since 2000*');
    }
    if (field == 'BO_STUDENT' && value==1 ){
        // var dataValue = $(o).data('value');
        $('#TX_SCHOOL').prop('disabled', false).removeClass("w3-disabled");
        $('#TX_SCHOOL').val($(o).data('value'));
    } else if (field == 'BO_STUDENT' && value== 0)  {
        $('#TX_SCHOOL').val('');
        $('#TX_SCHOOL').prop('disabled', true).addClass("w3-disabled");
        $('#TX_SCHOOL').prop('placeholder','Team/University affiliation');
    }
    // console.log($('#BO_EAST_'+userIDX).is(':checked'));
    // console.log(!$('#BO_EAST_'+userIDX).is(':checked'));
    if ($('#BO_EAST_'+userIDX).is(':checked') || $('#BO_WEST_'+userIDX).is(':checked')){
            // console.log("Keep");
        } else {
            // console.log("delete");
            $('#JUDGE_PREFERENCES_'+userIDX).fadeOut(250);
        }
    // console.log(txYear);
    profile_save(userIDX, field, value, txYear);
}
function profile_saveCheck(o, txYear) {
    var userIDX  = $.cookie('userIDX');
    var field    = $(o).data('field');
    var value    = 0;
    if ($(o).is(':checked')){value = 1}
    // console.log(field + "=" + value);
    if (field == 'BO_ALUMI' && value==1 ){
        // var dataValue = $(o).data('value');
        $('#IN_SINCE').prop('disabled', false).removeClass("w3-disabled");
        $('#IN_SINCE').val($(o).data('value'));
    } else if (field == 'BO_ALUMI' && value== 0)  {
        $('#IN_SINCE').val('');
        $('#IN_SINCE').prop('disabled', true).addClass("w3-disabled");
        $('#IN_SINCE').prop('placeholder','Volunteered since 2000*');
    }
    if (field == 'BO_STUDENT' && value==1 ){
        // var dataValue = $(o).data('value');
        $('#TX_SCHOOL').prop('disabled', false).removeClass("w3-disabled");
        $('#TX_SCHOOL').val($(o).data('value'));
    } else if (field == 'BO_STUDENT' && value== 0)  {
        $('#TX_SCHOOL').val('');
        $('#TX_SCHOOL').prop('disabled', true).addClass("w3-disabled");
        $('#TX_SCHOOL').prop('placeholder','Team/University affiliation');
    }
    
    if ($('#BO_EAST').is(':checked') || $('#BO_WEST').is(':checked')){
            $('.second').prop('disabled', false);
        } else {
            $('.second').prop('disabled', true);
            $('.second').prop('checked', false );
            $('#TX_SCHOOL').val('');
            $('#IN_SINCE').val('');
            $('#TX_SCHOOL').prop('placeholder','Team/University Attended');
            $('#IN_SINCE').prop('placeholder','Volunteered since 1986*');
        }
    console.log(txYear);
    profile_save(userIDX, field, value, txYear);
    }
function sae_menuDropDown(utIDX) {
    if ($('#subMenu_'+utIDX).hasClass('w3-show')){
        $('#subMenu_'+utIDX).removeClass('w3-show');
    } else {
        $('#subMenu_'+utIDX).addClass('w3-show');
    }
}
function sae_calcFlightScores(eventIDX, classIDX, teamIDX){
    $.modal("Flight Logs" , "90%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_calcFlightScores','act':'print','teamIDX':teamIDX,'classIDX':classIDX,'eventIDX':eventIDX},
        success: function(str){
            // alert(str);
            $('#modal_content').html(str);
            // $('[tabindex=1]').focus();
        }
    });
    
}
function sae_openReadOnlyFlightCard(teamIDX, inNumber, classIDX){
    var location = $.cookie('LOCATION');
    $.modal("Flight Logs - Team #: "+inNumber, "90%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openReadOnlyFlightCard','act':'print','teamIDX':teamIDX,'classIDX':classIDX,'inNumber':inNumber,'location':location},
        success: function(str){
            // alert(str);
            $('#modal_content').html(str);
            // $('[tabindex=1]').focus();
        }
    });
}
function sae_openResultStandings(classIDX){
    var location = $.cookie('LOCATION');
    $.modal("Published Results", "90%");
    console.log(classIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'sae_openResultStandings','act':'print','location':location,'classIDX':classIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}

function results_openResultStandings(classIDX){
    var location = $.cookie('LOCATION');
    $.modal("Published Results", "90%");
    console.log(classIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'results_openResultStandings','act':'print','location':location,'classIDX':classIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
function getUserAccess(userIDX){
    $('.saeAccess').prop('checked',false);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'getUserAccess','act':'print','userIDX':userIDX},
        success: function(str){
            var data = JSON.parse(str);
            for( let key in data ){
                if (key === "0"){
                    var groupIDX = data[key]['FK_GROUP_IDX'];
                    $('#userGroup_'+groupIDX).prop('checked',true);
                } else {
                    $('#JudgeAccess_'+key).prop('checked',true);
                    $('#AdminAccess_'+key).prop('checked',true);
                    $('#StudentAccess_'+key).prop('checked',true);
                }
                sae_getUserTeamMembership(userIDX);
            }
        }
    });
}   
function sae_loadGroupMembership(groupIDX){
    // alert(groupIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_loadGroupMembership','act':'print','groupIDX':groupIDX},
        success: function(str){
            $('#groupMembershipList').html(str);
            // alert(str);
        }
    });
}
function sae_updateUserGroupMembership(groupIDX){
    var userIDX = $('#manageUserDropdown option:selected').val();
    if (userIDX ==='' || userIDX === 0){
        $(obj).prop('checked',false);
        alert("Please Select a User.");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_updateUserGroupMembership','act':'print','groupIDX':groupIDX, 'userIDX':userIDX},
        success: function(str){
            var data = JSON.parse(str);
            $('.saeAccess').prop('checked',false);
            for( let key in data ){
                $('#JudgeAccess_'+key).prop('checked',true);
                $('#AdminAccess_'+key).prop('checked',true);
                $('#StudentAccess_'+key).prop('checked',true);
            }
        }
    });
}
function updateUserAccess(){
    var access = [];
    var userIDX = $('#manageUserDropdown option:selected').val();
    if (userIDX){
        $.each($('.saeAccess:checked'), function(){
            if (this.value>0){access.push(this.value)}
        });
        var data = access.toString();
        // alert(data);
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/main2.pl',
            data: {'do':'updateUserAccess','act':'print','userIDX':userIDX, 'access':data},
            success: function(str){
                alert('User Access Successfully Updated for ( '+$('#manageUserDropdown option:selected').text()+' ).');
            }
        });
    } else {
        alert('Please Select A User');
    }
    // alert(data);
}
function sae_deleteUser(){
    var userIDX = $('#manageUserDropdown option:selected').val();
    var userText = $('#manageUserDropdown option:selected').text();
    
    if (userIDX === 0){return}
    var jsYes = confirm("Are you sure you want to delete this user?\nID = "+userIDX+"\nName = "+userText);
    if (!jsYes){return}
    $('#manageUserDropdown option:selected').remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_deleteUser','act':'print','userIDX':userIDX},
        success: function(str){
            getUserAccess(0);
        }
    });

}
// function goHome(){
//     var userIDX = $.cookie('PK_USER_IDX');
//     var txFirst = $.cookie('TX_FIRST');
//     var txLast = $.cookie('TX_LAST');
//     alert(txFirst + " " + txLast);
// }
// function sae_loadHomePage(){
//     $('#mainPageContent').html("");
// }

function main2_showModalEventSelection(){
    // $.modal("Set Event Location", "50%");
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'main2_showModalEventSelection','act':'print','eventIDX':eventIDX},
        success: function(str){
            // alert(str);
            // $('#modal_content').html(str);
            $('#mainPageContent').html(str);
        }
    });
}
function main2_updateEventLocation(o) {
    $.cookie('LOCATION', $(o).val());
    $.cookie('FK_EVENT_IDX', $(o).val());
    alert("Event Location Changed.");
    // sae_loadHomePage();
}
function sae_showModalEventSelection(){
    $.modal("Set Event Location", "50%");
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_showModalEventSelection','act':'print','location':location},
        success: function(str){
            // alert(str);
            $('#modal_content').html(str);
        }
    });
}
function sae_showSetEventLocationFromMain(){
    var location = $.cookie('LOCATION');
    $('#mainPageContent').html(loading);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_showSetEventLocationFromMain','act':'print','location':location},
        success: function(str){
            // alert(str);
            $('#mainPageContent').html(str);
        }
    });
}
function sae_setModalEvent(obj){
    var eventIDX = $('#sae_eventSelection :selected').val();
    var txEvent = $('#sae_eventSelection :selected').text().substring(0, inLength)+'...';

    $(obj).close();
    $.cookie('LOCATION',eventIDX);
    $.cookie('DATABASE',txEvent);
    $('.DB_event').html('<span class="w3-small">DB: '+txEvent+'</span>');
    sae_loadHomePage();
}
function sae_setEventLocation(){
    var location = $('input[name=radio_selectEventLocation]:checked').val();
    var locationText = $('input[name=radio_selectEventLocation]:checked').data('value');
    $.cookie('LOCATION',location);
    // alert('Event Location Set for '+ locationText);
    sae_showSetEventLocationFromMain();
    // sae_loadHomePage(0);
}
function openTab(tabName, obj) {
    $('.PaperTabs').hide();
    $('.sae-tabs').removeClass('w3-light-blue');
    $('#'+tabName).show(0);
    loadTabContent(tabName);
    $(obj).addClass('w3-light-blue');
}

function sae_openTeamView(obj){
    $('#paperContentContainer').html(loading);
    $('.tablink').removeClass('w3-border-red');
    $('.paperTab').removeClass('w3-red');
    $(obj).addClass('w3-red');
    $(obj).children(":first").addClass('w3-border-red');
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openTeamView','act':'print','location':location},
        success: function(str){
            // alert(str);
            $('#paperContentContainer').html(str);
            // loader.removeClass('show');
        }
    });
}
function sae_openStatTeamView(obj, sortBy){
    $('#tabContent').html(loading);
    $('.tablink').removeClass('w3-border-red');
    $('.paperTab').removeClass('w3-red');
    $(obj).addClass('w3-red');
    $(obj).children(":first").addClass('w3-border-red');
    sae_loadStatTeamViewContent(sortBy);
}
function sae_openStatView(obj, sortBy){
    $('#tabContent').html(loading);
    $('.tablink').removeClass('w3-border-red');
    $('.paperTab').removeClass('w3-red');
    $(obj).addClass('w3-red');
    $(obj).children(":first").addClass('w3-border-red');
    sae_loadStatViewContent(sortBy);
}
function sae_openStatBreakdown(obj){
    $('#tabContent').html(loading);
    $('.tablink').removeClass('w3-border-red');
    $(obj).children(":first").addClass('w3-border-red');
    sae_loadBreakdownViewContent();
}
function sae_loadBreakdownViewContent(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_loadBreakdownViewContent','act':'print','location':location},
        success: function(str){
            $('#tabContent').html(str);
        }
    });
}

function sae_openTeamStatsByJudge(userIDX, cardTypeIDX){
    var divName = 'ASSIGN_TEAM_PREFERENCE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Teams Assessed</b>',divName,800);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openTeamStatsByJudge','act':'print','location':location, 'userIDX':userIDX,'cardTypeIDX':cardTypeIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_openJudgeStatsByTeam(teamIDX, cardTypeIDX){
    var divName = 'ASSIGN_TEAM_PREFERENCE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Judges involved with assessment</b>',divName,800);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openJudgeStatsByTeam','act':'print','location':location, 'teamIDX':teamIDX,'cardTypeIDX':cardTypeIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_openJudgeView(obj, sBy){
    $('#paperContentContainer').html(loading);
    $('.tablink').removeClass('w3-border-red');
    $('.paperTab').removeClass('w3-red');
    $(obj).addClass('w3-red');
    $(obj).children(":first").addClass('w3-border-red');
    sae_loadJudgeViewContent(sBy);
}
function sae_loadStatViewContent(sBy){
        // if (sortBy===''){sortBy=1} // If sortby is blank, then default it to sort by Name
    // alert(sBy);
    // console.log ("SortBy="+sBy+"\n");
    var location = $.cookie('LOCATION');

    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openStatView','act':'print','location':location,'sortBy':sBy},
        success: function(str){
            $('#tabContent').html(str);
        }
    });
}
function sae_loadStatTeamViewContent(sBy){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openStatTeamView','act':'print','location':location,'sortBy':sBy},
        success: function(str){
            $('#tabContent').html(str);
        }
    });
}
function sae_loadJudgeViewContent(){
    // if (sortBy===''){sortBy=1} // If sortby is blank, then default it to sort by Name
    var location = $.cookie('LOCATION');
    // alert(sortBy);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openJudgeView','act':'print','location':location},
        success: function(str){
            $('#tabContent').html(str);
        }
    });
}

function sae_batchRemoveDesignReportJudges(){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_batchRemoveDesignReportJudges','act':'print','location':location},
        success: function(str){
            // loadTabContent('ManagePapers_divTeam_view');
            openManagePapers();
            alert("Completed");
        }
    });
}
function loadTabContent(toDo){
    // var toDo = 'ManagePapers_'+ tab;
    // loader.addClass('show');
    var location = $.cookie('LOCATION');
    // alert(toDo);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':toDo,'act':'print','location':location},
        success: function(str){
            // alert(str);
            $('#'+toDo+'_ViewContainer').html(str);
            // loader.removeClass('show');
        }
    });
}
function loadAutoAssignPapers(){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'loadAutoAssignPapers','act':'print','location':location},
        success: function(str){
            // loadTabContent('ManagePapers_divTeam_view');
            openManagePapers();
            // alert("Completed");
        }
    });
}
function loadBatchAssign(inType){
    createNewModalDiv('Batch Assignment', 'TEMP_ASSIGN_BATCH_1', 650);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'loadBatchAssign','act':'print','location':location,'inType':inType},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_loadTeamsToAssign(userIDX, classIDX){
    var divName = 'ASSIGN_TEAM_PREFERENCE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Teams</b>',divName,550);
    // alert(classIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_loadTeamsToAssign','act':'print','userIDX':userIDX,'location':location,'divName':divName,'classIDX':classIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_addSelectedPreference(obj, userIDX, teamIDX){
    $(obj).parent().remove();
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_addSelectedPreference','act':'print','userIDX':userIDX,'location':location,'teamIDX':teamIDX},
        success: function(str){
            
            sae_loadJudgeViewContent();
        }
    });
}

function assignBatchToJudge(inType){
    var location = $.cookie('LOCATION');
    var userIDX = $('#selectedUserIDX').val();
    
    if (userIDX===0){
        alert("Please select a Judge");
        return
    }
    var list = Array();
    $(".sae_selectedClass:checked").each(function(){
        list.push($(this).val());
    });
    if (list.length<1){
        alert("Please select at least 1 Class.");
        return
    }
    console.log('location = '+location+ ',inType = '+inType+', userIDX='+userIDX+', list = '+ list.join(","));
    var jsYes = confirm("Click OK to confirm Assignment");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'assignBatchToJudge','act':'print','location':location,'inType':inType,'userIDX':userIDX, 'list':list.join(",")},
        success: function(str){
            // alert(str);
            // loadTabContent('ManagePapers_divTeam_view');
            console.log(str);
            openManagePapers();
            $('#TEMP_ASSIGN_BATCH_1').remove();
        }
    });
}
function sae_unassginSelectedJudge(inType){
    var location = $.cookie('LOCATION');
    var userIDX = $('#selectedUserIDX').val();
    if (userIDX===0){
        alert("Please select a Judge");
        return
    }
    var list = Array();
    $(".sae_selectedClass:checked").each(function(){
        list.push($(this).val());
    });
    if (list.length<1){
        alert("Please select at least 1 Class.");
        return
    }
    var jsYes = confirm("Click OK to confirm Un-Assignment");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_unassginSelectedJudge','act':'print','location':location,'inType':inType,'userIDX':userIDX, 'list':list.join(",")},
        success: function(str){
            // alert(str);
            // loadTabContent('ManagePapers_divTeam_view');
            openManagePapers();
            $('#TEMP_ASSIGN_BATCH_1').remove();
        }
    });
}
// function createNewModalDiv(title, ID_NAME, width){
//     // var ID_NAME = 'TEMP_OPENASSIGNMENTDETAILS';
//     var div = '<div ID="'+ID_NAME+'" class="w3-modal" style="display: block; z-index: 5001;">';
//     div += '<div class="w3-modal-content w3-card-4 w3-light-grey" style="width: '+width+'px; min-height: 300px;">';
//     // div += '<div class="w3-modal-content w3-card-4  w3-light-grey" style="max-width: '+width+'px; min-height: 300px;">';
//     div += '<div class="w3-container w3-top-bar" >';
//     // div += '<h4 style="padding: 1px 30px 0px 2px;">'+title+'</h4>';
//     div += '<h4 style="padding: 0px; margin: 0px; margin-right: 30px;">'+title+'</h4>';
//     div += '<span onclick="$(\'#'+ID_NAME+'\').remove();" class="w3-button w3-display-topright w3-hover-red">X</span>';
    
//     div += '</div>';
//     div += '<div ID="x_modal_Content" style="margin-top: 8px; padding: 4px;" class="w3-white w3-border"></div>';
//     div += '</div>';
//     div += '</div>';
//     $('html').prepend(div);
// }
function createModalForComments(){
    var div = '<div ID="'+ID_NAME+'" class="w3-modal" style="display: block; z-index: 10001;">';
    div += '<div class="w3-modal-content w3-card-4 white" style="width: '+width+'px; min-height: 300px;">';
    // div += '<div class="w3-modal-content w3-card-4 w3-light-grey" style="width: '+width+'px; min-height: 300px;">';
    div += '<div class="w3-container" >';
    div += '<h4 style="padding: 0px; margin: 1px;">'+title+'</h4>';
    div += '<span onclick="$(\'#'+ID_NAME+'\').remove();" class="w3-button w3-display-topright w3-hover-grey w3-red">X</span>';
    
    div += '</div>';
    div += '<div ID="x_modal_Content" style="margin-top: 8px; padding: 4px;" class="w3-white w3-border"></div>';
    div += '</div>';
    div += '</div>';
    $('html').prepend(div);
}
function openAssignmentDetails(teamIDX){
    var location = $.cookie('LOCATION');
    createNewModalDiv('Paper Assignment Details', 'TEMP_OPENASSIGNMENTDETAILS');
    openAssignmentDetails_fill(teamIDX);
}
function openAssignmentDetails_fill(teamIDX){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'openAssignmentDetails','act':'print','location':location,'teamIDX':teamIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function showAddJudge(inType, teamIDX, judgePaperCount, title){
    var location = $.cookie('LOCATION');
    $('#judgeSlot_'+inType+'_'+judgePaperCount).html(title);
    // $('#cardDeleteControl_'+inType+'_'+judgePaperCount).show();
    $('#button_'+inType+'_'+judgePaperCount).hide();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'showAddJudge','act':'print','location':location,'teamIDX':teamIDX,'judgePaperCount':judgePaperCount,'title':title,'inType':inType},
        success: function(str){
            $('#judgeSlot_'+inType+'_'+judgePaperCount).html(str);
            // $('#x_modal_Content').html(str);
        }
    });
}
function cancel_ShowAddJudge(inType, judgePaperCount){
    $('#judgeSlot_'+inType+'_'+judgePaperCount).html("");
    // $('#cardDeleteControl_'+inType+'_'+judgePaperCount).hide();
    $('#button_'+inType+'_'+judgePaperCount).show();   
}
function sae_addSelectedJudgeToTeam(inType, teamIDX, judgePaperCount, title){
    var location = $.cookie('LOCATION');
    var userIDX = $('#judgeSelectionForSlot_'+judgePaperCount+' option:selected').val();
    var userName = $('#judgeSelectionForSlot_'+judgePaperCount+' option:selected').text();
    // var userName;
    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_addSelectedJudgeToTeam','act':'print','location':location,'teamIDX':teamIDX,'judgePaperCount':judgePaperCount,'title':title,'inType':inType,'userIDX':userIDX,'userName':userName},
        success: function(str){
            $('#judgeSlot_'+inType+'_'+judgePaperCount).html(str);
            $('#cardDeleteControl_'+inType+'_'+judgePaperCount).show();
            $('#button_'+inType+'_'+judgePaperCount).remove();
            // loadTabContent('ManagePapers_divTeam_view');
            openManagePapers();
        }
    });
    
    // alert(userIDX);
}
function sae_removeJudgeFromCard(obj, cardIDX, teamIDX, inType, txTitle, count){
    // console.log("cardIDX="+cardIDX+", teamIDX="+teamIDX+", inType="+inType+", txTitle="+txTitle+", count="+count+"\n");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_removeJudgeFromCard','act':'print','cardIDX':cardIDX,'teamIDX':teamIDX,'inType':inType,'txTitle':txTitle,'count':count},
        success: function(str){
            // alert("Removed...");
            // alert(str);
            $(obj).parent().replaceWith(str);
            $('#cardDeleteControl_'+inType+'_'+count).show();
            
        }
    });
}
function sae_addTeamToCurrentJudge(inType, userIDX){
    var location = $.cookie('LOCATION');
    var teamIDX = $('#selectTeamToAdd_'+inType+' option:selected').val(); 
    var txSchool = $('#selectTeamToAdd_'+inType+' option:selected').text(); 
    if (teamIDX===0){return}
    $('#selectTeamToAdd_'+inType+' option:selected').remove(); 
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_addTeamToCurrentJudge','act':'print','location':location,'userIDX':userIDX, 'teamIDX':teamIDX,'inType':inType,'txSchool':txSchool},
        success: function(str){
            $('#listOfTeamsAssignedToJudge_'+inType).find(' > li:nth-last-child(1)').before(str);
        }
    });
}
function openJudgeAssignmentDetails(userIDX, userName){
    var location = $.cookie('LOCATION');
    createNewModalDiv(userName+' - Assessment Assignments', 'TEMP_OPENJUDGEASSIGNMENTDETAILS', 500);
    // alert(userIDX+", "+userName); 
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'openJudgeAssignmentDetails','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            // alert(str);
            $('#x_modal_Content').html(str);
            // loadTabContent('ManagePapers_divJudge_view');
            sae_loadJudgeViewContent();
        }
    });
}
function sae_deleteThisCardFromJudge(cardIDX, obj, inType){
    var teamIDX = $(obj).data('key');
    var teamSchool = $(obj).data('text');
    // alert();
    // alert($(obj).data('text'));
    $('#selectTeamToAdd_'+inType).append('<option value="'+teamIDX+'">'+teamSchool+'</option>');
    loadTabContent('divJudge_view');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_removeJudgeFromCard','act':'print','cardIDX':cardIDX},
        success: function(str){
            // loadTabContent('ManagePapers_divJudge_view');
            sae_loadJudgeViewContent();
        }
    });
}
// USER PROFILE

function sae_showUserProfile(){
    var userIDX = $.cookie('userIDX');
    var location = $.cookie('LOCATION');
    $('#mainPageContent').html(loading);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_showUserProfile','act':'print','userIDX':userIDX,'location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function sae_saveProfile(userIDX){
    // var userIDX = $.cookie('userIDX');
    var location = $.cookie('LOCATION');
    var txFirst = $('#profile_txFirst').val();
    var txLast = $('#profile_txLast').val();
    var txEmail = $('#profile_txEmail').val();
    // alert(location+", "+txFirst+", "+txLast+", "+txEmail+", "+userIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_saveProfile','act':'print','userIDX':userIDX,'location':location,'txEmail':txEmail,'txLast':txLast,'txFirst':txFirst},
        success: function(str){
            // $('#mainPageContent').html(str);
            alert("Successfully Updated User Profile");
        }
    });
}
function sae_changeMyPassword(userIDX){
    var divName = 'TEMP_DIV_CHANGE_MY_PASSWORD';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Change Password</b>',divName,400);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_changeMyPassword','act':'print','userIDX':userIDX,'location':location,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_validateCurrentPassword(obj, userIDX){
    var pwd = $(obj).val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_validateCurrentPassword','act':'print','userIDX':userIDX,'pwd':pwd},
        success: function(str){
            if (str == 0) {
                $('#span_CurrentStatus').removeClass('w3-hide');
                $(obj).focus();
            } else {
                $('#span_CurrentStatus').addClass('w3-hide');
            }
        }
    });
}
function sae_validateConfirmPassword(obj){
    var newPwd = $('#passwordNew').val();
    var conPwd = $(obj).val();
    if (newPwd != conPwd){
        $('#span_ConfirmStatus').removeClass('w3-hide');
        $(obj).focus();
        // $('#btn_changePassword').addClass('w3-disabled');
    } else {
        $('#span_ConfirmStatus').addClass('w3-hide');
        $('#btn_changePassword').removeClass('w3-disabled');
    }
}
function sae_changeMyPasswordSubmit(userIDX, divName){
    var location = $.cookie('LOCATION');
    var passwordNew = $('#passwordNew').val();
    // alert(passwordNew);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_changeMyPasswordSubmit','act':'print','location':location, 'userIDX':userIDX,'passwordNew':passwordNew},
        success: function(str){
                // alert (str);
            $('#'+divName).remove();
            alert("Passsword Changed");
        }
    });
}
function sae_displayTilesForGroup(groupIDX){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_displayTilesForGroup','act':'print','location':location, 'groupIDX':groupIDX},
        success: function(str){
            $('#groupAccess_Content').html(str);
            sae_loadGroupMembership(groupIDX);
        }
    });
}
function sae_expandAccessGroup(inType, obj){
    $(obj).children('.fa').toggleClass('fa-chevron-right fa-chevron-down');
    $('.accessGroup_'+inType).toggleClass('w3-hide');

    // $('.accessGroup_'+inType).toggleClass('fa-chevron-right fa-chevron-down');
}
function sae_processGroupAccess(obj, tilesIDX, groupIDX){
    if (obj.checked) {var toDo = 'sae_grantGroupAccess'} else {var toDo = 'sae_removeGroupAccess'}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':toDo,'act':'print','tilesIDX':tilesIDX, 'groupIDX':groupIDX},
        success: function(str){
            // $('#groupAccess_Content').html(str);
        }
    });

}
function sae_openAddMemberToGroup(groupIDX){
    var divName = 'TEMP_DIV_ADD_MEMBER';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Add To Group</b>',divName,400);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openAddMemberToGroup','act':'print', 'groupIDX':groupIDX},
        success: function(str){
            // alert(str);
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_addUserToGroup(userIDX, groupIDX, userName){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_addUserToGroup','act':'print', 'groupIDX':groupIDX, 'userIDX':userIDX,'userName':userName},
        success: function(str){
            // alert(str);
            $('#groupMembershipList').append(str);
        }
    });
}
function sae_removeUserFromGroup(userIDX, groupIDX){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_removeUserFromGroup','act':'print', 'userIDX':userIDX},
        success: function(str){
            // alert(str);
            // $('#groupMembershipList').append(str);
        }
    });
}
function sae_resetPassword(){
    var userIDX = $('#manageUserDropdown option:selected').val();
    var userText = $('#manageUserDropdown option:selected').text();
    if (userIDX == 0){return}
    var divName = 'TEMP_DIV_RESET_PASSWORD';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>'+userText.toUpperCase()+'</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_resetPassword','act':'print','userIDX':userIDX, 'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}

function sae_resetPasswordSubmit(userIDX, divName){
    var password = $('#sae_resetPasswordType').val();
    // alert(userIDX+", "+divName+", "+password);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_resetPasswordSubmit','act':'print', 'userIDX':userIDX,'password':password},
        success: function(str){
            // alert(str);
            alert("Password Reset Successfully");
            $('#'+divName).remove();
        }
    });
}
// function sae_getListOfTeams(){
//     var userIDX = $('#manageUserDropdown option:selected').val();
//     var userText = $('#manageUserDropdown option:selected').text();
//     if (userIDX == 0){return}
//     var divName = 'TEMP_DIV_ADD_TEAMS';
//     var location = $.cookie('LOCATION');
//     createNewModalDiv('<b>TEAMS</b>',divName,500);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/main2.pl',
//         data: {'do':'sae_getListOfTeams','act':'print','location':location,'userIDX':userIDX, 'divName':divName},
//         success: function(str){
//             // alert(str);
//             $('#x_modal_Content').html(str);
//         }
//     });
// }
// function sae_addTeamToUser(obj, teamIDX, teamName, userIDX){
//     // var userIDX = $('#manageUserDropdown option:selected').val();
//     var location = $.cookie('LOCATION');
//     $(obj).parent().remove();
//     // $(this).parent().remove();
//     // alert(teamIDX+", "+teamName+", "+userIDX);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/main2.pl',
//         data: {'do':'sae_addTeamToUser','act':'print','location':location,'userIDX':userIDX, 'teamIDX':teamIDX, 'teamName':teamName},
//         success: function(str){
//             $('#userListOfTeam_Content_UL').append(str);
//         }
//     });
// }
function sae_getUserTeamMembership(userIDX){
    // alert(userIDX);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_getUserTeamMembership','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            // alert(str);
            $('#userListOfTeam_Content_UL').html(str);
        }
    });
}
function sae_unscuscribe(utIDX){
    var jsYes = confirm("Are you sure you want to unsubscribe to this team?");
    if (!jsYes) {return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/home.pl',
        data: {'do':'sae_unsubscribeToTeam','act':'print','userTeamIDX':utIDX},
        success: function(str){
            $('#UT_'+utIDX).remove();
        }
    });
    
}
function sae_subscribeToTeam(userIDX, from){
    var teamCode = $('#sae_teamCodeEntry').val();
    var location = $.cookie('LOCATION');
    if (teamCode === ""){return}
    // console.log('userIDX='+userIDX);
    // console.log('teamCode='+teamCode);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_subscribeToTeam','act':'print','location':location, 'teamCode':teamCode, 'userIDX':userIDX},
        success: function(str){
            if (str ==0){
                alert('Invalid Team Access Code.  Please try again.');
            } else {
                if (from == 0){
                    sae_loadHomePage();
                } else {
                    $('#SubscriptionList').append(str);
                    // $('#UL_listOfSubScribedTeams li:last').before(str);
                }
                
            }
            $('#sae_teamCodeEntry').val('');
            // alert(str+" "+teamCode);
        }
    });
}
// Manage Teams
function sae_showAddNewTeam(obj){
    $('.tablink').removeClass('w3-border-red');
    $('.paperTab').removeClass('w3-red');
    $(obj).addClass('w3-red');
    $(obj).children(":first").addClass('w3-border-red');
    var divName = 'TEMP_DIV_ADD_TEAMS';
    var location = $.cookie('LOCATION');
    // alert(location);
    // console.log($('.tablink').length);
    createNewModalDiv('<b>ADD TEAMS</b>',divName,600);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_showAddNewTeam','act':'print','location':location, 'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_createANewTeam(divName){
    var inNumber = $('#new_teamInNumber').val();
    var txSchool = $('#new_teamTxSchool').val();
    var txName = $('#new_teamTxName').val();
    var classIDX = $('#new_fkClassIDX').val();
    var countryIDX = $('#new_teamTxCountry option:selected').val();
    var txCountry= $('#new_teamTxCountry option:selected').text();
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_createANewTeam','act':'print','location':location, 'inNumber':inNumber, 'txSchool':txSchool, 'txName':txName, 'classIDX':classIDX, 'countryIDX':countryIDX, 'txCountry':txCountry},
        success: function(str){
            console.log(str);
            $('#'+divName).remove();
            $('#TABLE_TEAMS').append(str);
            // $("#UL_teamList li").sort(sort_li).appendTo('#UL_teamList');
            // $('#x_modal_Content').html(str);
        }
    });
}
function sort_li(a, b) {
    return ($(b).data('position')) < ($(a).data('position')) ? 1 : -1;
}
function sae_updateClassSelection(obj){
    var v = $(obj).val();
    var classIDX = 2;
    $('.sae-specialFields').addClass('w3-hide');
    if (v<200){
        classIDX = 1;
        $('.sae-specialFields_1').removeClass('w3-hide');
    } else if(v>300) {
        classIDX = 3;
        $('.sae-specialFields_3').removeClass('w3-hide');
    } else {
        classIDX = 2;
    }
    $('#new_fkClassIDX').val(classIDX);
}
function sae_openTeamDetails(teamIDX){
    var divName = 'TEMP_DIV_TEAM_DETAILS';
    var location = $.cookie('LOCATION');
    // alert(location);
    createNewModalDiv('<b>TEAM DETAILS</b>',divName,650);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openTeamDetails','act':'print','location':location, 'divName':divName,'teamIDX':teamIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_updateTeamDetails(teamIDX, divName){
    var inNumber = $('#new_teamInNumber').val();
    var txSchool = $('#new_teamTxSchool').val();
    var txName = $('#new_teamTxName').val();
    var classIDX = $('#new_fkClassIDX').val();
    var countryIDX = $('#new_teamTxCountry option:selected').val();
    var txCountry= $('#new_teamTxCountry option:selected').text();
    var location = $.cookie('LOCATION');
    var inSlope = $('#new_teamSlope').val();
    var teamCode = $('#new_teamAccessCode').val();
    var inInt = $('#new_teamIntercept').val();
    var inLcargo = $('#new_teamCargoLength').val();
    var inPipes = $('#new_teamInPipes').val();
    var inWpipes = $('#new_teamInPipeWeights').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_updateTeamDetails','act':'print','location':location, 'inNumber':inNumber, 'txSchool':txSchool, 'txName':txName, 'classIDX':classIDX, 'countryIDX':countryIDX, 'txCountry':txCountry, 'inSlope':inSlope, 'inInt':inInt, 'inLcargo':inLcargo, 'inPipes':inPipes, 'inWpipes':inWpipes,'teamCode':teamCode, 'teamIDX':teamIDX},
        success: function(str){
            var data = JSON.parse(str);
            $('#'+divName).remove();
            $('#LI_TEAMIDX_'+teamIDX+'_name').html(data.NAME);
        }
    });
}
function sae_expandUserMembership(obj, teamIDX){
    // alert(idx);
    $(obj).children('.fa').toggleClass('fa-chevron-right fa-chevron-down');
    $('.teamUserMembership_'+teamIDX).toggleClass('w3-hide');
}

function sae_openTeamUserMembership(teamIDX){
    var divName = 'TEMP_DIV_USER_TEAM_MEMBERSHIP';
    var location = $.cookie('LOCATION');
    // alert(location);
    createNewModalDiv('<b>Subscribers</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openTeamUserMembership','act':'print','location':location, 'divName':divName,'teamIDX':teamIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_addUserToThisTeam(teamIDX){
    var userIDX = $('#manageUserDropdown2 option:selected').val();
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_addUserToThisTeam','act':'print','location':location, 'userIDX':userIDX,'teamIDX':teamIDX},
        success: function(str){
            $('#manageUserDropdown2 option:selected').remove();
            $('#sae_userTeamMemberList li:last').before(str);
        }
    });
}
function sae_unsubscribeToTeam(obj, userTeamIDX){
    // console.log(userTeamIDX);
    var jsYes = confirm("Click [ OK ] to continue to unsubscribe to this team?");
    if (!jsYes){return}
   
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/home.pl',
        data: {'do':'sae_unsubscribeToTeam','act':'print','userTeamIDX':userTeamIDX},
        success: function(str){
            // alert(str);
            $(obj).parent().remove();
        }
    });
}
// =============== IMPORT FILES ==============
function sae_showFileImport(obj){
    $('.tablink').removeClass('w3-border-red');
    $('.paperTab').removeClass('w3-red');
    $(obj).addClass('w3-red');
    $(obj).children(":first").addClass('w3-border-red');
    var divName = 'TEMP_DIV_FILE_IMPORT';
    var location = $.cookie('LOCATION');
    // alert(location);
    createNewModalDiv('<b>Subscribers</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_showFileImport','act':'print','location':location, 'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_importFile(divName){
    // alert('test import button'); 
    var formData = new FormData();
    var location = $.cookie('LOCATION');
    formData.append('csvFile', $('input[type=file]')[0].files[0]); 
    formData.append('location',location);
    formData.append('do','sae_importFile');
    formData.append('act','print');
    // formData.append('location',location);
    $.post({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: formData,
        contentType: false, // NEEDED, DON'T OMIT THIS (requires jQuery 1.6+)
        processData: false, // NEEDED, DON'T OMIT THIS
        success: function(str){
            // $('#sae_results').html(str);
            $('#'+divName).remove();
            alert("File Imported");
        }
    });
}
// ================ WEATHER ==================
function sae_openWeather(hours){
     $('#mainPageContent').html(loading);
    // var divName = 'TEMP_DIV_FILE_IMPORT';
    var location = $.cookie('LOCATION');
    // alert(location);
    // createNewModalDiv('<b>Subscribers</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_openWeather','act':'print','location':location,'hours':hours},
        success: function(str){
            // alert(str);
            // $('#x_modal_Content').html(str);
            $('#mainPageContent').html(str);
        }
    });
}

//================== Late Reports ==============================================
function sae_updateDaysLate(obj, teamIDX, xDays, boLate){
    var inDays = prompt("Number of Days Late", xDays);
    if (!inDays || inDays == xDays){return}
    var location = $.cookie('LOCATION');
    console.log("teamIDX="+teamIDX+", location="+location+", inDays="+inDays+", boLate="+boLate);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'sae_updateDaysLate','act':'print','location':location,'inDays':inDays, 'boLate':boLate,'teamIDX':teamIDX},
        success: function(str){
            $(obj).replaceWith(str);
        }
    });
    
}








