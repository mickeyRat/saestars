package SAE::ADV_SCORE;

use DBI;
use SAE::SDB;
use SAE::FLIGHT;
use List::Util qw(sum);
use Math::Trig;

my $dbi = new SAE::Db();
my $dropZoneRadius = 15; # Radius of the Drop Zone


sub new{
	my $className = shift;
	my $self = {};
	bless($self, $className);	
	return $self;
    }
sub calculate_Bpada(){
    my ($std, $inZone, $inStatic, $d) = @_;
    my $Zpada = 0;
    my $Bpada = 0;
    if ($inZone == 1 && $d<=$dropZoneRadius){ # Yes, PADA is in Zone
    	if ($inStatic == 1) {
    			$Zpada = 1;
    		} else {
    			$Zpada = 2;
    		}
    		if ($std > 0) {
    				my $x = 1/($std*sqrt(2*pi()));
    				$Bpada = 5*($x*exp(-($d**2)/(2*$std**2)));
    				return ($Zpada, $Bpada);
    			} else {
    				return (0, 0);
    			}
    	} else {
    		return (0, 0);
    	}
    }
sub _savePerformanceScores(){
    my ($self, $publishIDX, $teamIDX, $inPayload, $inPada, $inFlight) = @_;
    my $SQL = "INSERT INTO TB_SCORE (FK_PUBLISH_IDX, FK_TEAM_IDX, IN_PAYLOAD, IN_PADA, IN_FLIGHT) VALUES (?, ?, ?, ?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($publishIDX, $teamIDX, $inPayload, $inPada, $inFlight);
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
       $select->execute( $eventIDX, 2 );
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
    my $maxWater = 0;
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        $maxWater += $SCORE{$flightIDX}{IN_EFF_WATER};
    }
    my ($top3, $used) = &getTop3(\%SCORE);
    return ($top3);
}
sub _getGtvScore (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT IN_STD, BO_AUTO, IN_WATER FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my ($inStd, $boAuto, $inWater) = $select->fetchrow_array();   
    my $gtvMultiplier = 2.0;
    if ($boAuto<1) {$gtvMultiplier = 1.5}
    my $gtvScore = ($gtvMultiplier*$inWater)/4;
    return ($gtvScore);
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
    $str .= '<th style="width: 100px;text-align: right;"><br>Std. Dev</th>';
    $str .= '<th style="width: 100px;text-align: right;"><br>In Zone</th>';
    $str .= '<th style="width: 100px;text-align: right;">Zone<br>Type</th>';
    $str .= '<th style="width: 100px;text-align: right;">Distance<br>(feet)</th>';
    $str .= '<th style="width: 100px;text-align: right;">Water<br>Weight (lbs)</th>';
    $str .= '<th style="width: 100px;text-align: right;"><br>Z<sub>PADA</sub></th>';
    $str .= '<th style="width: 100px;text-align: right;"><br>B<sub>PADA</sub></th>';
    $str .= '<th style="width: 100px;text-align: right;">Raw<br>Score</th>';
    $str .= '<th style="width: 75px;text-align: right;">Minor<br>Penalty</th>';
    $str .= '<th style="width: 75px;text-align: right;">Major<br>Penalty</th>';
    $str .= '<th style="width: 75px;text-align: right;">Effective<br>Water</th>';
    $str .= '<th style="width: 100px;text-align: right;">Flight<br>Score</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    my $maxWs = 0;
    my $maxWeight = 0;
    my %PEN = (0=>'-', 1=>'Yes');
    my $maxWater = 0;
    my ($top3, $used) = &getTop3(\%SCORE);
    my %USED = %$used;
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        $maxWater += $SCORE{$flightIDX}{IN_EFF_WATER};
        # $str .= '<tr>';
        if (exists $USED{$flightIDX}){
                $str .= '<tr class="w3-pale-yellow">';
            } else {
                $str .= '<tr>';
            }
        $str .= sprintf '<td>%d</td>', $SCORE{$flightIDX}{IN_ROUND};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_STD};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $SCORE{$flightIDX}{IN_ZONE};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $SCORE{$flightIDX}{IN_TYPE};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_DISTANCE};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_WATER_FLT};
        $str .= sprintf '<td style="text-align: right;">%d</td>', $SCORE{$flightIDX}{IN_ZPADA};
        $str .= sprintf '<td style="text-align: right;">%2.8f</td>', $SCORE{$flightIDX}{IN_BPADA};
        $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_RAW};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $PEN{$SCORE{$flightIDX}{IN_MINOR}};
        $str .= sprintf '<td style="text-align: right;">%s</td>', $PEN{$SCORE{$flightIDX}{IN_MAJOR}};
        $str .= sprintf '<td style="text-align: right;">%2.2f</td>', $SCORE{$flightIDX}{IN_EFF_WATER};
        if (exists $USED{$flightIDX}){
                $str .= sprintf '<td class="w3-large" style="text-align: right;"><b>%2.4f</b></td>', $SCORE{$flightIDX}{IN_FS};
            } else {
                $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $SCORE{$flightIDX}{IN_FS};
            }
        $str .= '</tr>';
    }
    $str .= '<tr>';
    $str .= '<td colspan="12" style="text-align: right;"><span class="w3-large">Gross water weight available for GVT competition (lbs.)</span></td>';
    $str .= sprintf '<td style="text-align: right;"><span class="w3-large">%2.2f</span></td>', $maxWater;
    $str .= '</tr>';
    $str .= '<tr >';
    $str .= '<td colspan="12" style="text-align: right;"><span class="w3-large">Top 3 Flight Score (FS<sub>1</sub> + FS<sub>2</sub> + FS<sub>3</sub>)</span></td>';
    $str .= sprintf '<td style="text-align: right;"><span class="w3-large">%2.4f</span></td>', $top3;
    $str .= '</tr>';
    $str .= '</table>';
    $str .= '<br>'x3;
    return ($str);
    }
sub _getEffectiveWater (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT PK_FLIGHT_IDX, IN_ROUND, IN_WATER_FLT, IN_PEN_MINOR, IN_PEN_LANDING FROM TB_FLIGHT WHERE (FK_TEAM_IDX=? AND IN_STATUS=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX, 1);
    my %HASH = %{$select->fetchall_hashref('PK_FLIGHT_IDX')}; 
    my $effectiveWater = 0;
    my $totalWater = 0;
    foreach $flightIDX (keys %HASH){
    	my $minor = (1-($HASH{$flightIDX}{IN_PEN_MINOR}   * 0.25));
    	my $major = (1-($HASH{$flightIDX}{IN_PEN_LANDING} * 0.50));
    	my $water = $HASH{$flightIDX}{IN_WATER_FLT};
    	$effectiveWater += $water *  $minor * $major;
    	}
    return ($effectiveWater);
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
sub calculateFlightScore (){
	my ($flightIDX) = @_;
	my $Flight = new SAE::FLIGHT();
	my %FLIGHT = %{$Flight->_getFlightTicketDetails($flightIDX)};
	my $std = $FLIGHT{IN_STD};
	my $inZone = $FLIGHT{BO_INZONE};
	my $inStatic = $FLIGHT{BO_STATIC};
	my $inDistance = $FLIGHT{IN_DISTANCE};
	my $inWaterFlt = $FLIGHT{IN_WATER_FLT};
	my ($Zpada, $Bpada) = &calculate_Bpada($std, $inZone, $inStatic, $inDistance);
	my %DATA;
	my $inRawScore = $inWaterFlt + (8 * ($Zpada + $Bpada));
	my $fs = $inRawScore* (1-($FLIGHT{IN_PEN_MINOR} * 0.25)) * (1-($FLIGHT{IN_PEN_LANDING}* 0.5));
	my $effectiveWater = $inWaterFlt* (1-($FLIGHT{IN_PEN_MINOR} * 0.25)) * (1-($FLIGHT{IN_PEN_LANDING}* 0.5));
	if ($inDistance <= $dropZoneRadius) {$inZone = "Yes"} else {$inZone = "No"} 
	my %ZONE = (1=>"Yes", 0=>"-");
	my %TYPE = (1=>"Static", 0=>"Random", 2=>"Random");
	$DATA{$flightIDX}{PK_FLIGHT_IDX} = $flightIDX;
    $DATA{$flightIDX}{FK_TEAM_IDX}   = $FLIGHT{FK_TEAM_IDX};
    $DATA{$flightIDX}{IN_WATER_FLT}  = $FLIGHT{IN_WATER_FLT};
    $DATA{$flightIDX}{IN_ROUND}      = $FLIGHT{IN_ROUND};
    $DATA{$flightIDX}{IN_MINOR}      = $ZONE{$FLIGHT{IN_PEN_MINOR}};
    $DATA{$flightIDX}{IN_MAJOR}      = $ZONE{$FLIGHT{IN_PEN_LANDING}};
    $DATA{$flightIDX}{IN_DISTANCE}   = $inDistance;
    $DATA{$flightIDX}{IN_TYPE}       = $TYPE{$inStatic};
    $DATA{$flightIDX}{IN_ZONE}       = $ZONE{$inZone};
    $DATA{$flightIDX}{IN_STD}        = $std;
    $DATA{$flightIDX}{IN_ZPADA}      = $Zpada;
    $DATA{$flightIDX}{IN_BPADA}      = $Bpada;
    $DATA{$flightIDX}{IN_RAW}        = $inRawScore;
    $DATA{$flightIDX}{IN_EFF_WATER}  = $effectiveWater;
    $DATA{$flightIDX}{IN_FS}         = $fs;
    return (\%DATA);
    }
sub getTop3(){
	my ($score) = @_;
	my %SCORE = %$score;
	my @SORTED = (sort {$SCORE{$b}{IN_FS} <=> $SCORE{$a}{IN_FS}} keys %SCORE);
    my %USED;
	# print "Scored 0 = $SORTED[0]\n\n";
	my $sumOfTopThree = 0;
	for ($x=0; $x<=2; $x++){
            $sumOfTopThree += $SCORE{$SORTED[$x]}{IN_FS};
            $USED{$SORTED[$x]} = 1;
	    }
		# return ($sumOfTopThree);
        return ($sumOfTopThree, \%USED);
		}

return(1);