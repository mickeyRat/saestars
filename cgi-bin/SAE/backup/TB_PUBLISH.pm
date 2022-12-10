package SAE::TB_PUBLISH

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkPublishIdx;
my $FkEventIdx;
my $FkClassIdx;
my $TxSegment;
my $TxFile;
my $InRound;
my $TsCreate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbPublishRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND, TS_CREATE
		FROM `saestars_DB`.`TB_PUBLISH`
		WHERE PK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkPublishIdx 		 => 	$HASH{PK_PUBLISH_IDX}
		,FkEventIdx 		 => 	$HASH{FK_EVENT_IDX}
		,FkClassIdx 		 => 	$HASH{FK_CLASS_IDX}
		,TxSegment 		 => 	$HASH{TX_SEGMENT}
		,TxFile 		 => 	$HASH{TX_FILE}
		,InRound 		 => 	$HASH{IN_ROUND}
		,TsCreate 		 => 	$HASH{TS_CREATE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkPublishIdx(){
	my ( $self ) = shift;
	return ($self->{PkPublishIdx});
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkEventIdx});
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($self->{FkClassIdx});
}

sub getTxSegment(){
	my ( $self ) = shift;
	return ($self->{TxSegment});
}

sub getTxFile(){
	my ( $self ) = shift;
	return ($self->{TxFile});
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

sub setPkPublishIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkPublishIdx} = $value;
	return ($self->{PkPublishIdx});
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkEventIdx} = $value;
	return ($self->{FkEventIdx});
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkClassIdx} = $value;
	return ($self->{FkClassIdx});
}

sub setTxSegment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxSegment} = $value;
	return ($self->{TxSegment});
}

sub setTxFile(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxFile} = $value;
	return ($self->{TxFile});
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

