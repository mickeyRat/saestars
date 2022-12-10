#!/usr/bin/perl
use cPanelUserConfig;

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
sub showPublishPage(){
    my $location = $q->param('location');
    print $q->header();
    my $Scores = new SAE::SCORE();
    my %LIST = %{$Scores->_getPublishedList($location)};
    my $str = '<br>';
    $str .= '<div class="w3-container w3-margin-top">';
    $str .= "<h3>Publish Results</h3>";
    $str .= '<table class="w3-table-all w3-white">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 25%;">Class</th>';
    $str .= '<th style="width: 25%;">Regular Class</th>';
    $str .= '<th style="width: 25%;">Advanced Class</th>';
    $str .= '<th style="width: 25%;">Micro Class</th>';
    $str .= '</tr>';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<td>Design Results</td>';
    # my $str = &_templateResultCards($txFile);
    for (my $i=1; $i<=3; $i++){
        $str .= '<td>';
        my $inType=14;
        if ( $LIST{0}{$inType}{$i} ){
            my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
            my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
            my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
            my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
            my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
            $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow );
        } else {
            $str .= &_templateAddResultCard($i,$inType,0)
        }
        $str .= '</td>';
    }
    $str .= '</tr>';
#===== Responsive DESIGN==========
    $str .= '<tr class="w3-hide-medium w3-hide-large">';
    $str .= '<td>Design Results</td>';
    $str .= '</tr>';
    for (my $i=1; $i<=3; $i++){
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        my $inType=14;
        if ( $LIST{0}{$inType}{$i} ){
            my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
            my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
            my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
            my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
            my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
            $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow );
        } else {
            $str .= &_templateAddResultCard($i,$inType,0)
        }
        $str .= '</td>';
        $str .= '</tr>';
    }

    $str .= '<tr class="w3-hide-small">';
    $str .= '<td>Presentation Results</td>';
    for (my $i=1; $i<=3; $i++){
        $str .= '<td>';
        my $inType=15;
        if ( $LIST{0}{$inType}{$i} ){
            my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
            my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
            my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
            my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
            my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
            $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow  );
        } else {
            $str .= &_templateAddResultCard($i,$inType,0)
        }
        $str .= '</td>';
    }
    $str .= '</tr>';
#===== Responsive Presentation ==========
    $str .= '<tr class="w3-hide-medium w3-hide-large">';
    $str .= '<td>Presentation Results</td>';
    $str .= '</tr>';
    for (my $i=1; $i<=3; $i++){
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        my $inType=14;
        if ( $LIST{0}{$inType}{$i} ){
            my $txFile = $LIST{0}{$inType}{$i}{TX_FILE};
            my $classIDX = $LIST{0}{$inType}{$i}{FK_CLASS_IDX};
            my $inType = $LIST{0}{$inType}{$i}{FK_TILES_IDX};
            my $inRound = $LIST{0}{$inType}{$i}{IN_ROUND};
            my $inShow = $LIST{0}{$inType}{$i}{IN_SHOW};
            $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow );
        } else {
            $str .= &_templateAddResultCard($i,$inType,0)
        }
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';

    $str .= '<h4>Flights Results</h4>';
    $str .= '<table class="w3-table-all w3-white">';
    $str .= '<tr class=" w3-hide-small">';
    $str .= '<th style="width: 25%;">Class</th>';
    $str .= '<th style="width: 25%;">Regular Class</th>';
    $str .= '<th style="width: 25%;">Advanced Class</th>';
    $str .= '<th style="width: 25%;">Micro Class</th>';
    $str .= '</tr>';
    for ($row=1; $row<=10; $row++){
        $str .= '<tr class=" w3-hide-small">';
        $str .= '<td>Round '.$row.'</td>';
        for (my $i=1; $i<=3; $i++){
            my $inType=17;
            $str .= '<td>';
            if ( $LIST{$row}{$inType}{$i} ){
                my $txFile = $LIST{$row}{$inType}{$i}{TX_FILE};
                my $classIDX = $LIST{$row}{$inType}{$i}{FK_CLASS_IDX};
                my $inType = $LIST{$row}{$inType}{$i}{FK_TILES_IDX};
                my $inRound = $LIST{$row}{$inType}{$i}{IN_ROUND};
                my $inShow = $LIST{$row}{$inType}{$i}{IN_SHOW};
                $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow  );
            } else {
                $str .= &_templateAddResultCard($i,$inType,$row)
            }
            $str .= '</td>';
        }
        $str .= '</tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= '<b>Round:</b> <span>'.$row.'</span><br>';
        for (my $i=1; $i<=3; $i++){
            my $inType=17;
            if ( $LIST{$row}{$inType}{$i} ){
                my $txFile = $LIST{$row}{$inType}{$i}{TX_FILE};
                my $classIDX = $LIST{$row}{$inType}{$i}{FK_CLASS_IDX};
                my $inType = $LIST{$row}{$inType}{$i}{FK_TILES_IDX};
                my $inRound = $LIST{$row}{$inType}{$i}{IN_ROUND};
                my $inShow = $LIST{$row}{$inType}{$i}{IN_SHOW};
                $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound, $inShow  );
            } else {
                $str .= &_templateAddResultCard($i,$inType,$row);
            }
            $str .= '<br>';
        }
        $str .= '</td>';

        $str .= '</tr>';
    }
    $str .= '<tr>';
    $str .= '</table>';
    my %OVERALL = %{$Scores->_getOverallPublishList($location)};
    $str .= '<h4>Overall Results</h4>';
    $str .= '<table class="w3-table-all w3-white">';
    $str .= '<tr class="w3-hide-small">';
    $str .= '<th style="width: 25%;">Class</th>';
    $str .= '<th style="width: 25%;">Regular Class</th>';
    $str .= '<th style="width: 25%;">Advanced Class</th>';
    $str .= '<th style="width: 25%;">Micro Class</th>';
    $str .= '</tr>';
    $str .= '<tr class="w3-hide-medium w3-hide-large">';
    $str .= '<td>';
    for (my $i=1; $i<=3; $i++){
        my $inType=10;
        if ( exists $OVERALL{$i} ){
            my $txFile = $OVERALL{$i}{TX_FILE};
            my $classIDX = $i;
               $inType = $OVERALL{$i}{FK_TILES_IDX};
            my $inRound = $OVERALL{$i}{IN_ROUND};
            my $inShow = $OVERALL{$i}{IN_SHOW};
            $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound , $inShow );
        } else {
            my $lastRound = $Scores->_getLastRound($i , $location);
            $str .= $lastRound." - "; 
            $str .= &_templateAddResultCard($i,$inType,$lastRound);
        }
    }
    $str .= '</td>';
    $str .= '</tr>';
    
    $str .= '<tr class="w3-hide-small">';
    $str .= '<td>Results</td>';
    for (my $i=1; $i<=3; $i++){
        $str .= '<td>';
        my $inType=10;
        if ( exists $OVERALL{$i} ){
            my $txFile = $OVERALL{$i}{TX_FILE};
            my $classIDX = $i;
               $inType = $OVERALL{$i}{FK_TILES_IDX};
            my $inRound = $OVERALL{$i}{IN_ROUND};
            my $inShow = $OVERALL{$i}{IN_SHOW};
            $str .= &_templateResultCards($txFile, $classIDX , $inType , $inRound , $inShow );
        } else {
            my $lastRound = $Scores->_getLastRound($i , $location);
            $str .= &_templateAddResultCard($i,$inType,$lastRound);
        }
        $str .= '</td>';
    }
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