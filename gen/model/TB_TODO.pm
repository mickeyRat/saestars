package SAE::TB_TODO;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTodoIdx;
my $FkTeamIdx;
my $FkTodoTypeIdx;
my $FkEventIdx;
my $FkFlightIdx;
my $ClDescription;
my $ClComment;
my $TxTime;
my $TxRoom;
my $TxStatus;
my $InClear;
my $BoArchive;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TODO (FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $FkTodoTypeIdx, $FkEventIdx, $FkFlightIdx, $ClDescription, $ClComment, $TxTime, $TxRoom, $TxStatus, $InClear, $BoArchive);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE
		FROM TB_TODO
		WHERE PK_TODO_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTodoIdx 		 = 	$HASH{PK_TODO_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkTodoTypeIdx 		 = 	$HASH{FK_TODO_TYPE_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkFlightIdx 		 = 	$HASH{FK_FLIGHT_IDX};
	$ClDescription 		 = 	$HASH{CL_DESCRIPTION};
	$ClComment 		 = 	$HASH{CL_COMMENT};
	$TxTime 		 = 	$HASH{TX_TIME};
	$TxRoom 		 = 	$HASH{TX_ROOM};
	$TxStatus 		 = 	$HASH{TX_STATUS};
	$InClear 		 = 	$HASH{IN_CLEAR};
	$BoArchive 		 = 	$HASH{BO_ARCHIVE};
	return $self;

;}
sub getAllRecordBy_PkTodoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE PK_TODO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTodoTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE FK_TODO_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE FK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE CL_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTime(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE TX_TIME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxRoom(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE TX_ROOM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE TX_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InClear(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE IN_CLEAR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoArchive(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO WHERE BO_ARCHIVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_IDX, FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, CL_DESCRIPTION, CL_COMMENT, TX_TIME, TX_ROOM, TX_STATUS, IN_CLEAR, BO_ARCHIVE FROM TB_TODO";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where PK_TODO_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTodoIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where PK_TODO_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTodoTypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where FK_TODO_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkFlightIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where FK_FLIGHT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClDescription(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where CL_DESCRIPTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClComment(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where CL_COMMENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTime(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where TX_TIME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxRoom(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where TX_ROOM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where TX_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InClear(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where IN_CLEAR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoArchive(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO where BO_ARCHIVE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTodoIdx(){
	my ( $self ) = shift;
	return ($PkTodoIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkTodoTypeIdx(){
	my ( $self ) = shift;
	return ($FkTodoTypeIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkFlightIdx(){
	my ( $self ) = shift;
	return ($FkFlightIdx);
}

sub getClDescription(){
	my ( $self ) = shift;
	return ($ClDescription);
}

sub getClComment(){
	my ( $self ) = shift;
	return ($ClComment);
}

sub getTxTime(){
	my ( $self ) = shift;
	return ($TxTime);
}

sub getTxRoom(){
	my ( $self ) = shift;
	return ($TxRoom);
}

sub getTxStatus(){
	my ( $self ) = shift;
	return ($TxStatus);
}

sub getInClear(){
	my ( $self ) = shift;
	return ($InClear);
}

sub getBoArchive(){
	my ( $self ) = shift;
	return ($BoArchive);
}


#------- BUILDING SETTERS------

sub setPkTodoIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTodoIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkTodoTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTodoTypeIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setFkFlightIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkFlightIdx = $value;
	return ($field);
}

sub setClDescription(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClDescription = $value;
	return ($field);
}

sub setClComment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClComment = $value;
	return ($field);
}

sub setTxTime(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTime = $value;
	return ($field);
}

sub setTxRoom(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxRoom = $value;
	return ($field);
}

sub setTxStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxStatus = $value;
	return ($field);
}

sub setInClear(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InClear = $value;
	return ($field);
}

sub setBoArchive(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoArchive = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTodoTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where FK_TODO_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where FK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where CL_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTime(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where TX_TIME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxRoom(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where TX_ROOM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where TX_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InClear(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where IN_CLEAR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoArchive(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_IDX from TB_TODO where BO_ARCHIVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set FK_TEAM_IDX=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTodoTypeIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set FK_TODO_TYPE_IDX=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set FK_EVENT_IDX=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkFlightIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set FK_FLIGHT_IDX=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClDescription_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set CL_DESCRIPTION=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set CL_COMMENT=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTime_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set TX_TIME=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxRoom_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set TX_ROOM=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set TX_STATUS=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInClear_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set IN_CLEAR=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoArchive_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO set BO_ARCHIVE=? where PK_TODO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTodoIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET PK_TODO_IDX=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET FK_TEAM_IDX=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTodoTypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET FK_TODO_TYPE_IDX=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET FK_EVENT_IDX=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkFlightIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET FK_FLIGHT_IDX=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClDescription_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET CL_DESCRIPTION=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET CL_COMMENT=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTime_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET TX_TIME=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxRoom_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET TX_ROOM=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET TX_STATUS=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInClear_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET IN_CLEAR=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoArchive_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO SET BO_ARCHIVE=? where PK_TODO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

