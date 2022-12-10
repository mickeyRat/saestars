package SAE::TB_LATE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkLateIdx;
my $FkTeamIdx;
my $FkEventIdx;
my $InDays;
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

	my $SQL = "INSERT INTO TB_LATE (FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $FkEventIdx, $InDays);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_LATE_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS, TS_CREATE
		FROM TB_LATE
		WHERE PK_LATE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkLateIdx 		 = 	$HASH{PK_LATE_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InDays 		 = 	$HASH{IN_DAYS};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkLateIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_LATE_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS FROM TB_LATE WHERE PK_LATE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_LATE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_LATE_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS FROM TB_LATE WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_LATE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_LATE_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS FROM TB_LATE WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_LATE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDays(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_LATE_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS FROM TB_LATE WHERE IN_DAYS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_LATE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_LATE_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS FROM TB_LATE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_LATE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_LATE where PK_LATE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkLateIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_LATE where PK_LATE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_LATE where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_LATE where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDays(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_LATE where IN_DAYS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkLateIdx(){
	my ( $self ) = shift;
	return ($PkLateIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInDays(){
	my ( $self ) = shift;
	return ($InDays);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkLateIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkLateIdx = $value;
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

sub setInDays(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDays = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_LATE_IDX from TB_LATE where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_LATE_IDX from TB_LATE where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDays(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_LATE_IDX from TB_LATE where IN_DAYS=?";
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

	my $SQL = "UPDATE TB_LATE set FK_TEAM_IDX=? where PK_LATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE set FK_EVENT_IDX=? where PK_LATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDays_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE set IN_DAYS=? where PK_LATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE set TS_CREATE=? where PK_LATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkLateIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE SET PK_LATE_IDX=? where PK_LATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE SET FK_TEAM_IDX=? where PK_LATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE SET FK_EVENT_IDX=? where PK_LATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDays_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_LATE SET IN_DAYS=? where PK_LATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

