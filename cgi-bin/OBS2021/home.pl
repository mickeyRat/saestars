#!/usr/bin/perl
use cPanelUserConfig;

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
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    my $Home = new SAE::HOME();
    my $Score = new SAE::SCORE();
    %TEAMS = %{$Home->_getTeamSubscriptionsByUserID($userIDX, $location)};
    %TILES = %{$Home->_getTiles()};
    %COLOR = (1=>'w3-green',2=>'w3-teal',3=>'w3-red',4=>'w3-blue');
    %TODO = %{$Home->_getAllToDoByEvent($location)};
    %FLIGHTS = %{$Home->_getFlightRounds($userIDX, $location)};
    
    my $str;
    $str = '<br>';
    my $userTeamIDX;
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS ) {
        my $txFile = '';
        my $fileID = '';
        $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        ($SCORE[14], $late) =  $Score->_getOverallPaperByTeam($teamIDX);
        $SCORE[15] = $Score->_getPresoScoreByTeam($teamIDX,5);
        $SCORE[16] = $Score->_getTotalPenaltiesByTeam($teamIDX,$location);
        if ($classIDX == 1){
            my ($ffs, $maxPPB, $FS1, $FS2, $FS3, $t3ffs) = $Score->_getRegularFinalFlightScore($teamIDX, $location);
            $SCORE[17] = $ffs;
        } elsif ($classIDX == 2) {
            $SCORE[17] = $Score->_getAdvancedScoreByTeam($teamIDX,$location);
            # $str .= "********************************************* $teamIDX,$location,$SCORE[17] ";
        } else {    
            ($SCORE[17], $avg, $max, $demo) = $Score->_getMicroFlightScoreByTeam( $teamIDX , $location );
        }
        
        $userTeamIDX = $TEAMS{$teamIDX}{PK_USER_TEAM_IDX};
        $str .= '<div class="w3-round-large w3-display-container w3-card-4 w3-margin w3-margin-top">';
        $str .= '<h5 class="w3-margin w3-margin-top w3-padding"><b><i class="fa fa-dashboard"></i>Team #:'.substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL}.' Dashboard</b></h5>';
        $str .= '<div class="w3-row-padding w3-margin-bottom">';
        foreach $tileIDX (sort {$TILES{$a}{IN_ORDER} <=> $TILES{$b}{IN_ORDER}} keys %TILES) {
            my $eIDX = crypt($teamIDX, '20');
            $str .= '<div class="w3-quarter" >';
            $str .= '<div class="w3-container '.$COLOR{$TILES{$tileIDX}{IN_ORDER}}.' w3-padding-16">';
            $str .= '<div class="w3-left"><i class="fa fa-paperclip w3-xxxlarge"></i></div>';
            $str .= '<div class="w3-right">';
            if ($tileIDX==14) {
                 if ($late > $SCORE[$tileIDX] ){
                     $SCORE[$tileIDX] = 0;
                 } else {
                    $SCORE[$tileIDX] =  $SCORE[$tileIDX] - $late;
                 }
                 
                 
            } 
            $str .= sprintf '<h3><a class="w3-text-white" href="score.html?teamIDX='.$eIDX.'&source='.$tileIDX.'" target="_blank">%2.4f</a></h3>', $SCORE[$tileIDX];
            $str .= '</div>';
            $str .= '<div class="w3-clear"></div>';
            $str .= '<h5>'.$TILES{$tileIDX}{TX_TITLE}.'</h5>';
            $str .= '</div>';
            $str .= '</div>';
        }
        $str .= '</div>';
        $str .= '<div id="mainPageToDo" class="w3-container">';
        $str .= '<h5>TO DOs</h5>';
        $str .= '<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable w3-white">';
        $str .= '<tr class="w3-hide-small">';
        $str .= '<th style="width: 35%;">Todo</th>';
        $str .= '<th style="width: 15%;">Time</th>';
        $str .= '<th style="width: 30%;">Location</th>';
        $str .= '<th style="width: 20%;">Status</th>';
        $str .= '</tr>';
        foreach $todoIDX (sort {$a <=> $b} keys %{$TODO{$teamIDX}}) {
            $str .= '<tr class="w3-hide-small">';
            $str .= '<td>'.$TODO{$teamIDX}{$todoIDX}{TX_TODO}.'</td>';
            $str .= '<td>'.$TODO{$teamIDX}{$todoIDX}{TX_TIME}.'</td>';
            $str .= '<td>'.$TODO{$teamIDX}{$todoIDX}{TX_ROOM}.'</td>';
            $str .= '<td>'.$TODO{$teamIDX}{$todoIDX}{TX_STATUS}.'</td>';
            $str .= '</tr>';
            $str .= '<tr class="w3-hide-medium w3-hide-large">';
            $str .= '<td>';
            $str .= sprintf '<b>To Do:</b> <span class="w3-text-blue">%s</span><br>', $TODO{$teamIDX}{$todoIDX}{TX_TODO};
            $str .= sprintf '<b>Time:</b> <span class="w3-text-blue">%s</span><br>', $TODO{$teamIDX}{$todoIDX}{TX_TIME};
            $str .= sprintf '<b>Location:</b> <span class="w3-text-blue">%s</span><br>', $TODO{$teamIDX}{$todoIDX}{TX_ROOM};
            $str .= sprintf '<b>Status:</b> <span class="w3-text-blue">%s</span><br>', $TODO{$teamIDX}{$todoIDX}{TX_STATUS};
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '</table><br>';
        $str .= '</div>';
        
        $txFile = $Score->_getPublishedFridayResults($classIDX, $location, 14);
        $str .= '<div id="mainPageDesign" class="w3-container">';
        $str .= '<h5>Published Design Results</h5>';
        $str .= '<ul class="w3-ul w3-container w3-border w3-white">';
        if ($txFile){
            $str .= '<li><a href="post.html?fileID='.$txFile.'" target="_blank">Design Results</a></li>';
        } else {
            $str .= '<li>Not Published Yet</li>';
        }

        $str .= '</ul>';
        $str .= '</div>';
        $txFile = $Score->_getPublishedFridayResults($classIDX, $location, 15);
        $str .= '<div id="mainPagePreso" class="w3-container">';
        $str .= '<h5>Published Presentation Results</h5>';
        $str .= '<ul class="w3-ul w3-container w3-border w3-white">';
        if ($txFile){
            $str .= '<li><a href="post.html?fileID='.$txFile.'" target="_blank">Presentation Results</a></li>';
        } else {
            $str .= '<li>Not Published Yet</li>';
        }
        $str .= '</ul>';
        $str .= '</div>';

        $str .= '<div id="mainPageFlights" class="w3-container">';
        $str .= '<h5>Published Round Results</h5>';
        %PUB = %{$Score->_getStandings($teamIDX, $classIDX, $location)};
        $str .= '<table class="w3-table w3-striped w3-bordered w3-border w3-hoverable w3-white">';
        $str .= '<tr class="w3-hide-small">';
        $str .= '<th style="width: 15%;">Round #</th>';
        $str .= '<th style="width: ">...</th>';
        $str .= '</tr>';
        %POST = (1=>'st', 2=>'nd', 3=>'rd', 4=>'th', 5=>'th', 6=>'th', 7=>'th',8=>'th', 9=>'th', 0=>'th');
        foreach $inRound(sort {$a <=> $b} keys %PUB) {
            my @RANK = ();
            my %TEAMS = ();
            if ($classIDX==3){
                %TEAMS = %{$Score->_getTeamFlgihtScoresByClass($location, $classIDX, $inRound )};
            } elsif ($classIDX==2) {
                %TEAMS = %{$Score->_getAdvancedFlightsByEvent($location,  $inRound, $classIDX)};
            } else {
                %TEAMS = %{$Score->_getRegularFlightsByEvent($location,  $inRound, $classIDX)};
            }
            push (@RANK, sort {$TEAMS{$b}{IN_OVERALL} <=> $TEAMS{$a}{IN_OVERALL}} keys %TEAMS);
            my $idx = first { $RANK[$_] == $teamIDX } 0..$#RANK;
            $post = substr(($idx+1),-1,1);
            $str .= '<tr class="w3-hide-small">';
            $str .= '<td>'.$inRound.'</td>';
            $str .= '<td><a href="post.html?fileID='.$PUB{$inRound}.'" target="_blank">View</a></td>';
            # $str .= '<td><a href="post.html?fileID='.$PUB{$inRound}.'" target="_blank">Rank: '.($idx+1).' '.$POST{$post}.'</a></td>';
            $str .= '</tr>';
            $str .= '<tr class="w3-hide-medium w3-hide-large">';
            $str .= '<td>';
            $str .= sprintf '<b>Round:</b> <span class="w3-text-blue">%2.0f (<a class="w3-text-blue" href="post.html?fileID='.$PUB{$inRound}.'" target="_blank">Rank: '.($idx+1).' '.$POST{$post}.'</a>)</span><br>', $inRound;
            $str .= '</td>';
            $str .= '</tr>';

        }
        $str .= '</table><br>';
        $str .= '</div>';
        $str .= '<hr>';
        $str .= '</div>';
        $str .= '</div>';
    }
    $str .= '<div class="w3-round-large w3-display-container w3-card-2 w3-margin w3-margin-top w3-margin-bottom">';
    $str .= '<div class="w3-container" style="margin-top: 30px;">';
    $str .= '<h5>Team Subscription Code</h5>';
    $str .= '<input type="text" ID="sae_teamCodeEntry" class="w3-border w3-padding" style="width: 150px;">';
    $str .= '&nbsp;&nbsp;<button class="w3-button w3-circle w3-teal w3-large" onclick="sae_subscribeToTeam('.$userIDX.', 0);">+</button><br>';
    $str .= '<label>Invitation Code</label>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<br><br>';
    return ($str);
}

sub __template(){
    print $q->header();
    my $str;

    return ($str);
}
