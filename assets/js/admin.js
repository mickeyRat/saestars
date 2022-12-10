    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();

//     alert(d.cookie + " NOW = " + time);
$( d ).ready(function(){
    var userType = $.cookie('TYPE');
    if ($.cookie('expire') === null || $.cookie('expire') < time) {
        alert('Your session expired.  Please log in again');
        signOutAdmin();
    } else if ($.cookie('SID') && userType != '99'){
        signOutAdmin();
    }  else {
        loadMainPage();
    }
});
// ===== Loading Page Tiles ===+=============================================================
function loadMainPage(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'loadMainPage','act':'print'},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function loadSetupAndAdministration(){

    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'loadSetupAndAdministration','act':'print'},
        success: function(str){
            $('#main').html(str);
//             alert(str);
//             $('#pageTitle').html('STARS - User Account Administration');
        }
    });
}
function loadDesignReportManagement(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'loadDesignReportManagement','act':'print'},
        success: function(str){
            $('#main').html(str);
            $('#pageTitle').html('STARS - Design Report Administration');
            $('#backButton').off('click').on('click', function(){
                window.location.href="admin.html";
            }).show();
        }
    });
}
// ==========================================================================================
function submitResetAllJudgesPassword(){
    var tempPassword = $('#TempPassword').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'submitResetAllJudgesPassword','act':'print','tempPassword':tempPassword},
        success: function(str){
            alert('Password was rest for '+str+' judges.');
            closeModal('id01');
        }
    });
}
function resetAllJudgesPassword(){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'resetAllJudgesPassword','act':'print'},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function transactionFeed(){
    var location = $.cookie('LOCATION');
    $('#main').html('Loading...');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'transactionFeed','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
            $('#pageTitle').html('STARS - User Account Administration');
        }
    });
}
function loadNextSet(start, end){
    var location = $.cookie('LOCATION');
    $('#loadNextButton').remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'loadNextSet','act':'print','location':location,'start':start,'end':end},
        success: function(str){
            $('#feedContent').append(str);

        }
    });
}
function showUserAccountList(){
    var userTypeNumber = $.cookie('TYPE');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'showUserAccountList','act':'print','userTypeNumber':userTypeNumber},
        success: function(str){
            $('#main').html(str);
            $('#pageTitle').html('STARS - User Account Administration');
        }
    });
}
function showUserAccountInfo(PkUserIdx){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'showUserAccountInfo','act':'print','PkUserIdx':PkUserIdx},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function removeTeamFromUser(PkUserTeamIdx){
    var jsYes = confirm ("Are you sure? ");
    if (!jsYes){return}
//     alert(PkUserTeamIdx);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'removeTeamFromUser','act':'print','PkUserTeamIdx':PkUserTeamIdx},
        success: function(str){
            $('#USER_TEAM_'+PkUserTeamIdx).remove();
        }
    });
}
function showAddTeamToUser(PkUserIdx){
//     if ($('#EDIT_CENTER_ADD_TEAM').length == 0){
//         $('html').prepend('<div ID="EDIT_CENTER_ADD_TEAM" class="editDivAddTeam"></div>');
//     }
//     $('#EDIT_CENTER_ADD_TEAM').center();
    $('#id02').show();
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'showAddTeamToUser','act':'print','PkUserIdx':PkUserIdx,'location':location},
        success: function(str){
            $('#id02_content').html(str);
//             $('#EDIT_CENTER_ADD_TEAM').html(str);
        }
    });
}
function addSelectedTeamToUser(PkTeamIdx, PkUserIdx){
$('#LI_AVAILABLE_TEAM_'+PkTeamIdx).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'addSelectedTeamToUser','act':'print','PkTeamIdx':PkTeamIdx,'PkUserIdx':PkUserIdx},
        success: function(str){
//             deleteEditDivAddTeam();
//             closeModal('id02');
//             alert(str);

            $('#USER_TEAM_LIST').prepend(str);
        }
    });
}
function updateUserInfo(PkUserIdx){
    var TxFirstName = $('#TX_FIRST_NAME').val();
    var TxLastName = $('#TX_LAST_NAME').val();
    var TxEmail = $('#TX_EMAIL').val();
    var InUserType = $("input[name=UserType]:checked").val();
//     alert(TxFirstName+', '+TxLastName+', '+TxEmail+', '+InUserType);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'updateUserInfo','act':'print','PkUserIdx':PkUserIdx,'InUserType':InUserType ,'TxEmail':TxEmail ,'TxLastName':TxLastName ,'TxFirstName':TxFirstName},
        success: function(str){
            closeModal('id01');
            var obj = JSON.parse(str);
            $('#SPAN_FULLNAME_'+PkUserIdx).html(obj.TX_FULLNAME);
            $('#TD_TX_EMAIL_'+PkUserIdx).html(obj.TX_EMAIL);
            $('#IMG_AVATAR_'+PkUserIdx).attr('src','../images/'+obj.TX_USER_TYPE+'.png');
        }
    });
}
function deleteResetPasswordDiv(){
    $('#RESET_PASSWORD_DIV').remove();
}
function showResetPassword(PkUserIdx){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'showResetPassword','act':'print','PkUserIdx':PkUserIdx},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function generateRandomPassword(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'generateRandomPassword','act':'print'},
        success: function(str){
            $('#TempPassword').val(str);
        }
    });
}
function submitPasswordReset(PkUserIdx){
    var tempPassword = $('#TempPassword').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'submitPasswordReset','act':'print','PkUserIdx':PkUserIdx,'tempPassword':tempPassword},
        success: function(str){
            // deleteResetPasswordDiv();
            closeModal('id01');
        }
    });
}
function addEventToAJudge(PkUserIdx){
    var location = $.cookie('LOCATION');
//     var divName = "DIV_ADD_EVENT_TO_JUDGE";
// //     alert(PkUserIdx);
//     if ($('#'+divName).length == 0){
//         $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="width: 50%; z-index: 400"></div>');
//     }
//     $('#'+divName).center();
    $('#id02').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'addEventToAJudge','act':'print','PkUserIdx':PkUserIdx},
        success: function(str){
//         alert(str);
//             $('#'+divName).html(str);
            $('#id02_content').html(str);
        }
    });
}
function addEventLimitToJudge(PkUserIdx, PkEventIdx, TxEventName){
    var InLimit = $('#IN_LIMIT_'+PkEventIdx).val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'addEventLimitToJudge','act':'print','PkUserIdx':PkUserIdx,'PkEventIdx':PkEventIdx, 'InLimit':InLimit,'TxEventName':TxEventName},
        success: function(str){
            $('#JUDGE_EVENT_PARTICIPATION').append(str);
            $('.CTRL_'+PkEventIdx).remove();
            $('#LBL_'+PkEventIdx).html('Already participating in '+TxEventName);
//             if (close==0){
//                 closeModal('id02');
//             } else {
//                  $('#PK_EVENT_IDX').val($('#PK_EVENT_IDX option:first').val());
//             }

        }
    });
}
function deleteUserEventItem(PkUserEventIdx){
    var jsYes = confirm("Are you sure?" +PkUserEventIdx );
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'deleteUserEventItem','act':'print','PkUserEventIdx':PkUserEventIdx},
        success: function(str){
//             alert(str);
            $('#EVENT_LIST_'+PkUserEventIdx).remove();
        }
    });
}
function filterView(Item){
    $('.SAE_ALL').hide();
    $('.SAE_'+Item).show();
}
function deleteUser(PkUserIdx){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/admin.pl',
        data: {'do':'deleteUser','act':'print','PkUserIdx':PkUserIdx},
        success: function(str){
            $('#LIST_USER_'+PkUserIdx).remove();
        }
    });
}
