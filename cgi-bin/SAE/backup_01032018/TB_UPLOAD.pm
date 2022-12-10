package SAE::TB_UPLOAD;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_UPLOAD (TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE) values (?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxSerial, $TxFilename, $TxFile, $FkTeamIdx, $FkEventIdx, $TxLabel, $TxType, $InSize);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, TS_CREATE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE
		FROM TB_UPLOAD
		WHERE PK_UPLOAD_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUploadIdx 		 = 	$HASH{PK_UPLOAD_IDX};
	$TxSerial 		 = 	$HASH{TX_SERIAL};
	$TxFilename 		 = 	$HASH{TX_FILENAME};
	$TxFile 		 = 	$HASH{TX_FILE};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$TxLabel 		 = 	$HASH{TX_LABEL};
	$TxType 		 = 	$HASH{TX_TYPE};
	$InSize 		 = 	$HASH{IN_SIZE};
	return $self;

;}
sub getAllRecordBy_PkUploadIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE PK_UPLOAD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSerial(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE TX_SERIAL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFilename(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE TX_FILENAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxLabel(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE TX_LABEL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSize(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD WHERE IN_SIZE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, TX_SERIAL, TX_FILENAME, TX_FILE, FK_TEAM_IDX, FK_EVENT_IDX, TX_LABEL, TX_TYPE, IN_SIZE FROM TB_UPLOAD";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where PK_UPLOAD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkUploadIdx(){
	my ( $self ) = shift;
	return ($PkUploadIdx);
}

sub getTxSerial(){
	my ( $self ) = shift;
	return ($TxSerial);
}

sub getTxFilename(){
	my ( $self ) = shift;
	return ($TxFilename);
}

sub getTxFile(){
	my ( $self ) = shift;
	return ($TxFile);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getTxLabel(){
	my ( $self ) = shift;
	return ($TxLabel);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getInSize(){
	my ( $self ) = shift;
	return ($InSize);
}


#------- BUILDING SETTERS------

sub setPkUploadIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUploadIdx = $value;
	return ($field);
}

sub setTxSerial(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSerial = $value;
	return ($field);
}

sub setTxFilename(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFilename = $value;
	return ($field);
}

sub setTxFile(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFile = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setTxLabel(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxLabel = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setInSize(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSize = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxSerial(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_SERIAL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFilename(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_FILENAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxLabel(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_LABEL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSize(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where IN_SIZE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxSerial_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_SERIAL=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFilename_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_FILENAME=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFile_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_FILE=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TS_CREATE=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set FK_TEAM_IDX=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set FK_EVENT_IDX=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxLabel_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_LABEL=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_TYPE=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSize_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set IN_SIZE=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkUploadIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET PK_UPLOAD_IDX=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSerial_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_SERIAL=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFilename_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_FILENAME=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFile_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_FILE=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET FK_TEAM_IDX=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET FK_EVENT_IDX=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxLabel_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_LABEL=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_TYPE=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSize_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET IN_SIZE=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

