
    var d=document;
    var sid = $.cookie('SID');
    var now = new Date();
    var time = now.getTime();

//  alert("test 4" + time);
$( d ).ready(function(){
// alert("test 3");
    var userType = $.cookie('TYPE');
    var PkTeamIdx = $.cookie('PK_TEAM_IDX');
    var PkUserIdx = $.cookie('PK_USER_IDX');
//     alert(PkUserIdx);

//     loadFeed();
    if ($.cookie('expire') === null || $.cookie('expire') < time) {
        alert('Your session expired.  Please log in again');
        signOutAdmin();
    } else if ($.cookie('SID') && userType != '0'){
        signOutAdmin();
    } else {
//         alert ($.cookie('SID'));
    loadLeftPanel();
    }
});
// ============ Pull Down Refresh ======================

// ==================================================
function loadFeed(list){
    var location = $.cookie('LOCATION');
    var PkUserIdx = $.cookie('PK_USER_IDX');

    $.ajax({
        type: 'POST',
        url: '../cgi-bin/student.pl',
        data: {'do':'loadFeed','act':'print','PkUserIdx':PkUserIdx, 'location':location,'list':list},
        success: function(str){
            $('#middleContent').html(str);
        }
    });
}
function loadLeftPanel(){
    var location = $.cookie('LOCATION');
    var PkUserIdx = $.cookie('PK_USER_IDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/student.pl',
        data: {'do':'loadLeftPanel','act':'print','PkUserIdx':PkUserIdx, 'location':location},
        success: function(str){
//         alert(str);
            var data = JSON.parse(str);
            $('#leftContent').html(data.HTML);
            loadFeed(data.LIST);
        },
        error: function(i, err){
            aleft (err);
        }
    });
}
function toggleViewPassword(obj){
    var type = $("#myTeamCode").attr("type");
    if (type == "text"){
      $("#myTeamCode").attr('type','password');
      $(obj).removeClass('fa-eye').addClass('fa-eye-slash');
    } else{
      $("#myTeamCode").attr('type','text');
      $(obj).addClass('fa-eye').removeClass('fa-eye-slash');
    }
}
function hideAddTeamCodeEntry(){
    $("#myTeamCode").val('')
    $('.teamCodeEntry').hide(50);


}
function showAddTeamCodeEntry(){
    $('.teamCodeEntry').toggle(50);
    $("#myTeamCode").val('').focus();
}
function submitTeamCode(PkUserIdx){
    var location = $.cookie('LOCATION');
    var txTeamCode = $('#myTeamCode').val();
    if (txTeamCode == ''){return}
//     alert(txTeamCode);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/student.pl',
        data: {'do':'submitTeamCode','act':'print','txTeamCode':txTeamCode, 'PkUserIdx':PkUserIdx, 'location':location},
        success: function(str){
            var dat = JSON.parse(str);
            if (dat.TEAM>0){
                $('#teamMembershipList').html(dat.DATA);
                hideAddTeamCodeEntry();
                $('#teamMembershipOverview').html(dat.OVERVIEW);
            } else {
                alert(dat.DATA);
            }
        },
        error: function(XMLHttpRequest, textStatus, errorThrown){
            alert(XMLHttpRequest, textStatus, errorThrown);
        }
    });
}
function unsubscribeTeam(PkTeamIdx, PkUserIdx){
    var jsYes = confirm("Select OK to confirm that you no longer wish to subscribe to this team's scoring information.");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/student.pl',
        data: {'do':'unsubscribeTeam','act':'print','PkTeamIdx':PkTeamIdx, 'PkUserIdx':PkUserIdx},
        success: function(str){
//             alert(str);
            if (str>0){
                $('.subscription_'+PkTeamIdx).remove();
            }
        }
    });
}




function addTeam(){
  var x = document.getElementById("leftContent");
  if (x.style.display === "none")
  {
   x.style.display = "block";
  } else
  {
   w.style.display = "none";
  }
}



// function loadSetTeam(){
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var location = $.cookie('LOCATION');
// //     alert("here");
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'loadSetTeam','act':'print','PkUserIdx':PkUserIdx, 'location':location},
//         success: function(str){
// //             alert(str);
// //             $.cookie('PK_TEAM_IDX', str);
//             $('#main').html(str);
//         }
//     });
// }
//
// function loadMainPage(){
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var location = $.cookie('LOCATION');
//     var PkTeamIdx = $.cookie('PK_TEAM_IDX');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'loadMainPage','act':'print','PkUserIdx':PkUserIdx, 'location':location, 'PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#main').html(str);
//         }
//     });
// }
//
// function subscribeToATeam(PkUserIdx){
//     var TxCode = $('#TX_TEAM_CODE').val();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'subscribeToATeam','act':'print','PkUserIdx':PkUserIdx, 'TxCode':TxCode},
//         success: function(str){
//             if (str){
//                 $('#main').append(str);
//                 $('#TX_TEAM_CODE').val("");
//                 alert("Successfully subscribed to your team.");
//             } else {
//                 alert('Invalid Code');
//             }
//         }
//     });
// }
//
// function deleteTile(TileIdx){
//     var jsYes = confirm("Are you sure?");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'deleteTile','act':'print','TileIdx':TileIdx},
//         success: function(str){
//              $('#TILE_'+TileIdx).remove();
//         }
//     });
// }
// function setTeam(PkTeamIdx){
// //     alert(PkTeamIdx);
//     $.cookie('PK_TEAM_IDX',PkTeamIdx);
//     loadMainPage();
// }
// function viewDesignScore(PkTeamIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'viewDesignScore','act':'print', 'PkTeamIdx':PkTeamIdx},
//         success: function(str){
// //             alert(str);
//             $('#id01_content').html(str);
//         }
//     });
// }
// function viewPresoScore(PkTeamIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'viewPresoScore','act':'print', 'PkTeamIdx':PkTeamIdx},
//         success: function(str){
// //             alert(str);
//             $('#id01_content').html(str);
//         }
//     });
// }
// function viewPenalty(PkTeamIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'viewPenalty','act':'print', 'PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//         }
//     });
// }
// function viewFlightCards(PkTeamIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'viewFlightCards','act':'print', 'PkTeamIdx':PkTeamIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//         }
//     });
// }
// function viewCardDetail(PkTeamIdx, InRound, PkClassIdx){
//     $('#id02').show();
//
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'viewCardDetail','act':'print', 'PkTeamIdx':PkTeamIdx,'InRound':InRound,'PkClassIdx':PkClassIdx},
//         success: function(str){
//             $('#id02_content').html(str);
//         }
//     });
// }
// function viewRoundResults(PkClassIdx){
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/student.pl',
//         data: {'do':'viewRoundResults','act':'print', 'PkClassIdx':PkClassIdx},
//         success: function(str){
//             $('#id01_content').html(str);
//         }
//     });
// }
