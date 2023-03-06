var d=document;
var now = new Date();
var time = now.getTime();
// var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';

// -----------------------------------------------------------------------------------------------------------
var pStart = {x: 0, y:0};
var pStop = {x:0, y:0};

function swipeStart(e) {
    if (typeof e.targetTouches !== "undefined"){
        var touch = e.targetTouches[0];
        pStart.x = touch.screenX;
        pStart.y = touch.screenY;
    } else {
        pStart.x = e.screenX;
        pStart.y = e.screenY;
    }
}

function swipeEnd(e){
    if (typeof e.changedTouches !== "undefined"){
        var touch = e.changedTouches[0];
        pStop.x = touch.screenX;
        pStop.y = touch.screenY;
    } else {
        pStop.x = e.screenX;
        pStop.y = e.screenY;
    }
    swipeCheck();
}

function swipeCheck(){
    var changeY = pStart.y - pStop.y;
    var changeX = pStart.x - pStop.x;
    var ipage = $.cookie('page');
    // console.log("page="+ipage+","+changeY+","+changeX+" "+isPullDown(changeY, changeX));
    if (isPullDown(changeY, changeX) ) {
        if (ipage == 25){
            sae_flightOperations();
            console.log ("page = "+page);
        } else if (ipage === 0) {
            sae_loadHomePage(0);
        } else if (ipage == 27) {
            openCrashReinspection();
        } else if (ipage == 32) {
            sae_openTeamNotesList();
        }
    }
}

function isPullDown(dY, dX) {
    // methods of checking slope, length, direction of line created by swipe action 
    return dY < 0 && (
        (Math.abs(dX) <= 100 && Math.abs(dY) >= 100)
        || (Math.abs(dX)/Math.abs(dY) <= 0.3 && dY >= 60)
    );
}

document.addEventListener('touchstart', function(e){ swipeStart(e); }, false);
document.addEventListener('touchend', function(e){ swipeEnd(e); }, false);
// -----------------------------------------------------------------------------------------------------------
function loadMenuItems(){
    var userIDX = $.cookie('PK_USER_IDX');
    // console.log("user Type=" + $.cookie('TYPE'));
    $.cookie('page',0);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':'loadMenuItems','act':'print','userIDX':userIDX},
        success: function(str){
            $('#menuItem').html(str);
        }
    });
}
function mainMenuItemClick(menuItem, obj){
    var userIDX = $.cookie('userIDX');
    // if (cardUpdate || menuItem!=9){
    //     clearInterval(cardUpdate);
    //     cardUpdate = false;
    //     console.log("Clear setInterval");
    // }
    
    $('.sae-menu_item').removeClass('w3-blue');
    $('#MENUITEM_'+menuItem).addClass('w3-blue');
    // alert(menuItem);
    $.cookie('page',menuItem);
    switch(menuItem) {
        case 1: // Assess Report
            openReportItems('ManageReportAssessments', userIDX, 1);
            break;
        case 2: // Assess TDS
        //   openMenuItem('ManageTDSAssessments');
            openReportItems('ManageReportAssessments', userIDX, 2);
            break;
        case 3: // Assess Drawings
        //   openMenuItem('ManageDrawingAssessments');
            openReportItems('ManageReportAssessments', userIDX, 3);
            break;
        case 4: // Assess Requirements
        //   openMenuItem('ManageRequirementAssessments');
            openReportItems('ManageReportAssessments', userIDX, 4);
            break;
        case 5: // Tech Inspections
            showListOfTeam_Tech();
          // code block
            break;
        case 6: // Demo - Micro Class
            showMicroClassDemoPage();
          // code block
            break;
        case 7: // Presentations
            showListOfTeam_Preso('number');
          // code block
            break;
        case 8: // Penalties
          // code block
          break;
        case 9: // Flights
            showFlightTable();
          // code block
            break;
        case 10: // Overall
          // code block
            break;
        case 12: // Publish 
            showPublishPage();
            break;
        case 13: // Manager Users
            sae_openManageUsers();
            break;
        case 18: // Manager Papers
            openManagePapers();
            // openMenuItem('ManagePapers');
            // loadTabContent('ManagePapers_divTeam_view');
            break; 
        case 19: // Manage Report Rubric
            openRubricHome('rubricHomePage');
            break;
        case 20: // Manager Papers
            openFileUpload('openUploadDiv');
            break; 
        case 21: // Manager Teams
            openManageteam();
            // openMenuItem('ManageTeams');
            break; 
        case 22: //Online ECRs (ecr.js)
            sae_openECR();
            break; 
        case 23: //Online ECRs (ecr.js)
            sae_openWeather(4);
            break; 
        case 25: //Online ECRs (ecr.js)
            sae_flightOperations();
            break; 
        case 26: //ManageJudges
            openManageJudges(4);
            break; 
        case 27: //Crash Reinspection
            openCrashReinspection();
            break; 
        case 28: //Presentation Batch Upload
            window.open("preso_upload.html?location="+$.cookie('LOCATION'), "preso_upload", "width=600, height=600, toolbar=no, scrollbars=yes, resizable=yes");
            break;
        case 29: //Change Event Location
            sae_showModalEventSelection();
            break; 
        case 30: //show User Profile
            sae_showUserProfile(); // main2.js ---> main2.pl
            break; 
        case 31: //show Published Results
            sae_viewPublishedResults(); // publish.js ---> results.pl
            console.log(menuItem + 'sae_viewPublishedResults');
            break; 
        case 32: //show Published Results
            sae_openTeamNotesList(); // airboss.js ---> airboss.pl
            // console.log("test");
            break; 
        case 33: //show Published Results
            window.open("scan.html");
            // console.log("test");
            break; 
        case 34: //Open Tech Inspection Module
            openInspectionModule();
            // console.log("test");
            break; 
        default:
          // code block
      }
}
function openInspectionModule(){
    // $('#mainPageContent').html(loading);
    var eventIDX   = $.cookie('FK_EVENT_IDX');
    var inUserType = $.cookie('IN_USER_TYPE');
    // console.log(inUserType);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'openInspectionModule','act':'print','eventIDX':eventIDX,'inUserType':inUserType},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function openCrashReinspection(){
    // $('#mainPageContent').html(loading);
    var location = $.cookie('LOCATION');
    var inShowAll = $.cookie('showAllInspection');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/tech.pl',
        data: {'do':'openCrashReinspection','act':'print','location':location,'inShowAll':inShowAll},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function openManagePapers(){
    $('#mainPageContent').html(loading);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/paper.pl',
        // url: '../cgi-bin/main2.pl',
        data: {'do':'paper_openManagePapers','act':'print','location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}

function sae_flightOperations(){
    var location = $.cookie('LOCATION');
    var filter = $.cookie('FILTER');
    if (filter===''){filter=0}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_flightOperations', 'act':'print','location':location,'filter':filter},
        success: function(str){
            // console.log(str);
            $('#mainPageContent').html(str);
        }
    });
}

function openRubricHome(toDo){
    // var location = $.cookie('LOCATION');
    // alert(toDo);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':toDo, 'act':'print'},
        success: function(str){
            // alert(str);
            $('#mainPageContent').html(str);
        }
    });
}
function sae_openManageUsers(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'sae_openManageUsers','act':'print', 'location': location },
        success: function(str){
            // console.log(str);
            // alert(str);
            $('#mainPageContent').html(str);
        }
    });   
}

function openManageJudges(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/user.pl',
        data: {'do':'openManageJudges','act':'print', 'location': location,'eventIDX':location },
        success: function(str){
            // console.log(str);
            // alert(str);
            $('#mainPageContent').html(str);
        }
    });  
}

function openReportItems(toDo, userIDX, inType){
    var location = $.cookie('LOCATION');
    // alert(toDo+", "+userIDX+", "+inType);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/grade.pl',
        data: {'do':toDo,'act':'print','userIDX':userIDX ,'inType':inType , 'location': location },
        success: function(str){
            // alert(str);
            $('#mainPageContent').html(str);
        }
    });
}
function openManageteam(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/team.pl',
        data: {'do':'openManageteam','act':'print','location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function openMenuItem(toDo){
    // alert(toDo);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/main2.pl',
        data: {'do':toDo,'act':'print','location':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function openFileUpload(toDo){
    var location=$.cookie("LOCATION");
    window.open("upload.html?location="+location, "_blank", "width=600, height=600, toolbar=no, scrollbars=yes, resizable=yes");
}
// function showPublishPage(){
//     var location = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/results.pl',
//         data: {'do':'showPublishPage','act':'print','location':location},
//         success: function(str){
//             $('#mainPageContent').html(str);
//         }
//     });
// }
function showPublishPage(){
    var location = $.cookie('LOCATION');
    var userIDX =  $.cookie('userIDX');
    // console.log(userIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/publish.pl',
        data: {'do':'showPublishPage','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
