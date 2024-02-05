    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';


// ===============2024 ==========================================
function user_addMultipleVollunteers(o){
    var userIDX = $(o).val();
    var row = $('#row_control');
    // var str = "<tr><td>"+userIDX+"</td></tr>";
    var ajxData          = {};
    // var data             = {}; 
    ajxData.do           = 'user_addNewVolunteer';
    ajxData.act          = 'print';
    ajxData.userIDX      = userIDX;
    ajxData.eventIDX     = $.cookie('LOCATION');
    // console.log(ajxData);
    $(o).closest('tr').find('select option:selected').remove();
    $.ajax({
        type: 'GET',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $(str).insertAfter(row);
            // $(str).insertAfter(row);
            $("#selectControl option[value='"+userIDX+"']").remove();
        }
    });
}
function user_VolunteerOptionSelected(o) {
    var value = $(o).val();
    if (value < 0){
        // $(o)
        $.modal("Add Volunteer Judges", "75%");
        $(o)[0].selectedIndex = 0;
        var ajxData           = {};
        var data              = {};
        ajxData.do            = 'user_VolunteerOptionSelected';
        ajxData.act           = 'print';
        // ajxData.userIDX       = userIDX;
        ajxData.eventIDX      = $.cookie('LOCATION');
        // ajxData.row           = o;
        console.log(ajxData);
        // return;  
        $.ajax({
            type: 'GET',
            url: '../cgi-bin/user.pl',
            data: ajxData,
            success: function(str){
            $('#modal_content').html(str);
                // row_control
                // console.log(str);
                // $(str).insertAfter(row);
            }
        });
    }
}
function user_addNewVolunteer(o, userIDX) {
    var userIDX          = $(o).closest('tr').find('select option:selected').val();
    if (userIDX==0){return}
    var row = $(o).closest('tr');
    var ajxData          = {};
    var data             = {};
    ajxData.do           = 'user_addNewVolunteer';
    ajxData.act          = 'print';
    ajxData.userIDX      = userIDX;
    ajxData.eventIDX     = $.cookie('LOCATION');
    // console.log(ajxData);
    $(o).closest('tr').find('select option:selected').remove();
    $.ajax({
        type: 'GET',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $(str).insertAfter(row);
        }
    });
}
function user_dropAll(o, userIDX) {
    var jsYes = confirm('Click [ OK ] to confirm the action to REMOVE this Judge from the Event Volunteer List');
    if (!jsYes){return}
    var ajxData          = {};
    ajxData.do           = 'user_dropAll';
    ajxData.act          = 'print';
    ajxData.userIDX      = userIDX;
    ajxData.eventIDX     = $.cookie('LOCATION');
    $.ajax({
        type: 'GET',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            $(o).closest('tr').remove();
        }
    });
    }
function user_addRemoveVolunteer(o, userIDX, inType, classIDX) {
    var profileIDX       = $(o).data('value');
    var ajxData          = {};
    var data             = {};
    ajxData.do           = 'user_addRemoveVolunteer';
    ajxData.act          = 'print';
    data.IN_TYPE         = inType;
    data.FK_CLASS_IDX    = classIDX;
    data.FK_USER_IDX     = userIDX;
    data.IN_LIMIT        = 5;
    data.FK_EVENT_IDX    = $.cookie('LOCATION');
    // console.log("profileIDX = " + profileIDX);
    if(o.checked){
        // console.log("Add");
        ajxData.boAdd      = 1;
        ajxData.profileIDX = 0;
    } else {
        ajxData.boAdd      = 0;
        ajxData.profileIDX = profileIDX ;
        // console.log("Remove");
    }
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    // return
    $.ajax({
        type: 'GET',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $(o).data('value', str);
            // console.log("Done");
        }
    });
}
// ===============2023 ==========================================
function user_openGeneralEmailForm (o, field) {
    var ajxData = {};
    ajxData.do                   = 'user_openGeneralEmailForm';
    ajxData.act                  = 'print';
    ajxData.eventIDX             = $.cookie('LOCATION');
    ajxData.field                = field;
    ajxData.loginUserIDX         = $.cookie('PK_USER_IDX');
    console.log(ajxData);
    $.modal("Create list by Copying", "75%");
    // return;
    $.ajax({
        type: 'GET',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            
            $('#modal_content').html(str);
        },
        complete: function(){
            var scrollHeight = $('#EMAIL_TO').prop('scrollHeight');
            console.log($('#EMAIL_TO').prop('scrollHeight'));
            $('#EMAIL_TO').css("min-height",scrollHeight+'px')
        }
    });
    }
function user_downloadEmailList(o) {
    var ajxData = {};
    ajxData.do                   = 'user_downloadEmailList';
    ajxData.act                  = 'print';
    ajxData.FK_EVENT_IDX         = $.cookie('LOCATION');;
    // console.log(ajxData);
    $.ajax({
        type: 'GET',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            console.log("Done");
        }
    });
    }
function user_removeJudgeFromEventList (o, userIDX) {
    var jsYes = confirm("Click OK to confirm the removal of this Judge from the event.");
    if (!jsYes){return}
    var ajxData = {};
    ajxData.do                   = 'user_removeJudgeFromEventList';
    ajxData.act                  = 'print';
    ajxData.FK_EVENT_IDX         = $.cookie('LOCATION');;
    ajxData.FK_USER_IDX          = userIDX;

    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            $('#userBarPreference_'+userIDX).removeClass('w3-white').addClass('w3-pale-red');
            $('#userBarPreference_'+userIDX).fadeOut(500);
        }
    });
}
function user_closeAddJudgeModal (o, eventIDX) {
    $('#mainPageContent').html(loading);
    $(o).close();
    openManageJudges();
    // $('#EVENT_LIST_'+eventIDX).html(str);
}
function user_selectClassesPreference(o, classIDX, userIDX) {
    if (classIDX==0){
        user_updateClassPreference(o,1);
        user_updateClassPreference(o,2);
        user_updateClassPreference(o,3);
        $('.judgesPreference_'+userIDX).prop('checked', o.checked);
        $('.judgesBarPreference_'+userIDX).prop('checked', o.checked);

    } else {
        var count = $('input.judgesPreference_'+userIDX+':checked').length;
        if (count==3){ 
            $('#judge_'+userIDX+'_selectAll').prop('checked', true);
        } else { 
            $('#judge_'+userIDX+'_selectAll').prop('checked', false);
        }
        // console.log(count);
        user_updateClassPreference(o, classIDX);
        var barCount      = $('input.preferenceCount_'+userIDX+':checked').length;
        var barClassCount = $('input.judgesBarPreference_'+userIDX+':checked').length;
        if (barCount==0){
            $('#userBarPreference_'+userIDX).removeClass('w3-white').addClass('w3-pale-red');
            $('#userBarPreference_'+userIDX).fadeOut(500);
        }
        if (barClassCount>0 && barClassCount<3){
            $('#user_'+userIDX+'_selectAll').prop('checked', false);
        } else if (barClassCount==3) {
            $('#user_'+userIDX+'_selectAll').prop('checked', true);
        }
        // console.log('bar count = ' + barCount);
    }
    var barCount = $('input.preferenceCount_'+userIDX+':checked').length;
    if (barCount==0){
        $('#userBarPreference_'+userIDX).removeClass('w3-white').addClass('w3-pale-red');
        $('#userBarPreference_'+userIDX).fadeOut(500);
    }
}
function user_updateClassPreference (o, classIDX) {
    var inStatus = 0;
    if($(o).is(':checked')){inStatus=1}
    var ajxData = {};
    ajxData.do                   = 'user_addJudgeToList';
    ajxData.act                  = 'print';
    ajxData.FK_EVENT_IDX         = $.cookie('LOCATION');;
    ajxData.FK_CLASS_IDX         = classIDX;
    ajxData.FK_USER_IDX          = $(o).val();
    ajxData.inStatus             = inStatus;

    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
        }
    });
}
function user_openJudgeCopyList (o, viewEventIDX) {
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'user_openJudgeCopyList';
    ajxData.act         = 'print';
    ajxData.eventIDX    = eventIDX;
    $.modal("Create list by Copying", "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
function user_openJudgeList (o, viewEventIDX) {
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'user_openJudgeList';
    ajxData.act         = 'print';
    ajxData.eventIDX    = eventIDX;
    $.modal("List of Judges", "75%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
function user_copyJudgesList (o) {
    var FromEventIDX = $('input[name=eventList]:checked').val();
    var eventIDX = $.cookie('LOCATION');
    var ajxData          = {}; 
    ajxData.do           = 'user_copyJudgesList';
    ajxData.act          = 'print';
    ajxData.FromEventIDX = FromEventIDX;
    ajxData.eventIDX     = eventIDX;
    // $.modal("Create Just List for Event", "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#mainPageContent').html(loading);
            openManageJudges();
            $(o).close();
            // $('#modal_content').html(str);
        }
    });
    // _copyJudgesList
}



// ===============2023 ==========================================

function sae_updateChanges(o, userIDX){
    $('#savedMessage').fadeIn(250);
    // ('w3-hide');
    var inValue, boPassword;
    inValue    = 0;
    boPassword = 0;
    
    var txField = $(o).data('key');
    console.log(txField);
    if ($(o).is(':checkbox')){
        if ($(o).is(':checked')) {inValue = 1} else {inValue = 0}
    } else if ($(o).is(':password')) {
        boPassword = 1;
        inValue = $(o).val();
    } else if ($(o).is(':radio')) {
        inValue = $(o).val();
    } else {
        inValue = $(o).val();
    }
    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_updateChanges','act':'print','userIDX':userIDX,'inValue':inValue,'boPassword':boPassword,'txField':txField},
        success: function(str){
            // $(obj).html(str);
            // $('#x_modal_Content').html(str);
            
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
            
        }
    });
}
function sae_updateUserAccess(o, userIDX, tileIDX){
    var todo = 'sae_addUserAccess';
    if (!$(o).is(':checked')) {
        todo = 'sae_removeUserAccess';
    } 
    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':todo,'act':'print','userIDX':userIDX,'tileIDX':tileIDX},
        success: function(str){
        }
    });
}
function sae_updateUserTeam(o, teamIDX, userIDX){
    var todo = 'sae_addUserTeam';
    if (!$(o).is(':checked')) {
        todo = 'sae_removeUserTeam';
    } 
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':todo,'act':'print','teamIDX':teamIDX,'userIDX':userIDX},
        success: function(str){
            // console.log('str = ' + str);
        }
    });
    // console.log('todo = ' + todo);
    // console.log('userIDX = ' + userIDX);
    // console.log('teamIDX = ' + teamIDX);
}
function sae_SearchUserName(o){
    var input, table, tr, td, i, txtValue;
    var filter = $(o).val().toUpperCase();
    // console.log(filter);
    $('tbody').find('tr').each (function() {
        var text = $(this).find('td').text();
        if (text.toUpperCase().indexOf(filter) >-1) {
            $(this).show();
        } else {
            $(this).hide();
        }
        
    });
}
function sae_loadUserBook(obj){
    var divName = 'TEMP_USERBOOK';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>STARS Users</b>',divName,650);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_loadUserBook','act':'print','location':location,'divName':divName},
        success: function(str){
            // $(obj).html(str);
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_openUserTab(o, tabName) {
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
}

function sae_userSelected(userIDX){
    $.modal('User Profile', '90%');
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_userSelected','act':'print','eventIDX':eventIDX,'userIDX':userIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
}
function sae_processUserAccess(obj, userIDX, tilesIDX){
    var toDo = 'sae_removeUserAccess';
    if (obj.checked) {toDo = 'sae_grantUserAccess'}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':toDo,'act':'print','tilesIDX':tilesIDX, 'userIDX':userIDX},
        success: function(str){
            // $('#groupAccess_Content').html(str);
        }
    });
}
function sae_updateUserLevel(userIDX, inLevel){
    // alert(userIDX+", "+inLevel);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_updateUserLevel','act':'print','inLevel':inLevel, 'userIDX':userIDX},
        success: function(str){
            // alert(str);
            // $('#groupAccess_Content').html(str);
        }
    });
}
function sae_selectAllLevelAccess(inLevel, status, userIDX){
    $('.saeAccessLevel_'+inLevel).each(function(){
        if (status == 1){
            var check = $(this).data("access");
            var tileIDX = $(this).data("key");
            if (check === ''){
                $(this).attr('checked', 'checked');               
                sae_processUserAccess(this, userIDX, tileIDX);
            }
        } else {
            var check = $(this).data("access");
            var tileIDX = $(this).data("key");
            if (check == 'checked'){
                $(this).removeAttr('checked');               
                sae_processUserAccess(this, userIDX, tileIDX);
                // console.log("userIDX="+userIDX+", tileIDX="+tileIDX+"\n");
            }            
        }
    });
}
function sae_deleteUser(o, userIDX){
    var jsYes = confirm("Are you sure you want to delete this user?");
    if (!jsYes){return}
    // $('#manageUserDropdown option:selected').remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_deleteUser','act':'print','userIDX':userIDX},
        success: function(str){
            // $('.sae_userloaded').addClass('w3-hide');
            $('#TR_USER_'+userIDX).remove();
            $(o).close();
        }
    });
}
function sae_resetUserPassword(userIDX, userText){
    var divName = 'TEMP_DIV_RESET_PASSWORD';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>'+userText.toUpperCase()+'</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_resetPassword','act':'print','userIDX':userIDX, 'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}

function sae_getListOfTeams(userIDX){
    var divName = 'TEMP_DIV_ADD_TEAMS';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>TEAMS</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_getListOfTeams','act':'print','location':location,'userIDX':userIDX, 'divName':divName},
        success: function(str){
            // alert(str);
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_subscribeToATeam(obj, teamIDX, teamName, userIDX){
    var location = $.cookie('LOCATION');
    $(obj).parent().remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_addTeamToUser','act':'print','location':location,'userIDX':userIDX, 'teamIDX':teamIDX, 'teamName':teamName},
        success: function(str){
            $('#userListOfTeam_Content_UL').append(str);
        }
    });
}
function sae_removeUserTeam(obj, userTeamIDX){
    var location = $.cookie('LOCATION');
    // console.log("userTeamIDX="+userTeamIDX);
    $(obj).parent().remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_removeUserTeam','act':'print','location':location,'userTeamIDX':userTeamIDX},
        success: function(str){
            // console.log("str="+str);
        }
    });
}
function sae_updateClassPreference(obj, userIDX, classIDX){
    var toDo = 'sae_removeClassPreference';
    if (obj.checked) {toDo = 'sae_addClassPreference'}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':toDo,'act':'print','classIDX':classIDX, 'userIDX':userIDX},
        success: function(str){
            console.log("userIDX="+userIDX+", classIDX="+classIDX+", toDo="+toDo+"\n");
            // $('#groupAccess_Content').html(str);
        }
    });
}
function sae_updateEventPreference(obj, userIDX, eventIDX){
    var toDo = 'sae_removeEventPreference';
    if (obj.checked) {toDo = 'sae_addEventPreference'}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':toDo,'act':'print','eventIDX':eventIDX, 'userIDX':userIDX},
        success: function(str){
            // console.log("userIDX="+userIDX+", eventIDX="+eventIDX+"\n");
            // $('#groupAccess_Content').html(str);
        }
    });
}
function sae_updateUserAttributes(obj, userIDX, field){
    var val = 0;
    if ($(obj).is(':checked')){val=1} 
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_updateUserAttributes','act':'print','field':field, 'userIDX':userIDX,'val':val},
        success: function(str){

        }
    });
}
function sae_askYearStarted(obj, userIDX, txYear, field){
    var inYear = prompt ("Year started volunteering", txYear);
    if (!inYear || inYear==txYear){return}
    var dt = new Date();
    var n = dt.getFullYear();
    $.ajax({
        type: 'POST', 
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_updateUserAttributes','act':'print','field':field, 'userIDX':userIDX,'val':inYear},
        success: function(str){
            $(obj).html(inYear);
            $('#TD_USER_'+userIDX).html(parseInt(n)-parseInt(inYear));
            // alert(parseInt(n)-parseInt(inYear));
        }
    });
}
function sae_selectCurrentEvent(obj, eventIDX){
    $('.event_'+eventIDX).each(function(){
        if (obj.checked){
            // console.log("Yes, "+eventIDX+"\n");
            var userIDX = $(this).val();
            var check = $(this).data("access");
            if (check === ''){
                $(this).attr('checked', 'checked');   
                $(this).data('access', 'checked');
                sae_updateEventPreference(this, userIDX, eventIDX);
            }
        } else {
            // console.log("No, "+eventIDX+"\n");
            var userIDX = $(this).val();
            var check = $(this).data("access");
            if (check == 'checked'){
                $(this).removeAttr('checked');      
                $(this).data('access', '');
                sae_updateEventPreference(this, userIDX, eventIDX);
            }           
        }
    });
}
function sae_selectCurrentClass(obj, classIDX){
    $('.pref_class_'+classIDX).each(function(e, i){
        var userIDX = $(this).val();
        var check = $(this).data("access");
        if (obj.checked){
            console.log("Yes, "+classIDX+"\n");
            if (check === ''){
                $(this).attr('checked', 'checked');   
                $(this).data('access', 'checked');
                sae_updateClassPreference(this, userIDX, classIDX);
            }
        } else {
            console.log("No, "+classIDX+"\n");
            if (check == 'checked'){
                $(this).removeAttr('checked');      
                $(this).data('access', '');
                sae_updateClassPreference(this, userIDX, classIDX);
            }           
        }
    });
}
function sae_loadListOfJudges(){
    var location = $.cookie('LOCATION');
    $('#userContent').html(loading);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_loadListOfJudges','act':'print','location':location},
        success: function(str){
            $('#userContent').html(str);
            // console.log("str="+str);
        }
    });
}
function sae_batchChangePassword(className){
    var obj = {};
    var newPassword = prompt("New Password");
    if (!newPassword || newPassword===''){next}
    $('.'+className).each(function(){
        if (this.checked) {
            // console.log(this.value+"\n");
            obj[this.value] = 1;        
            this.checked = false;
        }
    });
    var jsonData = JSON.stringify( obj );
    // console.log(jsonData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_resetPasswordBatch','act':'print','newPassword':newPassword, 'jsonData':jsonData},
        success: function(str){
            console.log(str);
            alert('Batch Password Reset Complete.');
        }
    });
}

function sae_editUserInfo(userIDX){
    var divName = 'TEMP_USERBOOK';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>STARS Users</b>',divName,650);
    $('#x_modal_Content').html(loading);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_editUserInfo','act':'print','location':location,'userIDX':userIDX,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}

function sae_saveUserInfo(userIDX, divName){
    var txFirstName = $('#TX_FIRST_NAME').val();
    var txLastName = $('#TX_LAST_NAME').val();
    var txEmail = $('#TX_EMAIL').val();
    if (txFirstName === '' || txLastName === '' || txEmail === ''){
        alert('Invalid Update');
        return;
    }
    console.log('txFirstName='+txFirstName+', txLastName='+txLastName+', txEmail='+txEmail+', divName='+divName);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_saveUserInfo','act':'print', 'userIDX':userIDX, 'txFirstName':txFirstName, 'txLastName':txLastName , 'txEmail':txEmail },
        success: function(str){
            $('#saeUserCardInfo').replaceWith(str);
            $('#'+divName).remove();
        }
    });
}







    // var obj = {};
    // $('.inputBinary').each(function(i){
    //     if ($(this).is(":checked")){
    //         obj[$(this).data('key')]=$(this).val();
    //     }
    // });
    // $('.sae-inputs').each(function(i){
    //     obj[$(this).data('key')]=$(this).val();
    // });
    // var jsonData = JSON.stringify( obj );




















