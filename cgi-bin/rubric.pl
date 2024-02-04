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
use SAE::TABLE;

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
#  REPORT RUBRIC 2024
# ***********************************************************************************************************************************
sub rubric_addNewSection (){
    print $q->header();
    my $Rubric       = new SAE::RUBRIC();
    my $classIDX     = $q->param('classIDX');
    my $txType       = $q->param('txType');
    my $inSection    = $q->param('inSection');
    my $txSection    = $q->param('txSection');
    my $inWeight     = 0;
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str = sprintf '<h3><i>Section %d </i>- <b>%s</b> (<a class="SectionWeight_%d" href="javascript:void(0);" onclick="rubric_balanceSectionWeight(this, \'%s\', %d, %d);">%2.1f%</a>)</h3>', $inSection, $txSection, $inSection, $txType, $inSection, $classIDX, $secWeight;
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th style="width: 5%">#</th>';
    $str .= sprintf '<th style="width:85%;"><button class="w3-button w3-border w3-round w3-hover-green w3-card-2" onclick="rubric_addNewSubSection(this, %d, \'%s\', \'%s\', \'%2.1f\', %d, %d);">Add New Title</button></th>', $inSection, $txType, $txSection, $secWeight, $nextSubsentionNumber, $classIDX;
    $str .= '<th style="width: 10%; text-align: right;">Weight</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    $str .= '</tbody>';
    $str .= '</table>';

    return ($str);
    }
sub rubric_openAddNewSection (){
    print $q->header();
    my $Rubric    = new SAE::RUBRIC();
    my $classIDX  = $q->param('classIDX');
    my $txType    = $q->param('txType');
    my $inSection = $Rubric->_getNextSectionNumber($classIDX, $txType);
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= '<div class="w3-container w3-padding">';
    $str .= sprintf '<h2>Section %d</h2>', $inSection;
    $str .= '<input type="text" class="w3-input w3-border w3-round" placeholder="Section Title">';
    $str .= '<div class="w3-container w3-center w3-padding-24">';
    $str .= '<button class="w3-button w3-round w3-border w3-margin-right" onclick="$(this).close();">Cancel</button>';
    $str .= sprintf '<button class="w3-button w3-round w3-border w3-pale-green w3-hover-green w3-margin-left" onclick="rubric_addNewSection(this, %d, \'%s\', %d);">Create</button>', $classIDX, $txType, $inSection;
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
sub rubric_deleteSubsection (){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $reportIDX = $q->param('reportIDX');  
    my $str = $Ref->_deleteRecord('TB_REPORT','PK_REPORT_IDX', $reportIDX);
    return;
    }
sub rubric_saveNewSubSectionRecord (){
    my $eventIDX= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Table        = new SAE::TABLE();
    my $newReportIDX = $Table->_saveAsNew('TB_REPORT', $q->param('jsonData'));
    my $str = $newReportIDX;
    return ($str);
    }
sub rubric_updateSubsectionData (){
    print $q->header();
    my $reportIDX= $q->param('reportIDX');
    my %CONDITION   = ('PK_REPORT_IDX'=>$reportIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table       = new SAE::TABLE();
       $Table->_save('TB_REPORT', $q->param('jsonData'), $json_dcondition);
    return ($str);
    }
sub rubric_addNewSubSection (){
    print $q->header();
    my $txType    = $q->param('txType');
    my $txSection = $q->param('txSection');
    my $inSection = $q->param('inSection');
    my $divName   = $q->param('divName');
    my $classIDX   = $q->param('classIDX');
    my $Rubric    = new SAE::RUBRIC();
    my %SEC       = %{$Rubric->_getRubricSectionListByType($txType)};
    my $nextSubsentionNumber = $Rubric->_getLastSubSectionNumber($txType, $inSection, $classIDX);
    my $str;
    $str .= '<div class="w3-container" style="height: 600px; overflow-y: auto">';
        $str .= '<table class="w3-table-all">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 20%;">Field</th>';
        $str .= '<th>Data</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        $str .= '<tr>';
        $str .= sprintf '<td>SubSection #</td>';
        $str .= sprintf '<td><input type="number" data-key="IN_SUB" style="width: 125px;" min="1" class="w3-input w3-border" value="%d" onblur="collectNewSubsectionData(this);"></td>', $nextSubsentionNumber;
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>Title <i class="w3-small w3-text-red">(required)</i></td>';
        $str .= sprintf '<td><input type="text" data-key="TX_SUB" class="w3-input w3-border" required value="" onblur="collectNewSubsectionData(this);" placeholder="Subsection Title"></td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td colspan="2">Rubric Scoring Criteria';
        $str .= sprintf '<textarea class="w3-input w3-border" data-key="CL_DESCRIPTION" style="min-width: 100%; height: 50px;"   onKeyUp="grade_autoAdjustHeight(this);"  onblur="collectNewSubsectionData(this);" ></textarea></td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>Assessment Value</td>';
        $str .= sprintf '<td>';
        $str .= sprintf '<span class="w3-padding"><input type="radio" data-key="BO_BIN" value="0" name="BO_BIN" class="w3-radio" onclick="collectNewSubsectionData(this);"> Numeric </span>';
        $str .= sprintf '<span class="w3-padding"><input type="radio" data-key="BO_BIN" value="1" name="BO_BIN" class="w3-radio" onclick="collectNewSubsectionData(this);"> Yes|No </span>';
        $str .= sprintf '</td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>Weight of %d%</td>', $SUB{IN_SEC_WEIGHT};
        $str .= sprintf '<td><div class="w3-display-container">';
        $str .= sprintf '<input type="number" class="w3-input w3-border w3-left" data-key="IN_SUB_WEIGHT" min="0" step="5" value="%s" style="width: 75px; padding-right: 20px;"onChange="collectNewSubsectionData(this);">', $SUB{IN_SUB_WEIGHT};
        $str .= sprintf '<span style="position: relative; left: -20px; top: 9px;">%</span>';
        $str .= sprintf '</div></td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= '<td colspan="2" class="w3-display-container">';
        $str .= sprintf '<button class="w3-button w3-hover-red w3-border w3-round w3-left" onclick="$(this).close();">cancel</button>';
        $str .= sprintf '<button class="w3-button w3-green w3-border w3-round w3-right" onclick="rubric_saveNewSubSectionRecord(this, \'%s\', \'%s\', %d);">Save</button>',$divName, $txType, $classIDX;
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '</tbody>';
        $str .= '</table>';
    $str .= '</div>';
    return ($str);
    }
sub rubric_openSubSection (){
    print $q->header();
    my $reportIDX = $q->param('reportIDX');
    my $divName   = $q->param('divName');
    my $txType   = $q->param('txType');
    my $classIDX   = $q->param('classIDX');
    my $Rubric    = new SAE::RUBRIC();
    my %SUB       = %{$Rubric->_getSubSectionDetails($reportIDX)};
    my %SEC       = %{$Rubric->_getRubricSectionListByType($SUB{TX_TYPE}, $classIDX)};
    my $str;
    $str .= '<div class="w3-container" style="height: 600px; overflow-y: auto">';
        $str .= '<table class="w3-table-all">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 20%;">Title</th>';
        $str .= '<th>Data</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        $str .= '<tr>';
        $str .= sprintf '<td>Section </td>';
        $str .= sprintf '<td>';
        $str .= sprintf '<select data-key="IN_SEC" class="w3-select w3-border" onchange="rubric_updateSubSectionSelection(this, %d);">', $reportIDX;
        foreach $txSec (sort {$SEC{$a}{IN_SEC} <=> $SEC{$b}{IN_SEC}} keys %SEC) {
            my $inSec = $SEC{$txSec}{IN_SEC};
            if ($txSec eq $SUB{TX_SEC}){
                    $str .= sprintf '<option value="%d" selected data-value="%s" >%d - %s</option>', $inSec , $txSec, $inSec , $txSec;
                } else {
                    $str .= sprintf '<option value="%d" data-value="%s">%d - %s</option>', $inSec , $txSec, $inSec , $txSec;
                }
        }
        $str .= sprintf '</select>'; 
        $str .= sprintf '</td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>SubSection #</td>';
        $str .= sprintf '<td><input data-key="IN_SUB" type="number" style="width: 125px;" min="1" class="w3-input w3-border" value="%d" onblur="rubric_updateSubSectionSelection(this, %d);"></td>', $SUB{IN_SUB}, $reportIDX;
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>Title</td>';
        $str .= sprintf '<td><input data-key="TX_SUB" type="text" class="w3-input w3-border" value="%s" onblur="rubric_updateSubSectionSelection(this, %d);"></td>', $SUB{TX_SUB}, $reportIDX;
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td colspan="2">Rubric Scoring Criteria';
        $str .= sprintf '<textarea data-key="CL_DESCRIPTION" class="w3-input w3-border" style="min-width: 100%; height: 50px;" onBlur="rubric_updateSubSectionSelection(this, %d);" onKeyUp="grade_autoAdjustHeight(this);" onfocus="grade_autoAdjustHeight(this);">%s</textarea></td>', $reportIDX, $SUB{CL_DESCRIPTION};
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>Assessment Value</td>';
        $str .= sprintf '<td>';
        if ($SUB{BO_BIN}) {
                $str .= sprintf '<span class="w3-padding"><input type="radio" class="w3-radio" name="BO_BIN" data-key="BO_BIN" value="0" onClick="rubric_updateSubSectionSelection(this, %d);"> Numeric </span>', $reportIDX;
                $str .= sprintf '<span class="w3-padding"><input type="radio" class="w3-radio" name="BO_BIN" data-key="BO_BIN" value="1" onClick="rubric_updateSubSectionSelection(this, %d);" checked> Yes|No </span>', $reportIDX;
            } else {
                $str .= sprintf '<span class="w3-padding"><input type="radio" class="w3-radio" name="BO_BIN" data-key="BO_BIN" value="0" onClick="rubric_updateSubSectionSelection(this, %d);" checked> Numeric </span>', $reportIDX;
                $str .= sprintf '<span class="w3-padding"><input type="radio" class="w3-radio" name="BO_BIN" data-key="BO_BIN" value="1" onClick="rubric_updateSubSectionSelection(this, %d);"> Yes|No </span>', $reportIDX;
            }
        $str .= sprintf '</td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= sprintf '<td>Weight of %d%</td>', $SUB{IN_SEC_WEIGHT};
        $str .= sprintf '<td><div class="w3-display-container">';
        $str .= sprintf '<input data-key="IN_SUB_WEIGHT" type="number" class="w3-input w3-border w3-left" value="%s" style="width: 120px; padding-right: 20px;" onchange="rubric_updateSubSectionSelection(this, %d);" >', $SUB{IN_SUB_WEIGHT}, $reportIDX;
        $str .= sprintf '<span style="position: relative; left: -20px; top: 9px;">%</span>';
        $str .= sprintf '</div></td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= '<td colspan="2" class="w3-display-container">';
        $str .= sprintf '<button class="w3-button w3-hover-red w3-border w3-round w3-left w3-pale-red" onclick="rubric_deleteSubsection(this, \'%s\', %d);">Delete</button>', $divName, $reportIDX;
        $str .= sprintf '<button class="w3-button w3-green w3-border w3-round w3-right" onclick="$(\'#%s\').remove();">Close</button>',$divName;
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '</tbody>';
        $str .= '</table>';
    $str .= '</div>';
    return ($str);
    }
sub rubric_updateSectionWeight (){
    print $q->header();
    my $inSection        = $q->param('inSection');
    my $txType           = $q->param('txType');
    my $classIDX         = $q->param('classIDX');
    my %CONDITION        = ('IN_SEC'=>$inSection, 'TX_TYPE'=>$txType, 'FK_CLASS_IDX'=>$classIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table            = new SAE::TABLE();
       $Table->_save('TB_REPORT', $q->param('jsonData'), $json_dcondition);
    return ($str);
    }
sub rubric_updateSection (){
    print $q->header();
    my $inSection= $q->param('inSection');
    my $txType= $q->param('txType');
    my %CONDITION   = ('IN_SEC'=>$inSection, 'TX_TYPE'=>$txType);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table       = new SAE::TABLE();
       $Table->_save('TB_REPORT', $q->param('jsonData'), $json_dcondition);
    return ($str);
    }
sub rubric_updateWeight (){
    print $q->header();
    my $reportIDX= $q->param('reportIDX');
    my %CONDITION   = ('PK_REPORT_IDX'=>$reportIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table       = new SAE::TABLE();
       $Table->_save('TB_REPORT', $q->param('jsonData'), $json_dcondition);
    return ($str);
    }
sub rubric_balanceSectionWeight (){
    print $q->header();
    my $eventIDX  = $q->param('eventIDX');
    my $txType    = $q->param('txType');
    my $classIDX  = $q->param('classIDX');
    my $Rubric    = new SAE::RUBRIC();
    my %SEC       = %{$Rubric->_getRubricSectionListByType($txType, $classIDX)};
    my $str;
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr  class="w3-grey">';
    $str .= '<th style="width: 15%;">#</th>';
    $str .= '<th>Section</th>';
    $str .= '<th style="width: 20%;">Weight</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    my $total = 0;
    foreach $txSec (sort {$SEC{$a}{IN_SEC} <=> $SEC{$b}{IN_SEC}} keys %SEC) {
        my $inSection   = $SEC{$txSec}{IN_SEC};
        my $inSecWeight = $SEC{$txSec}{IN_SEC_WEIGHT};
        $str .= '<tr>';
        $str .= sprintf '<td>%d</td>', $inSection;
        $str .= sprintf '<td>%s</td>', $txSec;
        $str .= sprintf '<td style="text-align: right;">';
        $str .= sprintf '<input class="weightInput w3-input w3-border w3-round" style="text-align: right;" type="number" value="%2.1f" onchange="rubric_updateSectionWeight(this, %d, \'%s\', %d);">', $inSecWeight, $inSection, $txType, $classIDX;
        $str .= sprintf '</td>';
        $str .= '</tr>';
        $total += $SEC{$txSec}{IN_SEC_WEIGHT};
    }
    $str .= '<tr class="w3-light-grey">';
    $str .= '<td colspan="2" style="text-align: right;" class="w3-xlarge">Total</td>';
    my $totalBg = '';
    if ($total != 100) {$totalBg = 'w3-red'}
    $str .= sprintf '<td ><div ID="SECTION_TOTAL" class="w3-container %s w3-border w3-round w3-padding" >%2.1f%</div></td>', $totalBg, $total ;
    $str .= '</tr>';
    $str .= '</tbody>';
    $str .= '</table>';
    return ($str);
    }
sub rubric_balanceSubsectionWeight (){
    my $txType    = $q->param('txType');
    my $inSection = $q->param('inSection');
    my $classIDX = $q->param('classIDX');
    print $q->header();
    my $Rubric  = new SAE::RUBRIC();
    my %WEIGHT  = %{$Rubric->_getRubricWeight_ByType($txType, $inSection, $classIDX)};
    my $str;
    $str .= '<div class="w3-container" style="height: 600px; overflow-y: auto">';
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th>Sub-section</th>';
    $str .= '<th style="width: 17%;">Weight</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    my $total        = 0;
    foreach $reportIDX (sort {$WEIGHT{$a}{IN_SUB} <=> $WEIGHT{$b}{IN_SUB}} keys %WEIGHT) {
        my $inSubsection = $WEIGHT{$reportIDX}{IN_SUB};
        my $inSubWeight  = $WEIGHT{$reportIDX}{IN_SUB_WEIGHT};
        $str .= '<tr>';
        $str .= sprintf '<td style="text-align: left;">%d. %s</td>', $WEIGHT{$reportIDX}{IN_SUB}, $WEIGHT{$reportIDX}{TX_SUB};
        $str .= sprintf '<td style="text-align: right; padding: 0px;">';
        $str .= sprintf '<input class="weightInput w3-input w3-border w3-round" style="text-align: right;" type="number" value="%2.1f" onchange="rubric_updateWeight(this, %d, %d);">', $inSubWeight, $reportIDX, $inSubsection;
        $str .= sprintf '</td>';
        $total += $inSubWeight;
        $str .= '</tr>';
    }
    $str .= '<tr>';
    $str .= '<td style="text-align: right;" class="w3-xlarge">Total</td>';
    my $totalBg = '';
    if ($total != 100) {$totalBg = 'w3-red'}
    $str .= sprintf '<td ><div ID="SUB_SECTION_TOTAL" class="w3-container %s w3-border w3-round w3-padding" >%2.1f%</div></td>', $totalBg, $total ;
    $str .= '</tr>';
    $str .= '</tbody>';
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
    }
sub rubric_loadClassRubric (){
    print $q->header();
    my $eventIDX= $q->param('eventIDX');
    my $classIDX= $q->param('classIDX');
    my $txType  = $q->param('txType'); 
    my $Rubric  = new SAE::RUBRIC();
    my %CLASS   = (1=>'Regular Class',2=>'Advanced Class',3=>'Micro Class');
    my %RUBRIC  = %{$Rubric->_getRubricBySection($txType, $classIDX)};
    my %SECTION = %{$Rubric->_getRubricSectionListByType($txType, $classIDX)};
    my $txClass = $CLASS{$classIDX};
    my $str;
    # $str .= sprintf '<h2 class="w3-bar w3-border w3-light-grey w3-padding">';
    $str .= '<div class="w3-container w3-bar w3-border w3-light-gre w3-padding">';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-right w3-card-2 w3-hover-green" onclick="rubric_openAddNewSection(this, %d, \'%s\');">Add New %s Section</button>', $classIDX, $txType, $txClass;
    # $str .= sprintf '<span class="w3-margin-right w3-xlarge">%s</span>', $txClass;
    $str .= '</div>';
    foreach $txSection (sort { $SECTION{$a}{IN_SEC} <=> $SECTION{$b}{IN_SEC} } keys %SECTION) {
        my $inSection = $SECTION{$txSection}{IN_SEC};
        my $secWeight = $SECTION{$txSection}{IN_SEC_WEIGHT};
        my $nextSubsentionNumber = $Rubric->_getLastSubSectionNumber($txType, $inSection, $classIDX);
        # $str .= '<div class="w3-container">';
        $str .= sprintf '<h3><i>Section %d </i>- <b>%s</b> (<a class="SectionWeight_%d" href="javascript:void(0);" onclick="rubric_balanceSectionWeight(this, \'%s\', %d, %d);">%2.1f%</a>)</h3>', $inSection, $txSection, $inSection, $txType, $inSection, $classIDX, $secWeight;
        $str .= '<table class="w3-table-all">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 5%">#</th>';
        $str .= sprintf '<th style="width:85%;"><button class="w3-button w3-border w3-round w3-hover-green w3-card-2" onclick="rubric_addNewSubSection(this, %d, \'%s\', \'%s\', \'%2.1f\', %d, %d);">Add New Title</button></th>', $inSection, $txType, $txSection, $secWeight, $nextSubsentionNumber, $classIDX;
        $str .= '<th style="width: 10%; text-align: right;">Weight</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $inSubsection (sort  {$a <=> $b} keys %{$RUBRIC{$inSection}}) {
            foreach $reportIDX (sort  {$a <=> $b} keys %{$RUBRIC{$inSection}{$inSubsection}}) {
                my $txSub    = $RUBRIC{$inSection}{$inSubsection}{$reportIDX}{TX_SUB};
                my $inWeight = $RUBRIC{$inSection}{$inSubsection}{$reportIDX}{IN_SUB_WEIGHT};
                $str .= sprintf '<tr ID="ROW_SUBSECTION_%d">', $reportIDX;
                $str .= sprintf '<td ID="IN_SUB_HTML_%d">%d</td>', $reportIDX, $inSubsection ;
                $str .= sprintf '<td><a ID="TX_SUB_HTML_%d" href="javascript:void(0);" onclick="rubric_openSubSection(this, %d, %d);">%s</a></td>', $reportIDX, $reportIDX, $classIDX, $txSub;
                $str .= sprintf '<td style="text-align: right;" >';
                $str .= sprintf '<a ID="IN_SUB_WEIGHT_HTML_%d" class="subSectionWeight_%d" href="javascript:void(0);" onclick="rubric_balanceSubsectionWeight(this, \'%s\', %d, %d);">%2.1f %</a></td>', $reportIDX, $reportIDX, $txType, $inSection, $classIDX, $inWeight;
                $str .= '</tr>';
            }
        }
        $str .= '</tbody>';
        $str .= '</table>';
        # $str .= '</div>';
    }
    return ($str);
    }
sub rubric_loadRubric(){
    print $q->header();
    my $eventIDX= $q->param('eventIDX');
    my $txType  = $q->param('txType'); 
    my $str;
    $str .= '<div class="w3-bar w3-teal w3-margin-top">';
    $str .= sprintf '<button class="tab1 w3-bar-item w3-button tabs w3-red" onclick="rubric_openTabClass(this, \'%s\', 1);">Regular Class</button>', $txType ;
    $str .= sprintf '<button class="w3-bar-item w3-button tabs" onclick="rubric_openTabClass(this, \'%s\', 2);">Advanced Class</button>', $txType ;
    $str .= sprintf '<button class="w3-bar-item w3-button tabs" onclick="rubric_openTabClass(this, \'%s\', 3);">Micro Class</button>', $txType ;
    $str .= '</div>';
    $str .= '<div id="tabContent" class="w3-container w3-border tabClass" ></div>';
    return ($str);
    }
sub rubricHomePage() {
    print $q->header();
    $str .= '<div class="w3-container w3-margin-top">';
    $str .= '<br><h2>Rubric Development and Settings</h2>';
    $str .= '<div class="w3-bar w3-border w3-black">';
    $str .= sprintf '<span class="menu w3-bar-item w3-button w3-hover-pale-red w3-border-right" onclick="rubric_loadRubric(this, \'%s\');">Design Reports</span>', 'Assessment';
    $str .= sprintf '<span class="menu w3-bar-item w3-button w3-hover-pale-red w3-border-right" onclick="rubric_loadRubric(this, \'%s\');">TDS</span>', 'TDS';
    $str .= sprintf '<span class="menu w3-bar-item w3-button w3-hover-pale-red w3-border-right" onclick="rubric_loadRubric(this, \'%s\');">Drawing</span>', 'Drawing';
    $str .= sprintf '<span class="menu w3-bar-item w3-button w3-hover-pale-red w3-border-right" onclick="rubric_loadRubric(this, \'%s\');">Requirements</span>', 'Requirement';
    $str .= sprintf '<span class="menu w3-bar-item w3-button w3-hover-pale-red w3-border-right" onclick="rubric_loadRubric(this, \'%s\');">Presentations</span>', 'Presentation';
    $str .= '</div>';
    $str .= '<div ID="RubricContentElement" class="w3-container w3-border w3-round w3-white">';
    $str .= '';
    $str .= '</div>';
    $str .= '</div>';
    # $str.=&rubricHomePage_Leg();
    return ($str);
}
# ***********************************************************************************************************************************
#  REPORT RUBRIC 2024
# ***********************************************************************************************************************************


# # ***********************************************************************************************************************************
# #  REPORT RUBRIC 2019
# # ***********************************************************************************************************************************
# sub updateSubSection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $Rubric = new SAE::RUBRIC();
#     my $inNumber = $q->param('inNumber'); 
#     my $txTitle = $q->param('txTitle'); 
#     my $inMax = $q->param('subSecMaxValue'); 
#     my $inMin = $q->param('subSecMinValue'); 
#     my $clDescription = uri_unescape($q->param('clDescription'));
#     my $subSecType = $q->param('subSecType');
#     my $subSecThreshold = $q->param('subSecThreshold');  
#     my $subSectionIDX = $q->param('subSectionIDX');  
#     my $subSecWeight = $q->param('subSecWeight');  
#     $Rubric->_updateSubSectionRecord($inNumber, $txTitle, $clDescription, $subSecType, $subSecThreshold, $inMin , $inMax , $subSecWeight, $subSectionIDX) ;
#     return;
# }
# sub showEditSubSection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $divName = $q->param('divName');  
#     my $subSectionIDX = $q->param('subSectionIDX');  
#     my $secNumber = $q->param('secNumber');  
#     my $Rubric = new SAE::RUBRIC();
#     my $Util = new SAE::Common();
#     %SUB = %{$Rubric->_getSubSectionRecord($subSectionIDX)};
#     my $str;
#     $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
#     $str .= '<h3>Sub Section</h3>';
#     $str .= '<label class="w3-tiny">Sub-Section #</label>';
#     $str .= '<select ID="subSecNumber" class="w3-select w3-text-blue">';
#     # foreach $section (sort {$a <=> $b} @SECTION) {
#     for ($i=1; $i<=100; $i++){
#         my $inNumber = $SUB{$subSectionIDX}{IN_SUBSECTION};
#         if ($i==$inNumber){
#             $str .= '<option Value="'.$i.'" selected>Sub-Section '.$secNumber.'.'.$i.'</option>';
#         } else {
#             $str .= '<option Value="'.$i.'">Sub-Section '.$secNumber.'.'.$i.'</option>';
#         }
        
#     }
#     # $str .= '<option Value="3">Micro Class</option>';
#     $str .= '</select>';
    
#     $str .= '<label class="w3-tiny">Sub-Section Title</label>';
#     $str .= '<input ID="subSecTitle" class="w3-input w3-text-blue" type="text" value="'.$SUB{$subSectionIDX}{TX_SUBSECTION}.'"placeholder="Sub Section Title">';
    
#     $str .= '<label class="w3-tiny">Description</label>';
#     $str .= '<textarea id="clDescription" class="w3-input w3-small" style="max-width: 100%; min-height: 150px;" placehlder="Description of this sub-section">';
#     # $str .= $SUB{$subSectionIDX}{CL_DESCRIPTION};
#     $str .= $Util->removeBr($SUB{$subSectionIDX}{CL_DESCRIPTION});
#     $str .= '</textarea>';
#     # $str .= '<input ID="secWeight" class="w3-input w3-text-blue" type="number">';
#     $str .= '<label class="w3-tiny">Value Type</label>';
    
#     $str .= '<select ID="subSecType" class="w3-select w3-text-blue">';
#     if ($SUB{$subSectionIDX}{IN_TYPE} == 0) {
#         $str .= '<option Value="0" selected>Number</option>';
#         $str .= '<option Value="1">Yes/No</option>';
#     } else {
#         $str .= '<option Value="0">Number</option>';
#         $str .= '<option Value="1" selected>Yes/No</option>';
#     }
    
#     $str .= '</select>';
    
#     $str .= '<label class="w3-tiny">Min Value</label>';
#     $str .= '<input ID="subSecMinValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_MIN}.'" style="width: 100px; text-align: center; display:inline!important">';
#     $str .= '<label class="w3-tiny">Max Value</label>';
#     $str .= '<input ID="subSecMaxValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_MAX}.'" style="width: 100px; text-align: center; display:inline!important"><br>';
    
#     $str .= '<label class="w3-tiny">Weight</label>';
#     $str .= '<input ID="subSecWeight" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_WEIGHT}.'">';
    
#     $str .= '<label class="w3-tiny">Comment Threshold (Comments must be provided when score is below this threshold value)</label>';
#     $str .= '<input ID="subSecThreshold" class="w3-input w3-text-blue" type="number" min="1" max="100" value="'.$SUB{$subSectionIDX}{IN_THRESHOLD}.'">';

#     $str .= '</form>';
#     $str .= '<center class="w3-padding-16">';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="updateSubSection('.$subSectionIDX.',\''.$divName.'\', '.$secNumber.');">Save</button>';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
#     $str .= '</center>';
#     return ($str);
# }
# sub deleteSubSectionItem(){
#     print $q->header();
#     my $Ref = new SAE::REFERENCE();
#     my $subSectionIDX = $q->param('subSectionIDX'); 
#     my $str = $Ref->_deleteRecord('TB_SUBSECTION','PK_SUBSECTION_IDX', $subSectionIDX);
#     return ($str);
# }
# sub createSubSection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $Rubric = new SAE::RUBRIC();
#     my $sectionIDX = $q->param('sectionIDX'); 
#     my $inNumber = $q->param('inNumber'); 
#     my $secNumber = $q->param('secNumber'); 
#     my $txTitle = $q->param('txTitle'); 
#     my $inMax = $q->param('subSecMaxValue'); 
#     my $inMin = $q->param('subSecMinValue'); 
#     my $clDescription = uri_unescape($q->param('clDescription'));
#     my $subSecType = $q->param('subSecType');
#     my $subSecThreshold = $q->param('subSecThreshold');  
#     my $subSecWeight = $q->param('subSecWeight');  
#     my $subSectionIDX = $Rubric->_addSubSection($sectionIDX, $inNumber, $txTitle, $clDescription, $subSecType, $subSecThreshold, $inMin , $inMax, $subSecWeight);
#     my $str = &sectionList($secNumber, $subSectionIDX, $inNumber, $txTitle, $clDescription, $subSecType, $subSecThreshold);
#     return ($str);
# }
# sub showAddSubSection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $divName = $q->param('divName');  
#     my $sectionIDX = $q->param('sectionIDX');  
#     my $secNumber = $q->param('secNumber');  
#     my $inType = $q->param('inType');  
#     my $Rubric=new SAE::RUBRIC();
#     my $str;
#     $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
#     $str .= '<h3>Sub Section</h3>';
#     $str .= '<label class="w3-tiny">Sub-Section #</label>';
#     $str .= '<select ID="subSecNumber" class="w3-select w3-text-blue">';
#     # foreach $section (sort {$a <=> $b} @SECTION) {
#     for ($i=1; $i<=100; $i++){
#         $str .= '<option Value="'.$i.'">Sub-Section '.$secNumber.'.'.$i.'</option>';
#     }
#     # $str .= '<option Value="3">Micro Class</option>';
#     $str .= '</select>';
    
#     $str .= '<label class="w3-tiny">Sub-Section Title</label>';
#     $str .= '<input ID="subSecTitle" class="w3-input w3-text-blue" type="text" placeholder="Sub Section Title">';
    
#     $str .= '<label class="w3-tiny">Description</label>';
#     $str .= '<textarea id="clDescription" class="w3-input w3-small" style="max-width: 100%; min-height: 120px;" placehlder="Description of this sub-section">';
#     $str .= '</textarea>';
#     # $str .= '<input ID="secWeight" class="w3-input w3-text-blue" type="number">';
#     $str .= '<label class="w3-tiny">Value Type</label>';
    
#     $str .= '<select ID="subSecType" class="w3-select w3-text-blue">';
#     $str .= '<option Value="0">Number</option>';
#     $str .= '<option Value="1">Yes/No</option>';
#     $str .= '</select>';
    
#     $str .= '<label class="w3-tiny">Min Value</label>';
#     $str .= '<input ID="subSecMinValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="0" style="width: 100px; text-align: center; display:inline!important">';
#     $str .= '<label class="w3-tiny">Max Value</label>';
#     $str .= '<input ID="subSecMaxValue" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="100" style="width: 100px; text-align: center; display:inline!important"><br>';
    
#     $str .= '<label class="w3-tiny">Weight</label>';
#     $str .= '<input ID="subSecWeight" class="w3-input w3-text-blue" type="number"  min="1" max="100" placeholder="0">';

#     $str .= '<label class="w3-tiny">Comment Threshold (Comments must be provided when score is below this threshold value)</label>';
#     $str .= '<input ID="subSecThreshold" class="w3-input w3-text-blue" type="number"  min="1" max="100" value="50">';

#     $str .= '</form>';
#     $str .= '<center class="w3-padding-16">';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="createSubSection('.$sectionIDX.','.$secNumber.',\''.$divName.'\');">Save</button>';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
#     $str .= '</center>';
#     return ($str);
# }
# sub deleteSection(){
#     print $q->header();
#     my $Ref = new SAE::REFERENCE();
#     my $sectionIDX = $q->param('sectionIDX');  
#     my $str = $Ref->_deleteRecord('TB_SECTION','PK_SECTION_IDX', $sectionIDX);
#     return;
# }
# sub createANewSection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $Rubric = new SAE::RUBRIC();
#     my $secNumber = $q->param('secNumber'); 
#     my $secTitle = $q->param('secTitle'); 
#     my $secWeight = $q->param('secWeight'); 
#     my $secClass = $q->param('secClass'); 
#     my $inType = $q->param('inType'); 
#     my $str;
#     my $sectionIDX = $Rubric->_createNewSection($secNumber, $secTitle, $secWeight, $secClass, $inType);
#     $str = &__template_sectionList($sectionIDX, $secNumber, $secTitle, $secWeight, $secClass, $inType);
#     return ($str);
# }
# sub sectionList(){
#     my ($secNumber, $subSectionIDX, $number, $title, $description, $typeID, $threshold, $weight, $inType) = @_;
#     my %TYPE = (0=>"Number", 1=>"Yes/No");
#     my $str;
#     $str = '<tr class="subSection_'.$subSectionIDX.'"  class="w3-small">';
#     $str .= '<td ID="subSectionNumber_'.$subSectionIDX.'"  class="w3-small">'.$secNumber.'.'.$number.'</td>';
#     $str .= '<td ID="subSectionTitle_'.$subSectionIDX.'" class="w3-small">'.$title.'</td>';
#     $str .= '<td ID="subSectionDescription_'.$subSectionIDX.'" class="w3-small">'.$description.'</td>';
#     $str .= '<td ID="subSectionType_'.$subSectionIDX.'"  class="w3-small">'.$TYPE{$typeID}.'</td>';
#     $str .= '<td ID="subSectionThreshold_'.$subSectionIDX.'" class="w3-center w3-small">'.$threshold.'</td>';
#     $str .= '<td ID="subSectionWeight_'.$subSectionIDX.'" class="w3-center w3-small">'.$weight.'</td>';
#     # $str .= '<td ID="subSectionWeight_'.$subSectionIDX.'" class="w3-center w3-small">subSectionWeight_'.$subSectionIDX.'</td>';
#     $str .= '<td class="w3-small">';
#     # $str .= $subSectionIDX;
#     $str .= '<a href="javascript:void(0);" class="w3-link" onclick="showEditSubSection('.$subSectionIDX.', '.$secNumber.');">Edit</a>';
#     $str .= '<a href="javascript:void(0);" class="w3-link w3-margin-left" onclick="deleteSubSectionItem('.$subSectionIDX.');">Delete</a>';
#     $str .= '</td>';
#     $str .= '</tr>';
#     return ($str);
# }
# sub __template_sectionList(){
#     my ($sectionIDX, $secNumber, $secName, $secWeight, $secClass, $inType) = @_;
#     %APP = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
#     my $str;
#     my $Rubics = new SAE::RUBRIC;
#     %LIST = %{$Rubics->_getSubSection($sectionIDX)};
#     $str = '<button style="margin-top: 5px;" class="w3-button w3-block w3-left-align w3-light-grey sae-section_'.$sectionIDX.'" onclick="expandSubsection(this, '.$sectionIDX.')" >';
#     $str .= '<i class="fa fa-chevron-right"></i>&nbsp;&nbsp;';
#     $str .= '<span ID="sectionButton_'.$sectionIDX.'" >'.$secNumber.' - '.$secName.' - '.$APP{$secClass}.' ('.$secWeight.'%)</span>';
#     # $str .= &_tempSectionButton($sectionIDX, $secNumber , $secName , $secWeight);
#     $str .= '</button>';
#     $str .= '<div ID="section_'.$sectionIDX.'" class="w3-hide w3-container w3-white w3-card-2 w3-border sae-section_'.$sectionIDX.'">';
#     $str .= '<div class="w3-panel" style="padding: 5px; margin: 0px;">';
#     $str .= '<button class="w3-button" style="margin-left: 10px;" onclick="showAddSubSection('.$sectionIDX.','.$secNumber.','.$inType.');">Add Sub-Section</button>';
#     $str .= '<button class="w3-button" style="margin-left: 10px;" onclick="showEditSection('.$sectionIDX.', '.$inType.');">Edit Section</button>';
#     $str .= '<button class="w3-button" style="margin-left: 10px;" onclick="deleteSection('.$sectionIDX.');">Delete Section</button>';
#     $str .= '</div>';
#     $str .= '<table ID="table_subsection_'.$sectionIDX.'" class="w3-table-all">';
#     $str .= '<thead>';
#     $str .= '<tr class="w3-light-grey">';
#     $str .= '<th style="width: 15px;">#</th>';
#     $str .= '<th style="width: 100px;">Title</th>';
#     $str .= '<th>Description</th>';
#     $str .= '<th style="width: 15px;">Type</th>';
#     $str .= '<th style="width: 15px;">Threshold</th>';
#     $str .= '<th style="width: 15px;">Weight</th>';
#     $str .= '<th style="width: 15px;">Action</th>';
#     $str .= '</tr>';
#     $str .= '</thead>';
#     # print scalar(keys %LIST);
#     $str .= '<tbody>';
#     foreach $subSectionIDX (sort {$LIST{$a}{IN_SUBSECTION} <=> $LIST{$b}{IN_SUBSECTION}} keys %LIST) {
#         my $subNumber = $LIST{$subSectionIDX}{IN_SUBSECTION};
#         my $subTitle = $LIST{$subSectionIDX}{TX_SUBSECTION};
#         my $subDescription = $LIST{$subSectionIDX}{CL_DESCRIPTION};
#         my $subType = $LIST{$subSectionIDX}{IN_TYPE};
#         my $subThreshold = $LIST{$subSectionIDX}{IN_THRESHOLD};
#         my $subWeight= $LIST{$subSectionIDX}{IN_WEIGHT};
#         $str .= &sectionList($secNumber, $subSectionIDX, $subNumber, $subTitle, $subDescription, $subType, $subThreshold, $subWeight, $inType);
#     }
#     $str .= '</tbody>';
#     $str .= '</table>';
#     $str .= '<p>&nbsp;</p>';
#     $str .= '</div>';
#     return ($str);
# }
# sub updateSection(){
#     print $q->header();
#     my $Rubric = new SAE::RUBRIC();
#     my $secNumber = $q->param('secNumber'); 
#     my $secTitle = $q->param('secTitle'); 
#     my $secWeight = $q->param('secWeight'); 
#     my $secClass = $q->param('secClass'); 
#     my $sectionIDX = $q->param('sectionIDX'); 
#     %APP = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
#     $Rubric->_updateSectionRecord($secNumber, $secTitle, $secWeight, $secClass, $sectionIDX);
#     my $str = $secNumber.' - '.$secTitle.' - '.$APP{$secClass}.' ('.$secWeight.'%)';
#     # my $str = &_tempSectionButton($sectionIDX, $secNumber , $secTitle , $secWeight);
#     return ($str);
# }
# sub showEditSection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $divName = $q->param('divName');  
#     my $inType = $q->param('inType');  
#     my $sectionIDX = $q->param('sectionIDX');  
#     my $Rubric=new SAE::RUBRIC();
#     %SEC = %{$Rubric->_getSectionRecord($sectionIDX)};
#     %CLASS = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
#     $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
#     $str .= '<h3>Rubric</h3>';
#     $str .= '<label class="w3-tiny">Section #</label>';
#     $str .= '<select ID="secNumber" class="w3-select w3-text-blue">';
#     for ($section=1; $section<=100; $section++){
#         if ($section == $SEC{$sectionIDX}{IN_SECTION}) {
#             $str .= '<option Value="'.$section.'" selected>Section '.$section.'</option>';
#         } else {
#             $str .= '<option Value="'.$section.'">Section '.$section.'</option>';
#         }
#     }
#     $str .= '</select>';
#     $str .= '<label class="w3-tiny">Section Title</label>';
#     $str .= '<input ID="secTitle" class="w3-input w3-text-blue" value="'.$SEC{$sectionIDX}{TX_SECTION}.'" type="text">';
#     $str .= '<label class="w3-tiny">Weight (0 - 100%)</label>';
#     $str .= '<input ID="secWeight" class="w3-input w3-text-blue" value="'.$SEC{$sectionIDX}{IN_WEIGHT}.'" type="number">';
#     $str .= '<label class="w3-tiny">Class Applicability</label>';
#     $str .= '<select ID="secClass" class="w3-select w3-text-blue">';
#     my $secClass = $SEC{$sectionIDX}{IN_CLASS};
#     foreach $value (sort {$a <=> $b} keys %CLASS) {
#         if ($value == $secClass) {
#             $str .= '<option Value="'.$value.'" selected>'.$CLASS{$value}.'</option>';
#         } else {
#             $str .= '<option Value="'.$value.'">'.$CLASS{$value}.'</option>';
#         }
#     }
#     $str .= '</select>';
#     $str .= '</form>';
#     $str .= '<center class="w3-padding-16">';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="updateSection('.$sectionIDX.',\''.$divName.'\','.$inType.');">Save</button>';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
#     $str .= '</center>';
#     return ($str);
# }
# sub addASection(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $divName = $q->param('divName');  
#     my $inType = $q->param('inType');  
#     my $Rubric=new SAE::RUBRIC();
#     %CLASS = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
#     $str = '<form class="w3-display-container w3-white w3-padding w3-border">';
#     $str .= '<h3>Rubric</h3>';
#     $str .= '<label class="w3-tiny">Section #</label>';
#     $str .= '<select ID="secNumber" class="w3-select w3-text-blue">';
#     for ($section=1; $section<=20; $section++){
#         $str .= '<option Value="'.$section.'">Section '.$section.'</option>';
#     }
#     $str .= '</select>';
#     $str .= '<label class="w3-tiny">Section Title</label>';
#     $str .= '<input ID="secTitle" class="w3-input w3-text-blue" type="text">';
#     $str .= '<label class="w3-tiny">Weight (0 - 100%)</label>';
#     $str .= '<input ID="secWeight" class="w3-input w3-text-blue" type="number" placeholder="0.0">';
#     $str .= '<label class="w3-tiny">Class Applicability</label>';
#     $str .= '<select ID="secClass" class="w3-select w3-text-blue">';
#     foreach $value (sort {$a <=> $b} keys %CLASS) {
#         $str .= '<option Value="'.$value.'">'.$CLASS{$value}.'</option>';
#     }
#     $str .= '</select>';
#     $str .= '</form>';
#     $str .= '<center class="w3-padding-16">';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="createANewSection(\''.$divName.'\','.$inType.');">Save</button>';
#     $str .= '<button class="w3-margin-right" style="width: 90px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
#     $str .= '</center>';
#     return ($str);
# }   
# sub rubricHomePage_Leg(){
#     # print $q->header();
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');  
#     my $str;
#     my $Rubric=new SAE::RUBRIC();
#     %SECTION = %{$Rubric->_getSectionList()};
#     %TYPE=%{$Rubric->_getRubricType()};
#     $str = '<div class="w3-container w3-margin-top">';
#     $str .= '<br><h2>Rubric Management & Settings</h2>';
#     foreach $inType (sort {$TYPE{$a}{IN_ORDER} <=> $TYPE{$b}{IN_ORDER}} keys %TYPE){
#         if ($inType>5){next;}
#         $str .= '<button tabstop="false" tabindex="-1" style="margin-top: 2px;" class="w3-button w3-display-container w3-block w3-left-align w3-light-blue" onclick="sae_expandSectionType(this, '.$inType.')">';
#         $str .= '<i class="fa fa-chevron-right fa-all"></i>&nbsp;&nbsp;';
#         $str .= '<span>'.$TYPE{$inType}{TX_TITLE}.'</span>';
#         $str .= '</button>';
#         $str .= '<div ID="sectionType_'.$inType.'" class="w3-hide w3-container w3-border-bottom w3-padding w3-card-2">';
#         $str .= '<div class="w3-bar w3-border-bottom">';
#         $str .= '<button class="w3-button w3-border w3-round" onclick="addASection('.$inType.');">Add '.$TYPE{$inType}{TX_TITLE}.' Section</button>';
#         $str .= '</div>';
#         # $str .= '<h4 class="w3-padding-small w3-button w3-panel">'.$TYPE{$inType}{TX_TITLE}.' Rubric</h4>';

#         $str .= '<div ID="rubricSection_'.$inType.'" >';
#         foreach $sectionIDX ( sort {$SECTION{$inType}{$a}{IN_SECTION} <=> $SECTION{$inType}{$b}{IN_SECTION}} keys %{$SECTION{$inType}} ) {
#             $secNumber = $SECTION{$inType}{$sectionIDX}{IN_SECTION};
#             $secWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
#             $secTitle = $SECTION{$inType}{$sectionIDX}{TX_SECTION};
#             $secClass = $SECTION{$inType}{$sectionIDX}{IN_CLASS};
#             $str .= &__template_sectionList($sectionIDX, $secNumber, $secTitle, $secWeight, $secClass, $inType);
#         }
#         $str .= '</div>';
#         $str .= '<div ID="rubricSubSection"></div>';
#         $str .= '</div>';
#     }   
#     $str .= '</div>';
#     return ($str);
# }