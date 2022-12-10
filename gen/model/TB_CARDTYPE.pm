package SAE::TB_CARDTYPE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCardtypeIdx;
my $TxTitle;
my $InPoints;
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

	my $SQL = "INSERT INTO TB_CARDTYPE (TX_TITLE, IN_POINTS, IN_ORDER) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxTitle, $InPoints, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CARDTYPE_IDX, TX_TITLE, IN_POINTS, IN_ORDER
		FROM TB_CARDTYPE
		WHERE PK_CARDTYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCardtypeIdx 		 = 	$HASH{PK_CARDTYPE_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$InPoints 		 = 	$HASH{IN_POINTS};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkCardtypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARDTYPE_IDX, TX_TITLE, IN_POINTS, IN_ORDER FROM TB_CARDTYPE WHERE PK_CARDTYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARDTYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARDTYPE_IDX, TX_TITLE, IN_POINTS, IN_ORDER FROM TB_CARDTYPE WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARDTYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPoints(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARDTYPE_IDX, TX_TITLE, IN_POINTS, IN_ORDER FROM TB_CARDTYPE WHERE IN_POINTS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARDTYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARDTYPE_IDX, TX_TITLE, IN_POINTS, IN_ORDER FROM TB_CARDTYPE WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARDTYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARDTYPE_IDX, TX_TITLE, IN_POINTS, IN_ORDER FROM TB_CARDTYPE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_CARDTYPE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARDTYPE where PK_CARDTYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkCardtypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARDTYPE where PK_CARDTYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARDTYPE where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPoints(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARDTYPE where IN_POINTS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARDTYPE where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkCardtypeIdx(){
	my ( $self ) = shift;
	return ($PkCardtypeIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getInPoints(){
	my ( $self ) = shift;
	return ($InPoints);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkCardtypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCardtypeIdx = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setInPoints(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPoints = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARDTYPE_IDX from TB_CARDTYPE where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPoints(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARDTYPE_IDX from TB_CARDTYPE where IN_POINTS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARDTYPE_IDX from TB_CARDTYPE where IN_ORDER=?";
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

	my $SQL = "UPDATE TB_CARDTYPE set TX_TITLE=? where PK_CARDTYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPoints_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARDTYPE set IN_POINTS=? where PK_CARDTYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARDTYPE set IN_ORDER=? where PK_CARDTYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCardtypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARDTYPE SET PK_CARDTYPE_IDX=? where PK_CARDTYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARDTYPE SET TX_TITLE=? where PK_CARDTYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPoints_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARDTYPE SET IN_POINTS=? where PK_CARDTYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARDTYPE SET IN_ORDER=? where PK_CARDTYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

