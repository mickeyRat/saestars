package SAE::MIC_SCORE;

use DBI;
use SAE::SDB;
use SAE::FLIGHT;
use List::Util qw(sum);
use Math::Trig;

my $dbi = new SAE::Db();

sub new{
	my $className = shift;
	my $self = {};
	bless($self, $className);	
	return $self;
    }

### from INTERNAL CALLS
	sub getFlightLogs (){
	    my ($teamIDX) = @_;
	    my $str;
	    my $SQL = "SELECT * FROM TB_FLIGHT where (FK_TEAM_IDX=? AND IN_STATUS=?)";
		my $select = $dbi->prepare($SQL);
	        $select->execute( $teamIDX, 1 );
	    my %HASH = %{$select->fetchall_hashref('PK_FLIGHT_IDX')}; 
	    return (\%HASH);
		}
	sub calculateFlightScore(){
		my ($flightIDX) = @_;
		my $Flight = new SAE::FLIGHT();
		my %DATA;
		my %FLIGHT = %{$Flight->_getFlightTicketDetails($flightIDX)};
		my $inRaw = 0;
	    my $fs    = 0;
	    my $bonus = 0;
	    my $minor = 0;
	    my $major = 0;
		my $inLarge    = $FLIGHT{IN_LARGE};
	    my $inLbDamage = $FLIGHT{IN_LB_DAMAGE};
	    my $inSmall    = $FLIGHT{IN_SMALL};
	    my $inSbDamage = $FLIGHT{IN_SB_DAMAGE};
	    my $inPayload  = $FLIGHT{IN_WEIGHT};
	    my $inTof      = $FLIGHT{IN_TOF};

	    my $bonus = 0.5+(1*($inLarge+($inLbDamage*.5)))+(.4*($inSmall + ($inSbDamage*.5)));
	    if ($inTof>0){
	        $inRaw = 80*(sqrt($inPayload*$bonus)/$inTof);
	    }
	    my $fs = $inRaw* (1-($FLIGHT{IN_PEN_MINOR} * 0.25)) * (1-($FLIGHT{IN_PEN_LANDING}* 0.5));
	    my %ZONE = (1=>"Yes", 0=>"No");
	    $DATA{$flightIDX}{PK_FLIGHT_IDX} = $flightIDX;
	    $DATA{$flightIDX}{FK_TEAM_IDX}   = $FLIGHT{FK_TEAM_IDX};
	    $DATA{$flightIDX}{IN_WEIGHT}     = $FLIGHT{IN_WEIGHT};
	    $DATA{$flightIDX}{IN_ROUND}      = $FLIGHT{IN_ROUND};
	    $DATA{$flightIDX}{IN_MINOR}      = $ZONE{$FLIGHT{IN_PEN_MINOR}};
	    $DATA{$flightIDX}{IN_MAJOR}      = $ZONE{$FLIGHT{IN_PEN_LANDING}};
	    $DATA{$flightIDX}{IN_LARGE}      = $inLarge;
	    $DATA{$flightIDX}{IN_LB_DAMAGE}  = $inLbDamage;
	    $DATA{$flightIDX}{IN_SMALL}      = $inSmall;
	    $DATA{$flightIDX}{IN_SB_DAMAGE}  = $inSbDamage;
	    $DATA{$flightIDX}{IN_TOF}        = $inTof;
	    $DATA{$flightIDX}{IN_BONUS}      = $bonus;
	    $DATA{$flightIDX}{IN_RAW}        = $inRaw;
	    $DATA{$flightIDX}{IN_FS}         = $fs;
	    return (\%DATA);
		}
	sub getTop3(){
		my ($score) = @_;
		my %SCORE = %$score;
		my @SORTED = (sort {$SCORE{$b}{IN_FS} <=> $SCORE{$a}{IN_FS}} keys %SCORE);
		my $sumOfTopThree = 0;
		for ($x=0; $x<=2; $x++){
	        $sumOfTopThree += $SCORE{$SORTED[$x]}{IN_FS};
	    }
		return ($sumOfTopThree);
		}
sub _savePerformanceScores(){
    my ($self, $publishIDX, $teamIDX, $inFlight) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_FLIGHT) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inFlight);
    return;
}
sub _saveOverallScores(){
    my ($self, $publishIDX, $teamIDX, $inDesign, $inPres, $inFlight, $inPenalty, $inOverall) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_DESIGN, IN_PRESO, IN_FLIGHT, IN_PENALTY, IN_OVERALL) VALUES (?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inDesign, $inPres, $inFlight, $inPenalty, $inOverall);
    return;
}
sub _getTeamList (){
    my ($self, $eventIDX) = @_;
    my $SQL  = "SELECT * FROM TB_TEAM WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, 3 );
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
    }
sub _getScore(){
	my ($self, $teamIDX) = @_;
    # my $Score = new SAE::MIC_SCORE();
    my %LOGS = %{&getFlightLogs($teamIDX)};
    my %SCORE;
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        %SCORE = (%SCORE, %{&calculateFlightScore($flightIDX)});
    }
    my $str;
    my $maxWs = 0;
    my $maxWeight = 0;
    my %PEN = (0=>'-', 1=>'Yes');
    my $top3 = &getTop3(\%SCORE);
    return ($top3);
    }

sub _getTeamScores(){
	my ($self, $teamIDX) = @_;
    # my $Score = new SAE::MIC_SCORE();
    my %LOGS = %{&getFlightLogs($teamIDX)};
    my %SCORE;
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        %SCORE = (%SCORE, %{&calculateFlightScore($flightIDX)});
    }
    my $str;
    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th style="width: 50px;"><br>Att</th>';
    $str .= '<th style="width: 100px;text-align: right;">N<sub>large</sub><br><span class="w3-small">Good</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">N<sub>large</sub><br><span class="w3-small">Damaged</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">N<sub>small</sub><br><span class="w3-small">Good</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">N<sub>small</sub><br><span class="w3-small">Damaged</span></th>';
    $str .= '<th style="width: 100px;text-align: right;"><br><span class="w3-small">W<sub>payload</sub></span></th>';
    $str .= '<th style="width: 100px;text-align: right;"><br>T<sub>flight</sub></th>';
    $str .= '<th style="width: 100px;text-align: right;"><br><span class="w3-small">Bonus</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">Raw<br><span class="w3-small">Score</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">Minor<br><span class="w3-small">Penalty</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">Major<br><span class="w3-small">Penalty</span></th>';
    $str .= '<th style="width: 100px;text-align: right;">Flight<br><span class="w3-small">Score</span></th>';
    $str .= '</tr>';
    $str .= '</thead>';
    my $maxWs = 0;
    my $maxWeight = 0;
    my %PEN = (0=>'-', 1=>'Yes');
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        $str .= '<tr>';
        $str .= sprintf '<td>%d</td>', $SCORE{$flightIDX}{IN_ROUND};
        $str .= sprintf '<td style="text-align: right;">%d</td>', $SCORE{$flightIDX}{IN_LARGE};
        $str .= sprintf '<td style="text-align: right;">%d</td>', $SCORE{$flightIDX}{IN_LB_DAMAGE};
        $str .= sprintf '<td style="text-align: right;">%d</td>', $SCORE{$flightIDX}{IN_SMALL};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_SB_DAMAGE};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_WEIGHT};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_TOF};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_BONUS};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_RAW};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $SCORE{$flightIDX}{IN_MINOR};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $SCORE{$flightIDX}{IN_MAJOR};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_FS};
        $str .= '</tr>';
    }
    my $top3 = &getTop3(\%SCORE);
    $str .= '<tr>';
    $str .= '<td colspan="11" class="w3-large" style="text-align: right;">Top 3 Flight Score (FS<sub>1</sub> + FS<sub>2</sub> + FS<sub>3</sub>)</td>';
    $str .= sprintf '<td class="w3-large" style="text-align: right;">%2.4f</td>', $top3;
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<br>'x3;
    return ($str);
    }
return (1);