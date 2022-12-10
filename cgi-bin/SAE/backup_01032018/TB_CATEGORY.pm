package SAE::TB_CATEGORY;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCategoryIdx;
my $InSegmentRef;
my $InSection;
my $TxTitle;
my $TxDetail;
my $InMin;
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

	my $SQL = "INSERT INTO TB_CATEGORY (IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER) values (?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($InSegmentRef, $InSection, $TxTitle, $TxDetail, $InMin, $InMax, $InWeight, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER
		FROM TB_CATEGORY
		WHERE PK_CATEGORY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCategoryIdx 		 = 	$HASH{PK_CATEGORY_IDX};
	$InSegmentRef 		 = 	$HASH{IN_SEGMENT_REF};
	$InSection 		 = 	$HASH{IN_SECTION};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxDetail 		 = 	$HASH{TX_DETAIL};
	$InMin 		 = 	$HASH{IN_MIN};
	$InMax 		 = 	$HASH{IN_MAX};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkCategoryIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE PK_CATEGORY_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSegmentRef(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE IN_SEGMENT_REF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE IN_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMin(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE IN_MIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CATEGORY_IDX, IN_SEGMENT_REF, IN_SECTION, TX_TITLE, TX_DETAIL, IN_MIN, IN_MAX, IN_WEIGHT, IN_ORDER FROM TB_CATEGORY";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_CATEGORY_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CATEGORY where PK_CATEGORY_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkCategoryIdx(){
	my ( $self ) = shift;
	return ($PkCategoryIdx);
}

sub getInSegmentRef(){
	my ( $self ) = shift;
	return ($InSegmentRef);
}

sub getInSection(){
	my ( $self ) = shift;
	return ($InSection);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($TxDetail);
}

sub getInMin(){
	my ( $self ) = shift;
	return ($InMin);
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

sub setPkCategoryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCategoryIdx = $value;
	return ($field);
}

sub setInSegmentRef(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSegmentRef = $value;
	return ($field);
}

sub setInSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSection = $value;
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

sub setInMin(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMin = $value;
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

sub getIdBy_InSegmentRef(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where IN_SEGMENT_REF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where IN_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMin(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where IN_MIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CATEGORY_IDX from TB_CATEGORY where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateInSegmentRef_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set IN_SEGMENT_REF=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set IN_SECTION=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set TX_TITLE=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set TX_DETAIL=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMin_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set IN_MIN=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set IN_MAX=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set IN_WEIGHT=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY set IN_ORDER=? where PK_CATEGORY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCategoryIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET PK_CATEGORY_IDX=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSegmentRef_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET IN_SEGMENT_REF=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET IN_SECTION=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET TX_TITLE=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDetail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET TX_DETAIL=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMin_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET IN_MIN=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET IN_MAX=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET IN_WEIGHT=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CATEGORY SET IN_ORDER=? where PK_CATEGORY_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

