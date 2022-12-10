#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;

#====== SAE MODULES ==========================================================================
use SAE::SDB;
use SAE::Common;
use SAE::REFERENCE;
use SAE::ECR;

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
#================================================================================
sub sae_openECR(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    %ECRS = %{$Ecr->_getTeamsERCS( $userIDX, $location )};
    
    my $str;
    $str .= '<div class="w3-container w3-padding w3-margin-top" >';
    $str .= '<h3>Online Engineering Change Request (ECR)</h3>';
    $str .= '<table ID="TABLE_ECR_LIST" class="w3-table-all w3-small w3-border">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th colspan="6" class="w3-padding-small">';
    $str .= '<button class="w3-button w3-round w3-card-2 w3-border" onclick="sae_openECREntryForm('.$userIDX.',0);">Add ECR</button>';
    $str .= '</th>';
    $str .= '</tr>';
    $str .= '<tr class="w3-light-grey w3-hide-small">';
    $str .= '<th style="width: 5%;">ECR#</th>';
    $str .= '<th style="width: 25%;">Team</th>';
    $str .= '<th style="width: 40%;">Title</th>';
    $str .= '<th style="width: 10%;">Status</th>';
    $str .= '<th style="width: 10%;">Deductions</th>';
    $str .= '<th style="width: 10%;">Date Submitted</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    foreach $ecrIDX (sort {$a <=> $b} keys %ECRS){
        $teamName = substr("000".$ECRS{$ecrIDX}{IN_NUMBER},-3,3)." - ".$ECRS{$ecrIDX}{TX_SCHOOL};
        $ecrTitle = $ECRS{$ecrIDX}{TX_ECR};
        $ecrStatus = $ECRS{$ecrIDX}{IN_STATUS};
        $ecrPoints = $ECRS{$ecrIDX}{IN_DEDUCTION};
        $ecrCreate = $ECRS{$ecrIDX}{TS_CREATED};
        $str .= &_tempEcrRow($ecrIDX, $teamName, $ecrTitle, $ecrStatus, $ecrPoints, $ecrCreate);
    }
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
}
sub sae_openECREntryForm(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    if ($teamIDX>0){
        %TEAMS = %{$Ecr->_getTeamDataById( $teamIDX )};
    } else {
        %TEAMS = %{$Ecr->_getMyTeams( $userIDX, $location )};
    }
    
    @METHODS = ('Tech Inspection','Safety Inspection','Test Flight','Design Analysis');
    @SYSTEMS = ('Wing','Fuselage','Hor/Ver. Tail','Engine Support/Assembly','Landing Systems','Cargo Bay');
    my $str;
    # $str .= '<div class="w3-container" >';
    $str .= '<div class="w3-container w3-padding-small">';
    $str .= '<div class="w3-container" style="height: 600px; overflow: auto">';
    $str .= '<table class="w3-table w3-bordered w3-white">';
    $str .= '<tr><td colspan="3" class=" w3-padding-small" >';
    $str .= '<label class="w3-small" sae-select>Team:</label>';
    $str .= '<select class="w3-input w3-small " ID="selectTeamIDX">';
    if ($teamIDX == 0){
        $str .= '<option value="0"> - Select Team -</option>';
    }
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        my $teamName = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<option value="'.$teamIDX.'">'.$teamName.'</option>';
    }
    $str .= '</select>';
    $str .= '</td></tr>';

    $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Title:</label>';
    $str .= '<input type="text" class="sae-input w3-input w3-small w3-padding-small" data-key="TX_ECR">';
    $str .= '</td></tr>';

    $str .= '<tr><td class=" w3-padding-small">';
    $str .= '<label class="w3-small">How was this change discovered? (select all that\'s applicable)</label><br>';
    foreach $method (@METHODS){
        $str .= '<input type="checkbox" class="sae-check-method w3-check" value="'.$method.'"><label class="w3-small">'.$method.'</label><br>';
    }
    $str .= '</td>';

    $str .= '<td colspan="2" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Which systems were impacted by this change? (select all that\'s applicable)</label><br>';
    foreach $system (@SYSTEMS){
        $str .= '<input type="checkbox" class="sae-check-system w3-check" value="'.$system.'"> <label class="w3-small">'.$system.'</label><br>';
    }
    $str .= '</td></tr>';
    $str .= '<tr><td class=" w3-padding-small">';
    $str .= '<label class="w3-small">Change in Surface Area(in.<sup>2</sup>):</label>';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Original Area</label> <input type="text" class="sae-input w3-small" data-key="IN_AREA_OLD" style="width: 50px;"> in.<sup>2</sup>';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">New Area</label> <input type="text" class="sae-input w3-small" data-key="IN_AREA_NEW" style="width: 50px;"> in.<sup>2</sup>';
    $str .= '</td>';
    $str .= '</tr>';
    $str .= '<tr><td class=" w3-padding-small">';
    $str .= '<label class="w3-small">Change in Length (in.)</label>';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Original Length</label> <input type="text" class="sae-input w3-small" data-key="IN_LENGTH_OLD" style="width: 50px;"> in.';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">New Length</label> <input type="text" class="sae-input w3-small" data-key="IN_LENGTH_NEW" style="width: 50px;"> in.';
    $str .= '</td>';
    $str .= '</tr>';

    $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Detailed description of the change/modification</label><br>';
    $str .= '<textarea ID="clDescription" data-key="CL_DESCRIPTION" style="height: 50px" class="sae-input w3-input w3-small w3-border w3-padding-small  sae-text" style="min-width: 100%;"></textarea>';
    $str .= '</td></tr>';

    $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Why was this change/modification needed</label><br>';
    $str .= '<textarea ID="clReason" style="height: 50px" data-key="CL_REASON"  class="sae-input w3-input w3-small w3-border w3-padding-small  sae-text" style="min-width: 100%;"></textarea>';
    $str .= '</td></tr>';
    if ($teamIDX>0){
        $str .= &_tempEcrRow_Judge(0);
    }
    $str .= '<tr><td colspan="3" class="w3-display-container" style="text-align: center">';
    if ($teamIDX>0){
        $str .= '<button class="w3-button w3-round w3-border w3-green" onclick="sae_submitECR(\''.$divName.'\', 1);">Apply</button>';
    } else {
        $str .= '<button class="w3-button w3-round w3-border w3-green" onclick="sae_submitECR(\''.$divName.'\', 0);">Submit</button>';
    }
    
    $str .= '<button class="w3-margin-left w3-button w3-round w3-border w3-hover-red" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</td></tr>';

    $str .= '</table>';
    # $str .= '<br><br>';
    $str .= '</div>';
    $str .= '</div>';
    
    return ($str);
}
sub sae_editEcr(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $Util = new SAE::Common();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $divName = $q->param('divName');
    my $ecrIDX = $q->param('ecrIDX');
    my $judge = $q->param('judge');

    my $disabled = '';
    if ($judge==1){$disabled = "disabled"}

    %ECR = %{$Ecr->_getECRByID($ecrIDX)};
    %TEAMS = %{$Ecr->_getMyTeams( $userIDX , $location )};
    @METHODS = ('Tech Inspection','Safety Inspection','Test Flight','Design Analysis');
    @SYSTEMS = ('Wing','Fuselage','Hor/Ver. Tail','Engine Support/Assembly','Landing Systems','Cargo Bay');
    my $str;
    # $str .= '<div class="w3-container" >';
    $str .= '<div class="w3-container w3-padding-small">';
    $str .= '<div class="w3-container" style="height: 600px; overflow: auto">';
    $str .= '<table class="w3-table w3-bordered w3-white">';
    $str .= '<tr><td colspan="3" >';
    $str .= '<label class="w3-small" sae-select>Team:</label>';
    $str .= '<select class="w3-input w3-small " '.$disabled.' ID="selectTeamIDX">';
    $str .= '<option value="0"> - Select Team -</option>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        my $teamName = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        $selected = '';
        if ($teamIDX == $ECR{$ecrIDX}{FK_TEAM_IDX}){$selected = "selected"}
        $str .= '<option value="'.$teamIDX.'" '.$selected.'>'.$teamName.' ('.$teamIDX .')</option>';
    }
    $str .= '</select>';
    $str .= '</td></tr>';

    $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Title:</label>';
    $str .= '<input type="text" class="sae-input w3-input w3-small w3-padding-small " '.$disabled.' data-key="TX_ECR" value="'.$ECR{$ecrIDX}{TX_ECR}.'">';
    $str .= '</td></tr>';

    $str .= '<tr><td class=" w3-padding-small">';
    $str .= '<label class="w3-small">How was this change discovered? (select all that\'s applicable)</label><br>';
    @meth = split(",",$ECR{$ecrIDX}{TX_METHOD});
    %METH = map { $_ => 1 } @meth;
    foreach $method (@METHODS){
        $checked = '';
        if (exists $METH{$method}){$checked = 'Checked';}
        $str .= '<input type="checkbox" '.$checked.' class="sae-check-method  " '.$disabled.' style="margin: 0px 7px!important; " value="'.$method.'"> <label class="w3-small">'.$method.'</label><br>';
    }
    $str .= '</td>';

    $str .= '<td colspan="2" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Which systems were impacted by this change? (select all that\'s applicable)</label><br>';
    @sys = split(",",$ECR{$ecrIDX}{TX_SYSTEM});
    %SYS = map { $_ => 1 } @sys;
    foreach $system (@SYSTEMS){
        $checked = '';
        if (exists $SYS{$system}){$checked = 'Checked';}
        $str .= '<input type="checkbox" '.$checked.' class="sae-check-system  " '.$disabled.' style="margin: 0px 7px!important; " value="'.$system.'"> <label class="w3-small">'.$system.'</label><br>';
    }
    $str .= '</td></tr>';
    $str .= '<tr><td class=" w3-padding-small">';
    $str .= '<label class="w3-small">Change in Surface Area(in.<sup>2</sup>):</label>';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Original Area</label> <input type="text" class="sae-input w3-small "' .$disabled.' data-key="IN_AREA_OLD" style="width: 50px;" value="'.$ECR{$ecrIDX}{IN_AREA_OLD}.'"> in.<sup>2</sup>';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">New Area</label> <input type="text" class="sae-input w3-small " '.$disabled.' data-key="IN_AREA_NEW" style="width: 50px;" value="'.$ECR{$ecrIDX}{IN_AREA_NEW}.'"> in.<sup>2</sup>';
    $str .= '</td>';
    $str .= '</tr>';
    $str .= '<tr><td class=" w3-padding-small">';
    $str .= '<label class="w3-small">Change in Length (in.)</label>';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Original Length</label> <input type="text" class="sae-input w3-small " '.$disabled.' data-key="IN_LENGTH_OLD" style="width: 50px;" value="'.$ECR{$ecrIDX}{IN_LENGTH_OLD}.'"> in.';
    $str .= '</td>';
    $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    $str .= '<label class="w3-small">New Length</label> <input type="text" class="sae-input w3-small " '.$disabled.' data-key="IN_LENGTH_NEW" style="width: 50px;" value="'.$ECR{$ecrIDX}{IN_LENGTH_NEW}.'"> in.';
    $str .= '</td>';
    $str .= '</tr>';
    $clDescription = $Util->removeBr($ECR{$ecrIDX}{CL_DESCRIPTION});
    $clReason = $Util->removeBr($ECR{$ecrIDX}{CL_REASON});
    $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Detailed description of the change/modification</label><br>';
    $str .= '<textarea ID="clDescription" data-key="CL_DESCRIPTION"  style="height: 50px" class="sae-input w3-input w3-small w3-border w3-padding-small  sae-text " '.$disabled.' style="min-width: 100%;">'.$clDescription.'</textarea>';
    $str .= '</td></tr>';

    $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    $str .= '<label class="w3-small">Why was this change/modification needed</label><br>';
    $str .= '<textarea ID="clReason" style="height: 50px" data-key="CL_REASON"  class="sae-input w3-input w3-small w3-border w3-padding-small  sae-text " '.$disabled.' style="min-width: 100%;">'. $clReason .'</textarea>';
    $str .= '</td></tr>';
    if ($judge ==1){
        $str .= &_tempEcrRow_Judge($ECR{$ecrIDX}{IN_DEDUCTION});
    }
    $str .= '<tr><td colspan="3" class="w3-display-container" style="text-align: center">';
    if($judge>0){  
        $str .= '<button class="w3-button w3-round w3-border w3-green" onclick="sae_submitECR_Apply('.$ecrIDX.',\''.$divName.'\', 1);">Apply Deductions</button>';
    } else {
        $str .= '<button class="w3-button w3-round w3-border w3-green" onclick="sae_submitECR_Update('.$ecrIDX.',\''.$divName.'\', 0);">Submit Updates</button>';
    }
    
    $str .= '<button class="w3-margin-left w3-button w3-round w3-border w3-orange w3-hover-red" onclick="sae_deleteERC('.$ecrIDX.',\''.$divName.'\');">Delete</button>';
    $str .= '<button class="w3-margin-left w3-button w3-round w3-border w3-hover-red" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</td></tr>';

    $str .= '</table>';
    # $str .= '<br><br>';
    $str .= '</div>';
    $str .= '</div>';
    
    return ($str);
}
sub sae_deleteERC(){
    print $q->header();
    my $ecrIDX = $q->param('ecrIDX');
    my $Ecr = new SAE::ECR();
    $Ecr->_deleteERC($ecrIDX);
}
sub sae_submitECR_Update(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    # my $userIDX = $q->param('userIDX');
    my $teamName = $q->param('teamName');
    my $ecrIDX = $q->param('ecrIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $results= $Ecr->_submitECR_Update($ecrIDX , \%DATA);
    %STATUS = (0=>"Pending Review", 1=>"Applied");

    # my $str = &_tempEcrRow($ecrIDX, $teamName, $DATA{TX_ECR}, 'Pending Review', '0.00');
    return ();
}
sub sae_submitECR_Apply(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    my $inDeduction = $q->param('inDeduction');
    my $ecrIDX = $q->param('ecrIDX');
    my %DATA = ('IN_DEDUCTION'=>$inDeduction, 'IN_STATUS'=>1);
    my $results= $Ecr->_submitECR_Update($ecrIDX , \%DATA);
    %STATUS = (0=>"Pending Review", 1=>"Applied");

    # my $str = &_tempEcrRow($ecrIDX, $teamName, $DATA{TX_ECR}, 'Pending Review', '0.00');
    return ();
}
sub sae_submitECR(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $teamName = $q->param('teamName');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $ecrIDX = $Ecr->_submitECR($userIDX , \%DATA);
    %STATUS = (0=>"Pending Review", 1=>"Closed");
    my $str = &_tempEcrRow($ecrIDX, $teamName, $DATA{TX_ECR}, 0, 0);
    return ($str);
}
sub _tempEcrRow(){
    my ($ecrIDX, $teamName, $ecrTitle, $ecrStatus, $ecrPoints, $ecrCreate) = @_;
    my $str;
    %STATUS = (0=>"Pending Review", 1=>"Applied");
    if ( $ecrStatus  > 0 ) {
        $str .= '<tr class="w3-pale-red w3-hide-small" ID="TR_ECR_'.$ecrIDX.'">';
    } else {
        $str .= '<tr ID="TR_ECR_'.$ecrIDX.'" class="w3-hide-small">';
    }
    
    if ($ecrStatus  > 0 ) {
        $str .= '<td nowrap>E-'.substr("000000".$ecrIDX,-6,6).'</td>';
    } else {
        $str .= '<td nowrap><a href="javascript:void(0);" onclick="sae_editEcr('.$ecrIDX.',0);">'."E-".substr("000000".$ecrIDX,-4,4).'</a></td>';
    }
    $str .= '<td>'.$teamName.'</td>';
    $str .= '<td>'.$ecrTitle.'</td>';
    if ($ecrStatus  > 0 ) {
        $str .= '<td nowrap><i class="fa fa-check-square-o"></i> '.$STATUS{$ecrStatus}.'</td>';
    } else {
        $str .= '<td nowrap>'.$STATUS{$ecrStatus}.'</td>';
    }
    if($ecrPoints>0){
        $str .= sprintf '<td class="w3-text-red" style="text-align: right;">-%2.2f</td>', $ecrPoints;
    } else {
        $str .= sprintf '<td class="w3-text-red" style="text-align: right;">%2.2f</td>', $ecrPoints;
    }
    $str .= '<td>'.$ecrCreate.'</td>';
    $str .= '</tr>';
    $str .= '<tr></tr>';
    $str .= '<tr class="w3-hide-medium w3-hide-large">';
    
    $str .= '<td style="padding: 0;">';
    
    # $str .= 'ECR #: ';
    if ($ecrStatus  > 0 ) {
        $ecrLink = 'E-'.substr("000000".$ecrIDX,-6,6).'<br>';
        $w3color = 'w3-pale-red ';
    } else {
        $ecrLink = '<a class="w3-text-white" href="javascript:void(0);" onclick="sae_editEcr('.$ecrIDX.',0);">'."E-".substr("000000".$ecrIDX,-6,6).'</a><br>';
        $w3color = ' w3-blue-grey ';
    }
    $str .= '<div>';
    $str .= '<header class='.$w3color.' w3-padding-small"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><h4 style="padding: 2px 7px; margin: 0">ECR #: '.$ecrLink .'</h4></header>';
    $str .= '<div class="w3-padding">';
    $str .= sprintf '<b>Team: </b> <span>%s</span><br>', $teamName;
    $str .= sprintf '<b>ECR Title: </b> <span>%s</span><br>', $ecrTitle;
    $str .= '<i class="fa fa-check-square-o"></i> '.$STATUS{$ecrStatus}.'<br>';
    if ($ecrStatus  > 0 ) {
        $str .= sprintf '<b>Deduction: </b> <span class="w3-text-red">- %2.2f</span><br>', $ecrPoints;
    } else {
        $str .= sprintf '<b>Deduction: </b> <span class="w3-text-red">%2.2f</span><br>', $ecrPoints;
    }
    $str .= sprintf '<b>ECR Created: </b> <span>%s</span><br>', $ecrCreate;
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</td>';
    
    $str .= '</tr>';
}
sub _tempEcrRow_Judge(){
    my $inDeduction = shift;
    my $str;
    $str = '<tr class="w3-hide-small"><td colspan="3" class=" w3-padding-small w3-grey">';
    $str .= '<label class="w3-small">Official Use Only<br>';
    $str .= 'These charts provide guidelines to possible assessment of penalty points for different design changes. Final assessment of penalty points is subject to the judges\' determination.</label><br>';
    $str .= '</td></tr>';

    $str .= '<tr class="w3-hide-small"><td class="w3-padding-tiny w3-grey">';
    $str .= '<label class="w3-tiny">Penalties guidelies for for wing surface changes<br>';
    $str .= &_tempECRWing();
    $str .= '<label class="w3-small">Deductions: </label>';
    $str .= '<input type="text" ID="IN_DEDUCTION" data-key="IN_DEDUCTION" class="sae-input w3-input w3-small w3-border w3-padding-small w3-card-4" style="width: 100px;" value="'.$inDeduction.'">';
    $str .= '</td>';
    $str .= '<td colspan="2" class="w3-hide-small w3-padding-tiny w3-grey">';
    $str .= '<label class="w3-tiny">Penalty guidelines by category and size of change<br>';
    $str .= &_tempECRCategory();
    $str .= '</td></tr>';
    $str .= '<tr class="w3-hide-medium w3-hide-large w3-grey" >';
    $str .= '<td colspan="3">';
    $str .= '<label class="w3-small">Official Use Only<br>';
    $str .= 'These charts provide guidelines to possible assessment of penalty points for different design changes. Final assessment of penalty points is subject to the judges\' determination.</label><br>';
    $str .= '<label class="w3-tiny">Penalties guidelies for for wing surface changes<br>';
    $str .= &_tempECRWing();
    $str .= '<label class="w3-tiny">Penalty guidelines by category and size of change<br>';
    $str .= &_tempECRCategory();
    $str .= '<label class="w3-small">Deductions: </label>';
    $str .= '<input type="text" ID="IN_DEDUCTION" data-key="IN_DEDUCTION" class="sae-input w3-input w3-small w3-border w3-padding-small w3-card-4" style="width: 100px;" value="'.$inDeduction.'">';
    $str .= '</td>';
    
    $str .= '</tr>';


    return ($str);
}
sub _tempECRWing(){
    my $str;
    $str = '<table class="w3-tiny w3-table-all w3-padding-small">';
    $str .= '<tr>';
    $str .= '<td>Demension</td>';
    $str .= '<td>Added</td>';
    $str .= '<td>Removed</td>';
    $str .= '</tr>';

    $str .= '<tr>';
    $str .= '<td>Span</td>';
    $str .= '<td>2pts per inch</td>';
    $str .= '<td>1pts per inch</td>';
    $str .= '</tr>';
    
    $str .= '<tr>';
    $str .= '<td>Chord</td>';
    $str .= '<td>10pts per inch</td>';
    $str .= '<td>5pts per inch</td>';
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
}
sub _tempECRCategory(){
    my $str;
    $str = '<table class="w3-tiny w3-table-all w3-padding-small">';
    $str .= '<tr>';
    $str .= '<td>Type</td>';
    $str .= '<td>Small</td>';
    $str .= '<td>Medium</td>';
    $str .= '<td>Large</td>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Structural</td>';
    $str .= '<td>2pts</td>';
    $str .= '<td>4pts</td>';
    $str .= '<td>6pts</td>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Mechanical</td>';
    $str .= '<td>2pts</td>';
    $str .= '<td>4pts</td>';
    $str .= '<td>6pts</td>';

    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Electronics</td>';
    $str .= '<td>1pts</td>';
    $str .= '<td>2pts</td>';
    $str .= '<td>3pts</td>';

    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Miscellaneous</td>';
    $str .= '<td>1pts</td>';
    $str .= '<td>3pts</td>';
    $str .= '<td>5pts</td>';
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
}