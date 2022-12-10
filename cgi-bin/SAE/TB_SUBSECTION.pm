package SAE::TB_SUBSECTION;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkSubsectionIdx;
my $FkSectionIdx;
my $InSubsection;
my $TxSubsection;
my $ClDescription;
my $InType;
my $InThreshold;
my $InWeight;
my $InMin;
my $InMax;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SUBSECTION (FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkSectionIdx, $InSubsection, $TxSubsection, $ClDescription, $InType, $InThreshold, $InWeight, $InMin, $InMax);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX
		FROM TB_SUBSECTION
		WHERE PK_SUBSECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkSubsectionIdx 		 = 	$HASH{PK_SUBSECTION_IDX};
	$FkSectionIdx 		 = 	$HASH{FK_SECTION_IDX};
	$InSubsection 		 = 	$HASH{IN_SUBSECTION};
	$TxSubsection 		 = 	$HASH{TX_SUBSECTION};
	$ClDescription 		 = 	$HASH{CL_DESCRIPTION};
	$InType 		 = 	$HASH{IN_TYPE};
	$InThreshold 		 = 	$HASH{IN_THRESHOLD};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InMin 		 = 	$HASH{IN_MIN};
	$InMax 		 = 	$HASH{IN_MAX};
	return $self;

;}
sub getAllRecordBy_PkSubsectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE PK_SUBSECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE FK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSubsection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE IN_SUBSECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSubsection(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE TX_SUBSECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE IN_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InThreshold(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE IN_THRESHOLD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMin(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE IN_MIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_WEIGHT, IN_MIN, IN_MAX FROM TB_SUBSECTION";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SUBSECTION_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where PK_SUBSECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkSubsectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where PK_SUBSECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkSectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where FK_SECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSubsection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where IN_SUBSECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxSubsection(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where TX_SUBSECTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClDescription(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where CL_DESCRIPTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where IN_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InThreshold(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where IN_THRESHOLD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMin(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where IN_MIN=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMax(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SUBSECTION where IN_MAX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkSubsectionIdx(){
	my ( $self ) = shift;
	return ($PkSubsectionIdx);
}

sub getFkSectionIdx(){
	my ( $self ) = shift;
	return ($FkSectionIdx);
}

sub getInSubsection(){
	my ( $self ) = shift;
	return ($InSubsection);
}

sub getTxSubsection(){
	my ( $self ) = shift;
	return ($TxSubsection);
}

sub getClDescription(){
	my ( $self ) = shift;
	return ($ClDescription);
}

sub getInType(){
	my ( $self ) = shift;
	return ($InType);
}

sub getInThreshold(){
	my ( $self ) = shift;
	return ($InThreshold);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getInMin(){
	my ( $self ) = shift;
	return ($InMin);
}

sub getInMax(){
	my ( $self ) = shift;
	return ($InMax);
}


#------- BUILDING SETTERS------

sub setPkSubsectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkSubsectionIdx = $value;
	return ($field);
}

sub setFkSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkSectionIdx = $value;
	return ($field);
}

sub setInSubsection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSubsection = $value;
	return ($field);
}

sub setTxSubsection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSubsection = $value;
	return ($field);
}

sub setClDescription(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClDescription = $value;
	return ($field);
}

sub setInType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InType = $value;
	return ($field);
}

sub setInThreshold(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InThreshold = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
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




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkSectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where FK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSubsection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where IN_SUBSECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSubsection(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where TX_SUBSECTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where IN_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InThreshold(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where IN_THRESHOLD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMin(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where IN_MIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SUBSECTION_IDX from TB_SUBSECTION where IN_MAX=?";
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

	my $SQL = "UPDATE TB_SUBSECTION set FK_SECTION_IDX=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSubsection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set IN_SUBSECTION=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSubsection_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set TX_SUBSECTION=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClDescription_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set CL_DESCRIPTION=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set IN_TYPE=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInThreshold_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set IN_THRESHOLD=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set IN_WEIGHT=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMin_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set IN_MIN=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION set IN_MAX=? where PK_SUBSECTION_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkSubsectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET PK_SUBSECTION_IDX=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkSectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET FK_SECTION_IDX=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSubsection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET IN_SUBSECTION=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSubsection_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET TX_SUBSECTION=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClDescription_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET CL_DESCRIPTION=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET IN_TYPE=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInThreshold_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET IN_THRESHOLD=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET IN_WEIGHT=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMin_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET IN_MIN=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SUBSECTION SET IN_MAX=? where PK_SUBSECTION_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

