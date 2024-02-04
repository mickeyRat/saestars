#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use Cwd 'abs_path';
use SAE::PUBLISH;
use SAE::MICRO;
use SAE::REGULAR;
use SAE::ADVANCED;
use SAE::SCORE;
use SAE::ECR;
use SAE::AWARD;
use SAE::REG_SCORE;
use SAE::ADV_SCORE;
use SAE::MIC_SCORE;
use SAE::DESIGN;
use SAE::PRESO;
use SAE::TECH;



$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;
my %CLASS = (1=>'Regular', 2=>'Advanced', 3=>'Micro');

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
# ===================== 2024 ===================================================
# Templates
sub publish_tableTemplate (){
    my ($classIDX, $txFile , $txDate , $txName, $inType, $list) = @_;
    my %LIST = %{$list};
    my $eventIDX= $q->param('eventIDX');
    my $txRadioName = sprintf "Radio_%d", $classIDX;
    my $str;
    $str = sprintf '<table ID="TABLE_%d" class="w3-table-all w3-round">', $classIDX;
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 100px;">Public</th>';
        # $str .= '<th style="width: 100px;">Include</th>';
        $str .= '<th style="width: 100px;">UID</th>';
        $str .= '<th >Generated Time</th>';
        $str .= '<th style="width: 75px;">View</th>';
        $str .= '<th style="width: 75px;">Delete</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $publishIDX (sort {$a <=> $b} keys %{$LIST{$classIDX}}) {
            my $txFile = $LIST{$classIDX}{$publishIDX}{TX_FILE};
            my $txDate = $LIST{$classIDX}{$publishIDX}{TX_TIME};
            my $txName = $LIST{$classIDX}{$publishIDX}{TX_PUBLISH_BY};
            my $inShow = $LIST{$classIDX}{$publishIDX}{IN_SHOW};
            $str .= &publish_row($publishIDX, $txFile , $txDate , $txName, $txRadioName, $inShow);
        }
        $str .= '</tbody>';
        $str .= '<tr>';
        $str .= '<td colspan="5">';
        if ($inType == 1) { #Load Design Results
                $str .= sprintf '<button class="w3-button w3-border w3-round w3-green" onclick="publish_GenerateDesignReport(this, %d);">Generate</button>', $classIDX;
            } elsif ($inType == 2 ) {  #Load Presentation Results
                $str .= sprintf '<button class="w3-button w3-border w3-round w3-green" onclick="publish_GeneratePresenationResults(this, %d);">Generate</button>', $classIDX;
            } elsif ($inType == 3 ) {
                $str .= sprintf '<button class="w3-button w3-border w3-round w3-green" onclick="publish_GenerateMissionResults(this, %d);">Generate</button>', $classIDX;
            } elsif ($inType == 4) {
                $str .= sprintf '<button class="w3-button w3-border w3-round w3-green" onclick="publish_GenerateOverallResults(this, %d);">Generate</button>', $classIDX;
            }
        $str .= sprintf '<span class="w3-margin-left genLoading_%d" style="display: none;"><img src="../images/loader.gif"> Generating</span>', $classIDX;
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '</table>';
    return ($str);
    }
# Design ===============================================================================
sub publish_deleteResults(){
    print $q->header();
    my $publishIDX = $q->param('publishIDX');
    my $Pub = new SAE::PUBLISH();
    $Pub->_deletePublishedScore($publishIDX);
    }
sub publish_row() {
    my ($newIDX, $txFile, $now_string, $userName, $txRadioName, $inShow) = @_;
    my $checked = '';
    if ($inShow==1) {$checked = 'checked'}
    $str = '<tr>';
    $str .= sprintf '<td><input class="w3-check" type="checkbox" %s onclick="publish_activatePublicView(this, %d);"></td>', $checked, $newIDX;
    # $str .= sprintf '<td><input class="w3-radio" type="radio" NAME="%s"></td>', $txRadioName;
    $str .= sprintf '<td>v.%d</td>', $newIDX;
    $str .= sprintf '<td><span class="w3-small">Generated on: </span> <span class="w3-text-grey">%s</span> by <b>%s</b></td>', $now_string, $userName;
    $str .= sprintf '<td><a href="post.html?fileID=%s" target="_blank">View</a></td>', $txFile;
    $str .= sprintf '<td><a href="javascript:void(0);" onclick="publish_deleteResults(this, %d);">Delete</a></td>', $newIDX;
    $str .= '</tr>';
    }
sub publish_GenerateDesignReport (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $txTitle    = 'Design Results';
    my $userIDX    = $q->param('userIDX');
    my $Publish    = new SAE::PUBLISH();
    my ($newIDX, $txFile, $now_string, $userName) = $Publish->_generateResults($eventIDX, $classIDX, $txTitle, $userIDX, 1);
    my $txRadioName = sprintf "Radio_%d", $classIDX;
    # $Publish->_generateDesignScores($eventIDX, $newIDX, $classIDX);
    # 1. generate random number and get publish ID
    # 2. calculcate design score and populate TB_SCORE
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    # $str .= "***************** $eventIDX, $newIDX, $classIDX";
    $str .= &publish_row($newIDX, $txFile, $now_string, $userName, $txRadioName, 0);
    return ($str);
    }
sub publish_showDesign (){
    my $eventIDX = $q->param('eventIDX');
    # my $classIDX = $q->param('classIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Publish = new SAE::PUBLISH();
    my %LIST    = %{$Publish->_getPublishedList($eventIDX, 1)}; # 1 = Design
    my $str;
    foreach $classIDX (sort {$a<=>$b} keys %CLASS) {
        $str .= sprintf '<h3>%s Class Design Results</h3>', $CLASS{$classIDX};
        $str .= &publish_tableTemplate($classIDX, $txFile , $txDate , $txName, 1, \%LIST);
    }
    return ($str);
    }
#  Presentations ===============================================================================
sub publish_GeneratePresenationResults (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $txTitle    = 'Presentation Results';
    my $userIDX    = $q->param('userIDX');
    my $Publish    = new SAE::PUBLISH();
    my ($newIDX, $txFile, $now_string, $userName) = $Publish->_generateResults($eventIDX, $classIDX, $txTitle, $userIDX, 2);
    my $txRadioName = sprintf "Radio_%d", $classIDX;
    # $Publish->_generateDesignScores($eventIDX, $newIDX, $classIDX);
    # 1. generate random number and get publish ID
    # 2. calculcate design score and populate TB_SCORE
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= &publish_row($newIDX, $txFile, $now_string, $userName, $txRadioName, 0);
    return ($str);
    }
sub publish_showPresentation (){
    my $eventIDX= $q->param('eventIDX');
    print $q->header();
    my $Publish = new SAE::PUBLISH();
    my %LIST    = %{$Publish->_getPublishedList($eventIDX, 2)}; # 2 = Presentation
    my $str;
    foreach $classIDX (sort {$a<=>$b} keys %CLASS) {
        $str .= sprintf '<h3>%s Class Presentation Results</h3>', $CLASS{$classIDX};
        $str .= &publish_tableTemplate($classIDX, $txFile , $txDate , $txName, 2, \%LIST);
    }
    return ($str);
    }
# Mission ===============================================================================
sub publish_GenerateMissionResults (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $txTitle    = 'Mission Results';
    my $userIDX    = $q->param('userIDX');
    my $Publish    = new SAE::PUBLISH();
    my ($newIDX, $txFile, $now_string, $userName) = $Publish->_generateResults($eventIDX, $classIDX, $txTitle, $userIDX, 3);
    my $txRadioName = sprintf "Radio_%d", $classIDX;
    # $Publish->_generateDesignScores($eventIDX, $newIDX, $classIDX);
    # 1. generate random number and get publish ID
    # 2. calculcate design score and populate TB_SCORE
    my $str;
    $str .= &publish_row($newIDX, $txFile, $now_string, $userName, $txRadioName, 0);
    return ($str);
    }
sub publish_showMission (){
    my $eventIDX= $q->param('eventIDX');
    print $q->header();
    my $Publish = new SAE::PUBLISH();
    my %LIST    = %{$Publish->_getPublishedList($eventIDX, 3)}; # 3 = Mission Performance
    my $str;
    foreach $classIDX (sort {$a<=>$b} keys %CLASS) {
        $str .= sprintf '<h3>%s Class Mission Performance Results</h3>', $CLASS{$classIDX};
        $str .= &publish_tableTemplate($classIDX, $txFile , $txDate , $txName, 3, \%LIST);
    }
    return ($str);
    }
# Overall ===============================================================================
sub publish_GenerateOverallResults {
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $txTitle    = 'Overall Results';
    my $userIDX    = $q->param('userIDX');
    my $Publish    = new SAE::PUBLISH();
    my ($newIDX, $txFile, $now_string, $userName) = $Publish->_generateResults($eventIDX, $classIDX, $txTitle, $userIDX, 4);
    my $txRadioName = sprintf "Radio_%d", $classIDX;
    # $Publish->_generateDesignScores($eventIDX, $newIDX, $classIDX);
    # 1. generate random number and get publish ID
    # 2. calculcate design score and populate TB_SCORE
    my $str;
    $str .= &publish_row($newIDX, $txFile, $now_string, $userName, $txRadioName, 0);
    return ($str);
}
sub publish_showOverall (){
    my $eventIDX= $q->param('eventIDX');
    print $q->header();
    my $Publish = new SAE::PUBLISH();
    my %LIST    = %{$Publish->_getPublishedList($eventIDX, 4)}; # 4 = Mission Performance
    my $str;
    foreach $classIDX (sort {$a<=>$b} keys %CLASS) {
        $str .= sprintf '<h3>%s Class Overall Results</h3>', $CLASS{$classIDX};
        $str .= &publish_tableTemplate($classIDX, $txFile , $txDate , $txName, 4, \%LIST);
    }
    return ($str);
    }
# Superlatives ===============================================================================
sub publish_showSuperlative (){
    my $eventIDX= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str .= '<h3>Superlative Awards</h3>';
    return ($str);
    }

sub publish_Home (){
    my $eventIDX= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str .= '<div class="w3-container">';
    $str .= '<br><h3 class="w3-margin-top">Publish Results</h3>';
    $str .= '<div class="w3-bar w3-black">';
    $str .= '<button class="w3-bar-item w3-button tablink w3-red" onclick="publish_showDesign(this);">Design Awards</button>';
    $str .= '<button class="w3-bar-item w3-button tablink" onclick="publish_showPresentation(this);">Presentation Awards</button>';
    $str .= '<button class="w3-bar-item w3-button tablink" onclick="publish_showMission(this);">Mission Performance</button>';
    $str .= '<button class="w3-bar-item w3-button tablink" onclick="publish_showOverall(this);">Overall Performance</button>';
    $str .= '<button class="w3-bar-item w3-button tablink" onclick="publish_showSuperlative(this);">Superlatives</button>';
    $str .= '</div>';
    $str .= '<div ID="publish_content" class="w3-container"></div>';
    $str .= '</div>';


    # $str .= &showPublishPage();
    return ($str);
    }
sub publish_activatePublicView(){
    print $q->header();
    my $publishIDX = $q->param('publishIDX');
    my $checked    = $q->param('checked');
    my $Pub        = new SAE::PUBLISH();
    $Pub->_activatePublicView($publishIDX, $checked);
    return();
    }
# ===================== 2024 ===================================================





# ===================== 2022 ===================================================
# sub sae_includeInFinalScore(){
#     print $q->header();
#     my $publishIDX = $q->param('publishIDX');
#     my $checked = $q->param('checked');
#     my $Pub = new SAE::PUBLISH();
#     $Pub->_activateIncludeView($publishIDX, $checked);
#     }

# sub sae_deletePublishScore(){
#     print $q->header();
#     my $publishIDX = $q->param('publishIDX');
#     my $Pub = new SAE::PUBLISH();
#     $Pub->_deletePublishedScore($publishIDX);
#     }
# sub sae_generateResultScores(){
#     print $q->header();
#     my $classIDX = $q->param('classIDX');
#     my $txTitle = $q->param('txTitle');
#     my $eventIDX = $q->param('eventIDX');
#     my $userIDX = $q->param('userIDX');
#     my $headerName = "view".$txTitle;
#     $headerName =~ s/\s+//gi;
#     my $Pub = new SAE::PUBLISH();
#     my ($publishIDX, $txFileName, $txTime, $userName) = $Pub->_generateResults($eventIDX,$classIDX,$txTitle, $userIDX);
#     my $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txTitle);
#     &{$headerName}($eventIDX, $classIDX, $publishIDX);
#     return ($links);
#     }
# sub sae_generateSuperlativeScores(){
#     print $q->header();
#     my $classIDX = $q->param('classIDX');
#     my $awardIDX = $q->param('awardIDX');
#     my $eventIDX = $q->param('eventIDX');
#     my $userIDX = $q->param('userIDX');

#     my $Pub = new SAE::PUBLISH();
#     my $Award = new SAE::AWARD();
#     # my %AWARD = %{$Award->_getAwardData()};
#     my $txTitle =$Award->_getAwardTitle($awardIDX);
#     my $links;
#     my ($publishIDX, $txFileName, $txTime, $userName) = $Pub->_generateResults($eventIDX,$classIDX,$txTitle, $userIDX);
#     $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txTitle);
#     if ($awardIDX == 1 || $awardIDX == 5 || $awardIDX == 8){
#         &viewMostPayload($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 2) {
#         &viewBestPayloadRatio($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 3) {
#         &viewMostBall($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 4) {
#         &viewHeaviestPayload($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 6) {
#         &viewMostPadaInZone($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 7) {
#         &viewClosestToTargetCenter($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 9) {
#         &viewMostEffectiveVolumeDelivered($eventIDX, $classIDX, $publishIDX);
#     } elsif ($awardIDX == 10) {
#         &viewFastestTimeToTurn($eventIDX, $classIDX, $publishIDX);
#     }
#     return ($links);
#     }
# sub viewFastestTimeToTurn(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::MICRO($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_generateviewFastestTimeToTurn($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewMostEffectiveVolumeDelivered(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::MICRO($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_generateMostEffectiveVolumeDelivered($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewClosestToTargetCenter(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::ADVANCED($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_generateClosestToTargetCenter($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewMostPadaInZone(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::ADVANCED($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_generatePadaInZone($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewHeaviestPayload(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::REGULAR($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_getHeaviestPayloadFlown($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewMostBall(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::REGULAR($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_getMostBallFlown($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewBestPayloadRatio(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     $Obj = new SAE::REGULAR($eventIDX);
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_getBestPayloadRatio($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewMostPayload(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     if ($classIDX==3) {
#         $Obj = new SAE::MICRO($eventIDX);
#     } elsif ($classIDX==2) {
#         $Obj = new SAE::ADVANCED($eventIDX);
#     } else {
#         $Obj = new SAE::REGULAR($eventIDX);
#     }
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_getMostPayload($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewDesignReport(){ # Name of the method is derived from the label of the section head in the publish.pl file
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     if ($classIDX==3) {
#         $Obj = new SAE::MICRO($eventIDX);
#     } elsif ($classIDX==2) {
#         $Obj = new SAE::ADVANCED($eventIDX);
#     } else {
#         $Obj = new SAE::REGULAR($eventIDX);
#     }
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
    
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_designScores($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewPresentationScores(){ # Name of the method is derived from the label of the section head in the publish.pl file
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Obj;
#     if ($classIDX==3) {
#         $Obj = new SAE::MICRO($eventIDX);
#     } elsif ($classIDX==2) {
#         $Obj = new SAE::ADVANCED($eventIDX);
#     } else {
#         $Obj = new SAE::REGULAR($eventIDX);
#     }
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAMS){
#         $Score->_presoScores($eventIDX, $classIDX, $teamIDX, $publishIDX);
#     }
#     return ($str);
#     }
# sub viewMissionPerformanceScores(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     if ($classIDX==3){
#         $str = &assembleMicroClass($eventIDX, $classIDX, $publishIDX);
#     } elsif ($classIDX==2) {
#          $str = &assembleAdvancedClass($eventIDX, $classIDX, $publishIDX);
#     } else {
#         $str = &assembleRegularClass($eventIDX, $classIDX, $publishIDX);
#     }
#     }
# sub assembleRegularClass(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Reg = new SAE::REG_SCORE();
#     my %TEAM = %{$Reg->_getTeamList($eventIDX)};
#     foreach $teamIDX (sort keys %TEAM) {
#         my $Score = $Reg->_getScore($teamIDX);
#         $Reg->_savePerformanceScores($publishIDX, $teamIDX, $Score);
#     }

#     return ($str);
# }
# sub assembleAdvancedClass(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Adv = new SAE::ADV_SCORE();
#     my %TEAM = %{$Adv->_getTeamList($eventIDX)};
#     foreach $teamIDX (sort keys %TEAM) {
#         my $flightScore    = $Adv->_getScore($teamIDX);
#         my $gtvScore       = $Adv->_getGtvScore($teamIDX);
#         my $Score          = $flightScore + $gtvScore;
#         $Adv->_savePerformanceScores($publishIDX, $teamIDX, $flightScore, $gtvScore, $Score);
#     }
# }
# sub assembleMicroClass(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Mic = new SAE::MIC_SCORE();
#     my %TEAM = %{$Mic->_getTeamList($eventIDX)};
#     foreach $teamIDX (sort keys %TEAM) {
#         my $Score = $Mic->_getScore($teamIDX);
#         $Mic->_savePerformanceScores($publishIDX, $teamIDX, $Score);
#     }
#     return ($str);
# }
# sub viewOverallPerformance (){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
#     my $Design  = new SAE::DESIGN();
#     my $Preso   = new SAE::PRESO();
#     my $Tech    = new SAE::TECH();
#     my $Obj;
#     if ($classIDX==3) {
#         $Obj = new SAE::MIC_SCORE();
#     } elsif ($classIDX==2) {
#         $Obj = new SAE::ADV_SCORE();
#     } else {
#         $Obj = new SAE::REG_SCORE();
#     }
#     my %TEAMS = %{$Obj->_getTeamList($eventIDX)};
#     foreach $teamIDX (keys %TEAMS) {
#         my ( $raw, $late ) = $Design->_getOverallPaperByTeam($teamIDX);
#         my $DesginScore    = ($raw - $late);
#         my $PresoScore     = $Preso->_getPresoScoreByTeam($teamIDX, 5);
#         my $PenaltyScore   = $Tech->_getTechPenalties($teamIDX);
#         my $MissionScore   = $Obj->_getScore($teamIDX);
#         my $inOverall      = $DesginScore + $PresoScore + $MissionScore - $PenaltyScore;
#         $Obj->_saveOverallScores($publishIDX, $teamIDX, $DesginScore, $PresoScore, $MissionScore, $PenaltyScore, $inOverall );
#     }
#     return ();
#     }
# sub viewOverallPerformance_OBE(){
#     my ($eventIDX, $classIDX, $publishIDX) = @_;
    
#     my $Obj;
#     if ($classIDX==3) {
#         $Obj = new SAE::MICRO($eventIDX);
#     } elsif ($classIDX==2) {
#         $Obj = new SAE::ADVANCED($eventIDX);
#     } else {
#         $Obj = new SAE::REGULAR($eventIDX);
#     }
#     my $Score = new SAE::SCORE();
#     my %TEAMS = %{$Obj->_getTeamList()};
#     my $Ecr = new SAE::ECR();
#     foreach $teamIDX (keys %TEAMS) {
#         my $inPenalty  = 0;
#         my ($late, $designScore, $sorted) = $Score->_designScores($eventIDX, $classIDX, $teamIDX, $publishIDX);
#             $TEAMS{$teamIDX}{IN_DESIGN}   = $designScore;
#         my ($presoScore)                  = $Score->_presoScores($eventIDX, $classIDX, $teamIDX, $publishIDX);
#             $TEAMS{$teamIDX}{IN_PRESO}    = $presoScore;
#         my $flightScore = 0;
#         if ($classIDX==3) {
#             my ($TOPS, $FLIGHTS) = $Obj->_calcTeamScore($teamIDX);
#             my %SCORE = %{$FLIGHTS};
#             my @SORTED = @$TOPS;
#             $flightScore = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS};
#         } elsif ($classIDX==2) {
#             my ($inStd, $boAuto, $inWater, $waterFlown, $SCORES) = $Obj->_calcTeamScore($teamIDX);
#             my %SCORE = %{$SCORES};
#             my $gtvMultiplier = 2.0;
#             if ($boAuto<1) {$gtvMultiplier = 1.5}
#             my $waterScore = ($waterFlown + $gtvMultiplier*$inWater)/4;
#             my $SUM_PADA = 0;
#             foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
#                 my $subScore = ($SCORE{$flightIDX}{APADA} + $SCORE{$flightIDX}{BPADA});
#                 my $totalAttemptScore = $subScore - ($SCORE{$flightIDX}{IN_MINOR} * $subScore) - ($SCORE{$flightIDX}{IN_MAJOR} * $subScore);
#                    $SUM_PADA += $totalAttemptScore;
#             }
#             $flightScore = ($waterScore + (4*$SUM_PADA));

#         } else {
#             my ($maxPPB, $TOPS, $SCORES) = $Obj->_calcTeamScore($teamIDX);
#             my %SCORE = %{$SCORES};
#             my @SORTED = @$TOPS;
#             $flightScore = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS} + $maxPPB;

#         }

#         if ($Ecr->_getTotalPenalty($teamIDX)){$inPenalty      = $Ecr->_getTotalPenalty($teamIDX);}
#         my $inOverall      = $designScore + $presoScore + $flightScore - $inPenalty;
        
#         $Score->_saveOverallScores($publishIDX, $teamIDX, $designScore, $presoScore, $flightScore, $inPenalty, $inOverall );
#     }
#     return ($str);
# }
# sub showPublishPage(){
#     print $q->header();
#     my $Pub = new SAE::PUBLISH();
#     my $eventIDX = $q->param('location');
#     my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
#     my $str = '<br>';
#     $str .= '<div class="w3-container w3-margin-top">';
#     $str .= sprintf '<h3>Publish Results <span class="w3-margin-left w3-margin-right w3-small"><a href="post.html?vid=1" target="_blank">( View Final Award Presentation Order )</a></span></h3>';
#     $str .= '<table class="w3-table w3-bordered w3-white">';

#     $str .= '<tr>';
#     $str .= '<th style="width: 20%;">Class</th>';
#     $str .= '<th style="width: 20%;">Generate</th>';
#     $str .= '<th style="width: 60%;">Link</th>';
#     $str .= '</tr>'; 
#     $str .= '<tr>';
#     $str .= '<th colspan="3" class="w3-xlarge w3-blue-grey">DESIGN REPORTS SCORES</th>';
#     $str .= '</tr>';
#     foreach $classIDX (sort {$a <=> $b} keys %CLASS ) {
#         my $txTitle = 'Design Report';
#         my $txCell = 'DESIGN';
#         my $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txTitle);
#         $str .= '<tr class="acc_DESIGN">';
#         $str .= sprintf '<td>%s</td>', $CLASS{$classIDX};
#         $str .= sprintf '<td><button class="w3-small w3-button w3-border w3-green w3-card-2 w3-round" onclick="sae_generateResultScores(%d, \'%s\',\'%s\');">Generate</button></td>', $classIDX, $txTitle, $txCell;
#         $str .= sprintf '<td ID="%s_%d">%s</td>', $txCell, $classIDX, $links;
#         $str .= '</tr>';
#     }
    
#     $str .= '<tr>';
#     $str .= '<th colspan="3" class="w3-xlarge w3-green">TECHNICAL PRESENTATION SCORES</th>';
#     $str .= '</tr>';
#     foreach $classIDX (sort {$a <=> $b} keys %CLASS ) {
#         my $txTitle = 'Presentation Scores';
#         my $txCell = 'PRESO';
#         my $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txTitle);
#         $str .= '<tr class="acc_PRESO">';
#         $str .= sprintf '<td>%s</td>', $CLASS{$classIDX};
#         $str .= sprintf '<td><button class="w3-small w3-button w3-border w3-green w3-card-2 w3-round" onclick="sae_generateResultScores(%d, \'%s\',\'%s\');">Generate</button></td>', $classIDX, $txTitle, $txCell;
#         $str .= sprintf '<td ID="%s_%d">%s</td>', $txCell, $classIDX, $links;
#         $str .= '</tr>';
#     }
    
#     $str .= '<tr>';
#     $str .= '<th colspan="3" class="w3-xlarge w3-blue">FLIGHT & MISSION PERFORMANCE SCORES</th>';
#     $str .= '</tr>';
#     foreach $classIDX (sort {$a <=> $b} keys %CLASS ) {
#         my $txTitle = 'Mission Performance Scores';
#         my $txCell = 'FLIGHT';
#         my $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txTitle);
#         $str .= '<tr>';
#         $str .= sprintf '<td>%s</td>', $CLASS{$classIDX};
#         $str .= sprintf '<td><button class="w3-small w3-button w3-border w3-green w3-card-2 w3-round" onclick="sae_generateResultScores(%d, \'%s\',\'%s\');">Generate</button></td>', $classIDX, $txTitle, $txCell;
#         $str .= sprintf '<td ID="%s_%d">%s</td>', $txCell, $classIDX, $links;
#         $str .= '</tr>';
#     }
    
#     $str .= '<tr>';
#     $str .= '<th colspan="3" class="w3-xlarge w3-black">OVERALL SCORES</th>';
#     $str .= '</tr>';
#     foreach $classIDX (sort {$a <=> $b} keys %CLASS ) {
#         my $txTitle = 'Overall Performance';
#         my $txCell = 'OVERALL';
#         my $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txTitle);
#         $str .= '<tr>';
#         $str .= sprintf '<td>%s</td>', $CLASS{$classIDX};
#         $str .= sprintf '<td><button class="w3-small w3-button w3-border w3-green w3-card-2 w3-round" onclick="sae_generateResultScores(%d, \'%s\',\'%s\');">Generate</button></td>', $classIDX, $txTitle, $txCell;
#         $str .= sprintf '<td ID="%s_%d">%s</td>', $txCell, $classIDX, $links;
#         $str .= '</tr>';
#     }
#     $str .= '<tr>';
#     $str .= '<th colspan="3" class="w3-xlarge w3-purple">Superlative Awards</th>';
#     $str .= '</tr>';
#     my $Award = new SAE::AWARD();
#     my %SUPERLATIVE = %{$Award->_getListOfAwards()};
#     foreach $classIDX (sort {$a <=> $b} keys %CLASS ) {
#         $str .= '<tr>';
#         $str .= sprintf '<th colspan="3" class="w3-grey w3-text-white">%s</th>',  $CLASS{$classIDX};
#         $str .= '</tr>';
#         foreach $awardIDX (sort {$SUPERLATIVE{$classIDX}{$a}{IN_ORDER} <=> $SUPERLATIVE{$classIDX}{$b}{IN_ORDER}} keys %{$SUPERLATIVE{$classIDX}}) {
#             my $txAward = $SUPERLATIVE{$classIDX}{$awardIDX}{TX_TITLE};
#             my $txDescription = $SUPERLATIVE{$classIDX}{$awardIDX}{TX_DESCRIPTION};
#             my $txCell = sprintf 'SUPERLATIVES_%d', $awardIDX;
#             my $txTitle = 'Superlative Awards';
#             my $links = $Pub->_getPublishedResults($eventIDX, $classIDX, $txAward);
#             $str .= '<tr>';
#             $str .= sprintf '<td><b>%s</b><br><i class="w3-small">%s</i></td>',$txAward, $txDescription;
#             $str .= sprintf '<td><button class="w3-small w3-button w3-border w3-green w3-card-2 w3-round" onclick="sae_generateSuperlativeScores(%d, %d, \'%s\');">Generate</button></td>', $classIDX, $awardIDX, $txCell;
#             $str .= sprintf '<td ID="%s">%s</td>', $txCell, $links;
#             $str .= '</tr>';
#         }
#     }
#     $str .= '</table>';
    
#     return ($str);
# }
# # ===================== 2020 ===================================================
# sub showPublishPage_Back(){
#     print $q->header();
#     my $str = '<br>';
#     $str .= '<div class="w3-container w3-margin-top">';
#     $str.= "<h3>Publish Results</h3>";
#     $str .= '<table class="w3-table-all w3-white">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 25%;">Class</th>';
#     $str .= '<th style="width: 25%;">Regular Class</th>';
#     $str .= '<th style="width: 25%;">Advanced Class</th>';
#     $str .= '<th style="width: 25%;">Micro Class</th>';
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<td>Design Results</td>';
#     $str .= '<td>'.&_templateAddResultCard(1,14).'</td>'; # 1 = Class, 14 = Design
#     $str .= '<td>'.&_templateAddResultCard(2,14).'</td>'; # 2 = Class, 14 = Design
#     $str .= '<td>'.&_templateAddResultCard(3,14).'</td>'; # 3 = Class, 14 = Design
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<td>Presentation Results</td>';
#     $str .= '<td>'.&_templateAddResultCard(1,15).'</td>'; # 1 = Class, 15 = Presentation
#     $str .= '<td>'.&_templateAddResultCard(2,15).'</td>'; # 2 = Class, 15 = Presentation
#     $str .= '<td>'.&_templateAddResultCard(3,15).'</td>'; # 3 = Class, 15 = Presentation
#     $str .= '</tr>';
#     $str .= '</table>';
#     $str .= '<h4>Flights Results</h4>';
#     $str .= '<table class="w3-table-all w3-white">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 25%;">Class</th>';
#     $str .= '<th style="width: 25%;">Regular Class</th>';
#     $str .= '<th style="width: 25%;">Advanced Class</th>';
#     $str .= '<th style="width: 25%;">Micro Class</th>';
#     $str .= '</tr>';
#     for ($row=1; $row<=10; $row++){
#         $str .= '<tr>';
#         $str .= '<td>Round '.$row.'</td>';
#         $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
#         $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
#         $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
#         $str .= '</tr>';
#     }
#     $str .= '<tr>';
    
#     $str .= '</table>';
#     $str .= '<h4>Overall Results</h4>';
#     $str .= '<table class="w3-table-all w3-white">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 25%;">Class</th>';
#     $str .= '<th style="width: 25%;">Regular Class</th>';
#     $str .= '<th style="width: 25%;">Advanced Class</th>';
#     $str .= '<th style="width: 25%;">Micro Class</th>';
#     $str .= '</tr>';
#     $str .= '<tr>';
#     $str .= '<td>Results</td>';
#     $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
#     $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
#     $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
#     $str .= '</tr>';
#     $str .= '</table>';
#     for ($row=1; $row<=10; $row++){
#         $str .= '<br>';
#     }
    
#     $str .= '</div>';
#     return ($str);
# }
# sub sae_publishResults(){
#     print $q->header();
#     my $classIDX = $q->param('classIDX');
#     my $inType = $q->param('inType');
#     my $str = &_templateResultCards('xxxxxx');
#     return ($str);
# }

# sub _templateResultCards(){
#     my $tsFile = shift;
#     my $str;
#     $str .= '<div class="w3-margin-bottom w3-card-4 w3-small w3-margin-left w3-display-container w3-round" style="width: 50%;">';
#     $str .= '<header class="w3-container w3-light-grey w3-round">';
#     $str .= 'Results';
#     $str .= '</header>';
#     $str .= '<a class="w3-button w3-hover-red w3-display-topright " style="padding: 0px 5px;" onclick="$(this).parent().remove();">&times;</a>';
#     $str .= '<div class="w3-container w3-white" style="padding: 8px 2px;">';
#     $str .= '<a class="w3-margin-left" href="result.html?fileID='.$txFile.'" target="_blank"><i class="fa fa-search"></i> Preview View</a>';
#     $str .= '</div>';
#     $str .= '<button class="w3-button w3-block w3-dark-grey w3-hover-blue" onclick="">Publish</button>';
#     $str .= '</div>';
#     return ($str);
# }

# sub _templateAddResultCard(){
#     my $classIDX = shift;
#     my $inType = shift;
#     my $str;
#     $str = '<button class="w3-button w3-border w3-card-2" onclick="sae_publishResults(this,'.$classIDX.','.$inType.');">+</button>';
    
# }


