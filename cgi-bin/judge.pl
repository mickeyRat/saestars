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
use Mail::Sendmail;
# use HTML::Entities;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Common;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::TB_PAPER;
use SAE::TB_COMMENT;
use SAE::TB_COMMENT_TEMP;
use SAE::TB_UPLOAD;
use SAE::TB_SCORE_GROUP;
use SAE::TB_SCORE;
use SAE::TB_SCORE_SECTION;
use SAE::Tabulate;
# use SAE::Auth;
# use SAE::TB_USER_TEAM;
# use SAE::TB_EVENT;
# use SAE::TB_USER_EVENT;

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
sub __template(){
    print $q->header();
    my $location = $q->param('location');

    my $str;
    $str .= '<a class="button small" style="float: right;" href="javascript:void(0)" onclick="deleteDiv(\'DIV_OPEN_COMMENT_TEMPLATES\');">Exit</a>';

    return ($str);
}

#================== REQUEST MORE =========================== 2019
sub requestMore(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $txType = $q->param('TxType');
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $dbi = new SAE::Db();

    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};

    my $SQL = "SELECT GRADE.* FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=? AND TX_TYPE=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location, $txType);
    my %GRADE = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_GRADE_IDX'])};

    $SQL = "SELECT FK_TEAM_IDX FROM TB_GRADE WHERE FK_USER_IDX=? AND TX_TYPE=?";
    $select = $dbi->prepare($SQL);
    $select->execute($userIDX, lc($txType));
    my %SEEN;
    while (my ($FkTeamIdx) = $select->fetchrow_array()) {
        $SEEN{$FkTeamIdx} = 1;
    }

    my $str;


    $str .= '<div class="w3-container w3-blue w3-display-container" >';
    $str .= '<a class="w3-button w3-display-topright w3-hover-white" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<h4 style="float: left;">'.uc($txType).' Available for Assessment</h4>';
    $str .= '</div>';
    $str .= '<div class="w3-container" style="height: 450px; overflow-y: auto">';
    $str .= '<table class="w3-table-all w3-small" style="width: 100%;">';
    $str .= '<tr>';
    $str .= '<th style="width: 25%">Team</th>';
    $str .= '<th style="width: 75%">Score Cards</th>';
    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        $teamName = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).' - '.$TEAM{$teamIDX}{TX_SCHOOL};
        my $cardCount = scalar(keys %{$GRADE{$teamIDX}});

        $str .= '<tr>';
        $str .= '<td>'.$teamName.'</td>';
        $str .= '<td>';
        if ($cardCount > 0) {
            foreach $PkGradeIdx (sort {$a <=> $b} keys %{$GRADE{$teamIDX}}) {
                my $assignedUserIdx = $GRADE{$teamIDX}{$PkGradeIdx}{FK_USER_IDX};
                $myType = $GRADE{$teamIDX}{$PkGradeIdx}{TX_TYPE};
                $leftBar = '';
                if ($assignedUserIdx == $userIDX) {$leftBar = 'w3-leftbar w3-border-green'}
                if ($assignedUserIdx > 0 || exists $SEEN{$teamIDX}) {

                    $str .= '<button class="w3-button w3-margin-left w3-disabled '.$leftBar.' w3-status-'.$GRADE{$teamIDX}{$PkGradeIdx }{BO_STATUS}.'" style="border: 1px dashed #ccc; color: #ccc; width: 70px;" >--</button>';
                } else {
                    $str .= '<button class="w3-hover-green w3-button w3-margin-left w3-normal" style="width: 70px;  border: 1px dashed #ccc;" onclick="addRequestedCard('.$PkGradeIdx.','.$userIDX.');">+ Add</button>';
                }
             }
        } else {
            $str .= '<button class="w3-hover-green w3-button w3-margin-left w3-normal" style="width: 70px; border: 1px dashed #ccc;" onclick="addNewCardRequest(\''.lc($txType).'\','.$userIDX.','.$teamIDX .');">+ Add</button>';
        }
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '</div>';
    return ($str);
}
sub addRequestedCard(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $userIDX = $q->param('userIDX');
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $teamIDX = $q->param('teamIDX');
    my $SQL = "UPDATE TB_GRADE SET FK_USER_IDX=? WHERE PK_GRADE_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($userIDX, $PkGradeIdx);
    return ($str);
}
sub addNewCardRequest(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $teamIdx = $q->param('teamIdx');
    my $txType = $q->param('txType');
    my $userIdx = $q->param('userIdx');
    my $SQL = "INSERT INTO TB_GRADE (FK_TEAM_IDX, TX_TYPE, FK_USER_IDX) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($teamIdx, $txType, $userIdx) || die "Error";
    my $str;
    return ("$txType, $teamIdx, $userIdx, $SQL");
}
# ================= START ASSESSMENT ======================= 2019
sub saveAssessment(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $value = $q->param('value');
    my $status = $q->param('status');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $SQL = "DELETE FROM TB_SCORE WHERE FK_GRADE_IDX=?";
    my $delete = $dbi->prepare($SQL);
    $delete->execute($PkGradeIdx);
    $SQL = "UPDATE TB_GRADE SET IN_SCORE=?, BO_STATUS=? WHERE PK_GRADE_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($value, $status, $PkGradeIdx);
    $SQL = "INSERT INTO TB_SCORE (FK_QUESTION_IDX, FK_GRADE_IDX, IN_VALUE) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
    my $str;
    foreach $fkQuestionIdx (sort {$a <=> $b} keys %DATA) {
        $insert->execute($fkQuestionIdx, $PkGradeIdx, $DATA{$fkQuestionIdx});
    }
    if ($status < 3) {
        return ("Saved");
    } else {
        return ("Submitted");
    }

}
sub startAssessment(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $txType = $q->param('txType');
    my $FkClassIdx = $q->param('FkClassIdx');
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $PkUserIdx = $q->param('PkUserIdx');
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($PkTeamIdx);
    my $teamNummber = $Team->getInNumber();
    my $start = $q->param('start');
    my $SQL = "SELECT T.IN_WEIGHT AS TYPE_WEIGHT
    ,SEC.IN_WEIGHT AS SEC_WEIGHT
    ,SUB.IN_WEIGHT AS SUB_SEC_WEIGHT
    ,SUB.TX_SUB_SECTION
    ,Q.*
 FROM TB_TYPE AS T
	JOIN TB_SECTION AS SEC ON T.TX_TYPE=SEC.TX_SECTION
	JOIN TB_SUB_SECTION AS SUB ON SEC.PK_SECTION_IDX = SUB.FK_SECTION_IDX
    JOIN TB_QUESTION AS Q ON SUB.PK_SUB_SECTION_IDX=Q.FK_SUB_SECTION_IDX
WHERE T.TX_TYPE=? AND SEC.FK_CLASS_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($txType, $FkClassIdx);
    while (my ($typeWeight, $sectionWeight, $subSectionWieght, $txSubSection, $pkQuestionIdx, $FkSubSectionIdx, $inCheck, $txTitle, $TxDescription, $questionWeight, $inOrder) = $select->fetchrow_array()) {
        $SUBSECTION{$FkSubSectionIdx}=$txSubSection;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{IN_ORDER} = $inOrder;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{IN_CHECK} = $inCheck;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{TX_TITLE} = $txTitle;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{TX_DESCRIPTION} = $TxDescription;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{Q_IN_WEIGHT} = $questionWeight;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{T_IN_WEIGHT} = $typeWeight;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{S_IN_WEIGHT} = $sectionWeight;
        $QUESTION{$txSubSection}{$pkQuestionIdx}{U_IN_WEIGHT} = $subSectionWieght;
    }
    if ($start == 1){
        $SQL = "SELECT * FROM TB_SCORE WHERE FK_GRADE_IDX=?";
        $select = $dbi->prepare($SQL);
        $select->execute($PkGradeIdx);
        %VALUE = %{$select->fetchall_hashref(['FK_QUESTION_IDX'])};
    }
    $SQL = "SELECT PK_COMMENT_IDX, FK_QUESTION_IDX, TX_COMMENT, FK_USER_IDX, TS_CREATE FROM TB_COMMENT WHERE FK_TEAM_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkTeamIdx);
    %COMMENT = %{$select->fetchall_hashref(['FK_QUESTION_IDX','PK_COMMENT_IDX'])};
    my $str;

    $SQL = "SELECT PK_COMMENT_TEM_IDX, TX_TITLE, TX_COMMENT FROM TB_COMMENT_TEMP WHERE FK_USER_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    %COMMENT_TEMP = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};


    $str = '<div class="w3-sidebar w3-bar-block w3-light-grey w3-card w3-display-container" style="width:200px; top: 0px; left: 0px!improtant;">';
#     $str .= '('.$PkUserIdx.') '.scalar(keys %COMMENT_TEMP);
    $str .= '<h5 class="w3-bar-item">Team #:'.substr("000".$teamNummber,-3,3).'<br>'.$Team->getTxSchool().'</h5>';
#     $str .= '<h5 class="w3-bar-item">Assessment Summary</h5>';
   my $sectionCounter = 0;
   foreach $fkSubSectionIdx (sort {$a <=> $b} keys %SUBSECTION){
        $str .= '<div class="w3-display-container w3-small">';
        $str .= '<a href="#anchor_'.$sectionCounter.'" class="w3-bar-item w3-button tablink" data-key="'.$fkSubSectionIdx.'" onclick="openSection(this, \'section_'.$fkSubSectionIdx.'\')">'.$SUBSECTION{$fkSubSectionIdx}.'</a>';
        $str .= '<span ID="subTotalFor_'.$fkSubSectionIdx .'" class="w3-border-bottom w3-padding w3-display-right">0.00%</span>';
        $str .= '</div>';
        $str .= '<input tabindex="-1" class="mySectionTotal" id="subSectionTotal_'.$fkSubSectionIdx.'" type="hidden" min="0.0000" max="1" step="0.0001" value="0">';
        $sectionCounter++;
    }
    $str .= '<div class="w3-display-container w3-border-top">';
    $str .= '<span class="w3-bar-item">Total</span>';
    $str .= '<span class="w3-border-bottom w3-padding w3-display-right"><span ID="TotalForType" >0.00</span>%</span>';
    $str .= '</div>';
    $str .= '<div class="w3-bar-item">';
    $str .= '<button class="btn w3-button w3-display-bottom w3-yellow w3-card w3-border" style="width: 100%;" onclick="saveAssessment('.$PkGradeIdx.',2);">Save Draft</button>';
    $str .= '<button class="btn w3-button w3-display-bottom w3-blue w3-card w3-border w3-margin-top" style="width: 100%;" onclick="saveAssessment('.$PkGradeIdx.',3);">Submit</button>';
    $str .= '<button class="btn w3-button w3-display-bottom w3-red w3-margin-top" style="width: 100%;" onclick="exitAssessment();">Exit</button>';

    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div style="margin-left:200px">';
    $sectionCounter = 0; 
    foreach $fkSubSectionIdx (sort {$a <=> $b} keys %SUBSECTION){
        $txSubSection = $SUBSECTION{$fkSubSectionIdx};
        $str .= '<div id="section_'.$fkSubSectionIdx.'" class="w3-container section" style="display:none">';

        $str .= '<a name="anchor_'.$sectionCounter .'"><h2>'.uc($txSubSection);
        if (uc($txSubSection) eq 'REQUIREMENTS'){
           $str .= '&nbsp;<input type="checkbox" onchange="setPerfect(this);"> <span class="w3-tiny">100%</span>'; 
        }
        
        $str .= '</h2></a>';
        
        $str .= '<ul class="w3-ul">';
        foreach $pkQuestionIdx (sort {$QUESTION{$txSubSection }{$a}{IN_ORDER} <=> $QUESTION{$txSubSection}{$b}{IN_ORDER}} keys %{$QUESTION{$txSubSection}}) {
            $tWeight = $QUESTION{$txSubSection}{$pkQuestionIdx}{T_IN_WEIGHT};
            $uWeight = $QUESTION{$txSubSection}{$pkQuestionIdx}{U_IN_WEIGHT};
            $qWeight = $QUESTION{$txSubSection}{$pkQuestionIdx}{Q_IN_WEIGHT};

            $str .= '<li class="w3-bar">';
            $str .= '<div class="w3-normal">'.$QUESTION{$txSubSection}{$pkQuestionIdx}{TX_TITLE}.'</div>';
            $str .= '<div class="w3-small">'.$QUESTION{$txSubSection}{$pkQuestionIdx}{TX_DESCRIPTION}.'</div>';
            $str .= '<div class="w3-bar-item">';
#             $str .= '('.$fkSubSectionIdx.')'.$tWeight.','.$uWeight.','.$qWeight.br;
            if ($QUESTION{$txSubSection}{$pkQuestionIdx}{IN_CHECK} == 1) {
                my $checked = '';
                if ($VALUE{$pkQuestionIdx}{IN_VALUE}>0){
                    $checked = 'checked';
                }
                $str .= '<input class="subsection_'.$fkSubSectionIdx.' inputBinary largerCheckbox" id="q_'.$pkQuestionIdx.'" type="checkbox" data-section="'.$fkSubSectionIdx.'" data-key="'.$pkQuestionIdx.'" value="100" data-tweight="'.($tWeight/2).'" data-uweight="'.($uWeight/100).'" data-qweight="'.($qWeight/100).'" onchange="checkValue('.$fkSubSectionIdx.');" '.$checked .'  >';
                $str .= '<label for="q_'.$pkQuestionIdx.'" class="w3-small w3-margin-left w3-text-black">Yes, Requirement was met</label>';
            } else {
                if ($VALUE{$pkQuestionIdx}{IN_VALUE}>0){
                    $str .= '<input id="q_'.$pkQuestionIdx.'" class="w3-text-blue subsection_'.$fkSubSectionIdx.' inputNumber" data-section="'.$fkSubSectionIdx.'" data-key="'.$pkQuestionIdx.'" onblur="checkValue('.$fkSubSectionIdx.');" data-tweight="'.($tWeight/2).'" data-uweight="'.($uWeight/100).'" data-qweight="'.($qWeight/100).'"  type="number" max="100" step="0.5" min="0" maxlength="5" placeholder="0.00" value="'.$VALUE{$pkQuestionIdx}{IN_VALUE}.'">';
                } else {
                    $str .= '<input id="q_'.$pkQuestionIdx.'" class="w3-text-blue subsection_'.$fkSubSectionIdx.' inputNumber" data-section="'.$fkSubSectionIdx.'" data-key="'.$pkQuestionIdx.'" onblur="checkValue('.$fkSubSectionIdx.');" data-tweight="'.($tWeight/2).'" data-uweight="'.($uWeight/100).'" data-qweight="'.($qWeight/100).'"  type="number" max="100" step="0.5" min="0" maxlength="5" placeholder="0.00">';
                }
                $str .= '<span class="w3-tiny w3-margin-left w3-text-grey">Range from 0 - 100%</span>';
            }

#             $str .= '<input type="number" max="100" step="0.5" min="0" maxlength="5" placeholder="0.00%" >';

            $str .= '<button tabindex="-1" class="w3-button w3-margin-left w3-border w3-round-xlarge" onclick="openForm('.$pkQuestionIdx.',0)"><span class="fa fa-comments-o">&nbsp;</span>Comments</button>';
            $str .= '</div><br>';
            $str .= '<div ID="comment_section_for_'.$pkQuestionIdx.'" class="w3-bar" >';
            foreach $PkCommentIdx(sort {$b <=> $a} keys %{$COMMENT{$pkQuestionIdx}}) {

                $str .= &_templateComments($PkCommentIdx, $COMMENT{$pkQuestionIdx}{$PkCommentIdx}{TX_COMMENT}, $PkUserIdx, $COMMENT{$pkQuestionIdx}{$PkCommentIdx}{FK_USER_IDX}, $pkQuestionIdx, $COMMENT{$pkQuestionIdx}{$PkCommentIdx}{TS_CREATE});
            }

            $str .= '</div>';
            $str .= '<div class="w3-card-4 w3-border chat-popup" id="myForm_'.$pkQuestionIdx.'">';
            $str .= '<div class="w3-dropdown-click w3-center" style="width: 100%;">';
            $str .= '<button class="w3-button " onclick="showTemplateContent('.$pkQuestionIdx.');">Load From Templates<span class="w3-margin-left  fa fa-caret-down"></span></button>';
            $str .= '<div ID="templateContent_for_'.$pkQuestionIdx.'" class="w3-small w3-dropdown-content w3-bar-block w3-border" style="right:0; max-height: 400px; overflow: scroll;">';
            foreach $tempIDX (sort {lc($COMMENT_TEMP{$a}{TX_TITLE}) cmp lc($COMMENT_TEMP{$b}{TX_TITLE})} keys %COMMENT_TEMP) {
                $str .= &_templateForTemplate($tempIDX , $COMMENT_TEMP{$tempIDX}{TX_TITLE}, $COMMENT_TEMP{$tempIDX}{TX_COMMENT},$pkQuestionIdx);
#                 $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" data-value="'.$COMMENT_TEMP{$tempIDX}{TX_COMMENT}.'" onclick="loadComment(this, '.$pkQuestionIdx.')">'.$COMMENT_TEMP{$tempIDX}{TX_TITLE}.'</a>';
            }
            $str .= '</div>';
            $str .= '</div>';
            $str .= '<form action="javascript:void(0);" class="form-container">';
#             $str .= '<p>Comment</p>';
            $str .= '<input type="hidden" ID="UPDATE_COMMENT_FOR_'.$pkQuestionIdx.'">';
            $str .= '<br><br><label for="msg"><b>Comments</b></label>';
            $str .= '<textarea ID="COMMENT_FOR_'.$pkQuestionIdx.'" placeholder="Comments" name="msg" required></textarea>';

            $str .= '<button type="submit" class="btn w3-button w3-green" onclick="postComment('.$pkQuestionIdx.','.$PkGradeIdx.','.$PkTeamIdx.');">Post Comments</button>';
            $str .= '<button type="submit" class=" btn w3-button w3-orange" onclick="saveToTemplate('.$PkUserIdx.', '.$pkQuestionIdx.');">Save as a Template</button>';
            $str .= '<button type="button" class=" btn w3-button w3-red" onclick="closeForm('.$pkQuestionIdx.')">Exit with Saving</button>';

            $str .= '</form>';
            $str .= '</div>';
            $str .= '</li>';
        }
        $str .= '</ul>';
        $sectionCounter++;
        $str .= '<div class="w3-panel w3-padding w3-display-container" style="margin-top: 25px; padding-bottom: 25px;">';
#         $str .= ($sectionCounter-2);
        if (($sectionCounter-2)>=0){
            $str .= '<a tabindex="-1" href="#anchor_'.($sectionCounter-2) .'" class="w3-button w3-card-4 w3-border w3-display-left" onclick="nextSection('.($sectionCounter-2).');"><< Prev Section</a>';
        }
        $totalSection = scalar(keys %SUBSECTION);
        if ($sectionCounter < $totalSection){
            $str .= '<a href="#anchor_'.$sectionCounter .'" class="w3-button w3-card-4 w3-border w3-display-right w3-green" onfocus="nextSection('.$sectionCounter.');" onclick="nextSection('.$sectionCounter.');">Next Section >></a>';
        } else {
            $str .= '<a href="#anchor_'.$sectionCounter .'" class="w3-button w3-card-4 w3-border w3-display-right w3-blue" onclick="saveAssessment('.$PkGradeIdx.',3);">Submit</a>';
        }
        $str .= '</div>';
        $str .= '</div>';

    }

    $str .= '</div>';
    $DATA{FORM} = $str;
    $DATA{SUBSECTION} = join(",",keys %SUBSECTION);
    my $json = encode_json \%DATA;
    return ($json);
#     return ($str);
}
sub _templateForTemplate(){
    my $idx = shift;
    my $title = shift;
    my $comment = shift;
    my $qIDX = shift;
    my $str;
    $str = '<div class="w3-display-container" style="padding-right: 40px;">';
    $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" data-value="'.$comment.'" onclick="loadComment(this, '.$qIDX.')">'.$title.'</a>';
    $str .= '<span class="w3-display-right w3-button " onclick="deleteThisTemplate(this,'.$idx.')">X</span>';
    $str .= '</div>';
    return $str;
}
sub _templateComments(){
    my $str;
    my $commentIDX = shift;
    my $text = shift;
    my $userIDX = shift;
    my $commentUserIDX = shift;
    my $pkQuestionIdx = shift;
    my $tsCreate = shift;
#     $str = '<div ID="COMMENT_'.$commentIDX.'" class="w3-bar-item chat-container w3-small w3-display-container" style="padding: 3px!important; width: 100%;">';
    $str = '<div ID="COMMENT_'.$commentIDX.'" class="w3-small w3-panel w3-pale-yellow w3-border w3-border-yellow w3-leftbar" style="padding: 3px!important; width: 100%;">';
    $str .= '<p style="margin-top: 2px; padding-left: 10px;">'.$text.'</p>';
    $str .= '<span class="w3-button w3-display-topright" style="background: transparent!important;" onclick="deleteComment('.$commentIDX.');">X</span>';
    if ($userIDX == $commentUserIDX){
#         $str .= '<a class="w3-margin-left" href="javascript:void(0);" onclick="editComment('.$commentIDX.','.$pkQuestionIdx.');">Edit</a>';
        $str .= '<a  tabindex="-1" class="w3-margin-left" href="javascript:void(0);" onclick="editQuestionComment('.$commentIDX.','.$pkQuestionIdx.');">Edit</a>';
    } else {
        $str .= '<span tabindex="-1" class="w3-margin-left w3-disabled">Edit</span>';
    }
    $str .= '<span class="w3-margin-left w3-small">'.$tsCreate.'</span>';
#     $str .= "$userIDX = $commentUserIDX";
    $str .= '</div>';

    return ($str);
}
sub postComment(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkQuestionIdx = $q->param('PkQuestionIdx');
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $TxComment = uri_unescape($q->param('TxComment'));
    my $PkUserIdx = $q->param('PkUserIdx');
    my $PkGradeIdx = $q->param('PkGradeIdx');
    my $BoShow = $q->param('BoShow');
    my $SQL = "INSERT INTO TB_COMMENT (FK_QUESTION_IDX, FK_GRADE_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW, FK_TEAM_IDX) VALUES (?,?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkQuestionIdx, $PkGradeIdx, $TxComment, $PkUserIdx, $BoShow,$PkTeamIdx);
    my $newIDX = $insert->{q{mysql_insertid}};
    $SQL = "SELECT NOW()";
    my $select = $dbi->prepare($SQL);
    $select->execute();
    my ($tsCreate) = $select->fetchrow_array();
    $str = &_templateComments($newIDX, $TxComment, $PkUserIdx, $PkUserIdx, $PkQuestionIdx,$tsCreate );
    return ($str);
}
sub editQuestionComment(){
    print $q->header();
    my $PkQuestionIdx = $q->param('PkQuestionIdx');
    my $PkCommentIdx = $q->param('PkCommentIdx');
    my $str;
    my $Comment = new SAE::TB_COMMENT();
    $Comment->getRecordById($PkCommentIdx);
    my $Util = new SAE::Common();
    my $str = $Util->removeBr($Comment->getTxComment());
    return ($str);
}
sub deleteComment(){
    print $q->header();
    my $PkCommentIdx = $q->param('PkCommentIdx');
    my $Comment = new SAE::TB_COMMENT();
    $str = $Comment->deleteRecordById($PkCommentIdx);
    return ($PkCommentIdx);
}
sub saveToTemplate(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $pkQuestionIdx = $q->param('pkQuestionIdx');
    my $TxComment = uri_unescape($q->param('TxComment'));
#     my $BoShow = $q->param('BoShow');
    my $title = $q->param('title');
    my $dbi = new SAE::Db();
    my $SQL = "INSERT INTO TB_COMMENT_TEMP (FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE) VALUES (?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkUserIdx, $title, $TxComment, 1);
    my $newIDX = $insert->{q{mysql_insertid}};
    my $str;
    $str = &_templateForTemplate($newIDX, $title, $TxComment, $pkQuestionIdx);
    return ($str);
}
sub deleteThisTemplate(){
    print $q->header();
    $PkTempIdx = $q->param('PkTempIdx');
    my $Template = new SAE::TB_COMMENT_TEMP();
    $Template->deleteRecordById($PkTempIdx);
    my $str;
    return ($str);
}
# ================= START GRADING PAPER ==================== 2019
sub saveDraft(){
    print $q->header();
    my $PkPaperIdx = $q->param('PkPaperIdx');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $value = $q->param('value');
    my $Score = new SAE::TB_SCORE();
    foreach $PkScoreIdx (sort keys %DATA){
        $Score->updateInScore_ById($DATA{$PkScoreIdx}, $PkScoreIdx);
    }
    my $str;
    my $Tab = new SAE::Tabulate();
    $str = sprintf "%2.4f", $Tab->tabulateReport($PkPaperIdx);
    return ($str);
}
sub loadThisTemplate(){
    print $q->header();
    $location = $q->param('location');
    $PkCommentTempIdx = $q->param('PkCommentTempIdx');
    my $Template = new SAE::TB_COMMENT_TEMP();
    my $str;
    my $Util = new SAE::Common();
    $Template->getRecordById($PkCommentTempIdx);
    $str = $Util->removeBr($Template->getTxComment());

    return ($str);
}
sub showTemplateList(){
    print $q->header();

    my $PkUserIdx = $q->param('PkUserIdx');
    my $PkScoreItemIdx = $q->param('PkScoreItemIdx');
    my $str;

    my $Template = new SAE::TB_COMMENT_TEMP();
    %TEMP = %{$Template->getAllRecordBy_FkUserIdx($PkUserIdx)};

    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="deleteDiv(\'DIV_OPEN_COMMENT_TEMPLATES\');">&times;</a>';
    $str .= '<header class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">My Templates</h2>';
    $str .= '</header>';
#     $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';

    $str .= '<div class="w3-container">';
    $str .= '<ul class="w3-ul w3-container w3-hoverable">';
#     $str .= '<li class="w3-blue w3-bar">Templates</li>';
    foreach $templateIDX (sort {lc($TEMP{$a}{TX_TITLE}) cmp lc($TEMP{$b}{TX_TITLE})} keys %TEMP) {
        $str .= '<li ID="USER_TEMPLATE_'.$templateIDX.'" class="w3-bar w3-border w3-left-align" >';
        $str .= '<span class="w3-button w3-bar-item w3-right" onclick="deleteThisTemplate('.$templateIDX.')">&times;</span>';;
        $str .= '<span class="w3-button w3-bar-item w3-left fa fa-download" onclick="loadThisTemplate('.$templateIDX.', '.$PkScoreItemIdx.');"></span>';
        $str .= '<span class="w3-button w3-medium w3-bar-item " style="text-overflow: ellipsis;" onclick="loadThisTemplate('.$templateIDX.', '.$PkScoreItemIdx.');" > '.$TEMP{$templateIDX}{TX_TITLE}.'</span>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';

    return ($str);
}
sub saveCommentToTemplate(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $TxComment = uri_unescape($q->param('TxComment'));
    my $BoShow = $q->param('BoShow');
    my $TxTitle = $q->param('TxTitle');
    my $dbi = new SAE::Db();
    my $SQL = "INSERT INTO TB_COMMENT_TEMP (FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE) VALUES (?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkUserIdx, $TxTitle, $TxComment, $BoShow);
    my $str;

    return ("$PkUserIdx, $TxTitle, $TxComment, 0");
}
sub openSaveCommentToTemplate(){
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $TxComment = uri_unescape($q->param('TxComment'));
    my $Util = new SAE::Common();
    my $str;
    $str = '<a class="w3-button w3-border w3-display-topright" onclick="deleteDiv(\'DIV_SAVE_COMMENTS_TEMPLATE\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">Save Comment as Template</h2>';
    $str .= '</div>';
#     $str .= '<a class="button small" style="float: right;" href="javascript:void(0)" onclick="deleteDiv(\'DIV_SAVE_COMMENTS_TEMPLATE\');">Exit</a>';
#     $str .= '<h2>My Comment Template</h2>';
#     $str .= '<p><label>Template Title</label>';
    $str .= '<p><input class="w3-input w3-border" type="text" ID="TX_USER_TITLE" Placeholder="Template Title">';
    $str .= '</p>';
    $str .= '<textarea ID="TX_USER_COMMENT_'.$PkUserIdx.'" class="w3-border w3-input" style="height: 47%;">'.$Util->removeBr($TxComment).'</textarea>';
    $str .= '<div style="padding: 10px; text-align: center;">';
    $str .= '<a class="w3-button w3-card-4 w3-green" href="javascript:void(0);" onclick="saveCommentToTemplate('.$PkUserIdx.');">Save</a>';
    $str .= '</div>';
    $str .= '<div class="w3-small" style="padding: 10px; text-align: left;">';
    $str .= '<input ID="BO_SHOW_'.$PkUserIdx.'" type="checkbox" checked  name="demo-human" value="1">';
    $str .= '<label for="BO_SHOW_'.$PkUserIdx.'">This is a private template.  Do not make it visible to other judges.<label>';
    $str .= '</div>';

    return ($str);
}
# ================= LOADING MAIN DISPLAY =================== 2019
sub loadListOfAssignedPapers(){
    print $q->header();
    my $dbi = new SAE::Db();
    my %DATA;
    my $location = $q->param('location');
    my $PkUserIdx = $q->param('PkUserIdx');
    my $Tab = new SAE::Tabulate();
    my $SQL = "SELECT GRADE.*, GRADE.BO_STATUS AS BO_GRADE_STATUS, TEAM.*
        FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        WHERE TEAM.FK_EVENT_IDX=? AND FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location, $PkUserIdx);
    %GRADE = %{$select->fetchall_hashref(['TX_TYPE','PK_GRADE_IDX'])};


    $SQL = "SELECT * FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
    $select=$dbi->prepare($SQL);
    $select->execute($location);
    my %DOWNLOAD = %{$select->fetchall_hashref(['FK_TEAM_IDX','TX_LABEL'])};
    my %TYPE = ('report'=>35, 'tds'=>5, 'requirements'=>5, 'drawing'=>5);
    my $str;

    if (scalar (keys %GRADE)>0){
    foreach $txType (keys %GRADE){
        if ($txType eq 'demo' || $txType eq 'presentation') {next;}
        $str .= '<div class="w3-container w3-card-4 w3-border" style="margin-top: 1em; padding: 0px;">';
        $str .= '<h4 class="w3-margin-left">'.uc($txType).'</h4>';
        $str .= '<table class="w3-table-all w3-hoverable w3-small" style="width: 100%;">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 40%; text-align: left;"># School (Team Name)</th>';
        $str .= '<th style="width: 10%; text-align: right;">Download</th>';
        $str .= '<th style="width: 10%; text-align: right;">Score</th>';
        $str .= '<th style="width: 10%; text-align: right;">Points</th>';
        $str .= '<th style="width: 25%; text-align: right;">To Do</th>';
        $str .= '</tr>';
        foreach $PkGradeIdx(sort {$GRADE{$txType}{$a}{IN_NUMBER} <=> $GRADE{$txType}{$b}{IN_NUMBER}} keys %{$GRADE{$txType}}){
            $teamIDX = $GRADE{$txType}{$PkGradeIdx}{PK_TEAM_IDX};
            $gradeStatus = $GRADE{$txType}{$PkGradeIdx}{BO_GRADE_STATUS};
            $teamNumber = $GRADE{$txType}{$PkGradeIdx}{IN_NUMBER};
            $FkClassIdx = $GRADE{$txType}{$PkGradeIdx}{FK_CLASS_IDX};
            $inScore = $GRADE{$txType}{$PkGradeIdx}{IN_SCORE};

            $team  = substr("000".$GRADE{$txType}{$PkGradeIdx}{IN_NUMBER},-3,3).' - '.$GRADE{$txType}{$PkGradeIdx}{TX_SCHOOL}.' ('.$GRADE{$txType}{$PkGradeIdx}{TX_NAME}.') ';
            if ($txType eq 'report' || $txType eq 'requirements' ){
                $download = '<a class="w3-tooltip" href="download.php?fileID='.$DOWNLOAD{$teamIDX}{'Design_Report'}{TX_SERIAL}.'" target="_blank">Download<span class="w3-text w3-sand w3-border" style="padding: 0px 7px; position:absolute;left:35;bottom:0px; z-index: 999">'.$DOWNLOAD{$teamIDX}{TX_REPORT}{TX_FILENAME}.'</span></a>';
            } elsif ($txType eq 'drawing') {
                $download = '<a class="w3-tooltip" href="download.php?fileID='.$DOWNLOAD{$teamIDX}{'2D_Drawings'}{TX_SERIAL}.'" target="_blank">Download<span class="w3-text w3-sand w3-border" style="padding: 0px 7px; position:absolute;left:35;bottom:0px; z-index: 999">'.$DOWNLOAD{$teamIDX}{TX_DRAWING}{TX_FILENAME}.'</span></a>';
            } elsif ($txType eq 'tds') {
                $download = '<a class="w3-tooltip" href="download.php?fileID='.$DOWNLOAD{$teamIDX}{'Tech_Data_Sheet'}{TX_SERIAL}.'" target="_blank">Download<span class="w3-text w3-sand w3-border" style="padding: 0px 7px; position:absolute;left:35;bottom:0px; z-index: 999">'.$DOWNLOAD{$teamIDX}{TX_TDS}{TX_FILENAME}.'</span></a>';
            }
            $str .= '<tr ID="ROW_'.$PkGradeIdx.'">';
            $str .= '<td><div style="overflow: hidden; text-overflow: ellipsis;">'.$team.'</div></td>';
            $str .= '<td>'.$download.'</td>';
            $str .= sprintf '<td style="text-align: right;"><span>%2.2f%</span></td>',$inScore;
            $str .= sprintf '<td style="text-align: right;"><span>%2.2f / %2.2f</span></td>',$TYPE{$txType} * $inScore/100, $TYPE{$txType};

            $str .= '<td class="w3-display-container" style="text-align: right;">';

            if ($gradeStatus == 3){
                $str .= '<span class="w3-text-blue"><b>Submitted</b>&nbsp;&nbsp;';
                $str .= '<a class="w3-button w3-card-4 w3-blue w3-hover-green" style="margin: 0; padding: 2px 10px" href="javascript:void(0);" onclick="startAssessment('.$PkGradeIdx .','.$teamIDX.',\''.$txType.'\','.$FkClassIdx.',1);">Revise</a>';
                $str .= '</span>';
            } elsif ($gradeStatus == 2) {
                $str .= '<a class="w3-button w3-card-4 w3-yellow w3-hover-green" style="margin: 0; padding: 2px 10px" href="javascript:void(0);" onclick="startAssessment('.$PkGradeIdx .','.$teamIDX.',\''.$txType.'\','.$FkClassIdx.',1);">Continue</a>';
            } else {
                $str .= '<a class="w3-button w3-card w3-hover-green" style="margin: 0; padding: 2px 10px" href="javascript:void(0);" onclick="startAssessment('.$PkGradeIdx .','.$teamIDX.',\''.$txType.'\','.$FkClassIdx.',0);">Start</a>';
            }
#             $str .= " $txType, $PkGradeIdx, $GRADE{$txType}{$PkGradeIdx}{BO_STATUS} ";
            $str .= '</td>';
            $str .= '</tr>';
        }
        $str .= '<tfoot>';
        $str .= '<tr>';
        $str .= '<td colspan="10" style="text-align: right" >';
        $str .= '<button class="w3-button w3-hover-green w3-normal" style="border: 1px dashed #ccc;" onclick="requestMore('.$PkUserIdx.',\''.uc($txType).'\');">That was fun! I like to assess another '.uc($txType).'</button>';
        $str .= '</td>';
        $str .= '</tr>';
        $str .= '</tfoot>';
        $str .= '</table>';
        $str .= '</div>';
    }
    } else {
        $str = '<h3 style="margin: auto; padding: 20px; text-align: center">Thank you for volunteering to assess the SAE Aero-Design Reports.<br><br>Paper Assignment Pending...</h3>';
    }
    $DATA{FORM} = $str;
    my $json = encode_json \%DATA;
    return ($json);
#     return ($str);
}
