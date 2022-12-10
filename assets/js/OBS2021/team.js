    var d=document;
    var sid = $.cookie('SID');

function showTeamList(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'showTeamList','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
            $('#pageTitle').html('STARS - Team Account Administration');
            $('#backButton').off('click').on('click', function(){
                window.location.href="admin.html";
            }).show();
        }
    });
}
function showResetAccessCode(PkTeamIdx){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'showResetAccessCode','act':'print','PkTeamIdx':PkTeamIdx},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function generateRandomTeamCode(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'generateRandomTeamCode','act':'print'},
        success: function(str){
//         alert(str)
            $('#TX_TEAM_CODE').val(str);
        }
    });
}
function resetAccessCode(PkTeamIdx){
    var TxCode = $('#TX_TEAM_CODE').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'resetAccessCode','act':'print','PkTeamIdx':PkTeamIdx,'TxCode':TxCode},
        success: function(str){
            deleteDiv('DIV_EDIT_TEAM_CODE');
            alert("Team Access Code successfully updated.");
        }
    });
}
function showEditTeamInformation(PkTeamIdx){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'showEditTeamInformation','act':'print','PkTeamIdx':PkTeamIdx},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function saveTeamInfo(PkTeamIdx){
    var InNumber = $('#IN_NUMBER').val();
    var TxName = $('#TX_NAME').val();
    var TxSchool = $('#TX_SCHOOL').val();
    var InCapacity = $('#IN_CAPACITY').val();
    var InTubeLength = $('#IN_TUBE_LENGTH').val();
    var FkClassIdx = $('#FK_CLASS_IDX option:selected').val();
//     alert('IMG_WARNING_'+PkTeamIdx+": "+InNumber+", "+TxName+", "+TxSchool+", "+FkClassIdx+", "+InCapacity+", "+InTubeLength);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'saveTeamInfo','act':'print','PkTeamIdx':PkTeamIdx,'FkClassIdx':FkClassIdx ,'InTubeLength':InTubeLength ,'InCapacity':InCapacity ,'TxSchool':TxSchool ,'TxName':TxName ,'InNumber':InNumber},
        success: function(str){
            var obj = JSON.parse(str);
//             if (FkClassIdx == 1 && InCapacity != 0){
//                 $('#IMG_WARNING_'+PkTeamIdx).hide();
//             } else if (FkClassIdx == 1 && InCapacity == 0) {
//                 $('#IMG_WARNING_'+PkTeamIdx).show();
//             }
//             if (FkClassIdx == 3 && InTubeLength != 0){
//                 $('#IMG_WARNING_'+PkTeamIdx).hide();
//             } else if (FkClassIdx == 3 && InTubeLength == 0){
//                 $('#IMG_WARNING_'+PkTeamIdx).show();
//             }
            closeModal('id01');
            $('#SPAN_NUMBER_SCHOOL_'+PkTeamIdx).html(obj.IN_NUMBER + " - " + obj.TX_SCHOOL);
            $('#SPAN_NAME_'+PkTeamIdx).html(obj.TX_NAME);
//             $('#TD_TX_CLASS_'+PkTeamIdx).html(obj.TX_CLASS);
//             $('#TD_IN_NUMBER_'+PkTeamIdx).html(obj.IN_NUMBER);
        }
    });
}
function deleteTeam(PkTeamIdx){
    var jsYes = confirm("Are you sure? " + PkTeamIdx);
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'deleteTeam','act':'print','PkTeamIdx':PkTeamIdx},
        success: function(str){
            $('#LIST_TEAM_'+PkTeamIdx).remove();
        }
    });
}

function showAddTeam(){
    var location = $.cookie('LOCATION');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'showAddTeam','act':'print','location':location},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function addTeam(){
    var location = $.cookie('LOCATION');
    var InNumber = $('#IN_NUMBER').val();
    var TxSchool = $('#TX_SCHOOL').val();
    var TxName = $('#TX_NAME').val();
    var PkCountryIdx = $('#FK_COUNTRY_IDX option:selected').val();
    var PkClassIdx = $('#FK_CLASS_IDX option:selected').val();
    if (InNumber=='' || TxSchool == '' || TxName == '' || PkCountryIdx==0 || PkClassIdx==0) {
        alert("ERROR\n\nMissing Required Data");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'addTeam','act':'print','location':location, 'PkClassIdx':PkClassIdx , 'PkCountryIdx':PkCountryIdx , 'TxName':TxName , 'TxSchool':TxSchool , 'InNumber':InNumber },
        success: function(str){
            $('#TeamList').prepend(str);
            $('#id01_content').html('');
            closeModal('id01');
        }
    });
}

function generateAllNewCode(){
    var jsYes = confirm("** WARNING **\n\nThis action will generate ALL NEW TEAM CODES for the teams listed.\n\nClick OK to continue.");
    if (!jsYes){return}
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'generateAllNewCode','act':'print','location':location },
        success: function(str){
            alert(str);
        }
    });
}
