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
    showLoginScreen();
    // console.log("going to ShowLoginScreen 4");
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
    // $('#btn_testLogin').addEventListener("click",console.log('Hello World - from addEventListener'));
    
    
});

class sae_form{
    constructor (formID) {
        this.formID = formID;
    }
    
    process() {
        var obj = {};
        const formName = $(this.formID);
        const data = new FormData(document.getElementById(this.formID));
        data.forEach((value, key) => obj[key]=value);
        return(JSON.stringify(obj));
    }
    
    getData() {
        var obj = {};
        const formName = $(this.formID);
        const data = new FormData(document.getElementById(this.formID));
        data.forEach((value, key) => obj[key]=value);
        return(obj)
    }
}

// [Begin] User Sign-In ***********************************************************************
function showLoginScreen(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showLoginScreen','act':'print'},
        success: function(str){
            // console.log (str)
            $('#main').html(str)
        },
        error: function(xhr, textStatus, errorThrown){
            alert(textStatus + ': Request failed ' + errorThrown);
        }
    });
}
function goLogin(o){
    if(!event.detail || event.detail == 1){
        o.disabled = 'disabled';
        $(o).html('Submitting...');
    } else {
        o.disabled = '';
        $(o).html('Sign-In');
        return;
    }
    var frm = new sae_form('form_login');
    var ajxData = {};
    ajxData['do'] = 'login';
    ajxData['act'] = 'print';
    ajxData['jsonData'] = frm.process();
    var data = {};
        data = frm.getData();
    // var eventIDX = data.FK_EVENT_IDX;
    if (data.FK_EVENT_IDX == undefined) {
        alert('Please select an Event from the list.');
        o.disabled = '';
        $(o).html('Sign-In');
        return;
    }
    // console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',

        url: '../cgi-bin/index.pl',
        data: ajxData,
        success: function(str){
            var obj = JSON.parse(str);
            console.log("Obj.STATUS = " + obj.STATUS);
            console.log("Obj.SALT = " + obj.SALT);
            if (obj.STATUS == 1) {
                var now = new Date();
                var time = now.getTime();
                var expireTime = time + 1000 * 43200;
                now.setTime(expireTime);
                $.cookie('expire',expireTime);
                for (const key in obj){
                    if (key != 'HTML') {
                        console.log(key +":" + obj[key]);
                        $.cookie(key, obj[key]);
                    }
                }
                if (obj.BO_RESET == 1) {
                    $.modal('Update Temporary Password', "65%");
                    $('#modal_content').html(obj.HTML);
                    var onclickValue = $('#modal_x1').attr('onclick') + 'signOutAdmin();';
                    $('#modal_x1').attr('onclick', onclickValue);
                } else {
                    window.location.href="main.html";
                }
            } else {
                alert("Invalid Login ");
                o.disabled = '';
                $(o).html('Sign-In');                
            }
        }
    });
    return;
}
// [END] User Sign-In -------------------------------------------------------------------------
// [BEGIN] User Password Reset ****************************************************************
function changeTemporaryPassword(o, userIDX, TxEmail, TempPassword){
    var frm = new sae_form('form_passwordReset');
    var obj = frm.getData();
    const ajxData = {};
    ajxData['do'] = 'changeTemporaryPassword';
    ajxData['act'] = 'print';
    ajxData['userIDX'] = userIDX;

    if (obj.TEMP_PASSWORD != TempPassword){
        alert("Invalid Temporary Password");
        $('#TEMP_PASSWORD').val("").focus();
        return
    }
    if (obj.TX_PASSWORD != obj.CON_PASSWORD) {
        alert('You new password does not match.');
        $('#CON_PASSWORD').val("").focus();
        return
    }
    delete obj.CON_PASSWORD;
    delete obj.TEMP_PASSWORD;
    obj.BO_RESET=0;
    ajxData.jsonData = JSON.stringify(obj);
    // console.log(ajxData);

    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            $(o).close();
            window.location.href="main.html";
        }
    });
}
function sae_comparePassword(conPassword){
    var TxPassword = $('#TX_PASSWORD').val();
    // console.log('TX_PASSWORD = ' + TxPassword);
    // console.log('CONFIRM_PASSWORD = ' + conPassword);
    if (TxPassword != conPassword){
        $('#msg_passwordMismatch').show();
        console.log('mis-Match');
        $('#btn_register').prop('disabled', true);
    } else {
        $('#msg_passwordMismatch').hide();
        console.log('Match');
        $('#btn_register').prop('disabled', false).focus();

    }
}
function sae_showResetPassword(){
    $.modal("Temporary Password Request", "45%");
    var txEmail = $('#TxEmail').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showResetPassword','act':'print','txEmail':txEmail},
        success: function(str){
            $('#modal_content').html(str);
            // $('#id01_content').html(str);
        }
    });
}
function sae_cancelChangeTemporaryPassword(o){
    signOutAdmin();
    $(o).close();
}
// [END] User Password Reset ------------------------------------------------------------------
// [Begin] User Registration ******************************************************************
function btn_registerNewUser () {
    var frm = new sae_form('form_registerNewUser');
    var ajxData = {};
    ajxData['do'] = 'registerNewUser';
    ajxData['act'] = 'print';
    ajxData['jsonData'] = frm.process();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: ajxData,
        success: function(str){
            console.log(str)
            $('#modal_content').html(str);
            // if return values are in JSON format, uncomment the line below.
            // obj = JSON.parse(str);
        }
    });
}
function showRegisterNewUser(){
    $.modal('Sign up for a free account','80%','w3-green');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: {'do':'showRegisterNewUser','act':'print'},
        success: function(str){
            $('#modal_content').html(str);
            checkEmailAddress();
        },
        error: function(xhr, textStatus, errorThrown){
            alert(textStatus + ': Request failed ' + errorThrown);
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
// [END] User Registration --------------------------------------------------------------------
function btn_testLogin(){
    var form = new sae_form('form_login');
    var data = {};
        data = form.process();
    console.log(data)
}
function btn_objectTest () {
    var frm = new sae_form('form_registerNewUser');
    var ajxData = {};
    ajxData['do'] = 'objectTest';
    ajxData['act'] = 'print';
    ajxData['jsonData'] = frm.process();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: ajxData,
        success: function(str){
            console.log(str)
            // if return values are in JSON format, uncomment the line below.
            // obj = JSON.parse(str);
        }
    });
}
function btn_testUpdateData () {
    // if a modal window is needed, uncomment the line below.
    // $.modal('modalName','60%');
    var frm = new sae_form('form_registerNewUser');
    var ajxData = {};
    ajxData['do'] = 'testUpdateData';
    ajxData['act'] = 'print';
    ajxData['IDX'] = 3626;
    ajxData['jsonData'] = frm.getData();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            // if return values are in JSON format, uncomment the line below.
            // obj = JSON.parse(str);

            // if modal window is called, uncomment the line below
            // $('#modal_content').html(str);
        }
    });
}
function btn_testDeleteData () { //btn_testDeleteData
    // if a modal window is needed, uncomment the line below.
    // $.modal('modalName','60%');
    // var frm = new sae_form('formName');
    var ajxData = {};
    ajxData['do'] = 'testDeleteData';
    ajxData['act'] = 'print';
    // ajxData['jsonData'] = frm.getData();
    ajxData['IDX'] = 3626;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/index.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            // if return values are in JSON format, uncomment the line below.
            // obj = JSON.parse(str);

            // if modal window is called, uncomment the line below
            // $('#modal_content').html(str);
        }
    });
}

