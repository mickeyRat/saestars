#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Common;
use SAE::Auth;
use SAE::AUTO;
use SAE::REPORTS;
use SAE::REFERENCE;
use SAE::RUBRIC;
my $Util = new SAE::Common();

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
# ***********************************************************************************************************************************
#  REPORT RUBRIC 2019
# ***********************************************************************************************************************************
sub updateSubSection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Rubric = new SAE::RUBRIC();
    my $inNumber = $q->param('inNumber'); 
    my $txTitle = $q->param('txTitle'); 
    my $inMax = $q->param('subSecMaxValue'); 
    my $inMin = $q->param('subSecMinValue'); 
    my $clDescription = uri_unescape($q->param('clDescription'));
    my $subSecType = $q->param('subSecType');
    my $subSecThreshold = $q->param('subSecThreshold');  
    my $subSectionIDX = $q->param('subSectionIDX');  
    my $subSecWeight = $q->param('subSecWeight');  
    $Rubric->_updateSubSectionRecord($inNumber, $txTitle, $clDescription, $subSecType, $subSecThreshold, $inMin , $inMax , $subSecWeight, $subSectionIDX) ;
    return;
}
sub showEditSubSection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $divName = $q->param('divName');  
    my $subSectionIDX = $q->param('subSectionIDX');  
    my $secNumber = $q->param('secNumber');  
    my $Rubric = new SAE::RUBRIC();
    my $Util = new SAE::Common();
    %SUB = %{$Rubric->_getSubSectionRecord($subSectionIDX)};
    my $str;
    $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
    $str .= '<h3>Sub Section</h3>';
    $str .= '<label class="w3-tiny">Sub-Section #</label>';
    $str .= '<select ID="subSecNumber" class="w3-select w3-text-blue">';
    # foreach $section (sort {$a <=> $b} @SECTION) {
    for ($i=1; $i<=100; $i++){
        my $inNumber = $SUB{$subSectionIDX}{IN_SUBSECTION};
        if ($i==$inNumber){
            $str .= '<option Value="'.$i.'" selected>Sub-Section '.$secNumber.'.'.$i.'</option>';
        } else {
            $str .= '<option Value="'.$i.'">Sub-Section '.$secNumber.'.'.$i.'</option>';
        }
        
    }
    # $str .= '<option Value="3">Micro Class</option>';
    $str .= '</select>';
    
    $str .= '<label class="w3-tiny">Sub-Section Title</label>';
    $str .= '<input ID="subSecTitle" class="w3-input w3-text-blue" type="text" value="'.$SUB{$subSectionIDX}{TX_SUBSECTION}.'"placeholder="Sub Section Title">';
    
    $str .= '<label class="w3-tiny">Description</label>';
    $str .= '<textarea id="clDescription" class="w3-input w3-small" style="max-width: 100%; min-height: 150px;" placehlder="Description of this sub-section">';
    # $str .= $SUB{$subSectionIDX}{CL_DESCRIPTION};
    $str .= $Util->removeBr($SUB{$subSectionIDX}{CL_DESCRIPTION});
    $str .= '</textarea>';
    # $str .= '<input ID="secWeight" class="w3-input w3-text-blue" type="number">';
    $str .= '<label class="w3-tiny">Value Type</label>';
    
    $str .= '<select ID="subSecType" class="w3-select w3-text-blue">';
    if ($SUB{$subSectionIDX}{IN_TYPE} == 0) {
        $str .= '<option Value="0" selected>Number</option>';
        $str .= '<option Value="1">Yes/No</option>';
    } else {
        $str .= '<option Value="0">Number</option>';
        $str .= '<option Value="1" selected>Yes/No</option>';
    }
    
    $str .= '</select>';
    
    $str .= '<label class="w3-tiny">Min Value</label>';
    $str .= '<input ID="subSecMinValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_MIN}.'" style="width: 100px; text-align: center; display:inline!important">';
    $str .= '<label class="w3-tiny">Max Value</label>';
    $str .= '<input ID="subSecMaxValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_MAX}.'" style="width: 100px; text-align: center; display:inline!important"><br>';
    
    $str .= '<label class="w3-tiny">Weight</label>';
    $str .= '<input ID="subSecWeight" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_WEIGHT}.'">';
    
    $str .= '<label class="w3-tiny">Comment Threshold (Comments must be provided when score is below this threshold value)</label>';
    $str .= '<input ID="subSecThreshold" class="w3-input w3-text-blue" type="number" min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_THRESHOLD}.'">';

    $str .= '</form>';
    $str .= '<center class="w3-padding-16">';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="updateSubSection('.$subSectionIDX.',\''.$divName.'\', '.$secNumber.');">Save</button>';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    return ($str);
}
sub deleteSubSectionItem(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $subSectionIDX = $q->param('subSectionIDX'); 
    my $str = $Ref->_deleteRecord('TB_SUBSECTION','PK_SUBSECTION_IDX', $subSectionIDX);
    return ($str);
}
sub createSubSection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Rubric = new SAE::RUBRIC();
    my $sectionIDX = $q->param('sectionIDX'); 
    my $inNumber = $q->param('inNumber'); 
    my $secNumber = $q->param('secNumber'); 
    my $txTitle = $q->param('txTitle'); 
    my $inMax = $q->param('subSecMaxValue'); 
    my $inMin = $q->param('subSecMinValue'); 
    my $clDescription = uri_unescape($q->param('clDescription'));
    my $subSecType = $q->param('subSecType');
    my $subSecThreshold = $q->param('subSecThreshold');  
    my $subSecWeight = $q->param('subSecWeight');  
    my $subSectionIDX = $Rubric->_addSubSection($sectionIDX, $inNumber, $txTitle, $clDescription, $subSecType, $subSecThreshold, $inMin , $inMax, $subSecWeight);
    my $str = &sectionList($secNumber, $subSectionIDX, $inNumber, $txTitle, $clDescription, $subSecType, $subSecThreshold);
    return ($str);
}
sub showAddSubSection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $divName = $q->param('divName');  
    my $sectionIDX = $q->param('sectionIDX');  
    my $secNumber = $q->param('secNumber');  
    my $inType = $q->param('inType');  
    my $Rubric=new SAE::RUBRIC();
    my $str;
    $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
    $str .= '<h3>Sub Section</h3>';
    $str .= '<label class="w3-tiny">Sub-Section #</label>';
    $str .= '<select ID="subSecNumber" class="w3-select w3-text-blue">';
    # foreach $section (sort {$a <=> $b} @SECTION) {
    for ($i=1; $i<=100; $i++){
        $str .= '<option Value="'.$i.'">Sub-Section '.$secNumber.'.'.$i.'</option>';
    }
    # $str .= '<option Value="3">Micro Class</option>';
    $str .= '</select>';
    
    $str .= '<label class="w3-tiny">Sub-Section Title</label>';
    $str .= '<input ID="subSecTitle" class="w3-input w3-text-blue" type="text" placeholder="Sub Section Title">';
    
    $str .= '<label class="w3-tiny">Description</label>';
    $str .= '<textarea id="clDescription" class="w3-input w3-small" style="max-width: 100%; min-height: 120px;" placehlder="Description of this sub-section">';
    $str .= '</textarea>';
    # $str .= '<input ID="secWeight" class="w3-input w3-text-blue" type="number">';
    $str .= '<label class="w3-tiny">Value Type</label>';
    
    $str .= '<select ID="subSecType" class="w3-select w3-text-blue">';
    $str .= '<option Value="0">Number</option>';
    $str .= '<option Value="1">Yes/No</option>';
    $str .= '</select>';
    
    $str .= '<label class="w3-tiny">Min Value</label>';
    $str .= '<input ID="subSecMinValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="0" style="width: 100px; text-align: center; display:inline!important">';
    $str .= '<label class="w3-tiny">Max Value</label>';
    $str .= '<input ID="subSecMaxValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="100" style="width: 100px; text-align: center; display:inline!important"><br>';
    
    $str .= '<label class="w3-tiny">Weight</label>';
    $str .= '<input ID="subSecWeight" class="w3-input w3-text-blue" type="number"  min="1" max="100" placeholder="0">';

    $str .= '<label class="w3-tiny">Comment Threshold (Comments must be provided when score is below this threshold value)</label>';
    $str .= '<input ID="subSecThreshold" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="50">';

    $str .= '</form>';
    $str .= '<center class="w3-padding-16">';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="createSubSection('.$sectionIDX.','.$secNumber.',\''.$divName.'\');">Save</button>';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    return ($str);
}
sub deleteSection(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $sectionIDX = $q->param('sectionIDX');  
    my $str = $Ref->_deleteRecord('TB_SECTION','PK_SECTION_IDX', $sectionIDX);
    return;
}
sub createANewSection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Rubric = new SAE::RUBRIC();
    my $secNumber = $q->param('secNumber'); 
    my $secTitle = $q->param('secTitle'); 
    my $secWeight = $q->param('secWeight'); 
    my $secClass = $q->param('secClass'); 
    my $inType = $q->param('inType'); 
    my $str;
    my $sectionIDX = $Rubric->_createNewSection($secNumber, $secTitle, $secWeight, $secClass, $inType);
    $str = &__template_sectionList($sectionIDX, $secNumber, $secTitle, $secWeight, $secClass, $inType);
    return ($str);
}
sub sectionList(){
    my ($secNumber, $subSectionIDX, $number, $title, $description, $typeID, $threshold, $weight, $inType) = @_;
    my %TYPE = (0=>"Number", 1=>"Yes/No");
    my $str;
    $str = '<tr class="subSection_'.$subSectionIDX.'"  class="w3-small">';
    $str .= '<td ID="subSectionNumber_'.$subSectionIDX.'"  class="w3-small">'.$secNumber.'.'.$number.'</td>';
    $str .= '<td ID="subSectionTitle_'.$subSectionIDX.'" class="w3-small">'.$title.'</td>';
    $str .= '<td ID="subSectionDescription_'.$subSectionIDX.'" class="w3-small">'.$description.'</td>';
    $str .= '<td ID="subSectionType_'.$subSectionIDX.'"  class="w3-small">'.$TYPE{$typeID}.'</td>';
    $str .= '<td ID="subSectionThreshold_'.$subSectionIDX.'" class="w3-center w3-small">'.$threshold.'</td>';
    $str .= '<td ID="subSectionWeight_'.$subSectionIDX.'" class="w3-center w3-small">'.$weight.'</td>';
    # $str .= '<td ID="subSectionWeight_'.$subSectionIDX.'" class="w3-center w3-small">subSectionWeight_'.$subSectionIDX.'</td>';
    $str .= '<td class="w3-small">';
    # $str .= $subSectionIDX;
    $str .= '<a href="javascript:void(0);" class="w3-link" onclick="showEditSubSection('.$subSectionIDX.', '.$secNumber.');">Edit</a>';
    $str .= '<a href="javascript:void(0);" class="w3-link w3-margin-left" onclick="deleteSubSectionItem('.$subSectionIDX.');">Delete</a>';
    $str .= '</td>';
    $str .= '</tr>';
    return ($str);
}
sub __template_sectionList(){
    my ($sectionIDX, $secNumber, $secName, $secWeight, $secClass, $inType) = @_;
    %APP = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str;
    my $Rubics = new SAE::RUBRIC;
    %LIST = %{$Rubics->_getSubSection($sectionIDX)};
    $str = '<button style="margin-top: 5px;" class="w3-button w3-block w3-left-align w3-light-grey sae-section_'.$sectionIDX.'" onclick="expandSubsection(this, '.$sectionIDX.')" >';
    $str .= '<i class="fa fa-chevron-right"></i>&nbsp;&nbsp;';
    $str .= '<span ID="sectionButton_'.$sectionIDX.'" >'.$secNumber.' - '.$secName.' - '.$APP{$secClass}.' ('.$secWeight.'%)</span>';
    # $str .= &_tempSectionButton($sectionIDX, $secNumber , $secName , $secWeight);
    $str .= '</button>';
    $str .= '<div ID="section_'.$sectionIDX.'" class="w3-hide w3-container w3-white w3-card-2 w3-border sae-section_'.$sectionIDX.'">';
    $str .= '<div class="w3-panel" style="padding: 5px; margin: 0px;">';
    $str .= '<button class="w3-button" style="margin-left: 10px;" onclick="showAddSubSection('.$sectionIDX.','.$secNumber.','.$inType.');">Add Sub-Section</button>';
    $str .= '<button class="w3-button" style="margin-left: 10px;" onclick="showEditSection('.$sectionIDX.', '.$inType.');">Edit Section</button>';
    $str .= '<button class="w3-button" style="margin-left: 10px;" onclick="deleteSection('.$sectionIDX.');">Delete Section</button>';
    $str .= '</div>';
    $str .= '<table ID="table_subsection_'.$sectionIDX.'" class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr class="w3-light-grey">';
    $str .= '<th style="width: 15px;">#</th>';
    $str .= '<th style="width: 100px;">Title</th>';
    $str .= '<th>Description</th>';
    $str .= '<th style="width: 15px;">Type</th>';
    $str .= '<th style="width: 15px;">Threshold</th>';
    $str .= '<th style="width: 15px;">Weight</th>';
    $str .= '<th style="width: 15px;">Action</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    # print scalar(keys %LIST);
    $str .= '<tbody>';
    foreach $subSectionIDX (sort {$LIST{$a}{IN_SUBSECTION} <=> $LIST{$b}{IN_SUBSECTION}} keys %LIST) {
        my $subNumber = $LIST{$subSectionIDX}{IN_SUBSECTION};
        my $subTitle = $LIST{$subSectionIDX}{TX_SUBSECTION};
        my $subDescription = $LIST{$subSectionIDX}{CL_DESCRIPTION};
        my $subType = $LIST{$subSectionIDX}{IN_TYPE};
        my $subThreshold = $LIST{$subSectionIDX}{IN_THRESHOLD};
        my $subWeight= $LIST{$subSectionIDX}{IN_WEIGHT};
        $str .= &sectionList($secNumber, $subSectionIDX, $subNumber, $subTitle, $subDescription, $subType, $subThreshold, $subWeight, $inType);
    }
    $str .= '</tbody>';
    $str .= '</table>';
    $str .= '<p>&nbsp;</p>';
    $str .= '</div>';
    return ($str);
}
sub updateSection(){
    print $q->header();
    my $Rubric = new SAE::RUBRIC();
    my $secNumber = $q->param('secNumber'); 
    my $secTitle = $q->param('secTitle'); 
    my $secWeight = $q->param('secWeight'); 
    my $secClass = $q->param('secClass'); 
    my $sectionIDX = $q->param('sectionIDX'); 
    %APP = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    $Rubric->_updateSectionRecord($secNumber, $secTitle, $secWeight, $secClass, $sectionIDX);
    my $str = $secNumber.' - '.$secTitle.' - '.$APP{$secClass}.' ('.$secWeight.'%)';
    # my $str = &_tempSectionButton($sectionIDX, $secNumber , $secTitle , $secWeight);
    return ($str);
}
sub showEditSection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $divName = $q->param('divName');  
    my $inType = $q->param('inType');  
    my $sectionIDX = $q->param('sectionIDX');  
    my $Rubric=new SAE::RUBRIC();
    %SEC = %{$Rubric->_getSectionRecord($sectionIDX)};
    %CLASS = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
    $str .= '<h3>Rubric</h3>';
    $str .= '<label class="w3-tiny">Section #</label>';
    $str .= '<select ID="secNumber" class="w3-select w3-text-blue">';
    for ($section=1; $section<=100; $section++){
        if ($section == $SEC{$sectionIDX}{IN_SECTION}) {
            $str .= '<option Value="'.$section.'" selected>Section '.$section.'</option>';
        } else {
            $str .= '<option Value="'.$section.'">Section '.$section.'</option>';
        }
    }
    $str .= '</select>';
    $str .= '<label class="w3-tiny">Section Title</label>';
    $str .= '<input ID="secTitle" class="w3-input w3-text-blue" value="'.$SEC{$sectionIDX}{TX_SECTION}.'" type="text">';
    $str .= '<label class="w3-tiny">Weight (0 - 100%)</label>';
    $str .= '<input ID="secWeight" class="w3-input w3-text-blue" value="'.$SEC{$sectionIDX}{IN_WEIGHT}.'" type="number">';
    $str .= '<label class="w3-tiny">Class Applicability</label>';
    $str .= '<select ID="secClass" class="w3-select w3-text-blue">';
    my $secClass = $SEC{$sectionIDX}{IN_CLASS};
    foreach $value (sort {$a <=> $b} keys %CLASS) {
        if ($value == $secClass) {
            $str .= '<option Value="'.$value.'" selected>'.$CLASS{$value}.'</option>';
        } else {
            $str .= '<option Value="'.$value.'">'.$CLASS{$value}.'</option>';
        }
    }
    $str .= '</select>';
    $str .= '</form>';
    $str .= '<center class="w3-padding-16">';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="updateSection('.$sectionIDX.',\''.$divName.'\','.$inType.');">Save</button>';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    return ($str);
}
sub addASection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $divName = $q->param('divName');  
    my $inType = $q->param('inType');  
    my $Rubric=new SAE::RUBRIC();
    %CLASS = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
    $str .= '<h3>Rubric</h3>';
    $str .= '<label class="w3-tiny">Section #</label>';
    $str .= '<select ID="secNumber" class="w3-select w3-text-blue">';
    for ($section=1; $section<=20; $section++){
        $str .= '<option Value="'.$section.'">Section '.$section.'</option>';
    }
    $str .= '</select>';
    $str .= '<label class="w3-tiny">Section Title</label>';
    $str .= '<input ID="secTitle" class="w3-input w3-text-blue" type="text">';
    $str .= '<label class="w3-tiny">Weight (0 - 100%)</label>';
    $str .= '<input ID="secWeight" class="w3-input w3-text-blue" type="number" placeholder="0.0">';
    $str .= '<label class="w3-tiny">Class Applicability</label>';
    $str .= '<select ID="secClass" class="w3-select w3-text-blue">';
    foreach $value (sort {$a <=> $b} keys %CLASS) {
        $str .= '<option Value="'.$value.'">'.$CLASS{$value}.'</option>';
    }
    $str .= '</select>';
    $str .= '</form>';
    $str .= '<center class="w3-padding-16">';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="createANewSection(\''.$divName.'\','.$inType.');">Save</button>';
    $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    return ($str);
}   
sub rubricHomePage(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');  
    my $str;
    my $Rubric=new SAE::RUBRIC();
    %SECTION = %{$Rubric->_getSectionList()};
    %TYPE=%{$Rubric->_getRubricType()};
    $str = '<div class="w3-container w3-margin-top">';
    $str .= '<br><h2>Rubric Management & Settings</h2>';
    foreach $inType (sort {$TYPE{$a}{IN_ORDER} <=> $TYPE{$b}{IN_ORDER}} keys %TYPE){
        if ($inType>5){next;}
        $str .= '<button tabstop="false" tabindex="-1" style="margin-top: 2px;" class="w3-button w3-display-container w3-block w3-left-align w3-light-blue" onclick="sae_expandSectionType(this, '.$inType.')">';
        $str .= '<i class="fa fa-chevron-right fa-all"></i>&nbsp;&nbsp;';
        $str .= '<span>'.$TYPE{$inType}{TX_TITLE}.'</span>';
        $str .= '</button>';
        $str .= '<div ID="sectionType_'.$inType.'" class="w3-hide w3-container w3-border-bottom w3-padding w3-card-2">';
        $str .= '<div class="w3-bar w3-border-bottom">';
        $str .= '<button class="w3-button w3-border w3-round" onclick="addASection('.$inType.');">Add '.$TYPE{$inType}{TX_TITLE}.' Section</button>';
        $str .= '</div>';
        # $str .= '<h4 class="w3-padding-small w3-button w3-panel">'.$TYPE{$inType}{TX_TITLE}.' Rubric</h4>';

        $str .= '<div ID="rubricSection_'.$inType.'" >';
        foreach $sectionIDX ( sort {$SECTION{$inType}{$a}{IN_SECTION} <=> $SECTION{$inType}{$b}{IN_SECTION}} keys %{$SECTION{$inType}} ) {
            $secNumber = $SECTION{$inType}{$sectionIDX}{IN_SECTION};
            $secWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
            $secTitle = $SECTION{$inType}{$sectionIDX}{TX_SECTION};
            $secClass = $SECTION{$inType}{$sectionIDX}{IN_CLASS};
            $str .= &__template_sectionList($sectionIDX, $secNumber, $secTitle, $secWeight, $secClass, $inType);
        }
        $str .= '</div>';
        $str .= '<div ID="rubricSubSection"></div>';
        $str .= '</div>';
    }   
    $str .= '</div>';
    return ($str);
}