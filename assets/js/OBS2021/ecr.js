var d=document;
var now = new Date();
var time = now.getTime();

function sae_openECR(){
    var location = $.cookie('LOCATION');
    var userIDX = $.cookie('userIDX');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_openECR','act':'print','location':location,'userIDX':userIDX},
        success: function(str){
            $('#mainPageContent').html(str);
        }
    });
}

function sae_openECREntryForm(userIDX, teamIDX){
    var divName = 'TEMP_DIV_ADD_NEW_ECR';
    var location = $.cookie('LOCATION');
    createNewModalDiv('<b>Engineering Change Request (ECR)</b>',divName,850);
    // console.log ("teamIDX = "+teamIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_openECREntryForm','act':'print','userIDX':userIDX,'location':location,'teamIDX':teamIDX,'divName':divName},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_submitECR(divName, judge){
    var obj = {};
    var discover = new Array();
    var system = new Array();
    var location = $.cookie('LOCATION');
    var teamIDX = $('#selectTeamIDX option:selected').val();
    var teamName = $('#selectTeamIDX option:selected').text();
    obj['FK_TEAM_IDX'] = teamIDX;
    $('.sae-check-method').each(function(i){ 
        if ($(this).is(":checked")){ discover.push($(this).val())}
    });
    obj['TX_METHOD'] = discover.join(",");
    $('.sae-check-system').each(function(i){ 
        if ($(this).is(":checked")){ system.push($(this).val())}
    });
    obj['TX_SYSTEM'] = system.join(",");
    $('.sae-input').each(function(i){
        if ($(this).data('key') =='CL_DESCRIPTION' || $(this).data('key') == 'CL_REASON'){
            obj[$(this).data('key')]= encodeURIComponent(escapeVal($(this).val(),"<br />"));
        } else {
            obj[$(this).data('key')]=$(this).val();
        }
        // encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
        
    });
    if (judge==1) {
        obj['IN_STATUS']=1;
    }
    var jsonData = JSON.stringify( obj );
    // console.log (jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_submitECR','act':'print','teamIDX':teamIDX,'location':location,'teamName':teamName, 'jsonData':jsonData},
        success: function(str){
            // console.log(str);
            $('#'+divName).remove();
            if (judge==1){
                showListOfTeam_Tech();
            } else {
                $('#TABLE_ECR_LIST').append(str);
            }
            
        }
    });
}
function sae_editEcr(ecrIDX, judge){
    var divName = 'TEMP_DIV_EDIT_NEW_ECR';
    var location = $.cookie('LOCATION');
    var ecrNumber = "00000"+ecrIDX.toString();
    var lastFive = ecrNumber.slice(-4);
    var userIDX = $.cookie('userIDX');
    createNewModalDiv('<b>Engineering Change Request (ECR) : E-'+lastFive+'</b>',divName,850);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_editEcr','act':'print','userIDX':userIDX,'ecrIDX':ecrIDX,'location':location,'divName':divName,'judge':judge},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });
}
function sae_deleteERC(ecrIDX, divName){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_deleteERC','act':'print','ecrIDX':ecrIDX},
        success: function(str){
            $('#TR_ECR_'+ecrIDX).remove();
            $('#'+divName).remove();
        }
    });
}
function sae_submitECR_Update(ecrIDX, divName, judge){
    var obj = {};
    var discover = new Array();
    var system = new Array();
    var location = $.cookie('LOCATION');
    var teamIDX = $('#selectTeamIDX option:selected').val();
    var teamName = $('#selectTeamIDX option:selected').text();
    obj['FK_TEAM_IDX'] = teamIDX;
    $('.sae-check-method').each(function(i){ 
        if ($(this).is(":checked")){ discover.push($(this).val())}
    });
    obj['TX_METHOD'] = discover.join(",");
    $('.sae-check-system').each(function(i){ 
        if ($(this).is(":checked")){ system.push($(this).val())}
    });
    obj['TX_SYSTEM'] = system.join(",");
    $('.sae-input').each(function(i){
        if ($(this).data('key') =='CL_DESCRIPTION' || $(this).data('key') == 'CL_REASON'){
            obj[$(this).data('key')]= encodeURIComponent(escapeVal($(this).val(),"<br />"));
        } else {
            obj[$(this).data('key')]=$(this).val();
        }
        // encodeURIComponent(escapeVal($('#comments_entry_'+subSectionIDX).val(),"<br />"));
        
    });
    var jsonData = JSON.stringify( obj );
    // console.log (jsonData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_submitECR_Update','act':'print','teamIDX':teamIDX,'location':location,'teamName':teamName,'ecrIDX':ecrIDX, 'jsonData':jsonData},
        success: function(str){
            // console.log(str);
            $('#'+divName).remove();
            if (judge ===0){
                sae_openECR();
            } else {
                showListOfTeam_Tech();
            }
            
            // $('#TABLE_ECR_LIST').append(str);
        }
    });
}
function sae_submitECR_Apply(ecrIDX, divName, judge){
    var obj = {};
    var location = $.cookie('LOCATION');
    var inDeduction = $('#IN_DEDUCTION').val();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/ecr.pl',
        data: {'do':'sae_submitECR_Apply','act':'print','inDeduction':inDeduction, 'location':location,'ecrIDX':ecrIDX},
        success: function(str){
            $('#'+divName).remove();
            showListOfTeam_Tech();
        }
    });
}