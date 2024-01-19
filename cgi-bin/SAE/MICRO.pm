package SAE::MICRO;

use DBI;
use SAE::SDB;
use SAE::TB_TEAM;
use SAE::TB_FLIGHT;
use List::Util qw(sum);

my $dbi = new SAE::Db();
my %TEAM=();

sub new{
	$className = shift;
	my $location = shift;
	if ($location){
    	my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    	my $select = $dbi->prepare($SQL);
    	   $select->execute($location, 3);
    	%TEAM=%{$select->fetchall_hashref('PK_TEAM_IDX')};
	}
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _getMicroTeamList(){
    my $self = shift;
    return (\%TEAM);
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
# ---------------------------- 2024 --------------------------------------------
sub _calc24_FLightScore (){
    my ($self, $flightIDX) = @_;
    my $str;
    my $SQL = "SELECT IN_STATUS, IN_EMPTY, IN_SPAN, IN_DISTANCE, IN_WEIGHT, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE PK_FLIGHT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($flightIDX);
    my $score = 0;
    while (($inStatus, $inEmpty, $inSpan, $inBonus, $inPayload, $inPen25, $inPen50) = $select->fetchrow_array()) {
        if ($inStatus == 1){
            my $inSpan_ft = $inSpan/12;
            my $Mass  = 11/(($inEmpty-1)**4 + 8.9);
            my $Zone  = $inBonus - (($inSpan_ft)**1.5);
               $score = 3 * $inPayload * $Mass + $Zone;
            if ($inPen25){$score = $score * 0.75}
            if ($inPen50){$score = $score * 0.5}
        }
    }
    return ($score);
    }



# ---------------------------- 2022 --------------------------------------------
sub _calcTeamScore(){
    my ($self, $teamIDX) = @_;
    my @SORTED = ();
    $SQL = "SELECT PK_FLIGHT_IDX, IN_LARGE, IN_LB_DAMAGE, IN_SMALL, IN_SB_DAMAGE, IN_WEIGHT, IN_TOF, IN_PEN_MINOR, IN_PEN_LANDING, IN_ROUND FROM TB_FLIGHT where (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $flight = $dbi->prepare($SQL);
       $flight->execute($teamIDX, 1);
    my %FLIGHT= %{$flight->fetchall_hashref('PK_FLIGHT_IDX')};
    foreach $flightIDX (sort {$FLIGHT{$a}{IN_ROUND} <=> $FLIGHT{$b}{IN_ROUND}} keys %FLIGHT) {
        my $fs = 0;
        my $ffs = 0;
        my $bonus = 0;
        my $minor = 0;
        my $major = 0;
        $inLarge = $FLIGHT{$flightIDX}{IN_LARGE};
        $inLbDamage = $FLIGHT{$flightIDX}{IN_LB_DAMAGE};
        $inSmall = $FLIGHT{$flightIDX}{IN_SMALL};
        $inSbDamage = $FLIGHT{$flightIDX}{IN_SB_DAMAGE};
        $inPayload = $FLIGHT{$flightIDX}{IN_WEIGHT};
        $inTof = $FLIGHT{$flightIDX}{IN_TOF};
        $bonus = 0.5+(1*($inLarge+($inLbDamage*.5)))+(.4*($inSmall + ($inSbDamage*.5)));
        if ($inTof!=0){
            $fs = 80*(sqrt($inPayload*$bonus)/$inTof);
        }
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
        $FLIGHT{$flightIDX}{IN_BONUS} = $bonus;
        $FLIGHT{$flightIDX}{IN_FFS} = $fs*$minor*$major;
        $FLIGHT{$flightIDX}{IN_RAW} = $fs;
    }
     @SORTED = (sort {$FLIGHT{$b}{IN_FFS} <=> $FLIGHT{$a}{IN_FFS}} keys %FLIGHT);
    return (\@SORTED, \%FLIGHT);
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
sub _getTeamFinalScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    # my $SQL = "SELECT IN_ROUND, IN_LARGE, IN_SMALL, IN_WEIGHT, IN_TOF, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE FK_TEAM_IDX=?";
    # my $select = $dbi->prepare($SQL);
    #   $select->execute($teamIDX);
    # my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    my @SCORE = ();
    # foreach $inRound(sort keys %HASH){
    for ($rnd=1; $rnd<=$inRound; $rnd++){
        my $fs = &getTeamFLightScore($teamIDX, $rnd);
        push (@SCORE, $fs);
        # print "($teamIDX) Score = $fs\n";
    }
    my @FINAL =  sort {$b<=>$a} @SCORE;
    my $finalScore = 0;
    for ($i=0; $i<=2; $i++){
        $finalScore += $FINAL[$i];
    }
    return $finalScore;
}
sub _getTeamFlightScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    my $fs = &getTeamFLightScore($teamIDX, $inRound);
    return ($fs);
}
sub getTeamFLightScore(){
    my $teamIDX = shift;
    my $inRound = shift;
    my $SQL = "SELECT IN_LARGE, IN_SMALL, IN_WEIGHT, IN_TOF, IN_PEN_MINOR, IN_PEN_LANDING, IN_LB_DAMAGE, IN_SB_DAMAGE FROM TB_FLIGHT WHERE FK_TEAM_IDX=? AND IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX, $inRound);
    my ($inLarge, $inSmall, $inPayload, $inTof, $inMinor, $inMajor, $inLbDamage, $inSbDamage) = $select->fetchrow_array();
    my ($fs) = &calculateFlightScore($inLarge, $inSmall, $inPayload, $inTof, $inMinor, $inMajor, $inLbDamage, $inSbDamage);
    # print $fs."\n";
    return ($fs);
}
sub calculateFlightScore(){
    my ($inLarge, $inSmall, $inPayload, $inTof, $inMinor, $inMajor, $inLbDamage, $inSbDamage) = @_;
    if ($inMinor>0){$inMinor=.75} else {$inMinor=1}
    if ($inMajor>0){$inMajor=.5} else {$inMajor=1}
    # if ($inDamage>0){$inDamage=.5} else {$inDamage=1}
    my $fs = 0;
    my $bonus = 0;
    if ($inTof!=0){
        $bonus = 0.5+(1*($inLarge+($inLbDamage*.5)))+(.4*($inSmall + ($inSbDamage*.5)));
        $fs = 80*(sqrt($inPayload*$bonus)/$inTof)*$inMinor*$inMajor;
    }
    return ($fs, $bonus);
}
sub _getTeamScoreCard(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT IN_ROUND, IN_LARGE, IN_SMALL, IN_WEIGHT, IN_TOF, IN_PEN_MINOR, IN_PEN_LANDING, IN_LB_DAMAGE, IN_SB_DAMAGE FROM TB_FLIGHT WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_ROUND')};
    foreach $inRound (sort keys %HASH) {
        my ($fs, $bn) =  &calculateFlightScore($HASH{$inRound}{IN_LARGE}, $HASH{$inRound}{IN_SMALL}, $HASH{$inRound}{IN_WEIGHT}, $HASH{$inRound}{IN_TOF}, $HASH{$inRound}{IN_PEN_MINOR}, $HASH{$inRound}{IN_PEN_LANDING}, $HASH{$inRound}{IN_LB_DAMAGE}, $HASH{$inRound}{IN_SB_DAMAGE});
        $HASH{$inRound}{IN_BONUS} = $bn;
        $HASH{$inRound}{IN_FS} = $fs;
    }
    return (\%HASH);
}
return 1;
