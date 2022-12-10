package SAE::TB_RUBRIC;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkRubricIdx;
my $BoParent;
my $InSection;
my $TxTitle;
my $ClDescription;
my $FkRubricIdx;
my $FkClassIdx;
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

	my $SQL = "INSERT INTO TB_RUBRIC (BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($BoParent, $InSection, $TxTitle, $ClDescription, $FkRubricIdx, $FkClassIdx, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER
		FROM TB_RUBRIC
		WHERE PK_RUBRIC_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkRubricIdx 		 = 	$HASH{PK_RUBRIC_IDX};
	$BoParent 		 = 	$HASH{BO_PARENT};
	$InSection 		 = 	$HASH{IN_SECTION};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$ClDescription 		 = 	$HASH{CL_DESCRIPTION};
	$FkRubricIdx 		 = 	$HASH{FK_RUBRIC_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkRubricIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE PK_RUBRIC_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoParent(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE BO_PARENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE IN_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkRubricIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE FK_RUBRIC_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_RUBRIC_IDX, BO_PARENT, IN_SECTION, TX_TITLE, CL_DESCRIPTION, FK_RUBRIC_IDX, FK_CLASS_IDX, IN_ORDER FROM TB_RUBRIC";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_RUBRIC_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where PK_RUBRIC_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkRubricIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where PK_RUBRIC_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoParent(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where BO_PARENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where IN_SECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClDescription(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where CL_DESCRIPTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkRubricIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where FK_RUBRIC_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where FK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_RUBRIC where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkRubricIdx(){
	my ( $self ) = shift;
	return ($PkRubricIdx);
}

sub getBoParent(){
	my ( $self ) = shift;
	return ($BoParent);
}

sub getInSection(){
	my ( $self ) = shift;
	return ($InSection);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getClDescription(){
	my ( $self ) = shift;
	return ($ClDescription);
}

sub getFkRubricIdx(){
	my ( $self ) = shift;
	return ($FkRubricIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkRubricIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkRubricIdx = $value;
	return ($field);
}

sub setBoParent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoParent = $value;
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

sub setClDescription(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClDescription = $value;
	return ($field);
}

sub setFkRubricIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkRubricIdx = $value;
	return ($field);
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkClassIdx = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_BoParent(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where BO_PARENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where IN_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkRubricIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where FK_RUBRIC_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_RUBRIC_IDX from TB_RUBRIC where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateBoParent_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set BO_PARENT=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set IN_SECTION=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set TX_TITLE=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClDescription_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set CL_DESCRIPTION=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkRubricIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set FK_RUBRIC_IDX=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkClassIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set FK_CLASS_IDX=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC set IN_ORDER=? where PK_RUBRIC_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkRubricIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET PK_RUBRIC_IDX=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoParent_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET BO_PARENT=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET IN_SECTION=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET TX_TITLE=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClDescription_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET CL_DESCRIPTION=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkRubricIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET FK_RUBRIC_IDX=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkClassIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET FK_CLASS_IDX=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_RUBRIC SET IN_ORDER=? where PK_RUBRIC_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

