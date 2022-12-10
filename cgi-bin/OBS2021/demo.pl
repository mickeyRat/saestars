#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Text::CSV;

#---- SAE MODULES -------
use SAE::Common;
use SAE::TB_TEAM;
use SAE::DEMO;
use SAE::ECR;
use SAE::REFERENCE;
use SAE::PRESO;
use SAE::SCORE;

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
sub showMicroClassDemoPage(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    my $divName = $q->param('divName');
    my $Demo = new SAE::DEMO();
    my $Preso = new SAE::PRESO();
    my $Score = new SAE::SCORE();
    my %TEAMS = %{$Demo->_getMicroClassByEvent( 3, $location )};    # 3 = Micro Class Demo
    %TODO = %{$Preso->_getToDo( $location , 3 )};                   # 3 = Micro Class Demo
    %SCORES = %{$Score->_getMicroDemoScoreByEvent($location)};
    $str = '<div class="w3-container w3-padding-small">';
    $str .= '<br><h3>Micro Class Assembly Demonstration</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-light-grey w3-hide-small">';
    $str .= '<th style="width: 35%">Team # - Name</th>';
    $str .= '<th style="width: 20%">Schedule<br>';
    $str .= '<a href="javascript:void(0);" onclick="sae_showImportDemoSchedule();">Import</a>';
    $str .= '</th>';
    $str .= '<th style="width: 15%">Status</th>';
    $str .= '<th style="width: 10%">Score</th>';
    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $todoIDX = $TODO{$teamIDX}{PK_TODO_IDX};
        my $name = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        my $timeLocation = $TODO{$teamIDX}{TX_ROOM}.' ( '.$TODO{$teamIDX}{TX_TIME}.' )';
        my $scheduleLink = '<a class="w3-link" style="text-decoration: none;" href="javascript:void(0);" onclick="sae_openTeamPresoSchedule(3, '.$teamIDX.','.$todoIDX.')">'.$timeLocation.'</a>';
        my $nameLink = '<a class="w3-link w3-text-black" style="text-decoration: none;" href="javascript:void(0);" onclick="sae_openMicroDemo('.$teamIDX.');">'.$name.'</a>';
        my $toDoLink = '<a class="w3-link" style="text-decoration: none;" href="javascript:void(0);" onclick="sae_openMicroDemo('.$teamIDX.');">'.$TODO{$teamIDX}{TX_STATUS}.'</a>';
        my $score = $SCORES{$teamIDX};
        $str .= '<tr class="w3-hide-small">'; 
        $str .= '<td nowrap>'.$nameLink .'</td>';
        $str .= '<td ID="TD_teamPresoTime_'.$teamIDX.'" nowrap>'.$scheduleLink.'</td>';
        $str .= '<td ID="TD_TEAM_TODO_STATUS_'.$teamIDX.'" >'.$toDoLink.'</td>';
        $str .= sprintf '<td ID="TD_TEAM_DEMO_SCORE_'.$teamIDX.'">%2.4f</td>', $score;
        $str .= '</tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<span>%s</span><br>', $nameLink;
        $str .= sprintf '<span class="TD_teamPresoTime_'.$teamIDX.'">%s</span><br>', $timeLocation;
        $str .= sprintf '<span class="TD_TEAM_TODO_STATUS_'.$teamIDX.'">%s</span><br>', $toDoLink;
        $str .= sprintf 'Score: <span class="TD_TEAM_DEMO_SCORE_'.$teamIDX.'">%2.4f</span><br>', $score;
        $str .= '</td>';
        $str .= '</tr>';
        
    }
    $str .= '</table>';

    $str .= '</div>';

    return ($str);
}
sub sae_showImportDemoSchedule(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<div>';
    $str .= '<form class="w3-card-2 w3-round-large w3-padding w3-panel" method="post" action="javascript:sae_importDemoScheduleFile(\''.$divName.'\');" enctype="multipart/form-data">';
    $str .= '<input class="w3-file" type="file" name="csvFile" ID="csvFile" >';
    $str .= '<br><br>';
    $str .= '<input class="w3-margin-top w3-button w3-border w3-card-4 w3-round" type="submit" value="Import...">';
    $str .= '</form>';
    $str .= '<div ID="sae_results">';
    $str .= '</div>';
    $str .= '</div>';
    return($str);
}
sub sae_importDemoScheduleFile(){
    print $q->header();
    $str = "tested";
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
        $Preso->_deleteSchedule(3, $teamIDX, $location);
        $todoIDX = $Preso->_setSchedule(3, $teamIDX, $location, $toDoRoom, $toDoTime);
        $str .= $todoIDX."\n";
    }
    return ($str)
}
sub sae_openMicroDemo(){
    print $q->header();
    my $Ecr = new SAE::ECR();
    my $teamIDX = $q->param('teamIDX');
    my $location = $q->param('location');
    my $divName = $q->param('divName');
    %TEAM = %{$Ecr->_getTeamDataById($teamIDX)};
    my $str;
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-container w3-">';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-twothird">';
    $str .= 'Micro Class will demonstrate the timed assembly of their aircraft per the requirements of rule 9.6.';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-third">';
    if ($TEAM{$teamIDX}{IN_SECONDS} > 0 ){
        $str .= '<input ID="MICRO_IN_SECONDS" style="text-align: center;" type="number" placeholder="000" value="'.$TEAM{$teamIDX}{IN_SECONDS}.'" class="w3-input w3-border w3-card-2">';
    } else {
        $str .= '<input ID="MICRO_IN_SECONDS" style="text-align: center;" type="number" placeholder="000 - 180" class="w3-input w3-border w3-card-2">';
    }
    
    $str .= '<label>Enter time in seconds</label>';
    $str .= '</div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= '<div class="w3-panel w3-display-container w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-button w3-border w3-round w3-green " onclick="sae_submitMicroDemo('.$teamIDX.',\''.$divName.'\');">Submit</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left w3-hover-red" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_submitMicroDemo(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $inSeconds = $q->param('inSeconds');
    my $location = $q->param('location');
    my %DATA;
    my $Demo = new SAE::DEMO();
    my $Score = new SAE::SCORE();
    my $Preso = new SAE::PRESO();
    $Demo->_updateMicroDemoTime($teamIDX, $inSeconds);
    my $status = "Passed";
    if ($inSeconds>180){$status = "Failed"}
    $Preso->_updatePresoToDo($teamIDX, $location, 3, $status);
    # my $DemoScore = $score->_calculcateDemoScore($inSeconds);
    $str = '<a href="javascript:void(0);" onclick="sae_openMicroDemo('.$teamIDX.');">'.$status.' </a>';
    $DATA{HTML} = $str;
    $DATA{SCORE} = sprintf "%2.4f", $Score->_getMicroDemoScore($inSeconds);
    my $json = encode_json \%DATA;
    return ($json);
    # return ($str);
}


