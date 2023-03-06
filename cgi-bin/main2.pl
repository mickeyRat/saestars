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
use SAE::PROFILE;

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
# WEATHER
# ***********************************************************************************************************************************
sub sae_openWeather(){
    print $q->header();
    my $location = $q->param('location');
    my $hours = $q->param('hours');
    my $Weather = new SAE::WEATHER();
    my %WEATHER = %{$Weather->_getWeatherByHours( $location , $hours )};
    my %EVENT = %{$Weather->_getEventDataById( $location )};
    my $str = '<div class="w3-container">';
    $str .= '<br><h3>Weather: '.$EVENT{$location}{TX_EVENT_CITY}.'</h3>';
    $str .= '<p class="w3-small">Source: <a href="'.$EVENT{$location}{TX_WEB}.'" target="_blank">'.$EVENT{$location}{TX_WEB}.'</a></p>';
    $str .= '<div class="w3-panel">';
    $str .= 'Weather data for the last "x" hours: ';
    for ($i=1; $i<=8; $i++){
        $checked = '';
        if ($i == $hours){$checked = 'checked'}
        $str .= '<input class="w3-margin-left" type="radio" '.$checked.' name="durationSelection" onclick="sae_openWeather('.$i.');"> <label>'.$i.' </label> ';
    }

    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-border w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 25%;">Date - Time</th>';
    $str .= '<th style="width: 10%;">Site<br>Elevation</th>';
    $str .= '<th style="width: 10%;"><br>Temperature</th>';
    $str .= '<th style="width: 10%;"><br>Pressure</th>';
    $str .= '<th style="width: 10%;">Relative<br>Humidity</th>';
    $str .= '<th style="width: 10%;">Wind<br>Direction</th>';
    $str .= '<th style="width: 15%;">Calculated<br>Density-Altitude</th>';
    # $str .= '<th style="width: 15%;">Adjusted<br>Density-Altitude</th>';
    $str .= '</tr>';
    foreach $weatherIDX (sort {$b <=> $a} keys %WEATHER) {
        $str .= '<tr class="w3-hide-small">';
        $str .= '<td>'.$WEATHER{$weatherIDX}{TS_LOCAL}.'</td>';
        $str .= sprintf '<td>%2.1f ft.</td>', $WEATHER{$weatherIDX}{IN_ELEVATION};
        $str .= sprintf '<td>%2.1f &deg;F</td>', $WEATHER{$weatherIDX}{IN_TEMP};
        $str .= sprintf '<td>%2.2f in.</td>', $WEATHER{$weatherIDX}{IN_PRES};
        $str .= sprintf '<td>%2.2f%</td>', $WEATHER{$weatherIDX}{IN_RH};
        # $str .= sprintf '<td>%2.1f ft.</td>', $WEATHER{$weatherIDX}{IN_ELEVATION};
        $str .= sprintf '<td>%s</td>', $WEATHER{$weatherIDX}{TX_WINDDIR};
        $str .= sprintf '<td>%2.2f ft.</td>', $WEATHER{$weatherIDX}{IN_DENSITY};
        # $str .= sprintf '<td>%2.2f ft.</td>', ($WEATHER{$weatherIDX}{IN_ELEVATION} + $WEATHER{$weatherIDX}{IN_DENSITY});

        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr>';
        $str .= '<td class="w3-hide-medium w3-hide-large">';
        $str .= sprintf '<b>Date/Time</b>: <span class="w3-text-blue">%s</span><br>',$WEATHER{$weatherIDX}{TS_LOCAL};
        $str .= sprintf '<b>Temperature</b>: <span class="w3-text-blue">%2.1f &deg;F</span><br>',$WEATHER{$weatherIDX}{IN_TEMP};
        $str .= sprintf '<b>Pressure</b>: <span class="w3-text-blue">%2.2f in.</span><br>',$WEATHER{$weatherIDX}{IN_PRES};
        $str .= sprintf '<b>Rel. Humidity</b>: <span class="w3-text-blue">%2.2f %</span><br>',$WEATHER{$weatherIDX}{IN_RH};
        # $str .= sprintf '<b>Site Elev.</b>: <span class="w3-text-blue">%2.1f ft.</span><br>',$WEATHER{$weatherIDX}{IN_ELEVATION};
        $str .= sprintf '<b>Wind Direction:</b>: <span class="w3-text-blue">%s</span><br>',$WEATHER{$weatherIDX}{TX_WINDDIR};
        $str .= sprintf '<b>Calculated Den-Alt</b>: <span class="w3-text-blue">%2.2f ft.</span><br>',$WEATHER{$weatherIDX}{IN_DENSITY};
        # $str .= sprintf '<b>Adjusted Den-Alt</b>: <span class="w3-text-blue">%2.2f ft.</span><br>',($WEATHER{$weatherIDX}{IN_ELEVATION} + $WEATHER{$weatherIDX}{IN_DENSITY});
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</div>';
    return ($str);
}
# ***********************************************************************************************************************************
# User Profile
# ***********************************************************************************************************************************
sub sae_resetPasswordSubmit(){
    print $q->header();
    # my $dbi = new SAE::Db();
    my $userIDX = $q->param('userIDX');
    my $password = $q->param('password');
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();
    my $salt = $Auth->getTemporaryPassword(2);
    my $saltedPassword = $salt.crypt($password,$salt);
    # my $SQL = "UPDATE TB_USER SET TX_PASSWORD=?, BO_RESET=? WHERE PK_USER_IDX=?";
    # my $update = $dbi->prepare($SQL);
    # # $update->execute($saltedPassword, 1, $userIDX );

    $User->updateTxPassword_byId($saltedPassword, $userIDX);
    $User->updateBoReset_byId(1, $userIDX);
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
sub sae_changeMyPasswordSubmit(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $passwordNew = $q->param('passwordNew');
    my $User = new SAE::TB_USER();
    my $Auth = new SAE::Auth();
    my $salt = $Auth->getTemporaryPassword(2);
    my $userPassword = $salt.crypt($passwordNew, $salt);
    $User->updateTxPassword_byId($userPassword, $userIDX);
    return ("$userPassword, $userIDX");
}
sub sae_validateCurrentPassword(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $pwd = $q->param('pwd');
    my $Ref = new SAE::REFERENCE();
    my $Auth = new SAE::Auth();
    my %USER = %{$Ref->_getUserRecord($userIDX)};
    my $salt = substr($USER{$userIDX}{TX_PASSWORD},0,2);
    my $userPassword = $salt.crypt($pwd, $salt);
    if ($userPassword eq $USER{$userIDX}{TX_PASSWORD}){
        return(1);
    } else {
        return (0);
    }

}
sub sae_changeMyPassword(){ 
    print $q->header();
    my $Auth = new SAE::AUTO();
    my $userIDX = $q->param('userIDX'); 
    my $location = $q->param('location'); 
    my $divName = $q->param('divName'); 
    my $str;
    $str .= '<div class="w3-container w3-padding w3-white" style="margin-bottom: 65px;">';
    $str .= '<label class="w3-small">Current Password</label>';
    $str .= '<input ID="passwordCurrent" type="password" onblur="sae_validateCurrentPassword(this, '.$userIDX.');" ID="currentPassword" class="w3-input w3-border w3-small" value="" placeholder="Current Password">';
    $str .= '<div ID="span_CurrentStatus" class="w3-bar w3-red w3-hide"  style="margin-top: 5px; padding: 1px 10px;">Invalid Password</div>';
    $str .= '<hr>';
    $str .= '<label class="w3-small">New Password</label>';
    $str .= '<input ID="passwordNew" type="password" class="w3-input w3-border" ID="newPassword"  placeholder="New Password">';
    $str .= '<label class="w3-small">Confirm Password</label>';
    $str .= '<input ID="passwordConfirm" type="password" class="w3-input w3-border" ID="confirmPassword" onkeyup="sae_validateConfirmPassword(this);" placeholder="Re-Type Password">';
    $str .= '<div ID="span_ConfirmStatus" class="w3-bar w3-red w3-hide" style="margin-top: 5px; padding: 1px 10px;">Password Mismatch-Try Again</div>';
    $str .= '<a ID="btn_changePassword" class="w3-disabled w3-button w3-border w3-card-4 w3-display-bottommiddle w3-margin-bottom" href="javascript:void(0);" onclick="sae_changeMyPasswordSubmit('.$userIDX.',\''.$divName.'\');">Change</a>';
    $str .= '</div>';
    return ($str);
}
sub sae_saveProfile(){
    print $q->header();
    my $Auth = new SAE::AUTO();
    my $txFirst = $q->param('txFirst');  
    my $txLast = $q->param('txLast');  
    my $txEmail = $q->param('txEmail');  
    my $userIDX = $q->param('userIDX');  
    my $Auth = new SAE::Auth();
       $Auth->_setProfile($txFirst , $txLast , $txEmail , $userIDX);
    return;
}
sub sae_showUserProfile(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $eventIDX = $q->param('location');
    # my $userName = $q->param('userName');
    my $User = new SAE::USER($userIDX);
    my $Team = new SAE::TEAM();
    my $Profile = new SAE::PROFILE();
    my %USER = %{$User->_getUserData()};
    my %TEAMS    = %{$Team->_getTeamList($eventIDX)};
    my %USERTEAM = %{$Team->_getUserTeam($userIDX, $eventIDX)};
    my %PROFILE = %{$Profile->_getUserPreferenceHistory($userIDX)};
    
    my $Ref = new SAE::REFERENCE();
    # my $location = $q->param('location');  
    # my $userIDX = $q->param('userIDX');  
    # my %USER = %{$Ref->_getUserRecord($userIDX)};
    my %SUBSCRIPTION = %{$Ref->_getUserTeamList($userIDX, $eventIDX)};
    my $activeTab = 'w3-white w3-border-left w3-border-top w3-border-right';
    my $str = '<div class="w3-container" style="padding: 10px!important">';
    $str .= '<br />'x2;
    $str .= '<h2>User Profile</h2>';
    $str .= '<div class="w3-bar w3-blue-grey">';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink %s " onclick="sae_openUserTab(this, \'%s\');">Profile</button>', $activeTab,'userProfile';
    # $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="sae_openUserTab(this, \'%s\');">Access</button>', 'userAccess';
    $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="sae_openUserTab(this, \'%s\');">Team</button>', 'userTeam';
    if ($USER{IN_USER_TYPE}>=1){
        $str .= sprintf '<button class="w3-bar-item w3-button tablink " onclick="sae_openUserTab(this, \'%s\');">Event Preferences</button>', 'Preference';
    }
    $str .= '</div>';
    $str .= '<div id="userProfile" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs  w3-white w3-round">';
    $str .= sprintf '<h3>User ID: %d</h3>', $userIDX;
    $str .= sprintf '<label class="w3-text-grey w3-margin-bottom w3-small">Last Accessed: <span class="w3-text-light-blue">%s</span></label><br><br>', $USER{TS_ACCESS};
    $str .= sprintf '<label class="w3-text-grey w3-margin-bottom w3-small">First Name<input type="text" class="w3-input w3-border w3-round" value="%s" placeholder="First Name" data-key="TX_FIRST_NAME" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_FIRST_NAME}, $userIDX;
    $str .= sprintf '<label class="w3-text-grey w3-margin-bottom w3-small">Last Name<input type="text" class="w3-input w3-border w3-round" value="%s" placeholder="Last Name" data-key="TX_LAST_NAME" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_LAST_NAME}, $userIDX;
    $str .= sprintf '<label class="w3-text-grey w3-margin-bottom w3-small">Email<input type="text" class="w3-input w3-border w3-round" value="%s" placeholder="Email" data-key="TX_EMAIL" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_EMAIL}, $userIDX;
    $str .= sprintf '<label class="w3-text-grey w3-margin-bottom w3-small">Password<input type="password" class="w3-input w3-border w3-round" value="%s" placeholder="Email" data-key="TX_PASSWORD" onchange="sae_updateChanges(this, %d);"></label>', $USER{TX_PASSWORD}, $userIDX;
    
    $str .= '<br>'x3;
    $str .= '</div>';
    
    $str .= '<div id="userTeam" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-white w3-round">';
    $str .= sprintf '<h3>Team(s)</h3>';
    $str .= '<div ID="SubscriptionList" class="w3-row w3-padding w3-light-grey w3-border w3-margin-bottom">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        if (exists $USERTEAM{$teamIDX}) {
            my $txTeam = sprintf '%03d - %s', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
            $str .= '<div class="w3-col w3-half">';
            $str .= sprintf '<label class="w3-text-grey"><input class="w3-check" type="checkbox" checked onchange="sae_updateUserTeam(this, %d, %d)">&nbsp;%s</label>', $teamIDX, $userIDX, $txTeam;
            $str .= '</div>';
        }
    }
    $str .= '</div>';
    $str .= '<div class="w3-border w3-container w3-white w3-round w3-padding w3-margin-bottom">';
    $str .= '<label class="w3-small w3-text-grey">Team Code:<br><input type="number" id="sae_teamCodeEntry" class="w3-input w3-border w3-lightblue w3-round" style="width: 200px; display: inline;">&nbsp;';
    $str .= '</label>';
    $str .= sprintf '<button class="w3-button w3-border w3-green w3-round w3-margin-left " onclick="sae_subscribeToTeam(%d, 1);";>Add Team</button>', $userIDX;
    $str .= '</div>';
    $str .= '</div>';    

    $str .= '<div id="Preference" class="w3-container w3-border-left w3-border-right w3-border-bottom userTabs w3-hide w3-white w3-round">';
    $str .= sprintf '<h3>Event Preferences</h3>';
    $str .= '<ul class="w3-ul">';
    foreach $profileIDX (sort {$PROFILE{$b}{TX_YEAR} <=> $PROFILE{$a}{TX_YEAR}} keys %PROFILE)  {
        $str .= '<li ID="EVENT_PROFILE_BAR_'.$profileIDX.'" class="w3-bar w3-border w3-white w3-round w3-card-2">';
        # $str .= '<div class="w3-bar-item w3-right">';
        # $str .= '</div>';
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<a ID="Profile_'.$profileIDX.'" class="w3-large" href="javascript:void(0);" onclick="profile_openMyPreferences(this, %d, %d);">My %s Event Preferences</a>', $profileIDX, $PROFILE{$profileIDX}{TX_YEAR}, $PROFILE{$profileIDX}{TX_YEAR};
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul><br>';
    $str .= '</div>';  

    $str .= '</div>';
    return ($str);
}
sub _tempSubscribers(){
    my $str;
    my $name = shift;
    my $txCountry = shift;
    my $userTeamIDX = shift;
    $str .= '<li class="w3-display-container" style="padding:5px 5px 5px 25px;">';
    $str .= '<span onclick="sae_removeUserTeam(this, '.$userTeamIDX.');" class="w3-button w3-white w3-right">X</span>';
    $str .= '<span>'.$name.'</span><br>';
    $str .= '<span>'.$txCountry.'</span>';
    $str .= '</li>';
    return ($str);
}
sub sae_subscribeToTeam(){
    print $q->header();
    my $location = $q->param('location');  
    my $teamCode = $q->param('teamCode');  
    my $userIDX  = $q->param('userIDX');  
    my $Ref      = new SAE::REFERENCE();
    my $Auth     = new SAE::Auth();
    my $teamIDX  = $Ref->_getTeamIDXByTeamCode($teamCode);
    if ($teamIDX>0){
        my $userTeamIDX = $Auth->_addTeamToUser($userIDX, $teamIDX);
        my %TEAM        = %{$Ref->_getTeamData($teamIDX)};
        # $name = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
        # $txCountry = $TEAM{$teamIDX}{TX_COUNTRY};
        # $str .= &_tempSubscribers($name , $txCountry , $userTeamIDX );
        my $txTeam = sprintf '%03d - %s', $TEAM{$teamIDX}{IN_NUMBER}, $TEAM{$teamIDX}{TX_SCHOOL};
        my $str = '<div class="w3-col w3-half">';
        $str .= sprintf '<label class="w3-text-grey"><input class="w3-check" type="checkbox" checked onchange="sae_updateUserTeam(this, %d, %d)">&nbsp;%s</label>', $teamIDX, $userIDX, $txTeam;
        $str .= '</div>';
        return ($str);
    } else {
        return 0;
    }

}
# ***********************************************************************************************************************************
# Set Event 
# ***********************************************************************************************************************************
sub sae_showModalEventSelection(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $location = $q->param('location');
    my %EVENTS = %{$Ref->_getEventList()};
    my $str = '<div class="w3-margin w3-padding w3-display-container" style="height: 150px;">';
    $str .= '<label for="sae_eventSelection">Choose an Event:</label>';
    $str .= '<select ID="sae_eventSelection" class="w3-select w3-border w3-round w3-padding"> ';
    foreach $eventIDX (sort keys %EVENTS){
        my $selected = '';
        my $selectedClass='';
        if ($eventIDX == $location){$selected = 'selected'; $selectedClass='w3-pale-yellow'}
        $str .= sprintf '<option class="%s" value="%d" %s>%s</option>', $selectedClass, $eventIDX, $selected, $EVENTS{$eventIDX}{TX_EVENT_NAME};
    }
    $str .= '</select>';
    $str .= '<button class="w3-green w3-hover-blue w3-button w3-border w3-round-large w3-card-2 w3-margin-bottom w3-margin-right w3-display-bottomright" style="width: 120px;" onclick="sae_setModalEvent(this);">Set Event</button>';
    $str .= '</div>';
    return($str);
}
sub sae_showSetEventLocationFromMain(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $location = $q->param('location');  
    my %EVENT = %{$Ref->_getEventList()};
    my $str = '<div class="w3-margin w3-padding w3-container">';
    $str .= '<br><h2>Set Event Database</h2>';
    $str .= ' <div class="w3-card-2 w3-round w3-white" style="width:50%">';
    $str .= '<header class="w3-container w3-blue-grey"><meta http-equiv="Content-Type" content="text/html; charset=utf-8"> ';
    $str .= '<h3>Current Event Database Selected</h3> ';
    $str .= '</header> ';
    $str .= '<div class="w3-container w3-margin-top"> ';
    $str .= '<img src="images/stars_2.png" alt="Avatar" class="w3-left w3-circle w3-margin-right" style="width:60px">';
    $str .= sprintf '<p>Event: %s</p> ', $EVENT{$location}{TX_EVENT_NAME};
    $str .= sprintf '<p>Year: %s</p> ', $EVENT{$location}{IN_YEAR};
    $str .= sprintf '<p>Type: %s</p> ', $EVENT{$location}{TX_EVENT};
    

    $str .= '</div> ';
    $str .= '</div> ';
    $str .= '</div>';
    
    $str .= '<div class="w3-container w3-padding">';
    $str .= '<br><h2>Set Event Database xxx</h2>';
    $str .= '<fieldset >';
    # $str .= '<legend>Select Applicable Event</legend>';
    $str .= '<ul class="w3-ul w3-white">';
    my $selected = '';
    foreach $eventIDX (sort {lc($EVENT{$b}{TX_EVENT_NAME}) cmp lc($EVENT{$a}{TX_EVENT_NAME})} keys %EVENT) {
        $selected = '';
        if ($eventIDX == $location) {$selected='checked'}
        $str .= '<li class="w3-bar w3-hover-light-blue w3-border">';
        $str .= '<p class="w3-bar-item">';
        $str .= '<input class="w3-check" ID="LOCATION_'.$eventIDX.'" type="radio" name="radio_selectEventLocation" '.$selected.' value="'.$eventIDX.'"  data-value="'.$EVENT{$eventIDX}{TX_EVENT_NAME}.'">&nbsp; ';
        $str .= '<label for="LOCATION_'.$eventIDX.'">'.$EVENT{$eventIDX}{TX_EVENT_NAME}.'</label>';
        $str .= '</p>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    # $str .= '<a class="w3-button w3-border w3-round-large w3-hover-green w3-margin-top w3-pale-green w3-card-4" href="javascript:void(0);" onclick="sae_setEventLocation();">Set Location</a>';
    # $str .= '</div>';

    # $str .= '</fieldset>';
    $str .= '</div>';

    return ($str);
}
# ***********************************************************************************************************************************
# FILE UPLOAD UTILITIES
# ***********************************************************************************************************************************
sub loadEventLocation(){
    print $q->header();
    my $location = $q->param('location');  
    my $dbi = new SAE::Db();
    my 
    $str;
    my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT_NAME FROM TB_EVENT";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    %LOCATION = %{$select->fetchall_hashref('PK_EVENT_IDX')};
    $str .= '<h3><i class="fa fa-upload fa-fw"></i> STARS Upload Utility</h3>';
    $str .= '<label class="w3-medium">Select Target Event for Document Uploads:</label><span class="w3-tooltip">' ;
    $str .= '<Select class="w3-select w3-text-blue" name="EVENT_LOCATION" ID="EVENT_LOCATION" >';
    foreach $eventIDX (sort {lc($LOCATION{$a}{TX_EVENT_NAME}) cmp lc($LOCATION{$b}{TX_EVENT_NAME})} keys %LOCATION) {
        if ($eventIDX == $location) {
            $str .= '<option value="'.$eventIDX.'" selected>'.$LOCATION{$eventIDX}{TX_EVENT_NAME}.'</option>';
        } else {
            $str .= '<option value="'.$eventIDX.'">'.$LOCATION{$eventIDX}{TX_EVENT_NAME}.'</option>';
        }
    }
    $str .= '</Select><br>';
    $str .= '<a style="margin-top: 8px;" href="javascript:void(0);" onclick="expandInstructions(\'UPLOAD_INSTRUCTIONS\');">Instructions</a>';
    $str .= '<div ID="UPLOAD_INSTRUCTIONS" class="w3-medium w3-hide" style="margin-top: 5px;">';
    $str .= '<ol>';
    $str .= '<li>Drag & Drop files to the "[ DRAG & DROP HERE ]" zone.</li>';
    $str .= '<li>Make sure PDF filename has the Team Number in Parenthesis</li>';
    $str .= '<li>Make sure PDF filename has the words "<b>Design_Report</b>" for design reports</li>';
    $str .= '<li>Make sure PDF filename has the words "<b>Drawings</b>" for 2D plan drawings</li>';
    $str .= '<li>Make sure PDF filename has the words "<b>Tech_Data_Sheet</b>" for Technical Data Sheet</li>';
    $str .= '</ol>';
    $str .= '</div>';

    return ($str);
}
# ***********************************************************************************************************************************
#  REPORT JUDGE ASSIGNMENTS
# ***********************************************************************************************************************************
sub sae_removeJudgeFromCard(){
    print $q->header();
    my $cardIDX = $q->param('cardIDX');
    my $teamIDX = $q->param('teamIDX');
    my $inType = $q->param('inType');
    my $txTitle = $q->param('txTitle');
    my $count = $q->param('count');
    my $dbi = new SAE::Db();
    my $SQL = "DELETE FROM TB_CARD WHERE PK_CARD_IDX=?";
    my $delete = $dbi -> prepare($SQL);
    $delete -> execute ($cardIDX);
    my $str = &_templateDetailList_report($inType, $teamIDX, $txTitle, 'w3-white', $count);
    return ($str);
}
sub sae_addSelectedJudgeToTeam(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $inType = $q->param('inType');
    my $teamIDX = $q->param('teamIDX');
    my $userIDX = $q->param('userIDX');
    my $judgePaperCount = $q->param('judgePaperCount');
    my $title = $q->param('title');
    my $userName = $q->param('userName');
    $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX) VALUES(?,?,?,?)";
    my $insert = $dbi -> prepare($SQL);
       $insert->execute($userIDX, $teamIDX, $inType, $location);
    my $str = '<span><b>'.$title.'<b></span><br>';
    $str .= '<span class="w3-medium">'.$userName.'</span>';
    return ($str);
}
sub showAddJudge(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $inType = $q->param('inType');
    my $teamIDX = $q->param('teamIDX');
    my $judgePaperCount = $q->param('judgePaperCount');
    my $title = $q->param('title');

    my $SQL = "SELECT U.PK_USER_IDX, U.BO_EXTRA, U.TX_FIRST_NAME, U.TX_LAST_NAME FROM TB_USER AS U JOIN TB_PREF AS P ON U.PK_USER_IDX=P.FK_USER_IDX WHERE (P.FK_EVENT_IDX=? AND BO_EXTRA=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($location, 1);
    %USERS = %{$select->fetchall_hashref('PK_USER_IDX')};
    @JUDGES = sort {$a <=> $b} keys %USERS;
    
    $SQL = "SELECT FK_USER_IDX FROM TB_CARD WHERE FK_CARDTYPE_IDX=? AND FK_TEAM_IDX=?";
      $select = $dbi->prepare($SQL);
      $select->execute($inType, $teamIDX);
    while ($userIDX = $select->fetchrow_array()) {
        delete $USERS{$userIDX};
     }
    my $str = $title.'<br><select ID="judgeSelectionForSlot_'.$judgePaperCount.'" class="w3-select w3-border" style="width: 60%;">';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $str .= '<option value="'.$userIDX.'">'.$USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME}.'</option>';
    }
    $str .= '</select>';
    $str .= '<button class="w3-button w3-border w3-green" onClick="sae_addSelectedJudgeToTeam('.$inType.','.$teamIDX.','.$judgePaperCount.',\''.$title.'\');">Add</button>';
    $str .= '&nbsp;&nbsp;<button class="w3-button w3-border w3-hover-orange" onclick="cancel_ShowAddJudge('.$inType.','.$judgePaperCount.');">Cancel</button>';
    return ($str);
}
sub openAssignmentDetails(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.FK_CARDTYPE_IDX, CARD.FK_USER_IDX, CARD.IN_STATUS, TYPE.TX_TITLE, TYPE.IN_ORDER, USER.TX_FIRST_NAME, USER.TX_LAST_NAME FROM TB_CARD AS CARD 
        JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX 
        JOIN TB_CARDTYPE AS TYPE ON CARD.FK_CARDTYPE_IDX=TYPE.PK_CARDTYPE_IDX WHERE FK_TEAM_IDX=?";
    my $select = $dbi -> prepare($SQL);
       $select -> execute($teamIDX);
    %TEAMS = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','PK_CARD_IDX'])};
    
    $SQL = "SELECT * FROM TB_CARDTYPE WHERE PK_CARDTYPE_IDX<?";
    $select = $dbi -> prepare($SQL);
    $select -> execute(5);
    %TITLE = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')};
    my %STATUS = (0=>"To Do", 1=>"Draft", 2=>"Done");
    my %W3CLASS = (1=>"w3-yellow", 2=>"w3-light-blue");
    my $str = '<div class="w3-container">';
    $str .= '<center><button class="w3-card-2 w3-button w3-border" onclick="openAssignmentDetails_fill('.$teamIDX.');"><span class="fa fa-refresh fa-fw"></span>&nbsp; Reload List</button></center><br>';
    $str .= '<ul ID="PaperAssignmentDetailsList" class="w3-ul w3-card-2">';
    my $count = 0;
    foreach $inType (sort {$a <=> $b} keys %TITLE) {
        $JudgeCount = scalar (keys %{$TEAMS{$inType}});
        my $txTitle =  $TITLE{$inType}{TX_TITLE};
        
        foreach $cardIDX (sort keys %{$TEAMS{$inType}}){
            $count++;
            $inStatus = $TEAMS{$inType}{$cardIDX}{IN_STATUS};
            
            my $w3Class = $W3CLASS{$inStatus};
            $str .= '<li class="w3-bar inType_'.$inType.' '.$W3CLASS{$inStatus}.'">';
            if ($inStatus<2){
                $str .= '<span onclick="sae_removeJudgeFromCard(this, '.$cardIDX.', '.$teamIDX.','.$inType.', \''.$txTitle.'\','.$count.');" class="w3-bar-item w3-button w3-transparent w3-large w3-right">X</span>';    
            }
            $str .= '<img src="images/Student.png" class="w3-bar-item w3-circle w3-hide-small" style="width:65px">';
            $str .= '<div class="w3-bar-item">';
            $str .= '<span><b>'.$TEAMS{$inType}{$cardIDX}{TX_TITLE}.'</b></span><br>';
            $str .= '<span class="w3-medium">'.$TEAMS{$inType}{$cardIDX}{TX_LAST_NAME}.', '.$TEAMS{$inType}{$cardIDX}{TX_FIRST_NAME}.'</span>';
            $str .= '</div>';
            $str .= '</li>';
        }
        $judgePaperCount = $JudgeCount;
        if ($inType == 1 && $JudgeCount<3) {
            until ($judgePaperCount==3) {
                $str .= &_templateDetailList_report($inType, $teamIDX, $txTitle, $W3CLASS{0}, $judgePaperCount);
                $judgePaperCount++;
            }
        } elsif ($inType > 1 && $JudgeCount<1) {
            until ($judgePaperCount==1) {
                $str .= &_templateDetailList_report($inType, $teamIDX, $txTitle, $W3CLASS{0}, $judgePaperCount);
                $judgePaperCount++;
            }
        }
    }
    $str .= '</ul>';
    return ($str);
}
sub _templateDetailList_report(){
    my $inType = shift;
    my $teamIDX = shift;
    my $title = shift;
    my $w3Class = shift;
    my $judgePaperCount = shift;
    my $str = '<li class="w3-bar inType_'.$inType.' '.$w3Class.'" >';
    $str .= '<span ID="cardDeleteControl_'.$inType.'_'.$judgePaperCount.'" onclick="$(this).parent().hide();" style="display: none;" data-key="0" class="w3-bar-item w3-button w3-white w3-medium w3-right">X</span>';
    $str .= '<img src="images/Student.png" class="w3-bar-item w3-circle w3-hide-small" style="width:65px">';
    $str .= '<button class="w3-button" style="width: 310px;" ID="button_'.$inType.'_'.$judgePaperCount.'" onclick="showAddJudge('.$inType.','.$teamIDX.','.$judgePaperCount.',\''.$title.'\');">Add A '.$title.' Assessment Judge</button><br>';
    $str .= '<div ID="judgeSlot_'.$inType.'_'.$judgePaperCount.'" class="w3-bar-item">';
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub sae_unassginSelectedJudge(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $inType = $q->param('inType');
    my $userIDX = $q->param('userIDX');
    my @LIST = split(",",$list=$q->param('list'));
    my $list = join(",",@LIST);
    my $SQL = "SELECT PK_TEAM_IDX FROM TB_TEAM WHERE ((FK_EVENT_IDX=?) AND (FK_CLASS_IDX in ($list)))";
    my $select = $dbi -> prepare($SQL);
       $select -> execute($location);
    %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    $SQL = "DELETE FROM TB_CARD WHERE ((FK_TEAM_IDX=?) AND (FK_USER_IDX=?) AND (FK_CARDTYPE_IDX=?) AND (FK_EVENT_IDX=?))";
    my $delete = $dbi->prepare($SQL);
    foreach $teamIDX (sort keys %TEAMS) {
        $delete->execute($teamIDX, $userIDX, $inType, $location);
    }
    return;
}
sub assignBatchToJudge(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $location = $q->param('location');
    my $inType = $q->param('inType');
    my $userIDX = $q->param('userIDX');
    my @LIST = split(",",$list=$q->param('list'));
    my $list = join(",",@LIST);
    my $SQL = "SELECT PK_TEAM_IDX FROM TB_TEAM WHERE ((FK_EVENT_IDX=?) AND (FK_CLASS_IDX in ($list)))";
    my $select = $dbi -> prepare($SQL);
       $select -> execute($location);
    %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    $SQL = "SELECT PK_CARD_IDX, FK_TEAM_IDX FK_TEAM_IDX FROM TB_CARD WHERE ((FK_CARDTYPE_IDX=?) AND (FK_EVENT_IDX=?))";
        $select = $dbi -> prepare($SQL);
        $select -> execute($inType, $location);
    %CARDS = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX) VALUES(?,?,?,?)";
    my $insert = $dbi -> prepare($SQL);
    
    foreach $teamIDX (sort {$a <=> $b} keys %TEAMS){
        if (exists $CARDS{$teamIDX}){next}
        $insert -> execute($userIDX, $teamIDX, $inType, $location);
        print "$userIDX, $teamIDX, $inType, $location \n";
    }
    # return;
    return (join(", ",sort {$a<=>$b} keys %TEAMS));
}
sub loadBatchAssign(){
    print $q->header();
    my $location = $q->param('location');
    my $inType = $q->param('inType');
    my $Auto = new SAE::AUTO();
    my %USERS = %{$Auto->_getAllJudges($location)};
    
    my $str;
    # $str .= '<h6></h6>';
    $str .= '<fieldset>';
    $str .= '<legend>Select Applicable Class(es)</legend>';
    $str .= '<input class="w3-check sae_selectedClass" ID="class_1" type="checkbox" value="1">&nbsp; <label for="class_1">Regular Class</label><br>';
    $str .= '<input class="w3-check sae_selectedClass" ID="class_2" type="checkbox" value="2">&nbsp; <label for="class_2">Advanced Class</label><br>';
    $str .= '<input class="w3-check sae_selectedClass" ID="class_3" type="checkbox" value="3">&nbsp; <label for="class_3">Micro Class</label><br>';
    $str .= '</fieldset>';
    
    # $str .= '<hr>';
    $str .= '<fieldset>';
    $str .= '<legend>Select a Judge</legend>';
    $str .= '<select ID="selectedUserIDX" class="w3-select w3-border">';
    $str .= '<option value="0">- Select a Judge -</option>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $str .= '<option value="'.$userIDX.'">'.$USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME}.'</option>';    
    }
    $str .= '</select>';
    $str .= '</fieldset>';
    $str .= '<center class="w3-margin-top">';
    $str .= '<button class="w3-button w3-border w3-card-2 w3-round w3-margin-left" onclick="assignBatchToJudge('.$inType.');">Assign</button>';
    $str .= '<button class="w3-button w3-border w3-card-2 w3-round w3-margin-left" onclick="$(\'#TEMP_ASSIGN_BATCH_1\').remove();">Cancel</button>';
    $str .= '<button class="w3-button w3-border w3-card-2 w3-round w3-display-bottomright w3-margin-right w3-margin-bottom" onclick="sae_unassginSelectedJudge('.$inType.');">UnAssign</button>';
    $str .= '</center>';
    
    
    return ($str);
}
sub loadAutoAssignPapers(){
    print $q->header();
    my $location = $q->param('location');
    # return ($location);
    my $dbi = new SAE::Db();
    my $Auto = new SAE::AUTO();
    $Auto->_getAvailableJudges($location);
    my %DATA;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.FK_USER_IDX, CARD.FK_TEAM_IDX, USER.TX_FIRST_NAME, USER.TX_LAST_NAME 
        FROM TB_CARD AS CARD 
        JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX 
        WHERE (FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=?)";
    my $select = $dbi -> prepare($SQL);
      $select -> execute(1, $location);
    while (my ($cardIDX, $userIDX, $teamIDX, $txFirst, $txLast) = $select->fetchrow_array()){
        push (@$teamIDX, "<img src='images/Student.png' class='w3-left w3-circle w3-margin-right' style='width:20px;'>");
        $HASH{$teamIDX}=1;
        # $DATA{$teamIDX} .= '<img src="images/Student.png" alt="Avatar" class="w3-left w3-circle w3-margin-right" style="width:20px">';
        # $DATA{$teamIDX} .= $userIDX.",";
    }
    foreach $teamIDX (sort keys %HASH){
        $DATA{$teamIDX} = join(" ",@$teamIDX);
    }
    my $json = encode_json \%DATA;
    return ($json);
}
sub sae_updateDaysLate(){
    print $q->header();
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $inDays = $q->param('inDays');
    my $boLate = $q->param('boLate');
    my $Ref = new SAE::REFERENCE();
    if ($boLate == 0){
        $Ref->_createLateReports($teamIDX, $inDays, $location);
    } else {
        $Ref->_updateLateReports($teamIDX, $inDays);
    }
    my $str;
    $str = sprintf '<a href="javascript:void(0);" onclick="sae_updateDaysLate(this, %2d, %2d, %1d);">%2d</a>',$teamIDX, $inDays, $boLate, $inDays;
    return($str);
}
sub sae_addTeamToCurrentJudge(){
    print $q->header();
    my $Card = new SAE::CARD();
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $inType = $q->param('inType');
    my $teamIDX = $q->param('teamIDX');
    my $title = $q->param('txSchool');
    my $cardIDX = $Card->_createANewCard($userIDX, $teamIDX, $inType, $location);
    my $str;
    $str = '<li class="w3-display-container">'.$title.'<span onclick="this.parentElement.style.display=\'none\';  sae_deleteThisCardFromJudge('.$cardIDX.', this, '.$inType.');" data-key="'.$teamIDX.'" data-text="'.$title.'" class="w3-button w3-transparent w3-display-right">X</span> </li>';
    return ($str);
}
sub openJudgeAssignmentDetails(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $Ref = new SAE::REFERENCE();
    %TITLE = %{$Ref->_getCardTypeList()};
    %CARDS = %{$Ref->_getListOfAssignedCards($location , $userIDX)};
    %TEAMS = %{$Ref->_getListOfTeamsByEventId($location)};
    foreach $inType (sort keys %TITLE) {
        if ($inType>4){last}
        $str .= '<ul ID="listOfTeamsAssignedToJudge_'.$inType.'" class="w3-ul w3-card-2" style="max-height: 600px; overflow: auto;">';  
        $str .= '<h3 style="padding: 0px 10px; margin: 0px;">'.$TITLE{$inType}{TX_TITLE}.'</h3>';
        foreach $teamIDX (sort {$CARDS{$inType}{$a}{IN_NUMBER} <=> $CARDS{$inType}{$b}{IN_NUMBER}} keys %{$CARDS{$inType}}) {
            $cardIDX = $CARDS{$inType}{$teamIDX}{PK_CARD_IDX};
            $title = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)."-".$TEAMS{$teamIDX}{TX_SCHOOL};
            $str .= '<li class="w3-display-container">'.$title;
            $str .= '<span onclick="this.parentElement.style.display=\'none\'; sae_deleteThisCardFromJudge('.$cardIDX.', this, '.$inType.');" ';
            $str .= 'data-key="'.$teamIDX.'" data-text="'.$title.'" ';
            $str .= 'class="w3-button w3-transparent w3-display-right">X</span> ';
            $str .= '</li>';
        }
        my %AVAIL = %{$Ref->_getAvailableAssessments($inType, $location)};
        $str .= '<li class="w3-light-grey">';
        $str .= '<select ID="selectTeamToAdd_'.$inType.'" class="w3-select" onchange="sae_addTeamToCurrentJudge('.$inType.','.$userIDX.');">';
        if (scalar(keys %AVAIL)>0){
            $str .= '<option> - Add - </option>';
        } else {
            $str .= '<option> - No More Available - </option>';
        }
        
        foreach $teamIDX (sort {$a<=>$b} keys %AVAIL) {
            $title = substr("000".$AVAIL{$teamIDX}{IN_NUMBER},-3,3)." - ".$AVAIL{$teamIDX}{TX_SCHOOL};
            $str .= '<option value="'.$teamIDX.'">'.$title.'</option>';
        }
        $str .= '</select>';
        $str .= '</li>';
        $str .= '</ul><br>';
    }
    $str .= '</div>';
    return ($str);
}
sub openManagePapers(){
    print $q->header();
    my $str;
    $str .= '<div class="w3-container w3-margin-top w3-padding" >';
    $str .= '<h2>Manage Papers</h2>';
    $str .= '<div class="w3-row" style="width: 100%" >';
    $str .= '<a href="javascript:void(0);" onclick="sae_openTeamView(this);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding w3-border-red" style="width: 20%;">Team View</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openJudgeView(this);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Judge View</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openStatView(this, 1);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Judge Statistics</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openStatTeamView(this, 1);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Team Statistics</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_openStatBreakdown(this);"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Stats Breakdown</div></a>';
    # $str .= '<a href="javascript:void(0);" onclick="alert(\'Under Construction\')"><div class="w3-col tablink w3-bottombar w3-hover-light-grey w3-padding" style="width: 20%;">Class Statistics</div></a>';
    # $str .= '<button class="w3-bar-item w3-button sae-tabs w3-light-blue" onclick="sae_openTeamView(this);">Team View</button>';
    # $str .= '<button class="w3-bar-item w3-button sae-tabs " onclick="sae_openJudgeView(this);">Judges View</button>';
    $str .= '</div>';
    $str .= '<div ID="paperContentContainer" class="w3-margin-top" style="height: auto; overflow: auto;">';
    $str .= &_templateTeamView();
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_openStatTeamView(){
    print $q->header();
    my $str = &_templateStatTeamView();
    return ($str);
}
sub sae_openStatView(){
    print $q->header();
    my $str = &_templateStatJudgeView();
    return ($str);
}
sub sae_openJudgeView(){
    print $q->header();
    my $str = &_templateJudgeView();
    return ($str);
}
sub sae_openTeamView(){
    print $q->header();
    my $str = &_templateTeamView();
    return ($str);
}
sub sae_loadBreakdownViewContent(){
    print $q->header();
    my $str = &_templateBreakdownView();
    return ($str);
}

sub _templateBreakdownView(){
    my $location = $q->param('location');
    my $Card = new SAE::CARD();
    my %QUEST = %{$Card->_getQuestionLists()};
    my %STAT = %{$Card->_getQuestionBreakdownStatistics($location, 1)};
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<h3>Breakdown by Report Section/Subsection</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-blue-grey">';
    $str .= '<th style="width: 5%;">Section</th>';
    $str .= '<th style="width: 35%;">Title</th>';
    $str .= '<th style="width: 10%; text-align: right;">Min</th>';
    $str .= '<th style="width: 10%; text-align: right;">Max</th>';
    $str .= '<th style="width: 10%; text-align: right;">Std. Dev.</th>';
    $str .= '<th style="width: 10%; text-align: right;">CoV</th>';
    $str .= '<th style="width: 10%; text-align: right;">Median</th>';
    $str .= '<th style="width: 10%; text-align: right;">Mean</th>';
    $str .= '</tr>';
    foreach $inSection (sort {$a<=>$b} keys %QUEST){
        foreach $inSubSection (sort {$a<=>$b} keys %{$QUEST{$inSection}} ) {
            my $pkSubSectionIDX = $QUEST{$inSection}{$inSubSection}{PK_SUBSECTION_IDX};
            $str .= '<tr>';
            $str .= sprintf '<td>%d.%d</td>', $inSection, $inSubSection;
            $str .= sprintf '<td><b>%s</b>: %s</td>', $QUEST{$inSection}{$inSubSection}{TX_SECTION}, $QUEST{$inSection}{$inSubSection}{TX_SUBSECTION};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$pkSubSectionIDX}{IN_MIN};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$pkSubSectionIDX}{IN_MAX};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$pkSubSectionIDX}{IN_STD};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$pkSubSectionIDX}{IN_COV};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$pkSubSectionIDX}{IN_MED};
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$pkSubSectionIDX}{IN_AVG};
            $str .= '</tr>';
        }
    }
    return ($str);
}
sub sae_openJudgeStatsByTeam(){
       print $q->header();
    my $Card = new SAE::CARD();
    my $teamIDX = $q->param('teamIDX');
    my $cardTypeIDX = $q->param('cardTypeIDX');
    my $location= $q->param('location');
    my %USERS= %{$Card->_getReportStatisticStatusByTeam_2($cardTypeIDX, $teamIDX)};
    my $str;
    $str = '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th style="width: 30%;">Judge</th>';
    $str .= '<th style="width: 10%; text-align: right;">Experience</th>';
    $str .= '<th style="width: 10%; text-align: right;">Min</th>';
    $str .= '<th style="width: 10%; text-align: right;">Max</th>';
    $str .= '<th style="width: 10%; text-align: right;">Std. Dev.</th>';
    $str .= '<th style="width: 10%; text-align: right;">CoV</th>';
    $str .= '<th style="width: 10%; text-align: right;">Median</th>';
    $str .= '<th style="width: 10%; text-align: right;">Mean</th>';
    $str .= '</tr>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS){
        if ($userIDX>0){
            $str .= '<tr>';
            $str .= sprintf '<td>%s, %s</td>', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
            $str .= sprintf '<td style="text-align: right;">%s</td>', $USERS{$userIDX}{TX_YEAR};
            $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $USERS{$userIDX}{IN_MIN};
            $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $USERS{$userIDX}{IN_MAX};
            $str .= sprintf '<td style="text-align: right;">%2.4f%</td>', $USERS{$userIDX}{IN_STD};
            $str .= sprintf '<td style="text-align: right;">%2.4f%</td>', $USERS{$userIDX}{IN_COV};
            $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $USERS{$userIDX}{IN_MED};
            $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $USERS{$userIDX}{IN_AVG};
            $str .= '</tr>';
        }
    }
    $str .= '</table>';
    return ($str);
}
sub sae_openTeamStatsByJudge(){
    print $q->header();
    my $Card = new SAE::CARD();
    my $userIDX = $q->param('userIDX');
    my $cardTypeIDX = $q->param('cardTypeIDX');
    my $location= $q->param('location');
    my %TEAMS = %{$Card->_getReportStatisticStatusByJudge($cardTypeIDX, $userIDX)};
    my $str;
    $str = '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th style="width: 35%;">Team #/School</th>';
    $str .= '<th style="width: 5%;">Year</th>';
    $str .= '<th style="width: 10%; text-align: right;">Min</th>';
    $str .= '<th style="width: 10%; text-align: right;">Max</th>';
    $str .= '<th style="width: 10%; text-align: right;">Std. Dev.</th>';
    $str .= '<th style="width: 10%; text-align: right;">CoV</th>';
    $str .= '<th style="width: 10%; text-align: right;">Median</th>';
    $str .= '<th style="width: 10%; text-align: right;">Mean</th>';
    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        my $eIDX = crypt($teamIDX, '20');
        $str .= '<tr>';
        $str .= sprintf '<td><a  class="w3-link" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">%03d - %s</a></td>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $TEAMS{$teamIDX}{IN_YEAR};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $TEAMS{$teamIDX}{IN_MIN};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $TEAMS{$teamIDX}{IN_MAX};
        $str .= sprintf '<td style="text-align: right;">%2.4f%</td>', $TEAMS{$teamIDX}{IN_STD};
        $str .= sprintf '<td style="text-align: right;">%2.4f%</td>', $TEAMS{$teamIDX}{IN_COV};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $TEAMS{$teamIDX}{IN_MED};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $TEAMS{$teamIDX}{IN_AVG};
        $str .= '</tr>';
    }

    $str .= '</table>';
    return ($str);
}
sub _templateStatTeamView(){
    my $location = $q->param('location');
    my $sortBy = $q->param('sortBy');
    my $Card = new SAE::CARD();
    my $Ref = new SAE::REFERENCE();
    %TEAMS = %{$Ref->_getTeamDataByEvent($location)};
    my %STAT = %{$Card->_getTeamStatisticsByEvent(1, $location)};
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-blue-grey">';
    $str .= '<th style="width: 40%;"><a class="w3-text-white" href="javascript:void(0);" onclick="sae_loadStatTeamViewContent(1);">Team #/School</a></th>';
    $str .= '<th style="width: 10%; text-align: right;">Min</th>';
    $str .= '<th style="width: 10%; text-align: right;">Max</th>';
    $str .= '<th style="width: 10%; text-align: right;"><a class="w3-text-white" href="javascript:void(0);" onclick="sae_loadStatTeamViewContent(4);">Std. Dev.</a></th>';
    $str .= '<th style="width: 10%; text-align: right;">CoV</th>';
    $str .= '<th style="width: 10%; text-align: right;">Median</th>';
    $str .= '<th style="width: 10%; text-align: right;"><a class="w3-text-white" href="javascript:void(0);" onclick="sae_loadStatTeamViewContent(7);">Mean</a></th>';
    $str .= '</tr>';
    my @ORDER = ();
    if ($sortBy == 4){
        @ORDER = sort {$STAT{$b}{IN_STD} <=> $STAT{$a}{IN_STD}} keys %STAT;
    } elsif ($sortBy == 7) {
        @ORDER = sort {$STAT{$a}{IN_AVG} <=> $STAT{$b}{IN_AVG}} keys %STAT;
     }else {
         @ORDER = sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS;
    }
    foreach $teamIDX (@ORDER) {
        if ($teamIDX==0){next}
    # foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $eIDX = crypt($teamIDX, '20');
        $str .= '<tr>';
        if ($STAT{$teamIDX}{IN_AVG}>0){
            $str .= sprintf '<td><a class="w3-link" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">%03d - %s</a></td>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        } else {
            $str .= sprintf '<td>%03d - %s ('.$teamIDX.')</td>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        }
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $STAT{$teamIDX}{IN_MIN};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $STAT{$teamIDX}{IN_MAX};
        if ($STAT{$teamIDX}{IN_AVG}>0){
            $str .= sprintf '<td style="text-align: right;"><a href="javascript:void(0);" onclick="sae_openJudgeStatsByTeam('.$teamIDX.',1)">%2.4f</a></td>', $STAT{$teamIDX}{IN_STD};
        } else {
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$teamIDX}{IN_STD};
        }
        
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $STAT{$teamIDX}{IN_COV};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $STAT{$teamIDX}{IN_MED};
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', $STAT{$teamIDX}{IN_AVG};
        $str .= '</tr>';
    }
    $str .= '</table>';
        my $hdr = '<div class="w3-card w3-white w3-padding w3-margin w3-small">';
        $hdr .= sprintf '<h3>Summary  from the observed values of the sample</h3>';
        $hdr .= sprintf 'Population Size = %2.1f<br>', $STAT{0}{IN_COUNT};
        $hdr .= sprintf 'Degree of Freedom = %2.1f<br>', $STAT{0}{IN_DOF};
        $hdr .= sprintf 'Mean = %2.4f<br>', $STAT{0}{IN_MEAN};
        $hdr .= sprintf 'Upper Limit = %2.4f<br>', $STAT{0}{IN_UPPER};
        $hdr .= sprintf 'Lower Limit = %2.4f<br>', $STAT{0}{IN_LOWER};
        $hdr .= sprintf 'Variance = %2.4f<br>', $STAT{0}{IN_VAR};
        $hdr .= sprintf 'Standard Deviation = %2.4f<br>', $STAT{0}{IN_STDDEV};
        $hdr .= sprintf 'Standard Error = %2.4f<br>', $STAT{0}{IN_ERROR};
        $hdr .= sprintf 'the estimate of the mean is = %2.4f +/- %2.4f<br>', $STAT{0}{IN_MEAN}, $STAT{0}{IN_DELTA};
        $hdr .= sprintf 'Confidence Level = %2.2f%<br>', $STAT{0}{IN_CONFI};
        $hdr .= sprintf 'T-Statistics = %2.4f<br>', $STAT{0}{IN_TSTAT};
        $hdr .= sprintf 'Prob >|T|= %2.4f<br>', $STAT{0}{IN_PROB};
        $hdr .= '</div>';
    
    
    $str .= '</div>';
    
    return ($hdr.$str);
}
sub _templateStatJudgeView(){
    my $Card = new SAE::CARD();
    my $location = $q->param('location');
    my $sortBy = $q->param('sortBy');
    my %TYPE = (1=>'Design Report', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    my %CLASS = (1=>'Regular',2=>'Advanced',3=>'Micro');
    my %USERS = %{$Card->_getListOfJudges($location)};

    my $str;
    # my $str = 'Sory By:'.$sortBy;
    $str .= '<div class="w3-container">';
    foreach $typeIDX (sort keys %TYPE) {
    # $typeIDX = 2;
        my %STAT = %{$Card->_getReportStatisticStatusByEvent($typeIDX, $location)};
        $str .= '<h4>'.$TYPE{$typeIDX}.': Statistics</h4>';
        
        $str .= '<div class="w3-card w3-white w3-padding w3-margin w3-small">';
        $str .= sprintf '<h3>Summary  from the observed values of the sample</h3>';
        $str .= sprintf 'Population Size = %2.1f<br>', $STAT{$typeIDX}{IN_COUNT};
        $str .= sprintf 'Degree of Freedom = %2.1f<br>', $STAT{$typeIDX}{IN_DOF};
        $str .= sprintf 'Mean = %2.4f<br>', $STAT{$typeIDX}{IN_MEAN};
        $str .= sprintf 'Upper Limit = %2.4f<br>', $STAT{$typeIDX}{IN_UPPER};
        $str .= sprintf 'Lower Limit = %2.4f<br>', $STAT{$typeIDX}{IN_LOWER};
        $str .= sprintf 'Variance = %2.4f<br>', $STAT{$typeIDX}{IN_VAR};
        $str .= sprintf 'Standard Deviation = %2.4f<br>', $STAT{$typeIDX}{IN_STDDEV};
        $str .= sprintf 'Standard Error = %2.4f<br>', $STAT{$typeIDX}{IN_ERROR};
        $str .= sprintf 'the estimate of the mean is = %2.4f +/- %2.4f<br>', $STAT{$typeIDX}{IN_MEAN}, $STAT{$typeIDX}{IN_DELTA};
        $str .= sprintf 'Confidence Level = %2.2f%<br>', $STAT{$typeIDX}{IN_CONFI};
        $str .= sprintf 'T-Statistics = %2.4f<br>', $STAT{$typeIDX}{IN_TSTAT};
        $str .= sprintf 'Prob >|T|= %2.4f<br>', $STAT{$typeIDX}{IN_PROB};
        $str .= '</div>';
        
        $str .= '<table class="w3-table-all w3-small">';
        $str .= '<tr class="w3-blue-grey w3-hide-small">';
        $str .= '<th style="width: 30%;"><a class="w3-text-white" href="javascript:void(0);" onclick="sae_loadStatViewContent(1);">Judge</a></th>';
        $str .= '<th style="width: 10%;">Experience</th>';
        $str .= '<th style="width: 10%;">Min</th>';
        $str .= '<th style="width: 10%;">Max</th>';
        $str .= '<th style="width: 10%;"><a class="w3-text-white" href="javascript:void(0);" onclick="sae_loadStatViewContent(4);">Std. Dev.</a></th>';
        $str .= '<th style="width: 10%;">CoV</th>';
        $str .= '<th style="width: 10%;">Median</th>';
        $str .= '<th style="width: 10%;">Mean</th>';
        $str .= '</tr>';
        my @ORDER = ();
        if ($sortBy == 4){
            @ORDER = sort {$STAT{$b}{IN_STD} <=> $STAT{$a}{IN_STD}} keys %STAT;
        }else {
            @ORDER = sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS;
        }
        foreach $userIDX (@ORDER) {
            if ($userIDX==1){next}
        # foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
            $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
            if ($STAT{$userIDX}{IN_AVG}<=0){next}
            $str .= '<tr class="w3-hide-small">';    
            $str .= sprintf '<td>%s (%d)</td>',  $userName, $userIDX;
            $str .= sprintf '<td>%s</td>', $USERS{$userIDX}{TX_YEAR};
            $str .= sprintf '<td>%2.2f%</td>', $STAT{$userIDX}{IN_MIN};
            $str .= sprintf '<td>%2.2f%</td>', $STAT{$userIDX}{IN_MAX};
            $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_openTeamStatsByJudge('.$userIDX.', '.$typeIDX.');">%2.4f</a></td>', $STAT{$userIDX}{IN_STD};
            $str .= sprintf '<td>%2.4f</td>', $STAT{$userIDX}{IN_COV};
            $str .= sprintf '<td>%2.2f%</td>', $STAT{$userIDX}{IN_MED};
            $str .= sprintf '<td>%2.2f%</td>', $STAT{$userIDX}{IN_AVG};
            $str .= '</tr>';    
            $str .= '<tr></tr>';
            $str .= '<tr class="w3-hide-medium w3-hide-large">';
            $str .= '<td>';
            $str .= sprintf '<b>%s</b><br>', $userName;
            $str .= sprintf '<b>Min</b><span class="w3-margin-left">%2.4f</span><br>', $STAT{$userIDX}{IN_MIN};
            $str .= sprintf '<b>Max</b><span class="w3-margin-left">%2.4f</span><br>', $STAT{$userIDX}{IN_MAX};
            $str .= sprintf '<b>Std. Dev</b><span class="w3-margin-left">%2.4f</span><br>', $STAT{$userIDX}{IN_STD};
            $str .= sprintf '<b>Coeff. of Var.</b><span class="w3-margin-left">%2.4f</span><br>', $STAT{$userIDX}{IN_COV};
            $str .= sprintf '<b>Median</b><span class="w3-margin-left">%2.4f</span><br>', $STAT{$userIDX}{IN_MED};
            $str .= sprintf '<b>Mean</b><span class="w3-margin-left">%2.4f</span><br>', $STAT{$userIDX}{IN_AVG};
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '<tr class="w3-medium w3-hide-small w3-light-grey">';    
        $str .= sprintf '<td colspan="2">Overall</td>';
        $str .= sprintf '<td><b>%2.2f%</b></td>', $STAT{$typeIDX}{IN_MIN};
        $str .= sprintf '<td><b>%2.2f%</b></td>', $STAT{$typeIDX}{IN_MAX};
        $str .= sprintf '<td><b>%2.4f</b> </td>', $STAT{$typeIDX}{IN_STDDEV};
        $str .= sprintf '<td><b>%2.4f</b> </td>', $STAT{$typeIDX}{IN_COV};
        $str .= sprintf '<td><b>%2.2f%</b></td>', $STAT{$typeIDX}{IN_MED};
        $str .= sprintf '<td><b>%2.2f%</b></td>', $STAT{$typeIDX}{IN_AVG};
        $str .= '</tr>';
        $str .= '</table>';
        
        $str .= '</div>';
        %STAT = ();
    }
    $str .= '</div>';
    return ($str);
    # return ($hdr.$str);
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
    $str .= '<th style="width: 15%">TDS</th>';
    $str .= '<th style="width: 15%">Drawings</th>';
    $str .= '<th style="width: 15%">Requirements</th>';
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

sub _templateStatusButton(){
    my ($teamIDX, $w3Status, $inNUmber, $cardIDX, $classIDX, $inType) = @_;
    my $eIDX = crypt($teamIDX, '20');
    my $str;
    $str .= '<div class="w3-card w3-third w3-round w3-margin-right w3-border" style="margin-bottom: 4px;">';
    $str .= sprintf '<header class="w3-container %s w3-medium w3-border">#%03d</header>', $w3Status, $inNumber;
    $str .= '<p class="w3-display-container" style="height:30px; padding: 5px;">';
    $str .= '<i class="w3-display-left fa fa-pencil-square-o fa-lg" style="margin-left: 6px; cursor: pointer; " onclick="openAssessment('.$cardIDX.',\''.$inNumber.'\','.$classIDX.','.$teamIDX .','.$inType.', 3);"></i>';
    $str .= '<a class="w3-text-black" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank"><i class="w3-display-right fa fa-search fa-lg " style="margin-right: 6px; cursor: pointer;" aria-hidden="true"></i></a>';
    $str .= '</p>';
    $str .= '</div>';
    # $str = sprintf '<a class="w3-padding-small w3-button w3-border '.$w3Status.' w3-round w3-margin-right" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">#%03d</a>', $inNumber;
    
    return ($str);
}

sub sae_batchRemoveDesignReportJudges(){
    print $q->header();
    my $location = $q->param('location');
    my $inStatus = 0;
    my $Ref = new SAE::REFERENCE();
    $Ref->_removeAssignedJudgesByStatus($inStatus, $location);
    return;
}
sub sae_loadTeamsToAssign(){
    print $q->header();
    my $classIDX = $q->param('classIDX');
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    
    my $divName = $q->param('divName');
    my $Card = new SAE::CARD();
    my %TEAMS = %{$Card->_getAvailableTeamsByClass($classIDX, $location, 1)};
    my $str;
    $str .= '<div class="w3-container" style="height: 450px; overflow: auto;">';
    $str .= '<h3>Available Teams</h3>';
    $str .= '<ul class="w3-ul w3-card-2">';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        $str .= '<li class="w3-bar w3-container" style="padding: 0px;">';
        
        $str .= sprintf '<span class="w3-left w3-button" onclick="sae_addSelectedPreference(this, %1d, %1d);">+</span>', $userIDX, $teamIDX;
        $str .= sprintf '<span class="w3-bar-item">%03d - %s</span>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';
    
    
    return ($str);
}
sub sae_addSelectedPreference(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my $Card = new SAE::CARD();
    my $cardIDX = $Card->_createANewCard($userIDX, $teamIDX, 1, $location);
    return;
}
# ***********************************************************************************************************************************
#  MANAGE USERS
# ***********************************************************************************************************************************
sub sae_addUserToGroup(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $userIDX = $q->param('userIDX');
    my $groupIDX = $q->param('groupIDX');
    my $userName = $q->param('userName');
    my $Auth = new SAE::Auth();
    $Auth->_updateUserGroup($groupIDX, $userIDX);
    
    my $SQL = "DELETE FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $delete = $dbi->prepare($SQL);
    $delete->execute($userIDX);

    $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) 
        SELECT FK_TILES_IDX, $userIDX FROM TB_GROUP_ACCESS WHERE FK_GROUP_IDX=?";
    my $insert = $dbi->prepare($SQL); 
        $insert->execute($groupIDX);
    my $str = &_tempMemberList($userName, $userIDX, $groupIDX);
}
sub sae_removeUserFromGroup(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $dbi = new SAE::Db();
    my $Auth = new SAE::Auth();
    $Auth->_updateUserGroup(0, $userIDX );
    my $SQL = "DELETE FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $delete = $dbi->prepare($SQL);
    $delete->execute($userIDX);
}
sub sae_openAddMemberToGroup(){
    print $q->header();
    my $groupIDX = $q->param('groupIDX');
    my $Ref = new SAE::REFERENCE();
    %USERS = %{$Ref->_getGroupMembership(0)};
    my $str;
    my @ALPHA = ('A'..'Z');
    $str .= '<div class="w3-small" style="padding-bottom: 8px; text-align: cetner">';
    foreach $letter (sort {$a cmp $b} @ALPHA) {
        $str .= '<a style="margin-left: 6px;" href="#letter-'.$letter.'">'.$letter.'</a>';
    }
    $str .= '</div>';
    # $str .= join(" - ", sort {$a cmp $b} @ALPHA);
    $str .= '<div id="containerList" class="w3-container w3-border " style="height: 600px; overflow: auto;">';
    
    $str .= '<ul class="w3-ul">';
    my $header = "";
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})}keys %USERS) {
        my $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        $head = uc(substr($USERS{$userIDX}{TX_LAST_NAME},0,1));
        if ($head ne $header){
            $header = $head;
            $str .= '<li class="w3-grey" id="letter-'.$header.'">'.$header.'</li>';
        }
        $str .= '<li class="w3-display-container">';
        $str .= '<span onclick="$(this).parent().remove();sae_addUserToGroup('.$userIDX.','.$groupIDX.',\''.$userName.'\');" class="w3-small w3-button w3-display-left"><i class="fa fa-plus w3-small" aria-hidden="true"></i></span>';
        $str .= '&nbsp;&nbsp;<span style="margin-left: 20px;">'.$userName.'</span>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';

    return ($str);
}

sub sae_updateUserGroupMembership(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $groupIDX = $q->param('groupIDX');
    my $userIDX = $q->param('userIDX');
    my $Auth = new SAE::Auth();
    my $Ref = new SAE::REFERENCE();
    $Auth->_updateUserGroup($groupIDX, $userIDX);
    %DATA = %{$Ref->_getGroupAccess($groupIDX)};
    my $json = encode_json \%DATA;
    my $SQL = "DELETE FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $delete = $dbi->prepare($SQL);
    $delete->execute($userIDX);

    $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) 
        SELECT FK_TILES_IDX, $userIDX FROM TB_GROUP_ACCESS WHERE FK_GROUP_IDX=?";
    my $insert = $dbi->prepare($SQL); 
        $insert->execute($groupIDX);
    return ($json);
}
sub getUserAccess(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $userIDX = $q->param('userIDX');
    my $SQL = "SELECT FK_TILES_IDX FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($userIDX);
    %DATA = %{$select->fetchall_hashref('FK_TILES_IDX')};
    $SQL = "SELECT FK_GROUP_IDX FROM TB_USER WHERE PK_USER_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($userIDX);
    my $groupIDX = $select->fetchrow_array();
    $DATA{0}{FK_GROUP_IDX} = $groupIDX;
    my $json = encode_json \%DATA;
    return ($json);
}
sub ManageUsers(){
    print $q->header();
    my $str;
    $str = '<div class="w3-bar w3-blue w3-top w3-card-4" style="z-index: 10001; height: 39px; margin-top: 40px;">';
    $str .= '<button class="w3-bar-item w3-button sae-tabs w3-light-blue" onclick="openTab(\'ManageUsers_divUser_view\', this);">Manage Users</button>';
    $str .= '<button class="w3-bar-item w3-button sae-tabs " onclick="openTab(\'ManageUsers_divGroup_view\', this);">Manage Groups</button>';
    $str .= '</div>';
    $str .= '<div id="ManageUsers_divUser_view" class="w3-display-container PaperTabs w3-padding">';
    $str .= '<br><br><br><h3>Manage Users</h3>';
    $str .= '<div ID="ManageUsers_divUser_view_ViewContainer" class="w3-container">&nbsp;</div>';
    $str .= '</div>';

    $str .= '<div id="ManageUsers_divGroup_view" class="w3-display-container PaperTabs w3-padding" style="display: none;">';
    $str .= '<br><br><br><h3>Manage Groups</h3>';
    $str .= '<div ID="ManageUsers_divGroup_view_ViewContainer" class="w3-container">&nbsp;</div>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_removeGroupAccess(){
    print $q->header();
    my $tilesIDX = $q->param('tilesIDX');
    my $groupIDX = $q->param('groupIDX');
    my $Auth = new SAE::Auth();
    $Auth->_deleteGroupAccess($tilesIDX, $groupIDX);
}
sub sae_grantGroupAccess(){
    print $q->header();
    my $tilesIDX = $q->param('tilesIDX');
    my $groupIDX = $q->param('groupIDX');
    my $Auth = new SAE::Auth();
    $Auth->_addGroupAccess($tilesIDX, $groupIDX);
}
sub sae_loadGroupMembership(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $groupIDX = $q->param('groupIDX');
    %USERS = %{$Ref->_getGroupMembership($groupIDX)};
    my $str = '<div class="w3-panel w3-blue-grey">';
    $str .= '<button class="w3-button w3-card-2 w3-round w3-margin w3-white" onclick="sae_openAddMemberToGroup('.$groupIDX.');">Add Members</button>';
    $str .= '</div>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})}keys %USERS) {
        $str .= &_tempMemberList($USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME}, $userIDX , $groupIDX);
    }
    return($str);
}
sub _tempMemberList(){
    my $str;
    my $name = shift;
    my $userIDX = shift;
    my $groupIDX = shift;
    $str = '<li class="w3-display-container">';
    $str .= '<span onclick="$(this).parent().remove();sae_removeUserFromGroup('.$userIDX.','.$groupIDX.');" class="w3-small w3-button w3-display-topright">X</span>';
    $str .= '<span >'.$name.'</span>';
    $str .= '</li>';
    return ($str);
}
sub sae_displayTilesForGroup(){
    print $q->header();
    my $location = $q->param('location');
    my $groupIDX = $q->param('groupIDX');
    my $Ref = new SAE::REFERENCE();
    %TILES = %{$Ref->_getTypeTiles()};
    %GROUP = %{$Ref->_getGroupInAccess()};
    %ACCESS = %{$Ref->_getGroupAccess($groupIDX)};
    %GRP = %{$Ref->_getGroups()};
    my $str;
    $str .= '<p class="w3-margin-top w3-large">Selected Group [ "<u>'.$GRP{$groupIDX}{TX_GROUP}.'</u>" ] will be granted the following access:</p>';
    $str .= '<ul class="w3-ul w3-bar w3-small">';
    foreach $inType (sort keys %TILES) {
        # $groupIDX = $GROUP{$inType}{PK_GROUP_IDX};
        $str .= '<li onclick="sae_expandAccessGroup('.$inType.', this)" class="w3-blue-grey"><i class="fa fa-chevron-right"></i>&nbsp;&nbsp; Select the '.$GROUP{$inType}{TX_GROUP}.' Access Items';
        # $str .= '&nbsp; Check the items to grant access';
        foreach $tilesIDX (sort keys %{$TILES{$inType}}) {
            if (exists $ACCESS{$tilesIDX}){$checked = "checked"} else {$checked = ""}
            $str .= '<li class="w3-margin-left w3-hide accessGroup_'.$inType.'"><input type="checkbox" '.$checked.' onclick="sae_processGroupAccess(this, '.$tilesIDX.', '.$groupIDX.')">&nbsp;'.$TILES{$inType}{$tilesIDX}{TX_TITLE}.'</li>';
        }
        $str .= '</li>';
    }
    $str .= '</ul>';
    return ($str);
}
sub ManageUsers_divGroup_view(){
    print $q->header();
    my $User = new SAE::TB_USER();
    my $Ref = new SAE::REFERENCE();
    %USERS = %{$User->getAllRecord()};
    %GROUP = %{$Ref->_getGroups()};

    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<fieldset class="">';
    $str .= '<legend>Groups</legend>';
    foreach $groupIDX (sort {lc($GROUP{$b}{TX_GROUP}) cmp lc($GROUP{$a}{TX_GROUP})} keys %GROUP){
        # if ($groupIDX == 1){$checked = 'checked'} else {$checked = ''}
        $str .= '<input class="w3-radio w3-margin-left" type="radio" name="groupName" value="'.$groupIDX.'" onclick="sae_displayTilesForGroup('.$groupIDX.')">&nbsp;'.$GROUP{$groupIDX}{TX_GROUP};
    }
    $str .= '</fieldset>';
    # $str .= '<p class="w3-margin-top">Selected Group above will have access to the checked items below:</p>';
    $str .= '<div ID="groupAccess_Content" class="w3-margin-top w3-container w3-border w3-round">';
    $str .= '</div>';
    $str .= '<fieldset class="w3-margin-top">';
    $str .= '<legend>Current Members of selected group</legend>';
    
    $str .= '<ul ID="groupMembershipList" class="w3-ul w3-card-2">';

    $str .= '</ul>';
    $str .= '</fieldset>';
    $str .= '</div>';

    return ($str);
}
sub ManageUsers_divUser_view(){
    print $q->header();
    # my $dbi = new SAE::Db();
    my $User = new SAE::TB_USER();
    my $Ref = new SAE::REFERENCE();
    %USERS = %{$User->getAllRecord()};
    %TILES = %{$Ref->_getTypeTiles()};
    my $str;
    my @TYPES = (0,1,4);
    my %TITLES = (0=>'Students',1=>'Judges',4=>'Admin');
    my %TITLES_ID = (0=>'StudentAccess_',1=>'JudgeAccess_',4=>'AdminAccess_');
    my %TITLES_CLASS = (0=>'sae-StudentAccess',1=>'sae-JudgeAccess',4=>'sae-AdminAccess');
    # $str .= '<center class="w3-padding">';
    
    # $str .= '</center>';
    $str .= '<fieldset class="w3-panel w3-container w3-padding">';
    $str .= '<legend>User Access</legend>';
    $str .= '<div class="w3-container w3-blue-grey w3-padding" style="margin-top: 8px;"> ';
    
    
    $str .= '<label>Grant Access For: </label>';
    $str .= '<select ID="manageUserDropdown" class="w3-select" name="option" onmousedown="if(this.options.length>15){this.size=15;}"  onchange="this.size=0;getUserAccess(this.value);" onblur="this.size=0;">';
    $str .= '<option value="0" selected>--- Select A User ---</option>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $str .= '<option value="'.$userIDX.'">'.$USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME}.'</option>';
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<div class="w3-margin-top">';
    $str .= '<button class="w3-button w3-round-large w3-border w3-margin-left" onclick="sae_deleteUser();">Delete User</button>';
    $str .= '<button class="w3-button w3-round-large w3-border w3-margin-left" onclick="sae_resetPassword();">Reset Password</button>';
    $str .= '</div>';
    # $str .= '<h4 class="w3-xxlarge w3-margin-left">Grant Access For: <span class="w3-bold w3-text-blue" id="grantAccessName">&lt;Select a Name&gt;</span></h4>';
    $str .= '<div class="w3-row-padding  w3-margin-top">';
    $str .= '<table class="w3-table w3-border">';
    foreach $number (sort {$a<=>$b} @TYPES){
        $str .= '<tr class="w3-blue-grey">';
        $str .= '<td>';
        $str .= '<i class="fa fa-unlock-alt w3-xlarge"></i><span class="w3-large">&nbsp; '.$TITLES{$number}.'</span>';
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '<tr>';
        $str .= '<td>';
        foreach $pkTilesIdx (sort {$TILES{$number}{$a}{IN_ORDER} <=> $TILES{$number}{$b}{IN_ORDER}} keys %{$TILES{$number}}){
            if ($pkTilesIdx == 14 || $pkTilesIdx == 15  || $pkTilesIdx == 16  || $pkTilesIdx == 17){next}
            $str .= '<input ID="'.$TITLES_ID{$number}.''.$pkTilesIdx.'" class="w3-check '.$TITLES_CLASS{$number}.' saeAccess" ';
            $str .= 'type="checkbox" value="'.$pkTilesIdx.'" ';
            $str .= 'onchange="sae_processUserAccess(this, '.$pkTilesIdx.');" >';
            $str .= '&nbsp;&nbsp;<label for="'.$TITLES_ID{$number}.''.$pkTilesIdx.'">'.$TILES{$number}{$pkTilesIdx}{TX_TITLE}.'</label>';
            $str .= '<br>';
        }
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';

    $str .= '<div class="w3-clear"></div>';
    $str .= '</div>';
    $str .= '</fieldset>';
    $str .= '<fieldset class="w3-panel w3-container w3-padding">';
    $str .= '<legend>User Group</legend>';
    %GRP = %{$Ref->_getGroups()};
    $str .= '<input ID="userGroup_0" name="userGroup" checked value="0" type="radio" class="w3-radio"  onchange="sae_updateUserGroupMembership(0);">&nbsp; <label FOR="userGroup_0"> - None - </label><br>';
    foreach $groupIDX (sort {lc($GRP{$b}{TX_GROUP}) cmp lc($GRP{$a}{TX_GROUP})} keys %GRP){
        $str .= '<input ID="userGroup_'.$groupIDX .'" name="userGroup" value="'.$groupIDX.'" type="radio" class="w3-radio" onchange="sae_updateUserGroupMembership('.$groupIDX.');">&nbsp; <label FOR="userGroup_'.$groupIDX .'" >'.$GRP{$groupIDX}{TX_GROUP}.'</label><br>';
    }
    $str .= '</fieldset>';
    $str .= '<fieldset class="w3-panel w3-container w3-padding">';
    $str .= '<legend>Team</legend>';
    $str .= '<button class="w3-button w3-round-large w3-border w3-margin-bottom" onclick="sae_getListOfTeams();">Add Team(s)</button>';
    $str .= '<div ID="userListOfTeam_Content" class="w3-container">';
    $str .= '<ul class="w3-ul w3-card-2" ID="userListOfTeam_Content_UL">';
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '</fieldset>';
    return ($str);
}
sub loadMenuItems(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $Auth = new SAE::Auth();
    $str = $Auth->_getMenuItem($userIDX);
    return ($str);
}
sub _tempListOfTeams(){
    my $str;
    my $name = shift;
    my $teamIDX = shift;
    my $userIDX = shift;
    $str = '<li class="w3-display-container">';
    $str .= '<span onclick="sae_addTeamToUser(this, '.$teamIDX.',\''.$name.'\','.$userIDX.');" class="w3-small w3-button w3-display-left w3-padding-small">+</span>';
    $str .= '<span style="margin-left: 10px">'.$name.'</span>';
    $str .= '</li>';
    return ($str);
}
sub _tempListOfUserTeams(){
    my $str;
    my $name = shift;
    my $userTeamIDX = shift;
    $str = '<li class="w3-display-container">';
    $str .= '<span onclick="sae_removeUserTeam(this, '.$userTeamIDX.');" class="w3-small w3-button w3-display-right w3-padding-small">X</span>';
    $str .= '<span style="margin-left: 10px">'.$name.'</span>';
    $str .= '</li>';
    return ($str);
}
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
sub sae_getUserTeamMembership(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');
    %TEAMS = %{$Ref->_getUserTeamList($userIDX)};
    my $str;
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        $userTeamIDX = $TEAMS{$teamIDX}{PK_USER_TEAM_IDX};
        $inNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3);
        my $name = $inNumber." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= &_tempListOfUserTeams($name, $userTeamIDX);
    }
    return ($str);
}

# ***********************************************************************************************************************************
#  TEAM MANAGEMENT
# ***********************************************************************************************************************************
sub ManageTeams(){
    print $q->header();
    my $location = $q->param('location');
    my $Ref = new SAE::REFERENCE();
    %TEAMS = %{$Ref->_getListOfTeamsByEventId($location)};
    %CLASS = %{$Ref->_getClassList()};
    my $str;
    
    $str .= '<div class="w3-container w3-margin-top w3-padding" >';
    $str .= '<h2>Manage Teams</h2>';
    $str .= '<div class="w3-row" style="width: 40%;">';
    $str .= '<a href="javascript:void(0);" onclick="sae_showAddNewTeam(this);"><div class="w3-half tablink w3-bottombar w3-hover-light-grey w3-padding w3-border-red">Add Team</div></a>';
    $str .= '<a href="javascript:void(0);" onclick="sae_showFileImport(this);"><div class="w3-half tablink w3-bottombar w3-hover-light-grey w3-padding">Import List</div></a>';
    $str .= '</div>';
    $str .= '<div id="ManageUsers_divUser_view" class="w3-display-container w3-padding">';
    $str .= '<table class="w3-table-all w3-small" ID="TABLE_TEAMS">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th># - School</th>';
    $str .= '<th style="width: 10%;">Subscriber</th>';
    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}}keys %TEAMS) {
        $inNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3);
        $name = $inNumber.' - '.$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= &_tempTeamList($name, $teamIDX, $inNumber);
    }
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
}
sub _tempTeamList(){
    my $name = shift;
    my $teamIDX = shift;
    my $inNumber = shift;
    my $str;
    $str = '<tr></tr>';
    $str .= '<tr class="w3-hide-small sae-teamInfo_'.$teamIDX.'">';
    $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_openTeamDetails('.$teamIDX.');">%s</a></td>', $name;
    $str .= '<td style="text-align: right;"><a class="w3-border w3-button w3-padding-small w3-round" href="javascript:void(0);" onclick="sae_openTeamUserMembership('.$teamIDX.');"><i class="fa fa-user-plus"></i> Subscriber</a></td>';
    $str .= '</tr>';
    $str .= '<tr class="w3-hide-medium w3-hide-large">';
    $str .= '<td>';
    $str .= sprintf '<a href="javascript:void(0);" onclick="sae_openTeamDetails(%d);">%s</a><br>', $teamIDX, $name;
    $str .= sprintf '<a class="w3-border w3-button w3-padding-small w3-round  w3-margin-top" href="javascript:void(0);" onclick="sae_openTeamUserMembership(%d);"><i class="fa fa-user-plus"></i> Subscriber</a>',$teamIDX;
    $str .= '</td>';
    $str .= '</tr>';
    return ($str);
}
sub sae_showAddNewTeam(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    %CLASS = %{$Ref->_getClassList()};
    %COUNTRY = %{$Ref->_getCountryList()};
    my $location = $q->param('location');
    my $divName = $q->param('divName');
    my $str;
    $str = '<div class="w3-container" style="padding-bottom: 30px;">';
    $str .= '<div class="w3-display-container">';
    $str .= '<label>Team #</label>';
    $str .= '<input class="w3-input" type="number" ID="new_teamInNumber" onblur="sae_updateClassSelection(this);" min=1 max=999>';
    $str .= '<input class="w3-input w3-text-blue" type="hidden" ID="new_fkClassIDX">';
    $str .= '<label>School</label>';
    $str .= '<input class="w3-input" type="Text" ID="new_teamTxSchool">';
    $str .= '<label>Team Name</label>';
    $str .= '<input class="w3-input" type="Text" ID="new_teamTxName">';
    $str .= '<label>Country</label>';
    $str .= '<select ID="new_teamTxCountry" class="w3-select">';
    $str .= '<option value="0">- Select Country -</option>';
    foreach $countryIDX (sort {lc($COUNTRY{$a}{TX_COUNTRY}) cmp lc($COUNTRY{$b}{TX_COUNTRY})} keys %COUNTRY){
        $str .= '<option value="'.$countryIDX.'">'.$COUNTRY{$countryIDX}{TX_COUNTRY}.'</option>';
    }
    $str .= '</select>';
    $str .= '<div class="w3-display-bottom w3-margin-top" style="text-align: center;">';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-right" onclick="sae_createANewTeam(\''.$divName.'\');">Add</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_createANewTeam(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $location = $q->param('location');
    my $inNumber = $q->param('inNumber');
    my $txSchool = $q->param('txSchool');
    my $txName = $q->param('txName');
    my $classIDX = $q->param('classIDX');
    my $countryIDX = $q->param('countryIDX');
    my $txCountry = $q->param('txCountry');
    my $txCode = $Auth->getTemporaryPassword(6);
    my $newTeamIDX = $Auth->_createNewTeam($classIDX, $countryIDX, $txCountry, $inNumber, $txName, $txSchool, $location, $txCode);
    $name = substr("000".($inNumber*1),-3,3)." - ".$txSchool;
    $str = &_tempTeamList($name, $newTeamIDX, substr("000".$inNumber,-3,3));
    return ($str);
}
sub sae_updateTeamDetails(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $location = $q->param('location');
    my $inNumber = $q->param('inNumber');
    my $txSchool = $q->param('txSchool');
    my $txName = $q->param('txName');
    my $classIDX = $q->param('classIDX');
    my $countryIDX = $q->param('countryIDX');
    my $txCountry = $q->param('txCountry');
    my $inSlope = $q->param('inSlope');
    my $inInt = $q->param('inInt');
    my $inLcargo = $q->param('inLcargo');
    my $inPipes = $q->param('inPipes');
    my $inWpipes = $q->param('inWpipes');
    my $teamCode = $q->param('teamCode');
    my $teamIDX = $q->param('teamIDX');
    $Auth->_updateTeamDetails($classIDX, $countryIDX, $txCountry, $inNumber, $txName, $txSchool, $location, $txCode, $inSlope, $inInt, $inLcargo, $inPipes, $inWpipes, $teamCode, $teamIDX);
    $name = substr("000".($inNumber*1),-3,3)." - ".$txSchool;
    $DATA{NAME} = $name;
    $DATA{POSITION} = substr("000".$inNumber,-3,3);
    my $json = encode_json \%DATA;
    return ($json);
    # $str = &_tempTeamList($name, $teamIDX, substr("000".$inNumber,-3,3));
    # return ($str);
}
sub sae_openTeamDetails(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    %CLASS = %{$Ref->_getClassList()};
    %COUNTRY = %{$Ref->_getCountryList()};
    my $location = $q->param('location');
    my $divName = $q->param('divName');
    my $teamIDX = $q->param('teamIDX');
    %TEAM = %{$Ref->_getTeamData($teamIDX)};
    my $str;
    $str = '<div class="w3-container" style="padding-bottom: 30px;">';
    $str .= '<div class="w3-display-container">';
    $str .= '<label>Team #</label>';
    $str .= '<input class="w3-input w3-text-blue" type="number" ID="new_teamInNumber" onblur="sae_updateClassSelection(this);" min=1 max=999 value="'.$TEAM{$teamIDX}{IN_NUMBER}.'">';
    $str .= '<input class="w3-input w3-text-blue" type="hidden" ID="new_fkClassIDX" value="'.$TEAM{$teamIDX}{FK_CLASS_IDX}.'">';
    
    $str .= '<label>School</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamTxSchool" value="'.$TEAM{$teamIDX}{TX_SCHOOL}.'">';
    $str .= '<label>Team Name</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamTxName" value="'.$TEAM{$teamIDX}{TX_NAME}.'">';

    $str .= '<label>Country</label>';
    $str .= '<select ID="new_teamTxCountry" class="w3-select  w3-text-blue">';
    $str .= '<option value="0">- Select Country -</option>';
    foreach $countryIDX (sort {lc($COUNTRY{$a}{TX_COUNTRY}) cmp lc($COUNTRY{$b}{TX_COUNTRY})} keys %COUNTRY){
        if ($TEAM{$teamIDX}{TX_COUNTRY} == $COUNTRY{$countryIDX}{TX_COUNTRY}){$selected="selected"} else {$selected=""}
        $str .= '<option value="'.$countryIDX.'" '.$selected.'>'.$COUNTRY{$countryIDX}{TX_COUNTRY}.'</option>';
    }
    $str .= '</select>';
    $str .= '<label>Team Access Code</label>';
    $str .= '<input class="w3-input w3-text-blue w3-xlarge" type="password" style="font-family:\"Courier New\", Courier, monospace" ID="new_teamAccessCode" value="'.$TEAM{$teamIDX}{TX_CODE}.'">';
    $str .= '<input type="checkbox" onchange="sae_changeInputType(this, \'new_teamAccessCode\');"> <label class="w3-small">show Teamcode</label><br><br>';
    if ($TEAM{$teamIDX}{FK_CLASS_IDX}==1){$hide = '';} else {$hide='w3-hide'}
    # Regular Class Specialty Fields
    $str .= '<div ID="new_RegularClassFields" class="sae-specialFields sae-specialFields_1 '.$hide.'">';
    $str .= '<label>Slope</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamSlope" value="'.$TEAM{$teamIDX}{IN_SLOPE}.'">';
    $str .= '<label>y-Intercept (from TDS)</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamIntercept" value="'.$TEAM{$teamIDX}{IN_YINT}.'">';
    $str .= '<label>Length of Cargo Bay (inches)</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamCargoLength" value="'.$TEAM{$teamIDX}{IN_LCARGO}.'">';
    $str .= '</div>';
    # Micro Class Specialty Fields
    if ($TEAM{$teamIDX}{FK_CLASS_IDX}==3){$hide = '';} else {$hide='w3-hide'}
    $str .= '<div ID="new_MicroClassFields" class="sae-specialFields sae-specialFields_3 '.$hide.'">';
    $str .= '<label># of pipes</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamInPipes" value="'.$TEAM{$teamIDX}{IN_PIPES}.'">';
    $str .= '<label>Weight of Pipes (lbs.)</label>';
    $str .= '<input class="w3-input w3-text-blue" type="Text" ID="new_teamInPipeWeights" value="'.$TEAM{$teamIDX}{IN_WPIPES}.'">';
    $str .= '</div>';

    $str .= '<div class="w3-display-bottom w3-margin-top" style="text-align: center;">';
    $str .= '<button class="w3-button w3-border w3-round" onclick="sae_updateTeamDetails('.$teamIDX.',\''.$divName.'\')">Update</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-red w3-margin-left" onclick="sae_deleteTeam('.$teamIDX.',\''.$divName.'\');">Delete</button>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
}
sub sae_deleteTeam(){
    print $q->header();
    $teamIDX = $q->param('teamIDX');
    $Team = new SAE::TB_TEAM();
    $Team->deleteRecordById($teamIDX);
}
sub sae_openTeamUserMembership(){
    print $q->header();
    $teamIDX = $q->param('teamIDX');
    my $Ref = new SAE::REFERENCE();
    %MEMBERS = %{$Ref->_getTeamUserList($teamIDX)};
    %USERS = %{$Ref->_getUserList()};

    my $str;
    $str .= '<ul ID="sae_userTeamMemberList" class="w3-ul w3-card-4">';
    foreach $userIDX (sort {lc($MEMBERS{$a}{TX_LAST_NAME}) cmp lc($MEMBERS{$b}{TX_LAST_NAME})} keys %MEMBERS) {
        $userTeamIDX = $MEMBERS{$userIDX}{PK_USER_TEAM_IDX};
        $name = $MEMBERS{$userIDX}{TX_LAST_NAME}.', '.$MEMBERS{$userIDX}{TX_FIRST_NAME};
        $txEmail = $MEMBERS{$userIDX}{TX_EMAIL};
        $str .= &_tempTeamUserList($name , $txEmail , $userTeamIDX);
    }
    $str .= '<li>';
    $str .= '<select ID="manageUserDropdown2" class="w3-select w3-border w3-text-blue w3-padding" name="option" onmousedown="if(this.options.length>15){this.size=15;}"  onchange="this.size=0;sae_addUserToThisTeam('.$teamIDX.')" onblur="this.size=0;">';
    $str .= '<option value="0"> - Add Member -</option>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS){
        if (exists $MEMBERS{$userIDX}){next};
        $name = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        $str .= '<option class="w3-border-top" style="margin-left: 15px; " value="'.$userIDX.'">'.$name.'</option>';
    }
    $str .= '</select>';
    $str .= '</li>';
    $str .= '</ul>';

    return ($str)
}
sub _tempTeamUserList(){
    my $str;
    my $name = shift;
    my $txEmail = shift;
    my $userTeamIDX = shift;
    $str = '<li class="w3-display-container" style="padding:5px 5px 5px 25px;">';
    $str .= '<span onclick="sae_removeUserTeam(this, '.$userTeamIDX.');" class="w3-button w3-white w3-right">X</span>';
    $str .= '<span>'.$name.'</span><br>';
    $str .= '<span>'.$txEmail.'</span>';
    $str .= '</li>';
    return ($str);
}
sub sae_addUserToThisTeam(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $Ref = new SAE::REFERENCE();
    my $teamIDX = $q->param('teamIDX');
    my $userIDX = $q->param('userIDX');
    my $userTeamIDX = $Auth->_addTeamToUser($userIDX, $teamIDX);
    %MEMBERS = %{$Ref->_getUserRecord($userIDX)};
    $name = $MEMBERS{$userIDX}{TX_LAST_NAME}.', '.$MEMBERS{$userIDX}{TX_FIRST_NAME};
    $txEmail = $MEMBERS{$userIDX}{TX_EMAIL};
    $str .= &_tempTeamUserList($name , $txEmail , $userTeamIDX);
    return ($str);
}
sub sae_showFileImport(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<div>';
    $str .= '<form class="w3-card-2 w3-round-large w3-padding w3-panel" method="post" action="javascript:sae_importFile(\''.$divName.'\');" enctype="multipart/form-data">';
    $str .= '<input class="w3-file" type="file" name="csvFile" ID="csvFile" >';
    $str .= '<br><br>';
    $str .= '<input class="w3-margin-top w3-button w3-border w3-card-4 w3-round" type="submit" value="Import...">';
    $str .= '</form>';
    $str .= '<div ID="sae_results">';
    $str .= '</div>';
    $str .= '</div>';

    return($str);
}
sub sae_importFile(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $uploadDirectory = "/home/saestars/public_html/dev2/uploads";
    my $csv = Text::CSV->new( { sep_char => ",", binary => 1 , eol=> "\n", allow_loose_quotes => 1} ) or die "Cannot use CSV: ".Text::CSV->error_diag ();
    my $fileName = $q->param('csvFile');
    my $location = $q->param('location');
    my $file_handle = $q->upload('csvFile');   
    my $str;
    open ( UPLOADFILE, ">$uploadDirectory/$fileName" ) or die "$!"; binmode UPLOADFILE;
    while ( <$file_handle> ){
        print UPLOADFILE;
    }
    close UPLOADFILE;
    open $fh, '<', "$uploadDirectory/$fileName" or die "can't open csv ($uploadDirectory/$fileName) $!";
    my %DATA;
    my $counter=1;
    while ( my $row = $csv->getline( $fh ) ){
        $DATA{$counter}{IN_NUMBER}     = @$row[0];
        $DATA{$counter}{TX_SCHOOL}     = @$row[1];
        $DATA{$counter}{TX_NAME}       = @$row[2];
        $DATA{$counter}{TX_COUNTRY}    = @$row[3];
        $counter++;
    }
    close $fh;
    unlink "$uploadDirectory/$fileName";
    for ($i=2; $i<=scalar(keys %DATA); $i++){
        if ($DATA{$i}{IN_NUMBER}<200){
            $classIDX = 1;
        } elsif ($DATA{$i}{IN_NUMBER}>300){
            $classIDX = 3;
        } else {
            $classIDX = 2;
        }
        $inNumber = $DATA{$i}{IN_NUMBER};
        $txSchool = $DATA{$i}{TX_SCHOOL};
        $txName = $DATA{$i}{TX_NAME};
        $countryIDX = &checkCountry($DATA{$i}{TX_COUNTRY});
        $txCountry = $DATA{$i}{TX_COUNTRY};
        $txCode = $Auth->getTemporaryPassword(6);
        $teamIDX = $Auth->_createNewTeam($classIDX, $countryIDX, $txCountry, $inNumber, $txName, $txSchool, $location, $txCode);
    }
    return ($str)
}
sub checkCountry(){
    my $txCountry = shift;
    my $Ref = new SAE::REFERENCE();
    my $Auth = new SAE::Auth();
    %COUNTRY = %{$Ref->_getCountryListByName()};
    if (exists $COUNTRY{$txCountry}){
        $countryIDX = $COUNTRY{$txCountry}{PK_COUNTRY_IDX};
    } else {
        $countryIDX = $Auth->_addCountry($txCountry );
    }
    return ($countryIDX);
}
