#!/usr/bin/perl
use cPanelUserConfig;

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
    my $str = '<div ID="subSectionComments_'.$commentIDX.'" class="w3-bar-item w3-small w3-white w3-border w3-border-yellow w3-leftbar w3-display-container" style="margin-bottom: 5px; width: 100%!important">';
    $str .= '<p ID="subSectionCommentItem_'.$commentIDX.'" >'.$comments.'</p>';
    if ($commentUserIDX == $userIDX){
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
    %COMMENTS = %{$Reports->_loadComments($cardIDX)};
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
    $str .= '<a class="w3-button w3-border w3-round" style="width: 140px; margin-left: 16px;" href="view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'" target="report" onclick="window.open(\'view.php?doc='.$REPORT{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'&location='.$location.'\',\'report\',\'width=1000,height=600\')">Download</a>';
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
                $str .= '&nbsp;&nbsp;<a tabstop="false" tabindex="'.($tabCount * -1).'" class="w3-small w3-margin-left" href="javascript:void(0);" onclick="expandComments('.$subSectionIDX.');"><span class="fa fa-comment-o" ></span> Comments</a>';
                $str .= '</div>';
            $str .= '</div>';
            $str .= '</li>';
            #Comment Section ----------------------------------
            $str .= '<li ID="comments_'.$subSectionIDX.'" class="w3-bar w3-container w3-hide w3-pale-yellow w3-border w3-small">';
            $str .= 'Template: <select ID="templateList_'.$subSectionIDX.'" onchange="sae_applyTemplate('.$subSectionIDX.');" class="templateList w3-select w3-padding-small w3-medium w3-border w3-white" style="width: 50%;">';
            $str .= '<option value="0">Load from template...</option>';
            foreach $templateIDX (sort {lc($TEMPLATE{$a}{TX_TITLE}) cmp lc($TEAMPLATE{$b}{TX_TITLE})} keys %TEMPLATE){
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
    $str .= '</div>';
    return ($str);
}
sub ManageReportAssessments(){
    print $q->header();
    my $Reports = new SAE::REPORTS();
    my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');  
    my $inType = $q->param('inType');  
    my $location = $q->param('location');  
    %TODO = %{$Reports->_getJudgesToDos($userIDX, $inType, $location)};
    %CLASS = %{$Ref->_getClassList()};
    %CARDTYPE = %{$Ref->_getCardTypeList()};
    %PAPER = %{$Ref->_getTeamDocuments($location)};
    %DOC = (1=>1, 2=>2, 3=>3, 4=>1);
    %STATUS = (0=>"To Do", 1=>"Draft", 2=>"Done");
    %W3CLASS = (0=>"w3-white", 1=>"w3-yellow", 2=>"w3-blue");
    my $str;
    $str .= '<br><div class="w3-container w3-margin-top">';  
    # $str .= scalar(keys %TODO)."<br>";
    $str .= '<h2>To Do\'s: Grade '.$CARDTYPE{$inType}{TX_TITLE}.'</h2>';
    foreach $classIDX (sort keys %TODO){
        $str .= '<h4>'.$CLASS{$classIDX}{TX_CLASS}.' Class</h4>';
        $str .= '<table class="w3-table-all">';
        $str .= '<thead>';
        $str .= '<tr class="w3-blue-grey w3-hide-small">';
        $str .= '<th style="width: 5%;">#</th>';
        $str .= '<th>School</th>';
        $str .= '<th style="width: 15%;">Document</th>';
        $str .= '<th style="width: 15%;">Score</th>';
        $str .= '<th style="width: 10%;" >Status</th>'; 
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $cardIDX (sort {$TODO{$classIDX}{$a}{IN_NUMBER} <=> $TODO{$classIDX}{$b}{IN_NUMBER}} keys %{$TODO{$classIDX}}){
            my $teamIDX = $TODO{$classIDX}{$cardIDX}{PK_TEAM_IDX};
            my $score = $Ref->_calculatePaperScores($teamIDX,$cardIDX,$inType);
            $inNumber = substr("000".$TODO{$classIDX}{$cardIDX}{IN_NUMBER},-3,3);
            $str .= '<tr class="w3-small  w3-hide-small" >';
            $str .= '<td class="w3-small" >'.$inNumber.'</td>';
            $str .= '<td class="w3-small" ><a class="w3-link w3-text-blue-grey" href="javascript:void('.$cardIDX.');" onclick="openAssessment('.$cardIDX.',\''.$inNumber.'\','.$classIDX.','.$teamIDX .','.$inType.');">'.$TODO{$classIDX}{$cardIDX}{TX_SCHOOL}.'</a></td>';
            $str .= '<td class="w3-small" nowrap >';
            if ($PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}){
                $str .= '<a href="view.php?doc='.$PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$DOC{$inType}}{TX_PAPER}.'</a>';
            } else {
                $str .= '<span class="w3-small w3-text-blue-grey">not available</span>';
            }
            $str .= '</td>';
            $str .= sprintf '<td class="teamPaperScores_'.$teamIDX.' w3-small w3-right" nowrap ID="teamPaperScores_'.$teamIDX.'">%2.4f / %2.1f</td>', $score, $CARDTYPE{$inType}{IN_POINTS};
            $link = '<a class="w3-link w3-text-black" href="javascript:void('.$cardIDX.');" onclick="openAssessment('.$cardIDX.',\''.$inNumber.'\','.$classIDX.','.$teamIDX .','.$inType.');">'.$STATUS{$TODO{$classIDX}{$cardIDX}{IN_STATUS}}.'</a>';
            $str .= '<td nowrap class="'.$W3CLASS{$TODO{$classIDX}{$cardIDX}{IN_STATUS}}.'" style="text-align: right;">'.$link.'</td>';
            $str .= '</tr>';
            $str .= '<tr class="w3-hide-medium w3-hide-large ">';
            $str .= '<td class="'.$W3CLASS{$TODO{$classIDX}{$cardIDX}{IN_STATUS}}.' w3-card-2 ">';
            $str .= sprintf '<b>School:</b> <span class="w3-text-black">%s - %s</span><br>', $inNumber, $TODO{$classIDX}{$cardIDX}{TX_SCHOOL};
            $str .= '<b>Document:</b> <span class="w3-text-black">';
            if ($PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}){
                $str .= '<a href="view.php?doc='.$PAPER{$teamIDX}{$DOC{$inType}}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$DOC{$inType}}{TX_PAPER}.'</a>';
            } else {
                $str .= 'not available';
            }
            $str .= '</span><br>';
            $str .= sprintf '<b>Score:</b> <span class="teamPaperScores_'.$teamIDX.' w3-text-black ">%2.4f / %2.1f</span><br>', $score, $CARDTYPE{$inType}{IN_POINTS};
            $str .= '<b>Status:</b> <span class="teamPaperScores_'.$teamIDX.' w3-text-black ">'.$link.'</span><br>';
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '</tbody>'; 
        $str .= '</table>';
    }
    $str .= '</div>';
    return ($str);
}