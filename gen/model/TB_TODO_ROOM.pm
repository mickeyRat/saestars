package SAE::TB_TODO_ROOM;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTodoRoomIdx;
my $FkEventIdx;
my $TxRoom;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TODO_ROOM (FK_EVENT_IDX, TX_ROOM) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $TxRoom);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TODO_ROOM_IDX, FK_EVENT_IDX, TX_ROOM
		FROM TB_TODO_ROOM
		WHERE PK_TODO_ROOM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTodoRoomIdx 		 = 	$HASH{PK_TODO_ROOM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$TxRoom 		 = 	$HASH{TX_ROOM};
	return $self;

;}
sub getAllRecordBy_PkTodoRoomIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_ROOM_IDX, FK_EVENT_IDX, TX_ROOM FROM TB_TODO_ROOM WHERE PK_TODO_ROOM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_ROOM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_ROOM_IDX, FK_EVENT_IDX, TX_ROOM FROM TB_TODO_ROOM WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_ROOM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxRoom(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_ROOM_IDX, FK_EVENT_IDX, TX_ROOM FROM TB_TODO_ROOM WHERE TX_ROOM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_ROOM_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_ROOM_IDX, FK_EVENT_IDX, TX_ROOM FROM TB_TODO_ROOM";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_ROOM_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_ROOM where PK_TODO_ROOM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTodoRoomIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_ROOM where PK_TODO_ROOM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_ROOM where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxRoom(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_ROOM where TX_ROOM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTodoRoomIdx(){
	my ( $self ) = shift;
	return ($PkTodoRoomIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getTxRoom(){
	my ( $self ) = shift;
	return ($TxRoom);
}


#------- BUILDING SETTERS------

sub setPkTodoRoomIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTodoRoomIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setTxRoom(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxRoom = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_ROOM_IDX from TB_TODO_ROOM where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxRoom(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_ROOM_IDX from TB_TODO_ROOM where TX_ROOM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_ROOM set FK_EVENT_IDX=? where PK_TODO_ROOM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxRoom_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_ROOM set TX_ROOM=? where PK_TODO_ROOM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTodoRoomIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_ROOM SET PK_TODO_ROOM_IDX=? where PK_TODO_ROOM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_ROOM SET FK_EVENT_IDX=? where PK_TODO_ROOM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxRoom_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_ROOM SET TX_ROOM=? where PK_TODO_ROOM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

