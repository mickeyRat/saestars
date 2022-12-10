package SAE::TB_EVENT

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkEventIdx;
my $TxEventName;
my $InElevation;
my $TxEventCity;
my $BoArchive;
my $TxWeb;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbEventRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_EVENT_IDX, TX_EVENT_NAME, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB
		FROM `saestars_DB`.`TB_EVENT`
		WHERE PK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkEventIdx 		 => 	$HASH{PK_EVENT_IDX}
		,TxEventName 		 => 	$HASH{TX_EVENT_NAME}
		,InElevation 		 => 	$HASH{IN_ELEVATION}
		,TxEventCity 		 => 	$HASH{TX_EVENT_CITY}
		,BoArchive 		 => 	$HASH{BO_ARCHIVE}
		,TxWeb 		 => 	$HASH{TX_WEB}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkEventIdx(){
	my ( $self ) = shift;
	return ($self->{PkEventIdx});
}

sub getTxEventName(){
	my ( $self ) = shift;
	return ($self->{TxEventName});
}

sub getInElevation(){
	my ( $self ) = shift;
	return ($self->{InElevation});
}

sub getTxEventCity(){
	my ( $self ) = shift;
	return ($self->{TxEventCity});
}

sub getBoArchive(){
	my ( $self ) = shift;
	return ($self->{BoArchive});
}

sub getTxWeb(){
	my ( $self ) = shift;
	return ($self->{TxWeb});
}


#------- BUILDING SETTERS------

sub setPkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkEventIdx} = $value;
	return ($self->{PkEventIdx});
}

sub setTxEventName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxEventName} = $value;
	return ($self->{TxEventName});
}

sub setInElevation(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InElevation} = $value;
	return ($self->{InElevation});
}

sub setTxEventCity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxEventCity} = $value;
	return ($self->{TxEventCity});
}

sub setBoArchive(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoArchive} = $value;
	return ($self->{BoArchive});
}

sub setTxWeb(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxWeb} = $value;
	return ($self->{TxWeb});
}



return (1);

