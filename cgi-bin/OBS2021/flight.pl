#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);


use DateTime;
use Cwd 'abs_path';
use JSON;

#---- SAE MODULES -------

use SAE::Common;
use SAE::FLIGHT;
use SAE::WEATHER;


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
##========================2020==========================================================
##======================= Flgith Operations ============================================
sub sae_flightOperations(){
    print $q->header();
    my $location = $q->param('location');
    my $filter = $q->param('filter');
    my $Flight = new SAE::FLIGHT();
    %OPS = %{$Flight->_getMetricListByStatus($filter, $location)};
    %FILTER = (0=>'All Teams', 1=>'Flight Logs - Out', 2=>'In line', 3=>'Ready For Flight', 4=>'Start Flying', 5=>'Completed: Success',6=>'Completed: Failed',7=>'Completed: Crashed', 8=>'Weigh-In', 9=>'Flight Log - In');
    my $str;
    $str = '<br><h3 class="w3-margin-left" >Flight Operations</h3>';
    $str .= '<div class="w3-container">';
    $str .= '<label class="w3-small">Filter:</label>';
    $str .= '<select ID="FLIGHT_OPS_FILTER" class="w3-input w3-border w3-round" onchange="sae_applyFlightOpsFilter(this)">';
    foreach $key (sort {$a<=>$b} keys %FILTER){
        my $selected = '';
        if ($key == $filter){$selected = 'selected'}
        $str .= sprintf '<option value="%d" '.$selected.'>%s</option>', $key, $FILTER{$key};
    }
    $str .= '</select>';
    $str .= '</div>';

    $str .= '<div ID="flightOpsContainer" class="w3-container w3-margin-top" style="margin-top: 8px;">';
    $str .= '<ul class="w3-ul w3-card-2 w3-white">';
    foreach $flightIDX (sort {$OPS{$a}{IN_NUMBER} <=> $OPS{$b}{IN_NUMBER}}  keys %OPS) {
        my $inStatus = $OPS{$flightIDX}{IN_STATUS};
        $str .= sprintf '<li class="w3-display-container w3-bar w3-white w3-btn" style="text-align: left!important" onclick="sae_loadFlow(%d, \'%03d\', %d);">', $flightIDX, $OPS{$flightIDX}{IN_NUMBER}, $inStatus;
        $str .= sprintf '<div class="w3-bar-item w3-large"><b class="w3-xlarge">Round %d</b><br><b class="w3-large">Team #%03d</b><br>%s</div>', $OPS{$flightIDX}{IN_ROUND}, $OPS{$flightIDX}{IN_NUMBER}, $OPS{$flightIDX}{TX_SCHOOL};
        $str .= '<span class="w3-bar-item w3-xlarge w3-right fa fa-chevron-right w3-margin-top"></span>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '<hr></br><br><br>';
    $str .= '</div>';
    
    return ($str);
}
sub sae_loadFlow(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $inStatus = $q->param('inStatus');
    
    %FILTER = (0=>'All Teams', 1=>'Flight Logs - Out', 2=>'In line', 3=>'Ready For Flight', 4=>'Start Flying', 5=>'Completed: Success',6=>'Completed: Failed',7=>'Completed: Crashed', 8=>'Weigh-In', 9=>'Flight Log - In');
    my $str;
    # $str = '<h4 class="w3-margin-left">Flight Operation Flow</h4>';
    $str .= '<ul class="w3-ul w3-xlarge">';
    # my $w3 = 'w3-green';
    for ($i=1; $i<=8; $i++){
        # if ($i > $inStatus){$w3='w3-transparent'} 
        $str .= &_tempMetricButton($flightIDX, $i, $FILTER{$i}, $inStatus);
    }
    $str .= '</ul>';
    $str .= '<hr>';
    return ($str);
    
}
sub sae_updateMetric(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $inStatus = $q->param('inStatus');
    my $label = $q->param('label');
    my $step = $q->param('step');
    my $Flight = new SAE::FLIGHT();
    my $newStatus =  int($inStatus) + int($step);
    $Flight->_updateMetric( $newStatus, $flightIDX );
    
    my $str;
    if ($step <0){
        $str = &_tempMetricButton($flightIDX, $inStatus, $label, $newStatus);
    } else {
        $str = &_tempMetricButton($flightIDX, $test, $label, $newStatus);
    }
    
    return ($str);
}
sub _tempMetricButton(){
    my $flightIDX = shift;
    my $i = shift;
    my $label = shift;
    my $inStatus = shift;
    my $str;
    my $complete = '';
    if ($i==5 || $i == 6 || $i == 7){
         $complete = 'sae-complete';
    }
    if ($i > $inStatus){
        $str = sprintf '<li class="'.$complete.' w3-bar w3-card-2 w3-button w3-hover-pale-yellow w3-margin-top w3-border w3-round w3-transparent w3-display-container w3-padding-large w3-mobile" style="margin-top: 8px!important" onclick="sae_updateMetric(this, %d, %d, \'%s\', 0);">%s</li>', $flightIDX, $i, $label, $label;    
    } else {
        $str = sprintf '<li class="'.$complete.' w3-bar w3-card-2 w3-button w3-hover-yellow w3-margin-top w3-border w3-round w3-green w3-display-container w3-padding-large  w3-mobile" style="margin-top: 8px!important" onclick="sae_updateMetric(this, %d, %d, \'%s\', -1);">%s</li>', $flightIDX, $i, $label, $label;
    }
    
    # my $str = sprintf '<a class="w3-button w3-border w3-round '.$w3.' w3-hide-medium w3-hide-large" style="margin-top: 8px; width: 100%;" href="javascript:void(0);" onclick="sae_updateMetric(this, %d, %d, \'%s\');">%s</a>', $flightIDX, $inStatus, $label, $label;
    return ($str);
}
##======================== Flgihts =====================================================
sub _tempClearInspectionButton(){
    my $teamIDX = shift;
    # my $w3Class = shift;
    my $str = '<button ';
    $str .= ' class="w3-button w3-hover-red w3-padding-small w3-round w3-border w3-purple" ';
    $str .= ' OnClick="sae_openReinspectionList('.$teamIDX.');" ';
    $str .= '>';
    $str .= '<i class="fa fa-exclamation-triangle fa-fw"></i> INSP';
    $str .= '</button>';
    return ($str);
}
sub _tempOpenFlightCardButton(){
    my $teamTitle = shift;
    my $teamIDX = shift;
    my $classIDX = shift;
    my $flightIDX = shift;
    my $inRound = shift;
    my $label = shift;
    my $w3Class = shift;
    my $str;
    $str = '<button ';
    $str .= ' class="w3-button w3-hover-yellow w3-padding-small w3-round w3-border '.$w3Class.' stats_'.$classIDX.'_'.$w3Class.' stats_'.$w3Class.' "';
    $str .= ' OnClick="sae_openFlightCard('.$teamIDX.','.$classIDX.','.$flightIDX.','.$inRound.',\''.$teamTitle.'\','.$inRound.');" ';
    $str .= '>'.$w3Class;
    $str .= $label.' ('.$inRound.')';
    $str .= '</button>';
    return ($str);
}
sub _tempCreateFlightCardButton(){
    my $teamTitle = shift;
    my $teamIDX = shift;
    my $classIDX = shift;
    my $inRound = shift;
    my $str;
    $str = '<button ID="TEAM_'.$teamIDX .'_ROUND_'.$inRound.'" ';
    $str .= ' class="w3-button w3-hover-yellow w3-padding-small w3-round" ';
    $str .= ' OnClick="sae_createFlightCard(this, '.$inRound.','.$teamIDX.','.$classIDX.',\''.$teamTitle.'\');" ';
    $str .= ' style="border: 1px dashed #555; margin: 5px;" ';
    $str .= '>';
    $str .= '+ '.$inRound;
    $str .= '</button>';
    return ($str);
}
sub showFlightTable(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $maxRound = 10;
    my $str;
    my $location = $q->param('location');
    %TEAMS = %{$Flight->_getTeamByLocation($location)};
    %CARDS = %{$Flight->_getCardStatusByEvent($location)};
    %CRASH = %{$Flight->_getCrashDataByEvent($location)};
    $str .= '<div class="w3-container">';
    $str .= '<br><h3>Flights';
    $str .= '<Button class="w3-button w3-padding-small w3-border w3-round w3-small w3-margin-left w3-pale-green" onclick="showFlightTable();"><i class="fa fa-refresh fa-fw"></i>&nbsp;Refresh</Button>';
    $str .= '<Button class="w3-button w3-padding-small w3-border w3-round w3-small w3-margin-left" onclick="sae_showFlightStats();"><i class="fa fa-line-chart" aria-hidden="true"></i>&nbsp;Statistics</Button>';
    $str .= '</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 150px;">Team # - Name</th>';
    for ($i=1; $i<=$maxRound; $i++){
        $str .= '<th>Rnd '.$i.'</th>';
    }
    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        my $eIDX = crypt($teamIDX, '20');
        $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $name = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAMS{$teamIDX}{TX_SCHOOL};
        my $link = '<a class="w3-small w3-text-black" href="score.html?teamIDX='.$eIDX.'&source=17" target="_blank">'.$name.'</a>';
        $str .= '<tr class="w3-tiny">';
        # $str .= '<tr class="w3-tiny w3-hide-small">';
        $str .= '<td nowrap>'.$link.'</td>';
        for ($i=1; $i<=$maxRound; $i++){
            $str .= '<td style="padding-left: 1px; padding-right: 1px;">';
            if (exists $CARDS{$teamIDX}{$i}){
                $flightIDX = $CARDS{$teamIDX}{$i}{PK_FLIGHT_IDX};
                $txColor= $CARDS{$teamIDX}{$i}{TX_COLOR};
                $txStatus = $CARDS{$teamIDX}{$i}{TX_STATUS};
                $str .= &_tempOpenFlightCardButton($name, $teamIDX , $classIDX , $flightIDX , $i , $txStatus , $txColor);
            } else {
                if (exists $CRASH{$teamIDX} && $CRASH{$teamIDX}{IN_ROUND}<=$i){
                    $str .= &_tempClearInspectionButton($teamIDX);
                } else {
                    $str .= &_tempCreateFlightCardButton($name , $teamIDX , $classIDX , $i);
                }
                
            }            
            $str .= '</td>';
        }
        $str .= '</tr>';
        # $str .= '<tr></tr>';
        # $str .= '<tr class="w3-hide-medium w3-hide-large">';
        # $str .= '<td style="padding: 0px;" class="w3-container">';
        # my $link_small = '<a class="w3-text-white" href="score.html?teamIDX='.$eIDX.'&source=17" target="_blank">'.$name.'</a>';
        # $str .= '<header class="w3-container w3-blue-grey"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><h3>'.$link_small.'</h3></header>';
        # $str .= '<div class="w3-container" style="padding: 10px;">';
        # $str .= '<p>Rounds:</p>';
        # for ($i=1; $i<=$maxRound; $i++){
        #     if (exists $CARDS{$teamIDX}{$i}){
        #         $flightIDX = $CARDS{$teamIDX}{$i}{PK_FLIGHT_IDX};
        #         $txColor= $CARDS{$teamIDX}{$i}{TX_COLOR};
        #         $txStatus = $CARDS{$teamIDX}{$i}{TX_STATUS};
        #         $str .= &_tempOpenFlightCardButton($name, $teamIDX , $classIDX , $flightIDX , $i , $txStatus , $txColor);
        #     } else {
        #         if (exists $CRASH{$teamIDX} && $CRASH{$teamIDX}{IN_ROUND}<=$i){
        #             $str .= '&nbsp; '.&_tempClearInspectionButton($teamIDX);
        #         } else {
        #             $str .= '&nbsp; '.&_tempCreateFlightCardButton($name , $teamIDX , $classIDX , $i);
        #         }
        #     }  
        # }
        # $str .= '</div>';
        
        # $str .= '</td>';
        # $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
}
sub sae_createFlightCard(){
    print $q->header();
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $classIDX = $q->param('classIDX');
    my $inRound = $q->param('inRound');
    my $teamTitle = $q->param('teamTitle');
    my $Flight = new SAE::FLIGHT();
    $flightIDX = $Flight->_createFlightCard($teamIDX , $inRound , $location);
    my $str = &_tempOpenFlightCardButton($teamTitle, $teamIDX, $classIDX, $flightIDX, $inRound , 'Out-'.$inRound, 'w3-yellow');
    return ( $str );
}
sub sae_deleteFlightCard(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $inRound = $q->param('inRound');
    my $teamTitle = $q->param('teamTitle');
    my $classIDX = $q->param('classIDX');
    my $Flight = new SAE::FLIGHT();
    $Flight->_deleteFlightCardById($flightIDX);
    my $str = &_tempCreateFlightCardButton($teamTitle , $teamIDX , $classIDX , $inRound);
    return ($str);
}
sub sae_openFlightCard(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $divName = $q->param('divName');
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $inRound = $q->param('inRound');
    my $classIDX = $q->param('classIDX');
    my $location = $q->param('location');

    my $str .= '<div>';
    if ($classIDX == 1){
        $str .= &_regularClassFlightCard($teamIDX, $flightIDX, $divName, $inRound, $location);
    } elsif ($classIDX == 2) {
        $str .= &_advancedClassFlightCard($teamIDX, $flightIDX, $divName, $inRound );
    } else {
        $str .= &_microClassFlightCard($teamIDX, $flightIDX, $divName, $inRound );
    }
    $str .= '</div>';
    return ($str);
}
sub _tempCheckPenalties(){
    my $inMinor = shift;
    my $inLanding = shift;
    my $minorCheck = '';
    my $landingCheck = '';
    if ($inMinor==1){$minorCheck = 'checked'}
    if ($inLanding==1){$landingCheck = 'checked'}
    my $str;
    # $str .= '<div class="w3-half w3-container">';

    # $str .= '</div>';
    $str .= '<div class="w3-half w3-container">';
    $str .= '<input type="checkbox" data-key="IN_PEN_MINOR" class="sae-checked-item w3-check" '.$minorCheck.' value="1">&nbsp;&nbsp;<label class="w3-small">Minor Penalty (Rule 3.5)</label><br>';
    $str .= '<input type="checkbox" data-key="IN_PEN_LANDING" class="sae-checked-item w3-check" '.$landingCheck.' value="1">&nbsp;&nbsp;<label class="w3-small">Landing Penalty (Rule 3.10)</label>';
    $str .= '</div>';
    $str .= '<div class="w3-clear"><hr></div>';
    return ($str);
}
sub _regularClassFlightCard(){
    my $teamIDX = shift;
    my $flightIDX = shift;
    my $divName = shift;
    my $inRound = shift;
    my $location = shift;
    my $Flight = new SAE::FLIGHT();
    my $Weather = new SAE::WEATHER();
    my %TEAM = %{$Flight->_getTeamDataById($teamIDX)};
    my %FLIGHT = %{$Flight->_getCardStatusByID($flightIDX)};
    my $inStatus = $FLIGHT{$teamIDX}{IN_STATUS};
     my %HOURS = %{$Weather->_getWeatherByHours( $location , 8 )};
    my $str;
    
    $str .= '<div class="w3-container">';
    $str .= '<label class="w3-small">Length of Cargo</label>';
    if ($inStatus < 1){
        $update = sprintf 'value="%2.2f"', $TEAM{$teamIDX}{IN_LCARGO};
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_LCARGO};
    }
    $str .= '<input  style="width: 20%;" type="number" tabindex="2" data-key="IN_LCARGO" class="sae-flight-input w3-border w3-input w3-round-large" '.$update.' disabled>';
    $str .= '</div>';
    
    $str .= '<div class="w3-row">';
    

    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small">Time of Flight</label>';

    $str .= '<select tabindex="1" ID="TX_TIME_2" class="w3-border w3-input w3-round-large">';
    if ($inStatus < 1){
        $str .= '<option value="0">- Time of Flight -</option>';
    } 
    foreach $hourIDX (sort {$b <=> $a} keys %HOURS){
        $selected = '';
        if ($hourIDX == $FLIGHT{$teamIDX}{FK_WEATHER_IDX}) {$selected = 'selected'}
        @DT = split(/\s/,$HOURS{$hourIDX}{TS_LOCAL});
        $str .= '<option value="'.$hourIDX.'" '.$selected.'>'.$DT[1].'</option>';
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small"># of Balls</label>';
    if ($inStatus < 1){
        $update = 'placeholder="# balls"';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_SPHERE};
    }
    $str .= '<input type="number" tabindex="3" data-key="IN_SPHERE" class="sae-flight-input w3-border w3-input w3-round-large" '.$update.'>';
    $str .= '</div>';

    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small">Wingspan (in)</label>';
    if ($inStatus < 1){
        $update = 'placeholder="0.00 in."';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_SPAN};
    }
    $str .= '<input type="number" tabindex="3" data-key="IN_SPAN" class="sae-flight-input w3-border w3-input w3-round-large"  '.$update.'>';
    $str .= '</div>';
    
    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small">Payload</label>';
    if ($inStatus < 1){
        $update = 'placeholder="0.00 lbs."';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_WEIGHT};
    }
    $str .= '<input type="number" tabindex="4" ID="IN_WEIGHT" data-key="IN_WEIGHT" class="sae-flight-input w3-border w3-input w3-round-large IN_WEIGHT"  '.$update.'>';
    $str .= '</div>';

    
    
    $str .= '<div class="w3-half w3-container">';
    $str .= '<a href="javascript:void(0);" onclick="sae_openWeightCalculations();"><i class="fa fa-calculator"></i> &nbsp;Calculate Payload Weight</a>';
        $str .= '<div ID="CALC" class="w3-row w3-border w3-hide w3-card-2">';
            $str .= '<div class="w3-container w3-quarter w3-small">';
            $str .= 'Weight:<input tabindex="6" type="number" ID="PAYLOAD_LB" class="w3-input w3-small" placeholder="0"><label class="w3-small">lbs.</label>';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-quarter w3-small">';
            $str .= 'Weight:<input tabindex="7" type="number" ID="PAYLOAD_OZ" class="w3-input w3-small" placeholder="0 - 16"><label class="w3-small">oz.</label>';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-half">';
            $str .= '<p>Apply Results to:</p>';
            $str .= '<a class="w3-small" href="javascript:void(0);" onclick="sae_applyto(\'IN_WEIGHT\', 10000);">Payload Weight</a>';
            $str .= '</div>';
        $str .= '</div>';
    $str .= '</div>';
    $str .= &_tempCheckPenalties($FLIGHT{$teamIDX}{IN_PEN_MINOR}, $FLIGHT{$teamIDX}{IN_PEN_LANDING});
    # $str .= '<div class="w3-clear"><hr></div>';
    $str .= '<div class="w3-container w3-padding" style="text-align: right!important;">';
    $str .= '<a style="margin-left: 0px; padding: 7px;" class="w3-button w3-white w3-hover-red w3-round w3-border" href="javascript:void(0);" onclick="sae_deleteFlightCard('.$flightIDX.',\''.$divName.'\');">Delete</a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-white w3-hover-orange w3-round w3-border" href="javascript:void(0);" onclick="sae_updateCrashStatus('.$flightIDX.','.$teamIDX.',\''.$divName.'\','.$inRound.');">Crashed</a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-white w3-hover-yellow w3-round w3-border" href="javascript:void(0);" onclick="sae_updateDNFStatus('.$flightIDX.',\''.$divName.'\','.$inRound.');"> No Fly </a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-pale-green w3-hover-green w3-round w3-border" href="javascript:void(0);" onclick="sae_updateSuccessStatus('.$flightIDX.',\''.$divName.'\','.$inRound.');">Success</a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub _advancedClassFlightCard(){
    my $teamIDX = shift;
    my $flightIDX = shift;
    my $divName = shift;
    my $inRound = shift;
    my $Flight = new SAE::FLIGHT();
    my %TEAM = %{$Flight->_getTeamDataById($teamIDX)};
    my %FLIGHT = %{$Flight->_getCardStatusByID($flightIDX)};
    my $inStatus = $FLIGHT{$teamIDX}{IN_STATUS};
    my $str;
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small"># of Colonists</label>';
    if ($inStatus < 1){
        $update = 'placeholder="# Colonist"';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_COLONIST};
    }
    $str .= '<input type="number" tabindex="1" data-key="IN_COLONIST" class="sae-flight-input w3-border w3-input w3-round-large" '.$update.'>';
    $str .= '</div>';

    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small"># of Habitats</label>';
    if ($inStatus < 1){
        $update = 'placeholder="# Habitats"';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_HABITAT};
    }
    $str .= '<input type="number" tabindex="2" data-key="IN_HABITAT" class="sae-flight-input w3-border w3-input w3-round-large" '.$update.'>';
    $str .= '</div>';

    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small">Amount of Water</label>';
    if ($inStatus < 1){
        $update = 'placeholder="0.00 fl oz."';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_WATER};
    }
    $str .= '<input type="number" tabindex="3" ID="IN_WATER" data-key="IN_WATER" class="sae-flight-input w3-border w3-input w3-round-large"  '.$update.'>';
    $str .= '</div>';

    $str .= '<div class="w3-quarter w3-container">';
    $str .= '<label class="w3-small">Payload (lbs)</label>';
    if ($inStatus < 1){
        $update = 'placeholder="0.00 lbs."';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_WEIGHT};
    }
    $str .= '<input type="number" tabindex="4" data-key="IN_WEIGHT" class="sae-flight-input w3-border w3-input w3-round-large"  '.$update.'>';
    $str .= '</div>';

    $str .= '<div class="w3-half w3-container">';
    $str .= '<a href="javascript:void(0);" onclick="sae_openWeightCalculations();"><i class="fa fa-calculator"></i> &nbsp;Calculate Water Amount</a>';
        $str .= '<div ID="CALC" class="w3-row w3-border w3-hide w3-card-2">';
            $str .= '<div class="w3-container w3-quarter w3-small">';
            $str .= 'Calculate:<input tabindex="5" type="number" ID="PAYLOAD_NO" class="w3-input w3-small" placeholder="0"><label class="w3-small"># of Bottles</label>';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-quarter w3-small">';
            $str .= 'Calculate:<input tabindex="6" type="number" ID="PAYLOAD_OZ" class="w3-input w3-small" value="16.9"><label class="w3-small">fl oz./bottle</label>';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-half">';
            $str .= '<p>Apply Results to:</p>';
            $str .= '<a class="w3-small" href="javascript:void(0);" onclick="sae_advancedClass_applyto(\'IN_WATER\');">Water Supplies</a>';
            $str .= '</div>';
        $str .= '</div>';
    $str .= '</div>';

    $str .= &_tempCheckPenalties($FLIGHT{$teamIDX}{IN_PEN_MINOR}, $FLIGHT{$teamIDX}{IN_PEN_LANDING});
    # $str .= '<div class="w3-clear"><hr></div>';
    $str .= '<div class="w3-container w3-padding" style="text-align: right!important;">';
    $str .= '<a style="margin-left: 0px; padding: 7px;" class="w3-button w3-white w3-hover-red w3-round w3-border" href="javascript:void(0);" onclick="sae_deleteFlightCard('.$flightIDX.',\''.$divName.'\');">Delete</a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-white w3-hover-orange w3-round w3-border" href="javascript:void(0);" onclick="sae_updateCrashStatus('.$flightIDX.','.$teamIDX.',\''.$divName.'\','.$inRound.');">Crashed</a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-white w3-hover-yellow w3-round w3-border" href="javascript:void(0);" onclick="sae_updateDNFStatus('.$flightIDX.',\''.$divName.'\','.$inRound.');"> No Fly </a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-pale-green w3-hover-green w3-round w3-border" href="javascript:void(0);" onclick="sae_updateSuccessStatus('.$flightIDX.',\''.$divName.'\','.$inRound.');">Success</a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub _microClassFlightCard(){
    my $teamIDX = shift;
    my $flightIDX = shift;
    my $divName = shift;
    my $inRound = shift;
    my $Flight = new SAE::FLIGHT();
    my %TEAM = %{$Flight->_getTeamDataById($teamIDX)};
    my %FLIGHT = %{$Flight->_getCardStatusByID($flightIDX)};
    my $inStatus = $FLIGHT{$teamIDX}{IN_STATUS};
    my $str;
    $str .= '<div class="w3-row">';
    
    $str .= '<div class="w3-half w3-container">';
    $str .= '<label class="w3-small">Aircraft\'s Empty Weight</label>';
    if ($inStatus < 1){
        $update = 'placeholder="0.00 lbs"';
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_EMPTY};
    }
    $str .= '<input type="number" ID="IN_EMPTY" tabindex="2" data-key="IN_EMPTY" class="sae-flight-input w3-border w3-input w3-round-large IN_EMPTY" '.$update.'>';
    $str .= '</div>';
    
    $str .= '<div class="w3-half w3-container">';
    $str .= '<label class="w3-small">Payload Weight';
    $str .= sprintf ' (max payload = %2.2f lbs.)', $TEAM{$teamIDX}{IN_WPIPES};
    $str .= '</label>';
    if ($inStatus < 1){
        $update = sprintf 'placeholder="max weight = %2.2f lbs."', $TEAM{$teamIDX}{IN_WPIPES};
    } else {
        $update = sprintf 'value="%2.2f"', $FLIGHT{$teamIDX}{IN_WEIGHT};
    }
    $str .= '<input type="number" tabindex="1" ID="IN_WEIGHT" data-key="IN_WEIGHT" data-max="'.$TEAM{$teamIDX}{IN_WPIPES}.'"min="0" max="'.$TEAM{$teamIDX}{IN_WPIPES}.'" step="0.01" class="sae-flight-input w3-border w3-input w3-round-large IN_WEIGHT" '.$update.' onkeyup="sae_checkMaxWeight(this, '.$TEAM{$teamIDX}{IN_WPIPES}.')">';
    $str .= '</div>';

    
    $str .= '<div class="w3-half w3-container">';
    $str .= '<a href="javascript:void(0);" onclick="sae_openWeightCalculations();"><i class="fa fa-calculator"></i> &nbsp;Calculate</a>';
        $str .= '<div ID="CALC" class="w3-row w3-border w3-hide w3-card-2">';
            $str .= '<div class="w3-container w3-quarter w3-small">';
            $str .= 'Weight: <input tabindex="3" type="number" ID="PAYLOAD_LB" class="w3-input w3-small" placeholder="0"> lbs.';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-quarter w3-small">';
            $str .= 'Weight: <input tabindex="4" type="number" ID="PAYLOAD_OZ" class="w3-input w3-small" placeholder="0-16" min="0" max="16"> oz.';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-half">';
            $str .= '<p>Apply Results to:</p>';
            $str .= '<a class="w3-small" href="javascript:void(0);" onclick="sae_applyto(\'IN_WEIGHT\','.$TEAM{$teamIDX}{IN_WPIPES}.');">Payload Weight</a><br>';
            $str .= '<a class="w3-small" href="javascript:void(0);" onclick="sae_applyto(\'IN_EMPTY\',1000);">Empty Weight</a>';
            $str .= '</div>';
        $str .= '</div>';
    $str .= '</div>';
    $str .= &_tempCheckPenalties($FLIGHT{$teamIDX}{IN_PEN_MINOR}, $FLIGHT{$teamIDX}{IN_PEN_LANDING});
    # $str .= '<div class="w3-clear"><hr></div>';
    $str .= '<div class="w3-container w3-padding" style="text-align: right!important;">';
    $str .= '<a style="margin-left: 0px; padding: 7px;" class="w3-button w3-white w3-hover-red w3-round w3-border" href="javascript:void(0);" onclick="sae_deleteFlightCard('.$flightIDX.',\''.$divName.'\');">Delete</a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-white w3-hover-orange w3-round w3-border" href="javascript:void(0);" onclick="sae_updateCrashStatus('.$flightIDX.','.$teamIDX.',\''.$divName.'\','.$inRound.');">Crashed</a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-white w3-hover-yellow w3-round w3-border" href="javascript:void(0);" onclick="sae_updateDNFStatus('.$flightIDX.',\''.$divName.'\','.$inRound.');"> No Fly </a>';
    $str .= '<a style="margin-left: 10px; padding: 7px;" class="w3-button w3-pale-green w3-hover-green w3-round w3-border" href="javascript:void(0);" onclick="sae_updateSuccessStatus('.$flightIDX.',\''.$divName.'\','.$inRound.');">Success</a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_updateDNFStatus(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $inRound = $q->param('inRound');
    my $Flight = new SAE::FLIGHT();
    $Flight->_updateFlightCardStatus($flightIDX,2,$inRound);
    return ($str);
}
sub sae_updateCrashStatus(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $inRound = $q->param('inRound');
    my $Flight = new SAE::FLIGHT();
    $Flight->_updateFlightCardStatus($flightIDX,3,$inRound);
    return ($str);
}
sub sae_createReinspection(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $location = $q->param('location');
    my $divName = $q->param('divName');
    %ITEMS = %{$Flight->_getInspectionItems()};
    my $str;
    $str = '<div class="w3-row">';
    $str .= '<p>The following componets require re-inspection prior to next flight</p>';
    $str .= '<div class="w3-half w3-bar-right">';
    $str .= '<ul class="w3-ul">';
    foreach $itemIDX (sort {lc($ITEMS{$a}{TX_ITEM}) cmp lc($ITEMS{$b}{TX_ITEM})} keys %ITEMS){
        $str .= '<li style="padding: 0px;" >';
        $str .= '<input ID="'.$itemIDX.'" type="checkbox" class="sae-inspection_item w3-check" value="'.$ITEMS{$itemIDX}{TX_ITEM}.'"> <label  class="w3-small" FOR="'.$itemIDX.'">'.$ITEMS{$itemIDX}{TX_ITEM}.'</label>';
        $str .= '</li>';
    }
    $str .= '<li style="padding: 5px 0px;">';
    $str .= '<input ID="0" type="checkbox" class="sae-inspection_item w3-check" value="0"> <label  class="w3-small" FOR="0">Others</label> &nbsp;&nbsp;&nbsp;';
    $str .= '<input type="text" style="border: 1px solid #ccc; width: 75%;" ID="ITEM_OTHERS" >';
    $str .= '</li>';
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<div class="w3-half ">';
    $str .= '<label class="w3-small">Comments</label>';
    $str .= '<textarea class="w3-input w3-border sae-input" style="height: 100px; min-width: 100%; max-width: 100%;" data-key="CL_COMMENT"></textarea>';
    $str .= '</div>';
    $str .= '<div class="w3-clear"><hr></div>';
    $str .= '<div class="w3-panel w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-button w3-border w3-round-large " onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '<button class="w3-button w3-border w3-round-large w3-margin-left" onclick="sae_submitCrashReport('.$flightIDX.','.$teamIDX.',\''.$divName .'\');">Submit</button>';
    
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
}
sub sae_submitCrashReport(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $others = $q->param('others');
    my $flightIDX = $q->param('flightIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    if ($others ne '' ){
        $Flight->_addNewInspectionItem($others);
    }
    my $todoIDX = $Flight->_submitCrashReport($flightIDX , \%DATA);
    $Flight->_updateToDoFlightCard($flightIDX, $todoIDX);
    my $str;
    # my $str = &_tempEcrRow($ecrIDX, $teamName, $DATA{TX_ECR}, 0, 0);
    return ($str);
}
sub sae_openReinspectionList(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    %CRASH = %{$Flight->_getCrashDataByTeamId($teamIDX)};
    $str .= '<ul class="w3-ul">';
    # $str .= '<img src="images/inspection.png" alt="Avatar" style="width:80%">';
    foreach $todoIDX (sort keys %CRASH) {
        my @ITEMS = split(";", $CRASH{$todoIDX}{CL_DESCRIPTION});
        $str .= '<li style="padding: 2px;" class="w3-bar">';
        $str .= '<a class="w3-button w3-border w3-green w3-bar-item w3-round" href="javascript:void(0);" onclick="sae_clearReinspection(this, '.$teamIDX.','.$todoIDX.',\''.$divName.'\')">Clear</a> ';
        $str .= '<div class="w3-bar-item w3-small">Round '.$CRASH{$todoIDX}{IN_ROUND}.' - '.$CRASH{$todoIDX}{TX_STATUS}.'  for: ';
        $str .= '<ul class="w3-ul">';
        foreach $item (sort {$a<=>$b} @ITEMS){
            $str .= '<li style="padding: 1px; margin-left: 20px">'.$item.'</li>';
        }
        $str .= '</ul>';
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    return($str);
}
sub sae_clearReinspection(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $todoIDX = $q->param('todoIDX');
    my $Flight = new SAE::FLIGHT();
    $Flight->_updateReinspectionItems( $todoIDX );
    return ($str);
}
sub sae_updateSuccessStatus(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $flightIDX = $q->param('flightIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    $str = $Flight->_updateSuccessFlight($flightIDX , \%DATA);
    return ($str );
}
