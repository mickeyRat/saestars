package SAE::TB_PAPER;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPaperIdx;
my $FkCardIdx;
my $FkSubsectionIdx;
my $InValue;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkCardIdx, $FkSubsectionIdx, $InValue);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PAPER_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE
		FROM TB_PAPER
		WHERE PK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPaperIdx 		 = 	$HASH{PK_PAPER_IDX};
	$FkCardIdx 		 = 	$HASH{FK_CARD_IDX};
	$FkSubsectionIdx 		 = 	$HASH{FK_SUBSECTION_IDX};
	$InValue 		 = 	$HASH{IN_VALUE};
	return $self;

;}
sub getAllRecordBy_PkPaperIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER WHERE PK_PAPER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkCardIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER WHERE FK_CARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkSubsectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER WHERE FK_SUBSECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InValue(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER WHERE IN_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER where PK_PAPER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkPaperIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER where PK_PAPER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkCardIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER where FK_CARD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkSubsectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER where FK_SUBSECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InValue(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER where IN_VALUE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkPaperIdx(){
	my ( $self ) = shift;
	return ($PkPaperIdx);
}

sub getFkCardIdx(){
	my ( $self ) = shift;
	return ($FkCardIdx);
}

sub getFkSubsectionIdx(){
	my ( $self ) = shift;
	return ($FkSubsectionIdx);
}

sub getInValue(){
	my ( $self ) = shift;
	return ($InValue);
}


#------- BUILDING SETTERS------

sub setPkPaperIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPaperIdx = $value;
	return ($field);
}

sub setFkCardIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkCardIdx = $value;
	return ($field);
}

sub setFkSubsectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkSubsectionIdx = $value;
	return ($field);
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InValue = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkCardIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_CARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkSubsectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where FK_SUBSECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InValue(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_IDX from TB_PAPER where IN_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkCardIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_CARD_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkSubsectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set FK_SUBSECTION_IDX=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInValue_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER set IN_VALUE=? where PK_PAPER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkPaperIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET PK_PAPER_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkCardIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_CARD_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkSubsectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET FK_SUBSECTION_IDX=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInValue_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER SET IN_VALUE=? where PK_PAPER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

