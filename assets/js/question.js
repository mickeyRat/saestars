    var d=document;
    var sid = $.cookie('SID');

function sae_openManageQuestion(){
    // console.log("sae_openManageQuestion");
    $('#mainPageContent').html(loading);
    var location = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/question.pl',
        data: {'do':'sae_openManageQuestion','act':'print','eventIDX':location},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}
function sae_openAddRubrucQuestion(){
    var divName = 'TEMP_DIV_QUESTION_NEW';
    var location = $.cookie('LOCATION');
    createNewModalDiv('New Question Setup', divName, 750);
    // $('#EventSetupMenu').removeClass('w3-show');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/question.pl',
        data: {'do':'sae_openAddRubrucQuestion','act':'print','eventIDX':location,'divName':divName},
        success: function(str){
            // console.log(str);
            $('#x_modal_Content').html(str);
            
        }
    }); 
}
function sae_saveQuestion(divName){
    var jData = {};
    jData['TX_TITLE']       = escapeVal($('#TX_TITLE').val(),"<br />");
    jData['CL_DESCRIPTION'] = escapeVal($('#CL_DESCRIPTION').val(),"<br />");
    jData['CL_CRITERIA']    = escapeVal($('#CL_CRITERIA').val(),"<br />");
    jData['IN_TYPE']        = $('input[name="IN_TYPE"]:checked').val();
    var jsonData = JSON.stringify( jData );
    var location = $.cookie('LOCATION');
    // encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
    
    // console.log(jsonData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/question.pl',
        data: {'do':'sae_saveQuestion','act':'print','eventIDX':location,'divName':divName, 'jsonData':jsonData },
        success: function(str){
            console.log(str);
            // $('#x_modal_Content').html(str);
            $('#'+divName).remove();
            $('#TABLE_QUESTIONS').append(str);
        }
    }); 
}
function sae_deleteQuestion(questionIDX){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/question.pl',
        data: {'do':'sae_deleteQuestion','act':'print','questionIDX':questionIDX },
        success: function(str){
            console.log(str);
            $('#TR_QUESTION_IDX_'+questionIDX).remove();
        }
    }); 
}
function sae_editQuestion(questionIDX){
    var divName = 'TEMP_DIV_QUESTION_EDIT';
    createNewModalDiv('New Question Setup', divName, 750);
    console.log(divName);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/question.pl',
        data: {'do':'sae_editQuestion','act':'print','questionIDX':questionIDX,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_saveEditQuestion(obj, questionIDX, divName){
    var jData = {};
    jData['TX_TITLE']       = escapeVal($('#TX_TITLE').val(),"<br />");
    jData['CL_DESCRIPTION'] = escapeVal($('#CL_DESCRIPTION').val(),"<br />");
    jData['CL_CRITERIA']    = escapeVal($('#CL_CRITERIA').val(),"<br />");
    jData['IN_TYPE']        = $('input[name="IN_TYPE"]:checked').val();
    var jsonData = JSON.stringify( jData );
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/question.pl',
        data: {'do':'sae_saveEditQuestion','act':'print','questionIDX':questionIDX,'divName':divName, 'jsonData':jsonData },
        success: function(str){
            console.log(str);
            $('#'+divName).remove();
            $('#TR_QUESTION_IDX_'+questionIDX).replaceWith(str);
        }
    }); 
}
