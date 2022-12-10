package SAE::TB_SECTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkSectionIdx;
my $FkCardtypeIdx;
my $InSection;
my $TxSection;
my $InWeight;
my $InClass;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SECTION (FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkCardtypeIdx, $InSection, $TxSection, $InWeight, $InClass);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS
		FROM TB_SECTION
		WHERE PK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkSectionIdx 		 = 	$HASH{PK_SECTION_IDX};
	$FkCardtypeIdx 		 = 	$HASH{FK_CARDTYPE_IDX};
	$InSection 		 = 	$HASH{IN_SECTION};
	$TxSection 		 = 	$HASH{TX_SECTION};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InClass 		 = 	$HASH{IN_CLASS};
	return $self;

;}
sub getAllRecordBy_PkSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION WHERE PK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkCardtypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION WHERE FK_CARDTYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION WHERE IN_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION WHERE TX_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InClass(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION WHERE IN_CLASS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, FK_CARDTYPE_IDX, IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS FROM TB_SECTION";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where PK_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where PK_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkCardtypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where FK_CARDTYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where IN_SECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxSection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where TX_SECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InClass(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION where IN_CLASS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkSectionIdx(){
	my ( $self ) = shift;
	return ($PkSectionIdx);
}

sub getFkCardtypeIdx(){
	my ( $self ) = shift;
	return ($FkCardtypeIdx);
}

sub getInSection(){
	my ( $self ) = shift;
	return ($InSection);
}

sub getTxSection(){
	my ( $self ) = shift;
	return ($TxSection);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getInClass(){
	my ( $self ) = shift;
	return ($InClass);
}


#------- BUILDING SETTERS------

sub setPkSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkSectionIdx = $value;
	return ($field);
}

sub setFkCardtypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkCardtypeIdx = $value;
	return ($field);
}

sub setInSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSection = $value;
	return ($field);
}

sub setTxSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSection = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}

sub setInClass(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InClass = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkCardtypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION where FK_CARDTYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION where IN_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION where TX_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InClass(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION where IN_CLASS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkCardtypeIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION set FK_CARDTYPE_IDX=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION set IN_SECTION=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION set TX_SECTION=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION set IN_WEIGHT=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInClass_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION set IN_CLASS=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION SET PK_SECTION_IDX=? where PK_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkCardtypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION SET FK_CARDTYPE_IDX=? where PK_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION SET IN_SECTION=? where PK_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION SET TX_SECTION=? where PK_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION SET IN_WEIGHT=? where PK_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInClass_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION SET IN_CLASS=? where PK_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

