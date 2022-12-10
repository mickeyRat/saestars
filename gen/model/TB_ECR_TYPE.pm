package SAE::TB_ECR_TYPE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkEcrTypeIdx;
my $TxField;
my $TxType;
my $InSmall;
my $InMedium;
my $InLarge;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_ECR_TYPE (TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxField, $TxType, $InSmall, $InMedium, $InLarge);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE
		FROM TB_ECR_TYPE
		WHERE PK_ECR_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkEcrTypeIdx 		 = 	$HASH{PK_ECR_TYPE_IDX};
	$TxField 		 = 	$HASH{TX_FIELD};
	$TxType 		 = 	$HASH{TX_TYPE};
	$InSmall 		 = 	$HASH{IN_SMALL};
	$InMedium 		 = 	$HASH{IN_MEDIUM};
	$InLarge 		 = 	$HASH{IN_LARGE};
	return $self;

;}
sub getAllRecordBy_PkEcrTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE WHERE PK_ECR_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxField(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE WHERE TX_FIELD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE WHERE TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSmall(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE WHERE IN_SMALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMedium(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE WHERE IN_MEDIUM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLarge(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE WHERE IN_LARGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_TYPE_IDX, TX_FIELD, TX_TYPE, IN_SMALL, IN_MEDIUM, IN_LARGE FROM TB_ECR_TYPE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_TYPE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where PK_ECR_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkEcrTypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where PK_ECR_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxField(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where TX_FIELD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where TX_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSmall(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where IN_SMALL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMedium(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where IN_MEDIUM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLarge(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR_TYPE where IN_LARGE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkEcrTypeIdx(){
	my ( $self ) = shift;
	return ($PkEcrTypeIdx);
}

sub getTxField(){
	my ( $self ) = shift;
	return ($TxField);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getInSmall(){
	my ( $self ) = shift;
	return ($InSmall);
}

sub getInMedium(){
	my ( $self ) = shift;
	return ($InMedium);
}

sub getInLarge(){
	my ( $self ) = shift;
	return ($InLarge);
}


#------- BUILDING SETTERS------

sub setPkEcrTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkEcrTypeIdx = $value;
	return ($field);
}

sub setTxField(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxField = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setInSmall(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSmall = $value;
	return ($field);
}

sub setInMedium(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMedium = $value;
	return ($field);
}

sub setInLarge(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLarge = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxField(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_TYPE_IDX from TB_ECR_TYPE where TX_FIELD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_TYPE_IDX from TB_ECR_TYPE where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSmall(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_TYPE_IDX from TB_ECR_TYPE where IN_SMALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMedium(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_TYPE_IDX from TB_ECR_TYPE where IN_MEDIUM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLarge(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_TYPE_IDX from TB_ECR_TYPE where IN_LARGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxField_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE set TX_FIELD=? where PK_ECR_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE set TX_TYPE=? where PK_ECR_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSmall_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE set IN_SMALL=? where PK_ECR_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMedium_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE set IN_MEDIUM=? where PK_ECR_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLarge_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE set IN_LARGE=? where PK_ECR_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkEcrTypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE SET PK_ECR_TYPE_IDX=? where PK_ECR_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxField_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE SET TX_FIELD=? where PK_ECR_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE SET TX_TYPE=? where PK_ECR_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSmall_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE SET IN_SMALL=? where PK_ECR_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMedium_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE SET IN_MEDIUM=? where PK_ECR_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLarge_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR_TYPE SET IN_LARGE=? where PK_ECR_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

