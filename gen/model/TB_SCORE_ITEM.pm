package SAE::TB_SCORE_ITEM;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreItemIdx;
my $FkScoreSectionIdx;
my $TxScoreItem;
my $TxDetail;
my $InPercent;
my $BoBinary;
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

	my $SQL = "INSERT INTO TB_SCORE_ITEM (FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER) values (?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkScoreSectionIdx, $TxScoreItem, $TxDetail, $InPercent, $BoBinary, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER
		FROM TB_SCORE_ITEM
		WHERE PK_SCORE_ITEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreItemIdx 		 = 	$HASH{PK_SCORE_ITEM_IDX};
	$FkScoreSectionIdx 		 = 	$HASH{FK_SCORE_SECTION_IDX};
	$TxScoreItem 		 = 	$HASH{TX_SCORE_ITEM};
	$TxDetail 		 = 	$HASH{TX_DETAIL};
	$InPercent 		 = 	$HASH{IN_PERCENT};
	$BoBinary 		 = 	$HASH{BO_BINARY};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkScoreItemIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE PK_SCORE_ITEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE FK_SCORE_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxScoreItem(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE TX_SCORE_ITEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPercent(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE IN_PERCENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoBinary(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE BO_BINARY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_ITEM_IDX, FK_SCORE_SECTION_IDX, TX_SCORE_ITEM, TX_DETAIL, IN_PERCENT, BO_BINARY, IN_ORDER FROM TB_SCORE_ITEM";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_ITEM_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where PK_SCORE_ITEM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkScoreItemIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where PK_SCORE_ITEM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where FK_SCORE_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxScoreItem(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where TX_SCORE_ITEM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxDetail(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where TX_DETAIL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPercent(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where IN_PERCENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoBinary(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where BO_BINARY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_ITEM where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkScoreItemIdx(){
	my ( $self ) = shift;
	return ($PkScoreItemIdx);
}

sub getFkScoreSectionIdx(){
	my ( $self ) = shift;
	return ($FkScoreSectionIdx);
}

sub getTxScoreItem(){
	my ( $self ) = shift;
	return ($TxScoreItem);
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($TxDetail);
}

sub getInPercent(){
	my ( $self ) = shift;
	return ($InPercent);
}

sub getBoBinary(){
	my ( $self ) = shift;
	return ($BoBinary);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkScoreItemIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreItemIdx = $value;
	return ($field);
}

sub setFkScoreSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreSectionIdx = $value;
	return ($field);
}

sub setTxScoreItem(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxScoreItem = $value;
	return ($field);
}

sub setTxDetail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxDetail = $value;
	return ($field);
}

sub setInPercent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPercent = $value;
	return ($field);
}

sub setBoBinary(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoBinary = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkScoreSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_ITEM_IDX from TB_SCORE_ITEM where FK_SCORE_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxScoreItem(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_ITEM_IDX from TB_SCORE_ITEM where TX_SCORE_ITEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_ITEM_IDX from TB_SCORE_ITEM where TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPercent(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_ITEM_IDX from TB_SCORE_ITEM where IN_PERCENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoBinary(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_ITEM_IDX from TB_SCORE_ITEM where BO_BINARY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_ITEM_IDX from TB_SCORE_ITEM where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkScoreSectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM set FK_SCORE_SECTION_IDX=? where PK_SCORE_ITEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxScoreItem_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM set TX_SCORE_ITEM=? where PK_SCORE_ITEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM set TX_DETAIL=? where PK_SCORE_ITEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPercent_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM set IN_PERCENT=? where PK_SCORE_ITEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoBinary_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM set BO_BINARY=? where PK_SCORE_ITEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM set IN_ORDER=? where PK_SCORE_ITEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkScoreItemIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET PK_SCORE_ITEM_IDX=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET FK_SCORE_SECTION_IDX=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxScoreItem_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET TX_SCORE_ITEM=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDetail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET TX_DETAIL=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPercent_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET IN_PERCENT=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoBinary_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET BO_BINARY=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_ITEM SET IN_ORDER=? where PK_SCORE_ITEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

