package SAE::TB_COUNTRY

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkCountryIdx;
my $TxCountry;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbCountryRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COUNTRY_IDX, TX_COUNTRY
		FROM `saestars_DB`.`TB_COUNTRY`
		WHERE PK_COUNTRY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkCountryIdx 		 => 	$HASH{PK_COUNTRY_IDX}
		,TxCountry 		 => 	$HASH{TX_COUNTRY}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkCountryIdx(){
	my ( $self ) = shift;
	return ($self->{PkCountryIdx});
}

sub getTxCountry(){
	my ( $self ) = shift;
	return ($self->{TxCountry});
}


#------- BUILDING SETTERS------

sub setPkCountryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkCountryIdx} = $value;
	return ($self->{PkCountryIdx});
}

sub setTxCountry(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxCountry} = $value;
	return ($self->{TxCountry});
}



return (1);

