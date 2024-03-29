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
use Text::CSV;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Common;
use SAE::TB_TEAM;
use SAE::TB_SCORE;
use SAE::TB_TECH;
use SAE::ECR;
use SAE::REFERENCE;
use SAE::PRESO;
use SAE::SCORE;
use SAE::FLIGHT;
use SAE::TEAM;
use SAE::AIRBOSS;
use SAE::TECH;
use SAE::JSONDB;



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
### --------------- 2023 ------------------------------------------------------
sub tech_updateCheckItem (){
        my $eventIDX = $q->param('eventIDX');
        my $index = $q->param('FIELD_IDX');
        my $field = $q->param('FIELD');
        my $table = $q->param('TABLE');
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $JsonDB = new SAE::JSONDB();
        print $q->header();        
        my $str;
        $str =   $JsonDB->_update($table, \%DATA, qq($field=$index));
        # $str .= join("|", values %DATA);
        return ("$field=$index");
        }
sub tech_passTechInspection (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $planeIDX   = $q->param('planeIDX');
    my $itemIDX    = $q->param('itemIDX');
    my $teamIDX    = $q->param('teamIDX');  
    my $inStatus   = $q->param('inStatus');
    my $classIDX   = $q->param('classIDX');
    my $headingIDX = $q->param('headingIDX');
    my $checkType  = $q->param('checkType');
    my $userIDX  = $q->param('userIDX');
    my $Tech       = new SAE::TECH();
    $Tech->_submitTechInspectionStatus($teamIDX, $itemIDX, $inStatus, $eventIDX, $userIDX, $planeIDX);
    if ($checkType == 0){
            $Tech->_setInprogressSafetyInspection($planeIDX);
        } else {
            $Tech->_setInprogressInspection($planeIDX);
        }
    my %TECH       = %{$Tech->_getItemDetails( $teamIDX, $itemIDX )};
    my %TEAMS      = %{$Tech->_getTeamList($eventIDX)};
    my %CERT       = %{$Tech->_getCertificationStatus( $teamIDX )};
    # my $inStatus   =   $Tech->_getTeamInspectionStatus($teamIDX, $classIDX);
    my $certStatus = 0;
    if (exists $CERT{$itemIDX}) {$certStatus = 1}
    my $str;
    my %TEAM = %{$Tech->_getTeamDataFromPlane($planeIDX)};
    my $inPoints      = $TECH{IN_POINTS};
    my $boAbsolute    = $TECH{BO_ABSOLUTE};
    # my $requiredCheck = $TECH{BO_CHECK};
    $str    = &t_inspectionItem($checkType, $classIDX, $teamIDX, $itemIDX, $headingIDX, $TECH{TX_REQUIREMENT},$TECH{IN_HEAD},$TECH{IN_SECTION},$TECH{TX_SECTION},$inStatus, $certStatus, $inPoints, $planeIDX, 1, $boAbsolute);
    my $btn;
    if ($classIDX == 4){
            $btn = &t_padaButton($teamIDX,$TEAM{IN_NUMBER},$classIDX, $TEAM{IN_SEQUENCE}, $planeIDX);
        } else {
            $btn = &t_planeButton($teamIDX,$TEAM{IN_NUMBER},$classIDX, $TEAM{IN_SEQUENCE}, $planeIDX);
        }
    my %DATA;
        $DATA{ITEM}              = $str;
        $DATA{BTN}               = $btn;
        my $inspectionStatus     = $Tech->_getPlaneInspectionStatus($planeIDX, $classIDX );
        my $inspectionStatus     = $Tech->_getTeamInspectionStatus($teamIDX, $classIDX );
        my $inSafetyStatus       = $Tech->_getTeamSafetyStatus($teamIDX, $classIDX );
        my $inNumber             = $TEAMS{$teamIDX}{IN_NUMBER};
        my $classIDX             = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $txSchool             = $TEAMS{$teamIDX}{TX_SCHOOL};
        $DATA{TEAM_BAR}          = &t_teamInspectionBar($teamIDX, $inspectionStatus, $inSafetyStatus, $classIDX, $inNumber, $txSchool);
        $DATA{FK_ITEM_IDX}       = $itemIDX;
        $DATA{FK_TEAM_IDX}       = $teamIDX;
        $DATA{BO_INSPECTED}      = $inspectionStatus;
        $DATA{TEAM_REQ_ALERT}    = $Tech->_getTechRequirementsCheckStatus($teamIDX); 
        $DATA{TEAM_SAFETY_ALERT} = $Tech->_getTechSafetyCheckStatus($teamIDX); 
        $DATA{IN_POINTS}         = $inPoints;
        $DATA{TYPE}              = $checkType;
    my $json = encode_json \%DATA;
    return ($json);
    # return ($str);
    }
sub tech_confirmSafetyCheck (){
    print $q->header();
    my $planeIDX     = $q->param('planeIDX');
    my $classIDX     = $q->param('classIDX');
    my $txType       = 'safetySectionNumber';
    my $Plane        = new SAE::TECH();
    my %TECH         = %{$Plane->_getCompleteConfirmation($planeIDX, $txType )}; 
    my %REQ_TECH     = %{$Plane->_getRequiredTechList($classIDX)};
    # my %HEAD         = %{$Plane->_getSectionHeading($txType, $classIDX)};
    my %REQ          = %{$Plane->_getSafetyList($classIDX, $txType)};
    my $failedFlag   = 0;
    my $inTotal      = 0;
    my %STATUS       = (''=>'TBC', 0=>'<span class="w3-red w3-padding">Failed</span>', 1=>'<span class="w3-leftbar w3-border-green w3-pale-green w3-padding">Passed</span>', 2=>'<span class="w3-leftbar w3-border-green w3-yellow w3-padding">Penalty</span>');
    my $str;
    $str .= '<table class="w3-table-all">';
    $str .= '<tr>';
    $str .= '<th>Status</th>';
    $str .= '<th>Description</th>';
    $str .= '</tr>';
    foreach $reqIDX (sort {$REQ{$a}{IN_ORDER} <=> $REQ{$b}{IN_ORDER}} keys %REQ) {
        my $inStatus = $TECH{$reqIDX}{IN_STATUS};
        if ($inStatus != 1){$failedFlag = 1}
        $str .= '<tr>';
        $str .= sprintf '<td>%s</td>', $STATUS{$inStatus};
        $str .= sprintf '<td>%s - %s</td>',$REQ{$reqIDX}{IN_SECTION}, $REQ{$reqIDX}{TX_SECTION};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<div class="w3-container w3-center w3-padding">';
    # $str .= $classIDX;
    if ($failedFlag == 0) {
        $str .= sprintf '<button class="w3-button w3-round w3-green w3-border w3-padding" onclick="tech_completeSafetyCheck(this, %d, %d);">Complete Safety Inspection</button>', $planeIDX, $classIDX;
    } else {
        $str .= '<button class="w3-button w3-round w3-border w3-padding" disabled>STOP</button>';
    }
    $str .= '</div>';
    return ($str);
    }
sub tech_openSafetyCheck  (){
    my $teamIDX    = $q->param('teamIDX');
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $planeIDX   = $q->param('planeIDX');
    my $inNumber   = $q->param('inNumber');
    my $inSequence = $q->param('inSequence');
    my $txType     = 'safetySectionNumber';
    my $Tech       = new SAE::TECH();
    my %TECH       = %{$Tech->_getTeamTechList($planeIDX)};
    my %HEAD       = %{$Tech->_getSectionHeading($txType, $classIDX)};
    my %REQ        = %{$Tech->_getReqList($classIDX)};
    my %CERT       = %{$Tech->_getCertificationStatus( $teamIDX )};
    # my $flag_pass  = 0;
    print $q->header();
    my $str;
    $str .= '<div class="w3-container w3-padding-16 w3-border w3-round w3-card-4" style=" height: 700px; overflow-y: scroll;">';
    foreach $headingIDX (sort {$HEAD{$a}{IN_SECTION} <=> $HEAD{$b}{IN_SECTION}} keys %HEAD) {
        if (exists $REQ{$headingIDX}) {
            my $inHeading = $HEAD{$headingIDX}{IN_SECTION};
            $str .= sprintf '<h4 class="w3-strong">';
            $str .= sprintf '<b>%d - %s</b>', $HEAD{$headingIDX}{IN_SECTION}, $HEAD{$headingIDX}{TX_SECTION};
            $str .= '</h4>';
            $str .= '<ul class="w3-ul">';
            foreach $itemIDX (sort keys %{$REQ{$headingIDX}}) {
                my $certStatus = 0;
                if (exists $CERT{$itemIDX}) {$certStatus = 1}
                my $inStatus = $TECH{$itemIDX}{IN_STATUS};
                my $inPoints = $REQ{$headingIDX}{$itemIDX}{IN_POINTS};
                # if ($inStatus == 0) {$flag_pass = 1}
                # $str .= "inStatus  = $inStatus, $flag_pass ";
                $str .= &t_inspectionItem(0, $classIDX, $teamIDX, $itemIDX, $headingIDX, $REQ{$headingIDX}{$itemIDX}{TX_REQUIREMENT}, $inHeading, $REQ{$headingIDX}{$itemIDX}{IN_SECTION}, $REQ{$headingIDX}{$itemIDX}{TX_SECTION}, $inStatus, $certStatus, $inPoints, $planeIDX, 1, 0);

            }
            $str .= '</ul>';
        }
    }
    $str .= '<div class="w3-container w3-padding w3-margin w3-right">';
    # if ($flag_pass==1){
    #         $str .= sprintf '<button class="w3-button w3-border w3-card-4 w3-green w3-xxlarge w3-round-large w3-padding" onclick="tech_confirmSafetyCheck(this, %d, %d, %d, %d);">Next &gt;&gt;</button>', $planeIDX, $inNumber, $inSequence, $classIDX, $inNumber, $inSequence;
    #     } else {
            $str .= sprintf '<button class="w3-button w3-border w3-card-4 w3-green w3-xxlarge w3-round-large w3-padding" onclick="tech_confirmSafetyCheck(this, %d, %d, %d, %d);">Next &gt;&gt;</button>', $planeIDX, $inNumber, $inSequence, $classIDX, $inNumber, $inSequence;
        # }
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
    }
sub tech_openRequirementsCheck  (){
    print $q->header();
    my $teamIDX    = $q->param('teamIDX');
    my $planeIDX   = $q->param('planeIDX');
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $inNumber   = $q->param('inNumber');
    my $inSequence = $q->param('inSequence');
    my $txType     = 'reqSectionNumber';
    my $Tech       = new SAE::TECH();
    my %TECH       = %{$Tech->_getTeamTechList($planeIDX)};
    my %HEAD       = %{$Tech->_getSectionHeading($txType, $classIDX)};
    my %REQ        = %{$Tech->_getReqList( $classIDX )};
    my %CERT       = %{$Tech->_getCertificationStatus( $teamIDX )};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= '<div class="w3-container w3-padding w3-border w3-round w3-margin-bottom w3-light-grey">';
    $str .= '<input ID="BO_SHOW" type="radio" checked name="displayItems" class="w3-radio" onclick="tech_toggleRequiredInspection(this, 0);"><label for="BO_SHOW" class="w3-margin-left w3-margin-right w3-large">Display <u><b>ONLY</b></u> the Required Inspection Items</label><br>';
    $str .= '<input ID="BO_NOSHOW" type="radio" name="displayItems" class="w3-radio" onclick="tech_toggleRequiredInspection(this, 1);"><label for="BO_NOSHOW" class="w3-margin-left w3-margin-right w3-large">Display <u><b>ALL</b></u> Inspection Items</label>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-padding-16 w3-border w3-round w3-card-4" style=" height: 700px; overflow-y: scroll;">';
    foreach $headingIDX (sort {$HEAD{$a}{IN_SECTION} <=> $HEAD{$b}{IN_SECTION}} keys %HEAD) {
        if (exists $REQ{$headingIDX}) {
            my $inHeading = $HEAD{$headingIDX}{IN_SECTION};
            my $requiredCheck = $HEAD{$headingIDX}{BO_CHECK};
            if ($requiredCheck == 1) {
                $str .= sprintf '<h4 class="w3-strong">';
                $str .= sprintf '<b class="w3-text-red">%d - (Required) %s</b>', $HEAD{$headingIDX}{IN_SECTION}, $HEAD{$headingIDX}{TX_SECTION};
                $str .= '</h4>';
            } else {
                $str .= sprintf '<h4 class="w3-strong w3-hide optionalHeading">';
                $str .= sprintf '<b>%d - (<i>Optional</i>) %s</b>', $HEAD{$headingIDX}{IN_SECTION}, $HEAD{$headingIDX}{TX_SECTION};
                $str .= '</h4>';
            }
                $str .= '<ul class="w3-ul">';
            foreach $itemIDX (sort keys %{$REQ{$headingIDX}}) {
                my $certStatus = 0;
                if (exists $CERT{$itemIDX }) {$certStatus = 1}
                my $inStatus   = $TECH{$itemIDX}{IN_STATUS};
                my $inPoints   = $REQ{$headingIDX}{$itemIDX}{IN_POINTS};
                my $boAbsolute = $REQ{$headingIDX}{$itemIDX}{BO_ABSOLUTE};
                # $str .= 'boAbsolute ('.$itemIDX .')= '.$boAbsolute;
                $str .= &t_inspectionItem(1, $classIDX, $teamIDX, $itemIDX, $headingIDX, $REQ{$headingIDX}{$itemIDX}{TX_REQUIREMENT}, $inHeading, $REQ{$headingIDX}{$itemIDX}{IN_SECTION}, $REQ{$headingIDX}{$itemIDX}{TX_SECTION}, $inStatus, $certStatus, $inPoints, $planeIDX, $requiredCheck, $boAbsolute);
            }
            $str .= '</ul>';
        }
    }
    $str .= '<div class="w3-container w3-padding w3-margin w3-right">';
    $str .= sprintf '<button class="w3-button w3-border w3-card-4 w3-green w3-xxlarge w3-round-large w3-padding" onclick="tech_completeRequirementsCheck(this, %d, %d, %d, %d);">Next &gt;&gt;</button>', $planeIDX, $inNumber, $inSequence, $classIDX, $inNumber, $inSequence;
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
sub tech_completeRequirementsCheck (){
    print $q->header();
    my $planeIDX     = $q->param('planeIDX');
    my $classIDX     = $q->param('classIDX');
    my $txType       = 'reqSectionNumber';
    my $Plane        = new SAE::TECH();
    my %TECH         = %{$Plane->_getCompleteConfirmation($planeIDX, $txType)}; 
    my %REQ_TECH     = %{$Plane->_getRequiredTechList($classIDX)};
    my $failedFlag   = 0;
    my $inTotal      = 0;
    my %STATUS       = (''=>'TBC', 0=>'<span class="w3-red w3-padding">Failed</span>', 1=>'<span class="w3-leftbar w3-border-green w3-pale-green w3-padding">Passed</span>', 2=>'<span class="w3-leftbar w3-border-green w3-yellow w3-padding">Penalty</span>');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<table class="w3-table-all">';
    $str .= '<tr>';
    $str .= '<th style="width: 100px;"><br>Status</th>';
    $str .= '<th style="width: 100px;"><br>Section:</th>';
    $str .= '<th>Rules Reference<br>Description</th>';
    $str .= '<th style="width: 100px;">Points<br>Deduction</th>';
    $str .= '</tr>';
    foreach $reqIDX (sort {$REQ_TECH{$a}{IN_SECTION} <=> $REQ_TECH{$b}{IN_SECTION}} keys %REQ_TECH){
        my $inPoints = 0;
        if ($TECH{$reqIDX}{IN_STATUS}!=1){
            $inPoints = -$TECH{$reqIDX}{IN_POINTS};
            $inTotal += $TECH{$reqIDX}{IN_POINTS};
        }
        if ($TECH{$reqIDX}{IN_STATUS}==0){$failedFlag = 1}
        $str .= '<tr>';
        $str .= sprintf '<td>%s</td>', $STATUS{$TECH{$reqIDX}{IN_STATUS}};
        $str .= sprintf '<td nowrap>%s<span class="w3-text-red w3-xlarge">*</span></td>', $REQ_TECH{$reqIDX}{IN_SECTION};
        $str .= sprintf '<td>%s - %s</td>', $REQ_TECH{$reqIDX}{TX_REQUIREMENT}, $REQ_TECH{$reqIDX}{TX_SECTION};
        $str .= sprintf '<td class="w3-right">%2.2f</td>', $inPoints;
        $str .= '</tr>';
    }
    foreach $reqIDX (sort {$TECH{$a}{IN_SECTION} <=> $TECH{$b}{IN_SECTION}} keys %TECH){
        if (exists $REQ_TECH{$reqIDX}){next}
        my $inPoints = 0;
        if ($TECH{$reqIDX}{IN_STATUS}!=1){
            $inPoints = -$TECH{$reqIDX}{IN_POINTS};
            $inTotal += $TECH{$reqIDX}{IN_POINTS};
        }
        if ($TECH{$reqIDX}{IN_STATUS}==0){$failedFlag = 1}
        $str .= '<tr>';
        $str .= sprintf '<td>%s</td>', $STATUS{$TECH{$reqIDX}{IN_STATUS}};
        $str .= sprintf '<td>%s</td>', $TECH{$reqIDX}{IN_SECTION};
        $str .= sprintf '<td>%s - %s</td>', $TECH{$reqIDX}{TX_REQUIREMENT}, $TECH{$reqIDX}{TX_SECTION};
        $str .= sprintf '<td class="w3-right">%2.2f</td>', $inPoints;
        $str .= '</tr>';
    }
    $str .= '<tr>';
    $str .= '<th colspan="3" style="text-align: right">Total Penalty Points</th>';
    $str .= sprintf '<th style="text-align: right">%2.2f</th>', $inTotal*(-1);
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<div class="w3-container w3-padding w3-center">';
    # $str .= $classIDX;
    if ($failedFlag == 0){
        $str .= sprintf '<button class="w3-button w3-card-4 w3-round w3-border w3-green w3-xlarge" onclick="tech_completePlaneCheck(this, %d, %d);">Complete</button>', $planeIDX, $classIDX;
    } else {
        $str .= '<button class="w3-button w3-card-4 w3-round w3-border w3-disabled" disabled>Complete</button>';
    }
    
    $str .= '</div>';
    # $str .= sprintf 'Total Deduction = %2.2f',  $inTotal;
    $str .= '</div>';
    return ($str);
    }
sub tech_completeSafetyCheck (){
    my $planeIDX = $q->param('planeIDX');
    my $classIDX = $q->param('classIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Plane    = new SAE::TECH();
    print $q->header();
    $Plane->_setCompleteSafetyInspection($planeIDX);
    my %TEAM = %{$Plane->_getTeamDataFromPlane($planeIDX)};
    # my $str = &t_planeButton($TEAM{FK_TEAM_IDX},$TEAM{IN_NUMBER},$TEAM{FK_CLASS_IDX},$TEAM{IN_SEQUENCE},$planeIDX);
    my $str;
    if ($classIDX==4){
            $str = &t_padaButton($TEAM{FK_TEAM_IDX},$TEAM{IN_NUMBER},$classIDX,$TEAM{IN_SEQUENCE},$planeIDX);
        } else {
            $str = &t_planeButton($TEAM{FK_TEAM_IDX},$TEAM{IN_NUMBER},$TEAM{FK_CLASS_IDX},$TEAM{IN_SEQUENCE},$planeIDX);
        }
    my %DATA;
    $DATA{BTN}                 = $str;
    $DATA{FK_TEAM_IDX}         = $TEAM{FK_TEAM_IDX};
    $DATA{TEAM_REQ_ALERT}      = $Plane->_getTechRequirementsCheckStatus($TEAM{FK_TEAM_IDX}); 
    $DATA{TEAM_SAFETY_ALERT}   = $Plane->_getTechSafetyCheckStatus($TEAM{FK_TEAM_IDX}); 
    my $json = encode_json \%DATA;
    return ($json);
    }
sub tech_completePlaneCheck (){
    my $planeIDX = $q->param('planeIDX');
    my $classIDX = $q->param('classIDX');
    my $Plane    = new SAE::TECH();
    print $q->header();
    $Plane->_setCompleteInspection($planeIDX);
    my %TEAM = %{$Plane->_getTeamDataFromPlane($planeIDX)};
    my $str;
    if ($classIDX==4){
            $str = &t_padaButton($TEAM{FK_TEAM_IDX},$TEAM{IN_NUMBER},$classIDX,$TEAM{IN_SEQUENCE},$planeIDX);
        } else {
            $str = &t_planeButton($TEAM{FK_TEAM_IDX},$TEAM{IN_NUMBER},$TEAM{FK_CLASS_IDX},$TEAM{IN_SEQUENCE},$planeIDX);
        }
    my %DATA;
    $DATA{BTN}                 = $str;
    $DATA{FK_TEAM_IDX}         = $TEAM{FK_TEAM_IDX};
    $DATA{TEAM_REQ_ALERT}      = $Plane->_getTechRequirementsCheckStatus($TEAM{FK_TEAM_IDX}); 
    $DATA{TEAM_SAFETY_ALERT}   = $Plane->_getTechSafetyCheckStatus($TEAM{FK_TEAM_IDX}); 
    my $json = encode_json \%DATA;
    return ($json);
    }
sub tech_openTechInspectionTeamList (){
    my $eventIDX   = $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Tech       = new SAE::TECH();
    my %TEAMS      = %{$Tech->_getTeamList($eventIDX)};
    my %TECH       = %{$Tech->_getInsptectionStatus(\%TEAMS)};

    print $q->header();
    my $str;
    my %STATUS = (0=>'Not Started', 
            1=>'In-Progress', 
            2=>'Completed');
    my %STATUS_COLOR = (0=>'w3-white', 1=>'w3-pale-yellow', 2=>'w3-pale-blue');
    $str .= '<div class="w3-container w3-margin-top">';
    $str .= '<header class="w3-container" style="padding-top:22px"><h3>Technical Inspection</h3></header>';
    $str .= '<div class="w3-bar w3-light-grey">';
    $str .= '<button class="w3-bar-item w3-button w3-border w3-round"><i class="fa fa-arrow-left" aria-hidden="true" onClick="openInspectionModule();"> Back</i></button>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-margin-top">';
    $str .= '<ul class="w3-ul">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inNumber         = $TEAMS{$teamIDX}{IN_NUMBER};
        my $classIDX         = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $inspectionStatus = $TECH{$teamIDX}{BO_INSPECTED};
        my $txSchool         = $TEAMS{$teamIDX}{TX_SCHOOL};
        my $inSafetyStatus   = $Tech->_getTeamSafetyStatus($teamIDX, $classIDX);
        $str .= &t_teamInspectionBar($teamIDX, $inspectionStatus, $inSafetyStatus, $classIDX, $inNumber, $txSchool);
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
    }
sub tech_updateItem (){
        my $eventIDX = $q->param('eventIDX');
        my $itemIDX = $q->param('itemIDX');
        my $sectionIDX = $q->param('sectionIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $JsonDB = new SAE::JSONDB();
        print $q->header();
        my $str;
        $JsonDB->_update('TB_TECH_REQ', \%DATA, qq(PK_TECH_REQ_IDX=$itemIDX));
        $str = &t_itemRow($sectionIDX, $itemIDX, $DATA{IN_SECTION}, $DATA{TX_REQUIREMENT}, $DATA{TX_SECTION},$DATA{BO_REGULAR}, $DATA{BO_ADVANCE}, $DATA{BO_PADA},$DATA{BO_MICRO}, $DATA{IN_POINTS}, $DATA{BO_ABSOLUTE});
        return ($str);
    }
sub tech_editItem (){
    my $eventIDX  = $q->param('eventIDX');
    my $itemIDX   = $q->param('itemIDX');
    my $secNumber   = $q->param('secNumber');
    my $Tech      = new SAE::TECH();
    my %ITEM      = %{$Tech->_getTechItemDetails($itemIDX)};

    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $sectionIDX = $ITEM{FK_TECH_REQ_SECTION_IDX};

    print $q->header();
    my $str;
    my $absolute = '';
    if ($ITEM{BO_ABSOLUTE} == 1) {$absolute  = 'checked'}
    $str = '<div class="w3-container w3-round w3-margin-bottom w3-light-grey w3-card-4">';
    $str .= '<div class="w3-container" >';
    $str .= '<div class="w3-container w3-white w3-round w3-border w3-margin-top" style="display: flex !important; width: 100%; height: 40px">';
    $str .= sprintf '<input type="checkbox" ID="BO_ABSOLUTE" class="w3-check sectionClass w3-margin-lef" %s value="1" data-field="BO_ABSOLUTE"><label for="BO_ABSOLUTE" class="w3-margin-left" style="margin-top: 7px;"><b class="w3-text-red">ABSOLUTE REQUIREMENT</b></label><br>', $absolute;
    $str .= '</div>';
    $str .= '<div class="w3-container w3-white w3-round w3-border w3-margin-top" style="display: flex !important; width: 100%;">';
    $str .= sprintf '<label class="w3-large" style="margin-top: 10px; flex: 0 1 auto;">Item #: %d.</label>',$secNumber;
    $str .= sprintf '<input type="number" ID="IN_SECTION" class="w3-input w3-round w3-border-0 w3-large w3-text-blue" value="%d" style="flex: 1; padding: 10px 10px 5px 2px; " >', $ITEM{IN_SECTION};
    $str .= '</div>';
    $str .= '<div class="w3-container w3-white w3-margin-top w3-border w3-round" style="display: flex !important; width: 100%;">';
    $str .= '<label class="w3-large" style="margin-top: 10px; flex: 0 1 auto;">Rule\'s Reference: </label>';
    $str .= sprintf '<input type="text" ID="TX_REQUIREMENT" class="w3-input w3-border-0 w3-round w3-large w3-text-blue w3-margin-left " value="%s" style="flex: 1; padding: 10px; " >',$ITEM{TX_REQUIREMENT};
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container ">';
    $str .= '<label style="margin-left: 7px;">Description</label><br>';
    
    $str .= sprintf '<textarea type="text" ID="TX_SECTION" class="w3-input w3-border w3-round"style="width: 100%; min-width: 100%; max-width: 100%; max-height: 100px; min-height: 100px;" >%s</textarea><br>', $ITEM{TX_SECTION};
    # $str .= sprintf '<input type="text" ID="TX_SECTION" class="w3-input w3-border w3-round" value="%s"><br>', $ITEM{TX_SECTION};
    $str .= '<label style="margin-left: 5px;">This check-item applies to the following classes</label><br>';
    my $reg = '';
    my $adv = '';
    my $mic = '';
    if ($ITEM{BO_REGULAR} == 1) {$reg  = 'checked'}
    if ($ITEM{BO_ADVANCE} == 1) {$adv  = 'checked'}
    if ($ITEM{BO_PADA}    == 1) {$pada = 'checked'}
    if ($ITEM{BO_MICRO}   == 1) {$mic  = 'checked'}
    $str .= '<input type="checkbox" ID="applicableToAll" class="w3-check             " onclick="tech_toggleChecks(this);"><label class="w3-margin-left w3-margin-right">Applicable to all classes</label><br>';
    $str .= '<input type="checkbox" ID="REG_CHECK" class="w3-check sectionClass w3-margin-left" value="1" data-field="BO_REGULAR" '.$reg.'  onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="REG_CHECK" class="w3-margin-left w3-margin-right">Regular Class</label><br>';
    $str .= '<input type="checkbox" ID="ADV_CHECK" class="w3-check sectionClass w3-margin-left" value="2" data-field="BO_ADVANCE" '.$adv.'  onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="ADV_CHECK" class="w3-margin-left w3-margin-right">Advanced Class</label><br>';
    $str .= '<input type="checkbox" ID="ADV_PADA"  class="w3-check sectionClass w3-margin-left" value="4" data-field="BO_PADA"    '.$pada.' onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="ADV_PADA"  class="w3-margin-left w3-margin-right">PADA</label><br>';
    $str .= '<input type="checkbox" ID="MIC_CHECK" class="w3-check sectionClass w3-margin-left" value="3" data-field="BO_MICRO"   '.$mic.'  onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="MIC_CHECK" class="w3-margin-left w3-margin-right">Micro Class</label><br>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-white w3-margin-top w3-border w3-round w3-margin-bottom" style="display: flex !important; width: 100%;">';
    $str .= '<label class="w3-large" style="margin-top: 10px; flex: 0 1 auto;">Point Value: </label>';
    $str .= sprintf '<input type="number" ID="IN_POINTS" class="w3-input w3-border-0 w3-round w3-large w3-text-blue w3-margin-left"style="flex: 1; padding: 10px;" value="%4.2f" >', $ITEM{IN_POINTS};
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-center w3-padding">';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-right" onclick="$(this).close();">Cancel</button>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-margin-left w3-green" onclick="tech_updateItem(this, %d, %d);">Update Item</button>', $itemIDX, $sectionIDX;
    $str .= '</div>';
    return ($str);
    # return ($str);
    }
sub tech_addCheckItem (){
    my $eventIDX= $q->param('eventIDX');
    my $secNumber= $q->param('secNumber');
    my $sectionIDX= $q->param('sectionIDX');
    my $itemCount= $q->param('itemCount');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str = '<div class="w3-container w3-round w3-margin-bottom w3-light-grey w3-card-4">';
    $str .= '<div class="w3-container" >';
    $str .= '<div class="w3-container w3-white w3-round w3-border w3-margin-top" style="display: flex !important; width: 100%; height: 40px">';
    $str .= '<input type="checkbox" ID="BO_ABSOLUTE" class="w3-check sectionClass" value="1" data-field="BO_ABSOLUTE"><label for="BO_ABSOLUTE" class="w3-margin-left" style="margin-top: 7px;"><b class="w3-text-red">ABSOLUTE REQUIREMENT</b></label><br>';
    $str .= '<br></div>';
    $str .= '<div class="w3-container w3-white w3-round w3-border w3-margin-top" style="display: flex !important; width: 100%;">';
    $str .= '<label class="w3-large" style="margin-top: 10px; flex: 0 1 auto;">Item #: '.$secNumber.'.</label>';
    $str .= sprintf '<input type="number" ID="IN_SECTION" class="w3-input w3-border-0 w3-round w3-large w3-text-blue" placeholder="'.$itemCount.'" value="%d" style="flex: 1; padding: 10px 10px 5px 2px; " >', $itemCount;
    $str .= '</div>';
    $str .= '<div class="w3-container w3-white w3-margin-top w3-border w3-round" style="display: flex !important; width: 100%;">';
    $str .= '<label class="w3-large" style="margin-top: 10px; flex: 0 1 auto;">Rule\'s Reference: </label>';
    $str .= sprintf '<input type="text" ID="TX_REQUIREMENT" class="w3-input w3-border-0 w3-round w3-large w3-text-blue w3-margin-left " placeholder="x.xx" style="flex: 1; padding: 10px;" >';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container ">';
    $str .= '<label style="margin-left: 7px;">Description</label><br>';
    # $str .= '<input type="text" ID="TX_SECTION" class="w3-input w3-border w3-round"><br>';
    $str .= '<textarea type="text" ID="TX_SECTION" class="w3-input w3-border w3-round" style="width: 100%; min-width: 100%; max-width: 100%; max-height: 100px; min-height: 100px;" ></textarea><br>';
    $str .= '<label style="margin-left: 5px;">This check-item applies to the following classes</label><br>';
    $str .= '<input type="checkbox" ID="applicableToAll" class="w3-check             " onclick="tech_toggleChecks(this);"><label class="w3-margin-left w3-margin-right">Applicable to all classes</label><br>';
    $str .= '<input type="checkbox" ID="REG_CHECK" class="w3-check sectionClass w3-margin-left" value="1" data-field="BO_REGULAR" onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="REG_CHECK" class="w3-margin-left w3-margin-right">Regular Class</label><br>';
    $str .= '<input type="checkbox" ID="ADV_CHECK" class="w3-check sectionClass w3-margin-left" value="2" data-field="BO_ADVANCE" onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="ADV_CHECK" class="w3-margin-left w3-margin-right">Advanced Class</label><br>';
    $str .= '<input type="checkbox" ID="ADV_PADA" class="w3-check sectionClass w3-margin-left"  value="4" data-field="BO_PADA"    onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="ADV_PADA"  class="w3-margin-left w3-margin-right">PADA</label><br>';
    $str .= '<input type="checkbox" ID="MIC_CHECK" class="w3-check sectionClass w3-margin-left" value="3" data-field="BO_MICRO"   onclick="tech_toggleSelectAll(this);" placeholder="Title"><label for="MIC_CHECK" class="w3-margin-left w3-margin-right">Micro Class</label><br>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-white w3-margin-top w3-border w3-round w3-margin-bottom" style="display: flex !important; width: 100%;">';
    $str .= '<label class="w3-large" style="margin-top: 10px; flex: 0 1 auto;">Point Value: </label>';
    $str .= sprintf '<input type="number" ID="IN_POINTS" class="w3-input w3-border-0 w3-round w3-large w3-text-blue w3-margin-left"style="flex: 1; padding: 10px; " value="0">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-center w3-padding">';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-right" onclick="$(this).close();">Cancel</button>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-margin-left w3-green" onclick="tech_addItem(this, %d);">Add Check Item</button>', $sectionIDX;
    $str .= '</div>';
    return ($str);
    # return ($str);
    }
sub tech_updateField (){
        my $eventIDX = $q->param('eventIDX');
        my $field = $q->param('FIELD_IDX');
        my $value = $q->param('VALUE_IDX');
        my $table = $q->param('TABLE');
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $JsonDB = new SAE::JSONDB();
        print $q->header();
        my $str;
        $str =   $JsonDB->_update($table, \%DATA, qq($field=$value));
        return ();
    }
sub tech_deleteSection (){
    my $sectionIDX= $q->param('sectionIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    my $JsonDB = new SAE::JSONDB();
       $JsonDB->_delete('TB_TECH_REQ_SECTION', qq(PK_TECH_REQ_SECTION_IDX=$sectionIDX));
       $JsonDB->_delete('TB_TECH_REQ', qq(PK_TECH_REQ_SECTION_IDX=$sectionIDX));

    return ($str);
    }
sub tech_addItem (){
    my $eventIDX= $q->param('eventIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $sectionIDX = $DATA{FK_TECH_REQ_SECTION_IDX};
    print $q->header();
    my $str;
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_insert('TB_TECH_REQ', \%DATA);
    $str .= &t_itemRow($sectionIDX, $newIDX, $DATA{IN_SECTION}, $DATA{TX_REQUIREMENT}, $DATA{TX_SECTION},$DATA{BO_REGULAR}, $DATA{BO_ADVANCE}, $DATA{BO_PADA},$DATA{BO_MICRO}, $DATA{IN_POINTS}, $DATA{BO_ABSOLUTE});
    return ($str);
    }
sub tech_deleteItem (){
    my $itemIDX= $q->param('itemIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
       $JsonDB->_delete('TB_TECH_REQ', qq(PK_TECH_REQ_IDX=$itemIDX));

    return ($str);
    }
sub tech_addSection (){
    my $eventIDX= $q->param('eventIDX');
    my $sectionIDX= $q->param('sectionIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_insert('TB_TECH_REQ_SECTION', \%DATA);
    my $inType = 0;
    if ($DATA{TX_TYPE} == 'reqSectionNumber') {
        $inType = 1;
    }
    $str = &t_section($newIDX, $DATA{IN_SECTION},$DATA{TX_SECTION}, $DATA{TX_TYPE}, 0, $inType);
    return ($str);
    }
sub tech_openAddSection (){
    my $eventIDX= $q->param('eventIDX');
    my $txType  = $q->param('txType');
    my $secCount  = $q->param('secCount');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str = '<div class="w3-container w3-round w3-border w3-margin-bottom w3-light-grey">';
    $str .= '<div class="w3-cell-row">';
    $str .= '<div class="w3-container w3-cell w3-mobile  ">';
    $str .= '<label style="margin-left: 7px; margin-top: 10px;">Section #.</label><br>';
    $str .= sprintf '<input type="number" ID="IN_SECTION" class="w3-input w3-border w3-round " placeholder="'.$secCount.'" style="width: 100px" value="%d"><br>', $secCount;
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container ">';
    $str .= '<label style="margin-left: 7px;">Section Title</label><br>';
    $str .= '<input type="text" ID="TX_SECTION" class="w3-input w3-border w3-round" placeholder="Section Title"><br>';
    # $str .= '<label style="margin-left: 5px;">This section applies to the following classes</label><br>';
    # $str .= '<input type="checkbox" class="w3-check sectionClass" value="1" data-field="BO_REGULAR" placeholder="Title"><label class="w3-margin-left w3-margin-right">Regular Class</label><br>';
    # $str .= '<input type="checkbox" class="w3-check sectionClass" value="2" data-field="BO_ADVANCE" placeholder="Title"><label class="w3-margin-left w3-margin-right">Advanced Class</label><br>';
    # $str .= '<input type="checkbox" class="w3-check sectionClass" value="3" data-field="BO_MICRO" placeholder="Title"><label class="w3-margin-left w3-margin-right">Micro Class</label><br>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-center w3-padding">';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-right" onclick="$(this).close();">Cancel</button>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-margin-left w3-green" onclick="tech_addSection(this, \'%s\');">Add Section</button>', $txType;
    $str .= '</div>';
    return ($str);
    # return ($str);
    }
sub tech_openSetup (){
    my $eventIDX= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Tech = new SAE::TECH();
    my %TECH = %{$Tech->_getTechSection()};
    print $q->header();
    my $str = '<div class="w3-container w3-white w3-margin-top">';
    $str .= '<header class="w3-container" style="padding-top:22px">';
    $str .= '<h2>Technical Inspection Rubric Setup</h2>';
    $str .= '</header>';
    $str .= '<div class="w3-bar w3-light-white">';
    $str .= '<button class="w3-bar-item w3-button w3-border w3-round"><i class="fa fa-arrow-left" aria-hidden="true" onClick="openInspectionModule();"> Back</i></button>';
    $str .= '</div>';
    $str .= '<div class="w3-display-container w3-light-grey w3-margin-top">';
    # Requirement Section 
    $str .= sprintf '<button onclick="tech_expandSection(this, \'%s\')" class="w3-button w3-block w3-light-blue w3-left-align w3-padding-16">', 'requirementRubric';
    $str .= '<i class="fa fa-chevron-right fa-all w3-left"></i>';
    $str .= '<span class="w3-large w3-margin-left">Requirements</span>';
    $str .= '</button>';
    $str .= '<div id="requirementRubric" class="w3-hide w3-container" style="padding: 0;">';
    $str .= '<div class="w3-container w3-border w3-padding w3-light-grey">';
    $str .= sprintf '<button data-class="" class="w3-button w3-border w3-round w3-card-2 w3-hover-green" onclick="tech_openAddSection(\'%s\');">Add Requirements</button>','reqSectionNumber';
    $str .= '</div>';
    $str .= '<div id="reqSectionNumber_content" class="w3-container w3-border w3-padding w3-pale-yellow">';

    foreach $sectionIDX (sort {$TECH{reqSectionNumber}{$a}{IN_SECTION} <=> $TECH{reqSectionNumber}{$b}{IN_SECTION}} keys %{$TECH{reqSectionNumber}}) {
        $str .= &t_section($sectionIDX , $TECH{reqSectionNumber}{$sectionIDX}{IN_SECTION},$TECH{reqSectionNumber}{$sectionIDX}{TX_SECTION}, $TECH{reqSectionNumber}{$sectionIDX}{TX_TYPE}, $TECH{reqSectionNumber}{$sectionIDX}{BO_CHECK}, 1);
    }
    $str .= '</div>';
    $str .= '</div>'; 
    # Safety Section 
    $str .= sprintf '<button onclick="tech_expandSection(this, \'%s\')" class="w3-button w3-block w3-light-blue w3-left-align w3-padding-16">', 'safetyRubric';
    $str .= '<i class="fa fa-chevron-right fa-all w3-left"></i>';
    $str .= '<span class="w3-large w3-margin-left">Safety & Airworthiness</span>';
    $str .= '</button>';
    $str .= '<div id="safetyRubric" class="w3-hide w3-container" style="padding: 0;">';
    $str .= '<div class="w3-container w3-border w3-padding w3-light-grey">';
    $str .= sprintf '<button data-class="" class="w3-button w3-border w3-round w3-card-2 w3-hover-green" onclick="tech_openAddSection(\'%s\');">Add Requirements</button>','safetySectionNumber';
    $str .= '</div>';
    $str .= '<div id="safetySectionNumber_content" class="w3-container w3-border w3-padding w3-pale-yellow">';
    foreach $sectionIDX (sort {$TECH{safetySectionNumber}{$a}{IN_SECTION} <=> $TECH{safetySectionNumber}{$b}{IN_SECTION}} keys %{$TECH{safetySectionNumber}}) {
        $str .= &t_section($sectionIDX , $TECH{safetySectionNumber}{$sectionIDX}{IN_SECTION},$TECH{safetySectionNumber}{$sectionIDX}{TX_SECTION}, $TECH{safetySectionNumber}{$sectionIDX}{TX_TYPE}, $TECH{safetySectionNumber}{$sectionIDX}{BO_CHECK}, 0);
    }
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';
    # return ($str);
    my  %DATA;
        $DATA{html} = $str;
        $DATA{REQ} = join(";", keys %{$TECH{reqSectionNumber}});
        $DATA{SAFETY} = join(";", keys %{$TECH{safetySectionNumber}});
    my $json = encode_json \%DATA;
    return ($json);
    }
sub tech_reviewStudentChecklist (){
    my $eventIDX   = $q->param('eventIDX');
    my $teamIDX    = $q->param('teamIDX');
    my $classIDX   = $q->param('classIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $txType     = 'reqSectionNumber';
    my $Tech       = new SAE::TECH();
    my %TECH       = %{$Tech->_getStudentTechList($teamIDX)};
    my %HEAD       = %{$Tech->_getSectionHeading($txType, $classIDX)};
    my %REQ        = %{$Tech->_getReqList( $classIDX )};
    print $q->header();
    my $str;
    $str .= '<ul class="w3-ul">';
    foreach $reqSectionIDX (sort {$HEAD{$a}{IN_SECTION} <=> $HEAD{$b}{IN_SECTION}} keys %HEAD ) {
        # $str .= '$reqSectionIDX<br>';
        foreach $reqIDX (sort {$REQ{$reqSectionIDX}{$a}{IN_SECTION} <=> $REQ{$reqSectionIDX}{$b}{IN_SECTION}} keys %{$REQ{$reqSectionIDX}}) {
            # printf "  %d = %d\n", $reqIDX, $TECH{$reqIDX}{BO_CHECK};
            if($TECH{$reqIDX}{BO_CHECK} == 0){
                $str .= '<li class="w3-bar w3-border w3-white w3-round w3-margin-top w3-card-4">';
                $str .= '<i class="w3-bar-item fa-3x fa fa-times w3-text-red" aria-hidden="true"></i>';
                $str .= '<div class="w3-bar-item">';
                $str .= sprintf '%d.%d- %s', $HEAD{$reqSectionIDX}{IN_SECTION}, $REQ{$reqSectionIDX}{$reqIDX}{IN_SECTION}, $REQ{$reqSectionIDX}{$reqIDX}{TX_SECTION};
                $str .= '</div>';
                $str .= '</li>';
                } else {
                $str .= '<li class="w3-bar w3-border w3-green w3-round w3-margin-top w3-card-4">';
                $str .= '<i class="w3-bar-item fa-3x fa fa-check w3-text-white" aria-hidden="true"></i>';
                $str .= '<div class="w3-bar-item">';
                $str .= sprintf '%d.%d- %s', $HEAD{$reqSectionIDX}{IN_SECTION}, $REQ{$reqSectionIDX}{$reqIDX}{IN_SECTION}, $REQ{$reqSectionIDX}{$reqIDX}{TX_SECTION};
                $str .= '</div>';
                $str .= '</li>';
                }
            }
        }
    $str .= '</ul>';
    return ($str);
    }
sub tech_openTechInspectionPrecheckTeamList (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $Tech       = new SAE::TECH();
    my %TEAMS      = %{$Tech->_getTeamList($eventIDX)};
    my $str;
    my $txType     = 'reqSectionNumber';
    # my %TECH       = %{$Tech->_getStudentTechList($teamIDX)};
    
    my %STATUS     = (0=>'Self-Certification of Compliance completed.', 1=>'Self-Certification is not complete.  Cannot proceed to Inspection at this time.');
    # my %REQ        = %{$Tech->_getReqList( $classIDX )};
    $str = '<div class="w3-container w3-margin-top">';
    $str .= '<header class="w3-container"  style="padding-top:22px"><h3>Technical Inspection Pre-Check</h3></header>';
    $str .= '<div class="w3-bar w3-light-grey">';
    $str .= '<button class="w3-bar-item w3-button w3-border w3-round"><i class="fa fa-arrow-left" aria-hidden="true" onClick="openInspectionModule();"> Back</i></button>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<ul class="w3-ul">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inNumber         = $TEAMS{$teamIDX}{IN_NUMBER};
        my $classIDX         = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $txSchool         = $TEAMS{$teamIDX}{TX_SCHOOL};
        my %TECH       = %{$Tech->_getStudentTechList($teamIDX)};
        my %REQ        = %{$Tech->_getReqList( $classIDX )};
        my $boComplete = 0;
        my %HEAD       = %{$Tech->_getSectionHeading($txType, $classIDX)};
        foreach $reqSectionIDX (sort {$a<=>$b} keys %HEAD ) {
            foreach $reqIDX (sort keys %{$REQ{$reqSectionIDX}}) {
                if($TECH{$reqIDX}{BO_CHECK} == 0){$boComplete = 1}
            }
        }
        $str .= sprintf '<li class="w3-bar w3-border w3-white w3-round w3-margin-top w3-card" onclick="tech_reviewStudentChecklist(this, %d, %d, %d);">', $teamIDX, $inNumber, $classIDX;
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<div class="w3-xlarge"><b>%03d</b>',$TEAMS{$teamIDX}{IN_NUMBER};
        if ($boComplete == 0) {
            $str .= sprintf '<i class="fa fa-thumbs-o-up w3-margin-left w3-text-green" aria-hidden="true"> %s</i>', $STATUS{$boComplete};
            } else {
                $str .= sprintf '<i class="fa fa-thumbs-o-down w3-margin-left w3-text-red" aria-hidden="true"> %s</i>', $STATUS{$boComplete};
            }
        $str .= sprintf '</div>%s',  $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
    }
sub openInspectionModule (){
    my $eventIDX    = $q->param('eventIDX');
    my $inUserType  = $q->param('inUserType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    # my $str;
    my $str = '<div class="w3-container w3-white w3-margin-top">';
    $str .= '<header class="w3-container" style="padding-top:22px">';
    $str .= '<h3>Technical Inspection</h3>';
    $str .= '</header>';
    $str .= '<div class="w3-row w3-row-padding w3-margin-bottom">';
    if ($inUserType==4){
        $str .= '<div class="w3-quarter" onClick="tech_openSetup();" style="cursor: pointer">';
            $str .= '<div class="w3-container w3-light-grey w3-padding-16  w3-border w3-round w3-margin-bottom w3-card-4">';
                $str .= '<i class="fa fa-cogs fa-3x w3-right" aria-hidden="true"></i>';
                $str .= '<h4 class="w3-left">Setup Inspection Rubric</h4>';
                $str .= '</div>';
            $str .= '</div>';
        }
        # $str .= '<div class="w3-clear"></div><hr>';
        $str .= '<div class="w3-quarter" onClick="tech_openTechInspectionPrecheckTeamList(this);" style="cursor: pointer">';
            $str .= '<div class="w3-container w3-pale-yellow w3-padding-16 w3-border w3-round w3-margin-bottom w3-card-4">';
                $str .= '<i class="fa fa-eye-slash fa-3x w3-right" aria-hidden="true"></i>';
                $str .= '<h4 class="w3-left">PRE-CHECK</h4>';
                $str .= '</div>';
            $str .= '</div>';
        # $str .= '</div>';

        $str .= '<div class="w3-quarter" onClick="tech_openTechInspectionTeamList();" style="cursor: pointer">';
            $str .= '<div class="w3-container w3-light-blue w3-padding-16 w3-border w3-round w3-margin-bottom w3-card-4">';
                $str .= '<i class="fa fa-check-square-o fa-3x w3-right" aria-hidden="true"></i>';
                $str .= '<h4 class="w3-left">Perform Inspection</h4>';
                $str .= '</div>';
            $str .= '</div>';
        $str .= '</div>';
    return ($str);
    }
sub viewTeamReinspection (){
    my $eventIDX= $q->param('eventIDX');
    my $inspectIDX= $q->param('inspectIDX');
    my $Tech = new SAE::TECH();
    my %TECH = %{$Tech->_getInspectionItemDetails($inspectIDX)};
    print $q->header();
    my $str = '<div class="w3-container">';
    $str .= '<div class="w3-card-4">';
    $str .= '<header class="w3-container w3-red">';
    $str .= sprintf '<h3>%03d - %s</h3>', $TECH{IN_NUMBER}, $TECH{TX_SCHOOL};
    $str .= '</header>';
    my @ITEMS = split(";", $TECH{CL_ITEMS});
    $str .= '<ul class="w3-ul w3-border w3-round">';
    $str .= '<div class="w3-container w3-padding w3-large w3-pale-red">Requesting the following items be re-inspected and cleared for future flight attempts</div>';
    foreach $item (sort {$a cmp $b} @ITEMS){
        $str .= sprintf '<li class="w3-margin-left"><i class="fa fa-bug w3-margin-right" aria-hidden="true"></i>%s</li>', $item;
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-border w3-round">';
        $str .= sprintf '<h5>Attempt #%02d</h5>', $TECH{IN_ROUND};
        $str .= '<div class="w3-panel w3-margin-top w3-padding w3-leftbar w3-border-orange">';
    if ($TECH{ATTEMPT_NOTES}) {
        $str .= sprintf '%s', $TECH{ATTEMPT_NOTES};
        } else {
            $str .= '<i>No notes provided at this time</i>';
        }
        $str .= '</div>';
    # $str .= '<div class="w3-container w3-padding-large w3-margin-top w3-center">';
    # $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-green w3-margin-right" style="width: 270px;" onclick="clearReinspectionByTech(this, %d);">Cleared to Attempt Next Flight</button>', $inspectIDX;
    # $str .= '<button class="w3-button w3-margin-left w3-border w3-round w3-pale-red" style="width: 200px;" onclick="$(this).close();">Not Cleared</button>';
    # $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
    }
sub openCrashReinspection(){
    print $q->header();
    my $eventIDX = $q->param('location');
    # my $inShowAll = $q->param('inShowAll');
    my $Tech = new SAE::TECH();
    my %TECH = %{$Tech->_getListToBeReinspected($eventIDX)};
    my $str = '<br><div class="w3-container w3-margin-top">';
    $str .= '<h3>Re-Inspections</h3>';
    $str .= '<div class="w3-container">';
    $str .= '<input ID="showAllReinspectionTasks" class="w3-check" type="checkbox"  onclick="toggleShowAllReinspectionTasks(this);"><label class="w3-margin-left">Show All Reinspection Tasks</label>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<ul ID="UL_ReinspectionList" class="w3-ul">';
    foreach $inspectIDX (sort {$TECH{$a}{IN_NUMBER} <=> $TECH{$b}{IN_NUMBER}} keys %TECH) {
        $str .= $Tech->_getTechButton($inspectIDX);
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
 }
sub reviewInspectionDetails (){
    my $eventIDX   = $q->param('eventIDX');
    my $inspectIDX = $q->param('inspectIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Tech = new SAE::TECH();
    my %TECH = %{$Tech->_getInspectionItemDetails($inspectIDX)};
    print $q->header();
    my $str = '<div class="w3-container">';
    $str .= '<div class="w3-card-4">';
    $str .= '<header class="w3-container w3-red">';
    $str .= sprintf '<h3>%03d - %s</h3>', $TECH{IN_NUMBER}, $TECH{TX_SCHOOL};
    $str .= '</header>';
    my @ITEMS = split(";", $TECH{CL_ITEMS});
    $str .= '<ul class="w3-ul w3-border w3-round">';
    $str .= '<div class="w3-container w3-padding w3-large w3-pale-red">Requesting the following items be re-inspected and cleared for future flight attempts</div>';
    foreach $item (sort {$a cmp $b} @ITEMS){
        $str .= sprintf '<li class="w3-margin-left"><i class="fa fa-bug w3-margin-right" aria-hidden="true"></i>%s</li>', $item;
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-border w3-round">';
        $str .= sprintf '<h5>Attempt #%02d</h5>', $TECH{IN_ROUND};
        $str .= '<div class="w3-panel w3-margin-top w3-padding w3-leftbar w3-border-orange">';
    if ($TECH{ATTEMPT_NOTES}) {
        $str .= sprintf '%s', $TECH{ATTEMPT_NOTES};
        } else {
            $str .= '<i>No notes provided at this time</i>';
        }
        $str .= '</div>';
    $str .= '<div class="w3-container w3-padding-large w3-margin-top w3-center">';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-green w3-margin-right" style="width: 270px;" onclick="clearReinspectionByTech(this, %d);">Cleared to Attempt Next Flight</button>', $inspectIDX;
    $str .= '<button class="w3-button w3-margin-left w3-border w3-round w3-pale-red" style="width: 200px;" onclick="$(this).close();">Not Cleared</button>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
    }
sub reviewClearedInspectionDetails (){
    my $eventIDX   = $q->param('eventIDX');
    my $inspectIDX = $q->param('inspectIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Tech = new SAE::TECH();
    my %TECH = %{$Tech->_getInspectionItemDetails($inspectIDX)};
    print $q->header();
    my $str = '<div class="w3-container">';
    $str .= '<div class="w3-card-4">';
    $str .= '<header class="w3-container w3-red">';
    $str .= sprintf '<h3>%03d - %s</h3>', $TECH{IN_NUMBER}, $TECH{TX_SCHOOL};
    $str .= '</header>';
    my @ITEMS = split(";", $TECH{CL_ITEMS});
    $str .= '<ul class="w3-ul w3-border w3-round">';
    $str .= '<div class="w3-container w3-padding w3-large w3-pale-red">Requesting the following items be re-inspected and cleared for future flight attempts</div>';
    foreach $item (sort {$a cmp $b} @ITEMS){
        $str .= sprintf '<li class="w3-margin-left"><i class="fa fa-bug w3-margin-right" aria-hidden="true"></i>%s</li>', $item;
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-border w3-round">';
        $str .= sprintf '<h5>Attempt #%02d</h5>', $TECH{IN_ROUND};
        $str .= '<div class="w3-panel w3-margin-top w3-padding w3-leftbar w3-border-orange">';
    if ($TECH{ATTEMPT_NOTES}) {
        $str .= sprintf '%s', $TECH{ATTEMPT_NOTES};
        } else {
            $str .= '<i>No notes provided at this time</i>';
        }
        $str .= '</div>';
    $str .= '<div class="w3-container w3-padding-large w3-margin-top w3-center">';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-red w3-margin-right" style="width: 250px;" onclick="unclearReinpsectionByTech(this, %d);">Not Ready for Next Attempt</button>', $inspectIDX;
    $str .= '<button class="w3-button w3-margin-left w3-border w3-round" style="width: 200px;" onclick="$(this).close();">Close</button>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
    }
sub clearReinspectionByTech (){
    my $inspectIDX= $q->param('inspectIDX');
    my $userIDX= $q->param('userIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $Tech   = new SAE::TECH();
    my %TECH   = %{$Tech->_getInspectionItemDetails($inspectIDX)};
    my %DATA, %DATA2;
    my $teamIDX   = $TECH{FK_TEAM_IDX};
    my $flightIDX = $TECH{FK_FLIGHT_IDX};
    $DATA{BO_REINSPECT}   = 0;
    $DATA2{BO_STATUS}     = 0;
    $DATA2{IN_CLEARED_BY} = $userIDX;
    my $JsonDB = new SAE::JSONDB();
       $JsonDB->_update('TB_REINSPECT', \%DATA2, qq(PK_REINSPECT_IDX=$inspectIDX));
       $JsonDB->_update('TB_TEAM', \%DATA, qq(PK_TEAM_IDX=$teamIDX));
       $JsonDB->_update('TB_FLIGHT', \%DATA, qq(PK_FLIGHT_IDX=$flightIDX));

    my $json = encode_json \%TECH;
    return ($json);
    }
sub unclearReinpsectionByTech (){
    my $inspectIDX= $q->param('inspectIDX');
    my $userIDX= $q->param('userIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $Tech   = new SAE::TECH();
    my %TECH   = %{$Tech->_getInspectionItemDetails($inspectIDX)};
    my %DATA, %DATA2;
    my $teamIDX   = $TECH{FK_TEAM_IDX};
    my $flightIDX = $TECH{FK_FLIGHT_IDX};
    $DATA{BO_REINSPECT}   = 1;
    $DATA2{BO_STATUS}     = 1;
    $DATA2{IN_CLEARED_BY} = 0;
    my $JsonDB = new SAE::JSONDB();
       $JsonDB->_update('TB_REINSPECT', \%DATA2, qq(PK_REINSPECT_IDX=$inspectIDX));
       $JsonDB->_update('TB_TEAM', \%DATA, qq(PK_TEAM_IDX=$teamIDX));
       $JsonDB->_update('TB_FLIGHT', \%DATA, qq(PK_FLIGHT_IDX=$flightIDX));
    $TECH{BO_STATUS} = 0;
    my $json = encode_json \%TECH;
    return ($json);
    }
sub t_teamInspectionBar(){
    my ($teamIDX, $inspectionStatus, $inSafetyStatus, $classIDX, $inNumber, $txSchool) = @_;
    my $Plane = new SAE::TECH();
    my %PLANES = %{$Plane->_getTechPlanes($teamIDX)};

    my $str;
    $str = sprintf '<li ID="TECH_INSPECTION_%d" class="w3-bar w3-border w3-white w3-round w3-card-2 w3-margin-bottom">', $teamIDX;

    $str .= '<div class="w3-bar-item" style="width: 200px;">';
    $str .= sprintf '<span class="w3-xlarge">Team #: %03d</span><br>', $inNumber;
    $str .= sprintf '<span>%s</span>', $txSchool;
    $str .= '</div>';
    $str .= '<div ID="techHanger_'.$teamIDX.'" class="w3-bar-item" style="vertical-align: top; display: flex; flex-wrap: wrap;">';
    foreach $planeIDX (sort {$PLANES{$a}{IN_SEQUENCE} <=> $PLANES{$b}{IN_SEQUENCE}} keys %PLANES) {
        if ($PLANES{$planeIDX}{BO_PADA} == 1) {
                $str .= &t_padaButton($teamIDX, $inNumber, $classIDX, $PLANES{$planeIDX}{IN_SEQUENCE}, $planeIDX);    
            } else {
                $str .= &t_planeButton($teamIDX, $inNumber, $classIDX, $PLANES{$planeIDX}{IN_SEQUENCE}, $planeIDX);    
            }
    }
        $str .= sprintf '<button class="w3-container w3-button w3-center w3-margin-left planeButton_'.$teamIDX.'" style="border: 2px dashed #cbcbcb; width: 120px; height: 70px; background-color: #fff" onclick="tech_addPlane(this, %d, %d, %d, %d);">', $teamIDX, $inNumber, $classIDX, $planeIDX;
        $str .= '<b class="" style="color: #ccc">Add</b><br>';
        $str .= '<i class="fa fa-plus" style="color: #ccc" aria-hidden="true"></i>';
        $str .= '</button>';
    $str .= '</div>';
    $str .= '</li>';
    return($str);
    }
sub t_inspectionItem (){
    my ($checkType, $classIDX, $teamIDX, $itemIDX, $headingIDX, $txRequirement, $inHeading, $inSection, $txSection, $inStatus, $certStatus, $inPoints, $planeIDX, $requiredCheck, $boAbsolute) = @_;
    my $str;
    # checkType: 0=Safety, 1=Requirements
    my %COLOR = (0=>'w3-red', 1=>'w3-blue',2=>'w3-yellow');
    if ($requiredCheck==1) {
            $str = sprintf '<li ID="TECH_ITEM_%d_%d" class="w3-bar %s w3-border w3-round w3-padding-small w3-card-2 w3-margin-bottom" >', $teamIDX, $itemIDX, $COLOR{$inStatus};
        } else {
            $str = sprintf '<li ID="TECH_ITEM_%d_%d" class="w3-bar %s optionalHeading w3-hide w3-border w3-round w3-padding-small w3-card-2 w3-margin-bottom" >', $teamIDX, $itemIDX, $COLOR{$inStatus};
        }
                if ($certStatus == 1){
                    $str .= '<div class="w3-row w3-pale-green">';
                } else {
                    $str .= '<div class="w3-row w3-pale-red">';
                }
                if ($checkType==1) {
                    if ($certStatus == 1){
                            $str .= sprintf '<div class="w3-col w3-xlarge w3-center w3-padding-24 w3-mobile" style="width: 210px;">%2.1f pts',  $inPoints;
                            $str .= '<br><span class="w3-large">In Compliance</span>';
                            # $str .= '</div>';
                        } else {
                            $str .= sprintf '<div class="w3-col w3-xlarge w3-center w3-padding-24 w3-mobile" style="width: 210px;">%2.1f pts',  $inPoints;
                            $str .= '<br><span class="w3-large">Non-Compliance</span>';
                        }
                        $str .= '</div>';
                }
                $str .= '<div class="w3-rest w3-white w3-mobile w3-padding-bottom">';
                $str .= sprintf '<div class="w3-container w3-padding-16 w3-large">';
                if ($boAbsolute == 1){
                    $str .= sprintf '%d.%s - (<b class="w3-text-red"> ABSOLUTE </b>) %s</div>',$inHeading,  $inSection, $txSection;
                } else {
                    $str .= sprintf '%d.%s - %s</div>',$inHeading,  $inSection, $txSection;
                }
                if ($checkType==0) {
                        $str .= sprintf '<button class="w3-button w3-border w3-card w3-round w3-margin-left w3-margin-bottom w3-pale-red" style="width: 240px;" onclick="tech_passTechInspection(this, %d, %d, %d, %d, 0, %d, %d);">Fail</button>', $teamIDX, $itemIDX, $headingIDX, $classIDX, $checkType, $planeIDX;
                        $str .= sprintf '<button class="w3-button w3-border w3-card w3-round w3-margin-left w3-margin-bottom w3-pale-blue" style="width: 240px;" onclick="tech_passTechInspection(this, %d, %d, %d, %d, 1, %d, %d);">Pass</button>', $teamIDX, $itemIDX, $headingIDX, $classIDX, $checkType, $planeIDX;
                    } else {
                        $str .= sprintf '<button class="w3-button w3-border w3-card w3-round w3-margin-left w3-margin-bottom w3-pale-red" style="width: 240px;" onclick="tech_passTechInspection(this, %d, %d, %d, %d, 0, %d, %d);">Fail</button>', $teamIDX, $itemIDX, $headingIDX, $classIDX, $checkType, $planeIDX;
                        if ($certStatus == 1){
                            $str .= sprintf '<button class="w3-button w3-border w3-card w3-round w3-margin-left w3-margin-bottom w3-pale-blue" style="width: 240px;" onclick="tech_passTechInspection(this, %d, %d, %d, %d, 1, %d, %d);">Pass with No Penalty</button>', $teamIDX, $itemIDX, $headingIDX, $classIDX, $checkType, $planeIDX;
                        }
                        $str .= sprintf '<button class="w3-button w3-border w3-card w3-round w3-margin-left w3-margin-bottom w3-pale-yellow" style="width: 240px;" onclick="tech_passTechInspection(this, %d, %d, %d, %d, 2, %d, %d);">Pass w/ %2.1f Point Penalty</button>',$teamIDX, $itemIDX, $headingIDX, $classIDX, $checkType, $planeIDX, $inPoints;
                    }
                $str .= '</div>';

                $str .= '</div>';

  
    $str .= '</li>';
    return ($str);
    }
sub t_itemRow (){
    my ($sectionIDX, $itemIDX, $secNumber, $txRequirement, $txSection, $reg, $adv, $pada, $mic, $pts, $absolute) = @_;
    my %APPLICABLE = (1=>'Yes', 0=>'---');
    my %ABS = (1=>'<b class="w3-text-red">Yes</b>', 0=>'No', ''=>'No');
    # print $q->header();
    my $str;
    $str = '<tr ID="ITEM_'.$itemIDX.'">';
    $str .= sprintf '<td class="w3-left-align itemGroup_'.$sectionIDX.'">%d</td>', $secNumber;
    $str .= sprintf '<td class="w3-left-align">%s</td>', $txRequirement;
    $str .= sprintf '<td class="w3-left-align">%s</td>', $txSection;
    $str .= sprintf '<td class="w3-center">%s</td>', $ABS{$absolute};
    $str .= sprintf '<td class="w3-right-align">%s</td>', $APPLICABLE{$reg};
    $str .= sprintf '<td class="w3-right-align">%s</td>', $APPLICABLE{$adv};
    $str .= sprintf '<td class="w3-right-align">%s</td>', $APPLICABLE{$pada};
    $str .= sprintf '<td class="w3-right-align">%s</td>', $APPLICABLE{$mic};
    $str .= sprintf '<td class="w3-right-align pointsFor_%d" >%2.2f</td>', $sectionIDX, $pts;
    $str .= sprintf '<td class="w3-right-align">';
    $str .= sprintf '<i class="fa fa-pencil  w3-button w3-hover-green w3-round" aria-hidden="true" onclick="tech_editItem(this, %d, %d, %d);"></i>', $itemIDX, $secNumber, $sectionIDX;
    $str .= sprintf '<i class="fa fa-trash-o w3-button w3-hover-red w3-round" aria-hidden="true" onclick="tech_deleteItem(this, %d, %d);"></i>', $itemIDX, $sectionIDX;
    $str .= '</td>';
    $str .= '</tr>';
    return ($str);
    }   
sub t_section (){
    my ($sectionIDX, $sec, $title, $secClass, $boCheck, $sectionType) = @_;
    my $Tech = new SAE::TECH();
    my %ITEMS = %{$Tech->_getTechSectionCheckItems($sectionIDX)};
    my $str;
    $str = '<div class="w3-display-container w3-round w3-border w3-margin-bottom w3-card w3-white">';
    $str .= sprintf '<i class="fa fa-times w3-display-topright w3-margin w3-button w3-hover-red w3-round" aria-hidden="true" onclick="tech_deleteSection(this, %d);"></i>', $sectionIDX;
    $str .= '<div class="w3-border" style="display: flex; width: 100%; border: 1px solid #ccc; padding: 10px;">';
    $str .= sprintf '<label class="%s" style="flex: 0 1 auto;"><h4>%s - </h4></label>', $secClass, $sec;
    $str .= sprintf '<input data-field="TX_SECTION" data-key="PK_TECH_REQ_SECTION_IDX" data-index="'.$sectionIDX.'" data-table="TB_TECH_REQ_SECTION" onchange="tech_updateField(this);" class="w3-border-0 w3-margin0-left w3-xlarge" type="text" value="%s" style="flex: 1 !important; flex-basis: 100%; margin-right: 60px; padding-left: 10px;">', $title;
    # $str .= sprintf '<h4><span class="%s">%s</span> - <span editable>%s</span></h4>', $secClass, $sec, $title;
    $str .= '</div>';
    $str .= '<table ID="tableSection_'.$sectionIDX.'" class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr class="w3-light-grey">';
    $str .= '<th class="w3-left-align" style="width: 100px;">Item #</th>';
    $str .= '<th class="w3-left-align" style="width: 100px;">Rule Ref.</th>';
    $str .= '<th class="w3-left-align">Description</th>';
    $str .= '<th class="w3-right-align" class="w3-right-align" style="width: 100px;">Absolute</th>';
    $str .= '<th class="w3-right-align" class="w3-right-align" style="width: 100px;">Regular</th>';
    $str .= '<th class="w3-right-align" style="width: 100px;">Advanced</th>';
    $str .= '<th class="w3-right-align" style="width: 100px;">PADA</th>';
    $str .= '<th class="w3-right-align" style="width: 100px;">Micro</th>';
    $str .= '<th class="w3-right-align" style="width: 100px;">Points</th>';
    $str .= '<th class="w3-right-align" style="width: 150px;">Actions</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    
    foreach $itemIDX (sort {$ITEMS{$a}{IN_SECTION} <=> $ITEMS{$b}{IN_SECTION}} keys %ITEMS) {
        $str .= &t_itemRow($sectionIDX,$itemIDX, $ITEMS{$itemIDX}{IN_SECTION},$ITEMS{$itemIDX}{TX_REQUIREMENT},$ITEMS{$itemIDX}{TX_SECTION}, $ITEMS{$itemIDX}{BO_REGULAR}, $ITEMS{$itemIDX}{BO_ADVANCE}, $ITEMS{$itemIDX}{BO_PADA}, $ITEMS{$itemIDX}{BO_MICRO}, $ITEMS{$itemIDX}{IN_POINTS}, $ITEMS{$itemIDX}{BO_ABSOLUTE});
    }
    $str .= '</table>';
    $str .= '<div class="w3-display-container w3-border-top w3-padding w3-grey" style="height: 60px">';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-hover-green w3-card w3-light-grey w3-left" onclick="tech_addCheckItem(this, %d, %d)">Add Check Item</button>', $sectionIDX, $sec;
    $str .= '<div class="w3-display-bottomright w3-text-white w3-xlarge w3-margin-bottom w3-margin-right sectionPoints_'.$sectionIDX.'">0 Points</div>';
    $str .= '<div class="w3-display-bottommiddle w3-text-white w3-xlarge w3-margin-bottom">';
    # $str .= '<input type="checkbox" class="w3-check" onc><label class="w3-margin-left">Required Inspection</label>';
    if ($sectionType==1){
        if ($boCheck == 1) {
            $str .= sprintf '<input type="checkbox" class="w3-check" checked data-table="TB_TECH_REQ_SECTION" data-field="BO_CHECK" data-primekey="PK_TECH_REQ_SECTION_IDX" data-key="%d" onchange="tech_updateCheckItem(this);"><label class="w3-margin-left">Required Inspection</label>', $sectionIDX;
            } else {

            $str .= sprintf '<input type="checkbox" class="w3-check" data-table="TB_TECH_REQ_SECTION" data-field="BO_CHECK" data-primekey="PK_TECH_REQ_SECTION_IDX" data-key="%d" onchange="tech_updateCheckItem(this);"><label class="w3-margin-left">Required Inspection</label>', $sectionIDX;
            }
        }
    $str .= '</div>';
    $str .= '</div>';

    $str .= '</div>';
    return ($str);
    } 
sub t_planeButton(){
    my ($teamIDX, $inNumber, $classIDX, $inSequence, $planeIDX) = @_;
    my %COLOR = (0=>'w3-white', 1=>'w3-green');
    my $Plane = new SAE::TECH();
    my ($reqStatus, $safetyStatus) = $Plane->_getPlaneInspectionStatus($planeIDX);
    my $str;
    $str .= sprintf '<button ID="TECH_PLANE_%d" class="w3-container w3-pale-yellow w3-button w3-center w3-margin-left w3-border w3-round w3-card-4 w3-margin-bottom planeButton_'.$teamIDX.'" style="width: 120px; height: 70px;" onclick="tech_openInspection(this,%d, %d, %d, %d, %d);">', $planeIDX, $teamIDX, $inNumber, $classIDX, $inSequence, $planeIDX;
    # $str .= sprintf '<button ID="TECH_PLANE_%d" class="'.$COLOR{$inPlaneStatus}.' w3-container w3-button w3-center w3-margin-left w3-border w3-round w3-card-2 w3-margin-bottom" style="width: 100px; height: 70px;" onclick="tech_openInspection(this,%d, %d, %d, %d, %d);">', $planeIDX, $teamIDX, $inNumber, $classIDX, $inSequence, $planeIDX;
    # $str .= sprintf '<button ID="TECH_PLANE_%d" class="w3-container w3-button w3-center w3-margin-left w3-border w3-round w3-card-2" style="width: 100px; height: 70px;" onclick="tech_openRequirementsCheck(this,%d, %d, %d, %d, %d);">', $planeIDX, $teamIDX,$inNumber,$classIDX, $inSequence, $planeIDX;
    $str .= sprintf '<span class="w3-text-grey">Plane<br>#%03d-<b class="w3-text-blue">%02d</b></span><br>', $inNumber, $inSequence;
    $str .= sprintf '<span class="w3-badge w3-green w3-border %s">R</span> ', $COLOR{$reqStatus};
    $str .= sprintf '<span class="w3-badge w3-green w3-border %s">S</span>', $COLOR{$safetyStatus};
    $str .= '</button>';
    return ($str);
    }   
sub t_padaButton(){
    my ($teamIDX, $inNumber, $classIDX, $inSequence, $planeIDX) = @_;
    my %COLOR = (0=>'w3-white', 1=>'w3-green');
    my $Plane = new SAE::TECH();
    my ($reqStatus, $safetyStatus) = $Plane->_getPlaneInspectionStatus($planeIDX);
    my $str;
    $str .= sprintf '<button ID="TECH_PLANE_%d" class="w3-container w3-orange w3-button w3-center w3-margin-left w3-border w3-round w3-card w3-margin-bottom planeButton_'.$teamIDX.'" style="width: 120px; height: 70px;" onclick="tech_openInspection(this,%d, %d, %d, %d, %d);">', $planeIDX, $teamIDX, $inNumber, 4, $inSequence, $planeIDX;
    # $str .= sprintf '<button ID="TECH_PLANE_%d" class="'.$COLOR{$inPlaneStatus}.' w3-container w3-button w3-center w3-margin-left w3-border w3-round w3-card-2 w3-margin-bottom" style="width: 100px; height: 70px;" onclick="tech_openInspection(this,%d, %d, %d, %d, %d);">', $planeIDX, $teamIDX, $inNumber, $classIDX, $inSequence, $planeIDX;
    # $str .= sprintf '<button ID="TECH_PLANE_%d" class="w3-container w3-button w3-center w3-margin-left w3-border w3-round w3-card-2" style="width: 100px; height: 70px;" onclick="tech_openRequirementsCheck(this,%d, %d, %d, %d, %d);">', $planeIDX, $teamIDX,$inNumber,$classIDX, $inSequence, $planeIDX;
    $str .= sprintf '<span class="w3-text-black">PADA<br>#%03d-<b class="w3-text-blue">%02d</b></span><br>', $inNumber, $inSequence;
    $str .= sprintf '<span class="w3-badge w3-green w3-border %s">R</span> ', $COLOR{$reqStatus};
    $str .= sprintf '<span class="w3-badge w3-green w3-border %s">S</span>', $COLOR{$safetyStatus};
    $str .= '</button>';
    return ($str);
    }   
sub tech_addPlane_option (){
    my $eventIDX= $q->param('eventIDX');
    my $teamIDX   = $q->param('teamIDX');
    my $classIDX  = $q->param('classIDX');
    my $inNumber  = $q->param('inNumber');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<ul class="w3-ul">';
    $str .= sprintf '<li class="w3-bar w3-border w3-white w3-round w3-margin-top w3-card-4 w3-button w3-hover-green" onclick="tech_addMainPlane(this, %d, %d, %d);">', $teamIDX, $inNumber, $classIDX;;
    # $str .= '<div class="w3-bar-item w3-right">';
    # $str .= '</div>';
    $str .= '<div class="w3-bar-item">';
    $str .= '<i class="fa fa-plus fa-2x"aria-hidden="true"> Add Main Aircraft</i>';
    $str .= '</div>';
    $str .= '</li>';

    $str .= sprintf '<li class="w3-bar w3-border w3-white w3-round w3-margin-top w3-card-4 w3-button w3-hover-green" onclick="tech_addPada(this, %d, %d, %d);">',$teamIDX, $inNumber, $classIDX;
    # $str .= '<div class="w3-bar-item w3-right">';
    # $str .= '</div>';
    $str .= '<div class="w3-bar-item">';
    $str .= '<i class="fa fa-plus fa-2x" aria-hidden="true"> Add PADA</i>';
    $str .= '</div>';
    $str .= '</li>';
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
    }
sub tech_addPada (){
    my $eventIDX= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $teamIDX   = $q->param('teamIDX');
    my $classIDX  = $q->param('classIDX');
    my $inNumber  = $q->param('inNumber');
    my $Plane     = new SAE::TECH();
    my $inCount   = $Plane->_getPlaneCount($teamIDX, 1);
       $inCount++;
    my $planeIDX = $Plane->_addPada($teamIDX, $inCount);
    my $str = &t_padaButton($teamIDX, $inNumber, 4, $inCount, $planeIDX);   
    my %DATA;
    $DATA{BTN}                 = $str;
    $DATA{FK_TEAM_IDX}         = $teamIDX;
    $DATA{TEAM_REQ_ALERT}      = $Plane->_getTechRequirementsCheckStatus($teamIDX); 
    $DATA{TEAM_SAFETY_ALERT}   = $Plane->_getTechSafetyCheckStatus($teamIDX); 
    my $json = encode_json \%DATA;
    return ($json);
    }
sub tech_addPlane (){
    my $eventIDX  = $q->param('eventIDX');
    my $teamIDX   = $q->param('teamIDX');
    my $classIDX  = $q->param('classIDX');
    my $inNumber  = $q->param('inNumber');
    my $Plane     = new SAE::TECH();
    my $inCount   = $Plane->_getPlaneCount($teamIDX, 0);
    $inCount++;
    print $q->header();
    my $planeIDX = $Plane->_addPlane($teamIDX, $inCount);
    my $str = &t_planeButton($teamIDX, $inNumber, $classIDX, $inCount, $planeIDX);    
    my %DATA;
    $DATA{BTN}                 = $str;
    $DATA{FK_TEAM_IDX}         = $teamIDX;
    $DATA{TEAM_REQ_ALERT}      = $Plane->_getTechRequirementsCheckStatus($teamIDX); 
    $DATA{TEAM_SAFETY_ALERT}   = $Plane->_getTechSafetyCheckStatus($teamIDX); 
    my $json = encode_json \%DATA;
    return ($json);
    }
sub tech_deleteInspection (){
    my $planeIDX= $q->param('planeIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Plane  = new SAE::TECH();
    my %DATA   = %{$Plane->_getTeamDataFromPlane($planeIDX)}; 
    my $teamIDX   = $DATA{FK_TEAM_IDX};

    my $JsonDB = new SAE::JSONDB();
       $JsonDB->_delete('TB_TECH_PLANE', qq(PK_TECH_PLANE_IDX=$planeIDX));
       $JsonDB->_delete('TB_TECH', qq(FK_TECH_PLANE_IDX=$planeIDX));
    my %DATA;
    $DATA{FK_TEAM_IDX}         = $teamIDX;
    $DATA{TEAM_REQ_ALERT}      = $Plane->_getTechRequirementsCheckStatus($teamIDX); 
    $DATA{TEAM_SAFETY_ALERT}   = $Plane->_getTechSafetyCheckStatus($teamIDX); 
    my $json = encode_json \%DATA;
    return ($json);
    }
sub tech_openInspection (){
    my $teamIDX    = $q->param('teamIDX');
    my $planeIDX   = $q->param('planeIDX');
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $inNumber   = $q->param('inNumber');
    my $inSequence = $q->param('inSequence');
    print $q->header();
    my $str;
    $str .= '<div class="w3-container w3-padding-16 w3-border w3-round">';
    $str .= '<div class="w3-panel w3-padding w3-pale-yellow w3-border w3-border-yellow">';
    $str .= '<ul class="w3-ul"><i class="fa fa-exclamation-triangle fa-2x" aria-hidden="true"> CAUTION: Before proceeding with the Inspection</i>';
    $str .= '<li class="w3-text-red w3-padding-small">All Aircraft are to be presented with prop, flight battery and Red arming plug <b>REMOVED</b></li>';
    $str .= '<li class=" w3-padding-small">Confirm that aircraft has team numbers on top, bottom and sides as required.</li>';
    $str .= '<li class=" w3-padding-small">Confirm that aircraft has school name on the model and school address inside the model.</li>';
    # $str .= $classIDX;
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<ul class="w3-ul">';

    $str .= sprintf '<li class="w3-bar w3-card-2 w3-border w3-white w3-round w3-hover-green w3-margin-bottom" style="cursor: pointer;" onclick="tech_openRequirementsCheck(this,%d, %d, %d, %d, %d);">', $teamIDX, $inNumber,$classIDX, $inSequence, $planeIDX;
    $str .= '<div class="w3-bar-item w3-left">';
    $str .= sprintf '<i class="fa fa-check-square-o fa-2x" aria-hidden="true"> Plane #: %02d - Requirements</i><br>', $inSequence;

    $str .= sprintf '<span class="w3-large">Perform Requirement Checks</span>';
    $str .= '</div>';
    $str .= '<div class="w3-bar-item w3-right">';
    $str .= '<i class="fa fa-chevron-right fa-3x" aria-hidden="true"></i>';
    $str .= '</div>';
    $str .= '</li>';

# $str .= '<button class="w3-border '.$colorSafetyStatus.' w3-round w3-button w3-margin-right w3-hover-orange w3-margin-top" style="width: 200px;" onclick="tech_openSafetyCheck(this, '.$teamIDX.','.$inNumber.','.$classIDX.');">'.$txSafety.'</button>';
    $str .= sprintf '<li class="w3-bar w3-card-2 w3-border w3-white w3-round-large w3-hover-green w3-margin-bottom" style="cursor: pointer;" onclick="tech_openSafetyCheck(this,%d, %d, %d, %d, %d);">', $teamIDX, $inNumber,$classIDX, $inSequence, $planeIDX;
    $str .= '<div class="w3-bar-item w3-left">';
    $str .= sprintf '<i class="fa fa-medkit fa-2x" aria-hidden="true"> Plane #: %02d - Safety</i><br>', $inSequence;
    $str .= sprintf '<span class="w3-large">Perform Safety & Air-worthiness Checks</span>';
    $str .= '</div>';
    $str .= '<div class="w3-bar-item w3-right">';
    $str .= '<i class="fa fa-chevron-right fa-3x" aria-hidden="true"></i>';
    $str .= '</div>';
    $str .= '</li>';
    $str .= '<hr>';
    
    $str .= sprintf '<li class="w3-bar w3-card-2 w3-border w3-white w3-round-large w3-pale-red w3-hover-red w3-margin-bottom" style="cursor: pointer;" onclick="tech_deleteInspection(this, %d);">', $planeIDX;
    $str .= '<div class="w3-bar-item w3-left">';
    
    $str .= sprintf '<i class="fa fa-minus-circle fa-2x" aria-hidden="true"> Plane #: %02d - Remove</i><br>', $inSequence;
    $str .= sprintf '<span class="w3-large">Remove Aircraft from inspection inventory</span>';
    $str .= '</div>';
    $str .= '<div class="w3-bar-item w3-right">';
    $str .= '<i class="fa fa-times fa-3x w3-text-white" aria-hidden="true"></i>';
    $str .= '</div>';
    $str .= '</li>';

    $str .= '</ul>';
    # $str .= sprintf '<button     class="w3-round w3-button w3-card w3-border w3-large w3-pale-blue w3-hover-green" style="height: 100px; width: 100%;" onclick="tech_openRequirementsCheck(this,%d, %d, %d, %d, %d);">Plane #: %02d<br>Perform Requirement Check</button>', $teamIDX,$inNumber,$classIDX, $inSequence, $planeIDX, $inSequence;
    # $str .= sprintf '<br><button class="w3-round w3-button w3-card w3-border w3-margin-top  w3-large w3-pale-blue w3-hover-green"  style="height: 100px; width: 100%;">Plane #: %02d<br>Safey & Airworthiness Check</button>', $inSequence;
    # $str .= sprintf '<br><button class="w3-round w3-button w3-card w3-border w3-margin-top  w3-large w3-pale-red w3-hover-red" style="height: 100px; width: 100%;" onclick="tech_deleteInspection(this, %d);">Plane #: %02d<br>Remove From Inventory</button>', $planeIDX, $inSequence;
    $str .= '</div>';

    return ($str);
    }
### --------------- 2023 ------------------------------------------------------
sub __template(){
    print $q->header();
    my $str;
    my $location = $q->param('location');


    return ($str);
    }
sub _templateEcrCard(){
    my ($ecrIDX, $teamIDX, $inValue, $inStatus, $userType) = @_;
    if ($inStatus >0){
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-red" onclick="sae_openExitingECR(%d, %d, %d);">-%2.2f</button>', $ecrIDX, $ecrIDX, $teamIDX, $userType, $inValue;
    } else {
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-yellow" onclick="sae_openExitingECR(%d, %d, %d);">E-000%d: Pending Review</button>', $ecrIDX, $ecrIDX, $teamIDX, $userType, $ecrIDX;
    }
    return ($str);
    }
# ================= 2020 ==============================
sub showListOfTeam_Tech(){
    print $q->header();
    # my $dbi = new SAE::Db();
    my $str;
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Ecr = new SAE::ECR();
    my $Preso = new SAE::PRESO();
    my $Score = new SAE::SCORE();
    my $Ref = new SAE::REFERENCE();
    # my $Preso = new SAE::PRESO();
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};
    %ECRS = %{$Ecr->_getECRByEventID($location)};
    %PEN = %{$Score->_getPenaltyListByEvent($location)};
    %PAPER = %{$Ref->_getTeamDocuments($location)};
    my %TODO = %{$Preso->_getToDo($location, 2)};

    my $str;
    $str .= '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<h3>Tech/Safety Inspections</h3>';
    $str .= '<table class="w3-table-all w3-small" >';
    $str .= '<thead>';
    $str .= '<tr class="w3-light-grey w3-hide-small">';
    $str .= '<th style="width: 15%"># - School</th>';
    $str .= '<th style="width: 60px">Drawings</th>';
    
    $str .= '<th style="">Engineering Change Requests (ECRs)';
    $str .= '</th>';
   
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM){
        my $team = sprintf "%03d - %s", $TEAM{$teamIDX}{IN_NUMBER}, $TEAM{$teamIDX}{TX_SCHOOL};
        # $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
        my $eIDX = crypt($teamIDX, '20');
        $schedule = "Schedule";
        $status = "Status";
        if (exists($TODO{$teamIDX})) {
            $schedule = $TODO{$teamIDX}{TX_ROOM}." (".$TODO{$teamIDX}{TX_TIME}.')';
            if ($TODO{$teamIDX}{TX_STATUS} eq 'Passed'){
                $status =  '<i class="fa fa-check-square-o"></i> '.$TODO{$teamIDX}{TX_STATUS};
            } else {
                $status = $TODO{$teamIDX}{TX_STATUS};
            }
                
        } 
        $ecrLink = '<a href="score.html?teamIDX='.$eIDX.'&source=16" target="_blank">'.$team.'</a>';
        $ecrLink_small = '<a class="w3-text-white" style="text-decoration: none;" href="score.html?teamIDX='.$eIDX.'&source=16" target="_blank">'.$team.'</a>';
        # $drawingLink = '<a href="view.php?doc='.$PAPER{$teamIDX}{3}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{3}{TX_PAPER}.'</a>';
        $drawingLink = '<a href="read.html?fileID='.$PAPER{$teamIDX}{3}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{3}{TX_PAPER}.'</a>';
        $str .= '<tr class="w3-hide-small">';
        $str .= '<td nowrap ><div style="height: 18px; overflow: hidden">'.$ecrLink.'</div></td>';
        $str .= '<td nowrap >'.$drawingLink.'</td>';
        $str .= sprintf '<td class="TD_ECR_LIST_%d">', $teamIDX;
        $str .= '<a class="w3-button w3-padding-small w3-round" style="border: 1px dashed #ccc;"  href="javascript:void(0)" onclick="sae_openECREntryForm(99,'.$teamIDX.')">+</a>&nbsp;&nbsp;';
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            $str .= &_templateEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}, 99);
        }
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td style="padding: 0; border: none;">';
        $str .= '<div class="w3-border w3-round w3-margin-bottom w3-card-2">';
        $str .= '<header class="w3-blue-grey" style="padding: 1px 10px;">';
        $str .= sprintf '<h4>%s</h4>', $team;
        $str .= '</header>';
        $str .= '<div class="w3-padding w3-bar">';
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<span class="w3-large"><i class="fa fa-download fa-2x" aria-hidden="true"></i> %s</span>', $drawingLink;
        $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="sae_openECREntryForm(%d, %d)">+ ECR</button><br>', 99,$teamIDX;
        $str .= sprintf '<DIV class=" w3-margin-top TD_ECR_LIST_%d">', $teamIDX;
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            $str .= &_templateEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}, 99);
        }
        $str .= '</DIV>';
        $str .= '</div>';
        $str .= '</div>';
        $str .= '</div>';
        $str .= '</div>';
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
    }
sub sae_showUpdateInspectionStatus(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $Ref = new SAE::REFERENCE();
    my $Ecr = new SAE::ECR();
    %TEAMS = %{$Ref->_getTeamData( $teamIDX )};
    my $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
    if ($classIDX==1){
        $str .= &_showRegularClassTech($teamIDX, $divName, $TEAMS{$teamIDX}{IN_LCARGO});
    } elsif ($classIDX==2) {
        $str .= &_showAdvancedClassTech($teamIDX, $divName, $TEAMS{$teamIDX}{IN_VIDEO});
    } else {
        $str .= &_showMicoClassTech($teamIDX, $divName, $TEAMS{$teamIDX}{IN_PIPES}, $TEAMS{$teamIDX}{IN_WPIPES});
    }
    return ($str);
    }
sub _showAdvancedClassTech(){
    my $str;
    my $teamIDX = shift;
    my $divName = shift;
    my $inVideo = shift;
    $str .= '<table class="w3-table-all">';
    # $str .= '<tr>';
    $str .= '<td style="width: 45%" class="w3-small">';
    $str .= 'Advanced Class demonstrated that their aircraft has proven operational ability by providing a video showing the aircraft successfully taking off, releasing a CDA, and landing per the Section 8.1.';
    if ($inVideo==1){$checked = 'checked'} else {$checked = ''}
    $str .= '<br><input NAME="ADV_IN_VIDEO" type="checkbox" class="w3-check" value="1" '.$checked.'>&nbsp; Requirement Met';
    
    $str .= '</td>';
    # $str .= '<td><input type="number" class="w3-input w3-border" ID="REG_IN_LCARGO" placeholder="0.00" value="'.$inCargo.'"></td>';
    # $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<th class="w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-button w3-border w3-card-2 w3-margin-right w3-green" onclick="sae_submitInspectionStatus('.$teamIDX.',\'Passed\',2,\''.$divName.'\');">Passed</button>';
    $str .= '<button class="w3-margin0-left w3-button w3-border w3-card-2 w3-red" onclick="sae_submitInspectionStatus('.$teamIDX.',\'To Do\',2,\''.$divName.'\');">To Do</button>';
    $str .= '</th>';
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
    }
sub _showMicoClassTech($teamIDX, $divName){
    my $str;
    my $teamIDX = shift;
    my $divName = shift;
    my $inPipes = shift;
    my $inWPipes = shift;
    $str .= '<table class="w3-table-all">';
    $str .= '<tr>';
    $str .= '<td style="width: 45%" class="w3-large">Number of Pipes</td>';
    $str .= '<td><input type="number" class="w3-input w3-border" ID="IN_PIPES" placeholder="0.00" value="'.$inPipes.'"></td>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<tr>';
    $str .= '<td style="width: 45%" class="w3-large">Weight of all pipes</td>';
    $str .= '<td><input type="number" class="w3-input w3-border" ID="IN_WPIPES" placeholder="0.00" value="'.$inWPipes.'"></td>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<th colspan="2" class="w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-button w3-border w3-card-2 w3-margin-right w3-green" onclick="sae_submitInspectionStatus('.$teamIDX.',\'Passed\',3,\''.$divName.'\');">Passed</button>';
    $str .= '<button class="w3-margin0-left w3-button w3-border w3-card-2 w3-red" onclick="sae_submitInspectionStatus('.$teamIDX.',\'To Do\',3,\''.$divName.'\');">To Do</button>';
    $str .= '</th>';
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
    }
sub _showRegularClassTech(){
    my $str;
    my $teamIDX = shift;
    my $divName = shift;
    my $inCargo = shift;
    $str .= '<table class="w3-table-all">';
    $str .= '<tr>';
    $str .= '<td style="width: 45%" class="w3-large">Cargo Bay Length</td>';
    $str .= '<td><input type="number" class="w3-input w3-border" ID="REG_IN_LCARGO" placeholder="0.00" value="'.$inCargo.'"></td>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<th colspan="2" class="w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-button w3-border w3-card-2 w3-margin-right w3-green" onclick="sae_submitInspectionStatus('.$teamIDX.',\'Passed\',1,\''.$divName.'\');">Passed</button>';
    $str .= '<button class="w3-margin0-left w3-button w3-border w3-card-2 w3-red" onclick="sae_submitInspectionStatus('.$teamIDX.',\'To Do\',1,\''.$divName.'\');">To Do</button>';
    $str .= '</th>';
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
    }
sub sae_showImportTechSchedule(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<div>';
    $str .= '<form class="w3-card-2 w3-round-large w3-padding w3-panel" method="post" action="javascript:sae_importTechScheduleFile(\''.$divName.'\');" enctype="multipart/form-data">';
    $str .= '<input class="w3-file" type="file" name="csvFile" ID="csvFile" >';
    $str .= '<br><br>';
    $str .= '<input class="w3-margin-top w3-button w3-border w3-card-4 w3-round" type="submit" value="Import...">';
    $str .= '</form>';
    $str .= '<div ID="sae_results">';
    $str .= '</div>';
    $str .= '</div>';
    return($str);
    }
sub sae_importTechScheduleFile(){
    print $q->header();
    # my $Auth = new SAE::Auth();
    my $Ref = new SAE::REFERENCE();
    my $uploadDirectory = "/home/saestars/public_html/dev2/uploads";
    my $csv = Text::CSV->new( { sep_char => ",", binary => 1 , eol=> "\n", allow_loose_quotes => 1} ) or die "Cannot use CSV: ".Text::CSV->error_diag ();
    my $fileName = $q->param('csvFile');
    my $location = $q->param('location');
    my $file_handle = $q->upload('csvFile');   
    %TEAMS = %{$Ref->_getTeamDataLocation($location)};
    my $str;
    $str = "$uploadDirectory/$fileName";
    open ( UPLOADFILE, ">$uploadDirectory/$fileName" ) or die "$!"; binmode UPLOADFILE;
    while ( <$file_handle> ){
        print UPLOADFILE;
    }
    close UPLOADFILE;
    open $fh, '<', "$uploadDirectory/$fileName" or die "can't open csv ($uploadDirectory/$fileName) $!";
    my %DATA;
    my $counter=1;
    while ( my $row = $csv->getline( $fh ) ){
        $DATA{$counter}{IN_NUMBER}       = @$row[0];
        $teamIDX = $TEAMS{@$row[0]}{PK_TEAM_IDX};
        $DATA{$counter}{FK_TEAM_IDX}     = $teamIDX;
        $DATA{$counter}{TX_TIME}         = @$row[1];
        $DATA{$counter}{TX_ROOM}         = @$row[2];
        $counter++;
    }
    close $fh;
    unlink "$uploadDirectory/$fileName";
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    for ($i=2; $i<=scalar(keys %DATA); $i++){
        my $teamIDX = $DATA{$i}{FK_TEAM_IDX}; 
        my $toDoRoom = $DATA{$i}{TX_ROOM}; 
        my $toDoTime = $DATA{$i}{TX_TIME}; 
        if (!exists($ROOMS{$toDoRoom})) {
            $Preso->_addRoomTo_TODO_ROOM($toDoRoom, $location);
        }
        $Preso->_deleteSchedule(2, $teamIDX, $location);
        $todoIDX = $Preso->_setSchedule(2, $teamIDX, $location, $toDoRoom, $toDoTime);
    }
    return ($str)
    }
sub sae_updateInspectionStatus(){
    print $q->header();
    my $location = $q->param('location');
    my $status = $q->param('status');
    my $teamIDX = $q->param('teamIDX');
    my $inCargo = $q->param('inCargo');
    my $classIDX = $q->param('classIDX');
    my $inPipes = $q->param('inPipes');
    my $inWPipes = $q->param('inWPipes');
    my $inVideo = $q->param('inVideo');
    my $Ecr = new SAE::ECR();
    my $Preso = new SAE::PRESO();
    if ($classIDX==1){
        $Ecr->_updateCargoLength($teamIDX, $inCargo );
    } elsif ($classIDX==3) {
        $Ecr->_updateMicroPipes($teamIDX, $inPipes, $inWPipes );
    } else {
        $Ecr->_updateVideoDemo($teamIDX, $inVideo );
    }
    $Preso->_updatePresoToDo($teamIDX, $location, 2, $status);
    my $str;
    return ($str);
    }
# ==============================================================================
#   CRASH - REINSPECTION
# ==============================================================================

sub sae_openReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $Team = new SAE::TEAM($teamIDX);
    my $Flight = new SAE::FLIGHT();
    my $Ref = new SAE::REFERENCE();
    my $Airboss = new SAE::AIRBOSS();
    my %TEAM = %{$Team->_getTeamData()};
    my %NOTES = %{$Airboss->_getFlightNotes($teamIDX)};
    my %CRASH = %{$Flight->_getCrashInspectionItems($flightIDX)};
    my $str = '<div class="w3-container w3-padding">';
    $str .= sprintf '<div class="w3-container w3-large">';
    $str .= sprintf '<h3>Team #: %03d</h3>', $TEAM{IN_NUMBER};
    $str .= sprintf '<h6>The following items needs to be re-inspected</h6>';
    $str .= '<div class="w3-row w3-border-bottom w3-round">';
    foreach $crashIDX (sort {$CRASH{$a}{TX_ITEM} cmp $CRASH{$b}{TX_ITEM}} keys  %CRASH){
        $str .= sprintf '<div class="w3-mobile w3-half w3-padding w3-margin-right w3-border w3-margin-bottom w3-round  w3-hover-pale-yellow"><i class="fa fa-wrench" aria-hidden="true"></i> %s</div>', $CRASH{$crashIDX}{TX_ITEM};
    }
    $str .= '</div>';  
    $str .= '<label class="w3-margin-top">Crash Notes:</label><br>';
    $str .= sprintf '<p>%s</p>', $Flight->_getCrashNotes($flightIDX);

    $str .= '<div class="w3-container w3-center">';
    $str .= sprintf '<button class="w3-button w3-green w3-round w3-margin-right w3-margin-top w3-mobile" onclick="sae_clearReinspectionDetails(this, %d, %d, %d, %d);">Pass</button>&nbsp;', $teamIDX, $flightIDX, $todoIDX, 1;
    $str .= sprintf '<button class="w3-button w3-red w3-round w3-margin-top w3-mobile" onclick="sae_clearReinspectionDetails(this, %d, %d, %d, %d);">Failed</button>&nbsp;', $teamIDX, $flightIDX, $todoIDX, 0;
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<b class="w3-margin-left"><a href="javascript:void(0);" onclick="sae_expandNotes();">View Note History</a></b>';
    foreach $notesIDX  (sort {$b<=>$a} keys %NOTES) {
        if ($NOTES{$notesIDX}{FK_FLIGHT_IDX}) {
            $str .= sprintf '<p class="w3-border-bottom w3-small crash-notes" style="padding: 10px; display: none;"><b class="w3-text-blue">Judge\'s Notes:</b><br>%s</p>', $NOTES{$notesIDX}{CL_NOTES};
        } else {
            $str .= sprintf '<p class="w3-border-bottom w3-small crash-notes" style="padding: 10px; display: none;"><b class="w3-text-green">Flight-Line Notes:</b><br>%s</p>', $NOTES{$notesIDX}{CL_NOTES};
        }
    }
    $str .= '</div>';
    $str .= '</div>';
    return($str);
    }
sub sae_clearReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $inStatus = $q->param('inStatus');
    my $Flight = new SAE::FLIGHT($flightIDX);
    my $Tech = new SAE::TECH();
    my %FLIGHT = %{$Flight->_getFlightData()};
    my $logBtn = $Flight->_templateReinspectionButton($flightIDX, $teamIDX, $FLIGHT{IN_ROUND, $inStatus});
    if ($inStatus==1) {
        $logBtn = $Flight->_tempCheckOutButton($teamIDX);
    }
    my $techBtn = $Tech->_generateTechButton($todoIDX, $flightIDX, $teamIDX, $inStatus);
    $Flight->_updateReinspectionItems( $teamIDX, $flightIDX, $inStatus, $logBtn );
    my %DATA;
    $DATA{logBtn} = $logBtn;
    $DATA{techBtn} = $techBtn;
    $DATA{idx} = $teamIDX;
    $DATA{flightIDX} = $flightIDX;
    my $json = encode_json \%DATA;
    # return ($str);
    }
sub sae_failedReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $Flight = new SAE::FLIGHT();
    my $btn = $Flight->_templateReinspectionButton($flightIDX, $teamIDX);
    $Flight->_updateReinspectionItemsFailed( $teamIDX, $flightIDX, $btn );
    return ($str);
    }
sub _templateReinspectionButton(){
    my $flightIDX = shift;
    my $teamIDX = shift;
    my $Teams = new SAE::TB_TEAM();
       $Teams->getRecordById($teamIDX);
    my $number = $Teams->getInNumber();
    my $classIDX = $Teams->getFkClassIdx();
    # my $classIDX = shift;
    my $txNumber = sprintf '%03d', $number;
    my $str;
    $str = sprintf '<button class="w3-button w3-border w3-round w3-orange w3-hover-yellow" style="margin-top: 5px;" onclick="sae_openClearCrash(%d, \'%s\', %d, %d);"><i class="fa fa-exclamation-triangle w3-margin-right" aria-hidden="true"></i>#%s<i class="fa fa-exclamation-triangle w3-margin-left" aria-hidden="true"></i></button>', $teamIDX, $number, $classIDX, $flightIDX, $txNumber.': Re-Inspection Required';
    return ($str);
    }








### ---------- END ---------------