package SAE::TB_COUNTRY;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_COUNTRY () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COUNTRY_IDX, TX_COUNTRY
		FROM TB_COUNTRY
		WHERE PK_COUNTRY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCountryIdx 		 = 	$HASH{PK_COUNTRY_IDX};
	$TxCountry 		 = 	$HASH{TX_COUNTRY};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkCountryIdx(){
	my ( $self ) = shift;
	return ($PkCountryIdx);
}

sub getTxCountry(){
	my ( $self ) = shift;
	return ($TxCountry);
}


#------- BUILDING SETTERS------

sub setPkCountryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCountryIdx = $value;
	return ($field);
}

sub setTxCountry(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCountry = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxCountry(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COUNTRY_IDX from TB_COUNTRY where TX_COUNTRY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxCountry_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COUNTRY set TX_COUNTRY=? where PK_COUNTRY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

