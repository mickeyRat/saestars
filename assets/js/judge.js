    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();
    var Total = 0;
// alert('test ' + sid + ' ' + $.cookie('expire'));
$( d ).ready(function(){
//     alert("at Judge.html");
    var userType = $.cookie('TYPE');
    if ($.cookie('expire') === null || $.cookie('expire') < time) {
        alert('Your session expired.  Please log in again');
        signOutAdmin();
    } else if ($.cookie('SID') && userType == '0'){
        signOutAdmin();
    }  else {
    $('#main').html('<center><h3><img src="../../images/loader.gif"> Retrieving data.<br><br>This can take up to 60 seconds depending on your internet connection...<h3><a href="judge.html">refresh</a></center>');
        loadListOfAssignedPapers(0);
    }
});
function requestMore(userIDX, TxType){
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    var location = $.cookie('LOCATION');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'requestMore','act':'print','userIDX':PkUserIdx,'TxType':TxType,'location':location},
        success: function(str){
            $('#id01_content').html(str);

        }
    });
}
function addRequestedCard(PkGradeIdx, userIDX){
//     alert(userIDX+", "+PkGradeIdx);
    $('#id01').hide();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'addRequestedCard','act':'print','userIDX':userIDX,'PkGradeIdx':PkGradeIdx},
        success: function(str){
            $('#main').html('<center><h3><img src="../../images/loader.gif"> Retrieving data.<br><br>This can take up to 30 seconds depending on your internet connection...<h3></center>');
            loadListOfAssignedPapers(PkGradeIdx);
        }
    });
}
function addNewCardRequest(txType, userIdx, teamIdx){
//     alert(txType+', '+userIdx+', '+teamIdx);
    $('#id01').hide();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'addNewCardRequest','act':'print','txType':txType,'teamIdx':teamIdx,'userIdx':userIdx},
        success: function(str){
//             alert(str);
            $('#main').html('<center><h3><img src="../../images/loader.gif"> Retrieving data.<br><br>This can take up to 30 seconds depending on your internet connection...<h3></center>');
            loadListOfAssignedPapers(0);
        }
    });
}
function loadListOfAssignedPapers(gradeIDX){
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'loadListOfAssignedPapers','act':'print','PkUserIdx':PkUserIdx, 'location':location},
        success: function(str){
            var obj = JSON.parse( str );
            $('#main').html(obj.FORM);
//                 $('body').scrollTo('#ROW_'+gradeIDX);
var ele = document.getElementById('ROW_'+gradeIDX);
//             ele.scrollIntoView();
//             $('#ROW_'+gradeIDX).scrollIntoView();
//             scrollToElement($('#ROW_'+gradeIDX));
            // alert(ele);
        }
    });
}
function scrollToElement(ele) {
    alert(ele);
    $(window).scrollTop(ele.offset().top).scrollLeft(ele.offset().left);
}

function openSection(obj, sectionName) {
    var i, x, tablinks;
    x = $('.section').length;
    $('.section').each(function(){
        $(this).hide();
    });
    $('.tablink').each(function(){
        $(this).removeClass('w3-green');
    });
    $('#'+sectionName).show();
    $(obj).addClass('w3-green');
//     document.getElementById(sectionName).style.display = "block";
//         evt.currentTarget.className += " w3-green";

}

function openForm(pkQuestionIdx, status) {
    $('#myForm_'+pkQuestionIdx).show();
}

function closeForm(pkQuestionIdx) {
    $('#myForm_'+pkQuestionIdx).hide();
    var pkCommentIdx = $('#UPDATE_COMMENT_FOR_'+pkQuestionIdx).val();
    if (pkCommentIdx>0){
        $('#COMMENT_'+pkCommentIdx).show();
    }
}
function nextSection(i){
    if (i<=0){i=0}
    var x, tablinks;
    x = $('.section').length;
    $('.section').each(function(){
        $(this).hide();
    });
    $('.tablink').each(function(y){
        if (y!=i){
            $(this).removeClass('w3-green');
        } else {
            $(this).addClass('w3-green');
            var subSectionIdx = $(this).data('key');
            $('#section_'+subSectionIdx).show();
        }
    });
}
function startAssessment(PkGradeIdx, PkTeamIdx, txType, FkClassIdx, start){
    $('#main').html('<center><h3><img src="../../images/loader.gif"> Preparing your assessment environment...<h3></center>');
    var location = $.cookie('LOCATION');
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
//      alert(location+", "+PkUserIdx+", "+PkGradeIdx+", "+txType+", "+FkClassIdx);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'startAssessment','act':'print','txType':txType,'FkClassIdx':FkClassIdx,'PkGradeIdx':PkGradeIdx, 'start':start,'PkUserIdx':PkUserIdx,'PkTeamIdx':PkTeamIdx},
        success: function(str){
            var obj = JSON.parse( str );
            $('#main').html(obj.FORM);
            $('.tablink').each(function(i){
                if(i===0){
                    $(this).addClass('w3-green');
                    var subSectionIdx = $(this).data('key');
                    $('#section_'+subSectionIdx).show();
                }
            });
            $('.tablink button').first().addClass('w3-green');
            var subsection = obj.SUBSECTION.split(',');
            for (a in subsection){
                checkValue(subsection[a]);
            }
        }
    });
}
function exitAssessment(){
   $('#main').html('<center><h3><img src="../../images/loader.gif"> Retrieving data.<br><br>This can take up to 30 seconds depending on your internet connection...<h3></center>');
    loadListOfAssignedPapers(0);
//     document.getElementById('ROW_616').scrollIntoView();
}
function checkValue(subSectionIdx){
    var sumtotal = 0;
    var tweight = 0;
    var uweight = 0;
    var qweight = 0;
    var value = 0;
    var calTotal = 0;
//     alert(subSectionIdx + ", " + $('.subsection_Input_'+subSectionIdx).length);
    $('.subsection_'+subSectionIdx+'[type="number"]').each(function(){

        tweight =  $(this).data('tweight');
        uweight =  $(this).data('uweight');
        qweight =  $(this).data('qweight');
        value = $(this).val()/100;
        sumtotal += (1 * uweight * qweight * value) || 0;
//         alert(value);
    });
//     alert($('.inputNumber').length);
    $('.subsection_'+subSectionIdx+'[type="checkbox"]').each(function(){
        tweight =  $(this).data('tweight');
        uweight =  $(this).data('uweight');
        qweight =  $(this).data('qweight');
        if($(this).is(":checked")){
            value = 1;
        } else {
            value = 0;
        }
        sumtotal += (1 * uweight * qweight * value) ||0;
    });

    $('#subSectionTotal_'+subSectionIdx).val(sumtotal);
    $('#subTotalFor_'+subSectionIdx).html(((sumtotal/uweight) * 100).toFixed(2) + '%');
    $('.mySectionTotal').each(function(){
         calTotal += ($(this).val() * 1) || 0;
    });

    $('#TotalForType').html((calTotal * 100).toFixed(2));
    return;
}
function saveAssessment(PkGradeIdx, status){
    var obj = {};
    $('.inputBinary').each(function(i){
        if ($(this).is(":checked")){
            obj[$(this).data('key')]=100
        } else {
            obj[$(this).data('key')]=0;
        }
    });
    $('.inputNumber').each(function(i){
        obj[$(this).data('key')]=$(this).val();
    });
    var value = 0
    value = $('#TotalForType').text();
    var jsonData = JSON.stringify( obj );
//     alert(jsonData);
//     return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'saveAssessment','act':'print','PkGradeIdx':PkGradeIdx,'value':value,'status':status,'jsonData':jsonData},
        success: function(str){
            alert(str);
            if (status == 3){
                $('#main').html('<center><h3><img src="../../images/loader.gif"> Retrieving data.<br><br>This can take up to 20 seconds depending on your internet connection...<h3></center>');
                loadListOfAssignedPapers(PkGradeIdx);
            }
        }
    });


}
function postComment(PkQuestionIdx, PkGradeIdx, PkTeamIdx){
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    var TxComment = encodeURIComponent(escapeVal($('#COMMENT_FOR_'+PkQuestionIdx).val(),"<br />"));
    var pkCommentIdx = $('#UPDATE_COMMENT_FOR_'+PkQuestionIdx).val();
    if (pkCommentIdx>0){
        $('#COMMENT_'+pkCommentIdx).remove();
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/judge.pl',
            data: {'do':'deleteComment','act':'print','PkCommentIdx':pkCommentIdx,'PkTeamIdx':PkTeamIdx},
            success: function(str){
                $('#COMMENT_'+pkCommentIdx).remove();
            }
        });
    }
//     $('#comment_section_for_'+PkQuestionIdx).append('<div class="w3-bar-item chat-container w3-small w3-display-container" style="padding: 3px!important; width: 100%;"><p>'+escapeVal($('#COMMENT_FOR_'+pkQuestionIdx).val(),"<br />")+'</p><span class="w3-button w3-display-topright">X</span></div>');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'postComment','act':'print','PkGradeIdx':PkGradeIdx, 'PkQuestionIdx':PkQuestionIdx,'TxComment':TxComment,'PkUserIdx':PkUserIdx,'BoShow':0,'PkTeamIdx':PkTeamIdx},
        success: function(str){
             $('#comment_section_for_'+PkQuestionIdx).prepend(str);
             closeForm(PkQuestionIdx);
             $('#COMMENT_FOR_'+PkQuestionIdx).val('');

            // $('#LIST_COMMENT_FOR_'+PkScoreItemIdx).prepend(str);
//             $('#COMMENT_FOR_'+PkScoreItemIdx).val('');
        }
    });
}
function deleteComment(PkCommentIdx){
    var jsYes = confirm ("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'deleteComment','act':'print','PkCommentIdx':PkCommentIdx},
        success: function(str){
            $('#COMMENT_'+PkCommentIdx).remove();
        }
    });
}
function showTemplateContent(PkQuestionIdx){
    $('#templateContent_for_'+PkQuestionIdx).toggle();

}
function loadComment(obj, PkQuestionIdx){
    var TxComment = $(obj).data('value');
    $('#COMMENT_FOR_'+PkQuestionIdx).val(TxComment);
    $('#templateContent_for_'+PkQuestionIdx).toggle();
}
function editQuestionComment(PkCommentIdx, pkQuestionIdx){
//
    $('#UPDATE_COMMENT_FOR_'+pkQuestionIdx).val(PkCommentIdx);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'editQuestionComment','act':'print','PkCommentIdx':PkCommentIdx},
        success: function(str){
            openForm(pkQuestionIdx,1);
            $('#COMMENT_FOR_'+pkQuestionIdx).val(str);
            $('#COMMENT_'+PkCommentIdx).hide();
        }
    });
}
function saveToTemplate(PkUserIdx, pkQuestionIdx){
    var title = prompt("Please enter a Title", "Template Name (50 Char Max)");
    if (!title){alert("ERROR\n\nNo Title"); return}
//     alert(title);
    var TxComment = encodeURIComponent(escapeVal($('#COMMENT_FOR_'+pkQuestionIdx).val(),"<br />"));
//     alert(PkUserIdx+", "+TxComment+", "+title+", "+pkQuestionIdx);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'saveToTemplate','act':'print','PkUserIdx':PkUserIdx,'TxComment':TxComment,'title':title,'pkQuestionIdx':pkQuestionIdx},
        success: function(str){
            $('#templateContent_for_'+pkQuestionIdx).prepend(str);
            alert("Template Saved as "+title);
//             alert(str);
        }
    });
}
function deleteThisTemplate(obj, PkTempIdx){
    var jsYes = confirm("You are about to delete this Template.  Click OK to continue.");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'deleteThisTemplate','act':'print','PkTempIdx':PkTempIdx},
        success: function(str){
            $(obj).closest('div').remove();
        }
    });
}
function updateComment(PkCommentIdx, PkScoreItemIdx){
    var TxComment = encodeURIComponent(escapeVal($('#TX_COMMENT_'+PkCommentIdx).val(),"<br />"));
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    if ($('#BO_SHOW_'+PkCommentIdx+':checkbox:checked').length){
        var BoShow=0;
    } else {
        var BoShow=1;
    }
    $('#MY_LIST_COMMENT_IDX_'+PkCommentIdx).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'updateComment','act':'print','PkScoreItemIdx':PkScoreItemIdx, 'PkCommentIdx':PkCommentIdx,'TxComment':TxComment,'PkUserIdx':PkUserIdx,'BoShow':BoShow},
        success: function(str){
//             alert(PkScoreItemIdx);
            $('#LIST_COMMENT_FOR_'+PkScoreItemIdx).prepend(str);
            deleteDiv('DIV_EDIT_COMMENTS');
        }
    });
}
function openSaveCommentToTemplate(PkScoreItemIdx){
    var location = $.cookie('LOCATION');
    var TxComment = encodeURIComponent(escapeVal($('#COMMENT_FOR_'+PkScoreItemIdx).val(),"<br />"));
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    var divName = "DIV_SAVE_COMMENTS_TEMPLATE";
    if ($('#'+divName).length == 0){
        $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="height:50%; width: 60%;z-index: 400"></div>');
    }
    $('#'+divName).center();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'openSaveCommentToTemplate','act':'print','PkUserIdx':PkUserIdx,'TxComment':TxComment},
        success: function(str){
            $('#'+divName).html(str);
            $('#TX_TITLE').focus();
        }
    });
}
function saveCommentToTemplate(PkUserIdx){
    var TxTitle = $('#TX_USER_TITLE').val();
    if (TxTitle == ''){alert("ERROR\n\nNo Title"); return}
    var TxComment = encodeURIComponent(escapeVal($('#TX_USER_COMMENT_'+PkUserIdx).val(),"<br />"));
    if ($('#BO_SHOW_'+PkUserIdx+':checkbox:checked').length){
        var BoShow=1;
    } else {
        var BoShow=0;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'saveCommentToTemplate','act':'print','PkUserIdx':PkUserIdx,'TxComment':TxComment,'BoShow':BoShow,'TxTitle':TxTitle},
        success: function(str){
            deleteDiv('DIV_SAVE_COMMENTS_TEMPLATE');
            alert(TxTitle+"\n\nSuccessfully saved to your personal template list");
        }
    });
}
function showTemplateList(PkScoreItemIdx){
    var divName = "DIV_OPEN_COMMENT_TEMPLATES";
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    if ($('#'+divName).length == 0){
        $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="height:70%; width: 50%; z-index: 400"></div>');
    }
    $('#'+divName).center();
//     alert(PkUserIdx+", "+PkScoreItemIdx);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'showTemplateList','act':'print','PkUserIdx':PkUserIdx,'PkScoreItemIdx':PkScoreItemIdx},
        success: function(str){
            $('#'+divName).html(str);
        }
    });
}

function loadThisTemplate(PkCommentTempIdx, PkScoreItemIdx){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'loadThisTemplate','act':'print','PkCommentTempIdx':PkCommentTempIdx},
        success: function(str){
            $('#COMMENT_FOR_'+PkScoreItemIdx).val(str);
            deleteDiv('DIV_OPEN_COMMENT_TEMPLATES');
        }
    });
}
function saveDraft(PkPaperIdx, boExit){
    var PkScoreItemIdx;
    $('.w3-comments').each(function(){
        if ($(this).val().length > 0){
            PkScoreItemIdx = $(this).data('key');
            postComment(PkScoreItemIdx,PkPaperIdx);
        }
    });
//     return;
    $('#pointsTag').html('***');
    var obj = {};
    $('.inputBinary').each(function(i){
        if ($(this).is(":checked")){
            obj[$(this).data('key')]=$(this).val();
        }
    });
    $('.inputNumber').each(function(i){
        obj[$(this).data('key')]=$(this).val();
    });
    var jsonData = JSON.stringify( obj );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'saveDraft','act':'print','jsonData':jsonData,'PkPaperIdx':PkPaperIdx},
        success: function(str){
            if (boExit==1){
                $('#main').html('Loading...');
                loadListOfAssignedPapers(PkPaperIdx);
                $('#myHeader').show();
                $('#scoreNav').hide();
            }
            $('#pointsTag').html(str);

        }
    });
}
function showSubmitReview(PkPaperIdx, from){
// $('.backButton').hide;
//     var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'showSubmitReview','act':'print','PkUserIdx':PkUserIdx,'PkPaperIdx':PkPaperIdx, 'from':from},
        success: function(str){
            $('#id01_content').html(str);

        }
    });
}
function viewScore(PkPaperIdx){
// $('.backButton').hide;
    var PkUserIdx = $.cookie('PK_USER_IDX');
    var PkUserIdx = $.cookie('PK_JUDGE_IDX');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'viewScore','act':'print','PkPaperIdx':PkPaperIdx},
        success: function(str){
            $('#id01_content').html(str);

        }
    });
}

function completeAssessment(PkPaperIdx){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'completeAssessment','act':'print','PkPaperIdx':PkPaperIdx},
        success: function(str){
            window.location.href="judge.html";
        }
    });
}

function cancelSubmit(){
    $('#id01').hide();
    $('#id01_content').html('');
//     $('.backButton').show();
}

function reopenPaper(PkPaperIdx, FkTeamIdx, FkScoreGroupIdx){
    var jsYes = confirm ("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/judge.pl',
        data: {'do':'reopenPaper','act':'print','PkPaperIdx':PkPaperIdx,'FkTeamIdx':FkTeamIdx,'FkScoreGroupIdx':FkScoreGroupIdx},
        success: function(str){
            $('#TD_ASSESSMENT_STATUS_'+FkTeamIdx).html(str);
            //window.location.href="judge.html";
        }
    });
}
function setPerfect(obj){
    $(".inputBinary").prop('checked', $(obj).prop('checked'));
    $('.inputBinary').each(function(){
        var fkSubSectionIdx = $(this).data('section');
        checkValue(fkSubSectionIdx);
        // alert($(this).data('section'));
    });
}