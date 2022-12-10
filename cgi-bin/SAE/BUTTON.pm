package SAE::BUTTON;
use DBI;
use SAE::SDB;
use SAE::RUBRIC;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub generateFlightButtonStatus(){
    my ($self, $flightIDX, $teamIDX, $inRound, $inStatus, $classIDX) = @_;
    my $Team = new SAE::TEAM($teamIDX);
    my %TEAM = %{$Team->_getTeamData()};
    my $height = 45;
    my %STATUS = (1=>'w3-green', 2=>'w3-yellow', 3=>'w3-red', ''=>'w3-green', 0=>'w3-green');
    my $str;
    if ($classIDX==3) {
        $str = sprintf '<li ID="TEAM_%d" class="w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-white w3-display-container" onclick="sae_recordFlightCard_Mic(this, %d, %d, \'%03d\', %d);" >', $teamIDX, $flightIDX, $teamIDX, $TEAM{IN_NUMBER}, $inRound;
    } elsif ($classIDX==2) {
        $str = sprintf '<li ID="TEAM_%d" class="w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-white w3-display-container" onclick="sae_recordFlightCard_Adv(this, %d, %d, \'%03d\', %d);" >', $teamIDX, $flightIDX, $teamIDX, $TEAM{IN_NUMBER}, $inRound;
    } else {
        $str = sprintf '<li ID="TEAM_%d" class="w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-white w3-display-container" onclick="sae_recordFlightCard(this, %d, %d, \'%03d\', %d);" >', $teamIDX, $flightIDX, $teamIDX, $TEAM{IN_NUMBER}, $inRound;
    }
    $str .= '<i class="fa fa-chevron-right fa-2x w3-display-right w3-text-grey  w3-margin-right" aria-hidden="true"></i>';
    $str .= sprintf '<span class="w3-bar-item w3-circle w3-border w3-display-left w3-margin-left w3-center %s" style="height: %dpx; width: %dpx;">', $STATUS{$inStatus}, $height, $height;
    $str .= sprintf '<div style="margin-left: -7px; margin-top: 4px;">%03d</div>', $TEAM{IN_NUMBER};
    $str .= '</span>';
    $str .= '<div class="w3-bar-item w3-small" style="margin-left: 35px; text-align: left; padding-right: 100px;">';
    $str .= sprintf '<span>%s</span><br>', $TEAM{TX_SCHOOL};
    $str .= sprintf '<span>%s</span><br>', $TEAM{TX_COUNTRY};
    $str .= sprintf '<span>Checked-Out: <b class="w3-yellow">Attempt #%d</b></span><br>', $inRound;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
return(1);