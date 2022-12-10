package SAE::TB_NOTES;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkNotesIdx;
my $FkTeamIdx;
my $FkEventIdx;
my $FkFlightIdx;
my $TxType;
my $ClNotes;
my $TsCreate;
my $InRound;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_NOTES (FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND) values (?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $FkEventIdx, $FkFlightIdx, $TxType, $ClNotes, $InRound);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, TS_CREATE, IN_ROUND
		FROM TB_NOTES
		WHERE PK_NOTES_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkNotesIdx 		 = 	$HASH{PK_NOTES_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkFlightIdx 		 = 	$HASH{FK_FLIGHT_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$ClNotes 		 = 	$HASH{CL_NOTES};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$InRound 		 = 	$HASH{IN_ROUND};
	return $self;

;}
sub getAllRecordBy_PkNotesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE PK_NOTES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE FK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClNotes(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE CL_NOTES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_NOTES_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_FLIGHT_IDX, TX_TYPE, CL_NOTES, IN_ROUND FROM TB_NOTES";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_NOTES_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where PK_NOTES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkNotesIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where PK_NOTES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkFlightIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where FK_FLIGHT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where TX_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClNotes(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where CL_NOTES=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRound(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_NOTES where IN_ROUND=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkNotesIdx(){
	my ( $self ) = shift;
	return ($PkNotesIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkFlightIdx(){
	my ( $self ) = shift;
	return ($FkFlightIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getClNotes(){
	my ( $self ) = shift;
	return ($ClNotes);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}


#------- BUILDING SETTERS------

sub setPkNotesIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkNotesIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
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

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setClNotes(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClNotes = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_NOTES_IDX from TB_NOTES where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_NOTES_IDX from TB_NOTES where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_NOTES_IDX from TB_NOTES where FK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_NOTES_IDX from TB_NOTES where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClNotes(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_NOTES_IDX from TB_NOTES where CL_NOTES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_NOTES_IDX from TB_NOTES where IN_ROUND=?";
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

	my $SQL = "UPDATE TB_NOTES set FK_TEAM_IDX=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES set FK_EVENT_IDX=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkFlightIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES set FK_FLIGHT_IDX=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES set TX_TYPE=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClNotes_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES set CL_NOTES=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES set TS_CREATE=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES set IN_ROUND=? where PK_NOTES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkNotesIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET PK_NOTES_IDX=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET FK_TEAM_IDX=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET FK_EVENT_IDX=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkFlightIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET FK_FLIGHT_IDX=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET TX_TYPE=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClNotes_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET CL_NOTES=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRound_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_NOTES SET IN_ROUND=? where PK_NOTES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

