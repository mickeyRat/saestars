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
# use SAE::TEAM;
my $Util = new SAE::Common();

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
# ===============2023 =====================================================
sub grade_loadInstructions (){
    my $txFirstName     = $q->param('txFirstName');
    print $q->header();
    my $str = &t_scoringGuide($txFirstName);
    return ($str);
    }
sub grade_deleteTemplate (){
    my $tempIDX= $q->param('tempIDX');
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $str = $JsonDB->_delete('TB_TEMPLATE', qq(PK_TEMPLATE_IDX=$tempIDX));
    return ($str);
    }
sub grade_openTemplateList (){
    my $userIDX= $q->param('userIDX');
    my $Paper    = new SAE::REPORTS();
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
        $str .= sprintf '<i class="fa fa-download w3-white w3-button w3-hover-blue w3-round w3-border" data-value="%s" aria-hidden="true" onclick="grade_loadTemplate(this, %d);"></i>', $comments, $tempIDX;
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
sub grade_openTemplate (){
    my $userIDX= $q->param('userIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str .= '<div class="w3-container w3-card w3-border w3-round">';
    # $str .= '<label>Template Title</label><br>';
    $str .= '<input ID="templateTitle" type="text" class="w3-input w3-border w3-round w3-card-2 w3-margin-top" placeholder="Template Title">';
    $str .= sprintf '<textarea rows="10" ID="templateComment" class="w3-margin-top w3-input w3-border w3-border-black w3-round">%s</textarea>', $DATA{CL_COMMENT};
    $str .= '<div class="w3-container w3-center">';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-green w3-hover-green w3-margin-top w3-card" onclick="grade_saveTemplate(this)">SAVE</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-red w3-hover-red w3-margin-top w3-margin-left" onclick="$(this).close(\'sae-top2\');">Cancel</button>';
    $str .= '</div>';
    $str .= '<br>';
    $str .= '</div>';
    return ($str);
    }
sub grade_updateComments (){
    print $q->header();
    my $commentIDX = $q->param('commentIDX');
    my $userIDX    = $q->param('userIDX');
    my %DATA       = %{decode_json($q->param('jsonData'))};
    my $JsonDB     = new SAE::JSONDB();
        $JsonDB->_update('TB_COMMENTS', \%DATA, qq(PK_COMMENTS_IDX=$commentIDX));
    my $str = &t_commentBlocks($commentIDX, $DATA{CL_COMMENT}, $userIDX, $userIDX, 'Just Edited...');
    return ($str);
    }
sub grade_editComment (){
    my $commentIDX= $q->param('commentIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper    = new SAE::REPORTS();
    my $comments = $Paper->_getCommentById($commentIDX);
    my $str;
    $str .= '<div class="w3-container w3-pale-yellow w3-card w3-border w3-round">';
    $str .= sprintf '<textarea rows="10" ID="subsectionComment_update" class="w3-margin-top w3-input w3-border w3-border-black w3-round">%s</textarea>', $comments;
    $str .= '<div class="w3-container w3-center">';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-green w3-hover-green w3-margin-top w3-card" onclick="grade_updateComments(this, '.$commentIDX.')">Update</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-pale-red w3-hover-red w3-margin-top w3-margin-left" onclick="$(this).close(\'sae-top2\');">Cancel</button>';
    $str .= '</div>';
    $str .= '<br>';
    $str .= '</div>';
    
    return ($str);
    }
sub grade_deleteComment (){
    my $commentIDX= $q->param('commentIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    $JsonDB->_delete('TB_COMMENTS', qq(PK_COMMENTS_IDX=$commentIDX));

    return ($str);
    }
sub grade_postComments (){
    # my $userIDX= $q->param('userIDX');
    my $eventIDX= $q->param('eventIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_insert('TB_COMMENTS', \%DATA);
    my $str = &t_commentBlocks($newIDX, $DATA{CL_COMMENT}, $DATA{FK_USER_IDX}, $DATA{FK_USER_IDX}, 'Just Now');
    return ($str);
    }
sub grade_setAssessmentStatus (){
    print $q->header();
    my $cardIDX     = $q->param('FK_CARD_IDX');
    
    my $inStatus    = $q->param('IN_STATUS');
    my $classIDX    = $q->param('FK_CLASS_IDX');
    my $inCardType  = $q->param('FK_CARDTYPE_IDX');
    my $Paper    = new SAE::REPORTS();
       $Paper->_setAssessmentStatus($cardIDX, $inStatus);
    my %DETAILS = %{$Paper->_getCardAndTreamDetails($cardIDX )};
    my $inScore = $Paper->_calculateDesignScore($inCardType, $classIDX, $cardIDX);
    my $str = &t_teamAssessmentBar($cardIDX, $DETAILS{IN_NUMBER}, $DETAILS{TX_SCHOOL}, $classIDX, $DETAILS{FK_TEAM_IDX}, $inStatus, $inScore, $DETAILS{FK_CARDTYPE_IDX});

    return ($str);
    }
sub grade_updateField (){
    print $q->header();
    my $cardIDX  = $q->param('FK_CARD_IDX');
    my $subIDX   = $q->param('FK_SUBSECTION_IDX');
    my $inValue  = $q->param('IN_VALUE');
    my $Paper    = new SAE::REPORTS();
       $Paper->_setSubmitCardScore($cardIDX, $subIDX, $inValue);
       $Paper->_setAssessmentStatus($cardIDX,1);
    my $str;
    return ($str);
    }
sub grade_openHelp (){
    my $subIDX    = $q->param('subIDX');
    my $inSection = $q->param('inSection');
    my $teamIDX   = $q->param('teamIDX');
    my $cardIDX   = $q->param('cardIDX');
    my $userIDX   = $q->param('userIDX');
    my $inValue   = $q->param('inValue');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper      = new SAE::REPORTS();
    my %DETAILS    = %{$Paper->_getSubSectionDetails($subIDX)};
    my %COMMENTS   = %{$Paper->_getSubSectionComments($cardIDX, $subIDX)};
    my $str = '<div class="w3-container" style="height: 600px; padding: 0; overflow-y: scroll; ">';
    my $str = sprintf '<h4 class="w3-pale-yellow w3-border w3-border-black" style="padding: 4px 100px 4px 15px !important; margin-top: 0px;">%d.%d - %s</h4>', $inSection, $DETAILS{IN_SUBSECTION}, $DETAILS{TX_SUBSECTION};
    $str .= '<div class="w3-padding-small">';
    $str .= $DETAILS{CL_DESCRIPTION};
    $str .= '</div>';
    $str .= '<div class="w3-container w3-border-top w3-margin-top w3-pale-yellow w3-border w3-round w3-padding">';
    if ($inValue <=50){
            $str .= '<h5 class="w3-red w3-border w3-round w3-padding">We strongly encourage all judges to provide feedback on score lower than 50%</h5>';
        } else {
            $str .= '<h5 class="w3-blue w3-border w3-round w3-padding">Please provide feedback to help team improve on future design reports</h5>';
        }
    
    $str .= '<textarea rows="3" ID="subsectionComment" class="w3-input w3-border w3-border-black w3-round"></textarea>';
    $str .= sprintf '<button class="w3-button w3-round w3-border w3-hover-green w3-margin-top w3-pale-green w3-card-2" style="width: 130px;" onclick="grade_postComments(this, %d, %d, %d)">Post</button>', $cardIDX, $teamIDX, $subIDX;
    $str .= '<button class="w3-button w3-round w3-border w3-white w3-hover-blue w3-margin-top w3-margin-left w3-card-2" onclick="grade_openTemplate(this);">Save to Template</button>';
    $str .= sprintf '<button class="w3-button w3-round w3-border w3-white w3-hover-blue w3-margin-top w3-margin-left w3-card-2" onclick="grade_openTemplateList(this, %d);">Load from Template</button>', $userIDX ;
    $str .= '</div>';
    $str .= '<div class="w3-container w3-topbar w3-margin-top">';
    $str .= '<ul ID="COMMENT_CONTAINER" class="w3-ul w3-margin-top" style="padding: 0px;">';
    foreach $commentIDX (sort {$b <=> $a} keys %COMMENTS) {
        $str .= &t_commentBlocks($commentIDX, $COMMENTS{$commentIDX}{CL_COMMENT}, $userIDX, $COMMENTS{$commentIDX}{FK_USER_IDX}, $COMMENTS{$commentIDX}{TS_CREATE});
    }
    $str .= '</ul>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
sub grade_openAssessment(){
    my $eventIDX   = $q->param('eventIDX');
    my $userIDX    = $q->param('userIDX');
    my $classIDX   = $q->param('classIDX');
    my $cardIDX    = $q->param('cardIDX');
    my $teamIDX    = $q->param('teamIDX');
    my $inCardType = $q->param('inCardType');
    my $txFirstName  = $q->param('txFirstName');
    # my $inCardType = 1;
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper      = new SAE::REPORTS();
    my $Ref        = new SAE::REFERENCE();
    my %SECTION    = %{$Paper->_getPaperSection($inCardType, $classIDX)};
    my %SUBSECTION = %{$Paper->_getPaperSubSection()};
    my %SCORES     = %{$Paper->_getCardScores($cardIDX)};
    my %REPORT     = %{$Ref->_getTeamDocuments($eventIDX)};
    my $str = '<div class="w3-container w3-grey" style="text-align: right; padding: 10px; ">';
    $str .= '<button class="w3-button w3-border w3-round w3-light-grey" onclick="grade_loadInstructions(this);">Instructions</button>';
    $str .= '<a class="w3-button w3-border w3-round w3-text-black  w3-light-grey w3-margin-left" href="read.html?fileID='.$REPORT{$teamIDX}{$DOC{$inCardType}}{TX_KEYS}.'&location='.$eventIDX.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inCardType}}{TX_KEYS}.'&location='.$eve.'\',\'report\',\'width=1000,height=600\')">Download</a>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-4 w3-yellow w3-margin-left" onclick="grade_setAssessmentStatus(this, %d, %d, %d, %d);">Exit & Save as Draft</button>', $cardIDX , 1, $classIDX, $inCardType ;
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-card-4 w3-blue w3-margin-left" onclick="grade_setAssessmentStatus(this, %d, %d, %d, %d);">Save as Final</button>', $cardIDX , 2, $classIDX, $inCardType ; #2= Status of the assessment.  2=Complete; 1=Draft; 0=Not Started
    $str .= '</div>';
    $str .= '<div class="w3-container w3-row" style="padding: 0px; ">';
    my $instruction = &t_scoringGuide($txFirstName);
    $str .= '<div class="w3-third w3-container w3-light-grey w3-border w3-card-2" style="padding: 0px;">';
    $str .= '<table class="w3-table w3-white w3-card-4">';
    $str .= '<tr>';
    $str .= sprintf '<th></th>';
    $str .= '<th style="width: 100px; text-align: center;">Score<br>(0-100%)</th>';
    $str .= '</tr>';
    my $color = 'w3-white';
    if ($inCardType>1) {
        $str .= '<tr>';
        $str .= '<td class="w3-white w3-border" style="text-align: right; vertical-align: middle;">Select All</td>';
        $str .= sprintf '<td class="w3-white w3-center w3-border" style="vertical-align: middle;"><span class="w3-small"><input class="w3-check" type="checkbox" onclick="selectAllCheckBox(this, \'%s\', %d);"></td>','yesNo', $cardIDX;
        $str .= '</tr>';
        # $color = 'w3-light-grey';
    }
    foreach $sectionIDX (sort {$SECTION{$a}{IN_SECTION} <=> $SECTION{$b}{IN_SECTION}} keys %SECTION) {
        my $inSection = $SECTION{$sectionIDX}{IN_SECTION};
        my $txSection = $SECTION{$sectionIDX}{TX_SECTION};
        foreach $subIDX (sort {$SUBSECTION{$sectionIDX}{$a}{IN_SUBSECTION} <=> $SUBSECTION{$sectionIDX}{$b}{IN_SUBSECTION}} keys %{$SUBSECTION{$sectionIDX}}) {
            my $subInSection = $SUBSECTION{$sectionIDX}{$subIDX }{IN_SUBSECTION};
            my $txSubSection = $SUBSECTION{$sectionIDX}{$subIDX}{TX_SUBSECTION};
            my $entryType    = $SUBSECTION{$sectionIDX}{$subIDX}{IN_TYPE};
            $str .= '<tr class="rowTitle">';
            $str .= sprintf '<td class="w3-hover-pale-yellow w3-border" ><a class=" w3-text-black" href="javascript:void(0);" style="text-decoration: none;" onclick="grade_openHelp(this, %d, %d, %d, %d);">%d.%d: (%s) - %s</a></td>',$subIDX, $inSection, $cardIDX, $teamIDX, $inSection, $subInSection, $txSection, $txSubSection;
            $str .= sprintf '<td class="'.$color.' w3-center w3-border" style="padding: 0; vertical-align: middle;" onclick="grade_openHelp(this, %d, %d, %d, %d);">',$subIDX, $inSection, $cardIDX, $teamIDX;
            if (exists $SCORES{$subIDX}){
                    my $inValue = $SCORES{$subIDX}{IN_VALUE};
                    if ($entryType == 0) {
                            $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="text" value="'.$inValue.'" style="text-align: center;" class="w3-input w3-border-0 w3-round" onKeyDown="grade_moveToNextField(event, this);" onfocus="grade_openHelp(this, %d, %d, %d, %d);" onchange="grade_updateField(this, %d, %d)">', $subIDX, $inSection, $cardIDX, $teamIDX, $cardIDX, $subIDX;
                        } else {
                            my $checked = '';
                            if ($inValue >0){$checked ='checked'}
                            $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="checkbox" '.$checked.' style="text-align: center;" class="w3-check w3-border-0 w3-round yesNo" data-value="'.$subIDX.'" onchange="grade_updateCheckField(this, %d, %d);">', $cardIDX, $subIDX;
                        }
                } else {
                    if ($entryType == 0) {
                        $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="text" style="text-align: center;" placeholder="0%" class="w3-input w3-border-0 w3-round" onKeyDown="grade_moveToNextField(event, this);" onfocus="grade_openHelp(this, %d, %d, %d, %d);" onchange="grade_updateField(this, %d, %d)">', $subIDX, $inSection, $cardIDX, $teamIDX, $cardIDX, $subIDX;
                    } else {
                        $str .= sprintf '<input tabindex="'.$tabIndex++.'" type="checkbox" style="text-align: center;" class="w3-check w3-border-0 w3-round yesNo" data-value="'.$subIDX.'" onchange="grade_updateCheckField(this, %d, %d);">', $cardIDX, $subIDX;
                    }
                }
                $str .= '</td>';

            $str .= '</tr>';
        }
    }
    $str .= '</table>';
    $str .= '</div>';
    $str .= '<div ID="AssessmentHelper" class="w3-twothird w3-container w3-white">';
    $str .= &t_scoringGuide($txFirstName);
    
    $str .= '</div>';
    
    $str .= '<br>'x2;
    
    $str .= '</div>';
    return ($str);
    }
sub t_scoringGuide (){
    my ($txFirstName) = @_;
    my $str;
    $str = '<h4 style="padding: 4px 10px !important; margin-top: 0px;" class="w3-center w3-pale-yellow w3-border ">Scoring Guide</h4>';
    $str .= '<div class="w3-container w3-border w3-round w3-card">';
    $str .= '<br><p><b>'.$txFirstName.'</b>,<br><br>Thank you for taking time to support this event.<br>Below are the instructions on how we like for you tofolow as you grade this important portion of the Design Report/p><br>';
    $str .= '<ol type="1" style="padding: 12px; "><span class="w3-large"><b>INSTRUCTIONS</b></span>';
    $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Use grading scale from 0-100%.</li>';
    $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Click [ Download ] to access the Design Report.</li>';
    $str .= '<li style="margin-left: 35px; padding: 10px 5px;">The goal of SAE Aero-Design is to promote a positive learning environment and encourage students to continue to pursue engineering mindset.  Comments & feedback are <b>strongly</b> encouraged especially if you believe they\'ve earned a score 50% or below.</li>';
    $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Please keep all comments & feedback <u><i>positive and constructive</i></u>.  Provide examples on how the team can improve their scores if they had included x, y, & z to substanciate their claims.</li>';
    $str .= '<li style="margin-left: 35px; padding: 10px 5px;">Click in each section "score box" to learn more about the scoring criteria</li>';
    $str .= '<li class="w3-text-red" style="margin-left: 35px; padding: 10px 5px;"><b>IMPORTANT!</b> Scores are auto-saved as "Draft" as you enter them.  When you feel confident that your assessment is complete and accurate, Click on [ Save as Final ] at the top right corner of this assessment page to sumbit your <b>FINAL</b> Assessment.</li>';
    $str .= '</ol>';
    $str .= '</div>';
    $str .= '<br>'x3;
    return ($str);
    }
sub t_commentBlocks (){
    my ($commentIDX, $txComments, $currentUser, $userIDX, $tsCreate) = @_;
    my $str;
    # my $txComments = $COMMENTS{$commentIDX}{CL_COMMENT};
    $txComments =~ s/\n/<br>\n/g;
    $str .= '<li ID="Comment_'.$commentIDX.'" class="w3-bar w3-display-container w3-border w3-round w3-margin-bottom w3-card w3-pale-yellow" style="padding: 3px 0px 3px 3px;">';
    if ($currentUser == $userIDX){
        $str .= '<div class="w3-display-topright">';
        $str .= '<i class="fa fa-pencil w3-button w3-round w3-hover-green" aria-hidden="true" onClick="grade_editComment('.$commentIDX.')">...</i>';
        $str .= '<i class="fa fa-times w3-button w3-round w3-hover-red" aria-hidden="true" onClick="grade_deleteComment('.$commentIDX.');"></i>';
        $str .= '</div>';
    }
    $str .= '<div class="w3-bar-item w3-margin-right" style="padding: 3px; margin-top: 30px !important;">';
    $str .= $txComments;
    $str .= '<br>';
    $str .= sprintf '<span class="w3-small w3-text-blue">%s</span>',$tsCreate;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
    }
sub t_teamAssessmentBar(){
    my ($cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inStatus, $inScore, $inCardType)= @_;
    my %BTN_STATUS = (0=>'Start', 1=>'Continue', 2=>'Completed');
    my %BTN_COLOR  = (0=>'w3-white', 1=>'w3-yellow', 2=>'w3-blue');
    my %MAXSCORE = (1=>35, 2=>5, 3=>5, 4=>5);
    my $str;
    $str .= '<li ID="CARD_'.$cardIDX.'" class="w3-bar w3-border w3-white w3-round-large w3-card-2 w3-hover-pale-yellow" style="margin-bottom: 3px;">';
    $str .= '<div class="w3-container w3-padding-small">';
    $str .= '<table class="r" style="width: 100%; padding: 0px;">';
    $str .= '<tr>';
    $str .= sprintf '<td class="w3-large"  style="text-align: left;"><b>%03d</b> - %s</td>', $inNumber , $txSchool;
    if ($inScore>0){
            $str .= sprintf '<td style="width: 15%; text-align: right;">%1.4f/%2.1f <i>(%2.1f%)</i></td>', $inScore, $MAXSCORE{$inCardType}, 100*($inScore/$MAXSCORE{$inCardType});
        } else {
            $str .= sprintf '<td style="width: 15%; text-align: right;">0/%2.1f (0.0%)</td>', $MAXSCORE{$inCardType};
        }
    $str .= sprintf '<td style="width: 125px;  text-align: right;">';
    $str .= sprintf '<button class="w3-button %s w3-border w3-card w3-round w3-hover-green" onclick="grade_openAssessment(this, %d, %d, \'%s\', %d, %d, %d)">%s</button>', $BTN_COLOR{$inStatus}, $cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $BTN_STATUS{$inStatus};
    $str .= '</td>';
    $str .= '</tr>';
    $str .= '</table>';
    # $str .= sprintf '%03d - %s', $CARDS{$cardIDX}{IN_NUMBER}, $CARDS{$cardIDX}{TX_SCHOOL};
    $str .= '</div>';

    $str .= '</li>';
    return ($str);
    }
# =========================================================================
# SAVE AND UPDATE REPORT SCORES
sub sae_updateReportAssessment(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $Grade = new SAE::GRADE();
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $cardIDX = $q->param('cardIDX'); 
    my $teamIDX = $q->param('teamIDX'); 
    my $inType = $q->param('inType'); 
    my $status = $q->param('status'); 
    $Grade->_updateCardAssessments($cardIDX, \%DATA);
    $Grade->_updateCardStatus($cardIDX, $status);
    %CARDTYPE = %{$Ref->_getCardTypeList()};
    my $str = sprintf "%2.4f / %2.1f", $Ref->_calculatePaperScores($teamIDX, $cardIDX, $inType), $CARDTYPE{$inType}{IN_POINTS};
    return ($str);
    }
sub sae_submitReportAssessment(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $Grade = new SAE::GRADE();
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $teamIDX = $q->param('teamIDX'); 
    my $cardIDX = $q->param('cardIDX'); 
    my $inType = $q->param('inType'); 
    my $status = $q->param('status'); 
    $Grade->_saveAssessments($teamIDX, $cardIDX, $inType, \%DATA);
    $Grade->_updateCardStatus($cardIDX, $status);
    %CARDTYPE = %{$Ref->_getCardTypeList()};
    my $str = sprintf "%2.4f / %2.1f", $Ref->_calculatePaperScores($teamIDX, $cardIDX, $inType), $CARDTYPE{$inType}{IN_POINTS};
    return ($str);
    }
# =========================================================================
# COMMENTS & TEMPLATE
sub sae_updateComments(){
    print $q->header();
    my $commentIDX = $q->param('commentIDX'); 
    my $comments = $q->param('comments');  
    my $teamIDX = $q->param('teamIDX');  
    my $Reports = new SAE::REPORTS();
    my $Util = new SAE::Common();
    %COMMENT = %{$Reports->_updateComments($comments , $commentIDX)};
    my $str = uri_unescape($comments);
    return($str);
    }
sub sae_editComments(){
    print $q->header();
    my $commentIDX = $q->param('commentIDX'); 
    my $Reports = new SAE::REPORTS();
    my $Util = new SAE::Common();
    %COMMENT = %{$Reports->_loadCommentsToEdit($commentIDX)};
    my $str = $Util->removeBr($COMMENT{$commentIDX}{CL_COMMENT});
    return($str);
    }
sub sae_applyTemplate(){
    print $q->header();
    my $templateIDX = $q->param('templateIDX'); 
    my $Reports = new SAE::REPORTS();
    my $Util = new SAE::Common();
    %COMMENT = %{$Reports->_loadTeamplateItem($templateIDX)};
    # my $str = $templateIDX.' '.$COMMENT{$templateIDX}{CL_COMMENT};
    my $str = $Util->removeBr($COMMENT{$templateIDX}{CL_COMMENT});
    return($str);
    }
sub sae_saveToTemplate(){
    print $q->header();
    my $title = $q->param('title');  
    my $userIDX = $q->param('userIDX');  
    my $comments = $q->param('comments');  
    my $Reports = new SAE::REPORTS();
    my $templateIDX = $Reports->_saveToTemplate($title, $userIDX, $comments);
    my $str = '<option value="'.$templateIDX.'">'.$title.'</option>';
    # $str = 'test';
    return($str);
    }
sub sae_deleteComment(){
    print $q->header();
    my $commentIDX = $q->param('commentIDX');  
    my $Reports = new SAE::REPORTS();
    $Reports->_deleteComment($commentIDX);
    return($commentIDX);
    }
sub sae_postComments(){
    print $q->header();
    my $cardIDX = $q->param('cardIDX');  
    my $userIDX = $q->param('userIDX');  
    my $teamIDX = $q->param('teamIDX');  
    my $subSectionIDX = $q->param('subSectionIDX');  
    my $comments = $q->param('comments');  
    my $Reports = new SAE::REPORTS();
    my $commentIDX = $Reports->_postComments($cardIDX, $subSectionIDX, $userIDX, $comments, $teamIDX);
    my $str = &renderComments($cardIDX, $commentIDX, $subSectionIDX, uri_unescape($comments), $userIDX, $userIDX, $teamIDX );
    return ($str);
    }
# # =========================================================================
sub renderComments(){
    my $cardIDX = shift;
    my $commentIDX = shift;
    my $subSectionIDX = shift;
    my $comments = shift;
    my $userIDX = shift;
    my $commentUserIDX = shift;
    my $teamIDX = shift;
    my $User = new SAE::USER();
    my $admin = $User->_getAdminStatus($commentUserIDX);
    my $judgeName = $User->_getUserById($userIDX);
    my $str = '<div ID="subSectionComments_'.$commentIDX.'" class="w3-bar-item w3-small w3-white w3-border w3-border-yellow w3-leftbar w3-display-container" style="margin-bottom: 5px; width: 100%!important">';
    # $str .= sprintf '<label class="w3-tiny">Comment ID: %d</label>', $commentIDX;
    $str .= sprintf '<p ID="subSectionCommentItem_%d" >%s<br><label class="w3-tiny">Posted By: %s</label></p>', $commentIDX, $comments, $judgeName;
    if ($commentUserIDX == $userIDX || $admin==1){
        $str .= '<span onclick="sae_deleteComment('.$commentIDX.');" class="w3-button w3-display-topright">X</span>';
        $str .= '<a href="javascript:void(0);" onclick="sae_editComments('.$cardIDX.','.$subSectionIDX.','.$commentIDX.','.$teamIDX.')">Edit</a>';
    } 
    $str .= '</div>';
    return ($str);
    }
sub openAssessment(){
    print $q->header(); 
    my $divName = $q->param('divName');  
    my $classIDX = $q->param('classIDX');  
    my $cardIDX = $q->param('cardIDX');  
    my $inNumber = $q->param('inNumber');  
    my $userIDX = $q->param('userIDX');  
    my $teamIDX = $q->param('teamIDX');  
    my $location = $q->param('location');  
    my $from = $q->param('from');  
    my $inType = $q->param('inType');  # CardTypeIDX
    
    my $dbi = new SAE::Db();
    my $Rubric = new SAE::RUBRIC();
    my $Reports = new SAE::REPORTS();
    my $Ref = new SAE::REFERENCE();
    %SECTION = %{$Rubric->_getSectionList()};
    %SUBSECTION = %{$Rubric->_getSubSectionList()};
    # %COMMENTS = %{$Reports->_loadComments($cardIDX)};
    %COMMENTS = %{$Reports->_loadAllComments($teamIDX)};
    %TEMPLATE = %{$Reports->_loadTeamplate($userIDX)};
    %PAPER = %{$Reports->_getCardRecords($cardIDX)};
    %REPORT = %{$Ref->_getTeamDocuments($location)};
    # %REPORT = %{$Ref->_getTeamDocuments(28)};
    %SECAVG = %{$Ref->_getSectionAverage($teamIDX, $inType)};
    %CARDTYPE = %{$Ref->_getCardTypeList()};
    %BINARY = %{$Reports->_isBinaryInputs()};
    %DOC = (1=>1, 2=>2, 3=>3, 4=>1);
    my $str;
    # $str .= scalar (keys %{$SECTION{$inType}});
    $str .= '<div class="w3-display-container w3-border-bottom w3-card-4 w3-padding" >';
    
    # $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="_blank" >Download</a>';
    # $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
    # $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
    $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="read.html?fileID='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'read.html?fileIDdoc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
    $str .= '<button class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '<button id="button_expandSections" class="w3-button w3-border w3-margin-left w3-round" style="width: 160px; margin-left: 172px;" onclick="sae_collapseSections();">Collapse Sections</button>';
    $str .= '<button id="button_expandAll" class="w3-button w3-border  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_expandAll();">Expand ALL</button>';
    # $str .= '<button id="button_expandAll" class="w3-button w3-border  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_resetScores('.$cardIDX.');">Reset</button>';
    
    if (scalar(keys %PAPER)>0){
        $str .= '<button id="button_expandAll" class="w3-button w3-border w3-hover-yellow  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_updateReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',1, '.$from.');">Update As Draft</button>';
        $str .= '<button class="w3-button w3-border w3-blue w3-margin-left w3-round " style="width: 140px; margin-right: 16px;" onclick="sae_updateReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',2, '.$from.');">Update as Final</button>';
    } else {
        $str .= '<button id="button_expandAll" class="w3-button w3-border w3-hover-yellow  w3-margin-left w3-round" style="width: 140px; margin-left: 348px;" onclick="sae_submitReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',1, '.$from.');">Save As Draft</button>';
        $str .= '<button class="w3-button w3-border w3-blue w3-margin-left w3-round" style="width: 140px; margin-right: 16px;" onclick="sae_submitReportAssessment('.$cardIDX.',\''.$divName.'\','.$teamIDX.','.$inType.',2, '.$from.');">Submit as Final</button>';
    }
    $str .= '</div>';


    $str .= '<div class="w3-container" style="height: 650px; overflow: auto; margin-top: 10px;" >';
    my $secWeight = 0;
    my $tabCount = 1;

    
    foreach $sectionIDX (sort {$SECTION{$inType}{$a}{IN_SECTION} <=> $SECTION{$inType}{$b}{IN_SECTION}} keys %{$SECTION{$inType}}){
        my $secName = $SECTION{$inType}{$sectionIDX}{TX_SECTION};
        my $secNumber = $SECTION{$inType}{$sectionIDX}{IN_SECTION};
        my $secWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
        my $secClass = $SECTION{$inType}{$sectionIDX}{IN_CLASS};
        %APP = (0=>"All", 1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
        if (($secClass == $classIDX) || ($secClass == 0)) {
        $str .= '<button tabstop="false" tabindex="-1" style="margin-top: 2px;" class="w3-button w3-display-container w3-block w3-left-align w3-blue-grey sae-section_grade_'.$sectionIDX.'" ';
        $str .= 'onclick="expandSubsection(this, '.$sectionIDX.')" >';
        $str .= '<i class="fa fa-chevron-down fa-all"></i>&nbsp;&nbsp;';
        $str .= '<span ID="sectionButton_'.$sectionIDX.'" >'.$secNumber.' - '.$secName.' - '.$APP{$secClass}.'</span>';
        $str .= sprintf '<span class="w3-right">Average Score: <span ID="sectionAverage_'.$sectionIDX.'">%2.2f</span>%</span>', $SECAVG{$sectionIDX}{IN_AVERAGE};
        $str .= '</button>';
        $str .= '<div ID="section_'.$sectionIDX.'" class="w3-container w3-white w3-card-2 w3-border sae-allexpand sae-subsections-div sae-section_grade_'.$sectionIDX.'">';
        # $str .= '<div ID="section_'.$sectionIDX.'" class="w3-hide w3-container w3-white w3-card-2 w3-border sae-allexpand sae-subsections-div sae-section_grade_'.$sectionIDX.'">';
        $str .= '<ul  class="w3-ul w3-card-2" >';
        if (exists $BINARY{$sectionIDX}){
            $str .= '<div class="w3-third w3-container"></div>';
            $str .= '<div class="w3-third w3-container" style="padding-left:22px;">';
            $str .= '<input  ID="forSelectAll" type="checkbox" class="w3-check" onclick="toggleSelection(\'inputBinary\', this);">&nbsp; <label for="forSelectAll" class="w3-small">Select All</label>';
            $str .= '</div>';
            $str .= '<div class="w3-third w3-container"></div>';
        }
        
        foreach $subSectionIDX (sort {$SUBSECTION{$sectionIDX}{$a}{IN_SUBSECTION} <=> $SUBSECTION{$sectionIDX}{$b}{IN_SUBSECTION}} keys %{$SUBSECTION{$sectionIDX}}) {
            $subSectionNumber = $SUBSECTION{$sectionIDX}{$subSectionIDX}{IN_SUBSECTION};
            $subSectionTitle = $SUBSECTION{$sectionIDX}{$subSectionIDX}{TX_SUBSECTION};
            $inputType = $SUBSECTION{$sectionIDX}{$subSectionIDX}{IN_TYPE};
            $inPoints = $CARDTYPE{$inType}{IN_POINTS};
            
            $str .= '<li class="w3-bar w3-row" style="padding: 1px;">';
            $str .= '<div class="w3-bar-item" style="width: 100%;">';
                $str .= '<div ID="instruction_'.$subSectionIDX .'" class="w3-hide w3-padding-small w3-display-container sae-allexpand w3-round-large w3-pale-blue w3-border w3-card-2 w3-small" style="padding: 10px; padding-right: 37px!important; margin-bottom: 8px;"><u><b>'.$secNumber.'.'.$subSectionNumber.' - '.$subSectionTitle.' Scoring Critieria</b></u><br>';
                $str .= '<span onclick="showScoringCriteria(this,'.$subSectionIDX.');" class="w3-button w3-display-topright">X</span>';
                $str .= '<p>'.$SUBSECTION{$sectionIDX}{$subSectionIDX}{CL_DESCRIPTION}.'</p><br>';
                $str .= '<span class="w3-padding w3-red w3-round w3-card-2">NOTE: If your assessment is below '.$SUBSECTION{$sectionIDX}{$subSectionIDX}{IN_THRESHOLD}.'%, please provide comments so that the team can learn and adjust for future entries</span>';
                $str .= '<br><br></div>';
                $str .= '<div class="w3-third w3-container">';
                $str .= "<span>$secNumber.$subSectionNumber - $subSectionTitle</span><br>" ;
                $str .= '<a tabstop="false" style="margin-left: 20px;" tabindex="'.($tabCount * -1).'" class="w3-small" href="javascript:void(0);" onclick="expandInstruction(this, '.$subSectionIDX.');"><span class="fa fa-question fa-fw"></span>Scoring Guide</a>';
                $str .= '</div>';
                $str .= '<div class="w3-third w3-container">';
                my $checked = "";
                if ($inputType==0){
                    $str .= '<input type="number" tabindex="'.($tabCount++).'" ';
                    $str .= 'class="w3-border sae-inputs sae-input-'.$subSectionIDX.' sae-input-group-'.$sectionIDX.'" ';
                    $str .= 'data-weight="'.$secWeight.'" data-key="'.$subSectionIDX.'" data-section="'.$sectionIDX.'" ';
                    $str .= 'onkeyup="sae_calculateNow(this, '.$sectionIDX.', '.$inPoints.');" ';
                    # $str .= 'onblur="validateInput(this);"';
                    if (scalar(keys %PAPER)>0){
                        $str .= 'value="'.$PAPER{$subSectionIDX}{IN_VALUE}.'"';
                    } else {
                        $str .= 'placeholder="0.00"';
                    }
                    $str .= 'min="0" max="100" style="width: 76px; margin-left: 20px; text-align: center;">';
                } else {
                    if (scalar(keys %PAPER)>0 && $PAPER{$subSectionIDX}{IN_VALUE}>0){
                        $checked = "checked";
                    } else {
                        $checked = ""
                    }
                    $str .= '<input ID="inputCheckFor_'.$subSectionIDX.'" type="checkbox" class="w3-check inputBinary" data-key="'.$subSectionIDX.'" value="100" '.$checked.'><label for="inputCheckFor_'.$subSectionIDX.'">Yes, Requirements are met.</label>';
                }
                $str .= '</div>';
                $str .= '<div class="w3-third w3-container">';
                my $commentCount = scalar (keys %{$COMMENTS{$subSectionIDX}});
                if ($commentCount>0){
                    $str .= '&nbsp;&nbsp;<a tabstop="false" tabindex="'.($tabCount * -1).'" class="w3-small w3-margin-left" href="javascript:void(0);" onclick="expandComments('.$subSectionIDX.');"><span class="fa fa-comment-o" ></span> Comments ('.$commentCount.')</a>';
                } else {
                    $str .= '&nbsp;&nbsp;<a tabstop="false" tabindex="'.($tabCount * -1).'" class="w3-small w3-margin-left" href="javascript:void(0);" onclick="expandComments('.$subSectionIDX.');"><span class="fa fa-comment-o" ></span> Comments</a>';
                }
                $str .= '</div>';
            $str .= '</div>';
            $str .= '</li>';
            #Comment Section ----------------------------------
            $str .= '<li ID="comments_'.$subSectionIDX.'" class="w3-bar w3-container w3-hide w3-pale-yellow w3-border w3-small">';
            $str .= 'Template: <select ID="templateList_'.$subSectionIDX.'" onchange="sae_applyTemplate('.$subSectionIDX.');" class="templateList w3-select w3-padding-small w3-medium w3-border w3-white" style="width: 50%;">';
            $str .= '<option value="0">Load from template...</option>';
            foreach $templateIDX (sort {lc($TEMPLATE{$a}{TX_TITLE}) cmp lc($TEMPLATE{$b}{TX_TITLE})} keys %TEMPLATE){
                $str .= '<option value="'.$templateIDX.'">'.$TEMPLATE{$templateIDX}{TX_TITLE}.'</option>';
            }
            $str .= '</select>';
            # $str .= '<button style="margin-left: 0px; margin-top: 5px!important; width: 100px;" onclick="sae_applyTemplate('.$subSectionIDX.');">Apply</button>';
            $str .= '<textarea ID="comments_entry_'.$subSectionIDX.'" class="w3-input w3-border w3-white" style="margin-top: 5px; max-width: 100%; min-width: 100%; min-height: 50px;"></textarea>';
            
            $str .= '<button ID="buttonPostComment_'.$subSectionIDX.'" style="margin-left: 0px; margin-top: 5px!important; width: 100px;" onclick="sae_postComments('.$cardIDX.','.$subSectionIDX.','.$teamIDX.');">Post</button>';
            $str .= '<button ID="buttonCancelComment_'.$subSectionIDX.'" style="margin-left: 15px; margin-top: 5px!important; width: 100px;" onclick="expandComments('.$subSectionIDX.');">Cancel</button>';

            $str .= '<button style="margin-left: 15px; margin-top: 5px!important; width: 150px;" onclick="sae_saveToTemplate('.$subSectionIDX.');">Save as Template...</button><br>';
            $str .= '<b>Posted Comments:</b><br>';

            $str .= '<div ID="comments_posted_'.$subSectionIDX.'" class="w3-bar-item w3-panel " style="background-color: transparent!important; width: 100%!important; padding: 0px; ">' ;
            foreach $commentIDX (sort {$b<=>$a} keys %{$COMMENTS{$subSectionIDX}}){
                $str .= &renderComments($cardIDX, $commentIDX, $subSectionIDX, $COMMENTS{$subSectionIDX}{$commentIDX}{CL_COMMENT}, $COMMENTS{$subSectionIDX}{$commentIDX}{FK_USER_IDX}, $userIDX);
            }
                $str .= '</div>';
                $str .= '</li>';
                
            }
            $str .= '</ul>';
            $str .= '</div>';
        }
    }
    my $TeamData = new SAE::GRADE();
    my %TEAM = %{$TeamData->_getTeamData($teamIDX)};
    if (($inType==2 && $classIDX==1)) {
        $str .= '<div class="w3-container w3-round w3-border w3-margin-top w3-card-2 w3-padding">';
        $str .= '<h3>Team\'s Prediction Data</h3>';
        $str .= sprintf '<label>Slope:</label><input class="w3-input w3-border w3-round w3-align-right w3-margin-left" style="width: 150px; display: inline-block" type="number"  step="0.000001" max="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%1.6f">', 'IN_SLOPE', $teamIDX, $TEAM{IN_SLOPE};
        $str .= sprintf '<label class="w3-margin-left">Y-Intercept:</label><input class="w3-input w3-border w3-round w3-align-right w3-margin-left" style="width: 150px; display: inline-block"  type="number"  step="0.01" min="0" onchange="sae_updateTeamInfo(this,\'%s\',%d)" value="%1.2f">', 'IN_YINT', $teamIDX, $TEAM{IN_YINT};
        $str .= '</div>';
    }
    $str .= '</div>';
    return ($str);
    }
sub sae_openImportDesignScores(){
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
    $str .= sprintf '<button class="w3-button w3-round w3-border" style="width: 155px;" onclick="sae_uploadDesignExcelScoresheet(this, %d);">Upload</button>', $eventIDX;
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" style="width: 155px;" onclick="$(this).close();">Cancel</button>';
    $str .= '<div id="uploadedDisplay" class="w3-container w3-padding">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</form>';
    return ($str);
    }
sub ManageReportAssessments(){
    print $q->header();
    my $Paper = new SAE::REPORTS();
    # my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');  
    my $inType = $q->param('inType');  
    my $eventIDX = $q->param('location'); 
    my %CARDS    = %{$Paper->_getAssignedPapers($eventIDX, $userIDX, $inType)}; 
    my %TITLE    = (1=>'Design Report', 2=>'Technical Data Sheet', 3=>'Drawing', 4=>'Requirement');
    # %TODO = %{$Paper->_getJudgesToDos($userIDX, $inType, $location)};
    # %CLASS = %{$Ref->_getClassList()};
    # %CARDTYPE = %{$Ref->_getCardTypeList()};
    # %PAPER = %{$Ref->_getTeamDocuments($location)};
    # %DOC = (1=>1, 2=>2, 3=>3, 4=>1);
    # %STATUS = (0=>"To Do", 1=>"Draft", 2=>"Done");
    # %W3CLASS = (0=>"w3-white", 1=>"w3-yellow", 2=>"w3-blue");
    my $str;
    $str .= '<br><div class="w3-container w3-margin-top">';  
    # $str .= scalar(keys %TODO)."<br>";
    $str .= sprintf '<h2>%s: <i>Assessments</i></h2>', $TITLE{$inType};
    if ($inType == 1) {
        $str .= '<h3><button class="w3-button w3-border w3-round w3-green w3-hover-light-green w3-small" onclick="sae_openImportDesignScores();">Upload Excel</button></h3>';
    }
    $str .= '<div class="w3-container w3-row-padding">';
        $str .= '<ul class="w3-ul">';
        foreach $cardIDX (sort {$CARDS{$a}{IN_NUMBER} <=> $CARDS{$b}{IN_NUMBER}} keys %CARDS) {
            my $inNumber   = $CARDS{$cardIDX}{IN_NUMBER};
            my $txSchool   = $CARDS{$cardIDX}{TX_SCHOOL};
            my $classIDX   = $CARDS{$cardIDX}{FK_CLASS_IDX};
            my $teamIDX    = $CARDS{$cardIDX}{PK_TEAM_IDX};
            my $inStatus   = $CARDS{$cardIDX}{IN_STATUS};
            my $inCardType = $CARDS{$cardIDX}{FK_CARDTYPE_IDX};
            my $inScore    = $Paper->_calculateDesignScore($inCardType, $classIDX, $cardIDX);
            $str .= &t_teamAssessmentBar($cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inStatus, $inScore, $inCardType);
        }
        $str .= '</ul>';
    $str .= '</div>';

# ==========OLD============
    # foreach $classIDX (sort keys %TODO){
    #     $str .= '<h4>'.$CLASS{$classIDX}{TX_CLASS}.' Class</h4>';
    #     $str .= '<table class="w3-table-all">';
    #     $str .= '<thead>';
    #     $str .= '<tr class="w3-blue-grey w3-hide-small">';
    #     $str .= '<th style="width: 5%;">#</th>';
    #     $str .= '<th>School</th>';
    #     $str .= '<th style="width: 15%;">Document</th>';
    #     $str .= '<th style="width: 15%;">Score</th>';
    #     $str .= '<th style="width: 10%;" >Status</th>'; 
    #     $str .= '</tr>';
    #     $str .= '</thead>';
    #     $str .= '<tbody>';
    #     foreach $cardIDX (sort {$TODO{$classIDX}{$a}{IN_NUMBER} <=> $TODO{$classIDX}{$b}{IN_NUMBER}} keys %{$TODO{$classIDX}}){
    #         my $teamIDX = $TODO{$classIDX}{$cardIDX}{PK_TEAM_IDX};
    #         my $score = $Ref->_calculatePaperScores($teamIDX,$cardIDX,$inType);
    #         $inNumber = substr("000".$TODO{$classIDX}{$cardIDX}{IN_NUMBER},-3,3);
    #         $str .= '<tr class="w3-small  w3-hide-small" >';
    #         $str .= '<td class="w3-small" >'.$inNumber.'</td>';
    #         $str .= '<td class="w3-small" ><a class="w3-link w3-text-blue-grey" href="javascript:void('.$cardIDX.');" onclick="openAssessment('.$cardIDX.',\''.$inNumber.'\','.$classIDX.','.$teamIDX .','.$inType.', 1);">'.$TODO{$classIDX}{$cardIDX}{TX_SCHOOL}.'</a></td>';
    #         $str .= '<td class="w3-small" nowrap >';
    #         if ($PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}){
    #             # $str .= '<a href="view.php?doc='.$PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$DOC{$inType}}{TX_PAPER}.'</a>';
    #             $str .= '<a href="read.html?fileID='.$PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$DOC{$inType}}{TX_PAPER}.'</a>';
    #         } else {
    #             $str .= '<span class="w3-small w3-text-blue-grey">not available</span>';
    #         }
    #         $str .= '</td>';
    #         $str .= sprintf '<td class="teamPaperScores_'.$teamIDX.' w3-small w3-right" nowrap ID="teamPaperScores_'.$teamIDX.'">%2.4f / %2.1f</td>', $score, $CARDTYPE{$inType}{IN_POINTS};
    #         $link = '<a class="w3-link w3-text-black" href="javascript:void('.$cardIDX.');" onclick="openAssessment('.$cardIDX.',\''.$inNumber.'\','.$classIDX.','.$teamIDX .','.$inType.',1);">'.$STATUS{$TODO{$classIDX}{$cardIDX}{IN_STATUS}}.'</a>';
    #         $str .= '<td ID="TD_ASSESSMENT_'.$cardIDX.'" nowrap class="'.$W3CLASS{$TODO{$classIDX}{$cardIDX}{IN_STATUS}}.'" style="text-align: right;">'.$link.'</td>';
    #         $str .= '</tr>';
    #         $str .= '<tr class="w3-hide-medium w3-hide-large ">';
    #         $str .= '<td class="'.$W3CLASS{$TODO{$classIDX}{$cardIDX}{IN_STATUS}}.' w3-card-2 ">';
    #         $str .= sprintf '<b>School:</b> <span class="w3-text-black">%s - %s</span><br>', $inNumber, $TODO{$classIDX}{$cardIDX}{TX_SCHOOL};
    #         $str .= '<b>Document:</b> <span class="w3-text-black">';
    #         if ($PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}){
    #             $str .= '<a href="read.html?fileID='.$PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$DOC{$inType}}{TX_PAPER}.'</a>';
    #             # $str .= '<a href="view.php?doc='.$PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$DOC{$inType}}{TX_PAPER}.'</a>';
    #         } else {
    #             $str .= 'not available';
    #         }
    #         $str .= '</span><br>';
    #         $str .= sprintf '<b>Score:</b> <span class="teamPaperScores_'.$teamIDX.' w3-text-black ">%2.4f / %2.1f</span><br>', $score, $CARDTYPE{$inType}{IN_POINTS};
    #         $str .= '<b>Status:</b> <span class="teamPaperScores_'.$teamIDX.' w3-text-black ">'.$link.'</span><br>';
    #         $str .= '</td>';
    #         $str .= '</tr>';
    #     }
    #     $str .= '</tbody>'; 
    #     $str .= '</table>';
    # }
    # $str .= '</div>';
    return ($str);
}