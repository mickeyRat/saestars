package SAE::TB_COMMENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCommentIdx;
my $FkPaperIdx;
my $FkGradeIdx;
my $FkScoreItemIdx;
my $FkQuestionIdx;
my $FkTeamIdx;
my $TxComment;
my $TsCreate;
my $TsUpdate;
my $FkUserIdx;
my $BoShow;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_COMMENT (FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkPaperIdx, $FkGradeIdx, $FkScoreItemIdx, $FkQuestionIdx, $FkTeamIdx, $TxComment, $TsUpdate, $FkUserIdx, $BoShow);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_CREATE, TS_UPDATE, FK_USER_IDX, BO_SHOW
		FROM TB_COMMENT
		WHERE PK_COMMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCommentIdx 		 = 	$HASH{PK_COMMENT_IDX};
	$FkPaperIdx 		 = 	$HASH{FK_PAPER_IDX};
	$FkGradeIdx 		 = 	$HASH{FK_GRADE_IDX};
	$FkScoreItemIdx 		 = 	$HASH{FK_SCORE_ITEM_IDX};
	$FkQuestionIdx 		 = 	$HASH{FK_QUESTION_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$TxComment 		 = 	$HASH{TX_COMMENT};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$TsUpdate 		 = 	$HASH{TS_UPDATE};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$BoShow 		 = 	$HASH{BO_SHOW};
	return $self;

;}
sub getAllRecordBy_PkCommentIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE PK_COMMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkPaperIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkGradeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_GRADE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreItemIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_SCORE_ITEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkQuestionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TsUpdate(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE TS_UPDATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoShow(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE BO_SHOW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_PAPER_IDX, FK_GRADE_IDX, FK_SCORE_ITEM_IDX, FK_QUESTION_IDX, FK_TEAM_IDX, TX_COMMENT, TS_UPDATE, FK_USER_IDX, BO_SHOW FROM TB_COMMENT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where PK_COMMENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkCommentIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where PK_COMMENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkPaperIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where FK_PAPER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkGradeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where FK_GRADE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreItemIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where FK_SCORE_ITEM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkQuestionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where FK_QUESTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxComment(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where TX_COMMENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TsUpdate(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where TS_UPDATE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoShow(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT where BO_SHOW=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkCommentIdx(){
	my ( $self ) = shift;
	return ($PkCommentIdx);
}

sub getFkPaperIdx(){
	my ( $self ) = shift;
	return ($FkPaperIdx);
}

sub getFkGradeIdx(){
	my ( $self ) = shift;
	return ($FkGradeIdx);
}

sub getFkScoreItemIdx(){
	my ( $self ) = shift;
	return ($FkScoreItemIdx);
}

sub getFkQuestionIdx(){
	my ( $self ) = shift;
	return ($FkQuestionIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getTxComment(){
	my ( $self ) = shift;
	return ($TxComment);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getTsUpdate(){
	my ( $self ) = shift;
	return ($TsUpdate);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getBoShow(){
	my ( $self ) = shift;
	return ($BoShow);
}


#------- BUILDING SETTERS------

sub setPkCommentIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCommentIdx = $value;
	return ($field);
}

sub setFkPaperIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkPaperIdx = $value;
	return ($field);
}

sub setFkGradeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkGradeIdx = $value;
	return ($field);
}

sub setFkScoreItemIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreItemIdx = $value;
	return ($field);
}

sub setFkQuestionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkQuestionIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setTxComment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxComment = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setTsUpdate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsUpdate = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setBoShow(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoShow = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkPaperIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkGradeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_GRADE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkScoreItemIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_SCORE_ITEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkQuestionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoShow(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where BO_SHOW=?";
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

	my $SQL = "UPDATE TB_COMMENT set FK_PAPER_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkGradeIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_GRADE_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkScoreItemIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_SCORE_ITEM_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkQuestionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_QUESTION_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_TEAM_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set TX_COMMENT=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set TS_CREATE=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsUpdate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set TS_UPDATE=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_USER_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoShow_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set BO_SHOW=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCommentIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET PK_COMMENT_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkPaperIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET FK_PAPER_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkGradeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET FK_GRADE_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreItemIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET FK_SCORE_ITEM_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkQuestionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET FK_QUESTION_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET FK_TEAM_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET TX_COMMENT=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTsUpdate_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET TS_UPDATE=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET FK_USER_IDX=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoShow_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT SET BO_SHOW=? where PK_COMMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

