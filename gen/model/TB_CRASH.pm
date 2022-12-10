package SAE::TB_CRASH;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCrashIdx;
my $FkFlightIdx;
my $FkTeamIdx;
my $FkTodoIdx;
my $FkInspectionIdx;
my $TxItem;
my $TsCreate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_CRASH (FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkFlightIdx, $FkTeamIdx, $FkTodoIdx, $FkInspectionIdx, $TxItem);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM, TS_CREATE
		FROM TB_CRASH
		WHERE PK_CRASH_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCrashIdx 		 = 	$HASH{PK_CRASH_IDX};
	$FkFlightIdx 		 = 	$HASH{FK_FLIGHT_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkTodoIdx 		 = 	$HASH{FK_TODO_IDX};
	$FkInspectionIdx 		 = 	$HASH{FK_INSPECTION_IDX};
	$TxItem 		 = 	$HASH{TX_ITEM};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkCrashIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH WHERE PK_CRASH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH WHERE FK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTodoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH WHERE FK_TODO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkInspectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH WHERE FK_INSPECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxItem(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH WHERE TX_ITEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CRASH_IDX, FK_FLIGHT_IDX, FK_TEAM_IDX, FK_TODO_IDX, FK_INSPECTION_IDX, TX_ITEM FROM TB_CRASH";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_CRASH_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where PK_CRASH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkCrashIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where PK_CRASH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkFlightIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where FK_FLIGHT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTodoIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where FK_TODO_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkInspectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where FK_INSPECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxItem(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CRASH where TX_ITEM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkCrashIdx(){
	my ( $self ) = shift;
	return ($PkCrashIdx);
}

sub getFkFlightIdx(){
	my ( $self ) = shift;
	return ($FkFlightIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkTodoIdx(){
	my ( $self ) = shift;
	return ($FkTodoIdx);
}

sub getFkInspectionIdx(){
	my ( $self ) = shift;
	return ($FkInspectionIdx);
}

sub getTxItem(){
	my ( $self ) = shift;
	return ($TxItem);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkCrashIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCrashIdx = $value;
	return ($field);
}

sub setFkFlightIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkFlightIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkTodoIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTodoIdx = $value;
	return ($field);
}

sub setFkInspectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkInspectionIdx = $value;
	return ($field);
}

sub setTxItem(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxItem = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CRASH_IDX from TB_CRASH where FK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CRASH_IDX from TB_CRASH where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTodoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CRASH_IDX from TB_CRASH where FK_TODO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkInspectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CRASH_IDX from TB_CRASH where FK_INSPECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxItem(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CRASH_IDX from TB_CRASH where TX_ITEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkFlightIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH set FK_FLIGHT_IDX=? where PK_CRASH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH set FK_TEAM_IDX=? where PK_CRASH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTodoIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH set FK_TODO_IDX=? where PK_CRASH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkInspectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH set FK_INSPECTION_IDX=? where PK_CRASH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxItem_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH set TX_ITEM=? where PK_CRASH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH set TS_CREATE=? where PK_CRASH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCrashIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH SET PK_CRASH_IDX=? where PK_CRASH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkFlightIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH SET FK_FLIGHT_IDX=? where PK_CRASH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH SET FK_TEAM_IDX=? where PK_CRASH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTodoIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH SET FK_TODO_IDX=? where PK_CRASH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkInspectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH SET FK_INSPECTION_IDX=? where PK_CRASH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxItem_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CRASH SET TX_ITEM=? where PK_CRASH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

