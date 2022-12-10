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
# use SAE::Common;
use SAE::Auth;
use SAE::AUTO;
use SAE::REPORTS;
use SAE::REFERENCE;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::WEATHER;
use SAE::CARD;

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
# ***********************************************************************************************************************************
#  BATCH PASSWORD CHANGE
# ***********************************************************************************************************************************
sub sae_loadListOfJudges(){
    print $q->header(); 
    my $Ref = new SAE::REFERENCE();
    %USERS = %{$Ref->_getListofJudges(1)};
    my $str;
    $str .= sprintf '<a class="w3-button w3-border w3-round-large w3-pale-green w3-margin-bottom" href="javascript:void(0);" onclick="sae_batchChangePassword(\'%s\');">Batch Password Change</a>', 'inputBinary';
    $str .= '<table class="w3-table-all  w3-hoverable">';
    $str .= '<tr class="w3-blue-grey">';
    $str .= '<th style="width: 65px;"><input type="checkbox" class="w3-check" onclick="toggleSelection(\'inputBinary\', this);"></th>';
    # $str .= '<th style="width: 50px;">Judge ID</th>';
    $str .= '<th>Name</th>';
    $str .= '<th>Email</th>';
    $str .= '<th>Password</button></th>';
    $str .= '</tr>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})}keys %USERS) {
        if ($USERS{$userIDX}{IN_USER_TYPE}>1){next}
        my $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        $str .= '<tr>';
        $str .= sprintf '<td><input type="checkbox" class="inputBinary w3-check" value="'.$userIDX.'"></td>';
        # $str .= sprintf '<td>%05d</td>', $userIDX;
        $str .= sprintf '<td>%1s</td>', $userName;
        $str .= sprintf '<td>%1s</td>', $USERS{$userIDX}{TX_EMAIL};
        $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_resetUserPassword(%1d,\'%s\');">Change Password</a></td>',$userIDX, $userName;
        $str .= '</tr>';
        
    }
    $str .= '</table>';
    
    return ($str);
}
sub sae_resetPasswordBatch(){
    print $q->header();
    my %USERS = %{decode_json($q->param('jsonData'))};
    my $newPassword = $q->param('newPassword');
    my $Auth = new SAE::Auth();
    # my $User = new SAE::TB_USER();
    my $str;
    foreach $userIDX (sort {$a<=>$b} keys %USERS) {
        my $salt = $Auth->getTemporaryPassword(2);
        my $saltedPassword = $salt.crypt($newPassword,$salt);
        $Auth->_updatePassword($saltedPassword, 1, $userIDX);
        # $str .= "$userIDX = $saltedPassword\n";
    }
    return ($str);
}
# ***********************************************************************************************************************************
#  MANAGE USERS
# ***********************************************************************************************************************************
sub sae_updateUserAttributes(){
    print $q->header(); 
    my $userIDX = $q->param('userIDX');
    my $field = $q->param('field');
    my $val = $q->param('val');
    my $Ref = new SAE::REFERENCE();
    $Ref->_updateUserAttribute($userIDX, $field, $val); 
    return
    
}
sub sae_addClassPreference(){
      print $q->header();
    my $userIDX = $q->param('userIDX');
    my $classIDX = $q->param('classIDX');
    my $Ref = new SAE::REFERENCE();
    $Ref->_addClassPreference($userIDX, $classIDX); 
    return
}
sub sae_removeClassPreference(){
      print $q->header();
    my $userIDX = $q->param('userIDX');
    my $classIDX = $q->param('classIDX');
    my $Ref = new SAE::REFERENCE();
    $Ref->_removeClassPreference($userIDX, $classIDX); 
    return
}
sub sae_addEventPreference(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $eventIDX = $q->param('eventIDX');
    my $Ref = new SAE::REFERENCE();
    $Ref->_addEventPreference($userIDX, $eventIDX);
    return
}
sub sae_removeEventPreference(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $eventIDX = $q->param('eventIDX');
    my $Ref = new SAE::REFERENCE();
    $Ref->_removeEventPreference($userIDX, $eventIDX);
    return
}
sub openManageJudges(){
    print $q->header(); 
    my $Ref = new SAE::REFERENCE();
    %USERS = %{$Ref->_getListofJudges()};
    %EVENTS = %{$Ref->_getEventList()};
    %EVPREF = %{$Ref->_getEventPreference()};
    %CLPREF = %{$Ref->_getClassPreference()};
    %CLASS = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    my $str;
    $str = '<br>';
    $str .= '<div class="w3-container w3-margin w3-display-container w3-margin-top">';
    $str .= '<h3><i class="fa fa-gavel fa-fw"></i> Judge Preferences</h3>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-small w3-hoverable w3-border w3-card-2">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 200px;">Judges</th>';
    $str .= '<th>e-Mail</th>';
    foreach $eventIDX (sort keys %EVENTS) {
        $str .= sprintf '<th style="width: 80px;">%s<br>%s<br><input  ID="forSelectAll" type="checkbox" onclick="sae_selectCurrentEvent(this,'.$eventIDX.');"></th>', $EVENTS{$eventIDX}{IN_YEAR}, $EVENTS{$eventIDX}{TX_EVENT};
    }
    # $str .= '<input  ID="forSelectAll" type="checkbox" class="w3-check" onclick="toggleSelection(\'inputBinary\', this);">&nbsp; <label for="forSelectAll" class="w3-small">Select All</label>';
    $str .= '<th>Since</th>';
    $str .= '<th>Years of<br>Service</th>';
    $str .= '<th>Willing to <br>Assess Extra</th>';
    for ($i=1; $i<=3; $i++){
        $str .= sprintf '<th style="width: 80px;">%s<br>Class<br><input  ID="forSelectAll" type="checkbox" onclick="sae_selectCurrentClass(this,'.$i.');"></th>', $CLASS{$i};
    }
    $str .= '<th>Volunteer<br>Alumni</th>';
    $str .= '<th>Student<br>Alumni</th>';
    $str .= '</tr>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})}keys %USERS) {
        my $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td class="w3-medium">%s</td>', $userName;
        $str .= sprintf '<td>%s</td>', $USERS{$userIDX}{TX_EMAIL};
        foreach $eventIDX (sort keys %EVENTS) {
            my $checked = '';
            if (exists $EVPREF{$userIDX}{$eventIDX}){$checked = 'checked'}
            $str .= sprintf '<td><input class="event_'.$eventIDX.' w3-check" type="checkbox" data-access="'.$checked.'" value="'.$userIDX.'" onclick="sae_updateEventPreference(this, %1d, %1d);" %s></td>', $userIDX, $eventIDX, $checked;
        }
        $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_askYearStarted(this, %1d, \'%s\', \'%s\');">%s</a></td>', $userIDX, $USERS{$userIDX}{TX_YEAR}, 'TX_YEAR', $USERS{$userIDX}{TX_YEAR};
        $str .= sprintf '<td class="TD_USER_'.$userIDX.'" ID="TD_USER_'.$userIDX.'">%s</td>',  $year - $USERS{$userIDX}{TX_YEAR};
        my $eChecked = '';
        if ($USERS{$userIDX}{BO_EXTRA} == 1) {$eChecked = 'checked'}  
        $str .= sprintf '<td class="w3-border"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>Extra</span></td>', $userIDX, 'BO_EXTRA', $eChecked;
        for ($i=1; $i<=3; $i++){
            my $checked = '';
            if (exists $CLPREF{$userIDX}{$i}){$checked = 'checked'}
            $str .= sprintf '<td style="text-align: cetner;"><input class="pref_class_'.$i.' w3-check" data-access="'.$checked.'" type="checkbox" value="'.$userIDX.'" onclick="sae_updateClassPreference(this, %1d, %1d);" %s> %s</td>', $userIDX, $i, $checked, substr($CLASS{$i},0,1);
        }
        my $vChecked = '';
        my $sChecked = '';
        if ($USERS{$userIDX}{BO_VOL_ALUM} == 1) {$vChecked = 'checked'}    
        if ($USERS{$userIDX}{BO_STU_ALUM} == 1) {$sChecked = 'checked'}    
        $str .= sprintf '<td class="w3-border"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>V-Alum</span></td>', $userIDX, 'BO_VOL_ALUM', $vChecked;
        $str .= sprintf '<td class="w3-border"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>S-Alum</span></td>', $userIDX, 'BO_STU_ALUM', $sChecked;
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td class="w3-container">';
        $str .= sprintf '<header class="w3-large w3-blue-grey w3-padding"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><span>%s</span></header><br>', $userName;
        $str .= sprintf '<b>Email: </b><span>%s</span><br>', $USERS{$userIDX}{TX_EMAIL};
        $str .= sprintf '<b>Years Started: </b><span>%s</span><br>', $USERS{$userIDX}{TX_YEAR};
        $str .= sprintf '<b>Years of Service: </b><span class="TD_USER_'.$userIDX.'">%s</span><br>',  $year - $USERS{$userIDX}{TX_YEAR};
        $str .= sprintf '<br><b>Event Preference: </b><br>';
        
        foreach $eventIDX (sort keys %EVENTS) {
            my $checked = '';
            if (exists $EVPREF{$userIDX}{$eventIDX}){$checked = 'checked'}
            $str .= sprintf '<input class="eventSmall_'.$eventIDX.' w3-check w3-margin-left" type="checkbox" onclick="sae_updateEventPreference(this, %1d, %1d);" %s> &nbsp;%s %s',  $userIDX, $eventIDX, $checked,  $EVENTS{$eventIDX}{IN_YEAR}, $EVENTS{$eventIDX}{TX_EVENT};
        }
        $str .= sprintf '<br><br><b>Extra Preference: </b><br>';
        $str .= sprintf '<input class="w3-check w3-margin-left" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');"> <span>Yes, willing to take on Extra Assessments</span><br>', $userIDX, 'BO_EXTRA';
        $str .= sprintf '<br><b>Class Preference: </b><br>';
        for ($i=1; $i<=3; $i++){
            my $checked = '';
            if (exists $CLPREF{$userIDX}{$i}){$checked = 'checked'}
            $str .= sprintf '<input class="classSmall_'.$i.' w3-check w3-margin-left" type="checkbox" onclick="sae_updateClassPreference(this, %1d, %1d);" %s> %s', $userIDX, $i, $checked, $CLASS{$i};
        }
        $str .= sprintf '<br><br><b>Alumni Status: </b><br>';
        $str .= sprintf '<input class="w3-check w3-margin-left" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>Volunteer</span>', $userIDX, 'BO_VOL_ALUM', $vChecked;
        $str .= sprintf '<input class="w3-check w3-margin-left" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>Student</span>', $userIDX, 'BO_STU_ALUM', $sChecked;
        $str .= '</td>';
        $str .= '</tr>';    
        
    
    }
    $str .= '</table>';
    
    return ($str);
}
# ***********************************************************************************************************************************
#  MANAGE USERS
# ***********************************************************************************************************************************
sub sae_addTeamToUser(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $userIDX = $q->param('userIDX');
    my $teamIDX = $q->param('teamIDX');
    my $teamName = $q->param('teamName');
    my $location = $q->param('location');
    my $userTeamIDX = $Auth->_addTeamToUser($userIDX, $teamIDX);
    my $str = &_tempListOfUserTeams($teamName, $userTeamIDX);
}
sub _tempListOfUserTeams(){
    my $str;
    my $name = shift;
    my $userTeamIDX = shift;
    $str = '<li class="w3-bar w3-display-container">';
    # $str .= '<span onclick="sae_removeUserTeam(this, '.$userTeamIDX.');" class="w3-small w3-button w3-display-right w3-padding-small">X</span>';
    $str .= '<i onclick="sae_removeUserTeam(this, '.$userTeamIDX.');" class="w3-bar-item fa fa-trash-o w3-right w3-button"></i>';
    $str .= '<span style="margin-left: 10px">'.$name.'</span>';
    $str .= '</li>';
    return ($str);
}
sub sae_getListOfTeams(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    %TEAMS = %{$Ref->_getListOfTeamsByEventId($location)};
    %ASSIGNED = %{$Ref->_getUserTeamList($userIDX,$location )};
    # %ASSIGNED %{$Ref->_getTeamSubscriptionByID($userIDX, $location)};
    my $str = '<div class="w3-container" style="height: 600px; overflow: scroll">';
    $str .= '<ul class="w3-ul">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        if (exists $ASSIGNED{$teamIDX}){next}
        $inNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3);
        my $name = $inNumber." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= &_tempListOfTeams($name, $teamIDX, $userIDX);
    }
    $str .= '</ul>';
    $str .= '</div>';

    return($str);
}
sub _tempListOfTeams(){
    my $str;
    my $name = shift;
    my $teamIDX = shift;
    my $userIDX = shift;
    $str = '<li class="w3-display-container">';
    $str .= '<span onclick="sae_subscribeToATeam(this, '.$teamIDX.',\''.$name.'\','.$userIDX.');" class="w3-small w3-button w3-display-left w3-padding-small">+</span>';
    $str .= '<span style="margin-left: 10px">'.$name.'</span>';
    $str .= '</li>';
    return ($str);
}
sub sae_resetPasswordSubmit(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $password = $q->param('password');
    my $Auth = new SAE::Auth();
    my $salt = $Auth->getTemporaryPassword(2);
    my $saltedPassword = $salt.crypt($password,$salt);
    $Auth->_updatePassword($saltedPassword, 1, $userIDX);
    return ($saltedPassword);
}
sub sae_resetPassword(){ #Resetting password from the Admin Screen
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');  
    my $divName = $q->param('divName');  
    my $str = '<div class="w3-container w3-padding w3-margin">';
    $str .= '<form class="w3-form w3-white" method="POST" action="javascript:sae_resetPasswordSubmit('.$userIDX.',\''.$divName.'\');">';
    $str .= '<label>New Password:</label>';
    $str .= '<input type="password" id="sae_resetPasswordType" class="w3-input w3-border w3-text-blue">';
    $str .= '<input type="checkbox" onchange="sae_changeInputType(this,\'sae_resetPasswordType\');"> <label class="w3-small">show password</label><br><br>';
    $str .= '<input class="w3-button w3-card-2 w3-border w3-round" type="submit" value="Submit">';
    $str .= '</form>';
    $str .= '</div>';
    return ($str);
}
sub sae_deleteUser(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $User = new SAE::TB_USER();
    $User->deleteRecordById($userIDX);
}
sub sae_updateUserLevel(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');
    my $inLevel = $q->param('inLevel');
    my $str = $Ref->_updateUserLevelById($userIDX, $inLevel);
    return ($str);
}
sub sae_removeUserAccess(){
    print $q->header();
    my $tilesIDX = $q->param('tilesIDX');
    my $userIDX = $q->param('userIDX');
    my $Auth = new SAE::Auth();
    $Auth->_deleteUserAccess($tilesIDX, $userIDX);
}
sub sae_grantUserAccess(){
    print $q->header();
    my $tilesIDX = $q->param('tilesIDX');
    my $userIDX = $q->param('userIDX');
    my $Auth = new SAE::Auth();
    $Auth->_addUserAccess($tilesIDX, $userIDX);
}
sub _templateUserCard(){
    my $str;
    my $userIDX = shift;
    my $txFirst = shift;
    my $txLast = shift;
    my $txLogin = shift;
    my $txEmail = shift;
    my $username = "$txLast, $txFirst";
    $str = '<div ID="saeUserCardInfo" class="sae_userloaded w3-card-2 w3-white w3-margin w3-round">';
    $str .= '<header class="w3-container w3-blue-grey">';
    $str .= sprintf '<h3>%s</h3>', $username;
    $str .= '</header>';
    $str .= '<div class="w3-container">';
    $str .= '<img src="images/Student.png" alt="Avatar" class="w3-left w3-circle w3-margin-right w3-margin-top" style="width:90px">';
    $str .= sprintf '<p class="w3-margin-top">Email: <a href="mailto:%s">%s</a></p>',$txEmail, $txEmail;
    $str .= sprintf '<p >Login: %s</p>',$txLogin;
    $str .= sprintf '<p>User ID: %d</p>', $userIDX;
    $str .= sprintf '<p>Password: ***** ( <a href="javascript:void(0);"  onclick="sae_resetUserPassword('.$userIDX.',\''.$userName.'\');">Change Password</a>)</p>';
    $str .= '</div>';
    $str .= '<br><br>';
    $str .= '<button class="w3-button w3-card-2 w3-round-large w3-border w3-margin-left w3-green" style="width: 100px;" onclick="sae_editUserInfo('.$userIDX.');">Edit</button>&nbsp;&nbsp;&nbsp;';
    $str .= '<button class="w3-button w3-card-2 w3-round-large w3-border w3-margin-left w3-red" style="width: 100px;" onclick="sae_deleteUser('.$userIDX.');">Delete</button><br><br>';
    $str .= '</div>';
    
    return ($str);
}
sub sae_editUserInfo(){
    print $q->header();
    my $str;
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    my $divName = $q->param('divName');
    my $Ref = new SAE::REFERENCE();
    %USER = %{$Ref->_getUserDataByID($userIDX)};
    $str .= '<div class="w3-container w3-padding">';
    $str .= '<label class="w3-small">Firstname</label><br>';
    $str .= '<input type="text" class="w3-input w3-text-blue" value="'.$USER{TX_FIRST_NAME}.'" ID="TX_FIRST_NAME">';
    $str .= '<label class="w3-small">Lastname</label><br>';
    $str .= '<input type="text" class="w3-input w3-text-blue" value="'.$USER{TX_LAST_NAME}.'" ID="TX_LAST_NAME">';
    $str .= '<label class="w3-small">Email</label><br>';
    $str .= '<input type="text" class="w3-input w3-text-blue" value="'.$USER{TX_EMAIL}.'" ID="TX_EMAIL">';
    # $str .= '<br>';
    $str .= '<center>';
    $str .= '<button class="w3-button w3-card-2 w3-round-large w3-border w3-margin-top" onclick="sae_saveUserInfo('.$userIDX.',\''.$divName.'\')">Update</button>';
    $str .= '<button class="w3-button w3-card-2 w3-round-large w3-border w3-margin-top w3-margin-left" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    $str .= '</div>';
    return ($str);
}

sub sae_saveUserInfo(){
    print $q->header();
    my $str;
    my $userIDX = $q->param('userIDX');
    my $txFistName = $q->param('txFirstName');
    my $txLastName = $q->param('txLastName');
    my $txEmail = $q->param('txEmail');
    my $Ref = new SAE::REFERENCE();
    $Ref->_updateUserInfo($txFistName, $txLastName, $txEmail, $userIDX);
    $str = &_templateUserCard($userIDX, $txFistName, $txLastName, $txEmail, $txEmail);
    return ($str);
}
sub sae_userSelected(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    my $userName = $q->param('userName');
    my $Ref = new SAE::REFERENCE();
    my @TYPES = (0,1,4);
    my %REF = (0=>0, 1=>1, 4=>4, 99=>4);
    my %TITLES = (0=>'Students',1=>'Judges',4=>'Admin');
    my %TITLES_ID = (0=>'StudentAccess_',1=>'JudgeAccess_',4=>'AdminAccess_');
    my %TITLES_CLASS = (0=>'sae-StudentAccess',1=>'sae-JudgeAccess',4=>'sae-AdminAccess');
    
    %TILES = %{$Ref->_getTypeTiles()};
    %USER = %{$Ref->_getUserDataByID($userIDX)};
    %ACCESS = %{$Ref->_getUserAccessById($userIDX)};
    %SUB = %{$Ref->_getTeamSubscriptionByID($userIDX, $location)};
    
    my $str;
    $str = &_templateUserCard($userIDX, $USER{TX_FIRST_NAME}, $USER{TX_LAST_NAME}, $USER{TX_LOGIN}, $USER{TX_EMAIL});

    $str .= '<fieldset class="sae_userloaded w3-contianer w3-margin  w3-white w3-round">';
    $str .= '<legend>User Level</legend>';
    my $accessLevel = $REF{$USER{IN_USER_TYPE}};
    
    foreach $level (sort {$a<=>$b} @TYPES){
        my $checked = '';
        if ($accessLevel == $level){$checked = 'checked'}
        $str .= sprintf '<input class="w3-radio w3-margin-left" type="radio" name="IN_USER_TYPE" %s onclick="sae_updateUserLevel('.$userIDX.','.$level.')"> %s<br>', $checked, $TITLES{$level};
    }
    $str .= '</fieldset>';
    
    $str .= '<fieldset class="sae_userloaded w3-contianer w3-margin w3-white w3-round">';
    $str .= '<legend>Advanced Access level</legend>';
    foreach $number (sort {$a<=>$b} @TYPES){
        $str .= '<h4 class="sae_userloaded w3-margin-left w3-large w3-padding-small">'.$TITLES{$number}.' Menu Access ( <a class="w3-small " href="javascript:void(0);" onclick="sae_selectAllLevelAccess('.$number.', 1, '.$userIDX.');">Select All</a> | <a class="w3-small " href="javascript:void(0);" onclick="sae_selectAllLevelAccess('.$number.', 0,'.$userIDX.');">Unselect All</a>)</h4>';
        $str .= '<ul class="w3-ul sae_userloaded w3-margin-left w3-small">';
        foreach $pkTilesIdx (sort {$TILES{$number}{$a}{IN_ORDER} <=> $TILES{$number}{$b}{IN_ORDER}} keys %{$TILES{$number}}){
            if ($pkTilesIdx == 14 || $pkTilesIdx == 15  || $pkTilesIdx == 16  || $pkTilesIdx == 17){next}
            my $checked = '';
            if (exists $ACCESS{$pkTilesIdx}){$checked = 'checked'}
            $str .= '<li style="padding: 1px;">';
            $str .= '<input ID="'.$TITLES_ID{$number}.''.$pkTilesIdx.'" data-key="'.$pkTilesIdx.'" data-access="'.$checked.'" class="w3-check '.$TITLES_CLASS{$number}.' saeAccess saeAccessLevel_'.$number.'" ';
            $str .= 'type="checkbox" value="'.$pkTilesIdx.'" ';
            $str .= 'onchange="sae_processUserAccess(this, '.$userIDX.', '.$pkTilesIdx.');" '.$checked.'>';
            $str .= '&nbsp;&nbsp;<label for="'.$TITLES_ID{$number}.''.$pkTilesIdx.'">'.$TILES{$number}{$pkTilesIdx}{TX_TITLE}.'</label>';
            $str .= '</li>';
        }
        $str .= '</ul>';
    }
    
    $str .= '</fieldset>';
    $str .= '<fieldset class="sae_userloaded w3-contianer w3-margin w3-white w3-round">';
    $str .= '<legend>Team Subscription</legend>';
    $str .= '<button class="w3-button w3-round-large w3-border w3-margin-bottom w3-margin-left"  style="width: 175px;" onclick="sae_getListOfTeams('.$userIDX.');">Add Team(s)</button>';
    $str .= '<div ID="userListOfTeam_Content" class="w3-container">';
    $str .= '<ul class="w3-ul w3-card-2" ID="userListOfTeam_Content_UL">';
    foreach $utIDX (sort {$SUB{$a}{IN_NUMBER} <=> $SUB{$b}{IN_NUMBER}} keys %SUB){
        my $name = sprintf "%03d - %s", $SUB{$utIDX}{IN_NUMBER}, $SUB{$utIDX}{TX_SCHOOL};
        $str .= &_tempListOfUserTeams($name, $utIDX);
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '</fieldset>';
    
    return ($str);
}
sub sae_openManageUsers(){
    print $q->header(); 
    my $str;
    $str = '<br>';
    $str .= '<div class="w3-container w3-margin w3-display-container">';
    $str .= '<h3>Manage Users ';
    $str .= '<a class="w3-button w3-card-2 w3-border w3-round w3-margin-left w3-small" href="javascript:void(0);" onclick="sae_loadUserBook();">Select User</a>';
    $str .= '<a class="w3-button w3-card-2 w3-border w3-round w3-margin-left w3-small" href="javascript:void(0);" onclick="sae_loadListOfJudges();">Judge Password Change</a>';
    $str .= '</h3></div>';
    $str .= '<div ID="userContent" class="w3-container w3-display-container"><div>';
    return ($str);
}
sub sae_loadUserBook(){
    print $q->header();
    my $divName = $q->param('divName');

    my $str;
    my @ALPHA = ('A'..'Z');
    my $Ref = new SAE::REFERENCE();
    %USERS = %{$Ref->_getUserList()};
    
    my $header = "";
    $str .= '<div class="w3-small" style="padding-bottom: 8px; text-align: center">';
    foreach $letter (sort {$a cmp $b} @ALPHA) {
        $str .= '<a class="w3-medium" style="margin-left: 9px;" href="#letter-'.$letter.'">'.$letter.'</a> ';
    }
    $str .= '</div>';
    $str .= '<div id="containerList" class="w3-container w3-border " style="height: 570px; overflow: auto;">';
    $str .= '<ul class="w3-ul">';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})}keys %USERS) {
        my $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        my $head = uc(substr($USERS{$userIDX}{TX_LAST_NAME},0,1));
        if ($head ne $header){
            $header = $head;
            $str .= '<li class="w3-blue-grey w3-large" id="letter-'.$header.'">'.$header.'</li>';
        }
        $str .= '<li class="w3-medium w3-hover-pale-yellow w3-margin-left" style="padding: 1px; ">';

        if ($USERS{$userIDX}{IN_USER_TYPE}>0){
            $str .= '<i class="fa fa-gavel w3-small" aria-hidden="true"></i>&nbsp;';
        }
        $str .= sprintf '<a style="text-decoration: none;" href="javascript:void(0);" onclick="sae_userSelected(%1d, \'%s\',\'%s\');">%s <label class="w3-hide-small w3-margin-left; w3-text-black">( %s )</label></a>', $userIDX, $userName, $divName, $userName, $USERS{$userIDX}{TX_EMAIL};
        $str .= '</li>';
        
    }
    $str .= '</ul>';
    $str .= '</div>';

    return ($str);
}
sub sae_removeUserTeam(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $userTeamIDX = $q->param('userTeamIDX');
    $Auth->_deleteUserTeam($userTeamIDX);
    return;
}
