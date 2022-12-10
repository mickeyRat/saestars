package SAE::TB_ROUND

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkRoundIdx;
my $FkEventIdx;
my $InRound;
my $TsCreate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbRoundRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ROUND_IDX, FK_EVENT_IDX, IN_ROUND, TS_CREATE
		FROM `saestars_DB`.`TB_ROUND`
		WHERE PK_ROUND_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkRoundIdx 		 => 	$HASH{PK_ROUND_IDX}
		,FkEventIdx 		 => 	$HASH{FK_EVENT_IDX}
		,InRound 		 => 	$HASH{IN_ROUND}
		,TsCreate 		 => 	$HASH{TS_CREATE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkRoundIdx(){
	my ( $self ) = shift;
	return ($self->{PkRoundIdx});
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkEventIdx});
}

sub getInRound(){
	my ( $self ) = shift;
	return ($self->{InRound});
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($self->{TsCreate});
}


#------- BUILDING SETTERS------

sub setPkRoundIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkRoundIdx} = $value;
	return ($self->{PkRoundIdx});
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkEventIdx} = $value;
	return ($self->{FkEventIdx});
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InRound} = $value;
	return ($self->{InRound});
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsCreate} = $value;
	return ($self->{TsCreate});
}



return (1);

