    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';

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




















