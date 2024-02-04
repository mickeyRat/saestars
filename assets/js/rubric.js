var d=document;
var now = new Date();
var time = now.getTime();
var newSubSection = {};

// 2024 ==========================================================================
function rubric_addNewSection(o, classIDX, txType, inSection) {
    var txSection = $(o).closest('div').parent().find('input').val();
    // $('#tabContent').append('<h3><i>Section '+inSection+' - </i><b>'+txSection+'</b></h3>');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_addNewSection','act':'print','txType':txType,'classIDX':classIDX,'inSection':inSection,'txSection':txSection},
        success: function(str){
            $('#tabContent').append(str);
            // $('#tabContent').html(str);
            $(o).close();
        }
    }); 
    // body...
    }
function rubric_openAddNewSection(o, classIDX, txType) {
    $.modal("New Section", "45%");
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_openAddNewSection','act':'print','classIDX':classIDX,'txType':txType},
        success: function(str){
            $('#modal_content').html(str);
        }
    }); 
    }
function rubric_openTabClass(o, txType, classIDX) {
    // $('.tabClass').hide();
    $('.tabs').removeClass('w3-red');
    $(o).addClass('w3-red');
    // $('#'+className).show();
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_loadClassRubric','act':'print','txType':txType,'classIDX':classIDX},
        success: function(str){
            $('#tabContent').html(str);
        }
    }); 
    }
function rubric_deleteSubsection(o, divName, reportIDX) {
    var jsYes = confirm("Click [ Ok ] to confirm this DELETE action.");
    if (!jsYes){return}    
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_deleteSubsection','act':'print','reportIDX':reportIDX},
        success: function(str){

        }
    });  

    $('#ROW_SUBSECTION_'+reportIDX).remove();
    $('#'+divName).remove();
    }
function rubric_saveNewSubSectionRecord(o, divName, txType, classIDX) {
    if (!newSubSection.TX_SUB) {alert ('Missing Required Field'); return} 

    // return
    $('#savedMessage').show();
    var data            = {};
    var ajxData         = {}; 
    ajxData.do          = 'rubric_saveNewSubSectionRecord';
    ajxData.act         = 'print';
    ajxData['jsonData'] = JSON.stringify(newSubSection);
    console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: ajxData,
        success: function(str){     
            // console.log(str);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250); 
            newSubSection = {};
            $(o).close();
            // $('#'+divName).remove();
            // console.log('newSubSection Object = ' + JSON.stringify(newSubSection));
            rubric_openTabClass(o, txType, classIDX);

        },
    });
    }
function collectNewSubsectionData(o) {
    var key = $(o).data('key');
    newSubSection[key] = $(o).val();
    if ($(o).is(':checkbox')){
        if ($(o).prop('checked')){
            newSubSection[key] = 1;
        } else {
            newSubSection[key] = 0;
        }
    }
    // console.log('newSubSection Object = ' + JSON.stringify(newSubSection));
    }
function rubric_updateSubsectionData(reportIDX, field, inValue) {
    $('#savedMessage').show();
    var data            = {};
    var ajxData         = {}; 
    data[field]         = inValue;
    ajxData.do          = 'rubric_updateSubsectionData';
    ajxData.act         = 'print';
    ajxData.reportIDX   = reportIDX;
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: ajxData,
        success: function(str){     
            // console.log(str);
            // console.log("inValue="+inValue);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250); 
            if (field == 'IN_SUB_WEIGHT'){
                $('#IN_SUB_WEIGHT_HTML_'+reportIDX).text(parseFloat(inValue).toFixed(1)+'%');
                // console.log("IN IN_SUB_WEIGHT");
            } else if (field == 'BO_REG' || field == 'BO_ADV' || field == 'BO_MIC') {
                if (inValue==1){inValue = 'Yes'} else {inValue = '-'}
                $('#'+field+'_HTML_'+reportIDX).html(inValue);
                // console.log("IN BO_REG");
            } else {
                $('#'+field+'_HTML_'+reportIDX).html(inValue);
                // console.log("IN ELSE");
            }
        },
    });
    }
function rubric_updateSubSectionSelection(o, reportIDX) {

    var inValue;
    if ($(o).is(':checkbox')){
        inValue = 0;
        if ($(o).prop('checked')){inValue=1}
    } else if ( $(o).is('select') ) {
        inValue = $(o).find(':selected').val();
    } else {
        inValue = $(o).val();
    }
    var field = $(o).data('key');
    rubric_updateSubsectionData(reportIDX, field, inValue);
    if (field == 'IN_SEC') {
        inValue = $(o).find(':selected').data('value');
        rubric_updateSubsectionData(reportIDX, 'TX_SEC', inValue);
    }
    // console.log("inValue = " + inValue);
    // console.log("reportIDX = " + reportIDX);
    // console.log("field = " + field);
    }
function rubric_addNewSubSection(o, inSection, txType, txSection, inSectionWeight, nextSubSection, classIDX) {
    // console.log('inSection = ' + inSection);
    // console.log('txType = ' + txType);
    newSubSection.IN_SEC        = inSection;
    newSubSection.TX_SEC        = txSection;
    newSubSection.TX_TYPE       = txType;
    newSubSection.IN_SEC_WEIGHT = inSectionWeight;
    newSubSection.IN_SUB        = nextSubSection;
    newSubSection.FK_CLASS_IDX  = classIDX;
    // console.log('newSubSection Object = ' + JSON.stringify(newSubSection));
    $.modal('Section '+inSection+': '+txSection, '45%');
    // var divName = 'TEMP_DIV_UPDATE_SUBSECTION';
    // createNewModalDiv('<h3>Section '+inSection+': '+txSection+'</h3>',divName,800);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_addNewSubSection','act':'print','inSection':inSection,'txType':txType,'txSection':txSection,'classIDX':classIDX},
        success: function(str){
            // $('#x_modal_Content').html(str);
            $('#modal_content').html(str);
        }
    });   
    }
function rubric_updateSection(o, txType) {
    $('#savedMessage').show();
    var data            = {};
    var ajxData         = {}; 
    var field           = $(o).data('key');
    data[field]         = $(o).val();
    ajxData.do          = 'rubric_updateSection';
    ajxData.act         = 'print';
    ajxData.inSection   = $(o).data('value');
    ajxData.txType      = txType;
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    // return;
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: ajxData,
        success: function(str){     
            // console.log(str);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250); 
            if (field == 'IN_SEC'){
                $(o).data('value',$(o).val());
            }  
        },
    });

    }
function rubric_openSubSection(o, reportIDX, classIDX) {
    var divName = 'TEMP_DIV_UPDATE_SUBSECTION';
    createNewModalDiv('Edit: Subsection',divName,800);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_openSubSection','act':'print','divName':divName,'reportIDX':reportIDX, 'classIDX':classIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });   
    }
function rubric_updateSectionWeight(o, inSection, txType, classIDX) {
    // console.log('inSection = ' + inSection);
    var total = 0;
    $('.weightInput').each(function(){
        total += parseFloat($(this).val());
        // console.log($(this).val());
    });
    $('#SECTION_TOTAL').html(total.toFixed(1)+'%');
    if ( total != 100 ){
        $('#SECTION_TOTAL').addClass('w3-red');
    } else {
        $('#SECTION_TOTAL').removeClass('w3-red');
    }
    // console.log("Total = " + total);
    $('#savedMessage').show();
    var data            = {};
    var ajxData         = {}; 
    data.IN_SEC_WEIGHT  = parseFloat($(o).val());
    ajxData.do          = 'rubric_updateSectionWeight';
    ajxData.act         = 'print';
    ajxData.inSection   = inSection;
    ajxData.txType      = txType;
    ajxData.classIDX    = classIDX;
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: ajxData,
        success: function(str){     
            // console.log(str);
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);  
            $('.SectionWeight_'+inSection).html(parseFloat($(o).val()).toFixed(1)+'%');    
        },
    });
    }
function rubric_updateWeight(o, reportIDX, inSubSection, link) {
    // console.log('reportIDX = ' + reportIDX);
    var totalReg = 0;
    var totalAdv = 0;
    var totalMic = 0;
    var data            = {};
    var ajxData         = {}; 
    data.IN_SUB_WEIGHT  = parseFloat($(o).val());
    ajxData.do          = 'rubric_updateWeight';
    ajxData.act         = 'print';
    ajxData.reportIDX   = reportIDX;
    ajxData['jsonData'] = JSON.stringify(data);
    // console.log(ajxData);
    // console.log("inSubSection="+inSubSection);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: ajxData,
        success: function(str){     
            setTimeout(function(){ $('#savedMessage').fadeOut(350); }, 250);  
            $('.subSectionWeight_'+reportIDX).html(parseFloat($(o).val()).toFixed(1)+' %');    
            $('.subSectionWeight_'+inSubSection).val(parseFloat($(o).val()).toFixed(1));    
            var total = 0;
            $('.weightInput').each(function(){
                total += parseFloat($(this).val());
            });
            $('#SUB_SECTION_TOTAL').html(total.toFixed(1)+'%');
            if ( total != 100 ){
                $('#SUB_SECTION_TOTAL').addClass('w3-red');
            } else {
                $('#SUB_SECTION_TOTAL').removeClass('w3-red');
            }
        },
    });
    }
function rubric_balanceSectionWeight(o, txType, inSection, classIDX) {
    var divName = 'TEMP_DIV_BALANCE';
    createNewModalDiv('Balance Section Setup',divName,600);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_balanceSectionWeight','act':'print','divName':divName,'txType':txType,'inSection':inSection,'classIDX':classIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });    
    }
function rubric_balanceSubsectionWeight(o, txType, inSection, classIDX) {
    var divName = 'TEMP_DIV_BALANCE';
    createNewModalDiv('Balance SubSection Setup',divName,600);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_balanceSubsectionWeight','act':'print','divName':divName,'txType':txType,'inSection':inSection,'classIDX':classIDX},
        success: function(str){
            $('#x_modal_Content').html(str);
        }
    });    
    }
function rubric_loadRubric(o, txType) {
    $('.menu').removeClass('w3-red');
    $(o).addClass('w3-red');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/rubric.pl',
        data: {'do':'rubric_loadRubric','act':'print','txType':txType},
        success: function(str){
            $('#RubricContentElement').html(str);
            rubric_openTabClass(o, txType, 1);
            $('.tab1').addClass('w3-red');
        }
    });    
    }
// 2024 ==========================================================================


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