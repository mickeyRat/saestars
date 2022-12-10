var d=document;
var now = new Date();
var time = now.getTime();
// SECTION
function addASection(inType){
    var divName = 'TEMP_DIV_SECTIONCREATOR';
    createNewModalDiv('Add A Section',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'addASection','act':'print','divName':divName,'inType':inType},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });    
}
function createANewSection(divName, inType){
    var secNumber = $('#secNumber option:selected').val();
    var secTitle = $('#secTitle').val();
    var secWeight = $('#secWeight').val();
    var secClass = $('#secClass option:selected').val();
    // var secType = $('#secType option:selected').val();
    $('#'+divName).remove();
    // alert(divName);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'createANewSection','act':'print','secNumber':secNumber,'secTitle':secTitle,'secWeight':secWeight,'secClass':secClass,'inType':inType},
        success: function(str){
            $('#rubricSection_'+inType).append(str);
        }
    });
}
function updateSection(sectionIDX, divName, inType){
    var secNumber = $('#secNumber option:selected').val();
    var secTitle = $('#secTitle').val();
    var secWeight = $('#secWeight').val();
    var secClass = $('#secClass option:selected').val();
    $('#'+divName).remove();
    // alert(divName);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'updateSection','act':'print','sectionIDX':sectionIDX, 'secNumber':secNumber,'secTitle':secTitle,'secWeight':secWeight,'secClass':secClass,'inType':inType},
        success: function(str){
            // $('#rubricSection').append(str);
            $('#sectionButton_'+sectionIDX).html(str);
        }
    });
}
function deleteSection(sectionIDX){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    // alert(sectionIDX);
    $('.sae-section_'+sectionIDX).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'deleteSection','act':'print','sectionIDX':sectionIDX},
        success: function(str){
            // alert(str);
            // $('#x_modal_Content').html(str);
        }
    });   
}
function showEditSection(sectionIDX, inType){
    var divName = 'TEMP_DIV_SECTION_EDITOR';
    createNewModalDiv('Edit Section',divName,500);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'showEditSection','act':'print','divName':divName,'sectionIDX':sectionIDX,'inType':inType},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });   
}
// SUB SCTION 
function sae_expandSectionType(obj, inType){
    $('#sectionType_'+inType).toggleClass('w3-hide');
    $(obj).children('.fa').toggleClass('fa-chevron-right fa-chevron-down');
}

function expandSubsection(obj, sectionIDX){
    $('#section_'+sectionIDX).toggleClass('w3-hide');
    $(obj).children('.fa').toggleClass('fa-chevron-right fa-chevron-down');
}
function sae_expandAllSubSections(){
    // alert("Expanding all");
    $('.sae-allexpand').addClass('w3-hide');
    $('.sae-subsections-div').removeClass('w3-hide');
    $('.fa-all').removeClass('fa-chevron-right fa-chevron-down').toggleClass('fa-chevron-down');
    // $('.fa-all').addClass('fa-chevron-down');
    $('#button_expandSections').attr('onclick','sae_collapseSections();').html('Collapse Sections');
    $('#button_expandAll').attr('onclick','sae_collapseAll();').html('Collapse All');
}
function sae_collapseSections(){
    // alert("Expanding all");
    $('.sae-allexpand').addClass('w3-hide');
    $('.sae-subsections-div').addClass('w3-hide');
    $('.fa-all').removeClass('fa-chevron-right fa-chevron-down').toggleClass('fa-chevron-right');
    // $('.fa-all').allClass('fa-chevron-right');
    $('#button_expandSections').attr('onclick','sae_expandAllSubSections();').html('Expand Sections');
    $('#button_expandAll').attr('onclick','sae_expandAll();').html('Expand All');
}
function sae_expandAll(){
    // alert("Expanding all");
    $('.sae-allexpand ').removeClass('w3-hide');
    $('.fa-all').removeClass('fa-chevron-right fa-chevron-down');
    $('.fa-all').addClass('fa-chevron-down');
    $('#button_expandAll').attr('onclick','sae_collapseAll();').html('Collapse All');
    $('#button_expandSections').attr('onclick','sae_collapseSections();').html('Collapse Sections');
}
function sae_collapseAll(){
    $('.sae-allexpand ').addClass('w3-hide');
    $('.fa-all').removeClass('fa-chevron-right fa-chevron-down');
    $('.fa-all').addClass('fa-chevron-right');
    $('#button_expandAll').attr('onclick','sae_expandAll();').html('Expand All');
    $('#button_expandSections').attr('onclick','sae_expandAllSubSections();').html('Expand Sections');
}
function expandInstruction(obj, subSectionIDX){
    // alert(subSectionIDX);
    $('#instruction_'+subSectionIDX).toggleClass('w3-hide');
    // $(obj).children('.fa').toggleClass('fa-chevron-right fa-chevron-down');
}
function showAddSubSection(sectionIDX, secNumber, inType){
    var divName = 'TEMP_DIV_SUBSECTION_ADD';
    createNewModalDiv('Add A SubSection',divName,650);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'showAddSubSection','act':'print','divName':divName,'sectionIDX':sectionIDX,'secNumber':secNumber, 'inType':inType},
        success: function(str){
            $('#x_modal_Content').html(str); 
        }
    });    
}
function createSubSection(sectionIDX, secNumber, divName){
    var inNumber = $('#subSecNumber option:selected').val();
    var txTitle = $('#subSecTitle').val();
    var subSecThreshold = $('#subSecThreshold').val();
    var clDescription = encodeURIComponent(escapeVal($('#clDescription').val(),"<br />"));
    var subSecType = $('#subSecType option:selected').val();
    var subSecMinValue = $('#subSecMinValue').val();
    var subSecMaxValue = $('#subSecMaxValue').val();
    var subSecWeight = $('#subSecWeight').val();

    // alert(inNumber);
    // var TxComment = encodeURIComponent(escapeVal($('#COMMENT_FOR_'+PkQuestionIdx).val(),"<br />"));
    $('#'+divName).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'createSubSection','act':'print','secNumber':secNumber,'sectionIDX':sectionIDX, 'subSecMaxValue':subSecMaxValue, 'subSecMinValue':subSecMinValue, 'inNumber':inNumber,'txTitle':txTitle,'subSecThreshold':subSecThreshold,'clDescription':clDescription,'subSecType':subSecType,'subSecWeight':subSecWeight},
        success: function(str){
            $('#table_subsection_'+sectionIDX).append(str);
        }
    });
}
function deleteSubSectionItem(subSectionIDX){
    var jsYes = confirm("Are you sure?");
    if (!jsYes){return}
    // alert(sectionIDX);
    $('.subSection_'+subSectionIDX).remove();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'deleteSubSectionItem','act':'print','subSectionIDX':subSectionIDX},
        success: function(str){
            // alert(str);
        }
    });   
}
function showEditSubSection(subSectionIDX,secNumber){
    var divName = 'TEMP_DIV_SUBSECTION_EDIT';
    createNewModalDiv('Update SubSection',divName,650);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'showEditSubSection','act':'print','divName':divName,'subSectionIDX':subSectionIDX,'secNumber':secNumber},
        success: function(str){
            $('#x_modal_Content').html(str); 
        }
    });  
}
function updateSubSection(subSectionIDX, divName, secNumber){
    var inNumber = $('#subSecNumber option:selected').val();
    var inText = $('#subSecNumber option:selected').text();
    var txTitle = $('#subSecTitle').val();
    var subSecThreshold = $('#subSecThreshold').val();
    var clDescription = encodeURIComponent(escapeVal($('#clDescription').val(),"<br />"));
    var txDescription = $('#clDescription').val();
    var subSecType = $('#subSecType option:selected').val();
    var subSecMinValue = $('#subSecMinValue').val();
    var subSecMaxValue = $('#subSecMaxValue').val();
    var subSecWeight = $('#subSecWeight').val();
    var txType = $('#subSecType option:selected').text();
    $('#'+divName).remove();
    // alert(subSecWeight);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'updateSubSection','act':'print','subSectionIDX':subSectionIDX, 'subSecWeight':subSecWeight, 'subSecMaxValue':subSecMaxValue, 'subSecMinValue':subSecMinValue,'inNumber':inNumber,'txTitle':txTitle,'subSecThreshold':subSecThreshold,'clDescription':clDescription,'subSecType':subSecType},
        success: function(str){
            // alert(str);
            $('#subSectionNumber_'+subSectionIDX).html(secNumber+'.'+inNumber);
            $('#subSectionTitle_'+subSectionIDX).html(txTitle);
            $('#subSectionDescription_'+subSectionIDX).html(txDescription);
            $('#subSectionType_'+subSectionIDX).html(txType);
            $('#subSectionThreshold_'+subSectionIDX).html(subSecThreshold);
            $('#subSectionWeight_'+subSectionIDX).html(subSecWeight);
            // alert(subSectionIDX);
            
        }
    });
}