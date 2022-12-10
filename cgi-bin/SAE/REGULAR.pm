package SAE::REGULAR;

use DBI;
use SAE::SDB;
use SAE::TB_TEAM;
# use v5.10.1;
use Number::Format 'format_price';
use List::Util qw(sum);

my $dbi = new SAE::Db();
my %TEAM=();
my $mult = 0.9375;

sub new{
	$className = shift;
	my $location = shift;
	if ($location){
    	my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    	my $select = $dbi->prepare($SQL);
    	   $select->execute($location, 1);
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
    my $SQL = "SELECT IN_SLOPE, IN_YINT FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my ($inSlope, $inYint) = $select->fetchrow_array();  
    my @SORTED = ();
    $SQL = "SELECT PK_FLIGHT_IDX, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, IN_PEN_MINOR, IN_PEN_LANDING, IN_ROUND FROM `TB_FLIGHT` where (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    my $maxPPB = 0;
    
    foreach $flightIDX (sort {$FLIGHT{$a}{IN_ROUND} <=> $FLIGHT{$b}{IN_ROUND}} keys %FLIGHT) {
        my $minor = 0;
        my $major = 0;
        my $fs = 0;
        if (($FLIGHT{$flightIDX}{IN_SPAN} + $FLIGHT{$flightIDX}{IN_LCARGO})>0) {
            $fs = 120*((3*$FLIGHT{$flightIDX}{IN_SPHERE})+$FLIGHT{$flightIDX}{IN_WEIGHT})/($FLIGHT{$flightIDX}{IN_SPAN} + $FLIGHT{$flightIDX}{IN_LCARGO});
            if ($FLIGHT{$flightIDX}{IN_PEN_MINOR}>0){
                $FLIGHT{$flightIDX}{IN_MINOR} = $fs * 0.25;
                $minor = .75;
            } else {
                $FLIGHT{$flightIDX}{IN_MINOR} = 0;
                $minor = 1;
            }
            if ($FLIGHT{$flightIDX}{IN_PEN_LANDING}>0){
                $FLIGHT{$flightIDX}{IN_MAJOR} = $fs * 0.5;
                $major = .5;
            } else {
                $FLIGHT{$flightIDX}{IN_MAJOR} = 0;
                $major = 1;
            }
        } else {
            $FLIGHT{$flightIDX}{IN_MINOR}=0;
            $FLIGHT{$flightIDX}{IN_MAJOR}=0;
        }

        my $ffs = $fs - $FLIGHT{$flightIDX}{IN_MINOR} - $FLIGHT{$flightIDX}{IN_MAJOR};
        
        my $actualWeight = $FLIGHT{$flightIDX}{IN_WEIGHT} + (0.9375*$FLIGHT{$flightIDX}{IN_SPHERE});
        my $predicted = ($inSlope*$FLIGHT{$flightIDX}{IN_DENSITY}) + $inYint;
        my $ppb = (10 - ($actualWeight - $predicted)**2) * $minor * $major;
        if ($ppb > $maxPPB){$maxPPB = $ppb}
        if ($ppb<0){
            $FLIGHT{$flightIDX}{IN_BONUS} = 0;
        } else {
            $FLIGHT{$flightIDX}{IN_BONUS} = $ppb;
        }
        $FLIGHT{$flightIDX}{IN_FS} = $fs;
        $FLIGHT{$flightIDX}{IN_FFS} = $ffs;

    }
    @SORTED = (sort {$FLIGHT{$b}{IN_FFS} <=> $FLIGHT{$a}{IN_FFS}} keys %FLIGHT);
    # my $flightScore = $FLIGHT{$SORTED[0]}{IN_FFS} + $FLIGHT{$SORTED[1]}{IN_FFS} + $FLIGHT{$SORTED[2]}{IN_FFS} + $maxPPB;
    return ($maxPPB,\@SORTED, \%FLIGHT);
}
sub _savePerformanceScores(){
    my ($self, $publishIDX, $teamIDX, $inFlight) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_FLIGHT) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inFlight);
    return;
}
sub _getFlightScores(){
    my ($self, $publishIDX) = @_;
    my $SQL = "SELECT FK_TEAM_IDX, IN_FLIGHT FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $select = $dbi->prepare($SQL);
           $select -> execute( $publishIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}

# ---------------------------- 2021 --------------------------------------------
sub _getTeamList(){
    my $self = shift;
    return (\%TEAM);
}
sub _getTeamFinalScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    my $SQL = "SELECT F.IN_ROUND, F.IN_LCARGO, F.IN_SPHERE, F.IN_WEIGHT, F.IN_SPAN, W.IN_DENSITY, F.IN_PEN_MINOR, F.IN_PEN_LANDING FROM TB_FLIGHT AS F JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};

    my %SCORE = ();
    my @FS = ();
    for (my $rnd=1; $rnd<=$inRound; $rnd++){
        my $inPayload  = $HASH{$rnd}{IN_WEIGHT};
        my $inBall     = $HASH{$rnd}{IN_SPHERE};
        my $inDensity  = $HASH{$rnd}{IN_DENSITY};
        my $inMinor    = $HASH{$rnd}{IN_PEN_MINOR};
        my $inMajor    = $HASH{$rnd}{IN_PEN_LANDING};
        my $fs = &getTeamFlightScore($teamIDX, $rnd);
        my $actual     = $inPayload + ($mult * $inBall);
        # print "$teamIDX, $actual, $inDensity, $inMinor, $inMajor\n";
        my $bonus = &calculatePPB($teamIDX, $actual, $inDensity, $inMinor, $inMajor);
        $SCORE{$rnd}{IN_FS} = $fs;
        $SCORE{$rnd}{IN_BONUS} = $bonus;

    }
    push (@FS, sort {$SCORE{$b}{IN_FS} <=> $SCORE{$a}{IN_FS}} keys %SCORE);
    my $finalScore = 0;
    my $finalBonus = 0;
    for ($i=0; $i<=2; $i++){
        $finalScore += $SCORE{$FS[$i]}{IN_FS};
        if ($SCORE{$FS[$i]}{IN_BONUS}>$finalBonus){$finalBonus = $SCORE{$FS[$i]}{IN_BONUS}}
    }
    # print "$finalScore,\t$finalBonus\n";
    return ($finalScore, $finalBonus);
}
sub _getTeamFlightScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    my $fs = &getTeamFlightScore($teamIDX, $inRound);
    return ($fs);
}
sub getTeamFlightScore(){
    my $teamIDX = shift;
    my $inRound = shift;
    my $SQL = "SELECT F.IN_ROUND, F.IN_LCARGO, F.IN_SPHERE, F.IN_WEIGHT, F.IN_SPAN, W.IN_DENSITY, F.IN_PEN_MINOR, F.IN_PEN_LANDING FROM TB_FLIGHT AS F JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX where FK_TEAM_IDX=? AND F.IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX, $inRound);
    my ($inRound, $inLength, $inBall, $inPayload, $inSpan, $inDen, $inMinor, $inMajor) = $select->fetchrow_array();
    # printf "%-5d%5d%10d%10.2f%10d%10d%10d%10d%10d\n", $inRound, $inLCargo, $inBall, $inWeight, $inSpan, $inDen, $inMinor, $inMajor;
    my ($fs) = &calculateFlightScore($inBall, $inPayload, $inSpan, $inLength, $inMinor, $inMajor);
    return ($fs);
}
sub _getTeamScoreCard(){
    my $self = shift;
    my $teamIDX = shift;
    
    my $SQL = "SELECT F.FK_EVENT_IDX, F.FK_TEAM_IDX, F.IN_ROUND, F.IN_LCARGO, F.IN_SPHERE, F.IN_WEIGHT, F.IN_SPAN, W.IN_DENSITY, F.IN_PEN_MINOR, F.IN_PEN_LANDING FROM TB_FLIGHT AS F JOIN TB_WEATHER AS W ON F.FK_WEATHER_IDX=W.PK_WEATHER_IDX where FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    foreach $inRound (sort keys %HASH) {
        my $inPayload  = $HASH{$inRound}{IN_WEIGHT};
        my $inBall     = $HASH{$inRound}{IN_SPHERE};
        my $inSpan     = $HASH{$inRound}{IN_SPAN};
        my $inLength   = $HASH{$inRound}{IN_LCARGO};
        my $inDensity  = $HASH{$inRound}{IN_DENSITY};
        my $inMinor    = $HASH{$inRound}{IN_PEN_MINOR};
        my $inMajor    = $HASH{$inRound}{IN_PEN_LANDING};
        my $actual     = $inPayload + ($mult * $inBall);
        my $bonus = &calculatePPB($teamIDX, $actual, $inDensity,$inMinor, $inMajor);
        my $fs = calculateFlightScore($inBall, $inPayload, $inSpan, $inLength, $inMinor, $inMajor);
        
        $HASH{$inRound}{IN_BONUS} = $bonus;
        
        $HASH{$inRound}{IN_FS} = $fs;
    }
    return (\%HASH);
}
sub calculateFlightScore(){
    my ($inBall, $inPayload, $inSpan, $inLength, $inMinor, $inMajor) = @_;
    if ($inMinor>0){$inMinor=.75} else {$inMinor=1}
    if ($inMajor>0){$inMajor=.5} else {$inMajor=1}

    if (($inLength+$inSpan)==0){return 0}
    my $fs = (120*(((3*$inBall)+$inPayload)/($inLength+$inSpan)))*$inMinor*$inMajor;
    return ($fs);
}
sub calculatePPB(){
    my $teamIDX = shift;
    my $actual = shift;
    my $den = shift;
    my $inMinor = shift;
    my $inMajor = shift;
    # print "\$teamIDX=$teamIDX\t\$inMinor=$inMinor\t\$inMajor=$inMajor\n";
    if ($inMinor>0){$inMinor=.75} else {$inMinor=1}
    if ($inMajor>0){$inMajor=.5} else {$inMajor=1}
    # print "\$teamIDX=$teamIDX\t\$inMinor=$inMinor\t\$inMajor=$inMajor\n\n";
    my $SQL = "SELECT IN_SLOPE, IN_YINT FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my ($slope, $yInt) = $select->fetchrow_array();
    my $predicted = ($slope * $den) + $yInt;
    my $PPB = 0;
    if ($actual>0){
        # $PPB = (10 - ($actual - $predicted)**2); 
        $PPB = (10 - ($actual - $predicted)**2)*$inMinor*$inMajor;
    }
    # print "\$teamIDX=$teamIDX\t\$actual=$actual\t\$predicted=$predicted\t\$PPB=$PPB\t\$inMinor=$inMinor\t\$inMajor=$inMajor\n";
    if ($PPB>0){
        return ($PPB);
    } else {
        return (0);
    }
}

# ---------------------------- 2021 --------------------------------------------
sub getNoShows(){
    my $self = shift;
    my $eventIDX = shift;
    my $classIDX = shift;
    my %HASH = ();
    my $SQL = "SELECT TEAM.PK_TEAM_IDX FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($eventIDX, $classIDX);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

    my $SQL = "SELECT TEAM.PK_TEAM_IDX, GRADE.TX_TYPE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE GRADE.TX_TYPE=? AND TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=?
            GROUP BY TEAM.PK_TEAM_IDX";
    my $select = $dbi->prepare($SQL);
    $select->execute('presentation', $eventIDX, $classIDX);
    %SHOW = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $teamIDX (sort keys %TEAM){
        if (!exists $SHOW{$teamIDX}){
            $HASH{$teamIDX}=1;
        }
    }
#     print "$eventIDX, $classIDX";
    return (\%HASH);

}
sub _getTeamFlightScoreInRound(){
    # 323 = Passenger Key from TB_QUESTION TABLE;
    # 324 = Luggage   Key from TB_QUESTION TABLE;
    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in.
    my $team = new SAE::TB_TEAM();
    $team->getRecordById($teamIDX);
    my $inCapacity = $team->getInCapacity();
    my %SCORE;
    my $SQL = "SELECT SCORE.FK_QUESTION_IDX, SCORE.IN_VALUE, GRADE.BO_PEN25, GRADE.BO_PEN50 FROM TB_SCORE AS SCORE JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
	WHERE FK_QUESTION_IDX in (323,324)
    AND GRADE.FK_TEAM_IDX=?
    AND SCORE.IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX, $inRound);
    %SCORE = %{$select->fetchall_hashref(['FK_QUESTION_IDX'])};
    my $passenger = $SCORE{323}{IN_VALUE};
    my $luggage = $SCORE{324}{IN_VALUE};
    my $boPen25 = 0;
    my $boPen50 = 0;
    my $minor = "No";
    my $landing = "No";
    if ($SCORE{324}{BO_PEN25}==1){$boPen25 = .25; $minor = "Yes"}
    if ($SCORE{324}{BO_PEN50}==1){$boPen50 = .50; $landing = "Yes"}
    my $multiplier = (1 - ($boPen25 + $boPen50));
    my $empty = $inCapacity - $passenger;
    my $revenue = 100*$passenger + 50*$luggage - 100*$empty;
    if ($revenue>0){
        $revenue = $revenue * $multiplier;
    }
    return ($inCapacity, $passenger, $luggage, $empty, $revenue, $minor, $landing);
}
sub getTeamFlightScoreInRound(){
    my $self = shift;
    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in.
    my ($c, $p, $l, $e, $r, $m, $d) = &_getTeamFlightScoreInRound($teamIDX, $inRound);
    return ($c, $p, $l, $e, $r, $m, $d);
}
sub getRegularFinalFlightScoreUpToRound(){
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
    my $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.TX_TYPE, GRADE.IN_SCORE, TEAM.IN_LATE FROM TB_GRADE AS GRADE
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
    # my $total = ($avg + $req + $tds + $drw);
    my $total = ($avg + $req + $tds + $drw);
    # print $teamIDX.", ".$late.", $tt ($total)<br>";
    return ($avg, $req, $tds, $drw, $late, $total);
}
sub getPresoScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $classIDX = shift;
    my @preso;
    my %HASH;
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
    foreach $item (@preso){
        $itemScore = $item/100 * 50;
        $HASH{$c++} = $itemScore;
    }
    $total = ($average/2) + $demo;
    if (scalar(@preso)>0){
        return ($average/2,$HASH{1},$HASH{2},$HASH{3},$demo,$total);
    } else {
        return ($average/2,0,0,0,$demo,$total);
    }

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
