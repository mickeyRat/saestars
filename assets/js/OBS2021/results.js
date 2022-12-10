var d=document;
var sid = $.cookie('SID');

function sae_publishResults(obj, classIDX, inType, inRound){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'sae_publishResults','act':'print','location':location,'inRound':inRound,'classIDX':classIDX, 'inType':inType},
        success: function(str){
            $(obj).replaceWith(str);
        }
    });
}
function sae_makePublic(obj, txFile){
    // var location = $.cookie('LOCATION');
    if ($('#BO_SHOW_SCORE_'+txFile).is(":checked")){var checked = 1} else {var checked = 0}
    // console.log(checked);
    // return
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'sae_makePublic','act':'print','txFile':txFile, 'checked':checked},
        success: function(str){
            $(obj).remove();
            $('.'+txFile).remove();
        }
    });
}
function sae_deletePublishedScore(obj, txFile, classIDX, inType, inRound){
    // $(obj).parent().remove();
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'sae_deletePublishedScore','act':'print','location':location,'txFile':txFile,'classIDX':classIDX,'inType':inType,'inRound':inRound},
        success: function(str){
            // console.log(str);
            $(obj).parent().replaceWith(str);
            // 
        },
        error: function(){
            alert("Error!!!");
        }
    });
};
// ============== 2019 ============================
function showResultsMain(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'showResultsMain','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function generateFridayResults(idx, txType){
    var location = $.cookie('LOCATION');
//     alert(txType);
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'generateFridayResults','act':'print','location':location,'idx':idx,'txType':txType},
        success: function(str){
            $('#id01_content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function generateCheckedItems(idx, txType){
    var location = $.cookie('LOCATION');
    var obj = {};
    $('.inputBinary').each(function(i){
        if ($(this).is(":checked")){
            obj[$(this).data('label')]=1;
        }
    });
    var jsonData = JSON.stringify( obj );
//     alert(jsonData);
    $.ajax({
    type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'generateCheckedItems','act':'print','location':location, 'idx':idx, 'txType':txType, 'jsonData':jsonData},
        success: function(str){
//             alert(str);
            // $('#BTN_'+PkClassIdx+'_'+InRound).addClass('w3-green');
            $('#TD_ROW_RESULTS_FOR_'+idx).append(str);
            closeModal('id01');
        }
    });
}
function deletePublishedItem(PkPublishIdx){
    var jsYes = confirm("Are you sure? ");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'deletePublishedItem','act':'print','PkPublishIdx':PkPublishIdx},
        success: function(str){
            $('#PUBLISH_IDX_'+PkPublishIdx).remove();
        }
    });
}
function makePublic(obj, PkPublishIdx){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'makePublic','act':'print','PkPublishIdx':PkPublishIdx},
        success: function(str){
            $(obj).remove();
        }
    });
}
function generateFlightResults(idx, txType){
    var location = $.cookie('LOCATION');

    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'generateFlightResults','act':'print','location':location,'idx':idx,'txType':txType},
        success: function(str){
            $('#id01_content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function showGenerateButton(obj, r){
    $('.GENERATE_BUTTON').hide();
    if ($(obj).is(":checked")){
        $('.GENERATE_BUTTON_'+r).show();
    } else {
        $('.GENERATE_BUTTON').hide();
    }
}
function generateRoundResults(round, idx, classIDX, txType, FkScoreEventIdx){
    var location = $.cookie('LOCATION');
//     alert(txType);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'generateRoundResults','act':'print','location':location,'idx':idx, 'classIDX':classIDX,'txType':txType,'FkScoreEventIdx':FkScoreEventIdx,'round':round},
        success: function(str){
//             alert(str);
            $('#TD_ROW_RESULTS_FOR_'+idx).append(str);
//             $('[tabindex=1]').focus();
            closeModal('id01');
        }
    });
}
function generateOverall(idx, txType){
    var location = $.cookie('LOCATION');
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'generateOverall','act':'print','location':location,'idx':idx,'txType':txType},
        success: function(str){
            $('#id01_content').html(str);
            $('[tabindex=1]').focus();
        }
    });
}
function generateOverallResults(obj, round, idx, classIDX, txType, FkScoreEventIdx){
    var location = $.cookie('LOCATION');
//     alert(txType);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'generateOverallResults','act':'print','location':location,'idx':idx, 'classIDX':classIDX,'txType':txType,'FkScoreEventIdx':FkScoreEventIdx,'round':round},
        success: function(str){
//             alert(str);
            $('#TD_ROW_RESULTS_FOR_'+idx).append(str);
//             closeModal('id01');
            $(obj).remove();
        }
    });
}
function expandTable(table){
    $('.'+table).toggle();
}

// ================ 2018 ==========================
function expandDetails(PkClassIdx){
    $('#RESULTS_'+PkClassIdx).toggleClass('w3-show');
}

function openDesignResults(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'openDesignResults','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
        }
    });
}

function openPresoResults(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'openPresoResults','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
        }
    });
}

function openFlightResults(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'openFlightResults','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function openOverall(){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'openOverall','act':'print','location':location},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function publishResults(InRound, PkClassIdx, TxTitle, PkScoreEventIdx){
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'publishResults','act':'print','location':location, 'InRound':InRound, 'PkClassIdx':PkClassIdx, 'TxTitle':TxTitle, 'PkScoreEventIdx':PkScoreEventIdx},
        success: function(str){
            $('#BTN_'+PkClassIdx+'_'+InRound).addClass('w3-green');
            $('#RESULT_ITEM_'+PkClassIdx).append(str);
        }
    });
}
function publishFinalResults(){
    var location = $.cookie('LOCATION');
    var InMaxRound = $.cookie('IN_MAX_ROUND');
    if (InMaxRound==0){
        alert("Please select a final round");
        return;
    }
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'publishFinalResults','act':'print','location':location, 'InMaxRound':InMaxRound},
        success: function(str){
            $('#BTN_'+PkClassIdx+'_'+InRound).addClass('w3-green');
            $('#RESULT_ITEM_'+PkClassIdx).append(str);
        }
    });
}
function deletePublishedReport(PkClassIdx, TxFile, InRound){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'deletePublishedReport','act':'print','TxFile':TxFile},
        success: function(str){
            $('#BTN_'+PkClassIdx+'_'+InRound).removeClass('w3-green');
            $('#RESULT_ITEM_'+TxFile).remove();
        }
    });
}
function tabulateFinalScores(){
    var location = $.cookie('LOCATION');
    var maxRound = $('input[name=IN_MAX_ROUND]:checked').val();
//      alert(maxRound);
//     $('#LIST_OF_RESULTS').append(maxRound);
//     return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'tabulateFinalScores','act':'print','maxRound':maxRound,'location':location},
        success: function(str){
            $('#LIST_OF_RESULTS').append(str);
        }
    });
}

function publishFinalResults(TxFile, TxTitle){
    var jsYes = confirm("*** WARNING *** \n\nThis publish action will make the final result for \n\n[ "+TxTitle+" ]\n\n visible to the public.  Click OK to proceed.");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/results.pl',
        data: {'do':'publishFinalResults','act':'print','TxFile':TxFile},
        success: function(str){
            $('#BTN_PUBLISH_'+TxFile).remove();
            alert(str);
        }
    });


}
