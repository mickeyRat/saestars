package SAE::TB_ROUND;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkRoundIdx;
my $FkEventIdx;
my $InRound;
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

	my $SQL = "INSERT INTO TB_ROUND (FK_EVENT_IDX, IN_ROUND) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $InRound);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ROUND_IDX, FK_EVENT_IDX, IN_ROUND, TS_CREATE
		FROM TB_ROUND
		WHERE PK_ROUND_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkRoundIdx 		 = 	$HASH{PK_ROUND_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InRound 		 = 	$HASH{IN_ROUND};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkRoundIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ROUND_IDX, FK_EVENT_IDX, IN_ROUND FROM TB_ROUND WHERE PK_ROUND_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ROUND_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ROUND_IDX, FK_EVENT_IDX, IN_ROUND FROM TB_ROUND WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ROUND_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ROUND_IDX, FK_EVENT_IDX, IN_ROUND FROM TB_ROUND WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ROUND_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ROUND_IDX, FK_EVENT_IDX, IN_ROUND FROM TB_ROUND";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_ROUND_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ROUND where PK_ROUND_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkRoundIdx(){
	my ( $self ) = shift;
	return ($PkRoundIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkRoundIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkRoundIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ROUND_IDX from TB_ROUND where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ROUND_IDX from TB_ROUND where IN_ROUND=?";
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

	my $SQL = "UPDATE TB_ROUND set FK_EVENT_IDX=? where PK_ROUND_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ROUND set IN_ROUND=? where PK_ROUND_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ROUND set TS_CREATE=? where PK_ROUND_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkRoundIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ROUND SET PK_ROUND_IDX=? where PK_ROUND_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ROUND SET FK_EVENT_IDX=? where PK_ROUND_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRound_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ROUND SET IN_ROUND=? where PK_ROUND_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

