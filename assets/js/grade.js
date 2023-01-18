var d=document;
var now = new Date();
var time = now.getTime();



// ============= 2023 ========================
function  grade_teamAttributes(o, teamIDX, ) {
    var data                    = {};
    var ajxData                 = {}; 
    ajxData.do                  = 'grade_teamAttributes';
    ajxData.act                 = 'print';
    ajxData.teamIDX             = teamIDX;
    ajxData.table               = $(o).data('table');
    data[$(o).data('field')]    = $(o).val();
    ajxData['jsonData']         = JSON.stringify(data);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $('#template_'+tempIDX).remove();
            console.log(str);
        }
    });
    }
function grade_deleteTemplate(o, tempIDX) {
    var jsYes = confirm("Click [OK] toconfirm the action to delete this template from your library.");
    if (!jsYes){return}
    var ajxData         = {}; 
    ajxData.do          = 'grade_deleteTemplate';
    ajxData.act         = 'print';
    ajxData.tempIDX     = tempIDX;
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $('#template_'+tempIDX).remove();
            console.log(str);
        }
    });
    }
function grade_loadInstructions(argument) {
    var ajxData         = {}; 
    ajxData.do          = 'grade_loadInstructions';
    ajxData.act         = 'print';
    ajxData.txFirstName = $.cookie('TX_FIRST_NAME');;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $('#AssessmentHelper').html(str);
        }
    });
    
    // body...
}
function grade_loadTemplate (o, tempIDX) {
    $('#subsectionComment').val($(o).data('value'));
    $(o).close('sae-top2');
}
function grade_previewTemplate (o, tempIDX) {
    $('#templatePreview').html($(o).data('value'));
}
function grade_openTemplateList (o, userIDX) {
    var ajxData         = {}; 
    ajxData.do          = 'grade_openTemplateList';
    ajxData.act         = 'print';
    ajxData.userIDX     = userIDX;
    $.modal2("Load from Template", "80%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
}
function grade_saveTemplate (o) {
    var userIDX         = $.cookie('PK_USER_IDX');
    var comments        = $('#templateComment').val();
    var txTitle         = $('#templateTitle').val();
    if (txTitle == '') {alert("Missing Template Title"); return}
    var data            = {};
    var ajxData         = {}; 
    data.CL_COMMENT     = comments;
    data.TX_TITLE       = txTitle;
    data.FK_USER_IDX    = userIDX;
    ajxData.do          = 'grade_saveTemplate';
    ajxData.act         = 'print';
    ajxData['jsonData'] = JSON.stringify(data);
    console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $(o).close('sae-top2');
            // setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
        }
    });
    }
function grade_openTemplate (o) {
    var comments        = $('#subsectionComment').val();
    var data            = {};
    var ajxData         = {}; 
    var userIDX         = $.cookie('PK_USER_IDX');
    data.CL_COMMENT     = comments;
    ajxData.do          = 'grade_openTemplate';
    ajxData.act         = 'print';
    ajxData['jsonData'] = JSON.stringify(data);
    $.modal2("Save Commetns to Template", "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
    }
function grade_updateComments (o, commentIDX) {
    var comments = $('#subsectionComment_update').val();
    var data    = {};
    var ajxData = {};              
    data.CL_COMMENT              = comments;
    ajxData.do                   = 'grade_updateComments';
    ajxData.act                  = 'print';
    ajxData.commentIDX           = commentIDX;
    ajxData.userIDX              = $.cookie('PK_USER_IDX');
    ajxData['jsonData'] = JSON.stringify(data);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $('#Comment_'+commentIDX).replaceWith(str);
            $(o).close('sae-top2');
            // setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
        }
    });
 }
function grade_editComment (commentIDX) {
    $.modal2("Edit feedback & comments", "50%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'grade_editComment','act':'print','commentIDX':commentIDX},
        success: function(str){
            // console.log(str);
            $('#modal2_content').html(str);
        }
    });
    }
function grade_deleteComment (commentIDX) {
    // body...
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $('#savedMessage').show();
    var ajxData = {};
    ajxData['do'] = 'grade_deleteComment';
    ajxData['act'] = 'print';
    ajxData.commentIDX = commentIDX;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $('#Comment_'+commentIDX).remove();
            // console.log(str);
            // $('#COMMENT_CONTAINER').prepend(str);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 1000);
        }
    });
    }
function grade_postComments (o, cardIDX, teamIDX, subIDX) {
    $('#savedMessage').show();
    var data    = {};
    var ajxData = {};
    var userIDX = $.cookie('PK_USER_IDX');
    var comments = $('#subsectionComment').val();
    data.CL_COMMENT              = comments;
    ajxData.do                   = 'grade_postComments';
    ajxData.act                  = 'print';
    data.FK_CARD_IDX             = cardIDX;
    data.FK_SUBSECTION_IDX       = subIDX;
    data.FK_TEAM_IDX             = teamIDX;
    data.FK_USER_IDX             = userIDX;
    ajxData['jsonData'] = JSON.stringify(data);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            $('#subsectionComment').val('');
            $('#COMMENT_CONTAINER').prepend(str);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
        }
    });
    }
function grade_setAssessmentStatus (o, cardIDX, inStatus, classIDX, inCardType) {
    $('#savedMessage').show();
    var ajxData = {};
    // var data    = {};
    ajxData.do                   = 'grade_setAssessmentStatus';
    ajxData.act                  = 'print';
    ajxData.FK_CARD_IDX          = cardIDX;
    ajxData.IN_STATUS            = inStatus;
    ajxData.FK_CLASS_IDX         = classIDX;
    ajxData.FK_CARDTYPE_IDX      = inCardType;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
            $(o).close();
            $('#CARD_'+cardIDX).replaceWith(str);
        }
    });
    }
function selectAllCheckBox (o, className, cardIDX) {
    $('#savedMessage').show();
    var value = 0;
    if ($(o).is(':checked')){value = 100}
    $('.'+className).each(function(){
        $(this).prop('checked', o.checked);
        var subIDX = $(this).data('value');
        grade_updateFieldValue (cardIDX, subIDX, value);
    });
setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
}
function grade_updateFieldValue(cardIDX, subIDX, inValue) {
    var ajxData = {};
    ajxData.do                   = 'grade_updateField';
    ajxData.act                  = 'print';
    ajxData.FK_CARD_IDX          = cardIDX;
    ajxData.FK_SUBSECTION_IDX    = subIDX;
    ajxData.IN_VALUE             = inValue;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: ajxData,
        success: function(str){
            
        }
    });
}
function grade_updateCheckField(o, cardIDX, subIDX) {
    $('#savedMessage').show();
    var value = 0;
    if ($(o).is(':checked')){value = 100}
    grade_updateFieldValue (cardIDX, subIDX, value);
    setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
    }
function grade_updateField(o, cardIDX, subIDX) {
    $('#savedMessage').show();
    var value = $(o).val();
    grade_updateFieldValue (cardIDX, subIDX, value);
    setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);
    }
function grade_moveToNextField (e, o) {

    var fieldValue = $(o).val();
    if (isNaN(fieldValue)){
        // console.log("the number enter is invalid")
        $(o).val(0);
        return
    }
    if (fieldValue < 0){
        $(o).val(0);
        return
    }
    if (fieldValue > 100){
        $(o).val(100);
        return
    }
    // console.log(isNaN(fieldValue));
    // console.log('Value = ' + fieldValue);
    // console.log(e.keyCode);
    var next = $(o).prop('tabindex')+1;
    var prev = $(o).prop('tabindex')-1;
    if (e.keyCode==40){
        // $(o).val(fieldValue);
        $('[tabindex='+next+']').focus();
    }
    if (e.keyCode==38){

        $('[tabindex='+prev+']').focus();
    }
    }
function grade_openHelp (o, subIDX, inSection, cardIDX, teamIDX) {
    var inValue = $(o).val();
    var userIDX = $.cookie('PK_USER_IDX');
    $('.rowTitle').removeClass('w3-yellow').addClass('w3-white');
    $('#AssessmentHelper').html(loading);
    $(o).closest('tr').removeClass('w3-white').addClass('w3-yellow');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'grade_openHelp','act':'print','subIDX':subIDX,'inSection':inSection,'cardIDX':cardIDX,'teamIDX':teamIDX,'userIDX':userIDX,'inValue':inValue},
        success: function(str){
            $('#AssessmentHelper').html(str);
        }
    });
    
}
function grade_openAssessment (o, cardIDX, inNumber, txSchool, classIDX, teamIDX, inCardType, adminUserIDX) {
    // body...
    console.log('adminUserIDX      = ' + adminUserIDX);
    console.log('logged In userIDX = ' + $.cookie('PK_USER_IDX'));
    var eventIDX = $.cookie('LOCATION');
    var userIDX = $.cookie('PK_USER_IDX');
    var txFirstName = $.cookie('TX_FIRST_NAME');
    // console.log(txFirstName );
    $.modal('<b>Team #:' + pad(inNumber,3) + '</b> - '+txSchool, '97%');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'grade_openAssessment','act':'print','eventIDX':eventIDX,'txFirstName':txFirstName,'cardIDX':cardIDX,'userIDX':userIDX,'classIDX':classIDX,'teamIDX':teamIDX,'inCardType':inCardType,'adminUserIDX':adminUserIDX},
        success: function(str){
            $('#modal_content').html(str);
        }
    });

}



// ============= 2023 ========================

function sae_uploadDesignExcelScoresheet(o, eventIDX){
    $('#uploadedDisplay').html(loading); 
    var userIDX = $('#JUDGE_IDX :selected').val();
    // var eventIDX = $.cookie('LOCATION');
    var fd = new FormData();
    var files = $('#file')[0].files[0];
    fd.append('filename', files);
    fd.append('eventIDX', eventIDX);
    fd.append('userIDX', userIDX);
    // console.log(userIDX);
    // return;
    $.ajax({
        url: '../cgi-bin/upload_design.pl',
        type: 'post',
        data: fd,
        contentType: false,
        processData: false,
        success: function(str){
            // console.log(str);
            $('#uploadedDisplay').html(str); 
        },
    }).done(function(){
        sae_refreshReportList(userIDX, 1, eventIDX);
        $(o).close();
        alert("Upload Successful.");
    });
}
function sae_openImportDesignScores(){
    $.modal("Import Excel Design Scores", "50%");
    var eventIDX = $.cookie('LOCATION');
    var userIDX = $.cookie('USER_IDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_openImportDesignScores','act':'print','userIDX':userIDX,'eventIDX':eventIDX},
        success: function(str){
            // console.log(str);
            $('#modal_content').html(str);
        }
    });
    $('#divImport').removeClass('w3-hide');
}
function openAssessment(cardIDX, inNumber, classIDX, teamIDX, inType, from){
    var divName = 'TEMP_DIV_OPEN_ASSESSMENT'; 
    var userIDX = $.cookie('userIDX');
    var location = $.cookie('LOCATION');
    if (from ===''){from=1}
    // alert(inType);
    // console.log("location="+location);
    createNewModalDiv('<b>Team #'+inNumber+'</b> : Design Report Assessment',divName,1050);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'openAssessment','act':'print','location':location, 'divName':divName,'classIDX':classIDX, 'cardIDX':cardIDX,'inNumber':inNumber,'userIDX':userIDX,'teamIDX':teamIDX,'inType':inType,'from':from},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });    
}
function expandComments(subSectionIDX){
    $('#comments_'+subSectionIDX).toggleClass('w3-hide');
}
function showScoringCriteria(obj,subSectionIDX){
    // $(obj).parent().toggleClass('w3-hide');
    $('#instruction_'+subSectionIDX).toggleClass('w3-hide');
}

function sae_postComments(cardIDX, subSectionIDX, teamIDX){
    var comments =  encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
    if (comments===''){
        alert("No Comments Provided");
        return;
    }
    $('#comments_entry_'+subSectionIDX).val('');
    var userIDX = $.cookie('userIDX');
    // alert(cardIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_postComments','act':'print','cardIDX':cardIDX,'subSectionIDX':subSectionIDX, 'userIDX':userIDX,'comments':comments,'teamIDX':teamIDX},
        success: function(str){
            $('#comments_posted_'+subSectionIDX).prepend(str);
        }
    });
}
function sae_deleteComment(commentIDX){
    var jsYes = confirm("Are you sure? ");
    if (!jsYes){return}
    $('#subSectionComments_'+commentIDX).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_deleteComment','act':'print','commentIDX':commentIDX},
        success: function(str){
            // alert(str + " " +commentIDX);
            
        }
    });
}
function sae_saveToTemplate(subSectionIDX){
    var title = prompt("Please enter a template title");
    if (!title || title ==='') {return}
    var userIDX = $.cookie('userIDX');
    var comments =  encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
    // alert (comments);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_saveToTemplate','act':'print','title':title,'userIDX':userIDX,'comments':comments},
        success: function(str){
            // alert(str);
            $('.templateList').append(str);
        }
    });
};

function sae_applyTemplate(subSectionIDX){
    var templateIDX = $('#templateList_'+subSectionIDX+' option:selected').val();
    if (templateIDX ===0){
        return
    }
    $('#templateList_'+subSectionIDX).find('option:first').attr('selected', 'selected');
    // alert(subSectionIDX+" " +templateIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_applyTemplate','act':'print','templateIDX':templateIDX},
        success: function(str){
            // alert(str);
            $('#comments_entry_'+subSectionIDX).val(str)
            // $('.templateList').append(str);
        }
    });
}
function sae_cancelUpdateComments(cardIDX, subSectionIDX, teamIDX){
    $("#buttonPostComment_"+subSectionIDX).attr("onclick","sae_postComments("+cardIDX+","+subSectionIDX+","+teamIDX+");").text('Post');
    $("#buttonCancelComment_"+subSectionIDX).attr("onclick","expandComments("+subSectionIDX+");");
    $('#comments_entry_'+subSectionIDX).val('');
}
function sae_updateComments(cardIDX, commentIDX, subSectionIDX, teamIDX){
    var comments =  encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
    $('#comments_entry_'+subSectionIDX).val('');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_updateComments','act':'print','commentIDX':commentIDX,'comments':comments, 'teamIDX':teamIDX},
        success: function(str){
            $('#subSectionCommentItem_'+commentIDX).html(str);
            sae_cancelUpdateComments(cardIDX, subSectionIDX);
        }
    });
    // alert(comments);
}
function sae_editComments(cardIDX, subSectionIDX, commentIDX, teamIDX){
    $("#buttonPostComment_"+subSectionIDX).attr("onclick","sae_updateComments("+cardIDX+","+commentIDX+","+subSectionIDX+","+teamIDX+")").text('Update');
    $("#buttonCancelComment_"+subSectionIDX).attr("onclick","sae_cancelUpdateComments("+cardIDX+","+subSectionIDX+","+teamIDX+")");
    $('#comments_entry_'+subSectionIDX).val('');
    var userIDX = $.cookie('userIDX');
    // alert(cardIDX+", "+subSectionIDX+", "+commentIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_editComments','act':'print','cardIDX':cardIDX,'subSectionIDX':subSectionIDX, 'userIDX':userIDX, 'commentIDX':commentIDX},
        success: function(str){
            // alert(str);
            $('#comments_entry_'+subSectionIDX).val(str);
        }
    });
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// CALCULATIONS
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function validateInput(obj){

    if ($(obj).val()>100 || $(obj).val()<1){alert('Entry out of Range (1-100)'); $(obj).focus().val("");}
}
function sae_calculateNow(obj, sectionIDX, inPoints){
    let totalPoints = inPoints;
    var sectionWeight = $(obj).data('weight');
    var count = $(".sae-input-group-"+sectionIDX).length;
    // console.log("Total Count = "+count);
    var sum = 0;
    var subValue = 0;
    $(".sae-input-group-"+sectionIDX).each(function(){
        if ($(this).val() === 'NaN' || $(this).val() ===''){
            subValue = 0;
        } else {
            subValue = $(this).val();
        }
        sum +=  parseInt( subValue, 10 );
    });
    var avg = sum/count;
    var points = (avg * sectionWeight/100 * totalPoints);
    $('#sectionAverage_'+sectionIDX).html(avg.toFixed(2));
    // $('.summaryTotal').html(points.toFixed(2));
    // console.log("total = "+sum+"; Average = "+(sum/count).toFixed(2)+"\nSection Weight ="+$(obj).data('weight')+"\nSection Weight = "+sectionWeight+" Points = " +points);
}

function sae_submitReportAssessment(cardIDX, divName, teamIDX, inType, status, from){
    var obj = {};
    $('.inputBinary').each(function(i){
        if ($(this).is(":checked")){
            obj[$(this).data('key')]=$(this).val();
        } else {
            obj[$(this).data('key')]=0;
        }
    });
    $('.sae-inputs').each(function(i){
        obj[$(this).data('key')]=$(this).val();
    });
    var jsonData = JSON.stringify( obj );
    var userIDX = $.cookie('userIDX');
    console.log(jsonData);
    // alert(jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_submitReportAssessment','act':'print','cardIDX':cardIDX,'teamIDX':teamIDX,'inType':inType,'status':status, 'jsonData':jsonData},
        success: function(str){
            $('#'+divName).remove();
            alert("Submitted!\n\nThis Team Earned "+str+" points.");
            console.log("from="+from);
            $('#teamPaperScores_'+teamIDX).html(str);
            if (from == 1 || from ===''){
                openReportItems('ManageReportAssessments', userIDX, inType);
            }
            // $('#comments_entry_'+subSectionIDX).val(str); 
        }
    });
    // alert(jsonData);
}
function sae_updateReportAssessment(cardIDX, divName, teamIDX, inType, status, from){
    var obj = {};
    $('.inputBinary').each(function(i){
        if ($(this).is(":checked")){
            obj[$(this).data('key')]=$(this).val();
        } else {
            obj[$(this).data('key')]=0;
        }
    });
    $('.sae-inputs').each(function(i){
        obj[$(this).data('key')]=$(this).val();
    });
    var jsonData = JSON.stringify( obj );
    // console.log(jsonData);
    var userIDX = $.cookie('userIDX');
    // alert(jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'sae_updateReportAssessment','act':'print','cardIDX':cardIDX,'teamIDX':teamIDX,'inType':inType,'status':status, 'jsonData':jsonData},
        success: function(str){
            $('#'+divName).remove();
            alert("Updated!\n\nThis Team Earned "+str+" points.");
            console.log("from="+from);
            $('#teamPaperScores_'+teamIDX).html(str);
            if (from == 1 || from ===''){
                openReportItems('ManageReportAssessments', userIDX, inType);
            }
            // alert(str);
            // $('#comments_entry_'+subSectionIDX).val(str); 
        }
    });
    // alert(jsonData);
}
function sae_refreshReportList(userIDX, inType, eventIDX){
    var location = $.cookie('LOCATION');
    // alert(toDo+", "+userIDX+", "+inType);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':'ManageReportAssessments','act':'print','userIDX':userIDX ,'inType':inType , 'location': location },
        success: function(str){
            // alert(str);
            $('#mainPageContent').html(str);
        }
    });
}