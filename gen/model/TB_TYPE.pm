package SAE::TB_TYPE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTypeIdx;
my $TxType;
my $InWeight;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TYPE (TX_TYPE, IN_WEIGHT) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxType, $InWeight);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TYPE_IDX, TX_TYPE, IN_WEIGHT
		FROM TB_TYPE
		WHERE PK_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTypeIdx 		 = 	$HASH{PK_TYPE_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	return $self;

;}
sub getAllRecordBy_PkTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TYPE_IDX, TX_TYPE, IN_WEIGHT FROM TB_TYPE WHERE PK_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TYPE_IDX, TX_TYPE, IN_WEIGHT FROM TB_TYPE WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TYPE_IDX, TX_TYPE, IN_WEIGHT FROM TB_TYPE WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TYPE_IDX, TX_TYPE, IN_WEIGHT FROM TB_TYPE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TYPE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TYPE where PK_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TYPE where PK_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TYPE where TX_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TYPE where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTypeIdx(){
	my ( $self ) = shift;
	return ($PkTypeIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}


#------- BUILDING SETTERS------

sub setPkTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTypeIdx = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TYPE_IDX from TB_TYPE where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TYPE_IDX from TB_TYPE where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TYPE set TX_TYPE=? where PK_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TYPE set IN_WEIGHT=? where PK_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TYPE SET PK_TYPE_IDX=? where PK_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TYPE SET TX_TYPE=? where PK_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TYPE SET IN_WEIGHT=? where PK_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

