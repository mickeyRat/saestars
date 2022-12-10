package SAE::TB_SCORE_SECTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreSectionIdx;
my $FkScoreGroupIdx;
my $InWeight;
my $TxScoreSection;
my $TxScoreDetail;
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

	my $SQL = "INSERT INTO TB_SCORE_SECTION (FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkScoreGroupIdx, $InWeight, $TxScoreSection, $TxScoreDetail, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER
		FROM TB_SCORE_SECTION
		WHERE PK_SCORE_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreSectionIdx 		 = 	$HASH{PK_SCORE_SECTION_IDX};
	$FkScoreGroupIdx 		 = 	$HASH{FK_SCORE_GROUP_IDX};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$TxScoreSection 		 = 	$HASH{TX_SCORE_SECTION};
	$TxScoreDetail 		 = 	$HASH{TX_SCORE_DETAIL};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkScoreSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION WHERE PK_SCORE_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION WHERE FK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxScoreSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION WHERE TX_SCORE_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxScoreDetail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION WHERE TX_SCORE_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_SECTION_IDX, FK_SCORE_GROUP_IDX, IN_WEIGHT, TX_SCORE_SECTION, TX_SCORE_DETAIL, IN_ORDER FROM TB_SCORE_SECTION";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_SECTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where PK_SCORE_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkScoreSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where PK_SCORE_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where FK_SCORE_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxScoreSection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where TX_SCORE_SECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxScoreDetail(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where TX_SCORE_DETAIL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_SECTION where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkScoreSectionIdx(){
	my ( $self ) = shift;
	return ($PkScoreSectionIdx);
}

sub getFkScoreGroupIdx(){
	my ( $self ) = shift;
	return ($FkScoreGroupIdx);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getTxScoreSection(){
	my ( $self ) = shift;
	return ($TxScoreSection);
}

sub getTxScoreDetail(){
	my ( $self ) = shift;
	return ($TxScoreDetail);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkScoreSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreSectionIdx = $value;
	return ($field);
}

sub setFkScoreGroupIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreGroupIdx = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}

sub setTxScoreSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxScoreSection = $value;
	return ($field);
}

sub setTxScoreDetail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxScoreDetail = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_SECTION_IDX from TB_SCORE_SECTION where FK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_SECTION_IDX from TB_SCORE_SECTION where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxScoreSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_SECTION_IDX from TB_SCORE_SECTION where TX_SCORE_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxScoreDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_SECTION_IDX from TB_SCORE_SECTION where TX_SCORE_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_SECTION_IDX from TB_SCORE_SECTION where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkScoreGroupIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION set FK_SCORE_GROUP_IDX=? where PK_SCORE_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION set IN_WEIGHT=? where PK_SCORE_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxScoreSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION set TX_SCORE_SECTION=? where PK_SCORE_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxScoreDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION set TX_SCORE_DETAIL=? where PK_SCORE_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION set IN_ORDER=? where PK_SCORE_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkScoreSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION SET PK_SCORE_SECTION_IDX=? where PK_SCORE_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION SET FK_SCORE_GROUP_IDX=? where PK_SCORE_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION SET IN_WEIGHT=? where PK_SCORE_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxScoreSection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION SET TX_SCORE_SECTION=? where PK_SCORE_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxScoreDetail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION SET TX_SCORE_DETAIL=? where PK_SCORE_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_SECTION SET IN_ORDER=? where PK_SCORE_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

