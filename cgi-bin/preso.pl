#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI::Session;
use CGI::Cookie;
use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Text::CSV;
use Spreadsheet::ParseXLSX;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;
use List::Util qw( min max );

#---- SAE MODULES -------
use SAE::SDB;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::PRESO;
use SAE::REFERENCE;
use SAE::SCORE;
use SAE::Common;
use SAE::USER;
use SAE::TEAM;
use SAE::GRADE;
use SAE::TABLE;
use SAE::RUBRIC;

my %CLASS = (1=>'Regular', 2=>'Advanced', 3=>'Micro');

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
# ==2024 ================================================================
sub preso_loadJudgesStatisics (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $userIDX    = $q->param('userIDX');
    my $Preso      = new SAE::PRESO();
    my %TEAMS      = %{$Preso->_getListofTeamsJudged($userIDX, $eventIDX)};
    my %RUBRIC     = %{$Preso->_getListofTeamsJudgedScores($userIDX, $eventIDX)};
    my $str;
    foreach $cardIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inCardSCore = 0;
        $str .= sprintf '<tr class="w3-light-grey w3-small vol_%d">', $userIDX;
        $str .= sprintf '<td class="w3-padding-left" style="padding-left: 30px;"><em>%03d - %s</em></td>',$TEAMS{$cardIDX}{IN_NUMBER}, $TEAMS{$cardIDX}{TX_SCHOOL};
        foreach $inSec (sort {$a <=> $b} keys %{$RUBRIC{$cardIDX}}) {
            foreach $inSub (sort {$a <=> $b} keys %{$RUBRIC{$cardIDX}{$inSec}}) {
                    my $inScore  = $RUBRIC{$cardIDX}{$inSec}{$inSub}{IN_VALUE};
                    my $inWeight = $RUBRIC{$cardIDX}{$inSec}{$inSub}{IN_SUB_WEIGHT};
                    $str .= sprintf '<td style=" text-align: right;"><em>%1.1f</em></td>', $inScore;
                    $inCardSCore  += (($inScore/10)*($inWeight/100)*50);
                    push (@{$inSec.'_'.$inSub}, $inScore);
               }
               $str .= sprintf '<td style=" text-align: right;"><em>%1.2f</em></td>', $inCardSCore;
            }

        $str .= '</tr>';
    }
    return ($str);
    }
sub preso_showTeamStatistics (){
    print $q->header();
    my $teamIDX    = $q->param('teamIDX');
    my $classIDX    = $q->param('classIDX');
    my $Preso      = new SAE::PRESO();
    my %VOL        = %{$Preso->_getPresentationJudges($teamIDX)};
    my %RUBRIC     = %{$Preso->_getPresoRubric('Presentation', $classIDX)};
    my %SCORES     = %{$Preso->_getTeamPresoScores($teamIDX)};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= '<div class="w3-container" style="padding: 0px;">';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<thead>';
    $str .= '<tr class="w3-blue-grey">';
    $str .= '<th>Judge<br>Weight</th>';
    foreach $inSec (sort {$a <=> $b} keys %RUBRIC) {
        foreach $inSub (sort {$a <=> $b} keys %{$RUBRIC{$inSec}}) {
            $str .= sprintf '<th style="width: 65px; text-align: right;">%d.%d<br><span class="w3-tiny">%1.1f%</span></th>', $inSec, $inSub, $RUBRIC{$inSec}{$inSub}{IN_SUB_WEIGHT};;
        }
    }
    $str .= sprintf '<th style="width: 65px; text-align: right;">Score</th>', $inSec, $inSub;
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';

    foreach $cardIDX (sort {$a <=> $b} keys %VOL) {
        my $userIDX = $VOL{$cardIDX}{PK_USER_IDX};
        $str .= '<tr class="w3-white">';
        $str .= sprintf '<td><a class="w3-margin-left" href="javascript:void(0);" style="text-decoration: none;" onclick="preso_loadJudgesStatisics(this, %d);"><i class="fa fa-chevron-right" w3-margin-right></i>&nbsp;&nbsp;%s, %s</a></td>', $userIDX, $VOL{$cardIDX}{TX_LAST_NAME}, $VOL{$cardIDX}{TX_FIRST_NAME};
        my $inCardSCore = 0;
        foreach $inSec (sort {$a <=> $b} keys %{$SCORES{$cardIDX}}) {
            foreach $inSub (sort {$a <=> $b} keys %{$SCORES{$cardIDX}{$inSec}}) {
                my $inScore  = $SCORES{$cardIDX}{$inSec}{$inSub}{IN_VALUE};
                my $inWeight = $SCORES{$cardIDX}{$inSec}{$inSub}{IN_SUB_WEIGHT};
                $str .= sprintf '<td style="text-align: right;">%1.1f</td>', $inScore;
                $inCardSCore  += (($inScore/10)*($inWeight/100)*50);
                push (@{$inSec.'_'.$inSub}, $inScore);
            }
            $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $inCardSCore;
        }
        push (@score,  $inCardSCore);
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '<tfoot>';
    $str .= '<tr class="w3-light-grey">';
    $str .= '<td style="text-align: right;">Standard Deviation</td>';
    foreach $inSec (sort {$a <=> $b} keys %RUBRIC) {
        foreach $inSub (sort {$a <=> $b} keys %{$RUBRIC{$inSec}}) {
                my $bgColor = 'w3-light-grey';
                my $std = stddev(@{$inSec.'_'.$inSub});
                if ($std>=1.5) {
                    $bgColor = 'w3-pale-red';
                } elsif ($std>=.75) {
                    $bgColor = 'w3-pale-yellow';
                }
                $str .= sprintf '<td style="text-align: right;" class="%s">%1.2f</td>', $bgColor, $std;
            }
        }
        $str .= sprintf '<td style="text-align: right;">%1.4f</td>', stddev(@score);
        $str .= '</tr>';;
    $str .= '</tfoot>';
    $str .= '</table>';
    $str .= '</div>';

    return ($str);
    }
sub preso_saveLineItem (){
    print $q->header();
    my $paperIDX    = $q->param('paperIDX');
    my $cardIDX     = $q->param('cardIDX');
    my $teamIDX     = $q->param('teamIDX');
    my $txType      = 'Presentation';
    my %CONDITION   = ('PK_PAPER_IDX'=>$paperIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table       = new SAE::TABLE();
    my $Preso       = new SAE::PRESO();
       $Table->_save('TB_PAPER', $q->param('jsonData'), $json_dcondition);
    my $Grade = new SAE::GRADE();
    my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $teamIDX);
    # my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $txType);
    my %STATS = %{$Preso->_getTeamPresoStatistics($teamIDX)};
    $STATS{IN_SCORE}  = $score;
    my $json = encode_json \%STATS;
    return ($json);

    }
sub preso_deleteCard (){
    print $q->header();
    my $eventIDX = $q->param('eventIDX');
    my $cardIDX  = $q->param('cardIDX');
    my $teamIDX    = $q->param('teamIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    my $Preso = new SAE::PRESO();
    $Preso->_deletePresoScoreCard($cardIDX);
    $Preso->_deletePresoScoreCard_Paper($cardIDX);
    my %STATS = %{$Preso->_getTeamPresoStatistics($teamIDX)};
    my $json = encode_json \%STATS;
    return ($json);
    }
sub preso_autosaveFeedback (){
    print $q->header();
    my $paperIDX    = $q->param('paperIDX');
    my %CONDITION   = ('PK_PAPER_IDX'=>$paperIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table       = new SAE::TABLE();
       $Table->_save('TB_PAPER', $q->param('jsonData'), $json_dcondition);
    return("Saved");
    }
sub preso_updatePresentationScore (){
    print $q->header();
    my $Preso       = new SAE::PRESO();
    my $eventIDX    = $q->param('eventIDX');
    my $cardIDX     = $q->param('cardIDX');
    my $teamIDX     = $q->param('teamIDX');
    my %CARD        = %{$Preso->_getPresoCardDetails($cardIDX)};
    my $Team       = new SAE::TEAM();
    my %TEAM       = %{$Team->_getTeamDetails($teamIDX)};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= '<div class="w3-bar w3-white w3-margin-top">';
    $str .=  sprintf '<button class="w3-bar-item w3-button w3-green w3-hover-pale-green w3-border w3-right w3-rightbar w3-border-green w3-margin-right" onclick="$(this).close();">Exit Evaluation</button>';
    $str .=  sprintf '<button class="w3-bar-item w3-button w3-pale-red w3-hover-red w3-border w3-leftbar w3-border-red w3-margin-left" onclick="preso_deleteCard(this, %d, %d)">Delete</button>', $cardIDX, $teamIDX;
    $str .= '</div>';

    $str .= '<div class="w3-container" style="height: 600px; overflow-y: auto">';
    $str .= sprintf '<h2>%03d - %s</h2>', $TEAM{IN_NUMBER}, $TEAM{TX_SCHOOL};
    foreach $section (sort {$a <=> $b} keys %CARD) {
        foreach $subSection (sort {$a <=> $b} keys %{$CARD{$section}}){
            my $reportIDX       = $CARD{$section}{$subSection}{PK_REPORT_IDX};
            my $paperIDX        = $CARD{$section}{$subSection}{PK_PAPER_IDX};
            my $txSection       = $CARD{$section}{$subSection}{TX_SUB};
            my $divName         = sprintf "LineItem_%d", $reportIDX;
            my $lineScore       = $CARD{$section}{$subSection}{IN_VALUE};
            my $feedback        = $CARD{$section}{$subSection}{CL_FEEDBACK};
            my $inValueType     = $CARD{$section}{$subSection}{BO_BIN};
            my $sectionColor    = 'w3-teal';
            my %LABEL      = (1=>'Poor: Low',2=>'Poor: Medium',3=>'Poor: High',4=>'Average: Low',5=>'Average: Medium',6=>'Average: High',7=>'Excellent: Low',8=>'Excellent: Medium',9=>'Excellent: High',10=>'Perfect');
            if ($lineScore==0){$sectionColor  = 'w3-light-grey'}
            $str .= sprintf '<div ID="LINE_ITEM_%d" class="w3-row w3-padding w3-border w3-round w3-hover-pale-blue %s" >', $reportIDX, $sectionColor;
            $str .= sprintf '<div class="w3-col m6 " style="cursor: pointer;" onclick="preso_expandDescription(this, \'%s\');">', $divName;
            $str .= sprintf '<i id="arrow_'.$divName.'" class="fa fa-angle-double-right w3-margin-right w3-large" aria-hidden="true" ></i><b>%d.%d</b> - %s',$section, $subSection, $txSection ;
            # $str .= sprintf '<div class="w3-col m12"><i id="arrow_'.$divName.'" class="fa fa-angle-double-right w3-margin-right w3-large" aria-hidden="true" ></i><b>%d.%d</b> - %s</div>',$section, $subSection, $txSection ;
            $str .= '</div>';
            $str .= '<div class="w3-col m6">';
            if ($inValueType == 0) {
                # $str .= sprintf '<div class="w3-col m2">&nbsp;</div>';
                for ($i=10; $i>=1; $i--){
                    my $bgColor = 'w3-pale-red';
                    if ($i>3) {$bgColor = 'w3-yellow';}
                    if ($i>6) {$bgColor = 'w3-pale-green';}
                    if ($i>9) {$bgColor = 'w3-blue';}
                    my $checked         = '';
                    if ($i == $lineScore) {$checked = 'checked'}
                    $str .= sprintf '<div class="w3-cell w3-mobile %s w3-border w3-right" style="white-space: nowrap; padding: 2px 4px;">', $bgColor;
                    $str .= sprintf '<input %s class="w3-radio" data-key="%d" data-field="PK_REPORT_IDX" value="%d" type="radio" name="LINE_%d" onclick="preso_updateBreakingScoringThreshold(this, \'%s\', %d, %d, %d, %d)">', $checked, $paperIDX, $i, $paperIDX, $divName , $paperIDX, $cardIDX, $reportIDX, $teamIDX;
                    $str .= sprintf '<span> %d </span><span class="w3-small w3-hide-large w3-hide-medium"> %s</span>', $i, $LABEL{$i};
                    $str .= sprintf '</div>';
                }
                $str .= '</div>';
                $str .= '</div>';
            } else {
                $str .= '<div class="w3-cell w3-mobile w3-right">';
                # $str .= sprintf '<div class="w3-col m2">&nbsp;</div>';
                    my $checked         = '';
                    if ($lineScore == 10) {$checked = 'checked'}
                    $str .= sprintf '<input ID="TIME_LIMIT" type="checkbox" %s class="w3-check" data-key="IN_VALUE" value="10" onChange="preso_saveCheckAssessment(this, %d, %d, %d, %d )">', $checked, $paperIDX, $cardIDX, $reportIDX, $teamIDX;
                    $str .= '<label class="w3-margin-left">Yes, Team presented <b>under</b> time limit.</label>';
                    # $str .= '<label class="w3-margin-left">Yes, Team presented <b>under</b> time limit.</label>';
                $str .= sprintf '</div>';
                $str .= '</div>';
                $str .= '</div>';
                }
            $str .= sprintf '<div class="w3-row w3-padding w3-border w3-round w3-white w3-hide %s">', $divName;
                $str .= '<div class="w3-col m12" >';
                $str .= sprintf '%s', $CARD{$section}{$subSection}{CL_DESCRIPTION};;
                $str .= '</div>';
                $str .= '<div class="w3-col m12 w3-margin-top" >Feedback';
                $str .= sprintf '<textarea class="w3-input w3-border w3-pale-yellow w3-round " onfocus="grade_autoAdjustHeight(this);" onblur="preso_autosaveFeedback(this, %d);" style="min-width: 100%; height: 75px;">%s</textarea>', $paperIDX, $feedback;
                $str .= '</div>';
            $str .= '</div>';

        }
    }
    $str .= '</div>';

    return ($str);
    }
sub preso_confirmPresentationTime (){
    print $q->header();
    my %TIME = (1=>'12', 2=>'15', 3=>'12');
    my $eventIDX= $q->param('eventIDX');
    my $classIDX= $q->param('classIDX');
    my $teamIDX= $q->param('teamIDX');
    my $timeLimit= $q->param('timeLimit');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    my $checked = '';
    if ($timeLimit == 1) {$checked = 'checked'}
    $str .= '<div class="w3-container">';
    $str .= sprintf '<h3>Please confirm if the team presented under the <b class="w3-xlarge">%d</b> minute time.</h3>',$TIME{$classIDX};
    $str .= sprintf '<input ID="confirmTime" %s class="w3-check" type="checkbox" onClick="preso_updateTimeLimit(this);">',$checked;
    $str .= sprintf '<label for="confirmTime" class="w3-margin-left">Yes, the team presented <b><u>UNDER</u></b> the <b class="w3-xlarge">%d</b> minute time limit.</label>', $TIME{$classIDX};
    $str .= '<div class="w3-container w3-padding w3-center w3-margin-top">';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-pale-green w3-hover-green" onclick="preso_saveNewEvaluation(this, %d, %d);">Save Evaluation</button>', $classIDX, $teamIDX;
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
sub preso_saveNewEvaluation (){
    print $q->header();
    my $classIDX     = $q->param('classIDX');
    my $userIDX     = $q->param('userIDX');
    my $teamIDX     = $q->param('teamIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    # 1. Create Card and grab new cardIDX value from jsonCard
    # 2. Get Rubric for Presentation and put in Hash, using cardIDX as the reference
    # 3. Dereference jsonData into a HASH
    # 4. Loop through Rubric and add new Record into TB_PAPER with evaluation values
    # 5. get Score from the entry
    # 6. create a score button to return and append to the space.
    my $Table        = new SAE::TABLE();
    my $Rubric       = new SAE::RUBRIC();
    my $Grade        = new SAE::GRADE();
    my $User         = new SAE::USER();
    my $Preso       = new SAE::PRESO();
    my %RUBRIC       = %{$Rubric->_getPresentationRubric($classIDX)};
    my %DATA         = %{decode_json($q->param('jsonData'))};
    my %FEED         = %{decode_json($q->param('jsonFeed'))};
    my $newCardIDX   = $Table->_saveAsNew('TB_CARD', $q->param('jsonCard'));
    my $str;
    foreach $reportIDX (sort keys %RUBRIC) {
        my $inValue    = 0;
        my $txFeedback = '';
        if (exists $DATA{$reportIDX}){$inValue = $DATA{$reportIDX}}
        if (exists $FEED{$reportIDX}){$txFeedback = $FEED{$reportIDX}}
        my %HASH = ('FK_CARD_IDX'=>$newCardIDX, 'FK_REPORT_IDX'=>$reportIDX, 'IN_VALUE'=>$inValue, 'CL_FEEDBACK'=>$txFeedback);
        my $json = encode_json \%HASH;
        $Table->_saveAsNew('TB_PAPER', $json);
        # $str .= sprintf "cardIDX=%d; %d = %d [%s] \n", $newCardIDX, $reportIDX, $inValue, $txFeedback;
    }
    # my $inScore        = $Grade->_getAssessmentScore_byCard($newCardIDX, 'Presentation');
    my $inScore        = $Grade->_getAssessmentScore_byCard($newCardIDX, $teamIDX);
    my $txInitials     = $User->_getUserInitials($userIDX);
    my $btn            = &preso_evalTile($newCardIDX, $inScore, $txInitials, $teamIDX);
    my %STATS          = %{$Preso->_getTeamPresoStatistics($teamIDX)};
    $STATS{TG_BUTTON}  = $btn;
    # return ($str);
    my $json = encode_json \%STATS;
    return ($json);
    }
sub preso_openEvaluationForm (){
    print $q->header();
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $teamIDX    = $q->param('teamIDX');
    my $txType     = 'Presentation';
    my $Team       = new SAE::TEAM();
    my %TEAM       = %{$Team->_getTeamDetails($teamIDX)};
    my $Report     = new SAE::GRADE();
    my %RUBRIC     = %{$Report->_getReportRubric($txType, $classIDX)};
    my $str;
    my %LABEL      = (1=>'Poor: Low',2=>'Poor: Medium',3=>'Poor: High',4=>'Average: Low',5=>'Average: Medium',6=>'Average: High',7=>'Excellent: Low',8=>'Excellent: Medium',9=>'Excellent: High',10=>'Perfect');
    $str .= '<div class="w3-container">';
    
    $str .= '<div class="w3-bar  w3-white w3-border-grey w3-margin-top">';
    # $str .= '<button class="w3-bar-item w3-button " onclick="grade_instructions();">Instructions</button>';
    $str .=  sprintf '<button class="w3-bar-item w3-button w3-pale-red w3-hover-red w3-border w3-leftbar w3-border-red w3-margin-left" onclick="$(this).close();">Cancel</button>', $cardIDX, 1, $txType;
    $str .=  sprintf '<button class="w3-bar-item w3-button w3-pale-green w3-hover-green w3-border w3-right w3-rightbar w3-border-green w3-margin-right" onclick="preso_confirmPresentationTime(this, %d, %d);"><i class="fa fa-floppy-o" aria-hidden="true"></i> Save Evaluation</button>', $classIDX, $teamIDX;
    # $str .=  sprintf '<button class="w3-bar-item w3-button w3-pale-green w3-hover-green w3-border w3-right w3-rightbar w3-border-green w3-margin-right" onclick="preso_saveNewEvaluation(this, %d, %d);"><i class="fa fa-floppy-o" aria-hidden="true"></i> Save Evaluation</button>', $classIDX, $teamIDX;
    $str .= '</div>';
    $str .= '<div class="w3-container" style="height: 600px; overflow-y: auto">';
    $str .= sprintf '<h2>%03d - %s</h2>', $TEAM{IN_NUMBER}, $TEAM{TX_SCHOOL};
    foreach $section (sort {$a <=> $b} keys %RUBRIC) {
        foreach $subSection (sort {$a <=> $b} keys %{$RUBRIC{$section}}){
            my $reportIDX       = $RUBRIC{$section}{$subSection}{PK_REPORT_IDX};
            my $txSection       = $RUBRIC{$section}{$subSection}{TX_SUB};
            my $divName         = sprintf "LineItem_%d", $reportIDX;
            my $inValueType     = $RUBRIC{$section}{$subSection}{BO_BIN};
            my $sectionColor    = 'w3-light-grey';
            $str .= sprintf '<div ID="LINE_ITEM_%d" class="w3-row w3-padding w3-border w3-round w3-hover-pale-blue %s" >', $reportIDX, $sectionColor;
            $str .= sprintf '<div class="w3-col m6" style="cursor: pointer;" onclick="preso_expandDescription(this, \'%s\');">', $divName;
            $str .= sprintf '<i id="arrow_'.$divName.'" class="fa fa-angle-double-right w3-margin-right w3-large" aria-hidden="true" ></i><b>%d.%d</b> - %s',$section, $subSection, $txSection ;
            # $str .= sprintf '<div class="w3-col m7"><i id="arrow_'.$divName.'" class="fa fa-angle-double-right w3-margin-right w3-large" aria-hidden="true" ></i><b>%d.%d</b> - %s</div>',$section, $subSection, $txSection ;
            $str .= '</div>';
            $str .= '<div class="w3-col m6 ">';
            if ($inValueType == 0) {
                    for ($i=10; $i>=1; $i--){
                        my $bgColor = 'w3-pale-red';
                        if ($i>3) {$bgColor = 'w3-yellow';}
                        if ($i>6) {$bgColor = 'w3-pale-green';}
                        if ($i>9) {$bgColor = 'w3-blue';}
                        $str .= sprintf '<div class="w3-cell w3-mobile %s w3-border w3-right" style="white-space: nowrap; padding: 2px 4px;">', $bgColor;
                        $str .= sprintf '<input class="w3-radio" data-key="%d" data-field="PK_REPORT_IDX"  value="%d" type="radio" name="LINE_%d" onclick="preso_breakingScoringThreshold(this, \'%s\', %d)">', $reportIDX, $i, $reportIDX, $divName, $reportIDX;
                        $str .= sprintf '<span> %d </span><span class="w3-small w3-hide-large w3-hide-medium"> %s</span>', $i, $LABEL{$i};
                        $str .= sprintf '</div>';
                    }
                    $str .= '</div>';
                $str .= '</div>';
                    $str .= sprintf '<div class="w3-row w3-padding w3-border w3-round w3-white w3-hide %s">', $divName;
                        $str .= '<div class="w3-col m12" >';
                        $str .= sprintf '%s', $RUBRIC{$section}{$subSection}{CL_DESCRIPTION};;
                        $str .= '</div>';
                        $str .= '<div class="w3-col m12 w3-margin-top" >Feedback';
                        $str .= sprintf '<textarea class="w3-input w3-border w3-pale-yellow w3-round " data-key="%d" data-field="CL_FEEDBACK" onfocus="grade_autoAdjustHeight(this, %d);" onblur="preso_collectFormData(this);" style="min-width: 100%; height: 75px;">%s</textarea>', $reportIDX, $reportIDX;
                        $str .= '</div>';
                    $str .= '</div>';

                } else {
                    $str .= '<div class="w3-cell w3-mobile w3-right">';
                    $str .= sprintf '<input ID="TIME_LIMIT" class="w3-check" data-key="%d" value="10" type="checkbox" onchange="preso_breakingScoringThreshold(this, \'%s\', %d)">',  $reportIDX, $divName, $reportIDX;
                    $str .= '<label class="w3-margin-left">Yes, Team presented <b>under</b> time limit. </label>';
                    $str .= sprintf '</div>';
                    $str .= '</div>';
                    $str .= '</div>';
                    $str .= sprintf '<div class="w3-row w3-padding w3-border w3-round w3-white w3-hide %s">', $divName;
                        $str .= '<div class="w3-col m12" >';
                        $str .= sprintf '%s', $RUBRIC{$section}{$subSection}{CL_DESCRIPTION};;
                        $str .= '</div>';
                        $str .= '<div class="w3-col m12 w3-margin-top" >Feedback';
                        $str .= sprintf '<textarea class="w3-input w3-border w3-pale-yellow w3-round " data-key="%d" data-field="CL_FEEDBACK" onfocus="grade_autoAdjustHeight(this);" onblur="preso_collectFormData(this);" style="min-width: 100%; height: 75px;">%s</textarea>', $reportIDX;
                        $str .= '</div>';
                    $str .= '</div>';
                }
            }
    }
    $str .= '</div>';
    return ($str);
    }
sub preso_evalTile (){
    my ($cardIDX, $inScore, $txInitials, $teamIDX) = @_;
    my $str;
    $str = sprintf '<button ID="BUTTON_CARD_%d" class="w3-button w3-round w3-margin-left w3-border w3-small w3-pale-green w3-hover-green" onclick="preso_updatePresentationScore(this, %d, %d);">', $cardIDX, $cardIDX, $teamIDX;
    $str .= sprintf '<span class="w3-badge w3-green w3-border" >%s</span> <span ID="CARD_SCORE_%d">%2.2f</span>', $txInitials, $cardIDX, $inScore;
    $str .= sprintf '</button>';
    return ($str);
    }
sub preso_showListOfTeam (){
    print $q->header();
    my $eventIDX  = $q->param('eventIDX');
    my $userIDX   = $q->param('userIDX');
    my $sortBy    = $q->param('sortBy');
    my $Team      = new SAE::TB_TEAM();
    # my $Score     = new SAE::SCORE();
    my $Preso     = new SAE::PRESO();
    my %CLASS     = (1=>'Reg', 2=>'Adv', 3=>'Mic');
    my %TEAMS     = %{$Team->getAllRecordBy_FkEventIdx($eventIDX)};
    my %SCORE     = %{$Preso->_getBatchPresoScore($eventIDX)};
    my $str;
    # $str = '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<div class="w3-display-container" style="display: block; z-index: 7001;">';
    $str .= '<div ID="banner_saveMessage" class="w3-display-topmiddle"></div>';
    $str .= '</div>';
    $str .= '<h3 style="padding-top: 25px;">Design & Technical Presentations</h3>';
    $str .= '<div class="w3-row w3-padding w3-border w3-light-grey w3-hide-small w3-hide-medium">';
    $str .= '<div class="w3-col m10 ">';
        $str .= sprintf '<div class="w3-col m1">Team #</div>', $inNumber;
        $str .= sprintf '<div class="w3-col m1">Class</div>', $CLASS{$classIDX};
        $str .= sprintf '<div class="w3-col m3">School</div>', $txSchool;
        $str .= sprintf '<div class="w3-col m7 w3-border-left">Evaluation Scores</div>';
        $str .= '</div>';
        $str .= '<div class="w3-col m2 w3-border-left w3-small">';
        $str .= sprintf '<div class="w3-col m3">High</div>', 0;
        $str .= sprintf '<div class="w3-col m3">Low</div>', 0;
        $str .= sprintf '<div class="w3-col m3">Std. D.</div>', 0;
        $str .= sprintf '<div class="w3-col m3">Mean</div>', 0;
        $str .= '</div>';
    $str .= '</div>';

    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inNumber  = $TEAMS{$teamIDX}{IN_NUMBER};
        my $classIDX  = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $txSchool  = $TEAMS{$teamIDX}{TX_SCHOOL};
        my $txCountry = $TEAMS{$teamIDX}{TX_COUNTRY};
        $str .= '<div class="w3-row w3-padding w3-border w3-round">';
            $str .= '<div class="w3-col m10">';
            $str .= sprintf '<div class="w3-col s1">%03d</div>', $inNumber;
            $str .= sprintf '<div class="w3-col s1">%s</div>', $CLASS{$classIDX};
            $str .= sprintf '<div class="w3-col m2">%s</div>', $txSchool;
            $str .= sprintf '<div ID="cardBin_%d" class="w3-col w3-row-padding m8 w3-round">', $teamIDX;
            $str .= sprintf '<button class="w3-button w3-border w3-round w3-small w3-hover-green" onclick="preso_openEvaluationForm(this, %d, %d);">+</button>', $classIDX, $teamIDX ;
            foreach $cardIDX (sort {$a <=> $b} keys %{$SCORE{$teamIDX}}) {
                $str .= &preso_evalTile($cardIDX, $SCORE{$teamIDX}{$cardIDX}{IN_SCORE}, $SCORE{$teamIDX}{$cardIDX}{TX_INIT}, $teamIDX);
            }
            my %STAT = %{$Preso->_getTeamPresoStatistics($teamIDX)};
            $str .= '</div>';
            $str .= '</div>';
            $str .= '<div class="w3-col m2 w3-small">';
            $str .= '<hr class="w3-hide-large w3-hide-medium">';
            $str .= sprintf '<div class="w3-col s3"><div class="w3-hide-large w3-hide-medium w3-small">High</div><span ID="MAX_STAT_%d">%2.2f</span></div>'  , $teamIDX, $STAT{IN_MAX};
            $str .= sprintf '<div class="w3-col s3"><div class="w3-hide-large w3-hide-medium w3-small">Low</div><span ID="MIN_STAT_%d">%2.2f</span></div>'   , $teamIDX, $STAT{IN_MIN};
            my $txtColor = '';
            if ($STAT{IN_STD}>10) {
                $txtColor = 'w3-text-red';
                } elsif ($STAT{IN_STD}>5) {
                    $txtColor = 'w3-text-orange';
                    } else {
                        $txtColor = 'w3-text-green';
                    }
            $str .= sprintf '<div class="w3-col s3"><div class="w3-hide-large w3-hide-medium w3-small">Std. D</div><span class="%s"><a ID="STD_STAT_%d" href="javascript:void(0);" onclick="preso_showTeamStatistics(this, %d, %d);">%2.2f</a></span></div>',  $txtColor, $teamIDX, $teamIDX, $classIDX, $STAT{IN_STD};
            $str .= sprintf '<div class="w3-col s3"><div class="w3-hide-large w3-hide-medium w3-small">Mean</div><span ID="MEAN_STAT_%d"><b>%2.2f</b></span></div>'  , $teamIDX, $STAT{IN_MEAN};
            $str .= '</div>';
        $str .= '</div>';
        $str .= sprintf '<div ID="TEAM_STAT_%d" class="w3-container w3-hide" style="padding: 0px;">', $teamIDX;
        $str .= '<img src="../../images/loader.gif"> Loading...';
        $str .= '</div>';
        
    }

    # $str .= &showListOfTeam_Preso_LEG();
    return ($str);
    }
# ==2024 ================================================================
sub __template(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    return ($str);
}
sub sae_updateValidateScore(){
    print $q->header();
    my $paperIDX = $q->param('paperIDX');
    my $inValue = $q->param('inValue');
    my $Preso = new SAE::PRESO();
    $Preso->_updatePaperScore($paperIDX, $inValue);
    return ("Paper ID ($paperIDX) updated to $inValue");
}
sub sae_validatePreso(){
    print $q->header();
    my $Teams = new SAE::TB_TEAM();
    my $Preso = new SAE::PRESO();
    my $Users = new SAE::TB_USER();
    my %USERS = %{$Users->getAllRecord()};
    my %QUESTIONS = %{$Preso->_getPresentationQuestions(5)};
    my $str;
    my $location = $q->param('location');
    my $userIDX = $q->param('userIDX');
    my %TEAMS = %{$Teams->getAllRecordBy_FkEventIdx($location)};
    my %SCORES = %{$Preso->_getValidatedScoreCards(5, $location)};
    $str .= '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<h3>Validate Scores</h3>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="showListOfTeam_Preso(\'number\');">&lt;&lt; Back</button><br><br/>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my %CARDS = %{$Preso->_getScoreCardsByTeam($teamIDX, 5)};
        
        # $team = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<div class="w3-container w3-card-2 w3-border w3-round w3-margin-bottom">';
        $str .= sprintf '<h4>Team: %03d - %s</h4>', $TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<table class="w3-table w3-margin-bottom">';
        $str .= '<tr class="w3-small">';
        $str .= '<th>Card #</th>';
        foreach $subIDX (sort {$QUESTIONS{$a}{IN_SUBSECTION} <=> $QUESTIONS{$b}{IN_SUBSECTION}} keys %QUESTIONS) {
            $str .= sprintf '<th style="width: 8.33%">%d<br>%s</th>', $QUESTIONS{$subIDX}{IN_SUBSECTION}, $QUESTIONS{$subIDX}{TX_SUBSECTION};
        }
        $str .= '<th>Judge</th>';
        $str .= '</tr>';
        foreach $cardIDX (sort {$a<=>$b} keys %{$SCORES{$teamIDX}}) {
            my $userIDX;
            $str .= '<tr class="w3-small w3-hover-yellow">';
            $str .= sprintf '<td>%d</td>', $cardIDX;
            foreach $subIDX (sort {$QUESTIONS{$a}{IN_SUBSECTION} <=> $QUESTIONS{$b}{IN_SUBSECTION}} keys %QUESTIONS) {
                $userIDX =  $SCORES{$teamIDX}{$cardIDX}{$subIDX}{FK_USER_IDX};
                my $paperIDX = $SCORES{$teamIDX}{$cardIDX}{$subIDX}{PK_PAPER_IDX};
                my $inValue = $SCORES{$teamIDX}{$cardIDX}{$subIDX}{IN_VALUE}/10;
                if ($subIDX < 91){
                    $str .= sprintf '<td style="padding: 1px;"><input class="w3-input w3-border w3-round" type="number" max="10" min="0" value="%2.1f" data-key="%2.1f" style="text-align: right;" onChange="sae_updateValidatedInput(%d, this);"></td>', $inValue, $inValue, $paperIDX;
                } else {
                    my $checked = '';
                    if ( $SCORES{$teamIDX}{$cardIDX}{$subIDX}{IN_VALUE} > 0) {$checked = "checked"}
                    $str .= sprintf '<td style="padding: 1px; text-align: center; vertical-align: text-top;"><input class="w3-check w3-small" type="checkbox" value="100" %s onChange="sae_updateValidateCheckbox(%d, this);"></td>', $checked, $paperIDX;
                }
            }
            $str .= sprintf '<td>%s, %s</td>', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
            $str .= '</tr>';
        }

        $str .= '</table>';
        $str .= '</div>';
    }
    $str .= '</div>';
    return ($str);
}
# =================== 2022 START ========================================
sub sae_openImport(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $eventIDX= $q->param('eventIDX');
    my $User = new SAE::USER();
    my %JUDGES = %{$User->_getJudges()};
    my $str;
    
    $str .= '<form class="w3-container w3-padding" action = "javascript:void(0);" method = "post" enctype = "multipart/form-data">';
    $str .= sprintf '<label class="w3-text-grey" >Judge that performed the assessment:</label><br>';
    $str .= '<select ID="JUDGE_IDX" class="w3-select w3-border w3-round">';
    foreach $judgeIDX (sort {lc($JUDGES{$a}{TX_LAST_NAME}) cmp lc($JUDGES{$b}{TX_LAST_NAME})} keys %JUDGES) {
        my $selected = '';
        if ($judgeIDX == $userIDX){$selected = 'selected'}
     $str .= sprintf '<option value="%d" %s>%s, %s</option>', $judgeIDX, $selected, $JUDGES{$judgeIDX}{TX_LAST_NAME}, $JUDGES{$judgeIDX}{TX_FIRST_NAME};   
    }
    $str .= '</select>';
    $str .= '<div class="w3-center w3-light-grey w3-padding w3-border w3-round w3-margin-top">';
    $str .= sprintf '<label class="w3-text-grey" >Select the Excel file to import</label><br>';
    # $str .= '<label for="file" class="w3-button w3-border w3-green w3-round" style="display: in-line;">';
    $str .= '<label for="file" class="w3-button w3-border w3-grey w3-round" style="display: inline-block; width: 100%; overflow-hidden">';
    $str .= 'Browse ...';
    $str .= '</label>';
    $str .= sprintf '<input id="file" class="w3-round w3-border" style="display: none;" type="file" name="filename" onchange="getFileName(this);"/>';
    $str .= '</div>';
    $str .= '<div class="w3-panel w3-padding w3-center">';
    $str .= sprintf '<button class="w3-button w3-round w3-border" style="width: 155px;" onclick="sae_uploadExcelScoresheet(this, %d);">Upload</button>', $eventIDX;
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" style="width: 155px;" onclick="$(this).close();">Cancel</button>';
    $str .= '<div id="uploadedDisplay" class="w3-container w3-padding">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</form>';
    return ($str);
}
# =================== 2020 START ========================================
sub sae_openTeamPresoSchedule(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $todoType = $q->param('todoType');
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    my @MORNING = ('8:00', '8:30','9:00', '9:30','10:00', '10:30','11:00', '11:30');
    my @AFTERNOON = ('1:00', '1:30','2:00', '2:30','3:00', '3:30','4:00', '4:30');
    my $str;
    $str = '<div class="w3-row w3-round w3-border">';
    $str .= '<div class="w3-quarter">';
    $str .= '<h4 class="w3-margin-left">ROOM</h4>';
    foreach $txRoom (sort {$ROOMS{$a}{TX_ROOM} cmp $ROOMS{$b}{TX_ROOM}} keys %ROOMS){
        $roomIDX = $ROOMS{$txRoom}{PK_TODO_ROOM_IDX};
        $str .= '<div class="w3-margin-left"><input ID="ROOM_'.$roomIDX.'" class="w3-radio" type="radio" name="toDoRooms" value="'.$txRoom .'"><label FOR="ROOM_'.$roomIDX.'"class="w3-small">'.$txRoom.'</label></div>';
    }
    $str .= '<div class="w3-margin-left">';
    $str .= '<input ID="ROOM_0" class="w3-radio" type="radio" name="toDoRooms" value="0">';
    # $str .= '<label FOR="ROOM_'.$roomIDX.'"class="w3-small">'.$ROOMS{$roomIDX}{TX_ROOM}.'</label>';
    $str .= '<input type="text" placeHolder="Room Name" ID="ROOM_OTHER" onblur="selectOtherRoom();" style="width: 75%; border: none; border-bottom: 1px solid #ccc">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter">';
    $str .= '<h3> hh : mm</h3>';
    $str .= '<select ID="TIME_HOUR" class="w3-select w3-border w3-round w3-margin-right" style="width: 60px;">';
    for ($h=8; $h<=19;$h++){
        if ($h>12){
            $str .= sprintf '<option value="%02d">%02d</option>', ($h - 12), ($h - 12);
        } else {
            $str .= sprintf '<option value="%02d">%02d</option>', $h, $h;
        }
    }
    $str .= '</select>:';
    $str .= '<select ID="TIME_MIN" class="w3-select w3-border w3-round w3-margin-left" style="width: 60px;">';
    for ($m=0; $m<=55; $m +=5){
        $str .= sprintf '<option value="%02d">%02d</option>', $m, $m;
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter  w3-padding" style="text-align: right;">';
    $str .= '<button class="w3-hover-blue w3-small w3-button w3-border w3-round w3-margin-top w3-light-blue" style="width: 70px;" onclick="sae_setPresentationSchedule('.$todoType.', '.$teamIDX.',\''.$divName.'\')">Set</button>';
    $str .= '<button class="w3-hover-red w3-margin-left w3-small w3-button w3-border w3-round w3-margin-top" style="width: 70px;" onclick="$(\'#'.$divName.'\').remove()">Cancel</button>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_setPresentationSchedule(){
    print $q->header();
    my $todoType = $q->param('todoType');
    my $str;
    my $location = $q->param('location');
    my $teamIDX = $q->param('teamIDX');
    my $toDoRoom = $q->param('toDoRoom');
    my $toDoTime = $q->param('toDoTime');
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    if (!exists($ROOMS{$toDoRoom})) {
        $Preso->_addRoomTo_TODO_ROOM($toDoRoom, $location);
    }
    $Preso->_deleteSchedule($todoType, $teamIDX, $location);
    $todoIDX = $Preso->_setSchedule($todoType, $teamIDX, $location, $toDoRoom, $toDoTime);
    $str = '<a href="javascript:void(0);" onclick="sae_openTeamPresoSchedule('.$todoType.','.$teamIDX.','.$todoIDX.')">'.$toDoRoom.' ('.$toDoTime.')</a>';
    return ($str);
}
# 2020 IMPORT
sub sae_showImportSchedule(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<div>';
    $str .= '<form class="w3-card-2 w3-round-large w3-padding w3-panel" method="post" action="javascript:sae_importScheduleFile(\''.$divName.'\');" enctype="multipart/form-data">';
    $str .= '<input class="w3-file" type="file" name="csvFile" ID="csvFile" >';
    $str .= '<br><br>';
    $str .= '<input class="w3-margin-top w3-button w3-border w3-card-4 w3-round" type="submit" value="Import...">';
    $str .= '</form>';
    $str .= '<div ID="sae_results">';
    $str .= '</div>';
    $str .= '</div>';
    return($str);
}
sub sae_importScheduleFile(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $Ref = new SAE::REFERENCE();
    my $uploadDirectory = "/home/saestars/public_html/dev2/uploads";
    my $csv = Text::CSV->new( { sep_char => ",", binary => 1 , eol=> "\n", allow_loose_quotes => 1} ) or die "Cannot use CSV: ".Text::CSV->error_diag ();
    my $fileName = $q->param('csvFile');
    my $location = $q->param('location');
    my $file_handle = $q->upload('csvFile');   
    %TEAMS = %{$Ref->_getTeamDataLocation($location)};
    my $str;
    $str = "$uploadDirectory/$fileName";
    open ( UPLOADFILE, ">$uploadDirectory/$fileName" ) or die "$!"; binmode UPLOADFILE;
    while ( <$file_handle> ){
        print UPLOADFILE;
    }
    close UPLOADFILE;
    open $fh, '<', "$uploadDirectory/$fileName" or die "can't open csv ($uploadDirectory/$fileName) $!";
    my %DATA;
    my $counter=1;
    while ( my $row = $csv->getline( $fh ) ){
        $DATA{$counter}{IN_NUMBER}       = @$row[0];
        $teamIDX = $TEAMS{@$row[0]}{PK_TEAM_IDX};
        $DATA{$counter}{FK_TEAM_IDX}     = $teamIDX;
        $DATA{$counter}{TX_TIME}         = @$row[1];
        $DATA{$counter}{TX_ROOM}         = @$row[2];
        $counter++;
    }
    close $fh;
    # unlink "$uploadDirectory/$fileName";
    my $Preso = new SAE::PRESO();
    my %ROOMS = %{$Preso->_getPresoLocationList($location)};
    for ($i=2; $i<=scalar(keys %DATA); $i++){
        my $teamIDX = $DATA{$i}{FK_TEAM_IDX}; 
        my $toDoRoom = $DATA{$i}{TX_ROOM}; 
        my $toDoTime = $DATA{$i}{TX_TIME}; 
        if (!exists($ROOMS{$toDoRoom})) {
            $Preso->_addRoomTo_TODO_ROOM($toDoRoom, $location);
        }
        $Preso->_deleteSchedule(1, $teamIDX, $location);
        $todoIDX = $Preso->_setSchedule(1, $teamIDX, $location, $toDoRoom, $toDoTime);
    }
    return ($str)
}
# =================== 2020 END   ========================================
sub t_scorecard (){
    my ($teamIDX, $cardIDX, $score, $judgeName, $access, $marketing, $display, $time) = @_;
    my $str;
    $str .= '<div ID="SCORECARD_'.$cardIDX.'" class="w3-card-4 w3-margin-left w3-margin-bottom w3-white w3-display-container" style="width: 200px;">';
    $str .= sprintf '<header class="w3-container w3-light-grey">';
    $str .= sprintf '<h5 class="w3-left">%2.2f pts</h5>', $score;
    $str .= sprintf '</header>';
    my $spaces = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
    my $mStatus = $dStatus = $tStatus = 'w3-red';
    if ($marketing==100){$mStatus='w3-green'}
    if ($display==100){$dStatus='w3-green'}
    if ($time==100){$tStatus='w3-green'}
    $str .= '<div class="w3-display-topright w3-padding w3-tiny">';
    $str .= sprintf '<span class="w3-circle w3-border '.$mStatus.'" style="margin-left: 3px;">%s</span>', $spaces;
    $str .= sprintf '<span class="w3-circle w3-border '.$dStatus.'" style="margin-left: 3px;">%s</span>', $spaces;
    $str .= sprintf '<span class="w3-circle w3-border '.$tStatus.'" style="margin-left: 3px;">%s</span>', $spaces;
    $str .= '</div>';
    $str .= '<div class="w3-container w3-white" style="height: 43px; overflow-y: hidden">';
    $str .= sprintf '<span class="w3-small">Judged by:</span><br>%s', $judgeName;
    $str .= '</div>';
    if($access==1){
        $str .= sprintf '<button class="w3-button w3-block w3-dark-grey" style="position: relative; bottom: 0px;" onclick="sae_updateScoreCard(%d, %d);">Inspect</button>', $teamIDX, $cardIDX;
    }
    $str .= '</div>';

    return ($str);
    }
sub showListOfTeam_Preso_LEG(){
    print $q->header();
    # my $dbi = new SAE::Db();
    my $str;
    my $location  = $q->param('location');
    my $userIDX   = $q->param('userIDX');
    my $sortBy    = $q->param('sortBy');
    my $Team      = new SAE::TB_TEAM();
    my $Score     = new SAE::SCORE();
    my $Preso     = new SAE::PRESO();
    my %TEAM      = %{$Team->getAllRecordBy_FkEventIdx($location)};
    my %CARDS     = %{$Score->_getAllPresoScoreByEvent(5, $location)};
    my %SCORES    = %{$Score->_getAveragePresoScoreByEvent(5, $location)};
    my %ADMINS    = %{$Score->_getListOfAdmins()};
    my %TODO      = %{$Preso->_getToDo($location, 1)};
    my %ROOMS     = %{$Preso->_getRoomList($location)};
    my %OWNER     = %{$Score->_getCardOwner($location, 5)};
    my $str;
    $str = '<div class="w3-container w3-white w3-margin-top" style="padding-top: 15px;">';
    $str .= '<h2 class="w3-margin-top">Design & Technical Presentations</h2>';
    # $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left" onclick="sae_openImport(%d);">Import Excel Scoresheet</button>', $userIDX;
    # $str .= '<br>' x 2;
    $str .= '<div class="w3-container w3-margin-top  w3-card-4" style="padding:0px;">';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-margin-left w3-margin-top" onclick="sae_validatePreso(%d);">Expand Scorecard</button>', $location;
    $str .= '<table class="w3-table w3-bordered w3-border w3-margin-top" >';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th rowspan="2" style="vertical-align: bottom; width: 300px;">Teams</th>';
    $str .= '<th rowspan="2" style="vertical-align: bottom;">Score Card</th>';
    $str .= '<th colspan="5" class="w3-border-left w3-center w3-light-grey">Statistics</th>';
    $str .= '</tr>';
    $str .= '<tr style="width: 60px;" class="w3-white">';
    $str .= '<th style="width: 60px;" class="w3-small w3-center w3-border-left">High<br>Score</th>';
    $str .= '<th style="width: 60px;" class="w3-small w3-center">Low<br>Score</th>';
    $str .= '<th style="width: 60px;" class="w3-small w3-center">Std.<br>Dev</th>';
    $str .= '<th style="width: 60px;" class="w3-small w3-center">Coeff. of Var</th>';
    $str .= '<th style="width: 60px;" class="w3-small w3-center">Mean<br>(Avg.)</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=>$TEAM{$b}{IN_NUMBER}} keys %TEAM){
        my $txClass    = $CLASS{$TEAM{$teamIDX}{FK_CLASS_IDX}};
        my $txSchool   = $TEAM{$teamIDX}{TX_SCHOOL};
        my $inNumber   = $TEAM{$teamIDX}{IN_NUMBER};
        $str .= '<tr>';
        $str .= sprintf '<td><div class="w3-xlarge"><b>%03d</b></div>%s<br><b>Class:</b> <i class="w3-text-blue-grey">%s</i></td>', $inNumber, $txSchool, $txClass;
        $str .= '<td ID="TD_PRESOCARD_'.$teamIDX.'" style="vertical-align: top; display: flex; flex-wrap: wrap;">';
        foreach $cardIDX (sort {$CARDS{$teamIDX}{$a}{IN_POINTS} <=> $CARDS{$teamIDX}{$b}{IN_POINTS}} keys %{$CARDS{$teamIDX}}) {
            my %BIN   = %{$Preso->_getCardBinary($cardIDX)};
            my $myCardUserIDX = $OWNER{$cardIDX}{FK_USER_IDX};
            my $score = $CARDS{$teamIDX}{$cardIDX}{IN_POINTS};
            my $judgeName = sprintf '%s, %s', $CARDS{$teamIDX}{$cardIDX}{TX_LAST_NAME}, $CARDS{$teamIDX}{$cardIDX}{TX_FIRST_NAME};
            if (exists $ADMINS{$userIDX} || $myCardUserIDX == $userIDX) {
                $str .= &t_scorecard($teamIDX, $cardIDX, $score, $judgeName, 1, $BIN{91}{IN_VALUE}, $BIN{92}{IN_VALUE}, $BIN{93}{IN_VALUE});
            } else {
                $str .= &t_scorecard($teamIDX, $cardIDX, $score, $judgeName, 0, $BIN{91}{IN_VALUE}, $BIN{92}{IN_VALUE}, $BIN{93}{IN_VALUE});
            }
        }
        $str .= sprintf '<button class="w3-container w3-button w3-center w3-margin-left w3-light-grey" style="border: 3px dashed #ddd; width: 150px; height: 120px; background-color: #efefef" onclick="sae_openNewScoreCard(%d,%d);">', $teamIDX, 0;
        $str .= '<b class="w3-text-grey">Add Scorecard</b><br>';
        $str .= '<i class="fa fa-3x fa-plus w3-text-grey" aria-hidden="true"></i>';
        $str .= '</button>';
        $str .= '</td>';
        my $stdTextColor = 'w3-text-black';
        my $stdDev = $SCORES{$teamIDX}{IN_STD};
        if ($stdDev>12){
            $stdTextColor = 'w3-text-red';
            } elsif ($stdDev>7) {
                $stdTextColor = 'w3-text-yellow';
                } else {
                    $stdTextColor = 'w3-text-black';
                }
        $str .= sprintf '<td ID="TD_TEAM_MAX_SCORE_'.$teamIDX.'" class="w3-border-left " style="text-align: right;">%2.2f</td>', $SCORES{$teamIDX}{IN_MAX};
        $str .= sprintf '<td ID="TD_TEAM_MIN_SCORE_'.$teamIDX.'" class="" style="text-align: right;">%2.2f</td>', $SCORES{$teamIDX}{IN_MIN};
        $str .= sprintf '<td ID="TD_TEAM_STD_SCORE_'.$teamIDX.'" class="'.$stdTextColor.'" style="text-align: right;"><b>%2.2f</b></td>', $SCORES{$teamIDX}{IN_STD};
        if ($SCORES{$teamIDX}{IN_AVERAGE}!=0){
            $str .= sprintf '<td ID="TD_TEAM_CVAR_SCORE_'.$teamIDX.'" class="" style="text-align: right;">%2.2f</td>', $SCORES{$teamIDX}{IN_STD}/$SCORES{$teamIDX}{IN_AVERAGE};
        } else {
            $str .= sprintf '<td ID="TD_TEAM_CVAR_SCORE_'.$teamIDX.'" class="" style="text-align: right;">%2.2f</td>', 0;
        }
        $str .= sprintf '<td ID="TD_TEAM_AVERAGE_SCORE_'.$teamIDX.'" class="" style="text-align: right;"><b>%2.4f<b></td>', $SCORES{$teamIDX}{IN_AVERAGE};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_openNewScoreCard(){
    print $q->header();
    my $str;
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $eventIDX = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Teams = new SAE::TEAM();
    my $Preso = new SAE::PRESO();
    $Team->getRecordById($teamIDX);
    $teamTitle = substr("000".$Team->getInNumber(),-3,3).' - '.$Team->getTxSchool();
    my %LIST = %{$Teams->_getTeamList($eventIDX)};
    my $class = $Team->getFkClassIdx();
    my %PRESO = %{$Preso->_getPresentationQuestions(5)};
    my $divCounter = 0;
    my $tabIndex = 1;
    $str .= '<div class="w3-container w3-padding-bottom">';
    $str .= '<label class="w3-large" for="fkTeamIdx">Team: </label>';
    $str .= '<select ID="fkTeamIdx" class="w3-select w3-border w3-margin-bottom w3-large w3-pale-yellow">';
    foreach $fkTeamIDX (sort {$LIST{$a}{IN_NUMBER} <=> $LIST{$b}{IN_NUMBER}} keys %LIST) {
        my $selected = '';
        if ($fkTeamIDX == $teamIDX) {$selected = 'selected'}
        $str .= sprintf '<option %s value="%d">%03d - %s</option>', $selected, $fkTeamIDX, $LIST{$fkTeamIDX}{IN_NUMBER}, $LIST{$fkTeamIDX}{TX_SCHOOL};
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-border w3-hoverabl">';
    
    my $description = '';
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $description .= sprintf '<div ID="SUB_%d" class="w3-hide sae-preso-description w3-container" >',$subIDX;
        $description .= sprintf '<h4 style="padding: 0px; margin: 1px;"> %s</h4>', $PRESO{$subIDX}{TX_SUBSECTION};
        $description .= sprintf '<div class="w3-small">%s</div>',  $PRESO{$subIDX}{CL_DESCRIPTION};
        if($PRESO{$subIDX}{IN_TYPE}==0) {
            $description .= '<hr>';
            # $description .= sprintf '<h6>Comments:</h6>';
            $description .= sprintf '<textarea data-key="%d" class="w3-border w3-input inputComments w3-round  w3-pale-yellow" style="height: 175px; resize: vertical"  placeholder="Judge\'s Comments"></textarea>', $subIDX;
        }
        $description .= '</div>';
    }
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $str .= sprintf '<tr class="" data-key="%d" >', $subIDX;
            $str .= sprintf '<td class="w3-display-container" style="width: 40%; padding: 0px;" onclick="sae_showDescription(this, %d);">', $subIDX;
            $str .= sprintf '<label class="w3-padding" for="">%s - %s</label>',$PRESO{$subIDX}{IN_SUBSECTION},$PRESO{$subIDX}{TX_SUBSECTION};
            
            $str .= '</td>';
            $str .= '<td style="width: 10%; padding: 0px;">';
            if ($PRESO{$subIDX}{IN_TYPE}==0) {
                
                $str .= sprintf '<input class="w3-input w3-border w3-right inputNumber" data-key="%d" tabindex="%d" type="number" max="10" min="0" step="0.1" placeholder="0.0" onfocus="sae_showDescription(this, %d);" onblur="sae_processValue(this);"> ', $subIDX, $tabIndex++, $subIDX;
            } else {
                $str .= sprintf '<input data-key="%d" tabindex="%d" ', $subIDX, $tabIndex++;
                $str .= sprintf 'type="checkbox" class="w3-check w3-border inputBinary" value="100" onfocus="sae_showDescription(this, %d);"> Yes', $subIDX;
            }
            
            $str .= '</td>';
            $str .= '<td class="w3-display-container w3-white" style="width: 10px;">';
            $str .= sprintf '<i ID="CHEVERON_%d" class="fa fa-chevron-right w3-display-right w3-hide sae-preso-description" aria-hidden="true"></i>', $subIDX;
            $str .= '</td>';
            if ($divCounter==0){
                $divCounter++;
                $str .= sprintf '<td class="w3-border-left" rowspan="%d"  style="width: 50%">', $subIDX, scalar(keys %PRESO);
                $str .= $description;
                $str .= '</td>';
            }
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<div class="w3-display-container w3-panel" style="text-align: center;">';
    # $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green" onclick="sae_savePresentationScores(this, %d, %d, %d);">Record & Exit</button>', $teamIDX, 1, 0;
    $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green" onclick="sae_savePresentationScores(this, %d, %d);">Record & Exit</button>', 1, 0;
    # $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-green" onclick="sae_savePresentationScores('.$teamIDX.',0,0,\''.$divName .'\');">Save & Add Another</button>';
    $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-red " onclick="$(this).close();">Exit</button>';
    $str .= '</div>';
    return ($str);
    }
sub sae_updateScoreCard(){
    print $q->header();
    my $str;
    my $teamIDX = $q->param('teamIDX');
    my $divName = $q->param('divName');
    my $cardIDX = $q->param('cardIDX');
    my $eventIDX = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Preso = new SAE::PRESO();
    my $Teams = new SAE::TEAM();
    $Team->getRecordById($teamIDX);
    $teamTitle = substr("000".$Team->getInNumber(),-3,3).' - '.$Team->getTxSchool();
    my $class = $Team->getFkClassIdx();
    my %LIST = %{$Teams->_getTeamList($eventIDX)};
    my %PRESO = %{$Preso->_getPresentationQuestions(5)};
    my %VALUE = %{$Preso->_getCardScores($cardIDX)};
    my %COMMENTS = %{$Preso->_getPresoComments($cardIDX)};
    my $Util = new SAE::Common();

    my $divCounter = 0;
    my $tabIndex = 1;
    $str .= '<div class="w3-container w3-padding-bottom">';
    $str .= '<label class="w3-large" for="fkTeamIdx">Team: </label>';
    $str .= '<select ID="fkTeamIdx" class="w3-select w3-border w3-margin-bottom w3-large w3-pale-yellow">';
    foreach $fkTeamIDX (sort {$LIST{$a}{IN_NUMBER} <=> $LIST{$b}{IN_NUMBER}} keys %LIST) {
        my $selected = '';
        if ($fkTeamIDX == $teamIDX) {$selected = 'selected'}
        $str .= sprintf '<option %s value="%d">%03d - %s</option>', $selected, $fkTeamIDX, $LIST{$fkTeamIDX}{IN_NUMBER}, $LIST{$fkTeamIDX}{TX_SCHOOL};
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<table class="w3-table-all w3-border w3-hoverabl">';
    my $description = '';
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $description .= sprintf '<div ID="SUB_%d" class="w3-hide sae-preso-description w3-container" >',$subIDX;
        $description .= sprintf '<h4 style="padding: 0px; margin: 1px;"> %s</h4>', $PRESO{$subIDX}{TX_SUBSECTION};
        $description .= sprintf '<div class="w3-small">%s</div>',  $PRESO{$subIDX}{CL_DESCRIPTION};
        if ($PRESO{$subIDX}{IN_TYPE}==0) {
            my $comment = $Util->removeBr( $COMMENTS{$subIDX}{CL_COMMENT} );
            $description .= '<hr>';
            $description .= sprintf '<textarea data-key="%d" class="w3-border w3-input inputComments w3-round w3-pale-yellow" style="height: 175px; resize: vertical"  placeholder="Judge\'s Comments">%s</textarea>', $subIDX, $comment;
        }
        $description .= '</div>';
    }
    foreach $subIDX (sort {$PRESO{$a}{IN_SUBSECTION} <=> $PRESO{$b}{IN_SUBSECTION}} keys %PRESO) {
        $str .= sprintf '<tr class="" data-key="%d" >', $subIDX;
            $str .= sprintf '<td style="width: 40%; padding: 0px;" onclick="sae_showDescription(this, %d);">', $subIDX;
            $str .= sprintf '<label class="w3-padding" for="">%s - %s</label>',$PRESO{$subIDX}{IN_SUBSECTION},$PRESO{$subIDX}{TX_SUBSECTION};
            $str .= '</td>';
            $str .= '<td style="width: 10%; padding: 0px;">';
            if ($PRESO{$subIDX}{IN_TYPE}==0) {
                $str .= sprintf '<input class="w3-input w3-border w3-right inputNumber" data-key="%d" tabindex="%d" type="number" max="10" min="0" step="0.1" placeholder="0.0" onfocus="sae_showDescription(this, %d);" onblur="sae_processValue(this);" value="%2.1f"> ', $subIDX, $tabIndex++, $subIDX, ($VALUE{$subIDX}{IN_VALUE} / 10);
            } else {
                $checked = "";
            if ($VALUE{$subIDX}{IN_VALUE} >0){$checked = " checked "}
                $str .= sprintf '<input data-key="%d" tabindex="%d" %s ', $subIDX, $tabIndex++, $checked;
                $str .= sprintf 'type="checkbox" class="w3-check w3-border inputBinary" value="100" onfocus="sae_showDescription(this, %d);"> Yes', $subIDX;
            }
            $str .= '</td>';
            $str .= '<td class="w3-display-container w3-white" style="width: 10px;">';
            $str .= sprintf '<i ID="CHEVERON_%d" class="fa fa-chevron-right w3-display-right w3-hide sae-preso-description" aria-hidden="true"></i>', $subIDX;
            $str .= '</td>';
            if ($divCounter==0){
                $divCounter++;
                $str .= sprintf '<td class="w3-border-left" rowspan="%d"  style="width: 50%">', $subIDX, scalar(keys %PRESO);
                $str .= $description;
                $str .= '</td>';
            }
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<div class="w3-display-container w3-panel" style="text-align: center;">';
    # $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green w3-round" onclick="sae_savePresentationScores(this, '.$teamIDX.',1,'.$cardIDX.');">Update</button>';
    $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-green"          onclick="sae_savePresentationScores(this, %d, %d);">Update & Exit</button>', 1, $cardIDX;
    $str .= sprintf '<button class="w3-button w3-border w3-display-center w3-hover-red w3-round  w3-margin-left " onclick="sae_deleteScore(this, %d);">Delete</button>', $cardIDX;
    # $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-green" onclick="sae_savePresentationScores('.$teamIDX.',0,0,\''.$divName .'\');">Save & Add Another</button>';
    $str .= '<button class="w3-button w3-border w3-margin-left w3-hover-red " onclick="$(this).close();">Exit</button>';
    $str .= '</div>';
    
    return ($str);
 }
sub _tempLink(){
    my $str;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $score = shift;
    my $initals = shift;
    my $edit = shift;
    my $str;
    if ($edit==1) {
        $str .= sprintf '<button class="w3-button w3-white w3-padding-small w3-border w3-round w3-card-2 w3-margin-right w3-leftbar w3-border-blue w3-hover-blue" style="width: 150px;" onclick="sae_updateScoreCard(%d, %d);">', $teamIDX, $cardIDX;
    } else {
        $str .= sprintf '<button class="w3-white w3-padding-small w3-border w3-round w3-card-2 w3-margin-right" style="width: 150px;">', $teamIDX, $cardIDX;
    }
    $str .= sprintf '%2.4f<br><span class="w3-small">(%s)</span>', $score, $initals;
    $str .= '</button>';
    # $str = '<a ID="A_CARDIDX_'.$cardIDX.'" class="w3-margin-left w3-text-blue-grey w3-border w3-padding-small w3-round w3-card-2';
    # if ($edit > 0 ){
    #     $str .= ' w3-leftbar w3-border-blue w3-hover-text-blue"';
    # } else {
    #     $str .= '" style="text-decoration: none;"';
    # }

    # $str .= ' onclick="sae_updateScoreCard('.$teamIDX.','.$cardIDX.');" ';
    # $str .= sprintf ' href="javascript:void(0);" >%2.4f <br>(%s)</a>', $score, $initals;
    # $str .= sprintf ' href="javascript:void(0);" >%s:%2.4f</a>', $initals, $score;
    return ($str);
    }
sub sae_savePresentationScores(){
    print $q->header();
    my $Preso = new SAE::PRESO();
    my $Score = new SAE::SCORE();
    my $User  = new SAE::USER();
    my $teamIDX = $q->param('teamIDX');
    my $userIDX = $q->param('userIDX');
    my $location = $q->param('location');
    my $cardTypeIDX = 5;                              # 5 = presentations;
    my $cardIDX = $q->param('cardIDX');
    my %COMMENTS = %{decode_json($q->param('jsonComment'))};
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $str = "Start of Script: CardIDX = ".$cardIDX;
        if ($cardIDX == 0){
        # $str .= "Inside of 0\n $userIDX, $teamIDX, $cardTypeIDX, $location \n";
        $cardIDX=$Preso->_addPresentationScoreCard($userIDX, $teamIDX, $cardTypeIDX, $location);
        $Preso->_saveAssessments($cardIDX, \%DATA);
        $Preso->_saveComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    } else {
        # $str .= "Perform Update\n";
        $Preso->_updateAssessment($cardIDX, \%DATA);
        $Preso->_resetComments($cardIDX);
        $Preso->_saveComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
        # $Preso->_updateComment($cardIDX, $teamIDX, $userIDX, \%COMMENTS);
    }
    $Preso->_updatePresoToDo($teamIDX, $location, 1, "Completed");
    my %CARDS     = %{$Score->_getAllPresoScoreByEvent(5, $location)};
    my %SCORES    = %{$Score->_getAveragePresoScoreByEvent(5, $location)};
    my $txInitials = $Score->_getUserInitials($userIDX);
    my %USER       = %{$User->_getUserDetails($userIDX)};
    my $judgeName  = sprintf '%s, %s',$USER{TX_LAST_NAME},$USER{TX_FIRST_NAME};
    my $score      = $CARDS{$teamIDX}{$cardIDX}{IN_POINTS};
    my ( $presoScore ) = $Score->_getPresenationScoreByCard($cardIDX);
    # $str = &_tempLink($teamIDX, $cardIDX, $presoScore, $txInitials, 1);
    my %BIN   = %{$Preso->_getCardBinary($cardIDX)};
    my %DATA;
    $DATA{HTML}    = $str;
    $DATA{AVERAGE} = sprintf "%2.4f", $SCORES{$teamIDX}{IN_AVERAGE};
    # $DATA{AVERAGE} = sprintf "%2.2f", $Score->_getAllPresoScoreByTeamIDX($teamIDX, 5, $location);
    $DATA{CARD}    = &t_scorecard($teamIDX, $cardIDX, $score, $judgeName, 1, $BIN{91}{IN_VALUE}, $BIN{92}{IN_VALUE}, $BIN{93}{IN_VALUE});
    $DATA{MAX}     = sprintf '%2.2f', $SCORES{$teamIDX}{IN_MAX};
    $DATA{MIN}     = sprintf '%2.2f', $SCORES{$teamIDX}{IN_MIN};
    if ($SCORES{$teamIDX}{IN_STD}>12) {
        $DATA{STD}     = sprintf '<span class="w3-text-red"><b>%2.2f</b></span>', $SCORES{$teamIDX}{IN_STD};
        } elsif ($SCORES{$teamIDX}{IN_STD}>7) {
            $DATA{STD}     = sprintf '<span class="w3-text-yellow"><b>%2.2f</b></span>', $SCORES{$teamIDX}{IN_STD};
            } else {
                $DATA{STD}     = sprintf '<span class="w3-text-black"><b>%2.2f</b></span>', $SCORES{$teamIDX}{IN_STD};
            }
    
    if ($DATA{AVERAGE}!=0){
        $DATA{COE} = sprintf '%2.2f', $SCORES{$teamIDX}{IN_STD}/ $SCORES{$teamIDX}{IN_AVERAGE};
        } else {
        $DATA{COE} = 0;
        }
    my $json = encode_json \%DATA;
    return ($json);
    # return ($str);
}
sub sae_deleteScore(){
    print $q->header();
    my $cardIDX = $q->param('cardIDX');
    my $teamIDX = $q->param('teamIDX');
    my $location = $q->param('location');
    my $Preso = new SAE::PRESO();
    my $Score = new SAE::SCORE();
    $Preso->_deletePresoScoreCard($cardIDX);
    $Preso->_deletePresoScoreCard_Paper($cardIDX);
    $score = sprintf "%2.4f", $Score->_getAllPresoScoreByTeamIDX($teamIDX, 5, $location);
    %CARDS = %{$Preso->_getScoreCardsByTeam($teamIDX)};
    my $count = scalar(keys %CARDS);
    if ($count > 0){
        $Preso->_updatePresoToDo($teamIDX, $location, 1, "Completed");
    } else {
        $Preso->_updatePresoToDo($teamIDX, $location, 1, "To Do");
    }
    return ($score);
}
# ============= 2018 ===============================

