#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use CGI::Session;
# use CGI::Cookie;
# use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Mail::Sendmail;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::TB_PAPER;
use SAE::TB_UPLOAD;
use SAE::TB_GRADE;
# use SAE::TB_SCORE_EVENT;
# use SAE::TB_SCORE_GROUP;
# use SAE::TB_SCORE_SECTION;
# use SAE::TB_SCORE_ITEM;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::TB_CLASS;
use SAE::Common;
# use SAE::Auth;
# use SAE::TB_USER_TEAM;
use SAE::TB_EVENT;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");
my %GROUP = (1=>3, 2=>5, 3=>6);
if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
sub __template(){
    print $q->header();
    my $location = $q->param('location');
    my $str;

    return ($str);
}
#  ======================= FILE UPLOAD ================================
sub createGradeRecords(){
    print $q->header();
    my $txType = $q->param('txType');
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $count = $q->param('count');
    my $dbi = new SAE::Db();
    my $SQL = "SELECT count(*) AS number FROM TB_GRADE WHERE FK_TEAM_IDX=? AND TX_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($PkTeamIdx , $txType );
    my $limit = $select->fetchrow_array();
    my $toAdd = $count - $limit;
    if ($toAdd > 0){
        my $SQLinsert = "INSERT INTO TB_GRADE (FK_TEAM_IDX, TX_TYPE) VALUES (?, ?)";
        my $insert = $dbi->prepare($SQLinsert);
        for ($x=0; $x<$toAdd; $x++){
            $insert->execute($PkTeamIdx, $txType) || die "Cannot Insert";
        }
    }
    return();
}
sub showRemoveFiles(){
    print $q->header();
    my $location = $q->param('location');
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Upload = new SAE::TB_UPLOAD();
    %UPLOAD = %{$Upload->getAllRecordBy_FkTeamIdx($PkTeamIdx)};
    my $str;
#     $str .= join(",",keys %UPLOAD);
    $str .= '<a class="button small" style="float: right;" href="javascript:void(0);" onclick="deleteDiv(\'DIV_LIST_FILE_TO_REMOVE\')">Exit</a>';
    $str .= '<div class="w3-container">';
    if (scalar (keys %UPLOAD)>0){
        $str .= '<h2>Attached Files</h2>';
    } else {
        $str .= '<h2>No Files</h2>';
    }
    $str .= '<ul class="w3-ul w3-card-4">';
    foreach $PkUploadIdx (sort keys %UPLOAD) {
            $str .= '<li ID="LI_'.$PkUploadIdx.'" class="w3-display-container" style="text-align: left;">';
            $str .= '<span class="w3-padding fa fa-file-pdf-o"></span>';
            $str .= $UPLOAD{$PkUploadIdx}{TX_FILENAME};
            $str .= ' <span class="w3-button w3-transparent w3-display-right" onclick="removeFileFromTeam('.$PkUploadIdx.',\'TD_'.$UPLOAD{$PkUploadIdx}{TX_LABEL}.'_'.$PkTeamIdx.'\')">&times;</span>';
            $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';

    return ($str);
}
sub removeFileFromTeam(){
    print $q->header();
    my $PkUploadIdx = $q->param('PkUploadIdx');
    my $Upload = new SAE::TB_UPLOAD();
    $Upload->deleteRecordById($PkUploadIdx);
    my $str;
    $str = '-NA-';
    return ($str);
}
sub _templateFileBrowse(){
    my ($label, $nameID, $nameCodeID, $codeValue) = @_;
    my $str;
    $str = '<tr>';
    $str .= '<td style="width: 25%;">';
    $str .= $label;
    $str .= '</td>';
    $str .= '<td style="width: 75%; overflow: hidden;">';
    $str .= '<input class="w3-input" type="file" name="'.$nameID.'" id="'.$nameID.'" />';
    $str .= '<input type="hidden" name="'.$nameCodeID.'" ID="'.$nameCodeID.'" value="'.$codeValue.'"/>';
    $str .= '</td>';
    $str .= '</tr>';

    return ($str);
}
sub rndStr{
    join('', @_[ map{ rand @_ } 1 .. shift ])
}
sub showFileUploadForm(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $location = $q->param('location');

    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($PkTeamIdx);
    my $TxSchool = $Team->getTxSchool();
    my $InNumber = substr("000".$Team->getInNumber(),-3,3);
#     my $pass_teamIDX = $q->param('teamIDX');
#     my $team = new SAE::Team( $pass_teamIDX );
    my $str;
    $reportCode = rndStr 32, 'A'..'Z', 'a'..'z', 0..9;
    $tdsCode = rndStr 32, 'A'..'Z', 'a'..'z', 0..9;
    $drawingCode = rndStr 32, 'A'..'Z', 'a'..'z', 0..9;
    $str .= '<a class="w3-button w3-border w3-white w3-display-topright" onclick="closeModal(\'FILE_UPLOAD_OBJECT\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h3 id="teamName">'.$InNumber .' - '.$TxSchool.'</h3>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<table style="width: 100%;">';
    $str .= '<input type="hidden" name="teamIDX" ID="teamIDX" value="'.$PkTeamIdx.'"/>';
    $str .= '<input type="hidden" name="eventIDX" ID="eventIDX" value="'.$location.'"/>';
    $str .= &_templateFileBrowse('2D Drawing', 'drawing', 'drawingCode', $drawingCode);
    $str .= &_templateFileBrowse('Design Report', 'report', 'reportCode', $reportCode);
    $str .= &_templateFileBrowse('Technical Data Sheet', 'tds', 'tdsCode', $tdsCode);
    $str .= '</table>';
    $str .= '<div style="clear:both;"></div>';
    $str .= '<div id="message" class="w3-panel w3-pale-yellow w3-border w3-border-yellow"></div>';
    $str .= '</div>';
    $str .= '<div class="w3-container" style="text-align: center; padding: 10px;">';
    $str .= '<input class="w3-button w3-border w3-round-large" type="submit" value="Upload" class="submit" />';
    $str .= '</div>';
    return ($str);

}
sub showTeamFileList(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};
    my $SQL = "SELECT TX_LABEL, TX_SERIAL, PK_UPLOAD_IDX, TX_FILENAME, FK_TEAM_IDX FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
    my $select=$dbi->prepare($SQL);
    $select->execute($location);
    while (my ($TxLabel, $TxSerial, $PkUploadIdx, $TxFilename, $FkTeamIdx) = $select->fetchrow_array()) {
        $FILES{$FkTeamIdx}{$TxLabel}{TX_SERIAL}=$TxSerial;
        $FILES{$FkTeamIdx}{$TxLabel}{PK_UPLOAD_IDX}=$PkUploadIdx;
        $FILES{$FkTeamIdx}{$TxLabel}{TX_FILENAME}=$TxFilename;
    }
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadDesignReportManagement();">&nbsp;Back</a>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-hoverable w3-small">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th style="width: 50px;">#</th>';
    $str .= '<th >School</th>';
    $str .= '<th style="width: 100px;">Upload</th>';
    $str .= '<th style="width: 180px;">Report</th>';
    $str .= '<th style="width: 180px;">TDS</th>';
    $str .= '<th style="width: 180px;">2D Drawing</th>';
    $str .= '<th style="width: 76px;">Remove</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $PkTeamIdx (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        my $reportLink = '-NA-';
        my $tdsLink = '-NA-';
        my $drawingLink = '-NA-';
        if (exists $FILES{$PkTeamIdx}{'Design_Report'}){
            $reportLink = '<a class="w3-small fa fa-file-pdf-o" style="float: left;" href="download.php?fileID='.$FILES{$PkTeamIdx}{'Design_Report'}{TX_SERIAL}.'" target="_blank">&nbsp;&nbsp;'.$FILES{$PkTeamIdx}{'Design_Report'}{TX_FILENAME}.'</a>';
        }
        if (exists $FILES{$PkTeamIdx}{'Tech_Data_Sheet'}){
            $tdsLink = '<a class="w3-small fa fa-file-pdf-o" style="float: left;" href="download.php?fileID='.$FILES{$PkTeamIdx}{'Tech_Data_Sheet'}{TX_SERIAL}.'" target="_blank">&nbsp;&nbsp;'.$FILES{$PkTeamIdx}{'Tech_Data_Sheet'}{TX_FILENAME}.'</a>';
        }
        if (exists $FILES{$PkTeamIdx}{'2D_Drawings'}){
            $drawingLink = '<a class="w3-small fa fa-file-pdf-o" style="float: left;" href="download.php?fileID='.$FILES{$PkTeamIdx}{'2D_Drawings'}{TX_SERIAL}.'" target="_blank">&nbsp;&nbsp;'.$FILES{$PkTeamIdx}{'2D_Drawings'}{TX_FILENAME}.'</a>';
        }
        $str .= '<tr>';
        $str .= '<td class="w3-border-right" >'.substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td class="w3-border-right" >'.$TEAM{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td class="w3-border-right" >';
        $str .= '<a class="button small fit fa fa-plus special" href="javascript:void(0);" onclick="showFileUploadForm('.$PkTeamIdx.');">&nbsp;Upload</a>';
        $str .= '</td>';
        $str .= '<td ID="TD_TX_REPORT_'.$PkTeamIdx.'" class="w3-border-right;" >'.$reportLink.'</td>';
        $str .= '<td ID="TD_TX_TDS_'.$PkTeamIdx.'" class="w3-border-right;" >'.$tdsLink.'</td>';
        $str .= '<td ID="TD_TX_DRAWING_'.$PkTeamIdx.'" class="w3-border-right;" >'.$drawingLink.'</td>';
        $str .= '<td class="w3-border-right" >';
        $str .= '<a class="button small fit fa fa-trash" href="javascript:void(0);" onclick="showRemoveFiles('.$PkTeamIdx.');">&nbsp;Remove</a>';
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';

    return ($str);
}
#  ======================= DISTRIBUTE BY JUDGE =========================
sub showListOfReports(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Team = new SAE::TB_TEAM();
    my $location = $q->param('location');
    my $txType = $q->param('txType');
    my $userIDX = $q->param('userIDX');
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};

    my $SQL = "SELECT GRADE.* FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=? AND TX_TYPE=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location, $txType);
    %GRADE = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_GRADE_IDX'])};
#
    $SQL = "SELECT FK_TEAM_IDX FROM TB_GRADE WHERE FK_USER_IDX=? AND TX_TYPE=?";
    $select = $dbi->prepare($SQL);
    $select->execute($userIDX, $txType);
    while (my ($FkTeamIdx) = $select->fetchrow_array()) {
        $SEEN{$FkTeamIdx} = 1;
    }

    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h3 style="float: left;">'.uc($txType).' SCORE CARDS</h3>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-small" style="width: 100%;">';
    $str .= '<tr>';
    $str .= '<th style="width: 25%">Team</th>';
    $str .= '<th style="width: 75%">Score Cards</th>';
    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        $teamName = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
        $str .= '<tr>';
        $str .= '<td>'.$teamName.'</td>';
        $str .= '<td>';
        if (exists $SEEN{$teamIDX}){
            $str .= '<span class="w3-button w3-team_'.$teamIDX.' w3-disabled">..</span>';
        } else {
            $str .= '<button class="w3-button w3-team_'.$teamIDX.'" style="border: 1px dashed #ccc;" onclick="addGradeCard(this, '.$teamIDX.',\''.$txType.'\','.$userIDX.');">+</button>';
        }

        foreach $PkGradeIdx (sort {$a <=> $b} keys %{$GRADE{$teamIDX}}) {
            if ($GRADE{$teamIDX}{$PkGradeIdx}{FK_USER_IDX} > 0 || exists $SEEN{$teamIDX}) {
                $str .= '<button class="w3-button w3-margin-left w3-disabled" style="border: 1px dashed #ccc; color: #ccc;" >-------</button>';
            } else {
                $str .= &_templateAssignButton($teamIDX,$PkGradeIdx,$userIDX,$txType);
            }
        }
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    return ($str);
}
sub _templateAssignButton(){
    my $teamIDX = shift;
    my $PkGradeIdx = shift;
    my $userIDX = shift;
    my $txType = shift;
    my $str = '<button class="w3-button w3-border w3-margin-left w3-team_'.$teamIDX.'" onclick="assignTeamToJudge(this, '.$PkGradeIdx.','.$userIDX.','.$teamIDX.',\''.$txType.'\');">Assign</button>';
    return ($str);
}
sub addGradeCard(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $txType = $q->param('txType');
    my $teamIDX = $q->param('teamIDX');
    my $userIDX = $q->param('userIDX');
    my $SQL = "INSERT INTO TB_GRADE (FK_TEAM_IDX, TX_TYPE) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($teamIDX, $txType);
    my $newIDX = $insert->{q{mysql_insertid}};
    $str .= &_templateAssignButton($teamIDX,$newIDX,$userIDX,$txType);
#     $str = '<button class="w3-button w3-border w3-margin-left w3-team_'.$teamIDX.'" onclick="assignTeamToJudge(this, '.$newIDX.','.$userIDX.','.$teamIDX.',\''.$txType.'\');">Assign</button>';
    return ($str);
}
sub assignTeamToJudge(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $FkUserIdx = $q->param('userIDX');
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $teamIDX = $q->param('teamIDX');
    my $SQL = "UPDATE TB_GRADE SET FK_USER_IDX=? WHERE PK_GRADE_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($FkUserIdx, $PkGradeIdx);
    my $Team = new SAE::TB_TEAM();
    %TEAM = %{$Team->getAllRecordBy_PkTeamIdx($teamIDX)};
    $teamName = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
    $str = &_teamCardTemplate($PkGradeIdx, $teamName);
    return ($str);
}
sub _teamCardTemplate(){
    my $PkGradeIdx = shift;
    my $teamName = shift;
    my $eIDX = shift;
    my $doc = shift;
    my $status = shift;
    %STAT = (0=>'w3-white',1=>'w3-white',2=>'w3-yellow',3=>'w3-blue');
    my $str;
    $str  = '<li class="w3-bar '.$STAT{$status}.'" style="padding: 2px 0px 2px 7px !important">';
    $str .= '<span class="w3-bar-item w3-button w3-tiny w3-right" onclick="removeScoreCard(this,'.$PkGradeIdx.');">X</span>';
#     $str .= $teamName;
    $str .= '<a class="" href="score.html?teamIDX='.$eIDX.'&doc='.$doc.'&rnd=0" target="_blank">'.$teamName.'</a>';
#     $str .= '<a href="judge.html" target="_blank">'.$teamName.'</a>';
    $str .= '</li>';
    return ($str);
}
sub showDistributeByJudge(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Team = new SAE::TB_TEAM();
    my $User = new SAE::TB_USER();
    my $Class = new SAE::TB_CLASS();
    my $location = $q->param('location');

    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};

    my $SQL = "SELECT USER.TX_FIRST_NAME, USER.TX_LAST_NAME, USER.PK_USER_IDX, USER.TX_EMAIL FROM TB_USER AS USER JOIN TB_USER_EVENT AS UEVENT ON USER.PK_USER_IDX = UEVENT.FK_USER_IDX WHERE UEVENT.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    %JUDGE = %{$select->fetchall_hashref(['PK_USER_IDX'])};
    my $SQL = "SELECT GRADE.* FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    %GRADE = %{$select->fetchall_hashref(['FK_USER_IDX','TX_TYPE','PK_GRADE_IDX'])};

    my $str = '<div class="w3-container">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadDesignReportManagement();">&nbsp;Back</a>';
    $str .= '</div>';
    $str .= '<table class="w3-table w3-bordered w3-small">';
    $str .= '<tr class="w3-light-grey">';
    $str .= '<th style="width: 20%;">(ID) Judge</th>';
    $str .= '<th style="width: 20%;" class="w3-center">Assessing Report For</th>';
    $str .= '<th style="width: 20%;" class="w3-center">Assessing Requirements For</th>';
    $str .= '<th style="width: 20%;" class="w3-center">Assessing TDS For</th>';
    $str .= '<th style="width: 20%;" class="w3-center">Assessing Drawing For</th>';
    $str .= '</tr>';
    foreach $userIDX (sort {lc($JUDGE{$a}{TX_LAST_NAME}) cmp lc($JUDGE{$b}{TX_LAST_NAME})} keys %JUDGE) {
        $JudgeName = $JUDGE{$userIDX}{TX_FIRST_NAME}.' '.$JUDGE{$userIDX}{TX_LAST_NAME};
        $email = $JUDGE{$userIDX}{TX_EMAIL};
        $str .= '<tr class="w3-small">';
        $str .= '<td class="w3-border-right" rowspan="2">('.$userIDX.') '.$JudgeName .'<br>'.$email.'</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="report_Judge_'.$userIDX.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$userIDX}{'report'}}){
            my $eIDX = crypt($teamIDX,'19');
            $teamIDX = $GRADE{$userIDX}{'report'}{$pkGradeIdx}{FK_TEAM_IDX};
            $boStatus = $GRADE{$userIDX}{'report'}{$pkGradeIdx}{BO_STATUS};
            $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
            $str .= &_teamCardTemplate($pkGradeIdx, $team, $eIDX, 'report', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="requirements_Judge_'.$userIDX.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$userIDX}{'requirements'}}){
            $teamIDX = $GRADE{$userIDX}{'requirements'}{$pkGradeIdx}{FK_TEAM_IDX};
            $boStatus = $GRADE{$userIDX}{'requirements'}{$pkGradeIdx}{BO_STATUS};
            my $eIDX = crypt($teamIDX,'19');
            $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
            $str .= &_teamCardTemplate($pkGradeIdx, $team, $eIDX, 'requirements', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="tds_Judge_'.$userIDX.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$userIDX}{'tds'}}){
            $teamIDX = $GRADE{$userIDX}{'tds'}{$pkGradeIdx}{FK_TEAM_IDX};
            $boStatus = $GRADE{$userIDX}{'tds'}{$pkGradeIdx}{BO_STATUS};
            my $eIDX = crypt($teamIDX,'19');
            $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
            $str .= &_teamCardTemplate($pkGradeIdx, $team, $eIDX, 'tds', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="drawing_Judge_'.$userIDX.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$userIDX}{'drawing'}}){
            $teamIDX = $GRADE{$userIDX}{'drawing'}{$pkGradeIdx}{FK_TEAM_IDX};
            $boStatus = $GRADE{$userIDX}{'drawing'}{$pkGradeIdx}{BO_STATUS};
            my $eIDX = crypt($teamIDX,'19');
            $team = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
            $str .= &_teamCardTemplate($pkGradeIdx, $team, $eIDX, 'drawing', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr class="w3-small">';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="showListOfReports('.$userIDX.',\'report\');">+ Assign Team</a></td>';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="showListOfReports('.$userIDX.',\'requirements\');">+ Assign Team</a></td>';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="showListOfReports('.$userIDX.',\'tds\');">+ Assign Team</a></td>';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="showListOfReports('.$userIDX.',\'drawing\');">+ Assign Team</a></td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    return ($str);
}
#  ======================= DISTRIBUTE BY TEAM ==========================
sub showListOfJudges(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $teamIDX = $q->param('teamIDX');
    my $txType = $q->param('txType');
    my $location = $q->param('location');
    my $SQL = "SELECT USER.TX_FIRST_NAME, USER.TX_LAST_NAME, USER.PK_USER_IDX FROM TB_USER AS USER JOIN TB_USER_EVENT AS UEVENT ON USER.PK_USER_IDX = UEVENT.FK_USER_IDX WHERE UEVENT.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    %JUDGE = %{$select->fetchall_hashref(['PK_USER_IDX'])};
#     $SQL = "SELECT FK_USER_IDX, FK_TEAM_IDX, TX_TYPE FROM TB_GRADE WHERE FK_USER_IDX>?";
    $SQL = "SELECT GRADE.FK_USER_IDX, GRADE.FK_TEAM_IDX, GRADE.TX_TYPE, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE GRADE.FK_USER_IDX>?";
    $select = $dbi->prepare($SQL);
    $select->execute(0);
    while (my ($fkUserIdx, $fkTeamIdx, $TX_TYPE, $inNumber, $txSchool) = $select->fetchrow_array()) {
        $ASSIGNED{$fkUserIdx}++;
        $LIST{$fkUserIdx} .= substr("000".$inNumber,-3,3).' - '.$txSchool.'<br>';
        $SEEN{$TX_TYPE}{$fkTeamIdx}{$fkUserIdx} = 1;
    }

    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h3 style="float: left;">List Of Judges</h3>';
    $str .= '</div>';
    $str .= '<div class="w3-row w3-small">';
    foreach $userIDX (sort {lc($JUDGE{$a}{TX_LAST_NAME}) cmp lc($JUDGE{$b}{TX_LAST_NAME})} keys %JUDGE) {
        $str .= '<div class="w3-col s4 w3-left w3-display-container" style="overflow: hidden">';
#         $str .= $teamIDX.'-'.$userIDX;
        $JudgeName = $JUDGE{$userIDX}{TX_FIRST_NAME}.' '.$JUDGE{$userIDX}{TX_LAST_NAME};
        if (exists $SEEN{$txType}{$teamIDX}{$userIDX}){
            $str .= '<div class="w3-bar-item w3-padding"><span class="w3-button w3-disabled">..</span>&nbsp;';
        } else {
            $str .= '<div class="w3-bar-item w3-padding"><span class="w3-button w3-green" onclick="addJudgeToCard('.$userIDX.', '.$PkGradeIdx.',\''.$JudgeName.'\');">+</span>&nbsp;';
        }

        $str .= '<span class=" w3-tooltip">'.$JudgeName;
        $str .= '&nbsp;<span class="w3-badge w3-red">'.$ASSIGNED{$userIDX}.'</span>';
        $str .= '<span class="w3-text w3-tag w3-sand w3-animate-opacity w3-tiny" style="text-align: left !important;">'.$LIST{$userIDX}.'</span></span>';
        $str .= '</div>';
        $str .= '</div>';
    }
    $str .= '</div> ';
    return ($str);
}
sub addJudgeToCard(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $FkUserIdx = $q->param('userIDX');
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $JudgeName = $q->param('JudgeName');
    my $SQL = "UPDATE TB_GRADE SET FK_USER_IDX=? WHERE PK_GRADE_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($FkUserIdx, $PkGradeIdx);
    return $JudgeName;
}
sub removeScoreCard(){
    print $q->header();
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $Grade = new SAE::TB_GRADE();
    $Grade->deleteRecordBy_PkGradeIdx($PkGradeIdx);
}
sub addAScoreCard(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $txType = $q->param('txType');
    my $dbi = new SAE::Db();
    my $SQLinsert = "INSERT INTO TB_GRADE (FK_TEAM_IDX, TX_TYPE) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQLinsert);
    $insert->execute($PkTeamIdx, $txType) || die "Cannot Insert";
    my $newIDX = $insert->{q{mysql_insertid}};
    my $str = &_scoreCardTemplate($newIDX,0,0,$PkTeamIdx,$txType);
    return ($str);
}
sub _scoreCardTemplate(){
    my $PkGradeIdx = shift;
    my $assigned = shift;
    my $JudgeName = shift;
    my $teamIDX = shift;
    my $txType = shift;
    my $status = shift;
    %STAT = (0=>'w3-white',1=>'w3-white',2=>'w3-yellow',3=>'w3-blue');
    my $str;
    $str  = '<li class="w3-bar '.$STAT{$status}.'" style="padding: 0px !important">';
    $str .= '<span class="w3-bar-item w3-button w3-tiny w3-right" onclick="removeScoreCard(this,'.$PkGradeIdx.');">X</span>';
    if ($assigned > 0){
        $str .= '<img ID="img_'.$PkGradeIdx.'" src="images/Judge.png" class="w3-bar-item w3-hide-small" style="width: 50px" hspace="0" vspace="0">';
    } else {
         $str .= '<img ID="img_'.$PkGradeIdx.'" src="images/man.png" class="w3-bar-item w3-hide-small" style="width: 50px" hspace="0" vspace="0">';
    }
#     $str .= '<div class="w3-bar-item">';
    $str .= '<span class="w3-small w3-bar-item" style="margin-left: -28px"><a ID="JUDGE_FOR_'.$PkGradeIdx.'" href="javascript:void(0);" onclick="showListOfJudges('.$PkGradeIdx.','.$teamIDX.',\''.$txType .'\');">';
    if ($assigned > 0){
        $str .= $JudgeName;
    } else {
        $str .= 'Assign Judge';
    }
    $str .= '</a></span>';

#     $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub updateMarkdownFactor(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $teamIDX = $q->param('teamIDX');
    my $factor = $q->param('factor');
    my $SQL = "UPDATE TB_TEAM SET IN_FACTOR=? WHERE PK_TEAM_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($factor, $teamIDX);
}
sub updateDaysLate(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $teamIDX = $q->param('teamIDX');
    my $inLate = $q->param('inLate');
    my $SQL = "UPDATE TB_TEAM SET IN_LATE=? WHERE PK_TEAM_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($inLate, $teamIDX);
}
sub showDistributeByTeam(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $User = new SAE::TB_USER();
    my $Class = new SAE::TB_CLASS();
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};
    %USER = %{$User->getAllRecord()};
    %CLASS = %{$Class->getAllRecord()};
    my $SQL = "SELECT GRADE.* FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    %GRADE = %{$select->fetchall_hashref(['FK_TEAM_IDX','TX_TYPE','PK_GRADE_IDX'])};
    my $str = '<div class="w3-container">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadDesignReportManagement();">&nbsp;Back</a>';
    $str .= '</div>';
    $str .= '<table class="w3-table w3-bordered w3-small">';
    $str .= '<tr class="w3-light-grey">';
    $str .= '<th style="width: 20%;"># (Class) School</th>';
    $str .= '<th style="width: 60px">Markdown<br>Factor</th>';
    $str .= '<th style="width: 60px"># Days<br>Late</th>';
    $str .= '<th style="width: 15%;" class="w3-center">Assessing Report By</th>';
    $str .= '<th style="width: 15%;" class="w3-center">Assessing Requirements By</th>';
    $str .= '<th style="width: 15%;" class="w3-center">Assessing TDS By</th>';
    $str .= '<th style="width: 15%;" class="w3-center">Assessing Drawing By</th>';
    $str .= '</tr>';
    foreach $PkTeamIdx (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        my $eDIX = crypt($PkTeamIdx,'19');
        my $link = '<a href="score.html?teamIDX='.$eDIX.'&doc=requirements,tds,drawing,report&rnd=0" target="_blank" class="w3-link">'.$TEAM{$PkTeamIdx}{TX_SCHOOL}.'</a>';
        $str .= '<tr class="w3-small">';
        $str .= '<td class="w3-border-right" rowspan="2"><span style="padding: 2px 7px 2px 0px">'.substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3).' ('.$CLASS{$TEAM{$PkTeamIdx}{FK_CLASS_IDX}}{TX_CLASS}.')</span><br>';
        $str .= '<span class="w3-small" style="width: 100%;">'.$link.'</span>';
        # $str .= '<br><a href="score.html?teamIDX='.$eDIX.'&doc=requirements,tds,drawing,report&rnd=0" target="_blank" class="w3-button w3-small w3-border">View Summary</a>';
        
        $str .= '</td>';
        $str .= '<td>';
        $str .= 'Markdown %<br><input type="number" style="width: 60px;" step=".01" value="'.$TEAM{$PkTeamIdx}{IN_FACTOR}.'" onchange="updateMarkdownFactor(this, '.$PkTeamIdx .')">';
        $str .= '</td>';
        $str .= '<td>';
        $str .= 'Days Late<br><input type="number" style="width: 60px;"  value="'.$TEAM{$PkTeamIdx}{IN_LATE}.'" onchange="updateDaysLate(this,'.$PkTeamIdx.')">';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="report_Judge_'.$PkTeamIdx.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$PkTeamIdx}{'report'}}){
            $userIDX = $GRADE{$PkTeamIdx}{'report'}{$pkGradeIdx}{FK_USER_IDX};
            $boStatus = $GRADE{$PkTeamIdx}{'report'}{$pkGradeIdx}{BO_STATUS};
            $userName = $USER{$userIDX}{TX_FIRST_NAME}.' '.$USER{$userIDX}{TX_LAST_NAME};
            $str .= &_scoreCardTemplate($pkGradeIdx, $userIDX, $userName, $PkTeamIdx,'report', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="requirements_Judge_'.$PkTeamIdx.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$PkTeamIdx}{'requirements'}}){
            $userIDX = $GRADE{$PkTeamIdx}{'requirements'}{$pkGradeIdx}{FK_USER_IDX};
            $boStatus = $GRADE{$PkTeamIdx}{'requirements'}{$pkGradeIdx}{BO_STATUS};
            $userName = $USER{$userIDX}{TX_FIRST_NAME}.' '.$USER{$userIDX}{TX_LAST_NAME};
            $str .= &_scoreCardTemplate($pkGradeIdx, $userIDX, $userName, $PkTeamIdx,'requirements', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="tds_Judge_'.$PkTeamIdx.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$PkTeamIdx}{'tds'}}){
            $userIDX = $GRADE{$PkTeamIdx}{'tds'}{$pkGradeIdx}{FK_USER_IDX};
            $userName = $USER{$userIDX}{TX_FIRST_NAME}.' '.$USER{$userIDX}{TX_LAST_NAME};
            $boStatus = $GRADE{$PkTeamIdx}{'tds'}{$pkGradeIdx}{BO_STATUS};
            $str .= &_scoreCardTemplate($pkGradeIdx, $userIDX, $userName, $PkTeamIdx,'tds', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '<td class="w3-border-right w3-container w3-padding-small">';
        $str .= '<ul ID="drawing_Judge_'.$PkTeamIdx.'" class="w3-ul w3-card-4">';
        foreach $pkGradeIdx (sort keys %{$GRADE{$PkTeamIdx}{'drawing'}}){
            $userIDX = $GRADE{$PkTeamIdx}{'drawing'}{$pkGradeIdx}{FK_USER_IDX};
            $userName = $USER{$userIDX}{TX_FIRST_NAME}.' '.$USER{$userIDX}{TX_LAST_NAME};
            $boStatus = $GRADE{$PkTeamIdx}{'drawing'}{$pkGradeIdx}{BO_STATUS};
            $str .= &_scoreCardTemplate($pkGradeIdx, $userIDX, $userName, $PkTeamIdx,'drawing', $boStatus);
        }
        $str .= '</ul>';
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr class="w3-small">';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="addAScoreCard('.$PkTeamIdx.', \'report\');">+ Add Score Card</a></td>';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="addAScoreCard('.$PkTeamIdx.', \'requirements\');">+ Add Score Card</a></td>';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="addAScoreCard('.$PkTeamIdx.', \'tds\');">+ Add Score Card</a></td>';
        $str .= '<td class="w3-border-right" style="padding: 0px; position: relative;"><a class="w3-button w3-text-blue" style="width: 100% !important; bottom: 0;" onclick="addAScoreCard('.$PkTeamIdx.', \'drawing\');">+ Add Score Card</a></td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
#     $str .= '</table>';
    return $str;
}
