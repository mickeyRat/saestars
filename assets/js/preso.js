    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';
    var evalCardData = {}; // Created an Object to Collect New Evaluation Form Data before saving to Database.
    var evalFormData = {}; // Created an Object to Collect New Evaluation Form Data before saving to Database.
    var evalFeedback = {}; // Created an Object to Collect New Evaluation Form Data before saving to Database.

// ================ 2024 ==================================
function preso_showSaveBanner(message) {
    var newID = Math.floor(Math.random()*100000);
    var div = document.createElement("div");
    div.setAttribute ('ID', newID);
    div.setAttribute ('class', "w3-border w3-padding w3-round-large w3-green w3-margin-top");
    div.style.display   = "in-line";
    div.style.width   = "300px";
    div.innerHTML     = message;
    // console.log(div);
    $('#banner_saveMessage').append(div);

    setInterval(function () {$('#'+newID).hide(300)}, 500);
    setInterval(function () {$('#'+newID).remove()}, 750);
    }
function preso_deleteCard(o, cardIDX, teamIDX) {
    var jsYes = confirm("Click [ OK ] to confirm a DELETE request.");
    if (!jsYes){return}
    $(o).close();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'preso_deleteCard','act':'print','cardIDX':cardIDX,'teamIDX':teamIDX},
        success: function(str){
            var data = JSON.parse(str);
            // $('#A_CARDIDX_'+cardIDX).remove();
            $('#BUTTON_CARD_'+cardIDX).fadeOut(100);
            $('#MAX_STAT_'+teamIDX).html(parseFloat(data.IN_MAX).toFixed(2));
            $('#MIN_STAT_'+teamIDX).html(parseFloat(data.IN_MIN).toFixed(2));
            $('#STD_STAT_'+teamIDX).html(parseFloat(data.IN_STD).toFixed(2));
            $('#MEAN_STAT_'+teamIDX).html(parseFloat(data.IN_MEAN).toFixed(2));

        }
    });
    $(o).close();
    }
function preso_updatePresentationScore(o, cardIDX, teamIDX) {
    $.modal('Update: Presentation Evaluation Form', '97%');
    var data            = {};
    var ajxData         = {}; 
    var userIDX         = $.cookie('PK_USER_IDX');
    ajxData.do          = 'preso_updatePresentationScore';
    ajxData.act         = 'print';
    ajxData.cardIDX     = cardIDX;
    ajxData.teamIDX     = teamIDX;
    ajxData['jsonCard'] = JSON.stringify(ajxData);
    // console.log(ajxData);
    // ajxData.userIDX     = userIDX;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    }
function preso_saveNewEvaluation(o, classIDX, teamIDX) {
    var data            = {};
    var ajxData         = {}; 
    var userIDX         = $.cookie('PK_USER_IDX');
    ajxData.do          = 'preso_saveNewEvaluation';
    ajxData.act         = 'print';
    ajxData.classIDX    = classIDX;
    ajxData.userIDX     = userIDX;
    ajxData.teamIDX     = teamIDX;
    ajxData['jsonCard'] = JSON.stringify(evalCardData);
    ajxData['jsonData'] = JSON.stringify(evalFormData);
    ajxData['jsonFeed'] = JSON.stringify(evalFeedback);
    console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: ajxData,
        success: function(str){
            var data = JSON.parse(str);
            console.log(str);
            $('#cardBin_'+teamIDX).append(data.TG_BUTTON);
            $('#MAX_STAT_'+teamIDX).html(parseFloat(data.IN_MAX).toFixed(2));
            $('#MIN_STAT_'+teamIDX).html(parseFloat(data.IN_MIN).toFixed(2));
            $('#STD_STAT_'+teamIDX).html(parseFloat(data.IN_STD).toFixed(2));
            $('#MEAN_STAT_'+teamIDX).html(parseFloat(data.IN_MEAN).toFixed(2));
            $(o).close();
        }
    });
    }
function preso_collectFormData(o, reportIDX){
    if ($(o).is(':checkbox')) {
        evalFormData[$(o).data('key')] = 0;
        if ($(o).prop('checked')){
            evalFormData[$(o).data('key')] = 10;
            changeLineItemColor(reportIDX, 'w3-teal');
        } else {
            changeLineItemColor(reportIDX, '');
        }
    } else {
        if ($(o).data('field') == 'CL_FEEDBACK') {
            evalFeedback[$(o).data('key')] = $(o).val();
        } else {
            evalFormData[$(o).data('key')] = $(o).val();
            changeLineItemColor(reportIDX, 'w3-teal');
        }    
    }
    console.log(JSON.stringify(evalFormData)) ;
    // console.log(JSON.stringify(evalFeedback)) ;
    }
function changeLineItemColor(reportIDX, color) {
    var defaultColor = 'w3-light-grey';
    if (color=='w3-teal'){
        $('#LINE_ITEM_'+reportIDX).removeClass(defaultColor).addClass(color);
    } else {
        $('#LINE_ITEM_'+reportIDX).removeClass(color).addClass(defaultColor);
    }
}
function preso_updateBreakingScoringThreshold(o, divName, paperIDX, cardIDX, reportIDX, teamIDX) {
    var inValue = $(o).val();
    // console.log("paperIDX = " + paperIDX);   
    // console.log("inValue = " + inValue);   
    // console.log("cardIDX = " + cardIDX);   
    // console.log("reportIDX = " + reportIDX);   
    if (inValue<=5){
        $('#arrow_'+divName).addClass('fa-angle-double-down');
        if ($('.'+divName).hasClass('w3-hide')) {
            $('.'+divName).toggleClass('w3-hide');
        } 
    }
    preso_saveLineItem(paperIDX, inValue, cardIDX, reportIDX, teamIDX);
    // preso_collectFormData(o);
    // grade_saveAssessment(paperIDX, inValue, inSection, inSubSection, cardIDX, txType);
    // }
    }
function preso_autosaveFeedback(o, paperIDX) {
    var inValue = $(o).val();
    console.log("paperIDX = " + paperIDX);  
    console.log("inValue = " + inValue);  
    var data            = {};
    var ajxData         = {}; 
    data.CL_FEEDBACK    = inValue;
    ajxData.do          = 'preso_autosaveFeedback';
    ajxData.act         = 'print';
    ajxData.paperIDX    = paperIDX;
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            o.style.height = "75px";
            preso_showSaveBanner("Saving your latest feedback...");
        }
    });
    // body...
    }
function preso_saveCheckAssessment(o, paperIDX, cardIDX, reportIDX, teamIDX) {
    var inValue = 0;
    if ($(o).prop('checked')){inValue = 10} 
    preso_saveLineItem(paperIDX, inValue, cardIDX, reportIDX, teamIDX);
    }
function preso_saveLineItem(paperIDX, inValue, cardIDX, reportIDX, teamIDX) {
    var data            = {};
    var ajxData         = {}; 
    data.IN_VALUE       = inValue;
    ajxData.do          = 'preso_saveLineItem';
    ajxData.act         = 'print';
    ajxData.paperIDX    = paperIDX;
    ajxData.cardIDX     = cardIDX;
    ajxData.teamIDX     = teamIDX;
    // ajxData.txType      = txType;
    ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: ajxData,
        success: function(str){
            var data = JSON.parse(str);
            // console.log("Score = " + score);
            $('#CARD_SCORE_'+cardIDX).html(parseFloat(data.IN_SCORE).toFixed(2));
            $('#MAX_STAT_'+teamIDX).html(parseFloat(data.IN_MAX).toFixed(2));
            $('#MIN_STAT_'+teamIDX).html(parseFloat(data.IN_MIN).toFixed(2));
            $('#STD_STAT_'+teamIDX).html(parseFloat(data.IN_STD).toFixed(2));
            $('#MEAN_STAT_'+teamIDX).html(parseFloat(data.IN_MEAN).toFixed(2));
            preso_showSaveBanner("Sending your assesment ["+inValue+"] to the Server ");
            if (inValue>0){
                $('#LINE_ITEM_'+reportIDX).removeClass('w3-light-grey').addClass('w3-teal');
            } else {
                $('#LINE_ITEM_'+reportIDX).removeClass('w3-teal').addClass('w3-light-grey');
            }
        },
    });
    }
function preso_breakingScoringThreshold(o, divName, reportIDX){     
    var inValue = $(o).val();   
    if (inValue<=5){
        $('#arrow_'+divName).addClass('fa-angle-double-down');
        if ($('.'+divName).hasClass('w3-hide')) {
            $('.'+divName).toggleClass('w3-hide');
        } 
    }
    preso_collectFormData(o, reportIDX);
    // grade_saveAssessment(paperIDX, inValue, inSection, inSubSection, cardIDX, txType);
    }
function preso_expandDescription(o, divName) {
    $('.'+divName).toggleClass('w3-hide');
    $('#arrow_'+divName).toggleClass('fa-angle-double-down');
    }
function preso_openEvaluationForm(o, classIDX, teamIDX) {
    $.modal('Presentation Evaluation Form', '97%');
    evalCardData = {}; // Everytime a new Form is open, re-initialize the Object
    evalFormData = {}; // Everytime a new Form is open, re-initialize the Object
    var ajxData         = {}; 
    var eventIDX = $.cookie('LOCATION');
    var userIDX = $.cookie('PK_USER_IDX');
    evalCardData.FK_USER_IDX     = userIDX;
    evalCardData.FK_TEAM_IDX     = teamIDX;
    evalCardData.FK_CARDTYPE_IDX = 5;
    evalCardData.FK_EVENT_IDX    = eventIDX;
    evalCardData.IN_STATUS       = 2;

    ajxData['jsonData'] = JSON.stringify(evalCardData);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'preso_openEvaluationForm','act':'print','userIDX':userIDX,'eventIDX':eventIDX,'classIDX':classIDX, 'teamIDX':teamIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
     }

// ================ 2022 ==================================
function sae_openImport(userIDX){
    $.modal("Import Excel Presentation Scores", "50%");
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_openImport','act':'print','userIDX':userIDX,'eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    $('#divImport').removeClass('w3-hide');
}
function sae_uploadExcelScoresheet(o, eventIDX){
    // console.log(eventIDX);
    $('#uploadedDisplay').html(loading); 
    var userIDX = $('#JUDGE_IDX :selected').val();
    var fd = new FormData();
    var files = $('#file')[0].files[0];
    fd.append('filename', files);
    fd.append('eventIDX', eventIDX);
    fd.append('userIDX', userIDX);
    // console.log(userIDX);
    // return;
    $.ajax({
        url: '../cgi-bin/upload_preso.pl',
        type: 'post',
        data: fd,
        contentType: false,
        processData: false,
        success: function(str){
            // console.log(str);
            // $('#uploadedDisplay').html(str); 
        },
    }).done(function(){
        showListOfTeam_Preso('number');
        $(o).close();
    });
}
function getFileName(o){
    var i = $(o).prev('label').clone();
    var file = $('#file')[0].files[0].name;
    $(o).prev('label').text('Selected File: ' + file);

}
// ================ 2021 ==================================
function sae_showDescription(o, idx){
    // console.log($(o).data('key'));
    $('.sae-preso-description').addClass('w3-hide');
    $('#SUB_'+idx).removeClass('w3-hide');
    $('#CHEVERON_'+idx).removeClass('w3-hide');
}

function sae_validatePreso(){
    // console.log("loation = " + location);
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('PK_USER_IDX');
    $('#mainPageContent').html(loading);
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
    $('#mainPageContent').html(loading);
    var location = $.cookie('LOCATION');
    var eventIDX = $.cookie('LOCATION');
    var userIDX = $.cookie('PK_USER_IDX');
    if (sortBy===''){sortBy='number'}
    // console.log("sort by = " + sortBy);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'preso_showListOfTeam','act':'print','location':location,'userIDX':userIDX,'sortBy':sortBy,'eventIDX':eventIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    }).done(function(){
        // console.log("Done");
        document.querySelectorAll(".table th").forEach(headerCell => {
            headerCell.addEventListener("click", () => {
                // const tableElement = headerCell.parentElement.parentElement.parentElement;
                const tableElement = headerCell.closest('.table');
                const headerIndex = Array.prototype.indexOf.call(headerCell.parentElement.children, headerCell);
                const currentIsAscending = headerCell.classList.contains("th-sort-asc");
                const dType = $(headerCell).data('type');
                // console.log($(headerCell).data('type'));
        
                sortTableByColumn(tableElement, headerIndex, dType, !currentIsAscending);
            });
        });
    });;
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
    $.modal('Presentation Score Card');
    // var divName = 'TEMP_DIV_TEAM_PRESO_SCORECARD';
    var location = $.cookie('LOCATION');
    // createNewModalDiv('<b>Presentation Score Card</b>',divName,1000);
    // $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        // data: {'do':'sae_openNewScoreCard','act':'print','location':location,'teamIDX':teamIDX,'divName':divName},
        data: {'do':'sae_openNewScoreCard','act':'print','location':location,'teamIDX':teamIDX},
        success: function(str){
            // $('#modal_content').html(str);
            $('#modal_content').html(str);
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
    // var divName = 'TEMP_DIV_TEAM_PRESO_SCORECARD';
    // createNewModalDiv('<b>Presentation Score Card</b>',divName,1000);
    $.modal('Update Presentation Score Card');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_updateScoreCard','act':'print','location':location,'teamIDX':teamIDX,'cardIDX':cardIDX},
        success: function(str){
            $('#modal_content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
// function sae_savePresentationScores(o, teamIDX, close, cardIDX){
function sae_savePresentationScores(o, close, cardIDX){
    var totalCheck = 0;
    var userIDX  = $.cookie('PK_USER_IDX');
    var location = $.cookie('LOCATION');
    var teamIDX  = $('#fkTeamIdx option:selected').val();
    var obj = {};
    var cmt = {};
    $('.inputBinary').each(function(i){
        // console.log(i);
        // console.log("inputBinary data-key="+$(this).data('key')+"\n");
        if ($(this).is(":checked")){
            obj[$(this).data('key')] = 100;
            totalCheck++
        } else {
            obj[$(this).data('key')] = 0;
        }
    });
    $('.inputNumber').each(function(i){
        // console.log(i);
        // console.log("inputNumber data-key="+$(this).data('key')+"\n");
        var value = $(this).val();
        if (value>0){totalCheck++}
        obj[$(this).data('key')]=value*10;
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
    if (totalCheck==0){alert("No assessment made."); return;} else {$(o).close();}
    // console.log (divName);
    // console.log(jsonComment);
    // return
    console.log(userIDX);
    // $(o).close();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_savePresentationScores','act':'print','jsonData':jsonData,'jsonComment':jsonComment,'teamIDX':teamIDX,'userIDX':userIDX,'cardIDX':cardIDX,'location':location},
        success: function(str){
            // console.log(str);
            var data = JSON.parse(str);
            console.log(data);
            if (close==1){
                // $('#'+divName).remove();
                $(o).close();
                $('#A_CARDIDX_'+cardIDX).remove();
            }
            // $('#TD_ROW_FOR_'+teamIDX).append(data.HTML);
            $('#TD_TEAM_AVERAGE_SCORE_'+teamIDX).html(data.AVERAGE);
            $('#TD_TEAM_MAX_SCORE_'+teamIDX).html(data.MAX);
            $('#TD_TEAM_MIN_SCORE_'+teamIDX).html(data.MIN);
            $('#TD_TEAM_STD_SCORE_'+teamIDX).html(data.STD);
            $('#TD_TEAM_CVAR_SCORE_'+teamIDX).html(data.COE);
            if (cardIDX>0){
                $('#SCORECARD_'+cardIDX).replaceWith(data.CARD);
            } else {
                $('#TD_PRESOCARD_'+teamIDX).prepend(data.CARD);
            }

            $('[tabindex=1]').focus();
        }
    });
}
function sae_deleteScore(o, cardIDX){
    var teamIDX = $('#fkTeamIdx option:selected').val();
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/preso.pl',
        data: {'do':'sae_deleteScore','act':'print','cardIDX':cardIDX,'teamIDX':teamIDX,'location':location},
        success: function(str){
            $('#A_CARDIDX_'+cardIDX).remove();
            $('#SCORECARD_'+cardIDX).fadeOut(250);
            $(o).close();
            $('#TD_TEAM_AVERAGE_SCORE_'+teamIDX).html(str);
        }
    });
}