#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI::Session;
use CGI::Cookie;
use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Mail::Sendmail;
# use HTML::Entities;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::TB_CLASS;
use SAE::TB_COUNTRY;
use SAE::Auth;
# use SAE::TB_USER_TEAM;
# use SAE::TB_EVENT;

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
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $str;

    return ($str);
}
sub generateAllNewCode() {
    print $q->header();
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    %TEAM =  %{$Team->getAllRecordBy_FkEventIdx($location)};
    my $Auth = new SAE::Auth();
    foreach $PkTeamIdx (sort keys %TEAM) {
        $TxCode = $Auth->getTemporaryPassword(6);
        $Team->updateTxCode_ById($TxCode, $PkTeamIdx);
    }

    return ("Updated Team Code for ".scalar (keys %TEAM)." Teams");
}
sub addTeam(){
    print $q->header();
    my $InNumber = $q->param('InNumber');
    my $TxSchool = $q->param('TxSchool');
    my $TxName = $q->param('TxName');
    my $PkCountryIdx = $q->param('PkCountryIdx');
    my $PkClassIdx = $q->param('PkClassIdx');
    my $location = $q->param('location');
    my $dbi = new SAE::Db();
    my $SQL = "INSERT INTO TB_TEAM (IN_NUMBER, TX_SCHOOL, TX_NAME, FK_COUNTRY_IDX, FK_CLASS_IDX, FK_EVENT_IDX)
        VALUES (?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($InNumber, $TxSchool, $TxName, $PkCountryIdx, $PkClassIdx, $location);
    my $PkTeamIdx = $insert->{q{mysql_insertid}};
    $InNumber = substr("000".$InNumber,-3,3);
    $str .= &_templateList($PkTeamIdx, $InNumber, $TxSchool, $TxName);
    return ($str);
}
sub showAddTeam(){
    print $q->header();
    my $location = $q->param('location');
    my $Class = new SAE::TB_CLASS();
    %CLASS = %{$Class->getAllRecord()};
    my $Country = new SAE::TB_COUNTRY();
    %COUNTRY = %{$Country->getAllRecord()};
    my $location = $q->param('location');
    my $str;
    $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2>New Team</h2>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<p><label>Team Number</label>';
    $str .= '<input class="w3-number w3-input" type="number" ID="IN_NUMBER"></p>';
    $str .= '<p><label>University</label>';
    $str .= '<input class="w3-input" type="text" ID="TX_SCHOOL"></p>';
    $str .= '<p><label>Name</label>';
    $str .= '<input class="w3-input" type="text" ID="TX_NAME" ></p>';
    $str .= '<p><label>Country</label>';
    $str .= '<select ID="FK_COUNTRY_IDX" class="w3-input">';
     $str .= '<option value="0">--- Country of Origin ---</option>';
    foreach $PkCountryIdx (sort {$COUNTRY{$a}{TX_COUNTRY} cmp $COUNTRY{$b}{TX_COUNTRY}} keys %COUNTRY) {
        $str .= '<option value="'.$PkCountryIdx.'">'.$COUNTRY{$PkCountryIdx}{TX_COUNTRY}.'</option>';
    }
    $str .= '</select>';
    $str .= '</p>';
    $str .= '<p><label>Class</label>';
    $str .= '<select ID="FK_CLASS_IDX" class="w3-input">';
    $str .= '<option value="0">--- Class ---</option>';
    foreach $PkClassIdx (sort {$CLASS{$a}{TX_COUNTRY} cmp $CLASS{$b}{TX_CLASS}} keys %CLASS) {
        $str .= '<option value="'.$PkClassIdx.'">'.$CLASS{$PkClassIdx}{TX_CLASS}.'</option>';
    }
    $str .= '</select>';
    $str .= '</p>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<span class="w3-button w3-card-4 w3-margin w3-white" onclick="addTeam();">Add</span>';
    $str .= '<span class="w3-button w3-card-4 w3-margin w3-white" onclick="closeModal(\'id01\');">Cancel</span>';
    $str .= '</div>';
    return ($str);
}
sub deleteTeam(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Team = new SAE::TB_TEAM();
    $Team->deleteRecordById($PkTeamIdx);
    return();
}
sub saveTeamInfo(){
    print $q->header();
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    my %CLASS = %{$Class->getAllRecord()};
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $TxSchool = $q->param('TxSchool');
    my $TxName = $q->param('TxName');
    my $FkClassIdx = $q->param('FkClassIdx');
    my $InNumber = $q->param('InNumber');
    my $InTubeLength = $q->param('InTubeLength');
    my $InCapacity = $q->param('InCapacity');
    $Team->updateTxSchool_ById($TxSchool, $PkTeamIdx);
    $Team->updateTxName_ById($TxName, $PkTeamIdx);
    $Team->updateFkClassIdx_ById($FkClassIdx, $PkTeamIdx);
    $Team->updateInNumber_ById($InNumber, $PkTeamIdx);
    if ($FkClassIdx == 3) {
        $Team->updateInTubeLength_ById($InTubeLength, $PkTeamIdx);
    }
    if ($FkClassIdx == 1) {
        $Team->updateInCapacity_ById($InCapacity, $PkTeamIdx);
    }
    $DATA{TX_SCHOOL}=$TxSchool;
    $DATA{TX_NAME}=$TxName;
    $DATA{TX_CLASS}=$CLASS{$FkClassIdx}{TX_CLASS};
    $InNumber =~ s/^0+//sgi;
    $DATA{IN_NUMBER}=substr("000".$InNumber,-3,3);
    my $json = encode_json \%DATA;
    return ($json);
}
sub _templateTeamDetails(){
    my $fieldName = shift;
    my $fieldValue = shift;
    my $fieldId = shift;
    my $str;
    $str .= '<label class="w3-small">'.$fieldName.'</label>';
    $str .= '<input class="w3-input w3-text-blue" type="text" name="'.$fieldId.'" id="'.$fieldId.'" placeholder="'.$fieldName.'" value="'.$fieldValue.'"/>';

    return ($str);
}
sub showEditTeamInformation(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    %CLASS = %{$Class->getAllRecord()};
    my $str;
    $Team->getRecordById($PkTeamIdx);
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2>Team Information</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container">';
    $str .= &_templateTeamDetails('Team Number',substr("000".$Team->getInNumber(),-3,3),'IN_NUMBER');
    $str .= &_templateTeamDetails('School / University',$Team->getTxSchool(),'TX_SCHOOL');
    $str .= &_templateTeamDetails('Team Name',$Team->getTxName(),'TX_NAME');
#     $str .= '<div class="12u$">';
#     $str .= '<div class="select-wrapper">';
    $str .= '<label class="w3-small">Class</label>';
    $str .= '<select class="w3-input w3-text-blue" name="FK_CLASS_IDX" id="FK_CLASS_IDX">';
    foreach $PkClassIdx (sort keys %CLASS) {
        my $selected = '';
        if ($Team->getFkClassIdx() == $PkClassIdx){$selected = 'selected'}
        $str .= '<option value="'.$PkClassIdx.'" '.$selected.'>'.$CLASS{$PkClassIdx}{TX_CLASS}.'</option>';
    }
    $str .= '</select>';
#     $str .= '<div class="smallLabel">Class</div>';
    if ($Team->getFkClassIdx()==1) {
        $str .= &_templateTeamDetails('Max Seat Capacity' ,$Team->getInCapacity(),'IN_CAPACITY');
    }
    if ($Team->getFkClassIdx()==3) {
        $str .= &_templateTeamDetails('Tube Length' ,$Team->getInTubeLength(),'IN_TUBE_LENGTH');
    }
    $str .= '</form>';
    $str .= '<br>';
    $str .= '<div class="w3-bar w3-padding" style="text-align: center;">';
    $str .= '<a class="w3-button w3-border w3-center" class="button small special" onclick="saveTeamInfo('.$PkTeamIdx.');">Update</a><br><br>';
    $str .= '</div>';
    return ($str);
}
sub resetAccessCode(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $TxCode = $q->param('TxCode');
    my $Team = new SAE::TB_TEAM();
    $Team->updateTxCode_ById($TxCode, $PkTeamIdx);
    return ($TxCode);
}
sub showResetAccessCode(){
    print $q->header();
    my $Team = new SAE::TB_TEAM();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    $Team->getRecordById($PkTeamIdx);
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Team Access Code</h2>';
    $str .= '</div>';

#     $str .= '<h2>Team Access Code</h2>';
    $str .= '<form class="w3-container w3-center" >';
    $str .= '<p>Manually assign a team access code by typing a new code in the space provided<br>or<br>click <a href="javascript:void(0);" onclick="generateRandomTeamCode();">Generate Random Code</a></p>';
    $str .= '<p><input class="w3-input" type="text" style="text-align: center;" ID="TX_TEAM_CODE" placeholder="Team Access Code" value="'.$Team->getTxCode().'">';
    $str .= '<label><b>Access Code</label></b></p>';
    $str .= '<a class="w3-button w3-border w3-grey" onclick="resetAccessCode('.$PkTeamIdx.');">Update</a> ';

    $str .= '</form><br>';
    return ($str);
}
sub generateRandomTeamCode(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');

    my $str;
    my $Auth = new SAE::Auth();
    $str = $Auth->getTemporaryPassword(10);
    return ($str);
}
sub showTeamList(){
    print $q->header();
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};
    %CLASS = %{$Class->getAllRecord()};
    my $str;
    my $c=1;
    $str .= '<span class="w3-button w3-card w3-margin" onclick="loadSetupAndAdministration();">Back</span>';
    $str .= '<span class="w3-button w3-card w3-margin"  onclick="showAddTeam();">Add Team</span>';
    $str .= '<span class="w3-button w3-card w3-margin"  onclick="generateAllNewCode();">Generate New Codes</span>';
    $str .= '<ul ID="TeamList" class="w3-ul w3-card-4">';
    foreach $PkTeamIdx (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        $InNumber = substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
        $TxSchool = $TEAM{$PkTeamIdx}{TX_SCHOOL};
        $TxName = $TEAM{$PkTeamIdx}{TX_NAME};
        $str .= &_templateList($PkTeamIdx, $InNumber, $TxSchool, $TxName);
    }
    $str .= '</ul>';




#     $str .= '<div class="w3-row w3-border">';
#     foreach $PkTeamIdx (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
#     my $display = 'display: none;';
#         $classIDX = $TEAM{$PkTeamIdx}{FK_CLASS_IDX};
#         my $text;
#         $str .= '<div class="w3-container" style="padding: 7px; border-bottom: 1px solid #eeeeee;">';
#         $str .= '<div class="w3-col l2 " ><span class="w3-hide-large" >Team #: </span><span  ID="TD_IN_NUMBER_'.$PkTeamIdx .'">'.substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3).'</span>';
#         if ($classIDX == 1 && $TEAM{$PkTeamIdx}{IN_CAPACITY} == 0) {$display = 'display: inline;'; $text='Missing Vehicle\'s Max Capacity'}
# #         if ($classIDX == 3 && $TEAM{$PkTeamIdx}{IN_TUBE_LENGTH} == 0) {$display = 'display: inline;'; $text='Missing value for Tube Length'}
#         $str .= '<span class="w3-tooltip" ID="IMG_WARNING_'.$PkTeamIdx.'" style="'.$display.' position: relative; top: 0px; margin-left: 7px;"><img src="images/exclamation.ico" width="24" height="24"><span class="w3-text w3-tag w3-orange">'.$text.'</span></span>';
#         $str .= '</div>';
#         $str .= '<div class="w3-col l3 " ><span class="w3-hide-large" >School: </span><span ID="TD_TX_SCHOOL_'.$PkTeamIdx .'" >'.$TEAM{$PkTeamIdx}{TX_SCHOOL}.'</span></div>';
#         $str .= '<div class="w3-col l3 " ><span class="w3-hide-large" >Name: </span><span ID="TD_TX_NAME_'.$PkTeamIdx .'">'.$TEAM{$PkTeamIdx}{TX_NAME}.'</span></div>';
#         $str .= '<div class="w3-col l2 " ><span class="w3-hide-large" >Class: </span><span ID="TD_TX_CLASS_'.$PkTeamIdx .'">'.$CLASS{$classIDX}{TX_CLASS}.'</span></div>';
#         $str .= '<div class="w3-col l2 " >';
#         $str .= '<a class="w3-button w3-grey w3-round" style="width: 76px; padding: 2px; height: 2.0em;font-size: .8em !important" href="javascript:void(0);" onclick="showEditTeamInformation('.$PkTeamIdx.');">Edit</a> ';
#         $str .= '<a class="w3-button w3-red w3-round" style="width: 100px; padding: 2px; height: 2.0em;font-size: .8em !important"  href="javascript:void(0);" onclick="showResetAccessCode('.$PkTeamIdx.');">Access Code</a>';
#         $str .= '</div>';
#         $str .= '</div>'; # Container
#     }
#     $str .= '</div>';
    return ($str);
}

sub _templateList(){
    my ($PkTeamIdx, $InNumber, $TxSchool, $TxName) = @_;
    my $str;
    $str = '<li ID="LIST_TEAM_'.$PkTeamIdx.'" class="w3-bar">';
    $str .= '<span class="w3-bar-item w3-button w3-white w3-xlarge w3-right" onclick="deleteTeam('.$PkTeamIdx.')">&times;</span>';
#     $str .= '<span class="w3-bar-item w3-button w3-white w3-xxlarge w3-left fa fa-user-secret" onclick="showResetAccessCode('.$PkTeamIdx.')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-white w3-xxlarge w3-left fa fa-pencil-square-o" onclick="showEditTeamInformation('.$PkTeamIdx.');"></span>';
    $str .= '<img src="../images/users.png" class="w3-bar-item w3-circle w3-hide-small" style="width:85px" onclick="showEditTeamInformation('.$PkTeamIdx.');">';
    $str .= '<div class="w3-bar-item">';
    $str .= '<span class="w3-medium" ><a ID="SPAN_NUMBER_SCHOOL_'.$PkTeamIdx.'" href="javascript:void(0);" onclick="showEditTeamInformation('.$PkTeamIdx.');">#'.$InNumber.' - '.$TxSchool.'</a></span><br>';
#     $str .= '<span class="w3-small"ID="SPAN_NAME_'.$PkTeamIdx.'" >'.$TxName.'</span><br>';
    $str .= '<span class="fa fa-pencil-square-o" style="cursor: pointer;" onclick="showResetAccessCode('.$PkTeamIdx.')"> Team Code: ******</span>';
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}

