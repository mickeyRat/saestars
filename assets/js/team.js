    var d=document;
    var sid = $.cookie('SID');
    var loading = '<center class="center-screen "><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Generating...</span></center>';


// ------------------------2024------------------------------------------------
function team_UpdateTeamData(o, teamIDX) {
    var eventIDX         = $.cookie('LOCATION');
    var ajxData          = {}; 
    var data             = {};
    ajxData.do           = 'team_UpdateTeamData';
    ajxData.act          = 'print';
    ajxData.eventIDX     = eventIDX;
    ajxData.teamIDX      = teamIDX;
    if ($(o).is('input')){
        data[$(o).data('key')] = $(o).val();
    } else {
        data[$(o).data('key')] = $(o).find('option:selected').val();
    }
    ajxData['jsonData']     = JSON.stringify(data);
    console.log(JSON.stringify(ajxData));
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: ajxData,
        success: function(str){
            console.log(str);
            // $('#modal_content').html(str);
        }
    });
    }
function team_deleteTeam(o, teamIDX){
    var inNumber = $(o).data('value');
    var jsYes = confirm("Click [ OK ] to confirm you want to DELETE team "+inNumber);
    if (!jsYes){return}
    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'team_deleteTeam','act':'print','teamIDX':teamIDX},
        success: function(str){
            $(o).closest('tr').remove();
            // $('#TEAM_'+teamIDX).remove();
            // $(o).close();
        }
    });
    }
function genCode () {
    var minm = 100000; 
    var maxm = 999990; 
    var number = Math.floor(Math.random() * (maxm - minm + 1)) + minm; 
    return(number);
    }
function team_autoSelectClass(o) {
    var value = $(o).val();
    if (value>=300){
        $('#TEAM_CLASS>option:eq(3)').prop('selected',true);
    } else if (value>=200) {
        $('#TEAM_CLASS>option:eq(2)').prop('selected',true);
    } else if (value>0) { 
        $('#TEAM_CLASS>option:eq(1)').prop('selected',true);
    } else {
        $('#TEAM_CLASS>option:eq(0)').prop('selected',true);
    }
    }
function team_addNewTeam(o) {
    var flag = 0;
    var ajxData = {};
    var data = {};
    $('.newInput').each(function(){
        data[$(this).data('key')] = $(this).val();
        $(this).val('')
        // console.log($(this).data('key') + " = " + $(this).val());
    });
    data.TX_CODE      = genCode();
    data.FK_EVENT_IDX = $.cookie('FK_EVENT_IDX');

    ajxData['do']     = 'team_addNewTeam';
    ajxData['act']    = 'print';
    ajxData.eventIDX  = $.cookie('FK_EVENT_IDX');
    ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: ajxData,
        success: function(str){
            var row = $(o).closest('tr');
            $(str).insertAfter(row);
            // setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
        }
    });
    }
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
    // console.log(header);
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
    if ($('#file_'+paperIDX).get(0).files.length === 0) {
        // $('#uploadedDisplay_'+paperIDX).html("Please Choose a file...");
        alert("Please choose a file to upload.");
        return;
    }
    var fd = new FormData();
    var files = $('#file_'+paperIDX)[0].files[0];

    $('#uploadedDisplay_'+paperIDX).html(loading);
    // console.log(isObjEmpty(files));
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

