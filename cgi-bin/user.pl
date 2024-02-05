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
use HTTP::Headers;
use HTTP::Message;

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
use SAE::USER;
use SAE::TEAM;
use SAE::JSONDB;
use SAE::PROFILE;
use SAE::MAIL;
use SAE::PAPER;


$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;
my @tm         = localtime();
my $txYear     = ($tm[5] + 1900);

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
# ================== 2024 =========================================
sub user_VolunteerOptionSelected (){
        print $q->header();
        my $User       = new SAE::USER();
        my $eventIDX   = $q->param('eventIDX');
        # my $classIDX   = $q->param('classIDX');
        # my $teamIDX    = $q->param('teamIDX');
        # my $inType     = $q->param('inType');
        my $Paper      = new SAE::PAPER();
        my $str;
        # my %VOL        = %{$Paper->_getVolunteerJudges($eventIDX, $classIDX)};
        my %VOLUNTEERS = %{$User->_getAllVolunteers()};
        my %VOL        = %{$User->_getEventVolunteer($eventIDX)};
        # my %ASSIGNED   = %{$Paper->_getAssignedToTeam($teamIDX, $inType)}; #1 = Design Papers
        # my %INIT       = %{$User->_getUserFirstInitialAndLastName()};
        $str .= '<div class="w3-container" style="height: 600px; overflow-y: auto;">';
        $str .= '<div class="w3-column-4">';
        foreach $volIDX (sort {lc($VOLUNTEERS{$a}{TX_LAST_NAME}) cmp lc($VOLUNTEERS{$b}{TX_LAST_NAME})} keys %VOLUNTEERS) {
            if (exists $VOL{$volIDX}){next}
            my $volFullName = sprintf '%s, %s', $VOLUNTEERS{$volIDX}{TX_LAST_NAME}, $VOLUNTEERS{$volIDX}{TX_FIRST_NAME};
            $str .= sprintf '<div class="list_item">';
            $str .= sprintf '<input ID="%d" type="checkbox" class="w3-check" value="%d" onclick="user_addMultipleVollunteers(this);">', $volIDX, $volIDX;
            $str .= sprintf '<label for="%d" class="w3-margin-left">%s</label>', $volIDX, $volFullName;
            $str .= sprintf '</div>';
        }
        $str .= '</div>';
        $str .= '</div>';
        $str .= '<div class="w3-container w3-margin" style="text-align: center;">';
        $str .= sprintf '<button class="w3-center w3-button w3-round w3-border w3-pale-green w3-hover-green" onclick="$(this).close();">Close</button>', $classIDX, $inType;
        $str .= '</div>';
        return ($str);
        }
sub user_dropAll (){
    print $q->header();
    my $eventIDX     = $q->param('eventIDX');
    my $userIDX      = $q->param('userIDX');
    my $JsonDB       = new SAE::JSONDB();
    my $str          = $JsonDB->_delete('TB_PROFILE', qq(FK_USER_IDX=$userIDX AND FK_EVENT_IDX=$eventIDX));
    return ($str);
    }
sub user_addNewVolunteer (){
    print $q->header();
    my $User         = new SAE::USER();
    my $eventIDX     = $q->param('eventIDX');
    my $userIDX      = $q->param('userIDX');
    my %USER         = %{$User->_getUserDetails($userIDX)};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $txLast  = $USER{TX_LAST_NAME};
    my $txFirst = $USER{TX_FIRST_NAME};
    my $txEmail = $USER{TX_EMAIL};
    my $str;
    $str = '<tr>';
    $str .= sprintf '<td>%s, %s<br><span class="w3-small">%s</span></td>', $txLast, $txFirst, $txEmail;
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 1, 1);
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 1, 2);
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 1, 3);
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 2, 0);
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 3, 0);
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 4, 0);
    $str .= &user_templatePreferenceSelection(0, 0, $userIDX, 5, 0);
    $str .= '<td>';
    $str .= sprintf '<button style="width: 100%;" class="w3-button w3-round w3-border w3-pale-red w3-hover-red" onclick="user_dropAll(this, %d);">Remove</button>', $userIDX;
    $str .= '</td>';
    $str .= '</tr>';
    return ($str);
    }
sub user_addRemoveVolunteer (){
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $eventIDX   = $q->param('eventIDX');
    my $boAdd      = $q->param('boAdd');
    my $profileIDX = $q->param('profileIDX');

    if ($boAdd == 0) {
        $JsonDB->_delete('TB_PROFILE', qq(PK_PROFILE_IDX=$profileIDX));
        return(0);
    } else {
        my %DATA = %{decode_json($q->param('jsonData'))};
        my $newIDX = $JsonDB->_insert('TB_PROFILE', \%DATA);
        return($newIDX);
    }
    }
sub user_templatePreferenceSelection(){
    my ($checked, $profileIDX, $userIDX, $inType, $classIDX) = @_;
    my $str;
    if ($inType==2 || $inType==5){
            $str .= sprintf '<td class="w3-border-left" style="text-align: center;">';
        } else {
            $str .= sprintf '<td style="text-align: center;">';
        }
    $str .= sprintf '<input class="w3-check" %s data-value="%d" type="checkbox" onclick="user_addRemoveVolunteer(this, %d, %d, %d);">', $checked, $profileIDX, $userIDX, $inType, $classIDX;
    $str .= sprintf '</td>';
    return($str);
}
# ================== 2023 =========================================
sub user_openGeneralEmailForm (){
    print $q->header();
    my $eventIDX     = $q->param('eventIDX');
    my $loginUserIDX = $q->param('loginUserIDX');
    my $field        = $q->param('field');
    my $User         = new SAE::USER();
    my $Mail         = new SAE::MAIL();
    my $Profile      = new SAE::PROFILE();
    my %USER         = %{$User->_getUserDetails($loginUserIDX)};
    my %EMAILS       = %{$Profile->_getListofJudgesBySite($field, $txYear)};
    my $from         = $USER{TX_EMAIL};
    my $to           = join(", ", keys %EMAILS);
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= $Mail->_openEmailForm($to, $from, $subject, $message);

    return ($str);
    }
sub user_removeJudgeFromEventList (){
    my $eventIDX= $q->param('FK_EVENT_IDX');
    my $userIDX= $q->param('FK_USER_IDX');
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $str = $JsonDB->_delete('TB_PREF', qq(FK_USER_IDX=$userIDX AND FK_EVENT_IDX=$eventIDX));
    my $str;

    return ($str);
    }
sub user_addJudgeToList (){
    print $q->header();
    my $eventIDX  = $q->param('FK_EVENT_IDX');
    my $userIDX   = $q->param('FK_USER_IDX');
    my $classIDX  = $q->param('FK_CLASS_IDX');
    my $inStatus  = $q->param('inStatus');
    my $User      = new SAE::USER();
    my $newIDX = $User->_setUpdateJudgesList( $eventIDX, $userIDX, $classIDX, $inStatus);

    my $str;
    return ($newIDX);
    }
sub user_openJudgeList (){
    my $eventIDX  = $q->param('eventIDX');
    my @tm        = localtime();
    my $txYear    = ($tm[5] + 1900);
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Profile   = new SAE::PROFILE();
    # my $User      = new SAE::USER();
    my %JUDGES    = %{$Profile ->_getJudges($txYear)};
    my %USERS     = %{$Profile ->_getUsers()};
    # my %EJ = %{$User->_getEventJudge($eventIDX)};
    print $q->header();
    my $str;
    $str = '<div class="w3-container w3-border w3-round w3-light-grey" style="height: 600px; overflow-y: auto; padding: 0px; margin: 0;">';
    $str .= '<table class="w3-table-all">';
    $str .= '<tr>';
    $str .= '<th class="w3-center" style="width: 130px;">East</th>';
    $str .= '<th class="w3-center" style="width: 130px;">West</th>';
    $str .= '<th>Name</th>';
    $str .= '<th>Email</th>';
    $str .= '<th>Exp. Level</th>';
    $str .= '<th>School Affiliation</th>';
    $str .= '</tr>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        my $boEastCheck = '';
        my $boWestCheck = '';
        if ($JUDGES{$userIDX}{BO_EAST} == 1){$boEastCheck = 'checked'}
        if ($JUDGES{$userIDX}{BO_WEST} == 1){$boWestCheck = 'checked'}
        $str .= '<tr>';
        $str .= '<td class="w3-center"><input type="checkbox" data-field="BO_EAST" class="w3-check" '.$boEastCheck.' onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX .');"></td>';
        $str .= '<td class="w3-center"><input type="checkbox" data-field="BO_WEST" class="w3-check" '.$boWestCheck.' onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX .');"></td>';
        $str .= sprintf '<td>%s, %s</td>', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
        $str .= sprintf '<td>%s</td>', $USERS{$userIDX}{TX_EMAIL};
        $str .= sprintf '<td>%s</td>', $USERS{$userIDX}{TX_YEAR};
        $str .= sprintf '<td>%s</td>', $USERS{$userIDX}{TX_SCHOOL};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '</div>';
    $str .= '<div class="w3-panel w3-padding w3-center">';
    # # $str .= '<button class="w3-border w3-round w3-button w3-margin-top">Copy</button>';

    $str .= '<a class="w3-border w3-text-black w3-round w3-button w3-margin-top w3-margin-right w3-hover-green" href="cgi-bin/export.pl?do=export_allEmailExcel&act=print&eventIDX='.$eventIDX.'" target="_blank">Export Entire Email List (*.csv)</a>';
    $str .= '<button class="w3-border w3-round w3-button w3-margin-top w3-green"  style="width: 120px;" onclick="user_closeAddJudgeModal(this);">Close</button>';
    $str .= '</div>';
    return ($str);
    }
sub user_openJudgeCopyList  (){
    my $eventIDX = $q->param('eventIDX');
    my $User         = new SAE::USER();
    # my $Ref          = new SAE::REFERENCE();
    my %EVENTS       = %{$User->_getAllEvents()};
    print $q->header();
    my $str;
    $str .= '<div class="w3-container w3-border w3-round" style="height: 600px; overflow-y: auto;">';
    $str .= '<ul class="w3-ul w3-border w3-round">';
    foreach $evtIDX (sort {$b <=> $a} keys %EVENTS) {
        if ($evtIDX == $eventIDX){next}
        $str .= '<li class="w3-bar w3-white w3-round w3-hover-pale-yellow" style="padding: 1px 10px;">';
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<input ID="EVENT_'.$evtIDX.'" value="%d" type="radio" name="eventList" class="w3-check" onchange=""><label for="EVENT_'.$evtIDX.'" class="w3-margin-left">Create a New list from: <b>%s</b></label><br>',$evtIDX, $EVENTS{$evtIDX}{TX_EVENT_NAME};
        $str .= '</div>';
        $str .= '</li>';
        $str .= '</label>';
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<div class="w3-panel w3-padding w3-center">';
    $str .= '<button class="w3-border w3-round w3-button w3-margin-top w3-hover-blue" onclick="user_copyJudgesList(this);">Copy</button>';
    $str .= '<button class="w3-border w3-round w3-button w3-margin-top w3-margin-left" onclick="user_closeAddJudgeModal(this)">Cancel</button>';
    $str .= '</div>';
    return($str);
    }
sub user_copyJudgesList (){
    my $eventIDX     = $q->param('eventIDX');
    my $FromEventIDX = $q->param('FromEventIDX');
    print $q->header();
    my $User         = new SAE::USER();
    my $str = $User->_copyJudgesList($FromEventIDX, $eventIDX);
    return ($str);
    }
sub t_JudgeBar (){
    my ($userIDX, $txLastName, $txFirstName, $txEmail, $classCount, $hash) = @_;
    my %CLASS_PREF = %{$hash};
    my %CLASS = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my $str;
    $str = '<li ID="userBarPreference_'.$userIDX.'" class="w3-bar w3-border w3-white w3-round" style="margin-top: 7px;">';
    $str .= '<div class="w3-display-container">';
    # $str .= '<span onclick="" class="w3-display-right w3-button w3-round w3-large w3-right w3-margin-top">&times;</span>';
    $str .= sprintf '<i class="fa fa-times fa-2x w3-display-right w3-button w3-round w3-large w3-right w3-margin-top w3-hover-red" aria-hidden="true" onclick="user_removeJudgeFromEventList(this, %d);"></i>', $userIDX;
    $str .= sprintf '<div class="w3-quarter">';
    $str .= '<img src="../assets/img/person.jpeg" class="w3-bar-item w3-circle" style="width:80px">';
    $str .= sprintf '<b>%s, %s</b><br><span class="w3-text-blue w3-small">%s</span>', $txLastName, $txFirstName, $txEmail;
    $str .= '</div>';
    $str .= '<div class="w3-threequarter">';
    $str .= '<b>Preferences:</b> ';
    my $allChecked = '';
    if ($classCount>=3){$allChecked  = 'checked'}
    $str .= sprintf '<span class="w3-margin-left"><input ID="user_'.$userIDX.'_selectAll" type="checkbox" '.$allChecked.' value="'.$userIDX.'" class="w3-check" onchange="user_selectClassesPreference(this, 0, '.$userIDX.');">';
    $str .= sprintf '<label class="" > All</label></span> ';
    foreach $classIDX (sort {$a <=> $b} keys %CLASS) {
        my $checked = '';
        if (exists $CLASS_PREF{$classIDX}){$checked = 'checked'}
        # my $prefIDX = $CLASS_PREF{$classIDX}{PK_PREF_IDX}; 
        $str .= sprintf '<span class="w3-margin-left"><input type="checkbox" '.$checked.' value="'.$userIDX.'" class="w3-check judgesBarPreference_'.$userIDX.' preferenceCount_'.$userIDX.'" onchange="user_selectClassesPreference(this, '.$classIDX.' ,'.$userIDX.');"><label class="" > %s</label></span> ', $CLASS{$classIDX};
    }
    my $tdsCheck  = '';
    my $drawCheck = '';
    my $reqCheck  = '';
    if (exists $CLASS_PREF{20}){$tdsCheck = 'checked'}
    if (exists $CLASS_PREF{30}){$drawCheck = 'checked'}
    if (exists $CLASS_PREF{40}){$reqCheck = 'checked'}
    $str .= sprintf '<span class="w3-margin-left"><input type="checkbox" '.$tdsCheck.' value="'.$userIDX.'" class="w3-check preferenceCount_'.$userIDX.'" onchange="user_selectClassesPreference(this, 20, '.$userIDX.');">';
    $str .= sprintf '<label class="" > TDS</label></span> ';
    $str .= sprintf '<span class="w3-margin-left"><input type="checkbox" '.$drawCheck.' value="'.$userIDX.'" class="w3-check preferenceCount_'.$userIDX.'" onchange="user_selectClassesPreference(this, 30, '.$userIDX.');">';
    $str .= sprintf '<label class="" > Drawing</label></span> ';
    $str .= sprintf '<span class="w3-margin-left"><input type="checkbox" '.$reqCheck.' value="'.$userIDX.'" class="w3-check preferenceCount_'.$userIDX.'" onchange="user_selectClassesPreference(this, 40, '.$userIDX.');">';
    $str .= sprintf '<label class="" > Requirements</label></span> ';
    $str .= '<br><i class="w3-small w3-text-grey">Note: If no class selected, user will be removed from the event list.</i>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
    }
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
    my @tm         = localtime();
    my $txYear     = ($tm[5] + 1900);
    my $User       = new SAE::USER();
    my $Profile    = new SAE::PROFILE();
    my $eventIDX   = $q->param('eventIDX');
    my %EVENTS     = %{$Profile->_getEvents($txYear)};
    my $Ref        = new SAE::REFERENCE();
    my %USERS      = %{$Profile->_getUsers()};
    my %JUDGES     = %{$Profile->_getJudges( $txYear )};
    # %EVENTS        = %{$Ref->_getEventList()};
    # %EVPREF        = %{$Ref->_getEventPreference()};
    # %CLPREF        = %{$Ref->_getClassPreference()};
    %CLASS         = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my %VOLLIST    = %{$User->_getEventVolunteer($eventIDX)};
    my %REGPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 1)};
    my %ADVPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 1)};
    my %MICPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 1)};
    my %TDSPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 2)};
    my %DRWPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 3)};
    my %REQPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 4)};
    my %PREPREF    = %{$User->_getEventVolunteerPreferences($eventIDX, 5)};
    my %VOLUNTEERS = %{$User->_getAllVolunteers()};

    # my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    # $year += 1900;
    my $str;
    $str = '<div class="w3-container w3-margin-top">';
        $str .= '<h2 class="w3-margin-top">Judge Preferences for Current Event</h2>';

        # $str .= '<div class="w3-bar w3-border w3-blue-grey w3-border-grey w3-margin-top">';

        # # $str .= '<button class="w3-bar-item w3-button " onclick="grade_instructions();">Add Judge</button>';

        # $str .= '<div class="w3-dropdown-hover">';
        # $str .= '<button class="w3-button">Send Email</button> <i class="fa fa-caret-down"></i>';
        # $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
        # $str .= '<button CLASS="w3-bar-item w3-button w3-pale-yellow w3-hover-orange" onclick="user_openGeneralEmailForm(this, \'BO_EAST\');">Send Email to EAST Judges</button>';
        # $str .= '<button CLASS="w3-bar-item w3-button w3-pale-yellow w3-hover-orange" onclick="user_openGeneralEmailForm(this, \'BO_WEST\');">Send Email to WEST Judges</button>';
        # $str .= '</div>';
        # $str .= '</div>';

        # $str .= '<div class="w3-dropdown-hover">';
        # $str .= '<button class="w3-button">Export</button> <i class="fa fa-caret-down"></i>';
        # $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
        # $str .= '<a class="w3-bar-item w3-border w3-text-black  w3-pale-yellow w3-button w3-hover-green" href="cgi-bin/export.pl?do=export_emailExcel&act=print&eventIDX='.$eventIDX.'" target="_blank">Export Email (*.csv)</a>';
        # $str .= '<a class="w3-bar-item w3-border w3-text-black w3-pale-yellow w3-button w3-hover-green" href="cgi-bin/export.pl?do=export_volunteerEmailFormat&act=print&eventIDX='.$eventIDX.'" target="_blank">Export E-mail Format (*.txt)</a>';
        # $str .= '</div>';
        # $str .= '</div>';
        # $str .= '</div>';
    # $str .= %VOLLIST;
    $str .= '<table class="w3-table-all">';
        $str .= '<thead>';
        $str .= '<tr class="w3-border w3-light-grey">';
        $str .= '<th class="w3-border" rowspan="2" style="vertical-align: bottom;">Name</th>';
        $str .= '<th class="w3-border" colspan="3" style="text-align: center">Design Report</th>';
        $str .= '<th class="w3-border" colspan="3" style="text-align: center">Technical Report</th>';
        $str .= '<th class="w3-border" rowspan="2" style="vertical-align: bottom; width: 10%; text-align: center">Presentation</th>';
        $str .= '<th class="w3-border" rowspan="2" style="vertical-align: bottom; width: 10%; text-align: center">Add/Remove</th>';
        $str .= '</tr>';
        $str .= '<tr class="w3-border w3-light-grey w3-small">';
        $str .= '<th style="text-align: center; width: 10%; ">Regular</th>';
        $str .= '<th style="text-align: center; width: 10%; ">Advanced</th>';
        $str .= '<th style="text-align: center; width: 10%; ">Micro</th>';
        $str .= '<th style="text-align: center; width: 10%; ">TDS</th>';
        $str .= '<th style="text-align: center; width: 10%; ">Drawing</th>';
        $str .= '<th style="text-align: center; width: 10%; ">Requirements</th>';
        $str .= '</tr>';
        $str .= '<tr ID="row_control">';
        $str .= '<td>';
        $str .= '<select ID="selectControl" class="w3-input w3-border w3-round" onchange="user_VolunteerOptionSelected(this);">';
        $str .= '<option value="0">-Select-</option>';
        $str .= sprintf '<option value="-1">-- Select Multiple Names -- </option>';
        foreach $userIDX (sort {lc($VOLUNTEERS{$a}{TX_LAST_NAME}) cmp lc($VOLUNTEERS{$b}{TX_LAST_NAME})} keys %VOLUNTEERS) {
            if (exists $VOLLIST{$userIDX}){next}
            $str .= sprintf '<option value="%d">%s, %s</option>', $userIDX, $VOLUNTEERS{$userIDX}{TX_LAST_NAME}, $VOLUNTEERS{$userIDX}{TX_FIRST_NAME};
        }
        $str .= '</select>';
        $str .= '</td>';
        $str .= '<td colspan="8">';
        $str .= sprintf '<button class="w3-button w3-round w3-border w3-pale-green w3-hover-green" style="width: 110px;" onclick="user_addNewVolunteer(this, %d);">Add</button>';
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $userIDX (sort {lc($VOLLIST{$a}{TX_LAST_NAME}) cmp lc($VOLLIST{$b}{TX_LAST_NAME})} keys %VOLLIST) {
            my $txLast     = $VOLLIST{$userIDX}{TX_LAST_NAME};
            my $txFirst    = $VOLLIST{$userIDX}{TX_FIRST_NAME};
            my $txEmail    = $VOLLIST{$userIDX}{TX_EMAIL};
            my $boReg      = '';
            my $boAdv      = '';
            my $boMic      = '';
            my $boTDS      = '';
            my $boDRW      = '';
            my $boREQ      = '';
            my $boPRE      = '';
            my $profileIDX = 0;
            $str .= '<tr>';
            $str .= sprintf '<td>%s, %s<br><span class="w3-small">%s</span></td>', $txLast, $txFirst, $txEmail;
            if (exists $REGPREF{$userIDX}{1}) {$boReg = 'checked'; $profileIDX = $REGPREF{$userIDX}{1}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boReg, $profileIDX, $userIDX, 1, 1);
            $profileIDX = 0;
            if (exists $ADVPREF{$userIDX}{2}) {$boAdv = 'checked'; $profileIDX = $ADVPREF{$userIDX}{2}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boAdv, $profileIDX, $userIDX, 1, 2);
            $profileIDX = 0;
            if (exists $MICPREF{$userIDX}{3}) {$boMic = 'checked'; $profileIDX = $MICPREF{$userIDX}{3}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boMic, $profileIDX, $userIDX, 1, 3);
            $profileIDX = 0;
            if (exists $TDSPREF{$userIDX}) {$boTDS = 'checked'; $profileIDX = $TDSPREF{$userIDX}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boTDS, $profileIDX, $userIDX, 2, 0);
            $profileIDX = 0;
            if (exists $DRWPREF{$userIDX}) {$boDRW = 'checked'; $profileIDX = $DRWPREF{$userIDX}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boDRW, $profileIDX, $userIDX, 3, 0);
            $profileIDX = 0;
            if (exists $REQPREF{$userIDX}) {$boREQ = 'checked'; $profileIDX = $REQPREF{$userIDX}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boREQ, $profileIDX, $userIDX, 4, 0);
            $profileIDX = 0;
            if (exists $PREPREF{$userIDX}) {$boPRE = 'checked'; $profileIDX = $PREPREF{$userIDX}{PK_PROFILE_IDX}}
            $str .= &user_templatePreferenceSelection($boPRE, $profileIDX, $userIDX, 5, 0);
            $str .= '<td>';
            $str .= sprintf '<button style="width: 100%;" class="w3-button w3-round w3-border w3-pale-red w3-hover-red"  onclick="user_dropAll(this, %d);">Remove</button>', $userIDX;
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '</tbody>';
    $str .= '</table>';

# =============================
    # my $count = 1;
    # my $countEast  = 0;
    # my $countWest  = 0;
    # my $countReg   = 0;
    # my $countAdv   = 0;
    # my $countMic   = 0;
    # my $countPreso = 0;
    # foreach $userIDX (keys %JUDGES) {
    #     if ($JUDGES{$userIDX}{BO_EAST} == 1){$countEast++}
    #     if ($JUDGES{$userIDX}{BO_WEST} == 1){$countWest++}
    #     if ($JUDGES{$userIDX}{BO_REGULAR} == 1){$countReg++}
    #     if ($JUDGES{$userIDX}{BO_ADVANCE} == 1){$countAdv++}
    #     if ($JUDGES{$userIDX}{BO_MICRO} == 1){$countMic++}
    #     if ($JUDGES{$userIDX}{BO_PRESO} == 1){$countPreso++}
    # }
    # $str .= '<div class="w3-container w3-margin-top">';
    # $str .= '<br><h2 class="w3-margin-top">'.$txYear.' Judge Preferences</h2>';
    # $str .= '<div class="w3-bar w3-light-grey w3-border w3-padding">';
    # $str .= '<button class="w3-bar-item w3-border w3-button w3-hover-green" onclick="user_openJudgeList(this, '.$eventIDX.');">Add Judge To Event</button>';
    # $str .= '<div class="w3-dropdown-hover">';
    # $str .= '<button class="w3-button">Send Email</button> <i class="fa fa-caret-down"></i>';
    # $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
    # $str .= '<button CLASS="w3-bar-item w3-button w3-pale-yellow w3-hover-orange" onclick="user_openGeneralEmailForm(this, \'BO_EAST\');">Send Email to EAST Judges</button>';
    # $str .= '<button CLASS="w3-bar-item w3-button w3-pale-yellow w3-hover-orange" onclick="user_openGeneralEmailForm(this, \'BO_WEST\');">Send Email to WEST Judges</button>';
    # $str .= '</div>';
    # $str .= '</div>';
    # $str .= '<div class="w3-dropdown-hover">';
    # $str .= '<button class="w3-button">Export</button> <i class="fa fa-caret-down"></i>';
    # $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
    # $str .= '<a class="w3-bar-item w3-border w3-text-black  w3-pale-yellow w3-button w3-hover-green" href="cgi-bin/export.pl?do=export_emailExcel&act=print&eventIDX='.$eventIDX.'" target="_blank">Export Email (*.csv)</a>';
    # $str .= '<a class="w3-bar-item w3-border w3-text-black w3-pale-yellow w3-button w3-hover-green" href="cgi-bin/export.pl?do=export_volunteerEmailFormat&act=print&eventIDX='.$eventIDX.'" target="_blank">Export E-mail Format (*.txt)</a>';
    # $str .= '</div>';
    # $str .= '</div>';
    # $str .= '</div>';

    # $str .= '<table class="w3-table-all w3-border w3-bordered">';
    # $str .= '<thead>';
    # $str .= '<tr>';
    # $str .= '<th rowspan="2" class=" w3-border" style=" vertical-align: bottom;">Judge</th>';
    # $str .= '<th colspan="2" class="w3-center w3-border">Event</th>';
    # $str .= '<th colspan="6" class="w3-center w3-border" >Design Report Preferences</th>';
    # $str .= sprintf '<th rowspan="2" class="w3-center w3-border" style="width: 100px; vertical-align: bottom">Technical Presentations<br>(%d)</th>', $countPreso;
    # $str .= '<th rowspan="2" class="w3-center w3-border" style="width: 100px; vertical-align: bottom">Max. # of Papers</th>';
    # $str .= '<th rowspan="2" class="w3-center w3-border" style="width: 100px; vertical-align: bottom">Exp.<br> Level</th>';
    # $str .= '<th rowspan="2" class="w3-center w3-border" style="width: 250px; vertical-align: bottom">School Affiliation</th>';
    # $str .= '</tr>';
    # $str .= '<tr class="w3-white">';
    # $str .= sprintf '<th class="w3-border w3-center" style="width: 100px;">East<br>(%d)</th>', $countEast;
    # $str .= sprintf '<th class="w3-border w3-center" style="width: 100px;">West<br>(%d)</th>', $countWest;
    # # $str .= '<th class="w3-border w3-center" style="width: 100px;">West</th>';
    # $str .= sprintf '<th class="w3-border w3-center" style="width: 100px;">Reg<br>(%d)</th>', $countReg;
    # $str .= sprintf '<th class="w3-border w3-center" style="width: 100px;">Adv<br>(%d)</th>', $countAdv;
    # $str .= sprintf '<th class="w3-border w3-center" style="width: 100px;">Mic<br>(%d)</th>', $countMic;
    # $str .= '<th class="w3-border w3-center" style="width: 100px;">Drawing</th>';
    # $str .= '<th class="w3-border w3-center" style="width: 100px;">TDS</th>';
    # $str .= '<th class="w3-border w3-center" style="width: 100px;">Req</th>';
    # $str .= '</tr>';
    # $str .= '</thead>';
    # $str .= '<tbody>';
    # foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %JUDGES) {
    #     my $boEastCheck = '';
    #     if ($JUDGES{$userIDX}{BO_EAST} == 1){$boEastCheck = 'checked'} 
    #     my $boWestCheck = '';
    #     if ($JUDGES{$userIDX}{BO_WEST} == 1){$boWestCheck = 'checked'}
    #     my $boRegCheck = '';
    #     if ($JUDGES{$userIDX}{BO_REGULAR} == 1){$boRegCheck = 'checked'}
    #     my $boAdvCheck = '';
    #     if ($JUDGES{$userIDX}{BO_ADVANCE} == 1){$boAdvCheck = 'checked'}
    #     my $boMicCheck = '';
    #     if ($JUDGES{$userIDX}{BO_MICRO} == 1){$boMicCheck = 'checked'}
    #     my $boDrwCheck = '';
    #     if ($JUDGES{$userIDX}{BO_DRW} == 1){$boDrwCheck = 'checked'}
    #     my $boTdsCheck = '';
    #     if ($JUDGES{$userIDX}{BO_TDS} == 1){$boTdsCheck = 'checked'}
    #     my $boReqCheck = '';
    #     if ($JUDGES{$userIDX}{BO_REQ} == 1){$boReqCheck = 'checked'}
    #     my $boPresoCheck = '';
    #     if ($JUDGES{$userIDX}{BO_PRESO} == 1){$boPresoCheck = 'checked'}
    #     $str .= '<tr ID="JUDGE_PREFERENCES_'.$userIDX.'">';
    #     $str .= sprintf '<td>%d: <b>%s, %s</b><br><i class="w3-small">%s</i></td>', $count++, $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME}, $USERS{$userIDX}{TX_EMAIL};
    #     $str .= sprintf '<td class="w3-center w3-border required"><input ID="BO_EAST_'.$userIDX.'" data-field="BO_EAST"    %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boEastCheck;
    #     $str .= sprintf '<td class="w3-center w3-border required"><input ID="BO_WEST_'.$userIDX.'" data-field="BO_WEST"    %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boWestCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_REGULAR" %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boRegCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_ADVANCE" %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boAdvCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_MICRO"   %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boMicCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_DRW"     %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boDrwCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_TDS"     %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boTdsCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_REQ"     %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boReqCheck;
    #     $str .= sprintf '<td class="w3-center w3-border"><input data-field="BO_PRESO"   %s class="w3-check" type="checkbox" onclick="profile_adminSaveCheck(this,'.$txYear.','.$userIDX.');"></td>', $boPresoCheck;
    #     $str .= sprintf '<td class="w3-center w3-border">%d</td>', $JUDGES{$userIDX}{IN_LIMIT};
    #     $str .= sprintf '<td class="w3-center w3-border">%d</td>', $USERS{$userIDX}{TX_YEAR};
    #     $str .= sprintf '<td class="w3-center w3-border">%s</td>', $USERS{$userIDX}{TX_SCHOOL};
    # }
    # $str .= '</tbody>';
    # $str .= '</table>';
    # $str .= '</div>';

    # $str .= '<div class="w3-container w3-margin-top" >';
    # $str .= '<br><h2 class="w3-margin-top">Judges</h2>';

    # $str .= '<div class="w3-container w3-blue-grey">';
    # $str .= sprintf '<h3>%s</h3>',$EVENTS{$eventIDX}{TX_EVENT_NAME};
    # $str .= '</div>';
    # my $display = '';
    # my %CLASS = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    # # foreach $eventIDX (sort {$b <=> $a} keys %EVENTS) {
    #     my %JUDGES     = %{$User->_getEventJudges($eventIDX)};
    #     $str .= sprintf '<div ID="EVENT_'.$eventIDX.'" class="w3-container w3-white w3-border-0 w3-border-left w3-border-right w3-border-bottom event w3-padding-bottom" style="display: %s">', $display;
    #     $str .= '<button class="w3-border w3-round w3-button w3-margin-top w3-hover-green" onclick="user_openJudgeList(this, '.$eventIDX.');">Add Judge To Event</button>';
    #     $str .= '<button class="w3-border w3-round w3-button w3-margin-top w3-margin-left w3-hover-green" onclick="user_openJudgeCopyList(this, '.$eventIDX.');">Copy From Previous Event</button>';
    #     # $str .= '<button class="w3-border w3-round w3-button w3-margin-top w3-margin-left w3-hover-green" onclick="user_downloadEmailList(this);">Export List (*.csv)</button>';
    #     $str .= '<a class="w3-border w3-text-black w3-round w3-button w3-margin-top w3-margin-left w3-hover-green" href="cgi-bin/export.pl?do=export_volunteerEmailFormat&act=print&eventIDX='.$eventIDX.'" target="_blank">Export E-mail Format (*.txt)</a>';
    #     $str .= '<a class="w3-border w3-text-black w3-round w3-button w3-margin-top w3-margin-left w3-hover-green" href="cgi-bin/export.pl?do=export_emailExcel&act=print&eventIDX='.$eventIDX.'" target="_blank">Export Email (*.csv)</a>';
    #     $str .= '<div class="w3-container w3-border w3-round w3-margin-top w3-margin-bottom w3-light-grey">';
    #     $str .= '<ul UD="EVENT_LIST_'.$eventIDX.'" class="w3-ul">';
    #     foreach $userIDX (sort {lc($JUDGES{$a}{TX_LAST_NAME}) cmp lc ($JUDGES{$b}{TX_LAST_NAME})} keys %JUDGES) {
    #         my %CLASS_PREF = %{$User->_getClassPreference($userIDX, $eventIDX)};
    #         my $classCount = scalar(keys %CLASS_PREF);
    #         $str .= &t_JudgeBar($userIDX, $JUDGES{$userIDX}{TX_LAST_NAME}, $JUDGES{$userIDX}{TX_FIRST_NAME}, $JUDGES{$userIDX}{TX_EMAIL}, $classCount, \%CLASS_PREF);
    #     }
    #     $str .= '</ul>';

    #     $str .= '</div>';
        
    #     $str .= '</div>';
    #     $display = 'none;';
    # # }
    # $str .= '</div>';



    # $str .= '<br>';
    # $str .= '<div class="w3-container w3-margin w3-display-container w3-margin-top">';
    # $str .= '<h3><i class="fa fa-gavel fa-fw"></i> Judge Preferences</h3>';
    # $str .= '</div>';
    # $str .= '<table class="w3-table-all w3-small w3-hoverable w3-border w3-card-2">';
    # $str .= '<tr class="w3-hide-small">';
    # $str .= '<th style="width: 200px;">Judges</th>';
    # $str .= '<th>e-Mail</th>';
    # foreach $eventIDX (sort keys %EVENTS) {
    #     $str .= sprintf '<th style="width: 80px;">%s<br>%s<br><input  ID="forSelectAll" type="checkbox" onclick="sae_selectCurrentEvent(this,'.$eventIDX.');"></th>', $EVENTS{$eventIDX}{IN_YEAR}, $EVENTS{$eventIDX}{TX_EVENT};
    # }
    # # $str .= '<input  ID="forSelectAll" type="checkbox" class="w3-check" onclick="toggleSelection(\'inputBinary\', this);">&nbsp; <label for="forSelectAll" class="w3-small">Select All</label>';
    # $str .= '<th>Since</th>';
    # $str .= '<th>Years of<br>Service</th>';
    # $str .= '<th>Willing to <br>Assess Extra</th>';
    # for ($i=1; $i<=3; $i++){
    #     $str .= sprintf '<th style="width: 80px;">%s<br>Class<br><input  ID="forSelectAll" type="checkbox" onclick="sae_selectCurrentClass(this,'.$i.');"></th>', $CLASS{$i};
    # }
    # $str .= '<th>Volunteer<br>Alumni</th>';
    # $str .= '<th>Student<br>Alumni</th>';
    # $str .= '</tr>';
    # foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})}keys %USERS) {
    #     my $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
    #     $str .= '<tr class="w3-hide-small">';
    #     $str .= sprintf '<td class="w3-medium">%s</td>', $userName;
    #     $str .= sprintf '<td>%s</td>', $USERS{$userIDX}{TX_EMAIL};
    #     foreach $eventIDX (sort keys %EVENTS) {
    #         my $checked = '';
    #         if (exists $EVPREF{$userIDX}{$eventIDX}){$checked = 'checked'}
    #         $str .= sprintf '<td><input class="event_'.$eventIDX.' w3-check" type="checkbox" data-access="'.$checked.'" value="'.$userIDX.'" onclick="sae_updateEventPreference(this, %1d, %1d);" %s></td>', $userIDX, $eventIDX, $checked;
    #     }
    #     $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_askYearStarted(this, %1d, \'%s\', \'%s\');">%s</a></td>', $userIDX, $USERS{$userIDX}{TX_YEAR}, 'TX_YEAR', $USERS{$userIDX}{TX_YEAR};
    #     $str .= sprintf '<td class="TD_USER_'.$userIDX.'" ID="TD_USER_'.$userIDX.'">%s</td>',  $year - $USERS{$userIDX}{TX_YEAR};
    #     my $eChecked = '';
    #     if ($USERS{$userIDX}{BO_EXTRA} == 1) {$eChecked = 'checked'}  
    #     $str .= sprintf '<td class="w3-border"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>Extra</span></td>', $userIDX, 'BO_EXTRA', $eChecked;
    #     for ($i=1; $i<=3; $i++){
    #         my $checked = '';
    #         if (exists $CLPREF{$userIDX}{$i}){$checked = 'checked'}
    #         $str .= sprintf '<td style="text-align: cetner;"><input class="pref_class_'.$i.' w3-check" data-access="'.$checked.'" type="checkbox" value="'.$userIDX.'" onclick="sae_updateClassPreference(this, %1d, %1d);" %s> %s</td>', $userIDX, $i, $checked, substr($CLASS{$i},0,1);
    #     }
    #     my $vChecked = '';
    #     my $sChecked = '';
    #     if ($USERS{$userIDX}{BO_VOL_ALUM} == 1) {$vChecked = 'checked'}    
    #     if ($USERS{$userIDX}{BO_STU_ALUM} == 1) {$sChecked = 'checked'}    
    #     $str .= sprintf '<td class="w3-border"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>V-Alum</span></td>', $userIDX, 'BO_VOL_ALUM', $vChecked;
    #     $str .= sprintf '<td class="w3-border"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>S-Alum</span></td>', $userIDX, 'BO_STU_ALUM', $sChecked;
    #     $str .= '</tr>';
    #     $str .= '<tr></tr>';
    #     $str .= '<tr class="w3-hide-medium w3-hide-large">';
    #     $str .= '<td class="w3-container">';
    #     $str .= sprintf '<header class="w3-large w3-blue-grey w3-padding"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><span>%s</span></header><br>', $userName;
    #     $str .= sprintf '<b>Email: </b><span>%s</span><br>', $USERS{$userIDX}{TX_EMAIL};
    #     $str .= sprintf '<b>Years Started: </b><span>%s</span><br>', $USERS{$userIDX}{TX_YEAR};
    #     $str .= sprintf '<b>Years of Service: </b><span class="TD_USER_'.$userIDX.'">%s</span><br>',  $year - $USERS{$userIDX}{TX_YEAR};
    #     $str .= sprintf '<br><b>Event Preference: </b><br>';
        
    #     foreach $eventIDX (sort keys %EVENTS) {
    #         my $checked = '';
    #         if (exists $EVPREF{$userIDX}{$eventIDX}){$checked = 'checked'}
    #         $str .= sprintf '<input class="eventSmall_'.$eventIDX.' w3-check w3-margin-left" type="checkbox" onclick="sae_updateEventPreference(this, %1d, %1d);" %s> &nbsp;%s %s',  $userIDX, $eventIDX, $checked,  $EVENTS{$eventIDX}{IN_YEAR}, $EVENTS{$eventIDX}{TX_EVENT};
    #     }
    #     $str .= sprintf '<br><br><b>Extra Preference: </b><br>';
    #     $str .= sprintf '<input class="w3-check w3-margin-left" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');"> <span>Yes, willing to take on Extra Assessments</span><br>', $userIDX, 'BO_EXTRA';
    #     $str .= sprintf '<br><b>Class Preference: </b><br>';
    #     for ($i=1; $i<=3; $i++){
    #         my $checked = '';
    #         if (exists $CLPREF{$userIDX}{$i}){$checked = 'checked'}
    #         $str .= sprintf '<input class="classSmall_'.$i.' w3-check w3-margin-left" type="checkbox" onclick="sae_updateClassPreference(this, %1d, %1d);" %s> %s', $userIDX, $i, $checked, $CLASS{$i};
    #     }
    #     $str .= sprintf '<br><br><b>Alumni Status: </b><br>';
    #     $str .= sprintf '<input class="w3-check w3-margin-left" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>Volunteer</span>', $userIDX, 'BO_VOL_ALUM', $vChecked;
    #     $str .= sprintf '<input class="w3-check w3-margin-left" type="checkbox" value="1" onclick="sae_updateUserAttributes(this, %1d, \'%s\');" %s> <span>Student</span>', $userIDX, 'BO_STU_ALUM', $sChecked;
    #     $str .= '</td>';
    #     $str .= '</tr>';    
        
    
    # }
    # $str .= '</table>';
    
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
sub sae_updateChanges(){
    print $q->header(); 
    my $userIDX = $q->param('userIDX');
    my $txField = $q->param('txField');
    my $inValue = $q->param('inValue');
    my $boPassword = $q->param('boPassword');
    my $User = new SAE::USER($userIDX);
    if ($boPassword > 0){
        my $Auth = new SAE::Auth();
        my $salt = $Auth->getTemporaryPassword(2);
          $inValue = $salt.crypt($inValue,$salt);
    }
    $User->_saveField($txField, $inValue, $userIDX);
    return;
    }
sub sae_addUserAccess(){
    print $q->header(); 
    my $userIDX = $q->param('userIDX');
    my $tileIDX = $q->param('tileIDX');
    my $User = new SAE::USER();
    $User->_addUserAccess($tileIDX, $userIDX);
    return;
    }
sub sae_removeUserAccess(){
    print $q->header(); 
    my $userIDX = $q->param('userIDX');
    my $tileIDX = $q->param('tileIDX');
    my $User = new SAE::USER();
    $User->_removeUserAccess($tileIDX, $userIDX);
    return;
    }
sub sae_addUserTeam(){
    print $q->header(); 
    my $userIDX = $q->param('userIDX');
    my $teamIDX = $q->param('teamIDX');
    my $User = new SAE::USER();
    $User->_addUserTeam($teamIDX, $userIDX);
    return;
    }
sub sae_removeUserTeam(){
    print $q->header(); 
    my $userIDX = $q->param('userIDX');
    my $teamIDX = $q->param('teamIDX');
    my $User = new SAE::USER();
    $User->_removeUserTeam($teamIDX, $userIDX);
    return;
    }
sub sae_userSelected(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $eventIDX = $q->param('eventIDX');
    # my $userName = $q->param('userName');
    my $User = new SAE::USER($userIDX);
    my $Team = new SAE::TEAM();
    my %USER = %{$User->_getUserData()};
    my %TEAMS    = %{$Team->_getTeamList($eventIDX)};
    my %USERTEAM = %{$Team->_getUserTeam($userIDX, $eventIDX)};
    my $Ref = new SAE::REFERENCE();
    %TILES = %{$Ref->_getTypeTiles()};
    # %USER = %{$Ref->_getUserDataByID($userIDX)};
    %ACCESS = %{$Ref->_getUserAccessById($userIDX)};
    
    
    
    my @TYPES = (0,1,4);
    # my %REF = (0=>0, 1=>1, 4=>4, 99=>4);
    my %TITLES = (0=>'Student',1=>'Judge',4=>'Admin');
    # my %TITLES_ID = (0=>'StudentAccess_',1=>'JudgeAccess_',4=>'AdminAccess_');
    # my %TITLES_CLASS = (0=>'sae-StudentAccess',1=>'sae-JudgeAccess',4=>'sae-AdminAccess');
    my $str = '<div class="w3-container" style="padding: 1px!important">';
    my $activeTab = 'w3-white w3-border-left w3-border-top w3-border-right';
    $str .= '<div class="w3-bar w3-blue-grey">';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink %s " onclick="sae_openUserTab(this, \'%s\');">Profile</button>', $activeTab,'userProfile';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="sae_openUserTab(this, \'%s\');">Access</button>', 'userAccess';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="sae_openUserTab(this, \'%s\');">Team</button>', 'userTeam';
    # $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="sae_openUserTab(this, \'%s\');">Profile</button>', 'profile';
    $str .= '</div>';
    # -------------------- USER PROFILE ----------------------------------------
    $str .= '<div id="userProfile" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs">';
    $str .= sprintf '<h3>User: %d</h3>', $userIDX;
    $str .= sprintf '<label class="w3-text-grey">Last Accessed: <span class="w3-text-light-blue">%s</span></label><br><br>', $USER{TS_ACCESS};
    $str .= sprintf '<label class="w3-text-grey">First Name<input type="text" class="w3-input w3-border w3-round" value="%s" placeholder="First Name" data-key="TX_FIRST_NAME" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_FIRST_NAME}, $userIDX;
    $str .= sprintf '<label class="w3-text-grey">Last Name<input type="text" class="w3-input w3-border w3-round" value="%s" placeholder="Last Name" data-key="TX_LAST_NAME" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_LAST_NAME}, $userIDX;
    $str .= sprintf '<label class="w3-text-grey">Email<input type="text" class="w3-input w3-border w3-round" value="%s" placeholder="Email" data-key="TX_EMAIL" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_EMAIL}, $userIDX;
    $str .= sprintf '<label class="w3-text-grey">Password<input type="password" class="w3-input w3-border w3-round" value="%s" placeholder="Email" data-key="TX_PASSWORD" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_PASSWORD}, $userIDX;
    my $check = '';
    if ($USER{BO_RESET} > 0) {$check = 'checked'}
    $str .= sprintf '<label class="w3-text-grey"><input type="checkbox" class="w3-check" value="1" %s  data-key="BO_RESET" onchange="sae_updateChanges(this, %d);"> &nbsp;&nbsp;Require password change at next Log-In</label><br>', $check, $userIDX;
    $str .= '<br>'x3;
    $str .= '</div>';
    # -------------------- USER ACCESS ----------------------------------------
    $str .= '<div id="userAccess" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide">';
    $str .= sprintf '<h3>User: %d Access</h3>', $userIDX;
    $str .= '<div class="w3-row w3-padding w3-light-grey w3-border w3-margin-bottom">';
    $str .= '<h5>User Type</h5>';
    my $accessLevel = $USER{IN_USER_TYPE};
    foreach $level (sort {$a<=>$b} @TYPES){
        my $checked = '';
        if ($accessLevel == $level){$checked = 'checked'}
        $str .= '<div class="w3-col w3-quarter">';
        $str .= sprintf '<input type="radio" name="IN_USER_TYPE" value="%d" %s data-key="IN_USER_TYPE" onchange="sae_updateChanges(this, %d);">&nbsp; %s', $level, $checked, $userIDX, $TITLES{$level};
        $str .= '</div>';
    }
    $str .= '</div>';
    foreach $number (sort {$a<=>$b} @TYPES){
        $str .= '<div class="w3-row w3-padding w3-light-grey w3-border w3-margin-bottom w3-small">';
        $str .= sprintf '<h5>%s Level Access</h5>', $TITLES{$number};
        foreach $tileIDX (sort {$TILES{$number}{$a}{IN_ORDER} <=> $TILES{$number}{$b}{IN_ORDER}} keys %{$TILES{$number}}){
            if ($tileIDX == 14 || $tileIDX == 15  || $tileIDX == 16  || $tileIDX == 17){next}
            my $checked = '';
            if (exists $ACCESS{$tileIDX}){$checked = 'checked'}
            $str .= '<div class="w3-col w3-quarter">';
            $str .= sprintf '<label class="w3-text-grey"><input class="w3-check" type="checkbox" %s onchange="sae_updateUserAccess(this, %d, %d);">&nbsp; %s</label>', $checked,  $userIDX, $tileIDX, $TILES{$number}{$tileIDX}{TX_TITLE};
            $str .= '</div>';
        }
        $str .= '</div>';
    }
    $str .= '</div>';
    # -------------------- USER TEAMS ------------------------------------------

    
    $str .= '<div id="userTeam" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide">';
    $str .= sprintf '<h3>User: %d Team</h3>', $userIDX;
    $str .= '<div class="w3-row w3-padding w3-light-grey w3-border w3-margin-bottom">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $checked = '';
        if (exists $USERTEAM{$teamIDX}){$checked = 'checked'}
        my $txTeam = sprintf '%03d - %s', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<div class="w3-col w3-half">';
        $str .= sprintf '<label class="w3-text-grey"><input class="w3-check" type="checkbox" %s onchange="sae_updateUserTeam(this, %d, %d)">&nbsp;%s</label>', $checked, $teamIDX, $userIDX, $txTeam;
        $str .= '</div>';
    }
    $str .= '</div>';
    $str .= '</div>';
    
    $str .= '<div class="w3-center w3-margin-top w3-margin-bottom">';
    $str .= sprintf '<button class="w3-center w3-button w3-border w3-round w3-border-red w3-hover-red" onclick="sae_deleteUser(this, %d);">Delete User</button>', $userIDX;
    $str .= '</div>';
    
    $str .= '</div>';
    
    
    return ($str);
    }
sub sae_openManageUsers(){
    print $q->header(); 
    my $User = new SAE::USER();
    my %USERS = %{$User->_getAllUsers()};
    my %ROLE = (0=>'Student', 1=>'Judge', 99=>'Admin', 4=>'Admin');
    my $str;
    $str .= '<div class="w3-container w3-margin-top"><br>';
    $str .= '<h3><i class="fa fa-users f2-2x" aria-hidden="true"></i>&nbsp;Users</h3>';
    $str .= '<input class="w3-input w3-border w3-round" type="search" id="mySearchInput" onkeyup="sae_SearchUserName(this);" placeholder="Search for names.." title="Type in a name">';

    $str .= '<table ID="USER_TABLE" class="w3-table w3-bordered w3-margin-top w3-white">';
    $str .= '<thead>';
    $str .= '<tr class="w3-blue-grey">';
    $str .= '<th>Name</th>';
    $str .= '<th>EMAIL</th>';
    $str .= '<th>Access</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        my $userName = sprintf '%s, %s',$USERS{$userIDX}{TX_LAST_NAME},$USERS{$userIDX}{TX_FIRST_NAME};
        my $userEmail = $USERS{$userIDX}{TX_EMAIL};
        my $userTypeID = $USERS{$userIDX}{IN_USER_TYPE};
        $str .= sprintf '<tr ID="TR_USER_%d">', $userIDX;
        if ($userTypeID>0) {
            $str .= sprintf '<td><i class="fa fa-user w3-margin-right w3-text-red" aria-hidden="true"></i><a href="javascript:void(0);" onclick="sae_userSelected(%d);">%s</a></td>', $userIDX, $userName;
        } else {
            $str .= sprintf '<td><i class="fa fa-user-o w3-margin-right" aria-hidden="true"></i><a href="javascript:void(0);" onclick="sae_userSelected(%d);">%s</a></td>', $userIDX, $userName;
        }
        $str .= sprintf '<td><i class="fa fa-envelope-o w3-margin-right" aria-hidden="true"></i>%s</td>', $userEmail;
        $str .= sprintf '<td>%s</td>', $ROLE{$USERS{$userIDX}{IN_USER_TYPE}};
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';

    $str .= '</div>';    
    return ($str);
    }
sub sae_deleteUser(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $User = new SAE::USER();
    $User->_deleteUser($userIDX);
    }
