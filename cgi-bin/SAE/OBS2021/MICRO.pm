package SAE::MICRO;

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
    # 329 = payload Key from TB_QUESTION TABLE;
    # 330 = empty   Key from TB_QUESTION TABLE;
    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in.
    my $boPen25 = 0;
    my $boPen50 = 0;
    my $team = new SAE::TB_TEAM();
    $team->getRecordById($teamIDX);
    my $inCapacity = $team->getInCapacity();
    my %SCORE;
#     my $SQL = "SELECT GRADE.IN_SCORE, GRADE. BO_PEN25, GRADE.BO_PEN50 FROM TB_GRADE AS GRADE
#         JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#             WHERE TEAM.PK_TEAM_IDX=?
#             AND GRADE.TX_TYPE=?
#             AND GRADE.IN_ROUND=?";
    my $SQL = "SELECT GRADE.IN_SCORE, SCORE.PK_SCORE_IDX, QUE.PK_QUESTION_IDX, QUE.TX_TITLE, QUE.TX_DESCRIPTION,
                QUE.IN_ORDER, SCORE.IN_VALUE, GRADE.IN_ROUND, GRADE.BO_PEN25, GRADE.BO_PEN50, TEAM.IN_LATE 
            FROM TB_GRADE AS GRADE
            JOIN TB_SCORE AS SCORE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
            JOIN TB_QUESTION AS QUE ON SCORE.FK_QUESTION_IDX=QUE.PK_QUESTION_IDX
        WHERE FK_TEAM_IDX=? AND TX_TYPE=? AND GRADE.IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX, 'flight', $inRound);
    %SCORE = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
    my $payload = $SCORE{329}{IN_VALUE};
    my $empty = $SCORE{330}{IN_VALUE};
    my $pf = $SCORE{330}{IN_SCORE};

    my $minor = "No";
    my $landing = "No";
    if ($SCORE{330}{BO_PEN25}==1){$boPen25 = .25; $minor = "Yes"}
    if ($SCORE{330}{BO_PEN50}==1){$boPen50 = .50; $landing = "Yes"}

    # my $boPen25 = 0;
#     my $boPen50 = 0;
#     if ($SCORE{330}{BO_PEN25}==1){$boPen25 = .25}
#     if ($SCORE{330}{BO_PEN50}==1){$boPen50 = .50}
    my $multiplier = (1 - ($boPen25 + $boPen50));
    $SQL = "SELECT GRADE.IN_SCORE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.PK_TEAM_IDX=? AND TX_TYPE=?";
    $select = $dbi->prepare($SQL);
    $select->execute($teamIDX, 'demo');
    my $demo = $select->fetchrow_array();
    my $score = $pf;
    my $adjusted = ($multiplier * $score);
    # print $demo." ";
    return ($payload, $empty, $pf, $adjusted, $demo, $minor, $landing);
}
sub getTeamFlightScoreInRound(){
    my $self = shift;
    my $teamIDX = shift;  # Team Index
    my $inRound = shift;  # The round you are interested in.
#     my ($c, $p, $l, $e, $r, $m, $d) = &_getTeamFlightScoreInRound($teamIDX, $inRound);
#     return ($c, $p, $l, $e, $r, $m, $d);
    my ($p, $e, $s, $adjusted, $demo, $m, $d) = &_getTeamFlightScoreInRound($teamIDX, $inRound);
    return ($p, $e, $s, $adjusted, $demo, $m, $d);

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
    # my $total = ($avg + $req + $tds + $drw);
    my $total = ($avg + $req + $tds + $drw);
    return ($avg, $req, $tds, $drw, $late, $total);
}
sub getPresoScore(){
    my $self = shift;
    my $teamIDX = shift;
    my $classIDX = shift;
    my @preso;
    my $HASH = ();
    my $SQL = "SELECT GRADE.TX_TYPE, GRADE.IN_SCORE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my $c=0;
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
    print $teamIDX.", ".scalar(@preso)."<br>";
    # my $count = scalar(@preso);
    # if ($count >= 3){$count = 3}
    # for ($c=0; $c< $count; $c++){
    #     $itemScore = $preso[$c]/100 * 50;
    #     $HASH{$c} = $itemScore;
    #     print $c.", ";
    # }
    foreach $item (@preso){
        $c++;
        $itemScore = $item/100 * 50;
        $HASH{$c} = $itemScore;
    #     # $c++;?
    #     print "[ $c ] <br>";
    }
    $total = ($average/2);
    return ($average/2,$HASH{1},$HASH{2},$HASH{3},$demo,$total);
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
