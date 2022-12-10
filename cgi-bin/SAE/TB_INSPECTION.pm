package SAE::TB_INSPECTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkInspectionIdx;
my $TxItem;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_INSPECTION (TX_ITEM) values (?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxItem);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_INSPECTION_IDX, TX_ITEM
		FROM TB_INSPECTION
		WHERE PK_INSPECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkInspectionIdx 		 = 	$HASH{PK_INSPECTION_IDX};
	$TxItem 		 = 	$HASH{TX_ITEM};
	return $self;

;}
sub getAllRecordBy_PkInspectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_INSPECTION_IDX, TX_ITEM FROM TB_INSPECTION WHERE PK_INSPECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_INSPECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxItem(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_INSPECTION_IDX, TX_ITEM FROM TB_INSPECTION WHERE TX_ITEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_INSPECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_INSPECTION_IDX, TX_ITEM FROM TB_INSPECTION";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_INSPECTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_INSPECTION where PK_INSPECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkInspectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_INSPECTION where PK_INSPECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxItem(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_INSPECTION where TX_ITEM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkInspectionIdx(){
	my ( $self ) = shift;
	return ($PkInspectionIdx);
}

sub getTxItem(){
	my ( $self ) = shift;
	return ($TxItem);
}


#------- BUILDING SETTERS------

sub setPkInspectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkInspectionIdx = $value;
	return ($field);
}

sub setTxItem(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxItem = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxItem(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_INSPECTION_IDX from TB_INSPECTION where TX_ITEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxItem_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_INSPECTION set TX_ITEM=? where PK_INSPECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkInspectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_INSPECTION SET PK_INSPECTION_IDX=? where PK_INSPECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxItem_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_INSPECTION SET TX_ITEM=? where PK_INSPECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

