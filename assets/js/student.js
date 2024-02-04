
    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();

// ========== 2024 ==================================
function student_linkTeam(o) {
    var ajxData = {};
    var data = {};
    data.FK_USER_IDX  = $.cookie('PK_USER_IDX');
    ajxData['do']     = 'student_linkTeam';
    ajxData['act']    = 'print';
    ajxData.inCode    =$('#TEAM_LINK_NUMBER').val();
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/student.pl',
        data: ajxData,
        success: function(str){
            if (str == 0){
                alert("Cannot Link with an Invalid Team Code");
            } else {
                sae_loadHomePage();
            }
        }
    });
}
function student_LinkPage(o) {
        $('#link_content').toggleClass("w3-hide");
    }
function student_unlinkTeam(o, teamIDX) {
    var jsYes = confirm("Click [ OK ] to confirm you want to UN-LINK this team from your homepage");
    if (!jsYes){return}
    var userIDX = $.cookie('PK_USER_IDX');
    $(o).parent('div').parent('div').parent('div').remove();
    $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_unlinkTeam','act':'print','teamIDX':teamIDX,'userIDX':userIDX},
            success: function(str){
                $('#modal_content').html(str);
            }
        });
}
// ========== 2022 ==================================
    function student_openRequirementsChecks (o, teamIDX, classIDX) {
        var eventIDX = $.cookie('LOCATION');
        var userIDX = $.cookie('PK_USER_IDX');
        $.modal('Requirement Checks', '97%');
        // $('#modal_content').html(teamIDX); 
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_openRequirementsChecks','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'userIDX':userIDX,'classIDX':classIDX},
            success: function(str){
                $('#modal_content').html(str);
            }
        });
        }
    function student_openSafetyChecks (o, teamIDX, classIDX) {
        var eventIDX = $.cookie('LOCATION');
        var userIDX = $.cookie('PK_USER_IDX');
        $.modal('Safety & Airworthiness Checks', '97%');
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_openSafetyChecks','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'userIDX':userIDX,'classIDX':classIDX},
            success: function(str){
                $('#modal_content').html(str);
            }
        });

        }
    function student_updateCheckItem (o, teamIDX) {
        var userIDX = $.cookie('PK_USER_IDX');
        var inStatus = 0;
        if ($(o).is(':checked')){
            inStatus= 1;
            $(o).closest('label').removeClass('w3-border-red').addClass('w3-border-green');
        }  else {
            $(o).closest('label').removeClass('w3-border-green').addClass('w3-border-red');
        }
        var itemIDX = $(o).data('index');
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_updateCheckItem','act':'print','teamIDX':teamIDX,'userIDX':userIDX,'itemIDX':itemIDX,'inStatus':inStatus},
            success: function(str){

            }
        });
        }
