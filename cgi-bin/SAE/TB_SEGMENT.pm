package SAE::TB_SEGMENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkSegmentIdx;
my $InSegmentRef;
my $TxName;
my $TxDetail;
my $InMax;
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

	my $SQL = "INSERT INTO TB_SEGMENT (IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($InSegmentRef, $TxName, $TxDetail, $InMax, $InWeight);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT
		FROM TB_SEGMENT
		WHERE PK_SEGMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkSegmentIdx 		 = 	$HASH{PK_SEGMENT_IDX};
	$InSegmentRef 		 = 	$HASH{IN_SEGMENT_REF};
	$TxName 		 = 	$HASH{TX_NAME};
	$TxDetail 		 = 	$HASH{TX_DETAIL};
	$InMax 		 = 	$HASH{IN_MAX};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	return $self;

;}
sub getAllRecordBy_PkSegmentIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT WHERE PK_SEGMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSegmentRef(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT WHERE IN_SEGMENT_REF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxName(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT WHERE TX_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT WHERE TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SEGMENT_IDX, IN_SEGMENT_REF, TX_NAME, TX_DETAIL, IN_MAX, IN_WEIGHT FROM TB_SEGMENT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SEGMENT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where PK_SEGMENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkSegmentIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where PK_SEGMENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSegmentRef(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where IN_SEGMENT_REF=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxName(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where TX_NAME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxDetail(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where TX_DETAIL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMax(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where IN_MAX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SEGMENT where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkSegmentIdx(){
	my ( $self ) = shift;
	return ($PkSegmentIdx);
}

sub getInSegmentRef(){
	my ( $self ) = shift;
	return ($InSegmentRef);
}

sub getTxName(){
	my ( $self ) = shift;
	return ($TxName);
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


#------- BUILDING SETTERS------

sub setPkSegmentIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkSegmentIdx = $value;
	return ($field);
}

sub setInSegmentRef(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSegmentRef = $value;
	return ($field);
}

sub setTxName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxName = $value;
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




#------- BUILDING Getting ID by field Name------

sub getIdBy_InSegmentRef(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SEGMENT_IDX from TB_SEGMENT where IN_SEGMENT_REF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxName(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SEGMENT_IDX from TB_SEGMENT where TX_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SEGMENT_IDX from TB_SEGMENT where TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SEGMENT_IDX from TB_SEGMENT where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SEGMENT_IDX from TB_SEGMENT where IN_WEIGHT=?";
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

	my $SQL = "UPDATE TB_SEGMENT set IN_SEGMENT_REF=? where PK_SEGMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxName_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT set TX_NAME=? where PK_SEGMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT set TX_DETAIL=? where PK_SEGMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT set IN_MAX=? where PK_SEGMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT set IN_WEIGHT=? where PK_SEGMENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkSegmentIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT SET PK_SEGMENT_IDX=? where PK_SEGMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSegmentRef_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT SET IN_SEGMENT_REF=? where PK_SEGMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxName_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT SET TX_NAME=? where PK_SEGMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDetail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT SET TX_DETAIL=? where PK_SEGMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT SET IN_MAX=? where PK_SEGMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SEGMENT SET IN_WEIGHT=? where PK_SEGMENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

