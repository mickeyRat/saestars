package SAE::TB_ASSESSMENT_OPT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkAssessmentOptIdx;
my $FkAssessmentTypeIdx;
my $TxCategory;
my $TxTitle;
my $TxDetail;
my $InMax;
my $InWeight;
my $InOrder;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_ASSESSMENT_OPT (FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkAssessmentTypeIdx, $TxCategory, $TxTitle, $TxDetail, $InMax, $InWeight, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER
		FROM TB_ASSESSMENT_OPT
		WHERE PK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkAssessmentOptIdx 		 = 	$HASH{PK_ASSESSMENT_OPT_IDX};
	$FkAssessmentTypeIdx 		 = 	$HASH{FK_ASSESSMENT_TYPE_IDX};
	$TxCategory 		 = 	$HASH{TX_CATEGORY};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxDetail 		 = 	$HASH{TX_DETAIL};
	$InMax 		 = 	$HASH{IN_MAX};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkAssessmentOptIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE PK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkAssessmentTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE FK_ASSESSMENT_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_OPT_IDX, FK_ASSESSMENT_TYPE_IDX, TX_CATEGORY, TX_TITLE, TX_DETAIL, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_ASSESSMENT_OPT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_OPT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where PK_ASSESSMENT_OPT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkAssessmentOptIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where PK_ASSESSMENT_OPT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkAssessmentTypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where FK_ASSESSMENT_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxCategory(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where TX_CATEGORY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxDetail(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where TX_DETAIL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMax(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where IN_MAX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_OPT where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($PkAssessmentOptIdx);
}

sub getFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentTypeIdx);
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($TxCategory);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($TxDetail);
}

sub getInMax(){
	my ( $self ) = shift;
	return ($InMax);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkAssessmentOptIdx = $value;
	return ($field);
}

sub setFkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentTypeIdx = $value;
	return ($field);
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCategory = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setTxDetail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxDetail = $value;
	return ($field);
}

sub setInMax(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMax = $value;
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




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkAssessmentTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where FK_ASSESSMENT_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_OPT_IDX from TB_ASSESSMENT_OPT where IN_ORDER=?";
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

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set FK_ASSESSMENT_TYPE_IDX=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxCategory_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set TX_CATEGORY=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set TX_TITLE=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set TX_DETAIL=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set IN_MAX=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set IN_WEIGHT=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT set IN_ORDER=? where PK_ASSESSMENT_OPT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkAssessmentOptIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET PK_ASSESSMENT_OPT_IDX=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkAssessmentTypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET FK_ASSESSMENT_TYPE_IDX=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxCategory_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET TX_CATEGORY=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET TX_TITLE=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDetail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET TX_DETAIL=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET IN_MAX=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET IN_WEIGHT=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_OPT SET IN_ORDER=? where PK_ASSESSMENT_OPT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

