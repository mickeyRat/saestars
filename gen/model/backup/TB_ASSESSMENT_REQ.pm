package SAE::TB_ASSESSMENT_REQ

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkAssessmentReqIdx;
my $FkAssessmentOptIdx;
my $TxTitle;
my $TxDetail;
my $InWeight;
my $InOrder;
my $BoCheck;
my $TxInputType;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbAssessmentReqRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE
		FROM `saestars_DB`.`TB_ASSESSMENT_REQ`
		WHERE PK_ASSESSMENT_REQ_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkAssessmentReqIdx 		 => 	$HASH{PK_ASSESSMENT_REQ_IDX}
		,FkAssessmentOptIdx 		 => 	$HASH{FK_ASSESSMENT_OPT_IDX}
		,TxTitle 		 => 	$HASH{TX_TITLE}
		,TxDetail 		 => 	$HASH{TX_DETAIL}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
		,InOrder 		 => 	$HASH{IN_ORDER}
		,BoCheck 		 => 	$HASH{BO_CHECK}
		,TxInputType 		 => 	$HASH{TX_INPUT_TYPE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkAssessmentReqIdx(){
	my ( $self ) = shift;
	return ($self->{PkAssessmentReqIdx});
}

sub getFkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentOptIdx});
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($self->{TxTitle});
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($self->{TxDetail});
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($self->{InWeight});
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($self->{InOrder});
}

sub getBoCheck(){
	my ( $self ) = shift;
	return ($self->{BoCheck});
}

sub getTxInputType(){
	my ( $self ) = shift;
	return ($self->{TxInputType});
}


#------- BUILDING SETTERS------

sub setPkAssessmentReqIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkAssessmentReqIdx} = $value;
	return ($self->{PkAssessmentReqIdx});
}

sub setFkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentOptIdx} = $value;
	return ($self->{FkAssessmentOptIdx});
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

sub setBoCheck(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoCheck} = $value;
	return ($self->{BoCheck});
}

sub setTxInputType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxInputType} = $value;
	return ($self->{TxInputType});
}



return (1);

