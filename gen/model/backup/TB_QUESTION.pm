package SAE::TB_QUESTION

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkQuestionIdx;
my $TxTitle;
my $TxDescription;
my $InParent;
my $InWeight;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbQuestionRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT
		FROM `saestars_DB`.`TB_QUESTION`
		WHERE PK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkQuestionIdx 		 => 	$HASH{PK_QUESTION_IDX}
		,TxTitle 		 => 	$HASH{TX_TITLE}
		,TxDescription 		 => 	$HASH{TX_DESCRIPTION}
		,InParent 		 => 	$HASH{IN_PARENT}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkQuestionIdx(){
	my ( $self ) = shift;
	return ($self->{PkQuestionIdx});
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($self->{TxTitle});
}

sub getTxDescription(){
	my ( $self ) = shift;
	return ($self->{TxDescription});
}

sub getInParent(){
	my ( $self ) = shift;
	return ($self->{InParent});
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($self->{InWeight});
}


#------- BUILDING SETTERS------

sub setPkQuestionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkQuestionIdx} = $value;
	return ($self->{PkQuestionIdx});
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxTitle} = $value;
	return ($self->{TxTitle});
}

sub setTxDescription(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxDescription} = $value;
	return ($self->{TxDescription});
}

sub setInParent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InParent} = $value;
	return ($self->{InParent});
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InWeight} = $value;
	return ($self->{InWeight});
}



return (1);

