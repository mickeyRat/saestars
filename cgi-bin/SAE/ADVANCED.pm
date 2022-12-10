package SAE::ADVANCED;

use DBI;
use SAE::SDB;
use SAE::TB_TEAM;
use List::Util qw(sum);
use Math::Trig;

my $dbi = new SAE::Db();
my %TEAM=();
my $dropZoneRadius = 15; # Radius of the Drop Zone

sub new
{
	$className = shift;
	my $location = shift;
	if ($location){
    	my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    	my $select = $dbi->prepare($SQL);
    	   $select->execute($location, 2);
    	%TEAM=%{$select->fetchall_hashref('PK_TEAM_IDX')};
	}
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _getTeamList(){
    my $self = shift;
    return (\%TEAM);
}
sub _average(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
}
# ---------------------------- 2022 --------------------------------------------
sub _calcTeamScore(){
    my ($self, $teamIDX) = @_;
    my %SCORE;
    # print "\$teamIDX = $teamIDX\n";
    my $SQL = "SELECT IN_STD, BO_AUTO, IN_WATER FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my ($inStd, $boAuto, $inWater) = $select->fetchrow_array();   
    $SQL = "SELECT PK_FLIGHT_IDX, IN_ROUND, IN_DISTANCE, BO_APADA, IN_WATER_FLT, IN_PEN_MINOR, IN_PEN_LANDING, BO_INZONE FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    %FLIGHT=%{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    # print "$teamIDX, $inStd, $boAuto, $inWater\n";
    my $waterFlown = 0;
    foreach $flightIDX (sort keys %FLIGHT) {
        
        $SCORE{$flightIDX}{IN_ROUND}=$FLIGHT{$flightIDX}{IN_ROUND}; 
        $SCORE{$flightIDX}{IN_WATER_FLT}=$FLIGHT{$flightIDX}{IN_WATER_FLT}; 
        $SCORE{$flightIDX}{BPADA}=0;
        if ($FLIGHT{$flightIDX}{BO_INZONE}==1) {
            $SCORE{$flightIDX}{BPADA} = &calculateLandingBonus($inStd, $FLIGHT{$flightIDX}{IN_DISTANCE});
        } 
        $SCORE{$flightIDX}{IN_DISTANCE} = $FLIGHT{$flightIDX}{IN_DISTANCE};
        $SCORE{$flightIDX}{IN_PEN_MINOR} = $FLIGHT{$flightIDX}{IN_PEN_MINOR};
        $SCORE{$flightIDX}{IN_PEN_LANDING} = $FLIGHT{$flightIDX}{IN_PEN_LANDING};
        if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}>0){$SCORE{$flightIDX}{IN_MINOR} = 0.25} else {$SCORE{$flightIDX}{IN_MINOR}=0}
        if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}>0){$SCORE{$flightIDX}{IN_MAJOR} = 0.50} else {$SCORE{$flightIDX}{IN_MAJOR}=0}
        $SCORE{$flightIDX}{APADA}=0;
        if ($FLIGHT{$flightIDX}{IN_DISTANCE}<=$dropZoneRadius && $FLIGHT{$flightIDX}{BO_INZONE}==1){
            if ($FLIGHT{$flightIDX}{BO_APADA}<1) {$SCORE{$flightIDX}{APADA}=1.5} else {$SCORE{$flightIDX}{APADA}=0.25};
        }
        $SCORE{$flightIDX}{IN_EFFECTIVE_WATER} = ($FLIGHT{$flightIDX}{IN_WATER_FLT} * (1-$SCORE{$flightIDX}{IN_MINOR}) * (1-$SCORE{$flightIDX}{IN_MAJOR}));
        # $waterFlown += ($FLIGHT{$flightIDX}{IN_WATER_FLT} * (1-$SCORE{$flightIDX}{IN_MINOR}) * (1-$SCORE{$flightIDX}{IN_MAJOR}));
        $waterFlown += $SCORE{$flightIDX}{IN_EFFECTIVE_WATER};
    }
    return ($inStd, $boAuto, $inWater, $waterFlown, \%SCORE);
}

sub _savePerformanceScores(){
    my ($self, $publishIDX, $teamIDX, $inPayload, $inPada, $inFlight) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_PAYLOAD, IN_PADA, IN_FLIGHT) VALUES (?, ?, ?, ?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inPayload, $inPada, $inFlight);
    return;
}
sub _getFlightScores(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_PAYLOAD, IN_PADA, IN_FLIGHT FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}

sub _calcLandingBonus(){
    my ($self, $std, $d) = @_;
    &calculateLandingBonus( $std, $d );
    return ($b);
}

sub calculateLandingBonus(){
    my ($std, $d) = @_;
    if ($d<=$dropZoneRadius){
        if ($std>0){
            my $x = 1/($std*sqrt(2*pi()));
            $b = 5*($x*exp(-($d**2)/(2*$std**2)));
            return ($b);
        } else {
            return (0);
        }
    } else {
        return (0);
    }
}
sub _getTotalWaterDelivered(){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT sum(IN_WATER_FLT) AS IN_TOTAL FROM `TB_FLIGHT` WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my ($inTotal) = $select->fetchrow_array();
    return($inTotal);
}
# ---------------------------- 2021 --------------------------------------------

sub _getTeamList(){
    my $self = shift;
    return (\%TEAM);
}
sub _getTeamFlightScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    my %HASH = %{&getTeamFlightScore($teamIDX, $inRound)};
    return (\%HASH);
}
sub getTeamFlightScore(){
    my $teamIDX = shift;
    my $inRound = shift;
    my $SQL = "SELECT IN_ROUND, IN_COLONIST, IN_HABITAT, IN_WATER, IN_WEIGHT, IN_PEN_MINOR, IN_PEN_LANDING FROM `TB_FLIGHT` where FK_TEAM_IDX=? AND IN_ROUND=?";
    # my $SQL = "SELECT F.IN_ROUND, F.IN_LCARGO, F.IN_SPHERE, F.IN_WEIGHT, F.IN_SPAN, W.IN_DENSITY, F.IN_PEN_MINOR, F.IN_PEN_LANDING FROM TB_FLIGHT AS F JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX where FK_TEAM_IDX=? AND F.IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX, $inRound);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    # my ($inRound, $inColonist, $inHabitat, $inWater, $inPayload, $inMinor, $inMajor) = $select->fetchrow_array();
    # printf "%-5d%5d%10d%10.2f%10d%10d%10d%10d%10d\n", $inRound, $inLCargo, $inBall, $inWeight, $inSpan, $inDen, $inMinor, $inMajor;
    # my ($fs) = &calculateFlightScore($inBall, $inPayload, $inSpan, $inLength, $inMinor, $inMajor);
    # return ($fs);
    return (\%HASH);
}

sub _getTeamScoreCard(){
    my $self = shift;
    my $teamIDX = shift;
    # my $inRound = shift;
    my $SQL = "SELECT IN_ROUND, IN_COLONIST, IN_HABITAT, IN_WATER, IN_WEIGHT, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT where FK_TEAM_IDX=?";
    # my $SQL = "SELECT F.FK_EVENT_IDX, F.FK_TEAM_IDX, F.IN_ROUND, F.IN_LCARGO, F.IN_SPHERE, F.IN_WEIGHT, F.IN_SPAN, W.IN_DENSITY, F.IN_PEN_MINOR, F.IN_PEN_LANDING FROM TB_FLIGHT AS F JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX where FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    foreach $inRound (sort keys %HASH){
        my $inMinor = $HASH{$inRound}{IN_PEN_MINOR};
        my $inMajor = $HASH{$inRound}{IN_PEN_LANDING};
        if ($inMinor>0){$inMinor=.75} else {$inMinor=1}
        if ($inMajor>0){$inMajor=.5} else {$inMajor=1}
        $HASH{$inRound}{IN_COLONIST} = $HASH{$inRound}{IN_COLONIST}*$inMinor*$inMajor;
        $HASH{$inRound}{IN_HABITAT} = $HASH{$inRound}{IN_HABITAT}*$inMinor*$inMajor;
        $HASH{$inRound}{IN_WATER} = $HASH{$inRound}{IN_WATER}*$inMinor*$inMajor;
        $HASH{$inRound}{IN_WEIGHT} = $HASH{$inRound}{IN_WEIGHT}*$inMinor*$inMajor; 
    }
    return (\%HASH);
}
sub _getTeamFinalScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    my $SQL = "SELECT IN_ROUND, IN_COLONIST, IN_HABITAT, IN_WATER, IN_WEIGHT, IN_PEN_MINOR, IN_PEN_LANDING FROM `TB_FLIGHT` where FK_TEAM_IDX=?";
    # my $SQL = "SELECT F.FK_EVENT_IDX, F.FK_TEAM_IDX, F.IN_ROUND, F.IN_LCARGO, F.IN_SPHERE, F.IN_WEIGHT, F.IN_SPAN, W.IN_DENSITY, F.IN_PEN_MINOR, F.IN_PEN_LANDING FROM TB_FLIGHT AS F JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX where FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    my $inCol = 0;
    my $inHab = 0;
    my $inWater = 0;
    my $inPayload = 0;
    
    my %SCORE = ();
    $SCORE{$teamIDX}{IN_FFS} = 0;
    $SCORE{$teamIDX}{IN_DAYS} = 0;
    foreach $rnd (sort keys %HASH) {
        my $inMinor = $HASH{$rnd}{IN_PEN_MINOR};
        my $inMajor = $HASH{$rnd}{IN_PEN_LANDING};
        if ($inMinor>0){$inMinor=.75} else {$inMinor=1}
        if ($inMajor>0){$inMajor=.5} else {$inMajor=1}
        $inCol += $HASH{$rnd}{IN_COLONIST}*$inMinor*$inMajor;
        $inHab += $HASH{$rnd}{IN_HABITAT}*$inMinor*$inMajor;
        $inWater += $HASH{$rnd}{IN_WATER}*$inMinor*$inMajor;
        $inPayload += $HASH{$rnd}{IN_WEIGHT}*$inMinor*$inMajor;
    }
    # print "\$inCol=$inCol, \$inHab=$inHab, \$inWater=$inWater\n";
    my $inDays = &calculateDays($inCol, $inHab, $inWater);
    # print "\$inDays = $inDays\n";
    $SCORE{$teamIDX}{IN_DAYS} = $inDays;
    my $ffs = (($inCol * $inDays ) / (15 * $inRound)) + ((2 * $inPayload)/$inRound);
    # print "$inCol, $inHab, $inWater, $inPayload\n";
    $SCORE{$teamIDX}{IN_FFS} = $ffs;
    return (\%SCORE);
}
sub calculateDays(){
    my $inColonist = shift;
    my $inHabitat = shift;
    my $inWater = shift;
    my $inWaterConvert = $inWater * 16;
    
    # print "\$inColonist=$inColonist, \$inHabitat=$inHabitat, \$inWater=$inWater\n";
    my $days = 0;
    my $max = 0;
    if ($inHabitat == 0 || $inWaterConvert == 0) {
        $days = 0;
    } else {
        $max = $inColonist/(8*$inHabitat);
        # print "$max=$max\n";
        if (($inColonist/$inWaterConvert) > $max ) {$max = ($inColonist/$inWaterConvert)}
        # print "max = $max\n";
        $days = 25*(2**(1-$max));
    }
    # print "\$max=$max\n";
    return ($days);
}



# ---------------------------- 2021 --------------------------------------------

sub _getTeamFlightScoreInRound(){
    # 325 = Colonist Key from TB_QUESTION TABLE;
    # 326 = Habitats   Key from TB_QUESTION TABLE;
    # 327 = Water   Key from TB_QUESTION TABLE;
    # 328 = Static Payload   Key from TB_QUESTION TABLE;

    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in.
    my %SCORE;
    my $boPen25 = 0;
    my $boPen50 = 0;
    my $SQL = "SELECT SCORE.FK_QUESTION_IDX, SCORE.IN_VALUE, GRADE.BO_PEN25, GRADE.BO_PEN50, TEAM.IN_LATE  FROM TB_SCORE AS SCORE
	JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
    JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.PK_TEAM_IDX=?
            AND GRADE.TX_TYPE=?
            AND GRADE.IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX, 'flight', $inRound);
    %SCORE = %{$select->fetchall_hashref(['FK_QUESTION_IDX'])};
    my $col = $SCORE{325}{IN_VALUE};
    my $hab = $SCORE{326}{IN_VALUE};
    my $wat = $SCORE{327}{IN_VALUE};
    my $pay = $SCORE{328}{IN_VALUE};

    my $minor = "No";
    my $landing = "No";
    if ($SCORE{325}{BO_PEN25}==1){$boPen25 = .25; $minor = "Yes"}
    if ($SCORE{325}{BO_PEN50}==1){$boPen50 = .50; $landing = "Yes"}

#     my $boPen25 = 0;
#     my $boPen50 = 0;
#     if ($SCORE{328}{BO_PEN25}==1){$boPen25 = .25}
#     if ($SCORE{328}{BO_PEN50}==1){$boPen50 = .50}
    # print $teamIDX.' ';
    my $mult = (1 - ($boPen25 + $boPen50));
    # return ($col, $hab, $wat, $pay, $minor, $landing, $mult);
    return ($col*$mult, $hab*$mult, $wat*$mult, $pay*$mult, $minor, $landing, $mult);
}
sub getTeamFlightScoreInRound(){
    my $self = shift;
    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in.
    my ($c, $h, $w, $p, $m, $d, $mult) = &_getTeamFlightScoreInRound($teamIDX, $inRound);
    return ($c, $h, $w, $p, $m, $d, $mult);
}
sub getFinalFlightScoreUpToRound(){
    my $self = shift;
    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in going up to.
    my $revenue = 0;
    my %SCORE;
    for (my $x=1; $x<=$inRound; $x++){
        ($c, $p, $l, $e, $r, $m, $d) = &_getTeamFlightScoreInRound($teamIDX, $x);
        $revenue += $r;
    }
    my $score = sprintf "%2.4f", 0;
    if ($inRound>0){
        $score = (1/(40 * $inRound))*$revenue;
    }
#     my $score = sprintf "%2.4f",(1/(40 * $inRound))*$revenue;
#     my $normal = ($score/206)*100;
    my $normal = $score;
    if ($score <0){
        return (0,0);
    } else {
        return ($score);
    }
}
sub getDesignScore(){
    my $self = shift;
    my $teamIDX = shift;
    my @report;
    my $late = 0;
    my $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.TX_TYPE, GRADE.IN_SCORE, TEAM.IN_LATE  FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    while (my ($FkTeamIdx, $txType, $InScore, $inLate) = $select->fetchrow_array()) {
#         if ($txType eq 'flight' || $txType eq 'presentation' || $txType eq 'penalty' || $txType eq 'tech' || $txType eq 'demo'){next}
        if ($txType eq 'report'){
            push ( @report, $InScore );
        }
        $HASH{$txType} = $InScore;
        $late = $inLate * 5;
    }
    my $average = &_average(@report);
    my $avg = $average/100 * 35;
    my $tds = $HASH{'tds'}/100 * 5;
    my $req = $HASH{'requirements'}/100 * 5;
    my $drw = $HASH{'drawing'}/100 * 5;

    my $total = ($avg + $req + $tds + $drw);
    return ($avg, $req, $tds, $drw, $late, $total);
}
sub getPresoScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $classIDX = shift;
    my @preso = ();
    my %HASH = ();
    my $SQL = "SELECT GRADE.TX_TYPE, GRADE.IN_SCORE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my $c=1;
    while (my ($txType, $InScore) = $select->fetchrow_array()) {
        if ($txType eq 'presentation'){
            push ( @preso, $InScore );
        }
        $HASH{$txType} = $InScore;
    }
    my $demo = 0;
    if ($classIDX == 1) {
        $demo = ($HASH{demo}/2 * 3) ;
    }
    my $average = &_average(@preso);
#     print scalar(@preso);
    foreach $item (@preso){
        $itemScore = $item/100 * 50;
        $HASH{$c++} = $itemScore;
    }
    $total = ($average/2);

    return ($average/2,$HASH{1},$HASH{2},$HASH{3},$demo,$total, scalar(@preso));
}
sub getPenalty(){
    my $self = shift;
    my $teamIDX = shift;
    my $penalty = 0;
    $SQL = "SELECT SUM(GRADE.IN_SCORE) AS TOTAL_PENALTY
        FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        WHERE  TEAM.PK_TEAM_IDX=? AND GRADE.TX_TYPE=?
        GROUP BY GRADE.FK_TEAM_IDX";
    $select = $dbi->prepare($SQL);
    $select->execute($teamIDX, 'penalty');
    $penalty = $select->fetchrow_array();
    return ($penalty);
}
return 1;
