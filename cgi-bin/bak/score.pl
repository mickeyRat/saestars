#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use feature qw(switch);
use Cwd 'abs_path';

#---- SAE MODULES -------
use SAE::SCORE;
use SAE::RUBRIC;
use SAE::HOME;
use SAE::REFERENCE;
use List::Util qw(sum first) ;

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
# ====================== 2020 =============================
sub average(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
}
sub viewMyScoreCard(){
    print $q->header();
    my $eIDX = $q->param('teamIDX');
    my $location = $q->param('location');
    my $tileIDX = $q->param('source');
    my $Score = new SAE::SCORE();
    # my $Home = new SAE::HOME();
    # %TILES = %{$Home->_getTiles()};
    %TEAMS = %{$Score->_getTeamDataWithCrypt($location)};
    my $str;
    my $txFullName = $TEAMS{$eIDX}{TX_FULLNAME};
    my $teamIDX = $TEAMS{$eIDX}{PK_TEAM_IDX};
    my $classIDX = $TEAMS{$eIDX}{FK_CLASS_IDX};
   
    if ($tileIDX == 14){
        $str .= &_displayReportScores($teamIDX, $classIDX, $txFullName, $tileIDX);
    } elsif ($tileIDX == 15) {
        $str = &_displayPresoScores($teamIDX, $classIDX, $txFullName, $tileIDX);
    } elsif ($tileIDX == 16) {
        $str = &_displayPenalties($teamIDX, $classIDX, $txFullName, $tileIDX, $location );
    } elsif ($tileIDX == 17){
        if ($classIDX==1){
            $str = &_displayRegularFlights( $teamIDX, $classIDX, $txFullName, $tileIDX, $location );
        } elsif ($classIDX==2) {
            $str = &_displayAdvancedFlights( $teamIDX, $classIDX, $txFullName, $tileIDX, $location );
        } else {
            $str = &_displayMicroFlights( $teamIDX, $classIDX, $txFullName, $tileIDX, $location );
        }
    }
    return ($str);
};
sub _displayPresoScores(){
    my $teamIDX = shift;
    my $classIDX = shift;
    my $txFullName = shift;
    my $tileIDX = shift;
    my $cardTypeIDX=5;
    my $Score = new SAE::SCORE();
    my $Rubric=new SAE::RUBRIC();
    my $Home = new SAE::HOME();
    my %SECTION = %{$Rubric->_getSectionList()};
    my %SUB = %{$Rubric->_getSubSectionList()};
    my %TILES = %{$Home->_getTiles()};
    my %CTYPE = %{$Rubric->_getRubricType()};
    my $overallScore = $Score->_getPresoScoreByTeam($teamIDX,$cardTypeIDX);
    my %JUDGES = %{$Score->_getJudgesForPaper($teamIDX)};
    my @JUDGE = (keys %{$JUDGES{$cardTypeIDX}});
    my %COMMENTS = %{$Score->_getComments($teamIDX)};
    my $str;
    $str .= sprintf "<h3>%s<br>", $txFullName;
    $str .= sprintf "Total Score: <u>%2.4f</u> pts</h3>", $overallScore;
    $str .= '<h4>Scores Details </h4>';
    
    # $str .= ($#JUDGE + 1);
    $str .= '<div class="w3-container w3-round w3-margin-top w3-border">';
    $str .= '<h3>'.$CTYPE{$cardTypeIDX}{TX_TITLE}.'</h3>';
    $str .= '<table class="w3-table w3-bordered w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th>Title</th>';
    $str .= '<th>Description</th>';
    $str .= '<th>Weight (max Pts)</th>';
    for ($i=1; $i<=scalar(@JUDGE); $i++){
        $str .= '<th style="width: 7%; vtext-align: right;">Judge #'.$i.'</th>';
    }
    $str .= '<th style="width: 7%;text-align: right; ">Average</th>';
    $str .= '<th style="width: 7%;text-align: right; ">Points</th>';
    $str .= '</tr>';
    $sectionIDX = 76;
    $inSec = 1;
    foreach $subIDX (sort {$SUB{$sectionIDX}{$a}{IN_SUBSECTION} <=> $SUB{$sectionIDX}{$b}{IN_SUBSECTION} } keys %{$SUB{$sectionIDX}}){
        $inSub = $SUB{$sectionIDX}{$subIDX}{IN_SUBSECTION} ;
        $txSub = $SUB{$sectionIDX}{$subIDX}{TX_SUBSECTION} ;
        $txDescription= $SUB{$sectionIDX}{$subIDX}{CL_DESCRIPTION} ;
        $inWeight= $SUB{$sectionIDX}{$subIDX}{IN_WEIGHT} ;
        $inMaxPoints = ($inWeight * 50)/100;
        $str .= '<tr class="w3-hide-small">';
        $str .= '<td>'.$inSec.'.'.$inSub.'-'.$txSub.'</td>';
        $str .= '<td>'.$txDescription.'</td>';
        $str .= sprintf '<td>%2.1f&#37; (%2.2f pts)</td>',$inWeight, $inMaxPoints;
        foreach $cardIDX (@JUDGE){
            my $subAverage = $JUDGES{$cardTypeIDX}{$cardIDX}{$subIDX}{IN_VALUE};
            $str .= sprintf '<td style="text-align: right;">%2.1f%</td>',$subAverage ;
            push (@{$sectionIDX.'-'.$subIDX}, $subAverage);
        }
        push (@{$sectionIDX},  &average(@{$sectionIDX.'-'.$subIDX}));
        my $sectionAverage = &average(@{$sectionIDX.'-'.$subIDX});
        $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', &average(@{$sectionIDX.'-'.$subIDX});
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', ($inMaxPoints * $sectionAverage)/100;
        $str .= '</tr>';
        if (exists $COMMENTS{$subIDX}) {
            $str .= '<tr class="w3-hide-small">';
            $str .= '<td colspan="10"><b>COMMENTS:</b><br>';
            foreach $commentIDX (sort keys %{$COMMENTS{$subIDX}}) {
                $str .= sprintf '<div><i>%s<br></i></div>', $COMMENTS{$subIDX}{$commentIDX}{CL_COMMENT};
            }
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<b>%2.0f.%2.0f</b> - <span>%s</span><br>', $inSec, $inSub, $txSub;
        $str .= sprintf '<div style="padding: 0px 20px;">%s</div><br>', $txDescription;
        $str .= '<div class="w3-container">';
        $str .= '<ul class="w3-ul w3-border">';
        $str .= sprintf '<li class="w3-display-container">Weight: <span>%2.1f&#37;</span></li>',$inWeight;
        $str .= sprintf '<li class="w3-display-container">Max Points: <span>%2.2f pts</span></li>', $inMaxPoints;
        for ($i=1; $i<=scalar(@JUDGE); $i++){
            $cardIDX = $JUDGE[$i-1];
            $str .= sprintf '<li class="w3-display-container">Judge #%2.0f<span class="w3-transparent w3-display-right w3-margin-right">%2.2f&#37;</span></li>', $i, $JUDGES{$cardTypeIDX}{$cardIDX}{$subIDX}{IN_VALUE};
        }
        $str .= sprintf '<li class="w3-display-container">Average: <span class="w3-transparent w3-display-right w3-margin-right">%2.2f&#37;</span></li>', &average(@{$sectionIDX.'-'.$subIDX});
        $str .= sprintf '<li class="w3-display-container">Points: <span class="w3-transparent w3-display-right w3-margin-right">%2.4f pts</span></li>', ($inMaxPoints * $sectionAverage)/100;
        $str .= '</ul>';
        if (exists $COMMENTS{$subIDX}) {
            $str .= '<div class="w3-pale-yellow">';
            $str .= '<b>COMMENTS:</b><br>';
            foreach $commentIDX (sort keys %{$COMMENTS{$subIDX}}) {
                $str .= sprintf '<i>%s</i><br>', $COMMENTS{$subIDX}{$commentIDX}{CL_COMMENT};
            }
            $str .= '</div>';
        }
        $str .= '</div>';
        
        $str .= '</td>';
        $str .= '</tr>';
    }
    # $str .= '<tr class="w3-light-grey w3-hide-small">';
    #     $str .= sprintf '<td colspan="10" class="w3-large" style="text-align: right; padding: 2px 5px 15px 5px;">%2.4f pts</td>',  $overallScore;
    # $str .= '</tr>';
    $str .= '</table>';



    $str .= '</div>';
    return ($str);
}
sub _displayReportScores(){
    my $teamIDX = shift;
    my $classIDX = shift;
    my $txFullName = shift;
    my $tileIDX = shift;
    my $Score = new SAE::SCORE();
    my $Rubric=new SAE::RUBRIC();
    my $Home = new SAE::HOME();
    # my $Ref = new SAE::REFERENCE();
    my %SECTION = %{$Rubric->_getSectionList()};
    my %SUB = %{$Rubric->_getSubSectionList()};
    my %JUDGES = %{$Score->_getJudgesForPaper($teamIDX)};
    my ($overallScore, $late) = $Score->_getOverallPaperByTeam($teamIDX);
    my %TILES = %{$Home->_getTiles()};
    my %CTYPE = %{$Rubric->_getRubricType()};
    my %COMMENTS = %{$Score->_getComments( $teamIDX )};
    my $cardTypeIDX = 1;
    my $str;
    # my %LATE = %{$Ref->_getLateReportListByTeamIDX($teamIDX)};
    $str .= sprintf "<h3>%s<br>", $txFullName;
    $str .= sprintf "Report Score: <u>%2.4f</u> pts<br>", $overallScore;
    $str .= sprintf "Late Penalty: <u class='w3-text-red'>%2.1f</u> pts<br>", $late;
    if ($late>$overallScore){
        $overallScore = 0
    } else {
        $overallScore -= $late;
    }
    $str .= sprintf "Total Score: <u>%2.4f</u> pts</h3>", $overallScore;
    $str .= '<h4>Scores Details </h4>';
    for ($cardTypeIDX=1; $cardTypeIDX <=4; $cardTypeIDX ++){
        $str .= '<div class="w3-container w3-round w3-margin-top w3-border">';
        $str .= '<h3>'.$CTYPE{$cardTypeIDX}{TX_TITLE}.'</h3>';
        @JUDGE = (keys %{$JUDGES{$cardTypeIDX}});
        $str .= '<table class="w3-table w3-bordered w3-small">';
        $str .= '<tr class="w3-hide-small">';
        $str .= '<th>Title</th>';
        if ($cardTypeIDX>1){
            $str .= sprintf '<th style="width: 10%;text-align: right;">Judge #%1d</th>', ($cardTypeIDX+2);
            # $str .= sprintf '<th style="width: 10%;text-align: right;">Judge #%1d</th>', (scalar(@JUDGE)+$cardTypeIDX);
        } else {
            for ($i=1; $i<=scalar(@JUDGE); $i++){
                $str .= '<th style="width: 10%;text-align: right;">Judge #'.$i.'</th>';
            }
        }
        $str .= '<th style="width: 10%;text-align: right; ">Average</th>';
        $str .= '</tr>';
        foreach $sectionIDX (sort {$SECTION{$cardTypeIDX}{$a}{IN_SECTION}<=>$SECTION{$cardTypeIDX}{$b}{IN_SECTION}} keys %{$SECTION{$cardTypeIDX}}){
            $inClass = $SECTION{$cardTypeIDX}{$sectionIDX}{IN_CLASS};
            if ($inClass==0 || $inClass==$classIDX){
                $inSec = $SECTION{$cardTypeIDX}{$sectionIDX}{IN_SECTION};
                $str .= '<tr class="w3-blue-grey">';
                $pts = $CTYPE{$cardTypeIDX}{IN_POINTS};
                $secWeight = $SECTION{$cardTypeIDX}{$sectionIDX}{IN_WEIGHT}/100;
                $str .= sprintf '<td colspan="5">'.$inSec.': %s (%2.2f pts)</td>',$SECTION{$cardTypeIDX}{$sectionIDX}{TX_SECTION}, ($pts * $secWeight) ;
                $str .= '</tr>';
                my $mySecAverage = 0;
                foreach $subIDX (sort {$SUB{$sectionIDX}{$a}{IN_SUBSECTION} <=> $SUB{$sectionIDX}{$b}{IN_SUBSECTION} } keys %{$SUB{$sectionIDX}}){
                    $inSub = $SUB{$sectionIDX}{$subIDX}{IN_SUBSECTION} ;
                    $txSub = $SUB{$sectionIDX}{$subIDX}{TX_SUBSECTION} ;
                    $str .= '<tr class="w3-hide-small">';
                    $str .= '<td>&nbsp;&nbsp;&nbsp;&nbsp;'.$inSec.'.'.$inSub.'-'.$txSub.'</td>';
                    foreach $cardIDX (@JUDGE){
                        $str .= sprintf '<td style="text-align: right;">%2.1f%</td>',$JUDGES{$cardTypeIDX}{$cardIDX}{$subIDX}{IN_VALUE};
                        push (@{$sectionIDX.'-'.$subIDX}, $JUDGES{$cardTypeIDX}{$cardIDX}{$subIDX}{IN_VALUE});
                    }
                    push (@{$sectionIDX},  &average(@{$sectionIDX.'-'.$subIDX}));
                    $str .= sprintf '<td style="text-align: right;">%2.2f%</td>', &average(@{$sectionIDX.'-'.$subIDX});
                    $str .= '</tr>';
                    $str .= '<tr class="w3-hide-medium w3-hide-large">';
                    $str .= '<td>';
                    $str .= sprintf '%01d.%02d - %s', $inSec, $inSub, $txSub;
                    $str .= '<ul class="w3-ul w3-border">';
                   
                    
                    if ($cardTypeIDX>1){
                        $str .= sprintf '<li class="w3-display-container">Judge #%2d<span class="w3-transparent w3-display-right w3-margin-right">%2.2f&#37;</span></li>', ($cardTypeIDX+2), $JUDGES{$cardTypeIDX}{$cardIDX}{$subIDX}{IN_VALUE} ;
                    } else {
                        my $judge = 0;
                        foreach $cardIDX (@JUDGE){
                            $judge++;
                            $str .= sprintf '<li class="w3-display-container">Judge #%2d<span class="w3-transparent w3-display-right w3-margin-right">%2.2f&#37;</span></li>', $judge, $JUDGES{$cardTypeIDX}{$cardIDX}{$subIDX}{IN_VALUE} ;
                        }                        
                    }

                    $str .= sprintf '<li class="w3-display-container w3-light-grey">Sub-Section Average: <span class="w3-transparent w3-display-right w3-margin-right">%2.2f&#37;</span></li>', &average(@{$sectionIDX.'-'.$subIDX});
                    
                    $str .= '</ul>';
                    $str .= '</td>';
                    $str .= '</tr>';
                    if (exists $COMMENTS{$subIDX}){
                        $str .= '<tr>';
                        $str .= '<td colspan="5" >';
                        $str .= '<b>Comments:</b>';
                        foreach $commentIX (sort keys %{$COMMENTS{$subIDX}}){
                            $cardIDX = $COMMENTS{$subIDX}{$commentIX}{FK_CARD_IDX};
                            $idx = first { $JUDGE[$_] == $cardIDX  } 0..$#JUDGE;
                            $str .= '<div class="w3-pale-yellow w3-border w3-padding-small w3-round-large" style="margin-top: 5px;margin-left: 25px; ">';
                            if ($cardTypeIDX>1) {
                                $idx = ($cardTypeIDX+2);
                                $str .= '<b>Judge #'.($idx).': </b><i>"'.$COMMENTS{$subIDX}{$commentIX}{CL_COMMENT}.'"</i>';
                            } else {
                                $str .= '<b>Judge #'.($idx+1).': </b><i>"'.$COMMENTS{$subIDX}{$commentIX}{CL_COMMENT}.'"</i>';
                            }
                            
                            $str .= '</div>';
                        }
                        $str .= '</td>';
                        $str .= '</tr>';
                        
                    }
                }
                $mySecAverage = &average(@{$sectionIDX});
                $str .= '<tr class="w3-light-grey w3-hide-small">';
                $str .= sprintf '<td colspan="5" class="w3-large" style="text-align: right; padding: 2px 5px 15px 5px;">Section '.$inSec.' Average (%2.2f&#37;) or %2.4f pts</td>',  $mySecAverage , (($mySecAverage/100) * $secWeight * $pts);
                $str .= '</tr>';
                $str .= '<tr class="w3-light-grey w3-hide-medium w3-hide-large">';
                $str .= sprintf '<td colspan="5" class="" style="text-align: right; padding: 2px 5px 15px 5px;">Section '.$inSec.' Average (%2.2f&#37;) or %2.4f pts</td>',  $mySecAverage , (($mySecAverage/100) * $secWeight * $pts);
                $str .= '</tr>';
            }
        }
        $str .= '</table>'; 
        $str .= '</div>';
    } 
    return ($str);
}
sub _displayPenalties(){
    my $teamIDX = shift;
    my $classIDX = shift;
    my $txFullName = shift;
    my $tileIDX = shift;
    my $location = shift;
    my $Score = new SAE::SCORE();
    my %PEN = %{$Score->_getPenaltiesByTeam($teamIDX, $location )};
    my $overallScore = $Score->_getAllPenaltiesByTeam($teamIDX);
    my $str;
    $str .= sprintf "<h3>%s<br>", $txFullName;
    $str .= sprintf "Total Deduction: <u>%2.4f</u> pts</h3>", $overallScore;
    $str .= '<h4>Penalty Details </h4>';
    
    # $str .= ($#JUDGE + 1);
    $str .= '<div class="w3-container w3-round w3-margin-top w3-border">';
    $str .= '<h3>'.$CTYPE{$cardTypeIDX}{TX_TITLE}.'</h3>';
    $str .= '<table class="w3-table w3-bordered w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th>Title<br>Description</th>';
    # $str .= '<th>Description</th>';
    $str .= '<th style="width: 7%;text-align: right">Structural<br>Changes</th>';
    $str .= '<th style="width: 7%;text-align: right">Machanical<br>Changes</th>';
    $str .= '<th style="width: 7%;text-align: right">Electronic<br>Changes</th>';
    $str .= '<th style="width: 7%;text-align: right">Misc<br>Changes</th>';
    $str .= '<th style="width: 7%;text-align: right">Span<br>Modifications</th>';
    $str .= '<th style="width: 7%;text-align: right">Chord<br>Modifications</th>';
    $str .= '<th style="width: 7% ; text-align: right; ">Total<br>Deductions</th>';
    $str .= '</tr>';
    foreach $ecrIDX (sort keys %PEN){
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td>%s<br>%s</td>', $PEN{$ecrIDX}{TX_ECR}, $PEN{$ecrIDX}{CL_DESCRIPTION};
        # $str .= sprintf '<td>%s</td>', ;
        $str .= sprintf '<td style="text-align: right">%2.1f</td>', $PEN{$ecrIDX}{IN_STRUCTURE}*-1;
        $str .= sprintf '<td style="text-align: right">%2.1f</td>', $PEN{$ecrIDX}{IN_MECHANICAL}*-1;
        $str .= sprintf '<td style="text-align: right">%2.1f</td>', $PEN{$ecrIDX}{IN_ELECTRONIC}*-1;
        $str .= sprintf '<td style="text-align: right">%2.1f</td>', $PEN{$ecrIDX}{IN_MISC}*-1;
        $str .= sprintf '<td style="text-align: right">%2.1f</td>', $PEN{$ecrIDX}{IN_SPAN}*-1;
        $str .= sprintf '<td style="text-align: right">%2.1f</td>', $PEN{$ecrIDX}{IN_CHORD}*-1;
        $str .= sprintf '<td style="text-align: right" class="w3-text-red"><b>%2.1f</b></td>', $PEN{$ecrIDX}{IN_DEDUCTION}*-1;
        $str .= '</tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<b>Title:</b> <span>%s</span><br>',$PEN{$ecrIDX}{TX_ECR};
        $str .= sprintf '<b>Description:</b> <span>%s</span><br>',$PEN{$ecrIDX}{CL_DESCRIPTION};
        $str .= sprintf '<b>Structural Changes:</b> <span>%2.1f</span><br>',$PEN{$ecrIDX}{IN_STRUCTURE}*-1;
        $str .= sprintf '<b>Machanical Changes:</b> <span>%2.1f</span><br>',$PEN{$ecrIDX}{IN_MECHANICAL}*-1;
        $str .= sprintf '<b>Electronic Changes:</b> <span>%2.1f</span><br>',$PEN{$ecrIDX}{IN_ELECTRONIC}*-1;
        $str .= sprintf '<b>Misc Changes:</b> <span>%2.1f</span><br>',$PEN{$ecrIDX}{IN_MISC}*-1;
        $str .= sprintf '<b>Span Modifications:</b> <span>%2.1f</span><br>',$PEN{$ecrIDX}{IN_SPAN}*-1;
        $str .= sprintf '<b>Chord Modifications:</b> <span>%2.1f</span><br>',$PEN{$ecrIDX}{IN_CHORD}*-1;
        $str .= sprintf '<b>Deduction:</b> <span class="w3-text-red"><b>%2.1f</b></span><br>',$PEN{$ecrIDX}{IN_DEDUCTION}*-1;
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '<tr class="w3-pale-red">';
    $str .= sprintf '<td class="w3-padding w3-large w3-text-red" colspan="8" style="text-align: right">Total Deduction : %2.2f pts</td>', $overallScore;
    $str .= '</tr>';
    return ($str);
}
sub _displayMicroFlights(){
    my $teamIDX = shift;
    my $classIDX = shift;
    my $txFullName = shift;
    my $tileIDX = shift;
    my $location = shift;
    my $Score = new SAE::SCORE();
    my %FLIGHTS = %{$Score->_getMicroFlightLogs( $teamIDX, $location )};
    my ($score, $avg, $max, $demo) = $Score->_getMicroFlightScoreByTeam($teamIDX, $location );
    $str = sprintf "<center><h3>Team #%s</h3>", $txFullName;
    $str .= '<h4>Flight Log</h4>';
    $str .= '</center>';
    $str .= '<div class="w3-container w3-round w3-margin-top w3-border">';
    $str .= '<h3>'.$CTYPE{$cardTypeIDX}{TX_TITLE}.'</h3>';
    $str .= '<table class="w3-table-all w3-bordered w3-small">';
    $str .= '<tr>';
    $str .= '<th style="text-align: left; width: 5%;" >Round</th>';
    $str .= '<th style="text-align: right; width: 15%;">Payload</th>';
    $str .= '<th style="text-align: right; width: 15%;">Empty<br>Weight</th>';
    $str .= '<th style="text-align: right; width: 15%;">Rule 3.5<br>Infraction</th>';
    $str .= '<th style="text-align: right; width: 15%;">Rule 3.10.3<br>Infraction</th>';
    $str .= '<th style="text-align: right; width: 15%;">Raw<br>Flight Score</th>';
    $str .= '<th style="text-align: right;             ">Adjusted<br>Flight Score</th>';
    $str .= '</tr>';
    foreach $inRound (sort {$a<=>$b} keys %FLIGHTS){
        $txMinor = '-';
        $txLanding = '-';
        if ($FLIGHTS{$inRound}{IN_PEN_MINOR}>0) {$txMinor = 'Yes';}
        if ($FLIGHTS{$inRound}{IN_PEN_LANDING}>0) {$txLanding = 'Yes';}
        $str .= '<tr>';
        $str .= sprintf '<td style="text-align: left">%2.0f</td>', $inRound;
        $str .= sprintf '<td style="text-align: right">%2.4f</td>', $FLIGHTS{$inRound}{IN_PAYLOAD};
        $str .= sprintf '<td style="text-align: right">%2.4f</td>', $FLIGHTS{$inRound}{IN_EMPTY};
        $str .= sprintf '<td style="text-align: right">%4s</td>', $txMinor;
        $str .= sprintf '<td style="text-align: right">%4s</td>', $txLanding;
        $str .= sprintf '<td style="text-align: right">%2.4f</td>', $FLIGHTS{$inRound}{IN_RAW};
        $str .= sprintf '<td style="text-align: right">%2.4f</td>', $FLIGHTS{$inRound}{IN_SCORE};
        
    }
    $str .= '<tr>';
    $str .= sprintf '<td colspan="7" style="text-align: right">Average Flight Scores: <b>%2.4f</b></td>',$avg;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= sprintf '<td colspan="7" style="text-align: right">Max Flight Score: <b>%2.4f</b></td>',$max;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= sprintf '<td colspan="7" style="text-align: right">Demo Score: <b>%2.4f</b></td>',$demo;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= sprintf '<td colspan="7" style="text-align: right">Final Flight Score (FFS): <b>%2.4f</b></td>',$score;
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<div class="w3-panel w3-tiny w3-padding"">';
    $str .= '<P>FFS =  FINAL FLIGHT SCORE = 20 x [(.5 X FS<sub>avg</sub>) + (0.5 X FS<sub>max</sub>)] + AD</P>';
    $str .= '<P>AD = ASSEMBLY DEMO = 5 x [2-(t/60)]<sup>3</sup></P>';
    $str .= '<p>FS = W<sub>payload</sub> / Sqrt (W<sub>empty</sub>)</p>';
    $str .= '<p>FS<sub>max</sub> = Team\'s maximum single flight score<br>';
    $str .= 'FS<sub>avg</sub> = Empty Weight</br>';
    $str .= 'AD = Assembly Demo<br>';
    $str .= 't = time recorded in seconds<br>';
    $str .= 'W<sub>payload</sub> = Payload Weight</br>';
    $str .= 'W<sub>empty</sub> = Empty Weight</br>';
    $str .= 'N = Total Number of Flight Rounds During Competition</p>';

    $str .= '</div>';
    return ($str);
}
sub _displayAdvancedFlights(){
    my $teamIDX = shift;
    my $classIDX = shift;
    my $txFullName = shift;
    my $tileIDX = shift;
    my $location = shift;
    my $Score = new SAE::SCORE();
    my %LOGS = %{$Score->_getAdvancedFlightLogs($teamIDX)};
    my $str;
    my $c=0;
    my $h=0;
    my $w=0;
    my $s=0;
    $maxRound =  (scalar (keys %LOGS));
    $str .= sprintf "<center><h3>Team #%s $maxRound</h3>", $txFullName;
    $str .= '<h4>Flight Log</h4>';
    $str .= '</center>';
    $str .= '<div class="w3-container w3-round w3-margin-top">';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th style="text-align: left; width: 20%;">Round<br>(N)</th>';
    $str .= '<th style="text-align: right; width: 15%;">Colonist<br>(N<sub>c</sub>)</th>';
    $str .= '<th style="text-align: right; width: 15%;">Habitats<br>(N<sub>h</sub>)</th>';
    $str .= '<th style="text-align: right; width: 15%;">Water<br>(N<sub>w</sub>)</th>';
    $str .= '<th style="text-align: right; width: 15%;">Supplies<br>(S<sub>p</sub>)</th>';
    $str .= '<th style="text-align: right; width: 10%;">Minor Infraction<br>(Rule 3.5)</th>';
    $str .= '<th style="text-align: right; width: 10%;">Landing Infraction<br>(Rule 3.10.3)</th>';
    $str .= '</tr>';
    # if ($maxRound>1){
        for ($inRound=1; $inRound<= $maxRound; $inRound++){
        # foreach $inRound (sort {$a <=> $b} keys %LOGS) {
            $str .= '<tr>';
            $str .= sprintf '<td>%2.0f</td>', $inRound;
            $str .= sprintf '<td style="text-align: right;" nowrap>%2.2f (<span class="w3-small">raw = %2.2f</span>)</td>', $LOGS{$inRound}{FS_COLONIST},  $LOGS{$inRound}{RAW_COLONIST};
            $str .= sprintf '<td style="text-align: right;" nowrap>%2.2f (<span class="w3-small">raw = %2.2f</span>)</td>', $LOGS{$inRound}{FS_HABITAT},  $LOGS{$inRound}{RAW_HABITAT};
            $str .= sprintf '<td style="text-align: right;" nowrap>%2.2f (<span class="w3-small">raw = %2.2f</span>)</td>', $LOGS{$inRound}{FS_WATER},  $LOGS{$inRound}{RAW_WATER};
            $str .= sprintf '<td style="text-align: right;" nowrap>%2.2f (<span class="w3-small">raw = %2.2f</span>)</td>', $LOGS{$inRound}{FS_WEIGHT},  $LOGS{$inRound}{RAW_WEIGHT};
            $str .= sprintf '<td style="text-align: right;" nowrap>%s</td>', $LOGS{$inRound}{IN_PEN_MINOR};
            $str .= sprintf '<td style="text-align: right;" nowrap>%s</td>', $LOGS{$inRound}{IN_PEN_LANDING};
            $str .= '</tr>';
            $c+=$LOGS{$inRound}{FS_COLONIST};
            $h+=$LOGS{$inRound}{FS_HABITAT};
            $w+=$LOGS{$inRound}{FS_WATER};
            $s+=$LOGS{$inRound}{FS_WEIGHT};
        }
    # }
    $str .= '<tr class="w3-large w3-grey">';
    $str .= '<td>Total</td>';
    $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $c;
    $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $h;
    $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $w;
    $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $s;
    $str .= '<td style="text-align: right;">---</td>';
    $str .= '<td style="text-align: right;">---</td>';
    $str .= '</tr>';
    my ($days, $ffs) = $Score->_getAdvancedFinalCalculations($teamIDX, $location, $c,  $h,  $w,  $s );
    $str .= '<tr class="w3-large">';
    $str .= sprintf '<td colspan="7" style="text-align: right;">Total Days = %2.2f</td>', $days;
    $str .= '</tr>';
    $str .= '<tr class="w3-large">';
    $str .= sprintf '<td colspan="7" style="text-align: right;">Final Flight Score = %2.4f</td>', $ffs;
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<div class="w3-panel w3-tiny w3-padding">';
    $str .= '<p>FFS = Final Flight Score = [(N<sub>c</sub> x D)/(15 x N)] + [(2 x S<sub>p</sub>)/N]</p>';
    $str .= '<p>D = Days of Habitability = 25 x (2<sup>1-R<sub>max</sub></sup>)</p>';
    $str .= '<p>R<sub>max</sub> = Maximum([N<sub>c</sub>/(8xN<sub>h</sub>)],[N<sub>c</sub>/N<sub>w</sub>]) <br>';
    $str .= 'N<sub>c</sub> = Total number of colonist delivered during the competition<br>';
    $str .= 'N<sub>h</sub> = Total number of habitats delivered during the competition<br>';
    $str .= 'N<sub>w</sub> = Total amount of water (in fl oz) delivered during the competition<br>';
    $str .= 'S<sub>p</sub> = Total static payload (lbs) delivered during the competition<br>';
    $str .= 'N = Total Number of Flight Rounds During Competition</p>';
    $str .= '<p>NOTE:<br>To receive a mission performance score, you must deliver all three components (N<sub>c</sub>, N<sub>h</sub>, N<sub>w</sub>).';
    $str .= '<br>Raw: The number that was entered from the Flight Logs.  If Minor Flight Infractions or Landing Infraction were applied, the raw score was adjusted per the rules. (25% for Minor Flight Infractions and 50% for Landing Infractions)';
    $str .= '</p>';
    $str .= '</div>';
    return ($str);
}
sub _displayRegularFlights( $teamIDX, $classIDX, $txFullName, $tileIDX, $location ){
    my $teamIDX = shift;
    my $classIDX = shift;
    my $txFullName = shift;
    my $tileIDX = shift;
    my $location = shift;
    my $Score = new SAE::SCORE();
    my %LOGS = %{$Score->_getRegularFlightLog($teamIDX, $location)};
    my ($ffs, $maxPPB, $FS1, $FS2, $FS3, $t3ffs) = $Score->_getRegularFinalFlightScore($teamIDX, $location);
    my $str;
    $str = sprintf "<center><h3>Team #%s</h3>", $txFullName;
    $str .= '<h4>Flight Log</h4>';
    $str .= '</center>';
    $str .= '<div class="w3-container w3-round w3-margin-top">';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th style="text-align: left; width:  5%;">Round<br>(N)</th>';
    $str .= '<th style="text-align: right; width: 18%;">Time of Flight<br><span class="w3-tiny">(Used to determine the Density Altitude)</span></th>';
    $str .= '<th style="text-align: right; width: 9%;">Length of Cargo-bay<br><span class="w3-tiny">(L<sub>Cargo</sub>)</span></th>';
    $str .= '<th style="text-align: right; width: 9%;"># of Balls<br><span class="w3-tiny">(S)</span></th>';
    $str .= '<th style="text-align: right; width: 9%;">Payload<br><span class="w3-tiny">(W<sub>Steel</sub>)</span></th>';
    $str .= '<th style="text-align: right; width: 9%;">Wing Span<br><span class="w3-tiny">(b)</span></th>';
    $str .= '<th style="text-align: right; width: 9%;">Minor Infraction<br><span class="w3-tiny">(Rule 3.5)</span></th>';
    $str .= '<th style="text-align: right; width: 9%;">Landing Infraction<br><span class="w3-tiny">(Rule 3.10.3)</span></th>';
    $str .= '<th style="text-align: right; width: 12%;">Raw<br>Flight Score/<br>PPB</th>';
    $str .= '<th style="text-align: right; width: 12%;">Adjusted<br>Flight Score/<br>PPB</th>';
    $str .= '</tr>';
    foreach $inRound (sort {$a <=> $b} keys %LOGS) {
        $str .= '<tr>';
        $str .= sprintf '<td>%2.1f</td>', $inRound;
        if ($LOGS{$inRound}{TS_TIME}){
            $str .= sprintf '<td style="text-align: right;" nowrap>%s</td>', $LOGS{$inRound}{TS_TIME};
        } else {
            $str .= sprintf '<td style="text-align: right;" nowrap>%s</td>', 'DNF';
        }
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $LOGS{$inRound}{IN_LCARGO};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $LOGS{$inRound}{IN_SPHERE};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $LOGS{$inRound}{IN_WEIGHT};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $LOGS{$inRound}{IN_SPAN};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $LOGS{$inRound}{IN_PEN_MINOR};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $LOGS{$inRound}{IN_PEN_LANDING};
        $str .= sprintf '<td style="text-align: right;">%2.4f<br>%2.4f</td>', $LOGS{$inRound}{RAW_FS}, $LOGS{$inRound}{RAW_PPB};
        $str .= sprintf '<td style="text-align: right;">%2.4f<br>%2.4f</td>', $LOGS{$inRound}{IN_FS}, $LOGS{$inRound}{IN_PPB};
        $str .= '</tr>';
    }
    $str .= '<tr>';
    $str .= sprintf '<td colspan="10" style="text-align: right;" class="w3-large">Top 3 Flight Scores = %2.4f + %2.4f + %2.4f = %2.4f</td>', $FS1, $FS2, $FS3, $t3ffs;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= sprintf '<td colspan="10" style="text-align: right;" class="w3-large">Highest Prediction Point Bonus (PPB) from the Top 3 Flight Scores = %2.4f </td>', $maxPPB;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= sprintf '<td colspan="10" style="text-align: right;" class="w3-large">Final Flight Score + Bonus = %2.4f </td>', $ffs;
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<div class="w3-panel w3-tiny w3-padding" >';
    $str .= '<p>FS = 120 x ((2 x S + W<sub>steel</sub>) / (b + L<sub>cargo</sub>))</p>';
    $str .= '<p>FFS = FS<sub>1</sub> +  FS<sub>2</sub> +  FS<sub>3</sub> + PPB</p>';
    $str .= '<p>PPB = 10 - (A - P)<sup>2</sup></p>';
    $str .= '<p>S = Number of Spherical Cargo Carried on a Flight<br>';
    $str .= 'W<sub>steel</sub> = Regular Boxed Cargo Weight (lbs)<br>';
    $str .= 'b = Aircraft Wingspan (inches)<br>';
    $str .= 'L<sub>cargo</sub> = Length of Cargo Bay (inches) - From the Drawing Specs<br>';
    $str .= 'A<sub>steel</sub> = W<sub>steel</sub> + (0.9375 x S)<br>';
    $str .= 'P = Predicted Payload (lbs)<br>';
    $str .= '</div>';
    return ($str);
}
sub _publish(){
    
}





