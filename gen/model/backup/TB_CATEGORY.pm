package SAE::TB_CATEGORY

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkCategoryIdx;
my $InSegmentRef;
my $InSection;
my $TxTitle;
my $TxDetail;
my $InMin;
my $InMax;
my $InWeight;
my $InOrder;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbCategoryRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER
		FROM `saestars_DB`.`TB_CATEGORY`
		WHERE PK_CATEGORY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkCategoryIdx 		 => 	$HASH{PK_CATEGORY_IDX}
		,InSegmentRef 		 => 	$HASH{IN_SEGMENT_REF}
		,InSection 		 => 	$HASH{IN_SECTION}
		,TxTitle 		 => 	$HASH{TX_TITLE}
		,TxDetail 		 => 	$HASH{TX_DETAIL}
		,InMin 		 => 	$HASH{IN_MIN}
		,InMax 		 => 	$HASH{IN_MAX}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
		,InOrder 		 => 	$HASH{IN_ORDER}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkCategoryIdx(){
	my ( $self ) = shift;
	return ($self->{PkCategoryIdx});
}

sub getInSegmentRef(){
	my ( $self ) = shift;
	return ($self->{InSegmentRef});
}

sub getInSection(){
	my ( $self ) = shift;
	return ($self->{InSection});
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($self->{TxTitle});
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($self->{TxDetail});
}

sub getInMin(){
	my ( $self ) = shift;
	return ($self->{InMin});
}

sub getInMax(){
	my ( $self ) = shift;
	return ($self->{InMax});
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($self->{InWeight});
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($self->{InOrder});
}


#------- BUILDING SETTERS------

sub setPkCategoryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkCategoryIdx} = $value;
	return ($self->{PkCategoryIdx});
}

sub setInSegmentRef(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InSegmentRef} = $value;
	return ($self->{InSegmentRef});
}

sub setInSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InSection} = $value;
	return ($self->{InSection});
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxTitle} = $value;
	return ($self->{TxTitle});
}

sub setTxDetail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxDetail} = $value;
	return ($self->{TxDetail});
}

sub setInMin(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InMin} = $value;
	return ($self->{InMin});
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

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InOrder} = $value;
	return ($self->{InOrder});
}



return (1);

