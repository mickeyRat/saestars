package SAE::TB_ASSESSMENT_REQ;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkAssessmentReqIdx;
my $FkAssessmentOptIdx;
my $TxTitle;
my $TxDetail;
my $InWeight;
my $InOrder;
my $BoCheck;
my $TxInputType;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_ASSESSMENT_REQ (FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkAssessmentOptIdx, $TxTitle, $TxDetail, $InWeight, $InOrder, $BoCheck, $TxInputType);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE
		FROM TB_ASSESSMENT_REQ
		WHERE PK_ASSESSMENT_REQ_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkAssessmentReqIdx 		 = 	$HASH{PK_ASSESSMENT_REQ_IDX};
	$FkAssessmentOptIdx 		 = 	$HASH{FK_ASSESSMENT_OPT_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxDetail 		 = 	$HASH{TX_DETAIL};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InOrder 		 = 	$HASH{IN_ORDER};
	$BoCheck 		 = 	$HASH{BO_CHECK};
	$TxInputType 		 = 	$HASH{TX_INPUT_TYPE};
	return $self;

;}
sub getAllRecordBy_PkAssessmentReqIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE PK_ASSESSMENT_REQ_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkAssessmentOptIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE FK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoCheck(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE BO_CHECK=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxInputType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ WHERE TX_INPUT_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ASSESSMENT_REQ_IDX, FK_ASSESSMENT_OPT_IDX, TX_TITLE, TX_DETAIL, IN_WEIGHT, IN_ORDER, BO_CHECK, TX_INPUT_TYPE FROM TB_ASSESSMENT_REQ";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_ASSESSMENT_REQ_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ASSESSMENT_REQ where PK_ASSESSMENT_REQ_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkAssessmentReqIdx(){
	my ( $self ) = shift;
	return ($PkAssessmentReqIdx);
}

sub getFkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($FkAssessmentOptIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($TxDetail);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}

sub getBoCheck(){
	my ( $self ) = shift;
	return ($BoCheck);
}

sub getTxInputType(){
	my ( $self ) = shift;
	return ($TxInputType);
}


#------- BUILDING SETTERS------

sub setPkAssessmentReqIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkAssessmentReqIdx = $value;
	return ($field);
}

sub setFkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkAssessmentOptIdx = $value;
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

sub setBoCheck(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoCheck = $value;
	return ($field);
}

sub setTxInputType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxInputType = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkAssessmentOptIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where FK_ASSESSMENT_OPT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoCheck(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where BO_CHECK=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxInputType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_REQ_IDX from TB_ASSESSMENT_REQ where TX_INPUT_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkAssessmentOptIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set FK_ASSESSMENT_OPT_IDX=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set TX_TITLE=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set TX_DETAIL=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set IN_WEIGHT=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set IN_ORDER=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoCheck_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set BO_CHECK=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxInputType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ set TX_INPUT_TYPE=? where PK_ASSESSMENT_REQ_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkAssessmentReqIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET PK_ASSESSMENT_REQ_IDX=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkAssessmentOptIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET FK_ASSESSMENT_OPT_IDX=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET TX_TITLE=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDetail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET TX_DETAIL=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET IN_WEIGHT=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET IN_ORDER=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoCheck_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET BO_CHECK=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxInputType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_REQ SET TX_INPUT_TYPE=? where PK_ASSESSMENT_REQ_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

