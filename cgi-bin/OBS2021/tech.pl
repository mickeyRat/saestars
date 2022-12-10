#!/usr/bin/perl
use cPanelUserConfig;

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
    $str .= '<th style="width: 100px">Schedule<br>';
    $str .= '<a href="javascript:void(0);" onclick="sae_showImportTechSchedule();">Import</a>';
    $str .= '</th>';
    $str .= '<th style="width: 60px">Inspection<br>Status</th>';
    $str .= '<th style="width: 55px; text-align: right;">Total<br>Penalties</th>';
    
    $str .= '<th style="">Engineering Change Requests (ECRs)';
    # $str .= '<br><a href="javascript:void(0);" onclick="sae_showImportTechSchedule();">Import</a>';
    $str .= '</th>';
   
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $teamIDX (sort {$a <=> $b} keys %TEAM){
        $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
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
        $drawingLink = '<a href="view.php?doc='.$PAPER{$teamIDX}{3}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{3}{TX_PAPER}.'</a>';
        $str .= '<tr class="w3-hide-small">';
        $str .= '<td nowrap ><div style="height: 18px; overflow: hidden">'.$ecrLink.'</div></td>';
        $str .= '<td nowrap >'.$drawingLink.'</td>';
        $str .= '<td ID="TD_teamPresoTime_'.$teamIDX.'" nowrap><a href="javascript:void(0);" onclick="sae_openTeamPresoSchedule(2, '.$teamIDX.','.$TODO{$teamIDX}{PK_TODO_IDX}.')">'.$schedule.'</a></td>';
        $str .= '<td style="text-align: left;">';
        $str .= '<a class="w3-small" ID="LINK_INSPECTION_'.$teamIDX.'" href="javascript:void(0);" onclick="sae_showUpdateInspectionStatus('.$teamIDX.');">'.$status.'</a>';
        $str .= '</td>';
        if (exists $PEN{$teamIDX}) {
            $str .= sprintf '<td style="text-align: right;">- %2.1f</td>', $PEN{$teamIDX}{IN_TOTAL};
        } else {
            $str .= '<td style="text-align: right;"> - </td>';
        }
        $str .= '<td>';
        $str .= '<a class="w3-button w3-padding-small w3-round" style="border: 1px dashed #ccc;"  href="javascript:void(0)" onclick="sae_openECREntryForm(0,'.$teamIDX.')">+</a>&nbsp;&nbsp;';
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            # if ($ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}>0) {
            #     $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round w3-red" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
            #     $str .= sprintf '<i class="fa fa-check-square-o"></i> (-%2.1f)', $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION};
            # } else {
            #     $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
            # }
            # $str .= 'E-'.substr("0000".$ecrIDX,-4,4).'</a>&nbsp;&nbsp;';
            if ($ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}>0) {
                if ($ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}>0){
                    $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round w3-red" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
                } else {
                    $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round w3-yellow" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
                }
                $str .= sprintf '<i class="fa fa-check-square-o"></i> (%2.1f) ', $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION};
            } else {
                $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
            }
            $str .= 'E-'.substr("0000".$ecrIDX,-4,4).'</a>&nbsp;&nbsp;';
        }
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td style="padding: 0;">';
        $str .= '<div>';
        $str .= sprintf '<header class="w3-blue-grey w3-padding-small"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><h4 style="padding: 0; margin: 0;">%s</header>', $ecrLink_small;
        $str .= '<div class="w3-padding">';
        $str .= sprintf '<b>Document: </b><span>%s</span><br>', $drawingLink;
        $str .= sprintf '<b>Schedule: </b><span>%s</span><br>', $schedule;
        if (exists $PEN{$teamIDX}) {
            $str .= sprintf '<b>Penalties: </b><span class="w3-text-red">- %2.1f</span><br>', $PEN{$teamIDX}{IN_TOTAL};
        } else {
            $str .= '<b>Penalties: </b><span class="w3-text-red">0</span><br>';
        }
        $str .= '<a class="w3-button w3-padding-small w3-round" style="border: 1px dashed #111;" ID="LINK_INSPECTION_'.$teamIDX.'" href="javascript:void(0);" onclick="sae_showUpdateInspectionStatus('.$teamIDX.');">'.$status.'</a>';
        $str .= '<a class="w3-button w3-padding-small w3-round" style="border: 1px dashed #111; margin-left: 10px;"  href="javascript:void(0)" onclick="sae_openECREntryForm(0,'.$teamIDX.')">Add ECR</a><br><br>';
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            if ($ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}>0) {
                $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round w3-red" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
                $str .= '<i class="fa fa-check-square-o"></i> ';
            } else {
                $str .= '<a class="w3-button w3-tiny w3-padding-small w3-border w3-round" href="javascript:void(0)" onclick="sae_editEcr('.$ecrIDX.',1);">';
            }
            $str .= 'E-'.substr("0000".$ecrIDX,-4,4).'</a>&nbsp;&nbsp;';
        }
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
sub openCrashReinspection(){
    print $q->header();
    my $location = $q->param('location');
    my $Ref = new SAE::REFERENCE();
    %LIST = %{$Ref->_getReinspectListByEvent($location)};
    my $str = '<div class="w3-container w3-margin-top">';
    $str .= '<br>';
    $str .= '<h3>Re-Inspections</h3>';
    $str .= '<ul class="w3-ul w3-card-2">';
    foreach $todoIDX (sort {$a<=>$b} keys %LIST) {
        my $teamIDX = $LIST{$todoIDX}{PK_TEAM_IDX};
        $str .= '<li ID="TODO_IDX_'.$todoIDX.'"  class="w3-bar w3-white w3-display-container w3-button w3-hover-yellow" onclick="sae_openReinspectionDetails('.$teamIDX.','.$todoIDX.');">';
        $str .= sprintf '<p class="w3-bar-item">%03d - %s</p>', $LIST{$todoIDX}{IN_NUMBER}, $LIST{$todoIDX}{TX_SCHOOL};
        $str .= '<i class="w3-right w3-bar-item fa fa-chevron-right fa-fw"></i>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '<div>';
    return ($str);
}
sub sae_openReinspectionDetails(){
    print $q->header();
    my $Flight = new SAE::FLIGHT();
    my $Ref = new SAE::REFERENCE();
    my $teamIDX = $q->param('teamIDX');
    my $todoIDX = $q->param('todoIDX');
    my $divName = $q->param('divName');
    %CRASH = %{$Flight->_getCrashDataByTeamId($teamIDX)};
    %TEAM = %{$Ref->_getTeamData($teamIDX)};
    $str .= '<div class="w3-card-4 w3-white">';
    $str .= '<div class="w3-container w3-center">';
    $str .= '<h2>Crash Re-Inspection</h2>';
    $str .= sprintf '<h4>%03d - %s</h4>',$TEAM{$teamIDX}{IN_NUMBER}, $TEAM{$teamIDX}{TX_SCHOOL};
    
    $str .= '<img src="images/inspection.png" alt="Avatar" style="width:50%">';
    foreach $todoIDX (sort keys %CRASH) {
        my @ITEMS = split(";", $CRASH{$todoIDX}{CL_DESCRIPTION});
        $str .= '<ul class="w3-ul w3-large" style="text-align: left;">';
        $str .= '<B>Re-inspect the following item(s)</B><br>';
        foreach $item (sort {$a<=>$b} @ITEMS){
            $str .= '<li style="padding: 1px; ">- '.$item.'</li>';
        }
        $str .= '</ul>';
        $str .= '<div class="w3-section">';
        $str .= '<button class="w3-button w3-green w3-round" onclick="sae_clearReinspectionDetails('.$teamIDX.','.$todoIDX.',\''.$divName.'\')">Pass</button>&nbsp;';
        $str .= '<button class="w3-button w3-red w3-round" onclick="$(\'#'.$divName.'\').remove();">Failed</button>';
        $str .= '</div>';
    }
    
    $str .= '</div>';
    $str .= '</div>';
    
    # $str .= '<ul class="w3-ul">';
    # foreach $todoIDX (sort keys %CRASH) {
    #     my @ITEMS = split(";", $CRASH{$todoIDX}{CL_DESCRIPTION});
    #     $str .= '<li style="padding: 2px;" class="w3-bar">';
    #     $str .= '<a class="w3-button w3-border w3-green w3-bar-item w3-round" href="javascript:void(0);" onclick="sae_clearReinspectionDetails(this, '.$teamIDX.','.$todoIDX.',\''.$divName.'\')">Clear</a> ';
    #     $str .= '<div class="w3-bar-item">Round '.$CRASH{$todoIDX}{IN_ROUND}.' - '.$CRASH{$todoIDX}{TX_STATUS}.'  for: ';
    #     $str .= '<ul class="w3-ul">';
    #     foreach $item (sort {$a<=>$b} @ITEMS){
    #         $str .= '<li style="padding: 1px; margin-left: 20px">'.$item.'</li>';
    #     }
    #     $str .= '</ul>';
    #     $str .= '</div>';
    #     $str .= '</li>';
    # }
    # $str .= '</ul>';
    return($str);
}
sub sae_clearReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $todoIDX = $q->param('todoIDX');
    my $Flight = new SAE::FLIGHT();
    $Flight->_updateReinspectionItems( $todoIDX );
    return ($str);
}
