package SAE::TB_TEAM;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTeamIdx;
my $FkClassIdx;
my $FkCountryIdx;
my $InNumber;
my $TxName;
my $TxSchool;
my $InSlope;
my $InYint;
my $TxCode;
my $TxReport;
my $TxTds;
my $TxDrawing;
my $FkEventIdx;
my $InTubeLength;
my $BoStatus;
my $BoCheckin;
my $InCapacity;
my $InMax;
my $InFactor;
my $InLate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TEAM (FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkClassIdx, $FkCountryIdx, $InNumber, $TxName, $TxSchool, $InSlope, $InYint, $TxCode, $TxReport, $TxTds, $TxDrawing, $FkEventIdx, $InTubeLength, $BoStatus, $BoCheckin, $InCapacity, $InMax, $InFactor, $InLate);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE
		FROM TB_TEAM
		WHERE PK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTeamIdx 		 = 	$HASH{PK_TEAM_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$FkCountryIdx 		 = 	$HASH{FK_COUNTRY_IDX};
	$InNumber 		 = 	$HASH{IN_NUMBER};
	$TxName 		 = 	$HASH{TX_NAME};
	$TxSchool 		 = 	$HASH{TX_SCHOOL};
	$InSlope 		 = 	$HASH{IN_SLOPE};
	$InYint 		 = 	$HASH{IN_YINT};
	$TxCode 		 = 	$HASH{TX_CODE};
	$TxReport 		 = 	$HASH{TX_REPORT};
	$TxTds 		 = 	$HASH{TX_TDS};
	$TxDrawing 		 = 	$HASH{TX_DRAWING};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InTubeLength 		 = 	$HASH{IN_TUBE_LENGTH};
	$BoStatus 		 = 	$HASH{BO_STATUS};
	$BoCheckin 		 = 	$HASH{BO_CHECKIN};
	$InCapacity 		 = 	$HASH{IN_CAPACITY};
	$InMax 		 = 	$HASH{IN_MAX};
	$InFactor 		 = 	$HASH{IN_FACTOR};
	$InLate 		 = 	$HASH{IN_LATE};
	return $self;

;}
sub getAllRecordBy_PkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE PK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkCountryIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE FK_COUNTRY_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InNumber(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_NUMBER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxName(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE TX_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSchool(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE TX_SCHOOL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSlope(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_SLOPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InYint(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_YINT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxCode(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE TX_CODE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxReport(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE TX_REPORT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTds(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE TX_TDS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDrawing(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE TX_DRAWING=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTubeLength(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_TUBE_LENGTH=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE BO_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoCheckin(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE BO_CHECKIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InCapacity(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_CAPACITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InFactor(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_FACTOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLate(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE IN_LATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where PK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where PK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where FK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkCountryIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where FK_COUNTRY_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InNumber(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_NUMBER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxName(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_NAME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxSchool(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_SCHOOL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSlope(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_SLOPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InYint(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_YINT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxCode(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_CODE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxReport(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_REPORT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTds(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_TDS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxDrawing(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_DRAWING=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTubeLength(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_TUBE_LENGTH=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where BO_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoCheckin(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where BO_CHECKIN=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InCapacity(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_CAPACITY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMax(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_MAX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InFactor(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_FACTOR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLate(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_LATE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTeamIdx(){
	my ( $self ) = shift;
	return ($PkTeamIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}

sub getFkCountryIdx(){
	my ( $self ) = shift;
	return ($FkCountryIdx);
}

sub getInNumber(){
	my ( $self ) = shift;
	return ($InNumber);
}

sub getTxName(){
	my ( $self ) = shift;
	return ($TxName);
}

sub getTxSchool(){
	my ( $self ) = shift;
	return ($TxSchool);
}

sub getInSlope(){
	my ( $self ) = shift;
	return ($InSlope);
}

sub getInYint(){
	my ( $self ) = shift;
	return ($InYint);
}

sub getTxCode(){
	my ( $self ) = shift;
	return ($TxCode);
}

sub getTxReport(){
	my ( $self ) = shift;
	return ($TxReport);
}

sub getTxTds(){
	my ( $self ) = shift;
	return ($TxTds);
}

sub getTxDrawing(){
	my ( $self ) = shift;
	return ($TxDrawing);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInTubeLength(){
	my ( $self ) = shift;
	return ($InTubeLength);
}

sub getBoStatus(){
	my ( $self ) = shift;
	return ($BoStatus);
}

sub getBoCheckin(){
	my ( $self ) = shift;
	return ($BoCheckin);
}

sub getInCapacity(){
	my ( $self ) = shift;
	return ($InCapacity);
}

sub getInMax(){
	my ( $self ) = shift;
	return ($InMax);
}

sub getInFactor(){
	my ( $self ) = shift;
	return ($InFactor);
}

sub getInLate(){
	my ( $self ) = shift;
	return ($InLate);
}


#------- BUILDING SETTERS------

sub setPkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTeamIdx = $value;
	return ($field);
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkClassIdx = $value;
	return ($field);
}

sub setFkCountryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkCountryIdx = $value;
	return ($field);
}

sub setInNumber(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InNumber = $value;
	return ($field);
}

sub setTxName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxName = $value;
	return ($field);
}

sub setTxSchool(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxSchool = $value;
	return ($field);
}

sub setInSlope(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSlope = $value;
	return ($field);
}

sub setInYint(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InYint = $value;
	return ($field);
}

sub setTxCode(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCode = $value;
	return ($field);
}

sub setTxReport(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxReport = $value;
	return ($field);
}

sub setTxTds(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTds = $value;
	return ($field);
}

sub setTxDrawing(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxDrawing = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setInTubeLength(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTubeLength = $value;
	return ($field);
}

sub setBoStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoStatus = $value;
	return ($field);
}

sub setBoCheckin(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoCheckin = $value;
	return ($field);
}

sub setInCapacity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InCapacity = $value;
	return ($field);
}

sub setInMax(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMax = $value;
	return ($field);
}

sub setInFactor(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InFactor = $value;
	return ($field);
}

sub setInLate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkCountryIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where FK_COUNTRY_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InNumber(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_NUMBER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxName(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxSchool(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_SCHOOL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSlope(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_SLOPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InYint(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_YINT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxCode(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_CODE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxReport(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_REPORT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTds(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_TDS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDrawing(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_DRAWING=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTubeLength(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_TUBE_LENGTH=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where BO_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoCheckin(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where BO_CHECKIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InCapacity(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_CAPACITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InFactor(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_FACTOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLate(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_LATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkClassIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set FK_CLASS_IDX=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkCountryIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set FK_COUNTRY_IDX=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInNumber_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_NUMBER=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxName_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_NAME=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxSchool_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_SCHOOL=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSlope_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_SLOPE=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInYint_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_YINT=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxCode_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_CODE=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxReport_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_REPORT=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTds_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_TDS=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDrawing_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_DRAWING=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set FK_EVENT_IDX=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTubeLength_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_TUBE_LENGTH=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set BO_STATUS=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoCheckin_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set BO_CHECKIN=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInCapacity_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_CAPACITY=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_MAX=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInFactor_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_FACTOR=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_LATE=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET PK_TEAM_IDX=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkClassIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET FK_CLASS_IDX=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkCountryIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET FK_COUNTRY_IDX=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInNumber_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_NUMBER=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxName_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_NAME=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxSchool_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_SCHOOL=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSlope_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_SLOPE=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInYint_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_YINT=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxCode_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_CODE=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxReport_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_REPORT=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTds_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_TDS=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxDrawing_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_DRAWING=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET FK_EVENT_IDX=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTubeLength_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_TUBE_LENGTH=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET BO_STATUS=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoCheckin_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET BO_CHECKIN=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInCapacity_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_CAPACITY=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_MAX=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInFactor_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_FACTOR=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLate_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_LATE=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

