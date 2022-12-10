// {
//     var d=document;
//     var sid = $.cookie('SID');
//     var obj = new Object();
//     var emailFlag=0;
//     var menuData = new Object();
//     var now = new Date();
//     var time = now.getTime();
// }

// $( d ).ready(function(){
//     showLoginScreen();
//     // console.log("going to ShowLoginScreen 4");
//     var expire = parseInt($.cookie('expire'), 10) - parseInt(time, 10);
//     if (expire > 0) {
//         if ($.cookie('LOCATION')===null) {
//             showSetEventLocation();
//         } else {
//             window.location.href="main.html";
//         }
//     } else {
//             deleteAllCookies();
//             showLoginScreen();
//     }
//     // $('#btn_testLogin').addEventListener("click",console.log('Hello World - from addEventListener'));
    
    
// });


// function showLoginScreen(){
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'showLoginScreen','act':'print'},
//         success: function(str){
//             // console.log (str)
//             $('#main').html(str)
//         },
//         error: function(xhr, textStatus, errorThrown){
//             alert(textStatus + ': Request failed ' + errorThrown);
//         }
//     });
// }

// function showRegisterNewUser(){
//     $.modal('Sign up for a free account','35%');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'showRegisterNewUser','act':'print'},
//         success: function(str){
//             $('#modal_content').html(str);
//             checkEmailAddress();
//         },
//         error: function(xhr, textStatus, errorThrown){
//             alert(textStatus + ': Request failed ' + errorThrown);
//         }
//     });
// }
function test(o){
    if(!event.detail || event.detail == 1){
        console.log("True");
        o.disabled = 'disabled';
        $(o).html('Submitting...')
        return true;
    }
    else { 
        console.log("False");
        return false;
    }

}
// function goLogin(o){
//     // console.log(event.detail);
//     if(!event.detail || event.detail == 1){
//         o.disabled = 'disabled';
//         $(o).html('Submitting...');
//     } else {
//         o.disabled = '';
//         $(o).html('Sign-In');
//         return;
//     }
//     var TxEmail = $('#TxEmail').val();
//     var TxPassword = $('#TxPassword').val();
//     var eventIDX = $('#sae_eventSelection :selected').val();
//     if (eventIDX == 0){
//         alert('Please select an Event from the list.');
//         o.disabled = '';
//         $(o).html('Sign-In');
//         return;
//     }
//     // console.log('login test\n');
//     // return;
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'login','act':'print','TxEmail':TxEmail ,'TxPassword':TxPassword,'eventIDX':eventIDX},
//         success: function(str){
//             // console.log(str);
//             var data = JSON.parse(str);
//             if (data.VALID==1) {
//                 var now = new Date();
//                 var time = now.getTime();
//                 var expireTime = time + 1000 * 43200;
//                 now.setTime(expireTime);
//                 $.cookie('SID', data.SID);
//                 $.cookie('TYPE', data.TYPE);
//                 $.cookie('PK_USER_IDX', data.PK_USER_IDX);
//                 $.cookie('PK_JUDGE_IDX', data.PK_USER_IDX);
//                 $.cookie('userIDX', data.PK_USER_IDX);
//                 $.cookie('TX_FIRST', data.TX_FIRST);
//                 $.cookie('TX_LAST', data.TX_LAST);
//                 $.cookie('DATABASE', data.DATABASE);
//                 $.cookie('LOCATION', eventIDX);
//                 $.cookie('eventIDX', eventIDX);
//                 $.cookie('expire',expireTime);
//                 console.log('databasae = '+data.DATABASE);
//                 if (data.RESET==1) {
//                     $.modal('Update Temporary Password', "65%");
//                     $('#modal_content').html(data.HTML);
//                 } else {
//                     window.location.href="main.html";
//                 } 
                
//             } else {
//                 alert("Invalid Login ");
//                 o.disabled = '';
//                 $(o).html('Sign-In');
//             }
//         }
//     });
// }
function sae_cancelChangeTemporaryPassword(o){
    signOutAdmin();
    $(o).close();
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
function setEventLocation(){
    var eventIDX = $('#sae_eventSelection :selected').val();
    $.cookie('LOCATION',eventIDX);
    window.location.href="main.html";
}

// function registerNewUser(divName){
//     if (emailFlag==1){
//         alert('Email used already exists in the Database.');
//         $('#NewTxEmail').val("")
//         return;
//     }
//     var TxFirstName = $('#NewFirstName').val();
//     var TxLastName = $('#NewLastName').val();
//     var TxEmail = $('#NewTxEmail').val();
//     var TxPassword = $('#NewPassword').val();
//     var ConPassword = $('#ConPassword').val();
//     if (TxPassword != ConPassword){
//         alert("PASSWORD MISMATCH\n\nTry Again");
//         $('#ConPassword').val('');
//         $('#NewPassword').val('').focus();
//         return;
//     }
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'registerNewUser','act':'print','TxEmail':TxEmail ,'TxPassword':TxPassword,'TxLastName':TxLastName ,'TxFirstName':TxFirstName},
//         success: function(str){
//             $('#modal_content').html(str);
//         }
//     });
// }
// function checkEmailAddress(){
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'checkEmailAddress','act':'print'},
//         success: function(str){
//             obj = JSON.parse(str);
//         }
//     });
// }
// function validateEmailInDb(val){
//     if (!obj.hasOwnProperty(val)){
//         $('#emailWarning').hide();
//         emailFlag=0;
//     } else {
//         $('#emailWarning').show().html('This email [ '+val+' ] already exist.  Please use to the <a href="javascript:void(0);">Reset Password</a> option to recover your account or use a different email address to proceed with registration.');
//         $('#NewTxEmail').focus();
//         emailFlag=1;
//     }
// }
// function sae_showResetPassword(){
//     $.modal("Temporary Password Request", "65%");
//     var txEmail = $('#TxEmail').val();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'showResetPassword','act':'print','txEmail':txEmail},
//         success: function(str){
//             $('#modal_content').html(str);
//             // $('#id01_content').html(str);
//         }
//     });
// }
function resetPassword(){
    var txEmail = $('#NewTxEmail').val();
    if (isEmpty(txEmail)){
        console.log("No Email Address Provided");
        alert("No Email Address Provided.  Your temporary password request was canceled.");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'resetPassword','act':'print','txEmail':txEmail},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
// function updateTempPassword(o, TxEmail, TempPassword){
//     var Temp = $('#TempPassword').val();
//     // if (Temp != TempPassword){
//     //     alert("Invalid Temporary Password");
//     //     $('#TempPassword').val("").focus();
//     //     return;
//     // }
//     var TxNewPassword = $('#NewPassword').val();
//     var TxConPassword = $('#ConPassword').val();
//     if (TxNewPassword != TxConPassword) {
//         alert('You new password does not match.');
//         return;
//     }
//     console.log("temp Password = " + Temp);
//     console.log("New Password = " + TxNewPassword);
//     console.log("Old Password = " + TxConPassword);
//     return
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/index.pl',
//         data: {'do':'updateTempPassword','act':'print','TxEmail':TxEmail,'TxPassword':TxNewPassword},
//         success: function(str){
//             // $('#main').html(str);
//             $(o).close();
//             window.location.href="main.html";
//             // showSetEventLocation($.cookie('TYPE'));
//             // $('#id01_content').html('');
//             // $('#id01').hide();
//         }
//     });
// }

