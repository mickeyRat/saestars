
    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();

//  alert("test 4" + time);
// $( d ).ready(function(){
// // alert("test 3");
// //     var userType = $.cookie('TYPE');
// //     var PkTeamIdx = $.cookie('PK_TEAM_IDX');
// //     var PkUserIdx = $.cookie('PK_USER_IDX');
// // //     alert(PkUserIdx);

// // //     loadFeed();
// //     if ($.cookie('expire') === null || $.cookie('expire') < time) {
// //         alert('Your session expired.  Please log in again');
// //         signOutAdmin();
// //     } else if ($.cookie('SID') && userType != '0'){
// //         signOutAdmin();
// //     } else {
// // //         alert ($.cookie('SID'));
// //     loadLeftPanel();
// //     }
// });
// ============ Pull Down Refresh ======================

// ========== 2022 ==================================
    function student_openRequirementsChecks (o, teamIDX, classIDX) {
        var eventIDX = $.cookie('LOCATION');
        var userIDX = $.cookie('PK_USER_IDX');
        $.modal('Requirement Checks', '97%');
        // $('#modal_content').html(teamIDX); 
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_openRequirementsChecks','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'userIDX':userIDX,'classIDX':classIDX},
            success: function(str){
                $('#modal_content').html(str);
            }
        });
        }
    function student_openSafetyChecks (o, teamIDX, classIDX) {
        var eventIDX = $.cookie('LOCATION');
        var userIDX = $.cookie('PK_USER_IDX');
        $.modal('Safety & Airworthiness Checks', '97%');
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_openSafetyChecks','act':'print','eventIDX':eventIDX,'teamIDX':teamIDX,'userIDX':userIDX,'classIDX':classIDX},
            success: function(str){
                $('#modal_content').html(str);
            }
        });

        }
    function student_updateCheckItem (o, teamIDX) {
        var userIDX = $.cookie('PK_USER_IDX');
        var inStatus = 0;
        if ($(o).is(':checked')){
            inStatus= 1;
        } 
        var itemIDX = $(o).data('index');
        $.ajax({
            type: 'POST',
            url: '../cgi-bin/student.pl',
            data: {'do':'student_updateCheckItem','act':'print','teamIDX':teamIDX,'userIDX':userIDX,'itemIDX':itemIDX,'inStatus':inStatus},
            success: function(str){
                // $('#modal_content').html(str);
                // console.log(str);
            }
        });

            console.log(data);
        // body...
        }
// ==================================================
// function loadFeed(list){
//     var location = $.cookie('LOCATION');
//     var PkUserIdx = $.cookie('PK_USER_IDX');

//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'loadFeed','act':'print','PkUserIdx':PkUserIdx, 'location':location,'list':list},
//         success: function(str){
//             $('#middleContent').html(str);
//         }
//     });
// }
// function loadLeftPanel(){
//     var location = $.cookie('LOCATION');
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'loadLeftPanel','act':'print','PkUserIdx':PkUserIdx, 'location':location},
//         success: function(str){
// //         alert(str);
//             var data = JSON.parse(str);
//             $('#leftContent').html(data.HTML);
//             loadFeed(data.LIST);
//         },
//         error: function(i, err){
//             aleft (err);
//         }
//     });
// }
// function toggleViewPassword(obj){
//     var type = $("#myTeamCode").attr("type");
//     if (type == "text"){
//       $("#myTeamCode").attr('type','password');
//       $(obj).removeClass('fa-eye').addClass('fa-eye-slash');
//     } else{
//       $("#myTeamCode").attr('type','text');
//       $(obj).addClass('fa-eye').removeClass('fa-eye-slash');
//     }
// }
// function hideAddTeamCodeEntry(){
//     $("#myTeamCode").val('')
//     $('.teamCodeEntry').hide(50);


// }
// function showAddTeamCodeEntry(){
//     $('.teamCodeEntry').toggle(50);
//     $("#myTeamCode").val('').focus();
// }
// function submitTeamCode(PkUserIdx){
//     var location = $.cookie('LOCATION');
//     var txTeamCode = $('#myTeamCode').val();
//     if (txTeamCode == ''){return}
// //     alert(txTeamCode);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'submitTeamCode','act':'print','txTeamCode':txTeamCode, 'PkUserIdx':PkUserIdx, 'location':location},
//         success: function(str){
//             var dat = JSON.parse(str);
//             if (dat.TEAM>0){
//                 $('#teamMembershipList').html(dat.DATA);
//                 hideAddTeamCodeEntry();
//                 $('#teamMembershipOverview').html(dat.OVERVIEW);
//             } else {
//                 alert(dat.DATA);
//             }
//         },
//         error: function(XMLHttpRequest, textStatus, errorThrown){
//             alert(XMLHttpRequest, textStatus, errorThrown);
//         }
//     });
// }
// function unsubscribeTeam(PkTeamIdx, PkUserIdx){
//     var jsYes = confirm("Select OK to confirm that you no longer wish to subscribe to this team's scoring information.");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'unsubscribeTeam','act':'print','PkTeamIdx':PkTeamIdx, 'PkUserIdx':PkUserIdx},
//         success: function(str){
// //             alert(str);
//             if (str>0){
//                 $('.subscription_'+PkTeamIdx).remove();
//             }
//         }
//     });
// }




// function addTeam(){
//   var x = document.getElementById("leftContent");
//   if (x.style.display === "none")
//   {
//    x.style.display = "block";
//   } else
//   {
//    w.style.display = "none";
//   }
// }
