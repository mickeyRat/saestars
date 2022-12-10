package SAE::TB_PENALTY

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkPenaltyIdx;
my $FkTeamIdx;
my $TxType;
my $TxDetails;
my $TsCreate;
my $InValue;
my $TxCategory;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbPenaltyRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PENALTY_IDX, FK_TEAM_IDX, TX_TYPE, TX_DETAILS, TS_CREATE, IN_VALUE, TX_CATEGORY
		FROM `saestars_DB`.`TB_PENALTY`
		WHERE PK_PENALTY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkPenaltyIdx 		 => 	$HASH{PK_PENALTY_IDX}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
		,TxType 		 => 	$HASH{TX_TYPE}
		,TxDetails 		 => 	$HASH{TX_DETAILS}
		,TsCreate 		 => 	$HASH{TS_CREATE}
		,InValue 		 => 	$HASH{IN_VALUE}
		,TxCategory 		 => 	$HASH{TX_CATEGORY}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkPenaltyIdx(){
	my ( $self ) = shift;
	return ($self->{PkPenaltyIdx});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}

sub getTxType(){
	my ( $self ) = shift;
	return ($self->{TxType});
}

sub getTxDetails(){
	my ( $self ) = shift;
	return ($self->{TxDetails});
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($self->{TsCreate});
}

sub getInValue(){
	my ( $self ) = shift;
	return ($self->{InValue});
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($self->{TxCategory});
}


#------- BUILDING SETTERS------

sub setPkPenaltyIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkPenaltyIdx} = $value;
	return ($self->{PkPenaltyIdx});
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxType} = $value;
	return ($self->{TxType});
}

sub setTxDetails(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxDetails} = $value;
	return ($self->{TxDetails});
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsCreate} = $value;
	return ($self->{TsCreate});
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InValue} = $value;
	return ($self->{InValue});
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxCategory} = $value;
	return ($self->{TxCategory});
}



return (1);

