package SAE::FLIGHT;

use DBI;
use SAE::SDB;
use URI::Escape;
# use DateTime;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ===============================================================
# GET
# ===============================================================
sub _getTeamByLocation(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getCardStatusByEvent(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_FLIGHT WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','IN_ROUND'])}; 
    return (\%HASH);
}
sub _getTeamDataById(){
    my $self = shift;
    my $teamIDX = shift; 
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getCardStatusByID(){
    my $self = shift;
    my $flightIDX = shift;
    my $SQL = "SELECT * FROM TB_FLIGHT WHERE PK_FLIGHT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($flightIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getInspectionItems(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_INSPECTION";
    my $select = $dbi->prepare($SQL);
        $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_INSPECTION_IDX')}; 
    return (\%HASH);
}
sub _getCrashDataByEvent(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT TODO.*, FLIGHT.IN_ROUND
        FROM TB_TODO AS TODO JOIN TB_FLIGHT AS FLIGHT ON TODO.FK_FLIGHT_IDX=FLIGHT.PK_FLIGHT_IDX 
        WHERE ((TODO.FK_EVENT_IDX=?) AND (TODO.FK_TODO_TYPE_IDX=?) AND (TODO.IN_CLEAR=?))";
    my $select = $dbi->prepare($SQL);
        $select->execute($location, 4, 0);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getCrashDataByTeamId(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT TODO.*, FLIGHT.IN_ROUND 
        FROM TB_TODO AS TODO JOIN TB_FLIGHT AS FLIGHT ON TODO.FK_FLIGHT_IDX=FLIGHT.PK_FLIGHT_IDX 
        WHERE ((TODO.FK_TEAM_IDX=?) AND (TODO.FK_TODO_TYPE_IDX=?) AND (TODO.IN_CLEAR=?))";
    my $select = $dbi->prepare($SQL);
        $select->execute($teamIDX, 4, 0);
    my %HASH = %{$select->fetchall_hashref('PK_TODO_IDX')}; 
    return (\%HASH);
}
sub _getMetricListByStatus(){
    my $self = shift;
    my $inStatus = shift;
    my $location = shift;
    my $select;
    if ($inStatus == 0){
        my $SQL = "SELECT M.*, T.*, F.IN_ROUND FROM TB_METRIC AS M 
            JOIN TB_TEAM AS T ON M.FK_TEAM_IDX=T.PK_TEAM_IDX 
            JOIN TB_FLIGHT AS F ON F.PK_FLIGHT_IDX=M.FK_FLIGHT_IDX
            WHERE M.FK_EVENT_IDX=?";
        $select = $dbi->prepare($SQL);
        $select->execute( $location);
    } else {
        my $SQL = "SELECT M.*, T.*, F.IN_ROUND  FROM TB_METRIC AS M 
            JOIN TB_TEAM AS T ON M.FK_TEAM_IDX=T.PK_TEAM_IDX 
            JOIN TB_FLIGHT AS F ON F.PK_FLIGHT_IDX=M.FK_FLIGHT_IDX
            WHERE M.IN_STATUS=? AND M.FK_EVENT_IDX=?";
        $select = $dbi->prepare($SQL);
        $select->execute($inStatus, $location);
    }
    my %HASH = %{$select->fetchall_hashref('FK_FLIGHT_IDX')}; 
    return (\%HASH);
}
# ===============================================================
# INSERT
# ===============================================================
sub _createFlightCard(){
    my $self = shift;
    my $teamIDX = shift;
    my $inRound = shift;
    my $location = shift;
    my $SQL = "INSERT INTO TB_FLIGHT (FK_TEAM_IDX, IN_ROUND, FK_EVENT_IDX, TX_STATUS, TX_COLOR) VALUES (?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($teamIDX , $inRound , $location, 'Out-'.$inRound, 'w3-yellow');
    my $flightIDX = $insert->{q{mysql_insertid}};
    return($flightIDX);
}
sub _submitCrashReport(){
	my $self = shift;
	my $flightIDX = shift;
    my $hashData = shift;
	my $FIELDS = join(", ", keys %$hashData);
	my @VALUES = uri_unescape(values %$hashData);
	my $value = join ', ', (split(/ /, "? " x (scalar(keys %$hashData))));
	my $SQL = "INSERT INTO TB_TODO ($FIELDS) VALUES ($value);";
	my $insert = $dbi->prepare($SQL);
	for ($i=1; $i <= scalar(@VALUES); $i++) {
		$insert->bind_param($i ,$VALUES[$i-1]);
	}
	$insert->execute();
	my $todoIDX = $insert->{q{mysql_insertid}};
    print $SQL;
	return ( $todoIDX );
}
sub _addNewInspectionItem(){
    my $self = shift;
    my $txItem = shift;
    my $SQL = "INSERT INTO TB_INSPECTION (TX_ITEM) VALUES (?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($txItem);
    # my $flightIDX = $insert->{q{mysql_insertid}};
    return();
}

# ===============================================================
# UPDATES
# ===============================================================
sub _updateMetric(){
    my $self = shift;
    my $inStatus = shift;
    my $flightIDX = shift;
    my $final = shift;
    my $SQL;
    my $inSuccess = 0;
    if ($inStatus==2) {
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_INLINE=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } elsif($inStatus==3) {
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_READY=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } elsif($inStatus==4) {
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_START=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } elsif($inStatus==5) {
        $inSuccess=1;
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_COMPLETE=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } elsif($inStatus==6) {
        $inSuccess=0;
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_WEIGH_IN=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } elsif($inStatus==7) {
        $inSuccess=0;
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_WEIGH_IN=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } elsif($inStatus==8) {
        $inSuccess=1;
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_WEIGH_IN=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    } else {
        $inSuccess = $final;
        $SQL="UPDATE TB_METRIC SET IN_STATUS=?, TS_LOGIN=CURRENT_TIMESTAMP, BO_SUCCESS=? WHERE FK_FLIGHT_IDX=?";
    }
    $update = $dbi->prepare($SQL);
    $update->execute($inStatus, $inSuccess, $flightIDX);
    # print "\$inStatus=$inStatus, \$inSuccess=$inSuccess, \$flightIDX=$flightIDX\n";
    return;
}
sub _updateFlightCardStatus(){
    my $self = shift;
    my $flightIDX = shift;
    my $inStatus = shift;
    my $inRound = shift;

    my %COLOR = (0=>'w3-yellow',1=>'w3-green',2=>'w3-grey',3=>'w3-red');
    my %STATUS = (0=>'Out-'.$inRound,1=>'Good',2=>'DNF',3=>'Crash');
    # 0 = out, 1 = success, 2 = DNF, 3 = Crashed
    if ($inStatus > 1){
        my $SQL = "UPDATE TB_FLIGHT SET IN_STATUS=?, TX_STATUS=?, TX_COLOR=?, IN_LCARGO=?, IN_SPHERE=?, IN_WEIGHT=?, IN_SPAN=?, IN_DENSITY=?, TX_TIME=?, FK_WEATHER_IDX=?, IN_COLONIST=?, IN_HABITAT=?, IN_WATER=?, IN_EMPTY=?, IN_PEN_MINOR=?, IN_PEN_LANDING=? WHERE PK_FLIGHT_IDX=?";
        my $update = $dbi->prepare($SQL);
        $update->execute($inStatus, $STATUS{$inStatus}, $COLOR{$inStatus}, 0,0,0,0,0,0,0,0,0,0,0,0,0, $flightIDX);
    } else {
        my $SQL = "UPDATE TB_FLIGHT SET IN_STATUS=?, TX_STATUS=?, TX_COLOR=? WHERE PK_FLIGHT_IDX=?";
        my $update = $dbi->prepare($SQL);
        $update->execute($inStatus, $STATUS{$inStatus}, $COLOR{$inStatus}, $flightIDX);
    }
    
    return;
}
sub _updateToDoFlightCard(){
    my $self = shift;
    my $flightIDX = shift;
    my $todoIDX = shift;
    my $SQL = "UPDATE TB_FLIGHT SET FK_TODO_IDX=?, TX_COLOR WHERE PK_FLIGHT_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute( $todoIDX , 'w3-purple' , $flightIDX );
    return;
}
sub _updateReinspectionItems(){
    my $self = shift;
    my $todoIDX = shift;
    my $SQL = "UPDATE TB_TODO SET IN_CLEAR=? WHERE PK_TODO_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute( 1, $todoIDX);
    return;
}
sub _updateSuccessFlight(){
	my $self = shift;
	my $flightIDX = shift;
    my $hashData = shift;
	my $FIELDS = join("=?, ", keys %$hashData)."=? ";
	my @VALUES = uri_unescape(values %$hashData);
	my $value = join ', ', (split(/ /, "? " x (scalar(keys %$hashData))));
	my $SQL = "UPDATE TB_FLIGHT SET $FIELDS WHERE PK_FLIGHT_IDX=?";
	my $insert = $dbi->prepare($SQL);
	for ($i=1; $i <= scalar(@VALUES); $i++) {
		$insert->bind_param($i ,$VALUES[$i-1]) || die "$!";
	}
	$insert->bind_param($i,$flightIDX) ;
	$insert->execute();
	return ($SQL);
}
# sub _updateCardStatus(){
#     my $self = shift;
#     my $cardIDX = shift;
#     my $status = shift; #1= Draft, 2 = Done
#     my $SQL = "UPDATE TB_CARD SET IN_STATUS=? WHERE PK_CARD_IDX=?";
#     my  $update = $dbi->prepare($SQL);
#         $update->execute($status, $cardIDX);
#     return;
# }
# sub _updateCardAssessments(){
#     my $self = shift;
#     my $cardIDX = shift;
#     my $hashData = shift;
#     my %DATA = %$hashData;
#     my $SQL = "UPDATE TB_PAPER SET IN_VALUE=? WHERE (FK_CARD_IDX=? AND FK_SUBSECTION_IDX=?)";
#     my $update = $dbi->prepare($SQL);
#     foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
#         $update->execute($DATA{$subSectionIDX}, $cardIDX, $subSectionIDX) || die "Cannot Add @_"; 
#     }
#     return ();
# }

# ===============================================================
# DELETES
# ===============================================================
sub _deleteFlightCardById(){
    my $self = shift;
    my $flightIDX = shift;
    my $SQL = "DELETE FROM TB_FLIGHT WHERE PK_FLIGHT_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute($flightIDX);
    return
}
return (1);