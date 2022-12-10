    var d=document;
    var sid = $.cookie('SID');
    var loading = '<div class="w3-padding" style="margin: auto;"><img src="../../images/loader.gif"> Loading...</div>';

function showFlightTable(){
    // $('#mainPageContent').html(loading);
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'showFlightTable','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function sae_createFlightCard(obj, inRound, teamIDX, classIDX, teamTitle){
    var location = $.cookie('LOCATION');
    // console.log("inRound="+inRound+", teamIDX="+teamIDX+", classIDX="+classIDX+", teamTitle="+teamTitle+"\n");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_createFlightCard','act':'print','teamTitle':teamTitle,'classIDX':classIDX,'location':location,'teamIDX':teamIDX,'inRound':inRound},
        success: function(str){
            // console.log(str);
            $(obj).replaceWith(str);
        }
    });
}
function sae_showFlightStats(){
    var divName = 'TEMP_DIV_FLIGHT_STATS';
    var location = $.cookie('LOCATION');
    createNewModalDiv('Flight Operations Statistics',divName,650);
    

    
    var regGreen = $('.stats_1_w3-green').length;
    var regRed = $('.stats_1_w3-red').length;
    var regGrey = $('.stats_1_w3-grey').length;
    
    var advGreen = $('.stats_2_w3-green').length;
    var advRed = $('.stats_2_w3-red').length;
    var advGrey = $('.stats_2_w3-grey').length;
    
    var micGreen = $('.stats_3_w3-green').length;
    var micRed = $('.stats_3_w3-red').length;
    var micGrey = $('.stats_3_w3-grey').length;
    
    var totalAllGreen = regGreen + advGreen + micGreen;
    var totalAllRed   = regRed   + advRed   + micRed;
    var totalAllGrey  = regGrey  + advGrey  + micGrey;

    
    var str = '<table class="w3-table-all">';
    str += '<tr>';
    str += '<th style="text-align: right">Class</th>';
    str += '<th style="text-align: right">Successful</th>';
    str += '<th style="text-align: right">Unsuccessful</th>';
    str += '<th style="text-align: right">Crashed</th>';
    str += '<th style="text-align: right">Attempts</th>';
    str += '</tr>';
    str += '<tr>';
    str += '<td style="text-align: right">Regular</td>';
    str += '<td style="text-align: right">'+regGreen+'</td>';
    str += '<td style="text-align: right">'+regGrey+'</td>';
    str += '<td style="text-align: right">'+regRed+'</td>';
    str += '<td style="text-align: right">'+(regGreen+regGrey+regRed)+'</td>';
    str += '</tr>';
    str += '<tr>';
    str += '<td style="text-align: right">Advanced</td>';
    str += '<td style="text-align: right">'+advGreen+'</td>';
    str += '<td style="text-align: right">'+advGrey+'</td>';
    str += '<td style="text-align: right">'+advRed+'</td>';
    str += '<td style="text-align: right">'+(advGreen+advGrey+advRed)+'</td>';
    str += '</tr>';
    str += '<tr>';
    str += '<td style="text-align: right">Micro</td>';
    str += '<td style="text-align: right">'+micGreen+'</td>';
    str += '<td style="text-align: right">'+micGrey+'</td>';
    str += '<td style="text-align: right">'+micRed+'</td>';
    str += '<td style="text-align: right">'+(micGreen+micGrey+micRed)+'</td>';
    str += '</tr>';
    str += '<tr style="font-weight: bold;">';
    str += '<td style="text-align: right">Overall</td>';
    str += '<td style="text-align: right">'+totalAllGreen+'</td>';
    str += '<td style="text-align: right">'+totalAllGrey+'</td>';
    str += '<td style="text-align: right">'+totalAllRed+'</td>';
    str += '<td style="text-align: right">'+(totalAllGreen+totalAllGrey+totalAllRed)+'</td>';
    str += '</tr>';
    str += '</table>';
    $('#x_modal_Content').html(str);
    console.log("total w3-green="+totalAllGreen);
    console.log("total w3-red="+totalAllRed);
    console.log("total w3-grey="+totalAllGrey);
    console.log("Regular Class w3-green="+regGreen);
    // alert("done");
}

function sae_openFlightCard(teamIDX, classIDX, flightIDX, inRound, teamTitle){
    var divName = 'TEMP_DIV_FLIGHT_CARD';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Team #</b>'+teamTitle+' (Round '+inRound+' Flight Card)',divName,850);
    $('#x_modal_Content').html(loading);
    // console.log("teamIDX="+teamIDX+", classIDX="+classIDX+", flightIDX="+flightIDX+"\n");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openFlightCard','act':'print','flightIDX':flightIDX,'classIDX':classIDX, 'location':location,'teamIDX':teamIDX,'divName':divName,'inRound':inRound},
        success: function(str){
            $('#x_modal_Content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function sae_deleteFlightCard(flightIDX, divName){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    console.log(divName);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_deleteFlightCard','act':'print','flightIDX':flightIDX},
        success: function(str){
            showFlightTable();
            $('#'+divName).remove();
        }
    });    
}
function sae_updateCrashStatus(flightIDX, teamIDX, divName, inRound){
    var jsYes = confirm("Will this aircraft need to be re-inspected before the next flight?\n\nClick [ OK ] to generate a Crash Report.");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateCrashStatus','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX,'inRound':inRound},
        success: function(str){
            if (jsYes) {
                sae_createReinspection(flightIDX, teamIDX, inRound, divName);
            } else {
                showFlightTable();
                $('#'+divName).remove();
            }
        }
    }); 
}
function sae_updateDNFStatus(flightIDX, divName, inRound){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateDNFStatus','act':'print','flightIDX':flightIDX,'inRound':inRound},
        success: function(str){
            showFlightTable();
            $('#'+divName).remove();
        }
    }); 
}
function sae_createReinspection(flightIDX, teamIDX, inRound, divName){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_createReinspection','act':'print','flightIDX':flightIDX,'teamIDX':teamIDX, 'location':location,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function sae_submitCrashReport(flightIDX, teamIDX, divName){
    var obj = {};
    var items = new Array();
    var location = $.cookie('LOCATION');
    var others = $('#ITEM_OTHERS').val();
    $('.sae-inspection_item').each(function(i){ 
        if ($(this).is(":checked")){
            if ($(this).val()==0){
                items.push(others);
            } else {
                items.push($(this).val());
            }
        }
    });
    obj['CL_DESCRIPTION'] = items.join(";");
    obj['FK_FLIGHT_IDX']=flightIDX;
    obj['FK_EVENT_IDX']=location;
    obj['FK_TODO_TYPE_IDX']=4;
    obj['FK_TEAM_IDX']=teamIDX;
    obj['TX_TIME']='Before Next Flight';
    obj['TX_ROOM']='Re-Inspection Table';
    obj['TX_STATUS']='Crashed: Re-Inspection Required';
    $('.sae-input').each(function(i){
        if ($(this).data('key') =='CL_COMMENT'){
            obj[$(this).data('key')]= encodeURIComponent(escapeVal($(this).val(),"<br />"));
        } else {
            obj[$(this).data('key')]=$(this).val();
        }
    });
    var jsonData = JSON.stringify( obj );
    console.log (jsonData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_submitCrashReport','act':'print','flightIDX':flightIDX,'others':others,'jsonData':jsonData},
        success: function(str){
            // console.log(str);
            showFlightTable();
            $('#'+divName).remove();            
        }
    });
}
function sae_openReinspectionList(teamIDX){
    var divName = 'TEMP_DIV_FLIGHT_INSPECTION';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Reinspections',divName,800);
    $('#x_modal_Content').html(loading);
    // console.log("teamIDX="+teamIDX+", classIDX="+classIDX+", flightIDX="+flightIDX+"\n");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_openReinspectionList','act':'print','teamIDX':teamIDX,'divName':divName },
        success: function(str){
            $('#x_modal_Content').html(str);
            // $('[tabindex=1]').focus();
        }
    });
}
function sae_clearReinspection(obj, teamIDX, todoIDX, divName){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    // $(obj).parent().remove();
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_clearReinspection','act':'print','teamIDX':teamIDX,'todoIDX':todoIDX},
        success: function(str){
            $(obj).parent().remove();
            showFlightTable();
            // $('#'+divName).remove();
        }
    });
}
function sae_updateSuccessStatus(flightIDX, divName, inRound){
    var obj = {};
    var items = new Array();

    $('.sae-flight-input').each(function(i){
        obj[$(this).data('key')]=$(this).val();
    });
    $('.sae-checked-item').each(function(i){ 
        if ($(this).is(":checked")){
            obj[$(this).data('key')]=$(this).val();
        }
    });
    
    obj['TX_STATUS'] = '<i class="fa fa-thumbs-o-up"></i> Good';
    obj['IN_STATUS'] = 1;
    obj['TX_COLOR'] = 'w3-green';
    var weatherIDX = $('#TX_TIME_2 option:selected').val(); 
    var textTime = $('#TX_TIME_2 option:selected').text();
    obj['FK_WEATHER_IDX'] = weatherIDX;
    obj['TX_TIME'] = textTime;

    var jsonData = JSON.stringify( obj );
    console.log (jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateSuccessStatus','act':'print','flightIDX':flightIDX,'jsonData':jsonData},
        success: function(str){
            // console.log(str);
            showFlightTable();
            $('#'+divName).remove();            
        }
    });
    //  
}
function sae_openWeightCalculations(){
    $('#CALC').toggleClass('w3-hide');
}
function sae_applyto(target, limit){
    var lbs = parseInt($('#PAYLOAD_LB').val());
    var oz = $('#PAYLOAD_OZ').val()*1;
    console.log (oz);
    var payload = (lbs + (oz/16)).toFixed(2);
    if (payload > limit){
        var response = confirm("The calculated weight you've entered ("+payload+") is more than the allowed of weight of "+limit+" lbs.  This max-weight was pre-determined at the weigh-in during Tech-Inspection.\n\nPress [ OK ] to use the allowable Max Weight.\nPress [ Cancel ] to reset and enter the payload weight again.");
        if (response){
            $('.'+target).val(limit);
        } else {
            $('#PAYLOAD_LB').val('');
            $('#PAYLOAD_OZ').val('');
            $('[tabindex=4]').focus();
        }
        // alert("The calculated weight you've entered ("+payload+") is more than the allowed of weight of "+limit+" lbs.  This max-weight was pre-determined at the weigh-in during Tech-Inspection.");
    } else {
        $('.'+target).val(payload);
    }
    return;
}
function sae_advancedClass_applyto(target){
    var no = parseInt($('#PAYLOAD_NO').val());
    var oz = $('#PAYLOAD_OZ').val()*1;
    console.log (oz);
    var payload = (no*oz).toFixed(2);
    $('#'+target).val(payload);
    return;
}
// ============= MICRO CLASS ==================================
function sae_checkMaxWeight(obj, maxWeight){
    if ($(obj).val() > maxWeight){
        var response = confirm("The number you've entered ("+$(obj).val()+") is more than the allowed of weight of "+maxWeight+" lbs.  This max-weight was pre-determined at the weigh-in during Tech-Inspection.\n\nPress [ OK ] to use the allowable Max Weight.\nPress [ Cancel ] to reset and enter the payload weight again.");
        if (response){
            $(obj).val(maxWeight);
        } else {
            $(obj).val('');
            $('[tabindex=1]').focus();
        }
    }
}
// ============= METRICS ==================================
function sae_updateMetric(obj, flightIDX, inStatus, label, step){
    var location = $.cookie('LOCATION');
    var filter = $.cookie('FILTER');
    if (inStatus == 5 || inStatus == 6 || inStatus == 7 ){
        $('.sae-complete').hide();
        $(obj).show();
    } else {
        $('.sae-complete').show();
    }
    console.log("flightIDX="+flightIDX+", inStatus="+inStatus+", label="+label+",location="+location+", step="+step);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_updateMetric','act':'print','location':location,'inStatus':inStatus,'filter':filter,'label':label,'flightIDX':flightIDX,'step':step},
        success: function(str){
            
            $(obj).replaceWith(str);
            sae_applyFlightOpsFilter();
        }
    });
}

function sae_applyFlightOpsFilter(){
    var filter = $('#FLIGHT_OPS_FILTER option:selected').val();
    var location = $.cookie('LOCATION');
    $.cookie('FILTER', filter);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_flightOperations', 'act':'print','location':location,'filter':filter},
        success: function(str){
            // console.log(str);
            $('#mainPageContent').html(str);
        }
    });
    // console.log(filter);
}
function sae_loadFlow(flightIDX, inNumber, inStatus){
    var divName = 'TEMP_DIV_FLIGHT_CARD';
    createNewModalDiv('<b>Team #'+inNumber+': Flight Ops</b>',divName,550);
    var filter = $('#FLIGHT_OPS_FILTER option:selected').val();
    var location = $.cookie('LOCATION');
    console.log('location='+location+', filter='+filter+', inStatus='+inStatus+', flightIDX='+flightIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/flight.pl',
        data: {'do':'sae_loadFlow', 'act':'print','location':location,'filter':filter,'inStatus':inStatus,'flightIDX':flightIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });  
}

// // ===================== 2019 ==============================
// function showFlightMain(){
//     var location = $.cookie('LOCATION');
//     // alert("hello World");
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
//         data: {'do':'showFlightMain','act':'print','location':location},
//         success: function(str){
//             $('#main').html(str);
//         }
//     });
// }
// function creatFlightCard(PkTeamIdx, FkClassIdx, r){
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var location = $.cookie('LOCATION');
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
//         data: {'do':'creatFlightCard','act':'print','location':location,'PkTeamIdx':PkTeamIdx, 'FkClassIdx':FkClassIdx,'PkUserIdx':PkUserIdx,'r':r},
//         success: function(str){
//             $('#flightCard_'+PkTeamIdx+'_'+r).html(str);
//             // $('#TD_FLIGHT_ROW_FOR_'+PkTeamIdx).append(str);
// //             $('#main').html(str);
//         }
//     });
// }
// function openFlightCard(PkGradeIdx, PkTeamIdx, FkClassIdx, r){
// //     alert('test');
//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var location = $.cookie('LOCATION');
// //     alert(PkGradeIdx+', '+PkTeamIdx+', '+FkClassIdx+', '+PkUserIdx+', '+location);
//     $('#id01').show();
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
//         data: {'do':'openFlightCard','act':'print','location':location,'PkGradeIdx':PkGradeIdx,'PkTeamIdx':PkTeamIdx, 'FkClassIdx':FkClassIdx,'PkUserIdx':PkUserIdx,'round':r},
//         success: function(str){
//             $('#id01_content').html(str);
//             $('[tabindex=1]').focus();
//         }
//     })
// }
// function deleteFlightLog(PkGradeIdx, teamIDX, classIDX, r){
//     var jsYes = confirm(teamIDX+" Click OK to continue with deleting this flight log.");
//     if (!jsYes){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
//         data: {'do':'deleteFlightLog','act':'print','PkGradeIdx':PkGradeIdx,'teamIDX':teamIDX, 'classIDX':classIDX, 'round':r},
//         success: function(str){
//             $('#flightCard_'+teamIDX+'_'+r).html(str);
//             // $('#btn_flight_score_card_'+PkGradeIdx).remove();
//             closeModal('id01');
//         }
//     });
// }
// function toggleButton(q){
//     $('#btn_'+q).toggle();
// }

// function statusFlight(PkGradeIdx, status, PkTeamIdx, FkClassIdx, inCapacity, newClass, txStatus, r){


//     var PkUserIdx = $.cookie('PK_USER_IDX');
//     var boPen25=0;
//     var boPen50=0;
//     var round=r;
//     var obj = {};

//     if ($('#BO_PEN25').is(':checked')){
//         var boPen25=1;
//     }
//     if ($('#BO_PEN50').is(':checked')){
//         var boPen50=1;
//     }
//     $('.inputNumber').each(function(i){
//         if ($(this).data('key')==0){
//             round = $(this).val();
//         } else {
//             obj[$(this).data('key')]=$(this).val();
//         }
//     });
//     if (FkClassIdx==1) {
//         var val = validateRegularClassEntry(obj[323], obj[324], inCapacity);
//         if (obj[323] != val[0] || obj[324] != val[1]){
//             alert("ALERT!!!\n\nYour passenger and luggage values was adjust because it was outside of the acceptable parameters.\n\nPassenger Entered [ "+obj[323]+" ] adjusted to new value of "+val[0]+"\nLuggage Entered [ "+obj[324]+" ] adjusted to new value of "+val[1]);
//         }
//         obj[323] = val[0];
//         obj[324] = val[1];
//     }
//     // alert(round);
//     var jsonData = JSON.stringify( obj );
//     // alert(jsonData);
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
// //         data: {'do':'statusFlight','act':'print','PkGradeIdx':PkGradeIdx,'status':status,'PkTeamIdx':PkTeamIdx},
//         data: {'do':'statusFlight','act':'print','FkClassIdx':FkClassIdx, 'round':round,'status':status, 'PkGradeIdx':PkGradeIdx,'PkUserIdx':PkUserIdx,'PkTeamIdx':PkTeamIdx,'boPen50':boPen50, 'boPen25':boPen25, 'jsonData':jsonData},
//         success: function(str){
//             closeModal('id01');
//             $('#btn_flight_score_card_'+PkGradeIdx).removeClass('w3-yellow w3-green w3-red w3-grey');
//             $('#btn_flight_score_card_'+PkGradeIdx).addClass(newClass).html('('+round+') '+txStatus);

//         }
//     });
// }
// function validateRegularClassEntry(Load, Cargo, Cap){
//     var flag = 0;
//     if (Load > Cap){Load = Cap; flag=1} //If load is greater than capacity, then load is capacity
//     var minCargo = Load * .5;
//     if (Cargo <= minCargo) {Load = Cargo * 2}
//     var maxCargo = Load * .75;
//     if (Cargo > maxCargo){Cargo = maxCargo}
// //     alert(Load);
//     return [Load, Cargo];
// }
// function converNumbers(PkQuestionIdx){
//     var pounds = $('#POUNDS_'+PkQuestionIdx).val() * 1;
//     var ounce = $('#OUNCE_'+PkQuestionIdx).val() * 1;
//     var value = 0;
//     value = pounds + ounce/16;
//     $('#INPUT_'+PkQuestionIdx).val(value);
//     $('#btn_'+PkQuestionIdx).toggle();
// }
// function AddWaterAmount(PkQuestionIdx){
//     var input = $('#INPUT_'+PkQuestionIdx).val() * 1;
//     var bottle = $('#BOTTLE_'+PkQuestionIdx).val() * 1;
//     var amount = $('#AMOUNT_'+PkQuestionIdx).val() * 1;
//     var value = bottle * amount;
//     // var value = (input + (bottle * amount));
//     $('#INPUT_'+PkQuestionIdx).val(value);
//     $('#btn_'+PkQuestionIdx).toggle();
// }
// function checkMinMax(obj){
//     var max = $(obj).data('max');
//     var value = $(obj).val()*1;
//     if (value > max){$(obj).val(max)}
// }

// function updateTeamCapacity(obj, teamIDX, cap, qIDX){
//     var newCap = prompt("Aircraft Seat Capacity", cap);
//     if (!newCap){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
// //         data: {'do':'updateTeamCapacity','act':'print','teamIDX':teamIDX,'newCap':newCap},
//         data: {'do':'updateTeamCapacity','act':'print','teamIDX':teamIDX, 'newCap':newCap},
//         success: function(str){
//             var input = $('#INPUT_'+qIDX);
//             input.prop("max",newCap);
//             input.data('max', newCap)
//             input.prop('placeholder',newCap+' max');
//             $(obj).html('Capacity # '+newCap+' Seats');
//         }
//     });
// }
// function updateTeamMax(obj, teamIDX, cap, qIDX){
//     var newMax = prompt("Aircraft Seat Capacity", cap);
//     if (!newMax){return}
//     $.ajax({
//         type: 'POST',
//         url: '../cgi-bin/flight.pl',
// //         data: {'do':'updateTeamCapacity','act':'print','teamIDX':teamIDX,'newCap':newCap},
//         data: {'do':'updateTeamMax','act':'print','teamIDX':teamIDX, 'newMax':newMax},
//         success: function(str){
//             var input = $('#INPUT_'+qIDX);
//             input.prop("max",newMax);
//             input.data('max', newMax)
//             input.prop('placeholder',newMax+' max');
//             $(obj).html('Max Payload: '+newMax+' lbs');
//         }
//     });
// }
