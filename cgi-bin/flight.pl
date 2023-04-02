#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# use DateTime;
use Cwd 'abs_path';
use URI::Escape;
use JSON;
use POSIX qw(strftime);
use Time::Local;
my $now_string = strftime "%H:%M", localtime;
#---- SAE MODULES -------

use SAE::Common;
use SAE::FLIGHT;
use SAE::USER;
use SAE::WEATHER;
use SAE::TB_WEATHER;
use SAE::TB_TEAM;
use SAE::TEAM;
use SAE::TB_FLIGHT;
use SAE::REGULAR;
use SAE::ADVANCED;
use SAE::MICRO;
use SAE::AIRBOSS;
use SAE::TECH;
use SAE::REPORTS;
use SAE::EVENT;
use SAE::JSONDB;
use SAE::REG_SCORE;
use SAE::ADV_SCORE;
use SAE::MIC_SCORE;
use SAE::TECH;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");
my %STATUS = (1=>"Good Flight", 3=>"Crashed", 2=>"No Fly");
my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');

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
##======================== Flight Tickets ==============================================
    sub sae_updateEventInfo(){
        print $q->header();
        my $eventIDX = $q->param('eventIDX');
        my $txField = $q->param('txField');
        my $inValue = $q->param('inValue');
        my $Event = new SAE::EVENT();
        $Event->_updateEventInfo($txField, $inValue, $eventIDX);
        return;
        }
    sub sae_showSetFlightTicketLimits(){
        print $q->header();
        my $eventIDX = $q->param('eventIDX');
        my $Event = new SAE::EVENT($eventIDX);
        my %EVENT = %{$Event->_getEvent($eventIDX)};
        my $str;
        $str .= '<div style="height: 650px; overflow-y: scroll;">';
        $str .= '<table class="w3-table w3-bordered">';
        $str .= '<tr>';
        $str .= &saeEventRowTemplate('Event Name','TX_EVENT_NAME', $EVENT{TX_EVENT_NAME},1);
        $str .= &saeEventRowTemplate('Event Year','IN_YEAR', $EVENT{IN_YEAR},1);
        $str .= &saeEventRowTemplate('Event Location','TX_EVENT_CITY', $EVENT{TX_EVENT_CITY},1);
        $str .= &saeEventRowTemplate('Ticket Limit','IN_MAX_TICKET', $EVENT{IN_MAX_TICKET},0);
        $str .= '</table>';
        $str .= '</div>';
        return ($str);
        }
    sub saeEventRowTemplate(){
        my ($title, $txField, $inValue, $type) = @_;
        my $str;
        $str .= '<tr>';
        $str .= '<td >';
        $str .= sprintf '<label>%s</label>', $title;
        if ($type) {
            $str .= sprintf '<input class="w3-input w3-border w3-round" type="text" style="text-align: right;" data-key="%s" onchange="sae_updateEventInfo(this);" value="%s"">', $txField, $inValue;
        } else {
            $str .= sprintf '<input class="w3-input w3-border w3-round" type="number" style="text-align: right;" data-key="%s" min="1" step="1" onchange="sae_updateEventInfo(this);" value="%1.2f"">', $txField, $inValue;
        };
        $str .= '</td>';
        $str .= '</tr>';
        return ($str);
        }
##======================== Flights =====================================================
## Regular Class
    sub RegularClassTicketLog(){
        my ($eventIDX, $teamIDX, $inRound) = @_;
        my $Flight = new SAE::FLIGHT();
        my %TIX  = %{$Flight->_getTicketLog($eventIDX, $teamIDX)};
        # my %TEAM = %{$Flight->_getTeamData($teamIDX)};
        my $str;
        my $height = 40;
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
        my $today = sprintf "%04d-%02d-%02dT%02d:%02d", $year+1900, $mon+1, $mday,  $hour, $min;
        my $time  = sprintf "%02d:%02d", $hour, $min;
        $str = '<table class="w3-table w3-hoverable">';
        # $str .= qq($eventIDX, $teamIDX);
        $str .= '<thead>';
        $str .= '<tr class="w3-light-grey w3-center">';
        $str .= '<th style="width: 50px; text-align: center;"><br>Att.</th>';
        $str .= '<th style="width: 76px; text-align: center;">For<br>Score</th>';
        $str .= '<th style="width: 120px; text-align: center;"><br>Date & Time</th>';
        # $str .= '<th style="width: 130px; text-align: center;"><br>Time</th>';
        $str .= '<th style="width: 130px; text-align: center;">Payload<br><span class="w3-small">(lbs.)</span></th>';
        $str .= '<th style="width: 130px; text-align: center;">Wingspan<br><span class="w3-small">(inches)</span></th>';
        $str .= '<th style="width: 65px; text-align: center;">Minor<br><span class="w3-small">Penalty</span></th>';
        $str .= '<th style="width: 65px; text-align: center;">Major<br><span class="w3-small">Penalty</span></th>';
        $str .= '<th><br>Notes</th>';
        $str .= '<th style="width: 65px; text-align: center;"><br><span class="w3-small">Remove</span></th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        my $field = '';
        my $tabIndex = 1;
        foreach $flightIDX (sort {$TIX{$a}{IN_ROUND} <=> $TIX{$b}{IN_ROUND}} keys %TIX) {
            my $focus    = '';
            my $inNumber = $TIX{$flightIDX}{IN_NUMBER};
            if ($inRound == $TIX{$flightIDX}{IN_ROUND}){
                $focus   = 'w3-pale-yellow';
                $str .= sprintf '<tr ID="ROW_%d" class="'.$focus.' w3-hover-pale-yellow deleteContainer_%d" style="padding: 0px;">', $flightIDX, $flightIDX;
            } else {
                $str .= sprintf '<tr ID="ROW_%d" class="w3-hover-pale-yellow deleteContainer_%d" style="padding: 0px;">', $flightIDX, $flightIDX;
            }
            $str .= &t_row_attempt($flightIDX, 'IN_ROUND', $TIX{$flightIDX}{IN_ROUND}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_STATUS', $TIX{$flightIDX}{IN_STATUS}, $focus);
            $str .= &t_row_dateTime($flightIDX, 'TX_DATE_TIME', $TIX{$flightIDX}{TX_DATE_TIME}, $focus);
            $str .= &t_row_payload($flightIDX, 'IN_WEIGHT', $TIX{$flightIDX}{IN_WEIGHT}, $focus);
            $str .= &t_row_inputNumber($flightIDX, 'IN_SPAN', $TIX{$flightIDX}{IN_SPAN}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_PEN_MINOR', $TIX{$flightIDX}{IN_PEN_MINOR}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_PEN_LANDING', $TIX{$flightIDX}{IN_PEN_LANDING}, $focus);
            $str .= &t_row_inputText($flightIDX, 'CL_NOTES', $TIX{$flightIDX}{CL_NOTES}, $focus);     
            # $str .= &t_row_remove($flightIDX);     
            if ($TIX{$flightIDX}{BO_REINSPECT} == 0){
                $str .= &t_row_remove($flightIDX);  
            }  else {
                $str .= '<td style="text-align: center;">Tech</td>';
            }
            $str .= '</tr>';
            $str .= sprintf '<tr ID="DELETE_ROW_%d" class="deleteContainer_%d" style="display: none;">', $flightIDX, $flightIDX;
            $str .= '<td class="w3-padding-large w3-pale-red w3-border-red" colspan="20" style="text-align: center; padding: 20px; border: 3px solid red">';
            $str .= sprintf '<h3>Delete Flight Attempt #:%02d</h3>',$TIX{$flightIDX}{IN_ROUND};
            $str .= sprintf '<button class="w3-button w3-round-large w3-border w3-padding-large w3-margin-right w3-red" onclick="flight_confirmFlightTicket(this, %d, %d, %d, %d)">Confirm</button>', $flightIDX, $teamIDX, $inNumber, $classIDX;
            $str .= sprintf '<button class="w3-button w3-round-large w3-border w3-padding-large w3-margin-left w3-white" onclick="flight_cancelConfirmDeleteAttempt(this, %d);">Cancel</button>', $flightIDX;
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';
        # $str .= scalar(keys %TIX);;

        return ($str);
        }
    sub loadTeamScores_Reg (){
        my $teamIDX= $q->param('teamIDX');
        print $q->header();
        my $Score = new SAE::REG_SCORE();
        $str = $Score->_getTeamScores($teamIDX);
        }
## Advanced Class
    sub AdvancedClassTicketLog (){
        my ($eventIDX, $teamIDX, $inRound) = @_;
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getTicketLog($eventIDX, $teamIDX)};
        my $str = 'Hello World';
        my $height = 40;
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
        my $today = sprintf "%04d-%02d-%02dT%02d:%02d", $year+1900, $mon+1, $mday,  $hour, $min;
        my $time  = sprintf "%02d:%02d", $hour, $min;
        $str = '<table class="w3-table w3-hoverable">';
        # $str .= qq($eventIDX, $teamIDX);
        $str .= '<thead>';
        $str .= '<tr class="w3-light-grey w3-center">';
        $str .= '<th style="width: 50px; text-align: center;"><br>Att.</th>';
        $str .= '<th style="width: 65px; text-align: center;">For<br>Score</th>';
        $str .= '<th style="width: 140px; text-align: center;">Date & Time</th>';
        $str .= '<th style="width: 110px; text-align: center;">Payload<br><span class="w3-small">(lbs.)</span></th>';
        $str .= '<th style="width: 65px; text-align: center;"><br><span class="w3-small">In-Zone</span></th>';
        $str .= '<th style="width: 65px; text-align: center;">Static<br><span class="w3-small">Zone</span></th>';
        $str .= '<th style="width: 100px; text-align: center;">PADA<br><span class="w3-small">Distance (ft)</span></th>';
        # $str .= '<th style="width: 65px; text-align: center;"><br>Auto</th>';
        $str .= '<th style="width: 65px; text-align: center;">Minor<br><span class="w3-small">Penalty</span></th>';
        $str .= '<th style="width: 65px; text-align: center;">Major<br><span class="w3-small">Penalty</span></th>';
        $str .= '<th><br>Notes</th>';
        $str .= '<th style="width: 65px; text-align: center;"><br><span class="w3-small">Remove</span></th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        my $field = '';
        foreach $flightIDX (sort {$TIX{$a}{IN_ROUND} <=> $TIX{$b}{IN_ROUND}} keys %TIX) {
            my $focus = '';
            my $inNumber = $TIX{$flightIDX}{IN_NUMBER};
            if ($inRound == $TIX{$flightIDX}{IN_ROUND}){
                $focus   = 'w3-pale-yellow';
                $str .= sprintf '<tr ID="ROW_%d" class="'.$focus.' w3-hover-pale-yellow deleteContainer_%d" style="padding: 0px;">', $flightIDX, $flightIDX;
            } else {
                $str .= sprintf '<tr ID="ROW_%d" class="w3-hover-pale-yellow deleteContainer_%d" style="padding: 0px;">', $flightIDX, $flightIDX;
            }
            $str .= &t_row_attempt($flightIDX, 'IN_ROUND', $TIX{$flightIDX}{IN_ROUND}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_STATUS', $TIX{$flightIDX}{IN_STATUS}, $focus);
            $str .= &t_row_dateTime($flightIDX, 'TX_DATE_TIME', $TIX{$flightIDX}{TX_DATE_TIME}, $focus);
            $str .= &t_row_payload($flightIDX, 'IN_WATER_FLT', $TIX{$flightIDX}{IN_WATER_FLT}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'BO_INZONE', $TIX{$flightIDX}{BO_INZONE}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'BO_STATIC', $TIX{$flightIDX}{BO_STATIC}, $focus, $TIX{$flightIDX}{BO_INZONE});
            $str .= &t_row_inputNumber($flightIDX, 'IN_DISTANCE', $TIX{$flightIDX}{IN_DISTANCE}, $focus, $TIX{$flightIDX}{BO_INZONE});
            $str .= &t_row_checkBox($flightIDX, 'IN_PEN_MINOR', $TIX{$flightIDX}{IN_PEN_MINOR}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_PEN_LANDING', $TIX{$flightIDX}{IN_PEN_LANDING}, $focus);
            $str .= &t_row_inputText($flightIDX, 'CL_NOTES', $TIX{$flightIDX}{CL_NOTES}, $focus);
            if ($TIX{$flightIDX}{BO_REINSPECT} == 0){
                $str .= &t_row_remove($flightIDX);  
            }  else {
                $str .= '<td style="text-align: center;">Tech</td>';
            }
            $str .= '</tr>';
            $str .= sprintf '<tr ID="DELETE_ROW_%d" class="deleteContainer_%d" style="display: none;">', $flightIDX, $flightIDX;
            $str .= '<td class="w3-padding-large w3-pale-red w3-border-red" colspan="20" style="text-align: center; padding: 20px; border: 3px solid red">';
            $str .= sprintf '<h3>Delete Flight Attempt #:%02d</h3>',$TIX{$flightIDX}{IN_ROUND};
            $str .= sprintf '<button class="w3-button w3-round-large w3-border w3-padding-large w3-margin-right w3-red" onclick="flight_confirmFlightTicket(this, %d, %d, %d, %d)">Confirm</button>', $flightIDX, $teamIDX, $inNumber, $classIDX;
            $str .= sprintf '<button class="w3-button w3-round-large w3-border w3-padding-large w3-margin-left w3-white" onclick="flight_cancelConfirmDeleteAttempt(this, %d);">Cancel</button>', $flightIDX;
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= join(", ", keys %tIX);
        return ($str);
        }
    sub loadTeamScores_Adv (){
        my $teamIDX= $q->param('teamIDX');
        print $q->header();
        my $Score = new SAE::ADV_SCORE();
        $str = $Score->_getTeamScores($teamIDX);
        }
    sub loadTeamGTV (){
        my $teamIDX= $q->param('teamIDX');
        my $Team = new SAE::TEAM($teamIDX);
        my %TEAM = %{$Team->_getTeamData()};
        my $Advanced = new SAE::ADV_SCORE();
        my ($effWater) = $Advanced->_getEffectiveWater($teamIDX);
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $str;
        $str = '<div class="w3-container w3-margin">';
        $str .= sprintf '<label>Amount of water transported: ( <i>Maximum Allowed = <b>%2.2f</b> </i>)</label>', $effWater;
        my $data = sprintf 'data-table="TB_TEAM" data-key="PK_TEAM_IDX" data-index="%d" data-field="%s"', $teamIDX, 'IN_WATER';
        $str .= sprintf '<input type="number" '.$data.' class="w3-input w3-border w3-round w3-light-grey" style="width: 20%" value="%2.2f" data-max="%2.2f" placeholder="Max = %2.2f" max="%2.2f" onchange="updateField(this);">', $TEAM{IN_WATER}, $effWater, $effWater, $effWater;
        my $data    = sprintf 'data-table="TB_TEAM" data-key="PK_TEAM_IDX" data-index="%d" data-field="%s"', $teamIDX, 'BO_AUTO';
        my $checked = 'checked';
        if ($TEAM{BO_AUTO} == 0){$checked = ''} 
        $str .= '<br><input ID="BO_AUTO" class="w3-check" '.$data.' type="checkbox" '.$checked.' onclick="updateCheckItems(this);"><label class="w3-margin-left">Water was transported <i>autonomously</i></label>';
        $str .= $total.'</div>';

        # $str .= $teamIDX;;
        return ($str);
        }
## Micro Class
    sub MicroClassTicketLog (){
        my ($eventIDX, $teamIDX, $inRound) = @_;
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getTicketLog($eventIDX, $teamIDX)};
        my $str;
        my $height = 40;
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
        my $today = sprintf "%04d-%02d-%02dT%02d:%02d", $year+1900, $mon+1, $mday,  $hour, $min;
        my $time  = sprintf "%02d:%02d", $hour, $min;
        $str = '<table class="w3-table w3-hoverable">';
        # $str .= qq($eventIDX, $teamIDX);
        $str .= '<thead>';
        $str .= '<tr class="w3-light-grey w3-center">';
        $str .= '<th style="width: 50px; text-align: center;"><br>Att.</th>';
        # $str .= '<th class="w3-pale-red w3-small" style="width: 65px; text-align: center;">Re-inspection<br>Required</th>';
        $str .= '<th style="width: 65px; text-align: center;">For<br>Score</th>';
        $str .= '<th style="width: 140px; text-align: center;">Date & Time of Flight</th>';
        $str .= '<th style="width: 70px; text-align: center;">Good<br><span class="w3-small">LargeBox</span></th>';
        $str .= '<th style="width: 70px; text-align: center;">Damaged<br><span class="w3-small">LargeBox</span></th>';
        $str .= '<th style="width: 70px; text-align: center;">Good<br><span class="w3-small">SmallBox</span></th>';
        $str .= '<th style="width: 70px; text-align: center;">Damaged<br><span class="w3-small">SmallBox</span></th>';
        $str .= '<th style="width: 100px; text-align: center;">Payload<br><span class="w3-small">(lbs)</span></th>';
        $str .= '<th style="width: 100px; text-align: center;">First Turn<br><span class="w3-small">Time (Sec.)</span></th>';
        # $str .= '<th style="width: 100px; text-align: center;">PADA<br>Distance(ft)</th>';
        # $str .= '<th style="width: 65px; text-align: center;"><br>Auto</th>';
        $str .= '<th style="width: 65px; text-align: center;">25%<br><span class="w3-small">Penalty</span></th>';
        $str .= '<th style="width: 65px; text-align: center;">50%<br><span class="w3-small">Penalty</span></th>';
        $str .= '<th><br>Notes</th>';
        $str .= '<th style="width: 65px; text-align: center;"><br><span class="w3-small">Remove</span></th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        my $field = '';
        foreach $flightIDX (sort {$TIX{$a}{IN_ROUND} <=> $TIX{$b}{IN_ROUND}} keys %TIX) {
            my $focus = '';
            # my $inNumber = $TIX{$flightIDX}{IN_NUMBER};
            # if ($inRound == $TIX{$flightIDX}{IN_ROUND}){
            #     $focus = 'w3-pale-yellow';
            #     $str .= '<tr class="'.$focus.'" style="padding: 0px;">';
            # } else {
            #     $str .= '<tr style="padding: 0px;">';
            # }
            my $inNumber = $TIX{$flightIDX}{IN_NUMBER};
            if ($inRound == $TIX{$flightIDX}{IN_ROUND}){
                $focus   = 'w3-pale-yellow';
                $str .= sprintf '<tr ID="ROW_%d" class="'.$focus.' w3-hover-pale-yellow deleteContainer_%d" style="padding: 0px;">', $flightIDX, $flightIDX;
            } else {
                $str .= sprintf '<tr ID="ROW_%d" class="w3-hover-pale-yellow deleteContainer_%d" style="padding: 0px;">', $flightIDX, $flightIDX;
            }
            $str .= &t_row_attempt($flightIDX, 'IN_ROUND', $TIX{$flightIDX}{IN_ROUND}, $focus);
            # $str .= &t_row_crash($flightIDX, 'BO_REINSPECT', $TIX{$flightIDX}{BO_REINSPECT}, $focus, $inNumber, $inRound);
            $str .= &t_row_checkBox($flightIDX, 'IN_STATUS', $TIX{$flightIDX}{IN_STATUS}, $focus);
            $str .= &t_row_dateTime($flightIDX, 'TX_DATE_TIME', $TIX{$flightIDX}{TX_DATE_TIME}, $focus);
            $str .= &t_row_inputNumber($flightIDX, 'IN_LARGE', $TIX{$flightIDX}{IN_LARGE}, $focus);
            $str .= &t_row_inputNumber($flightIDX, 'IN_LB_DAMAGE', $TIX{$flightIDX}{IN_LB_DAMAGE}, $focus);
            $str .= &t_row_inputNumber($flightIDX, 'IN_SMALL', $TIX{$flightIDX}{IN_SMALL}, $focus);
            $str .= &t_row_inputNumber($flightIDX, 'IN_SB_DAMAGE', $TIX{$flightIDX}{IN_SB_DAMAGE}, $focus);
            $str .= &t_row_payload($flightIDX, 'IN_WEIGHT', $TIX{$flightIDX}{IN_WEIGHT}, $focus);
            $str .= &t_row_time($flightIDX, 'IN_TOF', $TIX{$flightIDX}{IN_TOF}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_PEN_MINOR', $TIX{$flightIDX}{IN_PEN_MINOR}, $focus);
            $str .= &t_row_checkBox($flightIDX, 'IN_PEN_LANDING', $TIX{$flightIDX}{IN_PEN_LANDING}, $focus);
            $str .= &t_row_inputText($flightIDX, 'CL_NOTES', $TIX{$flightIDX}{CL_NOTES}, $focus);   
            # $str .= &t_row_remove($flightIDX);    
            if ($TIX{$flightIDX}{BO_REINSPECT} == 0){
                $str .= &t_row_remove($flightIDX);  
            }  else {
                $str .= '<td style="text-align: center;">Tech</td>';
            }
            $str .= '</tr>';
            $str .= sprintf '<tr ID="DELETE_ROW_%d" class="deleteContainer_%d" style="display: none;">', $flightIDX, $flightIDX;
            $str .= '<td class="w3-padding-large w3-pale-red w3-border-red" colspan="20" style="text-align: center; padding: 20px; border: 3px solid red">';
            $str .= sprintf '<h3>Delete Flight Attempt #:%02d</h3>',$TIX{$flightIDX}{IN_ROUND};
            $str .= sprintf '<button class="w3-button w3-round-large w3-border w3-padding-large w3-margin-right w3-red" onclick="flight_confirmFlightTicket(this, %d, %d, %d, %d)">Confirm</button>', $flightIDX, $teamIDX, $inNumber, $classIDX;
            $str .= sprintf '<button class="w3-button w3-round-large w3-border w3-padding-large w3-margin-left w3-white" onclick="flight_cancelConfirmDeleteAttempt(this, %d);">Cancel</button>', $flightIDX;
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= join(", ", keys %tIX);
        return ($str);
        }
    sub loadTeamScores_Mic (){
        my $teamIDX= $q->param('teamIDX');
        print $q->header();
        my $Score = new SAE::MIC_SCORE();
        $str = $Score->_getTeamScores($teamIDX);
        }
## Templates
    sub t_row_attempt (){
        my ( $flightIDX, $field, $value, $focus) = @_;
        my $str;
        my $w3Class = $focus." w3-input w3-center w3-border w3-transparent";
        my $data = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s" ', $flightIDX, $field;
        my $style = sprintf 'min-height: 40px; !important; padding: 0px !important;';
        $str = '<td class="cell" >';
        $str .= sprintf '<input class="%s" %s style="%s" type="text" value="%02d" onchange="updateField(this);">', $w3Class, $data, $style, $value;
        $str .= '</td>';
        return ($str);
        }
    sub t_row_remove (){
        my ( $flightIDX ) = @_;
        my $str;
        my $w3Class = $focus." w3-input w3-center w3-border w3-transparent";
        my $data = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" ', $flightIDX;
        my $style = sprintf 'min-height: 40px; !important; padding: 0px !important;';
        $str = '<td class="cell w3-center w3-border-bottom" style="vertical-align: middle" >';
        $str .= sprintf '<i class="w3-button w3-transparent w3-round w3-hover-red fa fa-trash w3-text-red w3-large" aria-hidden="true" onclick="flight_showConfirmDeleteAttempt(this, %d);"></i>', $flightIDX;
        # $str .= sprintf '<input class="%s" %s style="%s" type="text" value="%d" onchange="updateField(this);">', $w3Class, $data, $style, $value;
        $str .= '</td>';
        return ($str);
        }
    sub t_row_crash (){
        my ( $flightIDX, $field, $value, $focus, $inNumber, $inRound) = @_;
        my $str;
        my $style   = 'min-height: 40px; padding: 0 !important; vertical-align: bottom; position: relative; top: -2px;';
        ## openReInspectionStatus 841
        my $w3Class = $focus.' w3-check w3-center w3-transparent ';
        if ($field eq 'BO_STATIC') {$w3Class .= 'inZoneEntry_'.$flightIDX. ' inStaticCount ';}
        if ($field eq 'BO_STATIC' && $inZone == 0){$w3Class .= ' w3-disabled'}

        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = '<td class="cell" style=" text-align: center;  border: 1px solid #ccc;">';
        if ($value == 1 ){$check = 'checked'} else {$check = ''}
        my $id = $field.'_'.$flightIDX;
        if ($field eq "IN_STATUS"){$id = 'FlightStatus_'.$flightIDX}
        $str .= sprintf '<input type="checkbox" ID="'.$id.'" type="checkbox"class="'.$w3Class.'" '.$data.' style="'.$style.'" '.$check.' onclick="flight_openReinspection(this, %d, %d, %d);updateCheckItems(this);">', $inNumber, $inRound, $flightIDX;
        $str .= '</td>';
        return ($str);
        }
    sub t_row_checkBox (){
        my ( $flightIDX, $field, $value, $focus, $inZone) = @_;
        my $str;
        my $style   = 'min-height: 40px; padding: 0 !important; vertical-align: bottom; position: relative; top: -2px;';

        my $w3Class = $focus.' w3-check w3-center w3-transparent ';
        if ($field eq 'BO_STATIC') {$w3Class .= 'inZoneEntry_'.$flightIDX. ' inStaticCount ';}
        if ($field eq 'BO_STATIC' && $inZone == 0){$w3Class .= ' w3-disabled'}

        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = '<td class="cell" style=" text-align: center;  border: 1px solid #ccc;">';
        if ($value == 1 ){$check = 'checked'} else {$check = ''}
        my $id = $field.'_'.$flightIDX;
        if ($field eq "IN_STATUS"){$id = 'FlightStatus_'.$flightIDX}
        $str .= '<input type="checkbox" ID="'.$id.'" type="checkbox"class="'.$w3Class.'" '.$data.' style="'.$style.'" '.$check.' onclick="updateTicketCheckinStatus(this,'.$flightIDX.');updateCheckItems(this);">';
        $str .= '</td>';
        return ($str);
        }
    sub t_row_dateTime (){
        my ( $flightIDX, $field, $value, $focus ) = @_;
        my $str;
        my $style   = 'min-height: 40px; !important; padding: 0px !important;';
        my $w3Class = $focus.' w3-input w3-center w3-border w3-transparent';
        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = sprintf '<td class="cell" >';
        $str .= sprintf '<input type="datetime-local" class="'.$w3Class.'" '.$data.' style="'.$style.'" value="%s" onchange="updateField(this);"> ', $value;
        $str .= '</td>';
        return ($str);
        }    
    sub t_row_payload (){
        my ( $flightIDX, $field, $value, $focus ) = @_;
        my $str;
        my $style   = 'min-height: 40px; padding: 0px !important;';
        my $w3Class = $focus.' w3-input w3-center w3-border w3-transparent';
        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = sprintf '<td class="cell w3-display-container" style="min-height: 40px;">';
        $str .= sprintf '<input type="number" ID="%s_%d" class="'.$w3Class.'" '.$data.' style="'.$style.'" step="0.01" min="0" value="%2.3f" onchange="updateField(this);">', $field, $flightIDX, $value;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 2px;" onclick="sae_openCalculator(%d, \'%s_\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX, $field;
        $str .= sprintf '</td>';
        return ($str);
        }
    sub t_row_time (){
        my ( $flightIDX, $field, $value, $focus ) = @_;
        my $str;
        my $style   = 'min-height: 40px; padding: 0px !important;';
        my $w3Class = $focus.' w3-input w3-center w3-border w3-transparent';
        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = sprintf '<td class="cell w3-display-container" style="min-height: 40px;">';
        $str .= sprintf '<input type="number" ID="%s_%d" class="'.$w3Class.'" '.$data.' style="'.$style.'" step="0.01" min="0" value="%2.2f" onchange="updateField(this);">', $field, $flightIDX, $value;
        $str .= sprintf '<button class="w3-display-right" style="margin-right: 2px; padding: 4px;" onclick="sae_openTimeCalculator(%d, \'%s_%d\');"><i class="fa fa-calculator w3-pale-green" aria-hidden="true"></i></button>', $flightIDX, $field, $flightIDX;
        $str .= sprintf '</td>';
        return ($str);
        }
    sub t_row_inputNumber (){
        my ( $flightIDX, $field, $value, $focus, $inZone) = @_;
        my $str;
        my $style   = 'min-height: 40px; padding: 0px !important;';
        my $w3Class = $focus.' w3-input w3-center w3-border w3-transparent ';
        if ($field eq 'IN_DISTANCE') {$w3Class .= 'inZoneEntry_'.$flightIDX}
        if ($field eq 'IN_DISTANCE' && $inZone == 0){$w3Class .= ' w3-disabled'}
        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = sprintf '<td class="cell w3-display-container" style="min-height: 40px;">';
        $str .= sprintf '<input type="number" class="'.$w3Class.'" '.$data.' style="'.$style.'" min="0" value="%2.1f" onchange="updateField(this);">', $value;
        $str .= sprintf '</td>';
        return ($str);
        }
    sub t_row_inputText (){
        my ( $flightIDX, $field, $value, $focus ) = @_;
        my $str;
        my $style   = 'min-height: 40px; padding: 0px; padding-left: 7px;';
        my $w3Class = $focus.' w3-input w3-left w3-border w3-transparent';
        my $data    = sprintf 'data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s"', $flightIDX, $field;
        $str = sprintf '<td class="cell w3-display-container" style="min-height: 40px;">';
        $str .= sprintf '<input type="text" class="'.$w3Class.'" '.$data.' style="'.$style.'" value="%s" onchange="updateField(this);">', $value;
        $str .= sprintf '</td>';
        return ($str);
        }
    sub t_tags(){
        my ($flightIDX, $label) = @_;
        my $str;
        $str = '<div class="tag">';
        $str .= sprintf '<span>%s</span>', $label;
        $str .= sprintf '<i class="fa fa-close" data-key="%d" onclick="deleteReInspectionItem(this);" aria-hidden="true"></i>', $flightIDX;
        $str .= '</div>';
        return($str);
        }
    sub T_inspectionListItem(){
        my ($flightIDX, $txItem) = @_;
        my $str;
        $str = sprintf '<li class="w3-display-container w3-hover-pale-yellow listItem" style="padding-right: 50px; cursor: pointer;" data-value="%s">', $txItem;
        $str .= sprintf '<div onclick="addClickedItem(%d, \'%s\');">%s</div>', $flightIDX, $txItem, $txItem;
        $str .= sprintf '<i class="fa fa-close w3-margin-right w3-display-right w3-button w3-round w3-hover-red" style="align-items: center;" onclick="deleteInspectionItemFromDatabase(this, \'%s\');" aria-hidden="true"></i>',$txItem;
        $str .= '</li>';
        return ($str);
        }
    sub t_reasonListItem(){
        my ($flightIDX, $txItem) = @_;
        my $str;
        $str = sprintf '<li class="w3-display-container w3-hover-light-grey reasonlistItem" style="padding: 4px 50px 4px 0px; cursor: pointer;" data-value="%s">', $txItem;
        $str .= sprintf '<div onclick="addClickedReason(%d, \'%s\');">%s</div>', $flightIDX, $txItem, $txItem;
        $str .= sprintf '<i class="fa fa-close w3-display-right w3-button w3-round w3-hover-red" style="align-items: center; margin-right: 0px;" onclick="deleteReasonItemFromDatabase(this, \'%s\');" aria-hidden="true"></i>',$txItem;
        $str .= '</li>';
        return ($str);
        }
    sub t_ticket (){
        my ($inNumber, $inRound, $flightIDX, $teamIDX, $classIDX, $boTixReinspect, $boTeamReinspect, $inStatus) = @_;
        my %TIX_COLOR = (0=>'w3-pale-yellow', 1=>'w3-blue', 2=>'w3-light-grey');
        my $disabled = '';
        if ($boTeamReinspect == 1 && $boTixReinspect == 0 ){$disabled = 'w3-disabled'}
        my $str = sprintf '<li ID="TICKET_%d">', $flightIDX;
        $str .= sprintf '<button class="%s w3-border w3-hover-green w3-round w3-button team_%d_Ticket %s" data-round="%d" ', $disabled, $teamIDX, $TIX_COLOR{$inStatus}, $inRound;
        $str .= sprintf 'onclick="btn_checkInTicket(%d, %d, %d, %d, %d);">',$inNumber, $inRound, $flightIDX, $teamIDX, $classIDX;
        $str .= sprintf '%03d-<b class="w3-large">%02d</b>',$inNumber, $inRound;
        # if ($inStatus == 0) {
        #     $str .= sprintf '<span class="fa fa-star-o w3-margin-left" aria-hidden="true"></span>';
        # } elsif ($inStatus == 1) {
        #     $str .= sprintf '<span class="fa fa-star w3-margin-left w3-text-amber" aria-hidden="true"></span>';
        # } else {
        #     $str .= sprintf '<span class="fa fa-star w3-margin-left w3-text-red" aria-hidden="true"></span>';
        # }
        $str .= sprintf '</button>';
        $str .= sprintf '</li>';
        return ($str);
        }
    sub t_tags (){
        my $text = shift;
        my @ITEMS = split(";", $text);
        my $str;
        foreach $item (sort {$a cmp $b} @ITEMS){
            $str .= '<div class="tag_log">';
            $str .= '<i class="fa fa-wrench" aria-hidden="true"></i>';
            $str .= sprintf '<span class="w3-margin-left">%s</span>', $item;
            $str .= '</div>';
        }
        return ($str);
        }
    sub t_teamDataRow(){
        my ($label, $value) = @_;
        my $str = '<tr>';
        $str .= sprintf '<td style="width: 25%; text-align: right;"><b>%s</b></td>', $label;
        $str .= sprintf '<td style="width: 75%; text-align: left;">%s</td>', $value;
        $str .= '</tr>';
        }
    sub t_teamDataRowEditable(){
        my ($label, $value, $table, $key, $idx, $field) = @_;
        my $str = '<tr>';
        $str .= sprintf '<td style="width: 25%; text-align: right;"><b>%s</b></td>', $label;
        $str .= sprintf '<td style="width: 75%; text-align: left;">';
        $str .= sprintf '<input class="w3-input w3-border w3-round" data-table="%s" data-key="%s" data-index="%d" data-field="%s" value="%s" onchange="updateField(this);">', $table, $key, $idx, $field, $value;
        $str .= sprintf '</td>';
        $str .= '</tr>';
        }
    sub t_addTicketButton (){
        my ($teamIDX, $inNumber, $boReinspect, $classIDX) = @_;
        my $str;
        my $class = "w3-button w3-round w3-border w3-card-4 w3-green";
        my $style = "height: 100%; width: 125px; line-height: 21px;";
        if ($boReinspect ==1 ){
            $class = "w3-button w3-round w3-border w3-card-4 w3-red";
        } 
        $str = sprintf '<button ID="TEAM_TICKET_ADDER_%d" class="'.$class.'" style="'.$style.'" data-number="%d" onclick="addTicket(this, %2d, %2d, %d, %d);">',$teamIDX, $inNumber, $teamIDX, $inNumber, $boReinspect, $classIDX;
        if ($boReinspect == 1){
            $str .= sprintf '<i class="fa fa-ban 2x" aria-hidden="true"></i> No Ticket<br><b>#%03d</b></button>', $inNumber;
        } else {
            $str .= sprintf '<i class="fa fa-plus 2x" aria-hidden="true"></i> Ticket<br><b>#%03d</b></button>', $inNumber;
        }
        return ($str);
        }
    sub t_ticketStatus (){
        my ($flightIDX, $inNumber, $teamIDX, $classIDX, $inRound, $ticketStatus, $reinspect) = @_;
        my $Flight = new SAE::FLIGHT();
        my @REASONS = @{$Flight->_getReasonsNoScore()};
        my $checkedOut = '';
        my $checkedForScore = '';
        my $checkedNotForScore = '';
        my $checkedOutDisabled = '';
        if ($ticketStatus == 1){$checkedOut = 'checked'}
        if ($ticketStatus == 0){$checkedForScore = 'checked'}
        # if ($ticketStatus == 2){$checkedNotForScore = 'checked'}
        if ($reinspect == 1){$checkedOutDisabled = 'disabled'}
        my $str;
        $str = '<div class="w3-container w3-quarter w3-light-grey w3-border w3-card-4 w3-padding-small" style="min-height: 638px;">';
            $str .= '<header class="w3-container w3-grey w3-round">';
            $str .= sprintf '<h3>Ticket # %03d-<b>%02d</b></h3>', $inNumber, $inRound;
            $str .= '</header>';    
            $str .= '<div class="w3-container">';
            $str .= sprintf '<input ID="delete_%d" class="w3-check" type="radio" value="99" name="TicketStatus"  onclick="updateAttemptStatus(event, this, %d);">', $flightIDX;
            $str .= '<label for="delete_'.$flightIDX.'" class="w3-margin-left w3-large">Delete</label>';
            $str .= '</div>';
            $str .= '<div ID="cor_99" class="w3-pale-red w3-panel w3-center w3-padding-large ticket_corridian" style="display: none; border-style: inset;  margin-top: 4px;">';
            # $str .= '<header class="w3-container w3-red">Confirm</header>';
            $str .= sprintf '<p class="w3-center w3-border w3-round w3-white">Click "Confirm" to delete:<br>Attempt #%02d<br>TEAM: #%03d</p>', $inRound, $inNumber;
            $str .= sprintf '<button class="w3-button w3-round w3-border w3-red w3-margin-top" onclick="confirmFlightTicket(this, %d, %d, %d, %d);">Confirm Delete</button>', $flightIDX, $teamIDX, $inNumber, $classIDX;
            $str .= '</div>';
            $str .= '<div class="w3-container">';
            $str .= sprintf '<input id="checkedOut_%d" '.$checkedOut.' '.$checkedOutDisabled.' class="w3-check" data-field="BO_OUT" data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" type="radio" value="1" name="TicketStatus" onclick="updateAttemptStatus(event, this, %d);">', $flightIDX, $flightIDX, $flightIDX;
            $str .= '<label for="checkedOut_'.$flightIDX.'"  '.$checkedOutDisabled.' class="w3-margin-left w3-large">Checked-Out</label>';
            $str .= '</div>';
            $str .= '<div class="w3-container">';
            $str .= sprintf '<input id="ForScore_%d" '.$checkedForScore.' class="w3-check" data-field="BO_OUT" data-table="TB_FLIGHT" data-key="PK_FLIGHT_IDX" data-index="%d" type="radio" value="0" name="TicketStatus" onclick="updateAttemptStatus(event, this, %d);">', $flightIDX, $flightIDX, $flightIDX;
            $str .= '<label for="ForScore_'.$flightIDX.'" class="w3-margin-left w3-large">Check-In</label>';
            $str .= '</div>';
            $str .= '<div class="w3-container w3-center w3-padding">';
                        $str .= '<button class="w3-button w3-card w3-border w3-round w3-card-2 w3-hover-grey w3-margin" style="width: 100px;" onclick="$(this).close();">Exit</button>';
                    $str .= '</div>';
            $str .= '</div>';
        return ($str);
        }
## Inspections
    # sub flight_openReinspection (){
    #     my $eventIDX   = $q->param('eventIDX');
    #     # my %DATA = %{decode_json($q->param('jsonData'))};
    #     my $Flight = new SAE::FLIGHT();
    #     my %LIST   = %{$Flight->_getListOfReinspectItems()};
    #     print $q->header();
    #     my $str;
    #     $str .= '<div class="w3-container">';
    #     $str .= '<ul class="w3-ul" style="height: 800px; overflow-y: auto;">';
    #     foreach $inspectionIDX (sort {lc($LIST{$a}{TX_ITEM}) cmp lc($LIST{$b}{TX_ITEM})} keys %LIST) {
    #         my $value = $LIST{$inspectionIDX}{TX_ITEM};
    #         $str .= sprintf '<label FOR="INSPECT_%d"><li class="w3-bar w3-border w3-white w3-round w3-hover-yellow" style="padding: 2px;">',$inspectionIDX;
    #         $str .= '<div class="w3-bar-item" style="padding: 1px 10px;">';
    #         $str .= sprintf '<input ID="INSPECT_%d" type="checkbox" class="w3-check inspectItems" value="%s"><label FOR="INSPECT_%d" class="w3-margin-left">%s</label>', $inspectionIDX, $value, $inspectionIDX, $value;
    #         $str .= '</div>';
    #         $str .= '</li></label>';
    #     }
    #     $str .= '<li class="w3-bar w3-border w3-white w3-round" style="padding: 2px;">';
    #     $str .= '<div class="w3-bar-item" style="padding: 1px 10px; width: 100%">';
    #     $str .= sprintf '<input ID="INSPECT_OTHER_CHECKBOX" type="checkbox" class="w3-check inspectOther">', $inspectionIDX, $value, $inspectionIDX, $value;
    #     $str .= sprintf '<input ID="INSPECT_OTHER" type="text" class="w3-input w3-animate-input w3-border w3-round w3-margin-left w3-pale-yellow" placeholder="Other..." onkeyup="flight_checkInspectOthers(this);" style="width: 20%; display: inline-block; max-width: 95%;">', $inspectionIDX, $value, $inspectionIDX, $value;
    #     $str .= '</div>';
    #     $str .= '</li>';
    #     $str .= '</ul>';
    #     $str .= '<div class="w3-container">';
    #     $str .= '<button class="w3-button w3-border w3-round-large w3-card w3-margin-right">Submit</button>';
    #     $str .= '<button class="w3-button w3-border w3-round-large w3-card w3-margin-left">Cancel</button>';
    #     $str .= '</div>';
    #     $str .= '</div>';
    
    #     return ($str);
    #     }
    sub loadInspectionLog (){
        my $teamIDX = $q->param('teamIDX');
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $Flight = new SAE::FLIGHT();
        my $User = new SAE::USER();
        my %JUDGES = %{$User->_getJudges()};
        my %LOGS = %{$Flight->_getTeamInspectionLogs($teamIDX)};
        
        # my $str = $teamIDX;
        $str .= '<table class="w3-table w3-bordered">';
        $str .= '<thead>';
        $str .= '<tr class="w3-pale-red">';
        $str .= '<th style="width: 76px;">Att</th>';
        $str .= '<th style="width: 200px;">Date/Time</th>';
        $str .= '<th style="width: 140px;">Requested By</th>';
        $str .= '<th style="width: 100px;">Status</th>';
        $str .= '<th style="width: 140px;">Cleared By</th>';
        $str .= '<th>Inpected Items</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $logIDX (sort {$LOGS{$b}{IN_ROUND} <=> $LOGS{$a}{IN_ROUND}} keys %LOGS){
            my $flightIDX = $LOGS{$logIDX}{FK_FLIGHT_IDX};
            my $inNumber  = $LOGS{$logIDX}{IN_NUMBER};
            my %STATUS = (0=>'<i class="fa fa-check-square-o w3-text-green" aria-hidden="true"></i>', 
                      1=>'<button class="w3-green w3-button w3-border w3-round" data-fk_team_idx="'.$teamIDX.'" onclick="clearReinspection(this, '.$flightIDX.', '.$inNumber.', '.$logIDX.');"> Clear Inspection</button>'
                      );
            $str .= '<tr>';
            $str .= sprintf '<td>%02d</td>', $LOGS{$logIDX}{IN_ROUND};
            $str .= sprintf '<td>%s</td>', $LOGS{$logIDX}{TS_CREATE};
            $str .= sprintf '<td>%s, %s</td>', $JUDGES{$LOGS{$logIDX}{IN_REQUEST_BY}}{TX_LAST_NAME}, $JUDGES{$LOGS{$logIDX}{IN_REQUEST_BY}}{TX_FIRST_NAME};
            $str .= sprintf '<td>%s</td>', $STATUS{$LOGS{$logIDX}{BO_STATUS}};
            $str .= sprintf '<td>%s, %s</td>', $JUDGES{$LOGS{$logIDX}{IN_CLEARED_BY}}{TX_LAST_NAME}, $JUDGES{$LOGS{$logIDX}{IN_CLEARED_BY}}{TX_FIRST_NAME};
            my $tags = &t_tags($LOGS{$logIDX}{CL_ITEMS});
            $str .= sprintf '<td><div class="tag-container_log w3-border-0" >%s</div></td>', &t_tags($LOGS{$logIDX}{CL_ITEMS});
            $str .= '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';

        return ($str);
        }
    sub clearReinspection (){
        my $flightIDX= $q->param('flightIDX');
        my $teamIDX= $q->param('teamIDX');
        my %DATA = %{decode_json($q->param('BO_REINSPECT'))};
        my %DATA2 = %{decode_json($q->param('BO_STATUS'))};
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
           $JsonDB->_update('TB_REINSPECT', \%DATA2, qq(FK_FLIGHT_IDX=$flightIDX));
           $JsonDB->_update('TB_TEAM', \%DATA, qq(PK_TEAM_IDX=$teamIDX));
           $JsonDB->_update('TB_FLIGHT', \%DATA, qq(PK_FLIGHT_IDX=$flightIDX));
        my $str;

        return ($str);
        }
    sub sae_ps_clearInspection (){
        my $teamIDX = $q->param('FK_TEAM_IDX');
        my $inNumber= $q->param('IN_NUMBER');
        my $classIDX;
        print $q->header();
        # my %DATA = %{decode_json($q->param('jsonData'))};
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getFlightTickets($teamIDX)};
        my $tickets;
        my %OBJ;
        foreach $flightIDX (sort {$TIX{$a}{IN_ROUND} <=> $TIX{$b}{IN_ROUND}} keys %TIX){
            my $boTicketReinspect = $TIX{$flightIDX}{BO_REINSPECT};
            my $inStatus    = $TIX{$flightIDX}{IN_STATUS};
            my $inRound     = $TIX{$flightIDX}{IN_ROUND};
               $classIDX    = $TIX{$flightIDX}{FK_CLASS_IDX};
            my $boReinspect = $TIX{$flightIDX}{TEAM_INSPECT_STATUS};
            $tickets .= &t_ticket($inNumber, $inRound, $flightIDX, $teamIDX, $classIDX, $boTicketReinspect, $boReinspect, $inStatus);
        }
        $str = &t_addTicketButton($teamIDX, $inNumber, 0, $classIDX);
        $OBJ{addButton} = &t_addTicketButton($teamIDX, $inNumber, 0, $classIDX);
        $OBJ{tickets} = $tickets;
        my $json = encode_json \%OBJ;
        return ($json);
        }
    sub sae_ps_notifyTeamsOfReinspection (){
        my $teamIDX= $q->param('FK_TEAM_IDX');
        my $Tech = new SAE::TECH();
        my %OBJ;
        print $q->header();
        my $tickets = $Tech->_getMyReinspection($teamIDX);
        $OBJ{FK_TEAM_IDX} = $teamIDX;
        $OBJ{NOTIFY_BUTTON} = $tickets;
        my $json = encode_json \%OBJ;
        return ($json);
        }
## 2023 code
    sub updateInspectionTags (){
        my $inspectIDX= $q->param('inspectIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
        $JsonDB->_update('TB_REINSPECT', \%DATA, qq(PK_REINSPECT_IDX=$inspectIDX));
        my $str;

        return ($str);
        }
    sub updateField (){
        my $eventIDX = $q->param('eventIDX');
        my $field = $q->param('FIELD_IDX');
        my $value = $q->param('VALUE_IDX');
        my $table = $q->param('TABLE');
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $JsonDB = new SAE::JSONDB();
        print $q->header();
        if (exists $DATA{'IN_EPOCH'}) {
            my $Flight = new SAE::FLIGHT();
            $DATA{'IN_DENSITY'} = $Flight->_getDensityAltitude($eventIDX, $DATA{IN_EPOCH});
            # print "getDensityAltitude = $DATA{'IN_DENSITY'}";
        }
        
        my $str;
        $str =   $JsonDB->_update($table, \%DATA, qq($field=$value));
        # $str .= join("|", values %DATA);
        return ("$field=$value");
        }
    sub changeDateTime (){
        my $eventIDX = $q->param('eventIDX');
        my $dateTime = $q->param('dateTime');
        my $epoch    = $q->param('epoch');
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $str;
        my $Flight = new SAE::FLIGHT();
        $str .= $Flight->_getDensityAltitude($eventIDX, $epoch);
        return ($str);
        }
    sub cancelReinspection (){
        my $flightIDX= $q->param('flightIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $teamIDX = $DATA{FK_TEAM_IDX};
        my %UPDATE = ();
        $UPDATE{'BO_REINSPECT'} = 0;
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
        $JsonDB->_delete('TB_REINSPECT', qq(FK_FLIGHT_IDX=$flightIDX AND BO_STATUS=1));
        $JsonDB->_update('TB_FLIGHT', \%UPDATE, qq(PK_FLIGHT_IDX=$flightIDX));
        $JsonDB->_update('TB_TEAM', \%UPDATE, qq(PK_TEAM_IDX=$teamIDX));
        my $str;

        return ($str);
        }
    sub getRequestInspectionList (){
        my $eventIDX= $q->param('eventIDX');
        my $flightIDX= $q->param('flightIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};

        my $teamIDX = $DATA{FK_TEAM_IDX};
        my %UPDATE = ();
        $UPDATE{'BO_REINSPECT'} = 1;
        print $q->header();
        # print join("\n", keys %DATA);
        my $Flight = new SAE::FLIGHT();
        my $JsonDB = new SAE::JSONDB();
        my $newIDX =  $JsonDB->_insert('TB_REINSPECT', \%DATA);
        my %LIST = %{$Flight->_getReinspectionList($flightIDX)};
        $JsonDB->_update('TB_FLIGHT', \%UPDATE, qq(PK_FLIGHT_IDX=$flightIDX));
        $JsonDB->_update('TB_TEAM', \%UPDATE, qq(PK_TEAM_IDX=$teamIDX));
        # _getReinspectionList
        # my %OBJ;
        # # $OBJ{list}       = $LIST{CL_ITEMS};
        # $OBJ{inspectIDX} = $newIDX;
        # my $list = $LIST{CL_ITEMS};
        # my $json = encode_json \%OBJ;
        return ($newIDX);
        # $list = "$newIDX; ".join("; ", keys %DATA);
        # return ($list);
        }
    sub btn_checkInTicket (){
        my $inRound  = $q->param('inRound');
        my $teamIDX  = $q->param('teamIDX');
        my $eventIDX = $q->param('eventIDX');
        my $classIDX = $q->param('classIDX');
        my $inNumber = $q->param('inNumber');
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getTicketDetails($eventIDX, $teamIDX, $inRound)};
        my %LIST = %{$Flight->_getInspectionList()};
        my $flightIDX = $TIX{PK_FLIGHT_IDX};
        my $inspectIDX = $Flight->_getReinspectKey($flightIDX, 1);
        my $items = $Flight->_getInspectionItems($flightIDX);
        my @REASONS = @{$Flight->_getReasonsNoScore()};
        # push (@REASON_LIST, values %REASONS{$_});
        my @ARRAY_LIST = ();
        my $tagList;
        my $str;
        $str .= '<div class=" w3-card-2 w3-border w3-round w3-padding w3-margin-borttom w3-yellow">';
            my $display = 'none;';
            my $checked = '';
            my $disabled = '';
            if ($TIX{BO_REINSPECT} == 1){$display = ''; $checked = 'checked'}
            # if ($TIX{IN_STATUS} == 0){$disabled = 'disabled'}
            my $data = sprintf ' data-key="PK_FLIGHT_IDX" data-index="%d" data-field="%s" data-round="%d" data-team="%d" data-number="%d" %s', $flightIDX, 'BO_REINSPECT', $inRound , $teamIDX, $inNumber, $disabled;
            $str .= sprintf '<input id="Inspection" type="checkbox" value="%d" class="w3-check ReinspectionCheckBox" %s onclick="openReInspectionStatus(this, %d);" %s> ', $inspectIDX, $data, $flightIDX, $checked;
            $str .= sprintf '<label class="w3-margin-left" for="Inspection"><span class="w3-xlarge w3-text-red">Attempt #: %03s-%02d - Re-Inspection Required. </span></label>', $inNumber, $inRound;
            $str .= sprintf '<div ID="reinspectionChecklist" class="container" style="display: %s" >', $display;
                $str .= '<h4>Items to be Reinspected</h4>';
                $str .= '<div class="tag-container">';
                $str .= '<div class="w3-dropdown-hover" style="align-items: center; flex: 1; background: #FFFFFF;">';
                $str .= sprintf '<input type="text" ID="InspectionItemInput"  autocomplete="off" class="w3-input" data-key="%d" onKeyUp="createInputTag(event, this);" style="flex: 1; font-size: 16px; padding: 5px; border:1; outline: none; width: 100%;">', $flightIDX;
                $str .= '<div id="InspectionDiv" class="divInput w3-dropdown-content w3-bar-block w3-card-2 w3-white" style="max-height: 600px;  overflow-y: scroll">';
                $str .= '<ul ID="InspectionDiv_List" class="w3-ul">';
                foreach $inspectionIDX (sort {lc($LIST{$a}{TX_ITEM}) cmp lc($LIST{$b}{TX_ITEM})} keys %LIST) {
                    my $txItem = $LIST{$inspectionIDX}{TX_ITEM};
                    push(@ARRAY_LIST, $txItem);
                    $str .= &T_inspectionListItem($flightIDX, $txItem);
                }
                $str .= '</ul>';
                $str .= '</div>';
                $str .= '</div>';
                $str .= '</div>';
                $str .= '<div class="w3-panel w3-pale-yellow w3-topbar w3-bottombar w3-border-amber w3-small">Team will not be able to fly with this aircraft until they\'ve clear reinspection or has been approved to use their backup aircraft<br>';
                $str .= '<ol class="w3-margin-top"><b>There are two ways to clear inspection.</b>';
                $str .= '<li class="w3-margin-left">Reinpsection is cleared by the Tech Inspector.</li>';
                $str .= '<li class="w3-margin-left">Click on the Inspection Log tab below and click on [Clear Inspection] button.</li>';
                $str .= '</ol>';
                $str .= '</div>';
                $str .= '</div>';
            $str .= '</div>';
        $str .= '<div class="w3-container w3-border w3-card-4" style="height: 800px; overflow-y: scroll; padding: 0px" >';
        $str .= '<div class="w3-row" style="padding: 0px;">';
            # $str .= &t_ticketStatus($flightIDX, $inNumber, $teamIDX, $classIDX, $inRound, $TIX{BO_OUT}, $TIX{BO_REINSPECT});
            $str .= '<div class="w3-white w3-container"  style="padding: 0px;">';
            # $str .= '<div class="w3-white w3-container w3-threequarter"  style="padding: 0px;">';
                $str .= '<div class="w3-bar w3-black">';
                    $str .= sprintf '<button class="w3-bar-item w3-button tablink w3-border-left w3-white" onclick="openTab(this,\'ticketLog\', %d, %d)">#%03d: Ticket Logs</button>', $teamIDX, $classIDX, $inNumber ;
                    if ($classIDX==2){
                        $str .= sprintf '<button class="w3-bar-item w3-button tablink w3-border-left" onclick="openTab(this,\'advancedGTV\', %d, %d)">Ground Transport Vehicle (GTV)</button>', $teamIDX, $classIDX ;
                    }
                    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="openTab(this,\'inspectionLog\', %d, %d)">Inspection Logs</button>', $teamIDX, $classIDX ;
                    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="openTab(this,\'teamData\', %d, %d)">Team Data</button>', $teamIDX, $classIDX;
                    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="openTab(this,\'teamDocuments\', %d, %d)">Team Documents</button>', $teamIDX, $classIDX ;
                    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="openTab(this,\'teamScore\', %d, %d)">Team Scoring</button>', $teamIDX, $classIDX ;
                $str .= '</div>';
                $str .= '<div id="ticketLog" class="w3-container w3-border-0 w3-border-left w3-border-right w3-border-bottom w3-padding-bottom tabContent" style="min-height: 600px;">';
                    $str .= sprintf '<h2 class="w3-margin-left">#%03d: Ticket Logs</h2>', $inNumber;

                    if ($classIDX==3){ # Micro Class Ticket Logs
                        $str .= &MicroClassTicketLog($eventIDX, $teamIDX, $inRound);
                    } elsif ($classIDX==2) { # Advanced Class Ticket Logs
                        $str .= &AdvancedClassTicketLog($eventIDX, $teamIDX, $inRound);
                    } else { # Regular Class Ticket Logs
                        $str .= &RegularClassTicketLog($eventIDX, $teamIDX, $inRound);
                    }
                    $str .= '<br><br>';

                $str .= '</div>';

                $str .= '<div id="advancedGTV" class="w3-container w3-border-0 w3-border-left w3-border-right w3-border-bottom w3-round tabContent" style="min-height: 600px;border-top: none; display: none;">';
                    $str .= sprintf '<h2 class="w3-margin-left">#%03d: Ground Transport Vehicle</h2>', $inNumber;
                    $str .= '<div id="advancedGTV_content" class="w3-container w3-border-0 "></div>';
                $str .= '</div>';

                $str .= '<div id="inspectionLog" class="w3-container w3-border-0 w3-border-left w3-border-right w3-border-bottom w3-round tabContent" style="min-height: 600px;border-top: none; display: none;">';
                    $str .= sprintf '<h2 class="w3-margin-left">#%03d: Inspection Logs</h2>', $inNumber;
                    $str .= '<div id="inspectionLog_content" class="w3-container w3-border-0 "></div>';
                $str .= '</div>';

                $str .= '<div id="teamData" class="w3-container w3-border-0 w3-border-left w3-border-right w3-border-bottom w3-round tabContent" style="min-height: 600px;border-top: none; display: none;">';
                    $str .= sprintf '<h2 class="w3-margin-left">#%03d: Team Data</h2>', $inNumber;
                    $str .= '<div id="teamData_content" class="w3-container w3-border-0 "></div>';
                $str .= '</div>';

                $str .= '<div id="teamDocuments" class="w3-container w3-border-0 w3-border-left w3-border-right w3-border-bottom w3-round tabContent" style="min-height: 600px;border-top: none; display: none;">';
                    $str .= sprintf '<h2 class="w3-margin-left">#%03d: Team Documents</h2>', $inNumber;
                    $str .= '<div id="teamDocuments_content" class="w3-container w3-border-0 "></div>';
                $str .= '</div>';

                $str .= '<div id="teamScore" class="w3-container w3-border-0 w3-border-left w3-border-right w3-border-bottom w3-round tabContent" style="min-height: 600px;border-top: none; display: none;">';
                    $str .= sprintf '<h2 class="w3-margin-left">#%03d: Team Scoring</h2>', $inNumber;
                    $str .= '<div id="teamScore_content" class="w3-container w3-border-0 "></div>';
                $str .= '</div>';
            $str .= '</div>';
        $str .= '</div>';
        my %data;
        $data{items}     = $items;
        $data{html}      = $str;
        $data{tagList}   = join (";",@ARRAY_LIST);
        $data{reasons}   = $TIX{CL_REASON};
        $data{flyStatus} = $TIX{IN_STATUS};
        $data{reasonList} = join(";", @REASONS);
        my $json = encode_json \%data;
        return ($json);

        # return ($str);
        }
    sub addItemToReasonList (){
        my $flightIDX= $q->param('flightIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
        my $newIDX = $JsonDB->_insert('TB_REASON', \%DATA);
        my $Flight = new SAE::FLIGHT();
        my @LIST = @{$Flight->_getReasonsNoScore()};
        my $str;
        foreach $txReason (sort {$a <=> $b} @LIST) {
            $str .= &t_reasonListItem($flightIDX, $txReason);
        }
        return ($str);
        }
    sub addItemToInspectinList (){
        my $flightIDX= $q->param('flightIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
        my $newIDX = $JsonDB->_insert('TB_INSPECTION', \%DATA);
        my $Flight = new SAE::FLIGHT();
        my %LIST = %{$Flight->_getInspectionList()};
        my $str;
        foreach $inspectionIDX (sort {lc($LIST{$a}{TX_ITEM}) cmp lc($LIST{$b}{TX_ITEM})} keys %LIST) {
            my $txItem = $LIST{$inspectionIDX}{TX_ITEM};
            $str .= &T_inspectionListItem($flightIDX, $txItem);
        }
        return ($str);
        }
    sub deleteInspectionItemFromDatabase (){
        my $txItem= $q->param('txItem');
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
           $JsonDB->_delete('TB_INSPECTION', qq(TX_ITEM='$txItem'));

        return ($str);
        }
    sub deleteReasonItemFromDatabase (){
        my $txItem= $q->param('txItem');
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $JsonDB = new SAE::JSONDB();
           $JsonDB->_delete('TB_REASON', qq(TX_REASON='$txItem'));

        return ($str);
        }
    sub addTicket (){
        my %DATA     = %{decode_json($q->param('jsonData'))};
        my $JsonDB   = new SAE::JSONDB();
        my %OBJ;
        print $q->header();
        # my $classIDX = $DATA{'FK_CLASS_IDX'};

        my $inNumber = delete($DATA{'IN_NUMBER'});
        my $flightIDX = $JsonDB->_insert('TB_FLIGHT', \%DATA);
        my $tag;
        $tag = &t_ticket($inNumber, $DATA{IN_ROUND}, $flightIDX, $DATA{FK_TEAM_IDX}, $DATA{FK_CLASS_IDX}, 0, 0, 0);

        $OBJ{tag} = $tag;
        $OBJ{flightIDX} = $flightIDX;
        $OBJ{teamIDX} = $DATA{FK_TEAM_IDX};
        my $json = encode_json \%OBJ;
        return($json);
        }
    sub flight_confirmFlightTicket (){
        my $idx= $q->param('idx');
        my $teamIDX= $q->param('teamIDX');
        my $inNumber= $q->param('inNumber');
        my $classIDX= $q->param('classIDX');
        my %OBJ;
        print $q->header();
        my $Flight = new SAE::FLIGHT();
        my $JsonDB = new SAE::JSONDB();
        # Checking to see if the Flight has a reinspection requirement.  If yes, update  TB_TEAM; BO_REINSPECT = 0.
        my $boReinspect = $Flight->_getFlightInspectionStatus($idx);
        $OBJ{REFRESH} = 'No';
        if ($boReinspect == 1){
            my %DATA;
            $DATA{BO_REINSPECT} = 0;
            $JsonDB->_update('TB_TEAM', \%DATA, qq(PK_TEAM_IDX=$teamIDX));
            $OBJ{REFRESH} = 'Yes';
            $OBJ{BUTTON} = &t_addTicketButton($teamIDX, $inNumber, 0, $classIDX);
        }
        $JsonDB->_delete('TB_FLIGHT', qq(PK_FLIGHT_IDX=$idx));
        my $str;
        $OBJ{FK_FLIGHT_IDX} = $idx;
        $OBJ{BO_REINSPECT} = $boReinspect;
        $OBJ{FK_TEAM_IDX} = $teamIDX;
        $OBJ{IN_NUMBER} = $inNumber;
        $OBJ{BO_STATUS} = 0;
        my $json = encode_json \%OBJ;
        return($json);
        }
    sub sae_ps_updateTicketStatus (){
        my $eventIDX= $q->param('eventIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $flightIDX = $DATA{VALUE_IDX};
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getFlightTicketDetails($flightIDX)};
        my $boTicketReinspect = $TIX{BO_REINSPECT};
        my $inStatus          = $TIX{IN_STATUS};
        my $inRound           = $TIX{IN_ROUND};
        my $classIDX          = $TIX{FK_CLASS_IDX};
        my $boReinspect       = $TIX{TEAM_INSPECT_STATUS};
        my $inNumber          = $TIX{IN_NUMBER};
        my $teamIDX           = $TIX{FK_TEAM_IDX};
        my $ticket = &t_ticket($inNumber, $inRound, $flightIDX, $teamIDX, $classIDX, $boTicketReinspect, $boReinspect, $inStatus);
           $DATA{TICKET} = $ticket;
        my $json = encode_json \%DATA;
        my $str = $flightIDX ;

        return ($json);
        }
    sub sae_ps_unclearInspectionTicket (){
        print $q->header();
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $teamIDX        = $DATA{FK_TEAM_IDX};
        my $inNumber       = $DATA{IN_NUMBER};
        my $inRound        = $DATA{IN_ROUND};
        my $classIDX       = $DATA{FK_CLASS_IDX};
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getFlightTickets($teamIDX)};

        my $tickets;
        my %OBJ;
        my @TEST;
        my @TEST2;
        foreach $flightIDX (sort {$TIX{$a}{IN_ROUND} <=> $TIX{$b}{IN_ROUND}} keys %TIX){
            my $boTicketReinspect = $TIX{$flightIDX}{BO_REINSPECT};
            my $inStatus    = $TIX{$flightIDX}{IN_STATUS};
            my $inRound     = $TIX{$flightIDX}{IN_ROUND};
               $classIDX    = $TIX{$flightIDX}{FK_CLASS_IDX};
            my $boReinspect = $TIX{$flightIDX}{TEAM_INSPECT_STATUS};
            $tickets .= &t_ticket($inNumber, $inRound, $flightIDX, $teamIDX, $classIDX, $boTicketReinspect, $boReinspect, $inStatus);
            push(@TEST, $boTicketReinspect);
            push(@TEST2, $boReinspect);
        }
        $str = &t_addTicketButton($teamIDX, $inNumber, 1, $classIDX);
        $OBJ{addButton} = &t_addTicketButton($teamIDX, $inNumber, 1, $classIDX);
        $OBJ{tickets} = $tickets;
            $OBJ{boTicketReinspect} = join(' | ', @TEST);
            $OBJ{boTeamReinspect} = join(' | ', @TEST2);
            # $OBJ{inStatus} = $inStatus;
        
        # $OBJ{teamIDX } = $teamIDX ;

        my $json = encode_json \%OBJ;
        return ($json);
        }
    sub updateAddTicketStatus (){
        # my $eventIDX= $q->param('eventIDX');
        my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $Tech = new SAE::TECH();
        my $Flight = new SAE::FLIGHT();
        my %TIX = %{$Flight->_getFlightTicketDetails($DATA{FK_FLIGHT_IDX})};
        my $boTicketReinspect = $TIX{BO_REINSPECT};
        my $inStatus          = $TIX{IN_STATUS};
        my $inRound           = $TIX{IN_ROUND};
        my $classIDX          = $TIX{FK_CLASS_IDX};
        my $boReinspect       = $TIX{TEAM_INSPECT_STATUS};
        my $inNumber          = $TIX{IN_NUMBER};
        my $flightIDX         = $DATA{FK_FLIGHT_IDX};
        my $teamIDX           = $DATA{FK_TEAM_IDX};
        my $inspectIDX        = $DATA{PK_REINSPECT_IDX};
        if ($DATA{BO_STATUS} == 1) {
            $DATA{BUTTON} = &t_addTicketButton($teamIDX, $inNumber, 1, $classIDX);
        } else {
            $DATA{BUTTON} = &t_addTicketButton($teamIDX, $inNumber, 0, $classIDX);
        }
        my $ticket = &t_ticket($inNumber, $inRound, $flightIDX, $teamIDX, $classIDX, $boTicketReinspect, $boReinspect, $inStatus);
        $DATA{TICKET} = $ticket;
        $DATA{INSPECT_BUTTON} = $Tech->_getTechButton($DATA{inspectIDX});
        my $json = encode_json \%DATA;
        return($json);
        # return ($str);
        }
    sub loadTeamData (){
        my $teamIDX= $q->param('teamIDX');
        # my %DATA = %{decode_json($q->param('jsonData'))};
        print $q->header();
        my $Team = new SAE::TEAM($teamIDX);
        my %TEAM = %{$Team->_getTeamData()};

        my $str;
        $str .= '<table class="w3-table">';
        $str .= &t_teamDataRow('UUID', $teamIDX);
        $str .= &t_teamDataRow('Team Number', $TEAM{IN_NUMBER});
        $str .= &t_teamDataRow('Aircraft Class', $CLASS{$TEAM{FK_CLASS_IDX}});
        $str .= &t_teamDataRow('Team Name', $TEAM{TX_NAME});
        $str .= &t_teamDataRow('School', $TEAM{TX_SCHOOL});
        $str .= &t_teamDataRow('Country', $TEAM{TX_COUNTRY});
        $str .= &t_teamDataRowEditable('Slope', $TEAM{IN_SLOPE}, 'TB_TEAM', 'PK_TEAM_IDX', $teamIDX, 'IN_SLOPE');
        $str .= &t_teamDataRowEditable('Y-Intercept', $TEAM{IN_YINT}, 'TB_TEAM', 'PK_TEAM_IDX', $teamIDX, 'IN_YINT');
        $str .= &t_teamDataRowEditable('Team Provided Standard Diviation', $TEAM{IN_STD}, 'TB_TEAM', 'PK_TEAM_IDX', $teamIDX, 'IN_STD');
        $str .= '</table>';
        # $str .= sprintf 'Team Number = %03d', substr("000".$TEAM{IN_NUMBER},0,-3);
        return ($str);
        }
    sub loadTeamDocuments (){
        my $teamIDX= $q->param('teamIDX');
        print $q->header();
        my $Team = new SAE::TEAM($teamIDX);
        my %DOCS = %{$Team->_getTeamDocuments($teamIDX)};
        my %PAPER = (1=>'Design Report', 2=>'TDS', 3=>'Drawing');
        my $str;
        foreach $paperIDX (sort {$PAPER{$a} cmp $PAPER{$b}} keys %PAPER) {
            $str .= '<div class="w3-container w3-margin" style="display: flex">';
            $str .= sprintf '<i class="fa fa-file-pdf-o fa-5x" aria-hidden="true" ></i><a class="w3-link w3-margin-left" style="align-items: center; text-decoration: none !important;" href="read.html?fileID=%s" target="_blank">%s</a>', $DOCS{$paperIDX}{TX_KEYS}, $DOCS{$paperIDX}{TX_FILENAME};
            # $str .= sprintf '<div ID="uploadedDisplay_%d"><a href="read.html?fileID=%s" target="_blank">%s</a></div>', $paperIDX, $DOCS{$paperIDX}{TX_KEYS}, $DOCS{$paperIDX}{TX_FILENAME}; 
            $str .= '</div>';

        }
        return ($str);
        }
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
        my %TICKETS = %{$Flight->_getTicketByEvent($location)};
        %ROW = (0=>'w3-white', 1=>'w3-light-grey');
        my $counter = 0;
        my $height = 45;
        $str .= '<div class=" w3-container w3-margin-top w3-row"><br>';
        
        $str .= '<div class="w3-bar w3-white w3-large w3-border w3-round w3-margin-top">';
        $str .= '<span class="w3-bar-item w3-button">Flight Logs</span>';
        $str .= '<div class="w3-dropdown-hover">';
        $str .= '<button class="w3-button">Event Attributes</button>';
        $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
        $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" onclick="sae_showListOfMissingSlope();" >Regular Class: Prediction Line (Slope & Y-Intercepts)</a>';
        $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" onclick="sae_showListOfMissingStd();">Advanced Class: Standard Deviation</a>';
        $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" onclick="sae_showSetFlightTicketLimits();">Tickets: Event Attributes</a>';
        $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" onclick="sae_showUsedTicketCount();">Tickets: Used Counts</a>';
        $str .= '</div>';
        $str .= '</div>';
        $str .= '</div><br>';

        $str .= '<table class="w3-table-all w3-white w3-hoverable w3-bordered">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th nowrap>Team #</th>';
        $str .= '<th>Ticket Status</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        # for ($n=1; $n<=15; $n++){
        #     $str .= &t_flightTable($n);
        # }
        foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
            my $inNumber =$TEAMS{$teamIDX}{IN_NUMBER};
            my $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
            my $team     = $TEAMS{$teamIDX}{TX_SCHOOL};
            my $txCountry =  $TEAMS{$teamIDX}{TX_COUNTRY};
            my $boReinspect = $TEAMS{$teamIDX}{BO_REINSPECT};
            my $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
            
            $str .= '<tr>';
            # $str .= '<td contenteditable="true">';
            $str .= sprintf '<td>',;
            $str .= &t_addTicketButton($teamIDX, $inNumber, $boReinspect, $classIDX);
            $str .= '</td>';
            $str .= '<td class="wrapper">';
            $str .= sprintf '<p><b>%s</b> (<i>%s</i>)</p>', $team, $txCountry;
            $str .= '<div class="content">';
            $str .= sprintf '<ul ID="ticketBucket_%d">',$teamIDX;
            foreach $flightIDX (sort {$TICKETS{$teamIDX}{$a}{IN_ROUND} <=> $TICKETS{$teamIDX}{$b}{IN_ROUND}} keys %{$TICKETS{$teamIDX}}){
                my $boTicketReinspect = $TICKETS{$teamIDX}{$flightIDX}{BO_REICOUNTRY};
                my $inStatus = $TICKETS{$teamIDX}{$flightIDX}{IN_STATUS};
                $str .= &t_ticket($inNumber, $TICKETS{$teamIDX}{$flightIDX}{IN_ROUND}, $flightIDX, $teamIDX, $classIDX, $boTicketReinspect, $boReinspect, $inStatus);
            }
            $str .= '</ul>';
            $str .= '</td>';
            $str .= '</tr>';
            
        }
        $str .= '</tbody>';
        $str .= '</table>';

        # $str .= '<ul class="w3-ul">';
        # foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        #     if ($TEAMS{$teamIDX}{IN_NUMBER} < 200) {next}
        #     my $txFlightStatus = $TEAMS{$teamIDX}{TX_FLIGHT_BUTTON};
        #     # my $btn = $Flight->_tempFlightLogButton($teamIDX, $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_NAME}, $TEAMS{$teamIDX}{TX_COUNTRY}, $TEAMS{$teamIDX}{FK_CLASS_IDX}, $TEAMS{$teamIDX}{IN_FLIGHT_STATUS});
        #     if ($TEAMS{$teamIDX}{TX_FLIGHT_BUTTON}) {
        #         $str .=  $txFlightStatus;
        #     } else {
        #         $str .= $Flight->_tempCheckOutButton($teamIDX, 1);
        #     }
        # }
        # $str .= '</ul>';
        $str .= '</div>';
        return ($str);
        }
    
## =========================================================================================================================
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
    sub sae_showUsedTicketCount(){
        print $q->header();
        my $eventIDX = $q->param('eventIDX');
        my $Flight = new SAE::FLIGHT();
        my $Event = new SAE::EVENT($eventIDX);
        my %EVENT = %{$Event->_getEvent($eventIDX)};
        my $max = $EVENT{IN_MAX_TICKET};
        my %CLASS = (1=>'Regular',2=>'Advanced',3=>'Micro');
        my $str;
        my $bar;
        my %TEAMS = %{$Flight->_getTeamByLocation($eventIDX)};
        my %TICKETS = %{$Flight->_getUsedTicketCount($eventIDX)};

        $bar = '<div class="w3-container w3-border w3-margin-top w3-card-2 " style="overflow-y: scroll; height: 450px;">';
        # foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $count = 0;
        my $teamAttempted = 0;
        my %COUNT;
        foreach $teamIDX (sort {$TICKETS{$b}{IN_USED} <=> $TICKETS{$a}{IN_USED}} keys %TICKETS) {
            my $used = $TICKETS{$teamIDX}{IN_USED};
            my $percent = 0;
            my $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
            if ($max > 0){
                if ($used>$max){$used = $max}
                $percent = ($used/$max) * 100;
                $bar .= sprintf '%03d - %s<br>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
                $bar .= '<div class="w3-light-grey">';
                $bar .= sprintf '<div class="w3-container w3-green w3-center" style="width:%d%">%d</div>', $percent, $used;
                $bar .= '</div><br>';
                $count += $used;
                $teamAttempted++;
                $COUNT{$classIDX}{USED} += $used;
                $COUNT{$classIDX}{ATTEMPTS}++;
                if ($TICKETS{$teamIDX}{IN_STATUS} == 1) {
                    $COUNT{$classIDX}{SUCCESS} = $used;
                } else {
                    $COUNT{$classIDX}{NF} += $used;
                }
            } else {
                $percent = 0;
                $bar .= sprintf '%03d <br>', $TEAMS{$teamIDX}{IN_NUMBER};
                $bar .= '<div class="w3-light-grey">';
                $bar .= sprintf '<div class="w3-container w3-green" style="width:0%">%d/%d</div>', $used, $max;
                $bar .= '</div>';
                $count += $used;
            }
            
        }
        $bar .= '</div>';
        $str = '<div class="w3-container">';
        $str .= '<table class="w3-table-all">';
        $str .= '<tr>';
        $str .= '<th>Class</th>';
        $str .= '<th># of teams attempted</th>';

        $str .= '<th>Total number of Attempts</th>';
        $str .= '<th>Average (eqv: Rounds)</th>';
        $str .= '</tr>';
        for ($i=1; $i<=3; $i++){
            $str .= '<tr>';
            $str .= sprintf '<td>%s</td>', $CLASS{$i};
            $str .= sprintf '<td>%d</td>', $COUNT{$i}{ATTEMPTS};
            $str .= sprintf '<td>%d</td>', $COUNT{$i}{USED};
            $str .= sprintf '<td>%d</td>', ($COUNT{$i}{USED}/$COUNT{$i}{ATTEMPTS});
            $str .= '</tr>';
        }
        $str .= '<tr class="w3-large">';
        $str .= sprintf '<th>Total</th>', $CLASS{$i};
        $str .= sprintf '<th>%d   </th>', $teamAttempted;
        $str .= sprintf '<th>%d   </th>', $count;
        $str .= sprintf '<th>%d   </th>', ($count/$teamAttempted);
        $str .= '</tr>';
        $str .= '</table>';
        # $str .= sprintf 'Total Flight Attempts = %d<br>', $count;
        # $str .= sprintf 'Total # of team that made an attempt = %d<br>', $teamAttempted;
        # $str .= sprintf 'Average Attempts Per Team = %d', ($count/$teamAttempted);
        # $str .= sprintf '<hr>Total Regular Class Attempts = %d<br>', ($COUNT{1}{USED});
        # $str .= sprintf 'Total Regular Teams = %d<br>', ($COUNT{1}{ATTEMPTS});
        # $str .= sprintf 'Total Regular Class Attempts = %d', ($COUNT{1}{USED}/$COUNT{1}{ATTEMPTS});
        
        $str .= '</div>';
        $str .= $bar;
        return ($str);
        }
    sub sae_updateFlightCardField(){
        print $q->header();
        my $Flight = new SAE::FLIGHT();
        my $inValue = $q->param('inValue');
        my $txField = $q->param('txField');
        my $flightIDX = $q->param('flightIDX');
        my $teamIDX = $q->param('teamIDX');
        my $str;
        # if ($txField eq 'FK_WEATHER_IDX') {
        #     my $Weather = new SAE::WEATHER();
        #     my %DATA = %{$Weather->_getWeather($inValue)};
        #     foreach $field (sort keys %DATA ) {
        #         $Flight->_updateFlightField($flightIDX, $field, $DATA{$field}, $teamIDX);
        #     }
        # } else {
            $Flight->_updateFlightField($flightIDX, $txField, $inValue, $teamIDX);
        # }
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
    sub sae_calcFlightScores(){
        # print $q->header();
        my $classIDX = $q->param('classIDX');
        my $str;
        if ($classIDX == 3) {
            $str = &sae_calcMicroScore();
        } elsif ($classIDX == 2) {
            $str = &sae_calcAdvanceScore();
        } else {
            $str = &sae_calcRegularScore();
        }
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
        $str .= sprintf '<button class="w3-bar-item w3-button tablink %s " onclick="sae_openTab(this, \'%s\');">Flight Logs</button>', $activeTab,'Logs';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">Prediction Data</button>', 'Data';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">Final Score</button>', 'Score';
        $str .= '</div>';
        
        $str .= '<div id="Logs" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs ">';
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Attempts</p></div>';
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
            $str .= sprintf '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Round</span><input  tabindex="'.$tabIndex.'" class="w3-input w3-border w3-round w3-center" type="number" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></div>', $inRound, $flightIDX, 'IN_ROUND', $teamIDX;
            $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Length of Cargo</span>';
            $str .= sprintf '<input tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0" type="number" placeholder="0.0" value="%2.2f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></div>',$Logs->getInLcargo(), $flightIDX, 'IN_LCARGO', $teamIDX ;
            
            $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Wing Span</span>';
            $str .= sprintf '<input  tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.1" min="0"  type="number" placeholder="0.0" value="%2.2f"  onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></div>',$Logs->getInSpan(),$flightIDX, 'IN_SPAN', $teamIDX ;
            
            $str .= '<div class="w3-col l1 w3-center"><span class="w3-hide-large w3-left">Time of Flight</span>';
            
            # $str .= $weatherIDX;
            $str .= sprintf '<select tabindex="'.($tabIndex++).'" ID="TX_TIME_%d" class="w3-border w3-input w3-round" style="height: 40px;" onchange="sae_updateTimeOfFlight(this, %d);">', $flightIDX, $flightIDX, $teamIDX;
            $str .= '<option value="0" selected disabled>+ Time</option>';
            foreach $hourIDX (sort {$b <=> $a} keys %HOURS){
                my $selected = '';
                if ($hourIDX == $weatherIDX) {$selected = 'selected'}
                $str .= sprintf '<option value="%d" '.$selected.' data-value="%5.4f">%s</option>', $hourIDX, $HOURS{$hourIDX}{IN_DENSITY}, $HOURS{$hourIDX}{TS_LOCAL};
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
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-green w3-hover-green w3-card-2 w3-round w3-small"       style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Good</button>',   $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-blue w3-card-2 w3-round w3-small"  style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">No Fly</button>', $flightIDX, 2, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-orane w3-card-2 w3-round  w3-small"     style="width: 70px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Crash</button>',  $flightIDX, 3, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round w3-small" style="width: 70px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-red w3-round w3-small" style="width: 70px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Cancel</button>', $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
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
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-red w3-round w3-small" style="width: 70px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Delete</button>', $flightIDX, 0, $teamIDX, $inNumber, $classIDX, $inRound;
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
            my $Report = new SAE::REPORTS();
            my %REPORT = %{$Report->_getTeamDocuments($teamIDX)};
            # $str .= scalar(keys %REPORT).'<br>';
            foreach $inPaper (sort {$a <=> $b} keys %REPORT ) {
                my $fileID = $REPORT{$inPaper}{TX_KEYS};
                my $docType = $REPORT{$inPaper}{TX_PAPER};
                my $fileName = $REPORT{$inPaper}{TX_FILENAME};
                $str .= '<div class="w3-col l12 w3-border w3-round w3-margin-top w3-padding">';
                $str .= sprintf '<label>%s</label><br>', $docType;
                $str .= sprintf '<i class="fa fa-download" aria-hidden="true"></i><a class="w3-link w3-margin-left" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">%s</a>', $fileID, $location, $fileID, $location, $fileName;
                $str .= '</div>';
            }
        $str .= '</div>';
        $str .= '<br>'x3;
        $str .= '</div>';
        
        $str .= '<div id="Score" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-padding">';
        $str .= sprintf '<button class="w3-button w3-card-2 w3-border w3-round w3-light-blue w3-hover-blue" onclick="sae_calcRegularScore(%d);">Calculate Final Score</button>', $teamIDX;
        $str .= '<div ID="ScoreContainer" class="w3-panel w3-margin w3-border w3-round w3-padding">';
        $str .= '</div>';
        $str .= '</div>';
        
        $str .= '</div>';
        $str .= "<br>" x3;
        return ($str);
        }
    sub sae_calcRegularScore(){
        print $q->header();
        my $Reg=new SAE::REGULAR();
        my $teamIDX = $q->param('teamIDX');
        my ($maxPPB, $TOPS, $SCORES) = $Reg->_calcTeamScore($teamIDX);
        my %SCORE = %{$SCORES};
        my @SORTED = @$TOPS;
        my %SEEN = ($SORTED[0]=>1,$SORTED[1]=>1,$SORTED[2]=>1);
        my $str = '<table class="w3-table w3-border w3-small">';
        $str .= '<tr>';
        $str .= '<th>Attempts</th>';
        $str .= '<th class="w3-right-align">L-Cargo<br>(in)</th>';
        $str .= '<th class="w3-right-align">Wing<br>Span<br>(in)</th>';
        $str .= '<th class="w3-right-align">Payload<br>Weight<br>(lbs)</th>';
        $str .= '<th class="w3-right-align">Balls<br>Carried<br>(#)</th>';
        $str .= '<th class="w3-right-align">Density<br>Altitude<br>(ft)</th>';
        $str .= '<th class="w3-right-align">Flight Score</th>';
        $str .= '<th class="w3-right-align">Detached<br>Penalties<br>(25%)</th>';
        $str .= '<th class="w3-right-align">Landing<br>Penalties<br>(50%)</th>';
        $str .= '<th class="w3-right-align">Prediction<br>Bonus</th>';
        $str .= '<th class="w3-right-align">Flight Score</th>';
        foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
            if ($SEEN{$flightIDX}){
                $str .= '<tr class="w3-pale-blue">';
            } else {
                $str .= '<tr>';
            }
            
            $str .= sprintf '<td class="w3-center-align">%d</td>', $SCORE{$flightIDX}{IN_ROUND};
            $str .= sprintf '<td class="w3-right-align">%2.2f</td>', $SCORE{$flightIDX}{IN_LCARGO};
            $str .= sprintf '<td class="w3-right-align">%2.2f</td>', $SCORE{$flightIDX}{IN_SPAN};
            $str .= sprintf '<td class="w3-right-align">%2.2f</td>', $SCORE{$flightIDX}{IN_WEIGHT};
            $str .= sprintf '<td class="w3-right-align">%d</td>', $SCORE{$flightIDX}{IN_SPHERE};
            $str .= sprintf '<td class="w3-right-align">%4.2f</td>', $SCORE{$flightIDX}{IN_DENSITY};
            $str .= sprintf '<td class="w3-right-align">%4.4f</td>', $SCORE{$flightIDX}{IN_FS};
            $str .= sprintf '<td class="w3-right-align">-%2.4f</td>', $SCORE{$flightIDX}{IN_MINOR};
            $str .= sprintf '<td class="w3-right-align">-%2.4f</td>', $SCORE{$flightIDX}{IN_MAJOR};
            $str .= sprintf '<td class="w3-right-align">%4.4f</td>', $SCORE{$flightIDX}{IN_BONUS};
            $str .= sprintf '<td class="w3-right-align">%4.4f</td>', $SCORE{$flightIDX}{IN_FFS};
            $str .= '</tr>';
        }
        $str .= '</table>';
        $str .= '<table class="w3-table w3-bordered">';
        my $top3FLights = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS};
        $str .= sprintf '<tr><td class="w3-right-align">Total: Top 3 Flight Scores</td><td class="w3-right-align  w3-text-blue" style="width: 120px;">%2.4f</td></tr>', $top3FLights;
        $str .= sprintf '<tr><td class="w3-right-align">Max Prediction Bonus</td><td class="w3-right-align  w3-text-blue" style="width: 120px;">%2.4f</td></tr>', $maxPPB;
        $str .= sprintf '<tr><td class="w3-right-align">Final Flight Scores</td><td class="w3-right-align w3-xlarge w3-text-blue" style="width: 120px;">%2.4f</td></tr>', $top3FLights + $maxPPB;
        $str .= '</table>';
        return ($str);
        }
    sub sae_showListOfMissingSlope(){
        print $q->header();
        my $eventIDX = $q->param('eventIDX');
        my $Team = new SAE::TEAM();
        my %TEAMS = %{$Team->_getTeamListByClass($eventIDX, 1)};
        my $str;
        $str .= '<div style="height: 650px; overflow-y: scroll;">';
        $str .= '<table class="w3-table w3-bordered w3-hoverable">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 150px;">Slope</th>';
        $str .= '<th style="width: 150px;">Y-Intercept</th>';
        $str .= '<th style="width: 100px;">Team #</th>';
        $str .= '<th>School</th>';
        $str .= '<th style="width: 150px;">TDS</th>';
        $str .= '<th style="width: 150px;">Drawings</th>';
        $str .= '<th style="width: 150px;">Design Report</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        my $Report = new SAE::REPORTS();
        foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
            my %REPORT = %{$Report->_getTeamDocuments($teamIDX)};
            my $tds = $drawing = $report = 'Not Available';
            if ($REPORT{2}{TX_KEYS}) {
                $tds = sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">TDS</a>', $REPORT{2}{TX_KEYS}, $eventIDX, $REPORT{2}{TX_KEYS}, $eventIDX;
            }
            if ($REPORT{3}{TX_KEYS}) {
                $drawing = sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">Drawing</a>', $REPORT{3}{TX_KEYS}, $eventIDX, $REPORT{3}{TX_KEYS}, $eventIDX;
            }
            if ($REPORT{1}{TX_KEYS}) {
                $report = sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">Report</a>', $REPORT{1}{TX_KEYS}, $eventIDX, $REPORT{1}{TX_KEYS}, $eventIDX;
            }
            if ($TEAMS{$teamIDX}{IN_SLOPE} == 0){
                $str .= sprintf '<tr class="w3-pale-yellow">';
            } else {
                $str .= sprintf '<tr>';
            }
            $str .= sprintf '<td><input class="w3-input w3-border w3-round w3-align-right" type="number"  step="0.000001" max="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%1.6f"></td>', 'IN_SLOPE', $teamIDX, $TEAMS{$teamIDX}{IN_SLOPE};
            $str .= sprintf '<td><input class="w3-input w3-border w3-round w3-align-right" type="number"  step="0.01" min="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%1.2f"></td>', 'IN_YINT', $teamIDX, $TEAMS{$teamIDX}{IN_YINT};
            $str .= sprintf '<td>%03d</td>',  $TEAMS{$teamIDX}{IN_NUMBER};
            $str .= sprintf '<td>%s</td>',    $TEAMS{$teamIDX}{TX_SCHOOL};
            $str .= sprintf '<td>%s</td>',    $tds;
            $str .= sprintf '<td>%s</td>',    $drawing;
            $str .= sprintf '<td>%s</td>',    $report;
            $str .= sprintf '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= '</div>';
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
        $str = '<div class="w3-container" style="padding: 1px!important">';
        
        my $activeTab = 'w3-white w3-border-left w3-border-top w3-border-right';
        $str .= '<div class="w3-bar w3-blue-grey">';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink %s " onclick="sae_openTab(this, \'%s\');">Flight Logs</button>', $activeTab,'Logs';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\', %d);">GTV</button>', 'Gtv', $teamIDX;
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">STD</button>', 'Data';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">Final Score</button>', 'Score';
        $str .= '</div>';

        $str .= '<div id="Logs" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs " style="padding: 0px!important">';
        $str .= '<table class="w3-table-all w3-round">';
        $str .= '<tr>';
        $str .= '<th style="width: 100px;" class="w3-center">Attempt</th>';
        $str .= '<th style="width: 130px;" class="w3-center">Time Of<br>Flight</th>';
        $str .= '<th style="width: 70px;" class="w3-center">In Landing<br>Zone</th>';
        $str .= '<th style="width: 110px;" class="w3-center">PADA<br>Distance<br>(ft)</th>';
        $str .= '<th style="width: 110px;" class="w3-center">Payload<br>(lbs)</th>';
        $str .= '<th style="width: 90px;" class="w3-center">Autonomous</th>';
        $str .= '<th style="width: 90px;" class="w3-center">Items<br>Detached<br>Penalty</th>';
        $str .= '<th style="width: 90px;" class="w3-center">Landing<br>Penalty</th>';
        $str .= '<th>Flight Assessment</th>';
        $str .= '<th style="text-align: right;">Remove</th>';
        $str .= '</tr>';
        foreach $inRound (sort {$a <=> $b} keys %FLIGHTS) {
            my $tabIndex = $inRound*100;
            my $flightIDX = $FLIGHTS{$inRound}{PK_FLIGHT_IDX};
            $Logs->getRecordById($flightIDX);
            if ($flightIDX != $fltIDX){$now_string = $Logs->getInTof()}
            
            if ($flightIDX == $fltIDX){
                $str .= sprintf '<tr ID="FlightRecord_%d" class="w3-border w3-pale-blue w3-card-4 w3-round w3-margin-top w3-margin-bottom">', $flightIDX;
                $str .= sprintf '<td class="w3-center"><input  tabindex="'.$tabIndex.'" class="w3-input w3-border w3-round w3-center w3-disabled" disabled type="number" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></td>', $inRound, $flightIDX, 'IN_ROUND', $teamIDX;
            } else {
                $str .= sprintf '<tr ID="FlightRecord_%d" class="w3-border w3-white">', $flightIDX;
                $str .= sprintf '<td class="w3-center"><input  tabindex="'.$tabIndex.'" class="w3-input w3-border w3-round w3-center" type="number" value="%d" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></td>', $inRound, $flightIDX, 'IN_ROUND', $teamIDX;
            }
            # $str .= '<tr>';
            $str .= sprintf '<td><input ID="IN_TOF" value="%s" class="w3-input w3-border w3-round w3-center" step="00:05" type="time" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></td>', $Logs->getInTof(), $flightIDX, 'IN_TOF', $teamIDX;
            my $inZone = $Logs->getBoInzone();
            my $inZoneChecked = '';
            my $inDistanceDisabled = 'disabled';
            my $classDisabled = 'w3-disabled';
            if ($inZone==1){$inZoneChecked = 'checked'; $inDistanceDisabled='';$classDisabled='' }
            $str .= sprintf '<td class="w3-right-align"><input ID="BO_INZONE" value="1" %s class="w3-check w3-border w3-round w3-center" type="checkbox" onchange="sae_updateInZone(this, %d, \'%s\');"></td>', $inZoneChecked, $flightIDX, 'BO_INZONE';
            
            $str .= sprintf '<td><input ID="IN_DISTANCE_%d" value="%d" placeholder="0" class="w3-input w3-border w3-round w3-center %s" %s type="number" min="0" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></td>', $flightIDX, $Logs->getInDistance(), $classDisabled, $inDistanceDisabled, $flightIDX, 'IN_DISTANCE', $teamIDX ;
            $str .= sprintf '<td><input ID="IN_WATER_FLT" value="%2.3f" placeholder="0" class="w3-input w3-border w3-round w3-center" type="number" min="0" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);"></td>', $Logs->getInWaterFlt(), $flightIDX, 'IN_WATER_FLT', $teamIDX;
            
            my $auto = $Logs->getBoApada();
            my $autoChecked = 'checked';
            if ($auto>0){$autoChecked = ''}
            $str .= sprintf '<td class="w3-center"><input ID="AUTO"  name="flightAttribute" class="w3-check w3-border w3-round" type="checkbox" value="0" %s  onClick="sae_updateLandingPenalty(this, %d, \'%s\');"></td>', $autoChecked, $flightIDX, 'BO_APADA';
            
            my $minor = $Logs->getInPenMinor();
            my $minorChecked = '';
            if ($minor>0){$minorChecked = 'checked'}
            $str .= sprintf '<td class="w3-center"><input ID="MINOR" name="flightAttribute" class="w3-check w3-border w3-round w3-center" type="checkbox" value="1" %s onClick="sae_updateLandingPenalty(this, %d, \'%s\');"></td>', $minorChecked, $flightIDX, 'IN_PEN_MINOR';
            
            my $major = $Logs->getInPenLanding();
            my $majorChecked = '';
            if ($major>0){$majorChecked = 'checked'}
            $str .= sprintf '<td class="w3-center"><input ID="MAJOR" name="flightAttribute" class="w3-check w3-border w3-round w3-center" type="checkbox" value="1" %s onClick="sae_updateLandingPenalty(this, %d, \'%s\');"></td>', $majorChecked, $flightIDX, 'IN_PEN_LANDING';
            
            my $Status = $Logs->getInStatus();
            
            if ($flightIDX == $fltIDX){
                $str .= '<td style="text-align: left;">';
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-green w3-hover-green w3-card-2 w3-round w3-small"          style="width: 90px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Good</button>',   $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-blue w3-card-2 w3-round  w3-small"    style="width: 90px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">No Fly</button>', $flightIDX, 2, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-orange w3-card-2 w3-round  w3-small"        style="width: 90px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Crash</button>',  $flightIDX, 3, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round  w3-small" style="width: 90px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
                $str .= '</td>';
                $str .= '<td style="text-align: right;">';
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-white w3-hover-red w3-round w3-small" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Remove</button>', $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= '</td>';
            } else {
                $str .= '<td style="text-align: left;">';
                $str .= sprintf '<select ID="flightState_'.$flightIDX.'" class="w3-select w3-margin-bottom w3-mobile w3-margin-right w3-border w3-round " style="width: 60%; height: 40px;" onchange="sae_updateFlightState(this, %d, %d, %d, %d, %d);">', $flightIDX, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<option value="0" selected>No Status</option>';
                foreach $inStatus (sort {$a<=>$b} keys %STATUS){
                    my $selected = '';
                    if ($Status == $inStatus){$selected = 'selected'}
                    $str .= sprintf '<option value="%d" %s>%s</option>', $inStatus, $selected, $STATUS{$inStatus};
                }
                $str .= '</select>';
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round  w3-small" style="width: 90px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
                $str .= '</td>';
                $str .= '<td style="text-align: right;">';
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-hover-pink w3-hover-red w3-round w3-small"  onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Remove</button>', $flightIDX, 0, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= '</td>';
            }
            $str .= '</tr>';
        }

        $str .= '</table>';
        $str .= '</div>';

        
        $str .= '<div id="Gtv" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide  w3-padding"></div>';

        $str .= '<div id="Data" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-padding">';
        $str .= '<label>Team Supplied Standard Deviation:</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round w3-text-blue w3-center-align" type="number" value="%2.1f" style="width: 100px; display: inline" onchange="sae_updateTeamInfo(this,\'%s\',%d)"><span> ft</span>', $Team->getInStd(), 'IN_STD', $teamIDX;
        
        my $Report = new SAE::REPORTS();
        my %REPORT = %{$Report->_getTeamDocuments($teamIDX)};
        # $str .= scalar(keys %REPORT).'<br>';
        foreach $inPaper (sort {$a <=> $b} keys %REPORT ) {
            my $fileID = $REPORT{$inPaper}{TX_KEYS};
            my $docType = $REPORT{$inPaper}{TX_PAPER};
            my $fileName = $REPORT{$inPaper}{TX_FILENAME};
            $str .= '<div class="w3-container w3-border w3-round w3-margin-top w3-padding">';
            $str .= sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">[ %s ] - %s</a>', $fileID, $location, $fileID, $location, $docType, $fileName;
            $str .= '</div>';
        }
        
        $str .= '</div>';
        
        
        
        $str .= '<div id="Score" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-padding">';
        $str .= sprintf '<button class="w3-button w3-card-2 w3-border w3-round w3-light-blue w3-hover-blue" onclick="sae_calcAdvanceScore(%d);">Calculate Final Score</button>', $teamIDX;
        $str .= '<div ID="ScoreContainer" class="w3-panel w3-margin w3-border w3-round w3-padding">';
        $str .= '</div>';
        $str .= '</div>';
        
        $str .= '</div>';
        $str .= "<br>";
        return ($str);
        }
    sub sae_getMaxEffectiveWater(){
        print $q->header();
        my $adv = new SAE::ADVANCED();
        my $teamIDX = $q->param('teamIDX');
        my $Team = new SAE::TB_TEAM();
        $Team->getRecordById($teamIDX);
        my ($inStd, $boAuto, $inWater, $waterFlown, $SCORES) = $adv->_calcTeamScore($teamIDX);
        my $str = '<label>Total Water (lbs) delivered by GTV During Demonstration:</label><br>';
        $str .= sprintf '<input class="w3-input w3-border w3-round  w3-text-blue" type="number" value="%2.2f" style="width: 100px; display: inline!important;" max="%2.2f" step="0.1" onchange="sae_updateGTVWaterCarried(this,\'%s\',%d, %2.2f);"> out of <span ID="SPAN_MAX_LIMIT">%2.2f</span>', $Team->getInWater(), $waterFlown, 'IN_WATER', $teamIDX, $waterFlown, $waterFlown;
        $str .= '<br>';
        $str .= '<label>Water was delivered autonomously</label><br>';
        if ($Team->getBoAuto()==1){
            $str .= sprintf '<input type="radio" name="gtv-auto" checked value="1" onchange="sae_updateTeamInfo(this,\'%s\',%d)"> Yes<br>', 'BO_AUTO', $teamIDX;
            $str .= sprintf '<input type="radio" name="gtv-auto" value="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)"> No<br>', 'BO_AUTO', $teamIDX;
        } else {
            $str .= sprintf '<input type="radio" name="gtv-auto" value="1" onchange="sae_updateTeamInfo(this,\'%s\',%d)"> Yes<br>', 'BO_AUTO', $teamIDX;
            $str .= sprintf '<input type="radio" name="gtv-auto" checked value="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)"> No<br>', 'BO_AUTO', $teamIDX;   
        }
        return ($str);
        }
    sub sae_calcAdvanceScore(){
        print $q->header();
        my $adv = new SAE::ADVANCED();
        my $teamIDX = $q->param('teamIDX');
        my ($inStd, $boAuto, $inWater, $waterFlown, $SCORES) = $adv->_calcTeamScore($teamIDX);
        my %SCORE = %{$SCORES};
        my $gtvMultiplier = 2.0;
        if ($boAuto<1) {$gtvMultiplier = 1.5}
        my $waterScore = ($waterFlown + $gtvMultiplier*$inWater)/4;
        my $SUM_PADA = 0;
        my $str = '<table class="w3-table-all w3-border w3-small">';
        $str .= '<tr>';
        $str .= '<th>Attempts</th>';
        $str .= '<th style="text-align: right;">Team\'s<br>Standard<br>Deviation (ft)</th>';
        $str .= '<th style="text-align: right;">Distance<br>From Target<br>(ft)</th>';
        $str .= '<th style="text-align: right;">Payload<br>W<sub>payload</sub><br>(lbs)</th>';
        $str .= '<th style="text-align: right;">Autonomous<br>Multiplier<br>A<sub>PADA</sub></th>';
        $str .= '<th style="text-align: right;">PADA<br>Landing Bonus<br>B<sub>PADA</sub></th>';
        $str .= '<th style="text-align: right;">Item<br>Detached<br>Penalties</th>';
        $str .= '<th style="text-align: right;">Landing<br>Penalties</th>';
        $str .= '<th style="text-align: right;">Effective PADA<br>(<span class="w3-tiny">A<sub>PADA</sub> + B<sub>PADA</sub></span>)<br>Scores</th>';
        $str .= '<th style="text-align: right;">Effective<br>Water<br>(lbs)</th>';
        $str .= '<th style="text-align: right;">Running<br>PADA<br>Score</th>';
        $str .= '</tr>';
        foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
            my $subScore = ($SCORE{$flightIDX}{APADA} + $SCORE{$flightIDX}{BPADA});
            my $totalAttemptScore = $subScore - ($SCORE{$flightIDX}{IN_MINOR} * $subScore) - ($SCORE{$flightIDX}{IN_MAJOR} * $subScore);
               $SUM_PADA += $totalAttemptScore;
            my $minor = '--';
            if ($SCORE{$flightIDX}{IN_PEN_MINOR}>0){$minor='<span class="w3-text-red">yes</span>'}
            my $major = '--';
            if ($SCORE{$flightIDX}{IN_PEN_LANDING}>0){$major='<span class="w3-text-red">yes</span>'}
            $str .= '<tr>';
            $str .= sprintf '<td>%d</td>', $SCORE{$flightIDX}{IN_ROUND};
            $str .= sprintf '<td style="text-align: right;">%d</td>', $inStd;
            $str .= sprintf '<td style="text-align: right;">%d</td>', $SCORE{$flightIDX}{IN_DISTANCE};
            $str .= sprintf '<td style="text-align: right;">%1.2f</td>', $SCORE{$flightIDX}{IN_WATER_FLT};
            $str .= sprintf '<td style="text-align: right;">%1.2f</td>', $SCORE{$flightIDX}{APADA};
            $str .= sprintf '<td style="text-align: right;">%2.4e</td>', $SCORE{$flightIDX}{BPADA};
            $str .= sprintf '<td style="text-align: right;">%s</td>', $minor;
            $str .= sprintf '<td style="text-align: right;">%s</td>', $major;
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $totalAttemptScore;
            $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_EFFECTIVE_WATER};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', (4*$SUM_PADA);
            $str .= '</tr>';
            
        #     printf "%10d\t%2.4e\t%1.2f\t%2.4e\t%10.8f\n", $SCORE{$flightIDX}{IN_ROUND}, $SCORE{$flightIDX}{BPADA}, $SCORE{$flightIDX}{APADA}, $SCORE{$flightIDX}{BPADA} + $SCORE{$flightIDX}{APADA}, (4*$SUM_PADA);
        }
        $str .= '</table>';
        $str .= '<table class="w3-table w3-bordered">';
        $str .= sprintf '<tr><td class="w3-right-align">Effective Water Delivered by Aircraft (lbs)</td><td class="w3-right-align" style="width: 120px;">%2.2f</td></tr>', $waterFlown;
        $str .= sprintf '<tr><td class="w3-right-align">Water Delivered by Ground Transport Vehicle (lbs)</td><td class="w3-right-align" style="width: 120px;">%2.2f</td></tr>', $inWater;
        $str .= sprintf '<tr><td class="w3-right-align">Ground Transport Vehicle Autonomous Multiplier (%)</td><td class="w3-right-align" style="width: 120px;">%2.2f</td></tr>', $gtvMultiplier;
        $str .= sprintf '<tr><td class="w3-right-align">Water Delivery Score (pts)</td><td class="w3-right-align" style="width: 120px;">%2.4f</td></tr>', $waterScore;
        $str .= sprintf '<tr><td class="w3-right-align">PADA Flight Score (pts)</td><td class="w3-right-align" style="width: 120px;">%2.4f</td></tr>', (4*$SUM_PADA);
        $str .= sprintf '<tr><td class="w3-right-align">Final Flight Score (pts)</td><td class="w3-right-align w3-xlarge w3-text-blue" style="width: 120px;">%2.4f</td></tr>', ($waterScore + (4*$SUM_PADA));
        $str .= '</table>';
        return ($str);
        }
    sub sae_showListOfMissingStd(){
        print $q->header();
        my $eventIDX = $q->param('eventIDX');
        my $Team = new SAE::TEAM();
        my %TEAMS = %{$Team->_getTeamListByClass($eventIDX, 2)};
        my $str;
        $str .= '<div style="height: 650px; overflow-y: scroll;">';
        $str .= '<table class="w3-table w3-bordered w3-hoverable">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 150px;">STD</th>';
        $str .= '<th style="width: 100px;">Team #</th>';
        $str .= '<th>School</th>';
        $str .= '<th style="width: 150px;">TDS</th>';
        $str .= '<th style="width: 150px;">Drawings</th>';
        $str .= '<th style="width: 150px;">Design Report</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        my $Report = new SAE::REPORTS();
        foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
            my %REPORT = %{$Report->_getTeamDocuments($teamIDX)};
            my $tds = $drawing = $report = 'Not Available';
            if ($REPORT{2}{TX_KEYS}) {
                $tds = sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">TDS</a>', $REPORT{2}{TX_KEYS}, $eventIDX, $REPORT{2}{TX_KEYS}, $eventIDX;
            }
            if ($REPORT{3}{TX_KEYS}) {
                $drawing = sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">Drawing</a>', $REPORT{3}{TX_KEYS}, $eventIDX, $REPORT{3}{TX_KEYS}, $eventIDX;
            }
            if ($REPORT{1}{TX_KEYS}) {
                $report = sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">Report</a>', $REPORT{1}{TX_KEYS}, $eventIDX, $REPORT{1}{TX_KEYS}, $eventIDX;
            }
            if ($TEAMS{$teamIDX}{IN_STD} == 0){
                $str .= sprintf '<tr class="w3-pale-yellow">';
            } else {
                $str .= sprintf '<tr>';
            }
            $str .= sprintf '<td><input class="w3-input w3-border w3-round w3-align-right" type="number"  step="0.5" min="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%2.2f"></td>', 'IN_STD', $teamIDX, $TEAMS{$teamIDX}{IN_STD};
            $str .= sprintf '<td>%03d</td>',  $TEAMS{$teamIDX}{IN_NUMBER};
            $str .= sprintf '<td>%s</td>',    $TEAMS{$teamIDX}{TX_SCHOOL};
            $str .= sprintf '<td>%s</td>',    $tds;
            $str .= sprintf '<td>%s</td>',    $drawing;
            $str .= sprintf '<td>%s</td>',    $report;
            $str .= sprintf '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= '</div>';
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
        
        my $str;
        $str = '<div class="w3-container w3-border" style="padding: 1px!important">';
        
        my $activeTab = 'w3-white w3-border-left w3-border-top w3-border-right';
        $str .= '<div class="w3-bar w3-blue-grey">';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink %s " onclick="sae_openTab(this, \'%s\');">Flight Logs</button>', $activeTab,'Logs';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">Documents</button>', 'documents';
        $str .= sprintf '<button class="w3-bar-item w3-button tablink" onclick="sae_openTab(this, \'%s\');">Final Score</button>', 'Score';
        $str .= '</div>';
        
        
        $str .= '<div class="w3-container">';
        $str .= '<div id="Logs" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs ">';
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col l1 w3-center w3-hide-small w3-hide-medium"><p>Attempt</p></div>';
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
            $str .= sprintf '<input ID="TOF_'.$flightIDX.'" tabindex="'.($tabIndex++).'" class="w3-input w3-border w3-round w3-right" step="0.05" min="0"  type="number" placeholder="0.00" value="%1.2f" onchange="sae_updateFlightCardField(%d, this.value, \'%s\', %d);">',$Logs->getInTof(),$flightIDX, 'IN_TOF', $teamIDX ;
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
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-green w3-hover-green w3-card-2 w3-round w3-small"         style="width: 60px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Good</button>',   $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-blue w3-card-2 w3-round w3-small"    style="width: 60px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">No Fly</button>', $flightIDX, 2, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-orange w3-card-2 w3-round  w3-small"       style="width: 60px; margin-right: 4px;" onclick="sae_updateFlightStatus(this, %d, %d, %d, %d, %d, %d);">Crash</button>',  $flightIDX, 3, $teamIDX, $inNumber, $classIDX, $inRound;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-pale-yellow w3-hover-yellow w3-card-2 w3-round w3-small" style="width: 60px; margin-right: 4px;" onclick="sae_showFlightNotes(%d, %d);">Notes</button>', $flightIDX, $teamIDX;
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-red w3-round w3-small"                    style="width: 60px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Cancel</button>', $flightIDX, 1, $teamIDX, $inNumber, $classIDX, $inRound;
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
                $str .= sprintf '<button tabindex="'.($tabIndex++).'" class="w3-button w3-margin-bottom w3-mobile w3-border w3-light-grey w3-hover-red w3-round w3-small" style="width: 60px;" onclick="sae_deleteFlightLog(this, %d, %d, %d, %d, %d, %d);">Delete</button>', $flightIDX, 0, $teamIDX, $inNumber, $classIDX, $inRound;
            }
            
            $str .= '</div>';
            $str .= '</div>';
            $str .= '<br class="w3-hide-large w3-hide-medium">';
        }
        $str .= '</div>';
        
        $str .= '<div id="documents" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-padding">';
        my $Report = new SAE::REPORTS();
        my %REPORT = %{$Report->_getTeamDocuments($teamIDX)};

        foreach $inPaper (sort {$a <=> $b} keys %REPORT ) {
            my $fileID = $REPORT{$inPaper}{TX_KEYS};
            my $docType = $REPORT{$inPaper}{TX_PAPER};
            my $fileName = $REPORT{$inPaper}{TX_FILENAME};
            $str .= '<div class="w3-container w3-border w3-round w3-margin-top w3-padding">';
            $str .= sprintf '<a class="w3-link" href="read.html?fileID=%s&location=%s" target="report" onclick="window.open(\'read.html?fileIDdoc=%s&location=%s\',\'report\',\'width=1000,height=600\')">[ %s ] - %s</a>', $fileID, $location, $fileID, $location, $docType, $fileName;
            $str .= '</div>';
        }
        $str .= '</div>'; 
        
        $str .= '<div id="Score" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-padding">';
        $str .= sprintf '<button class="w3-button w3-card-2 w3-border w3-round w3-light-blue w3-hover-blue" onclick="sae_calcMicroScore(%d);">Calculate Final Score</button>', $teamIDX;
        $str .= '<div ID="ScoreContainer" class="w3-panel w3-margin w3-border w3-round w3-padding">';
        $str .= '</div>';
        $str .= '</div>';
        
        $str .= '</div>';
        $str .= "<br>" x3;
        return ($str);
        }
    sub sae_calcMicroScore(){
        print $q->header();
        my $Mic= new SAE::MICRO();
        my $teamIDX = $q->param('teamIDX');
        my ($TOPS, $FLIGHTS) = $Mic->_calcTeamScore($teamIDX);
        my %SCORE = %{$FLIGHTS};
        my @SORTED = @$TOPS;
        my %SEEN = ($SORTED[0]=>1,$SORTED[1]=>1,$SORTED[2]=>1);
        my $str = '<table class="w3-table-all w3-border w3-small">';
        $str .= '<tr>';
        $str .= '<th>Attempts</th>';
        $str .= '<th class="w3-right-align">Good<br>Large<br>Box(es)</th>';
        $str .= '<th class="w3-right-align">Damaged<br>Large<br>Box(es)</th>';
        $str .= '<th class="w3-right-align">Good<br>Small<br>Box(es)</th>';
        $str .= '<th class="w3-right-align">Damaged<br>Small<br>Box(es)</th>';
        $str .= '<th class="w3-right-align">Payload<br>(lbs)</th>';
        $str .= '<th class="w3-right-align">Time To<br>First Turn<br>(Sec)</th>';
        $str .= '<th class="w3-right-align">Raw<br>Flight<br>Score</th>';
        $str .= '<th class="w3-right-align">Detached<br>Penalties</th>';
        $str .= '<th class="w3-right-align">Landing<br>Penalties</th>';
        $str .= '<th class="w3-right-align">Bonus<br>(pts))</th>';
        $str .= '<th class="w3-right-align">Flight Score</th>';
        $str .= '</tr>';
        foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
            if ($SEEN{$flightIDX}){
                $str .= '<tr class="w3-pale-blue">';
            } else {
                $str .= '<tr>';
            }
            $str .= sprintf '<td class="w3-center-align">%d</td>', $SCORE{$flightIDX}{IN_ROUND};
            $str .= sprintf '<td class="w3-right-align">%2d</td>', $SCORE{$flightIDX}{IN_LARGE};
            $str .= sprintf '<td class="w3-right-align">%2d</td>', $SCORE{$flightIDX}{IN_LB_DAMAGE};
            $str .= sprintf '<td class="w3-right-align">%2d</td>', $SCORE{$flightIDX}{IN_SMALL};
            $str .= sprintf '<td class="w3-right-align">%2d</td>', $SCORE{$flightIDX}{IN_SB_DAMAGE};
            $str .= sprintf '<td class="w3-right-align">%2.2f</td>', $SCORE{$flightIDX}{IN_WEIGHT};
            $str .= sprintf '<td class="w3-right-align">%2.1f</td>', $SCORE{$flightIDX}{IN_TOF};
            $str .= sprintf '<td class="w3-right-align">%2.1f</td>', $SCORE{$flightIDX}{IN_RAW};
            if ($SCORE{$flightIDX}{IN_MINOR}>0){
                $str .= sprintf '<td class="w3-right-align">-%2.4f</td>', $SCORE{$flightIDX}{IN_MINOR};
            } else {
                $str .= sprintf '<td class="w3-right-align">-</td>';
            }
            if($SCORE{$flightIDX}{IN_MAJOR}>0) {
                $str .= sprintf '<td class="w3-right-align">-%2.4f</td>', $SCORE{$flightIDX}{IN_MAJOR};
                
            } else {
                $str .= sprintf '<td class="w3-right-align">-</td>';
                
            }
            $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $SCORE{$flightIDX}{IN_BONUS};
            $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $SCORE{$flightIDX}{IN_FFS};
            $str .= '</tr>';
        }
        $str .= '</table>';
        $str .= '<table class="w3-table w3-bordered">';
        my $top3FLights = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS};
        $str .= sprintf '<tr><td class="w3-right-align">Final Flight Scores</td><td class="w3-right-align w3-xlarge w3-text-blue" style="width: 120px;">%2.4f</td></tr>', $top3FLights;
        $str .= '</table>';
        return($str);
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
        $CrashReport->_updateFlightButton($teamIDX, 1, $logBtn);
        # return ($btn);
        my %DATA;
        # $DATA{logBtn} = $btn;
        $DATA{logBtn} = $logBtn;
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
        
        # my $round = $q->param('round');
        my $teamIDX = $q->param('teamIDX');
        my $classIDX = $q->param('classIDX');
        my $inNumber = $q->param('inNumber');
        my $location = $q->param('location');
        my $Event = new SAE::EVENT($location);
        my %EVENT = %{$Event->_getEventData()};
        my $round = 1; 
        if ($Flight->_getTeamsLastRound($teamIDX)){$round=$Flight->_getTeamsLastRound($teamIDX)}

        my %FLIGHTS = %{$Flight->_getCardStatusByEvent($location)};
        my %HISTORY = %{$Flight->_getCrashHistory($teamIDX)};
        
        my $btn = sprintf '<button class="w3-white w3-mobile w3-hover-blue w3-button w3-border w3-round-large" onclick="$(this).close();sae_recordFlightCard(this, 0, %d, \'%03d\', 0);">View Flight Logs</button>',$teamIDX, $inNumber;
        if ($classIDX==2){
            $btn = sprintf '<button class="w3-white w3-mobile w3-hover-blue w3-button w3-border w3-round-large " onclick="$(this).close();sae_recordFlightCard_Adv(this, 0, %d, \'%03d\', 0);">View Flight Logs</button>',$teamIDX, $inNumber;
        }
        if ($classIDX==3){
            $btn = sprintf '<button class="w3-white w3-mobile w3-hover-blue w3-button w3-border w3-round-large " onclick="$(this).close();sae_recordFlightCard_Mic(this, 0, %d, \'%03d\', 0);">View Flight Logs</button>',$teamIDX, $inNumber;
        }
        my $str = '<div class="w3-margin w3-padding w3-container">';
        $str .= '<label for="sae_roundSelection">Flight Attempt';
        $str .= '<select ID="sae_roundSelection" class="w3-select w3-border w3-round w3-padding"> ';
        my $inMax = $EVENT{IN_MAX_TICKET};
        my $counter;
        for (my $r = 1; $r<=$inMax; $r++){
            if (exists $FLIGHTS{$teamIDX}{$r}){next}
            my $selected = '';
            my $selectedClass='';
            if ($round == $r){$selected = 'selected'; $selectedClass='w3-pale-yellow'}
            $str .= sprintf '<option class="%s" value="%d" %s>%s</option>', $selectedClass, $r, $selected, 'Attempt #'.$r;
            $counter++;
        }
        if (($counter - $r) == 0) {
            $str .= sprintf '<option disabled>No More Tickets Available</option>';
        }
        
        $str .= '</select></label>';
        $str .= '<div class="w3-container w3-mobile w3-margin-top" style="text-align: right;">';
        $str .= $btn;
        if (($counter - $r) > 0) {
            $str .= '<button class="w3-green w3-mobile w3-hover-blue w3-button w3-border w3-round-large w3-card-2 w3-margin-left" style="width: 120px;" ';
            $str .= sprintf 'onclick="sae_checkoutFlightLog(this, %d, %d, %d);">Checkout</button>', $teamIDX, $classIDX, $inNumber;
        }
        $str .= '</div>';
        if (scalar (keys %HISTORY)>0){
            $str .= '<div class="w3-margin-top w3-topbar">';
            $str .= '<a class="w3-small" href="javascript:void(0);" onclick="sae_expandNotes();">Re-inspection Log(s)</a>';
                foreach $todoIDX (sort {$b<=>$a} keys %HISTORY) {
                    my $flightIDX = $HISTORY{$todoIDX}{FK_FLIGHT_IDX};
                    $str .= sprintf '<div ID="HISTORY_TODO_%d" class="w3-panel w3-leftbar w3-border-red w3-pale-red w3-mobile w3-display-container w3-padding w3-small crash-notes" style="display:none; ">', $todoIDX;
                    $str .= sprintf '(Round: %d)<br><div style="margin-right: 30px;">%s</div>', $HISTORY{$todoIDX}{IN_ROUND}, $HISTORY{$todoIDX}{CL_DESCRIPTION};
                    # $str .= sprintf '<span class="w3-display-topright w3-transparent w3-button w3-round w3-hover-red" onclick="sae_deleteCrashReportCard(%d, %d);"><i class="fa fa-times" aria-hidden="true"></i></span>', $todoIDX, $flightIDX;
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









## ------------------------ END -------------------------
