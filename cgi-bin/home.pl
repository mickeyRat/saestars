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
sub sae_unsubscribeToTeam(){
    print $q->header();
    my $userTeamIDX = $q->param('userTeamIDX');
    my $Auth = new SAE::Auth();
    $Auth->_deleteUserTeam($userTeamIDX);

    return ($userTeamIDX);
}
sub sae_loadHomePage(){
    print $q->header();
    my %PANEL = (1=>'Design Scores',2=>'Presentation Scores' ,3=>'Penalties',4=>'Flights',5=>'Results');
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
    $str .= '<h5><b><i class="fa fa-dashboard"></i> My Dashboard</b></h5>';
    $str .= '</header>';

    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS ) {
        $str .= $Tech->_getMyReinspection();
        $str .= '<div class="w3-row-padding w3-padding w3-border w3-round">';
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
    
    ## - Section for when teams have to be reinspected


    ## - Section for tam scores




    # my %SCORE = ();
    # foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS ) {
    #     my $finalScore =0;
    #     my $classIDX= $TEAMS{$teamIDX}{FK_CLASS_IDX};
    #     my $reinspect = $Tech->_checkIfReInspectIsNeeded($location, $teamIDX);
    #     if ($classIDX==3){
    #         my $Obj=new SAE::MICRO();
    #         my ($TOPS, $FLIGHTS) = $Obj->_calcTeamScore($teamIDX);
    #         my %SCORE = %{$FLIGHTS};
    #         my @SORTED = @$TOPS;
    #         $finalScore = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS};
    #     } elsif ($classIDX==2) {
    #         my $Obj=new SAE::ADVANCED();
    #         my ($inStd, $boAuto, $inWater, $waterFlown, $SCORES) = $Obj->_calcTeamScore($teamIDX);
    #         my %SCORE = %{$SCORES};
    #         my $gtvMultiplier = 2.0;
    #         if ($boAuto<1) {$gtvMultiplier = 1.5}
    #         my $waterScore = ($waterFlown + $gtvMultiplier*$inWater)/4;
    #         my $SUM_PADA = 0;
    #         foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
    #             my $subScore = ($SCORE{$flightIDX}{APADA} + $SCORE{$flightIDX}{BPADA});
    #             my $totalAttemptScore = $subScore - ($SCORE{$flightIDX}{IN_MINOR} * $subScore) - ($SCORE{$flightIDX}{IN_MAJOR} * $subScore);
    #             $SUM_PADA += $totalAttemptScore;
    #         }
    #         $finalScore = ($waterScore + (4*$SUM_PADA));
    #     }else {
    #         my $Obj=new SAE::REGULAR();
    #         my ($maxPPB, $TOPS, $SCORES) = $Obj->_calcTeamScore($teamIDX);
    #         my %SCORE = %{$SCORES};
    #         my @SORTED = @$TOPS;
    #         $finalScore = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS} + $maxPPB; 
    #     }
    #     if ($reinspect){
    #         $str .= sprintf '<div ID="UT_%d" class="w3-row-padding w3-margin-bottom w3-display-container w3-border w3-round w3-card-4 sae_team_dashboard_%d w3-red"><br>', $TEAMS{$teamIDX}{PK_USER_TEAM_IDX}, $teamIDX;
    #         $str .= sprintf '<H1 class="sae_team_dashboard_header_%d blink_me">ALERT!!!<br>Reinspect required before your next flight attempt</H1>', $teamIDX;    
    #     } else {
    #         $str .= sprintf '<div ID="UT_%d" class="w3-row-padding w3-margin-bottom w3-display-container w3-border w3-round w3-card-4 sae_team_dashboard_%d"><br>', $TEAMS{$teamIDX}{PK_USER_TEAM_IDX}, $teamIDX;
    #         $str .= sprintf '<H1 class="w3-hide sae_team_dashboard_header_%d blink_me">ALERT!!!<br>Reinspect required before your next flight attempt</H1>', $teamIDX; 
    #     }
    #     $str .= sprintf '<div class="w3-dropdown-click w3-border w3-round w3-white w3-display-topright w3-margin-top w3-margin-right" >';
    #     $str .= sprintf '<button class="w3-button w3-round" onclick="sae_menuDropDown(%d);"><i class="fa fa-ellipsis-h" aria-hidden="true"></i></button>', $TEAMS{$teamIDX}{PK_USER_TEAM_IDX};
    #     $str .= sprintf '<div id="subMenu_%d" class="w3-dropdown-content w3-bar-block w3-border w3-right w3-card-2" style="left: -115px!important">', $TEAMS{$teamIDX}{PK_USER_TEAM_IDX};
    #     $str .= sprintf '<a href="javascript:void();" class="w3-bar-item w3-button" onclick="sae_unscuscribe(%d);"><i class="fa fa-times" aria-hidden="true"></i>&nbsp;Un-subscribe</a>', $TEAMS{$teamIDX}{PK_USER_TEAM_IDX};
    #     $str .= '</div>';
    #     $str .= '</div>';
    #     # $str .= sprintf '<button class="w3-button w3-border w3-round w3-white w3-hover-red w3-display-topright w3-margin-top w3-margin-right" onclick="sae_unscuscribe(%d);">X</button>', $TEAMS{$teamIDX}{PK_USER_TEAM_IDX};
    #     $str .= sprintf '<h3 class="w3-margin-left">Team #:%03d<br>%s</h3>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        
    #     foreach $idx (sort {$a <=> $b} keys %PANEL) {
    #         my $eIDX = crypt($teamIDX, '20');
    #         my $score = 0;
    #         my $late = 0;
    #         my $btn = '';
    #         if ($idx==1){
    #             ($score, $late) = $Design->_getOverallPaperByTeam($teamIDX);
    #             if ($late>50){
    #                 $score = 0;
    #             } else {
    #                 $score -= $late;
    #             }
    #             $btn = sprintf '<div class="w3-right w3-button w3-round w3-margin-top"><h6><a class="w3-text-black" style="text-decoration: none;" href="score.html?teamIDX=%s&source=%d" target="_blank">%2.4f</a><i class="fa fa-chevron-right w3-margin-left" aria-hidden="true"></i></h6></div>', $eIDX, '14', $score;
    #         } elsif ($idx==2) {
    #             $score = $Preso->_getPresoScoreByTeam($teamIDX, 5);
    #             $btn = sprintf '<div class="w3-right w3-button w3-round w3-margin-top "><h6><a class="w3-text-black" style="text-decoration: none;" href="score.html?teamIDX=%s&source=%d" target="_blank">%2.4f</a><i class="fa fa-chevron-right w3-margin-left" aria-hidden="true"></i></h6></div>', $eIDX, '15', $score;
    #         } elsif ($idx==3) {
    #             $score = $Score->_getTotalPenaltiesByTeam($teamIDX,$location);
    #             $btn = sprintf '<div class="w3-right w3-button w3-round w3-margin-top "><h6><a class="w3-text-black" style="text-decoration: none;" href="score.html?teamIDX=%s&source=%d" target="_blank">%2.4f</a><i class="fa fa-chevron-right w3-margin-left" aria-hidden="true"></i></h6></div>', $eIDX, '16', $score;
    #         } elsif ($idx==5) {
    #             $score = 'Standings';
    #             $btn = sprintf '<button class="w3-right w3-button w3-round w3-margin-top" onclick="sae_openResultStandings(%d);"><h6>%s<i class="fa fa-chevron-right w3-margin-left" aria-hidden="true"></i></h6></button>', $TEAMS{$teamIDX}{FK_CLASS_IDX}, $score;
    #         } else {
    #             $score = 'Flt. Log';
    #             # $btn = sprintf '<button class="w3-right w3-button w3-round w3-margin-top" onclick="sae_openReadOnlyFlightCard(%d,\'%03d\', %d);"><h6>%s<i class="fa fa-chevron-right w3-margin-left" aria-hidden="true"></i></h6></button>', $teamIDX, $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{FK_CLASS_IDX}, $score;
    #             $btn = sprintf '<button class="w3-right w3-button w3-round w3-margin-top" onclick="sae_calcFlightScores(%d, %d, %d);"><h6>%2.4f<i class="fa fa-chevron-right w3-margin-left" aria-hidden="true"></i></h6></button>', $location, $classIDX, $teamIDX, $finalScore;
    #         }
    #         $str .= '<div class="w3-quarter w3-margin-bottom w3-display-container w3-round">';
    #         $str .= sprintf '<div class="w3-container %s w3-padding-16 w3-round">', $COLOR{$idx};
    #         $str .= sprintf '<div class="w3-display-topleft w3-margin-left w3-margin-top">%s</div>', $PANEL{$idx};
    #         $str .= $btn;
    #         $str .= '</div>';
    #         $str .= '</div>';
    #     }
    #     $str .= '</div>';
    # }
    
    $str .= '<div class="w3-row-padding w3-margin-bottom w3-display-container w3-container w3-border w3-round w3-card-4 w3-padding-16" style="height: 90px">';
    $str .= '<span class="w3-display-left w3-margin-left">Subscription Code:<input class="w3-input w3-border w3-round" ID="sae_teamCodeEntry" style="width: 175px; "></span>';
    $str .= sprintf '<button class="w3-button w3-round w3-padding-16 w3-border w3-display-right w3-hover-blue w3-margin-right" onclick="sae_subscribeToTeam(%d, 0);">Subscribe<i class="fa fa-plus w3-margin-left" aria-hidden="true"></i></button>', $userIDX;
    $str .= '</div>';
    return ($str);
}

sub __template(){
    print $q->header();
    my $str;

    return ($str);
}
