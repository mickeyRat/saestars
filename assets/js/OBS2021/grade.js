var d=document;
var now = new Date();
var time = now.getTime();


function openAssessment(cardIDX, inNumber, classIDX, teamIDX, inType, from){
    var divName = 'TEMP_DIV_OPEN_ASSESSMENT'; 
    var userIDX = $.cookie('userIDX');
    var location = $.cookie('LOCATION');
    if (from ===''){from=1}
    // alert(inType);
    console.log("location="+location);
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
