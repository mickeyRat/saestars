package SAE::TB_CATEGORY_BACK

use DBI
use SAE::SDB

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
sub getTbCategoryBackRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CATEGORY_IDX, TX_TYPE, TX_CATEGORY, IN_VALUE
		FROM `saestars_DB`.`TB_CATEGORY_BACK`
		WHERE PK_CATEGORY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkCategoryIdx 		 => 	$HASH{PK_CATEGORY_IDX}
		,TxType 		 => 	$HASH{TX_TYPE}
		,TxCategory 		 => 	$HASH{TX_CATEGORY}
		,InValue 		 => 	$HASH{IN_VALUE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkCategoryIdx(){
	my ( $self ) = shift;
	return ($self->{PkCategoryIdx});
}

sub getTxType(){
	my ( $self ) = shift;
	return ($self->{TxType});
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($self->{TxCategory});
}

sub getInValue(){
	my ( $self ) = shift;
	return ($self->{InValue});
}


#------- BUILDING SETTERS------

sub setPkCategoryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkCategoryIdx} = $value;
	return ($self->{PkCategoryIdx});
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxType} = $value;
	return ($self->{TxType});
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxCategory} = $value;
	return ($self->{TxCategory});
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InValue} = $value;
	return ($self->{InValue});
}



return (1);

