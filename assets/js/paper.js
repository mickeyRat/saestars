{    
    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();
    var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';
    // var nameList = [];
}

// 2024 =====================================================================================
    function paper_batchAssign (o, classIDX, inType) {
    var eventIDX = $.cookie('LOCATION');
    var userIDX  = $('input[name="batch"]:checked').val();
    var volName  = $('input[name="batch"]:checked').data('value');
    if (userIDX==0){
        var jsYes = confirm("Click [ OK ] to confirm that you want to UNASSIGN a volunteer Judge for this Activity?");
        if (!jsYes){return}
    }
    // console.log("userIDX = " + userIDX);

    // var userIDX  = $('#BATCH_' + classIDX + ' :selected').val();
    var ajxData         = {}; 
    ajxData.do          = 'paper_batchAssign';
    ajxData.act         = 'print';
    ajxData.classIDX    = classIDX;
    ajxData.userIDX     = userIDX;
    ajxData.eventIDX    = eventIDX;
    ajxData.inType      = inType;
    ajxData.volName     = volName;
    console.log(JSON.stringify(ajxData));
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            if (userIDX == 0) {
                $('.judgeButton_'+classIDX).remove();
            } else {
                if (str){
                    // console.log("not Empty");
                    var obj = JSON.parse(str);
                    for (var key in obj) {
                    // console.log('key = ' + key);
                        for (var button in obj[key]){
                            $('#row_'+key).append(obj[key][button]);
                            // console.log(button);
                        }
                    }
                } 
            }
            $(o).close();
        }
    });
    }
    function paper_autoAssign (o, classIDX, inType) {
        var eventIDX = $.cookie('LOCATION');
        var inLimit  = $('#CLASS_LIMIT').val();
        if (inLimit == '' || inLimit == 'NaN'){
            alert("Please specify the number of report limit per judge.");
            return;
        }
        var ajxData         = {}; 
        ajxData.do          = 'paper_autoAssign';
        ajxData.act         = 'print';
        ajxData.classIDX    = classIDX;
        ajxData.inLimit     = inLimit;
        ajxData.eventIDX    = eventIDX;
        ajxData.inType      = inType;
        // console.log(JSON.stringify(ajxData));
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                // console.log(str);
                var obj = JSON.parse(str);
                // console.log(obj);
                for (var key in obj) {
                    // console.log('key = ' + key);
                    for (var button in obj[key]){
                        $('#row_'+key).append(obj[key][button]);
                        // console.log(button);
                    }
                }
            }
        });
        }
    function paper_openBatchAssign(o, classIDX, inType) {
        // body...
        // console.log("classIDX = " + classIDX);
        // console.log("inType = " + inType);
        var eventIDX = $.cookie('LOCATION');
        var ajxData         = {}; 
        ajxData.do          = 'paper_openBatchAssign';
        ajxData.act         = 'print';
        ajxData.inType      = inType;
        ajxData.classIDX    = classIDX;
        ajxData.eventIDX    = eventIDX;
        console.log(JSON.stringify(ajxData));
        $.modal("Batch Assignment", "40%");
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                // console.log(str);
                $('#modal_content').html(str);
            }
        });
        }
    function paper_openAutoAssign (o, classIDX, inType) {
        var eventIDX = $.cookie('LOCATION');
        var ajxData         = {}; 
        ajxData.do          = 'paper_openAutoAssign';
        ajxData.act         = 'print';
        ajxData.inType      = inType;
        ajxData.classIDX    = classIDX;
        ajxData.eventIDX    = eventIDX;
        $.modal("Auto Assignment", "50%");
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                // console.log(str);
                $('#modal_content').html(str);
            }
        });
        }
    function paper_showVolunteerStatistics(o, userIDX, classIDX, teamIDX, cardIDX) {
        var className = 'vol_'+userIDX;
        if ($(o).closest('tr').next('tr').hasClass(className)){
            do {
                $(o).closest('tr').next('tr').remove();
            } while ($(o).closest('tr').next('tr').hasClass(className));
        } else {
            var row = $(o).closest('tr');
            var eventIDX         = $.cookie('LOCATION');
                var ajxData          = {}; 
                ajxData.do           = 'paper_showVolunteerStatistics';
                ajxData.act          = 'print';
                ajxData.eventIDX     = eventIDX;
                ajxData.userIDX      = userIDX;
                ajxData.classIDX     = classIDX;
                ajxData.cardIDX      = cardIDX;
                $.ajax({
                    type: 'POST',
                    url: '../cgi-bin/paper.pl',
                    data: ajxData,
                    success: function(str){
                        $(str).insertAfter(row);
                    }
                });
        }


        }
    function paper_changeNavButtonColor(o) {
        $('.paperTab').removeClass('w3-red');
        $(o).addClass('w3-red');
        }
    function paper_openTab(o, inType) {
        $('#tabContent').html(loading); 
        paper_changeNavButtonColor(o);
        var eventIDX         = $.cookie('LOCATION');
        var ajxData          = {}; 
        ajxData.do           = 'paper_openTab';
        ajxData.act          = 'print';
        ajxData.inType       = inType;
        ajxData.eventIDX     = eventIDX;
        // console.log(JSON.stringify(ajxData));
       $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                $('#tabContent').html(str);
            }
        });
    }
    function paper_openJudgeList(o, classIDX, teamIDX, inType) {
        var eventIDX         = $.cookie('LOCATION');
        var ajxData          = {}; 
        ajxData.do           = 'paper_openJudgeList';
        ajxData.act          = 'print';
        ajxData.eventIDX     = eventIDX;
        ajxData.classIDX     = classIDX;
        ajxData.teamIDX      = teamIDX;
        ajxData.inType       = inType;
        $.modal("Volunteer Judges", "85%");
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                // console.log(str);
                $('#modal_content').html(str);
            }
        });
    }
    function paper_addRemoveAssignment(o, teamIDX, cardIDX, inType, classIDX) {
        var addVolunteer = 0; //0 = false; 1=true
        if ($(o).is(':checked')){
            addVolunteer = 1;
        } else {
            var jsYes = confirm("Click [ OK ] to confrim the action to REMOVE this Judge");
            if(!jsYes){
                $(o).prop('checked', 'checked');
                return;
            }
        }
        // console.log('addVolunteer =' + addVolunteer);
        var volName          = $(o).data('value'); 
        var userIDX          = $(o).val(); 
        var eventIDX         = $.cookie('LOCATION');
        var ajxData          = {}; 
        ajxData.do           = 'paper_addRemoveAssignment';
        ajxData.act          = 'print';
        ajxData.eventIDX     = eventIDX;
        ajxData.cardIDX      = cardIDX;
        ajxData.teamIDX      = teamIDX;
        ajxData.userIDX      = userIDX;
        ajxData.volName      = volName;
        ajxData.inType       = inType;
        ajxData.classIDX       = classIDX;
        ajxData.addVolunteer = addVolunteer;
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                if (addVolunteer === 1){
                    $('#row_'+teamIDX).append(str);
                } else {
                    $('#JUDGE_BUTTON_'+str).remove();
                }
                
            }
        });
        }
    function paper_openAssessment (o, cardIDX, classIDX, teamIDX, inCardType) {
        var eventIDX = $.cookie('LOCATION');
        var userIDX = $.cookie('PK_USER_IDX');
        console.log("cardIDX = " + cardIDX);
        console.log("classIDX = " + classIDX);
        console.log("teamIDX = " + teamIDX);
        console.log("inCardType = " + inCardType);
        $.modal('Assessment', '97%');
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/grade.pl',
            data: {'do':'grade_openAssessment','act':'print','eventIDX':eventIDX,'cardIDX':cardIDX,'userIDX':userIDX,'classIDX':classIDX,'teamIDX':teamIDX,'inCardType':inCardType},
            success: function(str){
                $('#modal_content').html(str);
            }
        });
    }
    function paper_getTeamScoringDetails(o, teamIDX, inType, classIDX) {
        $('#DETAILS_'+teamIDX).toggleClass('w3-hide');
        if ($('#DETAILS_'+teamIDX).hasClass('w3-hide')){
            // console.log("Do Nothing");
            $('#DETAIL_CONTENT_'+teamIDX).html('');
        } else {
            $('#DETAIL_CONTENT_'+teamIDX).html(loading);
            $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: {'do':'paper_getTeamScoringDetails','act':'print','teamIDX':teamIDX,'inType':inType, 'classIDX':classIDX},
            success: function(str){
                $('#DETAIL_CONTENT_'+teamIDX).html(str);
            }
        });
            
        }

    }
    function paper_updateDaysLate(o, teamIDX) {
        var eventIDX         = $.cookie('LOCATION');
        var ajxData          = {}; 
        ajxData.do           = 'paper_updateDaysLate';
        ajxData.act          = 'print';
        ajxData.eventIDX     = eventIDX;
        ajxData.teamIDX      = teamIDX;
        ajxData.inDays       = $(o).val();
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                // console.log(str);
                // $('#modal_content').html(str);
            }
        });
        }
// 2024 =====================================================================================




function paper_compareScoreForTeam(o, teamIDX, inCardType, userIDX, inNumber, txSchool) {
    var eventIDX         = $.cookie('LOCATION');
    var ajxData          = {}; 
    ajxData.do           = 'paper_compareScoreForTeam';
    ajxData.act          = 'print';
    ajxData.eventIDX     = eventIDX;
    ajxData.teamIDX      = teamIDX;
    ajxData.inCardType   = inCardType;
    ajxData.userIDX      = userIDX;
    // $.modal("Score Calibratrion View", "50%");
    $.modal('<b>Score Calibration View: Team #:' + pad(inNumber,3) + '</b><br>'+txSchool, '40%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function paper_removeDaysLate(o, teamIDX) {
    var ajxData          = {}; 
    ajxData.do           = 'paper_removeDaysLate';
    ajxData.act          = 'print';
    ajxData.teamIDX      = teamIDX;
   $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            $('#TEAM_LATE_'+teamIDX).html(0);
            $(o).close();
        }
    });
    }
function paper_saveDaysLate(o, teamIDX) {
    var eventIDX         = $.cookie('LOCATION');
    var ajxData          = {}; 
    ajxData.do           = 'paper_saveDaysLate';
    ajxData.act          = 'print';
    ajxData.eventIDX     = eventIDX;
    ajxData.teamIDX      = teamIDX;
    ajxData.inDays       = $('#IN_DAYS').val();
   $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            $('#TEAM_LATE_'+teamIDX).html(str);
            $(o).close();
        }
    });
    }

function paper_addOrRemove (o, userIDX, teamIDX, inCardType) {    
    if ($(o).is(':checked')){
        paper_assignTeamToJudge(o, userIDX, teamIDX, inCardType);
    } else {
        var cardIDX = $(o).data('key');
        paper_removeTeamFromJudge(cardIDX);
    }
    }
function paper_removeTeamFromJudge(cardIDX) {
    console.log(cardIDX);
    $('#paper_CARD_'+cardIDX).fadeOut(250);
    var ajxData        = {};
    ajxData.do         = 'paper_removeTeamFromJudge';
    ajxData.act        = 'print';
    ajxData.cardIDX    = cardIDX; 
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){

        }
    });
    }
function paper_assignTeamToJudge(o, userIDX, teamIDX, inCardType) {
    var ajxData        = {};
    ajxData.do         = 'paper_assignTeamToJudge';
    ajxData.act        = 'print';
    ajxData.userIDX    = userIDX; 
    ajxData.teamIDX    = teamIDX; 
    ajxData.inCardType = inCardType; 
    ajxData.eventIDX   = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            var data = JSON.parse(str);
            $(o).data('key', data.PK_CARD_IDX);
            $('#TD_ASSIGNED_TEAM_'+inCardType+'_'+userIDX).prepend(data.CARD);
        }
    });
    }
function paper_openShowAvailableTeams(o, userIDX, inCardType) {
    var eventIDX         = $.cookie('LOCATION');
    var ajxData          = {}; 
    ajxData.do           = 'paper_openShowAvailableTeams';
    ajxData.act          = 'print';
    ajxData.eventIDX     = eventIDX;
    ajxData.userIDX      = userIDX;
    ajxData.inCardType   = inCardType;
    $.modal("Teams", "65%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function paper_sendMail (o, from) {
    var message     = $('#EMAIL_MESSAGE').val(); ;
    
    var ajxData     = {};
    ajxData.do      = 'paper_sendMail';
    ajxData.act     = 'print';
    ajxData.message = message; 
    ajxData.subject = $('#EMAIL_SUBJECT').val(); 
    ajxData.to      = $('#EMAIL_TO').val(); 
    ajxData.from    = from; 
    $(o).close();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
        }
    });
    }
function paper_openSendReminderToAll(o, inCardType) {
    var eventIDX         = $.cookie('LOCATION');
    var loginUserIDX     = $.cookie('PK_USER_IDX');
    var ajxData          = {}; 
    ajxData.do           = 'paper_openSendReminderToAll';
    ajxData.act          = 'print';
    // ajxData.userIDX      = userIDX;
    ajxData.eventIDX     = eventIDX;
    ajxData.loginUserIDX = loginUserIDX;
    ajxData.inCardType   = inCardType;
    // ajxData.inCardType    = inCardType;
    // console.log(JSON.stringify(ajxData));
    $.modal("Reminder", "65%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function paper_openSendReminder(o, userIDX, inCardType) {
    var eventIDX         = $.cookie('LOCATION');
    var loginUserIDX     = $.cookie('PK_USER_IDX');
    var ajxData          = {}; 
    ajxData.do           = 'paper_openSendReminder';
    ajxData.act          = 'print';
    ajxData.userIDX      = userIDX;
    ajxData.eventIDX     = eventIDX;
    ajxData.loginUserIDX = loginUserIDX;
    ajxData.inCardType   = inCardType;
    // ajxData.inCardType    = inCardType;
    // console.log(JSON.stringify(ajxData));
    $.modal("Friendly Reminder", "55%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function paper_removeCardFromJudge(o, cardIDX) {
    // var jsYes = confirm("Click OK to confirm removal of this Judge");
    // if (!jsYes){return}
    $('#paper_CARD_'+cardIDX).fadeOut(250);
    var eventIDX       = $.cookie('LOCATION');
    var ajxData        = {};
    ajxData['do']      = 'paper_deleteUserAssignment';
    ajxData['act']     = 'print';
    ajxData.cardIDX    = cardIDX;
    console.log(JSON.stringify(ajxData));
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            $('#paper_CARD_'+cardIDX).remove();
        }
    });
    }  
function paperOpenTab(o) {
    $('#tabContent').html('<br><br><div class="w3-center w3-padding">Loading...</div>' + loading);
    $('.paperTab').removeClass('w3-red');
    $(o).addClass('w3-red');
    var tab = $(o).data('key');
    $('#'+tab).show();
    var eventIDX = $.cookie('LOCATION');
    var ajxData          = {}; 
    ajxData.do           = 'paper_open'+ tab;
    ajxData.act          = 'print';
    ajxData.eventIDX     = eventIDX;
    ajxData.location     = eventIDX;
    ajxData.adminUserIDX = $.cookie('PK_USER_IDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#tabContent').html(str);
        }
    });
    }
function paper_batchRemoval (o, classIDX, inCardType) {
    // console.log(inCardType);
    var jsYes = confirm("Batch Removal will only remove assigned judges without final scores.\nClick OK to continue");
    if (!jsYes){return}
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_batchRemoval';
    ajxData.act         = 'print';
    ajxData.classIDX    = classIDX;
    ajxData.eventIDX    = eventIDX;
    ajxData.inCardType  = inCardType;
    // if (inCardType>1){
    //     ajxData.inCardType  = inCardType/10;
    // } 
    
    // console.log(ajxData);
    // return
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            openManagePapers();
            // $('#modal_content').html(str);
        }
    });
    }



function paper_confirmDeleteUserAssignment (o, cardIDX, userIDX, teamIDX, inCardType) {
    $.modal('Confirm Removal of this Judge', '45%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: {'do':'paper_confirmDeleteUserAssignment','act':'print','eventIDX':eventIDX,'cardIDX':cardIDX,'userIDX':userIDX,'teamIDX':teamIDX,'inCardType':inCardType},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function paper_deleteUserAssignment (o, cardIDX, userIDX, teamIDX, inCardType) {
    // console.log("delete");
    // var jsYes = confirm("Click OK to confirm removal of this Judge");
    // if (!jsYes){return}
    $(o).close();
    var eventIDX       = $.cookie('LOCATION');
    $('.span_assigned_'+cardIDX).fadeOut(300);
    var ajxData        = {};
    ajxData['do']      = 'paper_deleteUserAssignment';
    ajxData['act']     = 'print';
    ajxData.cardIDX    = cardIDX;
    ajxData.userIDX    = userIDX;
    ajxData.teamIDX    = teamIDX;
    ajxData.inCardType = inCardType;
    ajxData.eventIDX   = eventIDX;
    // console.log(JSON.stringify(ajxData));
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            $('.span_assigned_'+cardIDX).remove();
            $('#div_available_judges').append(str);
        }
    });
    }   
function createList(o, txName, targetTag, userIDX, teamIDX, inCardType) {
    var eventIDX = $.cookie('LOCATION');
    var ajxData = {};
    var data = {};
    data.FK_USER_IDX        = userIDX;
    data.FK_TEAM_IDX        = teamIDX;
    data.FK_CARDTYPE_IDX    = inCardType;
    data.FK_EVENT_IDX       = $.cookie('LOCATION');
    data.IN_SCORE           = 0;
    data.IN_STATUS          = 0;
    ajxData['do']           = 'createList';
    ajxData['act']          = 'print';
    ajxData.txName          = txName;
    ajxData['jsonData']     = JSON.stringify(data);
    console.log(ajxData);
    console.log(targetTag);
    // nameList.push(txName);
    // console.log(nameList);
    $('#span_available_'+userIDX).fadeOut(300);
    $.ajax({
            type: 'POST',
            url: '../cgi-bin/paper.pl',
            data: ajxData,
            success: function(str){
                // addNameTag(str, targetTag);
                $('.'+targetTag).append(str);
                console.log('new index =  ' + str);
                // $('#reasonDiv_List').html(str);
            }
        });
    }
function paper_openAvailableJudges (o, teamIDX, classIDX, inCardType) {
    // resetNameList();
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_openAvailableJudges';
    ajxData.act         = 'print';
    ajxData.teamIDX     = teamIDX;
    ajxData.classIDX    = classIDX;
    ajxData.eventIDX    = eventIDX;
    ajxData.inCardType    = inCardType;
    $.modal("Available Judges", "80%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function paper_openAssignment (o, teamIDX, title) {
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_openAssignment';
    ajxData.act         = 'print';
    ajxData.eventIDX    = eventIDX;
    ajxData.teamIDX     = teamIDX;
    $.modal(title, "75%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    } 