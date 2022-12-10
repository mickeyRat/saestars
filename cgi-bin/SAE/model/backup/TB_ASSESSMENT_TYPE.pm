package SAE::TB_ASSESSMENT_TYPE

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkAssessmentTypeIdx;
my $TxType;
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
sub getTbAssessmentTypeRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ASSESSMENT_TYPE_IDX, TX_TYPE, TX_DETAIL, IN_MAX, IN_WEIGHT
		FROM `saestars_DB`.`TB_ASSESSMENT_TYPE`
		WHERE PK_ASSESSMENT_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkAssessmentTypeIdx 		 => 	$HASH{PK_ASSESSMENT_TYPE_IDX}
		,TxType 		 => 	$HASH{TX_TYPE}
		,TxDetail 		 => 	$HASH{TX_DETAIL}
		,InMax 		 => 	$HASH{IN_MAX}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($self->{PkAssessmentTypeIdx});
}

sub getTxType(){
	my ( $self ) = shift;
	return ($self->{TxType});
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

sub setPkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkAssessmentTypeIdx} = $value;
	return ($self->{PkAssessmentTypeIdx});
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxType} = $value;
	return ($self->{TxType});
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

