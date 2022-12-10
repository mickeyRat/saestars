package SAE::TB_CATEGORY_BACK;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCategoryIdx;
my $TxType;
my $TxCategory;
my $InValue;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_CATEGORY_BACK (TX_TYPE, TX_CATEGORY, IN_VALUE) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxType, $TxCategory, $InValue);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CATEGORY_IDX, TX_TYPE, TX_CATEGORY, IN_VALUE
		FROM TB_CATEGORY_BACK
		WHERE PK_CATEGORY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCategoryIdx 		 = 	$HASH{PK_CATEGORY_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$TxCategory 		 = 	$HASH{TX_CATEGORY};
	$InValue 		 = 	$HASH{IN_VALUE};
	return $self;

;}
sub getAllRecordBy_PkCategoryIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, TX_TYPE, TX_CATEGORY, IN_VALUE FROM TB_CATEGORY_BACK WHERE PK_CATEGORY_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, TX_TYPE, TX_CATEGORY, IN_VALUE FROM TB_CATEGORY_BACK WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, TX_TYPE, TX_CATEGORY, IN_VALUE FROM TB_CATEGORY_BACK WHERE TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InValue(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, TX_TYPE, TX_CATEGORY, IN_VALUE FROM TB_CATEGORY_BACK WHERE IN_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CATEGORY_BACK where PK_CATEGORY_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkCategoryIdx(){
	my ( $self ) = shift;
	return ($PkCategoryIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($TxCategory);
}

sub getInValue(){
	my ( $self ) = shift;
	return ($InValue);
}


#------- BUILDING SETTERS------

sub setPkCategoryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCategoryIdx = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCategory = $value;
	return ($field);
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InValue = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY_BACK where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY_BACK where TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InValue(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY_BACK where IN_VALUE=?";
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

	my $SQL = "UPDATE TB_CATEGORY_BACK set TX_TYPE=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxCategory_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY_BACK set TX_CATEGORY=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInValue_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY_BACK set IN_VALUE=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

