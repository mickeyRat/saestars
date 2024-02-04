#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Common;
use SAE::Auth;
use SAE::AUTO;
use SAE::REPORTS;
use SAE::REFERENCE;
use SAE::RUBRIC;
use SAE::GRADE;
use SAE::USER;
use SAE::JSONDB;
use SAE::PAPER;
use SAE::TABLE;
use SAE::TEAM;
my $Util = new SAE::Common();

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my %BTN_STATUS  = (0=>'Start', 1=>'Continue', 2=>'Completed');
my %BTN_COLOR   = (0=>'w3-white', 1=>'w3-yellow', 2=>'w3-pale-blue');

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
# ===============2024 =====================================================
sub grade_subimtAssessment {
    print $q->header();
    my $cardIDX     = $q->param('cardIDX');
    my $txType      = $q->param('txType');
    my $teamIDX     = $q->param('teamIDX');
    my $inStatus    = $q->param('inStatus');
    my %CONDITION   = ('PK_CARD_IDX'=>$cardIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my %DATA        = %{decode_json($q->param('jsonData'))};
    my $Table       = new SAE::TABLE();
       $Table->_save('TB_CARD', $q->param('jsonData'), $json_dcondition);

    my $Grade = new SAE::GRADE();
    my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $teamIDX );
    
    my $Paper = new SAE::PAPER();
    my %STATS       = %{$Paper->_getTeamAssessmentStatistics($teamIDX)};
    $STATS{'LABEL'} = $BTN_STATUS{$inStatus};
    $STATS{'COLOR'} = $BTN_COLOR{$inStatus};
    $STATS{'SCORE'} = $score;
    # my %RTN = ('LABEL'=>$BTN_STATUS{$DATA{IN_STATUS}}, 'COLOR'=>$BTN_COLOR{$DATA{IN_STATUS}}, 'SCORE'=>$score);
    my $json = encode_json \%STATS;
    return ($json);
    # return ($json_dcondition." ".$q->param('jsonData'));
    }
sub grade_instructions(){
    print $q->header();
    my $txFirstName = $q->param('txFirstName');
    my $str = '<div class="w3-container" style="height: 500px; overflow-y: auto;">';
    $str .= '<img src="../images/Assessment.png" width="500"><label>Figure 1: Grading Scale</label>';
    $str .= '<div class="w3-container">';
    $str .= 'Each section is evaluated on a scale from <b>1 to 10</b> and is divided into four categories';
    $str .= '<ul class="w3-margin-left"><li>Poor</li><li>Average</li><li>Excellent</li><li>Perfect</li></ul></b> 
    <p>Under each category, you can further differenciate the points earned by selecting the appropriate assessments of either <b>Low, Medium, or High</b>.</p>
    <div class="w3-container w3-border w3-padding w3-round">
    <h4>Example</h4>
    <ul> <b class="w3-text-red">Poor (1, 2, 3)</b>
    <li>If you give a rating of poor, was it low poor, medium poor, or on the high end of poor)</li>
    </ul>
    <ul> <b class="w3-text-orange">Average (4, 5, 6)</b>
    <li>If you give a rating of Average, was it on the low end of Average, Really Average, or on the high end of Average)</li>
    </ul>
    <ul> <b class="w3-text-green">Excellent (7, 8, 9)</b>
    <li>If you give a rating of Excellent, was it on the low end of Excellent, Excellent, or on the high end of Excellent)</li>
    </ul>
    <ul> <b class="w3-text-purple">Perfect (10)</b>
    <li>If you give a rating of Perfect, the team has provided <b>ALL</b> information to demonstate FULL knowledge, understanding, and readiness for the section</li>
    </ul>
    </div>
    <br><p>For scores of 5 or below, it is requested that you provide feedback to the team to improve future events.</p><hr>
    <p>1. Use the double Arrows in each section to expand the grading criteria.</p>
    <p>2. Teal colored Section indicate the section has received a score and has been successfully saved to the Database(See Figure 2)</p>';
    $str .= '</div>';
    $str .= '<img src="../images/screen1.png" width="700"><label>Figure 2</label>';
    $str .= '</div>';
    return ($str);
    }
sub grade_viewMetrics {
    print $q->header();
    my $Grade         = new SAE::GRADE();
    my $reportIDX     = $q->param('reportIDX');
    my $userIDX       = $q->param('userIDX');
    my $teamIDX       = $q->param('teamIDX');
    my $cardTypeIDX   = $q->param('cardTypeIDX');
    my %METRIC        = %{$Grade->_getSectionMetric($reportIDX, $cardTypeIDX)};
    my %STATUS        = (0=>'Draft', 1=>'Draft', 2=>'Submitted');
    # print join(", ", keys %{$METRIC{901}});
    my $str;
    $str .= '<div class="w3-container">';
    my @EVENT_SCORES = ();
    my @TEAM_SCORES = ();
    foreach $scoreTeamIDX (sort keys %METRIC){
        foreach $reportIDX (sort keys %{$METRIC{$scoreTeamIDX}}) {
            my $inValue = $METRIC{$scoreTeamIDX}{$reportIDX}{IN_VALUE};
            my $metricUserIDX = $METRIC{$scoreTeamIDX}{$reportIDX}{FK_USER_IDX};
            push(@EVENT_SCORES, $inValue);
            if ($scoreTeamIDX == $teamIDX) {
                push(@TEAM_SCORES, $inValue);
                my $bgColor = "w3-red";
                if ($inValue>3){$bgColor  = "w3-yellow"}
                if ($inValue>6){$bgColor  = "w3-green"}
                if ($inValue>9){$bgColor  = "w3-blue"}
                if ($metricUserIDX == $userIDX) {
                        $str .= sprintf '<label>You (<i class="w3-small">%s</i>)</label>', $STATUS{$METRIC{$scoreTeamIDX}{$reportIDX}{IN_STATUS}};
                    } else {
                        $str .= sprintf '<label>%s %s (<i class="w3-small">%s</i>)</label>', $METRIC{$scoreTeamIDX}{$reportIDX}{TX_FIRST_NAME}, $METRIC{$scoreTeamIDX}{$reportIDX}{TX_LAST_NAME}, $STATUS{$METRIC{$scoreTeamIDX}{$reportIDX}{IN_STATUS}};
                    }
                $str .= '<div class="w3-light-grey">';
                $str .= sprintf '<div class="w3-container %s w3-center" style="width:%d%">%d</div>', $bgColor, ($inValue/10)*100, $inValue;
                $str .= '</div>';
            }
        }
    }
    $str .= '<hr>';
    my $teamAverage = mean(@TEAM_SCORES);
    my $teamBgColor = "w3-red";
    if ($teamAverage>3){$teamBgColor  = "w3-yellow"}
    if ($teamAverage>6){$teamBgColor  = "w3-green"}
    if ($teamAverage>9){$teamBgColor  = "w3-blue"}


    $str .= sprintf '<label>Team Average</label>';
    $str .= '<div class="w3-light-grey">';
    $str .= sprintf '<div class="w3-container %s w3-center" style="width:%d%">%2.2f</div>', $teamBgColor, ($teamAverage/10)*100, $teamAverage;
    $str .= '</div>';

    my $eventAverage = mean(@EVENT_SCORES);
    my $eventBgColor = "w3-red";
    if ($eventAverage>3){$eventBgColor  = "w3-yellow"}
    if ($eventAverage>6){$eventBgColor  = "w3-green"}
    if ($eventAverage>9){$eventBgColor  = "w3-blue"}
    $str .= sprintf '<label>Event Average</label>';
    $str .= '<div class="w3-light-grey">';
    $str .= sprintf '<div class="w3-container %s w3-center" style="width:%d%">%2.2f</div>', $eventBgColor, ($eventAverage/10)*100, $eventAverage ;
    $str .= '</div>';

    
    $str .= '</div>';

    return ($str);
    }
sub grade_viewOtherFeedback {
    print $q->header();
    my $Grade     = new SAE::GRADE();
    my $teamIDX   = $q->param('teamIDX');
    my $reportIDX = $q->param('reportIDX');
    my $userIDX   = $q->param('userIDX');
    my %FEEDBACK  = %{$Grade->_getFeedback($teamIDX, $reportIDX)};
    my $str;
    my $feedbackCount = 0;
    $str .= '<div class="w3-container w3-padding" style="height: 500px; overflow-y: auto;">';
    foreach $paperIDX (sort {$b <=> $a} keys %FEEDBACK) {
        my $txStatus = "Draft";
        if ($FEEDBACK{$paperIDX}{IN_STATUS}==2) {$txStatus = "Submitted"}
        if ($FEEDBACK{$paperIDX}{CL_FEEDBACK}){
            $feedbackCount = 1;
            my $feedbackUserIDX = $FEEDBACK{$paperIDX}{FK_USER_IDX};
            $str .= '<div class="w3-container w3-border w3-margin-top w3-round-large w3-pale-yellow w3-card-2">';
            if ($feedbackUserIDX == $userIDX){
                    $str .= sprintf '<i class="w3-small">You (%s)</i> <br>', $txStatus;
                } else {
                    $str .= sprintf '<i class="w3-small">%s %s (%s)</i> <br>', $FEEDBACK{$paperIDX}{TX_FIRST_NAME}, $FEEDBACK{$paperIDX}{TX_LAST_NAME}, $txStatus;
                }
            $str .= sprintf '%s', $FEEDBACK{$paperIDX}{CL_FEEDBACK};
            $str .= '</div>';

        }
    }
    if ($feedbackCount == 0){
        $str .= '<div class="w3-container w3-border w3-margin-top w3-round-large w3-pale-yellow w3-card-2"><i class="fa fa-android fa-3x" aria-hidden="true"></i><p>No Feedback provided at this time.</p></div>';
    }
    $str .= '</div>';
    return ($str);
    }
sub grade_openTemplateList (){
    my $userIDX      = $q->param('userIDX');
    my $inSection    = $q->param('inSection');
    my $inSubSection = $q->param('inSubSection');
    my $Paper        = new SAE::REPORTS();
    print $q->header();
    my %TEMPS = %{$Paper->_getMyTemplates($userIDX)};

    my $str;
    $str .= '<div class="w3-container w3-row w3-light-grey">';
    $str .= '<div class="w3-row w3-white">';
    $str .= '<div class="w3-half w3-container w3-border" style="height: 500px; overflow-y: scroll; padding: 0px; margin: 0px; border-style: inset;">';
    $str .= '<ul class="w3-ul w3-border" style="">';
    foreach $tempIDX (sort {lc($TEMPS{$a}{TX_TITLE}) cmp lc($TEMPS{$b}{TX_TITLE})} keys %TEMPS) {
        my $comments = $TEMPS{$tempIDX}{CL_COMMENT};
        $comments =~ s/\n/<br>\n/g;
        $str .= '<li ID="template_'.$tempIDX.'" class="w3-bar w3-white w3-round w3-hover-pale-yellow" style="padding: 0px; margin: 0px;">';
        $str .= '<div class="w3-bar-item w3-right">';
        $str .= sprintf '<i class="fa fa-download w3-white w3-button w3-hover-blue w3-round w3-border" data-value="%s" aria-hidden="true" onclick="grade_loadTemplate(this, %d, %d, %d);"></i>', $comments, $tempIDX, $inSection, $inSubSection;
        $str .= sprintf '<i class="fa fa-eye w3-button w3-white w3-hover-green w3-round w3-border" data-value="%s" aria-hidden="true" onclick="grade_previewTemplate(this, %d);"></i>', $comments, $tempIDX ;
        $str .= sprintf '<i class="fa fa-trash w3-button w3-white w3-hover-red w3-round w3-border" aria-hidden="true" onclick="grade_deleteTemplate(this, %d);"></i>', $tempIDX;
        $str .= '</div>';
        $str .= '<div class="w3-bar-item" style="padding: 5px 12px !important; width: 60%; margin-top: 9px;">';
        $str .= sprintf '<a class="w3-text-black" href="javascript:void(0);" style="text-decoration: none" data-value="%s" onclick="grade_previewTemplate(this, %d);">%s</a>', $comments, $tempIDX, $TEMPS{$tempIDX}{TX_TITLE};
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '<div class="w3-half w3-container" style="height: 500px; overflow-y: auto;">';
    $str .= '<h3>Preview</h3>';
    $str .= '<div ID="templatePreview" class="w3-container">';
    $str .= '...';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<br>'x2;
    $str .= '</div>';
    return ($str);
    }
sub grade_saveTemplate (){
    my $eventIDX= $q->param('eventIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_insert('TB_TEMPLATE', \%DATA);
    # my $str = &t_commentBlocks($newIDX, $DATA{CL_COMMENT}, $DATA{FK_USER_IDX}, $DATA{FK_USER_IDX}, 'Just Now');
    return ($str);
    }
sub grade_deleteTemplate (){
    my $tempIDX= $q->param('tempIDX');
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $str = $JsonDB->_delete('TB_TEMPLATE', qq(PK_TEMPLATE_IDX=$tempIDX));
    return ($str);
    }
sub grade_openTemplate (){
    print $q->header();
    my $userIDX       = $q->param('userIDX');
    my $inSection     = $q->param('inSection');
    my $inSubSection  = $q->param('inSubSection');
    my $txTitle       = $q->param('txTitle');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    my $placeholder = sprintf "%d: %d.%d-%s", $userIDX , $inSection, $inSubSection, $txTitle;
    $str .= '<div class="w3-container w3-card w3-border w3-round">';
    $str .= sprintf '<input ID="templateTitle" type="text" class="w3-input w3-border w3-round w3-margin-top" value="%s">',  $placeholder;
    $str .= sprintf '<textarea rows="10" ID="templateComment" class="w3-margin-top w3-input w3-border w3-border-black w3-round" style="min-width: 100%">%s</textarea>', $DATA{CL_COMMENT};
    $str .= '<div class="w3-container w3-center">';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-green w3-hover-green w3-margin-top w3-card" onclick="grade_saveTemplate(this)">SAVE</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-red w3-hover-red w3-margin-top w3-margin-left" onclick="$(this).close(\'sae-top2\');">Cancel</button>';
    $str .= '</div>';
    $str .= '<br>';
    $str .= '</div>';
    return ($str);
    }
sub grade_saveSectionScore {
    print $q->header();
    my $paperIDX         = $q->param('paperIDX');
    my $cardIDX          = $q->param('cardIDX');
    my $txType           = $q->param('txType');
    my $teamIDX          = $q->param('teamIDX');
    my %CONDITION        = ('PK_PAPER_IDX'=>$paperIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table            = new SAE::TABLE();
       $Table->_save('TB_PAPER', $q->param('jsonData'), $json_dcondition);
    my $Grade            = new SAE::GRADE();
    my $Paper            = new SAE::PAPER();
    my $score            = $Grade->_getAssessmentScore_byCard($cardIDX, $teamIDX);
    my %STATS            = %{$Paper->_getTeamAssessmentStatistics($teamIDX)};
    $STATS{'LABEL'}      = $BTN_STATUS{1};
    $STATS{'COLOR'}      = $BTN_COLOR{1};
    $STATS{'SCORE'}      = $score;
    my $json = encode_json \%STATS;
    return ($json);
    # return($score);
    }
sub grade_saveSectionFeedback {
    print $q->header();
    my $paperIDX    = $q->param('paperIDX');
    my %CONDITION   = ('PK_PAPER_IDX'=>$paperIDX);
    my $json_dcondition  = encode_json \%CONDITION;
    my $Table       = new SAE::TABLE();
       $Table->_save('TB_PAPER', $q->param('jsonData'), $json_dcondition);
    return("Saved");
    }
sub grade_openAssessment(){
    print $q->header();
    my $classIDX   = $q->param('classIDX');
    my $cardIDX    = $q->param('cardIDX');
    my $teamIDX    = $q->param('teamIDX');
    my $inCardType = $q->param('inCardType');
    my %TYPE       = (1=>'Assessment',2=>'TDS',3=>'Drawing',4=>'Requirement');
    my $txType     = $TYPE{$inCardType};
    my $Report     = new SAE::GRADE();
    my $Team       = new SAE::TEAM();
    my %DOCS       = %{$Team->_getTeamDocuments($teamIDX)};
    my %RUBRIC     = %{$Report->_getReportRubric($txType, $classIDX)};
    my %SCORE      = %{$Report->_getReportScores($cardIDX, $txType, $classIDX)};
    my $str;
    $str .= '<div class="w3-container w3-light-grey">';
    
    $str .= '<div class="w3-container w3-margin-bottom w3-light-grey">';
    $str .= '<div class="w3-bar w3-border w3-light-grey w3-border-grey w3-margin-top">';
    $str .= '<button class="w3-bar-item w3-button " onclick="grade_instructions();">Instructions</button>';
    if ($DOCS{$inCardType}{TX_KEYS}){
        $str .=  sprintf '<a href="read.html?fileID=%s" target="_blank" class="w3-bar-item w3-button w3-text-black"><i class="fa fa-download" aria-hidden="true"></i> Download</a>', $DOCS{$inCardType}{TX_KEYS};
    }
    $str .=  sprintf '<button class="w3-bar-item w3-button " onclick="grade_subimtAssessment(this, %d, %d, %d, \'%s\');">Save as Draft</button>', $cardIDX, 1, $teamIDX, $txType;
    $str .=  sprintf '<button class="w3-bar-item w3-button " onclick="grade_subimtAssessment(this, %d, %d, %d, \'%s\');">Save as Final</button>', $cardIDX, 2, $teamIDX, $txType;
    if ($inCardType!=1){
        $str .= '<div class="w3-display-container" >';
        $str .= '<span class="w3-right">Select All ';
        $str .= sprintf '<input class="w3-check w3-margin-right w3-margin-left" type="checkbox" onclick="selectAllCheckBox(this, \'%s\', %d, \'%s\', %d);"><span>', 'binary_check', $cardIDX, $txType, $teamIDX ;
        $str .= '</div>';
    }
    $str .= '</div>';
    $str .= '<h3>Assessment</h3>';
    foreach $section (sort {$a <=> $b} keys %RUBRIC) {
        foreach $subSection (sort {$a <=> $b} keys %{$RUBRIC{$section}}){
            my $pk_report_idx   = $RUBRIC{$section}{$subSection}{PK_REPORT_IDX};
            my $divName         = sprintf "%d_%d", $section,$subSection;
            my $paperIDX        = $SCORE{$pk_report_idx}{PK_PAPER_IDX};
            my $feedback        = $SCORE{$pk_report_idx}{CL_FEEDBACK};
            my $inScore         = $SCORE{$pk_report_idx}{IN_VALUE};
            my $subSectionTitle = $RUBRIC{$section}{$subSection}{TX_SUB};
            my $valueType       = $RUBRIC{$section}{$subSection}{BO_BIN};
            my $sectionColor    = 'w3-teal';
            if ($inScore==0){$sectionColor  = 'w3-light-grey '}
            my %LABEL      = (1=>'Poor: Low',2=>'Poor: Medium',3=>'Poor: High',4=>'Average: Low',5=>'Average: Medium',6=>'Average: High',7=>'Excellent: Low',8=>'Excellent: Medium',9=>'Excellent: High',10=>'Perfect');

            $str .= sprintf '<div ID="SECTION_%d_%d" class="%s w3-row w3-border w3-round-large w3-button w3-block w3-left-align w3-hover-light-blue" style="margin: 2px 0px;">', $section, $subSection, $sectionColor;;
            $str .= sprintf '<div class="w3-col l6" onclick="grade_expandRubric(\'%d_%d\')" >', $section, $subSection; # Section Heading
            $str .= sprintf '<i id="arrow_%s" class="fa fa-angle-double-right w3-margin-right w3-xlarge" aria-hidden="true" ></i>', $divName;
            $str .= sprintf '<span style="white-space: pre-wrap;"><b>%d.%d </b>- (%s) - <i>%s</i></span>', $section,$subSection, $RUBRIC{$section}{$subSection}{TX_SEC}, $RUBRIC{$section}{$subSection}{TX_SUB};
            $str .= sprintf '</div>';
            if ($valueType==0){
                $str .= sprintf '<div class="w3-col l6 w3-row">'; # Grading Scale
                for ($i=10; $i>=1; $i--){
                    my $selected = '';
                    if ($inScore == $i) {$selected = 'checked'}
                    my $bgColor = 'w3-pale-red';
                    if ($i>3) {$bgColor = 'w3-yellow';}
                    if ($i>6) {$bgColor = 'w3-pale-green';}
                    if ($i>9) {$bgColor = 'w3-blue';}
                    $str .= sprintf '<div class="w3-cell w3-mobile %s w3-border w3-right" style="white-space: nowrap; padding: 2px 4px;">', $bgColor;
                    $str .= sprintf '<input %s class="w3-radio" type="radio" value="%d" name="%s" onClick="grade_breakingScoringThreshold(%d, \'%s\',this.value, %d, %d, %d, %d, \'%s\');" >', $selected, $i, $divName, $paperIDX, $divName, $section, $subSection, $cardIDX, $txType, $teamIDX;
                    $str .= sprintf '<span> %d </span><span class="w3-small w3-hide-large w3-hide-medium"> %s</span>', $i, $LABEL{$i};
                    $str .= sprintf '</div>';
                }
                $str .= sprintf '</div>'; # END grading Scale
            } else {
                my $checked = '';
                if ($inScore == 10) {$checked = 'checked'}
                $str .= '<div class="w3-row w3-col l6">';
                $str .= sprintf '<div class="w3-rest w3-right">';
                $str .= sprintf '<label class="w3-margin-right">Yes </label><input value="1" data-value="%d" data-number="%d" data-key="%d" type=checkbox class="binary_check w3-check" %s onchange="grade_saveCheckAssessment(this, %d, %d, %d, %d, \'%s\', %d);">', $paperIDX, $section, $subSection, $checked, $paperIDX, $section, $subSection, $cardIDX, $txType, $teamIDX;
                $str .= '</div>';
                $str .= '</div>';
            }
            $str .= sprintf '</div>'; # Last Div
            # $str .= sprintf '<div class="w3-col l12 w3-hide w3-white w3-border w3-card-4 scoringPanel %s">', $divName; 
            $str .= sprintf '<div class="w3-row w3-border w3-white w3-hide %s">', $divName; # Expanded Area for Description and Comments
            $str .= '<div class="w3-container w3-rest">';
            $str .= sprintf '<div class="w3-container" style="padding: 20px 20px 5px 20px !important;">%s</div>', $RUBRIC{$section}{$subSection}{CL_DESCRIPTION};
            if ($valueType==0){
                $str .= '<br><lable class="w3-margin-bottom"><b>Feedback: </b>If the team scored <span class="w3-red" style="padding: 0px 10px"> 5 or lower</span> for this section, please provide constructive feedback on how the team can improve their future score.</label>';
            }
            $str .= '</div>';
            $str .= '<div class="w3-panel" style="padding: 0px;">';
            $str .= '<div class="w3-bar w3-border w3-light-grey w3-border-grey w3-card-2 w3-margin-top">';
            $str .= sprintf '<label class="w3-bar-item w3-button w3-large fa fa-folder-open-o"  onclick="grade_openTemplateList(this, %d, %d);"> Load Template</label>', $section, $subSection;
            $str .= sprintf '<label class="w3-bar-item w3-button w3-large fa fa-floppy-o"       onclick="grade_openTemplate(this, %d, %d, \'%s\');"> Save as Template</label>', $section, $subSection, $subSectionTitle;
            $str .= sprintf '<label class="w3-bar-item w3-button w3-large fa fa-comments-o"     onclick="grade_viewOtherFeedback(this, %d, %d, %d, %d, \'%s\');"> View Feedback(s)</label>', $teamIDX, $pk_report_idx, $section, $subSection, $subSectionTitle;
            $str .= sprintf '<label class="w3-bar-item w3-button w3-large fa fa-bar-chart"      onclick="grade_viewMetrics(this, %d, %d, %d, %d, %d);"> View Section Statistics</label>', $teamIDX, $pk_report_idx, $section, $subSection, $inCardType;
            $str .= '</div>';
            
            $str .= sprintf '<textarea ID="CL_FEEDBACK_%s" class="w3-input w3-border w3-border-black w3-round w3-margin-bottom w3-pale-yellow" style="width: 100%; height: 75px; min-width: 100%;" onblur="grade_autosaveComments(this, %d, this.value)" onfocus="grade_autoAdjustHeight(this);">%s</textarea>', $divName, $paperIDX, $feedback;
            
            $str .= '</div>';
            # $str .= sprintf '%s', $RUBRIC{$section}{$subSection}{CL_DESCRIPTION};
            $str .= sprintf '</div>';
        }
    }
    $str .= '</div>';
    return ($str);
    }
sub t_teamAssessmentBar(){
    my ($cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inStatus, $inScore, $inCardType, $userIDX)= @_;
    my %BTN_STATUS = (0=>'Start', 1=>'Continue', 2=>'Completed');
    my %BTN_COLOR  = (0=>'w3-white', 1=>'w3-yellow', 2=>'w3-pale-blue');
    my %MAXSCORE = (1=>35, 2=>5, 3=>5, 4=>5);
    my $str;
    $str .= sprintf '<div class="w3-row w3-col l12 w3-border w3-padding w3-round w3-hover-pale-blue bar_Assessment_%d %s" style="margin: 2px 0px;" ID="CARD_%d">', $cardIDX, $BTN_COLOR{$inStatus}, $cardIDX;
    $str .= sprintf '<div class="w3-col l7"><b>%03d</b> - %s</div>', $inNumber , $txSchool;
    $str .= sprintf '<div class="w3-col l2" style="text-align: right; "><span ID="CARD_SCORE_%d">%2.1f</span>  / %2.1f</div>', $cardIDX, $inScore, $MAXSCORE{$inCardType};
    $str .= sprintf '<div class="w3-col l3" style="text-align: right; ">';
    $str .= sprintf '<a class="actionStatus_%d" href="javascript:void(0);" onclick="grade_openAssessment(this, %d, %d, \'%s\', %d, %d, %d, %d);">%s</a>', $cardIDX, $cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $userIDX, $BTN_STATUS{$inStatus};
    $str .= sprintf '</div>';
    $str .= sprintf '</div>';
    return ($str);
    }
sub ManageReportAssessments(){
    print $q->header();
    my $Paper = new SAE::REPORTS();
    my $Grade = new SAE::GRADE();
    
    my $userIDX  = $q->param('userIDX');  
    my $inType   = $q->param('inType');  
    my $eventIDX = $q->param('location'); 
    my %CARDS    = %{$Paper->_getAssignedPapers($eventIDX, $userIDX, $inType)}; 
    my %TITLE    = (1=>'Design Report', 2=>'Technical Data Sheet', 3=>'Drawing', 4=>'Requirement');
    my $str;
    $str .= '<br><div class="w3-container w3-margin-top">';  
    $str .= '<div class="w3-display-container" style="display: block; z-index: 7001;">';
    $str .= '<div ID="banner_saveMessage" class="w3-display-topmiddle" ></div>';
    $str .= '</div>';
    $str .= sprintf '<h2>%s: <i>Assessments</i></h2>', $TITLE{$inType};
    $str .= '<div class="w3-container w3-row-padding">';
        $str .= '<div class="w3-row">' ;
        foreach $cardIDX (sort {$CARDS{$a}{IN_NUMBER} <=> $CARDS{$b}{IN_NUMBER}} keys %CARDS) {
            my $inNumber   = $CARDS{$cardIDX}{IN_NUMBER};
            my $txSchool   = $CARDS{$cardIDX}{TX_SCHOOL};
            my $classIDX   = $CARDS{$cardIDX}{FK_CLASS_IDX};
            my $teamIDX    = $CARDS{$cardIDX}{PK_TEAM_IDX};
            my $inStatus   = $CARDS{$cardIDX}{IN_STATUS};
            my $inCardType = $CARDS{$cardIDX}{FK_CARDTYPE_IDX};
            my $txType     = $CARDS{$cardIDX}{TX_TYPE};
            # my $inScore    = $Paper->_calculateDesignScore($inCardType, $classIDX, $cardIDX);
            my $inScore    = $Grade->_getAssessmentScore_byCard($cardIDX, $teamIDX);
            $str .= &t_teamAssessmentBar($cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inStatus, $inScore, $inCardType, $userIDX);
        }
        $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
# ===============2023 =====================================================
# sub grade_teamAttributes (){
#     print $q->header();
#     my $teamIDX    = $q->param('teamIDX');
#     my $table    = $q->param('table');
#     my %DATA       = %{decode_json($q->param('jsonData'))};
#     my $JsonDB     = new SAE::JSONDB();
#         $JsonDB->_update($table, \%DATA, qq(PK_TEAM_IDX=$teamIDX));
#     return ($str);
#     }
# sub grade_loadInstructions (){
#     my $txFirstName     = $q->param('txFirstName');
#     print $q->header();
#     my $str = &t_scoringGuide($txFirstName);
#     return ($str);
#     }
# sub grade_updateComments (){
#     print $q->header();
#     my $commentIDX = $q->param('commentIDX');
#     my $userIDX    = $q->param('userIDX');
#     my %DATA       = %{decode_json($q->param('jsonData'))};
#     my $JsonDB     = new SAE::JSONDB();
#         $JsonDB->_update('TB_COMMENTS', \%DATA, qq(PK_COMMENTS_IDX=$commentIDX));
#     my $str = &t_commentBlocks($commentIDX, $DATA{CL_COMMENT}, $userIDX, $userIDX, 'Just Edited...');
#     return ($str);
#     }
# sub grade_editComment (){
#     my $commentIDX= $q->param('commentIDX');
#     # my %DATA = %{decode_json($q->param('jsonData'))};
#     print $q->header();
#     my $Paper    = new SAE::REPORTS();
#     my $comments = $Paper->_getCommentById($commentIDX);
#     my $str;
#     $str .= '<div class="w3-container w3-pale-yellow w3-card w3-border w3-round">';
#     $str .= sprintf '<textarea rows="10" ID="subsectionComment_update" class="w3-margin-top w3-input w3-border w3-border-black w3-round">%s</textarea>', $comments;
#     $str .= '<div class="w3-container w3-center">';
#     $str .= '<button class="w3-button w3-border w3-round w3-pale-green w3-hover-green w3-margin-top w3-card" onclick="grade_updateComments(this, '.$commentIDX.')">Update</button>';
#     $str .= '<button class="w3-button w3-border w3-round w3-pale-red w3-hover-red w3-margin-top w3-margin-left" onclick="$(this).close(\'sae-top2\');">Cancel</button>';
#     $str .= '</div>';
#     $str .= '<br>';
#     $str .= '</div>';
    
#     return ($str);
#     }
# sub grade_deleteComment (){
#     my $commentIDX= $q->param('commentIDX');
#     # my %DATA = %{decode_json($q->param('jsonData'))};
#     print $q->header();
#     my $JsonDB = new SAE::JSONDB();
#     $JsonDB->_delete('TB_COMMENTS', qq(PK_COMMENTS_IDX=$commentIDX));

#     return ($str);
#     }
# sub grade_postComments (){
#     # my $userIDX= $q->param('userIDX');
#     my $eventIDX= $q->param('eventIDX');
#     my %DATA = %{decode_json($q->param('jsonData'))};
#     print $q->header();
#     my $JsonDB = new SAE::JSONDB();
#     my $newIDX = $JsonDB->_insert('TB_COMMENTS', \%DATA);
#     my $str = &t_commentBlocks($newIDX, $DATA{CL_COMMENT}, $DATA{FK_USER_IDX}, $DATA{FK_USER_IDX}, 'Just Now');
#     return ($str);
#     }
# sub grade_setAssessmentStatus (){
#     print $q->header();
#     my $cardIDX     = $q->param('FK_CARD_IDX');
    
#     my $inStatus    = $q->param('IN_STATUS');
#     my $classIDX    = $q->param('FK_CLASS_IDX');
#     my $inCardType  = $q->param('FK_CARDTYPE_IDX');
#     my $Paper    = new SAE::REPORTS();
#        $Paper->_setAssessmentStatus($cardIDX, $inStatus);
#     my %DETAILS = %{$Paper->_getCardAndTreamDetails($cardIDX )};
#     my $inScore = $Paper->_calculateDesignScore($inCardType, $classIDX, $cardIDX);
#     my $str = &t_teamAssessmentBar($cardIDX, $DETAILS{IN_NUMBER}, $DETAILS{TX_SCHOOL}, $classIDX, $DETAILS{FK_TEAM_IDX}, $inStatus, $inScore, $DETAILS{FK_CARDTYPE_IDX}, $DETAILS{FK_USER_IDX});

#     return ($str);
#     }
# sub grade_updateField (){
#     print $q->header();
#     my $cardIDX  = $q->param('FK_CARD_IDX');
#     my $subIDX   = $q->param('FK_SUBSECTION_IDX');
#     my $inValue  = $q->param('IN_VALUE');
#     my $Paper    = new SAE::REPORTS();
#        $Paper->_setSubmitCardScore($cardIDX, $subIDX, $inValue);
#        $Paper->_setAssessmentStatus($cardIDX,1);
#     my $str;
#     return ($str);
#     }
# sub grade_openHelp (){
#     my $subIDX    = $q->param('subIDX');
#     my $inSection = $q->param('inSection');
#     my $teamIDX   = $q->param('teamIDX');
#     my $cardIDX   = $q->param('cardIDX');
#     my $userIDX   = $q->param('userIDX');
#     my $inValue   = $q->param('inValue');
#     # my %DATA = %{decode_json($q->param('jsonData'))};
#     print $q->header();
#     my $Paper      = new SAE::REPORTS();
#     my %DETAILS    = %{$Paper->_getSubSectionDetails($subIDX)};
#     my %COMMENTS   = %{$Paper->_getSubSectionComments($cardIDX, $subIDX)};
#     my $str = '<div class="w3-container" style="height: 600px; padding: 0; overflow-y: scroll; ">';
#     my $str = sprintf '<h4 class="w3-pale-yellow w3-border w3-border-black" style="padding: 4px 100px 4px 15px !important; margin-top: 0px;">%d.%d - %s</h4>', $inSection, $DETAILS{IN_SUBSECTION}, $DETAILS{TX_SUBSECTION};
#     $str .= '<div class="w3-padding-small">';
#     $str .= $DETAILS{CL_DESCRIPTION};
#     $str .= '</div>';
#     $str .= '<div class="w3-container w3-border-top w3-margin-top w3-pale-yellow w3-border w3-round w3-padding">';
#     if ($inValue <=50){
#             $str .= '<h5 class="w3-red w3-border w3-round w3-padding">We strongly encourage all judges to provide feedback on score lower than 50%</h5>';
#         } else {
#             $str .= '<h5 class="w3-blue w3-border w3-round w3-padding">Please provide feedback to help team improve on future design reports</h5>';
#         }
    
#     $str .= '<textarea rows="3" ID="subsectionComment" class="w3-input w3-border w3-border-black w3-round"></textarea>';
#     $str .= sprintf '<button class="w3-button w3-round w3-border w3-hover-green w3-margin-top w3-pale-green w3-card-2" style="width: 130px;" onclick="grade_postComments(this, %d, %d, %d)">Post</button>', $cardIDX, $teamIDX, $subIDX;
#     $str .= '<button class="w3-button w3-round w3-border w3-white w3-hover-blue w3-margin-top w3-margin-left w3-card-2" onclick="grade_openTemplate(this);">Save to Template</button>';
#     $str .= sprintf '<button class="w3-button w3-round w3-border w3-white w3-hover-blue w3-margin-top w3-margin-left w3-card-2" onclick="grade_openTemplateList(this, %d);">Load from Template</button>', $userIDX ;
#     $str .= '</div>';
#     $str .= '<div class="w3-container w3-topbar w3-margin-top">';
#     $str .= '<ul ID="COMMENT_CONTAINER" class="w3-ul w3-margin-top" style="padding: 0px;">';
#     foreach $commentIDX (sort {$b <=> $a} keys %COMMENTS) {
#         $str .= &t_commentBlocks($commentIDX, $COMMENTS{$commentIDX}{CL_COMMENT}, $userIDX, $COMMENTS{$commentIDX}{FK_USER_IDX}, $COMMENTS{$commentIDX}{TS_CREATE});
#     }
#     $str .= '</ul>';
#     $str .= '</div>';
#     $str .= '</div>';
#     return ($str);
#     }
# sub grade_openAssessment_Leg(){
#     my $eventIDX   = $q->param('eventIDX');
#     my $userIDX    = $q->param('userIDX');
#     my $classIDX   = $q->param('classIDX');
#     my $cardIDX    = $q->param('cardIDX');
#     my $teamIDX    = $q->param('teamIDX');
#     my $inCardType = $q->param('inCardType');
#     my $adminUserIDX = $q->param('adminUserIDX');
#     my $txFirstName  = $q->param('txFirstName');
#     # my $inCardType = 1;
#     # my %DATA = %{decode_json($q->param('jsonData'))};
#     print $q->header();
#     my $Paper      = new SAE::REPORTS();
#     my $Ref        = new SAE::REFERENCE();
#     my $Team       = new SAE::PAPER();
#     my %SECTION    = %{$Paper->_getPaperSection($inCardType, $classIDX)};
#     my %SUBSECTION = %{$Paper->_getPaperSubSection()};
#     my %SCORES     = %{$Paper->_getCardScores($cardIDX)};
#     my %REPORT     = %{$Ref->_getTeamDocuments($eventIDX)};
#     my %TEAM       = %{$Team->_getTeamDetails($teamIDX)};
#     my $str = '<div class="w3-container w3-grey" style="text-align: right; padding: 10px; ">';
#     my $disabled = '';
#     # my $classDisabled = '';
#     # if ($adminUserIDX != $userIDX){$disabled = 'disabled'; $classDisabled = 'w3-disabled'}
#     # $str .= 'inCardType='.$inCardType;
#     # $str .= '  ID='.$REPORT{$teamIDX}{$inCardType}{TX_KEYS};
#     if ($inCardType==4){$inCardType=1}
#     $str .= '<button class="w3-button w3-border w3-round w3-light-grey" onclick="grade_loadInstructions(this);">Instructions '.$inCardType.'</button>';
#     if ($inCardType==4){
#         # $inCardType=1
#         $str .= '<a class="w3-button w3-border w3-round w3-text-black  w3-light-grey w3-margin-left" href="read.html?fileID='.$REPORT{$teamIDX}{1}{TX_KEYS}.'&location='.$eventIDX.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{1}}{TX_KEYS}.'&location='.$eve.'\',\'report\',\'width=1000,height=600\')">Download</a>';    
#     } else {
#         $str .= '<a class="w3-button w3-border w3-round w3-text-black  w3-light-grey w3-margin-left" href="read.html?fileID='.$REPORT{$teamIDX}{$inCardType}{TX_KEYS}.'&location='.$eventIDX.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inCardType}}{TX_KEYS}.'&location='.$eve.'\',\'report\',\'width=1000,height=600\')">Download</a>';
#     }
#     # $str .= $REPORT{$teamIDX}{$inCardType}{TX_KEYS}.'<a class="w3-button w3-border w3-round w3-text-black  w3-light-grey w3-margin-left" href="read.html?fileID='.$REPORT{$teamIDX}{$inCardType}{TX_KEYS}.'&location='.$eventIDX.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inCardType}}{TX_KEYS}.'&location='.$eve.'\',\'report\',\'width=1000,height=600\')">Download</a>';
#     if ($adminUserIDX == $userIDX){
#         $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-4 w3-yellow w3-margin-left" onclick="grade_setAssessmentStatus(this, %d, %d, %d, %d);">Exit & Save as Draft</button>', $cardIDX , 1, $classIDX, $inCardType ;
#         $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-4 w3-blue w3-margin-left" onclick="grade_setAssessmentStatus(this, %d, %d, %d, %d);">Save as Final</button>', $cardIDX , 2, $classIDX, $inCardType ; #2= Status of the assessment.  2=Complete; 1=Draft; 0=Not Started
#     }
#     $str .= '</div>';
#     $str .= '<div class="w3-container w3-row" style="padding: 0px; ">';
#     my $instruction = &t_scoringGuide($txFirstName);
#     $str .= '<div class="w3-third w3-container w3-light-grey w3-border w3-card-2" style="padding: 0px;">';
#     $str .= '<table class="w3-table w3-white w3-card-4">';
#     $str .= '<tr>';
#     $str .= sprintf '<th>&nbsp;</th>';
#     # $str .= sprintf '<th>'.$adminUserIDX.' - '.$userIDX.'</th>';
#     $str .= '<th style="width: 100px; text-align: center;">Score<br>(0-100%)</th>';
#     $str .= '</tr>';
#     my $color = 'w3-white';
#     if ($inCardType>1) {
#         $str .= '<tr>';
#         $str .= '<td class="w3-white w3-border" style="text-align: right; vertical-align: middle;">Select All</td>';
#         $str .= sprintf '<td class="w3-white w3-center w3-border" style="vertical-align: middle;"><span class="w3-small"><input class="w3-check" type="checkbox" onclick="selectAllCheckBox(this, \'%s\', %d);"></td>','yesNo', $cardIDX;
#         $str .= '</tr>';
#         # $color = 'w3-light-grey';
#     }
#     foreach $sectionIDX (sort {$SECTION{$a}{IN_SECTION} <=> $SECTION{$b}{IN_SECTION}} keys %SECTION) {
#         my $inSection = $SECTION{$sectionIDX}{IN_SECTION};
#         my $txSection = $SECTION{$sectionIDX}{TX_SECTION};
#         foreach $subIDX (sort {$SUBSECTION{$sectionIDX}{$a}{IN_SUBSECTION} <=> $SUBSECTION{$sectionIDX}{$b}{IN_SUBSECTION}} keys %{$SUBSECTION{$sectionIDX}}) {
#             my $subInSection = $SUBSECTION{$sectionIDX}{$subIDX }{IN_SUBSECTION};
#             my $txSubSection = $SUBSECTION{$sectionIDX}{$subIDX}{TX_SUBSECTION};
#             my $entryType    = $SUBSECTION{$sectionIDX}{$subIDX}{IN_TYPE};
#             $str .= '<tr class="rowTitle">';
#             $str .= sprintf '<td class="w3-hover-pale-yellow w3-border" ><a class=" w3-text-black" href="javascript:void(0);" style="text-decoration: none;" onclick="grade_openHelp(this, %d, %d, %d, %d);">%d.%d: (%s) - %s</a></td>',$subIDX, $inSection, $cardIDX, $teamIDX, $inSection, $subInSection, $txSection, $txSubSection;
#             $str .= sprintf '<td class="'.$color.' w3-center w3-border" style="padding: 0; vertical-align: middle;" onclick="grade_openHelp(this, %d, %d, %d, %d);">',$subIDX, $inSection, $cardIDX, $teamIDX;
#             if (exists $SCORES{$subIDX}){
#                     my $inValue = $SCORES{$subIDX}{IN_VALUE};
#                     if ($entryType == 0) {
#                             $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="text" value="'.$inValue.'" style="text-align: center;" class="w3-input w3-border-0 w3-round" onKeyDown="grade_moveToNextField(event, this);" onfocus="grade_openHelp(this, %d, %d, %d, %d);" onchange="grade_updateField(this, %d, %d)">', $subIDX, $inSection, $cardIDX, $teamIDX, $cardIDX, $subIDX;
#                         } else {
#                             my $checked = '';
#                             if ($inValue >0){$checked ='checked'}
#                             $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="checkbox" '.$checked.' style="text-align: center;" class="w3-check w3-border-0 w3-round yesNo" data-value="'.$subIDX.'" onchange="grade_updateCheckField(this, %d, %d);">', $cardIDX, $subIDX;
#                         }
#                 } else {
#                     if ($entryType == 0) {
#                         $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="text" style="text-align: center;" placeholder="0%" class="w3-input w3-border-0 w3-round" onKeyDown="grade_moveToNextField(event, this);" onfocus="grade_openHelp(this, %d, %d, %d, %d);" onchange="grade_updateField(this, %d, %d)">', $subIDX, $inSection, $cardIDX, $teamIDX, $cardIDX, $subIDX;
#                     } else {
#                         $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="checkbox" style="text-align: center;" class="w3-check w3-border-0 w3-round yesNo" data-value="'.$subIDX.'" onchange="grade_updateCheckField(this, %d, %d);">', $cardIDX, $subIDX;
#                     }
#                 }
#                 $str .= '</td>';

#             $str .= '</tr>';
#         }
#     }
#     $str .= '</table>';
#     if ($inCardType==2 & $classIDX==1) {
#     $str .= '<div class="w3-container w3-margin-top" style="padding: 10px 0px;">';
#     $str .= '<h3 class="w3-margin-left">Payload Prediction Data</h3>';
#     $str .= '<table class="w3-table-all">'; 
#         $str .= '<tr class="w3-blue-grey">';
#         $str .= '<td style="text-align: right;" class="w3-padding"><b>Slope</b>:</td>';
#         $str .= sprintf '<td style="padding: 0; width: 100px;" ><input type="number" class="w3-input w3-border" data-field="IN_SLOPE" data-table="TB_TEAM" max="0" step=".0001" onchange="grade_teamAttributes(this, %d);" value="%2.5f"></td>', $teamIDX, $TEAM{IN_SLOPE};
#         $str .= '</tr>';
#         $str .= '<tr class="w3-blue-grey">';
#         $str .= '<td style="text-align: right;" class="w3-padding"><b>y-intercept</b>:</td>';
#         $str .= sprintf '<td style="padding: 0; width: 100px;" ><input type="number" class="w3-input w3-border" data-field="IN_YINT" data-table="TB_TEAM" min="0" step="0.05" onchange="grade_teamAttributes(this, %d);" value="%2.2f"></td>', $teamIDX, $TEAM{IN_YINT};
#         $str .= '</tr>';
#     $str .= '</table>';
#     $str .= '</div>';
#     }

#     if ($inCardType==2 & $classIDX==2) {
#     $str .= '<div class="w3-container w3-margin-top" style="padding: 10px 0px;">';
#     $str .= '<h3 class="w3-margin-left">Advanced Class Standard Deviation Data</h3>';
#     $str .= '<table class="w3-table-all">'; 
#         $str .= '<tr class="w3-blue-grey">';
#         $str .= '<td style="text-align: right;" class="w3-padding"><b>Standard Deviation (ft)</b>:</td>';
#         $str .= sprintf '<td style="padding: 0; width: 100px;" ><input type="number" class="w3-input w3-border" data-field="IN_STD" data-table="TB_TEAM" min="0" step="1" onchange="grade_teamAttributes(this, %d);" value="%2.1f"></td>', $teamIDX, $TEAM{IN_STD};
#         $str .= '</tr>';
#     $str .= '</table>';
#     $str .= '</div>';
#     }
#     $str .= '</div>';
#     $str .= '<div ID="AssessmentHelper" class="w3-twothird w3-container w3-white">';
#     $str .= &t_scoringGuide($txFirstName);
    
#     $str .= '</div>';
    
#     $str .= '<br>'x2;
    
#     $str .= '</div>';
#     return ($str);
#     }
# sub t_scoringGuide (){
#     my ($txFirstName) = @_;
#     my $str;
#     $str = '<h4 style="padding: 4px 10px !important; margin-top: 0px;" class="w3-center w3-pale-yellow w3-border ">Scoring Guide</h4>';
#     $str .= '<div class="w3-container w3-border w3-round w3-card">';
#     $str .= '<br><p><b>'.$txFirstName.'</b>,<br><br>Thank you for taking time to support this event.<br>Below are the instructions on how we like for you tofolow as you grade this important portion of the Design Report/p><br>';
#     $str .= '<ol type="1" style="padding: 12px; "><span class="w3-large"><b>INSTRUCTIONS</b></span>';
#     $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Use grading scale from 0-100%.</li>';
#     $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Click [ Download ] to access the Design Report.</li>';
#     $str .= '<li style="margin-left: 35px; padding: 10px 5px;">The goal of SAE Aero-Design is to promote a positive learning environment and encourage students to continue to pursue engineering mindset.  Comments & feedback are <b>strongly</b> encouraged especially if you believe they\'ve earned a score 50% or below.</li>';
#     $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Please keep all comments & feedback <u><i>positive and constructive</i></u>.  Provide examples on how the team can improve their scores if they had included x, y, & z to substanciate their claims.</li>';
#     $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Click in each section "score box" to learn more about the scoring criteria</li>';
#     $str .= '<li class="w3-text-red" style="margin-left: 35px; padding: 10px 5px;"><b>IMPORTANT!</b> Scores are auto-saved as "Draft" as you enter them.  When you feel confident that your assessment is complete and accurate, Click on [ Save as Final ] at the top right corner of this assessment page to sumbit your <b>FINAL</b> Assessment.</li>';
#     $str .= '</ol>';
#     $str .= '</div>';
#     $str .= '<br>'x3;
#     return ($str);
#     }
# sub t_commentBlocks (){
#     my ($commentIDX, $txComments, $currentUser, $userIDX, $tsCreate) = @_;
#     my $str;
#     # my $txComments = $COMMENTS{$commentIDX}{CL_COMMENT};
#     $txComments =~ s/\n/<br>\n/g;
#     $str .= '<li ID="Comment_'.$commentIDX.'" class="w3-bar w3-display-container w3-border w3-round w3-margin-bottom w3-card w3-pale-yellow" style="padding: 3px 0px 3px 3px;">';
#     if ($currentUser == $userIDX){
#         $str .= '<div class="w3-display-topright">';
#         $str .= '<i class="fa fa-pencil w3-button w3-round w3-hover-green" aria-hidden="true" onClick="grade_editComment('.$commentIDX.')">...</i>';
#         $str .= '<i class="fa fa-times w3-button w3-round w3-hover-red" aria-hidden="true" onClick="grade_deleteComment('.$commentIDX.');"></i>';
#         $str .= '</div>';
#     }
#     $str .= '<div class="w3-bar-item w3-margin-right" style="padding: 3px; margin-top: 30px !important;">';
#     $str .= $txComments;
#     $str .= '<br>';
#     $str .= sprintf '<span class="w3-small w3-text-blue">%s</span>',$tsCreate;
#     $str .= '</div>';
#     $str .= '</li>';
#     return ($str);
#     }

# =========================================================================
# SAVE AND UPDATE REPORT SCORES
# sub sae_updateReportAssessment(){
#     print $q->header();
#     my $Ref = new SAE::REFERENCE();
#     my $Grade = new SAE::GRADE();
#     my %DATA = %{decode_json($q->param('jsonData'))};
#     my $cardIDX = $q->param('cardIDX'); 
#     my $teamIDX = $q->param('teamIDX'); 
#     my $inType = $q->param('inType'); 
#     my $status = $q->param('status'); 
#     $Grade->_updateCardAssessments($cardIDX, \%DATA);
#     $Grade->_updateCardStatus($cardIDX, $status);
#     %CARDTYPE = %{$Ref->_getCardTypeList()};
#     my $str = sprintf "%2.4f / %2.1f", $Ref->_calculatePaperScores($teamIDX, $cardIDX, $inType), $CARDTYPE{$inType}{IN_POINTS};
#     return ($str);
#     }
# sub sae_submitReportAssessment(){
#     print $q->header();
#     my $Ref = new SAE::REFERENCE();
#     my $Grade = new SAE::GRADE();
#     my %DATA = %{decode_json($q->param('jsonData'))};
#     my $teamIDX = $q->param('teamIDX'); 
#     my $cardIDX = $q->param('cardIDX'); 
#     my $inType = $q->param('inType'); 
#     my $status = $q->param('status'); 
#     $Grade->_saveAssessments($teamIDX, $cardIDX, $inType, \%DATA);
#     $Grade->_updateCardStatus($cardIDX, $status);
#     %CARDTYPE = %{$Ref->_getCardTypeList()};
#     my $str = sprintf "%2.4f / %2.1f", $Ref->_calculatePaperScores($teamIDX, $cardIDX, $inType), $CARDTYPE{$inType}{IN_POINTS};
#     return ($str);
#     }
# =========================================================================
# # COMMENTS & TEMPLATE
# sub sae_updateComments(){
#     print $q->header();
#     my $commentIDX = $q->param('commentIDX'); 
#     my $comments = $q->param('comments');  
#     my $teamIDX = $q->param('teamIDX');  
#     my $Reports = new SAE::REPORTS();
#     my $Util = new SAE::Common();
#     %COMMENT = %{$Reports->_updateComments($comments , $commentIDX)};
#     my $str = uri_unescape($comments);
#     return($str);
#     }
# sub sae_editComments(){
#     print $q->header();
#     my $commentIDX = $q->param('commentIDX'); 
#     my $Reports = new SAE::REPORTS();
#     my $Util = new SAE::Common();
#     %COMMENT = %{$Reports->_loadCommentsToEdit($commentIDX)};
#     my $str = $Util->removeBr($COMMENT{$commentIDX}{CL_COMMENT});
#     return($str);
#     }
# sub sae_applyTemplate(){
#     print $q->header();
#     my $templateIDX = $q->param('templateIDX'); 
#     my $Reports = new SAE::REPORTS();
#     my $Util = new SAE::Common();
#     %COMMENT = %{$Reports->_loadTeamplateItem($templateIDX)};
#     # my $str = $templateIDX.' '.$COMMENT{$templateIDX}{CL_COMMENT};
#     my $str = $Util->removeBr($COMMENT{$templateIDX}{CL_COMMENT});
#     return($str);
#     }
# sub sae_saveToTemplate(){
#     print $q->header();
#     my $title = $q->param('title');  
#     my $userIDX = $q->param('userIDX');  
#     my $comments = $q->param('comments');  
#     my $Reports = new SAE::REPORTS();
#     my $templateIDX = $Reports->_saveToTemplate($title, $userIDX, $comments);
#     my $str = '<option value="'.$templateIDX.'">'.$title.'</option>';
#     # $str = 'test';
#     return($str);
#     }
# sub sae_deleteComment(){
#     print $q->header();
#     my $commentIDX = $q->param('commentIDX');  
#     my $Reports = new SAE::REPORTS();
#     $Reports->_deleteComment($commentIDX);
#     return($commentIDX);
#     }
# sub sae_postComments(){
#     print $q->header();
#     my $cardIDX = $q->param('cardIDX');  
#     my $userIDX = $q->param('userIDX');  
#     my $teamIDX = $q->param('teamIDX');  
#     my $subSectionIDX = $q->param('subSectionIDX');  
#     my $comments = $q->param('comments');  
#     my $Reports = new SAE::REPORTS();
#     my $commentIDX = $Reports->_postComments($cardIDX, $subSectionIDX, $userIDX, $comments, $teamIDX);
#     my $str = &renderComments($cardIDX, $commentIDX, $subSectionIDX, uri_unescape($comments), $userIDX, $userIDX, $teamIDX );
#     return ($str);
#     }
# # =========================================================================
# sub renderComments(){
#     my $cardIDX = shift;
#     my $commentIDX = shift;
#     my $subSectionIDX = shift;
#     my $comments = shift;
#     my $userIDX = shift;
#     my $commentUserIDX = shift;
#     my $teamIDX = shift;
#     my $User = new SAE::USER();
#     my $admin = $User->_getAdminStatus($commentUserIDX);
#     my $judgeName = $User->_getUserById($userIDX);
#     my $str = '<div ID="subSectionComments_'.$commentIDX.'" class="w3-bar-item w3-small w3-white w3-border w3-border-yellow w3-leftbar w3-display-container" style="margin-bottom: 5px; width: 100%!important">';
#     # $str .= sprintf '<label class="w3-tiny">Comment ID: %d</label>', $commentIDX;
#     $str .= sprintf '<p ID="subSectionCommentItem_%d" >%s<br><label class="w3-tiny">Posted By: %s</label></p>', $commentIDX, $comments, $judgeName;
#     if ($commentUserIDX == $userIDX || $admin==1){
#         $str .= '<span onclick="sae_deleteComment('.$commentIDX.');" class="w3-button w3-display-topright">X</span>';
#         $str .= '<a href="javascript:void(0);" onclick="sae_editComments('.$cardIDX.','.$subSectionIDX.','.$commentIDX.','.$teamIDX.')">Edit</a>';
#     } 
#     $str .= '</div>';
#     return ($str);
#     }
# sub openAssessment(){
#     print $q->header(); 
#     my $divName = $q->param('divName');  
#     my $classIDX = $q->param('classIDX');  
#     my $cardIDX = $q->param('cardIDX');  
#     my $inNumber = $q->param('inNumber');  
#     my $userIDX = $q->param('userIDX');  
#     my $teamIDX = $q->param('teamIDX');  
#     my $location = $q->param('location');  
#     my $from = $q->param('from');  
#     my $inType = $q->param('inType');  # CardTypeIDX
    
#     my $dbi = new SAE::Db();
#     my $Rubric = new SAE::RUBRIC();
#     my $Reports = new SAE::REPORTS();
#     my $Ref = new SAE::REFERENCE();
#     %SECTION = %{$Rubric->_getSectionList()};
#     %SUBSECTION = %{$Rubric->_getSubSectionList()};
#     # %COMMENTS = %{$Reports->_loadComments($cardIDX)};
#     %COMMENTS = %{$Reports->_loadAllComments($teamIDX)};
#     %TEMPLATE = %{$Reports->_loadTeamplate($userIDX)};
#     %PAPER = %{$Reports->_getCardRecords($cardIDX)};
#     %REPORT = %{$Ref->_getTeamDocuments($location)};
#     # %REPORT = %{$Ref->_getTeamDocuments(28)};
#     %SECAVG = %{$Ref->_getSectionAverage($teamIDX, $inType)};
#     %CARDTYPE = %{$Ref->_getCardTypeList()};
#     %BINARY = %{$Reports->_isBinaryInputs()};
#     %DOC = (1=>1, 2=>2, 3=>3, 4=>1);
#     my $str;
#     # $str .= scalar (keys %{$SECTION{$inType}});
#     $str .= '<div class="w3-display-container w3-border-bottom w3-card-4 w3-padding" >';
    
#     # $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="_blank" >Download</a>';
#     # $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
#     # $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
#     $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="read.html?fileID='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
#     $str .= '<button class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
#     $str .= '<button id="button_expandSections" class="w3-button w3-border w3-margin-left w3-round" style="width: 160px; margin-left: 172px;" onclick="sae_collapseSections();">Collapse Sections</button>';
#     $str .= '<button id="button_expandAll" class="w3-button w3-border  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_expandAll();">Expand ALL</button>';
#     # $str .= '<button id="button_expandAll" class="w3-button w3-border  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_resetScores('.$cardIDX.');">Reset</button>';
    
#     if (scalar(keys %PAPER)>0){
#         $str .= '<button id="button_expandAll" class="w3-button w3-border w3-hover-yellow  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_updateReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',1, '.$from.');">Update As Draft</button>';
#         $str .= '<button class="w3-button w3-border w3-blue w3-margin-left w3-round " style="width: 140px; margin-right: 16px;" onclick="sae_updateReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',2, '.$from.');">Update as Final</button>';
#     } else {
#         $str .= '<button id="button_expandAll" class="w3-button w3-border w3-hover-yellow  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_submitReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',1, '.$from.');">Save As Draft</button>';
#         $str .= '<button class="w3-button w3-border w3-blue w3-margin-left w3-round" style="width: 140px; margin-right: 16px;" onclick="sae_submitReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',2, '.$from.');">Submit as Final</button>';
#     }
#     $str .= '</div>';


#     $str .= '<div class="w3-container" style="height: 650px; overflow: auto; margin-top: 10px;" >';
#     my $secWeight = 0;
#     my $tabCount = 1;

    
#     foreach $sectionIDX (sort {$SECTION{$inType}{$a}{IN_SECTION} <=> $SECTION{$inType}{$b}{IN_SECTION}} keys %{$SECTION{$inType}}){
#         my $secName = $SECTION{$inType}{$sectionIDX}{TX_SECTION};
#         my $secNumber = $SECTION{$inType}{$sectionIDX}{IN_SECTION};
#         my $secWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
#         my $secClass = $SECTION{$inType}{$sectionIDX}{IN_CLASS};
#         %APP = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
#         if (($secClass == $classIDX) || ($secClass == 0)) {
#         $str .= '<button tabstop="false" tabindex="-1" style="margin-top: 2px;" class="w3-button w3-display-container w3-block w3-left-align w3-blue-grey sae-section_grade_'.$sectionIDX.'" ';
#         $str .= 'onclick="expandSubsection(this, '.$sectionIDX.')" >';
#         $str .= '<i class="fa fa-chevron-down fa-all"></i>&nbsp;&nbsp;';
#         $str .= '<span ID="sectionButton_'.$sectionIDX.'" >'.$secNumber.' - '.$secName.' - '.$APP{$secClass}.'</span>';
#         $str .= sprintf '<span class="w3-right">Average Score: <span ID="sectionAverage_'.$sectionIDX.'">%2.2f</span>%</span>', $SECAVG{$sectionIDX}{IN_AVERAGE};
#         $str .= '</button>';
#         $str .= '<div ID="section_'.$sectionIDX.'" class="w3-container w3-white w3-card-2 w3-border sae-allexpand sae-subsections-div sae-section_grade_'.$sectionIDX.'">';
#         # $str .= '<div ID="section_'.$sectionIDX.'" class="w3-hide w3-container w3-white w3-card-2 w3-border sae-allexpand sae-subsections-div sae-section_grade_'.$sectionIDX.'">';
#         $str .= '<ul  class="w3-ul w3-card-2" >';
#         if (exists $BINARY{$sectionIDX}){
#             $str .= '<div class="w3-third w3-container"></div>';
#             $str .= '<div class="w3-third w3-container" style="padding-left:22px;">';
#             $str .= '<input  ID="forSelectAll" type="checkbox" class="w3-check" onclick="toggleSelection(\'inputBinary\', this);">&nbsp; <label for="forSelectAll" class="w3-small">Select All</label>';
#             $str .= '</div>';
#             $str .= '<div class="w3-third w3-container"></div>';
#         }
        
#         foreach $subSectionIDX (sort {$SUBSECTION{$sectionIDX}{$a}{IN_SUBSECTION} <=> $SUBSECTION{$sectionIDX}{$b}{IN_SUBSECTION}} keys %{$SUBSECTION{$sectionIDX}}) {
#             $subSectionNumber = $SUBSECTION{$sectionIDX}{$subSectionIDX}{IN_SUBSECTION};
#             $subSectionTitle = $SUBSECTION{$sectionIDX}{$subSectionIDX}{TX_SUBSECTION};
#             $inputType = $SUBSECTION{$sectionIDX}{$subSectionIDX}{IN_TYPE};
#             $inPoints = $CARDTYPE{$inType}{IN_POINTS};
            
#             $str .= '<li class="w3-bar w3-row" style="padding: 1px;">';
#             $str .= '<div class="w3-bar-item" style="width: 100%;">';
#                 $str .= '<div ID="instruction_'.$subSectionIDX .'" class="w3-hide w3-padding-small w3-display-container sae-allexpand w3-round-large w3-pale-blue w3-border w3-card-2 w3-small" style="padding: 10px; padding-right: 37px!important; margin-bottom: 8px;"><u><b>'.$secNumber.'.'.$subSectionNumber.' - '.$subSectionTitle.' Scoring Critieria</b></u><br>';
#                 $str .= '<span onclick="showScoringCriteria(this,'.$subSectionIDX.');" class="w3-button w3-display-topright">X</span>';
#                 $str .= '<p>'.$SUBSECTION{$sectionIDX}{$subSectionIDX}{CL_DESCRIPTION}.'</p><br>';
#                 $str .= '<span class="w3-padding w3-red w3-round w3-card-2">NOTE: If your assessment is below '.$SUBSECTION{$sectionIDX}{$subSectionIDX}{IN_THRESHOLD}.'%, please provide comments so that the team can learn and adjust for future entries</span>';
#                 $str .= '<br><br></div>';
#                 $str .= '<div class="w3-third w3-container">';
#                 $str .= "<span>$secNumber.$subSectionNumber - $subSectionTitle</span><br>" ;
#                 $str .= '<a tabstop="false" style="margin-left: 20px;" tabindex="'.($tabCount * -1).'" class="w3-small" href="javascript:void(0);" onclick="expandInstruction(this, '.$subSectionIDX.');"><span class="fa fa-question fa-fw"></span>Scoring Guide</a>';
#                 $str .= '</div>';
#                 $str .= '<div class="w3-third w3-container">';
#                 my $checked = "";
#                 if ($inputType==0){
#                     $str .= '<input type="number" tabindex="'.($tabCount++).'" ';
#                     $str .= 'class="w3-border sae-inputs sae-input-'.$subSectionIDX.' sae-input-group-'.$sectionIDX.'" ';
#                     $str .= 'data-weight="'.$secWeight.'" data-key="'.$subSectionIDX.'" data-section="'.$sectionIDX.'" ';
#                     $str .= 'onkeyup="sae_calculateNow(this, '.$sectionIDX.', '.$inPoints.');" ';
#                     # $str .= 'onblur="validateInput(this);"';
#                     if (scalar(keys %PAPER)>0){
#                         $str .= 'value="'.$PAPER{$subSectionIDX}{IN_VALUE}.'"';
#                     } else {
#                         $str .= 'placeholder="0.00"';
#                     }
#                     $str .= 'min="0" max="100" style="width: 76px; margin-left: 20px; text-align: center;">';
#                 } else {
#                     if (scalar(keys %PAPER)>0 && $PAPER{$subSectionIDX}{IN_VALUE}>0){
#                         $checked = "checked";
#                     } else {
#                         $checked = ""
#                     }
#                     $str .= '<input ID="inputCheckFor_'.$subSectionIDX.'" type="checkbox" class="w3-check inputBinary" data-key="'.$subSectionIDX.'" value="100" '.$checked.'><label for="inputCheckFor_'.$subSectionIDX.'">Yes, Requirements are met.</label>';
#                 }
#                 $str .= '</div>';
#                 $str .= '<div class="w3-third w3-container">';
#                 my $commentCount = scalar (keys %{$COMMENTS{$subSectionIDX}});
#                 if ($commentCount>0){
#                     $str .= '&nbsp;&nbsp;<a tabstop="false" tabindex="'.($tabCount * -1).'" class="w3-small w3-margin-left" href="javascript:void(0);" onclick="expandComments('.$subSectionIDX.');"><span class="fa fa-comment-o" ></span> Comments ('.$commentCount.')</a>';
#                 } else {
#                     $str .= '&nbsp;&nbsp;<a tabstop="false" tabindex="'.($tabCount * -1).'" class="w3-small w3-margin-left" href="javascript:void(0);" onclick="expandComments('.$subSectionIDX.');"><span class="fa fa-comment-o" ></span> Comments</a>';
#                 }
#                 $str .= '</div>';
#             $str .= '</div>';
#             $str .= '</li>';
#             #Comment Section ----------------------------------
#             $str .= '<li ID="comments_'.$subSectionIDX.'" class="w3-bar w3-container w3-hide w3-pale-yellow w3-border w3-small">';
#             $str .= 'Template: <select ID="templateList_'.$subSectionIDX.'" onchange="sae_applyTemplate('.$subSectionIDX.');" class="templateList w3-select w3-padding-small w3-medium w3-border w3-white" style="width: 50%;">';
#             $str .= '<option value="0">Load from template...</option>';
#             foreach $templateIDX (sort {lc($TEMPLATE{$a}{TX_TITLE}) cmp lc($TEMPLATE{$b}{TX_TITLE})} keys %TEMPLATE){
#                 $str .= '<option value="'.$templateIDX.'">'.$TEMPLATE{$templateIDX}{TX_TITLE}.'</option>';
#             }
#             $str .= '</select>';
#             # $str .= '<button style="margin-left: 0px; margin-top: 5px!important; width: 100px;" onclick="sae_applyTemplate('.$subSectionIDX.');">Apply</button>';
#             $str .= '<textarea ID="comments_entry_'.$subSectionIDX.'" class="w3-input w3-border w3-white" style="margin-top: 5px; max-width: 100%; min-width: 100%; min-height: 50px;"></textarea>';
            
#             $str .= '<button ID="buttonPostComment_'.$subSectionIDX.'" style="margin-left: 0px; margin-top: 5px!important; width: 100px;" onclick="sae_postComments('.$cardIDX.','.$subSectionIDX.','.$teamIDX.');">Post</button>';
#             $str .= '<button ID="buttonCancelComment_'.$subSectionIDX.'" style="margin-left: 15px; margin-top: 5px!important; width: 100px;" onclick="expandComments('.$subSectionIDX.');">Cancel</button>';

#             $str .= '<button style="margin-left: 15px; margin-top: 5px!important; width: 150px;" onclick="sae_saveToTemplate('.$subSectionIDX.');">Save as Template...</button><br>';
#             $str .= '<b>Posted Comments:</b><br>';

#             $str .= '<div ID="comments_posted_'.$subSectionIDX.'" class="w3-bar-item w3-panel " style="background-color: transparent!important; width: 100%!important; padding: 0px; ">' ;
#             foreach $commentIDX (sort {$b<=>$a} keys %{$COMMENTS{$subSectionIDX}}){
#                 $str .= &renderComments($cardIDX, $commentIDX, $subSectionIDX, $COMMENTS{$subSectionIDX}{$commentIDX}{CL_COMMENT}, $COMMENTS{$subSectionIDX}{$commentIDX}{FK_USER_IDX}, $userIDX);
#             }
#                 $str .= '</div>';
#                 $str .= '</li>';
                
#             }
#             $str .= '</ul>';
#             $str .= '</div>';
#         }
#     }
#     my $TeamData = new SAE::GRADE();
#     my %TEAM = %{$TeamData->_getTeamData($teamIDX)};
#     if (($inType==2 && $classIDX==1)) {
#         $str .= '<div class="w3-container w3-round w3-border w3-margin-top w3-card-2 w3-padding">';
#         $str .= '<h3>Team\'s Prediction Data</h3>';
#         $str .= sprintf '<label>Slope:</label><input class="w3-input w3-border w3-round w3-align-right w3-margin-left" style="width: 150px; display: inline-block" type="number"  step="0.000001" max="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%1.6f">', 'IN_SLOPE', $teamIDX, $TEAM{IN_SLOPE};
#         $str .= sprintf '<label class="w3-margin-left">Y-Intercept:</label><input class="w3-input w3-border w3-round w3-align-right w3-margin-left" style="width: 150px; display: inline-block"  type="number"  step="0.01" min="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%1.2f">', 'IN_YINT', $teamIDX, $TEAM{IN_YINT};
#         $str .= '</div>';
#     }
#     $str .= '</div>';
#     return ($str);
#     }
# sub sae_openImportDesignScores(){
#         print $q->header();
#     my $userIDX = $q->param('userIDX');
#     my $eventIDX= $q->param('eventIDX');
#     my $User = new SAE::USER();
#     my %JUDGES = %{$User->_getJudges()};
#     my $str;
    
#     $str .= '<form class="w3-container w3-padding" action = "javascript:void(0);" method = "post" enctype = "multipart/form-data">';
#     $str .= sprintf '<label class="w3-text-grey" >Judge that performed the assessment:</label><br>';
#     $str .= '<select ID="JUDGE_IDX" class="w3-select w3-border w3-round">';
#     foreach $judgeIDX (sort {lc($JUDGES{$a}{TX_LAST_NAME}) cmp lc($JUDGES{$b}{TX_LAST_NAME})} keys %JUDGES) {
#         my $selected = '';
#         if ($judgeIDX == $userIDX){$selected = 'selected'}
#      $str .= sprintf '<option value="%d" %s>%s, %s</option>', $judgeIDX, $selected, $JUDGES{$judgeIDX}{TX_LAST_NAME}, $JUDGES{$judgeIDX}{TX_FIRST_NAME};   
#     }
#     $str .= '</select>';
#     $str .= '<div class="w3-center w3-light-grey w3-padding w3-border w3-round w3-margin-top">';
#     $str .= sprintf '<label class="w3-text-grey" >Select the Excel file to import</label><br>';
#     # $str .= '<label for="file" class="w3-button w3-border w3-green w3-round" style="display: in-line;">';
#     $str .= '<label for="file" class="w3-button w3-border w3-grey w3-round" style="display: inline-block; width: 100%; overflow-hidden">';
#     $str .= 'Browse ...';
#     $str .= '</label>';
#     $str .= sprintf '<input id="file" class="w3-round w3-border" style="display: none;" type="file" name="filename" onchange="getFileName(this);"/>';
#     $str .= '</div>';
#     $str .= '<div class="w3-panel w3-padding w3-center">';
#     $str .= sprintf '<button class="w3-button w3-round w3-border" style="width: 155px;" onclick="sae_uploadDesignExcelScoresheet(this, %d);">Upload</button>', $eventIDX;
#     $str .= '<button class="w3-button w3-border w3-round w3-margin-left" style="width: 155px;" onclick="$(this).close();">Cancel</button>';
#     $str .= '<div id="uploadedDisplay" class="w3-container w3-padding">';
#     $str .= '</div>';
#     $str .= '</div>';
#     $str .= '</form>';
#     return ($str);
#     }