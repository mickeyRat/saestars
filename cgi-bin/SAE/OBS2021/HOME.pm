package SAE::HOME;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# =====================================================================================================
#  GETTERS
# =====================================================================================================
sub _getTeamSubscriptionsByUserID(){
	my $self = shift;
	my $userIDX = shift;
	my $location = shift;
	my $SQL = "SELECT UT.*, TEAM.* 
		FROM TB_USER_TEAM AS UT JOIN TB_TEAM AS TEAM ON UT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
		WHERE (UT.FK_USER_IDX=? AND TEAM.FK_EVENT_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute($userIDX, $location);
	%HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};
	return (\%HASH);
}
sub _getTiles(){
	my $self = shift;
	my $SQL = "SELECT * FROM TB_TILES WHERE IN_TYPE=? AND IN_ORDER<=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute(0,4);
	%HASH = %{$select->fetchall_hashref('PK_TILES_IDX')};
	return (\%HASH);
}
sub _getToDoByTeamID(){
	my $self = shift;
	my $userIDX = shift;
	my $SQL = "SELECT UT.*, TYPE.TX_TODO, TODO.* FROM TB_USER_TEAM AS UT 
	JOIN TB_TODO AS TODO ON UT.FK_TEAM_IDX=TODO.FK_TEAM_IDX 
	JOIN TB_TODO_TYPE AS TYPE ON TODO.FK_TODO_TYPE_IDX=TYPE.PK_TODO_TYPE_IDX
    WHERE UT.FK_USER_IDX=? AND TODO.IN_CLEAR=?";
    
	my $select = $dbi->prepare($SQL);
	   $select->execute($userIDX, 0);
	%HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_TODO_IDX'])};
	return (\%HASH);
}
sub _getAllToDoByEvent(){
	my $self = shift;
	my $location = shift;
	my $SQL = "SELECT TODO.*, TYPE.* FROM TB_TODO AS TODO JOIN TB_TODO_TYPE AS TYPE ON TODO.FK_TODO_TYPE_IDX=TYPE.PK_TODO_TYPE_IDX
	    WHERE TODO.FK_EVENT_IDX=? AND TODO.IN_CLEAR=? ";
	my $select = $dbi->prepare($SQL);
	   $select->execute($location, 0);
	%HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_TODO_IDX'])};
	return (\%HASH);
}

sub _getFlightRounds(){
	my $self = shift;
	my $userIDX = shift;
	my $location = shift;
	my $SQL = "SELECT UT.*, FLIGHT.* FROM TB_USER_TEAM AS UT 
		JOIN TB_FLIGHT AS FLIGHT ON UT.FK_TEAM_IDX=FLIGHT.FK_TEAM_IDX
		WHERE (UT.FK_USER_IDX=? AND FLIGHT.FK_EVENT_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute($userIDX, $location);
	%HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_FLIGHT_IDX'])};
	return (\%HASH);
}
# =====================================================================================================
#  INSERTS
# =====================================================================================================


# =====================================================================================================
#  UPDATES
# =====================================================================================================


# =====================================================================================================
#  DELETES
# =====================================================================================================

return (1);