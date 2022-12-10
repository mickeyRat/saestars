package SAE::TB_GRADE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkGradeIdx;
my $FkUserIdx;
my $FkTeamIdx;
my $BoStatus;
my $InScore;
my $TxType;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_GRADE (FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkTeamIdx, $BoStatus, $InScore, $TxType);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE
		FROM TB_GRADE
		WHERE PK_GRADE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkGradeIdx 		 = 	$HASH{PK_GRADE_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$BoStatus 		 = 	$HASH{BO_STATUS};
	$InScore 		 = 	$HASH{IN_SCORE};
	$TxType 		 = 	$HASH{TX_TYPE};
	return $self;

;}
sub getAllRecordBy_PkGradeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE WHERE PK_GRADE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE WHERE BO_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE WHERE IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GRADE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GRADE_IDX, FK_USER_IDX, FK_TEAM_IDX, BO_STATUS, IN_SCORE, TX_TYPE FROM TB_GRADE";
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

sub getInScore(){
	my ( $self ) = shift;
	return ($InScore);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
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

return (1);

