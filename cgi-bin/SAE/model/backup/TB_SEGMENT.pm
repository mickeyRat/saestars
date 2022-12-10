package SAE::TB_SEGMENT

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkSegmentIdx;
my $InSegmentRef;
my $TxName;
my $TxDetail;
my $InMax;
my $InWeight;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbSegmentRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT
		FROM `saestars_DB`.`TB_SEGMENT`
		WHERE PK_SEGMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkSegmentIdx 		 => 	$HASH{PK_SEGMENT_IDX}
		,InSegmentRef 		 => 	$HASH{IN_SEGMENT_REF}
		,TxName 		 => 	$HASH{TX_NAME}
		,TxDetail 		 => 	$HASH{TX_DETAIL}
		,InMax 		 => 	$HASH{IN_MAX}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkSegmentIdx(){
	my ( $self ) = shift;
	return ($self->{PkSegmentIdx});
}

sub getInSegmentRef(){
	my ( $self ) = shift;
	return ($self->{InSegmentRef});
}

sub getTxName(){
	my ( $self ) = shift;
	return ($self->{TxName});
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($self->{TxDetail});
}

sub getInMax(){
	my ( $self ) = shift;
	return ($self->{InMax});
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($self->{InWeight});
}


#------- BUILDING SETTERS------

sub setPkSegmentIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkSegmentIdx} = $value;
	return ($self->{PkSegmentIdx});
}

sub setInSegmentRef(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InSegmentRef} = $value;
	return ($self->{InSegmentRef});
}

sub setTxName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxName} = $value;
	return ($self->{TxName});
}

sub setTxDetail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxDetail} = $value;
	return ($self->{TxDetail});
}

sub setInMax(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InMax} = $value;
	return ($self->{InMax});
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InWeight} = $value;
	return ($self->{InWeight});
}



return (1);

