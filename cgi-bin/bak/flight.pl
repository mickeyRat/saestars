#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use DateTime;
use Cwd 'abs_path';
use URI::Escape;
use JSON;

#---- SAE MODULES -------

use SAE::Common;
use SAE::FLIGHT;
use SAE::WEATHER;
use SAE::TB_WEATHER;
use SAE::TB_TEAM;
use SAE::TEAM;
use SAE::TB_FLIGHT;
use SAE::REGULAR;
use SAE::ADVANCED;
use SAE::MICRO;
use SAE::Common;
use SAE::AIRBOSS;
use SAE::TECH;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");
my %STATUS = (1=>"Good Flight", 3=>"Crashed", 2=>"No Fly");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
# Can't locate object method "_temp" via package "SAE::FLIGHT" at flight.pl line 716.

##========================2020==========================================================
##======================= Flight Operations ============================================
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
##======================== Flights =====================================================
sub showFlightTable(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $maxRound = 10;
    my $height = '50px';
    my $str;
    my $location = $q->param('location');
    %TEAMS = %{$Flight->_getTeamByLocation($location)};
    %CARDS = %{$Flight->_getCardStatusByEvent($location)};
    %CRASH = %{$Flight->_getCrashDataByEvent($location)};
    %ROW = (0=>'w3-white', 1=>'w3-light-grey');
    my $counter = 0;
    my $height = 45;
    $str .= '<div class=" w3-container w3-margin-top w3-row"><br>';
    $str .= '<h3>Flight Logs</h3>';
    $str .= '<ul class="w3-ul">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        my $txFlightStatus = $TEAMS{$teamIDX}{TX_FLIGHT_BUTTON};
        # my $btn = $Flight->_tempFlightLogButton($teamIDX, $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_NAME}, $TEAMS{$teamIDX}{TX_COUNTRY}, $TEAMS{$teamIDX}{FK_CLASS_IDX}, $TEAMS{$teamIDX}{IN_FLIGHT_STATUS});
        if ($TEAMS{$teamIDX}{TX_FLIGHT_BUTTON}) {
            $str .=  $txFlightStatus;
        } else {
            $str .= $Flight->_tempCheckOutButton($teamIDX, 1);
        }
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
}
##======================== Readonly Flight Cards =========================================
sub sae_openReadOnlyFlightCard(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $classIDX = $q->param('classIDX');
    my $location = $q->param('location');
    my $str;
    if ($classIDX==3){
        $str = &microClassLogs($teamIDX);
    } elsif ($classIDX==2) {
        $str = &advancedClassLogs($teamIDX);
    } else {
        $str = &regularClassLogs($teamIDX, $location);
    }
    return ($str);
}
sub microClassLogs(){
    my $teamIDX = shift;
    my $location = shift;
    my $Micro = new SAE::MICRO($location);
    my %LOGS = %{$Micro->_getTeamScoreCard($teamIDX)};
    my %STATUS = (0=>"No", 1=>"Yes", ''=>'--');
    my $str;
    
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 4%;">Rnd</th>';
    $str .= '<th style="width: 10%;text-align: right;"># of Good<br>Large Boxes</th>';
    $str .= '<th style="width: 10%;text-align: right;"># of Dmge<br>Large Boxes</th>';
    $str .= '<th style="width: 10%;text-align: right;"># of Good<br>Small Boxes</th>';
    $str .= '<th style="width: 10%;text-align: right;"># of Dmge<br>Small Boxes</th>';
    $str .= '<th style="width: 10%;text-align: right;">Payload<br>(lbs)</th>';
    $str .= '<th style="width: 10%;text-align: right;">Flight Time<br>(sec)</th>';
    $str .= '<th style="width: 7%;text-align: right;">Minor<br>Pen</th>';
    $str .= '<th style="width: 7%;text-align: right;">Major<br>Pen</th>';
    $str .= '<th style="width: 7%;text-align: right;">Bonus</th>';
    $str .= '<th style="width: 10%;text-align: right;">Flight Score</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $inRound (sort {$a <=> $b} keys %LOGS) {
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td style="text-align: center;">%d</td>',    $inRound;   
        $str .= sprintf '<td style="text-align: right;">%d</td>',    $LOGS{$inRound}{IN_LARGE};   
        $str .= sprintf '<td style="text-align: right;">%d</td>',    $LOGS{$inRound}{IN_LB_DAMAGE};   
        $str .= sprintf '<td style="text-align: right;">%d</td>',    $LOGS{$inRound}{IN_SMALL};   
        $str .= sprintf '<td style="text-align: right;">%d</td>',    $LOGS{$inRound}{IN_SB_DAMAGE};   
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $LOGS{$inRound}{IN_WEIGHT};   
        $str .= sprintf '<td style="text-align: right;">%d</td>',    $LOGS{$inRound}{IN_TOF}; 
        # $str .= sprintf '<td style="text-align: right;">%10s</td>',  $STATUS{$LOGS{$inRound}{IN_DAMAGE}}; 
        $str .= sprintf '<td style="text-align: right;">%10s</td>',  $STATUS{$LOGS{$inRound}{IN_PEN_MINOR}}; 
        $str .= sprintf '<td style="text-align: right;">%10s</td>',  $STATUS{$LOGS{$inRound}{IN_PEN_LANDING}}; 
        $str .= sprintf '<td style="text-align: right;">%10.2f</td>',$LOGS{$inRound}{IN_BONUS}; 
        $str .= sprintf '<td style="text-align: right;">%10.4f</td>',$LOGS{$inRound}{IN_FS}; 
        $str .= '</tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large w3-white">';
        $str .= '<td>';
        $str .= sprintf 'Flight Attempt: <span class="w3-text-blue">#%d</span><br>',    $inRound;   
        $str .= sprintf 'Large Boxes: <span class="w3-text-blue">%d</span></br>',    $LOGS{$inRound}{IN_LARGE};   
        $str .= sprintf 'Small Boxes: <span class="w3-text-blue">%d</span></br>',    $LOGS{$inRound}{IN_SMALL};   
        $str .= sprintf 'Payload: <span class="w3-text-blue">%2.2f</span> lbs.</br>', $LOGS{$inRound}{IN_WEIGHT};   
        $str .= sprintf 'Flight Time: <span class="w3-text-blue">%d</span> (sec)</br>',    $LOGS{$inRound}{IN_TOF}; 
        $str .= sprintf 'Damage Boxes: <span class="w3-text-blue">%10s</span></br>',  $STATUS{$LOGS{$inRound}{IN_DAMAGE}}; 
        $str .= sprintf 'Minor Penalty: <span class="w3-text-blue">%10s</span></br>',  $STATUS{$LOGS{$inRound}{IN_PEN_MINOR}}; 
        $str .= sprintf 'Major Penalty: <span class="w3-text-blue">%10s</span></br>',  $STATUS{$LOGS{$inRound}{IN_PEN_LANDING}}; 
        $str .= sprintf 'Bonus: <span class="w3-text-blue">%10.2f</span></br>',$LOGS{$inRound}{IN_BONUS}; 
        $str .= sprintf 'Flight Score: <span class="w3-text-blue">%10.4f</span></br>',$LOGS{$inRound}{IN_FS}; 
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    return ($str);
}
sub advancedClassLogs(){
    my $teamIDX = shift;
    my $location = shift;
    my $Advanced = new SAE::ADVANCED(29);
    # my %TEAM = %{$Advanced->_getTeamList()};
    my %LOGS = %{$Advanced->_getTeamScoreCard($teamIDX)};
    my %STATUS = (0=>"No", 1=>"Yes", ''=>'--');
    my $str;
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 5%;">Rnd</th>';
    $str .= '<th style="width: 10%;text-align: right;"># Colonists</th>';
    $str .= '<th style="width: 10%;text-align: right;"># Habitats</th>';
    $str .= '<th style="width: 10%;text-align: right;">Water</th>';
    $str .= '<th style="width: 15%;text-align: right;">Payload (lbs)</th>';
    $str .= '<th style="width: 10%;text-align: right;">Minor<br>Penalty</th>';
    $str .= '<th style="width: 10%;text-align: right;">Major<br>Penalty</th>';
    $str .= '</tr>';
    my $inCol = 0;
    my $inHab = 0;
    my $inWat = 0;
    my $inPay = 0;
    foreach $inRound (sort {$a<=>$b} keys %LOGS) {
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td style="text-align: center;">%d</td>', $inRound; 
        $str .= sprintf '<td style="text-align: right;">%2.2f </td>', $LOGS{$inRound}{IN_COLONIST}; 
        $str .= sprintf '<td style="text-align: right;">%2.2f </td>', $LOGS{$inRound}{IN_HABITAT}; 
        $str .= sprintf '<td style="text-align: right;">%2.2f fl oz.</td>', $LOGS{$inRound}{IN_WATER}; 
        $str .= sprintf '<td style="text-align: right;">%2.2f lbs.</td>', $LOGS{$inRound}{IN_WEIGHT}; 
        $str .= sprintf '<td style="text-align: right;">%s</td>', $STATUS{$LOGS{$inRound}{IN_PEN_MINOR}};    
        $str .= sprintf '<td style="text-align: right;">%s</td>', $STATUS{$LOGS{$inRound}{IN_PEN_LANDING}};    
        $str .= '</tr>';
        $inCol += $LOGS{$inRound}{IN_COLONIST};
        $inHab += $LOGS{$inRound}{IN_HABITAT};
        $inWat += $LOGS{$inRound}{IN_WATER};
        $inPay += $LOGS{$inRound}{IN_WEIGHT};
        $str .= '<tr class="w3-hide-medium w3-hide-large w3-white">';
        $str .= '<td>';
        $str .= sprintf 'Round  <span class="w3-text-blue w3-large">%d</span><br>', $inRound; 
        $str .= sprintf '# of Colonists: <span class="w3-text-blue w3-large">%2.2f </span><br>', $LOGS{$inRound}{IN_COLONIST}; 
        $str .= sprintf '# of Habitats: <span class="w3-text-blue w3-large">%2.2f </span><br>', $LOGS{$inRound}{IN_HABITAT}; 
        $str .= sprintf 'Water: <span class="w3-text-blue w3-large">%2.2f </span>fl oz.<br>', $LOGS{$inRound}{IN_WATER}; 
        $str .= sprintf 'Payload: <span class="w3-text-blue w3-large">%2.2f</span> lbs.<br>', $LOGS{$inRound}{IN_WEIGHT}; 
        $str .= sprintf 'Minor Penalty: <span class="w3-text-blue w3-large">%s</span><br>', $STATUS{$LOGS{$inRound}{IN_PEN_MINOR}};    
        $str .= sprintf 'Major Penalty: <span class="w3-text-blue w3-large">%s</span><br>', $STATUS{$LOGS{$inRound}{IN_PEN_LANDING}};  
        $str .= '</td>';
        $str .= '<tr>';
    }
    $str .= '<tr class="w3-hide-small w3-large">';
    $str .= sprintf '<td style="text-align: center;">TOTAL</td>'; 
    $str .= sprintf '<td style="text-align: right;">%2.2f </td>', $inCol; 
    $str .= sprintf '<td style="text-align: right;">%2.2f </td>', $inHab; 
    $str .= sprintf '<td style="text-align: right;">%2.2f fl oz.</td>', $inWat;
    $str .= sprintf '<td style="text-align: right;">%2.2f fl oz.</td>', $inPay;
    $str .= sprintf '<td style="text-align: right;">---.</td>';
    $str .= sprintf '<td style="text-align: right;">---</td>';
    $str .= '</tr>';
    $str .= '<tr class="w3-hide-medium w3-hide-large w3-white">';
    $str .= '<td class="w3-large">';
    $str .= sprintf 'TOTAL<br>', $inRound; 
    $str .= sprintf '# of Colonists: <span class="w3-text-blue w3-large">%2.2f </span><br>', $inCol; 
    $str .= sprintf '# of Habitats: <span class="w3-text-blue w3-large">%2.2f </span><br>', $inHab; 
    $str .= sprintf 'Water: <span class="w3-text-blue w3-large">%2.2f </span>fl oz.<br>', $inWat; 
    $str .= sprintf 'Payload: <span class="w3-text-blue w3-large">%2.2f</span> lbs.<br>', $inPay; 
    $str .= '</td>';
    $str .= '<tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    $str .= '</tbody>';
    $str .= '</table>';
    
    
    return $str;
}
sub regularClassLogs(){
    my $teamIDX = shift;
    my $location = shift;
    my $Regular = new SAE::REGULAR($location);
    my %LOGS = %{$Regular->_getTeamScoreCard($teamIDX)};
    my %STATUS = (0=>"No", 1=>"Yes", ''=>'--');
    my $str;
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 5%;">Rnd</th>';
    $str .= '<th style="width: 10%;text-align: right;">L-Cargo (in)</th>';
    $str .= '<th style="width: 10%;text-align: right;">Wing Span (in)</th>';
    $str .= '<th style="width: 10%;text-align: right;">Den-Alt (ft)</th>';
    $str .= '<th style="width: 10%;text-align: right;"># of Balls</th>';
    $str .= '<th style="width: 15%;text-align: right;">Payload (lbs)</th>';
    $str .= '<th style="width: 10%;text-align: right;">Minor<br>Penalty</th>';
    $str .= '<th style="width: 10%;text-align: right;">Major<br>Penalty</th>';
    $str .= '<th style="width: 10%;text-align: right;">Prediction<br>pt. Bonus</th>';
    $str .= '<th style="width: 10%;text-align: right;">Flight Score</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $inRound (sort {$a <=> $b} keys %LOGS) {
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td style="text-align: center;">%d</td>', $inRound;        
        $str .= sprintf '<td style="text-align: right;">%2.2f in.</td>', $LOGS{$inRound}{IN_LCARGO};        
        $str .= sprintf '<td style="text-align: right;">%2.2f in.</td>', $LOGS{$inRound}{IN_SPAN};        
        $str .= sprintf '<td style="text-align: right;">%2.2f ft.</td>', $LOGS{$inRound}{IN_DENSITY};   
        $str .= sprintf '<td style="text-align: right;">%2d</td>', $LOGS{$inRound}{IN_SPHERE};    
        $str .= sprintf '<td style="text-align: right;">%2.2f lbs.</td>', $LOGS{$inRound}{IN_WEIGHT};    
        $str .= sprintf '<td style="text-align: right;">%s</td>', $STATUS{$LOGS{$inRound}{IN_PEN_MINOR}};    
        $str .= sprintf '<td style="text-align: right;">%s</td>', $STATUS{$LOGS{$inRound}{IN_PEN_LANDING}};    
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $LOGS{$inRound}{IN_BONUS};   
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $LOGS{$inRound}{IN_FS}; 
        $str .= '</tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large w3-white">';
        $str .= '<td>';
        $str .= sprintf 'Flight Attempt: <span class="w3-text-blue w3-large">#%d</span>      <br>', $inRound;
        $str .= sprintf 'L-CARGO: <span class="w3-text-blue">%2.2f</span> in. <br>', $LOGS{$inRound}{IN_LCARGO};
        $str .= sprintf 'Wing Span: <span class="w3-text-blue">%2.2f</span> in.<br>', $LOGS{$inRound}{IN_SPAN};
        $str .= sprintf 'DenAlt: <span class="w3-text-blue">%2.2f</span> ft.  <br>', $LOGS{$inRound}{IN_DENSITY};
        $str .= sprintf '# of Balls: <span class="w3-text-blue">%d</span>  <br>', $LOGS{$inRound}{IN_SPHERE};
        $str .= sprintf 'Payload: <span class="w3-text-blue">%2.2f</span> lbs. <br>', $LOGS{$inRound}{IN_WEIGHT};
        $str .= sprintf 'Minor Penalty: <span class="w3-text-blue">%s</span><br>', $STATUS{$LOGS{$inRound}{IN_PEN_MINOR}};
        $str .= sprintf 'Major Penalty: <span class="w3-text-blue">%s</span><br>', $STATUS{$LOGS{$inRound}{IN_PEN_LANDING}};
        $str .= sprintf 'Prediction Bonus: <span class="w3-text-blue">%2.2f</span> pts<br>', $LOGS{$inRound}{IN_BONUS};
        $str .= sprintf 'Flight Score: <span class="w3-text-blue">%2.2f</span> pts<br>', $LOGS{$inRound}{IN_FS};

        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    
    
    return $str;
}
##======================== Flgiht Status Updates =========================================
sub sae_updateFlightCardField(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $inValue = $q->param('inValue');
    my $txField = $q->param('txField');
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $str;
    if ($txField eq 'FK_WEATHER_IDX') {
        my $Weather = new SAE::WEATHER();
        my %DATA = %{$Weather->_getWeather($inValue)};
        foreach $field (sort keys %DATA ) {
            $Flight->_updateFlightField($flightIDX, $field, $DATA{$field}, $teamIDX);
        }
    } else {
        $Flight->_updateFlightField($flightIDX, $txField, $inValue, $teamIDX);
    }
    # my $str = $Flight->_updateFlightField($flightIDX, $txField, $inValue, $teamIDX);
    return ();
}
sub sae_deleteFlightLog(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $inType = $q->param('inType');
    my $flightIDX = $q->param('flightIDX');
    my $classIDX = $q->param('classIDX');
    my $inNumber = substr("000".$q->param('inNumber'),-3,3);
    
    my $Flight = new SAE::FLIGHT();
    $Flight->_deleteFlightCardById($flightIDX);
    my $btn = $Flight->_tempCheckOutButton($teamIDX, 1);
    my %DATA;
    $DATA{btn} = $btn;
    $DATA{idx} = $teamIDX;
    $DATA{ype} = $inType;
    if ($inType == 1){$Flight->_updateFlightButton($teamIDX, $btn);} 
    my $json = encode_json \%DATA;
    return ($json);
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

###### REGULAR ########
sub sae_recordFlightCard(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $round = $q->param('round');
    my $fltIDX = $q->param('flightIDX');
    my $location = $q->param('location');
    my $Flight = new SAE::FLIGHT();
    my $Logs = new SAE::TB_FLIGHT();
    my $Weather = new SAE::WEATHER();
    my $Team = new SAE::TEAM($teamIDX);
    my %TEAM = %{$Team->_getTeamData()};
    my $inNumber = $TEAM{IN_NUMBER};
    my $classIDX = $TEAM{FK_CLASS_IDX};
    my %WEATHER = %{$Weather->_getWeatherByHours( $location , 8 )};
    my %FLIGHTS = %{$Flight->_getFlightCardData($teamIDX)};
    
    my $str;
    $str = '<div class="w3-container" style="padding: 1px!important">';
    
    my $activeTab = 'w3-white w3-border-left w3-border-top w3-border-right';
    $str .= '<div class="w3-bar w3-blue-grey">';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink %s " onclick="sae_openTab(this, \'%s\');">Logs</button>', $activeTab,'Logs';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">Data</button>', 'Data';
    $str .= '</div>';
    
    $str .= '<div id="Logs" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs ">';
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Round</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>L-Cargo<br><label class="w3-small">(inches)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Wing Span<br><label class="w3-small">(inches)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Time of Flight<br><label class="w3-small">(hh:mm:ss)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p># of Balls</p></div>';
    
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Payload<br><label class="w3-small">(lbs.)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Minor Pen.<br><label class="w3-small">(Rule 3.5)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Major Pen.<br><label class="w3-small">(Rule 3.9)</label></p></div>';
    $str .= '<div class="w3-col l4 w3-center w3-hide-small w3-hide-medium"><p>Check In As...</p></div>';
    $str .= '</div>';

    foreach $inRound (sort {$a <=> $b} keys %FLIGHTS) {

        my $flightIDX = $FLIGHTS{$inRound}{PK_FLIGHT_IDX};
        $Logs->getRecordById($flightIDX);
        my $weatherIDX = $Logs->getFkWeatherIdx();
        my %MYWEATHER = %{$Weather->_getSelectedWeather($weatherIDX)};
        my %HOURS = (%WEATHER, %MYWEATHER);
        my $tabIndex = $inRound*100;
        if ($flightIDX == $fltIDX) {
            $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border w3-pale-blue w3-card-4 w3-round w3-margin-top w3-margin-bottom" style="padding: 5px;">', $flightIDX;
        } else {
            $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border w3-round" style="padding: 5px;">', $flightIDX;
        }
        $str .= sprintf '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Round</span><input  tabindex="'.$tabIndex.'" class="w3-input w3-border w3-round w3-center" type="number" value="%d" ></div>', $inRound;
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Length of Cargo</span>';
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0" type="number" placeholder="0.0" value="%2.2f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></div>',$Logs->getInLcargo(), $flightIDX, 'IN_LCARGO', $teamIDX ;
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Wing Span</span>';
        $str .= sprintf '<input  tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.1" min="0"  type="number" placeholder="0.0" value="%2.2f"  onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></div>',$Logs->getInSpan(),$flightIDX, 'IN_SPAN', $teamIDX ;
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Time of Flight</span>';
        
        # $str .= $weatherIDX;
        $str .= sprintf '<select tabindex="'.($tabIndex++).'" ID="TX_TIME_%d" class="w3-border w3-input w3-round" style="height: 40px;" onchange="sae_updateTimeOfFlight(this, %d);">', $flightIDX, $flightIDX;
        $str .= '<option value="0" selected disabled>+ Time</option>';
        foreach $hourIDX (sort {$b <=> $a} keys %HOURS){
            my $selected = '';
            if ($hourIDX == $weatherIDX) {$selected = 'selected'}
            $str .= sprintf '<option value="%d" '.$selected.'>%s</option>', $hourIDX, $HOURS{$hourIDX}{TS_LOCAL};
        }
        $str .= '</select>';
        $str .= '</div>';
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left"># of Balls</span>';
        $str .= sprintf '<input  tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0" type="number" placeholder="0.0" value="%s" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);" ></div>',$Logs->getInSphere(),$flightIDX, 'IN_SPHERE', $teamIDX;
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">Payload (lbs)</span>';
        $str .= sprintf '<input ID="WEIGHT_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0"  type="number" placeholder="0.00" value="%2.2f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInWeight(),$flightIDX, 'IN_WEIGHT', $teamIDX ;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 4px;" onclick="sae_openCalculator(%d, \'WEIGHT_\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Minor Pen.</span>';
        my $minor = $Logs->getInPenMinor();
        my $minorChecked = '';
        if ($minor>0){$minorChecked = 'checked'}
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" type="checkbox" data-key="IN_PEN_MINOR" %s class="sae-checked-item w3-check" value="1" onClick="sae_updateLandingPenalty(this, %d, \'%s\');">', $minorChecked, $flightIDX, 'IN_PEN_MINOR';
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Minor Pen.</span>';
        my $major = $Logs->getInPenLanding();
        my $majorChecked = '';
        if ($major>0){$majorChecked = 'checked'}
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" type="checkbox" data-key="IN_PEN_MAJOR" %s class="sae-checked-item w3-check" value="1" onClick="sae_updateLandingPenalty(this, %d, \'%s\');">', $majorChecked, $flightIDX, 'IN_PEN_LANDING';
        $str .= '</div>';
        
        # $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Major Pen.</span><input class="w3-input w3-border w3-round" type="text"></div>';
        $str .= '<div class="w3-col l4 w3-right" style="text-align: right!important;">';
        my $Status = $Logs->getInStatus();
        if ($flightIDX == $fltIDX){
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-green w3-hover-blue w3-card-2 w3-round w3-small"       style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Good</button>',   $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-blue w3-card-2 w3-round w3-small"  style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">No Fly</button>', $flightIDX, 2, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-orange w3-hover-blue w3-card-2 w3-round  w3-small"     style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Crash</button>',  $flightIDX, 3, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round w3-small" style="width: 70px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small" style="width: 70px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Cancel</button>', $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
        } else {
            $str .= sprintf '<select ID="flightState_'.$flightIDX.'" class="w3-select w3-margin-bottom w3-mobile w3-margin-right w3-border w3-round" style="width: 50%; height: 40px; padding: 3px;" onchange="sae_updateFlightState(this, %d, %d, %d, %d, %d);">', $flightIDX, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<option value="0" selected>No Status</option>';
            foreach $inStatus (sort {$a<=>$b} keys %STATUS){
                my $selected = '';
                if ($Status == $inStatus){$selected = 'selected'}
                $str .= sprintf '<option value="%d" %s>%s</option>', $inStatus, $selected, $STATUS{$inStatus};
            }

            $str .= '</select>';
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round w3-small" style="width: 70px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small" style="width: 70px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Delete</button>', $flightIDX, 0, $teamIDX, $inNumber, $classIDX, $inRound;
        }
        
        $str .= '</div>';
        $str .= '</div>';
        $str .= '<br class="w3-hide-large w3-hide-medium">';
    }
    $str .= '<br>'x3;
    $str .= '</div>';
    $str .= '</div>';
    
    $str .= '<div id="Data" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide  w3-padding">';
    $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col l6 w3-center w3-padding">';
        $str .= '<label>Prediction Slope</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round" type="number" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%2.6f" step="0.000001" max="0" >', 'IN_SLOPE', $teamIDX, $TEAM{IN_SLOPE};
        $str .= '</div>';
        
        $str .= '<div class="w3-col l6 w3-center w3-padding">';
        $str .= '<label>Predicted Payload (lbs)</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round" type="number" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%2.2f" step="0.01" min="0">', 'IN_YINT', $teamIDX, $TEAM{IN_YINT};
        $str .= '</div>';
    $str .= '</div>';
    $str .= '<br>'x3;
    $str .= '</div>';
    
    
    $str .= '</div>';
    $str .= "<br>" x3;
    return ($str);
}
###### ADVANCED #######
sub sae_recordFlightCard_Adv(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $round = $q->param('round');
    my $fltIDX = $q->param('flightIDX');
    my $Flight = new SAE::FLIGHT();
    my $Logs = new SAE::TB_FLIGHT();
    # my $Weather = new SAE::WEATHER();
    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($teamIDX);
    my $inNumber = $Team->getInNumber();
    my $classIDX = $Team->getFkClassIdx();
    # my %HOURS = %{$Weather->_getWeatherByHours( 27 , 8 )};
    my %FLIGHTS = %{$Flight->_getFlightCardData($teamIDX)};
    # my %STATUS = (1=>"Good Flight", 3=>"Crashed", 2=>"No Fly");
    my $str;
    # $str .= '<h3>Advance Class Logs</h3>';
    $str .= '<div class="w3-container">';
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium" style="width: 75px;"><p>Round</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p># Colonist<br><label class="w3-small">(Integer)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p># Habitat<br><label class="w3-small">(Integer)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Water<br><label class="w3-small">(lbs)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Payload<br><label class="w3-small">(lbs.)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Minor Pen.<br><label class="w3-small">(Rule 3.5)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Major Pen.<br><label class="w3-small">(Rule 3.9)</label></p></div>';
    $str .= '<div class="w3-col l5 w3-center w3-hide-small w3-hide-medium"><p>Check In As...</p></div>';
    $str .= '</div>';
    foreach $inRound (sort {$a <=> $b} keys %FLIGHTS) {
        
        my $flightIDX = $FLIGHTS{$inRound}{PK_FLIGHT_IDX};
        $Logs->getRecordById($flightIDX);
    #     my $weatherIDX = $Logs->getFkWeatherIdx();
        my $tabIndex = $inRound*100;
        if ($flightIDX == $fltIDX) {
            $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border w3-pale-blue w3-card-4 w3-round w3-margin-top w3-margin-bottom"" style="padding: 5px;">', $flightIDX;
        } else {
            $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border w3-round" style="padding: 5px;">', $flightIDX;
            # $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border-top "  style="padding: 5px;">', $flightIDX;
        }
        $str .= sprintf '<div class="w3-col l1 w3-center" style="width: 75px;"><span class="w3-hide-large w3-left" >Round</span><input  tabindex="'.$tabIndex.'" class="w3-input w3-border w3-round w3-center" type="number" value="%d" ></div>', $inRound;
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left"># Colonist(s)</span>';
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0" type="number" placeholder="0" value="%d"onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInColonist(), $flightIDX, 'IN_COLONIST', $teamIDX ;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left"># Habitat(s)</span>';
        $str .= sprintf '<input  tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0"  type="number" placeholder="0" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInHabitat(),$flightIDX, 'IN_HABITAT', $teamIDX ;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">Water (lbs)</span>';
        $str .= sprintf '<input ID="WATER_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.005" min="0"  type="number" placeholder="0.0" value="%2.3f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInWater(),$flightIDX, 'IN_WATER', $teamIDX ;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 4px;" onclick="sae_openCalculator(%d, \'WATER_\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">Payload (lbs)</span>';
        $str .= sprintf '<input ID="WEIGHT_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0"  type="number" placeholder="0.00" value="%2.2f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInWeight(),$flightIDX, 'IN_WEIGHT', $teamIDX ;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 4px;" onclick="sae_openCalculator(%d, \'WEIGHT_\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX;
        $str .= '</div>';
          


        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Minor Pen.</span>';
        my $minor = $Logs->getInPenMinor();
        my $minorChecked = '';
        if ($minor>0){$minorChecked = 'checked'}
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" type="checkbox" data-key="IN_PEN_MINOR" %s class="sae-checked-item w3-check" value="1" onClick="sae_updateLandingPenalty(this, %d, \'%s\');">', $minorChecked, $flightIDX, 'IN_PEN_MINOR';
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Minor Pen.</span>';
        my $major = $Logs->getInPenLanding();
        my $majorChecked = '';
        if ($major>0){$majorChecked = 'checked'}
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" type="checkbox" data-key="IN_PEN_MAJOR" %s class="sae-checked-item w3-check" value="1" onClick="sae_updateLandingPenalty(this, %d, \'%s\');">', $majorChecked, $flightIDX, 'IN_PEN_LANDING';
        $str .= '</div>';
        
        $str .= '<div class="w3-col l5 w3-right" style="text-align: right!important;">';
        my $Status = $Logs->getInStatus();
        if ($flightIDX == $fltIDX){
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-green w3-hover-blue w3-card-2 w3-round w3-small"          style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Good</button>',   $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-blue w3-card-2 w3-round  w3-small"    style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">No Fly</button>', $flightIDX, 2, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-orange w3-hover-blue w3-card-2 w3-round  w3-small"        style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Crash</button>',  $flightIDX, 3, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round  w3-small" style="width: 70px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, $d);">Notes</button>', $flightIDX, $teamIDX;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small" style="width: 70px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Cancel</button>', $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
        } else {
            $str .= sprintf '<select ID="flightState_'.$flightIDX.'" class="w3-select w3-margin-bottom w3-mobile w3-margin-right w3-border w3-round w3-padding" style="width: 50%; height: 40px;" onchange="sae_updateFlightState(this, %d, %d, %d, %d, %d);">', $flightIDX, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<option value="0" selected>No Status</option>';
            foreach $inStatus (sort {$a<=>$b} keys %STATUS){
                my $selected = '';
                if ($Status == $inStatus){$selected = 'selected'}
                $str .= sprintf '<option value="%d" %s>%s</option>', $inStatus, $selected, $STATUS{$inStatus};
            }

            $str .= '</select>';
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round  w3-small" style="width: 70px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small" style="width: 70px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Delete</button>', $flightIDX, 0, $teamIDX, $inNumber, $classIDX, $inRound;
        }
        
        $str .= '</div>';
        $str .= '</div>';
        $str .= '<br class="w3-hide-large w3-hide-medium">';
    }
    $str .= '</div>';
    $str .= "<br>" x3;
    return ($str);
}
###### MICRO #######
sub sae_recordFlightCard_Mic(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $round = $q->param('round');
    my $fltIDX = $q->param('flightIDX');
    my $Flight = new SAE::FLIGHT();
    my $Logs = new SAE::TB_FLIGHT();
    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($teamIDX);
    my $inNumber = $Team->getInNumber();
    my $classIDX = $Team->getFkClassIdx();
    my %FLIGHTS = %{$Flight->_getFlightCardData($teamIDX)};
    my $str;
    # $str .= '<h3>Advance Class Logs</h3>';
    $str .= '<div class="w3-container">';
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Round</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>L-Boxes<br>Good</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>L-Boxes<br>Damaged</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>S-Boxes<br>Good</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>S-Boxes<br>Damaged</p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Payload<br><label class="w3-small">(lbs.)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Time of Flight<br><label class="w3-small">(Seconds)</label></p></div>';
    
    
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Minor Pen.<br><label class="w3-small">(Rule 3.5)</label></p></div>';
    $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Major Pen.<br><label class="w3-small">(Rule 3.9)</label></p></div>';
    $str .= '<div class="w3-col l3 w3-center w3-hide-small w3-hide-medium"><p>Check In As...</p></div>';
    $str .= '</div>';
    foreach $inRound (sort {$a <=> $b} keys %FLIGHTS) {
        
        my $flightIDX = $FLIGHTS{$inRound}{PK_FLIGHT_IDX};
        $Logs->getRecordById($flightIDX);
    #     my $weatherIDX = $Logs->getFkWeatherIdx();
        my $tabIndex = $inRound*100;
        if ($flightIDX == $fltIDX) {
            $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border w3-pale-blue w3-card-4 w3-round w3-margin-top w3-margin-bottom"" style="padding: 5px">', $flightIDX;
        } else {
            $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border w3-round" style="padding: 5px;">', $flightIDX;
            # $str .= sprintf '<div ID="FlightRecord_%d" class="w3-row w3-border-top "  style="padding: 5px;">', $flightIDX;
        }
        $str .= sprintf '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Round</span><input  tabindex="'.$tabIndex.'" class="w3-input w3-border w3-round w3-center" type="number" value="%d" ></div>', $inRound;
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Large Box</span>';
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0" type="number" placeholder="0" value="%d"onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInLarge(), $flightIDX, 'IN_LARGE' , $teamIDX;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">L-Box Damage</span>';
        $str .= sprintf '<input ID="LBD_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0"  type="number" placeholder="0.00" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInLbDamage(),$flightIDX, 'IN_LB_DAMAGE', $teamIDX ;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Small Box</span>';
        $str .= sprintf '<input  tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0"  type="number" placeholder="0" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInSmall(),$flightIDX, 'IN_SMALL', $teamIDX ;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">S-Box Damage</span>';
        $str .= sprintf '<input ID="SBD_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="1" min="0"  type="number" placeholder="0.00" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInSbDamage(),$flightIDX, 'IN_SB_DAMAGE', $teamIDX ;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">Payload (lbs)</span>';
        $str .= sprintf '<input ID="WEIGHT_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0"  type="number" placeholder="0.00" value="%2.2f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInWeight(),$flightIDX, 'IN_WEIGHT', $teamIDX ;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 4px;" onclick="sae_openCalculator(%d, \'WEIGHT_\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center w3-display-container"><span class="w3-hide-large w3-left">Time of Flight (lbs)</span>';
        $str .= sprintf '<input ID="TOF_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0"  type="number" placeholder="0.00" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInTof(),$flightIDX, 'IN_TOF', $teamIDX ;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 4px;" onclick="sae_openTimeCalculator(%d, \'TOF_\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX;
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Minor Penalty</span>';
        my $minor = $Logs->getInPenMinor();
        my $minorChecked = '';
        if ($minor>0){$minorChecked = 'checked'}
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" type="checkbox" data-key="IN_PEN_MINOR" %s class="sae-checked-item w3-check" value="1" onClick="sae_updateLandingPenalty(this, %d, \'%s\');">', $minorChecked, $flightIDX, 'IN_PEN_MINOR';
        $str .= '</div>';
        
        $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Major Penalty</span>';
        my $major = $Logs->getInPenLanding();
        my $majorChecked = '';
        if ($major>0){$majorChecked = 'checked'}
        $str .= sprintf '<input tabindex="'.($tabIndex++).'" type="checkbox" data-key="IN_PEN_MAJOR" %s class="sae-checked-item w3-check" value="1" onClick="sae_updateLandingPenalty(this, %d, \'%s\');">', $majorChecked, $flightIDX, 'IN_PEN_LANDING';
        $str .= '</div>';

        $str .= '<div class="w3-col l3 w3-right" style="text-align: right!important;">';
        my $Status = $Logs->getInStatus();
        if ($flightIDX == $fltIDX){
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-green w3-hover-blue w3-card-2 w3-round w3-small"         style="width: 60px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Good</button>',   $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-blue w3-card-2 w3-round w3-small"    style="width: 60px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">No Fly</button>', $flightIDX, 2, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-orange w3-hover-blue w3-card-2 w3-round  w3-small"       style="width: 60px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Crash</button>',  $flightIDX, 3, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round w3-small" style="width: 60px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small"                    style="width: 60px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Cancel</button>', $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
        } else {
            $str .= sprintf '<select ID="flightState_'.$flightIDX.'" class="w3-select w3-margin-bottom w3-mobile w3-margin-right w3-border w3-round w3-padding w3-small" style="width: 35%; height: 40px;" onchange="sae_updateFlightState(this, %d, %d, %d, %d, %d);">', $flightIDX, $teamIDX, $inNumber, $classIDX, $inRound;
            $str .= sprintf '<option value="0" selected>No Status</option>';
            foreach $inStatus (sort {$a<=>$b} keys %STATUS){
                my $selected = '';
                if ($Status == $inStatus){$selected = 'selected'}
                $str .= sprintf '<option value="%d" %s>%s</option>', $inStatus, $selected, $STATUS{$inStatus};
            }

            $str .= '</select>';
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round w3-small" style="width: 60px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
            $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small" style="width: 60px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Delete</button>', $flightIDX, 0, $teamIDX, $inNumber, $classIDX, $inRound;
        }
        
        $str .= '</div>';
        $str .= '</div>';
        $str .= '<br class="w3-hide-large w3-hide-medium">';
    }
    $str .= '</div>';
    $str .= "<br>" x3;
    return ($str);
}
##======================== Flight Notes ==================================================
sub sae_updateTeamInfo(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $teamIDX = $q->param('teamIDX');
    my $txField = $q->param('txField');
    my $inValue = $q->param('inValue');
    $Flight->_updateTeamInfo($txField, $inValue, $teamIDX);
    return;
}
sub sae_updateFlightStatus(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $Tech = new SAE::TECH();
    my $teamIDX = $q->param('teamIDX');
    my $inValue = $q->param('inValue');
    my $flightIDX = $q->param('flightIDX');
    my $classIDX = $q->param('classIDX');
    my $inRound = $q->param('inRound');
    my $reInspection = $q->param('reInspection');
    my $inNumber = substr("000".$q->param('inNumber'),-3,3);
    $Flight->_updateFlightField($flightIDX, 'IN_STATUS', $inValue, $teamIDX);
    my $inFlightStatus = 1;
    my $logBtn = $Flight->_tempCheckOutButton($teamIDX, $inFlightStatus);
    if($reInspection){
        $inFlightStatus = 3;
        # $todoIDX, $flightIDX, $teamIDX, $boArchive
        # $logBtn = $Flight->_templateReinspectionButton($flightIDX, $teamIDX, $inRound, $inFlightStatus);
        $logBtn = $Tech->_generateLogButton(0, $flightIDX, $teamIDX, $inFlightStatus);
    }
    $Flight->_updateFlightButton($teamIDX, $inFlightStatus, $logBtn);
    # return ($btn);
    my %DATA;
    $DATA{logBtn} = $logBtn;
    $DATA{idx} = $teamIDX;
    my $json = encode_json \%DATA;
    return ($json);
    
}
sub sae_saveFlightNotes(){
    print $q->header();
    my $Airboss = new SAE::AIRBOSS();
    my $teamIDX = $q->param('teamIDX');
    my $eventIDX = $q->param('eventIDX');
    my $inValue = uri_unescape($q->param('inValue'));
    my $flightIDX = $q->param('flightIDX');
    my $newNote = $q->param('newNote');
    my $str;
    if ($flightIDX){
        if ($newNote > 0 ) {
            $str = $Airboss->_saveNotes($inValue, $teamIDX, $eventIDX, $flightIDX);
            # $str .= " - New: $inValue, $teamIDX, $eventIDX, $flightIDX";
        } else {
            $str =$Airboss->_updateNotes($inValue, $flightIDX);
            # $str .= " - Update: \$inValue=$inValue, \$flightIDX=$flightIDX";
        }
    } else {
        $str = $Airboss->_saveNotes($inValue, $teamIDX, $eventIDX, $flightIDX);
        # $str .= ' - New';
    }
    # $str .= " \$newNote=$newNote";
    return ();
}
sub sae_showFlightNotes(){
    print $q->header();
    my $Util = new SAE::Common();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $Airboss = new SAE::AIRBOSS();
    my $Comments = $Airboss->_getNotesByFlightID($flightIDX);
    my %NOTES = %{$Airboss->_getFlightNotes($teamIDX)};
    my $str;
    my $notes = $Util->removeBr($Comments);
    $str = '<dic class="w3-container">';
    $str .= '<label>Notes</lable>';
    $str .= sprintf '<textarea ID="NOTES_'.$flightIDX.'" class="w3-input w3-border w3-round" style="max-width: 100%; height: 75px;">%s</textarea>', $notes;
    if ($notes){
        $str .= sprintf '<div class="w3-center w3-margin-top"><button class="w3-button w3-border w3-round w3-green w3-hover-blue" onclick="sae_saveFlightNotes(this, %d, %d, 0);">Update</button></div>', $flightIDX, $teamIDX;
    } else {
        $str .= sprintf '<div class="w3-center w3-margin-top"><button class="w3-button w3-border w3-round w3-green w3-hover-blue" onclick="sae_saveFlightNotes(this, %d, %d, 1);">Save</button></div>', $flightIDX, $teamIDX;
    }
    $str .= '<hr>';
    $str .= '<b class="w3-margin-left">(<a href="javascript:void(0);" onclick="sae_expandNotes();">View Note History</a>)</b>';
    foreach $notesIDX  (sort {$b<=>$a} keys %NOTES) {
        if ($NOTES{$notesIDX}{FK_FLIGHT_IDX}) {
            $str .= sprintf '<p class="w3-border-bottom w3-small crash-notes" style="padding: 10px; display: none;"><b class="w3-text-blue">Judge\'s Notes:</b><br>%s</p>', $NOTES{$notesIDX}{CL_NOTES};
        } else {
            $str .= sprintf '<p class="w3-border-bottom w3-small crash-notes" style="padding: 10px; display: none;"><b class="w3-text-green">Flight-Line Notes:</b><br>%s</p>', $NOTES{$notesIDX}{CL_NOTES};
        }
        
    }
    $str .= '</div>';
    return ($str);
}
##======================== Penalties =====================================================
##======================== Crash =====================================================
sub sae_openClearCrash(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $flightIDX = $q->param('flightIDX');
    my $classIDX = $q->param('classIDX');
    my $teamIDX = $q->param('teamIDX');
    my $inNumber = $q->param('inNumber');
    my %CRASH = %{$Flight->_getCrashInspectionItems($flightIDX)};
    my $str = '<div class="w3-container w3-padding">';
    $str .= sprintf '<div class="w3-container w3-large">';
    $str .= sprintf '<h3>Team #: %03d</h3>', $inNumber;
    $str .= sprintf '<h6>Items to be Re-inspected</h6>';
    $str .= '<div class="w3-row w3-border-bottom w3-round">';
    foreach $crashIDX (sort {$CRASH{$a}{TX_ITEM} cmp $CRASH{$b}{TX_ITEM}} keys  %CRASH){
        $str .= sprintf '<div class="w3-mobile w3-half w3-padding w3-margin-right w3-border w3-margin-bottom w3-round  w3-hover-pale-yellow"><i class="fa fa-wrench" aria-hidden="true"></i> %s</div>', $CRASH{$crashIDX}{TX_ITEM};
    }
    $str .= '</div>';
    $str .= '<label class="w3-margin-top">Notes:</label><br>';
    $str .= sprintf '<p>%s</p>', $Flight->_getCrashNotes($flightIDX);
    $str .= '<div class="w3-margin-top w3-center">';
    $str .= sprintf '<button class="w3-mobile w3-margin-top w3-button w3-border w3-green w3-hover-blue w3-bar-item w3-round w3-margin-right" onclick="sae_clearReinspection(this, %d, %d, %d, \'%03d\')">Clear to fly</button>', $flightIDX, $teamIDX, $classIDX, $inNumber;
    $str .= sprintf '<button class="w3-mobile w3-margin-top w3-button w3-border w3-hover-red w3-round" onclick="sae_deleteCrashReport(this, %d, %d)">Delete Crash Report</button>', $flightIDX, $teamIDX;
    $str .= '</div>';
    $str .= '</div>';
    return($str);
}
sub sae_deleteCrashReportCard(){
    print $q->header();
    my $todoIDX = $q->param('todoIDX');
    my $flightIDX = $q->param('flightIDX');
    my $CrashReport = new SAE::FLIGHT();
    $CrashReport->_deleteCrashReportCard($todoIDX);
    $CrashReport->_deleteCrashNotes($flightIDX);
    my %DATA;
    $DATA{todoIDX} = $todoIDX;
    $DATA{flightIDX} = $flightIDX;
    my $json = encode_json \%DATA;
    return ($json);
}
sub sae_deleteCrashReport(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $CrashReport = new SAE::FLIGHT();
    $CrashReport->_deleteCrashReport($flightIDX);
    $CrashReport->_deleteCrashNotes($flightIDX);
    my $logBtn = $CrashReport->_tempCheckOutButton($teamIDX, 1);
    # return ($btn);
    my %DATA;
    $DATA{logBtn} = $btn;
    $DATA{idx} = $teamIDX;
    $DATA{flightIDX} = $flightIDX;
    $DATA{techBtn} = '';
    my $json = encode_json \%DATA;
    return ($json);
}
sub sae_clearReinspection(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $classIDX = $q->param('classIDX');
    my $txNumber = $q->param('txNumber');
    my $inFlightStatus = 1;
    my $Flight = new SAE::FLIGHT();
    my $Tech = new SAE::TECH();
    $Flight->_updateReinspectionItems( $teamIDX, $flightIDX, $inFlightStatus );
    my $logBtn = $Flight->_tempCheckOutButton($teamIDX, $inFlightStatus);
    my $techBtn = $Tech->_generateTechButton(0, $flightIDX, $teamIDX, $inFlightStatus); #$todo = 0; last variable = inStatus.  1=passed Inspection.  0 = did not pass Inspection
    $Flight->_updateFlightButton($teamIDX, $inFlightStatus, $logBtn);
    my %DATA;
    $DATA{logBtn} = $logBtn;
    $DATA{techBtn} = $techBtn;
    $DATA{idx} = $teamIDX;
    $DATA{flightIDX} = $flightIDX;
    my $json = encode_json \%DATA;
    return ($json);
    # return ($btn);
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
    my $col = 4;
    my @LIST = sort {lc($ITEMS{$a}{TX_ITEM}) cmp lc($ITEMS{$b}{TX_ITEM})} keys %ITEMS;
    $str = '<div class="w3-container w3-padding" style="height: 450px; overflow: auto;">';
    $str .= '<p>The following componets require re-inspection prior to next flight</p>';
    $str .= '<table class="w3-table w3-striped w3-hoverable w3-bordered">';
    for my $i (0 .. $#LIST){
        if (($i % $col)==0){
            $str .= '<tr>';
        }
        $str .= sprintf '<td class="w3-small"><input type="checkbox" class="sae-inspection_item w3-check" value="%s"><label class="w3-margin-left">%s</lable></td>', $ITEMS{$LIST[$i]}{TX_ITEM}, $ITEMS{$LIST[$i]}{TX_ITEM};
        #   print $LIST[$i]."<br>";
        if ((($i-($col-1)) % $col)==0){
            $str .= '</tr>';
        }
    }
    $str .= '</table>';
    $str .= '<div class="w3-container">';
    $str .= '<label class="w3-small">Additional Notes</label>';
    $str .= '<textarea class="w3-input w3-border sae-input w3-round" style="height: 100px; min-width: 100%; max-width: 100%;" data-key="CL_COMMENT"></textarea>';
    $str .= '</div>';
    $str .= '<center class="w3-margin-top">';
    $str .= sprintf '<button class="w3-button w3-border w3-round-large" onclick="sae_submitCrashReport(this, %d, %d);">Submit</button>', $flightIDX, $teamIDX;
    $str .= '</center>';
    $str .= '</div>';
    return ($str);
}
sub sae_submitCrashReport(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $teamIDX = $q->param('teamIDX');
    my $eventIDX = $q->param('eventIDX');
    my $Flight = new SAE::FLIGHT();
    my $Tech = new SAE::TECH();
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $todoIDX = $Flight->_submitCrashReport($flightIDX , \%DATA);
    $Flight->_updateToDoFlightCard($flightIDX, $todoIDX);
    my @ITEMS = split(";",$DATA{CL_DESCRIPTION});
    foreach $item (@ITEMS){
        $Flight->_recordInspectionItem($item, $teamIDX, $flightIDX);
    }
    $Flight->_recordInspectionNotes($DATA{CL_COMMENT}, $teamIDX, $flightIDX, $eventIDX);
    my $btn = $Tech->_generateTechButton($todoIDX, $flightIDX, $teamIDX, 0);
    my %DATA;
    $DATA{btn} = $btn;
    $DATA{idx} = $teamIDX;
    my $json = encode_json \%DATA;
    return ($json);
    # return (1);
}
##======================== Flgihts =====================================================
##### REGULAR CLASS ###########
sub sae_openCheckoutCard(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $round = $q->param('round');
    my $teamIDX = $q->param('teamIDX');
    my $classIDX = $q->param('classIDX');
    my $inNumber = $q->param('inNumber');
    my $location = $q->param('location');
    
    my %FLIGHTS = %{$Flight->_getCardStatusByEvent($location)};
    my %HISTORY = %{$Flight->_getCrashHistory($teamIDX)};
    
    my $btn = sprintf '<button class="w3-white w3-mobile w3-hover-blue w3-button w3-border w3-round-large w3-margin-right" onclick="$(this).close();sae_recordFlightCard(this, 0, %d, \'%03d\', 0);">View Flight Logs</button>',$teamIDX, $inNumber;
    if ($classIDX==2){
        $btn = sprintf '<button class="w3-white w3-mobile w3-hover-blue w3-button w3-border w3-round-large " onclick="$(this).close();sae_recordFlightCard_Adv(this, 0, %d, \'%03d\', 0);">View Flight Logs</button>',$teamIDX, $inNumber;
    }
    if ($classIDX==3){
        $btn = sprintf '<button class="w3-white w3-mobile w3-hover-blue w3-button w3-border w3-round-large " onclick="$(this).close();sae_recordFlightCard_Mic(this, 0, %d, \'%03d\', 0);">View Flight Logs</button>',$teamIDX, $inNumber;
    }
    my $str = '<div class="w3-margin w3-padding w3-container">';
    $str .= '<label for="sae_roundSelection">Flight Round';
    $str .= '<select ID="sae_roundSelection" class="w3-select w3-border w3-round w3-padding"> ';
    for (my $r = 1; $r<=20; $r++){
        if (exists $FLIGHTS{$teamIDX}{$r}){next}
        my $selected = '';
        my $selectedClass='';
        if ($round == $r){$selected = 'selected'; $selectedClass='w3-pale-yellow'}
        $str .= sprintf '<option class="%s" value="%d" %s>%s</option>', $selectedClass, $r, $selected, 'Round '.$r;
    }
    $str .= '</select></label>';
    $str .= '<div class="w3-container w3-mobile w3-margin-top" style="text-align: right;">';
    $str .= $btn;
    $str .= '<button class="w3-green w3-mobile w3-hover-blue w3-button w3-border w3-round-large w3-card-2" style="width: 120px;" ';
    $str .= sprintf 'onclick="sae_checkoutFlightLog(this, %d, %d, %d);">Checkout</button>', $teamIDX, $classIDX, $inNumber;
    $str .= '</div>';
    if (scalar (keys %HISTORY)>0){
        $str .= '<div class="w3-margin-top w3-topbar">';
        $str .= '<a class="w3-small" href="javascript:void(0);" onclick="sae_expandNotes();">Re-inspection Log(s)</a>';
            foreach $todoIDX (sort {$b<=>$a} keys %HISTORY) {
                my $flightIDX = $HISTORY{$todoIDX}{FK_FLIGHT_IDX};
                $str .= sprintf '<div ID="HISTORY_TODO_%d" class="w3-panel w3-leftbar w3-border-red w3-pale-red w3-mobile w3-display-container w3-padding w3-small crash-notes" style="display:none; ">', $todoIDX;
                $str .= sprintf '(Round: %d)<br><div style="margin-right: 30px;">%s</div>', $HISTORY{$todoIDX}{IN_ROUND}, $HISTORY{$todoIDX}{CL_DESCRIPTION};
                $str .= sprintf '<span class="w3-display-topright w3-transparent w3-button w3-round w3-hover-red" onclick="sae_deleteCrashReportCard(%d, %d);"><i class="fa fa-times" aria-hidden="true"></i></span>', $todoIDX, $flightIDX;
                $str .= sprintf '</div>';
            }
        $str .= '</div>';
    }
    $str .= '</div>';

    return($str);
    
}
sub sae_checkoutFlightLog(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $inRound = $q->param('round');
    my $classIDX= $q->param('classIDX');
    my $inNumber = sprintf '%03d', $q->param('inNumber'); #substr("000".$q->param('inNumber'),-3,3);
    my $location = $q->param('location');
    my $Flight = new SAE::FLIGHT();
    my $Team = new SAE::TEAM($teamIDX);
    my %TEAM = %{$Team->_getTeamData()};
    my $inFlightStatus = 2;
    my $flightIDX = $Flight->_createFlightCard($teamIDX , $inRound , $location, $inFlightStatus);
    my $btn = $Flight->_templateCheckInButton_Reg($flightIDX, $teamIDX, $inRound, $inFlightStatus);
    if ($classIDX==2) {      ## Advanced Class
        $btn = $Flight->_templateCheckInButton_Adv($flightIDX, $teamIDX, $inRound, $inFlightStatus);
    } elsif ($classIDX==3) { ## Micro Class
        $btn = $Flight->_templateCheckInButton_Mic($flightIDX, $teamIDX, $inRound, $inFlightStatus);
    } 
    $Flight->_updateFlightButton($teamIDX, $inFlightStatus, $btn);
    my %DATA;
    $DATA{btn} = $btn;
    $DATA{idx} = $teamIDX;
    my $json = encode_json \%DATA;
    return ($json);
    
    
    # return ($btn);
}
##======================== Calculators =====================================================
sub sae_openTimeCalculator(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $txtID = $q->param('txtID');
    my $minute= $q->param('minute');
    my $second = $q->param('seconds');
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<lable for="IN_MINUTE">Minute(s)</label>';
    $str .= sprintf '<input id="IN_MINUTE" class="w3-input w3-border w3-round" type="number" value="%d" placeholder="0" step="1" min="0" max="60">', $minute;
    $str .= '<lable class="w3-margin-top" for="IN_SECOND">second(s)</label>';
    $str .= sprintf '<input id="IN_SECOND" class="w3-input w3-border w3-round" type="number" value="%d" placeholder="0" step="1" min="0" max="60">', $second;
    $str .= '<center class="w3-margin-top">';
    $str .= sprintf '<button class="w3-button w3-green w3-border w3-round" onclick="sae_convertTime(this, %d, \'%s\');">Save</button>', $flightIDX, $txtID;
    $str .= '</center>';
    $str .= '</div>';
    return($str);
}
sub sae_openCalculator(){
    print $q->header();
    my $flightIDX = $q->param('flightIDX');
    my $txtID = $q->param('txtID');
    my $lbs= $q->param('lbs');
    my $ozs = $q->param('ozs');
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<lable for="IN_POUND">Pounds (lb)</label>';
    $str .= sprintf '<input id="IN_POUND" class="w3-input w3-border w3-round" type="number" value="%d" placeholder="0" step="1" min="0">', $lbs;
    $str .= '<lable class="w3-margin-top" for="IN_OUNCE">Ounces (oz)</label>';
    $str .= sprintf '<input id="IN_OUNCE" class="w3-input w3-border w3-round" type="number" value="%2.1f" placeholder="0.00" step=".5" min="0" max="16">', $ozs;
    $str .= '<center class="w3-margin-top">';
    $str .= sprintf '<button class="w3-button w3-green w3-border w3-round" onclick="sae_convertWeight(this, %d, \'%s\');">Save</button>', $flightIDX, $txtID;
    $str .= '</center>';
    $str .= '</div>';
    return($str);
}