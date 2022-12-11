package SAE::TECH;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;
use SAE::TEAM;
use SAE::FLIGHT;


my $dbi = new SAE::Db();
my %TECH;
my %COUNTRY;

sub new{
    my $className = shift;
    my $self = {};
    bless($self, $className);   
    return $self;
    }

# -------------- 2023 --------------
sub _getMyReinspection (){
    my ($self, $teamIDX) = @_;
    my $str = &getMyReinspection($teamIDX);
    return ($str);
    }
sub getInspectionItemDetails (){
    my ($inspectIDX) = @_;
    my $SQL = "SELECT FLIGHT.CL_NOTES AS ATTEMPT_NOTES, TEAM.TX_SCHOOL, TEAM.TX_NAME, TEAM.TX_COUNTRY, TEAM.FK_CLASS_IDX, INSPECT.* FROM TB_REINSPECT AS INSPECT 
            JOIN TB_TEAM AS TEAM ON INSPECT.FK_TEAM_IDX = TEAM.PK_TEAM_IDX 
            JOIN TB_FLIGHT AS FLIGHT ON INSPECT.FK_FLIGHT_IDX = FLIGHT.PK_FLIGHT_IDX 
        WHERE (INSPECT.PK_REINSPECT_IDX=?)";
    my $select = $dbi->prepare($SQL);
        $select->execute( $inspectIDX );
    my %HASH = %{$select->fetchrow_hashref()}; 
    return (\%HASH);
    }
sub _getInspectionItemDetails (){
    my ($self, $inspectIDX) = @_;
    my %HASH = %{&getInspectionItemDetails($inspectIDX)}; 
    return (\%HASH);
    }
sub _getTechButton(){
    my ($self, $inspectIDX) = @_;
    my %TECH = %{&getInspectionItemDetails($inspectIDX)}; 
    my $cleared = $TECH{BO_STATUS};
    my $str;
    if ($cleared == 0){ # 1=Not cleared; 0=Cleared
            $str = sprintf '<li ID="REINSPECT_%d" class="w3-bar w3-margin-top w3-card w3-round w3-border w3-hide w3-green inspectionItem inspectionItemCleared" onclick="reviewClearedInspectionDetails(this, %d);">', $inspectIDX, $inspectIDX;
        } else {
            $str = sprintf '<li ID="REINSPECT_%d" class="w3-bar w3-white w3-margin-top w3-card w3-round w3-border inspectionItem" onclick="reviewInspectionDetails(this, %d);">', $inspectIDX, $inspectIDX;
        }
    $str .= '<div class="w3-bar-item">';
    $str .= sprintf '<span class="w3-large">%03d - <b>%s</b></span><br>', $TECH{IN_NUMBER}, $TECH{TX_SCHOOL};
    $str .= sprintf '<i>Reinspection requested after Attempt <span class="w3-yellow w3-border w3-padding-left w3-padding-right">';
    $str .= sprintf '&nbsp;&nbsp;#%s&nbsp;&nbsp;</span></i>', $TECH{IN_ROUND};
    $str .= '</div>';
    $str .= '</li>';

    return ($str);
    }
sub _getListToBeReinspected (){
    my ($self, $eventIDX) = @_;
    # my $SQL = "SELECT TEAM.TX_SCHOOL, 
    #     TEAM.TX_NAME, TEAM.TX_COUNTRY, TEAM.FK_CLASS_IDX, INSPECT.* FROM TB_REINSPECT AS INSPECT 
    #     JOIN TB_TEAM AS TEAM ON INSPECT.FK_TEAM_IDX = TEAM.PK_TEAM_IDX WHERE (INSPECT.FK_EVENT_IDX=?)";
    my $SQL = "SELECT * FROM TB_REINSPECT WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
            $select->execute( $eventIDX );
        my %HASH = %{$select->fetchall_hashref('PK_REINSPECT_IDX')}; 
        return (\%HASH);
    }
sub getMyReinspection (){
    my ($teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_REINSPECT where (FK_TEAM_IDX=? AND BO_STATUS=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my %TECH = %{$select->fetchall_hashref('PK_REINSPECT_IDX')}; 
    my $str;
    $str .= 'Hello World';


    return ($str);



    }
# -------------- 2023 --------------


# sub new{
# 	$className = shift;
# 	my $self = {};
#     my $location = shift;
#     # my $SQL = "SELECT TD.*, T.*, F.IN_ROUND FROM TB_TODO AS TD JOIN TB_TEAM as T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX JOIN TB_FLIGHT AS F ON TD.FK_FLIGHT_IDX=F.PK_FLIGHT_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=?)";
#     my $SQL = "SELECT TD.*, T.IN_NUMBER FROM TB_TODO AS TD JOIN TB_TEAM AS T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=?)";
#     my $select = $dbi->prepare($SQL);
#        $select->execute($location, 4);
#     %TECH = %{$select->fetchall_hashref('PK_TODO_IDX')};   
    
# 	bless($self, $className);
# 	return $self;
# }


sub _checkIfReInspectIsNeeded(){
    my ($self, $eventIDX, $teamIDX) = @_;
    my $SQL = "SELECT TD.*, T.IN_NUMBER FROM TB_TODO AS TD JOIN TB_TEAM AS T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=? AND FK_TEAM_IDX=? AND IN_CLEAR=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX, 4, $teamIDX, 0);
    my %TECH = %{$select->fetchall_hashref('PK_TODO_IDX')};   
    if (scalar(keys %TECH)>0){
        return 1;
    } else {
        return 0;
    }
}
sub _getTechListData(){
    my $self = shift;
    return (\%TECH);
}
sub genTechButton(){
    my ($todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    my %ARCHIVE = (0=>'',       1=>'sae-archive w3-light-grey w3-hide');
    my %CHECKED = (0=>'',       1=>'checked');
    my %COLOR   = (0=>'w3-red', 1=>'w3-green');
    my %STATUS = (1=>'w3-green', 2=>'w3-yellow', 3=>'w3-red', ''=>'w3-green', 0=>'w3-green');
    my $height  = 45;
    my $Team    = new SAE::TEAM($teamIDX);
    my $Flight    = new SAE::FLIGHT($flightIDX);
    my %TEAM    = %{$Team->_getTeamData()};
    my %FLIGHT    = %{$Flight->_getFlightData()};
    my $techBtn = sprintf '<li ID="TODO_IDX_%d"  class="%s w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-white w3-display-container w3-hover-yellow sae_inspectionItems" onclick="sae_openReinspectionDetails(%d, %d, %d, \'%s\');">', $flightIDX, $ARCHIVE{$boArchive}, $todoIDX, $teamIDX, $flightIDX, $COLOR{$boArchive};
    $techBtn .= '<i class="fa fa-chevron-right fa-2x w3-display-right  w3-margin-right" aria-hidden="true"></i>';
    $techBtn .= sprintf '<span class="w3-bar-item w3-circle w3-border %s w3-display-left w3-margin-left w3-center" style="height: %dpx; width: %dpx;">', $COLOR{$boArchive}, $height, $height;
    $techBtn .= sprintf '<div style="margin-left: -7px; margin-top: 4px;">%03d</div>', $TEAM{IN_NUMBER};
    $techBtn .= '</span>';
    $techBtn .= '<div class="w3-bar-item w3-small" style="margin-left: 35px; text-align: left; padding-right: 100px;">';
    $techBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_SCHOOL};
    $techBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_COUNTRY};
    $techBtn .= sprintf '<span>Crashed Attempt #%d: - Reinspection Required</span><br>', $FLIGHT{IN_ROUND};
    $techBtn .= '</li>';
    return ($techBtn);
}
sub _generateTechButton(){
    my ($self, $todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    my $str = &genTechButton($todoIDX, $flightIDX, $teamIDX, $boArchive);
    return ($str);

    # my %DATA;
    # $DATA{techBtn} = $techBtn;
    # $DATA{logBtn} = $logBtn;
    # my $json = encode_json \%DATA;
    # return ($techBtn);
    # return($str);
}
sub _generateLogButton(){
    my ($self, $todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    my $str = genLogButton($todoIDX, $flightIDX, $teamIDX, $boArchive);
    return ($str);
}

sub genLogButton(){
    my ($todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    # my %STATUS = (1=>'w3-green', 2=>'w3-yellow', 3=>'w3-red', ''=>'w3-green', 0=>'w3-green');
    my $height  = 45;
    my $Team    = new SAE::TEAM($teamIDX);
    my $Flight    = new SAE::FLIGHT($flightIDX);
    my %TEAM    = %{$Team->_getTeamData()};
    my %FLIGHT    = %{$Flight->_getFlightData()};
    my $logBtn = sprintf '<li ID="TEAM_%d" class="w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-display-container w3-white" onclick="sae_openClearCrash(this, %d, \'%03d\', %d, %d);" >', $teamIDX, $teamIDX, $TEAM{IN_NUMBER}, $TEAM{FK_CLASS_IDX}, $flightIDX;
    $logBtn .= '<i class="fa fa-chevron-right fa-2x w3-display-right w3-text-grey w3-margin-right" aria-hidden="true"></i>';                                                                         
    $logBtn .= sprintf '<span class="w3-bar-item w3-circle w3-border w3-display-left w3-margin-left w3-center w3-red" style="height: %dpx; width: %dpx;">', $height, $height;
    $logBtn .= sprintf '<div style="margin-left: -7px; margin-top: 4px;">%03d</div>', $TEAM{IN_NUMBER};
    $logBtn .= '</span>';
    $logBtn .= '<div class="w3-bar-item w3-small" style="margin-left: 35px; text-align: left; padding-right: 100px;">';
    $logBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_SCHOOL};
    $logBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_COUNTRY};
    $logBtn .= sprintf '<span>Crashed Rnd %d: - Reinspection Required</span><br>', $FLIGHT{IN_ROUND};
    $logBtn .= '</div>';
    $logBtn .= '</li>';
    return ($logBtn);
}
return (1);