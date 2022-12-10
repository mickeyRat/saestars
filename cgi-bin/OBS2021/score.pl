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
    $str .= '<th>Title</th>';
    $str .= '<th>Description</th>';
    $str .= '<th>Discovery<br>Method</th>';
    $str .= '<th>System(s)<br>Impacted</th>';
    $str .= '<th style="width: 7%;text-align: right; ">Deductions</th>';
    $str .= '</tr>';
    foreach $ecrIDX (sort keys %PEN){
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td>%s</td>', $PEN{$ecrIDX}{TX_ECR};
        $str .= sprintf '<td>%s</td>', $PEN{$ecrIDX}{CL_DESCRIPTION};
        $str .= sprintf '<td>%s</td>', $PEN{$ecrIDX}{TX_METHOD};
        $str .= sprintf '<td>%s</td>', $PEN{$ecrIDX}{TX_SYSTEM};
        $str .= sprintf '<td style="text-align: right">%2.2f</td>', $PEN{$ecrIDX}{IN_DEDUCTION};
        $str .= '</tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<b>Title:</b> <span>%s</span><br>',$PEN{$ecrIDX}{TX_ECR};
        $str .= sprintf '<b>Description:</b> <span>%s</span><br>',$PEN{$ecrIDX}{CL_DESCRIPTION};
        $str .= sprintf '<b>Discovery Method:</b> <span>%s</span><br>',$PEN{$ecrIDX}{TX_METHOD};
        $str .= sprintf '<b>Systems Impacted:</b> <span>%s</span><br>',$PEN{$ecrIDX}{TX_SYSTEM};
        $str .= sprintf '<b>Deduction:</b> <span class="w3-text-red"><b>%2.2f</b></span><br>',$PEN{$ecrIDX}{IN_DEDUCTION};
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '<tr class="w3-pale-red">';
    $str .= sprintf '<td class="w3-padding w3-large w3-text-red" colspan="5" style="text-align: right">Total Deduction : %2.2f pts</td>', $overallScore;
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










# sub viewMyScoreCard(){
#     print $q->header();
#     my $dbi = new SAE::Db();
#     my $auth = new SAE::Auth();
#     my $str;
# #     print "test";
#     $location = $q->param('location');
#     $eIDX = $q->param('teamIDX');
#     $doc = $q->param('doc');
#     $rnd = $q->param('rnd');
#     @DOC = split(",",$doc);
#     ($teamIDX, $inNumber, $classIDX, $txSchool) = @{$auth->decryptTeamIDX($location, $eIDX)};
# #     $str .= '<br>Doc = '.$doc.' ('.$teamIDX.') <br>';
#     if ($doc eq 'penalty'){
#         $str .= &_showPenalty($teamIDX, $inNumber, $classIDX, $txSchool);
#     } elsif ($doc eq 'flight') {
#         if ($classIDX==1){
#             $str .= &_showRegularFlightCard($teamIDX, $inNumber, $classIDX, $txSchool, $rnd);
#         } elsif ($classIDX==2)  {
#             $str .= &_showAdvancedFlightCard($teamIDX, $inNumber, $classIDX, $txSchool, $rnd);
#         } else {
#             $str .= &_showMicroFlightCard($teamIDX, $inNumber, $classIDX, $txSchool, $rnd);
#         }
#     } elsif ($doc eq 'demo') {
#         $str .= &_showDemo($teamIDX, $inNumber, $classIDX, $txSchool, $rnd);
#     } else {
#         $str .= &_showDesignAssessments($teamIDX, $inNumber, $classIDX, $txSchool, \@DOC);
#     }
# #     $str .= $location;
#     return ($str);
# }
# sub _showDemo(){
# my $dbi = new SAE::Db();
#     my $teamIDX = shift;
#     my $inNumber = shift;
#     my $classIDX = shift;
#     my $txSchool = shift;
#     my $SQL = "SELECT SCORE.*, TEAM.FK_CLASS_IDX, QUESTION.TX_TITLE, QUESTION.TX_DESCRIPTION, GRADE.IN_SCORE
#             FROM TB_SCORE AS SCORE JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
#             JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#             JOIN TB_QUESTION AS QUESTION ON SCORE.FK_QUESTION_IDX=QUESTION.PK_QUESTION_IDX
#         WHERE FK_QUESTION_IDX in (319,320,321,322) AND TEAM.PK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($teamIDX) || die "Error";
#     %DEMO = %{$select->fetchall_hashref(['FK_QUESTION_IDX'])};
#     my $str;

#     if ($classIDX==1){
#         $str .= '<h1 style="text-align: center;">#'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#         $str .= '<h2 style="text-align: center;">Loading/Unloading Demonstration</h2>';
#         $str .= '<table class="w3-table-all w3-small" style="width: 80%; margin: auto;">';
#         my $pass;
#         $str .= '<tr>';
#         $str .= '<th>Title</th>';
#         $str .= '<th>Description</th>';
#         $str .= '<th>Time</th>';
#         $str .= '<th>Status</th>';
#         $str .= '<th>Score</th>';
#         $str .= '</tr>';
#         my $totalScore = 0;
#         foreach $questionIDX (sort {$a <=> $b}  keys %DEMO) {
#             my $score = 0;
#             if ($DEMO{$questionIDX}{IN_VALUE}>60){
#                 $pass='<span class="fa fa-warning w3-text-red"> Failed</span>';
#             }  else {
#                 $pass = '<span class="fa fa-check w3-text-green"> Passed</span>';
#                 $score = 1;
#                 $totalScore++;
#             }
#             $str .= '<tr>';
#             $str .= '<td>'.$DEMO{$questionIDX}{TX_TITLE}.'</td>';
#             $str .= '<td>'.$DEMO{$questionIDX}{TX_DESCRIPTION}.'</td>';
#             $str .= sprintf '<td>%2.1f sec</td>',$DEMO{$questionIDX}{IN_VALUE};
#             $str .= '<td>'.$pass.'</td>';
#             $str .= sprintf '<td>%2.4f</td>', $score*1.5;
#             $str .= '</tr>';
#         }
#         $str .= '<tr>';
#         $str .= '<th colspan="4" style="text-align: right;">Total Score</th>';
#         $str .= sprintf '<th>%2.4f</th>', $totalScore*1.5;
#         $str .= '</tr>';
#         $str .= '</table>';
#     } elsif ($classIDX==2) {
#         $str .= '<h1 style="text-align: center;">#'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#         $str .= '<h2 style="text-align: center;">Proof Of Flight Demonstration</h2>';
#         $str .= '<table class="w3-table-all w3-small" style="width: 80%; margin: auto;">';
#         my $pass;
#         $str .= '<tr>';
#         $str .= '<th>Title</th>';
#         $str .= '<th>Description</th>';
#         $str .= '<th>Status</th>';
#         $str .= '</tr>';
#         my $totalScore = 0;
#         foreach $questionIDX (sort {$a <=> $b}  keys %DEMO) {
#             if ($DEMO{$questionIDX}{IN_VALUE}!=100){
#                 $pass='<span class="fa fa-warning w3-text-red"> Failed</span>';
#             }  else {
#                 $pass = '<span class="fa fa-check w3-text-green"> Passed</span>';
#             }
#             $str .= '<tr>';
#             $str .= '<td>'.$DEMO{$questionIDX}{TX_TITLE}.'</td>';
#             $str .= '<td>'.$DEMO{$questionIDX}{TX_DESCRIPTION}.'</td>';
#             $str .= '<td>'.$pass.'</td>';
#             $str .= '</tr>';
#         }
#         $str .= '</table>';
#     } else {
#         $str .= '<h1 style="text-align: center;">#'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#         $str .= '<h2 style="text-align: center;">Assembly Demonstration</h2>';
#         $str .= '<table class="w3-table-all w3-small" style="width: 80%; margin: auto;">';
#         my $pass;
#         $str .= '<tr>';
#         $str .= '<th>Title</th>';
#         $str .= '<th>Description</th>';
#         $str .= '<th>Time</th>';
#         $str .= '<th>Score</th>';
#         $str .= '</tr>';
#         my $totalScore = 0;
#         foreach $questionIDX (sort {$a <=> $b}  keys %DEMO) {
#             $str .= '<tr>';
#             $str .= '<td>'.$DEMO{$questionIDX}{TX_TITLE}.'</td>';
#             $str .= '<td>'.$DEMO{$questionIDX}{TX_DESCRIPTION}.'</td>';
#             $str .= sprintf '<td>%2.1f sec</td>',$DEMO{$questionIDX}{IN_VALUE};
#             $str .= sprintf '<td>%2.4f</td>', $DEMO{$questionIDX}{IN_SCORE};
#             $str .= '</tr>';
#         }
#         $str .= '</table>';
#     }

#     return ($str);
# }
# sub _showRegularFlightCard(){
#     my $teamIDX = shift;
#     my $inNumber = shift;
#     my $classIDX = shift;
#     my $txSchool = shift;
#     my $inRound = shift;
#     my $Team = new SAE::TB_TEAM();
#     $Team->getRecordById($teamIDX);
#     $teamCapacity = $Team->getInCapacity();
#     my $reg = new SAE::REGULAR();
#     my $dbi = new SAE::Db();

#     my $str;
#     $str .= '<h1 style="text-align: center;">#'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#     $str .= '<h2 style="text-align: center;">Flight Log Entries</h2>';
#     $str .= '<table class="w3-table-all w3-small" style="width: 80%; margin: auto;">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 10%;text-align: center;">Round<br>(N)</th>';
#     $str .= '<th style="width: 10%;text-align: right;;">Aircraft<br>Capacity</th>';
#     $str .= '<th style="width: 10%;text-align: right;;"># of<br>Occupied<br>Seats<br>(P)</th>';
#     $str .= '<th style="width: 10%;text-align: right;;"># of<br>Empty<br>Seats<br>(E)</th>';
#     $str .= '<th style="width: 10%;text-align: right;;">Luggage<br>Weight<br>Carried<br>(C)</th>';
#     $str .= '<th style="width: 10%;text-align: right;;">Rule 3.5<br>Infraction</th>';
#     $str .= '<th style="width: 10%;text-align: right;;">Rule 3.10.3<br>Infraction</th>';
#     $str .= '<th style="width: 10%;text-align: right;">Flight<br>Score<br>Revenue<br>(FS)</th>';
# #     $str .= '<th style="width: 40%;text-align: center;">Final Flight Score by Rounds</th>';
#     $str .= '</tr>';
#     my $total = 0;
#     for ($x=1; $x<=$inRound; $x++){
#         my ($capacity, $passenger, $cargo, $empty, $score, $minor, $landing) =  $reg->getTeamFlightScoreInRound($teamIDX, $x);
#         $str .= '<tr>';
#         $str .= '<td style="text-align: center;">'.$x.'</td>';
#         $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$capacity;
#         $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$passenger;
#         $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$empty;
#         $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$cargo;
#         $str .=  '<td style="text-align: right;">'.$minor.'</td>';
#         $str .=  '<td style="text-align: right;">'.$landing.'</td>';
#         $str .=         '<td style="text-align: right;">'.format_price($score,2,'$').'</td>';
# #         $str .= sprintf '<td class="w3-small" style="text-align: center;">%2.4f pts (after round '.$x.')</td>', $reg->getRegularFinalFlightScoreUpToRound($teamIDX, $x);
#         $str .= '</tr>';
#         $total += $score;
#     }
#     $str .= '<tr>';
#     my $colspan=7;
#     $flightTotal = $reg->getRegularFinalFlightScoreUpToRound($teamIDX, $inRound);
#     my @DESIGN = $reg->getDesignScore($teamIDX);
#     my @PRESO = $reg->getPresoScore($teamIDX);
#     my $penalty = $reg->getPenalty($teamIDX);
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Total Revenue (FS<sub>total</sub>):</th>';
#     $str .= sprintf '<th style="text-align: right;">$%2.2f</th>',$total;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Final Flight Score After '.$inRound.' Rounds:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$flightTotal ;
#     $str .= '</tr>';
    
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Technical Design Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$DESIGN[5] - $DESIGN[4];
#     $str .= '</tr>';
    
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Technical Presentation Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$PRESO[5];
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Penalties:</th>';
#     $str .= sprintf '<th colspan="2" class="w3-text-red" style="text-align: right;">- %2.4f pts</th>',$penalty;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Total Overall Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',($DESIGN[5] - $DESIGN[4] + $PRESO[5] + $flightTotal - $penalty);
#     $str .= '</tr>';
#     $str .= '</table>';
#     $str .= '<div class="w3-panel w3-tiny w3-padding" style="width: 80%; margin: auto;">';
#     $str .= '<p>FS = $100P + $50C - $100E</p>';
#     $str .= '<p>FFS = Final Flight Score = [1/(40 x N)] x FS<sub>total</sub></p>';
#     $str .= '<p>P = Number of seated passengers carried on a flight<br>';
#     $str .= 'C = Luggage weight (lbs)<br>';
#     $str .= 'E = Number of empty seats on a flight<br>';
#     $str .= 'N = Total Number of Flight Rounds During Competition</p>';
#     $str .= '</div>';
#     return ($str);
# }
# sub _showAdvancedFlightCard(){
#     my $teamIDX = shift;
#     my $inNumber = shift;
#     my $classIDX = shift;
#     my $txSchool = shift;
#     my $inRound = shift;
#     my $adv = new SAE::ADVANCED();
#     my $dbi = new SAE::Db();
#     my $str;
#     my $SQL = "SELECT GRADE.IN_SCORE, SCORE.PK_SCORE_IDX, QUE.PK_QUESTION_IDX, QUE.TX_TITLE, QUE.TX_DESCRIPTION, QUE.IN_ORDER, SCORE.IN_VALUE, GRADE.IN_ROUND
#             FROM TB_GRADE AS GRADE
#             JOIN TB_SCORE AS SCORE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
#             JOIN TB_QUESTION AS QUE ON SCORE.FK_QUESTION_IDX=QUE.PK_QUESTION_IDX
#         WHERE TX_TYPE=? AND FK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute('flight',$teamIDX);
#     %LOG = %{$select->fetchall_hashref(['IN_ROUND','PK_QUESTION_IDX'])};
#     $str .= '<h1 style="text-align: center;">#'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#     $str .= '<h2 style="text-align: center;">Flight Log Entries</h2>';
#     $str .= '<table class="w3-table-all w3-small" style="width: 60%; margin: auto;">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 10%;text-align: center;">Round<br>(N)</th>';
#     $str .= '<th style="width: 15%;text-align: right;">Colonist<br>(N<sub>c</sub>)</th>';
#     $str .= '<th style="width: 15%;text-align: right;">Habitats<br>(N<sub>H</sub>)</th>';
#     $str .= '<th style="width: 15%;text-align: right;">Water<br>(N<sub>w</sub>)</th>';
#     $str .= '<th style="width: 15%;text-align: right;">Supplies<br>(S<sub>p</sub>)</th>';
#     $str .= '<th style="width: 10%;text-align: right;;">Rule 3.5<br>Infraction</th>';
#     $str .= '<th style="width: 15%;text-align: right;;">Rule 3.10.3<br>Infraction</th>';
# #     $str .= '<th style="width: 50%;text-align: right;">Final Flight Score By Rounds</th>';
#     $str .= '</tr>';
#     my $col = 0;
#     my $hab = 0;
#     my $wat = 0;
#     my $sup = 0;
#     my $MAXratio;
#     for ($x=1; $x<=$inRound; $x++){
#         my ($c, $h, $w, $s, $m, $d, $mult) = $adv->getTeamFlightScoreInRound($teamIDX, $x);
#         $col += $c;
#         $hab += $h;
#         $wat += $w;
#         $sup += $s;
#         $str .= '<tr>';
#         $str .= '<td>'.$x.'</td>';
#         $str .= sprintf '<td style="text-align: right;">%2.1f</td>',$c;
#         $str .= sprintf '<td style="text-align: right;">%2.1f</td>',$h;
#         $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$w;
#         $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$s;
#         $str .= sprintf '<td style="text-align: right;">'.$m.'</td>';
#         $str .= sprintf '<td style="text-align: right;">'.$d.'</td>';
#         $str .= '</tr>';
#     }
    
#     $str .= '<tr>';
#     $str .= '<th>TOTAL</th>';
#     $str .= sprintf '<th style="text-align: right;">%2.2f</th>',$col;
#     $str .= sprintf '<th style="text-align: right;">%2.2f</th>',$hab;
#     $str .= sprintf '<th style="text-align: right;">%2.2f</th>',$wat;
#     $str .= sprintf '<th style="text-align: right;">%2.2f</th>',$sup;
#     $str .= sprintf '<th style="text-align: right;">---</th>';
#     $str .= sprintf '<th style="text-align: right;">---</th>';
#     $str .= '</tr>';
#     $colspan=6;
#     $maxCol = 0;
#     my @DESIGN = $adv->getDesignScore($teamIDX);
#     my @PRESO = $adv->getPresoScore($teamIDX);
#     my $penalty = $adv->getPenalty($teamIDX);
#     $str .= '<tr>';
#     $str .= '<td colspan="'.$colspan.'" style="text-align: right;">N<sub>c</sub>/8N<sub>H</sub></td>';
#     if ($hab==0){
#         $col3hab =0;
#     } else {
#         $col3hab = $col/(8*$hab);
#     }
#     $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $col3hab;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<td colspan="'.$colspan.'" style="text-align: right;">N<sub>c</sub>/N<sub>w</sub></td>';
#     if ($wat==0){
#         $col2wat = 0
#     } else {
#         $col2wat = $col/$wat;
#     }
#     $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $col2wat;
#     $str .= '</tr>';
#     $maxCol = $col3hab;
#     if ($col2wat>$maxCol){$maxCol=$col2wat}
#     $str .= '<tr>';
#     $str .= '<td colspan="'.$colspan.'" style="text-align: right;">Days of Habitability</td>';
#     if ($col2wat==0 || $col2wat==0){
#         $days = 0;
#     } else {
#         $days = 25*(2**(1-$maxCol));
#     }
#     $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $days;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Final Flight Score</th>';
#     my $flightTotal = 0;
#     if ($inRound==0){
#         $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>', $flightTotal;
#     } else {
#         $flightTotal = ($col*$days)/(15*$inRound) + (2*$sup)/$inRound;
#         $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>', $flightTotal;
#     }

#     $str .= '</tr>';

#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Technical Design Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$DESIGN[5] - $DESIGN[4];
#     $str .= '</tr>';
    
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Technical Presentation Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$PRESO[5];
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Penalties:</th>';
#     $str .= sprintf '<th colspan="2" class="w3-text-red" style="text-align: right;">- %2.4f pts</th>',$penalty;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Total Overall Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',($DESIGN[5] - $DESIGN[4] + $PRESO[5] + $flightTotal - $penalty);
#     $str .= '</tr>';

#     $str .= '</table>';
#     $str .= '<div class="w3-panel w3-tiny w3-padding" style="width: 60%; margin: auto;">';
#     $str .= '<p>FFS = Final Flight Score = [(N<sub>c</sub> x D)/(15 x N)] + [(2 x S<sub>p</sub>)/N]</p>';
#     $str .= '<p>D = Days of Habitability = 25 x (2<sup>1-R<sub>max</sub></sup>)</p>';
#     $str .= '<p>R<sub>max</sub> = Maximum([N<sub>c</sub>/(8xN<sub>h</sub>)],[N<sub>c</sub>/N<sub>w</sub>]) <br>';
#     $str .= 'N<sub>c</sub> = Total number of colonist delivered during the competition<br>';
#     $str .= 'N<sub>h</sub> = Total number of habitats delivered during the competition<br>';
#     $str .= 'N<sub>w</sub> = Total amount of water (in fl oz) delivered during the competition<br>';
#     $str .= 'N<sub>s</sub> = Total static payload (lbs) delivered during the competition<br>';
#     $str .= 'N = Total Number of Flight Rounds During Competition</p>';
#     $str .= '<p>NOTE: To receive a mission performance score, you must deliver all three components (N<sub>c</sub>, N<sub>h</sub>, N<sub>w</sub>).</p>';
#     $str .= '</div>';
#     return ($str);
# }
# sub _showMicroFlightCard(){
#     my $teamIDX = shift;
#     my $inNumber = shift;
#     my $classIDX = shift;
#     my $txSchool = shift;
#     my $inRound = shift;
#     my $mic = new SAE::MICRO();
#     my $dbi = new SAE::Db();
#     my $str;
#     my $SQL = "SELECT GRADE.IN_SCORE, SCORE.PK_SCORE_IDX, QUE.PK_QUESTION_IDX, 
#             QUE.TX_TITLE, QUE.TX_DESCRIPTION, QUE.IN_ORDER, SCORE.IN_VALUE, GRADE.IN_ROUND
#             FROM TB_GRADE AS GRADE
#             JOIN TB_SCORE AS SCORE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
#             JOIN TB_QUESTION AS QUE ON SCORE.FK_QUESTION_IDX=QUE.PK_QUESTION_IDX
#         WHERE TX_TYPE=? AND FK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute('flight',$teamIDX);
#     %LOG = %{$select->fetchall_hashref(['IN_ROUND','PK_QUESTION_IDX'])};
#     $SQL = "SELECT SCORE.IN_VALUE
#             FROM TB_GRADE AS GRADE
#             JOIN TB_SCORE AS SCORE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
#             JOIN TB_QUESTION AS QUE ON SCORE.FK_QUESTION_IDX=QUE.PK_QUESTION_IDX
#         WHERE TX_TYPE=? AND FK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute('demo',$teamIDX);
#     my $demoTime = $select->fetchrow_array();
#     my $str;
#     $str .= '<h1 style="text-align: center;">#'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#     $str .= '<h2 style="text-align: center;">Flight Log Entries</h2>';
#     $str .= '<table class="w3-table-all w3-small" style="width: 70%; margin: auto;">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 5%;text-align: center;">Round<br>(N)</th>';
#     $str .= '<th style="width: 15%;text-align: right;">Payload<br>W<sub>payload</sub></th>';
#     $str .= '<th style="width: 15%;text-align: right;">Empty<br>W<sub>empty</sub></th>';
#     $str .= '<th style="width: 15%;text-align: right;;">Rule 3.5<br>Infraction</th>';
#     $str .= '<th style="width: 15%;text-align: right;;">Rule 3.10.3<br>Infraction</th>';
#     $str .= '<th style="width: 15%;text-align: right;">Raw<br>Score</th>';
#     $str .= '<th style="width: 20%;text-align: right;">Flight<br>Score</th>';
# #     $str .= '<th style="width: 60%;text-align: center;">Flight Score Equation</th>';
#     $str .= '</tr>';
#     my $total = 0;
#     my $maxFs = 0;
#     my $total = 0;
#     for ($x=1; $x<=$inRound; $x++){
#         my ($payload, $empty, $fs, $adjusted, $demo, $minor, $landing) =  $mic->getTeamFlightScoreInRound($teamIDX, $x);
#         $str .= '<tr>';
#         $str .= '<td style="text-align: center;">'.$x.'</td>';
#         $total += $adjusted;
#         if ($adjusted > $maxFs){$maxFs = $adjusted}
#         $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$payload;
#         $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$empty;
#         $str .= '<td style="text-align: right;">'.$minor.'</td>';
#         $str .= '<td style="text-align: right;">'.$landing.'</td>';
#         if($empty>0){
#             $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$fs;
#             $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$adjusted;
#         } else {
#             $str .= sprintf '<td style="text-align: right;">%2.4f</td>',0;
#             $str .= sprintf '<td style="text-align: right;">%2.4f</td>',0;
#         }

# #         $str .= '<td class="w3-small" style="text-align: center;">FS = W<sub>payload</sub> / Sqrt (W<sub>empty</sub>)</td>';
#         $str .= '</tr>';
#     }
#     $str .= '<tr>';
#     my $colspan=6;
#     if ($inRound==0){$inRound=1}
#     my $averageFs = 0;
#     my $demoAssemblyTime = 5*(2-($demoTime/60))**3;
#     if ($demoTime==0){$demoAssemblyTime = 0}
#     my @DESIGN = $mic->getDesignScore($teamIDX);
#     my @PRESO = $mic->getPresoScore($teamIDX);
#     my $penalty = $mic->getPenalty($teamIDX);

#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Average Flight Score (FS<sub>avg</sub>):</th>';
#     if ($inRound==0){
#         $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>',0;
#     } else {
#         $averageFs = $total/$inRound;
#         $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>',$total/$inRound;
#     }

#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Max Flight Score (FS<sub>max</sub>):</th>';
#     $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>',$maxFs;
#     $str .= '</tr>';
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= sprintf '<th colspan="'.$colspan.'" style="text-align: right;">Assembly Demonstration (%2.4f secs) Score:</th>',$demoTime;
#     $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>',$demoAssemblyTime;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Final Flight Score After '.$inRound.' Rounds:</th>';
#     my $flightTotal = 20 * (($averageFs/2) + ($maxFs/2)) + $demoAssemblyTime;
#     $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>', $flightTotal;
# #     $str .= sprintf '<th style="text-align: right;">%2.4f pts</th>',20*((.5*$averageFs) + (.5 * $maxFs)) + $demoTime;
#     $str .= '</tr>';

#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Technical Design Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$DESIGN[5] - $DESIGN[4];
#     $str .= '</tr>';
    
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Technical Presentation Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',$PRESO[5];
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Penalties:</th>';
#     $str .= sprintf '<th colspan="2" class="w3-text-red" style="text-align: right;">- %2.4f pts</th>',$penalty;
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<th colspan="'.$colspan.'" style="text-align: right;">Total Overall Score:</th>';
#     $str .= sprintf '<th colspan="2" style="text-align: right;">%2.4f pts</th>',($DESIGN[5] - $DESIGN[4] + $PRESO[5] + $flightTotal - $penalty);
#     $str .= '</tr>';

#     $str .= '</table>';
#     $str .= '<div class="w3-panel w3-tiny w3-padding" style="width: 70%; margin: auto;">';
#     $str .= '<P>FFS =  FINAL FLIGHT SCORE = 20 x [(.5 X FS<sub>avg</sub>) + (0.5 X FS<sub>max</sub>)] + AD</P>';
#     $str .= '<P>AD = ASSEMBLY DEMO = 5 x [2-(t/60)]<sup>3</sup></P>';
#     $str .= '<p>FS = W<sub>payload</sub> / Sqrt (W<sub>empty</sub>)</p>';
#     $str .= '<p>FS<sub>max</sub> = Team\'s maximum single flight score<br>';
#     $str .= 'FS<sub>avg</sub> = Empty Weight</br>';
#     $str .= 'AD = Assembly Demo<br>';
#     $str .= 't = time recorded in seconds<br>';
#     $str .= 'W<sub>payload</sub> = Payload Weight</br>';
#     $str .= 'W<sub>empty</sub> = Empty Weight</br>';
#     $str .= 'N = Total Number of Flight Rounds During Competition</p>';

#     $str .= '</div>';
#     return ($str);
# }
# sub _showPenalty(){
#     my $teamIDX = shift;
#     my $inNumber = shift;
#     my $classIDX = shift;
#     my $txSchool = shift;
#     my $dbi = new SAE::Db();
#     my $str;
#     my $SQL = "SELECT * FROM TB_GRADE WHERE TX_TYPE=? AND FK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute('penalty',$teamIDX);
#     %PENALTY = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
#     $str = '<h1>'.substr("000".$inNumber,-3,3).' - '.$txSchool.'</h1>';
#     $str .= '<h3>Penalties</h3>';
#     $str .= '<table class="w3-table-all">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 200px;">Title</th>';
#     $str .= '<th>Description</th>';
#     $str .= '<th style="width: 100px;">Deductions</th>';
#     $str .= '</tr>';
#     my $total = 0;
#     foreach $pkGradeIdx (sort keys %PENALTY){
#         $inScore = $PENALTY{$pkGradeIdx}{IN_SCORE};
#         $str .= '<tr>';
#         $str .= '<td>'.$PENALTY{$pkGradeIdx}{TX_TITLE}.'</td>';
#         $str .= '<td>'.$PENALTY{$pkGradeIdx}{TX_DESCRIPTION}.'</td>';
#         $str .= sprintf '<td style="text-align: right">%2.2f</td>', $inScore;
#         $str .= '</tr>';
#         $total += $inScore;
#     }
#     $str .= '<tr>';
#     $str .= '<th colspan="2" style="text-align: right">Total Penalty Assessed</th>';
#     $str .= sprintf '<th style="text-align: right">%2.2f</th>', $total;
#     $str .= '</tr>';
#     $str .= '</table>';
#     $str .= '<p><sup>*</sup>Note: Please note that these penalty points will be applied to the overall calculation to determine the overall competition winner.</p>';
#     return($str);
# }
# sub _showDesignAssessments(){
#     my $PkTeamIdx = shift;
#     my $inNumber = shift;
#     my $classIDX = shift;
#     my $txSchool = shift;
#     my $Team = new SAE::TB_TEAM();
#     $Team->getRecordById($PkTeamIdx);
#     my $factor = $Team->getInFactor();
#     my $list = shift;
# #     @LIST = split(",",$list);
#     @LIST = @{$list};
# #     print $classIDX ."<br>";
#     my %WEIGHT = ();
#     if ($classIDX == 1) {
#         %WEIGHT = ('requirements'=>5.00, 'tds'=>5, 'drawing'=>5, 'report'=>35, 'presentation'=>50, 'demo'=>3);
#     } else {
#         %WEIGHT = ('requirements'=>5.00, 'tds'=>5, 'drawing'=>5, 'report'=>35, 'presentation'=>50);
#     }
#     my $str;
#     my $dbi = new SAE::Db();
#     my $SQL = "SELECT GRADE.*, SCORE.*, QUESTION.*, QUESTION.IN_WEIGHT AS QIN_WEIGHT, SUB.IN_WEIGHT AS SIN_WEIGHT, SUB.* FROM TB_GRADE AS GRADE
#         JOIN TB_SCORE AS SCORE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
#         JOIN TB_QUESTION AS QUESTION ON SCORE.FK_QUESTION_IDX=QUESTION.PK_QUESTION_IDX
#         JOIN TB_SUB_SECTION AS SUB ON QUESTION.FK_SUB_SECTION_IDX=SUB.PK_SUB_SECTION_IDX
#             WHERE GRADE.FK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx) || die "Error";
#     %GRADE = %{$select->fetchall_hashref(['TX_TYPE','PK_GRADE_IDX','FK_SUB_SECTION_IDX','PK_QUESTION_IDX'])};
#     $SQL = "SELECT * FROM TB_SUB_SECTION";
#     $select = $dbi->prepare($SQL);
#     $select->execute() || die "Error";
#     %SUBSEC = %{$select->fetchall_hashref(['PK_SUB_SECTION_IDX'])};
#     $SQL = "SELECT * FROM `TB_COMMENT` WHERE FK_TEAM_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx) || die "Error";
#     %COMMENT = %{$select->fetchall_hashref(['FK_GRADE_IDX','FK_QUESTION_IDX','PK_COMMENT_IDX'])};

#     foreach $type (@LIST) {
#         foreach $gradeIDX (sort keys %{$GRADE{$type}}) {
#             $str .= '<div class="w3-container w3-display-container w3-border-bottom w3-card-4">';
#             $str .= '<span class="w3-display-topright w3-margin-right w3-margin-top">Card ID:'.$gradeIDX.'</span>';
#             $str .= '<h1>Team #'.substr("000".$inNumber,-3,3).' : '.$txSchool.'</h1>';
#             $str .= '<h2>'.uc($type).': ('.$WEIGHT{$type}.' pts)</h2>';
#             my $TOTAL = 0;
#             foreach $subIDX (sort {$a<=>$b} keys %{$GRADE{$type}{$gradeIDX}}) {
#                 my $subtotal = 0;
#                 my $subSecPercentage = $SUBSEC{$subIDX}{IN_WEIGHT}/100;
#                 $str .= '<h3>'.uc($SUBSEC{$subIDX}{TX_SUB_SECTION}).' ('.$SUBSEC{$subIDX}{IN_WEIGHT}.'%)</h3>';
#                 $str .= '<table class="w3-table-all w3-small">';
#                 $str .= '<tr>';
#                 $str .= '<th>Title</th>';
#                 $str .= '<th>Description</th>';
#                 $str .= '<th>Question<br>Weight</th>';
#                 if ($type eq 'demo' && $classIDX ==1){
#                     $str .= '<th>Demo<br>Time</th>';
#                 } else {
#                     $str .= '<th>Judge\'s<br>Assessment</th>';
#                 }
#                 $str .= '<th>Factor</th>';
#                 $str .= '<th>Points</th>';
#                 $str .= '</tr>';
#                 foreach $questionIDX (sort {$GRADE{$type}{$gradeIDX}{$subIDX}{$a}{IN_ORDER} <=> $GRADE{$type}{$gradeIDX}{$subIDX}{$b}{IN_ORDER}} keys %{$GRADE{$type}{$gradeIDX}{$subIDX}}) {
#                     $qWeight = $GRADE{$type}{$gradeIDX}{$subIDX}{$questionIDX}{QIN_WEIGHT};
#                     $sWeight = $GRADE{$type}{$gradeIDX}{$subIDX}{$questionIDX}{SIN_WEIGHT};
#                     $inValue = $GRADE{$type}{$gradeIDX}{$subIDX}{$questionIDX}{IN_VALUE};
#                     my $pts = 0;
#                     if ($type eq 'demo' && $classIDX ==1){
#                         $qWeight = 50;
#                         $sWeight = 100;
#                         if ($inValue<=60){$pts = 1.5};
#                     } else {
#                         $pts = $WEIGHT{$type}*($qWeight/100)*($inValue/100)*($sWeight/100);
#                     }
#                     $subtotal += $pts;
#                     $str .= '<tr>';
#                     $str .= '<td>'.$GRADE{$type}{$gradeIDX}{$subIDX}{$questionIDX}{TX_TITLE}.'</td>';
#                     $str .= '<td>'.$GRADE{$type}{$gradeIDX}{$subIDX}{$questionIDX}{TX_DESCRIPTION}.'</td>';
#                     if ($type eq 'demo' && $classIDX ==1){
#                         $str .= sprintf '<td>%2.1f%</td>',$qWeight;
#                         $str .= sprintf '<td>%2.0f sec</td>',$inValue;
#                         $str .= sprintf '<td>%2.2f</td>',$pts;

#                     } else {
#                         $str .= sprintf '<td>%2.1f%</td>',$qWeight;
#                         $str .= sprintf '<td>%2.1f%</td>',$inValue;
#                         $str .= sprintf '<td>%2.2f</td>',$factor;
#                         $str .= sprintf '<td>%2.2f</td>',($pts * $factor);
#                     }
#                     $str .= '</tr>';
#                     foreach $commentIDX (sort keys %{$COMMENT{$gradeIDX}{$questionIDX}}) {
#                         $str .= '<tr class="w3-sand">';
#                         $str .= '<td class="w3-normal">Comment(s):</td>';
#                         $str .= '<td colspan="9"><em>'.$COMMENT{$gradeIDX}{$questionIDX}{$commentIDX}{TX_COMMENT}.'</em></td>';
#                         $str .= '</tr>';
#                     }
#                 }

#                 $str .= '<tr>';
#                 $str .= sprintf '<td colspan="10" style="text-align: right; padding: 5px;">sub-Total Points Earned: %2.2f / %2.2f</td>', ($subtotal * $factor), ($WEIGHT{$type})*$subSecPercentage;
#                 $str .= '</tr>';
#                 $str .= '</table>';
#                 $TOTAL += $subtotal;
#             }
#             $str .= '<footer class="w3-green">';
#             $str .= sprintf '<h3 style="text-align: right; padding: 6px ">TOTAL: %2.2f / '.$WEIGHT{$type}.'.00</h3>',($TOTAL * $factor);
#             $str .= '</footer>';
#             if ($type eq 'presentation') {
#                 push (@$PkTeamIdx, $TOTAL);
#             } elsif ($type eq 'report') {
#                 push (@$PkTeamIdx, ($TOTAL * $factor));
#             # if ($type eq 'report' || $type eq 'presentation' ){
#             #     push (@$PkTeamIdx, $TOTAL);
#             } else {
#              $TOTALSCORE{$type} = sprintf "%2.4f",($TOTAL * $factor);
#             }

#             $str .= '</div><br>';
#         }
#         if ($type eq 'report' || $type eq 'presentation' ){
#             $TOTALSCORE{$type} =sprintf "%2.4f", &average(@$PkTeamIdx);
#         }

#     }
#     my $FINAL = 0;
#     foreach $item (sort keys %TOTALSCORE) {
#         $FINAL += ($TOTALSCORE{$item});
# #         $str .= "$TOTALSCORE{$item}<br>";
#     }
#     $hdr = '<div class="w3-panel w3-card-4 w3-round w3-center">';
#     $hdr .= '<h1 class=" w3-green w3-padding"><div class="w3-large">';
#     $hdr .= join(" + ", keys %TOTALSCORE)." = FINAL SCORE";
#     $hdr .= '</div>';
#     $hdr .= '<div class="w3-large">';
#     $hdr .= join(" + ", values %TOTALSCORE)." = ".$FINAL;
#     $hdr .= '</div>';
#     $hdr .= '<div class="w3-xxlarge">';
#     $hdr .= sprintf 'FINAL SCORE = %2.4f', $FINAL;
#     $hdr .= '</div>';

#     $hdr .= '</div>';
# #     $str .= join("<br>",@LIST);
#     return($hdr.$str);
# }
