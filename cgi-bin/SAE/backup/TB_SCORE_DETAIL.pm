package SAE::TB_SCORE_DETAIL

use DBI
use SAE::SDB

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
sub getTbScoreDetailRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_DETAIL_IDX, FK_ASSESSMENT_TYPE_IDX, FK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_REQ_IDX, FK_TEAM_IDX, FK_USER_IDX, IN_VALUE, FK_JUDGE_TEAM_IDX, IN_ROUND
		FROM `saestars_DB`.`TB_SCORE_DETAIL`
		WHERE PK_SCORE_DETAIL_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkScoreDetailIdx 		 => 	$HASH{PK_SCORE_DETAIL_IDX}
		,FkAssessmentTypeIdx 		 => 	$HASH{FK_ASSESSMENT_TYPE_IDX}
		,FkAssessmentOptIdx 		 => 	$HASH{FK_ASSESSMENT_OPT_IDX}
		,FkAssessmentReqIdx 		 => 	$HASH{FK_ASSESSMENT_REQ_IDX}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
		,FkUserIdx 		 => 	$HASH{FK_USER_IDX}
		,InValue 		 => 	$HASH{IN_VALUE}
		,FkJudgeTeamIdx 		 => 	$HASH{FK_JUDGE_TEAM_IDX}
		,InRound 		 => 	$HASH{IN_ROUND}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkScoreDetailIdx(){
	my ( $self ) = shift;
	return ($self->{PkScoreDetailIdx});
}

sub getFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentTypeIdx});
}

sub getFkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentOptIdx});
}

sub getFkAssessmentReqIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentReqIdx});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($self->{FkUserIdx});
}

sub getInValue(){
	my ( $self ) = shift;
	return ($self->{InValue});
}

sub getFkJudgeTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkJudgeTeamIdx});
}

sub getInRound(){
	my ( $self ) = shift;
	return ($self->{InRound});
}


#------- BUILDING SETTERS------

sub setPkScoreDetailIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkScoreDetailIdx} = $value;
	return ($self->{PkScoreDetailIdx});
}

sub setFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentTypeIdx} = $value;
	return ($self->{FkAssessmentTypeIdx});
}

sub setFkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentOptIdx} = $value;
	return ($self->{FkAssessmentOptIdx});
}

sub setFkAssessmentReqIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentReqIdx} = $value;
	return ($self->{FkAssessmentReqIdx});
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkUserIdx} = $value;
	return ($self->{FkUserIdx});
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InValue} = $value;
	return ($self->{InValue});
}

sub setFkJudgeTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkJudgeTeamIdx} = $value;
	return ($self->{FkJudgeTeamIdx});
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InRound} = $value;
	return ($self->{InRound});
}



return (1);

