package SAE::TB_COMMENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCommentIdx;
my $FkTeamIdx;
my $FkAssessmentOptIdx;
my $TxComment;
my $TsCreate;
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

	my $SQL = "INSERT INTO TB_COMMENT (FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $FkAssessmentOptIdx, $TxComment, $FkUserIdx, $BoShow);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, TS_CREATE, FK_USER_IDX, BO_SHOW
		FROM TB_COMMENT
		WHERE PK_COMMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCommentIdx 		 = 	$HASH{PK_COMMENT_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkAssessmentOptIdx 		 = 	$HASH{FK_ASSESSMENT_OPT_IDX};
	$TxComment 		 = 	$HASH{TX_COMMENT};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$BoShow 		 = 	$HASH{BO_SHOW};
	return $self;

;}
sub getAllRecordBy_PkCommentIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE PK_COMMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkAssessmentOptIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoShow(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, FK_USER_IDX, BO_SHOW FROM TB_COMMENT WHERE BO_SHOW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
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

sub getPkCommentIdx(){
	my ( $self ) = shift;
	return ($PkCommentIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentOptIdx);
}

sub getTxComment(){
	my ( $self ) = shift;
	return ($TxComment);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
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

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentOptIdx = $value;
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

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkAssessmentOptIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_IDX from TB_COMMENT where FK_ASSESSMENT_OPT_IDX=?";
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

sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_TEAM_IDX=? where PK_COMMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkAssessmentOptIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT set FK_ASSESSMENT_OPT_IDX=? where PK_COMMENT_IDX=?";
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
return (1);

