    var d=document;
    var sid = $.cookie('SID');


function showListOfTeam_Tech(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'showListOfTeam_Tech','act':'print','location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}

function sae_showUpdateInspectionStatus(teamIDX){
    var divName = 'TEMP_DIV_EDIT_NEW_ECR';
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    createNewModalDiv('<b>Tech/Safety Inspections</b>',divName,500);
    // alert("Here");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_showUpdateInspectionStatus','act':'print','userIDX':userIDX,'location':location,'divName':divName,'teamIDX':teamIDX},
        success: function(str){
            // console.log(str);
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_submitInspectionStatus(teamIDX, status, classIDX, divName){
    var location = $.cookie('LOCATION');
    var inPipes = $('#IN_PIPES').val();
    var inWPipes = $('#IN_WPIPES').val();
    var inCargo = $('#REG_IN_LCARGO').val();   
    var inVideo = $('input[name="ADV_IN_VIDEO"]:checked').val();
    if (classIDX == 1){
        // var inCargo = $('#REG_IN_LCARGO').val();
        if ((status == 'Passed' && inCargo === '') || (status=='Passed' && inCargo==0)){
            $('#REG_IN_LCARGO').focus();
            alert("Team cannot pass inspection without Length of Cargo Bay (2020 Aero-Design Rules)");
            return;
        }
    }
    if (classIDX==3){
        // var inPipes = $('#IN_PIPES').val();
        // var inWPipes = $('#IN_WPIPES').val();
        if (status == 'Passed'){
            if (inPipes == 0 || inWPipes==0){
                alert("Team cannot pass inspection without proper pipe # and weight entry (2020 Aero-Design Rules)");
                return
            }
        }
    }
    if (classIDX == 2){
        if (status == 'Passed' && inVideo!=1){
            alert("Team cannot pass Tech Inspection without showing proof of flight via video");
            return;
        } else if (status == 'To Do') {
            inVideo = 0;
        } else {
            if (!inVideo){inVideo = 0};
            // $('input[name="ADV_IN_VIDEO"]').attr('checked',false);
        }
        
    }
    console.log("inVideo="+inVideo)
    // return;
    // console.log("teamIDX="+teamIDX+", status="+status+", divName="+divName+", inPipes="+inPipes+", inWPipes="+inWPipes);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_updateInspectionStatus','act':'print','inPipes':inPipes,'inWPipes':inWPipes,'inVideo':inVideo,'status':status,'inCargo':inCargo,'location':location,'teamIDX':teamIDX,'classIDX':classIDX},
        success: function(str){

            if (status=='Passed'){
                $('#LINK_INSPECTION_'+teamIDX).html('<i class="fa fa-check-square-o"></i> ' + status);
            } else {
                $('#LINK_INSPECTION_'+teamIDX).html(status);
            }
            // console.log(str);
            
            $('#'+divName).remove();
        }
    });
}
function sae_showImportTechSchedule(){
    var divName = 'TEMP_DIV_TEAM_SCHEUDLE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Import Tech Schedule</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_showImportTechSchedule','act':'print','location':location,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_importTechScheduleFile(divName){
    var formData = new FormData();
    var location = $.cookie('LOCATION');
    formData.append('csvFile', $('input[type=file]')[0].files[0]); 
    formData.append('location',location);
    formData.append('do','sae_importTechScheduleFile');
    formData.append('act','print');
    // formData.append('location',location);
    $.post({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: formData,
        contentType: false, // NEEDED, DON'T OMIT THIS (requires jQuery 1.6+)
        processData: false, // NEEDED, DON'T OMIT THIS
        success: function(str){
            // $('#sae_results').html(str);
            $('#'+divName).remove();
            alert("File Imported");
            showListOfTeam_Tech();
        }
    });
}

function sae_openReinspectionDetails(teamIDX, todoIDX){
    var divName = 'TEMP_DIV_REINSPECTION';
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    createNewModalDiv('<b>Reinspection Details</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_openReinspectionDetails','act':'print','location':location,'divName':divName,'teamIDX':teamIDX,'todoIDX':todoIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
    
    
}

function sae_clearReinspectionDetails(teamIDX, todoIDX, divName){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'sae_clearReinspectionDetails','act':'print','location':location,'divName':divName,'teamIDX':teamIDX,'todoIDX':todoIDX},
        success: function(str){
            // $('#x_modal_Content').html(str);
            $('#'+divName).remove();
            // $('#TODO_IDX_'+todoIDX).remove();
            openCrashReinspection();
        }
    });
}
function sae_cancelReinspectionDetailsdivName(divName){
    $('#'+divName).remove();
}





// // ================== 2019==================================
// function showTechInspectionMain(){
//     var location = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'showTechInspectionMain','act':'print','location':location},
//         success: function(str){
//             $('#main').html(str);
//         }
//     });
// }

// function openNewPenaltyCard(PkTeamIdx){
//     var location = $.cookie('LOCATION');
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'openNewPenaltyCard','act':'print','location':location,'PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//             $('[tabindex=1]').focus();
//         }
//     });
// }
// function savePenalty(PkTeamIdx, close, PkGradeIdx){
//     var location = $.cookie('LOCATION');
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var txTitle = encodeURIComponent(escapeVal($('#TX_TITLE').val(),"<br />"));
//     var txDescription = encodeURIComponent(escapeVal($('#TX_DESCRIPTION').val(),"<br />"));
//     var inScore = $('#IN_PENALTY').val();
//     $('#TX_TITLE').val('');
//     $('#TX_DESCRIPTION').val('');
//     $('#IN_PENALTY').val(0);
// //     alert(txTitle+", "+txDescription+", "+inScore+", "+location+", "+PkUserIdx+", "+PkTeamIdx+", "+close);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'savePenalty','act':'print','location':location,'PkTeamIdx':PkTeamIdx,'PkGradeIdx':PkGradeIdx,'PkUserIdx':PkUserIdx,'txTitle':txTitle,'txDescription':txDescription,'inScore':Math.abs(inScore)},
//         success: function(str){
//             if (close > 0) {
//                 $('#PenaltyCard_'+PkGradeIdx).remove();
//                 closeModal('id01');
//             }
//             $('#TD_PENALTY_ROW_FOR_'+PkTeamIdx).append(str);
//             $('[tabindex=1]').focus();
//         }
//     });
// }
// function dropDownPenaltyTemplate(){
//   $('#PenaltyTemplate').toggle('w3-show');
// }
// function loadThisTemplate(obj){
//     $('#TX_TITLE').val($(obj).data('title'));
//     $('#TX_DESCRIPTION').val($(obj).data('text'));
//     $('#IN_PENALTY').val($(obj).data('value'))
//     $('#PenaltyTemplate').toggle('w3-show');
// }
// function saveToTemplate(){
//     var obj = {};
//     obj['TX_TITLE'] = $('#TX_TITLE').val();
//     obj['TX_COMMENT'] = encodeURIComponent( escapeVal( $('#TX_DESCRIPTION').val(), "<br />" ) );
//     obj['IN_SCORE'] = $('#IN_PENALTY').val();
//     var jsonData = JSON.stringify( obj );
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'saveToTemplate','act':'print','jsonData':jsonData},
//         success: function(str){
//             $('#PenaltyTemplate').prepend(str);
//             alert("Successfully saved "+$('#TX_TITLE').val()+" to the template");
//         }
//     });
// }
// function deleteThisTemplate(obj, penIdx){
//     var jsYes = confirm("Click OK to remove this template from the list.");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'deleteThisTemplate','act':'print','penIdx':penIdx},
//         success: function(str){
//             $('#PENALTY_IDX_'+penIdx).remove();
//             $('#PenaltyTemplate').toggle('w3-show');
//         }
//     });

// }
// function updatePenalty(PkTeamIdx, PkGradeIdx){
//     var location = $.cookie('LOCATION');
// //     alert(PkTeamIdx+', '+PkGradeIdx);
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'updatePenalty','act':'print','location':location,'PkTeamIdx':PkTeamIdx,'PkGradeIdx':PkGradeIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//             $('[tabindex=1]').focus();
//         }
//     });
// }
// function deletePenalty(PkTeamIdx, PkGradeIdx){
//     var jsYes = confirm("Click OK to confirm you want to delete this penalty.");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'deletePenalty','act':'print','PkGradeIdx':PkGradeIdx,'PkTeamIdx':PkTeamIdx},
//         success: function(str){
//              $('#PenaltyCard_'+PkGradeIdx).remove();
//              closeModal('id01');
//         }
//     });
// }
// function updateTechStatus(classIDX, PkTeamIdx, txType){
//     var inValue = $('#INPUT_'+PkTeamIdx+'_'+classIDX);
//     var checkbox = $('#PASS_'+PkTeamIdx+'_'+classIDX);
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var boStatus = 0;
//     if (checkbox.is(':checked')){boStatus = 1};
// //     alert(boStatus);
// //     return;
//     var PkGradeIdx = checkbox.data('key');
// //     alert(PkGradeIdx);
//     // alert(inValue.val() + ', ' + classIDX + ', ' + PkGradeIdx);
//     // return;
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/tech.pl',
//         data: {'do':'updateTechStatus','act':'print','inValue':inValue.val(), 'boStatus':boStatus,'classIDX':classIDX, 'PkGradeIdx':PkGradeIdx,'PkTeamIdx':PkTeamIdx,'PkUserIdx':PkUserIdx,'txType':txType},
//         success: function(str){
//             checkbox.data('key',str);
//              alert('Saved');
//         }
//     });
// }

