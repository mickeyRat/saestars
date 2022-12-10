package SAE::TB_PREF;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPrefIdx;
my $FkUserIdx;
my $FkEventIdx;
my $FkClassIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_PREF (FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkEventIdx, $FkClassIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PREF_IDX, FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX
		FROM TB_PREF
		WHERE PK_PREF_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPrefIdx 		 = 	$HASH{PK_PREF_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	return $self;

;}
sub getAllRecordBy_PkPrefIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PREF_IDX, FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX FROM TB_PREF WHERE PK_PREF_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PREF_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PREF_IDX, FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX FROM TB_PREF WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PREF_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PREF_IDX, FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX FROM TB_PREF WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PREF_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PREF_IDX, FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX FROM TB_PREF WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PREF_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PREF_IDX, FK_USER_IDX, FK_EVENT_IDX, FK_CLASS_IDX FROM TB_PREF";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_PREF_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PREF where PK_PREF_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkPrefIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PREF where PK_PREF_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PREF where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PREF where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PREF where FK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkPrefIdx(){
	my ( $self ) = shift;
	return ($PkPrefIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}


#------- BUILDING SETTERS------

sub setPkPrefIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPrefIdx = $value;
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

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkClassIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PREF_IDX from TB_PREF where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PREF_IDX from TB_PREF where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PREF_IDX from TB_PREF where FK_CLASS_IDX=?";
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

	my $SQL = "UPDATE TB_PREF set FK_USER_IDX=? where PK_PREF_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PREF set FK_EVENT_IDX=? where PK_PREF_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkClassIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PREF set FK_CLASS_IDX=? where PK_PREF_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkPrefIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PREF SET PK_PREF_IDX=? where PK_PREF_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PREF SET FK_USER_IDX=? where PK_PREF_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PREF SET FK_EVENT_IDX=? where PK_PREF_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkClassIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PREF SET FK_CLASS_IDX=? where PK_PREF_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

