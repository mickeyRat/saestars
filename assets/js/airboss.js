var d=document;
var now = new Date();
var time = now.getTime();
var eventIDX = $.cookie('LOCATION');
// var loading = '<i class="fa fa-refresh fa-spin fa-3x fa-fw"></i><span class="sr-only">Loading...</span>';

function sae_openTeamNotesList(){
    var eventIDX = $.cookie('LOCATION');
    $('#mainPageContent').html('<center><br><br><br><br>'+loading+'</center>');
    // var userIDX = $.cookie('userIDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/airboss.pl',
        data: {'do':'sae_openTeamNotesList','act':'print','eventIDX':eventIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });    
}

function sae_viewFlightNotes(teamIDX){
    $.modal('Flight Notes','90%','w3-pale-yellow');
    
    $('#modal_content').html(loading);
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/airboss.pl',
        data: {'do':'sae_viewFlightNotes','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });    
}
function sae_showAddFlightNotes(o){
    $(o).hide(100);
    $('#divAddNotes').show(100);
}
function sae_cancelShowAddNotes(){
    $('#btn_addNotes').show();
    $('#divAddNotes').hide(100);
    $('#txt_FlightNotes').val('');
}
function sae_saveFlightLineNotes(teamIDX){
    if ($('#txt_FlightNotes').val() === '') {
        alert("Notes not saved.");
        return;
    }
    var txNotes = encodeURIComponent(escapeVal($('#txt_FlightNotes').val(),"<br />"));
    if (!$('#AB_'+teamIDX).hasClass('w3-yellow')){
        $('#AB_'+teamIDX).removeClass("w3-white");
         $('#AB_'+teamIDX).addClass("w3-yellow");
         $('#ABC_'+teamIDX).show(100);
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/airboss.pl',
        data: {'do':'sae_saveFlightLineNotes','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'txNotes':txNotes},
        success: function(str){
            $('#DIV_NOTES_LIST').prepend(str);
            sae_cancelShowAddNotes();
        }
    }); 
}

// function sae_openECR(){
//     var location = $.cookie('LOCATION');
//     var userIDX = $.cookie('userIDX');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_openECR','act':'print','location':location,'userIDX':userIDX},
//         success: function(str){
//             $('#mainPageContent').html(str);
//         }
//     });
// }
// function sae_openStudentExitingECR(ecrIDX, teamIDX, inStatus){
//     $.modal('Engineering Change Request','75%');
//     var location = $.cookie('LOCATION');
//     var userIDX = $.cookie('userIDX');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_openExitingECR','act':'print','location':location, 'userType':0, 'userIDX':userIDX, 'teamIDX':teamIDX, 'ecrIDX':ecrIDX,'inStatus':inStatus},
//         success: function(str){
//             $('#modal_content').html(str);
//         }
//     });
// }
// function sae_StudentSubmitECR(o, teamIDX, userType){
//     var location = $.cookie('LOCATION');
//     var userIDX = $.cookie('userIDX');
    
//     var obj = {};
//     obj.FK_TEAM_IDX     = teamIDX;
//     obj.TX_ECR          = $('#TX_ECR').val();
//     obj.CL_DESCRIPTION  = $('#CL_DESCRIPTION').val();
//     obj.IN_STATUS       = 0;
//     var jsonData = JSON.stringify( obj );
//     // console.log(userType);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_ApplyDeductions','act':'print', 'userIDX':userIDX, 'location':location,'teamIDX':teamIDX, 'userType':userType, 'jsonData':jsonData},
//         success: function(str){
//             // $('#modal_content').html(str);
            
//             $('.TD_ECR_LIST_'+teamIDX).each(function(){
//                 $(this).append(str);
//                 console.log(str);
//             });
//             $(o).close();
//         }
//     });
// }
// function sae_UpdateStudentECR(o, ecrIDX){
//     var location = $.cookie('LOCATION');
//     var userIDX = $.cookie('userIDX');
//     var obj = {};
//     obj.TX_ECR          = $('#TX_ECR').val();
//     obj.CL_DESCRIPTION  = $('#CL_DESCRIPTION').val();
//     obj.IN_STATUS       = 0;
//     var jsonData = JSON.stringify( obj );
//     // console.log(jsonData);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_UpdateDeductions','act':'print', 'userIDX':userIDX, 'location':location, 'jsonData':jsonData,'ecrIDX':ecrIDX},
//         success: function(str){
//             $(o).close();
//         }
//     });
// }
// function sae_updateDeduction(o, c){
//     // var inValue = $(o).val();
//     // console.log(c);
//     var totalDeduction = 0;
//     var itemDeduction = parseFloat($(o).val());
//     $('.'+c).val(itemDeduction.toFixed(1));
//     $('.sae-deductions').each(function(i){
//         totalDeduction +=  parseFloat($(this).val());
//     });
//     $('#TECH_TOTAL').val(totalDeduction.toFixed(1));
// }
// function sae_updateLengthDeduction(o, c, ar){
//     var totalDeduction = 0;
//     var addd = 0;
//     var remove = 0;
//     var total = 0;
//     if (c == 'sae-span'){
//         add    = $('#SPAN_ADD').val()*2;
//         remove = $('#SPAN_REMOVE').val();
//         total = (parseFloat(add) + parseFloat(Math.abs(remove)));
//     } else {
//         add    = $('#CHORD_ADD').val()*10;
//         remove = $('#CHORD_REMOVE').val()*5;
//         total = (parseFloat(add) + parseFloat(Math.abs(remove)));
//     }
//     $('.'+c).val(total.toFixed(1));
//     $('.sae-deductions').each(function(i){
//         totalDeduction +=  parseFloat($(this).val());
//     });
//     $('#TECH_TOTAL').val(totalDeduction.toFixed(1));

// }
// function sae_openECREntryForm(userType, teamIDX){
//     $.modal('Engineering Change Request','75%');
//     var location = $.cookie('LOCATION');
//     // console.log ("teamIDX = "+teamIDX);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_openECREntryForm','act':'print','userType':userType,'location':location,'teamIDX':teamIDX},
//         success: function(str){
//             $('#modal_content').html(str);
            
//         }
//     });
// }
// function sae_RemoveDeductions(o, ecrIDX){
//     var jsYes = confirm("Are you sure?");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_RemoveDeductions','act':'print','ecrIDX':ecrIDX},
//         success: function(str){
//             $('.BTN_ECR_'+ecrIDX).remove();
//             $(o).close();
//         }
//     });
    
// }
// function sae_UpdateDeductions(o,ecrIDX, teamIDX, userType){
//     var location = $.cookie('LOCATION');
//     var obj = {};
//     obj.IN_STRUCTURE    = $('.sae-type-1').val();
//     obj.IN_MECHANICAL   = $('.sae-type-2').val();
//     obj.IN_ELECTRONIC   = $('.sae-type-3').val();
//     obj.IN_MISC         = $('.sae-type-4').val();
//     obj.IN_SPAN_ADD     = $('#SPAN_ADD').val();
//     obj.IN_SPAN_REMOVE  = $('#SPAN_REMOVE').val();
//     obj.IN_CHORD_ADD    = $('#CHORD_ADD').val();
//     obj.IN_CHORD_REMOVE = $('#CHORD_REMOVE').val();
//     obj.IN_DEDUCTION    = $('#TECH_TOTAL').val();
//     obj.IN_SPAN         = $('#IN_SPAN').val();
//     obj.IN_CHORD        = $('#IN_CHORD').val();
//     obj.FK_TEAM_IDX     = teamIDX;
//     obj.TX_ECR          = $('#TX_ECR').val();
//     obj.CL_DESCRIPTION  = $('#CL_DESCRIPTION').val();
//     obj.IN_STATUS       = 1;
//     var jsonData = JSON.stringify( obj );
//     // console.log(jsonData);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_UpdateDeductions','act':'print','userType':userType, 'ecrIDX':ecrIDX, 'location':location,'teamIDX':teamIDX, 'jsonData':jsonData},
//         success: function(str){
//             // $('#modal_content').html(str);
//             $('.BTN_ECR_'+ecrIDX).each(function(){
//                 $(this).replaceWith(str);
//                 // console.log(str);
//             });
//             // $('#BTN_ECR_'+ecrIDX).replaceWith(str);
//             $(o).close();
//         }
//     });
// }
// function sae_ApplyDeductions(o, teamIDX, userType){
//     var location = $.cookie('LOCATION');
//     var userIDX = $.cookie('userIDX');
//     var obj = {};
//     obj.IN_STRUCTURE    = $('.sae-type-1').val();
//     obj.IN_MECHANICAL   = $('.sae-type-2').val();
//     obj.IN_ELECTRONIC   = $('.sae-type-3').val();
//     obj.IN_MISC         = $('.sae-type-4').val();
//     obj.IN_SPAN_ADD     = $('#SPAN_ADD').val();
//     obj.IN_SPAN_REMOVE  = $('#SPAN_REMOVE').val();
//     obj.IN_CHORD_ADD    = $('#CHORD_ADD').val();
//     obj.IN_CHORD_REMOVE = $('#CHORD_REMOVE').val();
//     obj.IN_DEDUCTION    = $('#TECH_TOTAL').val();
//     obj.IN_SPAN         = $('#IN_SPAN').val();
//     obj.IN_CHORD        = $('#IN_CHORD').val();
//     obj.FK_TEAM_IDX     = teamIDX;
//     obj.TX_ECR          = $('#TX_ECR').val();
//     obj.CL_DESCRIPTION  = $('#CL_DESCRIPTION').val();
//     obj.IN_STATUS       = 1;
//     var jsonData = JSON.stringify( obj );
//     // console.log(jsonData);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_ApplyDeductions','act':'print', 'userType':userType, 'userIDX':userIDX, 'location':location,'teamIDX':teamIDX, 'jsonData':jsonData},
//         success: function(str){
//             // $('#modal_content').html(str);
//             $('.TD_ECR_LIST_'+teamIDX).each(function(){
//                 $(this).append(str);
//                 console.log(str);
//             });
//             // $('.TD_ECR_LIST_'+teamIDX).append(str);
//             $(o).close();
//         }
//     });
// }
// function sae_openExitingECR(ecrIDX, teamIDX, userType){
//     $.modal('Engineering Change Request','75%');
//     var location = $.cookie('LOCATION');
//     var userIDX = $.cookie('userIDX');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_openExitingECR','act':'print','location':location, 'userIDX':userIDX, 'teamIDX':teamIDX, 'ecrIDX':ecrIDX,'userType':userType},
//         success: function(str){
//             $('#modal_content').html(str);
//         }
//     });
// }
// // function sae_submitECR(divName, judge){
// //     var obj = {};
// //     var discover = new Array();
// //     var system = new Array();
// //     var location = $.cookie('LOCATION');
// //     var teamIDX = $('#selectTeamIDX option:selected').val();
// //     var teamName = $('#selectTeamIDX option:selected').text();
// //     obj['FK_TEAM_IDX'] = teamIDX;
// //     $('.sae-check-method').each(function(i){ 
// //         if ($(this).is(":checked")){ discover.push($(this).val())}
// //     });
// //     obj['TX_METHOD'] = discover.join(",");
// //     $('.sae-check-system').each(function(i){ 
// //         if ($(this).is(":checked")){ system.push($(this).val())}
// //     });
// //     obj['TX_SYSTEM'] = system.join(",");
// //     $('.sae-input').each(function(i){
// //         if ($(this).data('key') =='CL_DESCRIPTION' || $(this).data('key') == 'CL_REASON'){
// //             obj[$(this).data('key')]= encodeURIComponent(escapeVal($(this).val(),"<br />"));
// //         } else {
// //             obj[$(this).data('key')]=$(this).val();
// //         }
// //         // encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
        
// //     });
// //     if (judge==1) {
// //         obj['IN_STATUS']=1;
// //     }
// //     var jsonData = JSON.stringify( obj );
// //     // console.log (jsonData);
// //     // return;
// //     $.ajax({
// //         type: 'POST',
// //         url: '../cgi-bin/ecr.pl',
// //         data: {'do':'sae_submitECR','act':'print','teamIDX':teamIDX,'location':location,'teamName':teamName, 'jsonData':jsonData},
// //         success: function(str){
// //             // console.log(str);
// //             $('#'+divName).remove();
// //             if (judge==1){
// //                 showListOfTeam_Tech();
// //             } else {
// //                 $('#TABLE_ECR_LIST').append(str);
// //             }
            
// //         }
// //     });
// // }
// function sae_editEcr(ecrIDX, judge){
//     var divName = 'TEMP_DIV_EDIT_NEW_ECR';
//     var location = $.cookie('LOCATION');
//     var ecrNumber = "00000"+ecrIDX.toString();
//     var lastFive = ecrNumber.slice(-4);
//     var userIDX = $.cookie('userIDX');
//     createNewModalDiv('<b>Engineering Change Request (ECR) : E-'+lastFive+'</b>',divName,850);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_editEcr','act':'print','userIDX':userIDX,'ecrIDX':ecrIDX,'location':location,'divName':divName,'judge':judge},
//         success: function(str){
//             $('#x_modal_Content').html(str);
//         }
//     });
// }
// function sae_deleteERC(ecrIDX, divName){
//     var jsYes = confirm("Are you sure?");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_deleteERC','act':'print','ecrIDX':ecrIDX},
//         success: function(str){
//             $('#TR_ECR_'+ecrIDX).remove();
//             $('#'+divName).remove();
//         }
//     });
// }
// function sae_submitECR_Update(ecrIDX, divName, judge){
//     var obj = {};
//     var discover = new Array();
//     var system = new Array();
//     var location = $.cookie('LOCATION');
//     var teamIDX = $('#selectTeamIDX option:selected').val();
//     var teamName = $('#selectTeamIDX option:selected').text();
//     obj['FK_TEAM_IDX'] = teamIDX;
//     $('.sae-check-method').each(function(i){ 
//         if ($(this).is(":checked")){ discover.push($(this).val())}
//     });
//     obj['TX_METHOD'] = discover.join(",");
//     $('.sae-check-system').each(function(i){ 
//         if ($(this).is(":checked")){ system.push($(this).val())}
//     });
//     obj['TX_SYSTEM'] = system.join(",");
//     $('.sae-input').each(function(i){
//         if ($(this).data('key') =='CL_DESCRIPTION' || $(this).data('key') == 'CL_REASON'){
//             obj[$(this).data('key')]= encodeURIComponent(escapeVal($(this).val(),"<br />"));
//         } else {
//             obj[$(this).data('key')]=$(this).val();
//         }
//         // encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
        
//     });
//     var jsonData = JSON.stringify( obj );
//     // console.log (jsonData);
//     // return;
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_submitECR_Update','act':'print','teamIDX':teamIDX,'location':location,'teamName':teamName,'ecrIDX':ecrIDX, 'jsonData':jsonData},
//         success: function(str){
//             // console.log(str);
//             $('#'+divName).remove();
//             if (judge ===0){
//                 sae_openECR();
//             } else {
//                 showListOfTeam_Tech();
//             }
            
//             // $('#TABLE_ECR_LIST').append(str);
//         }
//     });
// }
// function sae_submitECR_Apply(ecrIDX, divName, judge){
//     var obj = {};
//     var location = $.cookie('LOCATION');
//     var inDeduction = $('#IN_DEDUCTION').val();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/ecr.pl',
//         data: {'do':'sae_submitECR_Apply','act':'print','inDeduction':inDeduction, 'location':location,'ecrIDX':ecrIDX},
//         success: function(str){
//             $('#'+divName).remove();
//             showListOfTeam_Tech();
//         }
//     });
// }