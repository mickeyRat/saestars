    var d=document;
    var sid = $.cookie('SID');
    var loading = '<center class="center-screen "><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Generating...</span></center>';


// ------------------------2022------------------------------------------------

function sae_openImportTeam(){
    $.modal("Import Team", "50%");
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'sae_openImportTeam','act':'print','eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    $('#divImport').removeClass('w3-hide');
}
function sae_uploadTeamList(o){
    $('#uploadedDisplay').html(loading); 
    var eventIDX = $('#EVENT_IDX :selected').val();
    // var header = 0;
    // if ($('#HEADER').is(":checked")){
    //     header = 1;
    // } 
    console.log(header);
    var fd = new FormData();
    var files = $('#file')[0].files[0];
    fd.append('filename', files);
    fd.append('eventIDX', eventIDX);
    // fd.append('header', header);
    // return;
    $.ajax({
        url: '../cgi-bin/upload_team.pl',
        type: 'post',
        data: fd,
        contentType: false,
        processData: false,
        success: function(str){
            
            // console.log(str);
            $('#uploadedDisplay').html(str); 
        },
    }).done(function(){
        // showListOfTeam_Preso('number');
        $(o).close();
        openManageteam();
    });
}
// ------------------------2021------------------------------------------------
function sae_openTeamProfile(teamIDX){
    var location = $.cookie('LOCATION');
    // console.log('teamIDX = ' + teamIDX);
    $.modal("Team Information", "90%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'sae_openTeamProfile','act':'print','location':location,'teamIDX':teamIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
function sae_changeInputType(o, fieldName){
    if (o.checked) {
        $('#'+fieldName).attr('type','text');
    } else {
        $('#'+fieldName).attr('type','password');
    }
}
function sae_saveTeamProfile(o, teamIDX){
    var obj = {};
    var location = $.cookie('LOCATION');
    $('.sae_data').each(function(){
        obj[$(this).data('key')] = $(this).val();
    });
    var txCountry = $('#TX_COUNTRY option:selected').val();
    var classIDX = $('#FK_CLASS_IDX option:selected').val();
    obj['TX_COUNTRY'] = txCountry;
    obj['FK_CLASS_IDX'] = classIDX;
    var jsonData = JSON.stringify( obj );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'sae_saveTeamProfile','act':'print','location':location,'teamIDX':teamIDX,'jsonData':jsonData},
        success: function(str){
            $(o).close();
            alert(str);
            
        }
    });
}
function sae_deleteTeam(o, teamIDX){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'sae_deleteTeam','act':'print','teamIDX':teamIDX},
        success: function(str){
            $('#TEAM_'+teamIDX).remove();
            $(o).close();
        }
    });
}
function sae_openAddTeam(eventIDX){
    $.modal("Add Team", "90%");
    $('#modal_content').html(loading);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'sae_openAddTeam','act':'print','eventIDX':eventIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });
}
function sae_autoSelectClass(o){
    var inNumber = $(o).val();
    if (inNumber >=300) {
        $('#FK_CLASS_IDX option')[3].selected = true;
    } else if (inNumber >=200) {
        $('#FK_CLASS_IDX option')[2].selected = true;
    } else if (inNumber > 0) {
        $('#FK_CLASS_IDX option')[1].selected = true;
    } else {
        $('#FK_CLASS_IDX option')[0].selected = true;
    }
}
function sae_addNewTeam(o, eventIDX){
    var obj = {};
    var location = $.cookie('LOCATION');
    $('.sae_data').each(function(){
        obj[$(this).data('key')] = $(this).val();
    });
    var txCountry = $('#TX_COUNTRY option:selected').text();
    var countryIDX = $('#TX_COUNTRY option:selected').val();
    var classIDX = $('#FK_CLASS_IDX option:selected').val();
    obj['TX_COUNTRY']     = txCountry;
    obj['FK_COUNTRY_IDX'] = countryIDX;
    obj['FK_CLASS_IDX']   = classIDX;
    obj['FK_EVENT_IDX']   = eventIDX;
    var jsonData = JSON.stringify( obj );
    // console.log(jsonData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'sae_addNewTeam','act':'print','jsonData':jsonData},
        success: function(str){
            $(o).close();
            $('#UL_TEAM_LIST').prepend(str);
            // console.log(str);
            
        }
    });
}
function sae_upload(teamIDX, inNumber, eventIDX, paperIDX){
    $('#uploadedDisplay_'+paperIDX).html(loading);
    
    var fd = new FormData();
    var files = $('#file')[0].files[0];
    fd.append('filename', files);
    fd.append('eventIDX', eventIDX);
    fd.append('teamIDX', teamIDX);
    fd.append('inNumber', inNumber);
    fd.append('paperIDX', paperIDX);
    console.log(fd);
    $.ajax({
        url: '../cgi-bin/upload.pl',
        type: 'post',
        data: fd,
        contentType: false,
        processData: false,
        success: function(str){
            // console.log(str);
            $('#uploadedDisplay_'+paperIDX).html(str);
        },
    });
}
// ------------------------2021------------------------------------------------
// function showTeamList(){
//     var location = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'showTeamList','act':'print','location':location},
//         success: function(str){
//             $('#main').html(str);
//             $('#pageTitle').html('STARS - Team Account Administration');
//             $('#backButton').off('click').on('click', function(){
//                 window.location.href="admin.html";
//             }).show();
//         }
//     });
// }
// function showResetAccessCode(PkTeamIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'showResetAccessCode','act':'print','PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//         }
//     });
// }
// function generateRandomTeamCode(){
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'generateRandomTeamCode','act':'print'},
//         success: function(str){
// //         alert(str)
//             $('#TX_TEAM_CODE').val(str);
//         }
//     });
// }
// function resetAccessCode(PkTeamIdx){
//     var TxCode = $('#TX_TEAM_CODE').val();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'resetAccessCode','act':'print','PkTeamIdx':PkTeamIdx,'TxCode':TxCode},
//         success: function(str){
//             deleteDiv('DIV_EDIT_TEAM_CODE');
//             alert("Team Access Code successfully updated.");
//         }
//     });
// }
// function showEditTeamInformation(PkTeamIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'showEditTeamInformation','act':'print','PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//         }
//     });
// }
// function saveTeamInfo(PkTeamIdx){
//     var InNumber = $('#IN_NUMBER').val();
//     var TxName = $('#TX_NAME').val();
//     var TxSchool = $('#TX_SCHOOL').val();
//     var InCapacity = $('#IN_CAPACITY').val();
//     var InTubeLength = $('#IN_TUBE_LENGTH').val();
//     var FkClassIdx = $('#FK_CLASS_IDX option:selected').val();
// //     alert('IMG_WARNING_'+PkTeamIdx+": "+InNumber+", "+TxName+", "+TxSchool+", "+FkClassIdx+", "+InCapacity+", "+InTubeLength);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'saveTeamInfo','act':'print','PkTeamIdx':PkTeamIdx,'FkClassIdx':FkClassIdx ,'InTubeLength':InTubeLength ,'InCapacity':InCapacity ,'TxSchool':TxSchool ,'TxName':TxName ,'InNumber':InNumber},
//         success: function(str){
//             var obj = JSON.parse(str);
// //             if (FkClassIdx == 1 && InCapacity != 0){
// //                 $('#IMG_WARNING_'+PkTeamIdx).hide();
// //             } else if (FkClassIdx == 1 && InCapacity == 0) {
// //                 $('#IMG_WARNING_'+PkTeamIdx).show();
// //             }
// //             if (FkClassIdx == 3 && InTubeLength != 0){
// //                 $('#IMG_WARNING_'+PkTeamIdx).hide();
// //             } else if (FkClassIdx == 3 && InTubeLength == 0){
// //                 $('#IMG_WARNING_'+PkTeamIdx).show();
// //             }
//             closeModal('id01');
//             $('#SPAN_NUMBER_SCHOOL_'+PkTeamIdx).html(obj.IN_NUMBER + " - " + obj.TX_SCHOOL);
//             $('#SPAN_NAME_'+PkTeamIdx).html(obj.TX_NAME);
// //             $('#TD_TX_CLASS_'+PkTeamIdx).html(obj.TX_CLASS);
// //             $('#TD_IN_NUMBER_'+PkTeamIdx).html(obj.IN_NUMBER);
//         }
//     });
// }
// function deleteTeam(PkTeamIdx){
//     var jsYes = confirm("Are you sure? " + PkTeamIdx);
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'deleteTeam','act':'print','PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#LIST_TEAM_'+PkTeamIdx).remove();
//         }
//     });
// }

// function showAddTeam(){
//     var location = $.cookie('LOCATION');
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'showAddTeam','act':'print','location':location},
//         success: function(str){
//             $('#id01_content').html(str);
//         }
//     });
// }
// function addTeam(){
//     var location = $.cookie('LOCATION');
//     var InNumber = $('#IN_NUMBER').val();
//     var TxSchool = $('#TX_SCHOOL').val();
//     var TxName = $('#TX_NAME').val();
//     var PkCountryIdx = $('#FK_COUNTRY_IDX option:selected').val();
//     var PkClassIdx = $('#FK_CLASS_IDX option:selected').val();
//     if (InNumber=='' || TxSchool == '' || TxName == '' || PkCountryIdx==0 || PkClassIdx==0) {
//         alert("ERROR\n\nMissing Required Data");
//         return;
//     }
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'addTeam','act':'print','location':location, 'PkClassIdx':PkClassIdx , 'PkCountryIdx':PkCountryIdx , 'TxName':TxName , 'TxSchool':TxSchool , 'InNumber':InNumber },
//         success: function(str){
//             $('#TeamList').prepend(str);
//             $('#id01_content').html('');
//             closeModal('id01');
//         }
//     });
// }

// function generateAllNewCode(){
//     var jsYes = confirm("** WARNING **\n\nThis action will generate ALL NEW TEAM CODES for the teams listed.\n\nClick OK to continue.");
//     if (!jsYes){return}
//     var location = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/team.pl',
//         data: {'do':'generateAllNewCode','act':'print','location':location },
//         success: function(str){
//             alert(str);
//         }
//     });
// }
