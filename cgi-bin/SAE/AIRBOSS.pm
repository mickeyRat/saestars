package SAE::AIRBOSS;

use DBI;
use SAE::SDB;


my $dbi = new SAE::Db();
my %TEAM;


sub new{
	$className = shift;
	my $self = {};
	my $idx = shift;
	if ($idx) {
        my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
        my $select = $dbi->prepare($SQL);
           $select->execute($idx);
        %TEAM = %{$select->fetchall_hashref('PK_TEAM_IDX')};
        # %TEAM = %{$select->fetchrow_hashref()};
	}
	bless($self, $className);
	return $self;
}
sub _getTeamData(){
    my $self = shift;
    return (\%TEAM);
}
sub _getNotes(){
    my $self = shift;
	my $idx = shift;
	my %HASH;
	my $SQL = "SELECT CL_DESCRIPTION, CL_COMMENT FROM TB_TODO WHERE (FK_TODO_TYPE_IDX=? AND FK_TEAM_IDX=?) ORDER BY PK_TODO_IDX ASC";
	my $select = $dbi->prepare($SQL);
      $select->execute(4, $idx);
    my $counter = 1;
    while (my ($txItem, $txNotes) = $select->fetchrow_array()) {
        if ($txItem){
            $HASH{$counter++} = sprintf '<b class="w3-text-red">Watch For:</b><br>%s', $txItem;
        }
        if ($txNotes){
            $HASH{$counter++} = sprintf '<b class="w3-text-orange">Crash Notes:</b><br>%s', $txNotes;
        }
    }

    $SQL = "SELECT CL_NOTES FROM TB_NOTES WHERE FK_TEAM_IDX=? ORDER BY PK_NOTES_IDX ASC";
    $select = $dbi->prepare($SQL);
    $select->execute($idx);
    while (my ($txNotes) = $select->fetchrow_array()) {
        if ($txNotes){
            $HASH{$counter++} = sprintf '<b class="w3-text-green">Flight-Line Notes:</b><br>%s', $txNotes;
        }
    }
    return (\%HASH);
}

sub _getNoteFlag(){
    my $self = shift;
	my $idx = shift;
	my $flag = 0;
	my $SQL = "SELECT CL_DESCRIPTION, CL_COMMENT FROM TB_TODO WHERE (FK_TODO_TYPE_IDX=? AND FK_TEAM_IDX=?)";
	my $select = $dbi->prepare($SQL);
      $select->execute(4, $idx);
    my $counter = 1;
    while (my ($txItem, $txNotes) = $select->fetchrow_array()) {
        if ($txItem || $txNotes){
            $flag=1;
        }
        
    }
    $SQL = "SELECT CL_NOTES FROM TB_NOTES WHERE FK_TEAM_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($idx);
    while (my ($txNotes) = $select->fetchrow_array()) {
        if ($txNotes){
            $flag=1;
        }
    }
    return ($flag);
}
sub _saveNotes(){
    my $self = shift;
    my $txNotes = shift;
    my $teamIDX = shift;
    my $eventIDX = shift;
    my $flightIDX = shift;
    if ($flightIDX) {
        my $SQL = "INSERT INTO TB_NOTES (FK_TEAM_IDX, FK_EVENT_IDX, CL_NOTES, FK_FLIGHT_IDX, TX_TYPE) VALUES (?, ?, ?, ?, ?)";
        my $insert = $dbi->prepare($SQL);
           $insert->execute($teamIDX, $eventIDX, $txNotes, $flightIDX, 'Scoring Judge');
    } else {
        my $SQL = "INSERT INTO TB_NOTES (FK_TEAM_IDX, FK_EVENT_IDX, CL_NOTES, TX_TYPE) VALUES (?, ?, ?, ?)";
        my $insert = $dbi->prepare($SQL);
           $insert->execute($teamIDX, $eventIDX, $txNotes, 'Flight-Line Judge') ;
    }
    my $notesIDX = $insert->{q{mysql_insertid}};
    return($notesIDX);
}
sub _updateNotes(){
    my $self = shift;
    my $txNotes = shift;
    my $flightIDX = shift;
    my $SQL = "UPDATE TB_NOTES SET (CL_NOTES=?) WHERE FK_FLIGHT_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($txNotes, $flightIDX);
}
sub _getNotesByFlightID(){
    my $self = shift;
    my $idx = shift;
    my $SQL = "SELECT CL_NOTES FROM TB_FLIGHT WHERE FK_FLIGHT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($idx);
    my $notes = $select->fetchrow_array();
    return ($notes);
}
sub _getFlightNotes(){
    my $self = shift;
    my $idx = shift;
    my $SQL = "SELECT * FROM TB_NOTES WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($idx);
    my %HASH = %{$select->fetchall_hashref('PK_NOTES_IDX')};
    return (\%HASH);
}





return (1);
# sub _getAllUsers(){
#     my $self = shift;
#     my $SQL = "SELECT * FROM TB_USER";
#     my $select = $dbi->prepare($SQL);
#       $select->execute();
#     my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
#     return (\%HASH);
# }

# sub _registerNewUser(){
#     my ($self, $txFirst, $txLast, $txEmail, $txPassword) = @_;
#     my $SQL = "INSERT INTO TB_USER (TX_FIRST_NAME, TX_LAST_NAME, TX_LOGIN, TX_EMAIL, TX_PASSWORD, IN_USER_TYPE, IN_LIMIT) VALUES (?, ?, ?, ?, ?, ?, ?)";
#     my $insert = $dbi->prepare($SQL);
#       $insert->execute($txFirst, $txLast, $txEmail, $txEmail, $txPassword, 0, 0);
#     my $userIDX = $insert->{q{mysql_insertid}};
#     return ($userIDX);
# }
# sub _saveField(){
#     my ($self, $txField, $txValue, $idx) = @_;
#     my $SQL = "UPDATE TB_USER SET $txField=? WHERE PK_USER_IDX=?";
#     my $update = $dbi->prepare($SQL);
#       $update->execute($txValue, $idx);
#     return();
# }
# sub _addUserAccess(){
#     my ($self, $tileIDX, $userIDX) = @_;
#     my $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) VALUES (?, ?)";
#     my $insert = $dbi->prepare($SQL);
#       $insert->execute($tileIDX, $userIDX);
#     #   print "$tileIDX, $userIDX";
#     return;
# }

# sub _removeUserAccess(){
#     my ($self, $tileIDX, $userIDX) = @_;
#     my $SQL = "DELETE FROM TB_ACCESS WHERE (FK_TILES_IDX=? AND FK_USER_IDX=?)";
#     my $delete = $dbi->prepare($SQL);
#       $delete->execute($tileIDX, $userIDX);
#     #   print "$tileIDX, $userIDX";
#     return;
# }
# sub _addUserTeam(){
#     my ($self, $teamIDX, $userIDX) = @_;
#     my $SQL = "INSERT INTO TB_USER_TEAM (FK_TEAM_IDX, FK_USER_IDX) VALUES (?, ?)";
#     my $insert = $dbi->prepare($SQL);
#       $insert->execute($teamIDX, $userIDX);
#     return;
# }

# sub _removeUserTeam(){
#     my ($self, $teamIDX, $userIDX) = @_;
#     my $SQL = "DELETE FROM TB_USER_TEAM WHERE (FK_TEAM_IDX=? AND FK_USER_IDX=?)";
#     my $delete = $dbi->prepare($SQL);
#       $delete->execute($teamIDX, $userIDX) ;
#     return;
# }
# sub _deleteUser(){
#     my ($self, $userIDX) = @_;
#     my $SQL = "DELETE FROM TB_USER WHERE (PK_USER_IDX=?)";
#     my $delete = $dbi->prepare($SQL);
#       $delete->execute($userIDX) ;
#     return;
# }
# sub _getUserAccess(){
#     my $self = shift;
#     my $inType = shift;
#     my $SQL = "SELECT AC.* FROM TB_USER AS U JOIN TB_ACCESS AS AC ON U.PK_USER_IDX=AC.FK_USER_IDX WHERE U.IN_USER_TYPE=?";
#     my $select = $dbi->prepare($SQL);
#       $select->execute($inType);
#     my %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','FK_TILES_IDX'])};
#     return (\%HASH);
# }
# sub _getUserByType(){
#     my $self = shift;
#     my $inType = shift;
#     my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE=?";
#     my $select = $dbi->prepare($SQL);
#       $select->execute($inType);
#     my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
#     return (\%HASH);
# }
