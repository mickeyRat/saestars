package SAE::TB_SCORE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreIdx;
my $FkPaperIdx;
my $TxSession;
my $FkTeamIdx;
my $FkScoreGroupIdx;
my $FkScoreSectionIdx;
my $FkScoreItemIdx;
my $InRound;
my $InScore;
my $TxTitle;
my $TxComment;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SCORE (FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkPaperIdx, $TxSession, $FkTeamIdx, $FkScoreGroupIdx, $FkScoreSectionIdx, $FkScoreItemIdx, $InRound, $InScore, $TxTitle, $TxComment);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT
		FROM TB_SCORE
		WHERE PK_SCORE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreIdx 		 = 	$HASH{PK_SCORE_IDX};
	$FkPaperIdx 		 = 	$HASH{FK_PAPER_IDX};
	$TxSession 		 = 	$HASH{TX_SESSION};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkScoreGroupIdx 		 = 	$HASH{FK_SCORE_GROUP_IDX};
	$FkScoreSectionIdx 		 = 	$HASH{FK_SCORE_SECTION_IDX};
	$FkScoreItemIdx 		 = 	$HASH{FK_SCORE_ITEM_IDX};
	$InRound 		 = 	$HASH{IN_ROUND};
	$InScore 		 = 	$HASH{IN_SCORE};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxComment 		 = 	$HASH{TX_COMMENT};
	return $self;

;}
sub getAllRecordBy_PkScoreIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE PK_SCORE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkPaperIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE FK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSession(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE TX_SESSION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE FK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE FK_SCORE_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreItemIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE FK_SCORE_ITEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE WHERE TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_PAPER_IDX, TX_SESSION, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_SCORE_SECTION_IDX, FK_SCORE_ITEM_IDX, IN_ROUND, IN_SCORE, TX_TITLE, TX_COMMENT FROM TB_SCORE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where PK_SCORE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkScoreIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where PK_SCORE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkPaperIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_PAPER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxSession(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where TX_SESSION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_SCORE_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_SCORE_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreItemIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_SCORE_ITEM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRound(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_ROUND=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InScore(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_SCORE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxComment(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where TX_COMMENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkScoreIdx(){
	my ( $self ) = shift;
	return ($PkScoreIdx);
}

sub getFkPaperIdx(){
	my ( $self ) = shift;
	return ($FkPaperIdx);
}

sub getTxSession(){
	my ( $self ) = shift;
	return ($TxSession);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkScoreGroupIdx(){
	my ( $self ) = shift;
	return ($FkScoreGroupIdx);
}

sub getFkScoreSectionIdx(){
	my ( $self ) = shift;
	return ($FkScoreSectionIdx);
}

sub getFkScoreItemIdx(){
	my ( $self ) = shift;
	return ($FkScoreItemIdx);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}

sub getInScore(){
	my ( $self ) = shift;
	return ($InScore);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxComment(){
	my ( $self ) = shift;
	return ($TxComment);
}


#------- BUILDING SETTERS------

sub setPkScoreIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreIdx = $value;
	return ($field);
}

sub setFkPaperIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkPaperIdx = $value;
	return ($field);
}

sub setTxSession(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSession = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkScoreGroupIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreGroupIdx = $value;
	return ($field);
}

sub setFkScoreSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreSectionIdx = $value;
	return ($field);
}

sub setFkScoreItemIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreItemIdx = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}

sub setInScore(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InScore = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setTxComment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxComment = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkPaperIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSession(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where TX_SESSION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkScoreSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_SCORE_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkScoreItemIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_SCORE_ITEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkPaperIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_PAPER_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSession_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set TX_SESSION=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_TEAM_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkScoreGroupIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_SCORE_GROUP_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkScoreSectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_SCORE_SECTION_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkScoreItemIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_SCORE_ITEM_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_ROUND=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInScore_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_SCORE=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set TX_TITLE=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set TX_COMMENT=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkScoreIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET PK_SCORE_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkPaperIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_PAPER_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSession_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET TX_SESSION=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_TEAM_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_SCORE_GROUP_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_SCORE_SECTION_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreItemIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_SCORE_ITEM_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRound_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_ROUND=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInScore_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_SCORE=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET TX_TITLE=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET TX_COMMENT=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

