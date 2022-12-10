package SAE::TB_PUBLISH;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPublishIdx;
my $FkEventIdx;
my $FkClassIdx;
my $FkTilesIdx;
my $TxTitle;
my $TxFile;
my $InRound;
my $InShow;
my $BoScore;
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

	my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE) values (?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $FkClassIdx, $FkTilesIdx, $TxTitle, $TxFile, $InRound, $InShow, $BoScore);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE, TS_CREATE
		FROM TB_PUBLISH
		WHERE PK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPublishIdx 		 = 	$HASH{PK_PUBLISH_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$FkTilesIdx 		 = 	$HASH{FK_TILES_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxFile 		 = 	$HASH{TX_FILE};
	$InRound 		 = 	$HASH{IN_ROUND};
	$InShow 		 = 	$HASH{IN_SHOW};
	$BoScore 		 = 	$HASH{BO_SCORE};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE PK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE FK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InShow(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE IN_SHOW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH WHERE BO_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_TILES_IDX, TX_TITLE, TX_FILE, IN_ROUND, IN_SHOW, BO_SCORE FROM TB_PUBLISH";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
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

sub deleteRecordBy_PkPublishIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where PK_PUBLISH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where FK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTilesIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where FK_TILES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFile(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where TX_FILE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRound(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where IN_ROUND=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InShow(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where IN_SHOW=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoScore(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PUBLISH where BO_SCORE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

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

sub getFkTilesIdx(){
	my ( $self ) = shift;
	return ($FkTilesIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxFile(){
	my ( $self ) = shift;
	return ($TxFile);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}

sub getInShow(){
	my ( $self ) = shift;
	return ($InShow);
}

sub getBoScore(){
	my ( $self ) = shift;
	return ($BoScore);
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

sub setFkTilesIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTilesIdx = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
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

sub setInShow(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InShow = $value;
	return ($field);
}

sub setBoScore(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoScore = $value;
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
sub getIdBy_FkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where FK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where TX_TITLE=?";
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
sub getIdBy_InShow(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where IN_SHOW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoScore(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PUBLISH_IDX from TB_PUBLISH where BO_SCORE=?";
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
sub updateFkTilesIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set FK_TILES_IDX=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set TX_TITLE=? where PK_PUBLISH_IDX=?";
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
sub updateInShow_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set IN_SHOW=? where PK_PUBLISH_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoScore_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH set BO_SCORE=? where PK_PUBLISH_IDX=?";
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
sub updatePkPublishIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET PK_PUBLISH_IDX=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET FK_EVENT_IDX=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkClassIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET FK_CLASS_IDX=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTilesIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET FK_TILES_IDX=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET TX_TITLE=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFile_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET TX_FILE=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRound_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET IN_ROUND=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInShow_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET IN_SHOW=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoScore_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PUBLISH SET BO_SCORE=? where PK_PUBLISH_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

