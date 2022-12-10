package SAE::TB_TEAM;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTeamIdx;
my $FkEventIdx;
my $FkClassIdx;
my $FkCountryIdx;
my $TxCountry;
my $InNumber;
my $TxName;
my $TxSchool;
my $TxCode;
my $InLate;
my $InSlope;
my $InYint;
my $InStd;
my $BoAuto;
my $InWater;
my $InLcargo;
my $InPipes;
my $InWpipes;
my $InVideo;
my $InSeconds;
my $TxReport;
my $TxTds;
my $TxDrawing;
my $InTubeLength;
my $InFactor;
my $BoStatus;
my $BoCheckin;
my $InCapacity;
my $InMax;
my $TxStateCode;
my $TxFlightButton;
my $InFlightStatus;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TEAM (FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $FkClassIdx, $FkCountryIdx, $TxCountry, $InNumber, $TxName, $TxSchool, $TxCode, $InLate, $InSlope, $InYint, $InStd, $BoAuto, $InWater, $InLcargo, $InPipes, $InWpipes, $InVideo, $InSeconds, $TxReport, $TxTds, $TxDrawing, $InTubeLength, $InFactor, $BoStatus, $BoCheckin, $InCapacity, $InMax, $TxStateCode, $TxFlightButton, $InFlightStatus);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS
		FROM TB_TEAM
		WHERE PK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTeamIdx 		 = 	$HASH{PK_TEAM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$FkCountryIdx 		 = 	$HASH{FK_COUNTRY_IDX};
	$TxCountry 		 = 	$HASH{TX_COUNTRY};
	$InNumber 		 = 	$HASH{IN_NUMBER};
	$TxName 		 = 	$HASH{TX_NAME};
	$TxSchool 		 = 	$HASH{TX_SCHOOL};
	$TxCode 		 = 	$HASH{TX_CODE};
	$InLate 		 = 	$HASH{IN_LATE};
	$InSlope 		 = 	$HASH{IN_SLOPE};
	$InYint 		 = 	$HASH{IN_YINT};
	$InStd 		 = 	$HASH{IN_STD};
	$BoAuto 		 = 	$HASH{BO_AUTO};
	$InWater 		 = 	$HASH{IN_WATER};
	$InLcargo 		 = 	$HASH{IN_LCARGO};
	$InPipes 		 = 	$HASH{IN_PIPES};
	$InWpipes 		 = 	$HASH{IN_WPIPES};
	$InVideo 		 = 	$HASH{IN_VIDEO};
	$InSeconds 		 = 	$HASH{IN_SECONDS};
	$TxReport 		 = 	$HASH{TX_REPORT};
	$TxTds 		 = 	$HASH{TX_TDS};
	$TxDrawing 		 = 	$HASH{TX_DRAWING};
	$InTubeLength 		 = 	$HASH{IN_TUBE_LENGTH};
	$InFactor 		 = 	$HASH{IN_FACTOR};
	$BoStatus 		 = 	$HASH{BO_STATUS};
	$BoCheckin 		 = 	$HASH{BO_CHECKIN};
	$InCapacity 		 = 	$HASH{IN_CAPACITY};
	$InMax 		 = 	$HASH{IN_MAX};
	$TxStateCode 		 = 	$HASH{TX_STATE_CODE};
	$TxFlightButton 		 = 	$HASH{TX_FLIGHT_BUTTON};
	$InFlightStatus 		 = 	$HASH{IN_FLIGHT_STATUS};
	return $self;

;}
sub getAllRecordBy_PkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE PK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkCountryIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE FK_COUNTRY_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxCountry(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_COUNTRY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InNumber(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_NUMBER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxName(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxSchool(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_SCHOOL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxCode(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_CODE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLate(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_LATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSlope(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_SLOPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InYint(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_YINT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InStd(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_STD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoAuto(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE BO_AUTO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWater(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_WATER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLcargo(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_LCARGO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPipes(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_PIPES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWpipes(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_WPIPES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InVideo(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_VIDEO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSeconds(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_SECONDS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxReport(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_REPORT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTds(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_TDS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxDrawing(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_DRAWING=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTubeLength(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_TUBE_LENGTH=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InFactor(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_FACTOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE BO_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoCheckin(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE BO_CHECKIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InCapacity(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_CAPACITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxStateCode(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_STATE_CODE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFlightButton(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE TX_FLIGHT_BUTTON=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InFlightStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM WHERE IN_FLIGHT_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEAM_IDX, FK_EVENT_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, TX_CODE, IN_LATE, IN_SLOPE, IN_YINT, IN_STD, BO_AUTO, IN_WATER, IN_LCARGO, IN_PIPES, IN_WPIPES, IN_VIDEO, IN_SECONDS, TX_REPORT, TX_TDS, TX_DRAWING, IN_TUBE_LENGTH, IN_FACTOR, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, TX_STATE_CODE, TX_FLIGHT_BUTTON, IN_FLIGHT_STATUS FROM TB_TEAM";
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

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where FK_EVENT_IDX=?";
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

sub deleteRecordBy_TxCountry(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_COUNTRY=?";
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

sub deleteRecordBy_TxCode(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_CODE=?";
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

sub deleteRecordBy_InStd(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_STD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoAuto(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where BO_AUTO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWater(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_WATER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLcargo(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_LCARGO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPipes(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_PIPES=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWpipes(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_WPIPES=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InVideo(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_VIDEO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSeconds(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_SECONDS=?";
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

sub deleteRecordBy_InTubeLength(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_TUBE_LENGTH=?";
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

sub deleteRecordBy_TxStateCode(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_STATE_CODE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFlightButton(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where TX_FLIGHT_BUTTON=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InFlightStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEAM where IN_FLIGHT_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTeamIdx(){
	my ( $self ) = shift;
	return ($PkTeamIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}

sub getFkCountryIdx(){
	my ( $self ) = shift;
	return ($FkCountryIdx);
}

sub getTxCountry(){
	my ( $self ) = shift;
	return ($TxCountry);
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

sub getTxCode(){
	my ( $self ) = shift;
	return ($TxCode);
}

sub getInLate(){
	my ( $self ) = shift;
	return ($InLate);
}

sub getInSlope(){
	my ( $self ) = shift;
	return ($InSlope);
}

sub getInYint(){
	my ( $self ) = shift;
	return ($InYint);
}

sub getInStd(){
	my ( $self ) = shift;
	return ($InStd);
}

sub getBoAuto(){
	my ( $self ) = shift;
	return ($BoAuto);
}

sub getInWater(){
	my ( $self ) = shift;
	return ($InWater);
}

sub getInLcargo(){
	my ( $self ) = shift;
	return ($InLcargo);
}

sub getInPipes(){
	my ( $self ) = shift;
	return ($InPipes);
}

sub getInWpipes(){
	my ( $self ) = shift;
	return ($InWpipes);
}

sub getInVideo(){
	my ( $self ) = shift;
	return ($InVideo);
}

sub getInSeconds(){
	my ( $self ) = shift;
	return ($InSeconds);
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

sub getInTubeLength(){
	my ( $self ) = shift;
	return ($InTubeLength);
}

sub getInFactor(){
	my ( $self ) = shift;
	return ($InFactor);
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

sub getTxStateCode(){
	my ( $self ) = shift;
	return ($TxStateCode);
}

sub getTxFlightButton(){
	my ( $self ) = shift;
	return ($TxFlightButton);
}

sub getInFlightStatus(){
	my ( $self ) = shift;
	return ($InFlightStatus);
}


#------- BUILDING SETTERS------

sub setPkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTeamIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
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

sub setTxCountry(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCountry = $value;
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

sub setTxCode(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCode = $value;
	return ($field);
}

sub setInLate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLate = $value;
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

sub setInStd(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InStd = $value;
	return ($field);
}

sub setBoAuto(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoAuto = $value;
	return ($field);
}

sub setInWater(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWater = $value;
	return ($field);
}

sub setInLcargo(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLcargo = $value;
	return ($field);
}

sub setInPipes(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPipes = $value;
	return ($field);
}

sub setInWpipes(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWpipes = $value;
	return ($field);
}

sub setInVideo(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InVideo = $value;
	return ($field);
}

sub setInSeconds(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSeconds = $value;
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

sub setInTubeLength(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTubeLength = $value;
	return ($field);
}

sub setInFactor(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InFactor = $value;
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

sub setTxStateCode(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxStateCode = $value;
	return ($field);
}

sub setTxFlightButton(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFlightButton = $value;
	return ($field);
}

sub setInFlightStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InFlightStatus = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
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
sub getIdBy_TxCountry(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_COUNTRY=?";
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
sub getIdBy_TxCode(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_CODE=?";
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
sub getIdBy_InStd(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_STD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoAuto(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where BO_AUTO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWater(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_WATER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLcargo(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_LCARGO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPipes(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_PIPES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWpipes(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_WPIPES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InVideo(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_VIDEO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSeconds(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_SECONDS=?";
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
sub getIdBy_InTubeLength(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_TUBE_LENGTH=?";
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
sub getIdBy_TxStateCode(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_STATE_CODE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFlightButton(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where TX_FLIGHT_BUTTON=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InFlightStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEAM_IDX from TB_TEAM where IN_FLIGHT_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set FK_EVENT_IDX=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
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
sub updateTxCountry_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_COUNTRY=? where PK_TEAM_IDX=?";
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
sub updateTxCode_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_CODE=? where PK_TEAM_IDX=?";
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
sub updateInStd_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_STD=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoAuto_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set BO_AUTO=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWater_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_WATER=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLcargo_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_LCARGO=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPipes_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_PIPES=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWpipes_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_WPIPES=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInVideo_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_VIDEO=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSeconds_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_SECONDS=? where PK_TEAM_IDX=?";
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
sub updateInTubeLength_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_TUBE_LENGTH=? where PK_TEAM_IDX=?";
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
sub updateTxStateCode_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_STATE_CODE=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFlightButton_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set TX_FLIGHT_BUTTON=? where PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInFlightStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM set IN_FLIGHT_STATUS=? where PK_TEAM_IDX=?";
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

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET FK_EVENT_IDX=? where PK_TEAM_IDX = ?";
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

sub updateTxCountry_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_COUNTRY=? where PK_TEAM_IDX = ?";
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

sub updateTxCode_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_CODE=? where PK_TEAM_IDX = ?";
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

sub updateInStd_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_STD=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoAuto_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET BO_AUTO=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWater_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_WATER=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLcargo_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_LCARGO=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPipes_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_PIPES=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWpipes_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_WPIPES=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInVideo_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_VIDEO=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSeconds_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_SECONDS=? where PK_TEAM_IDX = ?";
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

sub updateInTubeLength_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_TUBE_LENGTH=? where PK_TEAM_IDX = ?";
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

sub updateTxStateCode_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_STATE_CODE=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFlightButton_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET TX_FLIGHT_BUTTON=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInFlightStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEAM SET IN_FLIGHT_STATUS=? where PK_TEAM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

