package SAE::TB_JUDGE_TEAM

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkJudgeTeamIdx;
my $FkEventIdx;
my $FkTeamIdx;
my $FkUserIdx;
my $TxType;
my $FkAssessmentTypeIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbJudgeTeamRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX
		FROM `saestars_DB`.`TB_JUDGE_TEAM`
		WHERE PK_JUDGE_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkJudgeTeamIdx 		 => 	$HASH{PK_JUDGE_TEAM_IDX}
		,FkEventIdx 		 => 	$HASH{FK_EVENT_IDX}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
		,FkUserIdx 		 => 	$HASH{FK_USER_IDX}
		,TxType 		 => 	$HASH{TX_TYPE}
		,FkAssessmentTypeIdx 		 => 	$HASH{FK_ASSESSMENT_TYPE_IDX}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkJudgeTeamIdx(){
	my ( $self ) = shift;
	return ($self->{PkJudgeTeamIdx});
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkEventIdx});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($self->{FkUserIdx});
}

sub getTxType(){
	my ( $self ) = shift;
	return ($self->{TxType});
}

sub getFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentTypeIdx});
}


#------- BUILDING SETTERS------

sub setPkJudgeTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkJudgeTeamIdx} = $value;
	return ($self->{PkJudgeTeamIdx});
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkEventIdx} = $value;
	return ($self->{FkEventIdx});
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

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxType} = $value;
	return ($self->{TxType});
}

sub setFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentTypeIdx} = $value;
	return ($self->{FkAssessmentTypeIdx});
}



return (1);

