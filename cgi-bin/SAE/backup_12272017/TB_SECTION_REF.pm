package SAE::TB_SECTION_REF;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkSectionIdx;
my $InSectionRef;
my $TxSection;
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

	my $SQL = "INSERT INTO TB_SECTION_REF (IN_SECTION_REF, TX_SECTION, IN_WEIGHT) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($InSectionRef, $TxSection, $InWeight);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SECTION_IDX, IN_SECTION_REF, TX_SECTION, IN_WEIGHT
		FROM TB_SECTION_REF
		WHERE PK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkSectionIdx 		 = 	$HASH{PK_SECTION_IDX};
	$InSectionRef 		 = 	$HASH{IN_SECTION_REF};
	$TxSection 		 = 	$HASH{TX_SECTION};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	return $self;

;}
sub getAllRecordBy_PkSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, IN_SECTION_REF, TX_SECTION, IN_WEIGHT FROM TB_SECTION_REF WHERE PK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSectionRef(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, IN_SECTION_REF, TX_SECTION, IN_WEIGHT FROM TB_SECTION_REF WHERE IN_SECTION_REF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, IN_SECTION_REF, TX_SECTION, IN_WEIGHT FROM TB_SECTION_REF WHERE TX_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SECTION_IDX, IN_SECTION_REF, TX_SECTION, IN_WEIGHT FROM TB_SECTION_REF WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SECTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SECTION_REF where PK_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkSectionIdx(){
	my ( $self ) = shift;
	return ($PkSectionIdx);
}

sub getInSectionRef(){
	my ( $self ) = shift;
	return ($InSectionRef);
}

sub getTxSection(){
	my ( $self ) = shift;
	return ($TxSection);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}


#------- BUILDING SETTERS------

sub setPkSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkSectionIdx = $value;
	return ($field);
}

sub setInSectionRef(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSectionRef = $value;
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




#------- BUILDING Getting ID by field Name------

sub getIdBy_InSectionRef(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION_REF where IN_SECTION_REF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION_REF where TX_SECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SECTION_IDX from TB_SECTION_REF where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateInSectionRef_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION_REF set IN_SECTION_REF=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION_REF set TX_SECTION=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SECTION_REF set IN_WEIGHT=? where PK_SECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

