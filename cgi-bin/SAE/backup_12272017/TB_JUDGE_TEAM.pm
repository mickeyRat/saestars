package SAE::TB_JUDGE_TEAM;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_JUDGE_TEAM (FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $FkTeamIdx, $FkUserIdx, $TxType, $FkAssessmentTypeIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX
		FROM TB_JUDGE_TEAM
		WHERE PK_JUDGE_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkJudgeTeamIdx 		 = 	$HASH{PK_JUDGE_TEAM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$FkAssessmentTypeIdx 		 = 	$HASH{FK_ASSESSMENT_TYPE_IDX};
	return $self;

;}
sub getAllRecordBy_PkJudgeTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX FROM TB_JUDGE_TEAM WHERE PK_JUDGE_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_JUDGE_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX FROM TB_JUDGE_TEAM WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_JUDGE_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX FROM TB_JUDGE_TEAM WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_JUDGE_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX FROM TB_JUDGE_TEAM WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_JUDGE_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX FROM TB_JUDGE_TEAM WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_JUDGE_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkAssessmentTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_JUDGE_TEAM_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_USER_IDX, TX_TYPE, FK_ASSESSMENT_TYPE_IDX FROM TB_JUDGE_TEAM WHERE FK_ASSESSMENT_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_JUDGE_TEAM_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_JUDGE_TEAM where PK_JUDGE_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkJudgeTeamIdx(){
	my ( $self ) = shift;
	return ($PkJudgeTeamIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentTypeIdx);
}


#------- BUILDING SETTERS------

sub setPkJudgeTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkJudgeTeamIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
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

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentTypeIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_JUDGE_TEAM_IDX from TB_JUDGE_TEAM where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_JUDGE_TEAM_IDX from TB_JUDGE_TEAM where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_JUDGE_TEAM_IDX from TB_JUDGE_TEAM where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_JUDGE_TEAM_IDX from TB_JUDGE_TEAM where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkAssessmentTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_JUDGE_TEAM_IDX from TB_JUDGE_TEAM where FK_ASSESSMENT_TYPE_IDX=?";
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

	my $SQL = "UPDATE TB_JUDGE_TEAM set FK_EVENT_IDX=? where PK_JUDGE_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_JUDGE_TEAM set FK_TEAM_IDX=? where PK_JUDGE_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_JUDGE_TEAM set FK_USER_IDX=? where PK_JUDGE_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_JUDGE_TEAM set TX_TYPE=? where PK_JUDGE_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkAssessmentTypeIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_JUDGE_TEAM set FK_ASSESSMENT_TYPE_IDX=? where PK_JUDGE_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

