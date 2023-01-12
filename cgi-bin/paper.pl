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
use SAE::Auth;
use SAE::AUTO;
use SAE::REPORTS;
use SAE::REFERENCE;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::WEATHER;
use SAE::CARD;
use SAE::TEAM;
use SAE::USER;
use SAE::PAPER;
use SAE::JSONDB;

my %CLASS      = (1=>'Regular', 2=>'Advanced', 3=>'Micro');

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
#==============================================================================
sub paper_openJudgeView(){
    print $q->header();
    my $eventIDX   = $q->param('location');
    my $str;
    $str = &view_teamView($eventIDX);
    return ($str);
}
sub paper_openTeamView(){
    print $q->header();
    my $eventIDX   = $q->param('location');
    my $str;
    $str = &view_teamView($eventIDX);
    return ($str);
}
sub paper_batchRemoval (){
    my $eventIDX  = $q->param('eventIDX');
    my $classIDX  = $q->param('classIDX');
    my $inCardType= $q->param('inCardType');
    print $q->header();
    my $Paper = new SAE::PAPER();
    $Paper->_batchRemoval($eventIDX, $classIDX, $inCardType);

    return ($str);
    }
sub paper_batchAssign (){
    my $eventIDX  = $q->param('eventIDX');
    my $classIDX  = $q->param('classIDX');
    my $userIDX   = $q->param('userIDX');
    my $inCardType= $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper = new SAE::PAPER();
    $Paper->_batchAssign($eventIDX, $classIDX, $userIDX, $inCardType);
    my $str;

    return ($str);
    }
sub paper_autoAssign (){
    my $eventIDX= $q->param('eventIDX');
    my $classIDX= $q->param('classIDX');
    my $inLimit= $q->param('inLimit');
    my $inCardType= $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper = new SAE::PAPER();
    my $str   = $Paper->_autoAssign($eventIDX, $classIDX, $inLimit, $inCardType);
    return ($str);
    }
sub paper_openAutoAssign (){
    my $eventIDX   = $q->param('eventIDX');
    my $inCardType = $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my %CLASS      = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my %TYPE       = (1=>'Design Report', 2=>'TDS', 3=>'3d Drawing', 4=>'Requirements');
    print $q->header();
    my $Paper      = new SAE::PAPER();
    my %USERS      = %{$Paper->_getListOfJudges($eventIDX, $inCardType)};
    my $str;
    $str .= '<div class="w3-container">';
    # $str .= scalar (keys );
    $str .= '<ul class="w3-ul">';
    if ($inCardType == 1) {
        foreach $classIDX (sort keys %CLASS) {
            $str .= '<li class="w3-bar w3-border w3-white w3-round">';
            $str .= '<div class="w3-bar-item w3-right">';
            # $str .= sprintf '<button class="w3-border w3-round w3-button w3-pale-green w3-hover-green" onclick="paper_autoAssign(this, %d, %d);">Auto Assign</button><br>', $classIDX, $inCardType;
            $str .= sprintf '<button class="w3-border w3-round w3-button w3-pale-red w3-hover-red w3-margin-top" onclick="paper_batchRemoval(this, %d, %d);">Bacth Removal</button>', $classIDX, $inCardType;
            $str .= '</div>';
            $str .= '<div class="w3-bar-item" >';
            $str .= sprintf '<h4>%s Class: %s</h4>', $CLASS{$classIDX}, $TYPE{$inCardType};
            $str .= sprintf '<input ID="CLASS_LIMIT_%d" type="number" style="width: 200px; display: inline" class="w3-input w3-border w3-round" placeholder="# or Reports/Judge">', $classIDX;
            $str .= sprintf '<button class="w3-margin-left w3-border w3-round w3-button w3-pale-green w3-hover-green" style="display: inline" onclick="paper_autoAssign(this, %d, %d);">Auto Assign</button>', $classIDX, $inCardType;
            # $str .= '<i>Judges Preferences are defined in the Judge\'s preference menu.</i>';
            $str .= '</div>';
            $str .= '</li>';
        }
    } else {
        foreach $classIDX (sort keys %CLASS) {
            $str .= '<li class="w3-bar w3-border w3-white w3-round">';
            $str .= '<div class="w3-bar-item w3-right">';
            $str .= sprintf '<button class="w3-border w3-round w3-button w3-pale-red w3-hover-red w3-margin-top" onclick="paper_batchRemoval(this, %d, %d);">Bacth Removal</button>', $classIDX, $inCardType;
            $str .= '</div>';
            $str .= '<div class="w3-bar-item">';
            $str .= sprintf '<h4>%s Class: %s</h4>', $CLASS{$classIDX}, $TYPE{$inCardType};
            $str .= sprintf '<select id="BATCH_%d" style="width: 200px; display: inline;" class="w3-input w3-border w3-round">', $classIDX;
            foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
                $str .= sprintf '<option value="%d">%s, %s</option>', $userIDX, $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
            }
            $str .= '</select>';
            $str .= sprintf '<button class="w3-margin-left w3-border w3-round w3-button w3-pale-green w3-hover-green" onclick="paper_batchAssign(this, %d, %d);">Batch Assign</button><br>', $classIDX, $inCardType;
            $str .= '</div>';
            $str .= '</li>';
        }
    }
    $str .= '</ul>';
    $str .= '</div>';

    return ($str);
    }
sub paper_deleteUserAssignment (){
    my $eventIDX= $q->param('eventIDX');
    my $cardIDX= $q->param('cardIDX');
    my $userIDX= $q->param('userIDX');
    my $teamIDX= $q->param('teamIDX');
    my $inCardType= $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_delete('TB_CARD', qq(PK_CARD_IDX=$cardIDX));
    my $str;
    $str = &t_nameTagAvailable($inCardType, $eventIDX, $userIDX, $teamIDX);
    return ($str);
    }
sub createList (){
    # my $eventIDX= $q->param('eventIDX');
    my $txName= $q->param('txName');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_insert('TB_CARD', \%DATA);
    my $Paper = new SAE::PAPER();
    my %TEAM  = %{$Paper->_getTeamDetails($DATA{FK_TEAM_IDX})};
    my $inNumber = $TEAM{IN_NUMBER};
    my $txSchool = $TEAM{TX_SCHOOL};
    my $classIDX = $TEAM{FK_CLASS_IDX};
    my $str = &t_nameTag($newIDX , $txName, 0, $DATA{FK_USER_IDX}, $DATA{FK_TEAM_IDX}, $DATA{FK_CARDTYPE_IDX}, $inNumber, $txSchool, $classIDX );

    return ($str );
    }
sub paper_openAvailableJudges (){
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $teamIDX    = $q->param('teamIDX');
    my $inCardType = $q->param('inCardType');
    my %CLASS      = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my %TYPE       = (1=>'Design Report', 2=>'TDS', 3=>'3d Drawing', 4=>'Requirements');
    my %TARGET     = (1=>'designReport_'.$teamIDX, 2=>'tds_'.$teamIDX, 3=>'3dDrawing_'.$teamIDX, 4=>'Requirements_'.$teamIDX);
    print $q->header();
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Paper      = new SAE::PAPER();
    # my $Paper = New SAE::PAPER();
    my %TEAM  = %{$Paper->_getTeamDetails($teamIDX)};
    my $inNumber = $TEAM{IN_NUMBER};
    my $txSchool = $TEAM{TX_SCHOOL};
    my $classIDX = $TEAM{FK_CLASS_IDX};
    my %USERS      = ();
    if ($inCardType == 1) {
        %USERS      = %{$Paper->_getListOfJudges($eventIDX, $classIDX)};
    } else {
        %USERS      = %{$Paper->_getListOfJudges($eventIDX, ($inCardType*10))};
    }
    my %JUDGE      = %{$Paper->_getJudgeAssignmentByTeam($inCardType, $teamIDX)};
    my %COUNT      = %{$Paper->_getAssignmentCount($inCardType, $eventIDX)};

    my $str;
    $str .= '<div class="w3-container w3-light-grey">';
    $str .= sprintf '<h3>%s Judges</h3>', $TYPE{$inCardType};
    $str .= sprintf '<div class="w3-container tag-name %s w3-white" style="min-height: 55px;">', $TARGET{$inCardType};
    foreach $userIDX (sort {lc ($JUDGE{$a}{TX_LAST_NAME}) cmp lc($JUDGE{$b}{TX_LAST_NAME})} keys %JUDGE) {
        my $cardIDX   = $JUDGE{$userIDX}{PK_CARD_IDX};
        my $judgeName = sprintf '%s, %s', $JUDGE{$userIDX}{TX_LAST_NAME}, $JUDGE{$userIDX}{TX_FIRST_NAME};
        my $inStatus  = $JUDGE{$userIDX}{IN_STATUS};
        $str .= &t_nameTag($cardIDX, $judgeName, $inStatus , $userIDX, $teamIDX, $inCardType, $inNumber, $txSchool, $classIDX);
    }
    $str .= '</div>';
    $str .= sprintf '<h3>Judges availalbe for %s Class %s</h3>', $CLASS{$classIDX}, $TYPE{$inCardType};
    $str .= '<div ID="div_available_judges" class="w3-container tag-name w3-white">';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        if (exists $JUDGE{$userIDX}){next}
        my $txName = sprintf '%s, %s', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
        my $assignmentCount = $COUNT{$userIDX}{IN_TOTAL};
        $str .= &t_nameTagAvailable($inCardType, $eventIDX, $userIDX, $teamIDX,);
    }
    # $str .= '';
    $str .= '</div>';

    $str .= '</div>';

    return ($str);
    }
sub paper_openManagePapers(){
    print $q->header();
	my $eventIDX   = $q->param('location');

 # ============ OLD =============
    $str .= '<div class="w3-container w3-margin-top w3-padding" >';
    $str .= '<h2>Manage Papers</h2>';
    $str .= '<div class="w3-row" style="width: 100%" >';
    $str .= '<a href="javascript:void(0);" onclick="paper_openTeamView(this);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding w3-border-red" style="width: 20%;">Team View</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="paper_openJudgeView(this);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Judge View</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openStatView(this, 1);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Judge Statistics</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openStatTeamView(this, 1);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Team Statistics</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openStatBreakdown(this);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Stats Breakdown</div></a>';
    # $str .= '<a href="javascript:void(0);" onclick="alert(\'Under Construction\')"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Class Statistics</div></a>';
    # $str .= '<button class="w3-bar-item w3-button sae-tabs w3-light-blue" onclick="sae_openTeamView(this);">Team View</button>';
    # $str .= '<button class="w3-bar-item w3-button sae-tabs " onclick="sae_openJudgeView(this);">Judges View</button>';
    $str .= '</div>';
    $str .= '<div ID="paperContentContainer" class="w3-margin-top" style="height: auto; overflow: auto;">';
    $str .= &view_teamView($eventIDX);
    # $str .= &_templateTeamView();
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
sub t_nameTagAvailable (){
    # my ($userIDX, $txName, $teamIDX, $inCardType, $inCount) = @_;
    my ($inCardType, $eventIDX, $userIDX, $teamIDX) = @_;
    my $Paper = new SAE::PAPER();
    my %DATA = %{$Paper->_getUserDetails($inCardType, $eventIDX, $userIDX)};
    my $txName = sprintf '%s, %s',$DATA{TX_LAST_NAME}, $DATA{TX_FIRST_NAME};
    my $inCount = $DATA{IN_COUNT};

    my %TARGET = (1=>'designReport_'.$teamIDX, 2=>'tds_'.$teamIDX, 3=>'3dDrawing_'.$teamIDX, 4=>'Requirements_'.$teamIDX);
    my $str;
    $str .= sprintf '<span ID="span_available_'.$userIDX.'" class="tag w3-hover-pale-yellow">';
    $str .= sprintf '<i class="w3-round w3-hover-green w3-button fa fa-plus" style="padding: 3px 5px;" onclick="createList(this, \'%s\',\'%s\', %d, %d, %d);"></i>', $txName, $TARGET{$inCardType}, $userIDX, $teamIDX, $inCardType;
    $str .= sprintf ' %s', $txName;
    my $color = '';
    if ($inCount>5){
       $color = 'w3-pale-red ';
    } elsif ($inCount>2) {
       $color = 'w3-pale-yellow ';
    } else {
       $color = 'w3-pale-green ';
    }
    $str .= sprintf ' <span class="%s w3-margin-left w3-circle w3-border w3-small" style="padding: 2px 7px">%d</span>', $color, $inCount;
    $str .= '</span>';

    return ($str);
    }
sub t_nameTag (){
    my ($cardIDX, $label, $inStatus, $userIDX, $teamIDX, $inCardType, $inNumber, $txSchool, $classIDX) = @_;
    my %COLOR = (0=>'', 1=>'w3-yellow', 2=>'w3-blue');
    my $str;
    $str = sprintf '<span class="tag %s w3-hover-pale-yellow span_assigned_%d" ><u style="cursor: pointer;" onclick="grade_openAssessment(this, %d, %d, \'%s\', %d, %d, %d, %d);">%s</u>',$COLOR{$inStatus}, $cardIDX, $cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $userIDX, $label;
    if ($inStatus<2){
        $str .= sprintf '<i class="w3-round w3-margin-left w3-hover-red w3-button fa fa-close" style="padding: 3px 5px;" onclick="paper_deleteUserAssignment(this, %d, %d, %d, %d);"></i>', $cardIDX, $userIDX, $teamIDX, $inCardType;
    }
    $str .= '</span>';
    return ($str);
    }
sub view_teamView (){
    my ($eventIDX) = @_; #= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    # print $q->header();
    my $str;
    my $Paper      = new SAE::PAPER();
    my %TEAMS      = %{$Paper->_getTeamList($eventIDX)};
    
    # my %JUDGE      = %{$Paper->_getAllJudges()};
    my %ASSIGNMENT = %{$Paper->_getJudgeAssignment($eventIDX)};
    my $str;
    
    $str .= '<div class="w3-container w3-margin-top w3-padding">';
    # $str .= '<h2 class="w3-margin-top">Manage Paper</h2>';
    $str .= '<table class="w3-table-all w3-bordered w3-white" style="width: 100%">';
    $str .= '<tr>';
    $str .= '<th style="vertical-align: middle"># - School</th>';
    $str .= '<th style="width: 400px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 1);">Design: Auto Assignment</button>';
    $str .= '</th>';
    $str .= '<th style="width: 170px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 20);">TDS: Batch</button>';
    $str .= '</th>';    
    $str .= '<th style="width: 170px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 30);">Drawing: Batch</button>';
    $str .= '</th>';    
    $str .= '<th style="width: 170px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 40);">Req.: Batch</button>';
    $str .= '</th>';

    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my %DESIGN     = %{$ASSIGNMENT{1}{$teamIDX}};
        my %TDS        = %{$ASSIGNMENT{2}{$teamIDX}};
        my %DRAWING    = %{$ASSIGNMENT{3}{$teamIDX}};
        my %REQ        = %{$ASSIGNMENT{4}{$teamIDX}};
        my $classIDX   = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $title      = "$CLASS{$classIDX} Class Judge Assignment";
        my $inNumber   = $TEAMS{$teamIDX}{IN_NUMBER};
        my %TARGET     = (1=>'designReport_'.$teamIDX, 2=>'tds_'.$teamIDX, 3=>'3dDrawing_'.$teamIDX, 4=>'Requirements_'.$teamIDX);
        my $txSchool = sprintf '<b>%03d</b>-%s<br><i class="w3-small">%s - %s Class</i>',$TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_COUNTRY}, $CLASS{$classIDX };
        $str .= '<tr>';
        $str .= sprintf '<td>%s</td>', $txSchool;
        # $str .= sprintf '<td></td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{1};
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 1;
        foreach $userIDX (sort {lc($DESIGN{$a}{TX_LAST_NAME}) cmp lc($DESIGN{$b}{TX_LAST_NAME})} keys %DESIGN) {
            my $cardIDX   = $DESIGN{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $DESIGN{$userIDX}{TX_LAST_NAME}, $DESIGN{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $DESIGN{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 1, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{2};
        # $str .= '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true"></i>';
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 2;
        foreach $userIDX (sort keys %TDS) {
            my $cardIDX = $TDS{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $TDS{$userIDX}{TX_LAST_NAME}, $TDS{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $TDS{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 2, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{3};
        # $str .= '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true"></i>';
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 3;
        foreach $userIDX (sort keys %DRAWING) {
            my $cardIDX = $DRAWING{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $DRAWING{$userIDX}{TX_LAST_NAME}, $DRAWING{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $DRAWING{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 3, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{4};
        # $str .= '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true"></i>';
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 4;
        foreach $userIDX (sort keys %REQ) {
            my $cardIDX = $REQ{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $REQ{$userIDX}{TX_LAST_NAME}, $REQ{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $REQ{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 4, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
    }
sub _templateTeamView(){
    # print $q->header();
    my $location = $q->param('location');
    my $Auto = new SAE::AUTO();
    my $Ref = new SAE::REFERENCE();
    my %STATUS = (0=>"To Do", 1=>"Draft", 2=>"Done");
    my %W3CLASS = (1=>"w3-yellow w3-border", 2=>"w3-blue w3-border");
    my %TYPE = (1=>'Reports', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    my %LATE = %{$Ref->_getLateReportListByEvent($location)};
    my $str;

    %TEAMS = %{$Ref->_getTeamDataByEvent($location)};
    %PAPER = %{$Ref->_getDocuments($location)};
    my %ASSIGNED = %{$Auto->_getAssignedPapers($location)};
    $str .= '<table class="w3-table-all w3-hoverable w3-hover-yellow w3-white  w3-small">';
    $str .= '<thead>';
    $str .= '<tr class="w3-blue-grey w3-hide-small" style="">';
    # $str .= '<th style="width: 5%; text-align: center; vertical-align: text-bottom">#</th>';
    $str .= '<th style="width: 30%; text-align: left; vertical-align: text-bottom" nowrap>School</th>'; 
    $str .= '<th style="width: 4%; text-align: left; vertical-align: text-bottom" nowrap>Days<br>Late</th>'; 
    $str .= '<th style="width: 10%; text-align: left; vertical-align: text-bottom" nowrap>Documents<br><a class="w3-text-white" href="javascript:void(0);" onclick="openFileUpload(\'openUploadDiv\');">Upload</a></th>';
    $str .= '<th style="width: 15%; text-align: center; vertical-align: text-bottom" nowrap>Report Judges<br><a class="w3-text-white" href="javascript:void(0);" onclick="loadAutoAssignPapers();">Batch Auto Assign</a><br><a class="w3-text-white" href="javascript:void(0);" onclick="sae_batchRemoveDesignReportJudges();">Batch Remove</a></th>';
    $str .= '<th style="width: 12%; text-align: center; vertical-align: text-bottom" nowrap>TDS<br><a class="w3-text-white" href="javascript:void(0);"  onclick="loadBatchAssign(2);">Batch Assign</a></th>';
    $str .= '<th style="width: 12%; text-align: center; vertical-align: text-bottom" nowrap>Drawings<br><a class="w3-text-white" href="javascript:void(0);"  onclick="loadBatchAssign(3);">Batch Assign</a></th>';
    $str .= '<th style="width: 12%; text-align: center; vertical-align: text-bottom" nowrap>Requirements<br><a class="w3-text-white" href="javascript:void(0);"  onclick="loadBatchAssign(4);">Batch Assign</a></th>';
    $str .= '<tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $eIDX = crypt($teamIDX, '20');
        my $teamNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3);
        my $txSchool = $teamNumber.' - '.$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<tr class="w3-hide-small">';
        # $str .= '<td>'.$teamNumber.'</td>';
        $str .= '<td><a class="w3-link" href="javascript:void(0);" onclick="openAssignmentDetails('.$teamIDX.')">'.$txSchool.'</a></td>';
        my $boLate= 0;
        if (exists $LATE{$teamIDX}){$boLate = 1}
        $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_updateDaysLate(this, %2d, %2d, %1d);">%2d</a></td>', $teamIDX, $LATE{$teamIDX}{IN_DAYS}, $boLate, $LATE{$teamIDX}{IN_DAYS};
        $str .= '<td>';
        foreach $uploadIDX (sort keys %{$PAPER{$teamIDX}}) {
            # $str .= 'test';
            # $str .= '<i class="fa fa-file-pdf-o fa-fw"></i><a href="view.php?doc='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
            $str .= '<i class="fa fa-file-pdf-o fa-fw"></i><a href="read.html?fileID='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
        }
        $str .= '</td>';
        for ($inType=1; $inType<=4; $inType++){
            $str .= '<td style="; text-align: right;" ID="paper_'.$teamIDX.'">';
            foreach $userIDX (sort {lc($ASSIGNED{1}{$teamIDX}{$a}{TX_LAST_NAME}) cmp lc($ASSIGNED{1}{$teamIDX}{$b}{TX_FIRST_NAME})} keys %{$ASSIGNED{$inType}{$teamIDX}}){
                $name = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_LAST_NAME}.", ".$ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_FIRST_NAME};
                $inStatus = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{IN_STATUS};
                if ($inStatus>0){
                    $str .= '<div class="'.$W3CLASS{$inStatus}.' w3-padding-small w3-round"><a class="w3-text-white" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">'.$name.'</a></div>';
                } else {
                    $str .= '<div class="'.$W3CLASS{$inStatus}.' w3-padding-small w3-round">'.$name.'</div>';
                }
                
            }
            $str .= '</td>';
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<span>%s</span><br>', $txSchool ;
        $str .= '<b>Documents:</b><br><span>';
        foreach $uploadIDX (sort keys %{$PAPER{$teamIDX}}) {
            # $str .= '<i class="fa fa-file-pdf-o fa-fw w3-margin-left"></i><a href="view.php?doc='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
            $str .= '<i class="fa fa-file-pdf-o fa-fw w3-margin-left"></i><a href="read.html?fileID='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
        }
        $str .= '</span><br>';
        for ($inType=1; $inType<=4; $inType++){
            $str .= '<b>'.$TYPE{$inType}.' Judges:</b><br><span>';
            foreach $userIDX (sort {lc($ASSIGNED{$inType}{$teamIDX}{$a}{TX_LAST_NAME}) cmp lc($ASSIGNED{$inType}{$teamIDX}{$b}{TX_FIRST_NAME})} keys %{$ASSIGNED{$inType}{$teamIDX}}){
                $name = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_LAST_NAME}.", ".$ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_FIRST_NAME};
                $inStatus = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{IN_STATUS};
                $str .= '<div class="'.$W3CLASS{$inStatus}.' w3-margin-left  w3-padding-small w3-round">'.$name.'</div>';
            }
            $str .= '</span><br>';
        }
        $str .= '</td>';
        $str .= '</tr>';

    }
    $str .= '</tbody>';
    $str .= '</table>';
    # $str .= '</div>';

    return ($str);
    }
sub _templateJudgeView(){
    my $location = $q->param('location');
    my %W3CLASS = (0=>"w3-white", 1=>"w3-yellow  w3-border", 2=>"w3-blue  w3-border");
    my %TYPE = (1=>'Reports', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    my %CLASS = (1=>'Regular',2=>'Advanced',3=>'Micro');
    my $str;
    my $Card = new SAE::CARD();
    %USERS = %{$Card->_getListOfJudges($location)};
    %CARDS = %{$Card->_getCardList($location)};
    %AVGSTATUS = %{$Card->_getAverageCardStatus($location)};
    %CPREF = %{$Card->_getClassPreference($location)};
    
    $str .= '<table class="w3-table-all w3-white w3-small">';
    $str .= '<thead>';
    $str .= '<tr class="w3-blue-grey w3-hide-small">';
    $str .= '<th style="width: 14%">Judge</th>';
    $str .= '<th style="width: 10%">Class<br>Preference</th>';
    $str .= '<th style="width: 20%">Reports</th>';
    $str .= '<th style="width: 13%">TDS</th>';
    $str .= '<th style="width: 13%">Drawings</th>';
    $str .= '<th style="width: 13%">Requirements</th>';
    $str .= '<tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        $str .= '<tr class="w3-hide-small">';
        $str .= '<td><a href="javascript:void(0);" onclick="openJudgeAssignmentDetails('.$userIDX.',\''.$userName.'\')">'.$userName.'</a></td>';
        $str .= '<td>';
        foreach $classIDX (sort keys %{$CPREF{$userIDX}}){
            $str .= sprintf '<a href="javascript:void(0);" onclick="sae_loadTeamsToAssign(%1d, %1d);">%s</a><br>', $userIDX, $classIDX, $CLASS{$classIDX};
        }
        $str .= '</td>';
        for ($inType=1; $inType<=4; $inType++){
            $str .= '<td class="w3-row">';
            foreach $inNumber (sort {$a<=>$b} keys %{$CARDS{$userIDX}{$inType}}) {
                my $teamIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_TEAM_IDX};
                my $cardIDX = $CARDS{$userIDX}{$inType}{$inNumber}{PK_CARD_IDX};
                my $classIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_CLASS_IDX};
                # my $eIDX = crypt($teamIDX, '20');
                $inStatus = $CARDS{$userIDX}{$inType}{$inNumber}{IN_STATUS};
                $str .= &_templateStatusButton($teamIDX, $W3CLASS{$inStatus}, $inNumber, $cardIDX, $classIDX, $inType);
                # $str .= sprintf '<a class="w3-padding-small w3-button w3-border '.$W3CLASS{$inStatus}.' w3-round w3-margin-right" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">#%03d</a>', $inNumber;
            }
            $str .= '</td>';
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td class="w3-row">';
        $str .= '<div class="w3-medium w3-blue-grey w3-container"><a class="w3-text-white" href="javascript:void(0);" onclick="openJudgeAssignmentDetails('.$userIDX.',\''.$userName.'\')">'.$userName.'</a></div>';
        $str .= '<b>Class Preferences:</b><br>';
        foreach $classIDX (sort keys %{$CPREF{$userIDX}}){
            $str .= sprintf '<a class="w3-margin-left" href="javascript:void(0);" onclick="sae_loadTeamsToAssign(%1d, %1d);">%s</a><br>', $userIDX, $classIDX, $CLASS{$classIDX};
        }
        for ($inType=1; $inType<=4; $inType++){
            $str .= sprintf '<b>%s</b>: <br>', $TYPE{$inType};
            $str .= '<div class="w3-margin-left w3-padding-small w3-border-bottom">';
            foreach $inNumber (sort {$a<=>$b} keys %{$CARDS{$userIDX}{$inType}}) {
                my $teamIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_TEAM_IDX};
                my $cardIDX = $CARDS{$userIDX}{$inType}{$inNumber}{PK_CARD_IDX};
                my $classIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_CLASS_IDX};
                # my $eIDX = crypt($teamI$inNumberDX, '20');
                $inStatus = $CARDS{$userIDX}{$inType}{$inNumber}{IN_STATUS};
                $str .= &_templateStatusButton($teamIDX, $W3CLASS{$inStatus}, $inNumber, $cardIDX, $classIDX, $inType);
                # $str .= sprintf '<a class="w3-padding-small w3-button w3-border '.$W3CLASS{$inStatus}.' w3-round w3-margin-right" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">#%03d</a>', $inNumber;
            }
            $str .= '</div>';
        }
        
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    return ($str);
}