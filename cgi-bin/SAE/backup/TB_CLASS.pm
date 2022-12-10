package SAE::TB_CLASS

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkClassIdx;
my $TxClass;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbClassRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CLASS_IDX, TX_CLASS
		FROM `saestars_DB`.`TB_CLASS`
		WHERE PK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkClassIdx 		 => 	$HASH{PK_CLASS_IDX}
		,TxClass 		 => 	$HASH{TX_CLASS}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkClassIdx(){
	my ( $self ) = shift;
	return ($self->{PkClassIdx});
}

sub getTxClass(){
	my ( $self ) = shift;
	return ($self->{TxClass});
}


#------- BUILDING SETTERS------

sub setPkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkClassIdx} = $value;
	return ($self->{PkClassIdx});
}

sub setTxClass(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxClass} = $value;
	return ($self->{TxClass});
}



return (1);

