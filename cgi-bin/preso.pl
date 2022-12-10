#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI::Session;
use CGI::Cookie;
use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Text::CSV;
use Spreadsheet::ParseXLSX;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::PRESO;
use SAE::REFERENCE;
use SAE::SCORE;
use SAE::Common;
use SAE::USER;
use SAE::TEAM;

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
sub __template(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    return ($str);
}
sub sae_updateValidateScore(){
    print $q->header();
    my $paperIDX = $q->param('paperIDX');
    my $inValue = $q->param('inValue');
    my $Preso = new SAE::PRESO();
    $Preso->_updatePaperScore($paperIDX, $inValue);
    return ("Paper ID ($paperIDX) updated to $inValue");
}
sub sae_validatePreso(){
    print $q->header();
    my $Teams = new SAE::TB_TEAM();
    my $Preso = new SAE::PRESO();
    my $Users = new SAE::TB_USER();
    my %USERS = %{$Users->getAllRecord()};
    my %QUESTIONS = %{$Preso->_getPresentationQuestions(5)};
    my $str;
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my %TEAMS = %{$Teams->getAllRecordBy_FkEventIdx($location)};
    my %SCORES = %{$Preso->_getValidatedScoreCards(5, $location)};
    $str .= '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<h3>Validate Scores</h3>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="showListOfTeam_Preso(\'number\');">&lt;&lt; Back</button><br><br/>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my %CARDS = %{$Preso->_getScoreCardsByTeam($teamIDX, 5)};
        
        # $team = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<div class="w3-container w3-card-2 w3-border w3-round w3-margin-bottom">';
        $str .= sprintf '<h4>Team: %03d - %s</h4>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<table class="w3-table w3-margin-bottom">';
        $str .= '<tr class="w3-small">';
        $str .= '<th>Card #</th>';
        foreach $subIDX (sort {$QUESTIONS{$a}{IN_SUBSECTION} <=> $QUESTIONS{$b}{IN_SUBSECTION}} keys %QUESTIONS) {
            $str .= sprintf '<th style="width: 8.33%">%d<br>%s</th>', $QUESTIONS{$subIDX}{IN_SUBSECTION}, $QUESTIONS{$subIDX}{TX_SUBSECTION};
        }
        $str .= '<th>Judge</th>';
        $str .= '</tr>';
        foreach $cardIDX (sort {$a<=>$b} keys %{$SCORES{$teamIDX}}) {
            my $userIDX;
            $str .= '<tr class="w3-small w3-hover-yellow">';
            $str .= sprintf '<td>%d</td>', $cardIDX;
            foreach $subIDX (sort {$QUESTIONS{$a}{IN_SUBSECTION} <=> $QUESTIONS{$b}{IN_SUBSECTION}} keys %QUESTIONS) {
                $userIDX =  $SCORES{$teamIDX}{$cardIDX}{$subIDX}{FK_USER_IDX};
                my $paperIDX = $SCORES{$teamIDX}{$cardIDX}{$subIDX}{PK_PAPER_IDX};
                my $inValue = $SCORES{$teamIDX}{$cardIDX}{$subIDX}{IN_VALUE}/10;
                if ($subIDX < 91){
                    $str .= sprintf '<td style="padding: 1px;"><input class="w3-input w3-border w3-round" type="number" max="10" min="0" value="%2.1f" data-key="%2.1f" style="text-align: right;" onChange="sae_updateValidatedInput(%d, this);"></td>', $inValue, $inValue, $paperIDX;
                } else {
                    my $checked = '';
                    if ( $SCORES{$teamIDX}{$cardIDX}{$subIDX}{IN_VALUE} > 0) {$checked = "checked"}
                    $str .= sprintf '<td style="padding: 1px; text-align: center; vertical-align: text-top;"><input class="w3-check w3-small" type="checkbox" value="100" %s onChange="sae_updateValidateCheckbox(%d, this);"></td>', $checked, $paperIDX;
                }
            }
            $str .= sprintf '<td>%s, %s</td>', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
            $str .= '</tr>';
        }

        $str .= '</table>';
        $str .= '</div>';
    }
    $str .= '</div>';
    return ($str);
}
# =================== 2022 START ========================================
sub sae_openImport(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $eventIDX= $q->param('eventIDX');
    my $User = new SAE::USER();
    my %JUDGES = %{$User->_getJudges()};
    my $str;
    
    $str .= '<form class="w3-container w3-padding" action = "javascript:void(0);" method = "post" enctype = "multipart/form-data">';
    $str .= sprintf '<label class="w3-text-grey" >Judge that performed the assessment:</label><br>';
    $str .= '<select ID="JUDGE_IDX" class="w3-select w3-border w3-round">';
    foreach $judgeIDX (sort {lc($JUDGES{$a}{TX_LAST_NAME}) cmp lc($JUDGES{$b}{TX_LAST_NAME})} keys %JUDGES) {
        my $selected = '';
        if ($judgeIDX == $userIDX){$selected = 'selected'}
     $str .= sprintf '<option value="%d" %s>%s, %s</option>', $judgeIDX, $selected, $JUDGES{$judgeIDX}{TX_LAST_NAME}, $JUDGES{$judgeIDX}{TX_FIRST_NAME};   
    }
    $str .= '</select>';
    $str .= '<div class="w3-center w3-light-grey w3-padding w3-border w3-round w3-margin-top">';
    $str .= sprintf '<label class="w3-text-grey" >Select the Excel file to import</label><br>';
    # $str .= '<label for="file" class="w3-button w3-border w3-green w3-round" style="display: in-line;">';
    $str .= '<label for="file" class="w3-button w3-border w3-grey w3-round" style="display: inline-block; width: 100%; overflow-hidden">';
    $str .= 'Browse ...';
    $str .= '</label>';
    $str .= sprintf '<input id="file" class="w3-round w3-border" style="display: none;" type="file" name="filename" onchange="getFileName(this);"/>';
    $str .= '</div>';
    $str .= '<div class="w3-panel w3-padding w3-center">';
    $str .= sprintf '<button class="w3-button w3-round w3-border" style="width: 155px;" onclick="sae_uploadExcelScoresheet(this, %d);">Upload</button>', $eventIDX;
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" style="width: 155px;" onclick="$(this).close();">Cancel</button>';
    $str .= '<div id="uploadedDisplay" class="w3-container w3-padding">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</form>';
    return ($str);
}
# =================== 2020 START ========================================
sub sae_openTeamPresoSchedule(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $todoType = $q->param('todoType');
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    my @MORNING = ('8:00', '8:30','9:00', '9:30','10:00', '10:30','11:00', '11:30');
    my @AFTERNOON = ('1:00', '1:30','2:00', '2:30','3:00', '3:30','4:00', '4:30');
    my $str;
    $str = '<div class="w3-row w3-round w3-border">';
    $str .= '<div class="w3-quarter">';
    $str .= '<h4 class="w3-margin-left">ROOM</h4>';
    foreach $txRoom (sort {$ROOMS{$a}{TX_ROOM} cmp $ROOMS{$b}{TX_ROOM}} keys %ROOMS){
        $roomIDX = $ROOMS{$txRoom}{PK_TODO_ROOM_IDX};
        $str .= '<div class="w3-margin-left"><input ID="ROOM_'.$roomIDX.'" class="w3-radio" type="radio" name="toDoRooms" value="'.$txRoom .'"><label FOR="ROOM_'.$roomIDX.'"class="w3-small">'.$txRoom.'</label></div>';
    }
    $str .= '<div class="w3-margin-left">';
    $str .= '<input ID="ROOM_0" class="w3-radio" type="radio" name="toDoRooms" value="0">';
    # $str .= '<label FOR="ROOM_'.$roomIDX.'"class="w3-small">'.$ROOMS{$roomIDX}{TX_ROOM}.'</label>';
    $str .= '<input type="text" placeHolder="Room Name" ID="ROOM_OTHER" onblur="selectOtherRoom();" style="width: 75%; border: none; border-bottom: 1px solid #ccc">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter">';
    $str .= '<h3> hh : mm</h3>';
    $str .= '<select ID="TIME_HOUR" class="w3-select w3-border w3-round w3-margin-right" style="width: 60px;">';
    for ($h=8; $h<=19;$h++){
        if ($h>12){
            $str .= sprintf '<option value="%02d">%02d</option>', ($h - 12), ($h - 12);
        } else {
            $str .= sprintf '<option value="%02d">%02d</option>', $h, $h;
        }
    }
    $str .= '</select>:';
    $str .= '<select ID="TIME_MIN" class="w3-select w3-border w3-round w3-margin-left" style="width: 60px;">';
    for ($m=0; $m<=55; $m +=5){
        $str .= sprintf '<option value="%02d">%02d</option>', $m, $m;
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter  w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-hover-blue w3-small w3-button w3-border w3-round w3-margin-top w3-light-blue" style="width: 70px;" onclick="sae_setPresentationSchedule('.$todoType.', '.$teamIDX.',\''.$divName.'\')">Set</button>';
    $str .= '<button class="w3-hover-red w3-margin-left w3-small w3-button w3-border w3-round w3-margin-top" style="width: 70px;" onclick="$(\'#'.$divName.'\').remove()">Cancel</button>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_setPresentationSchedule(){
    print $q->header();
    my $todoType = $q->param('todoType');
    my $str;
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $toDoRoom = $q->param('toDoRoom');
    my $toDoTime = $q->param('toDoTime');
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    if (!exists($ROOMS{$toDoRoom})) {
        $Preso->_addRoomTo_TODO_ROOM($toDoRoom, $location);
    }
    $Preso->_deleteSchedule($todoType, $teamIDX, $location);
    $todoIDX = $Preso->_setSchedule($todoType, $teamIDX, $location, $toDoRoom, $toDoTime);
    $str = '<a href="javascript:void(0);" onclick="sae_openTeamPresoSchedule('.$todoType.','.$teamIDX.','.$todoIDX.')">'.$toDoRoom.' ('.$toDoTime.')</a>';
    return ($str);
}
# 2020 IMPORT
sub sae_showImportSchedule(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<div>';
    $str .= '<form class="w3-card-2 w3-round-large w3-padding w3-panel" method="post" action="javascript:sae_importScheduleFile(\''.$divName.'\');" enctype="multipart/form-data">';
    $str .= '<input class="w3-file" type="file" name="csvFile" ID="csvFile" >';
    $str .= '<br><br>';
    $str .= '<input class="w3-margin-top w3-button w3-border w3-card-4 w3-round" type="submit" value="Import...">';
    $str .= '</form>';
    $str .= '<div ID="sae_results">';
    $str .= '</div>';
    $str .= '</div>';
    return($str);
}
sub sae_importScheduleFile(){
    print $q->header();
    my $Auth = new SAE::Auth();
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
    # unlink "$uploadDirectory/$fileName";
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    for ($i=2; $i<=scalar(keys %DATA); $i++){
        my $teamIDX = $DATA{$i}{FK_TEAM_IDX}; 
        my $toDoRoom = $DATA{$i}{TX_ROOM}; 
        my $toDoTime = $DATA{$i}{TX_TIME}; 
        if (!exists($ROOMS{$toDoRoom})) {
            $Preso->_addRoomTo_TODO_ROOM($toDoRoom, $location);
        }
        $Preso->_deleteSchedule(1, $teamIDX, $location);
        $todoIDX = $Preso->_setSchedule(1, $teamIDX, $location, $toDoRoom, $toDoTime);
    }
    return ($str)
}
# =================== 2020 END   ========================================
sub showListOfTeam_Preso(){
    print $q->header();
    # my $dbi = new SAE::Db();
    my $str;
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $sortBy= $q->param('sortBy');
    my $Team = new SAE::TB_TEAM();
    my $Score = new SAE::SCORE();
    my $Preso = new SAE::PRESO();
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};
    %CARDS = %{$Score->_getAllPresoScoreByEvent(5, $location)};
    %SCORES = %{$Score->_getAveragePresoScoreByEvent(5, $location)};
    my %ADMINS = %{$Score->_getListOfAdmins()};
    my %TODO = %{$Preso->_getToDo($location, 1)};
    my %ROOMS = %{$Preso->_getRoomList($location)};
    my %OWNER = %{$Score->_getCardOwner($location, 5)};
    my $str;
    $str .= '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<h3>Presentations</h3>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="sae_validatePreso(%d);">Expand Scorecard</button>', $location;
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="sae_openImport(%d);">Import Excel Scoresheet</button>', $userIDX;
    $str .= '<br>' x 2;
    @TEAMS = sort {$a <=> $b} keys %TEAM;
    $str .= '<table class="table table-sortable w3-table-all w3-small" >';
    $str .= '<thead>';
    $str .= '<tr class="w3-light-grey">';
    $str .= '<th style="" data-type="int"> # School </th>';
    $str .= '<th style="width: 100px; text-align: center;" data-type="string">Add Score</th>';
    $str .= '<th data-type="string">Score Cards</th>';
    $str .= '<th data-type="float">High</th>';
    $str .= '<th data-type="float">Low</th>';
    $str .= '<th data-type="float">Std. Dev</th>';
    $str .= '<th data-type="float">Coeff of <br>Var</th>';
    $str .= '<th data-type="float">Mean</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    # foreach $teamIDX (@TEAMS){
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=>$TEAM{$b}{IN_NUMBER}} keys %TEAM){
    # foreach $teamIDX (sort {$a <=> $b} keys %TEAM){
        $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
        my $eIDX = crypt($teamIDX, '20');
        $schedule = "Schedule";
        my $txRoom = 'teamListAll';
        if (exists($TODO{$teamIDX})) {
            $txRoom =  $TODO{$teamIDX}{TX_ROOM};
            $txRoom =~ s/\s+//g;
            $schedule = $TODO{$teamIDX}{TX_ROOM}." (".$TODO{$teamIDX}{TX_TIME}.')';
        } 
        $str .= sprintf '<tr class="%s teamListAll">', $txRoom;
        $str .= '<td nowrap ><a href="score.html?teamIDX='.$eIDX.'&source=15" target="_blank">'.$team .'</a></td>';
        # $str .= '<td ID="TD_teamPresoTime_'.$teamIDX.'" nowrap><a href="javascript:void(0);" onclick="sae_openTeamPresoSchedule(1, '.$teamIDX.','.$TODO{$teamIDX}{PK_TODO_IDX}.')">'.$schedule.'</a></td>';
        $str .= sprintf '<td nowrap><button class="w3-button w3-round w3-border w3-green w3-large w3-padding-small w3-hover-blue" style="width: 75px;" onclick="sae_openNewScoreCard(%d,%d);">%03d<br><span class="w3-small">Add Score</span></button></td>', $teamIDX, 0, $TEAM{$teamIDX}{IN_NUMBER};
        $str .= '<td ID="TD_ROW_FOR_'.$teamIDX.'">';
        foreach $cardIDX (sort {$CARDS{$teamIDX}{$a}{IN_POINTS} <=> $CARDS{$teamIDX}{$b}{IN_POINTS}} keys %{$CARDS{$teamIDX}}) {
            # my $txInitial =  sprintf "%s%s", substr($CARDS{$teamIDX}{$cardIDX}{TX_FIRST_NAME},0,1), substr($CARDS{$teamIDX}{$cardIDX}{TX_LAST_NAME},0,1);
            my $txInitial =  sprintf "%s, %s", $CARDS{$teamIDX}{$cardIDX}{TX_LAST_NAME}, $CARDS{$teamIDX}{$cardIDX}{TX_FIRST_NAME};
            # my $myCardUserIDX = $CARDS{$teamIDX}{$cardIDX}{FK_USER_IDX};
            my $myCardUserIDX = $OWNER{$cardIDX}{FK_USER_IDX};
            $score = $CARDS{$teamIDX}{$cardIDX}{IN_POINTS};
            # $str .= $myCardUserIDX.'-'.$userIDX;
            if (exists $ADMINS{$userIDX} || $myCardUserIDX == $userIDX) {
                $str .= &_tempLink($teamIDX, $cardIDX, $score, $txInitial,1);
            } else {
                $str .= &_tempLink($teamIDX, $cardIDX, $score, $txInitial,0);
            }
        }
        $str .= '</td>';
        
        $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'">%2.4f</td>', $SCORES{$teamIDX}{IN_MAX};
        $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'">%2.4f</td>', $SCORES{$teamIDX}{IN_MIN};
        $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'">%2.4f</td>', $SCORES{$teamIDX}{IN_STD};
        if ($SCORES{$teamIDX}{IN_AVERAGE}!=0){
            $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'">%2.4f</td>', $SCORES{$teamIDX}{IN_STD}/$SCORES{$teamIDX}{IN_AVERAGE};
        } else {
            $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'">%2.4f</td>', 0;
        }
        $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'"><b>%2.4f<b></td>', $SCORES{$teamIDX}{IN_AVERAGE};
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
}
sub sae_openNewScoreCard(){
    print $q->header();
    my $str;
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $eventIDX = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Teams = new SAE::TEAM();
    my $Preso = new SAE::PRESO();
    $Team->getRecordById($teamIDX);
    $teamTitle = substr("000".$Team->getInNumber(),-3,3).' - '.$Team->getTxSchool();
    my %LIST = %{$Teams->_getTeamList($eventIDX)};
    my $class = $Team->getFkClassIdx();
    my %PRESO = %{$Preso->_getPresentationQuestions(5)};
    my $divCounter = 0;
    my $tabIndex = 1;
    $str .= '<div class="w3-container w3-padding-bottom">';
    $str .= '<label class="w3-large" for="fkTeamIdx">Team: </label>';
    $str .= '<select ID="fkTeamIdx" class="w3-select w3-border w3-margin-bottom w3-large w3-pale-yellow">';
    foreach $fkTeamIDX (sort {$LIST{$a}{IN_NUMBER} <=> $LIST{$b}{IN_NUMBER}} keys %LIST) {
        my $selected = '';
        if ($fkTeamIDX == $teamIDX) {$selected = 'selected'}
        $str .= sprintf '<option %s value="%d">%03d - %s</option>', $selected, $fkTeamIDX, $LIST{$fkTeamIDX}{IN_NUMBER}, $LIST{$fkTeamIDX}{TX_SCHOOL};
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-border w3-hoverabl">';
    
    my $description = '';
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $description .= sprintf '<div ID="SUB_%d" class="w3-hide sae-preso-description w3-container" >',$subIDX;
        $description .= sprintf '<h4 style="padding: 0px; margin: 1px;"> %s</h4>', $PRESO{$subIDX}{TX_SUBSECTION};
        $description .= sprintf '<div class="w3-small">%s</div>',  $PRESO{$subIDX}{CL_DESCRIPTION};
        if($PRESO{$subIDX}{IN_TYPE}==0) {
            $description .= '<hr>';
            # $description .= sprintf '<h6>Comments:</h6>';
            $description .= sprintf '<textarea data-key="%d" class="w3-border w3-input inputComments w3-round  w3-pale-yellow" style="height: 175px; resize: vertical"  placeholder="Judge\'s Comments"></textarea>', $subIDX;
        }
        $description .= '</div>';
    }
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $str .= sprintf '<tr class="" data-key="%d" >', $subIDX;
            $str .= sprintf '<td class="w3-display-container" style="width: 40%; padding: 0px;" onclick="sae_showDescription(this, %d);">', $subIDX;
            $str .= sprintf '<label class="w3-padding" for="">%s - %s</label>',$PRESO{$subIDX}{IN_SUBSECTION},$PRESO{$subIDX}{TX_SUBSECTION};
            
            $str .= '</td>';
            $str .= '<td style="width: 10%; padding: 0px;">';
            if ($PRESO{$subIDX}{IN_TYPE}==0) {
                
                $str .= sprintf '<input class="w3-input w3-border w3-right inputNumber" data-key="%d" tabindex="%d" type="number" max="10" min="0" step="0.1" placeholder="0.0" onfocus="sae_showDescription(this, %d);" onblur="sae_processValue(this);"> ', $subIDX, $tabIndex++, $subIDX;
            } else {
                $str .= sprintf '<input data-key="%d" tabindex="%d" ', $subIDX, $tabIndex++;
                $str .= sprintf 'type="checkbox" class="w3-check w3-border inputBinary" value="100" onfocus="sae_showDescription(this, %d);"> Yes', $subIDX;
            }
            
            $str .= '</td>';
            $str .= '<td class="w3-display-container w3-white" style="width: 10px;">';
            $str .= sprintf '<i ID="CHEVERON_%d" class="fa fa-chevron-right w3-display-right w3-hide sae-preso-description" aria-hidden="true"></i>', $subIDX;
            $str .= '</td>';
            if ($divCounter==0){
                $divCounter++;
                $str .= sprintf '<td class="w3-border-left" rowspan="%d"  style="width: 50%">', $subIDX, scalar(keys %PRESO);
                $str .= $description;
                $str .= '</td>';
            }
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<div class="w3-display-container w3-panel" style="text-align: center;">';
    # $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green" onclick="sae_savePresentationScores(this, %d, %d, %d);">Record & Exit</button>', $teamIDX, 1, 0;
    $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green" onclick="sae_savePresentationScores(this, %d, %d);">Record & Exit</button>', 1, 0;
    # $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-green" onclick="sae_savePresentationScores('.$teamIDX.',0,0,\''.$divName .'\');">Save & Add Another</button>';
    $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-red " onclick="$(this).close();">Exit</button>';
    $str .= '</div>';
    
    
    
    
    
    
    # $str .= '<div class="w3-container w3-display-container w3-small" >';
    # $str .= '<h4>Add Presentation Scores for #'.$teamTitle.'</h4>';
    # $str .= '<table class="w3-table-all">';
    # $str .= '<tr>';
    # $str .= '<th style="width: 45%;">Title/Description</th>';
    # $str .= '<th style="width: 10%;">Score</th>';
    # $str .= '<th style="width: 45%;">Comments</th>';
    # $str .= '</tr>';
    # my $tabIndex = 1;
    # foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
    #     $str .= '<tr>';
    #     # $str .= '<tr class="w3-hide-small">';
    #     $str .= sprintf '<td style="padding: 1px 3px;"><b class="w3-large">%d - %s</b></td>',$PRESO{$subIDX}{IN_SUBSECTION},$PRESO{$subIDX}{TX_SUBSECTION};
    #     # $str .= sprintf '<td style="padding: 1px 3px;"><b class="w3-large">%d <span class="w3-tiny">%s</span></b><br><div class="w3-margin-left">%s</div></td>',$PRESO{$subIDX}{IN_SUBSECTION},$PRESO{$subIDX}{TX_SUBSECTION},$PRESO{$subIDX}{CL_DESCRIPTION};
    #     # $str .= '<td nowrap style="padding: 1px 3px;">'.$PRESO{$subIDX}{IN_SUBSECTION}.'. '.$PRESO{$subIDX}{TX_SUBSECTION}.'</td>';
    #     # $str .= '<td nowrap style="padding: 1px 3px;">'.$PRESO{$subIDX}{CL_DESCRIPTION}.'</td>';
    #     # $str .= '<td  colspan="2" nowrap style="padding: 1px 3px;" style="text-align: right">';
    #     if ($PRESO{$subIDX}{IN_TYPE}==0) {
    #         $str .= '<td style="padding: 1px 3px;" style="text-align: right">';
    #         $str .= '<input tabindex="'.($tabIndex++).'" data-key="'.$subIDX.'" ';
    #         $str .= 'style="width: 74px; height: 40px; text-align: center" type="number" ';
    #         $str .= 'class="inputNumber w3-border  w3-input w3-border w3-card-2" max="10" min="0" maxlength="4" onblur="sae_processValue(this);">';
    #     } else {
    #         $str .= '<td  colspan="2" style="padding: 1px 3px;" style="text-align: right">';
    #         $str .= '<input data-key="'.$subIDX.'" ';
    #         $str .= sprintf 'type="checkbox" class="w3-check w3-border inputBinary" value="100"> Yes, %s', $PRESO{$subIDX}{CL_DESCRIPTION};
    #     }
    #     $str .= '</td>';
    #     $str .= '<td style="padding: 1px 3px;" >';
    #     if ($PRESO{$subIDX}{IN_TYPE}==0) {
    #         $str .= '<textarea tabindex="'.($tabIndex++).'" data-key="'.$subIDX.'" class="inputComments w3-input w3-border" placeholer="Comments"></textarea>';
    #     } else {
    #         $str .= '&nbsp;';
    #     }
    #     $str .= '</td>';
    #     $str .= '</tr>';
    #     if ($PRESO{$subIDX}{IN_TYPE}==0) {
    #         $str .= '<tr>';
    #         $str .= sprintf '<td colspan="3" class="w3-small">%s</td>', $PRESO{$subIDX}{CL_DESCRIPTION};
    #         $str .= '</tr>';
    #     }
    # }
    # $str .= '</table>';
    # $str .= '<div class="w3-display-container w3-panel" style="text-align: center;">';
    # $str .= '<button class="w3-button w3-border w3-display-center w3-hover-green" onclick="sae_savePresentationScores('.$teamIDX.',1,0,\''.$divName .'\');">Save & Exit</button>';
    # # $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-green" onclick="sae_savePresentationScores('.$teamIDX.',0,0,\''.$divName .'\');">Save & Add Another</button>';
    # $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-red " onclick="$(\'#'.$divName.'\').remove();">Exit</button>';
    # $str .= '</div>';
    # $str .= '<br>' x 4;
    # $str .= '</div>';
    return ($str);
}
sub sae_updateScoreCard(){
    print $q->header();
    my $str;
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $cardIDX = $q->param('cardIDX');
    my $eventIDX = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Preso = new SAE::PRESO();
    my $Teams = new SAE::TEAM();
    $Team->getRecordById($teamIDX);
    $teamTitle = substr("000".$Team->getInNumber(),-3,3).' - '.$Team->getTxSchool();
    my $class = $Team->getFkClassIdx();
    my %LIST = %{$Teams->_getTeamList($eventIDX)};
    my %PRESO = %{$Preso->_getPresentationQuestions(5)};
    my %VALUE = %{$Preso->_getCardScores($cardIDX)};
    my %COMMENTS = %{$Preso->_getPresoComments($cardIDX)};
    my $Util = new SAE::Common();

    my $divCounter = 0;
    my $tabIndex = 1;
    $str .= '<div class="w3-container w3-padding-bottom">';
    $str .= '<label class="w3-large" for="fkTeamIdx">Team: </label>';
    $str .= '<select ID="fkTeamIdx" class="w3-select w3-border w3-margin-bottom w3-large w3-pale-yellow">';
    foreach $fkTeamIDX (sort {$LIST{$a}{IN_NUMBER} <=> $LIST{$b}{IN_NUMBER}} keys %LIST) {
        my $selected = '';
        if ($fkTeamIDX == $teamIDX) {$selected = 'selected'}
        $str .= sprintf '<option %s value="%d">%03d - %s</option>', $selected, $fkTeamIDX, $LIST{$fkTeamIDX}{IN_NUMBER}, $LIST{$fkTeamIDX}{TX_SCHOOL};
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-border w3-hoverabl">';
    my $description = '';
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $description .= sprintf '<div ID="SUB_%d" class="w3-hide sae-preso-description w3-container" >',$subIDX;
        $description .= sprintf '<h4 style="padding: 0px; margin: 1px;"> %s</h4>', $PRESO{$subIDX}{TX_SUBSECTION};
        $description .= sprintf '<div class="w3-small">%s</div>',  $PRESO{$subIDX}{CL_DESCRIPTION};
        if ($PRESO{$subIDX}{IN_TYPE}==0) {
            my $comment = $Util->removeBr( $COMMENTS{$subIDX}{CL_COMMENT} );
            $description .= '<hr>';
            $description .= sprintf '<textarea data-key="%d" class="w3-border w3-input inputComments w3-round w3-pale-yellow" style="height: 175px; resize: vertical"  placeholder="Judge\'s Comments">%s</textarea>', $subIDX, $comment;
        }
        $description .= '</div>';
    }
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $str .= sprintf '<tr class="" data-key="%d" >', $subIDX;
            $str .= sprintf '<td style="width: 40%; padding: 0px;" onclick="sae_showDescription(this, %d);">', $subIDX;
            $str .= sprintf '<label class="w3-padding" for="">%s - %s</label>',$PRESO{$subIDX}{IN_SUBSECTION},$PRESO{$subIDX}{TX_SUBSECTION};
            $str .= '</td>';
            $str .= '<td style="width: 10%; padding: 0px;">';
            if ($PRESO{$subIDX}{IN_TYPE}==0) {
                $str .= sprintf '<input class="w3-input w3-border w3-right inputNumber" data-key="%d" tabindex="%d" type="number" max="10" min="0" step="0.1" placeholder="0.0" onfocus="sae_showDescription(this, %d);" onblur="sae_processValue(this);" value="%2.1f"> ', $subIDX, $tabIndex++, $subIDX, ($VALUE{$subIDX}{IN_VALUE} / 10);
            } else {
                $checked = "";
            if ($VALUE{$subIDX}{IN_VALUE} >0){$checked = " checked "}
                $str .= sprintf '<input data-key="%d" tabindex="%d" %s ', $subIDX, $tabIndex++, $checked;
                $str .= sprintf 'type="checkbox" class="w3-check w3-border inputBinary" value="100" onfocus="sae_showDescription(this, %d);"> Yes', $subIDX;
            }
            $str .= '</td>';
            $str .= '<td class="w3-display-container w3-white" style="width: 10px;">';
            $str .= sprintf '<i ID="CHEVERON_%d" class="fa fa-chevron-right w3-display-right w3-hide sae-preso-description" aria-hidden="true"></i>', $subIDX;
            $str .= '</td>';
            if ($divCounter==0){
                $divCounter++;
                $str .= sprintf '<td class="w3-border-left" rowspan="%d"  style="width: 50%">', $subIDX, scalar(keys %PRESO);
                $str .= $description;
                $str .= '</td>';
            }
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<div class="w3-display-container w3-panel" style="text-align: center;">';
    # $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green w3-round" onclick="sae_savePresentationScores(this, '.$teamIDX.',1,'.$cardIDX.');">Update</button>';
    $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green"          onclick="sae_savePresentationScores(this, %d, %d);">Update & Exit</button>', 1, $cardIDX;
    $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-red w3-round  w3-margin-left " onclick="sae_deleteScore(this, %d);">Delete</button>', $cardIDX;
    # $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-green" onclick="sae_savePresentationScores('.$teamIDX.',0,0,\''.$divName .'\');">Save & Add Another</button>';
    $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-red " onclick="$(this).close();">Exit</button>';
    $str .= '</div>';
    
    return ($str);
}
sub _tempLink(){
    my $str;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $score = shift;
    my $initals = shift;
    my $edit = shift;
    my $str;
    if ($edit==1) {
        $str .= sprintf '<button class="w3-button w3-white w3-padding-small w3-border w3-round w3-card-2 w3-margin-right w3-leftbar w3-border-blue w3-hover-blue" style="width: 150px;" onclick="sae_updateScoreCard(%d, %d);">', $teamIDX, $cardIDX;
    } else {
        $str .= sprintf '<button class="w3-white w3-padding-small w3-border w3-round w3-card-2 w3-margin-right" style="width: 150px;">', $teamIDX, $cardIDX;
    }
    $str .= sprintf '%2.4f<br><span class="w3-small">(%s)</span>', $score, $initals;
    $str .= '</button>';
    # $str = '<a ID="A_CARDIDX_'.$cardIDX.'" class="w3-margin-left w3-text-blue-grey w3-border w3-padding-small w3-round w3-card-2';
    # if ($edit > 0 ){
    #     $str .= ' w3-leftbar w3-border-blue w3-hover-text-blue"';
    # } else {
    #     $str .= '" style="text-decoration: none;"';
    # }

    # $str .= ' onclick="sae_updateScoreCard('.$teamIDX.','.$cardIDX.');" ';
    # $str .= sprintf ' href="javascript:void(0);" >%2.4f <br>(%s)</a>', $score, $initals;
    # $str .= sprintf ' href="javascript:void(0);" >%s:%2.4f</a>', $initals, $score;
    return ($str);
}
sub sae_savePresentationScores(){
    print $q->header();
    my $Preso = new SAE::PRESO();
    my $Score = new SAE::SCORE();
    my $teamIDX = $q->param('teamIDX');
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    my $cardTypeIDX = 5;                              # 5 = presentations;
    my $cardIDX = $q->param('cardIDX');
    my %COMMENTS = %{decode_json($q->param('jsonComment'))};
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $str = "Start of Script: CardIDX = ".$cardIDX;
        if ($cardIDX == 0){
        # $str .= "Inside of 0\n $userIDX, $teamIDX, $cardTypeIDX, $location \n";
        $cardIDX=$Preso->_addPresentationScoreCard($userIDX, $teamIDX, $cardTypeIDX, $location);
        $Preso->_saveAssessments($cardIDX, \%DATA);
        $Preso->_saveComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    } else {
        # $str .= "Perform Update\n";
        $Preso->_updateAssessment($cardIDX, \%DATA);
        $Preso->_resetComments($cardIDX);
        $Preso->_saveComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
        # $Preso->_updateComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    }
    # print join(",",  values %DATA);
    # if ($cardIDX == 0){
    #     # $str .= "Inside of 0\n $userIDX, $teamIDX, $cardTypeIDX, $location \n";
    #     $cardIDX=$Preso->_addPresentationScoreCard($userIDX, $teamIDX, $cardTypeIDX, $location);
    #     $Preso->_saveAssessments($cardIDX, \%DATA);
    #     $Preso->_saveComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    # } else {
    #     # $str .= "Perform Update\n";
    #     $Preso->_updateAssessment($cardIDX, \%DATA);
    #     $Preso->_resetComments($cardIDX);
    #     $Preso->_saveComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    #     # $Preso->_updateComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    # }
    
    # print $cardIDX.' - '. $q->param('jsonComment');
    # print $cardIDX.' - '. join ("<br>", keys %COMMENTS);
    $Preso->_updatePresoToDo($teamIDX, $location, 1, "Completed");
    my $txInitials = $Score->_getUserInitials($userIDX);
    my ( $presoScore ) = $Score->_getPresenationScoreByCard($cardIDX);
    $str = &_tempLink($teamIDX, $cardIDX, $presoScore, $txInitials, 1);
    my %DATA;
    $DATA{HTML} = $str;
    $DATA{AVERAGE} = sprintf "%2.4f", $Score->_getAllPresoScoreByTeamIDX($teamIDX, 5, $location);
    my $json = encode_json \%DATA;
    return ($json);
    # return ($str);
}
sub sae_deleteScore(){
    print $q->header();
    my $cardIDX = $q->param('cardIDX');
    my $teamIDX = $q->param('teamIDX');
    my $location = $q->param('location');
    my $Preso = new SAE::PRESO();
    my $Score = new SAE::SCORE();
    $Preso->_deletePresoScoreCard($cardIDX);
    $Preso->_deletePresoScoreCard_Paper($cardIDX);
    $score = sprintf "%2.4f", $Score->_getAllPresoScoreByTeamIDX($teamIDX, 5, $location);
    %CARDS = %{$Preso->_getScoreCardsByTeam($teamIDX)};
    my $count = scalar(keys %CARDS);
    if ($count > 0){
        $Preso->_updatePresoToDo($teamIDX, $location, 1, "Completed");
    } else {
        $Preso->_updatePresoToDo($teamIDX, $location, 1, "To Do");
    }
    return ($score);
}
# ============= 2018 ===============================

