package SAE::TB_SCORE_DETAIL_BAK3;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreDetailIdx;
my $FkAssessmentTypeIdx;
my $FkAssessmentOptIdx;
my $FkAssessmentReqIdx;
my $FkTeamIdx;
my $FkUserIdx;
my $InValue;
my $FkJudgeTeamIdx;
my $InRound;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SCORE_DETAIL_BAK3 () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_DETAIL_IDX, FK_ASSESSMENT_TYPE_IDX, FK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_REQ_IDX, FK_TEAM_IDX, FK_USER_IDX, IN_VALUE, FK_JUDGE_TEAM_IDX, IN_ROUND
		FROM TB_SCORE_DETAIL_BAK3
		WHERE PK_SCORE_DETAIL_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreDetailIdx 		 = 	$HASH{PK_SCORE_DETAIL_IDX};
	$FkAssessmentTypeIdx 		 = 	$HASH{FK_ASSESSMENT_TYPE_IDX};
	$FkAssessmentOptIdx 		 = 	$HASH{FK_ASSESSMENT_OPT_IDX};
	$FkAssessmentReqIdx 		 = 	$HASH{FK_ASSESSMENT_REQ_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$InValue 		 = 	$HASH{IN_VALUE};
	$FkJudgeTeamIdx 		 = 	$HASH{FK_JUDGE_TEAM_IDX};
	$InRound 		 = 	$HASH{IN_ROUND};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkScoreDetailIdx(){
	my ( $self ) = shift;
	return ($PkScoreDetailIdx);
}

sub getFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentTypeIdx);
}

sub getFkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentOptIdx);
}

sub getFkAssessmentReqIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentReqIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getInValue(){
	my ( $self ) = shift;
	return ($InValue);
}

sub getFkJudgeTeamIdx(){
	my ( $self ) = shift;
	return ($FkJudgeTeamIdx);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}


#------- BUILDING SETTERS------

sub setPkScoreDetailIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreDetailIdx = $value;
	return ($field);
}

sub setFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentTypeIdx = $value;
	return ($field);
}

sub setFkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentOptIdx = $value;
	return ($field);
}

sub setFkAssessmentReqIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentReqIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InValue = $value;
	return ($field);
}

sub setFkJudgeTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkJudgeTeamIdx = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkAssessmentTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where FK_ASSESSMENT_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkAssessmentOptIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where FK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkAssessmentReqIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where FK_ASSESSMENT_REQ_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InValue(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where IN_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkJudgeTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where FK_JUDGE_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_DETAIL_IDX from TB_SCORE_DETAIL_BAK3 where IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkAssessmentTypeIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set FK_ASSESSMENT_TYPE_IDX=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkAssessmentOptIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set FK_ASSESSMENT_OPT_IDX=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkAssessmentReqIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set FK_ASSESSMENT_REQ_IDX=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set FK_TEAM_IDX=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set FK_USER_IDX=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInValue_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set IN_VALUE=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkJudgeTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set FK_JUDGE_TEAM_IDX=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_DETAIL_BAK3 set IN_ROUND=? where PK_SCORE_DETAIL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

