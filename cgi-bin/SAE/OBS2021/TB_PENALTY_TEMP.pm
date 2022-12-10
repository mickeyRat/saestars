package SAE::TB_PENALTY_TEMP;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPenaltyTempIdx;
my $TxTitle;
my $TxComment;
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

	my $SQL = "INSERT INTO TB_PENALTY_TEMP (TX_TITLE, TX_COMMENT, IN_SCORE) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxTitle, $TxComment, $InScore);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PENALTY_TEMP_IDX, TX_TITLE, TX_COMMENT, IN_SCORE
		FROM TB_PENALTY_TEMP
		WHERE PK_PENALTY_TEMP_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPenaltyTempIdx 		 = 	$HASH{PK_PENALTY_TEMP_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxComment 		 = 	$HASH{TX_COMMENT};
	$InScore 		 = 	$HASH{IN_SCORE};
	return $self;

;}
sub getAllRecordBy_PkPenaltyTempIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PENALTY_TEMP_IDX, TX_TITLE, TX_COMMENT, IN_SCORE FROM TB_PENALTY_TEMP WHERE PK_PENALTY_TEMP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PENALTY_TEMP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PENALTY_TEMP_IDX, TX_TITLE, TX_COMMENT, IN_SCORE FROM TB_PENALTY_TEMP WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PENALTY_TEMP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PENALTY_TEMP_IDX, TX_TITLE, TX_COMMENT, IN_SCORE FROM TB_PENALTY_TEMP WHERE TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PENALTY_TEMP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PENALTY_TEMP_IDX, TX_TITLE, TX_COMMENT, IN_SCORE FROM TB_PENALTY_TEMP WHERE IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PENALTY_TEMP_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PENALTY_TEMP_IDX, TX_TITLE, TX_COMMENT, IN_SCORE FROM TB_PENALTY_TEMP";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_PENALTY_TEMP_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PENALTY_TEMP where PK_PENALTY_TEMP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkPenaltyTempIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PENALTY_TEMP where PK_PENALTY_TEMP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PENALTY_TEMP where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxComment(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PENALTY_TEMP where TX_COMMENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InScore(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PENALTY_TEMP where IN_SCORE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkPenaltyTempIdx(){
	my ( $self ) = shift;
	return ($PkPenaltyTempIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxComment(){
	my ( $self ) = shift;
	return ($TxComment);
}

sub getInScore(){
	my ( $self ) = shift;
	return ($InScore);
}


#------- BUILDING SETTERS------

sub setPkPenaltyTempIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPenaltyTempIdx = $value;
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

sub setInScore(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InScore = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_TEMP_IDX from TB_PENALTY_TEMP where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_TEMP_IDX from TB_PENALTY_TEMP where TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_TEMP_IDX from TB_PENALTY_TEMP where IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP set TX_TITLE=? where PK_PENALTY_TEMP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP set TX_COMMENT=? where PK_PENALTY_TEMP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInScore_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP set IN_SCORE=? where PK_PENALTY_TEMP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkPenaltyTempIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP SET PK_PENALTY_TEMP_IDX=? where PK_PENALTY_TEMP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP SET TX_TITLE=? where PK_PENALTY_TEMP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP SET TX_COMMENT=? where PK_PENALTY_TEMP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInScore_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY_TEMP SET IN_SCORE=? where PK_PENALTY_TEMP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

