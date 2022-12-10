package SAE::TB_PAPER;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPaperIdx;
my $FkUserIdx;
my $FkTeamIdx;
my $FkScoreGroupIdx;
my $FkPaperStatusIdx;
my $FkEventIdx;
my $InJudge;
my $InScore;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_PAPER (FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkTeamIdx, $FkScoreGroupIdx, $FkPaperStatusIdx, $FkEventIdx, $InJudge, $InScore);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE
		FROM TB_PAPER
		WHERE PK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPaperIdx 		 = 	$HASH{PK_PAPER_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkScoreGroupIdx 		 = 	$HASH{FK_SCORE_GROUP_IDX};
	$FkPaperStatusIdx 		 = 	$HASH{FK_PAPER_STATUS_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InJudge 		 = 	$HASH{IN_JUDGE};
	$InScore 		 = 	$HASH{IN_SCORE};
	return $self;

;}
sub getAllRecordBy_PkPaperIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE PK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE FK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkPaperStatusIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE FK_PAPER_STATUS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InJudge(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE IN_JUDGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER WHERE IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_SCORE_GROUP_IDX, FK_PAPER_STATUS_IDX, FK_EVENT_IDX, IN_JUDGE, IN_SCORE FROM TB_PAPER";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER where PK_PAPER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkPaperIdx(){
	my ( $self ) = shift;
	return ($PkPaperIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkScoreGroupIdx(){
	my ( $self ) = shift;
	return ($FkScoreGroupIdx);
}

sub getFkPaperStatusIdx(){
	my ( $self ) = shift;
	return ($FkPaperStatusIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInJudge(){
	my ( $self ) = shift;
	return ($InJudge);
}

sub getInScore(){
	my ( $self ) = shift;
	return ($InScore);
}


#------- BUILDING SETTERS------

sub setPkPaperIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPaperIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
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

sub setFkPaperStatusIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkPaperStatusIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setInJudge(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InJudge = $value;
	return ($field);
}

sub setInScore(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InScore = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkPaperStatusIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_PAPER_STATUS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InJudge(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where IN_JUDGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_USER_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_TEAM_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkScoreGroupIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_SCORE_GROUP_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkPaperStatusIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_PAPER_STATUS_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_EVENT_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInJudge_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set IN_JUDGE=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInScore_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set IN_SCORE=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkPaperIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET PK_PAPER_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_USER_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_TEAM_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_SCORE_GROUP_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkPaperStatusIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_PAPER_STATUS_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_EVENT_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInJudge_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET IN_JUDGE=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInScore_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET IN_SCORE=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

