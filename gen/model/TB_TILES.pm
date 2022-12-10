package SAE::TB_TILES;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTilesIdx;
my $InType;
my $TxTitle;
my $TxIcon;
my $InOrder;
my $BoNew;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TILES (IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($InType, $TxTitle, $TxIcon, $InOrder, $BoNew);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW
		FROM TB_TILES
		WHERE PK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTilesIdx 		 = 	$HASH{PK_TILES_IDX};
	$InType 		 = 	$HASH{IN_TYPE};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxIcon 		 = 	$HASH{TX_ICON};
	$InOrder 		 = 	$HASH{IN_ORDER};
	$BoNew 		 = 	$HASH{BO_NEW};
	return $self;

;}
sub getAllRecordBy_PkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES WHERE PK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES WHERE IN_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxIcon(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES WHERE TX_ICON=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoNew(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES WHERE BO_NEW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TILES_IDX, IN_TYPE, TX_TITLE, TX_ICON, IN_ORDER, BO_NEW FROM TB_TILES";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where PK_TILES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTilesIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where PK_TILES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where IN_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxIcon(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where TX_ICON=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoNew(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TILES where BO_NEW=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTilesIdx(){
	my ( $self ) = shift;
	return ($PkTilesIdx);
}

sub getInType(){
	my ( $self ) = shift;
	return ($InType);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxIcon(){
	my ( $self ) = shift;
	return ($TxIcon);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}

sub getBoNew(){
	my ( $self ) = shift;
	return ($BoNew);
}


#------- BUILDING SETTERS------

sub setPkTilesIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTilesIdx = $value;
	return ($field);
}

sub setInType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InType = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setTxIcon(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxIcon = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}

sub setBoNew(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoNew = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_InType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TILES_IDX from TB_TILES where IN_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TILES_IDX from TB_TILES where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxIcon(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TILES_IDX from TB_TILES where TX_ICON=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TILES_IDX from TB_TILES where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoNew(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TILES_IDX from TB_TILES where BO_NEW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateInType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES set IN_TYPE=? where PK_TILES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES set TX_TITLE=? where PK_TILES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxIcon_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES set TX_ICON=? where PK_TILES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES set IN_ORDER=? where PK_TILES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoNew_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES set BO_NEW=? where PK_TILES_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTilesIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES SET PK_TILES_IDX=? where PK_TILES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES SET IN_TYPE=? where PK_TILES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES SET TX_TITLE=? where PK_TILES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxIcon_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES SET TX_ICON=? where PK_TILES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES SET IN_ORDER=? where PK_TILES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoNew_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TILES SET BO_NEW=? where PK_TILES_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

