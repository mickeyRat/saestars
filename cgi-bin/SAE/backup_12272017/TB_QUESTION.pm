package SAE::TB_QUESTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkQuestionIdx;
my $TxTitle;
my $TxDescription;
my $InParent;
my $InWeight;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_QUESTION (TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT) values (?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxTitle, $TxDescription, $InParent, $InWeight);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT
		FROM TB_QUESTION
		WHERE PK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkQuestionIdx 		 = 	$HASH{PK_QUESTION_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxDescription 		 = 	$HASH{TX_DESCRIPTION};
	$InParent 		 = 	$HASH{IN_PARENT};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	return $self;

;}
sub getAllRecordBy_PkQuestionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT FROM TB_QUESTION WHERE PK_QUESTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT FROM TB_QUESTION WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT FROM TB_QUESTION WHERE TX_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InParent(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT FROM TB_QUESTION WHERE IN_PARENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_QUESTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_QUESTION_IDX, TX_TITLE, TX_DESCRIPTION, IN_PARENT, IN_WEIGHT FROM TB_QUESTION WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
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

sub getPkQuestionIdx(){
	my ( $self ) = shift;
	return ($PkQuestionIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxDescription(){
	my ( $self ) = shift;
	return ($TxDescription);
}

sub getInParent(){
	my ( $self ) = shift;
	return ($InParent);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}


#------- BUILDING SETTERS------

sub setPkQuestionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkQuestionIdx = $value;
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

sub setInParent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InParent = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

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
sub getIdBy_InParent(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_QUESTION_IDX from TB_QUESTION where IN_PARENT=?";
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

#------- BUILDING update field by ID------

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
sub updateInParent_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_QUESTION set IN_PARENT=? where PK_QUESTION_IDX=?";
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
return (1);

