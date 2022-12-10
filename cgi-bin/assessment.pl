#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use CGI::Session;
# use CGI::Cookie;
# use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
# use Mail::Sendmail;
# use HTML::Entities;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::TB_SCORE_EVENT;
use SAE::TB_SCORE_GROUP;
use SAE::TB_SCORE_SECTION;
use SAE::TB_SCORE_ITEM;
# use SAE::TB_USER;
# use SAE::TB_TEAM;
use SAE::Common;
# use SAE::Auth;
# use SAE::TB_USER_TEAM;
use SAE::TB_EVENT;

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
# my %DATA = %{decode_json($q->param('jsonData'))};
sub __template(){
    print $q->header();
    my $PkScoreEventIdx = $q->param('PkScoreEventIdx');

    my $str;
    return ($str);
}

#============= LINE ITEMS ===================
sub showAddLineItem(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkScoreSectionIdx = $q->param('PkScoreSectionIdx');
    my $SQL = "SELECT MAX(IN_ORDER) FROM `TB_SCORE_ITEM` WHERE FK_SCORE_SECTION_IDX=?";
    my $select=$dbi->prepare($SQL);
    $select->execute($PkScoreSectionIdx);
    my $order = $select->fetchrow_array();
    $order++;
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id02\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Add Line Item</h2>';
    $str .= '</div>';

    $str .= '<form class="w3-container">';
    $str .= '<input class="w3-input" type="text" placeholder="Enter the Title of this Assessment Item" ID="TX_SCORE_ITEM">';
    $str .= '<div class="smallLabel">Line Item Title</div>';
    $str .= '<textarea class="w3-input w3-border" ID="TX_DETAIL"></textarea>';
    $str .= '<div class="smallLabel">Description</div>';
    $str .= '<select class="w3-select" ID="BO_BINARY">';
    $str .= '<option value="1">Yes/No</option>';
    $str .= '<option value="0">Numeric Value</option>';
    $str .= '</select>';
    $str .= '<div class="smallLabel">Type</div>';
    $str .= '<input required type="number" max="100" min="1" style="width: 100%; font-size: 1.25em; border: none; border-bottom: 1px solid #dddddd;" ID="IN_PERCENT" placeholder="Weight">';
    $str .= '<div class="smallLabel">Weight</div>';
    $str .= '<input required type="number" max="100" min="1" style="width: 100%; font-size: 1.25em; border: none; border-bottom: 1px solid #dddddd;" ID="IN_ORDER" value="'.$order.'" placeholder="List Order">';
    $str .= '<div class="smallLabel">Order</div>';
    $str .= '<br>';
    $str .= '<div class="w3-container w3-center">';
    $str .= '<a class="w3-button w3-border" href="javascript:void(0);" onclick="addLineItem('.$PkScoreSectionIdx.')">Save</a> ';
    $str .= '</div>';
    $str .= '</form><br><br>';
    return ($str);
}
sub deleteLineItem(){
    print $q->header();
    my $PkScoreItemIdx = $q->param('PkScoreItemIdx');
    my $Item = new SAE::TB_SCORE_ITEM();
    $Item->deleteRecordById($PkScoreItemIdx);
    my $str;
    return ($str);
}
sub addLineItem(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkScoreSectionIdx = $q->param('PkScoreSectionIdx');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $SQL = "INSERT INTO TB_SCORE_ITEM (FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER) VALUES (?,?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkScoreSectionIdx, $DATA{TX_SCORE_ITEM},uri_unescape($DATA{TX_DETAIL}),$DATA{IN_PERCENT},$DATA{BO_BINARY},$DATA{IN_ORDER} );
    my $newIDX = $insert->{q{mysql_insertid}};
    my $str;
    $str = &_templateLineItemRow($newIDX, $DATA{IN_ORDER}, $DATA{TX_SCORE_ITEM}, $DATA{IN_PERCENT}, $DATA{BO_BINARY});
    return ($str);
}
sub updateEditedLineItem(){
    print $q->header();
    my $PkScoreItemIdx = $q->param('PkScoreItemIdx');
    my $Item = new SAE::TB_SCORE_ITEM();
    my %DATA = %{decode_json($q->param('jsonData'))};
    $Item->updateTxScoreItem_byId($DATA{TX_SCORE_ITEM}, $PkScoreItemIdx);
    $Item->updateTxDetail_byId(uri_unescape($DATA{TX_DETAIL}), $PkScoreItemIdx);
    $Item->updateBoBinary_byId($DATA{BO_BINARY}, $PkScoreItemIdx);
    $Item->updateInPercent_byId($DATA{IN_PERCENT}, $PkScoreItemIdx);
    $Item->updateInOrder_byId($DATA{IN_ORDER}, $PkScoreItemIdx);
    my $json = encode_json \%DATA;
    return ($json);
}
sub saveItemChanges(){
    print $q->header();
    my $PkScoreGroupIdx = $q->param('PkScoreGroupIdx');
    my $Item = new SAE::TB_SCORE_ITEM();
    my $Group = new SAE::TB_SCORE_GROUP();
    my %DATA = %{decode_json($q->param('jsonData'))};
#     my $str;
#     $str .= join("\n",keys %{$DATA{TX_DETAIL}});
#     return($str);
    foreach $PkScoreItemIdx (sort keys %{$DATA{IN_PERCENT}}){
        $Item->updateInPercent_byId($DATA{IN_PERCENT}{$PkScoreItemIdx}, $PkScoreItemIdx );
    }
    foreach $PkScoreItemIdx (sort keys %{$DATA{IN_ORDER}}){
        $Item->updateInOrder_byId($DATA{IN_ORDER}{$PkScoreItemIdx}, $PkScoreItemIdx );
    }
    $Group->updateClDetails_ById( uri_unescape( $DATA{TX_DETAIL}{DATA} ), $PkScoreGroupIdx );
    my $str;
    $str = join(", ", keys %DATA);
    return ($str);
}
sub showEditLineItem(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Common = new SAE::Common();
    my $PkScoreItemIdx = $q->param('PkScoreItemIdx');
    my $Item = new SAE::TB_SCORE_ITEM();
    $Item->getRecordById($PkScoreItemIdx);
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id02\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Edit Line Item</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container">';
    $str .= '<label>Line Item Title</label>';
    $str .= '<input class="w3-input w3-text-blue" type="text" placeholder="Enter the Title of this Assessment Item" ID="TX_SCORE_ITEM" value="'.$Item->getTxScoreItem().'">';
    $str .= '<label>Description</label>';
    $str .= '<textarea class="w3-input w3-text-blue w3-border w3-small" data-height="50" ID="TX_DETAIL" >'.$Common->removeBr($Item->getTxDetail()).'</textarea>';
    $str .= '<a class="btnExpand w3-button w3-border fa fa-angle-double-down" href="javascript:void(0);" onclick="expandTextArea(\'TX_DETAIL\');"> Expand</a>';
    $str .= '<a class="btnCollapse w3-button w3-border fa fa-angle-double-up" style="display: none;" href="javascript:void(0);" onclick="collapseTextArea(\'TX_DETAIL\');"> Collapse</a>';
    $str .= '<br><label>Type</label>';
    $str .= '<select class="w3-select w3-text-blue" ID="BO_BINARY">';
    if ($Item->getBoBinary()==1) {
        $str .= '<option value="1" selected>Yes/No</option>';
        $str .= '<option value="0">Numeric Value</option>';
    } else {
        $str .= '<option value="1">Yes/No</option>';
        $str .= '<option value="0" selected>Numeric Value</option>';
    }
    $str .= '</select>';
    $str .= '<label>Weight</label>';
    $str .= '<input class="w3-input w3-text-blue" required type="number" max="100" min="1" ID="IN_PERCENT" value="'.$Item->getInPercent().'" placeholder="Weight">';
    $str .= '<label>Order</label>';
    $str .= '<input class="w3-input w3-text-blue" required type="number" max="100" min="1" ID="IN_ORDER" value="'.$Item->getInOrder().'" placeholder="List Order">';

    $str .= '<div class="w3-container w3-center w3-padding">';

    $str .= '<a class="w3-button w3-border" href="javascript:void(0);" onclick="updateEditedLineItem('.$PkScoreItemIdx.');">Update</a> ';
#     $str .= '<a class="button small" href="javascript:void(0);" onclick="deleteDiv(\'DIV_EDIT_LINE_ITEM\')">Cancel</a>';
    $str .= '</div>';
    $str .= '</form><br><br>';
    return ($str);

}

#============= Sections =====================
sub saveSectionWeight(){
    print $q->header();
    my $Section = new SAE::TB_SCORE_SECTION();

    my $PkScoreGroupIdx = $q->param('PkScoreGroupIdx');
    my %DATA = %{decode_json($q->param('jsonData'))};
    foreach $PkScoreSectionIdx (sort keys %DATA){
        $Section->updateInWeight_byId($DATA{$PkScoreSectionIdx}, $PkScoreSectionIdx );
    }
    my $str;
    $str = join(", ", keys %DATA);
    return ($str);
}
sub deleteSection(){
    print $q->header();
    my $PkScoreSectionIdx = $q->param('PkScoreSectionIdx');
    my $Section = new SAE::TB_SCORE_SECTION();
    $Section->deleteRecordById($PkScoreSectionIdx );
    my $str;
    return ($str);
}
sub addASection(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkScoreGroupIdx = $q->param('PkScoreGroupIdx');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $SQL = "INSERT INTO TB_SCORE_SECTION (TX_SCORE_SECTION, IN_WEIGHT, TX_SCORE_DETAIL, FK_SCORE_GROUP_IDX) VALUES (?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($DATA{TX_SCORE_SECTION},$DATA{IN_WEIGHT},uri_unescape($DATA{TX_SCORE_DETAIL}), $PkScoreGroupIdx);
    my $newIDX = $insert->{q{mysql_insertid}};

    my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= &_templateSectionRowData($newIDX, $PkScoreGroupIdx, $DATA{TX_SCORE_SECTION}, $DATA{IN_WEIGHT});
    return ($str);
}
sub showAddSectionToGroup(){
    print $q->header();
    my $PkScoreGroupIdx = $q->param('PkScoreGroupIdx');
    my $Group = new SAE::TB_SCORE_GROUP();
    $Group->getRecordById($PkScoreGroupIdx);
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Add Section to '.$Group->getTxScoreGroup().' </h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container">';
    $str .= &_templateEventDetails('Section Name', '', 'TX_SCORE_SECTION','text');
    $str .= &_templateEventDetails('Weight (% of Group Score)', 100, 'IN_WEIGHT', 'number');
#     $str .= '<div class="field">';
    $str .= '<label >Description:</label>';
    $str .= '<textarea class="w3-input w3-border" ID="TX_SCORE_DETAIL"/></textarea>';

    $str .= '<br>';
    $str .= '<div class="w3-container w3-center">';
    $str .= '<a class="w3-button w3-border w3-round-large" href="javascript:void(0);" onclick="addASection('.$PkScoreGroupIdx.');">Add</a> ' ;
    $str .= '</div>';
    $str .= '</form><br><br>';
    return ($str);
}
sub showSectionPage(){
    print $q->header();
    my $PkScoreEventIdx = $q->param('PkScoreEventIdx');
    my $PkScoreGroupIdx = $q->param('PkScoreGroupIdx');
    my $Group = new SAE::TB_SCORE_GROUP();
    $Group->getRecordById($PkScoreGroupIdx);
    my $Section = new SAE::TB_SCORE_SECTION();
    my %SECTION = %{$Section->getAllRecordBy_FkScoreGroupIdx($PkScoreGroupIdx)};
    my $total = 0;
    foreach $item (sort keys %SECTION) {
        $total += $SECTION{$item}{IN_WEIGHT};
    }
    my $str;
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="showGroupPage('.$PkScoreEventIdx.');">&nbsp;Back</a>';
    $str .= '<h2>Group Section</h2>';
    $str .= '<ul ID="SECTION_TABLE" class="w3-ul w3-card-4 w3-hoverable">';
    foreach $PkScoreSectionIdx (sort keys %SECTION) {
        $str .= &_templateSectionRowData($PkScoreSectionIdx, $PkScoreGroupIdx, $SECTION{$PkScoreSectionIdx}{TX_SCORE_SECTION}, $SECTION{$PkScoreSectionIdx}{IN_WEIGHT});
    }
    $str .= '</ul>';
    $str .= '<ul class="w3-ul w3-border-bottom w3-white w3-border-top" style="margin-top: 15px;">';
    $str .= '<li " class="w3-bar">';
    $str .= '<div class="w3-half">';
    $str .= '<p >Weight (%) TOTAL </p>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter">';
    $str .= '<span ID="TOTAL_SECTION_COUNT" class="w3-xlarge">'.$total.'</span>%';
    $str .= '</div>';
    $str .= '<div class="w3-quarter">';
    $str .= ' <a class="w3-button w3-border w3-right" ID="saveChangesToSectionWeight" href="javascript:void(0);" onclick="saveSectionWeight('.$PkScoreGroupIdx.');">Save Changes</a> ';
    $str .= '</div>';
    $str .= '</li>';
    $str .= '</ul><br>';
    $str .= '<a class="w3-button w3-border w3-card" href="javascript:void(0);" onclick="showAddSectionToGroup('.$PkScoreGroupIdx.');">Add Section to '.$Group->getTxScoreGroup().'</a>';
    return ($str);
}
sub showEditSectionItem(){
    print $q->header();
    my $PkScoreSectionIdx = $q->param('PkScoreSectionIdx');
    my $PkScoreGroupIdx = $q->param('PkScoreGroupIdx');
    my $Group = new SAE::TB_SCORE_GROUP();
    my $Common = new SAE::Common();
    $Group->getRecordById($PkScoreGroupIdx);
    my $Item = new SAE::TB_SCORE_ITEM();
    %ITEM = %{$Item->getAllRecordBy_FkScoreSectionIdx($PkScoreSectionIdx)};
    my $str;
    my $SumTotal = 0;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">'.$Group->getTxScoreGroup().' Section</h2>';
    $str .= '</div>';

    $str .= '<form class="w3-container">';
    $str .= '<p><label>Description:</label>';
    $str .= '<textarea class="w3-input w3-border" ID="CL_DETAILS" class="w3-input" onchange="updateSaveItemButton();">'.$Common->removeBr($Group->getClDetails()).'</textarea>';
    $str .= '</p>';
    $str .= '<div class="w3-container w3-padding">';
    $str .= '<a class="w3-button w3-card-4 w3-border " style="float: right;  margin-right: 15px;" href="javascript:void(0);" onclick="cancelLineItemChanges();">Cancel Changes</a>';
    $str .= '<a class="w3-button w3-card-4 w3-border " style="float: right;  margin-right: 15px;"ID="saveChangesToItemWeight" href="javascript:void('.$PkScoreGroupIdx.');" onclick="saveItemChanges('.$PkScoreGroupIdx.');">Save Changes</a> ';
    $str .= '&nbsp;<a class="w3-button w3-card-4 w3-border " style="float: right;  margin-right: 15px;" href="javascript:void(0);" onclick="showAddLineItem('.$PkScoreSectionIdx.');">Add Line Item</a>&nbsp; ';
    $str .= '</div>';
    $str .= '<ul ID="SECTION_ITEM_TABLE" class="w3-ul w3-border">';
#     $str .= '<ul ID="ITEM_TABLE" class="w3-ul w3-border">';

    foreach $PkScoreItemIdx (sort {$ITEM{$a}{IN_ORDER} <=> $ITEM{$b}{IN_ORDER}} keys %ITEM) {
        $str .= &_templateLineItemRow($PkScoreItemIdx, $ITEM{$PkScoreItemIdx}{IN_ORDER}, $ITEM{$PkScoreItemIdx}{TX_SCORE_ITEM}, $ITEM{$PkScoreItemIdx}{IN_PERCENT}, $ITEM{$PkScoreItemIdx}{BO_BINARY});
        $SumTotal += $ITEM{$PkScoreItemIdx}{IN_PERCENT};
    }
    $str .= '</ul>';

    $str .= '</div>';
    $str .= '<div class="w3-right w3-card-4 w3-border w3-padding">';
    $str .= sprintf 'TOTAL: <span ID="TOTAL_LINE_ITEM">%2.2f</span>', $SumTotal;
    $str .= '</div>';
    $str .= '</form>';
    $str .= '<br>';
    return ($str);
}
sub _templateEventDetails(){
    my $fieldName = shift;
    my $fieldValue = shift;
    my $fieldId = shift;
    my $type = shift;
    my $str;
    $str .= '<label >'.$fieldName.'</label>';
    $str .= '<input class="w3-input w3-text-blue" required max="100" min="1" type="'.$type.'" name="'.$fieldId.'" id="'.$fieldId.'" placeholder="'.$fieldName.'" value="'.$fieldValue.'" />';
    return ($str);
}
sub _templateSectionRowData(){
    my ($idx, $PkScoreGroupIdx, $TxScoreSection, $InWeight) = @_;
    my $str;
    $str = '<li ID="TR_SECTION_IDX_'.$idx.'" class="w3-bar w3-hoverable">';
    $str .= '<div class="w3-half">';
    $str .= '<p ID="TD_TX_SCORE_SECTION_'.$idx.'">'.$TxScoreSection.'</p>';
    $str .= '</div>';
    $str .= '<div class="w3-quarter">';
    $str .= '<input type="number" style="width: 100px; font-size: 1.25em;text-align: center;" max="100" min="1" class="CLASS-SECTION-IN_WEIGHT" data-value="'.$InWeight.'" data-key="'.$idx.'" value="'.$InWeight.'" onchange="enableSaveSectionChangesButton();">';
    $str .= '</div>';
    $str .= '<div class="w3-quarter">';
    $str .= '<span class="w3-bar-item w3-button w3-white w3-text-red w3-xlarge w3-right fa fa-remove" onclick="deleteSection('.$idx.')"></span>';
    $str .= '<span class="w3-bar-item w3-button w3-white w3-xlarge w3-right fa fa-edit" onclick="showEditSectionItem('.$idx.','.$PkScoreGroupIdx.')"></span>';
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub _templateLineItemRow(){
    my ($idx, $order, $title, $weight, $type) = @_;
    my %TYPE = (1=>'Yes/No', 0=>'Numeric Value');
    my $str;
    $str .= '<li ID="TR_LINE_ITEM_'.$idx.'" class="w3-bar">';
        $str .= '<span class="w3-button fa fa-remove w3-right  w3-text-red" onclick="deleteLineItem('.$idx.')"></span> ';
        $str .= '<span class="w3-button fa fa-edit w3-right" onclick="showEditLineItem('.$idx.');"></span>';
        $str .= '<div class="w3-bar-item" style="width: 100px;">';
        $str .= '<input class="w3-input CLASS-ITEM-IN_ORDER" MIN="1" MAX="100" ID="INPUT_IN_ORDER_'.$idx.'" type="number" data-key="'.$idx.'" data-value="'.$order.'" value="'.$order.'" onchange="updateSaveItemButton();">';
        $str .= '<label class="w3-small">Order</label>';
        $str .= '</div>';
        $str .= '<div class="w3-bar-item" style="width: 60%;">';
        $str .= $title;
        $str .= '</div>';
        $str .= '<div class="w3-bar-item" style="width: 100px;">';
        $str .= '<input class="w3-input CLASS-ITEM-IN_PERCENT" ID="TD_IN_PERCENT_'.$idx.'" type="number" value="'.$weight.'" data-value="'.$weight.'" data-key="'.$idx.'" onchange="updateSaveItemButton();">';
        $str .= '<label class="w3-small">Weight</label>';
        $str .= '</div>';
    $str .= '</li>';
    return ($str);
}

#============= GROUPS =======================
sub saveNewGroupInMax(){
    print $q->header();
    my $Group = new SAE::TB_SCORE_GROUP();
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    foreach $PkScoreGroupIdx (sort keys %DATA) {
        $Group->updateInMax_byId($DATA{$PkScoreGroupIdx}, $PkScoreGroupIdx );
    }
    return ($str);
}
sub showGroupPage(){
    print $q->header();
    my $PkScoreEventIdx = $q->param('PkScoreEventIdx');
    my $Group = new SAE::TB_SCORE_GROUP();
    my $ScoreEvent = new SAE::TB_SCORE_EVENT();
    $ScoreEvent->getRecordById($PkScoreEventIdx);
    %GROUP = %{$Group->getAllRecordBy_FkScoreEventIdx($PkScoreEventIdx)};
    my $sumRegular = 0;
    my $sumAdvanced = 0;
    my $sumMicro = 0;
    my $str;
    my $hdr;
    $hdr .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="showAssessmentEvent();">&nbsp;Back</a>';
    $hdr .= '<h3>'.$ScoreEvent->getTxScoreEvent().': Scoring Groups</h3>';
    foreach $PkScoreGroupIdx (sort keys %GROUP) {
        $class=$GROUP{$PkScoreGroupIdx}{FK_CLASS_IDX};
        if ($class==1) {
            $sumRegular += $GROUP{$PkScoreGroupIdx}{IN_MAX};
        } elsif ($class==2) {
            $sumAdvanced += $GROUP{$PkScoreGroupIdx}{IN_MAX};
        } elsif ($class==3) {
            $sumMicro += $GROUP{$PkScoreGroupIdx}{IN_MAX};
        } else {
            $sumRegular += $GROUP{$PkScoreGroupIdx}{IN_MAX};
            $sumAdvanced += $GROUP{$PkScoreGroupIdx}{IN_MAX};
            $sumMicro += $GROUP{$PkScoreGroupIdx}{IN_MAX};
        }
        $str .= &_tilesWithData($GROUP{$PkScoreGroupIdx}{TX_SCORE_GROUP}, $PkScoreEventIdx, $PkScoreGroupIdx, 'fa fa-th-list', $class, $GROUP{$PkScoreGroupIdx}{IN_MAX}, $ScoreEvent->getInMax());
    }
    $hdr .= '<div class="w3-row w3-border">';
    $hdr .= '<div class="w3-third w3-container w3-border">';
    $hdr .= '<h2>Regular Class Max Points</h2>';
    $hdr .= '<p><span class="w3-text-blue" ID="TOTAL_SUM_REGULAR" data-total="'.$sumRegular.'">'.$sumRegular.'</span> / '.$ScoreEvent->getInMax().' pts</p>';
    $hdr .= '</div>';
    $hdr .= '<div class="w3-third w3-container w3-border">';
    $hdr .= '<h2>Advanced Class Max Points</h2>';
    $hdr .= '<p><span class="w3-text-blue" ID="TOTAL_SUM_ADVANCED" data-total="'.$sumAdvanced.'">'.$sumAdvanced.'</span> / '.$ScoreEvent->getInMax().' pts</p>';
    $hdr .= '</div>';
    $hdr .= '<div class="w3-third w3-container w3-border">';
    $hdr .= '<h2>Micro Class Max Points</h2>';
    $hdr .= '<p><span class="w3-text-blue" ID="TOTAL_SUM_MICRO" data-total="'.$sumMicro.'">'.$sumMicro.'</span> / '.$ScoreEvent->getInMax().' pts</p>';
    $hdr .= '</div>';
    $hdr .= '</div>';
    return ($hdr.$str);
}
sub showAssessmentEvent(){
    print $q->header();
    my $ScoreEvent = new SAE::TB_SCORE_EVENT();
    %SCORE_EVENT = %{$ScoreEvent->getAllRecord()};
    my $str;
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadSetupAndAdministration();">&nbsp;Back</a>';
    $str .= '<h2>Type of Scoring Events</h2>';
    foreach $PkScoreEventIdx (sort keys %SCORE_EVENT) {
        $str .= &_tiles($SCORE_EVENT{$PkScoreEventIdx}{TX_SCORE_EVENT}, 'fa fa-pencil', 'showGroupPage('.$PkScoreEventIdx.');' );
    }
    return ($str);
}
sub _tilesWithData(){
    my ($label, $PkScoreEventIdx, $PkScoreGroupIdx, $image, $class, $groupMax, $actualMax) = @_;
    my $str;
    $str .= '<div class="w3-third w3-center  w3-padding">';
    $str .= '<div class="w3-card w3-container" style="min-height:260px; margin-top: 1.0em;">';
    $str .= '<h3>'.$label.'</h3><br>';
    $str .= '<a onclick="showSectionPage('.$PkScoreEventIdx.','.$PkScoreGroupIdx.');" href="javascript:void(0);" class="'.$image.' w3-margin-bottom w3-text-theme w3-hoverable" style="font-size:110px; text-decoration: none;"></a><br />';
    $str .= '<label>Maximum Points allocated for this Section</label><br>';
    $str .= '<input type="number" style="width: 100px; text-align: center; font-size: 1.25em" data-class="'.$class.'"class="IN_MAX_CLASS w3-align-center w3-card w3-text-blue" data-key="'.$PkScoreGroupIdx.'" data-value="'.$groupMax.'" value="'.$groupMax.'" onchange="addUpNumbers();">';
    $str .= '<br><a style="margin-top: 15px;" class="w3-button w3-border" onclick="saveNewGroupInMax('.$actualMax.')">Save</a>';
    $str .= '<br><br></div><br>';
    $str .= '</div>';
    return ($str);
}
sub _tiles(){
    my ($label, $image, $click) = @_;
    my $str;
    $str .= '<div class="w3-third w3-center">';
    $str .= '<div class="w3-card w3-container" style="min-height:260px; margin-top: 1.0em;">';
    $str .= '<h3>'.$label.'</h3><br>';
    $str .= '<a onclick="'.$click.'" href="javascript:void(0);" class="'.$image.' w3-margin-bottom w3-text-theme" style="font-size:110px; text-decoration: none;"></a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
