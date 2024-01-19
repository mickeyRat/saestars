package SAE::MIC_SCORE;

use DBI;
use SAE::SDB;
use SAE::FLIGHT;
use SAE::MICRO;
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
	    my %ZONE = (1=>"Yes", 0=>"-");
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
        my %USED;
		my $sumOfTopThree = 0;
		for ($x=0; $x<=2; $x++){
	        $sumOfTopThree += $SCORE{$SORTED[$x]}{IN_FS};
            $USED{$SORTED[$x]} = 1;
	    }
		return ($sumOfTopThree, \%USED);
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
    my ($top3, $used) = &getTop3(\%SCORE);
    return ($top3);
    }

sub _getTeamScores(){
	my ($self, $teamIDX) = @_;
    # my $Score = new SAE::MIC_SCORE();
    my $Micro = new SAE::MICRO();
    my @LIST = ();
    my %LOGS = %{&getFlightLogs($teamIDX)};
    my %SCORE;
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        %SCORE = (%SCORE, %{&calculateFlightScore($flightIDX)});
    }
    my %PEN = (0=>'-', 1=>'Yes');
    my $str;

    $str .= '<table class="w3-table-all">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th style="width: 50px;   text-align: left";  >Att.</th>';
    $str .= '<th style="width: 100px; text-align: right" >Empty<br>Weight</th>';
    $str .= '<th style="width: 100px; text-align: right" >Winspan<br>(in)</th>';
    $str .= '<th style="width: 100px; text-align: right" >Takeoff<br>Bonus</th>';
    $str .= '<th style="width: 100px; text-align: right" >Payload<br>(lbs)</th>';
    $str .= '<th style="width: 100px; text-align: right" >25%<br>Penalty</th>';
    $str .= '<th style="width: 100px; text-align: right" >50%<br>Penalty</th>';
    $str .= '<th style="width: 300px; text-align: right" >Flight<br>Score</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        my $score = $Micro->_calc24_FLightScore($flightIDX);
        push (@LIST, $score);
        $str .= '<tr>';
        $str .= sprintf '<td>%d</td>', $SCORE{$flightIDX}{IN_ROUND};
        $str .= sprintf '<td style="text-align: right;">%2.1f</td>', $LOGS{$flightIDX}{IN_EMPTY};
        $str .= sprintf '<td style="text-align: right;">%2.1f</td>', $LOGS{$flightIDX}{IN_SPAN};
        $str .= sprintf '<td style="text-align: right;">%2.1f</td>', $LOGS{$flightIDX}{IN_DISTANCE};
        $str .= sprintf '<td style="text-align: right;">%2.1f</td>', $LOGS{$flightIDX}{IN_WEIGHT};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $PEN{$LOGS{$flightIDX}{IN_PEN_MINOR}};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $PEN{$LOGS{$flightIDX}{IN_PEN_LANDING}};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $score;
        $str .= '</tr>';
    }
    my @SORTED = sort {$b <=> $a} @LIST;
    $str .= '</tbody>';
    $str .= '<tr>';
    $str .= '<td colspan="8" class="w3-large" style="text-align: right;">Final Score = Top 3 Flight Score (FS<sub>1</sub> + FS<sub>2</sub> + FS<sub>3</sub>)';
    # $str .= sprintf '%2.4f + %2.4f + %2.4f', $SORTED[0], $SORTED[1], $SORTED[2];
    my $top3 = $SORTED[0]+$SORTED[1]+$SORTED[2];
    $str .= '</td>';
    # $str .= sprintf '<td class="w3-large" style="text-align: right;">%2.4f</td>', $top3;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= sprintf '<td colspan="7" class="w3-large" style="text-align: right;"></td>', ;
    $str .= sprintf '<td class="w3-large" style="text-align: right;">%2.4f + %2.4f + %2.4f = <b class="w3-xlarge">%2.4f</b></td>', $SORTED[0], $SORTED[1], $SORTED[2], $top3;
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<br>'x3;
    return ($str);
    }
return (1);