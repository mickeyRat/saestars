package SAE::TB_UPLOAD;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkUploadIdx;
my $FkTeamIdx;
my $InNumber;
my $FkEventIdx;
my $TxKeys;
my $TxFilename;
my $TxType;
my $TxPaper;
my $InPaper;
my $TxFolder;
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

	my $SQL = "INSERT INTO TB_UPLOAD (FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $InNumber, $FkEventIdx, $TxKeys, $TxFilename, $TxType, $TxPaper, $InPaper, $TxFolder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER, TS_CREATE
		FROM TB_UPLOAD
		WHERE PK_UPLOAD_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUploadIdx 		 = 	$HASH{PK_UPLOAD_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$InNumber 		 = 	$HASH{IN_NUMBER};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$TxKeys 		 = 	$HASH{TX_KEYS};
	$TxFilename 		 = 	$HASH{TX_FILENAME};
	$TxType 		 = 	$HASH{TX_TYPE};
	$TxPaper 		 = 	$HASH{TX_PAPER};
	$InPaper 		 = 	$HASH{IN_PAPER};
	$TxFolder 		 = 	$HASH{TX_FOLDER};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkUploadIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE PK_UPLOAD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InNumber(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE IN_NUMBER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxKeys(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE TX_KEYS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFilename(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE TX_FILENAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxPaper(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE TX_PAPER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPaper(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE IN_PAPER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFolder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD WHERE TX_FOLDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_UPLOAD_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_UPLOAD_IDX, FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER FROM TB_UPLOAD";
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

sub deleteRecordBy_PkUploadIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where PK_UPLOAD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InNumber(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where IN_NUMBER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxKeys(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where TX_KEYS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFilename(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where TX_FILENAME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where TX_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxPaper(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where TX_PAPER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPaper(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where IN_PAPER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFolder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_UPLOAD where TX_FOLDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkUploadIdx(){
	my ( $self ) = shift;
	return ($PkUploadIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getInNumber(){
	my ( $self ) = shift;
	return ($InNumber);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getTxKeys(){
	my ( $self ) = shift;
	return ($TxKeys);
}

sub getTxFilename(){
	my ( $self ) = shift;
	return ($TxFilename);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getTxPaper(){
	my ( $self ) = shift;
	return ($TxPaper);
}

sub getInPaper(){
	my ( $self ) = shift;
	return ($InPaper);
}

sub getTxFolder(){
	my ( $self ) = shift;
	return ($TxFolder);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkUploadIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUploadIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setInNumber(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InNumber = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setTxKeys(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxKeys = $value;
	return ($field);
}

sub setTxFilename(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFilename = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setTxPaper(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxPaper = $value;
	return ($field);
}

sub setInPaper(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPaper = $value;
	return ($field);
}

sub setTxFolder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFolder = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InNumber(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where IN_NUMBER=?";
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
sub getIdBy_TxKeys(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_KEYS=?";
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
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxPaper(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_PAPER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPaper(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where IN_PAPER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFolder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_UPLOAD_IDX from TB_UPLOAD where TX_FOLDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set FK_TEAM_IDX=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInNumber_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set IN_NUMBER=? where PK_UPLOAD_IDX=?";
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
sub updateTxKeys_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_KEYS=? where PK_UPLOAD_IDX=?";
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
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_TYPE=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxPaper_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_PAPER=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPaper_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set IN_PAPER=? where PK_UPLOAD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFolder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD set TX_FOLDER=? where PK_UPLOAD_IDX=?";
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
sub updatePkUploadIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET PK_UPLOAD_IDX=? where PK_UPLOAD_IDX = ?";
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

sub updateInNumber_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET IN_NUMBER=? where PK_UPLOAD_IDX = ?";
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

sub updateTxKeys_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_KEYS=? where PK_UPLOAD_IDX = ?";
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

sub updateTxType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_TYPE=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxPaper_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_PAPER=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPaper_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET IN_PAPER=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFolder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_UPLOAD SET TX_FOLDER=? where PK_UPLOAD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

