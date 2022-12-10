#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use feature qw(switch);
use Cwd 'abs_path'; 


#---- SAE MODULES -------
use SAE::SCORE;
# use SAE::RUBRIC;
# use SAE::HOME;
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
sub viewPostResults(){
    print $q->header();
    my $Scores = new SAE::SCORE();
    my $fileID = $q->param('fileID');
    my $location = $q->param('location');
    my %DATA = %{$Scores->_getPublishedItem( $fileID )};
    my $classIDX = $DATA{FK_CLASS_IDX};
    my $tileIDX = $DATA{FK_TILES_IDX};
    my $txTitle = $DATA{TX_TITLE};
    my $boScore = $DATA{BO_SCORE};
    my $inRound = $DATA{IN_ROUND};
    my $str;
    if ($tileIDX == 14) {
        $str = &_displayDesignResults( $txTitle, $location , $classIDX, $boScore );
    } elsif ($tileIDX == 15) {
        $str = &_displayPresentationResults( $txTitle, $location , $classIDX, $boScore);
    } elsif ($tileIDX == 17) {
        $str = &_displayFlightResults( $txTitle, $location , $classIDX, $boScore, $inRound );
    } elsif ($tileIDX == 10) {
        $str = &_displayOverallResults( $txTitle, $location , $classIDX, $boScore, $inRound )
    }
    # $str .= "$txTitle, $location , $classIDX, $boScore, \$inRound=$inRound";

    return ($str);
};

sub _displayFlightResults(){
    my $txTitle = shift;
    my $location = shift;
    my $classIDX = shift;
    my $boScore = shift;
    my $inRound = shift;
    my $Score = new SAE::SCORE();
    if ($classIDX==3){
        %TEAMS = %{$Score->_getTeamFlgihtScoresByClass($location, $classIDX, $inRound )};
    } elsif ($classIDX==2) {
        %TEAMS = %{$Score->_getAdvancedFlightsByEvent($location,  $inRound, $classIDX)};
    } else {
        %TEAMS = %{$Score->_getRegularFlightsByEvent($location,  $inRound, $classIDX)};
    }
    %CLASS= (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str = '<center><h1>'.$txTitle.'</h1>';
    $str .= '<h3>'.$CLASS{$classIDX}.': Round '.$inRound.'</h3>';
    $str .= '</center>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Order</th>';
    $str .= '<th>School</th>';
    $str .= '<th style="text-align: right;">Country</th>';
    if ($boScore==1){
        $str .= '<th style="width: 100px; text-align: right;">Round '.$inRound.'<br>Score</th>';
    }
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    foreach $teamIDX (sort {$TEAMS{$b}{IN_OVERALL} <=> $TEAMS{$a}{IN_OVERALL}} keys %TEAMS){
        my $txSchool = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL}." (<i>".$TEAMS{$teamIDX}{TX_NAME}."</i>)";
        my $txNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        my $txName = '<i>'.$TEAMS{$teamIDX}{TX_NAME}.'</i>';
        if ($score != $TEAMS{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td>%2.0f</td>', $rank;
        $str .= sprintf '<td>%2s</td>', $txSchool;
        $str .= sprintf '<td style="text-align: right;">%2s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        if ($boScore==1){
            $str .= sprintf '<b>Rank: </b><span class="w3-text-blue">%2.0f (%2.4f)</span><br>', $rank, $TEAMS{$teamIDX}{IN_OVERALL};
        } else {
            $str .= sprintf '<b>Rank: </b><span class="w3-text-blue">%2.0f</span><br>', $rank;
        }
        $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txNumber ;
        $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txName;
        $str .= sprintf '<b>Country: </b><span class="w3-text-black">%s</span><br>', $TEAMS{$teamIDX}{TX_COUNTRY};
        $str .= '</td>';
        $str .= '</tr>';
    }
    $ste .= '</table>';
    return ($str); 
}
sub _displayDesignResults(){ #Displaying Design Sscores
    my $txTitle = shift;
    my $location = shift;
    my $classIDX = shift;
    my $boScore = shift;
    my $Score = new SAE::SCORE();
    %TEAMS = %{$Score->_getOverallDesignResults($location, $classIDX )};
    %CLASS= (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str = '<center><h1>'.$txTitle.'</h1>';
    $str .= '<h3>'.$CLASS{$classIDX}.'</h3>';
    $str .= '</center>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Order</th>';
    $str .= '<th>School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right;">Country</th>';
    if ($boScore==1){
        $str .= '<th style="width: 100px; text-align: right;">Late<br>Penalty</th>';
        $str .= '<th style="width: 100px; text-align: right;">Score</th>';
    }
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    foreach $teamIDX (sort {$TEAMS{$b}{IN_OVERALL} <=> $TEAMS{$a}{IN_OVERALL}} keys %TEAMS){
        # my $txSchool = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        my $txSchool = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL}." (<i>".$TEAMS{$teamIDX}{TX_NAME}."</i>)";
        my $txNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        my $txName = '<i>'.$TEAMS{$teamIDX}{TX_NAME}.'</i>';
        if ($score != $TEAMS{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td>%2.0f</td>', $rank;
        $str .= sprintf '<td>%2s</td>', $txSchool;
        # $str .= sprintf '<td>%2s</td>', $TEAMS{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right;">%2s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            if ($TEAMS{$teamIDX}{IN_LATE}>0){
                $str .= sprintf '<td style="text-align: right;" class="w3-text-red">-%2.1f</td>', $TEAMS{$teamIDX}{IN_LATE};
            } else {
                $str .= '<td style="text-align: right;" class="w3-text-red">-</td>';
            }
            
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<b>Rank: </b><span class="w3-large">%2.0f</span><br>', $rank;
        $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txNumber ;
        $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txName;
        $str .= sprintf '<b>Country: </b><span class="w3-text-black">%s</span><br>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            if ($TEAMS{$teamIDX}{IN_LATE}>0){
                $str .= sprintf '<b>Penalties</b>: <span class="w3-text-red w3-large">-%2.1f pts</span><br>', $TEAMS{$teamIDX}{IN_LATE} ;
            } else {
                $str .= '<b>ERC Penalties</b>: <span class="w3-text-black">-none-</span><br>';
            }
            
            $str .= sprintf '<b>Score</b>: <span class="w3-text-black w3-large">%2.4f pts</span><br>', $TEAMS{$teamIDX}{IN_OVERALL} ;
        }
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    return ($str);
}
sub _displayPresentationResults(){ #Displaying Design Sscores
    my $txTitle = shift;
    my $location = shift;
    my $classIDX = shift;
    my $boScore = shift;
    my $Score = new SAE::SCORE();
    %TEAMS = %{$Score->_getOverallPresoResults($location, $classIDX )};
    %CLASS= (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str = '<center><h1>'.$txTitle.'</h1>';
    $str .= '<h3>'.$CLASS{$classIDX}.'</h3>';
    $str .= '</center>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Order</th>';
    $str .= '<th>School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right;">Country</th>';
    if ($boScore==1){
        $str .= '<th style="width: 100px; text-align: right;">Score</th>';
    }
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
        foreach $teamIDX (sort {$TEAMS{$b}{IN_OVERALL} <=> $TEAMS{$a}{IN_OVERALL}} keys %TEAMS){
        # my $txSchool = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        my $txSchool = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL}." (<i>".$TEAMS{$teamIDX}{TX_NAME}."</i>)";
        my $txNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3)." - ".$TEAMS{$teamIDX}{TX_SCHOOL};
        my $txName = '<i>'.$TEAMS{$teamIDX}{TX_NAME}.'</i>';
        if ($score != $TEAMS{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '<tr class="w3-hide-small">';
        $str .= sprintf '<td>%2.0f</td>', $rank;
        $str .= sprintf '<td>%2s</td>', $txSchool;
        # $str .= sprintf '<td>%2s</td>', $TEAMS{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right;">%2s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        if ($boScore==1){
            $str .= sprintf '<b>Rank: </b><span class="w3-text-blue">%2.0f (%2.4f)</span><br>', $rank, $TEAMS{$teamIDX}{IN_OVERALL};
        } else {
            $str .= sprintf '<b>Rank: </b><span class="w3-text-blue">%2.0f</span><br>', $rank;
        }
        $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txNumber ;
        $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txName;
        $str .= sprintf '<b>Country: </b><span class="w3-text-black">%s</span><br>', $TEAMS{$teamIDX}{TX_COUNTRY};
        $str .= '</td>';
        $str .= '</tr>';

    }
    $str .= '</table>';
    return ($str);
}
sub _displayOverallResults(){
    my $txTitle = shift;
    my $location = shift;
    my $classIDX = shift;
    my $boScore = shift;
    my $inRound = shift;
    my $Score = new SAE::SCORE();
    %DESIGN = %{$Score->_getOverallDesignResults($location, $classIDX )};
    %PRESO = %{$Score->_getOverallPresoResults($location, $classIDX )};
    %PEN = %{$Score->_getPenaltyListByEvent($location)};
    if ($classIDX==3){
        %FLIGHT = %{$Score->_getTeamFlgihtScoresByClass($location, $classIDX, $inRound )};
    } elsif ($classIDX==2) {
        %FLIGHT = %{$Score->_getAdvancedFlightsByEvent($location,  $inRound, $classIDX)};
    } else {
        %FLIGHT = %{$Score->_getRegularFlightsByEvent($location,  $inRound, $classIDX)};
    }
    
    foreach $teamIDX (sort keys %DESIGN){
        $final = $DESIGN{$teamIDX}{IN_OVERALL} + $PRESO{$teamIDX}{IN_OVERALL} + $FLIGHT{$teamIDX}{IN_OVERALL} - $PEN{$teamIDX}{IN_TOTAL};
        $DESIGN{$teamIDX}{IN_FINAL} = $final;
    }


    %CLASS= (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str;
    # $str .= $inRound;
    # $str .= "$location, $classIDX";
    $str .= sprintf '<center><h1>%s: Outstanding Technical Design Report</h1>', $CLASS{$classIDX};
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Standing</th>';
    $str .= '<th>School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right;">Country</th>';
    $str .= '<th style="width: 100px; text-align: right;">Late<br>Penalty</th>';
    $str .= '<th style="width: 100px; text-align: right;">Design<br>Score</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $newClass="";
    # foreach $teamIDX (sort {$DESIGN{$b}{IN_FINAL} <=> $DESIGN{$a}{IN_FINAL}} keys %DESIGN) {
    foreach $teamIDX (sort {$DESIGN{$b}{IN_OVERALL} <=> $DESIGN{$a}{IN_OVERALL}} keys %DESIGN) {
        # my $txSchool = sprintf '', 
        if ($score != $DESIGN{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $DESIGN{$teamIDX}{IN_OVERALL};
        }
        if ($rank>3 || $rank==0){$newClass="w3-design w3-hide"}
        if ($DESIGN{$teamIDX}{IN_LATE}>50){
            $DESIGN{$teamIDX}{IN_LATE} = 50;
        }
        $str .= sprintf '<tr class="%s">', $newClass;  
        $str .= sprintf '<td style="text-align: left;">%d</td>', $rank;
        $str .= sprintf '<td style="text-align: left;">%03d - %s (<i>%s</i>)</td>',$DESIGN{$teamIDX}{IN_NUMBER}, $DESIGN{$teamIDX}{TX_SCHOOL}, $DESIGN{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right;">%s</td>',$DESIGN{$teamIDX}{TX_COUNTRY};
        if ($DESIGN{$teamIDX}{IN_LATE}>0){
            $str .= sprintf '<td class="w3-text-red" style="text-align: right;">-%2.1f</td>',$DESIGN{$teamIDX}{IN_LATE};
        } else {
            $str .= sprintf '<td class="w3-text-red" style="text-align: right;">---</td>';
        }
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$DESIGN{$teamIDX}{IN_OVERALL};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= sprintf '<a href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-design' ;
    $str .= '<hr style="page-break-before: always;">';
    
    $str .= sprintf '<center><h1>%s: Outstanding Technical Presentation</h1>', $CLASS{$classIDX};
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Standing</th>';
    $str .= '<th>School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right;">Country</th>';
    $str .= '<th style="width: 100px; text-align: right;">Presentation<br>Score</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $presoClass="";
    foreach $teamIDX (sort {$PRESO{$b}{IN_OVERALL} <=> $PRESO{$a}{IN_OVERALL}} keys %PRESO) {
        # my $txSchool = sprintf '', 
        if ($score != $PRESO{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $PRESO{$teamIDX}{IN_OVERALL};
        }
        if ($rank>3 || $rank==0){$presoClass="w3-preso w3-hide"}
        $str .= sprintf '<tr class="%s">', $presoClass;    
        $str .= sprintf '<td style="text-align: left;">%d</td>', $rank;
        $str .= sprintf '<td style="text-align: left;">%03d - %s (<i>%s</i>)</td>',$DESIGN{$teamIDX}{IN_NUMBER}, $DESIGN{$teamIDX}{TX_SCHOOL}, $DESIGN{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right;">%s</td>',$DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$PRESO{$teamIDX}{IN_OVERALL};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= sprintf '<a href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-preso' ;
    $str .= '<hr style="page-break-before: always;">';
    
    $str .= sprintf '<center><h1>%s: %d Rounds of Outstanding Mission Performance</h1>', $CLASS{$classIDX}, $inRound;
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Standing</th>';
    $str .= '<th>School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right;">Country</th>';
    $str .= '<th style="width: 100px; text-align: right;">Performance<br>Score</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $flightClass="";
    foreach $teamIDX (sort {$FLIGHT{$b}{IN_OVERALL} <=> $FLIGHT{$a}{IN_OVERALL}} keys %FLIGHT) {
        # my $txSchool = sprintf '', 
        if ($score != $FLIGHT{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $FLIGHT{$teamIDX}{IN_OVERALL};
        }
        if ($rank>3 || $rank==0){$flightClass="w3-flight w3-hide"}
        # $str .= '<tr>';  
        $str .= sprintf '<tr class="%s">', $flightClass;   
        $str .= sprintf '<td style="text-align: left;">%d</td>', $rank;
        $str .= sprintf '<td style="text-align: left;">%03d - %s (<i>%s</i>)</td>',$DESIGN{$teamIDX}{IN_NUMBER}, $DESIGN{$teamIDX}{TX_SCHOOL}, $DESIGN{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right;">%s</td>',$DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= sprintf '<a href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-flight' ;
    $str .= '<hr style="page-break-before: always;">';
    
    $str .= '<center><h1>'.$txTitle.'</h1>';
    $str .= '<h3>'.$CLASS{$classIDX}.': Last Round '.$inRound.'</h3>';
    $str .= '</center>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Standing</th>';
    $str .= '<th>School</th>';
    $str .= '<th style="text-align: right; width: 85px;">Country</th>';
    # $str .= '<th style="text-align: right; width: 85px;">Late<br>Report<br>Penalty</th>';
    $str .= '<th style="text-align: right; width: 85px;">Design<br>Scores</th>';
    $str .= '<th style="text-align: right; width: 85px;">Presentation<br>Scores</th>';
    $str .= '<th style="text-align: right; width: 85px;">Flight<br>Scores</th>';
    $str .= '<th style="text-align: right; width: 85px;">ECR<br>Penalties</th>';
    $str .= '<th style="text-align: right; width: 85px;">Overall<br>After<br>Round '.$inRound.'</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $overallClass="";
    foreach $teamIDX (sort {$DESIGN{$b}{IN_FINAL} <=> $DESIGN{$a}{IN_FINAL}} keys %DESIGN) {
        my $txSchool = substr("000".$DESIGN{$teamIDX}{IN_NUMBER},-3,3)." - ".$DESIGN{$teamIDX}{TX_SCHOOL}." (<i>".$DESIGN{$teamIDX}{TX_NAME}."</i>)";
        my $txNumber = substr("000".$DESIGN{$teamIDX}{IN_NUMBER},-3,3)." - ".$DESIGN{$teamIDX}{TX_SCHOOL};
        my $txName = '<i>'.$DESIGN{$teamIDX}{TX_NAME}.'</i>';
        if ($score != $DESIGN{$teamIDX}{IN_FINAL}){
            $rank++;
            $score = $DESIGN{$teamIDX}{IN_FINAL};
        }
        if ($rank>3 || $rank==0){$overallClass="w3-overall w3-hide"}
        $str .= sprintf '<tr class="w3-hide-small %s">', $overallClass;
        $str .= sprintf '<td>%2.0f</td>', $rank;
        $str .= sprintf '<td>%2s</td>', $txSchool;
        $str .= sprintf '<td style="text-align: right;">%2s</td>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $DESIGN{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $PRESO{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<td class="w3-text-red" style="text-align: right;">(%2.1f)</td>', $PEN{$teamIDX}{IN_TOTAL};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $DESIGN{$teamIDX}{IN_FINAL};
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<b>Rank: </b> <span class="w3-text-blue">%2.0f</span><br>', $rank;
        $str .= sprintf '<span>%s</span><br>', $txNumber;
        $str .= sprintf '<span>%s</span><br>', $txName;
        $str .= sprintf '<b>Country: </b> <span>%s</span><br>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= '<div class="w3-container">';
        $str .= '<ul class="w3-ul w3-border w3-white">';
        $str .= sprintf '<li class="w3-display-container">Design Score<span class="w3-transparent w3-display-right w3-margin-right">%2.4f</span></li>',$DESIGN{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<li class="w3-display-container">Presentation Score<span class="w3-transparent w3-display-right w3-margin-right">%2.4f</span></li>',$PRESO{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<li class="w3-display-container">Flight Score<span class="w3-transparent w3-display-right w3-margin-right">%2.4f</span></li>',$FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<li class="w3-display-container">Penalties<span class="w3-transparent w3-display-right w3-margin-right">%2.4f</span></li>',$PEN{$teamIDX}{IN_TOTAL};
        $str .= sprintf '<li class="w3-display-container">Final Score<span class="w3-transparent w3-display-right w3-margin-right">%2.4f</span></li>',$DESIGN{$teamIDX}{IN_FINAL};
        $str .= '</ul>';
        # $str .= '<span class="w3-container w3-half" style="display: inline!important">Design Score:</span>';
        # $str .= sprintf '<span class="w3-container w3-half" style="display: inline!important">%2.4f</span>',$DESIGN{$teamIDX}{IN_OVERALL};
        # $str .= sprintf '<span class="w3-container w3-rest">Design Score: </span><span style="width: 25%; text-align: right;">%2.4f</span><br>', $DESIGN{$teamIDX}{IN_OVERALL};
        # $str .= sprintf '<span class="w3-container w3-half">Presentation Score: </span><span  class="w3-container w3-half">%2.4f</span><br>', $PRESO{$teamIDX}{IN_OVERALL};
        # $str .= sprintf '<span class="w3-half">Flight Score: </span><span class="w3-half">%2.4f</span><br>', $FLIGHT{$teamIDX}{IN_OVERALL};
        # $str .= sprintf '<span class="w3-half">Penalties: </span><span class="w3-half">%2.4f</span><br>', $PEN{$teamIDX}{IN_TOTAL};
        # $str .= sprintf '<span class="w3-half">Final Score: </span><span class="w3-half">%2.4f</span><br>', $DESIGN{$teamIDX}{IN_FINAL};
        $str .= '</div>';
        $str .= '</td>';    
        $str .= '</tr>';
    }
    my $rank = 0;
    my $score = 0;
    $str .= '</table>';
    $str .= sprintf '<a href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-overall' ;
    $str .= '<hr style="page-break-before: always;">';
    return ($str);
}