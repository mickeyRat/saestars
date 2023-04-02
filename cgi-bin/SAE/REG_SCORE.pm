package SAE::REG_SCORE;

use DBI;
use SAE::SDB;
use SAE::TB_TEAM;
use SAE::FLIGHT;
# use v5.10.1;
use Number::Format 'format_price';
use List::Util qw(sum);

my $dbi = new SAE::Db();
# my %TEAM=();
my $mult = 0.9375;

sub new{
	my $className = shift;
	my $self = {};
	bless($self, $className);	
	return $self;
	}
sub _getFlightLogs (){
    my ($self, $teamIDX) = @_;
    my $str;
    my $SQL = "SELECT * FROM TB_FLIGHT where (FK_TEAM_IDX=? AND IN_STATUS=?)";
	my $select = $dbi->prepare($SQL);
        $select->execute( $teamIDX, 1 );
    my %HASH = %{$select->fetchall_hashref('PK_FLIGHT_IDX')}; 
    return (\%HASH);
	}
sub _calculateFlightScore (){
    my ($self, $teamIDX, $flightIDX, $inWeight) = @_;
    my %DATA;
    my ($den, $inMinor, $inMajor, $inRound, $inSpan) = &getDensityAltitude($flightIDX);
    my ($predicted, $ppb) = &calculatePayloadPrediction($teamIDX, $inWeight, $den);
    my $inRawScore = (($inWeight/2) + $ppb) ;
    my $fs = $inRawScore* (1-($inMinor * 0.25)) * (1-($inMajor* 0.5));
    $DATA{$flightIDX}{PK_FLIGHT_IDX} = $flightIDX;
    $DATA{$flightIDX}{FK_TEAM_IDX} = $teamIDX;
    $DATA{$flightIDX}{IN_WEIGHT} = $inWeight;
    $DATA{$flightIDX}{IN_ROUND} = $inRound;
    $DATA{$flightIDX}{IN_MINOR} = $inMinor;
    $DATA{$flightIDX}{IN_MAJOR} = $inMajor;
    $DATA{$flightIDX}{IN_DENSITY} = $den;
    $DATA{$flightIDX}{IN_PREDICTED} = $predicted;
    $DATA{$flightIDX}{IN_BONUS} = $ppb;
    $DATA{$flightIDX}{IN_RAW} = $inRawScore;
    $DATA{$flightIDX}{IN_FS} = $fs;
    $DATA{$flightIDX}{IN_SPAN} = &convertInchesToFeet($inSpan);
    $DATA{$flightIDX}{IN_WS} = &getWingSpanScore($inSpan);
    return (\%DATA);
	}
sub _getTop3(){
	my ($self, $score) = @_;
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

sub calculatePayloadPrediction (){
	my ($teamIDX, $actual, $den) = @_;
    # print qq(\$teamIDX=$teamIDX<br> \$actual=$actual<br> \$den=$den <br>);
	my $SQL = "SELECT IN_SLOPE, IN_YINT FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my ($slope, $yInt) = $select->fetchrow_array();
    my $predicted = ($slope * $den) + $yInt;
    my $ppb = 0;
    if ($actual>0){
        $ppb = (5 - ($actual - $predicted)**2);
    }
    if ($ppb<0){$ppb =0}
    return ($predicted, $ppb);
	}
sub getDensityAltitude (){
	my $flightIDX= shift;
	my $SQL = "SELECT IN_DENSITY FROM TB_FLIGHT WHERE PK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
       $select->execute($flightIDX);
    my ($inDensityAltitude) = $select->fetchrow_array();
    return ($inDensityAltitude);
	}
sub getWingSpanScore(){
	my $inSpan= shift;
	my $ws = 0;
	if ($inSpan) {$ws = 2**(1 +(($inSpan/12)/5))}
	return($ws);
	}
sub convertInchesToFeet(){
	my $inches= shift;
	my $feet = int($inches / 12);
	my $in = ($inches % 12);
	my $str = sprintf "%02d'-%02d\"", $feet, $in;
	return ($str);
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
       $select->execute( $eventIDX, 1 );
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
    }
sub _getScore (){
    my ($self, $teamIDX) = @_;
    my %LOGS = %{&getFlightLogs($teamIDX)};
    my %SCORE;
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        %SCORE = (%SCORE, %{&calculateFlightScore($flightIDX)});
    }
    my $str;
    my $maxWs = 0;
    my $maxWeight = 0;
    my %PEN = (0=>'-', 1=>'Yes');
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        if ($SCORE{$flightIDX}{IN_WEIGHT} > $maxWeight){
            $maxWs = $SCORE{$flightIDX}{IN_WS};
            $maxWeight = $SCORE{$flightIDX}{IN_WEIGHT};
        }
    }
    my ($top3, $used) = &getTop3(\%SCORE);
    my $Score = ($top3 + $maxWs);
    return ($Score);
    }
sub _getTeamScores (){
    my ($self, $teamIDX) = @_;
    my %LOGS = %{&getFlightLogs($teamIDX)};
    my %SCORE;
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        %SCORE = (%SCORE, %{&calculateFlightScore($flightIDX)});
    }
    my $str;
    $str .= '<table class="w3-table w3-bordered w3-small">';
    $str .= '<thead>';
    $str .= '<tr>';
    $str .= '<th style="width: 50px;"><br>Att</th>';
    $str .= '<th style="width: 100px;text-align: right;">Wingspan<br>(ft-in)</th>';
    $str .= '<th style="width: 100px;text-align: right;">Den-Alt<br>(ft)</th>';
    $str .= '<th style="width: 100px;text-align: right;">Payload<br>(lbs)</th>';
    $str .= '<th style="width: 100px;text-align: right;">Predicted<br>(lbs)</th>';
    $str .= '<th style="width: 100px;text-align: right;">Bonus<br>(PPB)</th>';
    $str .= '<th style="width: 100px;text-align: right;">Raw<br>Score</th>';
    $str .= '<th style="width: 75px;text-align: right;">Minor<br>Penalty</th>';
    $str .= '<th style="width: 75px;text-align: right;">Major<br>Penalty</th>';
    $str .= '<th style="width: 100px;text-align: right;">Flight<br>Score</th>';
    $str .= '<th style="width: 100px;text-align: right;">Wingspan<br>Score</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    my $maxWs = 0;
    my $maxWeight = 0;
    my %PEN = (0=>'-', 1=>'Yes');
    # my $top3 = &getTop3(\%SCORE);
    my ($top3, $used) = &getTop3(\%SCORE);
    my %USED = %$used;
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        if ($SCORE{$flightIDX}{IN_WEIGHT} > $maxWeight){
            $maxWs = $SCORE{$flightIDX}{IN_WS};
            $maxWeight = $SCORE{$flightIDX}{IN_WEIGHT};
        }
        if (exists $USED{$flightIDX}){
                $str .= '<tr class="w3-pale-yellow">';
            } else {
                $str .= '<tr>';
            }
        # $str .= '<tr>';
        $str .= sprintf '<td>%d</td>', $SCORE{$flightIDX}{IN_ROUND};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $SCORE{$flightIDX}{IN_SPAN};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_DENSITY};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_WEIGHT};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_PREDICTED};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_BONUS};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_RAW};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $PEN{$SCORE{$flightIDX}{IN_MINOR}};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $PEN{$SCORE{$flightIDX}{IN_MAJOR}};
        # $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_FS};
        if (exists $USED{$flightIDX}){
                $str .= sprintf '<td class="w3-large" style="text-align: right;"><b>%2.4f</b></td>', $SCORE{$flightIDX}{IN_FS};
            } else {
                $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_FS};
            }
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_WS};
        $str .= '</tr>';
    }
    $str .= '<tr>';
    $str .= '<td colspan="10" class="w3-large" style="text-align: right;">Max Wingspan Score</td>';
    $str .= sprintf '<td class="w3-large" style="text-align: right;">%2.4f</td>', $maxWs;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td colspan="10" class="w3-large" style="text-align: right;">Top 3 Flight Score (FS<sub>1</sub> + FS<sub>2</sub> + FS<sub>3</sub>)</td>';
    $str .= sprintf '<td class="w3-large" style="text-align: right;">%2.4f</td>', $top3;
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td colspan="10" class="w3-large" style="text-align: right;">Final Flight Score</td>';
    $str .= sprintf '<td class="w3-large" style="text-align: right;">%2.4f</td>', ($top3 + $maxWs);
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<br>'x3;
    return ($str);
    }
sub calculateFlightScore (){
    my ($flightIDX) = @_;
    my %DATA;
    my $Flight   = new SAE::FLIGHT();
	my %FLIGHT   = %{$Flight->_getFlightTicketDetails($flightIDX)};
	my $inWeight = $FLIGHT{IN_WEIGHT};
	my $inMajor  = $FLIGHT{IN_PEN_LANDING};
	my $inMinor  = $FLIGHT{IN_PEN_MINOR};
	my $inRound  = $FLIGHT{IN_ROUND};
	my $inSpan   = $FLIGHT{IN_SPAN};
    my $teamIDX  = $FLIGHT{FK_TEAM_IDX};
	my $den = &getDensityAltitude($flightIDX);
    # printf "den = %2.8f<br>",$den;
    my ($predicted, $ppb) = &calculatePayloadPrediction($teamIDX, $inWeight, $den);
    # printf "predicted = %2.8f<br>",$predicted;
    my $inRawScore = (($inWeight/2) + $ppb) ;
    my $fs = $inRawScore* (1-($inMinor * 0.25)) * (1-($inMajor* 0.5));
    $DATA{$flightIDX}{PK_FLIGHT_IDX} = $flightIDX;
    $DATA{$flightIDX}{FK_TEAM_IDX}   = $teamIDX;
    $DATA{$flightIDX}{IN_WEIGHT}     = $inWeight;
    $DATA{$flightIDX}{IN_ROUND}      = $inRound;
    $DATA{$flightIDX}{IN_MINOR}      = $inMinor;
    $DATA{$flightIDX}{IN_MAJOR}      = $inMajor;
    $DATA{$flightIDX}{IN_DENSITY}    = $den;
    $DATA{$flightIDX}{IN_PREDICTED}  = $predicted;
    $DATA{$flightIDX}{IN_BONUS}      = $ppb;
    $DATA{$flightIDX}{IN_RAW}        = $inRawScore;
    $DATA{$flightIDX}{IN_FS}         = $fs;
    $DATA{$flightIDX}{IN_SPAN}       = &convertInchesToFeet($inSpan);
    $DATA{$flightIDX}{IN_WS}         = &getWingSpanScore($inSpan);
    return (\%DATA);
	}
sub getFlightLogs (){
    my ($teamIDX) = @_;
    my $str;
    my $SQL = "SELECT * FROM TB_FLIGHT where (FK_TEAM_IDX=? AND IN_STATUS=?)";
	my $select = $dbi->prepare($SQL);
        $select->execute( $teamIDX, 1 );
    my %HASH = %{$select->fetchall_hashref('PK_FLIGHT_IDX')}; 
    return (\%HASH);
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





return (1);