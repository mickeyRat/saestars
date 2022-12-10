package SAE::SCORE;

use DBI;
use SAE::SDB;
use SAE::RUBRIC;
use SAE::REFERENCE();
use SAE::Auth();
# use List::Util;
use List::Util qw( sum min max reduce );
use Number::Format;
# use HTML::Entities;
use Statistics::Basic qw(:all);
use POSIX;

use SAE::MICRO;
use SAE::REGULAR;
use SAE::ADVANCED;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub _getAverage(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
}
#========================== 2022 =================================================================

# ------------------------- SUPERLATIVES FASTEST TIME TO FIRST TURN ------------------------------
sub _generateviewFastestTimeToTurn(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT MIN(IN_TOF) FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my ($inTime) = $flight->fetchrow_array();

    &_saveFastestTimeToTurn($publishIDX, $teamIDX, $inTime);
    return ($inTime);
}
sub _saveFastestTimeToTurn(){
    my ($publishIDX, $teamIDX, $totalVolume) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_TIME) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
      $insert->execute( $publishIDX, $teamIDX, $totalVolume );  
    return;
}
sub _getFastestTimeToTurn(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_TIME FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
          $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES EFFECTIVE VOLUME DELIVERED ------------------------------
sub _generateMostEffectiveVolumeDelivered(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_LARGE, IN_SMALL, IN_LB_DAMAGE, IN_SB_DAMAGE, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $minDistance = 100;
    my $largeVolume = 12*12*2;
    my $smallVolume = 6*6*4;
    my $totalVolume = 0;
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        my $inDistance = $FLIGHT{$flightIDX}{IN_DISTANCE};
        my $volume = ($FLIGHT{$flightIDX}{IN_LARGE} * $largeVolume) +  ($FLIGHT{$flightIDX}{IN_SMALL} * $smallVolume) + ($FLIGHT{$flightIDX}{IN_LB_DAMAGE} * $largeVolume * .5) + ($FLIGHT{$flightIDX}{IN_SM_DAMAGE} * $smallVolume * .5);
        $totalVolume += $volume * $minor * $major;
    }
    &_saveMostEffectiveVolumeDelivered($publishIDX, $teamIDX, $totalVolume);
    return ($totalVolume);
}
sub _saveMostEffectiveVolumeDelivered(){
    my ($publishIDX, $teamIDX, $totalVolume) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_VOLUME) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
      $insert->execute( $publishIDX, $teamIDX, $totalVolume );  
    return;
}
sub _getMostEffectiveVolumeDelivered(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_VOLUME FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
          $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES CLOSEST TO TARGET CENTER --------------------------------
sub _generateClosestToTargetCenter(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_DISTANCE, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=? AND BO_INZONE=?)";
    my $flight = $dbi->prepare($SQL);
      $flight->execute($teamIDX, 1, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $minDistance = 100;
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        # if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        # if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        my $inDistance = $FLIGHT{$flightIDX}{IN_DISTANCE};
        if ($inDistance<$minDistance) { $minDistance = $inDistance;}
    }
    
    &_saveClosestToTargetCenter($publishIDX, $teamIDX, $minDistance);
    return ($minDistance);
}
sub _saveClosestToTargetCenter(){
    my ($publishIDX, $teamIDX, $minDistance) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_DISTANCE) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
      $insert->execute( $publishIDX, $teamIDX, $minDistance );  
    return;
}
sub _getClosestToTargetCenter(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_DISTANCE FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
          $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES MOST PADA IN ZONE ---------------------------------------
sub _generatePadaInZone(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, BO_INZONE, IN_DISTANCE, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=? AND BO_INZONE=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $inZone = 0;
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        # if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        # if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        $inZone += $FLIGHT{$flightIDX}{BO_INZONE};
    }
    
    &_saveMostPadaInZone($publishIDX, $teamIDX, $inZone);
    return ($inZone);
}
sub _saveMostPadaInZone(){
    my ($publishIDX, $teamIDX, $inZone) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_PADA) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
       $insert->execute( $publishIDX, $teamIDX, $inZone );  
    return;
}
sub _getMostPadaInZone(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_PADA FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES HEAVIEST PAYLOAD ----------------------------------------
sub _getHeaviestPayloadFlown(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_WEIGHT, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $maxPayload = 0;
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        my $payload = $FLIGHT{$flightIDX}{IN_WEIGHT};
        if ($payload>$maxPayload) { $maxPayload = $payload;}
    }
    
    &_saveHeaviestPayload($publishIDX, $teamIDX, $maxPayload);
    return ($maxPayload);
}
sub _saveHeaviestPayload(){
    my ($publishIDX, $teamIDX, $inBall) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_PAYLOAD) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
       $insert->execute( $publishIDX, $teamIDX, $inBall );  
    return;
}
sub _getHeaviestPayload(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_PAYLOAD FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES MOST BALLS --------------------------------------------
sub _getMostBallFlown(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_SPHERE, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $inBall = 0;
    
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        my $wholeBall = 0;
        if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        $wholeBall = POSIX::floor( $FLIGHT{$flightIDX}{IN_SPHERE} * $minor * $major);
        $inBall += $wholeBall;
        # POSIX::floor(11/4)
    }
    &_saveMostBall($publishIDX, $teamIDX, $inBall);
    return ($inBall);
}
sub _saveMostBall(){
    my ($publishIDX, $teamIDX, $inBall) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_BALL) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
       $insert->execute( $publishIDX, $teamIDX, $inBall );  
    return;
}
sub _getMostBall(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_BALL FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES MOST PAYLOAD --------------------------------------------

sub _getBestPayloadRatio(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_WEIGHT, IN_SPAN, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $inPayload = 0;
    # my $ratio = 0;
    my $bestRatio = 0;
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        my $inSpan = $FLIGHT{$flightIDX}{IN_SPAN};
        if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        $inPayload = $FLIGHT{$flightIDX}{IN_WEIGHT} * $minor * $major;
        if ($inSpan>0){
            $ratio = 100 * ($inPayload/$inSpan);
        } else {
            $ratio = 0;
        }
        if ($ratio>$bestRatio) { $bestRatio = $ratio;}
    }
    
    &_saveBestRatio($publishIDX, $teamIDX, $bestRatio);
    return ($bestRatio);
}
sub _saveBestRatio(){
    my ($publishIDX, $teamIDX, $inRatio) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_RATIO) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
       $insert->execute( $publishIDX, $teamIDX, $inRatio );  
    return;
}
sub _getMostBestRatio(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_RATIO FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- SUPERLATIVES MOST PAYLOAD --------------------------------------------
sub _getMostPayload(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_WEIGHT, IN_WATER_FLT, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $inPayload = 0;
    foreach $flightIDX (sort keys %FLIGHT) {
        my $minor = 1;
        my $major = 1;
        if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}==1){$minor = .75}
        if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}==1){$minor = .5}
        if ($classIDX==2){
            $inPayload += $FLIGHT{$flightIDX}{IN_WATER_FLT} * $minor * $major;
        } else {
            $inPayload += $FLIGHT{$flightIDX}{IN_WEIGHT} * $minor * $major;
        }
    }
    &_saveMostPayload($publishIDX, $teamIDX, $inPayload);
    return ($inPayload);
}
sub _saveMostPayload(){
    my ($publishIDX, $teamIDX, $inPayload) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_PAYLOAD) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare( $SQL );
       $insert->execute( $publishIDX, $teamIDX, $inPayload );  
    return;
}
sub _getMostPayloadScores(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_PAYLOAD FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
# ------------------------- DESIGN ---------------------------------------------------------------
sub _getDesignScore(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_DESIGN, IN_LATE, IN_RAW FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
sub _designScores(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $Rubric=new SAE::RUBRIC();
    my %SECTION = %{$Rubric->_getSectionList()};
    my ($late, $design, $sorted) = &_calcDesignScore($teamIDX, \%SECTION);
    &_saveDesignScores($publishIDX, $teamIDX, $late, $design, $sorted);
    return ($late, $design, $sorted) ;
}
sub _saveDesignScores(){
    my ($publishIDX, $teamIDX, $late, $design, $inRaw) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_LATE, IN_DESIGN, IN_RAW) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $late, $design, $inRaw);
    return;
}
sub _calcDesignScore(){ # Developed in 2022 to increase the speed of calculating the designb scores 
    # my ($self, $teamIDX, $SEC) = @_;
    my ($teamIDX, $SEC) = @_;
    my %SECTION = %{$SEC};
    my $teamScore = 0;
    my $SQL = "SELECT CARD.FK_CARDTYPE_IDX, SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
        JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
        WHERE (CARD.FK_TEAM_IDX=?)
        GROUP BY CARD.FK_CARDTYPE_IDX, SUB.FK_SECTION_IDX";
        my $select = $dbi->prepare($SQL);
           $select -> execute($teamIDX);
        my %SCORE = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_SECTION_IDX'])};
    my $latePenalty = &_calculateLatePenalty($teamIDX);
    for (my $inType=1; $inType<=4; $inType++){
        my $score = 0;
        my $sectionScore = 0;
        my $sectionMaxPoint = &_getSectionMaxPoints($inType);
        foreach $sectionIDX (sort {$a<=>$b} keys %{$SECTION{$inType}}){
            my $inWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
            my $average = $SCORE{$inType}{$sectionIDX}{IN_AVERAGE};
            my $MaxSectionScore = $sectionMaxPoint * $inWeight /100;
            $sectionScore = ($inWeight/100) * ($average / 100) * $sectionMaxPoint;
            $score += $sectionScore;
        }
        $teamScore += $score;
    }
    my $finalScore = $teamScore-$latePenalty;
    my $rawScore = $finalScore;
    if (($finalScore)<=0) {
        $finalScore = 0;
    }
    return ($latePenalty, $finalScore, $rawScore);
}
sub _getSectionMaxPoints(){
    my ($cardTypeIDX) = @_;
    my $inPoints = 0;
    my $SQL = "SELECT IN_POINTS FROM TB_CARDTYPE WHERE PK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardTypeIDX);
    $inPoints = $select->fetchrow_array();
    return ($inPoints);
}
# ------------------------- PRESO ---------------------------------------------------------------
sub _getPresoScore(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_PRESO FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
sub _presoScores(){
    my ($self, $eventIDX, $classIDX, $teamIDX, $publishIDX) = @_;
    my $Rubric=new SAE::RUBRIC();
    my %SECTION = %{$Rubric->_getSectionList()};
    my ($preso) = &_calculatePresoScoreByTeam($teamIDX,5);
    &_savePresoScores($publishIDX, $teamIDX, $preso);
    return ($preso);
}
sub _savePresoScores(){
    my ($publishIDX, $teamIDX, $inPreso) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_PRESO) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inPreso);
    return;
}
sub _calculatePresoScoreByTeam(){
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my @SCORES = ();
    my $SQL = "SELECT CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
    JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX
    JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
    WHERE (SECTION.FK_CARDTYPE_IDX=? AND CARD.FK_TEAM_IDX=?)
    GROUP BY CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($cardTypeIDX, $teamIDX);
    while (my ($teamIDX, $cardIDX, $inPoints) = $select->fetchrow_array()) {
        push (@SCORES, $inPoints);
    }
    my $averageScore = &_getAverage(@SCORES);
    return ($averageScore);
}
# ------------------------- OVERALL -------------------------------------------------------------
sub _saveOverallScores(){
    my ($self, $publishIDX, $teamIDX, $inDesign, $inPres, $inFlight, $inPenalty, $inOverall) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_DESIGN, IN_PRESO, IN_FLIGHT, IN_PENALTY, IN_OVERALL) VALUES (?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inDesign, $inPres, $inFlight, $inPenalty, $inOverall);
    return;
}
sub _getOverallScores(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_DESIGN, IN_PRESO, IN_FLIGHT, IN_PENALTY, IN_OVERALL FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}

#========================== 2022 =================================================================
##============== SCORES FOR STUDENTS =======================================================
sub _getTeamDataWithCrypt(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT PK_TEAM_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, FK_CLASS_IDX FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    while (my ($teamIDX, $inNumber, $txName, $txSchool, $classIDX) = $select->fetchrow_array()) {
        my $eIDX = crypt($teamIDX, '20');
        $HASH{$eIDX}{PK_TEAM_IDX} = $teamIDX;
        $HASH{$eIDX}{TX_NAME} = $txName;
        $HASH{$eIDX}{IN_NUMBER} = $inNumber;
        $HASH{$eIDX}{TX_SCHOOL} = $txSchool;
        $HASH{$eIDX}{FK_CLASS_IDX} = $classIDX;
        $HASH{$eIDX}{TX_FULLNAME} = substr("000".$inNumber, -3,3).' - '.$txSchool;
    }
    return(\%HASH);
}
sub _getMaxRound(){
    my $location = shift;
    my $SQL = "SELECT FK_CLASS_IDX, MAX(IN_ROUND) AS IN_ROUND 
        FROM TB_PUBLISH WHERE FK_EVENT_IDX=? GROUP BY FK_CLASS_IDX";
    my $select = $dbi->prepare($SQL);
       $select->execute( $location ); 
    my %HASH = %{$select->fetchall_hashref('FK_CLASS_IDX')};   
    return (\%HASH);
}
sub _getJudgesForPaper(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT PAPER.*, CARD.FK_CARDTYPE_IDX FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
            WHERE CARD.FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX );
    my %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_CARD_IDX','FK_SUBSECTION_IDX'])}; 
    return (\%HASH);
}
sub _getComments(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT * FROM TB_COMMENTS WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX );
    my %HASH = %{$select->fetchall_hashref(['FK_SUBSECTION_IDX','PK_COMMENTS_IDX'])}; 
    return (\%HASH);
}
sub _getStandings(){
    my $self = shift;
    my $teamIDX = shift;
    my $classIDX = shift;
    my $location = shift;
    $SQL = "SELECT * FROM TB_PUBLISH WHERE (IN_SHOW=? AND FK_EVENT_IDX=? AND FK_CLASS_IDX=?)";
       $select = $dbi->prepare($SQL);
       $select->execute(1, $location, $classIDX);
    %PUB = %{$select->fetchall_hashref('IN_ROUND')};
    my $maxRound = max (keys %PUB);
    %HASH = ();
    for (my $i=1; $i<=$maxRound; $i++){
        $HASH{$i} = $PUB{$i}{TX_FILE};
    }
    return (\%HASH);
}
##============== PENALTIES ==================================================================
sub _getPenaltyListByEvent(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT ECR.FK_TEAM_IDX, SUM(ECR.IN_DEDUCTION) AS IN_TOTAL FROM TB_ECR AS ECR 
        JOIN TB_TEAM AS TEAM ON ECR.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE TEAM.FK_EVENT_IDX=?
        GROUP BY ECR.FK_TEAM_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($location);
    %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
sub _getTotalPenaltiesByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %HASH = %{&_getTeamsWithERCs($location)};
    my $score = 0;
    foreach $ecrIDX (sort keys %{$HASH{$teamIDX}}){
        $score += $HASH{$teamIDX}{$ecrIDX}{IN_DEDUCTION};
    }
    
    return($score);
}
sub _getTotalPenaltiesByEvent(){
    my $self = shift;
    my $location = shift;
    my %HASH = %{&_getTeamsWithERCs($location)};
    foreach $teamIDX (sort keys %HASH) {
        my $score = 0;
        foreach $ecrIDX (sort keys %{$HASH{$teamIDX}}){
            $score += $HASH{$teamIDX}{$ecrIDX}{IN_DEDUCTION};
        }
        $SCORE{$teamIDX}=$score;
    }
    return(\%SCORE);
}
sub _getPenaltiesByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %HASH = %{&_getTeamsWithERCs($location)};
    return(\%{$HASH{$teamIDX}});
}
sub _getPenaltiesByEvent(){
    my $self = shift;
    my $location = shift;
    my %HASH = %{&_getTeamsWithERCs($location)};
    return(\%HASH);
}
sub _getAllPenaltiesByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT SUM(IN_DEDUCTION) AS IN_DEDUCTIONS FROM TB_ECR WHERE FK_TEAM_IDX = ?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my ($deduction) = $select->fetchrow_array();
    # print "\$deduction = $deduction\n";
    return ($deduction);
}
sub _getTeamsWithERCs(){
    my $location = shift;
    my $SQL = "SELECT ECR.* FROM TB_ECR AS ECR JOIN TB_TEAM AS TEAM ON ECR.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_ECR_IDX'])};
    return (\%HASH);
}
##============== PAPER =======================================================
sub _getPaperScoreByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $inType = shift;
    my $score;
    $score = &_calculatePaperScores($teamIDX, $cardIDX, $inType);
    return ($score)
}
sub _calculatePaperScores(){
    # my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $inType = shift;
    my $Rubric=new SAE::RUBRIC();
    my $score = 0;
    my $sectionScore = 0;
    my $SQL = "SELECT * FROM TB_CARDTYPE";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %CARDTYPE = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')}; 
    my $PaperTotal = $CARDTYPE{$inType}{IN_POINTS};
    # print "\$teamIDX  = $teamIDX, \$cardIDX=$cardIDX\n ";
    # print "\$inType=$inType, \$PaperTotal=$PaperTotal\n";

    $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
        JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
        WHERE (CARD.FK_TEAM_IDX=? AND CARD.PK_CARD_IDX=?)
        GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $cardIDX);
    my %SCORE = %{$select->fetchall_hashref('FK_SECTION_IDX')};
    # print "Total Record = ".scalar(keys %SCORE)."\n";
    my %SECTION = %{$Rubric->_getSectionList()};
    foreach $sectionIDX (sort {$a<=>$b} keys %{$SECTION{$inType}}){
        my $inWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
        my $average = $SCORE{$sectionIDX}{IN_AVERAGE};
        my $MaxSectionScore = $PaperTotal * $inWeight /100;
        $sectionScore = ($inWeight/100) * ($average / 100) * $PaperTotal;
        # print "Weight = $inWeight\tAverage Score = $average\tMax Section = $MaxSectionScore \tSection Score = $sectionScore \n";
        $score += $sectionScore;
    }
    return ($score);
}
sub _getOverallPaperByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $inType = shift;
    my $score = &_calculateOverallPaperByTeam($teamIDX,1);
    $score += &_calculateOverallPaperByTeam($teamIDX,2);
    $score += &_calculateOverallPaperByTeam($teamIDX,3);
    $score += &_calculateOverallPaperByTeam($teamIDX,4);
    my $late = &_calculateLatePenalty($teamIDX);
    return ($score, $late);
}
sub _getOverallPaperSectionByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $inType = shift;
    my $score = &_calculateOverallPaperByTeam($teamIDX,$inType);
    return ($score);
}
sub _calculateLatePenalty(){
    my $teamIDX = shift;
    my $SQL = "SELECT * FROM TB_LATE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    my $late = $HASH{$teamIDX}{IN_DAYS} * 5;
    if ($late>50){$late=50}
    return ($late);
}
sub _calculateOverallPaperByTeam(){
    my $teamIDX = shift;
    my $inType = shift;
    my $Rubric=new SAE::RUBRIC();
    my $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
        JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
        WHERE (CARD.FK_TEAM_IDX=? AND CARD.FK_CARDTYPE_IDX=?)
        GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $inType);
    my %SCORE = %{$select->fetchall_hashref('FK_SECTION_IDX')};
    my %SECTION = %{$Rubric->_getSectionList()};
    my $SQL = "SELECT * FROM TB_CARDTYPE";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %CARDTYPE = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')}; 
    my $PaperTotal = $CARDTYPE{$inType}{IN_POINTS};
    my $score = 0;
    my $sectionScore = 0;
    foreach $sectionIDX (sort {$a<=>$b} keys %{$SECTION{$inType}}){
        my $inWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
        my $average = $SCORE{$sectionIDX}{IN_AVERAGE};
        my $MaxSectionScore = $PaperTotal * $inWeight /100;
        $sectionScore = ($inWeight/100) * ($average / 100) * $PaperTotal;
        $score += $sectionScore;
    }
    return ($score);
}
# # Average By Card
sub _getCardSectionAverage(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
            JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
            JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
            WHERE (CARD.FK_TEAM_IDX=? AND CARD.PK_CARD_IDX=?)
            GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $cardIDX);
    %HASH = %{$select->fetchall_hashref(FK_SECTION_IDX)};
    return (\%HASH);
}
#  OVERALL =====
sub _getSectionAverage(){
    my $self = shift;
    my $teamIDX = shift;
    my $inType = shift;
    my $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
            JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
            JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
            WHERE (CARD.FK_TEAM_IDX=? AND CARD.FK_CARDTYPE_IDX=?)
            GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $inType);
    %HASH = %{$select->fetchall_hashref(FK_SECTION_IDX)};
    return (\%HASH);
}
sub _getOverallDesignResults(){
    my $self=shift;
    my $location = shift;
    my $classIDX = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($location, $classIDX);
    my %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};

    foreach $teamIDX (sort keys %TEAMS){
        my $score = &_calculateOverallPaperByTeam($teamIDX,1);
        $score += &_calculateOverallPaperByTeam($teamIDX,2);
        $score += &_calculateOverallPaperByTeam($teamIDX,3);
        $score += &_calculateOverallPaperByTeam($teamIDX,4);
        my $late =  &_calculateLatePenalty($teamIDX);
        $TEAMS{$teamIDX}{IN_LATE} = $late;
        $TEAMS{$teamIDX}{IN_SORT} = $score - $late;
        if ($late > $score){
            $TEAMS{$teamIDX}{IN_OVERALL} = 0;
        } else {
            $TEAMS{$teamIDX}{IN_OVERALL} = $score - $late;
        }
        
        # print "\$teamIDX = $teamIDX, \$score=$TEAMS{$eamIDX}{IN_OVERALL}\n";
    }
    return(\%TEAMS) ;
}
# sub _getOverallDesignResults(){
#     my $self=shift;
#     my $location = shift;
#     my $classIDX = shift;
#     my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
#     my $select = $dbi->prepare( $SQL );
#       $select->execute($location, $classIDX);
#     my %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};

#     foreach $teamIDX (sort keys %TEAMS){
#         my $score = &_calculateOverallPaperByTeam($teamIDX,1);
#         $score += &_calculateOverallPaperByTeam($teamIDX,2);
#         $score += &_calculateOverallPaperByTeam($teamIDX,3);
#         $score += &_calculateOverallPaperByTeam($teamIDX,4);
#         my $late =  &_calculateLatePenalty($teamIDX);
#         $TEAMS{$teamIDX}{IN_LATE} = $late;
#         if ($late > $score){
#             $TEAMS{$teamIDX}{IN_OVERALL} = 0;
#         } else {
#             $TEAMS{$teamIDX}{IN_OVERALL} = $score - $late;
#         }
        
#         # print "\$teamIDX = $teamIDX, \$score=$TEAMS{$eamIDX}{IN_OVERALL}\n";
#     }
#     return(\%TEAMS) ;
# }
sub _getPublishedFridayResults(){
    my $self = shift;
    my $classIDX = shift;
    my $location = shift;
    my $tileIDX = shift;
    my $SQL = "SELECT TX_FILE FROM TB_PUBLISH WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=? AND FK_TILES_IDX=? AND IN_SHOW=?";
    my $select = $dbi->prepare($SQL);
      $select->execute($location, $classIDX, $tileIDX, 1);
    my ($txFile) = $select->fetchrow_array();
    if ($txFile){
        return ($txFile);
    } else {
        return ();
    }
    
}
##============== PRESO =======================================================
sub _getListOfAdmins(){
    my $self = shift;
    my $SQL = "SELECT PK_USER_IDX FROM TB_USER WHERE IN_USER_TYPE>=?";
    my $select = $dbi->prepare($SQL);
       $select -> execute(4);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
}
sub _getUserInitials(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "SELECT PK_USER_IDX, TX_FIRST_NAME, TX_LAST_NAME FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
      $select -> execute($userIDX);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    # my ($txFirst, $txLast) = $select->fetchrow_array() || die "Cannot Fetch Row $!";
    my $txInitials = sprintf "%s%s", substr($HASH{$userIDX}{TX_FIRST_NAME},0,1), substr($HASH{$userIDX}{TX_LAST_NAME},0,1);
    return ($txInitials);
}
sub _getPresenationScoreByCard(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
    WHERE PAPER.FK_CARD_IDX=?";
    # my $SQL = "SELECT USER.TX_FIRST_NAME, USER.TX_LAST_NAME, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS
    # FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
    # JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX
    # JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX
    # WHERE PAPER.FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select -> execute($cardIDX);
    my ($score) = $select->fetchrow_array() || die "Cannot Fetch Row $!";
    return ($score);
}
sub _getAllPresoScoreByEvent(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    # my $SQL = "SELECT CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    # FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
    # JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX
    # JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
    # WHERE (SECTION.FK_CARDTYPE_IDX=? AND CARD.FK_EVENT_IDX=?)
    # GROUP BY CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX";
    my $SQL = "SELECT USER.TX_FIRST_NAME, USER.TX_LAST_NAME, CARD.FK_USER_IDX, CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
    JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX
    JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
    JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX
    WHERE (SECTION.FK_CARDTYPE_IDX=? AND CARD.FK_EVENT_IDX=?)
    GROUP BY CARD.FK_USER_IDX, CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX ";

    my $select = $dbi->prepare($SQL);
       $select -> execute($cardTypeIDX, $location);
    %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','FK_CARD_IDX'])};
    return (\%HASH);
}
sub _getCardOwner(){
    my ($self, $eventIDX, $cardtypeIDX) = @_;
    my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX FROM TB_CARD WHERE FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select -> execute($eventIDX, $cardtypeIDX);
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')};
    return (\%HASH);
}
sub _getAllPresoScoreByTeamIDX(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    my @SCORES = ();
    my $SQL = "SELECT CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
    JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX
    JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
    WHERE (SECTION.FK_CARDTYPE_IDX=? AND CARD.FK_EVENT_IDX=? AND CARD.FK_TEAM_IDX=?)
    GROUP BY CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($cardTypeIDX, $location, $teamIDX);
    while (my ($teamIDX, $cardIDX, $inPoints) = $select->fetchrow_array()) {
        push (@SCORES, $inPoints);
    }
    $averageScore = &_getAverage(@SCORES);
    # %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','FK_CARD_IDX'])};
    return ($averageScore);
}
sub _getAveragePresoScoreByEvent(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    my $SQL = "SELECT CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
    JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX
    JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
    WHERE (SECTION.FK_CARDTYPE_IDX=? AND CARD.FK_EVENT_IDX=?)
    GROUP BY CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($cardTypeIDX, $location);
    while (my ($teamIDX, $cardIDX, $inPoints) = $select->fetchrow_array()) {
        push (@$teamIDX, $inPoints);
        $TEAMS{$teamIDX}{PK_TEAM_IDX} = $teamIDX;
    }
    foreach $teamIDX (sort {$a<=>$b} keys %TEAMS){
        # $TEAMS{$teamIDX}{IN_AVERAGE} = &_getAverage(@$teamIDX);
        $TEAMS{$teamIDX}{IN_AVERAGE} = mean(@$teamIDX);
        $TEAMS{$teamIDX}{IN_MAX} = max(@$teamIDX);
        $TEAMS{$teamIDX}{IN_MIN} = min(@$teamIDX);
        $TEAMS{$teamIDX}{IN_STD} = stddev(@$teamIDX);
    }
    return (\%TEAMS);
}
sub _getPresoScoreByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my $score = &_calculatePresoScoreByTeam($teamIDX, $cardTypeIDX);
    return ($score);
}
sub _getOverallPresoResults(){
    my $self=shift;
    my $location = shift;
    my $classIDX = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($location, $classIDX);
    my %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    foreach $teamIDX (sort keys %TEAMS){
        my $score = &_calculatePresoScoreByTeam($teamIDX,5);
        $TEAMS{$teamIDX}{IN_OVERALL} = $score;
        # print "\$teamIDX = $teamIDX, \$score=$TEAMS{$teamIDX}{IN_OVERALL} \n";
    }
    return(\%TEAMS);
}
## ============== MICRO CLASS DEMO ===================================================
sub _getMicroDemoScore(){
    my $self = shift;
    my $inSeconds = shift;
    my $score = &_calculcateDemoScore($inSeconds);
    return ($score);
}
sub _getMicroDemoScoreByEvent(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT PK_TEAM_IDX, IN_SECONDS FROM TB_TEAM WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($location, 3);
    %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    foreach $teamIDX (keys %HASH){
        if ($HASH{$teamIDX}{IN_SECONDS} > 0){
            $SCORE{$teamIDX} = &_calculcateDemoScore($HASH{$teamIDX}{IN_SECONDS});
        } else {
            $SCORE{$teamIDX} = 0;
        }
    }
    return (\%SCORE);
}
sub _getFlightScore(){
    my $self = shift;
    my $payload = shift;
    my $empty = shift;
    my $score = _calculateFlightScore($payload,$empty);
}
sub _getScoreCard(){
    my $location = shift;
    my $classIDX = shift;
    my $SQL = "SELECT FLIGHT.*, TEAM.IN_SECONDS FROM TB_FLIGHT AS FLIGHT JOIN TB_TEAM AS TEAM ON FLIGHT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location,$classIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_FLIGHT_IDX'])};
    return (\%HASH);
}
sub _getTeamFlgihtScoresByClass(){
    my $self = shift;
    my $location = shift;
    my $classIDX = shift;
    my $inRound = shift;
    my $Ref = new SAE::REFERENCE();
    my %TEAMS = %{$Ref->_getTeamDataByClass($location,$classIDX)};
    my %CARDS = %{&_getScoreCard($location,$classIDX)};
    my %RANK = ();
    my $fs=0;
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $roundCount = 1;
        my $demo = 0;
        my $inSeconds = 0;
        foreach $flightIDX (sort {$CARDS{$teamIDX}{$a}{IN_ROUND} <=> $CARDS{$teamIDX}{$b}{IN_ROUND}} keys %{$CARDS{$teamIDX}}) {
            if ($roundCount > $inRound){last}
            my $payload = $CARDS{$teamIDX}{$flightIDX}{IN_WEIGHT};
            my $empty = $CARDS{$teamIDX}{$flightIDX}{IN_EMPTY};
            my $inMinor = $CARDS{$teamIDX}{$flightIDX}{IN_PEN_MINOR};
            my $inLanding = $CARDS{$teamIDX}{$flightIDX}{IN_PEN_LANDING};
            my $rawfs = &_calculateFlightScore($payload, $empty);
            $fs = &_calculatePenInfractions($rawfs, $inMinor, $inLanding );

            $inSeconds = $CARDS{$teamIDX}{$flightIDX}{IN_SECONDS};
            push (@$teamIDX, $fs);
            $roundCount++;
        }
        if ($inSeconds > 0){
            $demo = &_calculcateDemoScore($inSeconds);
        }
        my $avg = 0;
        if ($inRound>0){
            $avg =  (sum(@$teamIDX)/$inRound);
        } 
        
        my $max = max(@$teamIDX);
        # print "$TEAMS{$teamIDX}{IN_NUMBER}, \$avg = $avg, \$max=$max, \$demo=$demo<br>";
        $TEAMS{$teamIDX}{IN_SCORE} = &_calculateRoundScore($avg, $max, $demo);
        $TEAMS{$teamIDX}{IN_OVERALL} = &_calculateRoundScore($avg, $max, $demo);
        $TEAMS{$teamIDX}{IN_DEMO} = $demo;
        @$teamIDX = ();
    }
    return (\%TEAMS);
}
sub _getTeamFlightScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT FLIGHT.*, TEAM.IN_SECONDS FROM TB_FLIGHT AS FLIGHT JOIN TB_TEAM AS TEAM ON FLIGHT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE TEAM.PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %CARDS = %{$select->fetchall_hashref('PK_FLIGHT_IDX')};
    my %RANK = ();
    my @team = ();
    foreach $flightIDX (sort {$CARDS{$a}{IN_ROUND} <=> $CARDS{$b}{IN_ROUND}} keys %CARDS) {
        my $demo = 0;
        my $inRound = $CARDS{$flightIDX}{IN_ROUND};
        my $payload = $CARDS{$flightIDX}{IN_WEIGHT};
        my $empty = $CARDS{$flightIDX}{IN_EMPTY};
        my $inSeconds = $CARDS{$flightIDX}{IN_SECONDS};
        my $inMinor = $CARDS{$flightIDX}{IN_PEN_MINOR};
        my $inLanding = $CARDS{$flightIDX}{IN_PEN_LANDING};
        $raw = &_calculateFlightScore($payload, $empty);
        $fs = &_calculatePenInfractions($raw, $inMinor, $inLanding );
        if ($inSeconds > 0){
            $demo = &_calculcateDemoScore($inSeconds);
        }
        push (@team, $fs);
        my $avg = 0;
        if ($inRound>0){
            $avg = (sum(@team)/$inRound);
        }
        my $max = max(@team);
        $RANK{$inRound}{IN_PAYLOAD} = $payload;
        $RANK{$inRound}{IN_EMPTY} = $empty;
        $RANK{$inRound}{IN_AVG} = $avg;
        $RANK{$inRound}{IN_MAX} = $max;
        $RANK{$inRound}{IN_FLIGHT} = $fs;
        $RANK{$inRound}{IN_DEMO} = $demo;
        $RANK{$inRound}{IN_SCORE} =&_calculateRoundScore($avg, $max, $demo);
    }
    return (\%RANK);
}
sub _getMicroFlightScoreByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    %MAX = %{&_getMaxRound($location)};
    my $SQL = "SELECT FLIGHT.PK_FLIGHT_IDX, FLIGHT.IN_ROUND, FLIGHT.IN_WEIGHT, FLIGHT.IN_EMPTY, TEAM.IN_SECONDS, FLIGHT.IN_PEN_MINOR, FLIGHT.IN_PEN_LANDING
        FROM TB_FLIGHT AS FLIGHT 
        JOIN TB_TEAM AS TEAM ON FLIGHT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE TEAM.PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %CARDS = %{$select->fetchall_hashref('IN_ROUND')};
    my @team = ();
    my $avg = 0;
    my $max = 0;
    my $inMax = $MAX{3}{IN_ROUND};
    my $maxKey = max (keys %CARDS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    my $demo = 0;
    # print "\$inMax = $inMax";
    # foreach $inRound (sort {$CARDS{$a}{IN_ROUND} <=> $CARDS{$b}{IN_ROUND}} keys %CARDS) {
    for (my $i=1; $i<=$inMax; $i++){
        my $inRound = $i;
        my $payload = $CARDS{$i}{IN_WEIGHT};
        my $empty = $CARDS{$i}{IN_EMPTY};
        my $inSeconds = $CARDS{$i}{IN_SECONDS};
        my $inMinor = $CARDS{$i}{IN_PEN_MINOR};
        my $inLanding = $CARDS{$i}{IN_PEN_LANDING};
        $inRaw = &_calculateFlightScore($payload, $empty);
        $fs = &_calculatePenInfractions($inRaw, $inMinor, $inLanding);
        if ($inSeconds > 0){
            $demo = &_calculcateDemoScore($inSeconds);
        }
        push (@team, $fs);
        # print "\$fs = $fs<br>";
    }
     my $avg = 0;
    if ($inMax>0){
        $avg = (sum(@team)/$inMax);
    }
    my $max = max(@team);
    # print "\$max = $max<br>";
    my $score = &_calculateRoundScore($avg, $max, $demo);
    # return ($score);
    return ($score, $avg, $max, $demo);

}
sub _getFlightLogs(){
    my $teamIDX = shift;
    my $SQL = "SELECT F.*, T.FK_CLASS_IDX, T.FK_EVENT_IDX 
        FROM TB_FLIGHT AS F JOIN TB_TEAM AS T ON F.FK_TEAM_IDX=T.PK_TEAM_IDX 
        WHERE F.FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    return (\%HASH);
}
sub _getMicroFlightLogs(){
    my $self = shift;
    my $teamIDX =shift;
    my $location = shift;
    my %LOGS = %{&_getFlightLogs($teamIDX)};
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{3}{IN_ROUND};
    my $maxKey = max (keys %LOGS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    my $inRaw=0;
    my %HASH=();
    for (my $i=1; $i<=$inMax; $i++){
        $payload = $LOGS{$i}{IN_WEIGHT};
        $empty = $LOGS{$i}{IN_EMPTY};
        $HASH{$i}{IN_PAYLOAD} = $payload;
        $HASH{$i}{IN_EMPTY} = $empty;
        print "$payload, $empty: ";
        $inRaw = &_calculateFlightScore($payload, $empty);
        print "($inRaw) --- ";
        $HASH{$i}{IN_RAW} = $inRaw;
        $inScore = &_calculatePenInfractions($inRaw, $LOGS{$i}{IN_PEN_MINOR}, $LOGS{$i}{IN_PEN_LANDING} );
        $HASH{$i}{IN_SCORE}  = $inScore ;
        $HASH{$i}{IN_PEN_MINOR}  = $LOGS{$i}{IN_PEN_MINOR};
        $HASH{$i}{IN_PEN_LANDING}  = $LOGS{$i}{IN_PEN_LANDING} ;
        # print "\$inRound  = $inRound, \$maxKey =$maxKey, \$inMax=$inMax \n";
    }
    return (\%HASH);
}
# CALCULATIONS =================================================================
sub testMicro(){
    my $self = shift;
    my $p = shift;
    my $e = shift;
    print &_calculateFlightScore($p, $e);
}
sub _calculatePenInfractions(){
    my $inScore = shift;
    my $inMinor = shift;
    my $inLanding = shift;
    my $mult = 0;
    if ($inMinor==1 && $inLanding==1){
        $mult = .75;
    } elsif ($inMinor==0 && $inLanding==1){
        $mult = .50;
    } elsif ($inMinor==1 && $inLanding==0) {
        $mult = .25;
    } else {
        $mult = 0;
    }
    # print "\$mult = $mult\n";
    my $score=$inScore * (1-$mult);
    return ($score);
}
sub _calculateFlightScore(){
    my ($payload, $empty) = @_;
    my $score;
    # print "\$payload=$payload, \$empty=$empty";
    if ($payload == 0 || $payload == '' || $empty == 0 || $empty == '' ){
        $score = 0;
    } else {
        $score = $payload/sqrt($empty);
    }
    return ($score);
}
sub _calculateRoundScore(){
    my ($avg, $max, $demo) = @_;
    my $score = 20 *(($avg/2) + ($max/2)) + $demo ;
    return ($score);
}
sub _calculcateDemoScore(){
    my $inSeconds = shift;
    my $score = 0;
    if ($inSeconds<=180){
        $score = 5 * (2-($inSeconds/60))**3;
    } else {
        $score = -5;
    }
    return ($score);
}
## ============== ADVANCED CLASS ================================================
sub _getAdvancedScoreByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %MAX = %{&_getMaxRound($location)};
    my $inRound = $MAX{2}{IN_ROUND};
    my $score = &_calculateAdvancedScoresByTeam($teamIDX, $location, $inRound);
    # print "\n$teamIDX, $location, $inRound\n";
    return ($score);
}
sub _getAdvacnedFlightByTeam(){
    my $teamIDX = shift;
    my $location = shift;
    my %MAX = %{&_getMaxRound($location)};
    my $inRound = $MAX{2}{IN_ROUND};
    
    my $SQL = "SELECT FK_TEAM_IDX, SUM(IN_WEIGHT) AS IN_WEIGHT, SUM(IN_COLONIST) AS IN_COLONIST, SUM(IN_HABITAT) AS IN_HABITAT, SUM(IN_WATER) AS IN_WATER FROM TB_FLIGHT
        WHERE (IN_ROUND <=? AND FK_TEAM_IDX=?)
        GROUP BY FK_TEAM_IDX";
    # my $SQL = "SELECT FK_TEAM_IDX, SUM(IN_WEIGHT) AS IN_WEIGHT, SUM(IN_COLONIST) AS IN_COLONIST, SUM(IN_HABITAT) AS IN_HABITAT, SUM(IN_WATER) AS IN_WATER FROM TB_FLIGHT AS FLIGHT
    #     JOIN TB_TEAM AS TEAM ON FLIGHT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    #     WHERE (IN_ROUND <=5 AND TEAM.FK_EVENT_IDX=25 AND TEAM.FK_CLASS_IDX=2)
    #     GROUP BY FLIGHT.FK_TEAM_IDX";
    my $select = $dbi->prepare($SQL);
       $select->execute($inRound, $teamIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    # print scalar (keys %HASH)."\n\n";
    return (\%HASH);
}
sub _getAdvancedFlightsByEvent(){
    my $self = shift;
    my $location = shift;
    my $inRound = shift;
    my $classIDX = shift;
    my $Ref = new SAE::REFERENCE();
    my %TEAMS = %{$Ref->_getTeamDataByClass($location,$classIDX)};
    # my $SQL = "SELECT FK_TEAM_IDX, SUM(IN_WEIGHT) AS IN_WEIGHT, SUM(IN_COLONIST) AS IN_COLONIST, SUM(IN_HABITAT) AS IN_HABITAT, SUM(IN_WATER) AS IN_WATER FROM TB_FLIGHT AS FLIGHT
    #     JOIN TB_TEAM AS TEAM ON FLIGHT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    #     WHERE (IN_ROUND <=? AND TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=?)
    #     GROUP BY FLIGHT.FK_TEAM_IDX";
    # my $select = $dbi->prepare($SQL);
    #    $select->execute($inRound, $location, $classIDX);
    # my %FLIGHTS = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    # print scalar (keys %HASH);
    my %RANK = ();
    foreach $teamIDX (sort keys %TEAMS){
        my $score = &_calculateAdvancedScoresByTeam($teamIDX, $location, $inRound);
        $TEAMS{$teamIDX}{IN_SCORE}=$score;
        $TEAMS{$teamIDX}{IN_OVERALL}=$score;
    }
    return (\%TEAMS);
}
sub _getAdvancedFlightComponents(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %HASH = %{&_getAdvacnedFlightByTeam($teamIDX, $location)};
    return (\%HASH);

}
sub _getMaxRounds(){
    my $self = shift;
    my $location = shift;
    my $classIDX = shift;
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{$classIDX}{IN_ROUND};
    return ($inMax);
}
sub _getAdvancedFlightLogs(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %LOGS = %{&_getFlightLogs($teamIDX)};
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{2}{IN_ROUND};
    print $inMax;
    my $maxKey = max (keys %LOGS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    my $c=0;
    my $h=0;
    my $w=0;
    my $s=0;
    my %HASH=();
    for (my $i=1; $i<=$inMax; $i++){
        my $raw_colonist = $LOGS{$i}{IN_COLONIST};
        my $raw_habitat = $LOGS{$i}{IN_HABITAT};
        my $raw_water = $LOGS{$i}{IN_WATER};
        my $raw_suppy = $LOGS{$i}{IN_WEIGHT};
        
        my $inMinor = $LOGS{$i}{IN_PEN_MINOR};
        my $inLanding = $LOGS{$i}{IN_PEN_LANDING};
        
        my $fsColonist = &_calculatePenInfractions($raw_colonist, $inMinor, $inLanding );
        my $fsHabitat = &_calculatePenInfractions($raw_habitat, $inMinor, $inLanding );
        my $fsWater = &_calculatePenInfractions($raw_water, $inMinor, $inLanding );
        my $fsSupply = &_calculatePenInfractions($raw_suppy, $inMinor, $inLanding );
        
        $c += $fsColonist;
        $h += $fsHabitat;
        $w += $fsWater;
        $s += $fsSupply;
        
        $HASH{$i}{FS_COLONIST} = $fsColonist;
        $HASH{$i}{FS_HABITAT} = $fsHabitat;
        $HASH{$i}{FS_WATER} = $fsWater;
        $HASH{$i}{FS_WEIGHT} = $fsSupply;
        
        $HASH{$i}{RAW_COLONIST} = $raw_colonist;
        $HASH{$i}{RAW_HABITAT} = $raw_habitat;
        $HASH{$i}{RAW_WATER} = $raw_water;
        $HASH{$i}{RAW_WEIGHT} = $raw_suppy;
        
        $txMinor = '-';
        $txLanding = '-';
        if ($LOGS{$i}{IN_PEN_MINOR}>0) {$txMinor = 'Yes';}
        if ($LOGS{$i}{IN_PEN_LANDING}>0) {$txLanding = 'Yes';}
        $HASH{$i}{IN_PEN_MINOR} = $txMinor;
        $HASH{$i}{IN_PEN_LANDING} = $txLanding;

    }
    # $HASH{0}{TOT_COLONIST} = $c;
    # $HASH{0}{TOT_HABITAT} = $h;
    # $HASH{0}{TOT_WATER} = $w;
    # $HASH{0}{TOT_WEIGHT} = $s;
    my $ffs = 0;
    my $days = &_calculateDays($c, $h, $w);
    if ($inMax>0){
        $ffs = ( $c * $days ) / ( 15 * $inMax) + ( 2 * $s) / $inMax;    
    }
    
    # print "$c, $h, $w, $s, $days, $inMax, $ffs\n";
    return (\%HASH);
}
sub _getAdvancedFinalCalculations(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my $colonist = shift;
    my $habitat = shift;
    my $water = shift;
    my $supply = shift;
    
    my %LOGS = %{&_getFlightLogs($teamIDX)};
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{2}{IN_ROUND};
    my $maxKey = max (keys %LOGS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    
    my $ffs = 0;
    my $days = &_calculateDays($colonist, $habitat, $water);
    if ($inMax>0){
        $ffs = ( $colonist * $days ) / ( 15 * $inMax) + ( 2 * $supply) / $inMax;
    }
    # print "\$colonist = $colonist, \$habitat = $habitat, \$water = $water,  \$supply = $supply,  \$days = $days,  \$ffs = $ffs, \$inMax = $inMax ";
    return ($days, $ffs);
}
## ============== ADVANCED CLASS CALCULATIONS ===================================
sub _calculateAdvancedScoresByTeam(){
    # my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %LOGS = %{&_getFlightLogs($teamIDX)};
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{2}{IN_ROUND};
    my $maxKey = max (keys %LOGS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    my $c=0;
    my $h=0;
    my $w=0;
    my $s=0;
    my %HASH=();
    for (my $i=1; $i<=$inMax; $i++){
        my $raw_colonist = $LOGS{$i}{IN_COLONIST};
        my $raw_habitat = $LOGS{$i}{IN_HABITAT};
        my $raw_water = $LOGS{$i}{IN_WATER};
        my $raw_suppy = $LOGS{$i}{IN_WEIGHT};
        
        my $inMinor = $LOGS{$i}{IN_PEN_MINOR};
        my $inLanding = $LOGS{$i}{IN_PEN_LANDING};
        
        my $fsColonist = &_calculatePenInfractions($raw_colonist, $inMinor, $inLanding );
        my $fsHabitat = &_calculatePenInfractions($raw_habitat, $inMinor, $inLanding );
        my $fsWater = &_calculatePenInfractions($raw_water, $inMinor, $inLanding );
        my $fsSupply = &_calculatePenInfractions($raw_suppy, $inMinor, $inLanding );
        
        $c += $fsColonist;
        $h += $fsHabitat;
        $w += $fsWater;
        $s += $fsSupply;

    }
    my $days = &_calculateDays($c, $h, $w);
    my $ffs = 0;
    if ($inMax > 0){
        $ffs = ( $c * $days ) / ( 15 * $inMax) + ( 2 * $s) / $inMax;
    }
    # print "$c, $h, $w, $s, $days, $inMax, $ffs\n";
    return ($ffs);

}
sub _calculateDays(){
    my $inColonist = shift;
    my $inHabitat = shift;
    my $inWater = shift;
    my $days = 0;
    my $max = 0;
    if ($inHabitat == 0 || $inWater == 0) {
        $days = 0;
    } else {
        $max = $inColonist/(8*$inHabitat);
        if (($inColonist/$inWater) > $max ) {$max = ($inColonist/$inWater)}
        # print "max = $max\n";
        $days = 25*(2**(1-$max));
    }

    return ($days);
}
## ============== REGULAR CLASS =================================================
sub _getRegularFlights(){
    # my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT F.*, T.IN_SLOPE, T.IN_YINT, T.FK_CLASS_IDX, T.FK_EVENT_IDX, T.IN_NUMBER, T.TX_SCHOOL, W.IN_TEMP, W.IN_PRES, W.IN_DENSITY, W.IN_ELEVATION, W.TS_LOCAL FROM TB_FLIGHT AS F
    	JOIN TB_TEAM AS T ON F.FK_TEAM_IDX=T.PK_TEAM_IDX
        JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX
        WHERE F.FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    return (\%HASH);
}
sub _getRegularFlightLog(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %LOGS = %{&_getRegularFlights($teamIDX)};
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{1}{IN_ROUND};
    my $maxKey = max (keys %LOGS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    my %HASH = ();
    

    
    for (my $i=1; $i<=$inMax; $i++){
        my $tof = $LOGS{$i}{TS_LOCAL};
        my $inLCargo = $LOGS{$i}{IN_LCARGO};
        my $inBalls = $LOGS{$i}{IN_SPHERE};
        my $inPayload = $LOGS{$i}{IN_WEIGHT};
        my $inSpan = $LOGS{$i}{IN_SPAN};
        my $inMinor = $LOGS{$i}{IN_PEN_MINOR};
        my $inLanding = $LOGS{$i}{IN_PEN_LANDING};
        my $inSlope =  $LOGS{$i}{IN_SLOPE};
        my $inYint =  $LOGS{$i}{IN_YINT};
        my $inEle =  $LOGS{$i}{IN_ELEVATION};
        my $inDen =  $LOGS{$i}{IN_DENSITY};
        my $actPayload = $inPayload + (0.9375 * $inBalls);
        my $rawPBB = &_calculatePPB($inSlope, $inYint, $inDen, $inEle, $actPayload);
        my $ppb = &_calculatePenInfractions($rawPBB, $inMinor, $inLanding );
        
        my $num = ((2 * $inBalls) + $inPayload);
        my $dem = ($inSpan + $inLCargo);
        my $rawFs = 0;
        if ($dem > 0){
            $rawFs = 120 * ($num / $dem);
        }
        my $fs = &_calculatePenInfractions($rawFs, $inMinor, $inLanding );
        $HASH{$i}{IN_FS} = $fs;
        $HASH{$i}{IN_PPB} = $ppb;
        $HASH{$i}{TS_TIME} = $tof;
        $HASH{$i}{IN_LCARGO} = $inLCargo;
        $HASH{$i}{IN_SPHERE} = $inBalls;
        $HASH{$i}{IN_WEIGHT} = $inPayload;
        $HASH{$i}{IN_SPAN} = $inSpan;
        $HASH{$i}{RAW_FS} = $rawFs;
        $HASH{$i}{RAW_PPB} = $rawPBB;
        $HASH{$i}{IN_DENSITY} =  ($inDen);
        # $HASH{$i}{IN_DENSITY} =  ($inDen + $inEle);
        $txMinor = '-';
        $txLanding = '-';
        if ($inMinor>0) {$txMinor = 'Yes';}
        if ($inLanding>0) {$txLanding = 'Yes';}
        $HASH{$i}{IN_PEN_MINOR} = $txMinor;
        $HASH{$i}{IN_PEN_LANDING} = $txLanding;
        $HASH{$i}{IN_PPB} = $ppb;
    }
    return (\%HASH);
    
}
sub _getRegularFinalFlightScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my %LOGS = %{&_getRegularFlights($teamIDX)};
    my %MAX = %{&_getMaxRound($location)};
    my $inMax = $MAX{1}{IN_ROUND};
    my $maxKey = max (keys %LOGS);
    if ($maxKey > $inMax){$inMax = $maxKey}
    my %SCORES = ();
    for (my $i=1; $i<=$inMax; $i++){
        my $tof = $LOGS{$i}{TS_LOCAL};
        my $inLCargo = $LOGS{$i}{IN_LCARGO};
        my $inBalls = $LOGS{$i}{IN_SPHERE};
        my $inPayload = $LOGS{$i}{IN_WEIGHT};
        my $inSpan = $LOGS{$i}{IN_SPAN};
        my $inMinor = $LOGS{$i}{IN_PEN_MINOR};
        my $inLanding = $LOGS{$i}{IN_PEN_LANDING};
        my $inSlope =  $LOGS{$i}{IN_SLOPE};
        my $inYint =  $LOGS{$i}{IN_YINT};
        my $inEle =  $LOGS{$i}{IN_ELEVATION};
        my $inDen =  $LOGS{$i}{IN_DENSITY};
        my $actPayload = $inPayload + (0.9375 * $inBalls);
        my $rawPBB = &_calculatePPB($inSlope, $inYint, $inDen, $inEle, $actPayload);
        my $ppb = &_calculatePenInfractions($rawPBB, $inMinor, $inLanding );
        
        my $num = ((2 * $inBalls) + $inPayload);
        my $dem = ($inSpan + $inLCargo);
        my $rawFs = 0;
        if ($dem > 0){
            $rawFs = 120 * ($num / $dem);
        }
        my $fs = &_calculatePenInfractions($rawFs, $inMinor, $inLanding );
        $SCORES{$i}{IN_FS} = $fs;
        $SCORES{$i}{IN_PPB} = $ppb;
    }
    push (@FS, sort {$SCORES{$b}{IN_FS} <=> $SCORES{$a}{IN_FS}} keys %SCORES);
    my $maxPPB = 0;
    my $ffs = 0;
    for ($i=0; $i<=2; $i++){
        my $inRound = $FS[$i];
        if ($SCORES{$inRound}{IN_PPB} > $maxPPB){$maxPPB = $SCORES{$inRound}{IN_PPB}}
        $ffs += $SCORES{$inRound}{IN_FS};
        # print "\$ffs=$ffs\n";
    }
    $t3ffs = $ffs;
    $ffs +=  $maxPPB;
    # print "\$teamIDX=$teamIDX, \$location=$location\tResults = ".join(", ", @FS)."\t\$maxPPB=$maxPPB, \$ffs=$ffs\n";
    
    # print "$maxPPB\n";
    return ($ffs, $maxPPB, $SCORES{$FS[0]}{IN_FS},$SCORES{$FS[1]}{IN_FS},$SCORES{$FS[2]}{IN_FS}, $t3ffs);
}
sub _getRegularFlightsByEvent(){
    my $self = shift;
    my $location = shift;
    my $inRound = shift;
    my $classIDX = shift;
    my $Ref = new SAE::REFERENCE();
    my %TEAMS = %{$Ref->_getTeamDataByClass($location,$classIDX)};
    # print scalar (keys %HASH);
    foreach $teamIDX (sort keys %TEAMS){
        my $score = &_calculateRegularFlightScore($teamIDX, $inRound);
        $TEAMS{$teamIDX}{IN_OVERALL}=$score;
        # print "$teamIDX\t=$score\n";
    }
    # print "\n\n";
    return (\%TEAMS);
}
## ============== REGULAR CALCULATION =================================================
sub _calculateRegularFlightScore(){
    my $teamIDX = shift;
    my $inRound = shift;
    my %LOGS = %{&_getRegularFlights($teamIDX)};
    my %SCORES = ();

    my @FS=();
    for (my $i=1; $i<=$inRound; $i++){
        my $tof = $LOGS{$i}{TS_LOCAL};
        my $inLCargo = $LOGS{$i}{IN_LCARGO};
        my $inBalls = $LOGS{$i}{IN_SPHERE};
        my $inPayload = $LOGS{$i}{IN_WEIGHT};
        my $inSpan = $LOGS{$i}{IN_SPAN};
        my $inMinor = $LOGS{$i}{IN_PEN_MINOR};
        my $inLanding = $LOGS{$i}{IN_PEN_LANDING};
        my $inSlope =  $LOGS{$i}{IN_SLOPE};
        my $inYint =  $LOGS{$i}{IN_YINT};
        my $inEle =  $LOGS{$i}{IN_ELEVATION};
        my $inDen =  $LOGS{$i}{IN_DENSITY};
        my $actPayload = $inPayload + (0.9375 * $inBalls);
        my $rawPBB = &_calculatePPB($inSlope, $inYint, $inDen, $inEle, $actPayload);
        my $ppb = &_calculatePenInfractions($rawPBB, $inMinor, $inLanding );
        
        my $num = ((2 * $inBalls) + $inPayload);
        my $dem = ($inSpan + $inLCargo);
        my $rawFs = 0;
        if ($dem > 0){
            $rawFs = 120 * ($num / $dem);
        }
        # print "$teamIDX = $rawFs\t\$num=$num, \$dem=$dem, \$inBalls=$inBalls\n";
        my $fs = &_calculatePenInfractions($rawFs, $inMinor, $inLanding );
        # print "$fs\n";
        $SCORES{$i}{IN_FS} = $fs;
        $SCORES{$i}{IN_PPB} = $ppb;
    }
    push (@FS, sort {$SCORES{$b}{IN_FS} <=> $SCORES{$a}{IN_FS}} keys %SCORES);
    my $maxPPB = 0;
    my $ffs = 0;
    # print "$teamIDX:\n";
    for ($i=0; $i<=2; $i++){
        my $inRound = $FS[$i];
        # print "$inRound\t";
        if ($SCORES{$inRound}{IN_PPB} > $maxPPB){$maxPPB = $SCORES{$inRound}{IN_PPB}}
        # print "$SCORES{$inRound}{IN_FS}\n";
        $ffs += $SCORES{$inRound}{IN_FS};
        # print "($inRound)\t\$ffs=$ffs\n";
    }
    # print "\n\n";
    $t3ffs = $ffs;
    $ffs +=  $maxPPB;
    # print "\$teamIDX=$teamIDX, \$location=$location\tResults = ".join(", ", @FS)."\t\$maxPPB=$maxPPB, \$ffs=$ffs\n";
    # print "\$teamIDX($teamIDX) = $ffs\n";
    # print "$maxPPB\n";
    return ($ffs);
    # return ($ffs, $maxPPB, $SCORES{$FS[0]}{IN_FS},$SCORES{$FS[1]}{IN_FS},$SCORES{$FS[2]}{IN_FS}, $t3ffs);
}
sub _calculatePPB(){
    my $slope = shift;
    my $yInt = shift;
    my $den = shift;
    my $ele = shift;
    my $actual = shift;
    my $predicted = ($slope*($ele + $den)) + $yInt;
    my $PPB = 0;
    if ($actual>0){
        $PPB = 10 - ($actual - $predicted)**2;
    }
    if ($PPB>0){
        return ($PPB);
    } else {
        return (0);
    }
    
}
## ============== PUBLISH (GETTER) ===============================================
sub _getListOfPublishedResults(){
    #----- Updated 2022 by Lonnie Dong ------------------------------
    #  Wanted to provide a new view of the posted results           -
    #  eventIDX = the event Index number in the database            -
    #  Filtered IN_SHOW set to 1 for true to be viewed by public    -
    #----------------------------------------------------------------
    my ($self, $eventIDX ) = @_;
    my $SQL = "SELECT * FROM TB_PUBLISH where (FK_EVENT_IDX=? and IN_SHOW=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute( $eventIDX, 1 );
    my %HASH = %{$select->fetchall_hashref(['TX_TITLE','FK_CLASS_IDX','PK_PUBLISH_IDX'])};
    return (\%HASH);
}
sub _getPublishedListByClass(){
    my $self = shift;
    my $location = shift;
    my $classIDX = shift;
    
    my $SQL = "SELECT * FROM TB_PUBLISH where (FK_EVENT_IDX=? and IN_SHOW=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute( $location, 1, $classIDX  );
    my %HASH = %{$select->fetchall_hashref('PK_PUBLISH_IDX')};
    return (\%HASH);
}
sub _getGeneratedResultsList(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute( $location );
    my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX', 'PK_PUBLISH_IDX'])};
    return (\%HASH);
}
sub _getPublishedList(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute( $location );
    my %HASH = %{$select->fetchall_hashref(['IN_ROUND','FK_TILES_IDX','FK_CLASS_IDX'])};
    return (\%HASH);
}
sub _getTiles(){
    my $SQL = "SELECT * FROM TB_TILES";
    my $select = $dbi->prepare( $SQL ); 
       $select -> execute();
    my %HASH = %{$select->fetchall_hashref('PK_TILES_IDX')};
    return (\%HASH);
}
sub _getPublishedItem(){
    my $self = shift;
    my $txFile = shift;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE TX_FILE=?";
    my $select = $dbi->prepare( $SQL ); 
       $select -> execute( $txFile );
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
}
sub _getLastRound(){
    my $self = shift;
    my $classIDX = shift;
    my $location = shift;
    my $SQL = "SELECT MAX(IN_ROUND) AS IN_LAST_ROUND FROM TB_FLIGHT AS F JOIN TB_TEAM AS T ON F.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE T.FK_EVENT_IDX=? and T.FK_CLASS_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select -> execute($location, $classIDX);
    my $lastRound = $select->fetchrow_array(); #Last recorded Round
    my %MAX = %{&_getMaxRound($location)}; #LAst Publidh Round
    my $inMax = $MAX{$classIDX}{IN_ROUND};
    # print "\$inMax=$inMax, \$lastRound=$lastRound";
    my $maxKey = $lastRound;
    if ($maxKey > $inMax){$inMax = $maxKey}
    return ($inMax);
}
sub _getOverallPublishList(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE FK_EVENT_IDX=? AND FK_TILES_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute( $location, 10 );
    my %HASH = %{$select->fetchall_hashref('FK_CLASS_IDX')};
    return (\%HASH);
}
## ============== PUBLISH INSERT (SETTER) ========================================
sub _publishRound(){
    my $self = shift;
    my $classIDX = shift;
    my $inRound = shift;
    my $inType = shift;
    my $location = shift;
    my %TILES = %{&_getTiles};
    my $Auth = new SAE::Auth();
    my $txFile = $Auth->getTemporaryPassword(64);
    my $txTitle  = $TILES{$inType}{TX_TITLE}." Standings";
    # print "1 = ". $inRound;
    if ($inRound eq ''){$inRound=0}
    # print "2 = ". $inRound;
    # print "\$inType =$inType \n";
    # print "\$location=$location, \$classIDX=$classIDX, \$txTitle=$txTitle, \$txFile=$txFile, \$inRound=$inRound, \$inType=$inType";
    my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_TITLE, TX_FILE, IN_ROUND, FK_TILES_IDX) 
        VALUES (?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($location, $classIDX, $txTitle, $txFile, $inRound, $inType);
    my $newIDX = $insert->{q{mysql_insertid}} || die "Error $@";
    return ($txFile, $newIDX, $txTitle);
}
## ============== PUBLISH UPDATE (SETTER) ========================================
sub _makeScoresPublic(){
    my $self = shift;
    my $txFile = shift;
    my $checked = shift;
    my $SQL = "UPDATE TB_PUBLISH SET IN_SHOW=?, BO_SCORE=? WHERE TX_FILE=?";
    my $update = $dbi->prepare( $SQL );
       $update->execute( 1, $checked, $txFile );
}
sub _updateResultAttribute(){
    my $self = shift;
    my $field = shift;
    my $value = shift;
    my $idx = shift;
    my $SQL = "UPDATE TB_PUBLISH SET $field=? WHERE PK_PUBLISH_IDX=?";
    my $update = $dbi->prepare( $SQL );
       $update->execute($value, $idx);
}
## ============== PUBLISH DELETE =================================================
sub _deletePublishedScore(){
    my $self = shift;
    my $txFile = shift;
    my $SQL = "DELETE FROM TB_PUBLISH WHERE TX_FILE=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute( $txFile );
    return;
}
sub _deletePublishedScoreID(){
    my $self = shift;
    my $idx = shift;
    my $SQL = "DELETE FROM TB_PUBLISH WHERE PK_PUBLISH_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute( $idx );
    return;
}


return (1);

