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
use SAE::EVENT();
use SAE::JSONDB();
# use SAE::TECH();

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
sub attend_viewSummary (){
    print $q->header();
    my $eventIDX     = $q->param('eventIDX');
    my $Event        = new SAE::EVENT();
    my %SUMMARY      = %{$Event->_getSummary($eventIDX)};
    my $totSatMin    = 9 * 60;
    my $totSunMin    = 4 * 60;
    
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<table class="w3-table-all">';
    my $totalRegistered = $SUMMARY{REG_TOT} + $SUMMARY{ADV_TOT} + $SUMMARY{MIC_TOT};
    my $totalCheckedIn  = $SUMMARY{REG} + $SUMMARY{ADV} + $SUMMARY{MIC};
    my $totalTickets    = ($totSatMin + $totSunMin) / ($totalCheckedIn * .9);
    my $sundayTicket    = $totSunMin/($totalCheckedIn * .9);
    $str .= sprintf '<tr><td style="width: 160px">Total Check-In Status</td><td><span class="w3-text-blue">%d</span> / %d<br>%2.1f&#37; In Attendance</td></tr>', $totalCheckedIn, $totalRegistered, ($totalCheckedIn/$totalRegistered) * 100;
    $str .= sprintf '<tr><td >Regular Checked-In Status</td><td><span class="w3-text-blue">%d</span> / %d<br>%2.1f&#37; Checked In </td></tr>', $SUMMARY{REG}, $SUMMARY{REG_TOT}, 100*($SUMMARY{REG}/$SUMMARY{REG_TOT});
    $str .= sprintf '<tr><td >Advanced Checked-In Status</td><td><span class="w3-text-blue">%d</span> / %d<br>%2.1f&#37; Checked In </td></tr>', $SUMMARY{ADV}, $SUMMARY{ADV_TOT}, 100*($SUMMARY{ADV}/$SUMMARY{ADV_TOT});
    $str .= sprintf '<tr><td >Micro Checked-In Status</td><td><span class="w3-text-blue">%d</span> / %d<br>%2.1f&#37; Checked In </td></tr>', $SUMMARY{MIC}, $SUMMARY{MIC_TOT}, 100*($SUMMARY{MIC}/$SUMMARY{MIC_TOT});
    $str .= sprintf '<tr><td >Total Student Attendance</td>';
    $str .= sprintf '<td>';
    $str .= sprintf '<span class="w3-text-blue">%d</span> Total<br>', $SUMMARY{TOT};
    $str .= sprintf '<span class="w3-text-blue">%2.1f</span> Average # of Students/Team', $SUMMARY{TOT}/$totalCheckedIn;
    $str .= sprintf '</td></tr>';
    $str .= sprintf '<tr><td >Recommend Total # of<br>Tickets for this Event </td>';
    $str .= sprintf '<td>';
    $str .= sprintf '<span class="w3-text-blue">%d</span> Total<br>', $totalTickets;
    $str .= sprintf '<span class="w3-text-blue">%d</span> for Saturday<br>', $totalTickets - $sundayTicket ;
    $str .= sprintf '<span class="w3-text-blue">%d</span> for Sunday', $sundayTicket;
    $str .= sprintf '</td></tr>';
    $str .= '</table>';
    $str .= '</div>';

    return ($str);
    }
sub attend_saveCheckIn (){
    print $q->header();
    my $Event    = new SAE::EVENT();
    my $str;
    my $teamIDX  = $q->param('teamIDX');
    my $eventIDX = $q->param('eventIDX');
    my %TEAM     = %{$Event->_getTeamDetails($teamIDX)};
    my $status   = $q->param('status');
    my %DATA     = %{decode_json($q->param('jsonData'))};
    my $JsonDB   = new SAE::JSONDB();
       $JsonDB->_update('TB_TEAM', \%DATA, qq(PK_TEAM_IDX=$teamIDX));
    my %OTHER    = %{$Event->_getDesignAndPresentation($eventIDX)};
    my $design   = '<span class="w3-text-red">no</span>';
    my $preso    = '<span class="w3-text-red">no</span>';
        if (exists $OTHER{$teamIDX}{1}){$design = '<span class="w3-text-blue">yes</span>'}
        if (exists $OTHER{$teamIDX}{5}){$preso  = ' <span class="w3-text-blue">yes</span>'}
    my %OBJ;
    $OBJ{PK_TEAM_IDX} = $teamIDX;
    if ($status==1){
            $str = &t_CheckedIbBar($teamIDX, $TEAM{IN_NUMBER}, $TEAM{TX_SCHOOL}, $TEAM{TX_NAME}, $design ,$preso, $DATA{IN_COUNT});
        } else {
            $str = &t_regularBar($teamIDX, $TEAM{IN_NUMBER}, $TEAM{TX_SCHOOL}, $TEAM{TX_NAME}, $design ,$preso, $DATA{IN_COUNT});
        }
    $OBJ{BAR} = $str;
    my $json = encode_json \%OBJ;
    return ($json);
    # return ($str);
    }
sub attend_CheckIn (){
    my $eventIDX  = $q->param('eventIDX');
    my $teamIDX   = $q->param('teamIDX');
    my $Event = new SAE::EVENT();
    my %TEAM = %{$Event->_getTeamDetails($teamIDX)};
    print $q->header();
    my $str;
    $str .= '<div class="w3-container w3-padding w3-light-grey">';
    $str .= '<div class="w3-container w3-padding-bottom w3-border w3-round-large w3-padding w3-white">';
    $str .= '<label><b>Team #:</b></label><br>';
    $str .= sprintf '<span class="w3-small">%03d</span><br>', $TEAM{IN_NUMBER};

    $str .= '<label><b>School</b></label><br>';
    $str .= sprintf '<span class="w3-small">%s</span><br>', $TEAM{TX_SCHOOL};

    $str .= '<label><b>Team Name</b></label><br>';
    $str .= sprintf '<span class="w3-small">%s</span><br><br>', $TEAM{TX_NAME};
    # $str .= '<div class="w3-container w3-margin-top w3-card-4 w3-padding w3-round-large">';
    $str .= '<label class="w3-margin-top w3-xlarge"><b># of Team Members (& Advisor) in Attendance:</b></label>';
    if ($TEAM{IN_COUNT} || $TEAM{IN_COUNT}>0) {
            $str .= sprintf '<input type="number" class="w3-input w3-border w3-round-large w3-padding w3-large w3-pale-yellow" ID="IN_COUNT" pattern="\d*" style="width: 200px;" value="%d">', $TEAM{IN_COUNT};
        } else {
            $str .= '<input type="number"  tabindex=1 class="w3-input w3-border w3-round-large w3-padding w3-large w3-pale-yellow" ID="IN_COUNT" pattern="\d*" style="width: 200px;">';
        }
    $str .= '</div>';
    # $str .= '</div>';
    # $str .= '<div class="w3-bar">';
    $str .= '<div class="w3-bar w3-center w3-margin-top w3-margin-bottom">';
    $str .= sprintf '<button class="w3-button w3-hover-white" onclick="$(this).close();"> Cancel </button>';
    $str .= sprintf '&nbsp;&nbsp;<button class="w3-button w3-border w3-pale-red w3-hover-red" onclick="attend_saveCheckIn(this, %d, 0)"> Not Here </button>', $teamIDX;
    $str .= sprintf '&nbsp;&nbsp;<button class="w3-button w3-border w3-pale-green w3-hover-green" onclick="attend_saveCheckIn(this, %d, 1)"> Check-In </button>', $teamIDX;
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }

sub attend_openTeamList (){
    my $eventIDX= $q->param('eventIDX');
    my $Event = new SAE::EVENT();
    # my $Tech       = new SAE::TECH();
    my %TEAMS = %{$Event->_getListOfTeams($eventIDX)};
    my %OTHER = %{$Event->_getDesignAndPresentation($eventIDX)};
    # my %TECH       = %{$Tech->_getStudentTechList($teamIDX)};
    print $q->header();
    my $str; 
    $str .= '<div class=" w3-container"><br>';
    $str .= '<h3>Team Check-In <span class="w3-large w3-round-large w3-button" onclick="attend_viewSummary(this);"><u>View Attendance Summary</u></span></h3>';
    $str .= '<ul class="w3-ul">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $design  = '<span class="w3-text-red">no</span>';
        my $preso   = '<span class="w3-text-red">no</span>';
        my $inCount = $TEAMS{$teamIDX}{IN_COUNT};
        if (exists $OTHER{$teamIDX}{1}){$design = '<span class="w3-text-blue">yes</span>'}
        if (exists $OTHER{$teamIDX}{5}){$preso  = '<span class="w3-text-blue">yes</span>'}

        if ($TEAMS{$teamIDX}{BO_ATTEND}){
                $str .= &t_CheckedIbBar($teamIDX, $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_NAME}, $design ,$preso, $inCount);
            } else {
                $str .= &t_regularBar($teamIDX, $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_NAME}, $design, $preso, 0);
            }
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
    }
sub t_regularBar {
    my ($teamIDX, $inNumber, $txSchool, $txName, $design ,$preso, $inCount) = @_;
    my $str;
    $str .= sprintf '<li ID="bar_%d" class="w3-bar w3-border w3-white w3-round-large w3-button w3-hover-pale-yellow w3-margin-bottom" onclick="attend_CheckIn(this, %d, %d)">', $teamIDX, $teamIDX, $inNumber;
    $str .= &t_barContent($inNumber, $txSchool, $txName, $design ,$preso, $inCount);
    $str .= '</li>';
    return ($str);
}

sub t_CheckedIbBar {
    my ($teamIDX, $inNumber, $txSchool, $txName, $design ,$preso, $inCount) = @_;
    my $str;
    $str .= sprintf '<li ID="bar_%d" class="w3-bar w3-border w3-pale-green w3-round-large w3-button w3-hover-pale-yellow w3-margin-bottom" onclick="attend_CheckIn(this, %d, %d)">', $teamIDX, $teamIDX, $inNumber;
    $str .= &t_barContent($inNumber, $txSchool, $txName, $design ,$preso, $inCount);
    $str .= '</li>';
    return ($str);
}
sub t_barContent (){
    my ($inNumber, $txSchool, $txName, $design ,$preso, $inCount) = @_;
    my $str;
    $str .= '<div class="w3-bar-item w3-margin-left-0 " style="text-align: left;">';
    $str .= sprintf '<span class="w3-xlarge"><b>%03d</b></span><br>', $inNumber;
    $str .= sprintf '<span class="">%s</span><br>', $txSchool;
    $str .= sprintf '<span class="w3-small">%s</span><br>', $txName;
    $str .= sprintf '<span>Students: <i class="w3-text-blue">%d</i></span><span class="w3-small w3-margin-left">Design: %s</span><span class="w3-small w3-margin-left">Preso: %s</span>', $inCount, $design, $preso;
    $str .= '</div>';
    return ($str);
    }