package SAE::TB_SUB_SECTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkSubSectionIdx;
my $FkSectionIdx;
my $TxSubSection;
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

	my $SQL = "INSERT INTO TB_SUB_SECTION (FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkSectionIdx, $TxSubSection, $InWeight);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SUB_SECTION_IDX, FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT
		FROM TB_SUB_SECTION
		WHERE PK_SUB_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkSubSectionIdx 		 = 	$HASH{PK_SUB_SECTION_IDX};
	$FkSectionIdx 		 = 	$HASH{FK_SECTION_IDX};
	$TxSubSection 		 = 	$HASH{TX_SUB_SECTION};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	return $self;

;}
sub getAllRecordBy_PkSubSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUB_SECTION_IDX, FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT FROM TB_SUB_SECTION WHERE PK_SUB_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUB_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUB_SECTION_IDX, FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT FROM TB_SUB_SECTION WHERE FK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUB_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSubSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUB_SECTION_IDX, FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT FROM TB_SUB_SECTION WHERE TX_SUB_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUB_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUB_SECTION_IDX, FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT FROM TB_SUB_SECTION WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUB_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUB_SECTION_IDX, FK_SECTION_IDX, TX_SUB_SECTION, IN_WEIGHT FROM TB_SUB_SECTION";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SUB_SECTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUB_SECTION where PK_SUB_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkSubSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUB_SECTION where PK_SUB_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUB_SECTION where FK_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxSubSection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUB_SECTION where TX_SUB_SECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUB_SECTION where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkSubSectionIdx(){
	my ( $self ) = shift;
	return ($PkSubSectionIdx);
}

sub getFkSectionIdx(){
	my ( $self ) = shift;
	return ($FkSectionIdx);
}

sub getTxSubSection(){
	my ( $self ) = shift;
	return ($TxSubSection);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}


#------- BUILDING SETTERS------

sub setPkSubSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkSubSectionIdx = $value;
	return ($field);
}

sub setFkSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkSectionIdx = $value;
	return ($field);
}

sub setTxSubSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSubSection = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUB_SECTION_IDX from TB_SUB_SECTION where FK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSubSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUB_SECTION_IDX from TB_SUB_SECTION where TX_SUB_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUB_SECTION_IDX from TB_SUB_SECTION where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkSectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION set FK_SECTION_IDX=? where PK_SUB_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSubSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION set TX_SUB_SECTION=? where PK_SUB_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION set IN_WEIGHT=? where PK_SUB_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkSubSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION SET PK_SUB_SECTION_IDX=? where PK_SUB_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION SET FK_SECTION_IDX=? where PK_SUB_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSubSection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION SET TX_SUB_SECTION=? where PK_SUB_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUB_SECTION SET IN_WEIGHT=? where PK_SUB_SECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

