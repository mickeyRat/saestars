package SAE::TB_USER_TYPE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkUserTypeIdx;
my $TxType;
my $InType;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_USER_TYPE (TX_TYPE, IN_TYPE) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxType, $InType);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_TYPE_IDX, TX_TYPE, IN_TYPE
		FROM TB_USER_TYPE
		WHERE PK_USER_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUserTypeIdx 		 = 	$HASH{PK_USER_TYPE_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$InType 		 = 	$HASH{IN_TYPE};
	return $self;

;}
sub getAllRecordBy_PkUserTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_TYPE_IDX, TX_TYPE, IN_TYPE FROM TB_USER_TYPE WHERE PK_USER_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_TYPE_IDX, TX_TYPE, IN_TYPE FROM TB_USER_TYPE WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_TYPE_IDX, TX_TYPE, IN_TYPE FROM TB_USER_TYPE WHERE IN_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_TYPE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER_TYPE where PK_USER_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkUserTypeIdx(){
	my ( $self ) = shift;
	return ($PkUserTypeIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getInType(){
	my ( $self ) = shift;
	return ($InType);
}


#------- BUILDING SETTERS------

sub setPkUserTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUserTypeIdx = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setInType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InType = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_TYPE_IDX from TB_USER_TYPE where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_TYPE_IDX from TB_USER_TYPE where IN_TYPE=?";
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

	my $SQL = "UPDATE TB_USER_TYPE set TX_TYPE=? where PK_USER_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_TYPE set IN_TYPE=? where PK_USER_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

