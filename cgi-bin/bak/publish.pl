#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

use Cwd 'abs_path';


$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;
# my $adv_normal = 100;
# my $reg_normal = 100;
# my $mic_normal = 100;

# my $adv_normal = 150;
# my $reg_normal = 135;
# my $mic_normal = 135;

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
# ===================== 2020 ===================================================
sub showPublishPage(){
    print $q->header();
    my $str = '<br>';
    $str .= '<div class="w3-container w3-margin-top">';
    $str.= "<h3>Publish Results</h3>";
    $str .= '<table class="w3-table-all w3-white">';
    $str .= '<tr>';
    $str .= '<th style="width: 25%;">Class</th>';
    $str .= '<th style="width: 25%;">Regular Class</th>';
    $str .= '<th style="width: 25%;">Advanced Class</th>';
    $str .= '<th style="width: 25%;">Micro Class</th>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Design Results</td>';
    $str .= '<td>'.&_templateAddResultCard(1,14).'</td>'; # 1 = Class, 14 = Design
    $str .= '<td>'.&_templateAddResultCard(2,14).'</td>'; # 2 = Class, 14 = Design
    $str .= '<td>'.&_templateAddResultCard(3,14).'</td>'; # 3 = Class, 14 = Design
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Presentation Results</td>';
    $str .= '<td>'.&_templateAddResultCard(1,15).'</td>'; # 1 = Class, 15 = Presentation
    $str .= '<td>'.&_templateAddResultCard(2,15).'</td>'; # 2 = Class, 15 = Presentation
    $str .= '<td>'.&_templateAddResultCard(3,15).'</td>'; # 3 = Class, 15 = Presentation
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<h4>Flights Results</h4>';
    $str .= '<table class="w3-table-all w3-white">';
    $str .= '<tr>';
    $str .= '<th style="width: 25%;">Class</th>';
    $str .= '<th style="width: 25%;">Regular Class</th>';
    $str .= '<th style="width: 25%;">Advanced Class</th>';
    $str .= '<th style="width: 25%;">Micro Class</th>';
    $str .= '</tr>';
    for ($row=1; $row<=10; $row++){
        $str .= '<tr>';
        $str .= '<td>Round '.$row.'</td>';
        $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
        $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
        $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
        $str .= '</tr>';
    }
    $str .= '<tr>';
    
    $str .= '</table>';
    $str .= '<h4>Overall Results</h4>';
    $str .= '<table class="w3-table-all w3-white">';
    $str .= '<tr>';
    $str .= '<th style="width: 25%;">Class</th>';
    $str .= '<th style="width: 25%;">Regular Class</th>';
    $str .= '<th style="width: 25%;">Advanced Class</th>';
    $str .= '<th style="width: 25%;">Micro Class</th>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>Results</td>';
    $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
    $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
    $str .= '<td><button class="w3-button w3-border w3-card-2">+</button></td>';
    $str .= '</tr>';
    $str .= '</table>';
    for ($row=1; $row<=10; $row++){
        $str .= '<br>';
    }
    
    $str .= '</div>';
    return ($str);
}
sub sae_publishResults(){
    print $q->header();
    my $classIDX = $q>-param('classIDX');
    my $inType = $q>-param('inType');
    my $str = &_templateResultCards('xxxxxx');
    return ($str);
}

sub _templateResultCards(){
    my $tsFile = shift;
    my $str;
    $str .= '<div class="w3-margin-bottom w3-card-4 w3-small w3-margin-left w3-display-container w3-round" style="width: 50%;">';
    $str .= '<header class="w3-container w3-light-grey w3-round">';
    $str .= 'Results';
    $str .= '</header>';
    $str .= '<a class="w3-button w3-hover-red w3-display-topright " style="padding: 0px 5px;" onclick="$(this).parent().remove();">&times;</a>';
    $str .= '<div class="w3-container w3-white" style="padding: 8px 2px;">';
    $str .= '<a class="w3-margin-left" href="result.html?fileID='.$txFile.'" target="_blank"><i class="fa fa-search"></i> Preview View</a>';
    $str .= '</div>';
    $str .= '<button class="w3-button w3-block w3-dark-grey w3-hover-blue" onclick="">Publish</button>';
    $str .= '</div>';
    return ($str);
}

sub _templateAddResultCard(){
    my $classIDX = shift;
    my $inType = shift;
    my $str;
    $str = '<button class="w3-button w3-border w3-card-2" onclick="sae_publishResults(this,'.$classIDX.','.$inType.');">+</button>';
    
}
# ====================== 2019 =============================
# sub viewMyScoreCard(){

# }

# sub generateOverallResults(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my $classIDX = $q->param('classIDX');
#     my $txType = $q->param('txType');
#     my $round = $q->param('round');
#     my $inCat = $q->param('idx');
#     my $Auth = new SAE::Auth();
#     my $TxFile = $Auth->getTemporaryPassword(48);
#     my $FkScoreEventIdx = $q->param('FkScoreEventIdx');
#     my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, FK_SCORE_EVENT_IDX, TX_FILE, IN_SHOW, IN_ROUND, IN_CAT) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
#     my $insert = $dbi->prepare($SQL);
#     $insert->execute($location, $classIDX, $txType, $FkScoreEventIdx, $TxFile, 0,$round, $inCat);
#     my $newIDX = $insert->{q{mysql_insertid}} || die "Error";
#     $str = &_templateResultCards($classIDX, $txType, $newIDX, $inCat, $TxFile, 0, $round);
#     return ($str);
# }
# sub generateOverall(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my $idx = $q->param('idx');
#     my $txType = $q->param('txType');
#     my $str;
# #     my $SQL = "SELECT IN_ROUND FROM TB_PUBLISH WHERE FK_EVENT_IDX=? AND IN_CAT=?";
# #     my $select = $dbi->prepare($SQL);
# #     $select->execute($location, $idx);
# #     while (my($round)=$select->fetchrow_array()){
# #         $SEEN{$round} = 1;
# #     }
#     $str = '<div class="w3-container w3-blue w3-dispaly-container" >';
#     $str .= '<p style="float: left;">'.$txType.' Generator</p>';
#     $str .= '<a class="w3-button w3-hover-white w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
#     $str .= '</div>';
#     $str .= '<div class="w3-container w3-white w3-padding" style="height: 450px; overflow-y: auto;">';
#     $str .= '<ul class="w3-ul w3-tiny">';
#     for (my $r=1; $r<=12; $r++){
#         $FkClassIdx = $idx/10;
#         $w3_disabled = '';
#         if( exists $SEEN{$r}) {$w3_disabled = 'w3-disabled'}
#         $str .= '<li class="'.$w3_disabled.' w3-bar w3-display-container w3-tiny" style="padding: 2px 10px">';
#         $str .= '<input ID="Round_'.$r.'" type="radio" name="Rounds" data-key="'.$idx.'" data-label="'.$value.'" value="'.$value.'" onchange="showGenerateButton(this, '.$r.');" class="inputBinary w3-display-left largerCheckbox">';
#         $str .= '<label for="Round_'.$r.'" class="w3-bar-item w3-margin-left">Overall After Round '.$r.'</label>';
#         $str .= '<button  class="w3-tiny w3-button w3-border w3-blue w3-card w3-margin-left GENERATE_BUTTON GENERATE_BUTTON_'.$r.'" style="display: none;" onclick="generateOverallResults(this, '.$r.','.$idx.',1,\'Regular Class '.$txType.'\', 5);">Regular Class</button>';
#         $str .= '<button  class="w3-tiny w3-button w3-border w3-blue w3-card w3-margin-left GENERATE_BUTTON GENERATE_BUTTON_'.$r.'" style="display: none;" onclick="generateOverallResults(this, '.$r.','.$idx.',2,\'Advanced Class '.$txType.'\', 5);">Advanced Class</button>';
#         $str .= '<button  class="w3-tiny w3-button w3-border w3-blue w3-card w3-margin-left GENERATE_BUTTON GENERATE_BUTTON_'.$r.'" style="display: none;" onclick="generateOverallResults(this, '.$r.','.$idx.',3,\'Micro Class '.$txType.'\', 5);">Micro Class</button>';
#         $str .= '</li>';
#     }
#     $str .= '</ul>';
#     $str .= '</div>';

#     return ($str);
# }
# sub generateRoundResults(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my $classIDX = $q->param('classIDX');
#     my $txType = $q->param('txType');
#     my $round = $q->param('round');
#     my $inCat = $q->param('idx');
#     my $Auth = new SAE::Auth();
#     my $TxFile = $Auth->getTemporaryPassword(48);
#     my $FkScoreEventIdx = $q->param('FkScoreEventIdx');
#     my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, FK_SCORE_EVENT_IDX, TX_FILE, IN_SHOW, IN_ROUND, IN_CAT) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
#     my $insert = $dbi->prepare($SQL);
#     $insert->execute($location, $classIDX, $txType, $FkScoreEventIdx, $TxFile, 0,$round, $inCat);
#     my $newIDX = $insert->{q{mysql_insertid}} || die "Error";
#     $str = &_templateResultCards($classIDX, $txType, $newIDX, $inCat, $TxFile, 0, $round);
#     return ($str);
# }
# sub generateFlightResults(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my $idx = $q->param('idx');
#     my $txType = $q->param('txType');
#     my $str;
#     my $SQL = "SELECT IN_ROUND FROM TB_PUBLISH WHERE FK_EVENT_IDX=? AND IN_CAT=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($location, $idx);
#     while (my($round)=$select->fetchrow_array()){
#         $SEEN{$round} = 1;
#     }
#     $str = '<div class="w3-container w3-blue w3-dispaly-container" >';
#     $str .= '<p style="float: left;">'.$txType.' Generator</p>';
#     $str .= '<a class="w3-button w3-hover-white w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
#     $str .= '</div>';
#     $str .= '<div class="w3-container w3-white w3-padding" style="height: 450px; overflow-y: auto;">';
#     $str .= '<ul class="w3-ul">';
#     for (my $r=1; $r<=12; $r++){
#         $FkClassIdx = $idx/10;
#         $w3_disabled = '';
#         if( exists $SEEN{$r}) {$w3_disabled = 'w3-disabled'}
#         $str .= '<li class="'.$w3_disabled.' w3-bar w3-display-container" style="padding: 2px 10px">';
#         $str .= '<input ID="Round_'.$r.'" type="radio" name="Rounds" data-key="'.$idx.'" data-label="'.$value.'" value="'.$value.'" onchange="showGenerateButton(this, '.$r.');" class="inputBinary w3-display-left largerCheckbox">';
#         $str .= '<label for="Round_'.$r.'" class="w3-bar-item w3-margin-left">Round '.$r.'</label>';
#         $str .= '<button ID="BTN_FOR_'.$r.'" ';
#         $str .= 'class="w3-small w3-button w3-border w3-blue w3-card w3-margin-left GENERATE_BUTTON  GENERATE_BUTTON_'.$r.'" style="display: none;" ';
#         $str .= 'onclick="generateRoundResults('.$r.','.$idx.','.$FkClassIdx.',\''.$txType.'\', 3);">Generate</button>';
#         $str .= '</li>';
#     }
#     $str .= '</ul>';
#     $str .= '</div>';

#     return ($str);
# }
# sub makePublic(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $PkPublishIdx = $q->param('PkPublishIdx');
#     my $SQL = "UPDATE TB_PUBLISH SET IN_SHOW=? WHERE PK_PUBLISH_IDX=?";
#     my $update = $dbi->prepare($SQL);
#     $update->execute(1, $PkPublishIdx);
# #     return ($PkPublishIdx);
# }
# sub deletePublishedItem(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $PkPublishIdx = $q->param('PkPublishIdx');
#     my $SQL = "DELETE FROM TB_PUBLISH WHERE PK_PUBLISH_IDX=?";
#     my $delete = $dbi->prepare($SQL);
#     $delete->execute($PkPublishIdx);
#     $SQL = "DELETE FROM TB_FEED WHERE FK_PUBLISH_IDX=?";
#     $delete = $dbi->prepare($SQL);
#     $delete->execute($PkPublishIdx);
#     return ($PkPublishIdx);
# }
# sub _templateResultCards(){
#     my $classIDX = shift;
#     my $txType = shift;
#     my $PkPublishIdx = shift;
#     my $inCat = shift;
#     my $txFile = shift;
#     my $inShow = shift;
#     my $inRound = shift;
#     my $str;
#     %CLASS = (1=>'Regular',2=>'Advanced',3=>'Micro');
#     my $str;
#     $str = '<div ID="PUBLISH_IDX_'.$PkPublishIdx.'" class="w3-margin-bottom w3-card-4 w3-small w3-margin-left  w3-display-container" style="width:110px; float: left; text-align: center;">';
#     $str .= '<header class="w3-container w3-light-grey"><meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
#     if ($inCat>9){
#         $str .= 'Round '.$inRound;
#     } else {
#         $str .= $CLASS{$classIDX};
#     }

#     $str .= '<a class="w3-button w3-hover-red w3-display-topright " style="padding: 0px 5px;" onclick="deletePublishedItem('.$PkPublishIdx.');">&times;</a>';
#     $str .= '</header>';

#     $str .= '<div class="w3-container w3-white" style="padding: 8px 2px;">';
#     $str .= '<a href="result.html?fileID='.$txFile.'"  target="_blank"><span class="fa fa-search">View '.$txType.'</span></a>';

#     $str .= '</div>';
#     if ($inShow == 0){
#         $str .= '<button class="w3-button w3-block w3-dark-grey w3-hover-blue" onclick="makePublic(this, '.$PkPublishIdx.');">Publish</button>';
#     }
#     $str .= '</div> ';
#     return ($str);
# }
# sub generateCheckedItems(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my $idx = $q->param('idx');
#     my $txType = $q->param('txType');
#     my $Auth = new SAE::Auth();

#     my %DATA = %{decode_json($q->param('jsonData'))};

#     my $FkScoreEventIdx=$idx;
#     if ($idx>2){$FkScoreEventIdx=3}
#     my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, FK_SCORE_EVENT_IDX, TX_FILE, IN_SHOW, IN_CAT) VALUES (?, ?, ?, ?, ?, ?, ?)";
#     my $insert = $dbi->prepare($SQL);

#     foreach $classIDX (sort {$a <=> $b} keys %DATA){
#         my $TxFile = $Auth->getTemporaryPassword(48);
#         $insert->execute($location, $classIDX, $txType, $FkScoreEventIdx, $TxFile, 0, $idx ) || die $0;
#         my $newIDX = $insert->{q{mysql_insertid}} || die "Error";
#         $str .= &_templateResultCards($classIDX, $txType, $newIDX, $idx, $TxFile, 0, 0);
# #         $str .= "$location, $classIDX, $txType, $FkScoreEventIdx, $TxFile<br>";
#     }
#     return ($str);
# }
# sub _templateFridayItems(){
#     my $idx = shift;
#     my $txType = shift;
#     my $value = shift;
# #     my $txType = shift;
#     my $str;
#     $str = '<li class="w3-bar w3-display-container">';
#     $str .= '<input ID="Class_'.$value.'" type="checkbox" data-key="'.$idx.'" data-label="'.$value.'" value="'.$value.'" class="inputBinary w3-display-left largerCheckbox">';
#     $str .= '<label for="Class_'.$value.'" class="w3-bar-item w3-margin-left">Regular Class '.$txType.'</label>';
#     $str .= '</li>';
#     return($str);
# }
# sub generateFridayResults(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my $idx = $q->param('idx');
#     my $txType = $q->param('txType');
#     my $str;
#     $str = '<div class="w3-container w3-blue w3-dispaly-container" >';
#     $str .= '<p style="float: left;">'.$txType.' Results Generator</p>';
#     $str .= '<a class="w3-button w3-hover-white w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
#     $str .= '</div>';
#     $str .= '<ul>';
#     $str .= &_templateFridayItems($idx, 'Regular Class '.$txType, 1);
#     $str .= &_templateFridayItems($idx, 'Advanced Class '.$txType, 2);
#     $str .= &_templateFridayItems($idx, 'Micro Class '.$txType, 3);
#     $str .= '</ul>';
#     $str .= '<div class="w3-panel w3-container w3-padding" style="text-align: center; padding-bottom: 20px;">';
#     $str .= '<Button class="w3-button w3-border w3-hover-blue" onclick="generateCheckedItems('.$idx.',\''.$txType.'\');">Generate</Button>';
#     $str .= '<Button class="w3-button w3-border w3-margin-left" onclick="closeModal(\'id01\');">Cancel</Button>';
#     $str .= '</div>';
#     return ($str);
# }
# sub showResultsMain(){
#     print $q->header();
#     my $str;
#     my $dbi = new SAE::Db();
#     my $location = $q->param('location');
#     my %CATEGORY = (
#         1=>"Design Results",
#         2=>"Presentation Results",
#         10=>"Regular Class Flight Results",
#         20=>"Advanced Class Flight Results",
#         30=>"Micro Class Flight Results",
#         100=>"Overall Results"
# #         200=>"Final Results"
#     );
#     my $SQL = "SELECT * FROM TB_PUBLISH WHERE FK_EVENT_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($location);
#     %PUB = %{$select->fetchall_hashref(['IN_CAT','PK_PUBLISH_IDX'])};
#     $str = '<div class="w3-container w3-white">';
#     $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadMainPage();">&nbsp;Back</a>';
#     $str .= '</div>';
#     $str .= '<table class="w3-table-all w3-small">';
#     $str .= '<thead>';
#     $str .= '<tr>';
#     $str .= '<th style="width: 150px;">Category</th>';
#     $str .= '<th style="width: 50px; text-align: center;" >+</th>';
#     $str .= '<th >Results</th>';
#     $str .= '</tr>';
#     $str .= '</thead>';
#     $str .= '<tbody>';
#     foreach $idx (sort {$a <=> $b} keys %CATEGORY) {
#         $str .= '<tr>';
#         $str .= '<td>'.$CATEGORY{$idx}.'</td>';
#         $str .= '<td>';
#         if ($idx < 10 ) {
#             $str .= '<button ID="BTN_DEMO_ADD_CARD_'.$teamIDX.'" class="w3-button " style="border: 1px dashed #ccc;" onclick="generateFridayResults('.$idx.',\''.$CATEGORY{$idx}.'\');">+</button>';
#         } elsif ($idx == 10 || $idx == 20 || $idx == 30) {
#             $str .= '<button ID="BTN_DEMO_ADD_CARD_'.$teamIDX.'" class="w3-button " style="border: 1px dashed #ccc;" onclick="generateFlightResults('.$idx.',\''.$CATEGORY{$idx}.'\');">+</button>';
# #             $str .= '<button ID="BTN_DEMO_ADD_CARD_'.$teamIDX.'" class="w3-button " style="border: 1px dashed #ccc;" onclick="generateFlightResults('.$teamIDX.',\''.$CATEGORY{$idx}.'\');">+</button>';
#         } else {
#             $str .= '<button ID="BTN_DEMO_ADD_CARD_'.$teamIDX.'" class="w3-button " style="border: 1px dashed #ccc;" onclick="generateOverall('.$idx.',\''.$CATEGORY{$idx}.'\');">+</button>';
#         }

#         $str .= '</td>';
#         $str .= '<td ID="TD_ROW_RESULTS_FOR_'.$idx.'" >';
#         foreach $PkPubIdx(sort {$PUB{$idx}{$a}{IN_ROUND} <=> $PUB{$idx}{$b}{IN_ROUND}} keys %{$PUB{$idx}}) {
#             $classIDX = $PUB{$idx}{$PkPubIdx}{FK_CLASS_IDX};
#             $inShow = $PUB{$idx}{$PkPubIdx}{IN_SHOW};
#             $inRound = $PUB{$idx}{$PkPubIdx}{IN_ROUND};
#             $txTitle = $PUB{$idx}{$PkPubIdx}{TX_TITLE};
#             $txFile = $PUB{$idx}{$PkPubIdx}{TX_FILE};
#             $str .= &_templateResultCards($classIDX, $txTitle, $PkPubIdx, $idx, $txFile, $inShow, $inRound);
#         }
#         $str .= '</td>';
#         $str .= '</tr>';
#     }
#     $str .= '</tbody>';
#     $str .= '</table>';

#     return ($str);
# }
# sub showPublishedResults(){
#     print $q->header();
#     my $str;
#     my $fileID = $q->param('fileID');
#     my $str;
#     my $dbi = new SAE::Db();
#     my $SQL = "SELECT * FROM TB_PUBLISH WHERE TX_FILE=?";
# 	my $select = $dbi->prepare($SQL);
# 	   $select->execute($fileID);
# 	my %HASH = %{$select->fetchrow_hashref()};
#     my $Tab = new SAE::Tabulate();
#     my $classIDX = $HASH{FK_CLASS_IDX};
#     my $eventIDX = $HASH{FK_EVENT_IDX};
#     my $inRound = $HASH{IN_ROUND};
#     if ($HASH{FK_SCORE_EVENT_IDX} == 1){
#         if ($classIDX==1){
#             $str .= &getRegularDesignResults($classIDX, $eventIDX, 'table-row');
#         } elsif ($classIDX==2) {
#             $str .= &getAdvancedDesignResults($classIDX, $eventIDX, 'table-row');
#         } elsif ($classIDX==3) {
#             $str .= &getMicroDesignResults($classIDX, $eventIDX, 'table-row');
#         }
#     } elsif ($HASH{FK_SCORE_EVENT_IDX} == 2) {
#         if ($classIDX==1){
#             $str .= &getRegularPresoResults($classIDX, $eventIDX, 'table-row');
#         } elsif ($classIDX==2) {
#             $str .= &getAdvancedPresoResults($classIDX, $eventIDX, 'table-row');
#         } elsif ($classIDX==3) {
#             $str .= &getMicroPresoResults($classIDX, $eventIDX, 'table-row');
#         }
#     } elsif ($HASH{FK_SCORE_EVENT_IDX} == 3) {
#         if ($classIDX==1){
#             $str .= &getRegularMissionResults( $classIDX, $eventIDX, $inRound, 'table-row' );
# #             $str .= $Tab->getRegularFlightResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
#         } elsif ($classIDX==2) {
#             $str .= &getAdvancedMissionResults( $classIDX, $eventIDX, $inRound, 'table-row');
#         } elsif ($classIDX==3) {
#             $str .= &getMicroMissionResults( $classIDX, $eventIDX, $inRound);
# #             $str .= $Tab->getMicroFlightResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
#         }
#     } elsif ($HASH{FK_SCORE_EVENT_IDX} == 5) {
# #         $str .= $Tab->getOverallResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
#         if ($classIDX==1){
#             $str .= &getRegularOverallResults($classIDX, $eventIDX, $inRound, 'none' );
#         } elsif ($classIDX==2) {
#             $str .= &getAdvancedOverallResults($classIDX, $eventIDX, $inRound, 'none' );
#         } elsif ($classIDX==3) {
#             $str .= &getMicroOverallResults($classIDX, $eventIDX, $inRound, 'none' );
#         }
#     }
#     return ($str);
# }
# # ============================ REGULAR CLASS RESULTS ============================
# sub getRegularOverallResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $inRound = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $reg = new SAE::REGULAR();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY, TEAM.IN_FACTOR  FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     my %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($ap, $s1, $s2, $s3, $d, $presototal) = $reg->getPresoScore($teamIDX, $classIDX);
#         my ($ad, $r, $t, $dr, $late, $designtotal) = $reg->getDesignScore($teamIDX);
#         my $revenue = 0;
#         for (my $x=1; $x<=$inRound; $x++){
#             my ($c, $p, $l, $e, $rev) = $reg->getTeamFlightScoreInRound($teamIDX, $x);
#             $revenue += $rev;
#         }
#         my ($pen) = $reg->getPenalty($teamIDX);
#         $TEAM{$teamIDX}{PRESO} = $presototal;
#         $TEAM{$teamIDX}{DESIGN} = ($designtotal - $late) * $TEAM{$teamIDX}{IN_FACTOR};
#         $TEAM{$teamIDX}{PENALTY} = $pen;
#         my $score = (1/(40 * $inRound))*$revenue;
#         my $normal = ($score/$reg_normal)*100;
#         if ($normal < 0){$normal = 0}
#         $TEAM{$teamIDX}{NORMAL} = $normal;
#         $TEAM{$teamIDX}{IN_TOTAL} = $TEAM{$teamIDX}{DESIGN} + $presototal + $normal - $pen;
#     }
#     my $str;
#     $str .= &getRegularDesignResults($classIDX,$eventIDX, 'none');
#     $str .= &getRegularPresoResults($classIDX,$eventIDX, 'none');
#     $str .= &getRegularMissionResults($classIDX,$eventIDX, $inRound ,'none');
#     $str .= '<h1>'.$Class->getTxClass().' Class Overall Results (Round '.$inRound.')</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">Design</th>';
#     $str .= '<th style="text-align: right">Presentation</th>';
#     $str .= '<th style="text-align: right">Normalized<br>Flight<br>Score</th>';
#     $str .= '<th style="text-align: right">Penalties</th>';
#     $str .= '<th style="text-align: right">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="overallhiddenRow" style="display: none;">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DESIGN};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{PRESO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{NORMAL};
#         $str .= sprintf '<td nowrap style="text-align: right"><span class="w3-text-red">-%2.1f</span></td>',$TEAM{$teamIDX}{PENALTY};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'overallhiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getRegularPresoResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $reg = new SAE::REGULAR();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($a, $s1, $s2, $s3, $d, $total) = $reg->getPresoScore($teamIDX, $classIDX);
#         $TEAM{$teamIDX}{PRESO} = $a;
#         $TEAM{$teamIDX}{1} = $s1;
#         $TEAM{$teamIDX}{2} = $s2;
#         $TEAM{$teamIDX}{3} = $s3;
#         $TEAM{$teamIDX}{DEMO} = $d;
#         $TEAM{$teamIDX}{IN_TOTAL} = $total;
#     }
#     my $str;
# #     $str .= "$classIDX,$eventIDX";
#     $str .= '<h1>'.$Class->getTxClass().' Class Final Technical Presentation Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">Score #1</th>';
#     $str .= '<th style="text-align: right">Score #2</th>';
#     $str .= '<th style="text-align: right">Score #3</th>';
#     $str .= '<th style="text-align: right">Avg. Score</th>';
#     $str .= '<th style="text-align: right">Demo</th>';
#     $str .= '<th  style="text-align: right;">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="PresohiddenRow" style="display: '.$display.';">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{1};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{2};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{3};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{PRESO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.1f</td>',$TEAM{$teamIDX}{DEMO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'PresohiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getRegularDesignResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $reg = new SAE::REGULAR();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY, TEAM.IN_FACTOR FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($a, $r, $t, $d, $late, $total) = $reg->getDesignScore($teamIDX);
#         $TEAM{$teamIDX}{REPORT} = $a;
#         $TEAM{$teamIDX}{TDS} = $t;
#         $TEAM{$teamIDX}{REQ} = $r;
#         $TEAM{$teamIDX}{DRW} = $d;
#         $TEAM{$teamIDX}{SUB_TOTAL} = $total;
#         $TEAM{$teamIDX}{IN_LATE} = $late;
#         # $TEAM{$teamIDX}{_LATE} = $TEAM{$teamIDX}{IN_LATE} * 5;
#         $TEAM{$teamIDX}{IN_TOTAL} = ($total - $late) * $TEAM{$teamIDX}{IN_FACTOR};
#     }
#     my $str;
#     $str = '<h1>'.$Class->getTxClass().' Class Final Technical Design Report Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">REQ</th>';
#     $str .= '<th style="text-align: right">DRW</th>';
#     $str .= '<th style="text-align: right">TDS</th>';
#     $str .= '<th style="text-align: right">Avg. Rpt</th>';
#     $str .= '<th style="text-align: right">Sub Total</th>';
#     $str .= '<th style="text-align: right">Late Report<br>Penalty</th>';
#     $str .= '<th style="text-align: right">Factor</th>';
#     $str .= '<th  style="text-align: right;">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="DesignhiddenRow" style="display: '.$display.';">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{REQ};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DRW};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{TDS};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{REPORT};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{SUB_TOTAL};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.2f</td>',$TEAM{$teamIDX}{IN_LATE};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.2f</td>',$TEAM{$teamIDX}{IN_FACTOR};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',($TEAM{$teamIDX}{IN_TOTAL});
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'DesignhiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getRegularMissionResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $inRound = shift;
#     my $display = shift;
#     my %NOSHOW = ();
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $reg = new SAE::REGULAR();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     %NOSHOW = %{$reg->getNoShows($eventIDX, $classIDX)};
#     foreach $teamIDX (sort keys %TEAM) {
#         my $revenue = 0;
#         for (my $x=1; $x<=$inRound; $x++){
#             ($c, $p, $l, $e, $r) = $reg->getTeamFlightScoreInRound($teamIDX, $x);
#             $TEAM{$teamIDX}{$x} = $r;
#             $revenue += $r;
#         }
#         $TEAM{$teamIDX}{TOTAL_REVENUE} = $revenue;
#         my $score = (1/(40 * $inRound))*$revenue;
#         my $normal = ($score/$reg_normal)*100;
#         $TEAM{$teamIDX}{IN_TOTAL} = sprintf "%2.4f",$score ;
#         $TEAM{$teamIDX}{NORMAL} = sprintf "%2.4f",$normal ;
#     }
#     my $str;

#     $str = '<h1>'.$Class->getTxClass().' Class Round '.$inRound.' Mission Performance Results</h1>';
# #     $str .= 'NO SHOW = '.join(',', keys %NOSHOW);
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 250px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     for ($round=1; $round<=$inRound; $round++) {
#         $str .= '<th style="text-align: right; width: 105px;">Round '.$round.'<br>Revenue</th>';
#     }
#     $str .= '<th style="text-align: right;width: 105px;">Total<br>Revenue<br>Generated</th>';
#     $str .= '<th style="text-align: right;width: 105px;">Raw<br>Flight<br>Score</th>';
#     $str .= '<th style="text-align: right;width: 105px;">Normalized<br>Flight<br>Score</th>';
#     $str .= '</tr>';
#     my $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL}<=>$TEAM{$a}{IN_TOTAL}} keys %TEAM ){
#         if (exists $NOSHOW{$teamIDX}){next}
#         $total = $TEAM{$teamIDX}{IN_TOTAL};
#         $normal = $TEAM{$teamIDX}{NORMAL};
#         if ($total <0){$total = 0; $normal = 0;}
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="regFlighthiddenRow" style="display: '.$display.';">';
#         }
#         if ($total > 0){
#             $str .= '<td>'.$c++.'</td>';
#         } else {
#             $str .= '<td>---</td>';
#         }

#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         for (my $x=1; $x<=$inRound; $x++) {
#             $str .= '<td nowrap style="text-align: right">'.format_price($TEAM{$teamIDX}{$x},2,'$').'</td>';
#         }

#         $str .= sprintf '<td nowrap style="text-align: right">'.format_price($TEAM{$teamIDX}{TOTAL_REVENUE},2,'$').'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$total;
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>', $normal;

#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'regFlighthiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# # ============================ ADVANCED CLASS RESULTS ============================
# sub _calDaysScore(){
#     my $colonist = shift;
#     my $habitat = shift;
#     my $water = shift;
#     my $static = shift;
#     my $inRound = shift;
#     my $col2Hab;
#     my $col2Water;
#     my $days = 0;
#     my $total = 0;
#     if ($habitat>0){
#         $col2Hab = $colonist/(8 * $habitat);
#     }
#     if ($water>0){
#         $col2Water = $colonist/$water;
#     }
#     if ($habitat==0 || $water==0 || $colonist==0){
#          $days = 0;
#     } else {
#         $max = $col2Hab;
#         if ($col2Water > $col2Hab){$max = $col2Water}
#         $days = 25 * 2**(1-$max);
#     }
#     if ($inRound==0){
#         $total = 0;
#     } else {
#         $total = (($colonist*$days)/(15*$inRound)) + (2*$static)/$inRound;
#     }
#     return ($days, $total);
# }
# sub getAdvancedOverallResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $inRound = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $adv = new SAE::ADVANCED();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY, TEAM.IN_FACTOR FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     my %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($ap, $s1, $s2, $s3, $d, $presototal) = $adv->getPresoScore($teamIDX, $classIDX);
#         my ($ad, $r, $t, $dr, $late, $designtotal) = $adv->getDesignScore($teamIDX);
#         my $max;
#         for (my $x=1; $x<=$inRound; $x++){
#             ($c, $h, $w, $p) = $adv->getTeamFlightScoreInRound($teamIDX, $x);
#             $TEAM{$teamIDX}{COL} += $c;
#             $TEAM{$teamIDX}{HAB} += $h;
#             $TEAM{$teamIDX}{WAT} += $w;
#             $TEAM{$teamIDX}{PAY} += $p;
#         }
#         my ($pen) = $adv->getPenalty($teamIDX);
# #         print "$TEAM{$teamIDX}{COL}, $TEAM{$teamIDX}{HAB}, $TEAM{$teamIDX}{WAT}, $TEAM{$teamIDX}{PAY}, $inRound<br>";
#         my ($days, $total) = &_calDaysScore($TEAM{$teamIDX}{COL}, $TEAM{$teamIDX}{HAB}, $TEAM{$teamIDX}{WAT}, $TEAM{$teamIDX}{PAY}, $inRound);
#         $TEAM{$teamIDX}{IN_DAYS} =$days;
#         $TEAM{$teamIDX}{PRESO} = $presototal;
#         $TEAM{$teamIDX}{DESIGN} = ($designtotal-$late) * $TEAM{$teamIDX}{IN_FACTOR};
#         $TEAM{$teamIDX}{TOTAL} = $total;
#         $TEAM{$teamIDX}{PENALTY} = $pen;
#         $TEAM{$teamIDX}{IN_TOTAL} = $TEAM{$teamIDX}{DESIGN} + $presototal + $total - $pen;
#     }
#      my $str;
#     $str .= &getAdvancedDesignResults($classIDX,$eventIDX, 'none');
#     $str .= &getAdvancedPresoResults($classIDX,$eventIDX, 'none');
#     $str .= &getAdvancedMissionResults($classIDX,$eventIDX, $inRound ,'none');
#     $str .= '<h1>'.$Class->getTxClass().' Class Overall Results (Round '.$inRound.')</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">Design</th>';
#     $str .= '<th style="text-align: right">Presentation</th>';
#     $str .= '<th style="text-align: right">Normalized<br>Mission<br>Performance</th>';
#     $str .= '<th style="text-align: right">Penalties</th>';
#     $str .= '<th style="text-align: right">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="overallhiddenRow" style="display: none;">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DESIGN};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{PRESO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',($TEAM{$teamIDX}{TOTAL}/$adv_normal)*100;
#         $str .= sprintf '<td nowrap style="text-align: right"><span class="w3-text-red">-%2.1f</span></td>',$TEAM{$teamIDX}{PENALTY};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'overallhiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getAdvancedDesignResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $adv = new SAE::ADVANCED();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY, TEAM.IN_FACTOR FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($a, $r, $t, $d, $late, $total) = $adv->getDesignScore($teamIDX);
#         $TEAM{$teamIDX}{REPORT} = $a;
#         $TEAM{$teamIDX}{TDS} = $t;
#         $TEAM{$teamIDX}{REQ} = $r;
#         $TEAM{$teamIDX}{DRW} = $d;
#         $TEAM{$teamIDX}{IN_LATE} = $late;
#         $TEAM{$teamIDX}{SUB_TOTAL} = $total;
#         $TEAM{$teamIDX}{IN_TOTAL} = ($total - $late) * $TEAM{$teamIDX}{IN_FACTOR};
#     }
#     my $str;
#     $str = '<h1>'.$Class->getTxClass().' Class Final Technical Design Report Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">REQ</th>';
#     $str .= '<th style="text-align: right">DRW</th>';
#     $str .= '<th style="text-align: right">TDS</th>';
#     $str .= '<th style="text-align: right">Avg. Rpt</th>';
#     $str .= '<th style="text-align: right">Sub Total</th>';
#     $str .= '<th style="text-align: right">Late Report<br>Penalty</th>';
#     $str .= '<th style="text-align: right">Factor</th>';
#     $str .= '<th  style="text-align: right;">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="DesignhiddenRow" style="display: '.$display.';">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{REQ};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DRW};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{TDS};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{REPORT};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{SUB_TOTAL};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.2f</td>',$TEAM{$teamIDX}{IN_LATE};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.2f</td>',$TEAM{$teamIDX}{IN_FACTOR};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'DesignhiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getAdvancedPresoResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $adv = new SAE::ADVANCED();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($a, $s1, $s2, $s3, $d, $total) = $adv->getPresoScore($teamIDX, $classIDX);
#         $TEAM{$teamIDX}{PRESO} = $a;
#         $TEAM{$teamIDX}{1} = $s1;
#         $TEAM{$teamIDX}{2} = $s2;
#         $TEAM{$teamIDX}{3} = $s3;
#         $TEAM{$teamIDX}{DEMO} = $d;
#         $TEAM{$teamIDX}{IN_TOTAL} = $total;
# #         $TEAM{$teamIDX}{COUNT} = $count;
#     }
#     my $str;
# #     $str .= "$classIDX,$eventIDX";
#     $str .= '<h1>'.$Class->getTxClass().' Class Final Technical Presentation Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">Score #1</th>';
#     $str .= '<th style="text-align: right">Score #2</th>';
#     $str .= '<th style="text-align: right">Score #3</th>';
#     $str .= '<th style="text-align: right">Avg. Score</th>';
# #     $str .= '<th style="text-align: right">Demo</th>';/
#     $str .= '<th  style="text-align: right;">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="PresohiddenRow" style="display: '.$display.';">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{1};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{2};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{3};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{PRESO};
# #         $str .= sprintf '<td nowrap style="text-align: right">%2.1f</td>',$TEAM{$teamIDX}{DEMO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'PresohiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getAdvancedMissionResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $inRound = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $adv = new SAE::ADVANCED();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my %TEAM = ();
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

#     foreach $teamIDX (sort keys %TEAM) {
#         my $max;
#         for (my $x=1; $x<=$inRound; $x++){
#             ($c, $h, $w, $p) = $adv->getTeamFlightScoreInRound($teamIDX, $x);
#             $TEAM{$teamIDX}{COL} += $c;
#             $TEAM{$teamIDX}{HAB} += $h;
#             $TEAM{$teamIDX}{WAT} += $w;
#             $TEAM{$teamIDX}{PAY} += $p;
#         }
#         my ($days, $total) = &_calDaysScore($TEAM{$teamIDX}{COL}, $TEAM{$teamIDX}{HAB}, $TEAM{$teamIDX}{WAT}, $TEAM{$teamIDX}{PAY}, $inRound);
#         $TEAM{$teamIDX}{IN_DAYS} =$days;
#         $TEAM{$teamIDX}{IN_TOTAL} =$total;
#     }
#     my $str;
#     $str = '<h1>'.$Class->getTxClass().' Class Round '.$inRound.' Mission Performance Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 250px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right;"># of<br>Colonist</th>';
#     $str .= '<th style="text-align: right;"># of<br>Habitat</th>';
#     $str .= '<th style="text-align: right;">Amt. of<br>Water</th>';
#     $str .= '<th style="text-align: right;">Amt. of<br>Fuel<br>(Static)</th>';
#     $str .= '<th style="text-align: right;">Days<br>Of<br>Habitability</th>';
# #     $str .= '<th style="text-align: right;">Penalties</th>';
#     $str .= '<th style="text-align: right;">Final<br>Flight<br>Score</th>';
#     $str .= '<th style="text-align: right;">Normalized<br>Flight<br>Score</th>';
#     $str .= '</tr>';
#     my $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL}<=>$TEAM{$a}{IN_TOTAL}} keys %TEAM ){
#         $total = $TEAM{$teamIDX}{IN_TOTAL};
#         $normal = $TEAM{$teamIDX}{NORMAL};
#         if ($total <0){$total = 0; $normal = 0;}
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="advFlighthiddenRow" style="display: '.$display.';">';
#         }
#         if ($total > 0){
#             $str .= '<td>'.$c++.'</td>';
#         } else {
#             $str .= '<td>---</td>';
#         }

#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';

#         $str .= sprintf '<td nowrap style="text-align: right">%2.3f</td>',$TEAM{$teamIDX}{COL};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.3f</td>',$TEAM{$teamIDX}{HAB};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.3f</td>',$TEAM{$teamIDX}{WAT};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.3f</td>',$TEAM{$teamIDX}{PAY};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.3f</td>',$TEAM{$teamIDX}{IN_DAYS};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$total ;
#         $str .= sprintf '<td nowrap style="text-align: right"><b>%2.4f</b></td>',$total ;
# #         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>', $normal;

#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'advFlighthiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# # ============================ MICRO CLASS RESULTS ============================
# sub getMicroOverallResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $inRound = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $mic = new SAE::MICRO();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY, TEAM.IN_FACTOR FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     my %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($ap, $s1, $s2, $s3, $d, $presototal) = $mic->getPresoScore($teamIDX, $classIDX);
#         my ($ad, $r, $t, $dr, $late, $designtotal) = $mic->getDesignScore($teamIDX);

#         my $max=0;
#         my $pf=0;
#         my $flight = 0;
#         for (my $x=1; $x<=$inRound; $x++){
#             ($payload, $empty, $pf, $adjusted, $demo, $m, $d) = $mic->getTeamFlightScoreInRound($teamIDX, $x);
            
# #             ($pf, $demo) = $mic->getTeamFlightScoreInRound($teamIDX, $x);
# #             (getTeamFlightScoreInRound)

# #             ($p, $e, $s, $d, $m, $d) = $mic->getTeamFlightScoreInRound($teamIDX, $x);

#             if ($adjusted > $max){$max = $adjusted}
#             $flight += $adjusted;
#             $TEAM{$teamIDX}{$x} = $adjusted;
#             $TEAM{$teamIDX}{DEMO} = $demo;
#         }
#         my $pen = $mic->getPenalty($teamIDX);
#         $TEAM{$teamIDX}{MAX}=$max;
#         if ($inRound==0){
#             $total= 0;
#         } else {
#             $total = (20 * (.5*($flight/$inRound) + .5*($max))) + $demo;
#         }
#         my $normal = ($total/$mic_normal)*100;
# #         my $normal = $total;
# #         $TEAM{$teamIDX}{MAX} = $max;
# #         $TEAM{$teamIDX}{FLIGHT} = $flight;
#         $TEAM{$teamIDX}{PRESO} = $presototal;
#         $TEAM{$teamIDX}{DESIGN} = ($designtotal - $late) * $TEAM{$teamIDX}{IN_FACTOR};
#         # $TEAM{$teamIDX}{DESIGN} = $designtotal * $TEAM{$teamIDX}{IN_FACTOR};
#         $TEAM{$teamIDX}{NORMAL} = $normal;
#         $TEAM{$teamIDX}{PENALTY} = $pen;
#         $TEAM{$teamIDX}{IN_TOTAL} = $TEAM{$teamIDX}{DESIGN} + $presototal + $normal - $pen;
#     }
#      my $str;
#     $str .= &getMicroDesignResults($classIDX,$eventIDX, 'none');
#     $str .= &getMicroPresoResults($classIDX,$eventIDX, 'none');
#     $str .= &getMicroMissionResults($classIDX,$eventIDX, $inRound ,'none');
#     $str .= '<h1>'.$Class->getTxClass().' Class Overall Results (Round '.$inRound.')</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">Design</th>';
#     $str .= '<th style="text-align: right">Presentation</th>';
#     $str .= '<th style="text-align: right">Mission<br>Performance</th>';
#     $str .= '<th style="text-align: right">Penalties</th>';
#     $str .= '<th style="text-align: right">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="overallhiddenRow" style="display: none;">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DESIGN};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{PRESO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{NORMAL};
#         $str .= sprintf '<td nowrap style="text-align: right"><span class="w3-text-red">-%2.1f</span></td>',$TEAM{$teamIDX}{PENALTY};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'overallhiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getMicroDesignResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $mic = new SAE::MICRO();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY, TEAM.IN_FACTOR FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($a, $r, $t, $d, $late, $total) = $mic->getDesignScore($teamIDX);
#         $TEAM{$teamIDX}{REPORT} = $a;
#         $TEAM{$teamIDX}{TDS} = $t;
#         $TEAM{$teamIDX}{REQ} = $r;
#         $TEAM{$teamIDX}{DRW} = $d;
#         $TEAM{$teamIDX}{IN_LATE} = $late;
#         $TEAM{$teamIDX}{SUB_TOTAL} = $total;
#         $TEAM{$teamIDX}{IN_TOTAL} = ($total - $late) * $TEAM{$teamIDX}{IN_FACTOR};
#     }
#     my $str;
#     $str = '<h1>'.$Class->getTxClass().' Class Final Technical Design Report Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">REQ</th>';
#     $str .= '<th style="text-align: right">DRW</th>';
#     $str .= '<th style="text-align: right">TDS</th>';
#     $str .= '<th style="text-align: right">Avg. Rpt</th>';
#     $str .= '<th style="text-align: right">Sub Total</th>';
#     $str .= '<th style="text-align: right">Late Report<br>Penalty</th>';
#     $str .= '<th style="text-align: right">Factor</th>';
#     $str .= '<th  style="text-align: right;">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="DesignhiddenRow" style="display: '.$display.';">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{REQ};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DRW};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{TDS};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{REPORT};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{SUB_TOTAL};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.2f</td>',$TEAM{$teamIDX}{IN_LATE};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.2f</td>',$TEAM{$teamIDX}{IN_FACTOR};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'DesignhiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getMicroPresoResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $mic = new SAE::MICRO();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($a, $s1, $s2, $s3, $d, $total) = $mic->getPresoScore($teamIDX, $classIDX);
#         $TEAM{$teamIDX}{PRESO} = $a;
#         $TEAM{$teamIDX}{1} = $s1;
#         $TEAM{$teamIDX}{2} = $s2;
#         $TEAM{$teamIDX}{3} = $s3;
#         $TEAM{$teamIDX}{DEMO} = $d;
#         $TEAM{$teamIDX}{IN_TOTAL} = $total;
#     }
#     my $str;
# #     $str .= "$classIDX,$eventIDX";
#     $str .= '<h1>'.$Class->getTxClass().' Class Final Technical Presentation Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 350px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right">Score #1</th>';
#     $str .= '<th style="text-align: right">Score #2</th>';
#     $str .= '<th style="text-align: right">Score #3</th>';
#     $str .= '<th style="text-align: right">Avg. Score</th>';
# #     $str .= '<th style="text-align: right">Demo</th>';/
#     $str .= '<th  style="text-align: right;">Total</th>';
#     $str .= '</tr>';
#     $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL} <=> $TEAM{$a}{IN_TOTAL}} keys %TEAM) {
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="PresohiddenRow" style="display: '.$display.';">';
#         }
#         $str .= '<td>'.$c++.'</td>';
#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{1};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{2};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{3};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{PRESO};
# #         $str .= sprintf '<td nowrap style="text-align: right">%2.1f</td>',$TEAM{$teamIDX}{DEMO};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'PresohiddenRow\');">expand/collapse</a>';
#     return ($str);
# }
# sub getMicroMissionResults(){
#     my $classIDX = shift;
#     my $eventIDX = shift;
#     my $inRound = shift;
#     my $display = shift;
#     my $dbi = new SAE::Db();
#     my $Event = new SAE::TB_EVENT();
#     my $Class = new SAE::TB_CLASS();
#     my $mic = new SAE::MICRO();
#     $Event->getRecordById($eventIDX);
#     $Class->getRecordById($classIDX);
#     my %TEAM = ();
#     my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
#         JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
#         WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     $select = $dbi->prepare($SQL);
#     $select->execute($eventIDX, $classIDX);
#     %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

#     foreach $teamIDX (sort keys %TEAM) {
#         my $max=0;
#         my $pf=0;
#         # my $adjusted=0;
#         my $flight = 0;
#         for (my $x=1; $x<=$inRound; $x++){
#             ($payload, $empty, $pf, $adjusted, $demo, $m, $d) = $mic->getTeamFlightScoreInRound($teamIDX, $x);
#             if ($adjusted > $max){$max = $adjusted}
#             $flight += $adjusted;
#             $TEAM{$teamIDX}{$x} = $adjusted;
#             if ($demo>0){$TEAM{$teamIDX}{DEMO} = $demo}
# #             $TEAM{$teamIDX}{DEMO} = $demo;
#         }
#         $TEAM{$teamIDX}{MAX}=$max;
#         if ($inRound==0){
#             $TEAM{$teamIDX}{IN_TOTAL} = 0;
#         } else {
#              $TEAM{$teamIDX}{IN_TOTAL} = (20 * (.5*($flight/$inRound) + .5*($max))) + $demo;
#         }
#     }
#     my $str;
#     $str = '<h1>'.$Class->getTxClass().' Class Round '.$inRound.' Mission Performance Results</h1>';
#     $str .= '<h3>'.$Event->getTxEventName().'</h3>';
#     $str .= '<table class="w3-table-all w3-tiny">';
#     $str .= '<tr>';
#     $str .= '<th style="width: 20px;">Pos.</th>';
#     $str .= '<th style="width: 20px;">#</th>';
#     $str .= '<th style="width: 250px;">University</th>';
#     $str .= '<th style="width: 175px;">Country</th>';
#     $str .= '<th style="text-align: right;">Demonstration</th>';
#     for ($x=1; $x<=$inRound; $x++){
#         $str .= '<th style="text-align: right;">Round '.$x.'</th>';
#     }

#     $str .= '<th style="text-align: right;">Max<br>Round<br>Score</th>';
#     $str .= '<th style="text-align: right;">Final<br>Flight<br>Score</th>';
#     $str .= '<th style="text-align: right;">Normalized<br>Flight<br>Score</th>';
#     $str .= '</tr>';
#     my $c=1;
#     foreach $teamIDX (sort {$TEAM{$b}{IN_TOTAL}<=>$TEAM{$a}{IN_TOTAL}} keys %TEAM ){
#         $total = $TEAM{$teamIDX}{IN_TOTAL};
#         $normal = $TEAM{$teamIDX}{NORMAL};
#         if ($total <0){$total = 0; $normal = 0;}
#         if ($c<4){
#             $str .= '<tr style="display: table-row;">';
#         } else {
#             $str .= '<tr class="micFlighthiddenRow" style="display: '.$display.';">';
#         }
#         if ($total > 0){
#             $str .= '<td>'.$c++.'</td>';
#         } else {
#             $str .= '<td>---</td>';
#         }

#         $str .= '<td>'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_SCHOOL}.'</td>';
#         $str .= '<td nowrap>'.$TEAM{$teamIDX}{TX_COUNTRY}.'</td>';
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{DEMO};
#         for ($x=1; $x<=$inRound; $x++){
#             $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{$x};
#         }
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{MAX};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',$TEAM{$teamIDX}{IN_TOTAL};
#         $str .= sprintf '<td nowrap style="text-align: right">%2.4f</td>',($TEAM{$teamIDX}{IN_TOTAL}/$mic_normal)*100;
#         $str .= '</tr>';
#     }
#     $str .= '</table>';
#     $str .= '<a class="w3-link w3-small w3-button" href="javascript:void(0)" onclick="expandTable(\'micFlighthiddenRow\');">expand/collapse</a>';
#     return ($str);
# }

# # ====================== 2018 ==============================
# sub __template(){
#     print $q->header();
#     my $str;
#     my $location = $q->param('location');


#     return ($str);
# }
# sub publishFinalResults(){
#     print $q->header();
#     my $str;
#     my $TxFile = $q->param('TxFile');
#     my $dbi = new SAE::Db();
#     my $SQL = "UPDATE TB_PUBLISH SET IN_SHOW=? where TX_FILE = ?";
# 	my $update = $dbi->prepare($SQL);
# 	   $update->execute(1, $TxFile);
#     return ($TxFile);
# }
# sub tabulateFinalScores(){
#     print $q->header();
#     my $str;
#     my $location = $q->param('location');
#     my $maxRound = $q->param('maxRound');
#     my $PkScoreEventIdx = 4;
#     my $Auth = new SAE::Auth();
#     my $Award = new SAE::TB_AWARD();
#     my $TxFile;
#     my $dbi = new SAE::Db();
#     %TITLE = %{$Award->getAllRecord()};
#     $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, FK_AWARD_IDX, TX_TITLE, TX_FILE, IN_ROUND, FK_SCORE_EVENT_IDX, IN_SHOW)
#         VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
#     my $insert = $dbi->prepare($SQL);
#     foreach $PkAwardIdx (sort keys %TITLE){
#         $TxFile = $Auth->getTemporaryPassword(48);
#         $TxTitle = 'Round '.$maxRound.': '.$TITLE{$PkAwardIdx}{TX_AWARD};
#         $FkClassIdx = $TITLE{$PkAwardIdx}{FK_CLASS_IDX};
#         $insert->execute($location, $FkClassIdx, $PkAwardIdx, $TxTitle, $TxFile, $maxRound, 4, 0);
# #         $str .= "$location, $TITLE{$TxTitle}, $TxTitle, $TxFile, $maxRound, 4, 0<hr>";
#         $str .= &_templateOverallBarItem($TxTitle, $TxFile);
#     }
# #     $str .= &_templateBarItem($PkClassIdx, $TxFile, $TxTitle, $InRound ,'Now', 0);
#     return ($str);
# }
# sub showFinalWithoutPublishing(){
#     print $q->header();
#     my $str;
#     my $location = $q->param('location');
#     $str = 'Hello World!!!';

#     return ($str);
# }
# sub deletePublishedReport(){
#     print $q->header();
#     my $str;
#     my $TxFile = $q->param('TxFile');
#     my $Report = new SAE::TB_PUBLISH();
#     $Report->deleteRecordBy_TxFile($TxFile);

#     return ($TxFile);
# }
# # sub showPublishedResults(){
# #     print $q->header();
# #     my $str;
# #     my $fileID = $q->param('fileID');
# #     my $str;
# #     my $dbi = new SAE::Db();
# #     my $SQL = "SELECT * FROM TB_PUBLISH WHERE TX_FILE=?";
# # 	my $select = $dbi->prepare($SQL);
# # 	   $select->execute($fileID);
# # 	my %HASH = %{$select->fetchrow_hashref()};
# # # 	foreach $field (sort keys %HASH){
# # # 	    $str .= $field." = ".$HASH{$field}."<br>";
# # # 	}
# # #     $str .= $fileID."<br>";
# #     my $Tab = new SAE::Tabulate();
# #     if ($HASH{FK_SCORE_EVENT_IDX} == 1){
# #         $str .= $Tab->getDesigntResults($HASH{FK_CLASS_IDX},$HASH{FK_EVENT_IDX});
# #     } elsif ($HASH{FK_SCORE_EVENT_IDX} == 2) {
# #         $str .= $Tab->getPresentationResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX});
# #     } elsif ($HASH{FK_SCORE_EVENT_IDX} == 3) {
# #         if ($HASH{FK_CLASS_IDX}==1){
# #             $str .= $Tab->getRegularFlightResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         } elsif ($HASH{FK_CLASS_IDX}==2) {
# #             $str .= $Tab->getAdvancedFlightResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         } elsif ($HASH{FK_CLASS_IDX}==3) {
# #             $str .= $Tab->getMicroFlightResults( $HASH{FK_CLASS_IDX}, $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         }
# #     } elsif ($HASH{FK_SCORE_EVENT_IDX} == 4){
# #         if ($HASH{FK_AWARD_IDX}==1){
# #             $str .= $Tab->getOverallScore( $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND}, $HASH{FK_CLASS_IDX});
# #         } elsif ($HASH{FK_AWARD_IDX}==2) {
# #             $str .= $Tab->getOverallScore( $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND}, $HASH{FK_CLASS_IDX});
# #         } elsif ($HASH{FK_AWARD_IDX}==3) {
# #             $str .= $Tab->getOverallScore( $HASH{FK_EVENT_IDX}, $HASH{IN_ROUND}, $HASH{FK_CLASS_IDX});
# #         } elsif ($HASH{FK_AWARD_IDX}==4) {
# #             $str .= $Tab->getRegularMostPayloadLifted($HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         } elsif ($HASH{FK_AWARD_IDX}==5) {
# #             $str .= $Tab->getHotAward($HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         } elsif ($HASH{FK_AWARD_IDX}==6) {
# #             $str .= $Tab->getMicroMostPayloadLifted($HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         } elsif ($HASH{FK_AWARD_IDX}==7) {
# #             $str .= $Tab->getMicroPayloadFraction($HASH{FK_EVENT_IDX}, $HASH{IN_ROUND});
# #         }
# #
# #     }
# #     return ($str);
# # }
# sub publishResults(){
#     print $q->header();
#     my $str;
#     my $location = $q->param('location');
#     my $PkClassIdx = $q->param('PkClassIdx');
#     my $InRound = $q->param('InRound');
#     my $TxTitle = $q->param('TxTitle');
#     my $PkScoreEventIdx = $q->param('PkScoreEventIdx');
#     my $Auth = new SAE::Auth();
#     my $TxFile = $Auth->getTemporaryPassword(48);
#     my $dbi = new SAE::Db();

#     $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, TX_FILE, IN_ROUND, FK_SCORE_EVENT_IDX)
#         VALUES (?, ?, ?, ?, ?, ?)";
#     my $insert = $dbi->prepare($SQL);
#     $insert->execute($location, $PkClassIdx, $TxTitle, $TxFile, $InRound, $PkScoreEventIdx);
#     if ($PkScoreEventIdx==3){
#         $TxTitle = 'ROUND '.$InRound.' - '.$TxTitle;
#     }
#     $str .= &_templateBarItem($PkClassIdx, $TxFile, $TxTitle, $InRound ,'Now');
#     return ($str);
# }
# sub _templateBarItem(){
#     my ($PkClassIdx, $TxFile, $TxTitle, $InRound, $TsCreate) = @_;
#     my $str;
#     $str = '<li ID="RESULT_ITEM_'.$TxFile.'" class="w3-bar" >';
#     $str .= '<span class="w3-button w3-bar-item w3-left" onclick="deletePublishedReport('.$PkClassIdx.', \''.$TxFile.'\','.$InRound.');">&times;</span>';
#     $str .= '<a class="w3-bar-item "href="result.html?fileID='.$TxFile.'" target="_blank">'.$TxTitle.' ( '.$TsCreate.' )</a>';
#     $str .= '</li>';
#     return ($str);
# }
# sub _templateOverallBarItem(){
#     my ($TxTitle, $TxFile, $InShow) = @_;
#     my $str;
#     $str .= '<li ID="RESULT_ITEM_'.$TxFile.'" class="w3-display-container">';
#     $str .= '<a class="w3-button fa fa-search w3-xlarge w3-border" href="result.html?fileID='.$TxFile.'" target="_blank"></a>&nbsp;';

#     if ($InShow==0){
#         $str .= '<span ID="BTN_PUBLISH_'.$TxFile.'" class="w3-button fa fa-external-link w3-xlarge w3-border" onclick="publishFinalResults(\''.$TxFile.'\',\''.$TxTitle.'\');"></span>&nbsp;';
#     }
#     $str .= $TxTitle;
#     $str .= '<span class="w3-button fa fa-remove w3-xlarge w3-right" onclick="deletePublishedReport(0,\''.$TxFile.'\',0);"></span>&nbsp;';
#     $str .= '</li>';
#     return ($str);
# }
# # ================ OVERALL =============================================
# sub openOverall(){
#     print $q->header();
#     my $location = $q->param('location');
#     my $Class = new SAE::TB_CLASS();
#     my %CLASS = %{$Class->getAllRecord()};

#     my $dbi = new SAE::Db();

#     my $SQL = "SELECT MAX(IN_ROUND) AS MAX_ROUND FROM TB_SCORE AS SCORE
#         JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#         WHERE TEAM.FK_EVENT_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($location);
#     my $MaxRound = $select->fetchrow_array();

#     $SQL = "SELECT TX_TITLE, TX_FILE, IN_SHOW FROM `TB_PUBLISH` where FK_EVENT_IDX=? AND FK_SCORE_EVENT_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($location, 4);
#     %FINAL = %{$select->fetchall_hashref(['TX_FILE'])};

#     my $str;
#     $str .= '<div class="w3-container w3-white">';
#     $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="showResultsMain();">&nbsp;Back</a>';
#     $str .= '</div>';
#     $str .= '<h2>Overall Results</h2>';
# #     $str .= '<p>';

# 	$str .= '<form class="w3-container w3-card-4 w3-round-large" >';
# 	$str .= '<h4>Select Round To Tabulate Final Score</h4>';
# 	$str .= '<div class="w3-bar ">';
# 	for ($i=1; $i<=10; $i++){
# 	    if ($i == $MaxRound){
# 	        $str .= '<p class="w3-bar-item"><input class="w3-radio" type="radio" ID="ITEM_'.$i.'" value="'.$i.'" name="IN_MAX_ROUND" checked>&nbsp;';
# 	        $str .= '<label for="ITEM_'.$i.'" >Round '.$i.'</label></p>';
# 	    } else {
# # 	        $str .= '<label>Round '.$i.'</label>';
# 	        $str .= '<p class="w3-bar-item"><input class="w3-radio" ID="ITEM_'.$i.'" type="radio" value="'.$i.'" name="IN_MAX_ROUND">&nbsp;';
# 	        $str .= '<label for="ITEM_'.$i.'" >Round '.$i.'</label></p>';
# 	    }
# 	}
# 	$str .= '</div>';
# 	$str .= '<span class="w3-button w3-border w3-round w3-hover-shadow w3-green" onclick="tabulateFinalScores();">Tabulate Scores</span><br><br>';
# 	$str .= '</form><hr>';
#     $str .= '<div class="w3-container w3-padding w3-card w3-round" style="min-height: 300px;">';
#     $str .= '<p>The following results are not visible by the students until you click on the publish icon <span class="fa fa-external-link w3-medium "></span>.</p>';
#     $str .= '<ul ID="LIST_OF_RESULTS" class="w3-ul w3-card-2 ">';
#     foreach $TxFile (sort {$FINAL{$a}{TX_TITLE} cmp $FINAL{$b}{TX_TITLE}} keys %FINAL) {
#         $str .= &_templateOverallBarItem($FINAL{$TxFile}{TX_TITLE}, $TxFile, $FINAL{$TxFile}{IN_SHOW});
#     }
#     $str .= '</ul>';
#     $str .= '</div>';
#     return ($str);
# }
# # ================ DESIGN ==============================================
# sub openDesignResults(){
#     print $q->header();
#     my $location = $q->param('location');
#     my $Class = new SAE::TB_CLASS();
#     my %CLASS = %{$Class->getAllRecord()};
#     my $dbi = new SAE::Db();

#     my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, FK_SCORE_EVENT_IDX, TX_FILE, IN_ROUND, DATE_FORMAT(TS_CREATE, '%m/%d/%Y %h:%i:%s') AS TS_DATE FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND FK_SCORE_EVENT_IDX=?)";
# 	my $select = $dbi->prepare($SQL);
# 	   $select->execute($location, 1);
# 	my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_PUBLISH_IDX'])};

#     my $str;
#     $str .= '<div class="w3-container w3-white">';
#     $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="showResultsMain();">&nbsp;Back</a>';
#     $str .= '</div>';
#     $str .= '<ul class="w3-ul" style="padding-bottom: 10em;">';
#     foreach $PkClassIdx (sort {$a <=> $b} keys %CLASS) {
#         $str .= '<li class="w3-bar-item w3-border-bottom">';
#             $str .= '<h2 ID="TeamExpand_'.$PkClassIdx.'" class="w3-button"  onclick="expandDetails('.$PkClassIdx.');">&nbsp;'.$CLASS{$PkClassIdx}{TX_CLASS}.' Class Design Report Results</h2>';
#             $str .= '<div class="w3-padding w3-panel w3-card w3-hide" ID="RESULTS_'.$PkClassIdx.'">';
#             $str .= '<h3 class="w3-bar-item">Published Results</h3>';
#             $str .= '<ul class="w3-container w3-ul"  ID="RESULT_ITEM_'.$PkClassIdx.'">';
#             foreach $PkPublishIdx (sort {$a<=>$b} keys %{$HASH{$PkClassIdx}}) {
#                 $BTN{$PkClassIdx}{0}{CLASS} = 'w3-green';
#                 $str .= &_templateBarItem($PkClassIdx, $HASH{$PkClassIdx}{$PkPublishIdx}{TX_FILE}, $HASH{$PkClassIdx}{$PkPublishIdx}{TX_TITLE}, 0, $HASH{$PkClassIdx}{$PkPublishIdx}{TS_DATE});
#             }
#             $str .= '</ul>';
#             $str .= '<div class="w3-container">';
#             $str .= '<a ID="BTN_'.$PkClassIdx.'_0" class="w3-button w3-border '.$BTN{$PkClassIdx}{0}{CLASS}.'" href="javascript:void(0);" onclick="publishResults(0, '.$PkClassIdx.', \'Design Results\', 1)">Publish</a>';
#             $str .= '</div>';

#         $str .= '</li>';
#     }
#     $str .= '</ul>';
#     return ($str);
# }
# # ================ PRESO ==============================================
# sub openPresoResults(){
#     print $q->header();
#     my $location = $q->param('location');
#     my $Class = new SAE::TB_CLASS();
#     my %CLASS = %{$Class->getAllRecord()};
#     my $dbi = new SAE::Db();
#     my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, FK_SCORE_EVENT_IDX, TX_FILE, IN_ROUND, DATE_FORMAT(TS_CREATE, '%m/%d/%Y %h:%i:%s') AS TS_DATE FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND FK_SCORE_EVENT_IDX=?)";
# 	my $select = $dbi->prepare($SQL);
# 	   $select->execute($location, 2);
# 	my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_PUBLISH_IDX'])};

#     my $str;
#     my $location = $q->param('location');
#     $str .= '<div class="w3-container w3-white">';
#     $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="showResultsMain();">&nbsp;Back</a>';
#     $str .= '</div>';
#         $str .= '<ul class="w3-ul" style="padding-bottom: 10em;">';
#     foreach $PkClassIdx (sort {$a <=> $b} keys %CLASS) {
#         $str .= '<li class="w3-bar-item w3-border-bottom">';
#             $str .= '<h2 ID="TeamExpand_'.$PkClassIdx.'" class="w3-button"  onclick="expandDetails('.$PkClassIdx.');">&nbsp;'.$CLASS{$PkClassIdx}{TX_CLASS}.' Class Technical Presentation Results</h2>';
#             $str .= '<div class="w3-padding w3-panel w3-card w3-hide" ID="RESULTS_'.$PkClassIdx.'">';
#             $str .= '<h3 class="w3-bar-item">Published Results</h3>';
#             $str .= '<ul class="w3-container w3-ul" ID="RESULT_ITEM_'.$PkClassIdx.'" >';
#             foreach $PkPublishIdx (sort {$a<=>$b} keys %{$HASH{$PkClassIdx}}) {
#                 $BTN{$PkClassIdx}{0}{CLASS} = 'w3-green';
# #                 $BTN{$PkClassIdx}{$InRound}{ID} = 'BTN_'.$PkClassIdx.'_'.$InRound;
#                 $str .= &_templateBarItem($PkClassIdx, $HASH{$PkClassIdx}{$PkPublishIdx}{TX_FILE}, $HASH{$PkClassIdx}{$PkPublishIdx}{TX_TITLE}, 0, $HASH{$PkClassIdx}{$PkPublishIdx}{TS_DATE});
#             }
#             $str .= '</ul>';
#             $str .= '<div class="w3-container">';
#             $str .= '<a ID="BTN_'.$PkClassIdx.'_0" class="w3-button w3-border '.$BTN{$PkClassIdx}{0}{CLASS}.'" href="javascript:void(0);" onclick="publishResults(0, '.$PkClassIdx.', \'Presentation Results\', 2)">Publish</a>';
#             $str .= '</div>';

#         $str .= '</li>';
#     }
#     $str .= '</ul>';
#     return ($str);
# }
# # ================ FLIGHTS ==============================================
# sub openFlightResults(){
#     print $q->header();
#     my $str;
#     my $location = $q->param('location');
#     my $Class = new SAE::TB_CLASS();
#     my %CLASS = %{$Class->getAllRecord()};
#     my $dbi = new SAE::Db();

#     my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, FK_SCORE_EVENT_IDX, TX_FILE, IN_ROUND, DATE_FORMAT(TS_CREATE, '%m/%d/%Y %h:%i:%s') AS TS_DATE
#             FROM TB_PUBLISH
#             WHERE (FK_EVENT_IDX=? AND FK_SCORE_EVENT_IDX=?)";
# 	my $select = $dbi->prepare($SQL);
# 	   $select->execute($location, 3);
# 	my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_PUBLISH_IDX'])};

#     $str .= '<div class="w3-container w3-white">';
#     $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="showResultsMain();">&nbsp;Back</a>';
#     $str .= '</div>';
#     $str .= '<ul class="w3-ul" style="padding-bottom: 10em;">';
#     foreach $PkClassIdx (sort {$a <=> $b} keys %CLASS) {
#         $str .= '<li class="w3-bar-item w3-border-bottom">';
#             $str .= '<h2 ID="TeamExpand_'.$PkClassIdx.'" class="w3-button"  onclick="expandDetails('.$PkClassIdx.');">&nbsp;'.$CLASS{$PkClassIdx}{TX_CLASS}.' Class Flight Results</h2>';
#             $str .= '<div class="w3-padding w3-panel w3-card w3-hide" ID="RESULTS_'.$PkClassIdx.'">';
#             $str .= '<h3 class="w3-bar-item">Published Results</h3>';
#             $str .= '<ul class="w3-container w3-ul" ID="RESULT_ITEM_'.$PkClassIdx.'" >';
#             foreach $PkPublishIdx (sort {$HASH{$PkClassIdx}{$a}{IN_ROUND} <=> $HASH{$PkClassIdx}{$b}{IN_ROUND}} keys %{$HASH{$PkClassIdx}}) {
#                 $InRound = $HASH{$PkClassIdx}{$PkPublishIdx}{IN_ROUND};
#                 $BTN{$PkClassIdx}{$InRound}{CLASS} = 'w3-green';
#                 $BTN{$PkClassIdx}{$InRound}{ID} = 'BTN_'.$PkClassIdx.'_'.$InRound;
#                 my $TxTitle = 'ROUND '.$HASH{$PkClassIdx}{$PkPublishIdx}{IN_ROUND}.' - '.$HASH{$PkClassIdx}{$PkPublishIdx}{TX_TITLE};
#                 my $TxFile = $HASH{$PkClassIdx}{$PkPublishIdx}{TX_FILE};
#                 my $TsDate = $HASH{$PkClassIdx}{$PkPublishIdx}{TS_DATE};
#                 $str .= &_templateBarItem($PkClassIdx, $TxFile, $TxTitle, $InRound, $TsDate);
#             }
#             $str .= '</ul>';
#             $str .= '<div class="w3-container">';
#             $str .= '<label>Publish</label><br>';
#             for ($x=1; $x<=10; $x++){
#                 $str .= '<a ID="BTN_'.$PkClassIdx.'_'.$x.'" class="w3-button w3-border '.$BTN{$PkClassIdx}{$x}{CLASS}.'" href="javascript:void(0);" onclick="publishResults('.$x.', '.$PkClassIdx.', \'Flight Results\', 3)">Round '.$x.'</a> ';
#             }
#             $str .= '</div>';

#         $str .= '</li>';
#     }
#     $str .= '</ul>';

#     return ($str);
# }
# # ================ MAIN =============================================
# sub showResultsMain_2018(){ # Loading functions from team.js
#     print $q->header();
#     my $str;
#     $str .= '<div class="w3-container">';
#     $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadMainPage();">&nbsp;Back</a>';
#     $str .= '</div>';
#     $str .= &_tiles('Design Results',           'fa fa-line-chart',     'openDesignResults();' ); # call in preso.js
#     $str .= &_tiles('Presentation Results',     'fa fa-pie-chart',      'openPresoResults();' );
#     $str .= &_tiles('Flight Results',           'fa fa-bar-chart',      'openFlightResults();' );
#     $str .= &_tiles('Overall Results',          'fa fa-trophy',         'openOverall();' );

#     return ($str);
# }

# sub _tiles(){
#     my ($label, $image, $click) = @_;
#     my $str;
#     $str .= '<div class="w3-third w3-center">';
#     $str .= '<div class="w3-card w3-container" style="min-height:260px; margin-top: 1.0em;">';
#     $str .= '<h3>'.$label.'</h3><br>';
#     $str .= '<a onclick="'.$click.'" href="javascript:void(0);" class="'.$image.' w3-margin-bottom w3-text-theme" style="font-size:110px; text-decoration: none;"></a>';
#     $str .= '</div>';
#     $str .= '</div>';
#     return ($str);
# }

