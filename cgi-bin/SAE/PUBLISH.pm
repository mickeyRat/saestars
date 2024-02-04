package SAE::PUBLISH;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );
use Number::Format;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;
use SAE::Auth();
use SAE::USER();
use SAE::TEAM();
use SAE::GRADE();
use SAE::MICRO;


my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
#====================================== SETTERS ==================================================================
sub saveOverallScores(){
    my ($publishIDX, $teamIDX, $inDesign, $inPreso, $inMission, $inPenalty) = @_;
    my $inValue = $inDesign + $inPreso + $inMission - $inPenalty;
    my $SQL = "INSERT INTO TB_RESULTS (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_SCORE, IN_DESIGN, IN_PRESO, IN_MISSION, IN_PENALTY) VALUES (?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert ->execute($publishIDX, $teamIDX, $inValue, $inDesign, $inPreso, $inMission, $inPenalty);
    return();
    }
sub saveScores(){
    my ($publishIDX, $teamIDX, $inValue) = @_;
    my $SQL = "INSERT INTO TB_RESULTS (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_SCORE) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert ->execute($publishIDX, $teamIDX, $inValue);
    return();
    }
sub calculateDesignScores(){
    my ($eventIDX, $teamIDX) = @_;
    my $Grade  = new SAE::GRADE();
    my %TYPE   = (1=>'Assessment', 2=>'TDS', 3=>'Drawing', 4=>'Requirement');
    my %CARDS  = %{&getCards($teamIDX)}; # 1 = Design Report
    my $inValue = 0;
    foreach $cardTypeIDX (sort keys %CARDS){
        my @SCORES = ();
        foreach $cardIDX (sort keys %{$CARDS{$cardTypeIDX}}) {
            my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $TYPE{$cardTypeIDX});
            push(@SCORES, $score);
        }
        $inValue += mean(@SCORES);
    }
    return ($inValue);
    }
sub generateDesignScores (){
    # 1. Get a list of teams for the event
    # 2. Get all the Design Cards for the team
    # 3. Get Score for each card (Design, TDS, Requirements, and Drawings)
    # 4. average the scores from each card and add it to the TB_RESULTS TABLE
    my ($eventIDX, $publishIDX, $classIDX) = @_;
    my $Team   = new SAE::TEAM();
    my %TEAMS  = %{$Team->_getTeamListByClass($eventIDX, $classIDX)};
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inValue = &calculateDesignScores($eventIDX, $teamIDX);
        &saveScores($publishIDX, $teamIDX, $inValue);
    }
    return ();
    }
sub calculatePresentationScores (){
    my ($teamIDX) = @_;
    my $Grade   = new SAE::GRADE();
    my %CARDS   = %{&getPresentationCards($teamIDX, 5)}; # 5 = Presentation
    my $inValue = 0;
    my @SCORES  = ();
    foreach $cardIDX (sort keys %CARDS){
        my $score = $Grade->_getAssessmentScore_byCard($cardIDX, 'Presentation');
        push(@SCORES, $score);
    }
    $inValue = mean(@SCORES);
    return ($inValue);
    }
sub generatePresentationScores (){
    # 1. Get a list of teams for the event
    # 2. Get all the Presentation Cards for the team
    # 3. Get Score for each card (Presentation only.  get card call for value of 5 = presentation)
    # 4. average the scores from each card and add it to the TB_RESULTS TABLE
    my ($eventIDX, $publishIDX, $classIDX) = @_;
    my $Team   = new SAE::TEAM();
    my %TEAMS  = %{$Team->_getTeamListByClass($eventIDX, $classIDX)};
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inValue = &calculatePresentationScores($eventIDX, $teamIDX);
        &saveScores($publishIDX, $teamIDX, $inValue);
    }
    return ();
    }
sub calculateMissionScores (){
    my ($teamIDX) = @_;
    my $Micro     = new SAE::MICRO();
    my %LOGS      = %{&getFlightLogs($teamIDX)};
    my $inValue   = 0;
    my @SCORES    = ();
    printf "Team = %d\n", $teamIDX;
    foreach $flightIDX (sort keys %LOGS) {
        my $score = $Micro->_calc24_FLightScore($flightIDX);
        push (@SCORES, $score);
    }
    my @SORTED = sort {$b <=> $a} @SCORES;
    my $inValue = $SORTED[0]+$SORTED[1]+$SORTED[2];
    return ($inValue);
    }
sub generateMissionScores (){
    # 1. Get a list of teams for the event
    # 2. Get all the Presentation Cards for the team
    # 3. Get Score for each card (Presentation only.  get card call for value of 5 = presentation)
    # 4. average the scores from each card and add it to the TB_RESULTS TABLE
    my ($eventIDX, $publishIDX, $classIDX) = @_;
    my $Team      = new SAE::TEAM();
    my %TEAMS     = %{$Team->_getTeamListByClass($eventIDX, $classIDX)};
    my %SCORE;
    my $str;
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inValue = &calculateMissionScores($teamIDX);
        &saveScores($publishIDX, $teamIDX, $inValue);
    }
    return ($str);
    }
sub generateOverallScores (){
    # 1. Get a list of teams for the event
    # 2. Get all the Presentation Cards for the team
    # 3. Get Score for each card (Presentation only.  get card call for value of 5 = presentation)
    # 4. average the scores from each card and add it to the TB_RESULTS TABLE
    my ($eventIDX, $publishIDX, $classIDX) = @_;
    my $Team      = new SAE::TEAM();
    my %TEAMS     = %{$Team->_getTeamListByClass($eventIDX, $classIDX)};
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $inDesign  = &calculateDesignScores($eventIDX, $teamIDX);
        my $inPreso   = &calculatePresentationScores($teamIDX);
        my $inMission = &calculateMissionScores($teamIDX);
        my $inPenalty = 0;
        &saveOverallScores($publishIDX, $teamIDX, $inDesign, $inPreso, $inMission, $inPenalty);
    }
    return ($str);
    }
sub _activatePublicView(){  #Keep 2024 
    my ($self, $publishIDX, $checked) = @_;
    my $SQL    = "UPDATE TB_PUBLISH SET IN_SHOW=? WHERE PK_PUBLISH_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute( $checked, $publishIDX );
    return;
    }
sub _generateResults(){
    my ($self, $eventIDX, $classIDX, $txTitle, $userIDX, $inType) = @_;
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    my $now_string = localtime;
    my $Auth = new SAE::Auth();
    my $User = new SAE::USER();
    my $userName = $User->_getUserById($userIDX);
    my $txFile = $Auth->getTemporaryPassword(64); 
    my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_CLASS, TX_TITLE, TX_FILE, TX_TIME, TX_PUBLISH_BY, IN_TYPE) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($eventIDX, $classIDX, $CLASS{$classIDX}, $txTitle, $txFile, $now_string, $userName, $inType);
    my $newIDX = $insert->{q{mysql_insertid}} || die "Error $_";
    if ( $inType == 1) {
            &generateDesignScores($eventIDX, $newIDX, $classIDX);
        } elsif ( $inType == 2) {
            &generatePresentationScores($eventIDX, $newIDX, $classIDX);
        } elsif ( $inType == 3) {
            &generateMissionScores($eventIDX, $newIDX, $classIDX);
        } elsif ( $inType == 4) {
            &generateOverallScores($eventIDX, $newIDX, $classIDX);
        }
    return ($newIDX, $txFile, $now_string, $userName);
    }
#====================================== GETTERS ==================================================================
sub getFlightLogs (){ #Keep 2024
    my ($teamIDX) = @_;
    my $str;
    # my $SQL = "SELECT * FROM TB_FLIGHT where (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $SQL = "SELECT * FROM TB_FLIGHT WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute( $teamIDX );
    my %HASH = %{$select->fetchall_hashref('PK_FLIGHT_IDX')}; 
    return (\%HASH);
    }
sub getPresentationCards(){ #Keep 2024
    my ($teamIDX, $cardTypeIDX) = @_;
    my $SQL = "SELECT * FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX, $cardTypeIDX );
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')};
    return (\%HASH);
    }
sub getCards(){ #Keep 2024
    my ($teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX<=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX, 4 );
    my %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX', 'PK_CARD_IDX'])};
    return (\%HASH);
    }
sub _getPublishedList (){ #Keep 2024
    my ($self, $eventIDX, $inType ) = @_;
    my $str;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND IN_TYPE=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $inType );
    my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX', 'PK_PUBLISH_IDX'])};
    return (\%HASH);
    }

sub _getPubishStatus (){
    my ($self, $eventIDX, $classIDX, $inType) = @_;
    my $SQL = "SELECT IN_SHOW FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=? AND IN_TYPE=? AND IN_SHOW=1)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $classIDX, $inType );
    my $rows = $select->rows();
    if ($rows){
        return (1);
    } else {
        return(0);
    }
    }
sub _getPublishStatus(){
    my ($self, $eventIDX, $classIDX, $txTitle) = @_;
    my $SQL = "SELECT IN_SHOW FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND TX_TITLE=? AND IN_SHOW=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $txTitle, 1, $classIDX );
    my $rows = $select->rows();
    # print "$eventIDX, $txTitle, 1\n";
    # print $rows;
    # print "\n";
    if ($rows){
        return (1);
    } else {
        return(0);
    }
    }
# sub _getSelectedFinalReportFileID(){
#     my ($self, $eventIDX) = @_;
#     my $SQL = "SELECT * FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND IN_INCLUDE=?)";
#     my $select = $dbi->prepare($SQL);
#        $select->execute( $eventIDX, 1 );
#     my %HASH = %{$select->fetchall_hashref(['TX_TITLE', 'FK_CLASS_IDX'])};
#     return (\%HASH);
# }
# sub _getReportHeaders(){
#     my ($self, $txFile) = @_;
#     my $SQL = "SELECT * FROM TB_PUBLISH WHERE (TX_FILE=?)";
#     my $select = $dbi->prepare($SQL);
#        $select->execute( $txFile );
#     my %HASH = %{$select->fetchrow_hashref()};
#     return (\%HASH);
# }
# sub _getPublishedResults(){
#     my ($self, $eventIDX, $classIDX, $txTitle) = @_;
#     # print "$eventIDX, $classIDX, $txTitle\n";
#     my $SQL = "SELECT * FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=? AND TX_TITLE=?)";
#     my $select = $dbi->prepare($SQL);
#        $select->execute( $eventIDX, $classIDX, $txTitle );
#     my %HASH = %{$select->fetchall_hashref('PK_PUBLISH_IDX')}; 
#     my %AWARD = ('Design Report'=>1,'Presentation Scores'=>1,'Mission Performance Scores'=>1,'Overall Performance'=>1);
#     my $str;
#     foreach $publishIDX (sort keys %HASH) {
#         $str .= '<div ID="PUBLISH_'.$publishIDX.'" class="w3-card-2 w3-border w3-round w3-margin-bottom">';
#         $str .= '<header class="w3-container w3-light-grey">';
#         $str .= sprintf '<h5 class="w3-small">%s - Generated on: %s ( <i>v.%d</i > ) published by: <b>%s</b></h5>', $txTitle, $HASH{$publishIDX}{TX_TIME}, $publishIDX, $HASH{$publishIDX}{TX_PUBLISH_BY};
#         $str .= '</header>';
#         $str .= '<div class="w3-container w3-white w3-padding">';
#         my $checked = '';
#         my $include = '';
#         if ($HASH{$publishIDX}{IN_SHOW}==1) {$checked = 'checked'}
#         if ($HASH{$publishIDX}{IN_INCLUDE}==1) {$include = 'checked'}
#         $str .= '<p>';
#         if (exists $AWARD{$HASH{$publishIDX}{TX_TITLE}}){
#             $str .= sprintf '<input class="w3-check" type="checkbox" %s onclick="sae_includeInFinalScore(this, %d);"><label  class="w3-margin-left">Include this result in the Final Award Presentation</label><br>', $include, $publishIDX, $eventIDX;
#         }
#         $str .= sprintf '<input class="w3-check" type="checkbox" %s onclick="sae_activatePublicView(this, %d);">', $checked, $publishIDX;
#         $str .= sprintf '<label class="w3-margin-left w3-pale-red w3-padding">Public Access</label><span class="w3-margin-left w3-margin-right"><a href="post.html?fileID=%s" target="_blank">View</a></span>',  $HASH{$publishIDX}{TX_FILE};
#         $str .= ' | ';
#         $str .= sprintf '<span class="w3-margin-left w3-margin-right"><a href="javascript:void(0);" onclick="sae_deletePublishScore(%d);">Delete</a></span>', $publishIDX;
#         # $str .= ' | ';
#         # $str .= sprintf '<span class="w3-margin-left w3-margin-right"><a href="javascript:void(0);" onclick="sae_includeInFinalScore(%d, %d);">Include In Final</a></span></p>', $publishIDX, $eventIDX;
#         $str .= '</div>';
#         $str .= '</div>';
#     }
#     # print $str."\n";
#     return ($str);
# }

#====================================== DELETE ==================================================================
sub _deletePublishedScore(){ #keep 2024
    my ($self, $publishIDX) = @_;
    my $SQL = "DELETE FROM TB_PUBLISH WHERE PK_PUBLISH_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete->execute( $publishIDX );
    
    $SQL = "DELETE FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $deleteScore = $dbi->prepare($SQL);
       $deleteScore->execute( $publishIDX );

    $SQL = "DELETE FROM TB_RESULTS WHERE FK_PUBLISH_IDX=?";
    my $deleteScore = $dbi->prepare($SQL);
       $deleteScore->execute( $publishIDX );
    return;
}
return (1);



