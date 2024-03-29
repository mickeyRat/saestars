    var d=document;
    var sid = $.cookie('SID');

// ================ 2021 ==================================
function sae_validatePreso(){
    // console.log("loation = " + location);
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('PK_USER_IDX');
    $('#mainPageContent').html("<br><br><br><br><br><br>Loading...");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_validatePreso','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}

function sae_updateValidatedInput(paperIDX, obj){
    var inValue = $(obj).val(); 
    if (inValue>10 || inValue<=0){
        $(obj).focus();
        $(obj).val($(obj).data('key'));
        alert("Input ["+inValue+"] out of range (0 - 10).");
        return;  
    } 
    $(obj).data('key',inValue) ;
    sae_updateValidateScore(paperIDX, (inValue*10));
}
function sae_updateValidateCheckbox(paperIDX, obj){
    var inValue = 0;
    if ($(obj).is(":checked")){
        inValue = 100;
    }
    sae_updateValidateScore(paperIDX, inValue);
}
function sae_updateValidateScore(paperIDX, inValue){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_updateValidateScore','act':'print','paperIDX':paperIDX,'inValue':inValue},
        success: function(str){

        }
    });
}
// ================ 2020 ==================================

// function openPresoBatchUpload(location){
//     // var location=$.cookie("LOCATION");
//     window.open("preso_upload.html?location="+location, "preso_upload", "width=600, height=600, toolbar=no, scrollbars=yes, resizable=yes");
// }
function sae_showFilteredList(obj){
    // alert($(obj).val());
    $('.teamListAll').hide();
    $('.'+$(obj).val()).show();
}
function selectOtherRoom(){
    $('#ROOM_0').attr('checked',true);
}
function showListOfTeam_Preso(sortBy){
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('PK_USER_IDX');
    if (sortBy===''){sortBy='number'}
    // console.log("sort by = " + sortBy);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'showListOfTeam_Preso','act':'print','location':location,'userIDX':userIDX,'sortBy':sortBy},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
// 2020 Team Schedule
function sae_openTeamPresoSchedule(todoType, teamIDX, todoIDX){
    var divName = 'TEMP_DIV_TEAM_SCHEUDLE';
    var location = $.cookie('LOCATION');
    // alert(location);
    createNewModalDiv('<b>Team Schedule</b>',divName,800);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_openTeamPresoSchedule','act':'print','todoType':todoType,'location':location,'teamIDX':teamIDX,'divName':divName,'todoIDX':todoIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_setPresentationSchedule(todoType, teamIDX, divName){
    var location = $.cookie('LOCATION');
    var toDoRoom = $('input[name=toDoRooms]:checked').val();
    var toDoTime = $('#TIME_HOUR :selected').val()+":"+$('#TIME_MIN :selected').val();
    // var toDoTime = $('input[name=toDoTimes]:checked').val();
    if (toDoRoom ==0){toDoRoom = $('#ROOM_OTHER').val()}
    console.log("toDoTime="+toDoTime);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_setPresentationSchedule','act':'print','location':location,'teamIDX':teamIDX,'toDoRoom':toDoRoom,'toDoTime':toDoTime,'todoType':todoType},
        success: function(str){
            $('#'+divName).remove();
            $('#TD_teamPresoTime_'+teamIDX).html(str);
            // alert(str);
        }
    });
    // console.log("teamIDX = "+teamIDX+", divName="+divName+",location="+location+", toDoRoom="+toDoRoom+", toDoTime="+toDoTime);

}
function sae_showImportSchedule(){
    var divName = 'TEMP_DIV_TEAM_SCHEUDLE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Import Schedule</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_showImportSchedule','act':'print','location':location,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_importScheduleFile(divName){
    // alert('test import button'); 
    var formData = new FormData();
    var location = $.cookie('LOCATION');
    formData.append('csvFile', $('input[type=file]')[0].files[0]); 
    formData.append('location',location);
    formData.append('do','sae_importScheduleFile');
    formData.append('act','print');
    // formData.append('location',location);
    console.log($('input[type=file]')[0].files[0]);
    $.post({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: formData,
        contentType: false, // NEEDED, DON'T OMIT THIS (requires jQuery 1.6+)
        processData: false, // NEEDED, DON'T OMIT THIS
        success: function(str){
            // $('#sae_results').html(str);
            console.log(str);
            $('#'+divName).remove();
            alert("File Imported");
            showListOfTeam_Preso();
        }
    });
}
function sae_openNewScoreCard(teamIDX){
    var divName = 'TEMP_DIV_TEAM_PRESO_SCORECARD';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Presentation Score Card</b>',divName,1000);
    // $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_openNewScoreCard','act':'print','location':location,'teamIDX':teamIDX,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
            $('[tabindex=1]').focus();
            
        }
    });
}
function sae_processValue(obj){
    if ($(obj).val()>1000){
        $(obj).val($(obj).val()/1000)
    }
    if ($(obj).val()>100){
        $(obj).val($(obj).val()/100)
    }
    if ($(obj).val()>10){
        $(obj).val($(obj).val()/10)
    }
}
// ================ 2019 ==================================
function sae_updateScoreCard(teamIDX, cardIDX){
    var location = $.cookie('LOCATION');
    var divName = 'TEMP_DIV_TEAM_PRESO_SCORECARD';
    createNewModalDiv('<b>Presentation Score Card</b>',divName,1000);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_updateScoreCard','act':'print','location':location,'teamIDX':teamIDX,'cardIDX':cardIDX,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function sae_savePresentationScores(teamIDX, close, cardIDX, divName){
    var userIDX = $.cookie('PK_USER_IDX');
    var location = $.cookie('LOCATION');
    var obj = {};
    var cmt = {};
    $('.inputBinary').each(function(i){
        // console.log(i);
        // console.log("inputBinary data-key="+$(this).data('key')+"\n");
        if ($(this).is(":checked")){
            obj[$(this).data('key')] = 100;
        } else {
            obj[$(this).data('key')] = 0;
        }
    });
    $('.inputNumber').each(function(i){
        // console.log(i);
        // console.log("inputNumber data-key="+$(this).data('key')+"\n");
        var value = $(this).val();
        obj[$(this).data('key')]=$(this).val()*10;
        // console.log("value="+value+"\n");
        $(this).val('');
    });
    $('.inputComments').each(function(i){
        var value = $(this).val();
        var comments =  encodeURIComponent(escapeVal($(this).val(),"<br />"));
        cmt[$(this).data('key')]=comments;
        $(this).val('');
    });
    var jsonData = JSON.stringify( obj );
    var jsonComment = JSON.stringify( cmt );
    // console.log (divName);
    console.log(jsonComment);
    // return
    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_savePresentationScores','act':'print','jsonData':jsonData,'jsonComment':jsonComment,'teamIDX':teamIDX,'userIDX':userIDX,'cardIDX':cardIDX,'location':location},
        success: function(str){
            // console.log(str);
            var data = JSON.parse(str);
            if (close==1){
                $('#'+divName).remove();
                $('#A_CARDIDX_'+cardIDX).remove();
            }
            $('#TD_ROW_FOR_'+teamIDX).append(data.HTML);
            $('#TD_TEAM_AVERAGE_SCORE_'+teamIDX).html(data.AVERAGE);
            $('[tabindex=1]').focus();
        }
    });
}
function sae_deleteScore(teamIDX, cardIDX, divName){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_deleteScore','act':'print','cardIDX':cardIDX,'teamIDX':teamIDX,'location':location},
        success: function(str){
            $('#A_CARDIDX_'+cardIDX).remove();
            $('#'+divName).remove();
            $('#TD_TEAM_AVERAGE_SCORE_'+teamIDX).html(str);
        }
    });
}