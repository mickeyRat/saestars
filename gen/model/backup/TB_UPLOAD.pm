package SAE::TB_UPLOAD

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkUploadIdx;
my $TxSerial;
my $TxFilename;
my $TxFile;
my $TsCreate;
my $FkTeamIdx;
my $FkEventIdx;
my $TxLabel;
my $TxType;
my $InSize;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbUploadRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, TS_CREATE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE
		FROM `saestars_DB`.`TB_UPLOAD`
		WHERE PK_UPLOAD_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkUploadIdx 		 => 	$HASH{PK_UPLOAD_IDX}
		,TxSerial 		 => 	$HASH{TX_SERIAL}
		,TxFilename 		 => 	$HASH{TX_FILENAME}
		,TxFile 		 => 	$HASH{TX_FILE}
		,TsCreate 		 => 	$HASH{TS_CREATE}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
		,FkEventIdx 		 => 	$HASH{FK_EVENT_IDX}
		,TxLabel 		 => 	$HASH{TX_LABEL}
		,TxType 		 => 	$HASH{TX_TYPE}
		,InSize 		 => 	$HASH{IN_SIZE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkUploadIdx(){
	my ( $self ) = shift;
	return ($self->{PkUploadIdx});
}

sub getTxSerial(){
	my ( $self ) = shift;
	return ($self->{TxSerial});
}

sub getTxFilename(){
	my ( $self ) = shift;
	return ($self->{TxFilename});
}

sub getTxFile(){
	my ( $self ) = shift;
	return ($self->{TxFile});
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($self->{TsCreate});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkEventIdx});
}

sub getTxLabel(){
	my ( $self ) = shift;
	return ($self->{TxLabel});
}

sub getTxType(){
	my ( $self ) = shift;
	return ($self->{TxType});
}

sub getInSize(){
	my ( $self ) = shift;
	return ($self->{InSize});
}


#------- BUILDING SETTERS------

sub setPkUploadIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkUploadIdx} = $value;
	return ($self->{PkUploadIdx});
}

sub setTxSerial(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxSerial} = $value;
	return ($self->{TxSerial});
}

sub setTxFilename(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxFilename} = $value;
	return ($self->{TxFilename});
}

sub setTxFile(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxFile} = $value;
	return ($self->{TxFile});
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsCreate} = $value;
	return ($self->{TsCreate});
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkEventIdx} = $value;
	return ($self->{FkEventIdx});
}

sub setTxLabel(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxLabel} = $value;
	return ($self->{TxLabel});
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxType} = $value;
	return ($self->{TxType});
}

sub setInSize(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InSize} = $value;
	return ($self->{InSize});
}



return (1);

