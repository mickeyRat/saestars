package SAE::TB_ASSESSMENT_OPT

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkAssessmentOptIdx;
my $FkAssessmentTypeIdx;
my $TxCategory;
my $TxTitle;
my $TxDetail;
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
sub getTbAssessmentOptRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER
		FROM `saestars_DB`.`TB_ASSESSMENT_OPT`
		WHERE PK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkAssessmentOptIdx 		 => 	$HASH{PK_ASSESSMENT_OPT_IDX}
		,FkAssessmentTypeIdx 		 => 	$HASH{FK_ASSESSMENT_TYPE_IDX}
		,TxCategory 		 => 	$HASH{TX_CATEGORY}
		,TxTitle 		 => 	$HASH{TX_TITLE}
		,TxDetail 		 => 	$HASH{TX_DETAIL}
		,InMax 		 => 	$HASH{IN_MAX}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
		,InOrder 		 => 	$HASH{IN_ORDER}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($self->{PkAssessmentOptIdx});
}

sub getFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentTypeIdx});
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($self->{TxCategory});
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($self->{TxTitle});
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

sub getInOrder(){
	my ( $self ) = shift;
	return ($self->{InOrder});
}


#------- BUILDING SETTERS------

sub setPkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkAssessmentOptIdx} = $value;
	return ($self->{PkAssessmentOptIdx});
}

sub setFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentTypeIdx} = $value;
	return ($self->{FkAssessmentTypeIdx});
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxCategory} = $value;
	return ($self->{TxCategory});
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

