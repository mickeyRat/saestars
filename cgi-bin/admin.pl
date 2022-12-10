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
use Mail::Sendmail;
# use List::Util;
# use HTML::Entities;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::Auth;
use SAE::TB_USER_TEAM;
use SAE::TB_EVENT;
use SAE::TB_USER_EVENT;

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

    return ($str);
}
sub deleteUser(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $User = new SAE::TB_USER();
    $User->deleteRecordById($PkUserIdx);
    return();
}
sub getPasswordResetText(){
    my ($firstName, $email, $password) = @_;
    my $str;
    $str .= "Hi $firstName,<br><br>";
    $str .= "<p>The password for your SAE STARS account (<b>$email</b>) has been successfully reset.</p>";
    $str .= "<p>If you didn't make this change or if you believe an unauthorized person has accessed your account, please see and SAE Scoring Judge immediately.</p>";
#     $str .= "<p>Goto <a href='http://www.saestars.com'>http://www.saestars.com</a></p>";
#     $str .= "<p>You've requested your password to be reset for the account at <a href='http://www.saestars.com'>http://www.saestars.com</a></p>";
    $str .= "<p>Login Email: $email<br />";
    $str .= "Temporary Password: $password<br />";
    $str .= "</p>";
    $str .= "<a href='http://www.saestars.com'>http://www.saestars.com</a>";
    $str .= "<br><br>Best,<br><br>";
    $str .= "Aero Design Scoring Judge";
    return ($str);
}
sub submitPasswordReset(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $tempPassword = $q->param('tempPassword');
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();

    my $salt = $Auth->getTemporaryPassword(2);
    my $saltedPassword = $salt.crypt($tempPassword,$salt);
    $User->updateTxPassword_byId($saltedPassword, $PkUserIdx);
    $User->updateBoReset_byId(1, $PkUserIdx);
    $User->getRecordById($PkUserIdx);
    my $fullName = $User->getTxFirstName()." ".$User->getTxLastName();
    my $txLastName = $User->getTxFirstName();
    my $txEmail= $User->getTxEmail();
#     my $txEmail = 'thedongs@live.com';
    my $str;
    my $body = &getPasswordResetText($fullName, $txEmail, $tempPassword);
    my %mail = (   To      => $txEmail,
                    From    => 'donotreply@saestars.com',
                    'Content-Type' => 'text/html; charset=UTF-8',
                    Subject => 'Password Reset Request',
                    Message => $body
                );
    sendmail(%mail) or die $Mail::Sendmail::error;
    return ($body);
}
sub generateRandomPassword(){
    print $q->header();
    my $str;
    my $Auth = new SAE::Auth();
    $str = $Auth->getTemporaryPassword(10);
    return ($str);
}
sub showResetPassword(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $User = new SAE::TB_USER();
    $User->getRecordById($PkUserIdx);
    my $str;
#     $str .= '<div class=" ">';
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">Password Reset</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container w3-center w3-section">';
    $str .= '<p>Resetting Password for '.$User->getTxFirstName().' '.$User->getTxLastName().'.<br>New temporary password will be sent to <u>'.$User->getTxEmail().'</u></p>';
    $str .= '<p>Enter a temporary password in the space provide<br>or<br>click <a href="javascript:void(0);" onclick="generateRandomPassword();">Generate Random Password</a>.</p>';
    $str .= '<p><input class="w3-input" type="text" ID="TempPassword" style="text-align: center;" required placeholder="Temporary Password"></p>';
    $str .= '<a class="w3-button w3-border" onclick="submitPasswordReset('.$PkUserIdx.');">Submit</a>';
    $str .= '</form><br>';
#     $str .= '</div>';
    return ($str);
}

#===== User Accounts =================================================
sub submitResetAllJudgesPassword(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $tempPassword = $q->param('tempPassword');
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();
    my $salt = $Auth->getTemporaryPassword(2);
    my $saltedPassword = $salt.crypt($tempPassword,$salt);
    my $SQL = "UPDATE TB_USER SET TX_PASSWORD=?, BO_RESET=? WHERE IN_USER_TYPE=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($saltedPassword ,1 ,1);
    return ($update->rows());
}
sub resetAllJudgesPassword(){
    print $q->header();
#     my $PkUserIdx = $q->param('PkUserIdx');
    my $User = new SAE::TB_USER();
    $User->getRecordById($PkUserIdx);
    my $str;
#     $str .= '<div class=" ">';
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">Password Reset</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container w3-center w3-section">';
    $str .= '<p>Resetting Password for all Judges</p>';
    $str .= '<p>Enter a temporary password in the space provide<br>or<br>click <a href="javascript:void(0);" onclick="generateRandomPassword();">Generate Random Password</a>.</p>';
    $str .= '<p><input class="w3-border w3-card w3-padding" type="text" ID="TempPassword" style="text-align: center;" required placeholder="Temporary Password"></p>';
    $str .= '<a class="w3-button w3-border" onclick="submitResetAllJudgesPassword();">Submit</a>';
    $str .= '</form><br>';
#     $str .= '</div>';
    return ($str);
}
sub showUserAccountList(){
    print $q->header();
    my $userTypeNumber = $q->param('userTypeNumber');
    my $dbi = new SAE::Db();
    my $str;
    my $SQL = "SELECT * FROM TB_USER";
    my $select = $dbi->prepare($SQL);
    $select->execute();
    my %USERS = %{$select->fetchall_hashref(['PK_USER_IDX'])};

    $SQL = "SELECT TX_TYPE, IN_TYPE FROM TB_USER_TYPE";
    my $userType = $dbi->prepare($SQL);
    $userType->execute();
    while (my ($txType, $inType) = $userType->fetchrow_array()) {
        $TYPE{$inType} = $txType;
    }
    $SQL = "SELECT EVENT.PK_EVENT_IDX, EVENT.TX_EVENT_NAME, USER.PK_USER_IDX FROM TB_USER_EVENT AS UE
        JOIN TB_EVENT AS EVENT ON EVENT.PK_EVENT_IDX=UE.FK_EVENT_IDX
        JOIN TB_USER AS USER ON USER.PK_USER_IDX=UE.FK_USER_IDX
        WHERE USER.IN_USER_TYPE>0";
    $select = $dbi->prepare($SQL);
    $select->execute();
    while (my ($PkEventIdx, $TxEvent, $PkUserIdx) = $select->fetchrow_array()) {
        $EVENT{$PkEventIdx} = $TxEvent;
        push(@$PkUserIdx, 'SAE_'.$PkEventIdx);
    }
    $str = '<div class="w3-bar">';
        $str .= '<span class="w3-bar-item w3-button fa fa-angle-double-left" onclick="loadSetupAndAdministration();">&nbsp;Back</span>';
        $str .= '<div class="w3-dropdown-hover">';
            $str .= '<span class="w3-button fa fa-angle-double-down"> Filtered View</span>';
            $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
                $str .= '<span class="w3-bar-item w3-button" onclick="filterView(\'ALL\');">All Registered Users</span>';
                $str .= '<span class="w3-bar-item w3-button" onclick="filterView(\'Student\');">All Students</span>';
                $str .= '<span class="w3-bar-item w3-button" onclick="filterView(\'Judge\');">All Judges</span>';
                $str .= '<span class="w3-bar-item w3-button" onclick="filterView(\'Admin\');">All Admins</span>';
                $str .= '<hr>';
                foreach $PkEventIdx (sort {$EVENT{a} cmp $EVENT{b}} keys %EVENT) {
                    $str .= '<span class="w3-bar-item w3-button" onclick="filterView('.$PkEventIdx.');">Judges for '.$EVENT{$PkEventIdx}.'</span>';
                }
            $str .= '</div>';
        $str .= '</div>';
        if ($userTypeNumber==99){
            $str .= '<div class="w3-button" onclick="resetAllJudgesPassword();">Reset Judges Password</div>';
        }

    $str .= '</div>';

    $str .= '<ul ID="TeamList" class="w3-ul w3-card-4">';
    foreach $PkUserIdx (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS){
#         $str .= join(", ", @$PkUserIdx);
        $FullName = $USERS{$PkUserIdx}{TX_LAST_NAME}.", ".$USERS{$PkUserIdx}{TX_FIRST_NAME};
        $TxEmail = $USERS{$PkUserIdx}{TX_EMAIL};
        $Type = $TYPE{$USERS{$PkUserIdx}{IN_USER_TYPE}};
        $str .= &_templateUserItem($PkUserIdx, $FullName, $Type, $TxEmail, join(" ", @$PkUserIdx));
    }
    $str .= '</ul>';
    return ($str);
}
sub _templateUserItem(){
    my ($PkUserIdx, $FullName, $Type, $TxEmail, $List) = @_;
    my $str;
    $str = '<li ID="LIST_USER_'.$PkUserIdx.'" class="w3-bar SAE_'.$Type.' SAE_ALL '.$List.'">';
    $str .= '<span class="w3-bar-item w3-button w3-white w3-xlarge w3-right" onclick="deleteUser('.$PkUserIdx.')">&times;</span>';
    $str .= '<img ID="IMG_AVATAR_'.$PkUserIdx.'" src="../images/'.$Type.'.png" class="w3-bar-item w3-circle w3-hide-small" style="width:85px" onclick="showUserAccountInfo('.$PkUserIdx.');">';
    $str .= '<div class="w3-bar-item">';
    $str .= '<span class="w3-medium" ><a ID="SPAN_FULLNAME_'.$PkUserIdx.'" href="javascript:void(0);" onclick="showUserAccountInfo('.$PkUserIdx.');">'.$FullName.'</a></span><br>';
    $str .= '<span ID="SPAN_EMAIL_'.$PkUserIdx.'">'.$TxEmail.'</span>';
    $str .= '<span class="w3-button w3-small w3-padding" onclick="showResetPassword('.$pkUserIdx.');">Reset Password</span><br>';
#     $str .= $List;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub _templateUserDetails(){
    my $fieldName = shift;
    my $fieldValue = shift;
    my $fieldId = shift;
    my $str;
    $str .= '<p>';
    $str .= '<label>'.$fieldName.'</div>';
    $str .= '<input class="w3-input w3-text-blue" type="text" name="'.$fieldId.'" id="'.$fieldId.'" placeholder="'.$fieldName.'" value="'.$fieldValue.'"/>';
	$str .= '</p>';

    return ($str);
}
sub _templateRadio(){
    my ($label, $name, $fieldId, $value, $checked) = @_;
    my $str;
    $str .= '<span class="w3-padding">';
    $str .= '<input class="w3-radio" type="radio" id="'.$fieldId.'_'.$value.'" value="'.$value.'" name="UserType" '.$checked.'>';
    $str .= '<label>'.$label.'</label>';
    $str .= '</span>';
    return ($str);
}
sub showUserAccountInfo(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $User = new SAE::TB_USER();

    my $dbi = new SAE::Db();
    $User->getRecordById($PkUserIdx);
    my $SQL = "SELECT TB_MERGE.PK_USER_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL
        FROM TB_USER_TEAM AS TB_MERGE
            JOIN TB_USER AS USER ON TB_MERGE.FK_USER_IDX=USER.PK_USER_IDX
            JOIN TB_TEAM AS TEAM ON TB_MERGE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        WHERE TB_MERGE.FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    %HASH = %{$select->fetchall_hashref(['PK_USER_TEAM_IDX'])};
    $CHECK{$User->getInUserType()}='checked';
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">User Information</h2>';
    $str .= '</div>';

    $str .= '<form class="w3-container">';
    $str .= &_templateUserDetails('First Name',$User->getTxFirstName(), 'TX_FIRST_NAME');
    $str .= &_templateUserDetails('Last Name',$User->getTxLastName(), 'TX_LAST_NAME');
    $str .= &_templateUserDetails('Email Address',$User->getTxEmail(), 'TX_EMAIL');
    $str .= '<label><b>User Type:</b></label>';
    $str .= &_templateRadio('Student', 'UserType', 'IN_USER_TYPE', 0, $CHECK{0});
    $str .= &_templateRadio('Judge', 'UserType', 'IN_USER_TYPE', 1, $CHECK{1});
    $str .= &_templateRadio('Organizer', 'UserType', 'IN_USER_TYPE', 3, $CHECK{3});
    $str .= &_templateRadio('Admin', 'UserType', 'IN_USER_TYPE', 99, $CHECK{99});
    $str .= '<div class="w3-bar w3-text-center w3-padding">';
    $str .= '<a style="margin: .75em;" class="w3-button w3-white w3-card w3-border w3-round-large" href="javascript:void(0);" onclick="updateUserInfo('.$PkUserIdx.');">Update</a>';

    $str .= '</div>';
    $str .= '</form>';
    $str .= '</div><br>';

    $str .= '<div class="w3-container w3-section" >';

        if ($User->getInUserType() == 0) {
        $str .= '<div class="w3-container w3-blue">';
        $str .= '<h2 style="float: left;">Teams Linked to this User</h2>';
        $str .= '</div>';
            $str .= '<ul ID="USER_TEAM_LIST" class="w3-ul w3-card-4" style="margin: 1.25em;" >';
                foreach my $idx (sort keys %HASH) {
                    my $TeamNumber = substr("000".$HASH{$idx}{IN_NUMBER},-3,3);
                    my $TeamSchool = $HASH{$idx}{TX_SCHOOL};
                    $str .= &_templateListOfUserTeams($idx, $TeamNumber, $TeamSchool);
                }
            $str .= '</ul>';

            $str .= '<div class="w3-container w3-text-center w3-padding">';
                $str .= '<a style="margin: .75em;" class="w3-button w3-white w3-card w3-border w3-round-large" href="javascript:void(0);" onclick="showAddTeamToUser('.$PkUserIdx.');">Link a Team</a>';
            $str .= '</div>';
        }
        if ($User->getInUserType() == 1) {
            my $SQL = "SELECT UE.PK_USER_EVENT_IDX, UE.IN_LIMIT, EVENT.TX_EVENT_NAME FROM TB_USER_EVENT AS UE JOIN TB_EVENT AS EVENT ON UE.FK_EVENT_IDX=EVENT.PK_EVENT_IDX WHERE UE.FK_USER_IDX=?";
            my $select = $dbi->prepare($SQL);
            $select->execute($PkUserIdx);
            %UE = %{$select->fetchall_hashref(['PK_USER_EVENT_IDX'])};

            $str .= '<div class="w3-container w3-blue">';
            $str .= '<h2 style="float: left;">Participating Event</h2>';
            $str .= '</div>';


            $str .= '<ul ID="JUDGE_EVENT_PARTICIPATION"  class="w3-ul w3-card">';
                foreach $ueIDX (sort keys %UE) {
                     $str .= &_templateUserEventList($ueIDX, $UE{$ueIDX}{TX_EVENT_NAME}, $UE{$ueIDX}{IN_LIMIT});
                }
            $str .= '</ul>';

            $str .= '<div class="w3-container w3-text-center w3-padding">';
                $str .= '<a class="w3-button w3-border w3-card w3-round-large" href="javascript:void(0);" onclick="addEventToAJudge('.$PkUserIdx.');">Add Event</a>';
            $str .= '</div><br><br>';
        }
    $str .= '</div>';
    return ($str);
}
sub removeTeamFromUser(){
    print $q->header();
    my $PkUserTeamIdx = $q->param('PkUserTeamIdx');
    my $UserTeam = new SAE::TB_USER_TEAM();
    $UserTeam->deleteRecordById($PkUserTeamIdx);
    return ();
}
sub showAddTeamToUser(){
    print $q->header();
    my $location = $q->param('location');
    my $PkUserIdx = $q->param('PkUserIdx');
    my $Team = new SAE::TB_TEAM();
    my %TEAM = %{$Team->getAllRecordBy_FkEventIdx( $location )};
    my $UserTeam = new SAE::TB_USER_TEAM();
    %USERTEAM = %{$UserTeam->getAllRecordBy_FkUserIdx($PkUserIdx)};
    foreach my $idx (sort keys %USERTEAM) {
#     print $USERTEAM{$idx}{FK_TEAM_IDX}.br;
        $SEEN{$USERTEAM{$idx}{FK_TEAM_IDX}}=1;
    }

    my $str;
#     $str .= scalar(keys  %USERTEAM );
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id02\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h3 style="float: left;">Teams</h3>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-border-large w3-padding" style="height: 450px; overflow-y: scroll;">';
    $str .= '<ul class="w3-ul w3-card-4">';
    foreach $PkTeamIdx (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        if (exists $SEEN{$PkTeamIdx}){next}
        my $TeamNumber = substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
        my $TeamSchool = $TEAM{$PkTeamIdx}{TX_SCHOOL};
        $str .= '<li ID="LI_AVAILABLE_TEAM_'.$PkTeamIdx.'" class="w3-bar">';
        $str .= '<span onclick="addSelectedTeamToUser('.$PkTeamIdx.','.$PkUserIdx.')" class="w3-bar-item w3-button w3-border w3-white w3-xlarge w3-left">+</span>';
        $str .= '<div class="w3-bar-item">';
        $str .= '<span class="w3-large"><b>Team #: '.$TeamNumber.'</b></span><br>';
        $str .= '<span>School: '.$TeamSchool.'</span>';
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div><br>';



    return ($str);
}
sub _templateListOfUserTeams(){
    my ($idx, $teamNumber, $teamSchool) = @_;
    my $str;
    $str = '<li ID="USER_TEAM_'.$idx.'" class="w3-bar">';
    $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-remove" onclick="removeTeamFromUser('.$idx.')" ></span>';
    $str .= '<div class="w3-bar-item">';
    $str .= '<span class="w3-large"><b>#: '.$teamNumber.'</b></span><br>';
    $str .= '<span>School: '.$teamSchool.'</span>';
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub addSelectedTeamToUser(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Team = new SAE::TB_TEAM();

    my $PkUserIdx = $q->param('PkUserIdx');
    my $PkTeamIdx = $q->param('PkTeamIdx');

    $Team->getRecordById($PkTeamIdx);
    my $SQL = "INSERT INTO TB_USER_TEAM (FK_USER_IDX, FK_TEAM_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkUserIdx, $PkTeamIdx);
    my $newIDX = $insert->{q{mysql_insertid}};
    my $str;
    my $TeamNumber = substr("000".$Team->getInNumber(),-3,3);
    my $TeamSchool = $Team->getTxSchool();
    $str = &_templateListOfUserTeams($newIDX, $TeamNumber, $TeamSchool);
    return ($str);
}
sub updateUserInfo(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $TxFirstName = $q->param('TxFirstName');
    my $TxLastName = $q->param('TxLastName');
    my $TxEmail = $q->param('TxEmail');
    my $InUserType = $q->param('InUserType');
    my $User = new SAE::TB_USER();
    $User->updateTxFirstName_ById($TxFirstName, $PkUserIdx);
    $User->updateTxLastName_ById($TxLastName, $PkUserIdx);
    $User->updateTxEmail_ById($TxEmail, $PkUserIdx);
    $User->updateInUserType_ById($InUserType, $PkUserIdx);
        $SQL = "SELECT TX_TYPE, IN_TYPE FROM TB_USER_TYPE";
    my $userType = $dbi->prepare($SQL);
    $userType->execute();
    while (my ($txType, $inType) = $userType->fetchrow_array()) {
        $TYPE{$inType} = $txType;
    }
    $DATA{TX_FULLNAME}= "$TxLastName, $TxFirstName";
    $DATA{TX_FIRST_NAME}=$TxFirstName;
    $DATA{TX_LAST_NAME}=$TxLastName;
    $DATA{TX_EMAIL}=$TxEmail;
    $DATA{TX_USER_TYPE}=$TYPE{$InUserType};
    my $json = encode_json \%DATA;
    return ($json);
}
sub addEventToAJudge(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $Event = new SAE::TB_EVENT();
    my %EVENT = %{$Event->getAllRecord()};
    my $dbi = new SAE::Db();
    my $SQL = "SELECT * FROM TB_USER_EVENT WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    %SEEN = %{$select->fetchall_hashref(['FK_EVENT_IDX'])};
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id02\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Available Events</h2>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
#     $str .= '<h2>Event Participation</h2>';
    $str .= '<p><label>Add Event </label>';
    $str .= '<ul class="w3-ul w3-card-4">';
    foreach $FkEventIdx (sort keys %EVENT){
        $str .= '<li class="w3-bar">';
        if (!exists $SEEN{$FkEventIdx}){
            $str .= '<span onclick="addEventLimitToJudge('.$PkUserIdx.', '.$FkEventIdx.',\''.$EVENT{$FkEventIdx}{TX_EVENT_NAME}.'\')" class="w3-bar-item w3-button w3-border w3-xlarge w3-left CTRL_'.$FkEventIdx.'">+</span>';
            $str .= '<div class="w3-bar-item">';
            $str .= '<label class="CTRL_'.$FkEventIdx.'">Paper Limit</label><input class="w3-center CTRL_'.$FkEventIdx.'" style="width: 50px; border: none; border-bottom: 1px solid #cccccc;" ID="IN_LIMIT_'.$FkEventIdx.'" type="input" placeholder="Limit" value="3">';
            $str .= '<span ID="LBL_'.$FkEventIdx.'" class="w3-large w3-margin-left">'.$EVENT{$FkEventIdx}{TX_EVENT_NAME}.'</span>';
            $str .= '</div>';
        } else {
            $str .= '<div class="w3-bar-item">';
            $str .= '<span class="w3-large w3-margin-left">Already participating in '.$EVENT{$FkEventIdx}{TX_EVENT_NAME}.'</span>';
            $str .= '</div>';
        }

        $str .= '</lu>';
    }
    $str .= '</ul><br><br>';
    # $str .= '<select class="w3-select" ID="PK_EVENT_IDX">';
#     $str .= '<option value="0">- Select an Event -</option>';
#     foreach $FkEventIdx (sort keys %EVENT){
#         $str .= '<option value="'.$FkEventIdx.'">'.$EVENT{$FkEventIdx}{TX_EVENT_NAME}.'</option>';
#     }
#     $str .= '</select></p>';
#     $str .= '<p><label>Number of Paper(s) willing to review</label>';
#     $str .= '<input class="w3-input" type="number" MAX="300" MIN="0" ID="IN_LIMIT" placeholder="Number of Papers to grade for selected event"></p>';
#     $str .= '</div>';
#     $str .= '<div class="w3-container w3-text-center">';
#     $str .= '<span class="w3-button w3-card w3-border"  onclick="addEventLimitToJudge('.$PkUserIdx.', 0);">Save & Exit</span> ';
#     $str .= '<span class="w3-button w3-card w3-border"  onclick="addEventLimitToJudge('.$PkUserIdx.', 1);">Save & Add Another</span> ';
#     $str .= '</div><br><br>';
#     $str .= '<a href="javascript:void(0);" onclick="addEventLimitToJudge2('.$PkUserIdx.')">Add</a>';

    return ($str);
}
sub addEventLimitToJudge(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $InLimit = $q->param('InLimit');
    my $PkEventIdx = $q->param('PkEventIdx');
    my $TxEventName = $q->param('TxEventName');
    my $Limit = new SAE::TB_USER_EVENT();
    my $SQL = "INSERT INTO TB_USER_EVENT (FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT ) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkUserIdx, $PkEventIdx, $InLimit);
    my $newIDX = $insert->{q{mysql_insertid}};
    my $str;
    $str .= &_templateUserEventList($newIDX, $TxEventName, $InLimit);
    return ($str);
}
sub _templateUserEventList(){
    my ($idx, $label, $limit) = @_;
    my $str;
    $str .= '<li ID="EVENT_LIST_'.$idx.'" class="w3-bar">';
    $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-remove" href="javascript:void(0);" onclick="deleteUserEventItem('.$idx.');"></span>';
    $str .= '<div class="w3-bar-item">';
    $str .= '<span>Event: '.$label.'</span><br>';
    $str .= '<span>Paper Limit: '.$limit.'</span>';
    $str .= '</div>';
    $str .= '</li>';

    return ($str);
}
sub deleteUserEventItem(){
    print $q->header();
    my $PkUserEventIdx = $q->param('PkUserEventIdx');
    my $Limit = new SAE::TB_USER_EVENT();
    $Limit->deleteRecordById($PkUserEventIdx );
    my $str;

    return ($str);
}

# ================ TRANSACTION FEEDS =====================================
sub loadNextSet(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $loc = $q->param('location');
    my $start = $q->param('start');
    my $set = $q->param('end');
    my $SQL = "SELECT FEED.*, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_FEED AS FEED JOIN TB_TEAM AS TEAM ON FEED.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=?
        ORDER BY FEED.PK_FEED_IDX  DESC LIMIT ?,?";
    my $select = $dbi->prepare($SQL);
    $select->execute($loc, $start, $set);
    %FEED = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
    my $str;
    foreach $feedIDX (sort {$b <=> $a} keys %FEED){
        my $title = $FEED{$feedIDX}{TX_TITLE};
        my $txSchool = '#'.substr("000".$FEED{$feedIDX}{IN_NUMBER},-3,3).' - '.$FEED{$feedIDX}{TX_SCHOOL};
        my $feed = $FEED{$feedIDX}{TX_FEED};
        my $tsCreate = $FEED{$feedIDX}{TS_CREATE};
        $str .= &_templateFeed($feedIDX, $title, $txSchool, $feed, $tsCreate);
    }
    $str .= '<div ID="loadNextButton" class="w3-container w3-padding w3-light-grey" style="text-align: center;"><button class="w3-button w3-border w3-card" onclick="loadNextSet('.($start + $set).','.$set.');">Load Next '.$set.' Transaction Feeds</button></div>';
    return ($str);
}
sub transactionFeed(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $set = 25;
    my $loc = $q->param('location');
    my $SQL = "SELECT FEED.*, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_FEED AS FEED JOIN TB_TEAM AS TEAM ON FEED.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=?
        ORDER BY FEED.PK_FEED_IDX  DESC LIMIT ?,?";
    my $select = $dbi->prepare($SQL);
    $select->execute($loc, 0, $set);
    %FEED = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadMainPage();">&nbsp;Back</a>';
    $str .= '<a class="fa fa-refresh  w3-button" href="javascript:void(0);" onclick="transactionFeed();">&nbsp;Refesh</a>';
    $str .= '</div>';
    $str .= '<div ID="feedContent">';
    foreach $feedIDX (sort {$b <=> $a} keys %FEED){
        my $title = $FEED{$feedIDX}{TX_TITLE};
        my $txSchool = '#'.substr("000".$FEED{$feedIDX}{IN_NUMBER},-3,3).' - '.$FEED{$feedIDX}{TX_SCHOOL};
        my $feed = $FEED{$feedIDX}{TX_FEED};
        my $tsCreate = $FEED{$feedIDX}{TS_CREATE};
        $str .= &_templateFeed($feedIDX, $title, $txSchool, $feed, $tsCreate);
    }
    $str .= '<div ID="loadNextButton" class="w3-container w3-padding w3-light-grey" style="text-align: center;"><button class="w3-button w3-border w3-card" onclick="loadNextSet('.$set.','.$set.');">Load Next '.$set.' Transaction Feeds</button></div>';
    $str .= '</div><br><br><br>';

    return ($str);
}
sub _templateFeed(){
    my $feedIDX = shift;
    my $textTitle = shift;
    my $txSchool = shift;
    my $textFeed = shift;
    my $tsCreate = shift;
    my $str;
    $str .= '<div class="w3-container w3-card w3-white w3-round w3-margin">';
    $str .= '<header class="w3-container">';
    $str .= '<h3 style="margin-bottom: 0px; padding-bottom: 0px;">'.$textTitle.'</h3>';
    $str .= '<h4 style="margin-bottom: 0px; padding-bottom: 0px;">'.$txSchool.'</h4>';
    $str .= '<span class="w3-small">'.$tsCreate.'</span>';
    $str .= '</header>';
    $str .= '<div class="w3-container">';
    $str .= '<p>'.$textFeed.'</p>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}


# ================ PRESO REPORT RILES  ===================================
sub loadPresentationScoring(){ # Loading functions from team.js
    print $q->header();
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadMainPage();">&nbsp;Back</a>';
    $str .= '</div>';
    $str .= &_tiles('Input Presentation Scores',    'fa fa-database',       'showListOfTeam_Preso();' ); # call in preso.js
    $str .= &_tiles('Results',                      'fa fa-bar-chart',      'showResultsOfPreso();' );
    return ($str);
}


# ================ DESIGN REPORT TILES ===================================
sub loadDesignReportManagement(){ # Loading functions from team.js
    print $q->header();
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadMainPage();">&nbsp;Back</a>';
    $str .= '</div>';
    $str .= &_tiles('Upload Design Reports',        'fa fa-upload',         'showTeamFileList();' );
    $str .= &_tiles('Distribute By Team',           'fa fa-group',          'showDistributeByTeam();' );
    $str .= &_tiles('Distribute By Judge',          'fa fa-gavel',          'showDistributeByJudge();' );
    return ($str);
}
# ================ MAIN STARTUP PAGE ===================================
sub loadMainPage(){ #Loading functions from admin.js
    print $q->header();
    my $str;
    $str .= &_tiles('Setup &amp; Administration',   'fa fa-gears',          'loadSetupAndAdministration();' );
    $str .= &_tiles('Design Report Distribution',   'fa fa-leanpub',        'loadDesignReportManagement();' );
#     $str .= &_tiles('Presentations Scoring',        'fa fa-desktop',        'loadPresentationScoring();' );
    $str .= &_tiles('Presentations Scoring',        'fa fa-desktop',        'showListOfTeam_Preso();' ); #preso.js
    $str .= &_tiles('Tech-Inspections',             'fa fa-search',         'showTechInspectionMain();' );
    $str .= &_tiles('Demonstrations',               'fa fa-play-circle-o',  'showDemoMain();' );
    $str .= &_tiles('Flight Scoring',               'fa fa-plane',          'showFlightMain();' );

    $str .= &_tiles('Results',                      'fa fa-trophy',         'showResultsMain();' );
    $str .= &_tiles('Transaction Feeds',            'fa fa-rss-square',     'transactionFeed();' );

    $str .= &_tiles('Sign Out',                     'fa fa-sign-out',       'signOutAdmin();' );
    return ($str);
}
sub loadSetupAndAdministration() { #Loading functions from admin.js
    print $q->header();
    my $str;
    $str .= '<div class="w3-container ">';
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadMainPage();">&nbsp;Back</a>';
    $str .= '</div>';
    $str .= &_tiles('User Account Setup',           'fa fa-user',           'showUserAccountList();' );
    $str .= &_tiles('Team Setup',                   'fa fa-group',          'showTeamList();' );
    $str .= &_tiles('Manage Event',                 'fa fa-flag-checkered', 'showEventList();' );
    $str .= &_tiles('Manage Assessment Questions',  'fa fa-clipboard',      'showAssessmentEvent();' );
#     $str .= &_tiles('Home',                         'fa fa-home',           'loadMainPage();' );
    return ($str);
}
sub _tiles(){
    my ($label, $image, $click) = @_;
    my $str;
    $str .= '<div class="w3-third w3-center">';
    $str .= '<div class="w3-card w3-container" style="min-height:260px; margin-top: 1.0em;">';
    $str .= '<h3>'.$label.'</h3><br>';
    $str .= '<a onclick="'.$click.'" href="javascript:void(0);" class="'.$image.' w3-margin-bottom w3-text-theme" style="font-size:110px; text-decoration: none;"></a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
