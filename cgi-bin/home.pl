#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use List::Util qw(first);

#---- SAE MODULES -------
use SAE::HOME;
use SAE::REFERENCE;
use SAE::Auth;
use SAE::SCORE;
use SAE::DESIGN;
use SAE::PRESO;
use SAE::GRADE;
use SAE::REGULAR;
use SAE::ADVANCED;
use SAE::MICRO;
use SAE::TECH;
use SAE::PROFILE;
use SAE::JSONDB;
use SAE::USER;
use SAE::REG_SCORE;
use SAE::ADV_SCORE;
use SAE::MIC_SCORE;
use SAE::PUBLISH;
use SAE::EVENT;
use SAE::TABLE;
use SAE::PROFILE;
use SAE::PAPER;

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
sub main2_updatePreference (){
    print $q->header();
    my $userIDX    = $q->param('userIDX');
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $inType     = $q->param('inType');
    my $inNew      = $q->param('inNew');
    my $Event      = new SAE::EVENT();
    my $Table      = new SAE::TABLE();
    my %DATA = %{decode_json($q->param('jsonData'))};
    my ($check, $profileIDX) = $Event->_checkUserPreferences($userIDX, $eventIDX, $classIDX, $inType);
    if ($inNew == 0) {
            my %CONDITION = ('PK_PROFILE_IDX'=>$profileIDX);
            my $json_dcondition  = encode_json \%CONDITION;
            $Table->_deleteRecord('TB_PROFILE', $json_dcondition);
        } else {
            my $newProfileIDX = $Table->_saveAsNew('TB_PROFILE', $q->param('jsonData'));
            $str .= 'New IDX = '.$newProfileIDX ;
        }
    return ($str);
    }
sub openJudgesProfile (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $userIDX    = $q->param('userIDX');
    my $User       = new SAE::USER();
    my $Event      = new SAE::EVENT();
    my %EVENTS     = %{$Event->_getEventList()};
    $str .= sprintf '<div class="w3-container">';
    $str .= '<h3>You\'ve been identified as a Volunteer Judge for this event. Please update your profile and preferences for the event you are interested in participating</h3>';
    $str .= sprintf '<div class="w3-row w3-border">';
    $str .= sprintf '<div class="w3-col l2 w3-padding" >Event:<br><b>%s</b></div>',$EVENTS{$eventIDX}{TX_EVENT_NAME};
        $str .= sprintf '<div class="w3-col l2 w3-row w3-border-left w3-center" >';
        $str .= sprintf '<p class="">Max Paper</p>';
            $str .= sprintf '<div class="w3-col w3-padding" style="width: 100%">';
            $str .= sprintf '<input ID="IN_LIMIT_%d" class="w3-input w3-border-top w3-border" type="number" min="0" value="5" style="height: 38px;" >';
            $str .= sprintf '</div>';
        $str .= sprintf '</div>';
    $str .= sprintf '<div class="w3-row w3-col l3 w3-border-left">';
        $str .= sprintf '<p class="w3-center">Design Report Class Preference</p>';
            $str .= sprintf '<div class="w3-col l4 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input class="w3-check" data-class="1" data-type="1" data-event="%d" type="checkbox"onchange="main2_updatePreference(this, %d)"><br>Regular</div>' , $eventIDX, $userIDX;
            $str .= sprintf '<div class="w3-col l4 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input class="w3-check" data-class="2" data-type="1" data-event="%d" type="checkbox"onchange="main2_updatePreference(this, %d)"><br>Advanced</div>', $eventIDX, $userIDX;
            $str .= sprintf '<div class="w3-col l4 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input class="w3-check" data-class="3" data-type="1" data-event="%d" type="checkbox"onchange="main2_updatePreference(this, %d)"><br>Micro</div>'   , $eventIDX, $userIDX;
    $str .= sprintf '</div>';
    $str .= sprintf '<div class="w3-col l3 w3-border w3-row ">';
    $str .= sprintf '<p class="w3-center">Techincal Assessments</p>';
    $str .= sprintf '<div class="w3-col l4 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input data-class="0" data-type="2" data-event="%d" class="w3-check" type="checkbox" onchange="main2_updatePreference(this, %d)"><br>TDS</div>',          $eventIDX, $userIDX;
    $str .= sprintf '<div class="w3-col l4 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input data-class="0" data-type="3" data-event="%d" class="w3-check" type="checkbox" onchange="main2_updatePreference(this, %d)"><br>Drawing</div>',      $eventIDX, $userIDX;
    $str .= sprintf '<div class="w3-col l4 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input data-class="0" data-type="4" data-event="%d" class="w3-check" type="checkbox" onchange="main2_updatePreference(this, %d)"><br>Requirements</div>', $eventIDX, $userIDX;
    $str .= sprintf '</div>';
    $str .= sprintf '<div class="w3-col l2 w3-border w3-row ">';
    $str .= sprintf '<p class="w3-center">Presentations</p>';
    $str .= sprintf '<div class="w3-col l12 w3-small w3-border-top w3-center" style="padding: 4px 6px;"><input data-class="0" data-type="5" data-event="%d" class="w3-check" type="checkbox" onchange="main2_updatePreference(this, %d)"><br>Yes</div>', $eventIDX, $userIDX;

    $str .= sprintf '</div>';
    $str .= sprintf '</div>';  # End of w3-row
    $str .= '<div class="w3-container w3-center w3-padding w3-margin">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-margin-top w3-hover-green w3-pale-green second" onclick="profile_close(this, 0);">Close</button>';
    $str .= '</div>';
    $str .= sprintf '</div>';  # End of Container
    return ($str);
    }
sub sae_unsubscribeToTeam(){
    print $q->header();
    my $userTeamIDX = $q->param('userTeamIDX');
    my $Auth = new SAE::Auth();
    $Auth->_deleteUserTeam($userTeamIDX);

    return ($userTeamIDX);
    }
sub home_teamplateFlightResults (){
    my ($txTitle, $inScore) = @_;
    my $str;
    $str .= '<div class="w3-col l6 w3-padding">';
    $str .= '<div class="w3-border-right w3-border-top w3-border-left w3-padding w3-round">';
    $str .= sprintf '<h5>%s</h5>', $txTitle;
    $str .= sprintf '<h5>Points: %1.4f</h5>', $inScore;
    $str .= '</div>';
    $str .= '<a class="w3-button w3-block w3-border-right w3-border-bottom w3-border-left w3-light-grey w3-hover-blue" href="javascript:void(0);">View Details</a>';
    $str .= '</div>';
    }
sub home_templateScoringTiles(){
    my ($txTitle, $teamIDX, $inSource, $inScore, $inStatus) = @_;
    my $eIDX  = crypt($teamIDX, '20');
    my $str;
    $str .= '<div class="w3-col l4 w3-padding">';
    $str .= '<div class="w3-border-right w3-border-top w3-border-left w3-padding w3-round">';
    $str .= sprintf '<h5>%s</h5>', $txTitle;
    if ($inStatus==1){
        $str .= sprintf '<h5>Points: <b>%1.4f</b></h5>', $inScore;
    } else {
        $str .= sprintf '<h5>Points: <b>Not Available</b></h5>';
    }
    $str .= '</div>';
    if ($inStatus==1){
        $str .= sprintf '<a class="w3-button w3-block w3-border-right w3-border-bottom w3-border-left w3-light-grey w3-hover-blue" href="score.html?teamIDX=%s&source=%d" target="_blank">View Details</a>', $eIDX, $inSource;
    } else {
        $str .= sprintf '<a class="w3-button w3-block w3-border w3-light-grey w3-disabled" href="javascript:void(0);">To Be Published</a>';

    }
    $str .= '</div>';

    # <a href="score.html?teamIDX=%s&source=%d" target="_blank"><h3>%2.4f</h3></a>
}
sub sae_loadHomePage(){
    print $q->header();
    my %PANEL    = (1=>'Design',2=>'Presentation' ,3=>'Penalties',4=>'Flights',5=>'Results');
    my %COLOR    = (1=>'w3-pale-green',2=>'w3-pale-blue',3=>'w3-pale-red',4=>'w3-light-grey', 5=>'w3-sand');
    my %ICON     = (1=>'fa-paperclip', 2=>'fa-desktop', 3=>'fa-exclamation-triangle', 4=>'fa-plane', 5=>'fa-trophy');
    my %TITLE    = (1=>'Design Report', 2=>'Presentation Scores');
    my $userIDX  = $q->param('userIDX');
    # my $location = $q->param('location');
    my $eventIDX = $q->param('location');
    my $Home     = new SAE::HOME();
    my %TEAMS    = %{$Home->_getTeamSubscriptionsByUserID($userIDX, $eventIDX)};

    my $Publish  = new SAE::PUBLISH();
    my $Grade    = new SAE::GRADE();
    my $Design   = new SAE::DESIGN();
    my $Preso    = new SAE::PRESO();
    my $Score    = new SAE::SCORE();
    my $Reg      = new SAE::REG_SCORE();
    my $Adv      = new SAE::ADV_SCORE();
    my $Mic      = new SAE::MIC_SCORE();
    my $Tech     = new SAE::TECH();
    my $Paper    = new SAE::PAPER();
    my $Publish  = new SAE::PUBLISH();
    my $str = '<div class="w3-container w3-white w3-margin-top">';
    $str .= '<header class="w3-container" style="padding-top:22px">';
    $str .= '<h5><b><i class="fa fa-dashboard"></i> My  Dashboard</b></h5>';
    $str .= '<div class="w3-bar w3-black w3-margin-top" style="w3-margin-top: 25px;">';
        $str .= sprintf '<button class="w3-bar-item w3-button paperTab" onclick="student_LinkPage(this);" >Link Team</button>';
        $str .= '</div>';
    $str .= '<div ID="link_content" class="w3-container w3-border w3-round w3-padding w3-hide">';
    $str .= '<input ID="TEAM_LINK_NUMBER" type="number" class="w3-input w3-border w3-round" style="width: 120px; display: inline-block">';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-green w3-hover-green w3-margin-left" onclick="student_linkTeam(this);">Link Team</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-red w3-hover-red w3-margin-left" onclick="student_LinkPage(this);">Cancel</button>';
    $str .= '</div>';
    $str .= '</header>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS ) {
    $str .= '<div class="w3-row">';
        my %SCORES              = %{$Grade->_getScoringSummary($teamIDX)};
        my $Penalty             = $Tech->_getTeamTechPenalties($teamIDX);
        my $classIDX            = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $inScore             = $Paper->_generateDesignScores($eventIDX, $teamIDX);
        my $inLateScore         = $Paper->_getLateScore($teamIDX);
        my $DesignPublishStatus = $Publish->_getPubishStatus($eventIDX, $classIDX, 1);  #1 = Design Report
        my $PresoPublishStatus  = $Publish->_getPubishStatus($eventIDX, $classIDX, 2);  #2 = Presentation Report
        $str .= sprintf '<div class="w3-col l12 w3-padding">';
        $str .= sprintf '<div class="w3-border w3-display-container w3-round w3-topbar w3-border-blue-grey w3-padding w3-light-grey">';
        $str .= sprintf '<a href="javascript:void(0);" class="w3-display-topright w3-small w3-margin-right" onclick="student_unlinkTeam(this, %d);">Unlink %03d</a>', $teamIDX, $TEAMS{$teamIDX}{IN_NUMBER};
        $str .= sprintf '<div><h3>%03d: %s</h3></div>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        # $str .= sprintf '<div><h2>Current Overall Score: %1.4f</h2></div>', 0;
        $str .= sprintf '</div>';
        $str .= sprintf '</div>';
        $str .= sprintf '<div class="w3-col l6 w3-padding">';
        $str .= sprintf '<div class="w3-border-right w3-border-top w3-border-left  w3-padding w3-white">';
        $str .= sprintf '<h3>ACTION: Self-Certify Requirement</h3>';
        $str .= sprintf '<p class="w3-small w3-margin-bottom"><b>Requirements Inspection:</b> Team will have to self-certify that the team has checked and met <u>all</u> requirements specified in the current ruleset';
        $str .= sprintf 'Please reference REQUIREMENTS CHECK & SAFETY AND AIRWORTHINESS INSPECTION PENALTIES in the rules document for further details</p>';
        $str .= sprintf '</div>';
        $str .= sprintf '<button class="w3-button w3-block w3-green w3-border-right w3-border-bottom w3-border-leftw3-hover-blue" onclick="student_openRequirementsChecks(this, %d, %d);">Certify Requirements</button>', $teamIDX, $classIDX;
        # onclick="student_openRequirementsChecks(this, %d, %d)">', $teamIDX, $teamIDX, $classIDX;
        $str .= sprintf '</div>';
        $str .= sprintf '<div class="w3-col l6 w3-padding">';
        $str .= sprintf '<div class="w3-border-right w3-border-top w3-border-left w3-padding w3-white">';
        $str .= sprintf '<h3>ACTION: Safety Inspection</h3>';
        $str .= sprintf '<p class="w3-small w3-margin-bottom"><b>Safety Inspection:</b> Team will have to self-certify that the team has checked and met <u>all</u>  requirements specified in the current ruleset';
        $str .= sprintf 'Please reference REQUIREMENTS CHECK & SAFETY AND AIRWORTHINESS INSPECTION PENALTIES in the rules document for further details</p>';
        $str .= sprintf '</div>';
        $str .= sprintf '<button class="w3-button w3-block w3-green w3-border-right w3-border-bottom w3-border-left w3-hover-blue" onclick="student_openSafetyChecks(this, %d, %d);">Certify Air-System Safety</button>', $teamIDX, $classIDX;
        $str .= sprintf '</div>';

        $str .= '<div class="w3-rest"></div>';
        $str .= &home_templateScoringTiles('Design', $teamIDX, 14, $inScore - $inLateScore, $DesignPublishStatus);
        $str .= &home_templateScoringTiles('Presentation', $teamIDX, 15, $SCORES{5}, $PresoPublishStatus);
        $str .= &home_templateScoringTiles('Penalties', $teamIDX, 16, $Penalty);
        $str .= '<div class="w3-rest"></div>';
        $str .= &home_teamplateFlightResults('Flights', 0);
        $str .= &home_teamplateFlightResults('Standings', 0);
        $str .= '<div class="w3-rest"></div>';

        $str .= '<hr>';

    $str .= '</div>';  # end of Row Div
    }
    

# ------------
    # foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS ) {
    #     my $eventIDX            = $TEAMS{$teamIDX}{FK_EVENT_IDX};
    #     my $classIDX            = $TEAMS{$teamIDX}{FK_CLASS_IDX};
    #     my $inSafetyStatus      = $Tech->_getTeamSafetyStatus($teamIDX, $classIDX);
    #     my $inRequirementStatus = $Tech->_getTeamInspectionStatus($teamIDX, $classIDX);
    #     $str .= '<div class="w3-row-padding w3-padding w3-border w3-round w3-margin-top w3-card-4 w3-light-grey">';
    #     $str .= sprintf '<header class="w3-container w3-light-grey"><span class="w3-xxlarge">%03d</span> - <span class="w3-xlarge" style="padding: 0; margin: 0;">%s</span></header>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
    #     $str .= sprintf '<div ID="TeamReuirements_%d" class="w3-half w3-margin-bottom">', $teamIDX;
    #     $str .= $Tech->_getTechRequirementsCheckStatus($teamIDX, $inRequirementStatus, $classIDX);
    #     $str .= '</div>';
    #     $str .= sprintf '<div ID="TeamSafety_%d" class="w3-half w3-margin-bottom">', $teamIDX;
    #     $str .= $Tech->_getTechSafetyCheckStatus($teamIDX, $inSafetyStatus, $classIDX);
    #     $str .= '</div>';
    #     $str .= '<div class="w3-clear"></div>';
    #     $str .= sprintf '<div ID="TeamReinspectionNotification_%d" class="w3-half w3-margin-bottom">', $teamIDX;
    #     $str .= $Tech->_getMyReinspection($teamIDX);
    #     $str .= '</div>';
    #     $str .= '<div class="w3-clear"></div>';
    #     foreach $panelIDX (sort {$a <=> $b} keys %PANEL) {
    #         my $mScore = 0;
    #         my $raw   = 0;
    #         my $late  = 0;
    #         my $late  = 0;
    #         my $eIDX  = crypt($teamIDX, '20');
    #         my $source = 14;
    #         if ($panelIDX == 1){
    #             my ( $raw, $late ) = $Design->_getOverallPaperByTeam($teamIDX);
    #             $Score = $raw - $late;
    #             $source = 14;
    #         } elsif ($panelIDX == 2) {
    #             $Score = $Preso->_getPresoScoreByTeam($teamIDX, 5);
    #             $source = 15;
    #         } elsif ($panelIDX == 3) {
    #             $Score = $Tech->_getTechPenalties($teamIDX);
    #             $source = 16;
    #         } elsif ($panelIDX >=4) {
    #             $source = 17;
    #             if ($classIDX==1){
    #                 $Score = $Reg->_getScore($teamIDX);
    #             } elsif ($classIDX==2) {
    #                 $Score = $Adv->_getScore($teamIDX);
    #             } elsif ($classIDX==3) {
    #                 $Score = $Mic->_getScore($teamIDX);
    #             }
    #         }
    #         if ($Score<0){$Score=0}
    #         if ($panelIDX<=4){
    #                 my $publishStatus = $Publish->_getPublishStatus($eventIDX, $classIDX, $TITLE{$panelIDX});
    #                 $str .= '<div class="w3-quarter w3-margin-top">';
    #                 $str .= sprintf '<div class="w3-container %s w3-padding-16 w3-border w3-card-2 w3-round">', $COLOR{$panelIDX};
    #                 $str .= '<div class="w3-left">';
    #                 $str .= sprintf '<i class="fa %s w3-xxlarge"></i>', $ICON{$panelIDX};
    #                 $str .= '</div>';
    #                 if ($panelIDX>2){
    #                         $str .= sprintf '<div class="w3-right"><a href="score.html?teamIDX=%s&source=%d" target="_blank"><h3>%2.4f</h3></a></div>', $eIDX, $source, $Score;
    #                     } else {
    #                         if ($publishStatus==1){
    #                                 $str .= sprintf '<div class="w3-right"><a href="score.html?teamIDX=%s&source=%d" target="_blank"><h3>%2.4f</h3></a></div>', $eIDX, $source, $Score;
    #                             } else {
    #                                 $str .= '<div class="w3-right"><h4><i>To be published</i></h4></div>';
    #                             }
    #                     }
    #                 $str .= '<div class="w3-clear"></div>';
    #                 $str .= sprintf '<h4>%s</h4>', $PANEL{$panelIDX};
    #                 # $str .= '</a>';
    #                 $str .= '</div>';
    #                 $str .= '</div>';
    #                 $Score = 0;
    #             } else {
    #                 $str .= sprintf '<div class="w3-quarter w3-margin-top" >';
    #                 $str .= sprintf '<div class="w3-container %s w3-padding-16 w3-border w3-card-2 w3-round">', $COLOR{$panelIDX};
    #                 $str .= '<div class="w3-left">';
    #                 $str .= sprintf '<i class="fa %s w3-xxlarge"></i>', $ICON{$panelIDX};
    #                 $str .= '</div>';
    #                 $str .= sprintf '<div class="w3-right"><a style="text-decoration: none;" href="javascript:void(0);" onclick="sae_openResultStandings(%d);"><h3>[ View ]</h3></a></div>',$classIDX;
    #                 # $str .= '<div class="w3-clear"> '.$teamIDX.' - '.$panelIDX .'</div>';
    #                 $str .= '<div class="w3-clear"></div>';
    #                 $str .= sprintf '<h4>%s</h4>', $PANEL{$panelIDX};
    #                 # $str .= '</a>';
    #                 $str .= '</div>';
    #                 $str .= '</div>';
    #             }
    #         }
    #     $str .= '</div>';
    # }
    # $str .= '<div class="w3-row-padding w3-margin-bottom w3-display-container w3-container w3-border w3-round w3-card-4 w3-padding-16" style="height: 90px">';
    # $str .= '<span class="w3-display-left w3-margin-left">Subscription Code:<input class="w3-input w3-border w3-round" ID="sae_teamCodeEntry" style="width: 175px; "></span>';
    # $str .= sprintf '<button class="w3-button w3-round w3-padding-16 w3-border w3-display-right w3-hover-blue w3-margin-right" onclick="sae_subscribeToTeam(%d, 0);">Subscribe<i class="fa fa-plus w3-margin-left" aria-hidden="true"></i></button>', $userIDX;
    # $str .= '</div>';
    return ($str);
    }

