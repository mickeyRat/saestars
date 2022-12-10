package SAE::TB_GROUP;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkGroupIdx;
my $TxGroup;
my $InAccess;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_GROUP (TX_GROUP, IN_ACCESS) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxGroup, $InAccess);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_GROUP_IDX, TX_GROUP, IN_ACCESS
		FROM TB_GROUP
		WHERE PK_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkGroupIdx 		 = 	$HASH{PK_GROUP_IDX};
	$TxGroup 		 = 	$HASH{TX_GROUP};
	$InAccess 		 = 	$HASH{IN_ACCESS};
	return $self;

;}
sub getAllRecordBy_PkGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_IDX, TX_GROUP, IN_ACCESS FROM TB_GROUP WHERE PK_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxGroup(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_IDX, TX_GROUP, IN_ACCESS FROM TB_GROUP WHERE TX_GROUP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InAccess(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_IDX, TX_GROUP, IN_ACCESS FROM TB_GROUP WHERE IN_ACCESS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_IDX, TX_GROUP, IN_ACCESS FROM TB_GROUP";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP where PK_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkGroupIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP where PK_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxGroup(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP where TX_GROUP=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InAccess(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP where IN_ACCESS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkGroupIdx(){
	my ( $self ) = shift;
	return ($PkGroupIdx);
}

sub getTxGroup(){
	my ( $self ) = shift;
	return ($TxGroup);
}

sub getInAccess(){
	my ( $self ) = shift;
	return ($InAccess);
}


#------- BUILDING SETTERS------

sub setPkGroupIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkGroupIdx = $value;
	return ($field);
}

sub setTxGroup(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxGroup = $value;
	return ($field);
}

sub setInAccess(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InAccess = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxGroup(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GROUP_IDX from TB_GROUP where TX_GROUP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InAccess(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GROUP_IDX from TB_GROUP where IN_ACCESS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxGroup_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP set TX_GROUP=? where PK_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInAccess_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP set IN_ACCESS=? where PK_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP SET PK_GROUP_IDX=? where PK_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxGroup_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP SET TX_GROUP=? where PK_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInAccess_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP SET IN_ACCESS=? where PK_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

