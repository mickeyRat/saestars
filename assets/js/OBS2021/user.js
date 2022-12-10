    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';

function sae_loadUserBook(obj){
    var divName = 'TEMP_USERBOOK';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>STARS Users</b>',divName,650);
    var location = $.cookie("LOCATION");
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

function sae_userSelected(userIDX, txName, divName){
    // console.log(userIDX+", "+txName);
    // $('#PK_USER_IDX').val(userIDX);
    // $('#display_Name').html(txName);
    $('#'+divName).remove();
    $('.sae_userloaded').removeClass('w3-hide')
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_userSelected','act':'print','location':location,'userIDX':userIDX,'userName':txName},
        success: function(str){
            $('#userContent').html(str);
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
function sae_deleteUser(userIDX){
    var jsYes = confirm("Are you sure you want to delete this user?");
    if (!jsYes){return}
    $('#manageUserDropdown option:selected').remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_deleteUser','act':'print','userIDX':userIDX},
        success: function(str){
            $('.sae_userloaded').addClass('w3-hide');
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




















