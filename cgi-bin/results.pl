#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;  
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Cwd 'abs_path';
use SAE::SCORE;

my $q = new CGI;
my $qs = new CGI($ENV{'QUERY_STRING'});

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
sub sae_viewPublishedResults(){
    print $q->header(); 
    my $eventIDX = $q->param('eventIDX');
    my $classIDX = $q->param('classIDX');
    my $Scores = new SAE::SCORE();
    my %RESULTS = %{$Scores->_getListOfPublishedResults($eventIDX)};
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    print $q->header(); 
    my $str;
    $str .= '<div class="w3-container w3-margin-top"><br>';
    # $str .= '<h3><i class="fa fa-users f2-2x" aria-hidden="true"></i>&nbsp;Users</h3>';
    # $str .= '<div class="w3-container w3-white"><br><br>';
    $str .= '<h3>&nbsp;Results</h3>';
    foreach $txTitle (sort keys %RESULTS) {
        
        foreach $classIDX (sort keys %{$RESULTS{$txTitle}}) {
            $str .= '<div class="w3-panel w3-border w3-round w3-white w3-card">';
            $str .= sprintf '<h3>%s: <span class="w3-blue w3-padding-left w3-padding-right"> %s </span></h3>', $txTitle, $CLASS{$classIDX};
            $str .= '<table class="w3-table w3-bordered">';
            $str .= '<tr class="w3-light-grey">';
            # $str .= '<th style="width: 15%;">Class</th>';
            $str .= '<th style="width: 15%;">Version</th>';
            $str .= '<th style="width: 25%;">Date/Time Generated</th>';
            $str .= '<th>Link</th>';
            $str .= '</tr>';
            foreach $publishIDX (sort keys %{$RESULTS{$txTitle}{$classIDX}}) {
                $str .= '<tr>';
                # $str .= sprintf '<td class="w3-left-align">%s</td>', $CLASS{$classIDX} ;
                $str .= sprintf '<td class="w3-left-align">v.%d</td>', $publishIDX;
                $str .= sprintf '<td class="w3-left-align">%s</td>', $RESULTS{$txTitle}{$classIDX}{$publishIDX}{TX_TIME};
                $str .= sprintf '<td class="w3-left-align"><a href="post.html?fileID=%s" target="_blank">View</a></td>', $RESULTS{$txTitle}{$classIDX}{$publishIDX}{TX_FILE};
                $str .= '</tr>';
            }
            $str .= '</table><br>';
            $str .= '</div>';
        }
        
    }

    $str .= '</div>';
    return ($str);
}
sub results_openResultStandings(){
    my $location = $q->param('location');
    my $classIDX = $q->param('classIDX');
    my $Scores = new SAE::SCORE();
    my %LIST = %{$Scores->_getPublishedListByClass($location, $classIDX)};
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    print $q->header(); 
    my $str;
    $str .= '<div class="w3-container">';
    $str .= sprintf '<h3>%s</h3>', $CLASS{$classIDX};
    $str .= '<ul class="w3-ul">';
    foreach $publishIDX (sort {$a<=>$b} keys %LIST) {
        $str .= '<li class="w3-bar w3-margin-bottom w3-border w3-round w3-card-2">';
        # $str .= '<span onclick="this.parentElement.style.display=\'none\'" class="w3-bar-item w3-button w3-xlarge w3-right">&times;</span>';
        # $str .= '<img src="img_avatar2.png" class="w3-bar-item w3-circle" style="width:85px">';
        $str .= '<i class="fa fa-trophy w3-bar-item fa-2x" aria-hidden="true"></i>';
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<span class="w3-large"><a href="post.html?fileID=%s" target="_blank">%s</a></span><br>', $LIST{$publishIDX}{TX_FILE}, $LIST{$publishIDX}{TX_TITLE};
        $str .= sprintf '<span>Generated on %s ( <i>v.%d</i> )</span>', $LIST{$publishIDX}{TX_TIME}, $publishIDX;
        # if ($LIST{$publishIDX}{FK_TILES_IDX} == 17) {
        #     $str .= sprintf '<span>Round %d</span>', $LIST{$publishIDX}{IN_ROUND};
        # }
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
}
sub sae_openResultStandings(){
    my $location = $q->param('location');
    my $classIDX = $q->param('classIDX');
    my $Scores = new SAE::SCORE();
    my %LIST = %{$Scores->_getPublishedListByClass($location, $classIDX)};
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    print $q->header(); 
    my $str;
    $str .= '<div class="w3-container">';
    $str .= sprintf '<h3>%s</h3>', $CLASS{$classIDX};
    $str .= '<ul class="w3-ul">';
    foreach $publishIDX (sort {$a<=>$b} keys %LIST) {
        $str .= '<li class="w3-bar w3-margin-bottom w3-border w3-round w3-card-2">';
        # $str .= '<span onclick="this.parentElement.style.display=\'none\'" class="w3-bar-item w3-button w3-xlarge w3-right">&times;</span>';
        # $str .= '<img src="img_avatar2.png" class="w3-bar-item w3-circle" style="width:85px">';
        $str .= '<i class="fa fa-trophy w3-bar-item fa-2x" aria-hidden="true"></i>';
        $str .= '<div class="w3-bar-item">';
        $str .= sprintf '<span class="w3-large"><a href="post.html?fileID=%s" target="_blank">%s</a></span><br>', $LIST{$publishIDX}{TX_FILE}, $LIST{$publishIDX}{TX_TITLE};
        $str .= sprintf '<span>Generated on %s ( <i>v.%d</i> )</span>', $LIST{$publishIDX}{TX_TIME}, $publishIDX;
        # if ($LIST{$publishIDX}{FK_TILES_IDX} == 17) {
        #     $str .= sprintf '<span>Round %d</span>', $LIST{$publishIDX}{IN_ROUND};
        # }
        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
}


sub sae_updateResultAttribute(){
    print $q->header();
    my $publishIDX = $q->param('publishIDX');
    my $value= $q->param('value');
    my $field = $q->param('field');
    my $Scores = new SAE::SCORE();
    $Scores->_updateResultAttribute($field, $value, $publishIDX);
    return;
}
sub sae_deleteResults(){
    print $q->header();
    my $publishIDX = $q->param('publishIDX');
    my $Scores = new SAE::SCORE();
    $Scores->_deletePublishedScoreID($publishIDX);
    return;
}
sub sae_generateResults(){
    print $q->header();
    my $resultClass = $q->param('resultClass');
    my $resultType = $q->param('resultType');
    my $location = $q->param('location');
    my $resultRound = $q->param('resultRound');
    my $Scores = new SAE::SCORE();
    my ($txCode, $publishIDX, $txTitle) = $Scores->_publishRound($resultClass, $resultRound, $resultType, $location);
    my $str = &sae_templateResultItems($txTitle, $txCode, $publishIDX, $resultClass, $resultRound,0,1);
    return ($str);
}
sub sae_templateResultItems(){
    my ($txTitle, $txCode, $publishIDX, $classIDX, $inRound, $inShow, $boScore) = @_;
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    my $txLinkTitle = $txTitle;
    my $show='';
    my $score='';
    if ($inRound>0){$txLinkTitle = sprintf 'Round %d: %s', $inRound, $txTitle} 
    if ($inShow>0) {$show = 'checked'}
    if ($boScore>0) {$score = 'checked'}
    my $str;
    $str .= sprintf '<tr ID="TR_RESULT_%d" class="w3-hover-pale-yellow">', $publishIDX;
    $str .= sprintf '<td style="width: 25%;"><a  href="post.html?fileID='.$txCode.'" target="_blank">%s</a></td>', $txLinkTitle;
    $str .= sprintf '<td style="width: 25%;">%s</td>', $CLASS{$classIDX};
    # $str .= sprintf '<td style="width: 25%;">%s</td>', $CLASS{$classIDX};
    $str .= sprintf '<td style="width: 10%;"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateResultAttribute(this, \'%s\', %d);" %s></td>','IN_SHOW',$publishIDX, $show;
    $str .= sprintf '<td style="width: 10%;"><input class="w3-check" type="checkbox" value="1" onclick="sae_updateResultAttribute(this, \'%s\', %d);" %s></td>','BO_SCORE',$publishIDX, $score;
    # $str .= sprintf '<td style="width: 10%;"><input class="w3-check" type="checkbox" value="1"></td>';
    $str .= sprintf '<td style="text-align: right;">';
    $str .= sprintf '<button class="w3-button w3-round w3-border w3-orange w3-hover-red" onclick="sae_deleteResults(%d);">&times; Delete</button>', $publishIDX;
    $str .= '</td>';
    $str .= '</tr>';
    return ($str);
}
sub sae_openCreateResults(){
    print $q->header();
    my $location = $q->param('location');
    my %TYPE = (14=>"1 - Design Results", 15=>"2 - Presentation Results",17=>"3 - Flight Results", 10=>"4 - Overall Results");
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    my $str;
    $str .= '<div class="sae-form w3-container">';
    $str .= '<label>Select Class</label>';
    $str .= '<select id="resultClass" class="w3-select w3-border w3-round w3-padding">';
    $str .= sprintf '<option value="%s" disabled selected>%s</option>', '-', '- Class - ';
    foreach $classIDX (sort keys %CLASS) {
        $str .= sprintf '<option value="%s" class="">%s</option>', $classIDX, $CLASS{$classIDX};
    }
    $str .= '</select>';
    # $str .= '<hr>';
    $str .= '<label>Select Result Type</label>';
    $str .= '<select id="resultType"class="w3-select w3-border w3-round w3-padding" onchange="sae_changeResultType(this.value);">';
    $str .= sprintf '<option value="%s" disabled selected>%s</option>', '-', '- Type - ';
    foreach $type (sort {$TYPE{$a} cmp $TYPE{$b}} keys %TYPE) {
        $str .= sprintf '<option value="%s" class="">%s</option>', $type, $TYPE{$type};
    }
    $str .= '</select>';
    
    # $str .= '<div id="roundSelection">';
    $str .= '<label class="sae-roundSelection w3-hide">Select Result Type</label>';
    $str .= '<select id="resultRound"class="w3-select w3-border w3-round w3-padding sae-roundSelection w3-hide">';
    $str .= sprintf '<option value="%d" disabled selected>%s</option>', '0', '- Round - ';
    for (my $round=1; $round<=20; $round++){
        $str .= sprintf '<option value="%d" class="">Round %d</option>', $round, $round;
    }
    $str .= '</select>';
    $str .= '<br>'x2;
    $str .= '<button class="w3-button w3-round w3-border w3-green w3-hover-blue" onclick="sae_generateResults(this);">Generate</button>';
    $str .= '<br>'x3;
    # $str .= '</div>';
    $str .= '</div>';
    return ($str);
}

sub showPublishPage(){
    my $location = $q->param('location');
    print $q->header();
    my $Scores = new SAE::SCORE();
    my %LIST = %{$Scores->_getGeneratedResultsList($location)};
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    my $str;
    $str .= '<div class="w3-container w3-margin-top"">';
    $str .= '<h3  style="margin-top: 50px!important;><i class="fa fa-trophy" aria-hidden="true"></i> Publish Results</h3>';
    $str .= sprintf '<button class="w3-button w3-border w3-card w3-round" onclick="sae_openCreateResults();"><i class="fa fa-plus" aria-hidden="true"></i> Publish</button>';
    foreach $classIDX (sort {$a <=> $b} keys %LIST) {
        $str .= '<br>'x2;
        $str .= sprintf '<h3>%s</h3>',$CLASS{$classIDX};
        $str .= sprintf '<table ID="TABLE_RESULTS_%d" class="w3-table-all w3-hoverable w3-white w3-round">', $classIDX;
        $str .= '<thead>';
        $str .= '<tr style="border-bottom: 3px solid #000;">';
        $str .= '<th>Title</th>';
        $str .= '<th>Class</th>';
        $str .= '<th>Make<br>Public</th>';
        $str .= '<th>Include<br>Score</th>';
        $str .= '<th>&nbsp;</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $publishIDX (sort {$b <=> $a} keys %{$LIST{$classIDX}}) {
            $str .= &sae_templateResultItems($LIST{$classIDX}{$publishIDX}{TX_TITLE}, $LIST{$classIDX}{$publishIDX}{TX_FILE}, $publishIDX, $LIST{$classIDX}{$publishIDX}{FK_CLASS_IDX}, $LIST{$classIDX}{$publishIDX}{IN_ROUND},$LIST{$classIDX}{$publishIDX}{IN_SHOW},$LIST{$classIDX}{$publishIDX}{BO_SCORE});
        }
        $str .= '</tbody>';
        $str .= '</table>';
    }
    
    
    
    
    # $str .= '<br>'x2;
    # $str .= '<table ID="TABLE_RESULTS_1" class="w3-table-all w3-hoverable w3-white">';
    # $str .= '<thead>';
    # $str .= '<tr style="border-bottom: 3px solid #000;">';
    # $str .= '<th>Title</th>';
    # $str .= '<th>Class</th>';
    # $str .= '<th>Make<br>Public</th>';
    # $str .= '<th>Include<br>Score</th>';
    # $str .= '<th>&nbsp;</th>';
    # $str .= '</tr>';
    # $str .= '</thead>';
    # $str .= '<tbody>';
    # foreach $publishIDX (sort {$b<=>$a} keys %LIST) {
    #     $str .= &sae_templateResultItems($LIST{$publishIDX}{TX_TITLE}, $LIST{$publishIDX}{TX_FILE}, $publishIDX, $LIST{$publishIDX}{FK_CLASS_IDX}, $LIST{$publishIDX}{IN_ROUND},$LIST{$publishIDX}{IN_SHOW},$LIST{$publishIDX}{BO_SCORE});
    # }
    # $str .= '</tbody>';
    # $str .= '</table>';
    
    # $str .= '<br>'x2;
    # $str .= '<table ID="TABLE_RESULTS_2" class="w3-table-all w3-hoverable w3-white">';
    # $str .= '<thead>';
    # $str .= '<tr style="border-bottom: 3px solid #000;">';
    # $str .= '<th>Title</th>';
    # $str .= '<th>Class</th>';
    # # $str .= '<th>Round</th>';
    # $str .= '<th>Make<br>Public</th>';
    # $str .= '<th>Include<br>Score</th>';
    # $str .= '<th>&nbsp;</th>';
    # $str .= '</tr>';
    # $str .= '</thead>';
    # $str .= '<tbody>';
    # foreach $publishIDX (sort {$b<=>$a} keys %LIST) {
    #     $str .= &sae_templateResultItems($LIST{$publishIDX}{TX_TITLE}, $LIST{$publishIDX}{TX_FILE}, $publishIDX, $LIST{$publishIDX}{FK_CLASS_IDX}, $LIST{$publishIDX}{IN_ROUND},$LIST{$publishIDX}{IN_SHOW},$LIST{$publishIDX}{BO_SCORE});
    # }
    # $str .= '</tbody>';
    # $str .= '</table>';
    
    # $str .= '<br>'x2;
    # $str .= '<table ID="TABLE_RESULTS_3" class="w3-table-all w3-hoverable w3-white">';
    # $str .= '<thead>';
    # $str .= '<tr style="border-bottom: 3px solid #000;">';
    # $str .= '<th>Title</th>';
    # $str .= '<th>Class</th>';
    # # $str .= '<th>Round</th>';
    # $str .= '<th>Make<br>Public</th>';
    # $str .= '<th>Include<br>Score</th>';
    # $str .= '<th>&nbsp;</th>';
    # $str .= '</tr>';
    # $str .= '</thead>';
    # $str .= '<tbody>';
    # foreach $publishIDX (sort {$b<=>$a} keys %LIST) {
    #     $str .= &sae_templateResultItems($LIST{$publishIDX}{TX_TITLE}, $LIST{$publishIDX}{TX_FILE}, $publishIDX, $LIST{$publishIDX}{FK_CLASS_IDX}, $LIST{$publishIDX}{IN_ROUND},$LIST{$publishIDX}{IN_SHOW},$LIST{$publishIDX}{BO_SCORE});
    # }
    # $str .= '</tbody>';
    # $str .= '</table>';
    $str .= '</div>';
    
    
    
    
#     my $str = '<br>';
#     $str .= '<div class="w3-container w3-margin-top" style="margin-top: 40px;">';
#     $str .= "<h3>Publish Results</h3>";
#     $str .= '<table class="w3-table-all w3-white">';
#     $str .= '<tr class="w3-hide-small">';
#     $str .= '<th style="width: 25%;">Class</th>';
#     $str .= '<th style="width: 25%;">Regular Class</th>';
#     $str .= '<th style="width: 25%;">Advanced Class</th>';
#     $str .= '<th style="width: 25%;">Micro Class</th>';
#     $str .= '</tr>';
#     $str .= '<tr class="w3-hide-small">';
#     $str .= '<td>Design Results</td>';
#     # my $str = &_templateResultCards($txFile);
#     for (my $i=1; $i<=3; $i++){
#         $str .= '<td>';
#         my $inType=14;
#         if ( $LIST{0}{$inType}{$i} ){
#             my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
#             my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
#             my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
#             my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
#             my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
#             $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow );
#         } else {
#             $str .= &_templateAddResultCard($i,$inType,0)
#         }
#         $str .= '</td>';
#     }
#     $str .= '</tr>';
# #===== Responsive DESIGN==========
#     $str .= '<tr class="w3-hide-medium w3-hide-large">';
#     $str .= '<td>Design Results</td>';
#     $str .= '</tr>';
#     for (my $i=1; $i<=3; $i++){
#         $str .= '<tr class="w3-hide-medium w3-hide-large">';
#         $str .= '<td>';
#         my $inType=14;
#         if ( $LIST{0}{$inType}{$i} ){
#             my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
#             my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
#             my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
#             my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
#             my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
#             $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow );
#         } else {
#             $str .= &_templateAddResultCard($i,$inType,0)
#         }
#         $str .= '</td>';
#         $str .= '</tr>';
#     }

#     $str .= '<tr class="w3-hide-small">';
#     $str .= '<td>Presentation Results</td>';
#     for (my $i=1; $i<=3; $i++){
#         $str .= '<td>';
#         my $inType=15;
#         if ( $LIST{0}{$inType}{$i} ){
#             my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
#             my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
#             my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
#             my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
#             my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
#             $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow  );
#         } else {
#             $str .= &_templateAddResultCard($i,$inType,0)
#         }
#         $str .= '</td>';
#     }
#     $str .= '</tr>';
# #===== Responsive Presentation ==========
#     $str .= '<tr class="w3-hide-medium w3-hide-large">';
#     $str .= '<td>Presentation Results</td>';
#     $str .= '</tr>';
#     for (my $i=1; $i<=3; $i++){
#         $str .= '<tr class="w3-hide-medium w3-hide-large">';
#         $str .= '<td>';
#         my $inType=14;
#         if ( $LIST{0}{$inType}{$i} ){
#             my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
#             my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
#             my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
#             my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
#             my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
#             $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow );
#         } else {
#             $str .= &_templateAddResultCard($i,$inType,0)
#         }
#         $str .= '</td>';
#         $str .= '</tr>';
#     }
#     $str .= '</table>';

#     $str .= '<h4>Flights Results</h4>';
#     $str .= '<table class="w3-table-all w3-white">';
#     $str .= '<tr class=" w3-hide-small">';
#     $str .= '<th style="width: 25%;">Class</th>';
#     $str .= '<th style="width: 25%;">Regular Class</th>';
#     $str .= '<th style="width: 25%;">Advanced Class</th>';
#     $str .= '<th style="width: 25%;">Micro Class</th>';
#     $str .= '</tr>';
#     for ($row=1; $row<=10; $row++){
#         $str .= '<tr class=" w3-hide-small">';
#         $str .= '<td>Round '.$row.'</td>';
#         for (my $i=1; $i<=3; $i++){
#             my $inType=17;
#             $str .= '<td>';
#             if ( $LIST{$row}{$inType}{$i} ){
#                 my $txFile = $LIST{$row}{$inType}{$i}{TX_FILE};
#                 my $classIDX = $LIST{$row}{$inType}{$i}{FK_CLASS_IDX};
#                 my $inType = $LIST{$row}{$inType}{$i}{FK_TILES_IDX};
#                 my $inRound = $LIST{$row}{$inType}{$i}{IN_ROUND};
#                 my $inShow = $LIST{$row}{$inType}{$i}{IN_SHOW};
#                 $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow  );
#             } else {
#                 $str .= &_templateAddResultCard($i,$inType,$row)
#             }
#             $str .= '</td>';
#         }
#         $str .= '</tr>';
#         $str .= '<tr class="w3-hide-medium w3-hide-large">';
#         $str .= '<td>';
#         $str .= '<b>Round:</b> <span>'.$row.'</span><br>';
#         for (my $i=1; $i<=3; $i++){
#             my $inType=17;
#             if ( $LIST{$row}{$inType}{$i} ){
#                 my $txFile = $LIST{$row}{$inType}{$i}{TX_FILE};
#                 my $classIDX = $LIST{$row}{$inType}{$i}{FK_CLASS_IDX};
#                 my $inType = $LIST{$row}{$inType}{$i}{FK_TILES_IDX};
#                 my $inRound = $LIST{$row}{$inType}{$i}{IN_ROUND};
#                 my $inShow = $LIST{$row}{$inType}{$i}{IN_SHOW};
#                 $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow  );
#             } else {
#                 $str .= &_templateAddResultCard($i,$inType,$row);
#             }
#             $str .= '<br>';
#         }
#         $str .= '</td>';

#         $str .= '</tr>';
#     }
#     $str .= '<tr>';
#     $str .= '</table>';
#     my %OVERALL = %{$Scores->_getOverallPublishList($location)};
#     $str .= '<h4>Overall Results</h4>';
#     $str .= '<table class="w3-table-all w3-white">';
#     $str .= '<tr class="w3-hide-small">';
#     $str .= '<th style="width: 25%;">Class</th>';
#     $str .= '<th style="width: 25%;">Regular Class</th>';
#     $str .= '<th style="width: 25%;">Advanced Class</th>';
#     $str .= '<th style="width: 25%;">Micro Class</th>';
#     $str .= '</tr>';
#     $str .= '<tr class="w3-hide-medium w3-hide-large">';
#     $str .= '<td>';
#     for (my $i=1; $i<=3; $i++){
#         my $inType=10;
#         if ( exists $OVERALL{$i} ){
#             my $txFile = $OVERALL{$i}{TX_FILE};
#             my $classIDX = $i;
#               $inType = $OVERALL{$i}{FK_TILES_IDX};
#             my $inRound = $OVERALL{$i}{IN_ROUND};
#             my $inShow = $OVERALL{$i}{IN_SHOW};
#             $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound , $inShow );
#         } else {
#             my $lastRound = $Scores->_getLastRound($i , $location);
#             $str .= $lastRound." - "; 
#             $str .= &_templateAddResultCard($i,$inType,$lastRound);
#         }
#     }
#     $str .= '</td>';
#     $str .= '</tr>';
    
#     $str .= '<tr class="w3-hide-small">';
#     $str .= '<td>Results</td>';
#     for (my $i=1; $i<=3; $i++){
#         $str .= '<td>';
#         my $inType=10;
#         if ( exists $OVERALL{$i} ){
#             my $txFile = $OVERALL{$i}{TX_FILE};
#             my $classIDX = $i;
#               $inType = $OVERALL{$i}{FK_TILES_IDX};
#             my $inRound = $OVERALL{$i}{IN_ROUND};
#             my $inShow = $OVERALL{$i}{IN_SHOW};
#             $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound , $inShow );
#         } else {
#             my $lastRound = $Scores->_getLastRound($i , $location);
#             $str .= &_templateAddResultCard($i,$inType,$lastRound);
#         }
#         $str .= '</td>';
#     }
#     $str .= '</tr>';
#     $str .= '</table>';
#     for ($row=1; $row<=10; $row++){
#         $str .= '<br>';
#     }
    
#     $str .= '</div>';
    return ($str);
}
sub sae_publishResults(){
    print $q->header();
    my $classIDX = $q->param('classIDX');
    my $inType = $q->param('inType');
    my $location = $q->param('location');
    my $inRound = $q->param('inRound');
    my $Scores = new SAE::SCORE();
    my ($txFile, $publishIDX) = $Scores->_publishRound($classIDX, $inRound, $inType, $location);
    # my $str = "Round = ".$inRound." : ";
    my $str = &_templateResultCards($txFile, $classIDX, $inType, $inRound);
    return ($str);
}
sub _templateResultCards(){
    my $txFile = shift;
    my $classIDX = shift;
    my $inType = shift;
    my $inRound = shift;
    my $inShow = shift;
    my $str;
    my %CLASS = (1=>'Regular',2=>'Advanced',3=>'Micro');
    $str .= '<div class="w3-margin-bottom w3-card-2 w3-small w3-margin-left w3-display-container w3-round">';
    $str .= '<header class="w3-container w3-light-grey w3-round"><meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
    $str .= $CLASS{$classIDX}.' Results';
    $str .= '</header>';
    $str .= '<a class="w3-button w3-hover-red w3-display-topright " style="padding: 0px 5px;" onclick="sae_deletePublishedScore(this, \''.$txFile.'\', '.$classIDX.','.$inType.','.$inRound.')">&times;</a>';
    $str .= '<div class="w3-container w3-white" style="padding: 8px 2px;">';
    $str .= '<a class="w3-margin-left" href="post.html?fileID='.$txFile.'" target="_blank"><i class="fa fa-search"></i> Preview</a><br>';
    # $str .= '<a class="w3-margin-left" href="post.html?fileID='.$txFile.'" target="_blank"><i class="fa fa-search"></i> Preview</a> w/o Score<br>';
    $str .= '</div>';
    if ( $inShow==0 ||  $inShow eq ''){
        if ($inType != 10){
            $str .= '<div class="w3-margin-left w3-padding-small '.$txFile.'">';
            $str .= '<input type="checkbox" value="1" ID="BO_SHOW_SCORE_'.$txFile.'"> ';
            $str .= '<label FOR="BO_SHOW_SCORE_'.$txFile.'">Display Scores</label>';
            $str .= '</div>';
        }
        
        $str .= '<button class="w3-button w3-block w3-orange w3-hover-blue" onclick="sae_makePublic(this, \''.$txFile.'\');">Publish</button>';
    }
    $str .= '</div>';
    return ($str);
}
sub _templateAddResultCard(){
    my $classIDX = shift;
    my $inType = shift;
    my $inRound = shift;
    my $str;
    $str = '<button class="w3-button w3-border w3-card-2" onclick="sae_publishResults(this,'.$classIDX.','.$inType.','.$inRound.');">+ ('.$inRound.')</button>';
    return($str);
}
sub sae_deletePublishedScore(){
    print $q->header();
    my $str;
    my $location = $q->param('location');
    my $txFile = $q->param('txFile');
    my $classIDX = $q->param('classIDX');
    my $inType = $q->param('inType');
    my $inRound = $q->param('inRound');
    my $Scores = new SAE::SCORE();
    $Scores->_deletePublishedScore($txFile);
    $str = &_templateAddResultCard($classIDX, $inType, $inRound);
    # $str .= "$classIDX, $inType, $inRound";
    return ($str);
}
sub sae_makePublic(){
    print $q->header();
    my $str;
    my $txFile = $q->param('txFile');
    my $checked = $q->param('checked');
    my $Scores = new SAE::SCORE();
    $Scores->_makeScoresPublic($txFile, $checked);
    return ();
}