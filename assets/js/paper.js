{    
    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();
    // var nameList = [];
}
function paper_openJudgeView(o) {
    $('#paperContentContainer').html(loading);
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_openJudgeView';
    ajxData.act         = 'print';
    ajxData.eventIDX    = eventIDX;
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            $('#paperContentContainer').html(str);
        }
    });
}
function paper_openTeamView(obj){
    $('#paperContentContainer').html(loading);
    // $('.tablink').removeClass('w3-border-red');
    // $(obj).children(":first").addClass('w3-border-red');
    // var location = $.cookie('LOCATION');
    // $.ajax({
    //     type: 'POST',
    //     url: '../cgi-bin/paper.pl',
    //     data: {'do':'paper_openTeamView','act':'print','location':location,'eventIDX':location},
    //     success: function(str){
    //         // alert(str);
    //         $('#paperContentContainer').html(str);
    //         // loader.removeClass('show');
    //     }
    // });
    var eventIDX        = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_openTeamView';
    ajxData.act         = 'print';
    ajxData.eventIDX    = eventIDX;
    ajxData.location    = eventIDX;
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            $('#paperContentContainer').html(str);
        }
    });
}
function paper_batchRemoval (o, classIDX, inCardType) {
    var jsYes = confirm("Batch Removal will only remove assigned judges without final scores.\nClick OK to continue");
    if (!jsYes){return}
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_batchRemoval';
    ajxData.act         = 'print';
    ajxData.classIDX    = classIDX;
    ajxData.eventIDX    = eventIDX;
    ajxData.inCardType  = inCardType;
    if (inCardType>1){
        ajxData.inCardType  = inCardType/10;
    } 
    
    console.log(ajxData);
    // return
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            openManagePapers();
            // $('#modal_content').html(str);
        }
    });
}
function paper_batchAssign (o, classIDX, inCardType) {
    var eventIDX = $.cookie('LOCATION');
    var userIDX  = $('#BATCH_' + classIDX + ' :selected').val();
    var ajxData         = {}; 
    ajxData.do          = 'paper_batchAssign';
    ajxData.act         = 'print';
    ajxData.classIDX    = classIDX;
    ajxData.userIDX     = userIDX;
    ajxData.eventIDX    = eventIDX;
    ajxData.inCardType  = inCardType;
    // ajxData.inCardType    = inCardType;
    // $.modal("Auto Assignment", "50%");
    console.log(ajxData);
    // return
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            openManagePapers();
            // $('#modal_content').html(str);
        }
    });
}
function paper_autoAssign (o, classIDX, inCardType) {
    var eventIDX = $.cookie('LOCATION');
    var inLimit  = $('#CLASS_LIMIT_' + classIDX).val();
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
    ajxData.inCardType  = inCardType;
    // ajxData.inCardType    = inCardType;
    // $.modal("Auto Assignment", "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            openManagePapers();
            // $('#modal_content').html(str);
        }
    });
}
function paper_openAutoAssign (o, inCardType) {
    var eventIDX = $.cookie('LOCATION');
    var ajxData         = {}; 
    ajxData.do          = 'paper_openAutoAssign';
    ajxData.act         = 'print';
    ajxData.inCardType     = inCardType;
    // ajxData.classIDX    = classIDX;
    ajxData.eventIDX    = eventIDX;
    // ajxData.inCardType    = inCardType;
    if (inCardType==1) {
        $.modal("Auto Assignment", "50%");
    } else {
        $.modal("Batch Assignment", "50%");
    }
    
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
function paper_deleteUserAssignment (o, cardIDX, userIDX, teamIDX, inCardType) {
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
    console.log(JSON.stringify(ajxData));
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