#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use URI::Escape;
use Cwd 'abs_path';
# use JSON;
use List::Util qw(first);

#---- SAE MODULES -------
use SAE::HOME;
use SAE::REFERENCE;
use SAE::Auth;
use SAE::SCORE;
use SAE::DESIGN;
use SAE::PRESO;
use SAE::REGULAR;
use SAE::ADVANCED;
use SAE::MICRO;
use SAE::TECH;
use SAE::PROFILE;
use SAE::JSONDB;
use SAE::USER;

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
# User HomePage
# ***********************************************************************************************************************************
sub profile_delete (){
    my $profileIDX = $q->param('profileIDX');
    my $JsonDB     = new SAE::JSONDB();

    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    $JsonDB->_delete('TB_PROFILE', qq(PK_PROFILE_IDX=$profileIDX));
    return ($str);
    }
sub profile_openMyPreferences (){
    my $profileIDX = $q->param('profileIDX');
    my $inUserType = $q->param('inUserType');
    my $Profile    = new SAE::PROFILE();
    my %PROFILE    = %{$Profile->_getUserEventPreferences($profileIDX)};
    my $txYear     = $PROFILE{TX_YEAR};
    my $userIDX    = $PROFILE{FK_USER_IDX};
    my $User       = new SAE::USER();
    my %USER       = %{$User->_getUser($userIDX)}; 
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    # my $str = $profileIDX;
    my $str;
    $str .= '<div class="w3-container">';    
    $str .= '<fieldset class="w3-margin-top w3-round w3-border w3-card"><legend> Event Preferences ( <i class="w3-text-red">*Required</i> )</legend>';
    $str .= '<i>I like to participate in the following events (Select at least one):</i><br>';
    $str .= '<div class="w3-container">';
    my $boEastCheck = '';
    if ($PROFILE{BO_EAST} == 1){$boEastCheck = 'checked'}
    my $boWestCheck = '';
    if ($PROFILE{BO_WEST} == 1){$boWestCheck = 'checked'}
    my $boRegCheck = '';
    if ($PROFILE{BO_REGULAR} == 1){$boRegCheck = 'checked'}
    my $boAdvCheck = '';
    if ($PROFILE{BO_ADVANCE} == 1){$boAdvCheck = 'checked'}
    my $boMicCheck = '';
    if ($PROFILE{BO_MICRO} == 1){$boMicCheck = 'checked'}
    my $boDrwCheck = '';
    if ($PROFILE{BO_DRW} == 1){$boDrwCheck = 'checked'}
    my $boTdsCheck = '';
    if ($PROFILE{BO_TDS} == 1){$boTdsCheck = 'checked'}
    my $boReqCheck = '';
    if ($PROFILE{BO_REQ} == 1){$boReqCheck = 'checked'}
    my $boPresoCheck = '';
    if ($PROFILE{BO_PRESO} == 1){$boPresoCheck = 'checked';}
    my $boAluCheck = '';
    if ($PROFILE{BO_ALUMI} == 1){$boAluCheck = 'checked'}
    my $boStuCheck = '';
    if ($PROFILE{BO_STUDENT} == 1){$boStuCheck = 'checked'}
    $str .= '<input ID="BO_EAST" type="checkbox" class="w3-check" data-field="BO_EAST" '.$boEastCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>'.$txYear.' Aero-Design East</b> </label><br>';
    $str .= '<input ID="BO_WEST" type="checkbox" class="w3-check" data-field="BO_WEST" '.$boWestCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>'.$txYear.' Aero-Design West</b> </label><br>';
    $str .= '</div>';
    $str .= '</fieldset>';

    $str .= '<fieldset class="second w3-margin-top w3-round w3-border w3-card"><legend> Design Report Preferences  ( <i class="w3-text-red">*Required</i> )</legend>';
    $str .= '<i>I am volulnteering to grade design reports for the following classes (Select at least one):</i><br>';
    $str .= '<div class="w3-container">';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_REGULAR" '.$boRegCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Regular Class</b> Design Reports </label><br>';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_ADVANCE" '.$boAdvCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Advanced Class</b> Design Reports </label><br>';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_MICRO"   '.$boMicCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Micro Class</b> Design Reports </label><br>';
    $str .= '</div>';
    $str .= '</fieldset>';
    if ($inUserType>1){
        $str .= '<fieldset class="second w3-round w3-border w3-card w3-margin-top w3-light-grey"><legend> Advanced Judges Preferences </legend>';
        $str .= '<div class="w3-container">';
        $str .= '<input type="checkbox" class="w3-check second" data-field="BO_DRW" '.$boDrwCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>3D-Drawings</b> </label><br>';
        $str .= '<input type="checkbox" class="w3-check second" data-field="BO_TDS" '.$boTdsCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Technical Data Sheets (TDS)</b> </label><br>';
        $str .= '<input type="checkbox" class="w3-check second" data-field="BO_REQ" '.$boRegCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Rules & Requirement Compliance</b> </label><br>';
        $str .= '</div>';
        $str .= '</fieldset>';
    }

    $str .= '<fieldset class="second w3-margin-top w3-round w3-border w3-card"><legend> Presentation Preferences </legend>';
    $str .= '<div class="w3-container">';
    
    # if ($PROFILE{BO_PRESO} == 1){$presoDisabled = ''}
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_PRESO" '.$boPresoCheck.' onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Yes</b>, I like to volunteer to support the Virtual Team Presentations ( <i>Ask event coordinators for specific details</i> )</label><br>';
    $str .= '</div>';
    $str .= '</fieldset>';
    $str .= '<fieldset class="second w3-margin-top w3-round w3-border w3-card"><legend> Volunteer History (Optional)</legend>';
    $str .= '<div class="w3-container">';
    my $yearPlaceHolder = "Volunteered since 1986";
    if ($USER{TX_YEAR}){$yearPlaceHolder = "Volunteered since ".$USER{TX_YEAR};}
    my $schoolPlaceHolder = "Team/University affiliation";
    if ($USER{TX_SCHOOL}){$schoolPlaceHolder = $USER{TX_SCHOOL}}
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_ALUMI"  '.$boAluCheck.' data-value="'.$USER{TX_YEAR}.'" onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Yes</b>, I have previously volunteered for these competition. </label> ';
    if ($PROFILE{BO_ALUMI} == 1){
            $str .= sprintf '<input ID="IN_SINCE" type="text" class="w3-input w3-border w3-round " data-field="IN_SINCE" onchange="profile_saveInput(this,'.$txYear.');" style="margin-left: 45px; width: 250px;" value="%s">', $USER{TX_YEAR};
        } else {
            $str .= sprintf '<input ID="IN_SINCE" type="text" class="w3-input w3-border w3-round " disabled data-field="IN_SINCE" onchange="profile_saveInput(this,'.$txYear.');" style="margin-left: 45px; width: 250px;" placeholder="'.$yearPlaceHolder.'">';
        }
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_STUDENT" '.$boStuCheck.' data-value="'.$USER{TX_SCHOOL}.'" onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Yes</b>, I was a former student competitor. If yes, please identify your previous team affiliation</label> ';
    if ($PROFILE{BO_STUDENT} == 1){
            $str .= sprintf '<input ID="TX_SCHOOL" type="text" class="w3-input w3-border w3-round " data-field="TX_SCHOOL" onchange="profile_saveInput(this,'.$txYear.');" style="margin-left: 45px; width: 250px;" value="%s">', $USER{TX_SCHOOL};
        } else {
            $str .= sprintf '<input ID="TX_SCHOOL" type="text" class="w3-input w3-border w3-round " disabled data-field="TX_SCHOOL" onchange="profile_saveInput(this,'.$txYear.');" style="margin-left: 45px; width: 250px;" placeholder="'.$schoolPlaceHolder.'">';
        }
    $str .= '</div>';
    $str .= '</fieldset>';

    $str .= '<fieldset class="second w3-margin-top w3-round w3-border w3-card"><legend> Misc (Optional)</legend>';

    $str .= '<div class="w3-container">';
    $str .= '<label>Maximum number of Design Report I can take</label>';
    $str .= sprintf '<input type="text" class="w3-input w3-border w3-round w3-card second" data-field="IN_LIMIT" onchange="profile_saveInput(this,'.$txYear.');" style="display: inline; margin-left: 15px; width: 80px;" value="%d">', $PROFILE{IN_LIMIT};
    $str .= '</div>';
    $str .= '</fieldset>';

    $str .= '</div>';
    $str .= '<div class="w3-container w3-center w3-margin-top">';
    $str .= '<button class="w3-margin-right w3-button w3-border w3-round w3-card w3-margin-top w3-hover-green w3-pale-green second" onclick="profile_close(this, '.$profileIDX.');">Update '.$txYear.' Event Pereferences</button>';
    $str .= '<button class="w3-margin-left w3-button w3-border w3-round w3-card w3-margin-top w3-hover-red w3-pale-red" onclick="profile_delete(this, '.$profileIDX.');">Delete '.$txYear.' Event Pereferences</button>';
    $str .= '</div>';
    $str .= '<br>' x 2;

    return ($str);
    return ($str);
    }
sub profile_save (){
    my $userIDX = $q->param('userIDX');
    my $field   = $q->param('field');
    my $value   = $q->param('value');
    my $txYear  = $q->param('txYear');
    my $Profile = new SAE::PROFILE();
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    $Profile->_save($userIDX, $field, $value, $txYear);
    my $str;

    return ($str);
    }
sub openJudgesProfile (){
    my $userIDX = $q->param('userIDX');
    my $inUserType = $q->param('inUserType');
    my $User       = new SAE::USER();
    my %USER       = %{$User->_getUser($userIDX)}; 
    # my $Profile    = new SAE::PROFILE();
    my @tm = localtime();
    my $txYear = ($tm[5] + 1900);
    # my %EVENT      = %{$Profile->_getEvents($txYear)};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    # my $str = $userIDX;
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<h2>You\'ve been identified as a Volunteer Judge. Please update your profile and preferences for this year\'s competition</h2>';
    
    $str .= '<fieldset class="w3-margin-top w3-round w3-border w3-card"><legend> Event Preferences ( <i class="w3-text-red">*Required</i> )</legend>';
    $str .= '<i>I like to participate in the following events (Select at least one):</i><br>';
    $str .= '<div class="w3-container">';
    $str .= '<input ID="BO_EAST" type="checkbox" class="w3-check" data-field="BO_EAST" onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>'.$txYear.' Aero-Design East</b> </label><br>';
    $str .= '<input ID="BO_WEST" type="checkbox" class="w3-check" data-field="BO_WEST" onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>'.$txYear.' Aero-Design West</b> </label><br>';
    $str .= '</div>';
    $str .= '</fieldset>';

    $str .= '<fieldset class="w3-margin-top w3-round w3-border w3-card"><legend> Design Report Preferences  ( <i class="w3-text-red">*Required</i> )</legend>';
    $str .= '<i>I am volulnteering to grade design reports for the following classes (Select at least one):</i><br>';
    $str .= '<div class="w3-container">';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_REGULAR" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Regular Class</b> Design Reports </label><br>';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_ADVANCE" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Advanced Class</b> Design Reports </label><br>';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_MICRO"   disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Micro Class</b> Design Reports </label><br>';
    $str .= '</div>';
    $str .= '</fieldset>';
    if ($inUserType>1){
        $str .= '<fieldset class="w3-round w3-border w3-card w3-margin-top w3-light-grey"><legend> Advanced Judges Preferences </legend>';
        $str .= '<div class="w3-container">';
        $str .= '<input type="checkbox" class="w3-check second" data-field="BO_DRW" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>3D-Drawings</b> </label><br>';
        $str .= '<input type="checkbox" class="w3-check second" data-field="BO_TDS" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Technical Data Sheets (TDS)</b> </label><br>';
        $str .= '<input type="checkbox" class="w3-check second" data-field="BO_REQ" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Rules & Requirement Compliance</b> </label><br>';
        $str .= '</div>';
        $str .= '</fieldset>';
    }

    $str .= '<fieldset class="second w3-margin-top w3-round w3-border w3-card"><legend> Presentations Preferences </legend>';
    $str .= '<div class="w3-container">';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_PRESO" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Yes</b>, I like to volunteer to support the Virtual Team Presentations ( <i>Ask event coordinators for specific details</i> )</label><br>';
    $str .= '</div>';

    $str .= '</fieldset>';

    $str .= '<fieldset class="w3-margin-top w3-round w3-border w3-card"><legend> Volunteer History (Optional)</legend>';
    $str .= '<div class="w3-container">';
    my $yearPlaceHolder = "Volunteered since 1986";
    if ($USER{TX_YEAR}){$yearPlaceHolder = "Volunteered since ".$USER{TX_YEAR};}
    my $schoolPlaceHolder = "Team/University affiliation";
    if ($USER{TX_SCHOOL}){$schoolPlaceHolder = $USER{TX_SCHOOL}}
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_ALUMI" data-value="'.$USER{TX_YEAR}.'" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Yes</b>, I have previously volunteered for these competition. </label> ';
    $str .= '<input ID="IN_SINCE" type="text" class="w3-input w3-border w3-round w3-disabled" data-field="IN_SINCE" onchange="profile_saveInput(this,'.$txYear.');" style="margin-left: 45px; width: 250px;" disabled placeholder="'.$yearPlaceHolder.'">';
    $str .= '<input type="checkbox" class="w3-check second" data-field="BO_STUDENT" data-value="'.$USER{TX_SCHOOL}.'" disabled onclick="profile_saveCheck(this,'.$txYear.');"><label class="w3-margin-left"><b>Yes</b>, I was a former student competitor. If yes, please identify your previous team affiliation</label> ';
    $str .= '<input ID="TX_SCHOOL" type="text" class="w3-input w3-border w3-round w3-disabled" data-field="TX_SCHOOL" onchange="profile_saveInput(this,'.$txYear.');" style="margin-left: 45px; width: 250px;" disabled placeholder="'.$schoolPlaceHolder.'">';
    $str .= '</div>';
    $str .= '</fieldset>';

    $str .= '<fieldset class="w3-margin-top w3-round w3-border w3-card"><legend> Misc (Optional)</legend>';

    $str .= '<div class="w3-container">';
    $str .= '<label>Maximum number of Design Report I can take</label>';
    $str .= '<input type="text" class="w3-input w3-border w3-round w3-card second" disabled data-field="IN_LIMIT" onchange="profile_saveInput(this,'.$txYear.');" style="display: inline; margin-left: 15px; width: 80px;" value="3">';
    $str .= '</div>';
    $str .= '</fieldset>';


    $str .= '</div>';
    $str .= '<div class="w3-container w3-center w3-margin-top">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-margin-top w3-hover-green w3-pale-green second" disabled onclick="profile_close(this, 0);">Update Pereferences</button>';
    $str .= '</div>';
    $str .= '<br>' x 2;

    return ($str);
    }
sub sae_unsubscribeToTeam(){
    print $q->header();
    my $userTeamIDX = $q->param('userTeamIDX');
    my $Auth = new SAE::Auth();
    $Auth->_deleteUserTeam($userTeamIDX);

    return ($userTeamIDX);
    }
sub sae_loadHomePage(){
    print $q->header();
    my %PANEL = (1=>'Design',2=>'Presentation' ,3=>'Penalties',4=>'Flights',5=>'Results');
    my %COLOR = (1=>'w3-pale-green',2=>'w3-pale-blue',3=>'w3-pale-red',4=>'w3-light-grey', 5=>'w3-sand');
    my %ICON = (1=>'fa-paperclip', 2=>'fa-line-chart', 3=>'fa-exclamation-triangle', 4=>'fa-plane', 5=>'fa-trophy');
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    my $eventIDX = $q->param('location');
    my $Home = new SAE::HOME();
    my %TEAMS = %{$Home->_getTeamSubscriptionsByUserID($userIDX, $location)};
    my $Design = new SAE::DESIGN();
    my $Preso  = new SAE::PRESO();
    my $Score  = new SAE::SCORE();
    my $Tech   = new SAE::TECH();
    my $str = '<div class="w3-container w3-white w3-margin-top">';
    $str .= '<header class="w3-container" style="padding-top:22px">';
    $str .= '<h5><b><i class="fa fa-dashboard"></i> My  Dashboard</b></h5>';
    $str .= '</header>';

    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS ) {
        my $classIDX            = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $inSafetyStatus      = $Tech->_getTeamSafetyStatus($teamIDX, $classIDX);
        my $inRequirementStatus = $Tech->_getTeamInspectionStatus($teamIDX, $classIDX);
        $str .= '<div class="w3-row-padding w3-padding w3-border w3-round w3-margin-top w3-card-4 w3-light-grey">';
        $str .= sprintf '<header class="w3-container w3-light-grey"><span class="w3-xxlarge">%03d</span><br><h3 style="padding: 0; margin: 0;">%s</h3></header>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= sprintf '<div ID="TeamReuirements_%d" class="w3-half w3-margin-bottom">', $teamIDX;
        $str .= $Tech->_getTechRequirementsCheckStatus($teamIDX, $inRequirementStatus, $classIDX);
        $str .= '</div>';
        $str .= sprintf '<div ID="TeamSafety_%d" class="w3-half w3-margin-bottom">', $teamIDX;
        $str .= $Tech->_getTechSafetyCheckStatus($teamIDX, $inSafetyStatus, $classIDX);
        $str .= '</div>';
        $str .= '<div class="w3-clear"></div>';
        $str .= sprintf '<div ID="TeamReinspectionNotification_%d" class="w3-half w3-margin-bottom">', $teamIDX;
        $str .= $Tech->_getMyReinspection($teamIDX);
        $str .= '</div>';
        $str .= '<div class="w3-clear"></div>';
        foreach $panelIDX (sort {$a <=> $b} keys %PANEL) {
            $str .= '<div class="w3-quarter w3-margin-top">';
                $str .= sprintf '<div class="w3-container %s w3-padding-16 w3-border w3-card-2 w3-round">', $COLOR{$panelIDX};
                $str .= '<div class="w3-left">';
                $str .= sprintf '<i class="fa %s w3-xxlarge"></i>', $ICON{$panelIDX};
                $str .= '</div>';
                $str .= sprintf '<div class="w3-right"><h3>%2.4f</h3></div>', 0;
                $str .= '<div class="w3-clear"></div>';
                $str .= sprintf '<h4>%s</h4>', $PANEL{$panelIDX};
                $str .= '</div>';
                $str .= '</div>';
            }
        $str .= '</div>';
    }
    
    $str .= '<div class="w3-row-padding w3-margin-bottom w3-display-container w3-container w3-border w3-round w3-card-4 w3-padding-16" style="height: 90px">';
    $str .= '<span class="w3-display-left w3-margin-left">Subscription Code:<input class="w3-input w3-border w3-round" ID="sae_teamCodeEntry" style="width: 175px; "></span>';
    $str .= sprintf '<button class="w3-button w3-round w3-padding-16 w3-border w3-display-right w3-hover-blue w3-margin-right" onclick="sae_subscribeToTeam(%d, 0);">Subscribe<i class="fa fa-plus w3-margin-left" aria-hidden="true"></i></button>', $userIDX;
    $str .= '</div>';
    return ($str);
}

