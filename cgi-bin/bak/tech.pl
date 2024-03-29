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
use SAE::TEAM;
use SAE::AIRBOSS;
use SAE::TECH;



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
sub _templateEcrCard(){
    my ($ecrIDX, $teamIDX, $inValue, $inStatus, $userType) = @_;
    if ($inStatus >0){
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-red" onclick="sae_openExitingECR(%d, %d, %d);">-%2.2f</button>', $ecrIDX, $ecrIDX, $teamIDX, $userType, $inValue;
    } else {
        $str = sprintf '<button class="BTN_ECR_%d w3-button w3-border w3-round w3-margin-left w3-yellow" onclick="sae_openExitingECR(%d, %d, %d);">E-000%d: Pending Review</button>', $ecrIDX, $ecrIDX, $teamIDX, $userType, $ecrIDX;
    }
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
    
    $str .= '<th style="">Engineering Change Requests (ECRs)';
    $str .= '</th>';
   
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $teamIDX (sort {$a <=> $b} keys %TEAM){
        my $team = sprintf "%03d - %s", $TEAM{$teamIDX}{IN_NUMBER}, $TEAM{$teamIDX}{TX_SCHOOL};
        # $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
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
        $str .= sprintf '<td class="TD_ECR_LIST_%d">', $teamIDX;
        $str .= '<a class="w3-button w3-padding-small w3-round" style="border: 1px dashed #ccc;"  href="javascript:void(0)" onclick="sae_openECREntryForm(99,'.$teamIDX.')">+</a>&nbsp;&nbsp;';
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            $str .= &_templateEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}, 99);
        }
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td style="padding: 0; border: none;">';
        $str .= '<div class="w3-border w3-round w3-margin-bottom w3-card-2">';
        $str .= '<header class="w3-blue-grey" style="padding: 1px 10px;">';
        $str .= sprintf '<h4>%s</h4>', $team;
        $str .= '</header>';
        $str .= '<div class="w3-padding w3-bar">';
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<span class="w3-large"><i class="fa fa-download fa-2x" aria-hidden="true"></i> %s</span>', $drawingLink;
        $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="sae_openECREntryForm(%d, %d)">+ ECR</button><br>', 99,$teamIDX;
        $str .= sprintf '<DIV class=" w3-margin-top TD_ECR_LIST_%d">', $teamIDX;
        foreach $ecrIDX (sort {$a<=>$b} keys %{$ECRS{$teamIDX}}) {
            $str .= &_templateEcrCard($ecrIDX, $teamIDX, $ECRS{$teamIDX}{$ecrIDX}{IN_DEDUCTION}, $ECRS{$teamIDX}{$ecrIDX}{IN_STATUS}, 99);
        }
        $str .= '</DIV>';
        $str .= '</div>';
        $str .= '</div>';
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
    my $inShowAll = $q->param('inShowAll');
    my $Tech = new SAE::TECH($location);
    # my $Ref = new SAE::REFERENCE();
    my $height = 45;
    # my %LIST = %{$Ref->_getReinspectListByEvent($location)};
    my %LIST = %{$Tech->_getTechListData()};
    my %ARCHIVE = (1=>'sae-archive w3-light-grey w3-hide', 0=>'');
    my %CHECKED = (1=>'checked', 0=>'');
    my $str = '<br><div class="w3-container w3-margin-top">';
    $str .= '<h3>Re-Inspections</h3>';
    $str .= '<div class="w3-container w3-margin-bottom">';
    $str .= '<input type="checkbox"  onclick="sae_showAll(this);"> Show All';
    $str .= '</div>';
    $str .= '<ul ID="UL_CRASH_REPORT_LIST" class="w3-ul">&nbsp;';
    # $str .= "List Count = ".scalar (keys %LIST);
    foreach $todoIDX (sort {$LIST{$a}{IN_NUMBER}<=>$LIST{$b}{IN_NUMBER}} keys %LIST) {
        my $teamIDX = $LIST{$todoIDX}{FK_TEAM_IDX};
        my $flightIDX = $LIST{$todoIDX}{FK_FLIGHT_IDX};
        my $boArchive = $LIST{$todoIDX}{BO_ARCHIVE};
        $str .= $Tech->_generateTechButton($todoIDX, $flightIDX, $teamIDX, $boArchive);
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
}
sub sae_openReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $Team = new SAE::TEAM($teamIDX);
    my $Flight = new SAE::FLIGHT();
    my $Ref = new SAE::REFERENCE();
    my $Airboss = new SAE::AIRBOSS();
    my %TEAM = %{$Team->_getTeamData()};
    my %NOTES = %{$Airboss->_getFlightNotes($teamIDX)};
    my %CRASH = %{$Flight->_getCrashInspectionItems($flightIDX)};
    my $str = '<div class="w3-container w3-padding">';
    $str .= sprintf '<div class="w3-container w3-large">';
    $str .= sprintf '<h3>Team #: %03d</h3>', $TEAM{IN_NUMBER};
    $str .= sprintf '<h6>The following items needs to be re-inspected</h6>';
    $str .= '<div class="w3-row w3-border-bottom w3-round">';
    foreach $crashIDX (sort {$CRASH{$a}{TX_ITEM} cmp $CRASH{$b}{TX_ITEM}} keys  %CRASH){
        $str .= sprintf '<div class="w3-mobile w3-half w3-padding w3-margin-right w3-border w3-margin-bottom w3-round  w3-hover-pale-yellow"><i class="fa fa-wrench" aria-hidden="true"></i> %s</div>', $CRASH{$crashIDX}{TX_ITEM};
    }
    $str .= '</div>';  
    $str .= '<label class="w3-margin-top">Crash Notes:</label><br>';
    $str .= sprintf '<p>%s</p>', $Flight->_getCrashNotes($flightIDX);

    $str .= '<div class="w3-container w3-center">';
    $str .= sprintf '<button class="w3-button w3-green w3-round w3-margin-right w3-margin-top w3-mobile" onclick="sae_clearReinspectionDetails(this, %d, %d, %d, %d);">Pass</button>&nbsp;', $teamIDX, $flightIDX, $todoIDX, 1;
    $str .= sprintf '<button class="w3-button w3-red w3-round w3-margin-top w3-mobile" onclick="sae_clearReinspectionDetails(this, %d, %d, %d, %d);">Failed</button>&nbsp;', $teamIDX, $flightIDX, $todoIDX, 0;
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<b class="w3-margin-left"><a href="javascript:void(0);" onclick="sae_expandNotes();">View Note History</a></b>';
    foreach $notesIDX  (sort {$b<=>$a} keys %NOTES) {
        if ($NOTES{$notesIDX}{FK_FLIGHT_IDX}) {
            $str .= sprintf '<p class="w3-border-bottom w3-small crash-notes" style="padding: 10px; display: none;"><b class="w3-text-blue">Judge\'s Notes:</b><br>%s</p>', $NOTES{$notesIDX}{CL_NOTES};
        } else {
            $str .= sprintf '<p class="w3-border-bottom w3-small crash-notes" style="padding: 10px; display: none;"><b class="w3-text-green">Flight-Line Notes:</b><br>%s</p>', $NOTES{$notesIDX}{CL_NOTES};
        }
    }
    $str .= '</div>';
    $str .= '</div>';
    return($str);
}
sub sae_clearReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $inStatus = $q->param('inStatus');
    my $Flight = new SAE::FLIGHT($flightIDX);
    my $Tech = new SAE::TECH();
    my %FLIGHT = %{$Flight->_getFlightData()};
    my $logBtn = $Flight->_templateReinspectionButton($flightIDX, $teamIDX, $FLIGHT{IN_ROUND, $inStatus});
    if ($inStatus==1) {
        $logBtn = $Flight->_tempCheckOutButton($teamIDX);
    }
    my $techBtn = $Tech->_generateTechButton($todoIDX, $flightIDX, $teamIDX, $inStatus);
    $Flight->_updateReinspectionItems( $teamIDX, $flightIDX, $inStatus, $logBtn );
    my %DATA;
    $DATA{logBtn} = $logBtn;
    $DATA{techBtn} = $techBtn;
    $DATA{idx} = $teamIDX;
    $DATA{flightIDX} = $flightIDX;
    my $json = encode_json \%DATA;
    # return ($str);
}
sub sae_failedReinspectionDetails(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $Flight = new SAE::FLIGHT();
    my $btn = $Flight->_templateReinspectionButton($flightIDX, $teamIDX);
    $Flight->_updateReinspectionItemsFailed( $teamIDX, $flightIDX, $btn );
    return ($str);
}
sub _templateReinspectionButton(){
    my $flightIDX = shift;
    my $teamIDX = shift;
    my $Teams = new SAE::TB_TEAM();
       $Teams->getRecordById($teamIDX);
    my $number = $Teams->getInNumber();
    my $classIDX = $Teams->getFkClassIdx();
    # my $classIDX = shift;
    my $txNumber = sprintf '%03d', $number;
    my $str;
    $str = sprintf '<button class="w3-button w3-border w3-round w3-orange w3-hover-yellow" style="margin-top: 5px;" onclick="sae_openClearCrash(%d, \'%s\', %d, %d);"><i class="fa fa-exclamation-triangle w3-margin-right" aria-hidden="true"></i>#%s<i class="fa fa-exclamation-triangle w3-margin-left" aria-hidden="true"></i></button>', $teamIDX, $number, $classIDX, $flightIDX, $txNumber.': Re-Inspection Required';
    return ($str);
}