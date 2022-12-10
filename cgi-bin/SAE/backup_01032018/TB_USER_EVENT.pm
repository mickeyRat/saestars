package SAE::TB_USER_EVENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkUserEventIdx;
my $FkUserIdx;
my $FkEventIdx;
my $InLimit;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_USER_EVENT (FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkEventIdx, $InLimit);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_EVENT_IDX, FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT
		FROM TB_USER_EVENT
		WHERE PK_USER_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUserEventIdx 		 = 	$HASH{PK_USER_EVENT_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InLimit 		 = 	$HASH{IN_LIMIT};
	return $self;

;}
sub getAllRecordBy_PkUserEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_EVENT_IDX, FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT FROM TB_USER_EVENT WHERE PK_USER_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_EVENT_IDX, FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT FROM TB_USER_EVENT WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_EVENT_IDX, FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT FROM TB_USER_EVENT WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLimit(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_EVENT_IDX, FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT FROM TB_USER_EVENT WHERE IN_LIMIT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_EVENT_IDX, FK_USER_IDX, FK_EVENT_IDX, IN_LIMIT FROM TB_USER_EVENT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_USER_EVENT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER_EVENT where PK_USER_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkUserEventIdx(){
	my ( $self ) = shift;
	return ($PkUserEventIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInLimit(){
	my ( $self ) = shift;
	return ($InLimit);
}


#------- BUILDING SETTERS------

sub setPkUserEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUserEventIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setInLimit(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLimit = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_EVENT_IDX from TB_USER_EVENT where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_EVENT_IDX from TB_USER_EVENT where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLimit(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_EVENT_IDX from TB_USER_EVENT where IN_LIMIT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT set FK_USER_IDX=? where PK_USER_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT set FK_EVENT_IDX=? where PK_USER_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLimit_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT set IN_LIMIT=? where PK_USER_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkUserEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT SET PK_USER_EVENT_IDX=? where PK_USER_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT SET FK_USER_IDX=? where PK_USER_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT SET FK_EVENT_IDX=? where PK_USER_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLimit_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_EVENT SET IN_LIMIT=? where PK_USER_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

