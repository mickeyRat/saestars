package SAE::Tabulate;

use DBI;
use SAE::SDB;
use SAE::TB_TEAM;
use SAE::TB_EVENT;
use SAE::TB_CLASS;
use SAE::TB_SCORE_GROUP;
use SAE::TB_PAPER;
use List::Util qw(sum);
use Number::Format;

my $dollar = new Number::Format;

my $dbi = new SAE::Db();
my %GROUP = (1=>3, 2=>5, 3=>6);

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub average(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
}
sub getHotAward(){
    my ($self) = shift;
    my $PkEventIdx = shift;
    my $maxRound = shift;
    my $Event = new SAE::TB_EVENT();
    $Event->getRecordById($PkEventIdx);
    my $SQL = "SELECT SCORE.FK_TEAM_IDX, ITEM.TX_SCORE_ITEM, SUM(SCORE.IN_SCORE) AS IN_ZONE
        FROM TB_SCORE AS SCORE
        JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX = ITEM.PK_SCORE_ITEM_IDX
        JOIN TB_SCORE_SECTION AS SECT ON ITEM.FK_SCORE_SECTION_IDX = SECT.PK_SCORE_SECTION_IDX
        JOIN TB_SCORE_GROUP AS G ON SECT.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
        JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE SCORE.FK_SCORE_GROUP_IDX=?
            AND TEAM.FK_EVENT_IDX=?
            AND TEAM.FK_CLASS_IDX=?
            AND IN_ROUND<=?
        GROUP BY SCORE.FK_TEAM_IDX, ITEM.TX_SCORE_ITEM";
    my $select = $dbi->prepare($SQL);
    $select->execute(12, $PkEventIdx, 2, $maxRound);
    while (my ($PkTeamIdx, $Item, $InZone) = $select->fetchrow_array()) {
        if ($Item eq 'Load') {next}
        $FINAL{$PkTeamIdx}{$Item}=$InZone;
        $FINAL{$PkTeamIdx}{IN_TOTAL} += $InZone;
#         if ($PkTeamIdx == 506){
# #             print $InZone.'<br>';
#         }
    }
    %ZONE = %{$select->fetchall_hashref(['FK_TEAM_IDX','TX_SCORE_ITEM'])};
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, 2);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM) {
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{IN_NUMBER}=substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);

    }
    my $str;
    $str = '<h1>Advanced Class: Humanitarian On Target (HOT) Award</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th class="w3-right-align">Zone 1</th>';
    $str .= '<th class="w3-right-align">Zone 2</th>';
    $str .= '<th class="w3-right-align">Zone 3</th>';
    $str .= '<th class="w3-right-align">Zone 4</th>';
    $str .= '<th class="w3-right-align">Total</th>';
    $str .= '</tr>';
    my $c = 1;
    foreach $PkTeamIdx (sort {$FINAL{$b}{IN_TOTAL} <=> $FINAL{$a}{IN_TOTAL}} keys %FINAL) {
        $str .= '<tr>';
        if ($FINAL{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.$FINAL{$PkTeamIdx}{IN_NUMBER}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        $str .= '<td class="w3-right-align">'.$FINAL{$PkTeamIdx}{Zone1}.'</td>';
        $str .= '<td class="w3-right-align">'.$FINAL{$PkTeamIdx}{Zone2}.'</td>';
        $str .= '<td class="w3-right-align">'.$FINAL{$PkTeamIdx}{Zone3}.'</td>';
        $str .= '<td class="w3-right-align">'.$FINAL{$PkTeamIdx}{Zone4}.'</td>';
        $str .= '<td class="w3-border w3-right-align"><b>'.$FINAL{$PkTeamIdx}{IN_TOTAL}.'</b></td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    return ($str);
}
sub getMicroMostPayloadLifted(){
    my ($self) = shift;
    my $PkEventIdx = shift;
    my $maxRound = shift;
    my $Event = new SAE::TB_EVENT();
    $Event->getRecordById($PkEventIdx);
    my $SQL = "SELECT SCORE.FK_TEAM_IDX, SCORE.IN_ROUND, SCORE.IN_SCORE
    FROM TB_SCORE AS SCORE
    JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX = ITEM.PK_SCORE_ITEM_IDX
    JOIN TB_SCORE_SECTION AS SECT ON ITEM.FK_SCORE_SECTION_IDX = SECT.PK_SCORE_SECTION_IDX
    JOIN TB_SCORE_GROUP AS G ON SECT.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
    JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE SCORE.FK_SCORE_GROUP_IDX=?
    AND TEAM.FK_EVENT_IDX=?
    AND TEAM.FK_CLASS_IDX=?
    AND ITEM.TX_SCORE_ITEM=?
    AND SCORE.IN_ROUND <=?";
    my $select = $dbi->prepare($SQL);
    $select->execute(13, $PkEventIdx, 3, 'Load', $maxRound);
    while (my ($PkTeamIdx, $InRound, $InScore) = $select->fetchrow_array()) {
        $FINAL{$PkTeamIdx}{$InRound}=$InScore;
        $FINAL{$PkTeamIdx}{IN_TOTAL} += $InScore;
    }
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, 3);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM) {
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{IN_NUMBER}=substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
    }
    my $str;
    $str = '<h1>Micro Class: Total Payload Lifted</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    for ($i=1; $i<=$maxRound; $i++){
        $str .= '<th class="w3-right-align">Round '.$i.'</th>';
    }
    $str .= '<th class="w3-right-align">Total</th>';
    $str .= '</tr>';
    my $c = 1;
    foreach $PkTeamIdx (sort {$FINAL{$b}{IN_TOTAL} <=> $FINAL{$a}{IN_TOTAL}} keys %FINAL) {
        $str .= '<tr>';
        if ($FINAL{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.$FINAL{$PkTeamIdx}{IN_NUMBER}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        for ($i=1; $i<=$maxRound; $i++){
            $str .= sprintf '<td class="w3-right-align">%2.2f</td>', $FINAL{$PkTeamIdx}{$i};
        }
        $str .= sprintf '<td class="w3-right-align w3-border">%2.2f</td>', $FINAL{$PkTeamIdx}{IN_TOTAL};
    }
    $str .= '</table>';
    return ($str);
}
sub getMicroPayloadFraction(){
    my ($self) = shift;
    my $PkEventIdx = shift;
    my $maxRound = shift;
    my $Event = new SAE::TB_EVENT();
    $Event->getRecordById($PkEventIdx);
    my $SQL = "SELECT SCORE.FK_TEAM_IDX, ITEM.TX_SCORE_ITEM, SCORE.IN_ROUND, SCORE.IN_SCORE
    FROM TB_SCORE AS SCORE
    JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX = ITEM.PK_SCORE_ITEM_IDX
    JOIN TB_SCORE_SECTION AS SECT ON ITEM.FK_SCORE_SECTION_IDX = SECT.PK_SCORE_SECTION_IDX
    JOIN TB_SCORE_GROUP AS G ON SECT.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
    JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE SCORE.FK_SCORE_GROUP_IDX=?
    AND TEAM.FK_EVENT_IDX=?
    AND TEAM.FK_CLASS_IDX=?
    AND SCORE.IN_ROUND <=?";
    my $select = $dbi->prepare($SQL);
    $select->execute(13, $PkEventIdx, 3, $maxRound);
    while (my ($PkTeamIdx, $Item, $InRound, $InScore) = $select->fetchrow_array()) {
        $SUB{$PkTeamIdx}{$InRound}{$Item}=$InScore;
#         print "$InScore<br>";
    }
    my $total =1;
    foreach $PkTeamIdx (sort keys %SUB) {
        for($i=1; $i<=$maxRound; $i++){
#             $total = $SUB{$PkTeamIdx}{$i}{Load} + $SUB{$PkTeamIdx}{$i}{Empty};
            if (($SUB{$PkTeamIdx}{$i}{Load} + $SUB{$PkTeamIdx}{$i}{Empty}) >0){$total = ($SUB{$PkTeamIdx}{$i}{Load} + $SUB{$PkTeamIdx}{$i}{Empty})}
            my $pf = $SUB{$PkTeamIdx}{$i}{Load}/$total;
            if ($pf > $FINAL{$PkTeamIdx}{IN_TOTAL}){$FINAL{$PkTeamIdx}{IN_TOTAL} = $pf}
            $FINAL{$PkTeamIdx}{$i} = $pf;
        }
    }
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, 3);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM) {
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{IN_NUMBER}=substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
    }
    my $str;
    $str = '<h1>Micro Class: Highest Payload Fraction</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    for ($i=1; $i<=$maxRound; $i++){
        $str .= '<th class="w3-right-align">Round '.$i.'</th>';
    }
    $str .= '<th class="w3-right-align">Max<br>Payload<br>Fraction</th>';
    $str .= '</tr>';
    my $c = 1;
    foreach $PkTeamIdx (sort {$FINAL{$b}{IN_TOTAL} <=> $FINAL{$a}{IN_TOTAL}} keys %FINAL) {
        $str .= '<tr>';
        if ($FINAL{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.$FINAL{$PkTeamIdx}{IN_NUMBER}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        for ($i=1; $i<=$maxRound; $i++){
            if ($FINAL{$PkTeamIdx}{$i} == $FINAL{$PkTeamIdx}{IN_TOTAL}){
                $str .= sprintf '<td class="w3-right-align"><b>%2.2f%</b></td>', $FINAL{$PkTeamIdx}{$i}*100;
            } else {
                $str .= sprintf '<td class="w3-right-align">%2.2f%</td>', $FINAL{$PkTeamIdx}{$i}*100;
            }
        }
        $str .= sprintf '<td class="w3-border w3-right-align" ><b>%2.2f%</b></td>', $FINAL{$PkTeamIdx}{IN_TOTAL}*100;
    }
    $str .= '</table>';
    return ($str);
}
sub getRegularMostPayloadLifted(){
    my ($self) = shift;
    my $PkEventIdx = shift;
    my $maxRound = shift;
    my $Event = new SAE::TB_EVENT();
    $Event->getRecordById($PkEventIdx);

    my $SQL = "SELECT SCORE.FK_TEAM_IDX, SCORE.IN_ROUND, SCORE.IN_SCORE
    FROM TB_SCORE AS SCORE
    JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX = ITEM.PK_SCORE_ITEM_IDX
    JOIN TB_SCORE_SECTION AS SECT ON ITEM.FK_SCORE_SECTION_IDX = SECT.PK_SCORE_SECTION_IDX
    JOIN TB_SCORE_GROUP AS G ON SECT.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
    JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE SCORE.FK_SCORE_GROUP_IDX=?
    AND TEAM.FK_EVENT_IDX=?
    AND TEAM.FK_CLASS_IDX=?
    AND ITEM.TX_SCORE_ITEM=?
    AND SCORE.IN_ROUND <=?";
    my $select = $dbi->prepare($SQL);
    $select->execute(11, $PkEventIdx, 1, 'Cargo', $maxRound);
    while (my ($PkTeamIdx, $InRound, $InScore) = $select->fetchrow_array()) {
        $FINAL{$PkTeamIdx}{$InRound}=$InScore;
        $FINAL{$PkTeamIdx}{IN_TOTAL} += $InScore;
    }
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, 1);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM) {
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{IN_NUMBER}=substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
    }
    my $str;
    $str = '<h1>Regular Class: Total Payload Carried</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-small">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    for ($i=1; $i<=$maxRound; $i++){
        $str .= '<th class="w3-right-align">Round '.$i.'</th>';
    }
    $str .= '<th class="w3-right-align">Total</th>';
    $str .= '</tr>';
    my $c = 1;
    foreach $PkTeamIdx (sort {$FINAL{$b}{IN_TOTAL} <=> $FINAL{$a}{IN_TOTAL}} keys %FINAL) {
        $str .= '<tr>';
        if ($FINAL{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.$FINAL{$PkTeamIdx}{IN_NUMBER}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$FINAL{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        for ($i=1; $i<=$maxRound; $i++){
            $str .= sprintf '<td class="w3-right-align" >%2.2f</td>', $FINAL{$PkTeamIdx}{$i};
        }
        $str .= sprintf '<td class="w3-right-align w3-border">%2.2f</td>', $FINAL{$PkTeamIdx}{IN_TOTAL};
    }
    $str .= '</table>';
    return ($str);
}

# SELECT TEAM.PK_TEAM_IDX, SUM(SCORE.IN_VALUE) AS IN_TOTAL
# 	FROM TB_SCORE AS SCORE
#     JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
#     JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#     WHERE TEAM.FK_EVENT_IDX=21 AND TEAM.FK_CLASS_IDX=1
#     GROUP BY TEAM.PK_TEAM_IDX
# =============== SUNDAY FINAL RESULTS ============== 2019
sub getOverallScore(){
    my $self = shift;
    my $location = shift;
    my $maxRound = shift;
    my $PkClassIdx = shift;
    my %FLGIHT;

    my %DESIGN = %{&buildDesignHashByClass($PkClassIdx,$location)};
    my %PRESO = %{&buildPresoByClass($PkClassIdx,$location)};
    if ($PkClassIdx == 3) {
        %FLIGHT = %{&buildMicroFlightResults(3,$location, $maxRound)};
    } elsif ($PkClassIdx == 2) {
        %FLIGHT = %{&buildAdvancedFlightResults(2,$location, $maxRound )};
    } else {
        %FLIGHT = %{&buildRegularFlightResults(1,$location, $maxRound )};
    }
    my %PENALTY = %{&buildPenaltyByClass($PkClassIdx,$location)};
    my %DEMO = %{&buildDemoResults($PkClassIdx,$location)};
#     my %DESIGNADV = %{&buildDesignHashByClass(2,$location)};
#     my %DESIGNMIC = %{&buildDesignHashByClass(3,$location)};
    my %TOTAL;
    foreach $PkTeamIdx (sort keys %DESIGN) {
        $TOTAL{$PkTeamIdx}{IN_TOTAL} = $DESIGN{$PkTeamIdx}{IN_TOTAL} + $PRESO{$PkTeamIdx}{IN_TOTAL} + $FLIGHT{$PkTeamIdx}{IN_TOTAL} + $DEMO{$PkTeamIdx}{IN_TOTAL} - $PENALTY{$PkTeamIdx}{IN_TOTAL};
    }
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($location);
    $Class->getRecordById($PkClassIdx );

    $str = '<h1>Round '.$maxRound.': '.$Class->getTxClass().' Class Overall Results</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-medium">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th class="w3-right-align">Design</th>';
    $str .= '<th class="w3-right-align">Presentation</th>';
    $str .= '<th class="w3-right-align">Flight</th>';
    if ($PkClassIdx==3){
        $str .= '<th class="w3-right-align">Demo</th>';
    }
    $str .= '<th class="w3-right-align">Penalty</th>';
    $str .= '<th class="w3-right-align">Total</th>';
    $str .= '</tr>';
    my $c=1;
    foreach $PkTeamIdx (sort {$TOTAL{$b}{IN_TOTAL} <=> $TOTAL{$a}{IN_TOTAL}} keys %TOTAL) {
        $str .= '<tr>';
        $str .= '<td>'.$c++.'</td>';
        $str .= '<td>'.$DESIGN{$PkTeamIdx}{IN_NUMBER}.'</td>';
        $str .= '<td>'.$DESIGN{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$DESIGN{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $DESIGN{$PkTeamIdx}{IN_TOTAL};
        $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $PRESO{$PkTeamIdx}{IN_TOTAL};
        $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $FLIGHT{$PkTeamIdx}{IN_TOTAL};
        if ($PkClassIdx==3){
            $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $DEMO{$PkTeamIdx}{IN_TOTAL};
        }
        if ($PENALTY{$PkTeamIdx}{IN_TOTAL} > 0){
            $str .= sprintf '<td class="w3-right-align">%2.2f</td>', $PENALTY{$PkTeamIdx}{IN_TOTAL}*-1;
        } else {
            $str .= '<td class="w3-right-align">-</td>';
        }

        $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $TOTAL{$PkTeamIdx}{IN_TOTAL};

        $str .= '</tr>';
    }
    $str .= '</table>';

    return ($str);
} # 2018
sub buildHighestPayload(){ #2019
    my ($PkClassIdx, $PkEventIdx, $FkQuestionIdx) = @_;
    my %HASH;
    my %FINAL;
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
#
    my $SQL = "SELECT TEAM.PK_TEAM_IDX, SCORE.IN_ROUND, SCORE.IN_VALUE
	FROM TB_SCORE AS SCORE
    JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
    JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=? AND SCORE.FK_QUESTION_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx, $FkQuestionIdx);
    while (my ($teamIDX, $inRound, $inTotal) = $select->fetchrow_array()) {
        $FINAL{$teamIDX}{$inRound} = $inTotal;
        $HASH{$teamIDX}{IN_TOTAL} += $inTotal;
    }

    foreach $teamIDX (sort keys %TEAM) {
        $FINAL{$teamIDX}{IN_TOTAL} = $HASH{$teamIDX}{IN_TOTAL};
        $FINAL{$teamIDX}{TX_COUNTRY} = $TEAM{$teamIDX}{TX_COUNTRY};
        $FINAL{$teamIDX}{TX_SCHOOL} = $TEAM{$teamIDX}{TX_SCHOOL};
        $FINAL{$teamIDX}{IN_NUMBER} = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3);
    }
    return (\%FINAL);
}
sub getOverallResults(){
    my $self = shift;
    my ($PkClassIdx, $PkEventIdx, $InRound) = @_;
    my $str;
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($PkEventIdx);
    $Class->getRecordById($PkClassIdx);


    my $str = &_templateDesignReseults($PkClassIdx, $PkEventIdx,'none');
    $str .= &_templatePresentationReseults($PkClassIdx, $PkEventIdx,'none');
    if ($PkClassIdx==1){
        $str .= &_templateRegularFlightResults($PkClassIdx, $PkEventIdx, $InRound,'none');
    } elsif ($PkClassIdx==2) {
        $str .= &_templateAdvancedFlightResults($PkClassIdx, $PkEventIdx, $InRound, 'none');
    } else {
        $str .= &_templateMicroFlightResults($PkClassIdx, $PkEventIdx, $InRound, 'none');
    }


    my %DESIGN = %{&buildDesignHashByClass($PkClassIdx, $PkEventIdx)};
    my %PRESO = %{&buildPresentationResults($PkClassIdx, $PkEventIdx)};
    my %PAYLOAD;

    my %FLIGHT;
    if ($PkClassIdx==1){
       %FLIGHT = %{&buildRegularFlightResults($PkClassIdx, $PkEventIdx, $InRound)};
    } elsif ($PkClassIdx==2) {
        %FLIGHT = %{&buildAdvancedFlightResults($PkClassIdx, $PkEventIdx, $InRound)};
    } else {
        %FLIGHT = %{&buildMicroFlightResults($PkClassIdx, $PkEventIdx, $InRound)};
    }

    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

    $SQL = "SELECT GRADE.FK_TEAM_IDX, SUM(GRADE.IN_SCORE) AS TOTAL_PENALTY
        FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        WHERE  TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=? AND TX_TYPE=?
        GROUP BY GRADE.FK_TEAM_IDX";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx, 'penalty');
    while (my ($teamIDX, $inValue) = $select->fetchrow_array()){
        $FINAL{$teamIDX}{PENALTY} = $inValue;
    }
    foreach $teamIDX (sort keys %TEAM) {
        $TEAM{$teamIDX}{DESIGN}=$DESIGN{$teamIDX}{IN_TOTAL};
        $TEAM{$teamIDX}{PRESO}=$PRESO{$teamIDX}{IN_TOTAL};
        if ($FLIGHT{$teamIDX}{IN_TOTAL}<0){
            $TEAM{$teamIDX}{FLIGHT}=0;
        } else {
            $TEAM{$teamIDX}{FLIGHT}=$FLIGHT{$teamIDX}{IN_TOTAL};
#             print "class($PkClassIdx) $TEAM{$teamIDX}{IN_NUMBER}  $FLIGHT{$teamIDX}{IN_TOTAL}<br>";
        }
        $TEAM{$teamIDX}{FINAL} = $TEAM{$teamIDX}{DESIGN} + $TEAM{$teamIDX}{PRESO} + $TEAM{$teamIDX}{FLIGHT} - $FINAL{$teamIDX}{PENALTY};
    }

    #-------------- SECTION BREAK ------------------------
    $str .= '<hr>';
    $str .= '<h1>'.$Class->getTxClass().' Class Overall Results (Round '.$InRound.')</h1>';
    $str .= '<h3>'.$Event->getTxEventName().' Results</h3>';

    $str .= '<table class="w3-table-all w3-tiny">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th style="text-align: right;">Design</th>';
    $str .= '<th style="text-align: right;">Presentation</th>';
    $str .= '<th style="text-align: right;">Flight</th>';
    $str .= '<th style="text-align: right;">Penalties</th>';
    $str .= '<th style="text-align: right;">Overall<br>Total</th>';
    $str .= '</tr>';
    $c = 1;
    foreach $PkTeamIdx (sort {$TEAM{$b}{FINAL} <=> $TEAM{$a}{FINAL}} keys %TEAM){
        if ($c<4){
            $str .= '<tr style="display: table-row;">';
        } else {
            $str .= '<tr class="OverallhiddenRow" style="display: none;">';
        }
        if ($DESIGN{$PkTeamIdx}{IN_TOTAL}){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td>'.$TEAM{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$DESIGN{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$TEAM{$PkTeamIdx}{DESIGN};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$TEAM{$PkTeamIdx}{PRESO};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$TEAM{$PkTeamIdx}{FLIGHT};
        if ($FINAL{$PkTeamIdx}{PENALTY}>0){
            $str .= sprintf '<td class="w3-text-red" style="text-align: right;">- %2.2f</td>',$FINAL{$PkTeamIdx}{PENALTY};
        } else {
            $str .= '<td class="" style="text-align: right;">--</td>';
        }
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$TEAM{$PkTeamIdx}{FINAL};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<a class="w3-link w3-small" href="javascript:void(0)" onclick="expandTable(\'OverallhiddenRow\');">expand/collapse</a>';


    return ($str);
}
# =============== FRIDAY RESULTS ==================== 2019
# --------------- Design ---------------------------- 2019
sub buildDesignHashByClass(){
    my ($PkClassIdx, $PkEventIdx) = @_;
    my %HASH;
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM) {
        @$PkTeamIdx = ();
    }
    $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.TX_TYPE, GRADE.IN_SCORE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    while (my ($FkTeamIdx, $txType, $InScore) = $select->fetchrow_array()) {
        if ($txType eq 'flight' || $txType eq 'presentation' || $txType eq 'penalty'){next}
        if ($txType eq 'report'){
            push ( @$FkTeamIdx, $InScore );
        }
        $HASH{$FkTeamIdx}{$txType} = $InScore;
    }
        foreach $PkTeamIdx (sort keys %TEAM) {
            $HASH{$PkTeamIdx}{report} = &average(@$PkTeamIdx);
            $report = $HASH{$PkTeamIdx}{report}/100 * 35;
            $tds = $HASH{$PkTeamIdx}{tds}/100 * 5;
            $requirements = $HASH{$PkTeamIdx}{requirements}/100 * 5;
            $drawing = $HASH{$PkTeamIdx}{drawing}/100 * 5;
            $HASH{$PkTeamIdx}{IN_TOTAL} = $report + $tds + $requirements + $drawing;
            $HASH{$PkTeamIdx}{TX_COUNTRY} = $TEAM{$PkTeamIdx}{TX_COUNTRY};
            $HASH{$PkTeamIdx}{TX_SCHOOL} = $TEAM{$PkTeamIdx}{TX_SCHOOL};
            $HASH{$PkTeamIdx}{IN_NUMBER} = substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
        }
    return (\%HASH);
}
sub getDesignScoreByTeam(){
    my $self = shift;
    my ($PkTeamIdx, $PkClassIdx, $PkEventIdx) = @_;
    my %SCORE = %{&buildDesignHashByClass($PkClassIdx, $PkEventIdx)};
    return ($SCORE{$PkTeamIdx}{IN_TOTAL});
}
sub _templateDesignReseults(){
    my ($PkClassIdx, $PkEventIdx,$display) = @_;
    my $str;
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($PkEventIdx);
    $Class->getRecordById($PkClassIdx);
    my $PkClassIdx = shift;
    my %DESIGN = %{&buildDesignHashByClass($PkClassIdx, $PkEventIdx)};
    $str = '<h1>'.$Class->getTxClass().' Class Final Technical Design Report Results</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-tiny">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th>REQ</th>';
    $str .= '<th>DRW</th>';
    $str .= '<th>TDS</th>';
    $str .= '<th>Avg. Rpt</th>';
    $str .= '<th  style="text-align: right;">Total</th>';
    $str .= '</tr>';
    $c=1;
    foreach $PkTeamIdx (sort {$DESIGN{$b}{IN_TOTAL} <=> $DESIGN{$a}{IN_TOTAL}} keys %DESIGN){
        if ($c<4){
            $str .= '<tr style="display: table-row;">';
        } else {
            $str .= '<tr class="DesignhiddenRow" style="display: '.$display.';">';
        }
        if ($DESIGN{$PkTeamIdx}{IN_TOTAL}){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td>'.$TEAM{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$DESIGN{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        $str .= sprintf '<td>%2.4f</td>',($DESIGN{$PkTeamIdx}{requirements}/100 * 5);
        $str .= sprintf '<td>%2.4f</td>',($DESIGN{$PkTeamIdx}{drawing}/100 * 5);
        $str .= sprintf '<td>%2.4f</td>',($DESIGN{$PkTeamIdx}{tds}/100 * 5);
        $str .= sprintf '<td>%2.4f</td>',($DESIGN{$PkTeamIdx}{report}/100 * 35);
        $str .= sprintf '<td class="w3-border"  style="text-align: right;"><b>%2.4f</b></td>',$DESIGN{$PkTeamIdx}{IN_TOTAL};

        $str .= '</TR>';
    }
    $str .= '</table>';
    $str .= '<a class="w3-link w3-small" href="javascript:void(0)" onclick="expandTable(\'DesignhiddenRow\');">expand/collapse</a>';
    return ($str);
}
sub getDesigntResults(){
    my $self = shift;
    my ($PkClassIdx, $PkEventIdx) = @_;
    my $str = &_templateDesignReseults($PkClassIdx, $PkEventIdx,'table-row');
    return ($str);
}
# --------------- PENALTY --------------------------- 2019
sub buildPenaltyByTeam(){
    my $PkTeamIdx = shift;
    $SQL = "SELECT SUM(GRADE.IN_SCORE) AS TOTAL_PENALTY
        FROM TB_GRADE AS GRADE JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        WHERE  TEAM.PK_TEAM_IDX=? AND TX_TYPE=?
        GROUP BY GRADE.FK_TEAM_IDX";
    $select = $dbi->prepare($SQL);
    $select->execute($PkTeamIdx, 'penalty');
    my ($inValue) = $select->fetchrow_array();
    return ($inValue);
}
sub getPenaltyByTeam(){
    my $self = shift;
    my ($PkTeamIdx, $PkClassIdx, $PkEventIdx) = @_;
    my $score = &buildPenaltyByTeam($PkTeamIdx);
    return ($score);
}
# --------------- Demo ------------------------------ 2019
sub buildDemoResultsByTeam(){
    my ($PkTeamIdx, $FkClassIdx) = @_;
    my %HASH;
    my $demo;
    my $SQL = "SELECT GRADE.IN_SCORE FROM TB_GRADE AS GRADE WHERE (GRADE.FK_TEAM_IDX=? AND GRADE.TX_TYPE=?)";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkTeamIdx, 'demo');
    my $score = $select->fetchrow_array();
#     print '('.$FkClassIdx.')'.$score.'<br>';
    if ($FkClassIdx==1){
        $demo = ($score * 3)/2 ;
    } else {
        $demo = $score;
    }
    return ($demo);
}
# --------------- Presentations --------------------- 2019
sub buildPresentationResults(){
    my ($PkClassIdx, $PkEventIdx) = @_;
    my %HASH;
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM) {
        @$PkTeamIdx = ();
    }
    $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.TX_TYPE, GRADE.IN_SCORE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    while (my ($FkTeamIdx, $txType, $InScore) = $select->fetchrow_array()) {
        if ($txType eq 'flight' || $txType eq 'report' || $txType eq 'penalty' || $txType eq 'tds' || $txType eq 'drawing' || $txType eq 'requirements'){next}
        if ($txType eq 'presentation'){
            push ( @$FkTeamIdx, $InScore );
        }
        $HASH{$FkTeamIdx}{$txType} = $InScore;
    }
        foreach $PkTeamIdx (sort keys %TEAM) {
            $c=1;
            @TEMP = @$PkTeamIdx;
            foreach $item (@TEMP){
                $itemScore = $item/100 * 50;
                $HASH{$PkTeamIdx}{$c++} = $itemScore;
            }
            $HASH{$PkTeamIdx}{presentation} = &average(@$PkTeamIdx);
            my $demo = 0;
            if ($PkClassIdx == 1) {
                $demo = ($HASH{$PkTeamIdx}{demo}/2 * 3) ;
            } else {
                $demo = 0;
            }
            $HASH{$PkTeamIdx}{IN_DEMO} = $demo;
            $preso = $HASH{$PkTeamIdx}{presentation}/100 * 50;
#             print "$PkTeamIdx = $preso<br>";
            $HASH{$PkTeamIdx}{IN_TOTAL} = $preso + $demo;
            $HASH{$PkTeamIdx}{TX_COUNTRY} = $TEAM{$PkTeamIdx}{TX_COUNTRY};
            $HASH{$PkTeamIdx}{TX_SCHOOL} = $TEAM{$PkTeamIdx}{TX_SCHOOL};
            $HASH{$PkTeamIdx}{IN_NUMBER} = substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
        }
    return (\%HASH);
}
sub getPresentationScoreByTeam(){
    my $self = shift;
    my ($PkTeamIdx, $PkClassIdx, $PkEventIdx) = @_;
    my %SCORE = %{&buildPresentationResults($PkClassIdx, $PkEventIdx)};
    return ($SCORE{$PkTeamIdx}{IN_TOTAL});
}
sub getDemoScoreByTeam(){
    my $self = shift;
    my ($PkTeamIdx, $PkClassIdx, $PkEventIdx) = @_;
    my $score = &buildDemoResultsByTeam($PkTeamIdx, $PkClassIdx, $PkEventIdx);
    return ($score);
}
sub _templatePresentationReseults(){
    my ($PkClassIdx, $PkEventIdx, $display) = @_;
    my $str;
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($PkEventIdx);
    $Class->getRecordById($PkClassIdx);
    my $PkClassIdx = shift;
    my %PRESO = %{&buildPresentationResults($PkClassIdx, $PkEventIdx)};
    $str = '<h1>'.$Class->getTxClass().' Class Final Technical Presentation Results</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-tiny">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th>Score #1</th>';
    $str .= '<th>Score #2</th>';
    $str .= '<th>Score #3</th>';
    if ($PkClassIdx ==1){
        $str .= '<th>Demo</th>';
    }
    $str .= '<th style="text-align: right;">Average<br>Score</th>';
    $str .= '</tr>';
    $c=1;
    foreach $PkTeamIdx (sort {$PRESO{$b}{IN_TOTAL} <=> $PRESO{$a}{IN_TOTAL}} keys %PRESO){
        if ($c<4){
            $str .= '<tr style="display: table-row;">';
        } else {
            $str .= '<tr class="PresohiddenRow" style="display: '.$display.';">';
        }
        if ($PRESO{$PkTeamIdx}{IN_TOTAL}){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td>'.$TEAM{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$PRESO{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        for (my $i=1; $i<=3; $i++){
            if ($PRESO{$PkTeamIdx}{$i}){
                $str .= sprintf '<td>%2.4f</td>',$PRESO{$PkTeamIdx}{$i};
            } else {
                $str .= '<td>-</td>'
            }
        }
        if ($PkClassIdx ==1){
            if (($PRESO{$PkTeamIdx}{demo}/2*3)>0){
                $str .= sprintf '<td>%2.4f</td>',($PRESO{$PkTeamIdx}{demo}/2*3);
            }else {
                $str .=  '<td>-</td>';
            }
        }
        $str .= sprintf '<td class="w3-border" style="text-align: right;"><b>%2.4f</b></td>',$PRESO{$PkTeamIdx}{IN_TOTAL};
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<a class="w3-link w3-small" href="javascript:void(0)" onclick="expandTable(\'PresohiddenRow\');">expand/collapse</a>';
    return ($str);
}
sub getPresentationResults(){
    my $self = shift;
    my ($PkClassIdx, $PkEventIdx) = @_;
    my $str =  &_templatePresentationReseults($PkClassIdx, $PkEventIdx,'table-row');
    return ($str);
}
# =============== FLIGHT RESULTS ==================== 2019
sub getFlightScoreByTeam(){
    my $self = shift;
    my ($PkTeamIdx, $PkClassIdx, $PkEventIdx, $maxRound) = @_;
    my %SCORE;
    if ($PkClassIdx==1){
        %SCORE = %{&buildRegularFlightResults($PkClassIdx, $PkEventIdx, $maxRound)};
    } elsif ($PkClassIdx==2) {
        %SCORE = %{&buildAdvancedFlightResults($PkClassIdx, $PkEventIdx, $maxRound)};
    } elsif($PkClassIdx==3) {
        %SCORE = %{&buildMicroFlightResults($PkClassIdx, $PkEventIdx, $maxRound)};
    }
    return ($SCORE{$PkTeamIdx}{IN_TOTAL});
}
# --------------- REGULAR CLASS  -------------------- 2019
sub buildRegularFlightResults(){
    my ( $PkClassIdx, $PkEventIdx, $InRoundLimit ) = @_;
    my %SCORE;
    my %FINAL;
    my $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY, TEAM.IN_CAPACITY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

    $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.IN_SCORE, GRADE.IN_ROUND FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.FK_EVENT_IDX=?
            AND TEAM.FK_CLASS_IDX=?
            AND GRADE.TX_TYPE=?
            AND GRADE.IN_ROUND<=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx, 'flight', $InRoundLimit);
    %SCORE = %{$select->fetchall_hashref(['FK_TEAM_IDX','IN_ROUND'])};


    foreach $teamIDX (sort keys %TEAM){
        for (my $x=1; $x<=$InRoundLimit; $x++){
            $inScore = $SCORE{$teamIDX}{$x}{IN_SCORE};
# ---------  Comment this out to revert back to previous year's calculations ------------
#             if (!exists $SCORE{$teamIDX}{$x}{IN_SCORE}){                                #
#                 $inScore = -100*$TEAM{$teamIDX}{IN_CAPACITY};                           #
#             }                                                                           #
# ---------  Comment this out to revert back to previous year's calculations ------------
            $FINAL{$teamIDX}{$x} = $inScore;
            $FINAL{$teamIDX}{IN_REVENUE} += $inScore;
        }
    }
    foreach $PkTeamIdx (sort keys %TEAM){
#         $FINAL{$PkTeamIdx}{IN_TOTAL}= (1/(40 * $InRoundLimit))*$FINAL{$PkTeamIdx}{IN_REVENUE};
        if ($InRoundLimit==0 ){$InRoundLimit=1}
        if ($InRoundLimit>0){
            $FINAL{$PkTeamIdx}{IN_TOTAL}= (1/(40 * $InRoundLimit))*$FINAL{$PkTeamIdx}{IN_REVENUE};
        } else {
            $FINAL{$PkTeamIdx}{IN_TOTAL}=0;
        }
        $FINAL{$PkTeamIdx}{IN_NUMBER}=$TEAM{$PkTeamIdx}{IN_NUMBER};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
    }
    return (\%FINAL);
}
sub _templateRegularFlightResults(){
    my ($PkClassIdx, $PkEventIdx, $InRound,$display) = @_;
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($PkEventIdx);
    $Class->getRecordById($PkClassIdx);
    my $str;
    my (%REGFLIGHT) = %{&buildRegularFlightResults($PkClassIdx, $PkEventIdx, $InRound)};
    $str = '<h1>'.$Class->getTxClass().' Class Round '.$InRound.' Mission Performance Results</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-tiny">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    for ($round=1; $round<=$InRound; $round++) {
    $str .= '<th style="text-align: right;">Revenue<br>After<br>Round '.$round.'</th>';
    }
#     $str .= '<th>Revenue</th>';
#     $str .= '<th style="text-align: right;">Penalties</th>';
    $str .= '<th style="text-align: right;">Total<br>Revenue<br>Generated</th>';
    $str .= '<th style="text-align: right;">Final<br>Flight<br>Score</th>';
    $str .= '</tr>';
    $c=1;
    foreach $PkTeamIdx (sort {$REGFLIGHT{$b}{IN_TOTAL} <=> $REGFLIGHT{$a}{IN_TOTAL}} keys %REGFLIGHT) {
        if ($c<4){
            $str .= '<tr style="display: table-row;">';
        } else {
            $str .= '<tr class="regFlighthiddenRow" style="display: '.$display.';">';
        }
        $w3Color = 'w3-text-black';
        if ($REGFLIGHT{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
            $w3Color = 'w3-text-red';
        }
        $str .= '<td>'.substr("000".$REGFLIGHT{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td>'.$REGFLIGHT{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$REGFLIGHT{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        for ($round=1; $round<=$InRound; $round++) {
            $str .= sprintf '<td style="text-align: right;" class="">$%2.2f</td>', $REGFLIGHT{$PkTeamIdx}{$round};
        }
#
#         $str .= sprintf '<td style="text-align: right;" class="w3-border-left w3-text-red">- %2.2f</td>', $REGFLIGHT{$PkTeamIdx}{PENALTY};
        $str .= sprintf '<td style="text-align: right;" class="w3-border-left '.$w3Color.'">$%2.2f</td>', $REGFLIGHT{$PkTeamIdx}{IN_REVENUE};
        if ($REGFLIGHT{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= sprintf '<th style="text-align: right;" class="w3-border-left">%2.4f</th>', $REGFLIGHT{$PkTeamIdx}{IN_TOTAL};
        } else {
            $str .= sprintf '<th style="text-align: right;" class="w3-border-left">%2.4f</th>', 0;
        }
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<a class="w3-link w3-small" href="javascript:void(0)" onclick="expandTable(\'regFlighthiddenRow\');">expand/collapse</a>';
    return ($str);
}
sub getRegularFlightResults(){
    my $self = shift;
    my ($PkClassIdx, $PkEventIdx, $InRound) = @_;
    my $str = &_templateRegularFlightResults($PkClassIdx, $PkEventIdx, $InRound, 'table-row');
    return ($str);
}
# --------------- ADVANCED CLASS  ------------------- 2019
sub buildAdvancedFlightResults(){
    my ( $PkClassIdx, $PkEventIdx, $InRoundLimit) = @_;
    my %SCORE;
    my %PAYLOAD;
    my %COL;
    my %HAB;
    my %WATER;
    my %FINAL;
    my $str;
    $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.IN_ROUND, SCORE.FK_QUESTION_IDX, SCORE.IN_VALUE FROM TB_SCORE AS SCORE
	JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX=GRADE.PK_GRADE_IDX
    JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.FK_EVENT_IDX=?
            AND TEAM.FK_CLASS_IDX=?
            AND GRADE.TX_TYPE=?
            AND GRADE.IN_ROUND<=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx, 'flight', $InRoundLimit);
    while (my ($teamIDX, $inRound, $questionIDX, $inValue) = $select->fetchrow_array()){
        $FINAL{$teamIDX}{$questionIDX} += $inValue;
    }

    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM){
        $colonist = $FINAL{$PkTeamIdx}{325};
        $habitat = $FINAL{$PkTeamIdx}{326};
        $water = $FINAL{$PkTeamIdx}{327};
        $static = $FINAL{$PkTeamIdx}{328};
        if ($habitat>0){
            $col2Hab = $colonist/(8 * $habitat);
        }
        if ($water>0){
            $col2Water = $colonist/$water;
        }
        if ($habitat==0 && $water==0 || $colonist==0){
            $FINAL{$PkTeamIdx}{IN_DAYS} = 0;
        } else {
            my $max = $col2Hab;
            if ($col2Water > $col2Hab){$max = $col2Water}
            $FINAL{$PkTeamIdx}{IN_DAYS} = 25 * 2**(1-$max);
        }
#         if ($FINAL{$PkTeamIdx}{325})
#         print "$PkTeamIdx = $FLIGHT{$PkTeamIdx}<br>";
        if ($InRoundLimit==0){$InRoundLimit=1}
        $FINAL{$PkTeamIdx}{IN_TOTAL} = (($colonist*$FINAL{$PkTeamIdx}{IN_DAYS})/(15*$InRoundLimit)) + (2*$static)/$InRoundLimit;
#         print "class($PkClassIdx) $TEAM{$PkTeamIdx}{IN_NUMBER}  $FINAL{$PkTeamIdx}{IN_TOTAL}<br>";
        $FINAL{$PkTeamIdx}{IN_NUMBER}=$TEAM{$PkTeamIdx}{IN_NUMBER};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
    }

    return (\%FINAL);
}
sub _templateAdvancedFlightResults(){
    my ($PkClassIdx, $PkEventIdx, $InRound, $display) = @_;
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($PkEventIdx);
    $Class->getRecordById($PkClassIdx);
    my (%ADVFLIGHT) = %{&buildAdvancedFlightResults($PkClassIdx, $PkEventIdx, $InRound)};
    my $str;
    $str = '<h1>'.$Class->getTxClass().' Class Round '.$InRound.' Mission Performance Results</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-tiny">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th style="text-align: right;"># of<br>Colonist</th>';
    $str .= '<th style="text-align: right;"># of<br>Habitat</th>';
    $str .= '<th style="text-align: right;">Amt. of<br>Water</th>';
    $str .= '<th style="text-align: right;">Amt. of<br>Fuel<br>(Static)</th>';
    $str .= '<th style="text-align: right;">Days<br>Of<br>Habitability</th>';
#     $str .= '<th style="text-align: right;">Penalties</th>';
    $str .= '<th style="text-align: right;">Final<br>Flight<br>Score</th>';
    $str .= '</tr>';
    $c=1;
    foreach $PkTeamIdx (sort {$ADVFLIGHT{$b}{IN_TOTAL} <=> $ADVFLIGHT{$a}{IN_TOTAL}} keys %ADVFLIGHT) {
        if ($c<4){
            $str .= '<tr style="display: table-row;">';
        } else {
            $str .= '<tr class="advFlighthiddenRow" style="display: '.$display.'">';
        }
        if ($ADVFLIGHT{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.substr("000".$ADVFLIGHT{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td>'.$ADVFLIGHT{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$ADVFLIGHT{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$ADVFLIGHT{$PkTeamIdx}{325};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$ADVFLIGHT{$PkTeamIdx}{326};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>',$ADVFLIGHT{$PkTeamIdx}{327};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$ADVFLIGHT{$PkTeamIdx}{328};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>',$ADVFLIGHT{$PkTeamIdx}{IN_DAYS};
#         $str .= sprintf '<td class="w3-text-red" style="text-align: right;">-%2.1f</td>',$ADVFLIGHT{$PkTeamIdx}{PENALTY};
        if ($ADVFLIGHT{$PkTeamIdx}{IN_TOTAL}<0){
            $str .= sprintf '<th style="text-align: right;" class="w3-border-left">%2.4f</th>', 0;
        } else {
            $str .= sprintf '<th style="text-align: right;" class="w3-border-left">%2.4f</th>', $ADVFLIGHT{$PkTeamIdx}{IN_TOTAL};
        }
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<a class="w3-link w3-small" href="javascript:void(0)" onclick="expandTable(\'advFlighthiddenRow\');">expand/collapse</a>';
    return ($str);
}
sub getAdvancedFlightResults(){
    my $self = shift;
    my ($PkClassIdx, $PkEventIdx, $InRound) = @_;
    my $str = &_templateAdvancedFlightResults($PkClassIdx, $PkEventIdx, $InRound, 'table-row');
    return ($str);
}
# --------------- MICRO CLASS     ------------------- 2019
sub buildMicroFlightResults(){
    my ( $PkClassIdx, $PkEventIdx, $InRoundLimit) = @_;
    my %SCORE;
    my %ROUND;
    my %FINAL;
    my %FLIGHT;
    my %MAX;
#     print "$PkClassIdx, $PkEventIdx, $InRoundLimit<br>";
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, COUNTRY.TX_COUNTRY FROM TB_TEAM AS TEAM
        JOIN TB_COUNTRY AS COUNTRY ON TEAM.FK_COUNTRY_IDX=COUNTRY.PK_COUNTRY_IDX
        WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    foreach $teamIDX (sort {$a <=> $b} keys %TEAM){
        $MAX{$teamIDX}=0;
    }

    $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.IN_SCORE, GRADE.IN_ROUND FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.FK_EVENT_IDX=?
            AND TEAM.FK_CLASS_IDX=?
            AND GRADE.TX_TYPE=?
            AND GRADE.IN_ROUND<=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx, 'flight', $InRoundLimit);
    while (my ($teamIDX, $inScore, $inRound) = $select->fetchrow_array()){
        if ($inScore>$MAX{$teamIDX}){$MAX{$teamIDX} = $inScore}
        $FINAL{$teamIDX}{$inRound} = $inScore;
        if ($inScore<0){$FINAL{$teamIDX}{$inRound}=0}
        $FLIGHT{$teamIDX} += $inScore;
    }


    $SQL = "SELECT GRADE.FK_TEAM_IDX, GRADE.TX_TYPE, GRADE.IN_SCORE FROM TB_GRADE AS GRADE
        JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
            WHERE TEAM.FK_EVENT_IDX=? AND TEAM.FK_CLASS_IDX=? AND TX_TYPE=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, $PkClassIdx, 'demo');
    %DEMO = %{$select->fetchall_hashref(['FK_TEAM_IDX'])};
    foreach $PkTeamIdx (sort keys %TEAM){
#         print $InRoundLimit;
        $FINAL{$PkTeamIdx}{IN_DEMO}=$DEMO{$PkTeamIdx}{IN_SCORE};
#         if ($InRoundLimit==0){$InRoundLimit=1}
        if ($InRoundLimit==0){
            $FINAL{$PkTeamIdx}{IN_TOTAL}= (20 * (.5*($MAX{$PkTeamIdx}))) + $FINAL{$PkTeamIdx}{IN_DEMO};
        } else {
            $FINAL{$PkTeamIdx}{IN_TOTAL}= (20 * (.5*($FLIGHT{$PkTeamIdx}/$InRoundLimit) + .5*($MAX{$PkTeamIdx}))) + $FINAL{$PkTeamIdx}{IN_DEMO};
        }

        $FINAL{$PkTeamIdx}{IN_NUMBER}=$TEAM{$PkTeamIdx}{IN_NUMBER};
        $FINAL{$PkTeamIdx}{TX_SCHOOL}=$TEAM{$PkTeamIdx}{TX_SCHOOL};
        $FINAL{$PkTeamIdx}{TX_COUNTRY}=$TEAM{$PkTeamIdx}{TX_COUNTRY};
        $FINAL{$PkTeamIdx}{IN_MAX}=$MAX{$PkTeamIdx};
        $FINAL{$PkTeamIdx}{IN_DEMO}=$DEMO{$PkTeamIdx}{IN_SCORE};
    }
    return (\%FINAL);
}
sub _templateMicroFlightResults(){
    my ($PkClassIdx, $PkEventIdx, $InRound, $display) = @_;
    my $Event = new SAE::TB_EVENT();
    my $Class = new SAE::TB_CLASS();
    $Event->getRecordById($PkEventIdx);
    $Class->getRecordById($PkClassIdx);
    my (%MICFLIGHT) = %{&buildMicroFlightResults($PkClassIdx, $PkEventIdx, $InRound)};
    my $str;
    $str = '<h1>'.$Class->getTxClass().' Class Round '.$InRound.' Mission Performance Results</h1>';
    $str .= '<h3>'.$Event->getTxEventName().'</h3>';
    $str .= '<table class="w3-table-all w3-tiny">';
    $str .= '<tr>';
    $str .= '<th>Pos.</th>';
    $str .= '<th>#</th>';
    $str .= '<th>University</th>';
    $str .= '<th>Country</th>';
    $str .= '<th>Demo</th>';

    for ($round=1; $round<=$InRound; $round++) {
        $str .= '<th style="text-align: right;">Round '.$round.'</th>';
    }
    $str .= '<th style="text-align: right;">Max<br>Round<br>Score</th>';
#     $str .= '<th style="text-align: right;">Penalties</th>';
    $str .= '<th style="text-align: right;">Final<br>Flight<br>Score</th>';
    $str .= '</tr>';
    $c=1;
    foreach $PkTeamIdx (sort {$MICFLIGHT{$b}{IN_TOTAL} <=> $MICFLIGHT{$a}{IN_TOTAL}} keys %MICFLIGHT) {
        if ($c<4){
            $str .= '<tr style="display: table-row;">';
        } else {
            $str .= '<tr class="micFlighthiddenRow" style="display: '.$display.';">';
        }
        if ($MICFLIGHT{$PkTeamIdx}{IN_TOTAL}>0){
            $str .= '<td>'.$c++.'</td>';
        } else {
            $str .= '<td>---</td>';
        }
        $str .= '<td>'.substr("000".$MICFLIGHT{$PkTeamIdx}{IN_NUMBER},-3,3).'</td>';
        $str .= '<td>'.$MICFLIGHT{$PkTeamIdx}{TX_SCHOOL}.'</td>';
        $str .= '<td>'.$MICFLIGHT{$PkTeamIdx}{TX_COUNTRY}.'</td>';
        $str .= sprintf '<td>%2.2f</td>', $MICFLIGHT{$PkTeamIdx}{IN_DEMO};

        for ($round=1; $round<=$InRound; $round++) {
            $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $MICFLIGHT{$PkTeamIdx}{$round};
        }
        $str .= sprintf '<th style="text-align: right;" class="w3-border-left">%2.2f</th>', $MICFLIGHT{$PkTeamIdx}{IN_MAX};
#         $str .= sprintf '<td style="text-align: right;" class="w3-border-left w3-text-red">-%2.2f</td>', $MICFLIGHT{$PkTeamIdx}{PENALTY};
        $finalScore = $MICFLIGHT{$PkTeamIdx}{IN_TOTAL};
        if ( $MICFLIGHT{$PkTeamIdx}{IN_TOTAL} < 0){$finalScore = 0}
        $str .= sprintf '<th style="text-align: right;" class="w3-border-left">%2.4f</th>', $finalScore;
        $str .= '</tr>';
    }
    $str .= '</table>';
    $str .= '<a class="w3-link w3-small" href="javascript:void(0)" onclick="expandTable(\'micFlighthiddenRow\');">expand/collapse</a>';
    return ($str);
}
sub getMicroFlightResults(){
    my $self = shift;
    my ($PkClassIdx, $PkEventIdx, $InRound) = @_;
    my $str = &_templateMicroFlightResults($PkClassIdx, $PkEventIdx, $InRound, 'table-row');
    return ($str);
}

#==================== REGULAR CLASS ============================
sub getRegularFlightScoreByRound(){
    my ($self) = shift;
    my $InRound = shift;
    my $PkTeamIdx = shift;
    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($PkTeamIdx);
    my $Capacity = $Team->getInCapacity();
    my $SQL = "SELECT SCORE.IN_SCORE, ITEM.TX_SCORE_ITEM FROM TB_SCORE AS SCORE
        JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
        WHERE SCORE.FK_SCORE_GROUP_IDX=? AND SCORE.IN_ROUND=?";
    my $select = $dbi->prepare($SQL);
    $select->execute( 11, $InRound );
    while (my ($InScore, $TxTitle) = $select->fetchrow_array()){
        $SCORE{$TxTitle} = $InScore;
    }
    my $Empty = $Capacity - $SCORE{Load};
    my $FS = (100*$SCORE{Load}) + (50*$SCORE{Cargo}) - (100 * $Empty);
    if ($FS<0){$FS=0}
    return ( $FS );
}
sub getRegularClassFlightLogs(){
    my ($self) = shift;
    my $PkTeamIdx = shift;
    my $PkScoreGroupIdx = shift;
    my %HASH;
    my %CARD;
    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($PkTeamIdx);
    my $Capacity = $Team->getInCapacity();

    my $SQL = "SELECT IN_ROUND, FK_SCORE_ITEM_IDX, IN_SCORE FROM TB_SCORE WHERE FK_SCORE_GROUP_IDX=? AND FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkScoreGroupIdx, $PkTeamIdx);
    while (my ($InRound, $PkScoreItemIdx, $InScore) = $select->fetchrow_array()) {
        $CARD{$InRound}{$PkScoreItemIdx} = $InScore;
    }
    foreach $InRound (sort {$a <=> $b} keys %CARD) {
        my $Empty = $Capacity - $CARD{$InRound}{82};
        my $fs = (100 * $CARD{$InRound}{82}) + (50 * $CARD{$InRound}{80}) - (100 * $Empty);
        if ($fs <0){$fs = 0;}
        $HASH{$InRound} = $fs;
    }
    return (\%HASH);
}
#==================== ADVANCED CLASS ===========================
sub getAdvancedFlightScoreByRound(){
    my ($self) = shift;
    my $InRound = shift;
    my $PkTeamIdx = shift;
    my $SQL = "SELECT ITEM.PK_SCORE_ITEM_IDX, ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, ITEM.IN_PERCENT FROM TB_SCORE AS SCORE
	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
    WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($InRound, $PkTeamIdx, 12);
    while (my ($PkScoreItemIdx, $TxTitle, $InScore, $InPercent) = $select->fetchrow_array()){
        $SCORE{$TxTitle} = $InScore;
        $ZONE{$TxTitle} = $InPercent;
    }
    my $fs = $SCORE{Load} + ($SCORE{Load} * ($SCORE{Zone1} * $ZONE{Zone1} + $SCORE{Zone2} * $ZONE{Zone2} + $SCORE{Zone3} * $ZONE{Zone3} + $SCORE{Zone4} * $ZONE{Zone4}));
    return ($fs);
}
sub getAdvancedClassFlightLogs(){
    my ($self) = shift;
    my $PkTeamIdx = shift;
    my $PkScoreGroupIdx = shift;
    my %HASH;
    my %SCORE;
    my %ZONE;

    my $SQL = "SELECT IN_ROUND, FK_SCORE_ITEM_IDX, IN_SCORE, ITEM.IN_PERCENT, ITEM.TX_SCORE_ITEM
            FROM TB_SCORE AS SCORE
	        JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
            WHERE FK_SCORE_GROUP_IDX=? AND FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkScoreGroupIdx, $PkTeamIdx);
    while (my ($InRound, $PkScoreItemIdx, $InScore, $InPercent, $TxTitle) = $select->fetchrow_array()) {
        $SCORE{$InRound}{$TxTitle} = $InScore;
        $ZONE{$TxTitle}=$InPercent;
    }
    foreach $InRound (sort {$a <=> $b} keys %SCORE) {
        my $fs = $SCORE{$InRound}{Load} + ($SCORE{$InRound}{Load} * ($SCORE{$InRound}{Zone1} * $ZONE{Zone1} + $SCORE{$InRound}{Zone2} * $ZONE{Zone2} + $SCORE{$InRound}{Zone3} * $ZONE{Zone3} + $SCORE{$InRound}{Zone4} * $ZONE{Zone4}));
        $HASH{$InRound} = $fs;
    }
    return (\%HASH);
}
#==================== MICRO CLASS ==============================
sub getMicroFlightScoreByRound(){
    my ($self) = shift;
    my $InRound = shift;
    my $PkTeamIdx = shift;
    my $SQL = "SELECT ITEM.PK_SCORE_ITEM_IDX, ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, ITEM.IN_PERCENT FROM TB_SCORE AS SCORE
	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
    WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($InRound, $PkTeamIdx, 13);
    while (my ($PkScoreItemIdx, $TxTitle, $InScore, $InPercent) = $select->fetchrow_array()){
        $SCORE{$TxTitle} = $InScore;
    }
    my $fs = $SCORE{Load}/($SCORE{Empty}**.5);
    return ($fs);
}
sub getMicroClassFlightLogs(){
    my ($self) = shift;
    my $PkTeamIdx = shift;
    my $PkScoreGroupIdx = shift;
    my %HASH;
    my %SCORE;


    my $SQL = "SELECT IN_ROUND, FK_SCORE_ITEM_IDX, IN_SCORE, ITEM.IN_PERCENT, ITEM.TX_SCORE_ITEM
            FROM TB_SCORE AS SCORE
	        JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
            WHERE FK_SCORE_GROUP_IDX=? AND FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkScoreGroupIdx, $PkTeamIdx);
    while (my ($InRound, $PkScoreItemIdx, $InScore, $InPercent, $TxTitle) = $select->fetchrow_array()) {
        $SCORE{$InRound}{$TxTitle} = $InScore;
    }
    foreach $InRound (sort {$a <=> $b} keys %SCORE) {
        my $fs = $SCORE{$InRound}{Load}/($SCORE{$InRound}{Empty}**.5);
        $HASH{$InRound} = $fs;
    }
    return (\%HASH);
}
#==================== PRESENTATIONS ============================
sub getTeamPresoScoreGroupBySession(){
    my ($self) = shift;
    my $TxSession = shift;

    my $SQL = "SELECT SCORE.TX_SESSION, SUM(G.IN_MAX * (SECTION.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100)) AS IN_TOTAL
        FROM TB_SCORE AS SCORE
         JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
            JOIN TB_SCORE_SECTION AS SECTION ON ITEM.FK_SCORE_SECTION_IDX=SECTION.PK_SCORE_SECTION_IDX
            JOIN TB_SCORE_GROUP AS G ON SECTION.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
            WHERE (SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?)
            GROUP BY SCORE.TX_SESSION";
    my $select = $dbi->prepare($SQL);
    $select->execute($TxSession, 8);
    %HASH = %{$select->fetchall_hashref(['TX_SESSION'])};
    return (\%HASH);
}
sub tabulateReport(){
    my ($self) = shift;
    my $PkPaperIdx = shift;
    my $SQL = "SELECT SUM(G.IN_MAX * (SECTION.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100)) AS TOTAL
        FROM TB_SCORE AS SCORE
	        JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
            JOIN TB_SCORE_SECTION AS SECTION ON ITEM.FK_SCORE_SECTION_IDX=SECTION.PK_SCORE_SECTION_IDX
            JOIN TB_SCORE_GROUP AS G ON SECTION.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
        WHERE SCORE.FK_PAPER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkPaperIdx);

    my $score = $select->fetchrow_array();
    return ( $score );
}
sub getPresoScoreBySession(){
    my ($self) = shift;
    my $TxSession = shift;
    my $SQL = "SELECT sum((G.IN_MAX * (SECTION.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100))) AS TOTAL
        FROM TB_SCORE AS SCORE
         JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
            JOIN TB_SCORE_SECTION AS SECTION ON ITEM.FK_SCORE_SECTION_IDX=SECTION.PK_SCORE_SECTION_IDX
            JOIN TB_SCORE_GROUP AS G ON SECTION.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
        WHERE SCORE.TX_SESSION=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($TxSession);
    my ($score) = $select->fetchrow_array();
    return ($score);
}
sub getEntryCountByTeam(){
    my ($self) = shift;
    my $PkTeamIdx = shift;
    my $SQL = "SELECT COUNT(DISTINCT(TX_SESSION))
        FROM TB_SCORE WHERE FK_SCORE_GROUP_IDX=? AND FK_TEAM_IDX=? GROUP BY FK_TEAM_IDX";
    my $select = $dbi->prepare($SQL);
    $select->execute(8, $PkTeamIdx );
    my ($count) = $select->fetchrow_array();
    return ($count);
}
sub tabulateReview(){
    my ($self) = shift;
    my $PkPaperIdx = shift;


    my $SQL = "SELECT PK_SCORE_GROUP_IDX, TX_SCORE_GROUP FROM TB_SCORE_GROUP";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %GROUP = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
    $SQL = "SELECT SCORE.PK_SCORE_IDX
            , SCORE.IN_SCORE
            , G.PK_SCORE_GROUP_IDX
	        , SECTION.PK_SCORE_SECTION_IDX
	        , SECTION.TX_SCORE_SECTION
            , ITEM.PK_SCORE_ITEM_IDX
            , ITEM.TX_SCORE_ITEM
            , ITEM.BO_BINARY
            , ITEM.IN_ORDER
            , G.IN_MAX
            , SECTION.IN_WEIGHT
            , ITEM.IN_PERCENT
            , (G.IN_MAX * (SECTION.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100)) AS TOTAL
            , (G.IN_MAX * (SECTION.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100)) AS IN_MAX_POINT
            , (G.IN_MAX * (SECTION.IN_WEIGHT/100)) AS IN_SECTION_MAX
        FROM TB_SCORE AS SCORE
         JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
            JOIN TB_SCORE_SECTION AS SECTION ON ITEM.FK_SCORE_SECTION_IDX=SECTION.PK_SCORE_SECTION_IDX
            JOIN TB_SCORE_GROUP AS G ON SECTION.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
        WHERE SCORE.FK_PAPER_IDX=?";
        my $select = $dbi->prepare($SQL);
        $select->execute($PkPaperIdx);
        %PAPER = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX','PK_SCORE_ITEM_IDX'])};

        $SQL = "SELECT FK_TEAM_IDX FROM TB_PAPER WHERE PK_PAPER_IDX=?";
        $select = $dbi->prepare($SQL);
        $select->execute($PkPaperIdx);
        my $PkTeamIdx = $select->fetchrow_array();



        $SQL = "SELECT COMMENT.PK_COMMENT_IDX, COMMENT.FK_SCORE_ITEM_IDX, COMMENT.TX_COMMENT, COMMENT.TS_CREATE, COMMENT.BO_SHOW, CONCAT(USER.TX_FIRST_NAME, ' ', USER.TX_LAST_NAME) AS TX_FULLNAME FROM TB_COMMENT AS COMMENT
            JOIN TB_PAPER AS PAPER ON PAPER.PK_PAPER_IDX=COMMENT.FK_PAPER_IDX
            JOIN TB_USER AS USER ON COMMENT.FK_USER_IDX=USER.PK_USER_IDX
            WHERE PAPER.FK_TEAM_IDX=?";
        my $comment = $dbi->prepare($SQL);
        $comment->execute($PkTeamIdx);
#         print "TeamIDX = $PkTeamIdx";
        %COMMENT = %{$comment->fetchall_hashref(['FK_SCORE_ITEM_IDX','PK_COMMENT_IDX'])};
        my $str;
        my $hdr;
        $str = '<table class="w3-table-all w3-small">';
        $str .= '<thead>';
        $str .= '<tr>';
        $str .= '<th style="width: 20%">Section Title</th>';
        $str .= '<th style="width: 25%">Item Title</th>';
        $str .= '<th class="w3-right-align" style="width: 25%">Judge\'s Assessment</th>';
        $str .= '<th class="w3-right-align" style="width: 10%">Points Available</th>';
        $str .= '<th class="w3-right-align" style="width: 10%">Points Deducted</th>';
        $str .= '<th class="w3-right-align" style="width: 10%">Points Awarded</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        my $totalMax = 0;
        my $totalDeduction = 0;
        my $totalAwarded = 0;
        my $PkScoreGroupIdx=0;
        foreach $PkScoreSectionIdx (sort {$a <=> $b} keys %PAPER) {
            foreach $PkScoreItemIdx (sort {$PAPER{$PkScoreSectionIdx}{$a}{IN_ORDER} <=> $PAPER{$PkScoreSectionIdx}{$b}{IN_ORDER}} keys %{$PAPER{$PkScoreSectionIdx}}) {
                my $maxPoint = $PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{IN_MAX_POINT};
                my $deduction = ($PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{IN_MAX_POINT} - $PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{TOTAL});
                my $pointsAwarded = $PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{TOTAL};
                my $assessment = $PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{IN_SCORE};
                $PkScoreGroupIdx = $PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{PK_SCORE_GROUP_IDX};
                $totalMax += $maxPoint;
                $totalDeduction += $deduction;
                $totalAwarded += $pointsAwarded;
                $str .= '<tr>';
                $str .= sprintf '<td>'.$PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{TX_SCORE_SECTION}.'</td>';
                $str .= '<td>'.$PAPER{$PkScoreSectionIdx}{$PkScoreItemIdx}{TX_SCORE_ITEM}.'</td>';
                $str .= '<td class=" w3-right-align">';
                if ($assessment==0){
                    $str .= sprintf '<span class="w3-yellow"> %2.1f%</span>&nbsp;&nbsp;<span class="w3-text-orange fa fa-warning"></span>', $assessment;
                } else {
                    $str .= '<div class="w3-light-grey w3-small w3-border" style="width: 100%;"> ';
                    if ($assessment<40) {
                        $w3_color = "w3-pale-red";
                    } elsif ($assessment<75) {
                        $w3_color = "w3-pale-yellow";
                    } else {
                        $w3_color = "w3-green";
                    }
                    $str .= '<div class="w3-container '.$w3_color.'" style="width:'.$assessment.'%">'.$assessment.'%</div> ';
                    $str .= '</div> ';
#                     $str .= sprintf '%2.1f%', $assessment;
                }
                $str .= '</td>';
                $str .= sprintf '<td class=" w3-right-align">%2.2f pts</td>', $maxPoint;
                $str .= '<td class="w3-text-red w3-right-align" >';
                if ($deduction>0){$str .= '- '}
                $str .= sprintf '%2.2f pts</td>', $deduction;
                $str .= sprintf '<td class=" w3-right-align">%2.2f pts</td>', $pointsAwarded;
                $str .= '</tr>';
                foreach $PkCommentIdx (sort {$COMMENT{$PkScoreItemIdx}{$a}{PK_COMMENT_IDX} <=> $COMMENT{$PkScoreItemIdx}{$b}{PK_COMMENT_IDX}} keys %{$COMMENT{$PkScoreItemIdx}}) {
                    $str .= '<tr>';
                    $str .= '<td colspan="6">';
                    $str .= '<h5 style="margin: 0!important; padding: 0!important">Comments</h5>';
                    $str .= '<div class="w3-padding w3-container w3-sand w3-border">';
                    $str .= '<span class="w3-tiny"><em>';
                    $userName = 'Anonymous';
                    if ($COMMENT{$PkScoreItemIdx}{$PkCommentIdx}{BO_SHOW} == 1) {
                        $userName = $COMMENT{$PkScoreItemIdx}{$PkCommentIdx}{TX_FULLNAME};
                    }
                    $str .= 'By Judge: '.$userName;
                    $str .= ' [ '.$COMMENT{$PkScoreItemIdx}{$PkCommentIdx}{TS_CREATE}.' ] ';
                    $str .= '</em></span>';
                    $str .= '<br>';
                    $str .= $COMMENT{$PkScoreItemIdx}{$PkCommentIdx}{TX_COMMENT};

                    $str .= '</div>';
                    $str .= '</td>';
                    $str .= '</tr>';
                }
            }
        }
        $str .= '</tbody>';
        $str .= '<tfoot>';
        $str .= '<tr class="w3-large">';
        $str .= '<th colspan="2" style="text-align: right;">TOTAL:</th>';
        $str .= '<th  class=" w3-right-align">&nbsp;</th>';
        $str .= sprintf '<th  class=" w3-right-align">%2.2f</th>', $totalMax;
        $str .= sprintf '<th class="w3-text-red w3-right-align" >-%2.2f</th>', $totalDeduction;
        $str .= sprintf '<th  class=" w3-right-align">%2.4f</th>', $totalAwarded;
        $str .= '</tr>';
        $str .= '</tfoot>';
        $str .= '</table>';

        $hdr = '<div class="w3-container w3-blue">';
        $hdr .= '<h3 style="float: left;">';
        $hdr .= $GROUP{$PkScoreGroupIdx}{TX_SCORE_GROUP};
        if ($totalMax > 0){
            $hdr .= sprintf ': Final Assessment Review (%2.2f%)', 100*($totalAwarded/$totalMax);
        } else {
            $hdr .= ': Final Assessment Review (0.00%)';
        }
        $hdr .= '</h3>';
        $hdr .= '</div>';
        return ($hdr.$str);
}
#==================== STUDENT ==================================
# sub getDesignScoreByTeamIdx(){
#     my ($self) = shift;
#     my $PkTeamIdx = shift;
#         my $SQL = "SELECT SCORE.FK_TEAM_IDX
#  		, SECT.FK_SCORE_GROUP_IDX
#         , SCORE.FK_PAPER_IDX
#         , SUM(G.IN_MAX * (SECT.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100)) AS IN_TOTAL
#     FROM TB_SCORE AS SCORE
# 	JOIN TB_PAPER AS PAPER ON SCORE.FK_PAPER_IDX=PAPER.PK_PAPER_IDX
#     JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX = ITEM.PK_SCORE_ITEM_IDX
#     JOIN TB_SCORE_SECTION AS SECT ON ITEM.FK_SCORE_SECTION_IDX = SECT.PK_SCORE_SECTION_IDX
#     JOIN TB_SCORE_GROUP AS G ON SECT.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
#     JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#     WHERE TEAM.PK_TEAM_IDX=?
#     GROUP BY SCORE.FK_TEAM_IDX
#  		, SECT.FK_SCORE_GROUP_IDX
#         , SCORE.FK_PAPER_IDX";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx);
#     while (my ($PkTeamIdx, $PkScoreGroupIdx, $PkPaperIdx, $InTotal) = $select->fetchrow_array()) {
#         if (exists $EXCLUDE{$PkTeamIdx}){next}
#         $HASH{$PkScoreGroupIdx} = $InTotal;
#         if ($PkScoreGroupIdx==7){
#             push ( @$PkTeamIdx, $InTotal );
#         }
#     }
#     my $DesignScore = $HASH{1} + $HASH{2} + $HASH{3} + &average(@$PkTeamIdx);
#     return ($DesignScore);
# }
# sub getPresoScoreByTeamIdx(){
#     my ($self) = shift;
#     my $PkTeamIdx = shift;
#     my $SQL = "SELECT SUM(G.IN_MAX * (SECTION.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100)) AS IN_TOTAL
#         FROM TB_SCORE AS SCORE
#          JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
#             JOIN TB_SCORE_SECTION AS SECTION ON ITEM.FK_SCORE_SECTION_IDX=SECTION.PK_SCORE_SECTION_IDX
#             JOIN TB_SCORE_GROUP AS G ON SECTION.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
#             WHERE (SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?)
#             GROUP BY SCORE.TX_SESSION";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx, 8);
#     while (my ($InScore) = $select->fetchrow_array()) {
#         push(@SCORE, $InScore);
# #         print "$PkTeamIdx = $InScore<br>";
#     }
#     $SQL = "SELECT TEAM.FK_CLASS_IDX, (DEMO.BO_PASS1 + DEMO.BO_PASS2) AS DEMO FROM TB_DEMO AS DEMO JOIN TB_TEAM AS TEAM ON DEMO.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE FK_TEAM_IDX=?";
#     my $demo = $dbi->prepare($SQL);
#     $demo->execute($PkTeamIdx);
#     my ($PkClassIdx, $InDemo) = $demo->fetchrow_array();
# #     print "$PkClassIdx, $InDemo";
#     my $score = &average(@SCORE);
#     if ($PkClassIdx != 3){
#         $score += (2-$InDemo);
#     }
#     return ($score);
# }
# sub getTeamPresoScore(){
#     my ($self) = shift;
#     my $PkTeamIdx = shift;
#     my $SQL = "SELECT SCORE.TX_SESSION
#         , ITEM.TX_SCORE_ITEM
#         , SCORE.FK_SCORE_ITEM_IDX
#         , G.IN_MAX * (SECT.IN_WEIGHT/100) * (ITEM.IN_PERCENT/100) * (SCORE.IN_SCORE/100) AS IN_TOTAL FROM TB_SCORE AS SCORE
#         JOIN TB_SCORE_ITEM AS ITEM on SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
#         JOIN TB_SCORE_SECTION AS SECT ON ITEM.FK_SCORE_SECTION_IDX=SECT.PK_SCORE_SECTION_IDX
#         JOIN TB_SCORE_GROUP AS G ON SECT.FK_SCORE_GROUP_IDX=G.PK_SCORE_GROUP_IDX
#         JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#         WHERE SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx, 8);
#     while (my ($TxSession, $TxScoreItem, $PkScoreItemIdx, $InScore) = $select->fetchrow_array()) {
#         $ITEM{$PkScoreItemIdx} = $TxScoreItem;
#         $SCORE{$TxSession}{$PkScoreItemIdx} = $InScore;
#         push (@$TxSession, $InScore);
#     }
#
#     $SQL = "SELECT TEAM.FK_CLASS_IDX, (DEMO.BO_PASS1 + DEMO.BO_PASS2) AS DEMO FROM TB_DEMO AS DEMO JOIN TB_TEAM AS TEAM ON DEMO.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE FK_TEAM_IDX=?";
#     my $demo = $dbi->prepare($SQL);
#     $demo->execute($PkTeamIdx);
#     my ($PkClassIdx, $InDemo) = $demo->fetchrow_array();
#     if ($PkClassIdx != 3){
#         $InDemoScore = (2-$InDemo) ;
#     } else {
#         $InDemoScore = 0;
#     }
# #     print "\$PkTeamIdx = $PkTeamIdx<br>";
#     my $TotalJudge = scalar(keys %SCORE);
#     my $str;
#     $str = '<div class="w3-container w3-blue">';
#     $str .= '<h2 >Presentation Score Summary</h2>';
#     $str .= '</div>';
#
#     $str .= '<table class="w3-table-all">';
#     $str .= '<thead>';
#     $str .= '<tr>';
#     $str .= '<th>Section Title</th>';
#     for($i=1; $i<=$TotalJudge; $i++){
#         $str .= '<th class="w3-right-align">Judge #'.$i.'</th>';
#     }
#     $str .= '<th class="w3-right-align">Average</th>';
#     $str .= '</tr>';
#     $str .= '</thead>';
#     $str .= '<tbody>';
#     my $total = 0;
#     foreach $PkScoreItemIdx (sort keys %ITEM) {
#         $str .= '<tr>';
#         $str .= '<td>'.$ITEM{$PkScoreItemIdx}.'</td>';
#         foreach $TxSession (sort keys %SCORE) {
#             $str .= sprintf '<td class="w3-right-align">%2.4f</td>', $SCORE{$TxSession}{$PkScoreItemIdx};
#             push (@$PkScoreItemIdx, $SCORE{$TxSession}{$PkScoreItemIdx});
#         }
# #         print join(", ", @$PkScoreItemIdx);
#         $total += &average(@$PkScoreItemIdx);
#         $str .= sprintf '<td class="w3-right-align">%2.4f</td>', &average(@$PkScoreItemIdx);
#         $str .= '</tr>';
#     }
#     $str .= '<tr>';
#     $str .= '<th>SubTotal Presentation Score</th>';
#     foreach $TxSession (sort keys %SCORE) {
#         $str .= sprintf '<th class="w3-right-align">%2.4f</th>', sum(@$TxSession);
#         push (@SUBTOITAL, sum(@$TxSession));
#
#     }
# #     $total += &average(@$PkScoreItemIdx);
#     $str .= sprintf '<th class="w3-right-align">%2.4f</th>', &average(@SUBTOITAL);
#     $str .= '</tr>';
#     if ($PkClassIdx != 3){
#         $str .= '<tr>';
#         $str .= '<td class="w3-right-align" colspan="'.($TotalJudge+1).'">Demonstration Requirement = </td>';
#         $str .= sprintf '<td class="w3-right-align"><b>%2.4f</b></td>', $InDemoScore;
#         $str .= '</tr>';
#     }
#     $str .= '<tr>';
#     $str .= '<td class="w3-right-align" colspan="'.($TotalJudge+1).'">Total Presentation Score = </td>';
#     $str .= sprintf '<td class="w3-right-align"><b>%2.4f</b></td>', $total + $InDemoScore;
#     $str .= '</tr>';
#     $str .= '</tbody>';
#     $str .= '</table>';
#     return ($str);
# }
# sub getPenaltyByTeamIdx(){
#     my ($self) = shift;
#     my $PkTeamIdx = shift;
#     my $Penalty = 0;
#     my $SQL = "SELECT IN_SCORE FROM TB_SCORE WHERE FK_TEAM_IDX=? AND FK_SCORE_GROUP_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx, 10);
#     while (my ($InScore) = $select->fetchrow_array()) {
#         $Penalty += $InScore;
#     }
#     return ($Penalty);
# }
# sub getPenaltyDetails(){
#     my ($self) = shift;
#     my $PkTeamIdx = shift;
#     my $str;
#     my %PEN;
#     my $Total = 0;
#     my $SQL = "SELECT PK_SCORE_IDX, TX_TITLE, TX_COMMENT, IN_SCORE FROM TB_SCORE WHERE FK_TEAM_IDX=? AND FK_SCORE_GROUP_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx, 10);
# #     print "$PkTeamIdx, 10<br>";
#     %PEN = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
#     $str = '<div class="w3-container w3-blue">';
#     $str .= '<h2 >Detailed Penalty Summary</h2>';
#     $str .= '</div>';
#     $str .= '<table class="w3-table-all">';
#     $str .= '<thead>';
#     $str .= '<tr>';
#     $str .= '<th style="width: 15%;">Title</th>';
#     $str .= '<th>Description</th>';
#     $str .= '<th class="w3-text-red w3-right-align" style="width: 15%;">Points<br>Deducted</th>';
#     $str .= '</tr>';
#     $str .= '</thead>';
#     $str .= '</tbody>';
#     foreach $PkScoreIdx (sort {$a <=> $b} keys %PEN ) {
#         $str .= '<tr>';
#         $str .= '<td>'.$PEN{$PkScoreIdx}{TX_TITLE}.'</td>';
#         $str .= '<td>'.$PEN{$PkScoreIdx}{TX_COMMENT}.'</td>';
#         $str .= sprintf '<td class="w3-right-align w3-text-red">-%2.4f</td>', $PEN{$PkScoreIdx}{IN_SCORE};
#         $Total += $PEN{$PkScoreIdx}{IN_SCORE};
#         $str .= '</tr>';
#     }
#     $str .= '</tbody>';
#     $str .= '<tfoot>';
#     $str .= '<tr>';
#     $str .= '<th colspan="2" class="w3-text-red w3-right-align">Total</th>';
#     $str .= sprintf '<th class="w3-text-red w3-right-align">-%2.4f</th>', $Total;
#     $str .= '</tr>';
#     $str .= '</tfoot>';
#     $str .= '</table>';
#     return ($str);
# }
# sub getFlightScoreByTeamIdx(){
#     my ($self) = shift;
#     my $PkTeamIdx = shift;
#     my $MicroScore = 0;
#     my $MaxScore = 0;
#     my $SQL = "SELECT FK_CLASS_IDX, FK_EVENT_IDX FROM TB_TEAM WHERE PK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($PkTeamIdx);
#     my ($PkClassIdx, $PkEventIdx) = $select->fetchrow_array();
#     $SQL = "SELECT MAX(SCORE.IN_ROUND) FROM TB_SCORE AS SCORE
# 	    JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
#         WHERE TEAM.FK_EVENT_IDX=?";
#     my $round = $dbi->prepare($SQL);
#     $round->execute($PkEventIdx);
#     my ($MaxRound) = $round->fetchrow_array();
#     if($MaxRound==0){$MaxRound=1}
#     for ($round=1; $round<=$MaxRound; $round++){
#         if ($PkClassIdx == 1){
#             $score += _getRegularFlightScoreByRound($round, $PkTeamIdx);
#         } elsif ($PkClassIdx == 2) {
#             $score += _getAdvancedFlightScoreByRound($round, $PkTeamIdx);
#         } elsif ($PkClassIdx == 3) {
#             $MicroScore = _getMicroFlightScoreByRound($round, $PkTeamIdx);
#             if ($MicroScore > $MaxScore){$MaxScore = $MicroScore}
#             $score += $MicroScore;
#         } else {
#             $score = 'ERROR';
#         }
#     }
#     if ($PkClassIdx == 1){
#         $score = sprintf "%2.4f", (1/(40 * $MaxRound))*$score;
#     } elsif ($PkClassIdx == 3) {
#         $score = sprintf "%2.4f", (20*(.5*($score/$MaxRound) + .5*($MaxScore)));
#     } else {
#         $score = sprintf "%2.4f", (4*($score/$MaxRound));
#     }
#     return ($score);
# }
# sub _getAdvancedFlightScoreByRound(){
#     my $InRound = shift;
#     my $PkTeamIdx = shift;
#     my $SQL = "SELECT SCORE.IN_ROUND, ITEM.PK_SCORE_ITEM_IDX, ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, ITEM.IN_PERCENT FROM TB_SCORE AS SCORE
# 	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
#     WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($InRound, $PkTeamIdx, 12);
#     while (my ($Round, $PkScoreItemIdx, $TxTitle, $InScore, $InPercent) = $select->fetchrow_array()){
#         $SCORE{$TxTitle} = $InScore;
#         $ZONE{$TxTitle} = $InPercent;
#         $SEEN{$Round}=1;
#     }
#     my $fs = 0;
#     if (exists $SEEN{$InRound}){
#         $fs = $SCORE{Load} + ($SCORE{Load} * ($SCORE{Zone1} * $ZONE{Zone1} + $SCORE{Zone2} * $ZONE{Zone2} + $SCORE{Zone3} * $ZONE{Zone3} + $SCORE{Zone4} * $ZONE{Zone4}));
#     }
# #     print "\$fs = $fs<br>";
#     return ($fs);
# }
# sub _getRegularFlightScoreByRound(){
#     my $InRound = shift;
#     my $PkTeamIdx = shift;
#     my $Team = new SAE::TB_TEAM();
#     $Team->getRecordById($PkTeamIdx);
#     my $InScore = 0;
#     my $Capacity = $Team->getInCapacity();
#     my $FS = 0;
#     my $SQL = "SELECT SCORE.IN_ROUND, SCORE.IN_SCORE, ITEM.TX_SCORE_ITEM FROM TB_SCORE AS SCORE
#         JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
#         WHERE SCORE.FK_SCORE_GROUP_IDX=? AND SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute( 11, $InRound, $PkTeamIdx );
#     while (my ($Round, $InScore, $TxTitle) = $select->fetchrow_array()){
#         $SCORE{$TxTitle} = $InScore;
#         $SEEN{$Round}=1;
#     }
# #     print "$SEEN{$InRound} ";
#
#     my $Empty = $Capacity - $SCORE{Load};
#     if (exists $SEEN{$InRound}){
#         $FS = (100*$SCORE{Load}) + (50*$SCORE{Cargo}) - (100 * $Empty);
#     } else {
#         $FS=0
#     }
#     if ($FS<0){$FS=0}
#     return ( $FS );
# }
# sub _getMicroFlightScoreByRound(){
#     my $InRound = shift;
#     my $PkTeamIdx = shift;
#     my $SQL = "SELECT ITEM.PK_SCORE_ITEM_IDX, ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, ITEM.IN_PERCENT FROM TB_SCORE AS SCORE
# 	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
#     WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
#     my $select = $dbi->prepare($SQL);
#     $select->execute($InRound, $PkTeamIdx, 13);
#     while (my ($PkScoreItemIdx, $TxTitle, $InScore, $InPercent) = $select->fetchrow_array()){
#         $SCORE{$TxTitle} = $InScore;
#     }
#     my $fs = $SCORE{Load}/($SCORE{Empty}**.5);
# #     print "\$fs = $fs<br>";
#     return ($fs);
# }
