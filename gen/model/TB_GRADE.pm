package SAE::TB_GRADE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkGradeIdx;
my $FkUserIdx;
my $FkTeamIdx;
my $BoStatus;
my $BoPen25;
my $BoPen50;
my $InScore;
my $TxType;
my $TxTitle;
my $TxDescription;
my $InRound;
my $ETeamIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_GRADE (FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkTeamIdx, $BoStatus, $BoPen25, $BoPen50, $InScore, $TxType, $TxTitle, $TxDescription, $InRound, $ETeamIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX
		FROM TB_GRADE
		WHERE PK_GRADE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkGradeIdx 		 = 	$HASH{PK_GRADE_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$BoStatus 		 = 	$HASH{BO_STATUS};
	$BoPen25 		 = 	$HASH{BO_PEN25};
	$BoPen50 		 = 	$HASH{BO_PEN50};
	$InScore 		 = 	$HASH{IN_SCORE};
	$TxType 		 = 	$HASH{TX_TYPE};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxDescription 		 = 	$HASH{TX_DESCRIPTION};
	$InRound 		 = 	$HASH{IN_ROUND};
	$ETeamIdx 		 = 	$HASH{E_TEAM_IDX};
	return $self;

;}
sub getAllRecordBy_PkGradeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE PK_GRADE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE BO_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoPen25(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE BO_PEN25=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoPen50(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE BO_PEN50=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE TX_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ETeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE WHERE E_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, BO_PEN25, BO_PEN50, IN_SCORE, TX_TYPE, TX_TITLE, TX_DESCRIPTION, IN_ROUND, E_TEAM_IDX FROM TB_GRADE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where PK_GRADE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkGradeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where PK_GRADE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where BO_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoPen25(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where BO_PEN25=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoPen50(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where BO_PEN50=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InScore(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where IN_SCORE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where TX_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxDescription(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where TX_DESCRIPTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRound(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where IN_ROUND=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ETeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GRADE where E_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkGradeIdx(){
	my ( $self ) = shift;
	return ($PkGradeIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getBoStatus(){
	my ( $self ) = shift;
	return ($BoStatus);
}

sub getBoPen25(){
	my ( $self ) = shift;
	return ($BoPen25);
}

sub getBoPen50(){
	my ( $self ) = shift;
	return ($BoPen50);
}

sub getInScore(){
	my ( $self ) = shift;
	return ($InScore);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxDescription(){
	my ( $self ) = shift;
	return ($TxDescription);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}

sub getETeamIdx(){
	my ( $self ) = shift;
	return ($ETeamIdx);
}


#------- BUILDING SETTERS------

sub setPkGradeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkGradeIdx = $value;
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

sub setBoStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoStatus = $value;
	return ($field);
}

sub setBoPen25(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoPen25 = $value;
	return ($field);
}

sub setBoPen50(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoPen50 = $value;
	return ($field);
}

sub setInScore(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InScore = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setTxDescription(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxDescription = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}

sub setETeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ETeamIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where BO_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoPen25(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where BO_PEN25=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoPen50(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where BO_PEN50=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDescription(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where TX_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ETeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GRADE_IDX from TB_GRADE where E_TEAM_IDX=?";
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

	my $SQL = "UPDATE TB_GRADE set FK_USER_IDX=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set FK_TEAM_IDX=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set BO_STATUS=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoPen25_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set BO_PEN25=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoPen50_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set BO_PEN50=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInScore_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set IN_SCORE=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set TX_TYPE=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set TX_TITLE=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDescription_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set TX_DESCRIPTION=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set IN_ROUND=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateETeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE set E_TEAM_IDX=? where PK_GRADE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkGradeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET PK_GRADE_IDX=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET FK_USER_IDX=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET FK_TEAM_IDX=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET BO_STATUS=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoPen25_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET BO_PEN25=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoPen50_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET BO_PEN50=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInScore_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET IN_SCORE=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET TX_TYPE=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET TX_TITLE=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDescription_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET TX_DESCRIPTION=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRound_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET IN_ROUND=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateETeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GRADE SET E_TEAM_IDX=? where PK_GRADE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

