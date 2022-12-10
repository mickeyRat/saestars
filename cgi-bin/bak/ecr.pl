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
use SAE::TB_ECR;
use SAE::TB_ECR_TYPE;
use SAE::TB_TEAM;

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
sub sae_ApplyDeductions(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $Team = new SAE::TB_TEAM();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $userType = $q->param('userType');
    my $teamIDX = $q->param('teamIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $ecrIDX = $Ecr->_submitECR($userIDX , \%DATA);
    my %STATUS = (0=>"Pending Review", 1=>"Closed");
    my %TEAM = $Team->getRecordById($teamIDX);
    # my $str = &_tempEcrRow($ecrIDX, $teamName, $DATA{TX_ECR}, 0, 0);
    if ($userType == 99){
       $str = &_templateEcrCard($ecrIDX, $teamIDX, $DATA{IN_DEDUCTION}, 1, 99);
    } else {
       $str = &_templateStudentEcrCard($ecrIDX, $teamIDX, $DATA{IN_DEDUCTION}, 0, 0);
    }
    
    return ($str);
}
sub sae_UpdateDeductions(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $userType = $q->param('userType');
    my $ecrIDX = $q->param('ecrIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $results= $Ecr->_submitECR_Update($ecrIDX , \%DATA);
    my $str;
    if ($userType == 99){
       $str = &_templateEcrCard($ecrIDX, $teamIDX, $DATA{IN_DEDUCTION}, 1, 99);
    } else {
       $str = &_templateStudentEcrCard($ecrIDX, $teamIDX, $DATA{IN_DEDUCTION}, 1, 0);
    }
    return ($str);
}
sub _templateEcrCard(){
    my ($ecrIDX, $teamIDX, $inValue, $inStatus) = @_;
    if ($inStatus >0){
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-red" onclick="sae_openExitingECR(%d, %d, %d);">-%2.2f</button>', $ecrIDX, $ecrIDX, $teamIDX, 99, $inValue;
    } else {
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-yellow" onclick="sae_openExitingECR(%d, %d, %d);">E-000%d: Pending Review</button>', $ecrIDX, $ecrIDX, $teamIDX, 99, $ecrIDX;
    }
    return ($str);
}
sub _templateStudentEcrCard(){
    my ($ecrIDX, $teamIDX, $inValue, $inStatus) = @_;
    if ($inStatus >0){
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-red" onclick="sae_openStudentExitingECR(%d, %d, %d);">-%2.2f</button>', $ecrIDX, $ecrIDX, $teamIDX, $inStatus, $inValue;
    } else {
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-yellow" onclick="sae_openStudentExitingECR(%d, %d, %d);">E-000%d: Pending Review</button>', $ecrIDX, $ecrIDX, $teamIDX, $inStatus, $ecrIDX;
    }
    return ($str);
}
sub sae_RemoveDeductions(){
    print $q->header();
    my $ecrIDX = $q->param('ecrIDX');
    my $Ecr = new SAE::ECR();
    $Ecr->_deleteERC($ecrIDX);
}
#================================================================================
sub sae_openECR(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my %TEAMS = %{$Ecr->_getMyTeams( $userIDX, $location )};
    my %ECRS  = %{$Ecr->_getECRByEventID($location)};
    my $str;
    $str = '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<h3 class="w3-margin-top">Online Engineering Change Request (ECR)</h3>';
    $str .= '<table class="w3-table-all w3-small" >';
    $str .= '<thead>';
    $str .= '<tr class="w3-light-grey w3-hide-small">';
    $str .= '<th style="width: 25%"># - School</th>';
    $str .= '<th style="width: 75%">Engineering Change Requests (ECRs)';
    $str .= '</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $txTeam = sprintf '%03d - %s', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td>%s</td>', $txTeam;
        $str .= sprintf '<td class="TD_ECR_LIST_%d">', $teamIDX;
        $str .= '<a class="w3-button w3-padding-small w3-round w3-margin-right" style="border: 1px dashed #ccc;"  href="javascript:void(0)" onclick="sae_openECREntryForm(0,'.$teamIDX.');">+</a>';
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            $str .= &_templateStudentEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS});
        }
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-large w3-hide-medium">';
        $str .= '<td style="padding: 0; border: none;>';
        $str .= '<div class="w3-border w3-round w3-margin-bottom w3-card-2">';
        $str .= sprintf '<h4 class="w3-blue-grey"><span class="w3-margin-left">%s</span></h4>',$txTeam;
        $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-2 w3-margin-left" onclick="sae_openECREntryForm(%d, %d)"><i class="fa fa-plus f2-2x" aria-hidden="true"></i> Engieering Change Request</button><br>', 0, $teamIDX;
        $str .= sprintf '<div class="TD_ECR_LIST_%d w3-margin-top">', $teamIDX;
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            $str .= &_templateStudentEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS});
        }
        $str .= '</div><br>';
        $str .= '</div>';
        $str .= '</td>';
        $str .= '</tr>';
        
        
        
        
        
        
        
        # $str .= '<td style="padding: 0; border: none;">';
        # $str .= '<div class="w3-border w3-round w3-margin-bottom w3-card-2">';
        # $str .= '<header class="w3-blue-grey" style="padding: 1px 10px;">';
        # $str .= sprintf '<h4>%s</h4>', $team;
        # $str .= '</header>';
        # $str .= '<div class="w3-padding w3-bar">';
        # $str .= '<div class="w3-bar-item">';
        # $str .= sprintf '<span class="w3-large"><i class="fa fa-download fa-2x" aria-hidden="true"></i> %s</span>', $drawingLink;
        # $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="sae_openECREntryForm(%d, %d)">+ ECR</button><br>', 99,$teamIDX;
        # $str .= sprintf '<DIV class=" w3-margin-top TD_ECR_LIST_%d">', $teamIDX;
        # foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
        #     $str .= &_templateEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}, 99);
        # }
        # $str .= '</DIV>';
        # $str .= '</div>';
        # $str .= '</div>';
        # $str .= '</div>';
        # $str .= '</div>';
        # $str .= '</td>';
        
    }
    
    $str .= '</tbody>';
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
}
sub sae_openExitingECR(){
    print $q->header();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $teamIDX = $q->param('teamIDX');
    my $userType= $q->param('userType');

    my $ecrIDX= $q->param('ecrIDX');
    # Getting ECR Data
    my $Ecr = new SAE::ECR();
    my %ECR = %{$Ecr->_getECRByID($ecrIDX)};
    #Getting Team Data
    my $Team    = new SAE::TB_TEAM();
       $Team->getRecordById($teamIDX);
    
    my $EcrType = new SAE::TB_ECR_TYPE();
    my %ECR_TYPE = %{$EcrType->getAllRecord()};
    
    my $str;
    $str .= '<div class="w3-container w3-border w3-round" style="height: 615px; overflow-y: auto;">';
    $str .= sprintf '<h4 style="padding: 1px 8px">%03d - %s</h4>', $Team->getInNumber(), $Team->getTxSchool();
    $str .= sprintf '<input ID="TX_ECR" type="text" class="w3-input w3-border w3-round w3-small" placeholder="ECR Title" value="%s">', $ECR{TX_ECR};
    if ($userType==99){
        $str .= sprintf '<textarea ID="CL_DESCRIPTION" class="w3-input w3-border w3-margin-top w3-round w3-small" style="resize: vertical; height: 75px;" placeholder="Short Description">%s</textarea>', $ECR{CL_DESCRIPTION};
    } else {
        $str .= sprintf '<textarea ID="CL_DESCRIPTION" class="w3-input w3-border w3-margin-top w3-round w3-small" style="resize: vertical; height: 250px;" placeholder="Short Description">%s</textarea>', $ECR{CL_DESCRIPTION};
    }

    if ($userType == 99){
        $str .= sprintf '<table class="w3-table-all w3-hoverable w3-margin-top w3-small %d">';
        $str .= '<tr>';
        $str .= '<th>Type of Changes</th>';
        $str .= '<th style="width: 10%;">None</th>';
        $str .= '<th style="width: 10%;">Small</th>';
        $str .= '<th style="width: 10%;">Medium</th>';
        $str .= '<th style="width: 10%;">Large</th>';
        $str .= '<th style="width: 10%;">Deductions</th>';
        $str .= '</tr>';
        $str .= '<tbody>';
        foreach $ecrTypeIDX (sort {$a <=> $b} keys %ECR_TYPE) {
            # $str .= 'field='.$ECR_TYPE{$ecrTypeIDX}{TX_FIELD};
            # $str .= $ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}};
            my $checked_0 = '';
            my $checked_1 = '';
            my $checked_2 = '';
            my $checked_3 = '';
            my $inDeduction = 0;
            if ($ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}} == 0 ) {$checked_0 = 'checked'}
            if ($ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}} == $ECR_TYPE{$ecrTypeIDX}{IN_SMALL} ) {$checked_1 = 'checked'; $inDeduction=$ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}}}
            if ($ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}} == $ECR_TYPE{$ecrTypeIDX}{IN_MEDIUM} ) {$checked_2 = 'checked'; $inDeduction=$ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}}}
            if ($ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}} >= $ECR_TYPE{$ecrTypeIDX}{IN_LARGE} ) {$checked_3 = 'checked'; $inDeduction=$ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}}}
            $str .= '<tr>';
            $str .= sprintf '<td class="" style="padding: 2px 5px;">%s</td>', $ECR_TYPE{$ecrTypeIDX}{TX_TYPE};
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio" name="TYPE_%d" value="0" '.$checked_0.' onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">none</span></td>', $ecrTypeIDX, $ecrTypeIDX, ;
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio" name="TYPE_%d" value="%d" '.$checked_1.' onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">%d pts</span></td>',   $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_SMALL}, $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_SMALL};
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio" name="TYPE_%d" value="%d" '.$checked_2.' onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">%d pts</span></td>',   $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_MEDIUM}, $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_MEDIUM};
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio" name="TYPE_%d" value="%d" '.$checked_3.' onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">%d pts +</span></td>', $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_LARGE}, $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_LARGE};
            $str .= sprintf '<td style="padding: 1px;"><input type="number" class="w3-input w3-border w3-round sae-deduction-%d sae-deductions sae-type-%d" value="%2.1f" onchange="sae_updateDeduction(this, \'sae-type-%d\');"></td>', $ecrTypeIDX, $ecrTypeIDX, $inDeduction;
            $str .= '</tr>';
        }
        $str .= '<tr>';
        $str .= '<td class="" style="padding: 2px 5px;">Wing Span (ADDED/REMOVED)</td>';
        $str .= '<td style="padding: 1px 5px; text-align: right;">ADDED<br>(Inches)</td>';
        $str .= sprintf '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round"  type="number" ID="SPAN_ADD" value="%2.1f" step="0.1" min="0"    onchange="sae_updateLengthDeduction(this,\'sae-span\',\'add\');"></td>', $ECR{IN_SPAN_ADD};
        $str .= '<td style="padding: 1px 5px; text-align: right;">REMOVED<br>(Inches)</td>';
        $str .= sprintf '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round"  type="number" ID="SPAN_REMOVE" value="%2.1f" step="0.1" max="0" onchange="sae_updateLengthDeduction(this,\'sae-span\',\'remove\');"></td>', $ECR{IN_SPAN_REMOVE};
        $str .= sprintf '<td style="padding: 1px 1px;"><input ID="IN_SPAN"type="number" class="w3-input w3-border w3-round sae-span sae-deductions" value="%2.1f" onchange="sae_updateDeduction(this, \'sae-type-span\');"></td>', $ECR{IN_SPAN};
        $str .= '</tr>';
        
        $str .= '<tr>';
        $str .= '<td class="" style="padding: 2px 5px;">Wing Chord (ADDED/REMOVED)</td>';
        $str .= '<td style="padding: 1px 5px; text-align: right;">ADDED<br>(Inches)</td>';
        $str .= sprintf '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round" type="number" ID="CHORD_ADD" value="%2.1f" step="0.1" min="0"    onchange="sae_updateLengthDeduction(this,\'sae-chord\',\'add\');"></td>', $ECR{IN_CHORD_ADD};
        $str .= '<td style="padding: 1px 5px; text-align: right;">REMOVED<br>(Inches)</td>';
        $str .= sprintf '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round" type="number" ID="CHORD_REMOVE" value="%2.1f" step="0.1" max="0" onchange="sae_updateLengthDeduction(this,\'sae-chord\',\'remove\');"></td>', $ECR{IN_CHORD_REMOVE};
        $str .= sprintf '<td style="padding: 1px 1px;"><input ID="IN_CHORD"type="number" class="w3-input w3-border w3-round sae-chord sae-deductions" value="%2.1f" onchange="sae_updateDeduction(this, \'sae-type-chord\');"></td>', $ECR{IN_CHORD};
        $str .= '</tr>';
        
        $str .= '<tr>';
        $str .= '<td colspan="5" style=" text-align: right;">TOTAL DEDUCTION</td>';
        $str .= sprintf '<td class=""    style="padding: 1px 1px; text-align: right;"><input ID="TECH_TOTAL" class="w3-input w3-border w3-round w3-white w3-text-red" type="number" value="%2.1f" disabled></td>', $ECR{IN_DEDUCTION};
        $str .= '</tr>';
        $str .= '</tbody>';
        $str .= '</table>';
    } else {
        if ($ECR{IN_STATUS} == 1){
            my $totalDeduction = 0;
            $str .= sprintf '<table class="w3-table-all w3-hoverable w3-margin-top w3-small">';
            $str .= '<tr>';
            $str .= '<th>Type of Changes</th>';
            $str .= '<th style="width: 10%;">Deductions</th>', ;
            $str .= '</tr>';
            foreach $ecrTypeIDX (sort {$a <=> $b} keys %ECR_TYPE) {
                my $inDeduction = $ECR{$ECR_TYPE{$ecrTypeIDX}{TX_FIELD}};
                $str .= '<tr>';
                $str .= sprintf '<td class="" style="padding: 1px 5px;">%s</td>', $ECR_TYPE{$ecrTypeIDX}{TX_TYPE};
                $str .= sprintf '<td style="padding: 1px 10px; text-align: right">-%2.1f</td>',  $inDeduction;
                $str .= '</tr>';
                $totalDeduction += $inDeduction;
            }
            $str .= '<tr>';
            $str .= '<td class="" style="padding: 1px 5px;">SPAN Increase/Reduction</td>';
            $str .= sprintf '<td style="padding: 1px 10px; text-align: right">-%2.1f</td>', $ECR{IN_SPAN};
            $totalDeduction += $ECR{IN_SPAN};
            $str .= '</tr>';
            $str .= '<tr>';
            $str .= '<td class="" style="padding: 1px 5px;">Chord Increase/Reduction</td>';
            $str .= sprintf '<td style="padding: 1px 10px; text-align: right">-%2.1f</td>', $ECR{IN_CHORD};
            $totalDeduction += $ECR{IN_CHORD};
            $str .= '</tr>';
            $str .= '<tr class="w3-large w3-text-red">';
            $str .= '<td class="" style="padding: 1px 5px;">TOTAL DEDUCTION</td>';
            $str .= sprintf '<td style="padding: 1px 10px; text-align: right">-%2.2f</td>', $totalDeduction;
            $str .= '</tr>';
            $str .= '</table>';
        }
    }
    $str .= '<div class="w3-container w3-margin-top w3-center">';
    if ($ECR{IN_STATUS} == 0 || $userType == 99) {
        if ($userType == 99) {
            $str .= sprintf '<button class="w3-button w3-border w3-round w3-white w3-hover-red" onclick="sae_RemoveDeductions(this, %d);">Remove Deductions</button>', $ecrIDX;
            $str .= sprintf '<button class="w3-button w3-border w3-round w3-blue  w3-margin-left" onclick="sae_UpdateDeductions(this, %d, %d, %d);">Update Deductions</button>', $ecrIDX, $teamIDX, $userType;
        } else {
            $str .= sprintf '<button class="w3-button w3-border w3-round w3-white w3-hover-red"   onclick="sae_RemoveDeductions(this, %d);">Remove ECR</button>', $ecrIDX;
            $str .= sprintf '<button class="w3-button w3-border w3-round w3-blue  w3-margin-left" onclick="sae_UpdateStudentECR(this, %d);">Update ECR</button>', $ecrIDX;
        }
        
    }
    
    $str .= '<br>' x 2;
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_openECREntryForm(){
    print $q->header();
    my $location = $q->param('location');
    my $userType = $q->param('userType');
    my $teamIDX = $q->param('teamIDX');
    my $Ecr     = new SAE::ECR($teamIDX);
    my $EcrType = new SAE::TB_ECR_TYPE();
    my %ECR_TYPE = %{$EcrType->getAllRecord()};
    my $str;

    # if ($teamIDX>0){
        %TEAMS = %{$Ecr->_getTeamData( $teamIDX )};
    # } else {
    #     %TEAMS = %{$Ecr->_getMyTeams( $userIDX, $location )};
    # }
    $str .= '<div class="w3-container w3-border w3-round" style="height: 615px; overflow-y: auto;">';
    $str .= sprintf '<h4 style="padding: 1px 8px">%03d - %s</h4>', $TEAMS{IN_NUMBER}, $TEAMS{TX_SCHOOL};
    $str .= '<input ID="TX_ECR" type="text" class="w3-input w3-border w3-round w3-small" placeholder="ECR Title">';
    if ($userType==99) {
        $str .= '<textarea ID="CL_DESCRIPTION" class="w3-input w3-border w3-margin-top w3-round w3-small" style="resize: vertical; height: 75px;" placeholder="Describe the change(s) made."></textarea>';
    } else {
        $str .= '<textarea ID="CL_DESCRIPTION" class="w3-input w3-border w3-margin-top w3-round w3-small" style="resize: vertical; height: 300px;" >';
        $str .= 'Describe the change(s) made and the justification for the change.&#13;&#10;';
        $str .= 'Structural Changes:&#13;&#10;&#13;&#10;';
        $str .= 'Mechanical Changes:&#13;&#10;&#13;&#10;';
        $str .= 'Electronic Changes:&#13;&#10;&#13;&#10;';
        $str .= 'Misc Changes (Describe changes that does not fall under Structural/Mechanical/Electronic):&#13;&#10;&#13;&#10;';
        $str .= 'Wing Span Added/Removed Changes (Provide Length in Inches):&#13;&#10;&#13;&#10;';
        $str .= 'Chord Added/Removed Changes (Provide Length in Inches):&#13;&#10;&#13;&#10;';
        $str .= '</textarea>';
    }
        
    if ($userType == 99){
        $str .= '<table class="w3-table-all w3-hoverable w3-margin-top w3-small">';
        $str .= '<tr>';
        $str .= '<th>Type of Changes</th>';
        $str .= '<th style="width: 10%;">None</th>';
        $str .= '<th style="width: 10%;">Small</th>';
        $str .= '<th style="width: 10%;">Medium</th>';
        $str .= '<th style="width: 10%;">Large</th>';
        $str .= '<th style="width: 10%;">Deductions</th>';
        $str .= '</tr>';
        $str .= '<tbody>';
        foreach $ecrTypeIDX (sort {$a <=> $b} keys %ECR_TYPE) {
            $str .= '<tr>';
            $str .= sprintf '<td class="" style="padding: 2px 5px;">%s</td>', $ECR_TYPE{$ecrTypeIDX}{TX_TYPE};
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio"  name="TYPE_%d" value="0" checked onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">none</span></td>', $ecrTypeIDX, $ecrTypeIDX, ;
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio"  name="TYPE_%d" value="%d" onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">%d pts</span></td>',   $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_SMALL}, $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_SMALL};
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio"  name="TYPE_%d" value="%d" onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">%d pts</span></td>',   $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_MEDIUM}, $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_MEDIUM};
            $str .= sprintf '<td style="padding: 1px;"><input class="w3-check" type="radio"  name="TYPE_%d" value="%d" onchange="sae_updateDeduction(this, \'sae-type-%d\');">&nbsp;<span class="w3-small">%d pts +</span></td>', $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_LARGE}, $ecrTypeIDX, $ECR_TYPE{$ecrTypeIDX}{IN_LARGE};
            $str .= sprintf '<td style="padding: 1px;"><input type="number" class="w3-input w3-border w3-round sae-deduction-%d sae-deductions sae-type-%d" value="0.0" onchange="sae_updateDeduction(this, \'sae-type-%d\');"></td>', $ecrTypeIDX, $ecrTypeIDX;
            $str .= '</tr>';
        }
        $str .= '<tr>';
        $str .= '<td class="" style="padding: 2px 5px;">Wing Span (ADDED/REMOVED)</td>';
        $str .= '<td style="padding: 1px 5px; text-align: right;">ADDED<br>(Inches)</td>';
        $str .= '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round" type="number" ID="SPAN_ADD" value="0" step="0.1" min="0"    onchange="sae_updateLengthDeduction(this,\'sae-span\',\'add\');"></td>';
        $str .= '<td style="padding: 1px 5px; text-align: right;">REMOVED<br>(Inches)</td>';
        $str .= '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round" type="number" ID="SPAN_REMOVE" value="0" step="0.1" max="0" onchange="sae_updateLengthDeduction(this,\'sae-span\',\'remove\');"></td>';
        $str .= '<td style="padding: 1px 1px;"><input ID="IN_SPAN" type="number" class="w3-input w3-border w3-round sae-span sae-deductions" value="0.0" onchange="sae_updateDeduction(this, \'sae-type-span\');"></td>';
        $str .= '</tr>';
        
        $str .= '<tr>';
        $str .= '<td class="" style="padding: 2px 5px;">Wing Chord (ADDED/REMOVED)</td>';
        $str .= '<td style="padding: 1px 5px; text-align: right;">ADDED<br>(Inches)</td>';
        $str .= '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round" type="number" ID="CHORD_ADD" value="0" step="0.1" min="0"    onchange="sae_updateLengthDeduction(this,\'sae-chord\',\'add\');"></td>';
        $str .= '<td style="padding: 1px 5px; text-align: right;">REMOVED<br>(Inches)</td>';
        $str .= '<td style="padding: 1px 5px;"><input class="w3-input w3-border w3-round" type="number" ID="CHORD_REMOVE" value="0" step="0.1" max="0" onchange="sae_updateLengthDeduction(this,\'sae-chord\',\'remove\');"></td>';
        $str .= '<td style="padding: 1px 1px;"><input ID="IN_CHORD" type="number" class="w3-input w3-border w3-round sae-chord sae-deductions" value="0.0" onchange="sae_updateDeduction(this, \'sae-type-chord\');"></td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= '<td colspan="5" style=" text-align: right;">TOTAL DEDUCTION</td>';
        $str .= sprintf '<td class=""    style="padding: 1px 1px; text-align: right;"><input ID="TECH_TOTAL" class="w3-input w3-border w3-round w3-white w3-text-red" type="number" disabled></td>';
        $str .= '</tr>';
        $str .= '</tbody>';
        $str .= '</table>';
    }
    $str .= '<div class="w3-container w3-margin-top w3-center">';
    if ($userType == 99) {
        $str .= sprintf '<button class="w3-button w3-border w3-round w3-blue" onclick="sae_ApplyDeductions(this, %d, %d);">Apply Deductions</button>', $teamIDX, $userType;
    } else {
        $str .= sprintf '<button class="w3-button w3-border w3-round w3-blue" onclick="sae_StudentSubmitECR(this, %d, %d);">Submit ECR</button>', $teamIDX, $userType;
    }
    
    $str .= '<br>' x 2;
    $str .= '</div>';
    $str .= '</div>';
    # @METHODS = ('Tech Inspection','Safety Inspection','Test Flight','Design Analysis');
    # @SYSTEMS = ('Wing','Fuselage','Hor/Ver. Tail','Engine Support/Assembly','Landing Systems','Cargo Bay');
    # # my $str;
    # # $str .= '<div class="w3-container" >';
    # $str .= '<div class="w3-container w3-padding-small">';
    # $str .= '<div class="w3-container" style="height: 600px; overflow: auto">';
    # $str .= '<table class="w3-table w3-bordered w3-white">';
    # $str .= '<tr><td colspan="3" class=" w3-padding-small" >';
    # $str .= '<label class="w3-small" sae-select>Team:</label>';
    # $str .= '<select class="w3-input w3-small " ID="selectTeamIDX">';
    # if ($teamIDX == 0){
    #     $str .= '<option value="0"> - Select Team -</option>';
    # }
    # foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
    #     my $teamName = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
    #     $str .= '<option value="'.$teamIDX.'">'.$teamName.'</option>';
    # }
    # $str .= '</select>';
    # $str .= '</td></tr>';

    # $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Title:</label>';
    # $str .= '<input type="text" class="sae-input w3-input w3-small w3-padding-small" data-key="TX_ECR">';
    # $str .= '</td></tr>';

    # $str .= '<tr><td class=" w3-padding-small">';
    # $str .= '<label class="w3-small">How was this change discovered? (select all that\'s applicable)</label><br>';
    # foreach $method (@METHODS){
    #     $str .= '<input type="checkbox" class="sae-check-method w3-check" value="'.$method.'"><label class="w3-small">'.$method.'</label><br>';
    # }
    # $str .= '</td>';

    # $str .= '<td colspan="2" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Which systems were impacted by this change? (select all that\'s applicable)</label><br>';
    # foreach $system (@SYSTEMS){
    #     $str .= '<input type="checkbox" class="sae-check-system w3-check" value="'.$system.'"> <label class="w3-small">'.$system.'</label><br>';
    # }
    # $str .= '</td></tr>';
    # $str .= '<tr><td class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Change in Surface Area(in.<sup>2</sup>):</label>';
    # $str .= '</td>';
    # $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Original Area</label> <input type="text" class="sae-input w3-small" data-key="IN_AREA_OLD" style="width: 50px;"> in.<sup>2</sup>';
    # $str .= '</td>';
    # $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">New Area</label> <input type="text" class="sae-input w3-small" data-key="IN_AREA_NEW" style="width: 50px;"> in.<sup>2</sup>';
    # $str .= '</td>';
    # $str .= '</tr>';
    # $str .= '<tr><td class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Change in Length (in.)</label>';
    # $str .= '</td>';
    # $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Original Length</label> <input type="text" class="sae-input w3-small" data-key="IN_LENGTH_OLD" style="width: 50px;"> in.';
    # $str .= '</td>';
    # $str .= '<td style="text-align: right;" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">New Length</label> <input type="text" class="sae-input w3-small" data-key="IN_LENGTH_NEW" style="width: 50px;"> in.';
    # $str .= '</td>';
    # $str .= '</tr>';

    # $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Detailed description of the change/modification</label><br>';
    # $str .= '<textarea ID="clDescription" data-key="CL_DESCRIPTION" style="height: 50px" class="sae-input w3-input w3-small w3-border w3-padding-small  sae-text" style="min-width: 100%;"></textarea>';
    # $str .= '</td></tr>';

    # $str .= '<tr><td colspan="3" class=" w3-padding-small">';
    # $str .= '<label class="w3-small">Why was this change/modification needed</label><br>';
    # $str .= '<textarea ID="clReason" style="height: 50px" data-key="CL_REASON"  class="sae-input w3-input w3-small w3-border w3-padding-small  sae-text" style="min-width: 100%;"></textarea>';
    # $str .= '</td></tr>';
    # if ($teamIDX>0){
    #     $str .= &_tempEcrRow_Judge(0);
    # }
    # $str .= '<tr><td colspan="3" class="w3-display-container" style="text-align: center">';
    # if ($teamIDX>0){
    #     $str .= '<button class="w3-button w3-round w3-border w3-green" onclick="sae_submitECR(\''.$divName.'\', 1);">Apply</button>';
    # } else {
    #     $str .= '<button class="w3-button w3-round w3-border w3-green" onclick="sae_submitECR(\''.$divName.'\', 0);">Submit</button>';
    # }
    
    # $str .= '<button class="w3-margin-left w3-button w3-round w3-border w3-hover-red" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    # $str .= '</td></tr>';

    # $str .= '</table>';
    # # $str .= '<br><br>';
    # $str .= '</div>';
    # $str .= '</div>';
    
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