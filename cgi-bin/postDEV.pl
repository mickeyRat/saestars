#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use feature qw(switch);
use Cwd 'abs_path'; 


#---- SAE MODULES -------
use SAE::SCORE;
use SAE::MICRO;
use SAE::REGULAR;
use SAE::ADVANCED;
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
    my $Micro = new SAE::MICRO($location);
    my $Regular = new SAE::REGULAR($location);
    my %TEAMS = ();
    
    # if ($classIDX==3){
    #     %FLIGHT = %{&calculateMicroClassFlights($inRound, $location)};
    # } elsif ($classIDX==2) {
    #     %FLIGHT = %{&calculateAdvancedClassFlights($inRound, $location)};
    # } else {
    #     %FLIGHT = %{&calculateRegularClassFlights($inRound, $location)};
    # }
    
    if ($classIDX==3){
        # %TEAMS = %{$Micro->_getMicroTeamList()};
        # foreach $teamIDX (sort keys %TEAMS) {
        #     $TEAMS{$teamIDX}{IN_OVERALL} = $Micro->_getTeamFinalScore($teamIDX, $inRound);
        # }
        %TEAMS = %{&calculateMicroClassFlights($inRound, $location)};
    } elsif ($classIDX==2) {
        # %TEAMS = %{$Score->_getAdvancedFlightsByEvent($location,  $inRound, $classIDX)};
        %TEAMS = %{&calculateAdvancedClassFlights($inRound, $location)};
    } else {
        # %TEAMS = %{$Regular->_getTeamList()};
        # foreach $teamIDX (sort keys %TEAMS) {
        #     my ($ffs, $bonus) = $Regular->_getTeamFinalScore($teamIDX, $inRound);
        #     $TEAMS{$teamIDX}{IN_OVERALL} = $ffs+$bonus;
        # }
        %TEAMS = %{&calculateRegularClassFlights($inRound, $location)};
    }
    %CLASS= (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str = '<center><h1>'.$txTitle.' ccc</h1>';
    $str .= '<h3>'.$CLASS{$classIDX}.': Round '.$inRound.'</h3>';
    $str .= '</center>';
    $str .= '<table class="w3-table-all w3-white w3-card">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px;">Order</th>';
    $str .= '<th># - School (<i>Name</i>)</th>';
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
        if ($score == 0){
            $str .= sprintf '<td style="padding: 1px; text-align: center;">--</td>';
        } else {
            $str .= sprintf '<td style="padding: 1px; text-align: center;">%2.0f</td>', $rank;
        }
        
        $str .= sprintf '<td style="padding: 1px;">%2s</td>', $txSchool;
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>', $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $TEAMS{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $TEAMS{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Score</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $TEAMS{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        # if ($boScore==1){
        #     $str .= sprintf '<b>Rank: </b><span class="w3-text-blue">%2.0f (%2.4f)</span><br>', $rank, $TEAMS{$teamIDX}{IN_OVERALL};
        # } else {
        #     $str .= sprintf '<b>Rank: </b><span class="w3-text-blue">%2.0f</span><br>', $rank;
        # }
        # $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txNumber ;
        # $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txName;
        # $str .= sprintf '<b>Country: </b><span class="w3-text-black">%s</span><br>', $TEAMS{$teamIDX}{TX_COUNTRY};
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
    $str .= '<table class="w3-table-all">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px; padding: 1px;">Order</th>';
    $str .= '<th style=" padding: 1px;">School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right; padding: 1px;">Country</th>';
    if ($boScore==1){
        $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Late<br>Penalty</th>';
        $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Score</th>';
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
        $str .= sprintf '<td style=" padding: 1px;">%2.0f</td>', $rank;
        $str .= sprintf '<td style=" padding: 1px;">%2s</td>', $txSchool;
        # $str .= sprintf '<td>%2s</td>', $TEAMS{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            if ($TEAMS{$teamIDX}{IN_LATE}>0){
                $str .= sprintf '<td style="text-align: right; padding: 1px;" class="w3-text-red">-%2.1f</td>', $TEAMS{$teamIDX}{IN_LATE};
            } else {
                $str .= '<td style="text-align: right; padding: 1px;" class="w3-text-red">-</td>';
            }
            
            $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>', $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $TEAMS{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $TEAMS{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s3 w3-small">Late Pen.</div>';
        $str .= sprintf '<div class="w3-col s9 w3-text-red w3-small" style="text-align: right;">-%2.1f</div>', $TEAMS{$teamIDX}{IN_LATE};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Score</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $TEAMS{$teamIDX}{IN_OVERALL};
        $str .= '</div>'; 
        
        
        # $str .= sprintf '<b>Rank: </b><span class="w3-large">%2.0f</span><br>', $rank;
        # $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txNumber ;
        # $str .= sprintf '<span class="w3-text-black">%s</span><br>', $txName;
        # $str .= sprintf '<b>Country: </b><span class="w3-text-black">%s</span><br>', $TEAMS{$teamIDX}{TX_COUNTRY};
        # if ($boScore==1){
        #     if ($TEAMS{$teamIDX}{IN_LATE}>0){
        #         $str .= sprintf '<b>Penalties</b>: <span class="w3-text-red w3-large">-%2.1f pts</span><br>', $TEAMS{$teamIDX}{IN_LATE} ;
        #     } else {
        #         $str .= '<b>ERC Penalties</b>: <span class="w3-text-black">-none-</span><br>';
        #     }
            
        #     $str .= sprintf '<b>Score</b>: <span class="w3-text-black w3-large">%2.4f pts</span><br>', $TEAMS{$teamIDX}{IN_OVERALL} ;
        # }
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
    $str .= '<table class="w3-table-all">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px; padding: 1px;">Order</th>';
    $str .= '<th style=" padding: 1px;">School</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right; padding: 1px;">Country</th>';
    if ($boScore==1){
        $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Score</th>';
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
        $str .= sprintf '<td style=" padding: 1px;">%2.0f</td>', $rank;
        $str .= sprintf '<td style=" padding: 1px;">%2s</td>', $txSchool;
        # $str .= sprintf '<td>%2s</td>', $TEAMS{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right; padding: 1px; padding: 1px;">%2s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
        if ($boScore==1){
            $str .= sprintf '<td style="text-align: right; padding: 1px; padding: 1px;">%2.4f</td>', $TEAMS{$teamIDX}{IN_OVERALL};
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $TEAMS{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $TEAMS{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Score</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $TEAMS{$teamIDX}{IN_OVERALL};
        $str .= '</div>'; 

        $str .= '</td>';
        $str .= '</tr>';

    }
    $str .= '</table>';
    return ($str);
}
sub calculateMicroClassFlights(){
    my ($inRound, $eventIDX) = @_;
    my $Micro = new SAE::MICRO($eventIDX);
    my %TEAM = %{$Micro->_getMicroTeamList()};
    foreach $teamIDX (sort keys %TEAM) {
        $TEAM{$teamIDX}{IN_OVERALL} = $Micro->_getTeamFinalScore($teamIDX, $inRound);
    }
    return (\%TEAM);
}
sub calculateAdvancedClassFlights(){
    my ($inRound, $eventIDX) = @_;
    my $Advanced = new SAE::ADVANCED($eventIDX);
    my %TEAM = %{$Advanced->_getTeamList()};
    foreach $teamIDX (sort keys %TEAM) {
        my %FINAL = %{$Advanced->_getTeamFinalScore($teamIDX, $inRound)};
        $TEAM{$teamIDX}{IN_DAYS} = $FINAL{$teamIDX}{IN_DAYS};
        $TEAM{$teamIDX}{IN_OVERALL} = $FINAL{$teamIDX}{IN_FFS};
    }
    return (\%TEAM);
}
sub calculateRegularClassFlights(){
    my ($inRound, $eventIDX) = @_;
        my $Regular = new SAE::REGULAR($eventIDX);
    my %TEAM = %{$Regular->_getTeamList()};
    foreach $teamIDX (sort keys %TEAM) {
        # $TEAM{$teamIDX}{IN_FFS} = $Micro->_getTeamFinalScore($teamIDX, $inRound);
        my ($ffs, $bonus) = $Regular->_getTeamFinalScore($teamIDX, $inRound);
        $TEAM{$teamIDX}{IN_OVERALL} = $ffs + $bonus;
        $TEAM{$teamIDX}{IN_RAW} = $ffs;
        $TEAM{$teamIDX}{IN_PPB} = $bonus;
        $Regular->_getTeamFinalScore($teamIDX,$inRound);
    }
    return (\%TEAM);
}
sub _displayOverallResults(){
    my $txTitle = shift;
    my $location = shift;
    my $classIDX = shift;
    my $boScore = shift;
    my $inRound = shift;
    my $Score = new SAE::SCORE();
    
    my $Advanced = new SAE::ADVANCED($location);
    my $Micro = new SAE::MICRO($location);
    my %TEAMS;
    my %FLIGHT;
    %DESIGN = %{$Score->_getOverallDesignResults($location, $classIDX )};
    %PRESO = %{$Score->_getOverallPresoResults($location, $classIDX )};
    %PEN = %{$Score->_getPenaltyListByEvent($location)};
    if ($classIDX==3){
        %FLIGHT = %{&calculateMicroClassFlights($inRound, $location)};
    } elsif ($classIDX==2) {
        %FLIGHT = %{&calculateAdvancedClassFlights($inRound, $location)};
    } else {
        %FLIGHT = %{&calculateRegularClassFlights($inRound, $location)};
    }
    foreach $teamIDX (sort keys %DESIGN){
        my $inDesign = sprintf "%2.4f", $DESIGN{$teamIDX}{IN_OVERALL};
        my $inPreso  = sprintf "%2.4f",  $PRESO{$teamIDX}{IN_OVERALL};
        my $inFlight = sprintf "%2.4f", $FLIGHT{$teamIDX}{IN_OVERALL};
        my $inPen    = sprintf "%2.4f",    $PEN{$teamIDX}{IN_TOTAL};
        # $final = $DESIGN{$teamIDX}{IN_OVERALL} + $PRESO{$teamIDX}{IN_OVERALL} + $FLIGHT{$teamIDX}{IN_OVERALL} - $PEN{$teamIDX}{IN_TOTAL};
        my $final = $inDesign + $inPreso - $inPen +  $inFlight;
        $DESIGN{$teamIDX}{IN_FINAL} = $final;
    }
    %CLASS= (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str;
    # $str .= $inRound;
    # $str .= "$location, $classIDX";
    $str .= sprintf '<center><h1>%s: Outstanding Technical Design Report</h1></center>', $CLASS{$classIDX};
    $str .= '<table class="w3-table-all">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px; padding: 1px;">Rank</th>'; 
    $str .= '<th style="padding: 1px;">Team</th>';
    $str .= '<th style="text-align: right; padding: 1px;">Country</th>';
    $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Late<br>Penalty</th>';
    $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Design<br>Score</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $newClass="";
    # foreach $teamIDX (sort {$DESIGN{$b}{IN_FINAL} <=> $DESIGN{$a}{IN_FINAL}} keys %DESIGN) {
    foreach $teamIDX (sort {$DESIGN{$b}{IN_OVERALL} <=> $DESIGN{$a}{IN_OVERALL}} keys %DESIGN) {
        my $txSchool = sprintf '%03d - %s', $DESIGN{$teamIDX}{IN_NUMBER}, $DESIGN{$teamIDX}{TX_SCHOOL};
        if ($score != $DESIGN{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $DESIGN{$teamIDX}{IN_OVERALL};
        }
        if ($rank>3 || $rank==0){$newClass="w3-design w3-hide"}
        if ($DESIGN{$teamIDX}{IN_LATE}>50){
            $DESIGN{$teamIDX}{IN_LATE} = 50;
        }
        $str .= sprintf '<tr class="%s w3-hide-small">', $newClass;  
        $str .= sprintf '<td style="text-align: left; padding: 1px;">%d</td>', $rank;
        $str .= sprintf '<td style="text-align: left; padding: 1px;">%s (<i>%s</i>)</td>',$txSchool, $DESIGN{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%s</td>',$DESIGN{$teamIDX}{TX_COUNTRY};
        if ($DESIGN{$teamIDX}{IN_LATE}>0){
            $str .= sprintf '<td class="w3-text-red" style="text-align: right; padding: 1px;">-%2.1f</td>',$DESIGN{$teamIDX}{IN_LATE};
        } else {
            $str .= sprintf '<td class="w3-text-red" style="text-align: right; padding: 1px;">---</td>';
        }
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>',$DESIGN{$teamIDX}{IN_OVERALL};

        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $DESIGN{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s3 w3-small">Late Pen.</div>';
        if ($DESIGN{$teamIDX}{IN_LATE}>0){
            $str .= sprintf '<div class="w3-col s9 w3-text-red w3-small" style="text-align: right;">-%2.1f</div>', $DESIGN{$teamIDX}{IN_LATE};
        } else {
            $str .= sprintf '<div class="w3-col s9 w3-text-red w3-small" style="text-align: right;">--</div>', $DESIGN{$teamIDX}{IN_LATE};
        }
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Score</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $DESIGN{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    
    $str .= sprintf '<a class="w3-hide-small" href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-design' ;
    $str .= '<hr style="page-break-before: always;">';
    
    $str .= sprintf '<center><h1>%s: Outstanding Technical Presentation</h1></center>', $CLASS{$classIDX};
    $str .= '<table class="w3-table-all">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px; padding: 1px;">Rank</th>';
    $str .= '<th style=" padding: 1px;">Team</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right; padding: 1px;">Country</th>';
    $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Presentation<br>Score</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $presoClass="";
    foreach $teamIDX (sort {$PRESO{$b}{IN_OVERALL} <=> $PRESO{$a}{IN_OVERALL}} keys %PRESO) {
        my $txSchool = sprintf '%03d - %s', $DESIGN{$teamIDX}{IN_NUMBER}, $DESIGN{$teamIDX}{TX_SCHOOL};
        if ($score != $PRESO{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $PRESO{$teamIDX}{IN_OVERALL};
        }
        if ($rank>3 || $rank==0){$presoClass="w3-preso w3-hide"}
        $str .= sprintf '<tr class="%s w3-hide-small">', $presoClass;    
        $str .= sprintf '<td style="text-align: left; padding: 1px;">%d</td>', $rank;
        $str .= sprintf '<td style="text-align: left; padding: 1px;">%s (<i>%s</i>)</td>',$txSchool , $DESIGN{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%s</td>',$DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>',$PRESO{$teamIDX}{IN_OVERALL};
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $DESIGN{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Score</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $PRESO{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= sprintf '<a class="w3-hide-small" href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-preso' ;
    $str .= '<hr style="page-break-before: always;">';
    
    $str .= sprintf '<center><h1>%s: %d Rounds of Outstanding Mission Performance</h1></center>', $CLASS{$classIDX}, $inRound;
    $str .= '<table class="w3-table-all">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px; padding: 1px;">Rank</th>';
    $str .= '<th style=" padding: 1px;">Team</th>';
    # $str .= '<th>Name</th>';
    $str .= '<th style="text-align: right; padding: 1px;">Country</th>';
    $str .= '<th style="width: 100px; text-align: right; padding: 1px;">Performance<br>Score</th>';
    $str .= '</tr>';
    my $rank = 0;
    my $score = 0;
    my $flightClass="";
    foreach $teamIDX (sort {$FLIGHT{$b}{IN_OVERALL} <=> $FLIGHT{$a}{IN_OVERALL}} keys %FLIGHT) {
        my $txSchool = sprintf '%03d - %s', $DESIGN{$teamIDX}{IN_NUMBER}, $DESIGN{$teamIDX}{TX_SCHOOL};
        if ($score != $FLIGHT{$teamIDX}{IN_OVERALL}){
            $rank++;
            $score = $FLIGHT{$teamIDX}{IN_OVERALL};
        }
        if ($rank>3 || $rank==0){$flightClass="w3-flight w3-hide"}
        # $str .= '<tr>';  
        $str .= sprintf '<tr class="%s w3-hide-small">', $flightClass;   
        if ($FLIGHT{$teamIDX}{IN_OVERALL}==0){
            $str .= sprintf '<td style="text-align: left; padding: 1px;">--</td>', $rank;
        } else {
            $str .= sprintf '<td style="text-align: left; padding: 1px;">%d</td>', $rank;
        }
        
        $str .= sprintf '<td style="text-align: left; padding: 1px;">%s (<i>%s</i>)</td>',$txSchool, $FLIGHT{$teamIDX}{TX_NAME};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%s</td>',$FLIGHT{$teamIDX}{TX_COUNTRY};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>',$FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr  class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $DESIGN{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Score</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        
        # $str .= sprintf '<div>Rank: <span class="w3-text-blue">%s</span></div>', $rank;
        # $str .= sprintf '<div>Team: <span class="w3-text-blue">%s</span></div>', $txSchool;
        # $str .= sprintf '<div>Country: <span class="w3-text-blue">%s</span></div>', $FLIGHT{$teamIDX}{TX_COUNTRY};
        # $str .= sprintf '<div>Score: <span class="w3-text-blue">%2.4f</span> pts</div>', $FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= sprintf '<a class="w3-hide-small" href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-flight' ;
    $str .= '<hr style="page-break-before: always;">';
    $str .= '<center><h1>'.$txTitle.'</h1>';
    $str .= '<h3>'.$CLASS{$classIDX}.': Last Round '.$inRound.'</h3>';
    $str .= '</center>';
    $str .= '<table class="w3-table-all">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 75px; padding: 1px;">Rank</th>';
    $str .= '<th style=" padding: 1px;">School</th>';
    $str .= '<th style="text-align: right; width: 85px; padding: 1px;">Country</th>';
    # $str .= '<th style="text-align: right; width: 85px;">Late<br>Report<br>Penalty</th>';
    $str .= '<th style="text-align: right; width: 85px; padding: 1px;">Design<br>Scores</th>';
    $str .= '<th style="text-align: right; width: 85px; padding: 1px;">Presentation<br>Scores</th>';
    $str .= '<th style="text-align: right; width: 85px; padding: 1px;">Flight<br>Scores</th>';
    $str .= '<th style="text-align: right; width: 85px; padding: 1px;">ECR<br>Penalties</th>';
    $str .= '<th style="text-align: right; width: 85px; padding: 1px;">Overall<br>After<br>Round '.$inRound.'</th>';
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
        $str .= sprintf '<td style=" padding: 1px;">%2.0f</td>', $rank;
        $str .= sprintf '<td style=" padding: 1px;">%2s</td>', $txSchool;
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2s</td>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>', $DESIGN{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>', $PRESO{$teamIDX}{IN_OVERALL};
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>', $FLIGHT{$teamIDX}{IN_OVERALL};
        if ($PEN{$teamIDX}{IN_TOTAL}>0){
            $str .= sprintf '<td class="w3-text-red" style="text-align: right; padding: 1px;">-%2.1f</td>', $PEN{$teamIDX}{IN_TOTAL};
        } else {
            $str .= '<td class="w3-text-red" style="text-align: right; padding: 1px;">---</td>';
        }
        $str .= sprintf '<td style="text-align: right; padding: 1px;">%2.4f</td>', $DESIGN{$teamIDX}{IN_FINAL};
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Rank</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $rank;
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Team #</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%03d</div>', $DESIGN{$teamIDX}{IN_NUMBER};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">School</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s2 w3-small">Country</div>';
        $str .= sprintf '<div class="w3-col s10 w3-text-blue w3-small" style="text-align: right;">%s</div>', $DESIGN{$teamIDX}{TX_COUNTRY};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s4 w3-small">Design Score</div>';
        $str .= sprintf '<div class="w3-col s8 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $DESIGN{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s4 w3-small">Presentation Score</div>';
        $str .= sprintf '<div class="w3-col s8 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $PRESO{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s4 w3-small">Flight Score</div>';
        $str .= sprintf '<div class="w3-col s8 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $FLIGHT{$teamIDX}{IN_OVERALL};
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s4 w3-small">Penalties</div>';
        if ($PEN{$teamIDX}{IN_TOTAL}>0){
            $str .= sprintf '<div class="w3-col s8 w3-text-red w3-small" style="text-align: right;">-%2.4f</div>', $inPen;
        } else {
            $str .= sprintf '<div class="w3-col s8 w3-text-red w3-small" style="text-align: right;">--</div>', $inPen;
        }
        $
        $str .= '</div>';
        
        $str .= '<div class="w3-row">';
        $str .= '<div class="w3-col s4 w3-small">Overall SCore</div>';
        $str .= sprintf '<div class="w3-col s8 w3-text-blue w3-small" style="text-align: right;">%2.4f</div>', $DESIGN{$teamIDX}{IN_FINAL};
        $str .= '</div>';
        
        $str .= '</td>';    
        $str .= '</tr>';
    }
    my $rank = 0;
    my $score = 0;
    $str .= '</table>';
    $str .= sprintf '<a class="w3-hide-small" href="javascript:void(0);" onclick="sae_toggleView(\'%s\');">Expand/Collapse</a>', 'w3-overall' ;
    $str .= '<hr style="page-break-before: always;">';
    return ($str);
}