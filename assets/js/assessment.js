    var d=document;
    var sid = $.cookie('SID');

// ----------------------- GROUPS     ------------------------
function showAssessmentEvent(){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showAssessmentEvent','act':'print'},
        success: function(str){
            $('#main').html(str);
            $('#pageTitle').html('STARS - Assessment Setup & Maintenance');
            $('#backButton').off('click').on('click', function(){
                window.location.href="admin.html";
            }).show();
        }
    });
}
function showGroupPage(PkScoreEventIdx){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showGroupPage','act':'print','PkScoreEventIdx':PkScoreEventIdx},
        success: function(str){
            $('#main').html(str);
            $('#backButton').off('click').on('click', function(){
               showAssessmentEvent();
            }).show();
        }
    });
}
function showSectionPage(PkScoreEventIdx, PkScoreGroupIdx){
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showSectionPage','act':'print','PkScoreEventIdx':PkScoreEventIdx,'PkScoreGroupIdx':PkScoreGroupIdx},
        success: function(str){
            $('#main').html(str);
            $('#backButton').off('click').on('click', function(){
               showGroupPage(PkScoreEventIdx);
            }).show();
        }
    });
}
function cancelToGroupChanges(){
    var Sum = 0;
    $('.IN_MAX_CLASS').each(function(){
         $(this).val($(this).data('value'));
         Sum +=  parseFloat($(this).val());
    });
    $('#GroupSaveButton').removeClass('w3-orange');
    $('#TOTAL_SUM').html(Sum);
}
function saveNewGroupInMax(InMax){
//     var Sum = 0;
    var text = '';
    var obj = {};
    if ($('#TOTAL_SUM_REGULAR').data('total') != InMax) {
        text += "Your total for the Regular Class is "+$('#TOTAL_SUM_REGULAR').data('total')+" pts. Your Total MUST equal "+InMax+" pts.\n";
    }
    if ($('#TOTAL_SUM_ADVANCED').data('total') != InMax) {
        text += "Your total for the Advanced Class is "+$('#TOTAL_SUM_ADVANCED').data('total')+" pts. Your Total MUST equal "+InMax+" pts.\n";
    }
    if ($('#TOTAL_SUM_MICRO').data('total') != InMax) {
        text += "Your total for the Micro Class is "+$('#TOTAL_SUM_MICRO').data('total')+" pts. Your Total MUST equal "+InMax+" pts.\n";
    }
    if (text.length > 0){
        alert(text);
        return
    }


    $('.IN_MAX_CLASS').each(function(){
        obj[$(this).data('key')]=$(this).val();
    });
    var jsonData = JSON.stringify( obj );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'saveNewGroupInMax','act':'print','jsonData':jsonData},
        success: function(str){
            $('.IN_MAX_CLASS').each(function(){
                $(this).data('value',$(this).val());
            });
            alert("Successfully Updated");
        }
    });
}
// ----------------------- SECTIONS   ------------------------
function showAddSectionToGroup(PkScoreGroupIdx){
    $('#id01').show();
        $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showAddSectionToGroup','act':'print','PkScoreGroupIdx':PkScoreGroupIdx},
        success: function(str){
            $('#id01_content').html(str);
        }
    });
}
function addASection(PkScoreGroupIdx){
    var obj = {};
    var TxScoreSection = $('#TX_SCORE_SECTION').val();
    var InWeight = $('#IN_WEIGHT').val();
    var TxScoreDetail = encodeURIComponent(escapeVal($('#TX_SCORE_DETAIL').val(),"<br />"));
    obj['TX_SCORE_SECTION']=TxScoreSection;
    obj['IN_WEIGHT']=InWeight;
    obj['TX_SCORE_DETAIL']=TxScoreDetail;
    var jsonData = JSON.stringify( obj );
//     alert(PkScoreGroupIdx);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'addASection','act':'print','PkScoreGroupIdx':PkScoreGroupIdx,'jsonData':jsonData},
        success: function(str){
            $('#SECTION_TABLE').append(str);
            closeModal('id01');
            var Sum = getTotalSectionCount();
            $('#TOTAL_SECTION_COUNT').html(Sum);
            if (Sum != 100){
                $('#saveChangesToSectionWeight').addClass('w3-orange');
                alert("Your Section Weight must equal 100% to continue.\n\nIt is currently at "+Sum+"%");
            }
        }
    });
}
function deleteSection(PkScoreSectionIdx){
    var jsYes = confirm('Are you sure?');
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'deleteSection','act':'print','PkScoreSectionIdx':PkScoreSectionIdx},
        success: function(str){
            $('#TR_SECTION_IDX_'+PkScoreSectionIdx).remove();
            var Sum = getTotalSectionCount();
            $('#TOTAL_SECTION_COUNT').html(Sum);
            if (Sum != 100){
                $('#saveChangesToSectionWeight').addClass('w3-orange');
                alert("Your Section Weight must equal 100% to continue.\n\nIt is currently at "+Sum+"%");
            }
        }
    });
}
function showEditSectionItem(PkScoreSectionIdx, PkScoreGroupIdx){
    $('#id01').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showEditSectionItem','act':'print','PkScoreSectionIdx':PkScoreSectionIdx,'PkScoreGroupIdx':PkScoreGroupIdx},
        success: function(str){
            $('#id01_content').html(str);
            var Sum = getTotalItemCount();
            if (Sum != 100){
                alert("The Sum of all the lIne Item Assessment must add up to 100%.\n\nYour current value now is "+Sum+"%");
                $('#saveChangesToItemWeight').addClass('w3-orange');
            }
           $('#TOTAL_LINE_ITEM').html(Sum);
        }
    });
}
function enableSaveSectionChangesButton(){
    var Sum = getTotalSectionCount();
    $('#saveChangesToSectionWeight').addClass('w3-orange');
    $('#TOTAL_SECTION_COUNT').html(Sum);
}
function cancelSectionUpdate(){
    $('.CLASS-SECTION-IN_WEIGHT').each(function(){
        $(this).val($(this).data('value'));
    });
    $('#saveChangesToSectionWeight').remove('w3-orange');
}
function saveSectionWeight(PkScoreGroupIdx){
    var obj = {};
    var Sum = 0;
    $('.CLASS-SECTION-IN_WEIGHT').each(function(){
        obj[$(this).data('key')]=$(this).val();
        Sum +=  parseFloat($(this).val());
    });
    if (Sum != 100){
        alert("Your Section Weight must equal 100% to continue.\n\nIt is currently at "+Sum+"%");
        return
    }
    var jsonData = JSON.stringify( obj );
//     alert(jsonData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'saveSectionWeight','act':'print','PkScoreGroupIdx':PkScoreGroupIdx,'jsonData':jsonData},
        success: function(str){
            $('#saveChangesToSectionWeight').removeClass('w3-orange');
            alert("Successfully Update the Weights");
        }
    });
}
function showAddLineItem(PkScoreSectionIdx){
    $('#id02').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showAddLineItem','act':'print','PkScoreSectionIdx':PkScoreSectionIdx},
        success: function(str){
            $('#id02_content').html(str);
        }
    });
}
// ----------------------- LINE ITEMS ------------------------
function addLineItem(PkScoreSectionIdx){
    var obj = {};
    var TxScoreItem = $('#TX_SCORE_ITEM').val();
    obj['TX_SCORE_ITEM'] = $('#TX_SCORE_ITEM').val();
    obj['TX_DETAIL'] = encodeURIComponent(escapeVal($('#TX_DETAIL').val(),"<br />"));
    obj['BO_BINARY'] = $('#BO_BINARY option:selected').val();
    obj['IN_PERCENT'] = $('#IN_PERCENT').val();
    obj['IN_ORDER'] = $('#IN_ORDER').val();
    var jsonData = JSON.stringify( obj );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'addLineItem','act':'print','PkScoreSectionIdx':PkScoreSectionIdx,'jsonData':jsonData},
        success: function(str){
//         alert(str);
            $('#SECTION_ITEM_TABLE').append(str);
            closeModal('id02');
            var Sum = getTotalItemCount();

            if (Sum != 100){
                alert("The Sum of all the lIne Item Assessment must add up to 100%.\n\nYour current value now is "+Sum+"%");
                $('#saveChangesToItemWeight').addClass('w3-orange');
            }
           $('#TOTAL_LINE_ITEM').html(Sum);
        }
    });
}
function getTotalItemCount(){
    var Sum = 0;
    $('.CLASS-ITEM-IN_PERCENT').each(function(){
        Sum +=  parseFloat($(this).val());
    });
    return (Sum);
}
function deleteLineItem(PkScoreItemIdx){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'deleteLineItem','act':'print','PkScoreItemIdx':PkScoreItemIdx},
        success: function(str){
            $('#TR_LINE_ITEM_'+PkScoreItemIdx).remove();
            var Sum = getTotalItemCount();
            if (Sum != 100){
                alert("The Sum of all the lIne Item Assessment must add up to 100%.\n\nYour current value now is "+Sum+"%");
                $('#saveChangesToItemWeight').addClass('w3-orange');
            }
            $('#TOTAL_LINE_ITEM').html(Sum);
        }
    });
}
function updateSaveItemButton(){
    $('#saveChangesToItemWeight').addClass('w3-orange');
    var Sum = getTotalItemCount();
    $('#TOTAL_LINE_ITEM').html(Sum);
}
function saveItemChanges(PkScoreGroupIdx){
    var obj = {};
    var Sum = 0;
    obj['IN_PERCENT'] = {};
    obj['IN_ORDER'] = {};
    obj['TX_DETAIL'] = {};
    $('.CLASS-ITEM-IN_PERCENT').each(function(){
        obj['IN_PERCENT'][$(this).data('key')]=$(this).val();
        Sum +=  parseFloat($(this).val());
    });
    $('.CLASS-ITEM-IN_ORDER').each(function(){
        obj['IN_ORDER'][$(this).data('key')]=$(this).val();
    });
    if (Sum != 100){
        alert("Your Line Item Weight must equal 100% to continue.\n\nIt is currently at "+Sum+"%");
        return
    }

    obj['TX_DETAIL']['DATA'] = encodeURIComponent( escapeVal( $('#CL_DETAILS').val(), "<br />" ) );
    var jsonData = JSON.stringify( obj );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'saveItemChanges','act':'print','jsonData':jsonData,'PkScoreGroupIdx':PkScoreGroupIdx},
        success: function(str){
            $('#saveChangesToItemWeight').removeClass('w3-orange');
            alert("Successfully Update the Weights");
        }
    });
}
function cancelLineItemChanges(){
    $('.CLASS-ITEM-IN_PERCENT').each(function(){
        $(this).val($(this).data('value'));
    });
    $('.CLASS-ITEM-IN_ORDER').each(function(){
        $(this).val($(this).data('value'));
    });
    $('#saveChangesToItemWeight').removeClass('w3-orange');
}
function showEditLineItem(PkScoreItemIdx){
    $('#id02').show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'showEditLineItem','act':'print','PkScoreItemIdx':PkScoreItemIdx},
        success: function(str){
//         alert(str);
            $('#id02_content').html(str);

        }
    });
}
function updateEditedLineItem(PkScoreItemIdx){
    var obj = {};
    var TxScoreItem = $('#TX_SCORE_ITEM').val();
    obj['TX_SCORE_ITEM'] = $('#TX_SCORE_ITEM').val();
    obj['TX_DETAIL'] = encodeURIComponent(escapeVal($('#TX_DETAIL').val(),"<br />"));
    obj['BO_BINARY'] = $('#BO_BINARY option:selected').val();
    obj['BO_BINARY_TEXT'] = $('#BO_BINARY option:selected').text();
    obj['IN_PERCENT'] = $('#IN_PERCENT').val();
    obj['IN_ORDER'] = $('#IN_ORDER').val();
    var jsonData = JSON.stringify( obj );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/assessment.pl',
        data: {'do':'updateEditedLineItem','act':'print','PkScoreItemIdx':PkScoreItemIdx,'jsonData':jsonData},
        success: function(str){
        var myOBJ = JSON.parse(str);
            $('#TD_IN_ORDER_'+PkScoreItemIdx).html(myOBJ.IN_ORDER);
            $('#TD_IN_PERCENT_'+PkScoreItemIdx).val(myOBJ.IN_PERCENT);
            $('#TD_TX_TYPE_'+PkScoreItemIdx).html(myOBJ.BO_BINARY_TEXT);
            $('#TD_TX_SCORE_ITEM_'+PkScoreItemIdx).html(myOBJ.TX_SCORE_ITEM);
            closeModal('id02');
            var Sum = getTotalItemCount();
            alert (Sum);
            if (Sum != 100){
                alert("The Sum of all the lIne Item Assessment must add up to 100%.\n\nYour current value now is "+Sum+"%");
                $('#saveChangesToItemWeight').addClass('w3-orange');
            }
           $('#TOTAL_LINE_ITEM').html(Sum);
        }
    });
}
// ----------------------- UTILITIES  ------------------------
function addUpNumbers(){
    var SumRegular = 0;
    var SumAdvanced = 0;
    var SumMicro = 0;
    var SumGeneral = 0;
    $('#GroupSaveButton').addClass('w3-orange');
    $('.IN_MAX_CLASS').each(function(){
        if ($(this).data('class')==1) {
            SumRegular +=  parseFloat($(this).val());
        } else if ($(this).data('class')==2) {
            SumAdvanced +=  parseFloat($(this).val());
        } else if ($(this).data('class')==3) {
            SumMicro +=  parseFloat($(this).val());
        } else {
            SumRegular +=  parseFloat($(this).val());
            SumAdvanced +=  parseFloat($(this).val());
            SumMicro +=  parseFloat($(this).val());
        }
//         Sum +=  parseFloat($(this).val());
    });
    $('#TOTAL_SUM_REGULAR').html(SumRegular);
    $('#TOTAL_SUM_ADVANCED').html(SumAdvanced);
    $('#TOTAL_SUM_MICRO').html(SumMicro);
    $('#TOTAL_SUM_REGULAR').data('total',SumRegular);
    $('#TOTAL_SUM_ADVANCED').data('total',SumAdvanced);
    $('#TOTAL_SUM_MICRO').data('total',SumMicro);

}
function getTotalSectionCount(){
    var Sum = 0;
    $('.CLASS-SECTION-IN_WEIGHT').each(function(){
//         obj[$(this).data('key')]=$(this).val();
        Sum +=  parseFloat($(this).val());
    });
    return (Sum);
}
function expandTextArea(o){
    var currentHeight = $('#'+o).height();
    var newHeight = $('#'+o).get(0).scrollHeight;
    $('#'+o).height(newHeight);
    $('#'+o).data('height', currentHeight);
    $('.btnExpand').hide();
    $('.btnCollapse').show();
}

function collapseTextArea(o){
    var newHeight = $('#'+o).data('height');
//     alert(newHeight);
    $('#'+o).height(newHeight);
    $('.btnExpand').show();
    $('.btnCollapse').hide();
}
