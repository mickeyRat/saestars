{
    var d=document;
    var sid = $.cookie('SID');
    var obj = new Object();
    var emailFlag=0;
    var menuData = new Object();
    var now = new Date();
    var time = now.getTime();
}

$( d ).ready(function(){
    var expire = parseInt($.cookie('expire'), 10) - parseInt(time, 10);
    if (expire > 0) {
        if ($.cookie('LOCATION')===null) {
            showSetEventLocation();
        } else {
            window.location.href="main.html";
        }
    } else {
            deleteAllCookies();
            showLoginScreen();
    }
});

function showLoginScreen(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showLoginScreen','act':'print'},
        success: function(str){
            $('#main').html(str)
        },
        error: function(xhr, textStatus, errorThrown){
            alert(textStatus + ': Request failed ' + errorThrown);
        }
    });
}
// var divName = 'TEMP_DIV_SECTION_EDITOR';
// createNewModalDiv('Edit Section',divName,500);
// $.ajax({
//     type: 'POST',
//     url: '../cgi-bin/rubric.pl',
//     data: {'do':'showEditSection','act':'print','divName':divName,'sectionIDX':sectionIDX,'inType':inType},
//     success: function(str){
//         $('#x_modal_Content').html(str);
//     }
// });   

function showRegisterNewUser(){
    var divName = 'TEMP_DIV_RegisterNewUser';
    createNewModalDiv('Registration',divName,500);
    console.log(divName);
    // $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showRegisterNewUser','act':'print','divName':divName},
        success: function(str){
//             $('#main').html(str);
            $('#x_modal_Content').html(str);
            // $('#id01_content').html(str);
            checkEmailAddress();

        },
        error: function(xhr, textStatus, errorThrown){
            alert(textStatus + ': Request failed ' + errorThrown);
        }
    });
}
function goLogin(){
    var TxEmail = $('#TxEmail').val();
    var TxPassword = $('#TxPassword').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'login','act':'print','TxEmail':TxEmail ,'TxPassword':TxPassword},
        success: function(str){
            var data = JSON.parse(str);
            if (data.VALID==1) {
                var now = new Date();
                var time = now.getTime();
                var expireTime = time + 1000 * 43200;
                now.setTime(expireTime);
                $.cookie('SID', data.SID);
                $.cookie('TYPE', data.TYPE);
                $.cookie('PK_USER_IDX', data.PK_USER_IDX);
                $.cookie('PK_JUDGE_IDX', data.PK_USER_IDX);
                $.cookie('userIDX', data.PK_USER_IDX);
                $.cookie('TX_FIRST', data.TX_FIRST);
                $.cookie('TX_LAST', data.TX_LAST);
                $.cookie('DATABASE', data.DATABASE);
                $.cookie('expire',expireTime);
                if (data.RESET==1) {
                    $('#id01').show();
                    $('#id01_content').html(data.HTML);
                } else {
                    showSetEventLocation(data.TYPE);
                }
            } else {
                alert("Invalid Login ");
            }
        }
    });
}
function showSetEventLocation(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showSetEventLocation','act':'print'},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function setEventLocation(eventIDX){
    $.cookie('LOCATION',eventIDX);
    window.location.href="main.html";
}

function registerNewUser(divName){
    if (emailFlag==1){
        alert('Email used already exists in the Database.');
        $('#NewTxEmail').val("")
        return;
    }
    var TxFirstName = $('#NewFirstName').val();
    var TxLastName = $('#NewLastName').val();
    var TxEmail = $('#NewTxEmail').val();
    var TxPassword = $('#NewPassword').val();
    var ConPassword = $('#ConPassword').val();
    if (TxPassword != ConPassword){
        alert("PASSWORD MISMATCH\n\nTry Again");
        $('#ConPassword').val('');
        $('#NewPassword').val('').focus();
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'registerNewUser','act':'print','TxEmail':TxEmail ,'TxPassword':TxPassword,'TxLastName':TxLastName ,'TxFirstName':TxFirstName,'divName':divName },
        success: function(str){
            // $('#id01_content').html(str);
            $('#x_modal_Content').html(str);
        }
    });
}
function checkEmailAddress(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'checkEmailAddress','act':'print'},
        success: function(str){
            obj = JSON.parse(str);
        }
    });
}
function validateEmailInDb(val){
    if (!obj.hasOwnProperty(val)){
        $('#emailWarning').hide();
        emailFlag=0;
    } else {
        $('#emailWarning').show().html('This email [ '+val+' ] already exist.  Please use to the <a href="javascript:void(0);">Reset Password</a> option to recover your account or use a different email address to proceed with registration.');
        $('#NewTxEmail').focus();
        emailFlag=1;
    }
}
function showResetPassword(){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showResetPassword','act':'print'},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function resetPassword(){
    var TxEmail = $('#NewTxEmail').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'resetPassword','act':'print','TxEmail':TxEmail},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function updateTempPassword(TxEmail, TempPassword){
    var Temp = $('#TempPassword').val();
    if (Temp != TempPassword){
        alert("Invalid Temporary Password");
        $('#TempPassword').val("").focus();
        return;
    }
    var TxNewPassword = $('#NewPassword').val();
    var TxConPassword = $('#ConPassword').val();
    if (TxNewPassword != TxConPassword) {
        alert('You new password does not match.');
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'updateTempPassword','act':'print','TxEmail':TxEmail,'TxPassword':TxNewPassword},
        success: function(str){
            $('#main').html(str);
            showSetEventLocation($.cookie('TYPE'));
            $('#id01_content').html('');
            $('#id01').hide();
        }
    });
}

