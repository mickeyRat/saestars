    var d=document;
    var sid = $.cookie('SID');

function showMicroClassDemoPage(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/demo.pl',
        data: {'do':'showMicroClassDemoPage','act':'print','location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function sae_showImportDemoSchedule(){
    var divName = 'TEMP_DIV_TEAM_SCHEUDLE';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Import Demo Schedule</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/demo.pl',
        data: {'do':'sae_showImportDemoSchedule','act':'print','location':location,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_importDemoScheduleFile(divName){
    var formData = new FormData();
    var location = $.cookie('LOCATION');
    formData.append('csvFile', $('input[type=file]')[0].files[0]); 
    formData.append('location',location);
    formData.append('do','sae_importDemoScheduleFile');
    formData.append('act','print');
    // formData.append('location',location);
    $.post({
        type: 'POST',
        url: '../cgi-bin/demo.pl',
        data: formData,
        contentType: false, // NEEDED, DON'T OMIT THIS (requires jQuery 1.6+)
        processData: false, // NEEDED, DON'T OMIT THIS
        success: function(str){
            console.log("str = "+ str)
            $('#sae_results').html(str);
            $('#'+divName).remove();
            alert("File Imported");
            showMicroClassDemoPage();
        }
    });
}
function sae_openMicroDemo(teamIDX){
    var divName = 'TEMP_DIV_ASSEMBLY_DEMO';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Micro Class Assembly Demo</b>',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/demo.pl',
        data: {'do':'sae_openMicroDemo','act':'print','location':location,'teamIDX':teamIDX, 'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_submitMicroDemo(teamIDX, divName){
    var location = $.cookie('LOCATION');
    var inSeconds = $('#MICRO_IN_SECONDS').val();
    if (inSeconds==0 || inSeconds===''){
        $('#MICRO_IN_SECONDS').focus();
        alert('Invalid Time Entered');
        return;

    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/demo.pl',
        data: {'do':'sae_submitMicroDemo','act':'print','location':location,'teamIDX':teamIDX,'inSeconds':inSeconds},
        success: function(str){
            // console.log(str);
            var data = JSON.parse(str);
            $('#TD_TEAM_TODO_STATUS_'+teamIDX).html(data.HTML);
            $('#TD_TEAM_DEMO_SCORE_'+teamIDX).html(data.SCORE);
            $('#'+divName).remove();

        }
    });
}
//     alert($.cookie('SID') + "\n" + $.cookie('LOCATION')+ "\n" + $.cookie('TYPE')+ "\n" + $.cookie('PK_USER_IDX'));
// ====================== 2019 =============================
// function showDemoMain(){
//     var location = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'showDemoMain','act':'print','location':location},
//         success: function(str){
//             $('#main').html(str);
//         }
//     });
// }
// function openDemoCard(PkTeamIdx, FkClassIdx){
//     var location = $.cookie('LOCATION');
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'openDemoCard','act':'print','location':location,'PkTeamIdx':PkTeamIdx,'FkClassIdx':FkClassIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//             $('[tabindex=1]').focus();
//         }
//     });
// }
// function updateDemoScoreCard(PkTeamIdx, PkGradeIdx, FkClassIdx){
//     var location = $.cookie('LOCATION');
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'updateDemoScoreCard','act':'print','location':location,'PkGradeIdx':PkGradeIdx,'PkTeamIdx':PkTeamIdx,'FkClassIdx':FkClassIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//             $('[tabindex=1]').focus();
//         }
//     });
// }

// function saveDemoInputs(PkTeamIdx, FkClassIdx,close,PkGradeIdx){
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var obj = {};
//     $('.inputBinary').each(function(i){
//         if ($(this).is(":checked")){
//             obj[$(this).data('key')]=100
//         } else {
//             obj[$(this).data('key')]=0;
//         }
//     });
//     $('.inputNumber').each(function(i){
//         obj[$(this).data('key')]=$(this).val();
//     });
//     var jsonData = JSON.stringify( obj );
// //     alert(jsonData);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'saveDemoInputs','act':'print','PkTeamIdx':PkTeamIdx,'PkUserIdx':PkUserIdx,'FkClassIdx':FkClassIdx,'PkGradeIdx':PkGradeIdx,'jsonData':jsonData},
//         success: function(str){
//             if (close==1) {
//                 $('#btn_demo_score_card_'+PkGradeIdx).remove();
//             }
//             $('#TD_DEMO_ROW_FOR_'+PkTeamIdx).append(str);
//             closeModal('id01');
//             $('#BTN_DEMO_ADD_CARD_'+PkTeamIdx).addClass('w3-disabled');
//         }
//     });
// }
// function deleteDemoCard(PkGradeIdx, PkTeamIdx){
//     var jsYes = confirm("Click OK to confirm that you want to delete this Demonstration Score Card.");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'deleteDemoCard','act':'print','PkGradeIdx':PkGradeIdx},
//         success: function(str){
//             $('#btn_demo_score_card_'+PkGradeIdx).remove();
//             $('#BTN_DEMO_ADD_CARD_'+PkTeamIdx).removeClass('w3-disabled');
//             closeModal('id01');
//         }
//     });
// }


// // ===================== 2018 ========================================
// function showDemoAssessment(PkTeamIdx){
//     $('#TEAM_DEMO_'+PkTeamIdx).toggleClass('w3-show');
// }

// function cleanClass(PkTeamIdx){
//     $('#TEAM_DEMO_STATUS_'+PkTeamIdx).removeClass('w3-white w3-text-grey w3-red w3-yellow w3-green w3-text-white w3-text-black');
// }

// function submitRegularClassDemo(PkTeamIdx){
//     var location = $.cookie('LOCATION');
//     var loadingTime = $('#REG_DEMO_LOAD_TIME_'+PkTeamIdx).val();
//     var unLoadingTime = $('#REG_DEMO_UNLOAD_TIME_'+PkTeamIdx).val();
//     if (loadingTime == 0 || unLoadingTime==0){
//         alert("Invalide Time Entry");
//         return;
//     }
//     cleanClass(PkTeamIdx);
//     if (loadingTime <=60 && unLoadingTime<=60){
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-green w3-text-white').html('PASS');
//     } else if ((loadingTime <=60 && unLoadingTime > 60) || (loadingTime > 60 && unLoadingTime<=60) ) {
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-yellow w3-text-black').html('PARTIAL');
//     } else {
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-red w3-text-white').html('FAIL');
//     }
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'submitRegularClassDemo','act':'print','location':location, 'PkTeamIdx':PkTeamIdx,'loadingTime':loadingTime,'unLoadingTime':unLoadingTime},
//         success: function(str){
// //             $('#main').html(str);
//             alert("Successfully Saved to the Database.");
//             showDemoAssessment(PkTeamIdx);
//         }
//     });
// }
// function submitAdvancedClassDemo(PkTeamIdx, InStatus){
//     var location = $.cookie('LOCATION');
//     cleanClass(PkTeamIdx);
//     if (InStatus==1) {
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-green w3-text-white').html('PASS');
//     } else {
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-red w3-text-white').html('FAIL');
//     }
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'submitAdvancedClassDemo','act':'print','location':location, 'PkTeamIdx':PkTeamIdx,'InStatus':InStatus},
//         success: function(str){
//             alert(str);
//             showDemoAssessment(PkTeamIdx);
//         }
//     });
// }
// function saveAssemblyDemo(PkTeamIdx){
//     var location = $.cookie('LOCATION');

//     cleanClass(PkTeamIdx);
//     var demoTime = $('#IN_ASSEMBLY_TIME_'+PkTeamIdx).val();
//     if (demoTime < 1){
//         alert("Invalid Time Entry.");
//         return
//     }
//     if (demoTime <= 180){
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-green w3-text-white').html('PASS');
//         var InStatus = 1;
//     } else {
//         $('#TEAM_DEMO_STATUS_'+PkTeamIdx).addClass('w3-red w3-text-white').html('FAIL');
//         var InStatus = 0;
//     }
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/demo.pl',
//         data: {'do':'saveAssemblyDemo','act':'print','location':location, 'PkTeamIdx':PkTeamIdx,'InStatus':InStatus, 'demoTime':demoTime},
//         success: function(str){
//             alert(str);
//             showDemoAssessment(PkTeamIdx);
//         }
//     });
// }

// function convertSecond( obj , PkTeamIdx){
//     var time = obj.value;
//     var minutes =Math.floor(obj.value/60);
//     var seconds = time - minutes * 60;
//     var finalTime = str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
//     $('#MICRO_TIME_DISPLAY_'+PkTeamIdx).html(finalTime);
// }

// function str_pad_left(string,pad,length) {
//     return (new Array(length+1).join(pad)+string).slice(-length);
// }
