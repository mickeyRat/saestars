package SAE::ADVANCED;

use DBI;
use SAE::SDB;
use SAE::TB_TEAM;
use List::Util qw(sum);

my $dbi = new SAE::Db();

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _average(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
}
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
