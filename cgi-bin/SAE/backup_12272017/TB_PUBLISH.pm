package SAE::TB_PUBLISH;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $FkClassIdx, $TxSegment, $TxFile, $InRound);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND, TS_CREATE
		FROM TB_PUBLISH
		WHERE PK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPublishIdx 		 = 	$HASH{PK_PUBLISH_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$TxSegment 		 = 	$HASH{TX_SEGMENT};
	$TxFile 		 = 	$HASH{TX_FILE};
	$InRound 		 = 	$HASH{IN_ROUND};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE PK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSegment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE TX_SEGMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, TX_SEGMENT, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where PK_PUBLISH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkPublishIdx(){
	my ( $self ) = shift;
	return ($PkPublishIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}

sub getTxSegment(){
	my ( $self ) = shift;
	return ($TxSegment);
}

sub getTxFile(){
	my ( $self ) = shift;
	return ($TxFile);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkPublishIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPublishIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkClassIdx = $value;
	return ($field);
}

sub setTxSegment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSegment = $value;
	return ($field);
}

sub setTxFile(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFile = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSegment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where TX_SEGMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set FK_EVENT_IDX=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkClassIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set FK_CLASS_IDX=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSegment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set TX_SEGMENT=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFile_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set TX_FILE=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set IN_ROUND=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set TS_CREATE=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

