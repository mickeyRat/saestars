package SAE::TB_ECR;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkEcrIdx;
my $FkTeamIdx;
my $InEcrValue;
my $TxEcr;
my $ClDescription;
my $InDeduction;
my $TxCategory;
my $TxMethod;
my $TxSystem;
my $ClReason;
my $InAreaOld;
my $InAreaNew;
my $InLengthOld;
my $InLengthNew;
my $InStatus;
my $InMisc;
my $InElectronic;
my $InMechanical;
my $InStructure;
my $InChordRemove;
my $InChordAdd;
my $InSpanRemove;
my $InSpanAdd;
my $InSpan;
my $InChord;
my $TsCreated;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_ECR (FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $InEcrValue, $TxEcr, $ClDescription, $InDeduction, $TxCategory, $TxMethod, $TxSystem, $ClReason, $InAreaOld, $InAreaNew, $InLengthOld, $InLengthNew, $InStatus, $InMisc, $InElectronic, $InMechanical, $InStructure, $InChordRemove, $InChordAdd, $InSpanRemove, $InSpanAdd, $InSpan, $InChord);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD, TS_CREATED
		FROM TB_ECR
		WHERE PK_ECR_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkEcrIdx 		 = 	$HASH{PK_ECR_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$InEcrValue 		 = 	$HASH{IN_ECR_VALUE};
	$TxEcr 		 = 	$HASH{TX_ECR};
	$ClDescription 		 = 	$HASH{CL_DESCRIPTION};
	$InDeduction 		 = 	$HASH{IN_DEDUCTION};
	$TxCategory 		 = 	$HASH{TX_CATEGORY};
	$TxMethod 		 = 	$HASH{TX_METHOD};
	$TxSystem 		 = 	$HASH{TX_SYSTEM};
	$ClReason 		 = 	$HASH{CL_REASON};
	$InAreaOld 		 = 	$HASH{IN_AREA_OLD};
	$InAreaNew 		 = 	$HASH{IN_AREA_NEW};
	$InLengthOld 		 = 	$HASH{IN_LENGTH_OLD};
	$InLengthNew 		 = 	$HASH{IN_LENGTH_NEW};
	$InStatus 		 = 	$HASH{IN_STATUS};
	$InMisc 		 = 	$HASH{IN_MISC};
	$InElectronic 		 = 	$HASH{IN_ELECTRONIC};
	$InMechanical 		 = 	$HASH{IN_MECHANICAL};
	$InStructure 		 = 	$HASH{IN_STRUCTURE};
	$InChordRemove 		 = 	$HASH{IN_CHORD_REMOVE};
	$InChordAdd 		 = 	$HASH{IN_CHORD_ADD};
	$InSpanRemove 		 = 	$HASH{IN_SPAN_REMOVE};
	$InSpanAdd 		 = 	$HASH{IN_SPAN_ADD};
	$InSpan 		 = 	$HASH{IN_SPAN};
	$InChord 		 = 	$HASH{IN_CHORD};
	$TsCreated 		 = 	$HASH{TS_CREATED};
	return $self;

;}
sub getAllRecordBy_PkEcrIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE PK_ECR_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InEcrValue(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_ECR_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxEcr(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE TX_ECR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDeduction(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_DEDUCTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxMethod(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE TX_METHOD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSystem(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE TX_SYSTEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClReason(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE CL_REASON=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InAreaOld(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_AREA_OLD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InAreaNew(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_AREA_NEW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLengthOld(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_LENGTH_OLD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLengthNew(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_LENGTH_NEW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMisc(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_MISC=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InElectronic(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_ELECTRONIC=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMechanical(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_MECHANICAL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InStructure(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_STRUCTURE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InChordRemove(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_CHORD_REMOVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InChordAdd(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_CHORD_ADD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSpanRemove(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_SPAN_REMOVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSpanAdd(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_SPAN_ADD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSpan(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_SPAN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InChord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR WHERE IN_CHORD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ECR_IDX, FK_TEAM_IDX, IN_ECR_VALUE, TX_ECR, CL_DESCRIPTION, IN_DEDUCTION, TX_CATEGORY, TX_METHOD, TX_SYSTEM, CL_REASON, IN_AREA_OLD, IN_AREA_NEW, IN_LENGTH_OLD, IN_LENGTH_NEW, IN_STATUS, IN_MISC, IN_ELECTRONIC, IN_MECHANICAL, IN_STRUCTURE, IN_CHORD_REMOVE, IN_CHORD_ADD, IN_SPAN_REMOVE, IN_SPAN_ADD, IN_SPAN, IN_CHORD FROM TB_ECR";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_ECR_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where PK_ECR_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkEcrIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where PK_ECR_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InEcrValue(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_ECR_VALUE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxEcr(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where TX_ECR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClDescription(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where CL_DESCRIPTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDeduction(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_DEDUCTION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxCategory(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where TX_CATEGORY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxMethod(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where TX_METHOD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxSystem(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where TX_SYSTEM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClReason(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where CL_REASON=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InAreaOld(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_AREA_OLD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InAreaNew(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_AREA_NEW=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLengthOld(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_LENGTH_OLD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLengthNew(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_LENGTH_NEW=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMisc(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_MISC=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InElectronic(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_ELECTRONIC=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMechanical(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_MECHANICAL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InStructure(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_STRUCTURE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InChordRemove(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_CHORD_REMOVE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InChordAdd(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_CHORD_ADD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSpanRemove(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_SPAN_REMOVE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSpanAdd(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_SPAN_ADD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSpan(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_SPAN=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InChord(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ECR where IN_CHORD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkEcrIdx(){
	my ( $self ) = shift;
	return ($PkEcrIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getInEcrValue(){
	my ( $self ) = shift;
	return ($InEcrValue);
}

sub getTxEcr(){
	my ( $self ) = shift;
	return ($TxEcr);
}

sub getClDescription(){
	my ( $self ) = shift;
	return ($ClDescription);
}

sub getInDeduction(){
	my ( $self ) = shift;
	return ($InDeduction);
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($TxCategory);
}

sub getTxMethod(){
	my ( $self ) = shift;
	return ($TxMethod);
}

sub getTxSystem(){
	my ( $self ) = shift;
	return ($TxSystem);
}

sub getClReason(){
	my ( $self ) = shift;
	return ($ClReason);
}

sub getInAreaOld(){
	my ( $self ) = shift;
	return ($InAreaOld);
}

sub getInAreaNew(){
	my ( $self ) = shift;
	return ($InAreaNew);
}

sub getInLengthOld(){
	my ( $self ) = shift;
	return ($InLengthOld);
}

sub getInLengthNew(){
	my ( $self ) = shift;
	return ($InLengthNew);
}

sub getInStatus(){
	my ( $self ) = shift;
	return ($InStatus);
}

sub getInMisc(){
	my ( $self ) = shift;
	return ($InMisc);
}

sub getInElectronic(){
	my ( $self ) = shift;
	return ($InElectronic);
}

sub getInMechanical(){
	my ( $self ) = shift;
	return ($InMechanical);
}

sub getInStructure(){
	my ( $self ) = shift;
	return ($InStructure);
}

sub getInChordRemove(){
	my ( $self ) = shift;
	return ($InChordRemove);
}

sub getInChordAdd(){
	my ( $self ) = shift;
	return ($InChordAdd);
}

sub getInSpanRemove(){
	my ( $self ) = shift;
	return ($InSpanRemove);
}

sub getInSpanAdd(){
	my ( $self ) = shift;
	return ($InSpanAdd);
}

sub getInSpan(){
	my ( $self ) = shift;
	return ($InSpan);
}

sub getInChord(){
	my ( $self ) = shift;
	return ($InChord);
}

sub getTsCreated(){
	my ( $self ) = shift;
	return ($TsCreated);
}


#------- BUILDING SETTERS------

sub setPkEcrIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkEcrIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setInEcrValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InEcrValue = $value;
	return ($field);
}

sub setTxEcr(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxEcr = $value;
	return ($field);
}

sub setClDescription(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClDescription = $value;
	return ($field);
}

sub setInDeduction(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDeduction = $value;
	return ($field);
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCategory = $value;
	return ($field);
}

sub setTxMethod(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxMethod = $value;
	return ($field);
}

sub setTxSystem(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSystem = $value;
	return ($field);
}

sub setClReason(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClReason = $value;
	return ($field);
}

sub setInAreaOld(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InAreaOld = $value;
	return ($field);
}

sub setInAreaNew(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InAreaNew = $value;
	return ($field);
}

sub setInLengthOld(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLengthOld = $value;
	return ($field);
}

sub setInLengthNew(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLengthNew = $value;
	return ($field);
}

sub setInStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InStatus = $value;
	return ($field);
}

sub setInMisc(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMisc = $value;
	return ($field);
}

sub setInElectronic(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InElectronic = $value;
	return ($field);
}

sub setInMechanical(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMechanical = $value;
	return ($field);
}

sub setInStructure(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InStructure = $value;
	return ($field);
}

sub setInChordRemove(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InChordRemove = $value;
	return ($field);
}

sub setInChordAdd(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InChordAdd = $value;
	return ($field);
}

sub setInSpanRemove(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSpanRemove = $value;
	return ($field);
}

sub setInSpanAdd(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSpanAdd = $value;
	return ($field);
}

sub setInSpan(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSpan = $value;
	return ($field);
}

sub setInChord(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InChord = $value;
	return ($field);
}

sub setTsCreated(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreated = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InEcrValue(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_ECR_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxEcr(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where TX_ECR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClDescription(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where CL_DESCRIPTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDeduction(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_DEDUCTION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxMethod(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where TX_METHOD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSystem(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where TX_SYSTEM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClReason(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where CL_REASON=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InAreaOld(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_AREA_OLD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InAreaNew(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_AREA_NEW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLengthOld(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_LENGTH_OLD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLengthNew(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_LENGTH_NEW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMisc(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_MISC=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InElectronic(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_ELECTRONIC=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMechanical(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_MECHANICAL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InStructure(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_STRUCTURE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InChordRemove(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_CHORD_REMOVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InChordAdd(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_CHORD_ADD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSpanRemove(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_SPAN_REMOVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSpanAdd(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_SPAN_ADD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSpan(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_SPAN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InChord(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ECR_IDX from TB_ECR where IN_CHORD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set FK_TEAM_IDX=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInEcrValue_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_ECR_VALUE=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxEcr_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set TX_ECR=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClDescription_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set CL_DESCRIPTION=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDeduction_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_DEDUCTION=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxCategory_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set TX_CATEGORY=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxMethod_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set TX_METHOD=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSystem_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set TX_SYSTEM=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClReason_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set CL_REASON=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInAreaOld_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_AREA_OLD=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInAreaNew_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_AREA_NEW=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLengthOld_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_LENGTH_OLD=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLengthNew_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_LENGTH_NEW=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_STATUS=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMisc_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_MISC=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInElectronic_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_ELECTRONIC=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMechanical_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_MECHANICAL=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInStructure_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_STRUCTURE=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInChordRemove_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_CHORD_REMOVE=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInChordAdd_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_CHORD_ADD=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSpanRemove_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_SPAN_REMOVE=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSpanAdd_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_SPAN_ADD=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSpan_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_SPAN=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInChord_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set IN_CHORD=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreated_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR set TS_CREATED=? where PK_ECR_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkEcrIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET PK_ECR_IDX=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET FK_TEAM_IDX=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInEcrValue_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_ECR_VALUE=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxEcr_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET TX_ECR=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClDescription_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET CL_DESCRIPTION=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDeduction_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_DEDUCTION=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxCategory_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET TX_CATEGORY=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxMethod_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET TX_METHOD=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSystem_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET TX_SYSTEM=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClReason_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET CL_REASON=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInAreaOld_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_AREA_OLD=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInAreaNew_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_AREA_NEW=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLengthOld_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_LENGTH_OLD=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLengthNew_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_LENGTH_NEW=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_STATUS=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMisc_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_MISC=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInElectronic_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_ELECTRONIC=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMechanical_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_MECHANICAL=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInStructure_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_STRUCTURE=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInChordRemove_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_CHORD_REMOVE=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInChordAdd_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_CHORD_ADD=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSpanRemove_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_SPAN_REMOVE=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSpanAdd_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_SPAN_ADD=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSpan_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_SPAN=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInChord_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ECR SET IN_CHORD=? where PK_ECR_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

