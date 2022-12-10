package SAE::TB_QUESTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkQuestionIdx;
my $FkSubSectionIdx;
my $InCheck;
my $TxTitle;
my $TxDescription;
my $InWeight;
my $InOrder;
my $BoDemo;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_QUESTION (FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkSubSectionIdx, $InCheck, $TxTitle, $TxDescription, $InWeight, $InOrder, $BoDemo);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO
		FROM TB_QUESTION
		WHERE PK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkQuestionIdx 		 = 	$HASH{PK_QUESTION_IDX};
	$FkSubSectionIdx 		 = 	$HASH{FK_SUB_SECTION_IDX};
	$InCheck 		 = 	$HASH{IN_CHECK};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxDescription 		 = 	$HASH{TX_DESCRIPTION};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InOrder 		 = 	$HASH{IN_ORDER};
	$BoDemo 		 = 	$HASH{BO_DEMO};
	return $self;

;}
sub getAllRecordBy_PkQuestionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE PK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkSubSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE FK_SUB_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InCheck(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE IN_CHECK=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE TX_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoDemo(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION WHERE BO_DEMO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, FK_SUB_SECTION_IDX, IN_CHECK, TX_TITLE, TX_DESCRIPTION, IN_WEIGHT, IN_ORDER, BO_DEMO FROM TB_QUESTION";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where PK_QUESTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkQuestionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where PK_QUESTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkSubSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where FK_SUB_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InCheck(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where IN_CHECK=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxDescription(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where TX_DESCRIPTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoDemo(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_QUESTION where BO_DEMO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkQuestionIdx(){
	my ( $self ) = shift;
	return ($PkQuestionIdx);
}

sub getFkSubSectionIdx(){
	my ( $self ) = shift;
	return ($FkSubSectionIdx);
}

sub getInCheck(){
	my ( $self ) = shift;
	return ($InCheck);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxDescription(){
	my ( $self ) = shift;
	return ($TxDescription);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}

sub getBoDemo(){
	my ( $self ) = shift;
	return ($BoDemo);
}


#------- BUILDING SETTERS------

sub setPkQuestionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkQuestionIdx = $value;
	return ($field);
}

sub setFkSubSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkSubSectionIdx = $value;
	return ($field);
}

sub setInCheck(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InCheck = $value;
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

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}

sub setBoDemo(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoDemo = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkSubSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where FK_SUB_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InCheck(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where IN_CHECK=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDescription(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where TX_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoDemo(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where BO_DEMO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkSubSectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set FK_SUB_SECTION_IDX=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInCheck_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set IN_CHECK=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set TX_TITLE=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDescription_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set TX_DESCRIPTION=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set IN_WEIGHT=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set IN_ORDER=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoDemo_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set BO_DEMO=? where PK_QUESTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkQuestionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET PK_QUESTION_IDX=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkSubSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET FK_SUB_SECTION_IDX=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInCheck_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET IN_CHECK=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET TX_TITLE=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDescription_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET TX_DESCRIPTION=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET IN_WEIGHT=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET IN_ORDER=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoDemo_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION SET BO_DEMO=? where PK_QUESTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

