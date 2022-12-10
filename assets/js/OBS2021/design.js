    var d=document;
    var sid = $.cookie('SID');

// ----- DISTRIBUTE BY JUDGE ------------
function showListOfReports(userIDX,txType){
    var location = $.cookie('LOCATION');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showListOfReports','act':'print','location':location,'userIDX':userIDX,'txType':txType},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function addGradeCard(obj, teamIDX, txType, userIDX){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'addGradeCard','act':'print','location':location,'teamIDX':teamIDX,'txType':txType,'userIDX':userIDX},
        success: function(str){
            $(obj).closest('td').append(str)
        }
    });
}
function assignTeamToJudge(obj, PkGradeIdx, userIDX, teamIDX,txType){
//     $(obj).addClass('w3-disabled');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'assignTeamToJudge','act':'print','PkGradeIdx':PkGradeIdx,'userIDX':userIDX,'teamIDX':teamIDX},
        success: function(str){
            $('#'+txType+'_Judge_'+userIDX).append(str);
            $('.w3-team_'+teamIDX).addClass('w3-disabled');
        }
    });
}
function showDistributeByJudge(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showDistributeByJudge','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
            $('#backButton').off('click').on('click', function(){
                loadMainDesign();
            }).show();
        }
    });
}
function removePaperFromJudge(PkPaperIdx){
//     alert(PkPaperIdx);
    $('#PAPER_IDX_'+PkPaperIdx).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'removePaperFromJudge','act':'print','PkPaperIdx':PkPaperIdx},
        success: function(str){
            $('#PAPER_IDX_'+PkPaperIdx).remove();
        }
    });
}
function showAddTeamToJudge(PkUserIdx){
    var location = $.cookie('LOCATION');
    var divName = "DIV_LIST_OF_PAPERS";
    if ($('#'+divName).length == 0){
        $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="width: 70%;z-index: 400"></div>');
    }
    $('#'+divName).center();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showAddTeamToJudge','act':'print','PkUserIdx':PkUserIdx,'location':location},
        success: function(str){
//         alert(str);
            $('#'+divName).html(str);
        }
    });
}
function addTeamToJudge(PkTeamIdx, PkUserIdx, InNumber, col, PkScoreGroupIdx){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'addTeamToJudge','act':'print','PkScoreGroupIdx':PkScoreGroupIdx,'location':location,'PkUserIdx':PkUserIdx,'PkTeamIdx':PkTeamIdx,'InNumber':InNumber, 'col':col},
        success: function(str){
//             alert (str);
            $('#AVAIL_PAPER_'+col+'_IDX_'+PkTeamIdx).remove();
            $('#TD_COL_'+col+'_'+PkUserIdx).append(str);
        }
    });
}
//------ DISTRIBUTE BY TEAM -------------
function showDistributeByTeam(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showDistributeByTeam','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
            $('#backButton').off('click').on('click', function(){
                loadMainDesign();
            }).show();
        }
    });
}
function showListOfAvailableJudges(PkTeamIdx, PkScoreGroupIdx, TCell, col){
    var location = $.cookie('LOCATION');
    var divName = "DIV_LIST_OF_JUDGES";
    if ($('#'+divName).length == 0){
        $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="height:80%; width: 70%;z-index: 400"></div>');
    }
    $('#'+divName).center();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showListOfAvailableJudges','act':'print','PkTeamIdx':PkTeamIdx,'TCell':TCell,'PkScoreGroupIdx':PkScoreGroupIdx, 'col':col,'location':location},
        success: function(str){
//         alert(str);
            $('#'+divName).html(str);
        }
    });
}
function assignJudgeToTeam(PkUserIdx, PkTeamIdx, PkScoreGroupIdx, TCell, Judge, col){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'assignJudgeToTeam','act':'print','PkTeamIdx':PkTeamIdx,'PkUserIdx':PkUserIdx, 'PkScoreGroupIdx':PkScoreGroupIdx, 'Judge':Judge, 'TCell':TCell,'col':col,'location':location},
        success: function(str){
//             alert(str);
            $('#'+TCell).html(str);
            deleteDiv('DIV_LIST_OF_JUDGES');
        }
    });
}
function removeJudgeFromPaper(PkPaperIdx, PkScoreGroupIdx, PkTeamIdx, TCell, col){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'removeJudgeFromPaper','act':'print','PkPaperIdx':PkPaperIdx, 'PkTeamIdx':PkTeamIdx, 'PkScoreGroupIdx':PkScoreGroupIdx, 'TCell':TCell,'col':col},
        success: function(str){
            $('#'+TCell).html(str);
        }
    });
}
// ----- FILE UPLOAD --------------------
function showTeamFileList(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showTeamFileList','act':'print','location':location},
        success: function(str){
//             alert(str)
            $('#main').html(str);
            $('#backButton').off('click').on('click', function(){
                loadMainDesign();
            }).show();
        }
    });
}
function showFileUploadForm(PkTeamIdx){

    var location = $.cookie('LOCATION');
//     var divName = "DIV_FILE_UPLOAD_FORM";
//     if ($('#'+divName).length == 0){
//         $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="width: 70%;z-index: 400"></div>');
//     }
//     $('#'+divName).center();
    $('#FILE_UPLOAD_OBJECT').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showFileUploadForm','act':'print','PkTeamIdx':PkTeamIdx, 'location':location},
        success: function(str){
//         alert(str);
            $('#uploadFileForm').html(str).center;
//             $('#uploadFileForm').html(str);
//             $('#FILE_UPLOAD_OBJECT').show().center();

        }
    });

}
$( d ).ready(function (e) {
    $("#uploadFileForm").on('submit',(function(e) {
        var formData = new FormData(this);
        e.preventDefault();
//         alert(formData);
        var teamIDX = $('#teamIDX').val();
        var eventIDX = $('#eventIDX').val();

        $('#loading').show();
        $.ajax({
            url: "fileUpload.php", // Url to which the request is send
            type: "POST",             // Type of request to be send, called as method
            data: new FormData(this), // Data sent to server, a set of key/value pairs (i.e. form fields and values)
            contentType: false,       // The content type used when sending data to the server.
            cache: false,             // To unable request pages to be cached
            processData:false,        // To send DOMDocument or non processed data file it is set to false
            success: function(str)   {
                var report = $('#report').val()
                var reportName = report.replace(/^.*\\/, "");
                var tds = $('#tds').val()
                var tdsName = tds.replace(/^.*\\/, "");
                var drawing = $('#drawing').val()
                var drawingName = drawing.replace(/^.*\\/, "");

                if ($('#report').val()){
                    $('#TD_TX_REPORT_'+teamIDX).html('<a class="w3-large fa fa-file-pdf-o" style="float: left;" href="download.php?fileID='+$('#reportCode').val()+'" target="_blank">&nbsp;&nbsp;'+reportName+'</a>');
                    createGradeRecords(teamIDX,'report',3);
                    createGradeRecords(teamIDX,'requirements',1);
                }
                if ($('#tds').val()) {
                    $('#TD_TX_TDS_'+teamIDX).html('<a class="w3-large fa fa-file-pdf-o" style="float: left;" href="download.php?fileID='+$('#tdsCode').val()+'" target="_blank">'+tdsName+'</a>');
                    createGradeRecords(teamIDX,'tds',1);
                }
                if ($('#drawing').val()) {
                    $('#TD_TX_DRAWING_'+teamIDX).html('<a class="w3-large fa fa-file-pdf-o" style="float: left;" href="download.php?fileID='+$('#drawingCode').val()+'" target="_blank">'+drawingName+'</a>');
                    createGradeRecords(teamIDX,'drawing',1);
                }
                $('#loading').hide();
                $("#message").html(str);
                $('#loading').hide();

            },
            error: function(xhr, textStatus, errorThrown){
                alert(textStatus + ': Request failed ' + errorThrown);
            }

        });
    }));
});
function createGradeRecords(PkTeamIdx, txType, count){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'createGradeRecords','act':'print','PkTeamIdx':PkTeamIdx, 'txType':txType,'count':count},
        success: function(str){
//             alert(str);
        }
    });
}
function hideFileUploadDiv(){
    $('#FILE_UPLOAD_OBJECT').hide();
}
function removeFileFromTeam(PkUploadIdx, target){
//     alert(PkUploadIdx+" "+target);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'removeFileFromTeam','act':'print','PkUploadIdx':PkUploadIdx},
        success: function(str){
            $('#'+target).html(str);
            $('#LI_'+PkUploadIdx).remove();
        }
    });
}
function showRemoveFiles(PkTeamIdx){
    var location = $.cookie('LOCATION');
    var divName = "DIV_LIST_FILE_TO_REMOVE";
    if ($('#'+divName).length == 0){
        $('html').prepend('<div ID="'+divName+'" class="editTeamDiv" style="width: 50%;z-index: 400"></div>');
    }
    $('#'+divName).center();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showRemoveFiles','act':'print','PkTeamIdx':PkTeamIdx,'location':location},
        success: function(str){
//         alert(str);
            $('#'+divName).html(str);

        }
    });

}
function showReportSummaryAdmin(PkPaperIdx, from){
//     alert("here");
    var PkUserIdx = $.cookie('PK_USER_IDX');
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
function removeScoreCard(obj, PkGradeIdx){
    $(obj).closest('li').remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'removeScoreCard','act':'print','PkGradeIdx':PkGradeIdx},
        success: function(str){
//             alert(PkGradeIdx);
//             $('#'+txType+'_Judge_'+PkTeamIdx).append(str);
        }
    });
}
function addAScoreCard(PkTeamIdx, txType){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'addAScoreCard','act':'print','PkTeamIdx':PkTeamIdx, 'txType':txType},
        success: function(str){
            $('#'+txType+'_Judge_'+PkTeamIdx).append(str);
        }
    });
}

window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
    $('#myBtn').show();
//     $('.float').show();
//     document.getElementById("myBtn").style.display = "block";
  } else {
  $('#myBtn').hide();
//   $('.float').hide();
//     document.getElementById("myBtn").style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}
function showListOfJudges(PkGradeIdx, teamIDX, txType ){

    var location = $.cookie('LOCATION');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'showListOfJudges','act':'print','location':location,'PkGradeIdx':PkGradeIdx,'teamIDX':teamIDX,'txType':txType},
        success: function(str){
            $('#id01_content').html(str);
//             alert(PkGradeIdx);
        }
    });
}
function addJudgeToCard(userIDX, PkGradeIdx, JudgeName){
    $('#img_'+PkGradeIdx).attr('src','images/Judge.png');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'addJudgeToCard','act':'print','PkGradeIdx':PkGradeIdx,'userIDX':userIDX,'JudgeName':JudgeName},
        success: function(str){
            $('#JUDGE_FOR_'+PkGradeIdx).html(str);
            closeModal('id01');
        }
    });
}
// function openJudgeAssignmentDetails(userIDX){
//     var location = $.cookie('LOCATION');
//     $('#id02').show();
// }

function updateMarkdownFactor(obj, teamIDX){
    var myfactor = $(obj).val();
    alert("Markdown factor update to: "+ myfactor);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'updateMarkdownFactor','act':'print','teamIDX':teamIDX,'factor':myfactor},
        success: function(str){
            // $('#LIST_USER_'+PkUserIdx).remove();
        }
    });
}

function updateDaysLate(obj, teamIDX){
    var inLate = $(obj).val();
    alert("Days late update to: "+ inLate);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/design.pl',
        data: {'do':'updateDaysLate','act':'print','teamIDX':teamIDX,'inLate':inLate},
        success: function(str){
            // $('#LIST_USER_'+PkUserIdx).remove();
        }
    });
}