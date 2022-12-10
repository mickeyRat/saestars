package SAE::TB_USER_TYPE

use DBI
use SAE::SDB

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
sub getTbUserTypeRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_TYPE_IDX, TX_TYPE, IN_TYPE
		FROM `saestars_DB`.`TB_USER_TYPE`
		WHERE PK_USER_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkUserTypeIdx 		 => 	$HASH{PK_USER_TYPE_IDX}
		,TxType 		 => 	$HASH{TX_TYPE}
		,InType 		 => 	$HASH{IN_TYPE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkUserTypeIdx(){
	my ( $self ) = shift;
	return ($self->{PkUserTypeIdx});
}

sub getTxType(){
	my ( $self ) = shift;
	return ($self->{TxType});
}

sub getInType(){
	my ( $self ) = shift;
	return ($self->{InType});
}


#------- BUILDING SETTERS------

sub setPkUserTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkUserTypeIdx} = $value;
	return ($self->{PkUserTypeIdx});
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxType} = $value;
	return ($self->{TxType});
}

sub setInType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InType} = $value;
	return ($self->{InType});
}



return (1);

