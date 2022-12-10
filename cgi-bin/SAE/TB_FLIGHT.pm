package SAE::TB_FLIGHT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkFlightIdx;
my $FkEventIdx;
my $FkTeamIdx;
my $FkTodoIdx;
my $InRound;
my $TxStatus;
my $TxColor;
my $InStatus;
my $TsCreate;
my $TsUpdate;
my $InLcargo;
my $InSphere;
my $InWeight;
my $InSpan;
my $InDensity;
my $TxTime;
my $FkWeatherIdx;
my $InTemp;
my $InPres;
my $InRh;
my $InElevation;
my $InColonist;
my $InHabitat;
my $InWater;
my $InEmpty;
my $InPenMinor;
my $InPenLanding;
my $InDamage;
my $InSbDamage;
my $InLbDamage;
my $ClNotes;
my $InLarge;
my $InSmall;
my $InTof;
my $InDistance;
my $BoInzone;
my $BoApada;
my $BoAgtv;
my $InWaterFlt;
my $InWatreDev;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_FLIGHT (FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $FkTeamIdx, $FkTodoIdx, $InRound, $TxStatus, $TxColor, $InStatus, $TsUpdate, $InLcargo, $InSphere, $InWeight, $InSpan, $InDensity, $TxTime, $FkWeatherIdx, $InTemp, $InPres, $InRh, $InElevation, $InColonist, $InHabitat, $InWater, $InEmpty, $InPenMinor, $InPenLanding, $InDamage, $InSbDamage, $InLbDamage, $ClNotes, $InLarge, $InSmall, $InTof, $InDistance, $BoInzone, $BoApada, $BoAgtv, $InWaterFlt, $InWatreDev);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_CREATE, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV
		FROM TB_FLIGHT
		WHERE PK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkFlightIdx 		 = 	$HASH{PK_FLIGHT_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkTodoIdx 		 = 	$HASH{FK_TODO_IDX};
	$InRound 		 = 	$HASH{IN_ROUND};
	$TxStatus 		 = 	$HASH{TX_STATUS};
	$TxColor 		 = 	$HASH{TX_COLOR};
	$InStatus 		 = 	$HASH{IN_STATUS};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$TsUpdate 		 = 	$HASH{TS_UPDATE};
	$InLcargo 		 = 	$HASH{IN_LCARGO};
	$InSphere 		 = 	$HASH{IN_SPHERE};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	$InSpan 		 = 	$HASH{IN_SPAN};
	$InDensity 		 = 	$HASH{IN_DENSITY};
	$TxTime 		 = 	$HASH{TX_TIME};
	$FkWeatherIdx 		 = 	$HASH{FK_WEATHER_IDX};
	$InTemp 		 = 	$HASH{IN_TEMP};
	$InPres 		 = 	$HASH{IN_PRES};
	$InRh 		 = 	$HASH{IN_RH};
	$InElevation 		 = 	$HASH{IN_ELEVATION};
	$InColonist 		 = 	$HASH{IN_COLONIST};
	$InHabitat 		 = 	$HASH{IN_HABITAT};
	$InWater 		 = 	$HASH{IN_WATER};
	$InEmpty 		 = 	$HASH{IN_EMPTY};
	$InPenMinor 		 = 	$HASH{IN_PEN_MINOR};
	$InPenLanding 		 = 	$HASH{IN_PEN_LANDING};
	$InDamage 		 = 	$HASH{IN_DAMAGE};
	$InSbDamage 		 = 	$HASH{IN_SB_DAMAGE};
	$InLbDamage 		 = 	$HASH{IN_LB_DAMAGE};
	$ClNotes 		 = 	$HASH{CL_NOTES};
	$InLarge 		 = 	$HASH{IN_LARGE};
	$InSmall 		 = 	$HASH{IN_SMALL};
	$InTof 		 = 	$HASH{IN_TOF};
	$InDistance 		 = 	$HASH{IN_DISTANCE};
	$BoInzone 		 = 	$HASH{BO_INZONE};
	$BoApada 		 = 	$HASH{BO_APADA};
	$BoAgtv 		 = 	$HASH{BO_AGTV};
	$InWaterFlt 		 = 	$HASH{IN_WATER_FLT};
	$InWatreDev 		 = 	$HASH{IN_WATRE_DEV};
	return $self;

;}
sub getAllRecordBy_PkFlightIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE PK_FLIGHT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTodoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE FK_TODO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE TX_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxColor(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE TX_COLOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TsUpdate(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE TS_UPDATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLcargo(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_LCARGO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSphere(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_SPHERE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSpan(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_SPAN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDensity(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_DENSITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTime(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE TX_TIME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkWeatherIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE FK_WEATHER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTemp(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_TEMP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPres(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_PRES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRh(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_RH=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InElevation(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_ELEVATION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InColonist(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_COLONIST=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InHabitat(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_HABITAT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWater(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_WATER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InEmpty(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_EMPTY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPenMinor(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_PEN_MINOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPenLanding(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_PEN_LANDING=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDamage(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_DAMAGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSbDamage(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_SB_DAMAGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLbDamage(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_LB_DAMAGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClNotes(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE CL_NOTES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLarge(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_LARGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InSmall(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_SMALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTof(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_TOF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDistance(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_DISTANCE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoInzone(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE BO_INZONE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoApada(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE BO_APADA=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoAgtv(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE BO_AGTV=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWaterFlt(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_WATER_FLT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InWatreDev(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT WHERE IN_WATRE_DEV=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FLIGHT_IDX, FK_EVENT_IDX, FK_TEAM_IDX, FK_TODO_IDX, IN_ROUND, TX_STATUS, TX_COLOR, IN_STATUS, TS_UPDATE, IN_LCARGO, IN_SPHERE, IN_WEIGHT, IN_SPAN, IN_DENSITY, TX_TIME, FK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_COLONIST, IN_HABITAT, IN_WATER, IN_EMPTY, IN_PEN_MINOR, IN_PEN_LANDING, IN_DAMAGE, IN_SB_DAMAGE, IN_LB_DAMAGE, CL_NOTES, IN_LARGE, IN_SMALL, IN_TOF, IN_DISTANCE, BO_INZONE, BO_APADA, BO_AGTV, IN_WATER_FLT, IN_WATRE_DEV FROM TB_FLIGHT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_FLIGHT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where PK_FLIGHT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkFlightIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where PK_FLIGHT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTodoIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where FK_TODO_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRound(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_ROUND=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where TX_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxColor(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where TX_COLOR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TsUpdate(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where TS_UPDATE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLcargo(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_LCARGO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSphere(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_SPHERE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWeight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_WEIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSpan(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_SPAN=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDensity(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_DENSITY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTime(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where TX_TIME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkWeatherIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where FK_WEATHER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTemp(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_TEMP=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPres(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_PRES=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRh(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_RH=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InElevation(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_ELEVATION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InColonist(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_COLONIST=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InHabitat(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_HABITAT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWater(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_WATER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InEmpty(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_EMPTY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPenMinor(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_PEN_MINOR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPenLanding(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_PEN_LANDING=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDamage(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_DAMAGE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSbDamage(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_SB_DAMAGE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLbDamage(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_LB_DAMAGE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClNotes(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where CL_NOTES=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLarge(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_LARGE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InSmall(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_SMALL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTof(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_TOF=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDistance(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_DISTANCE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoInzone(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where BO_INZONE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoApada(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where BO_APADA=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoAgtv(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where BO_AGTV=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWaterFlt(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_WATER_FLT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InWatreDev(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FLIGHT where IN_WATRE_DEV=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkFlightIdx(){
	my ( $self ) = shift;
	return ($PkFlightIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkTodoIdx(){
	my ( $self ) = shift;
	return ($FkTodoIdx);
}

sub getInRound(){
	my ( $self ) = shift;
	return ($InRound);
}

sub getTxStatus(){
	my ( $self ) = shift;
	return ($TxStatus);
}

sub getTxColor(){
	my ( $self ) = shift;
	return ($TxColor);
}

sub getInStatus(){
	my ( $self ) = shift;
	return ($InStatus);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getTsUpdate(){
	my ( $self ) = shift;
	return ($TsUpdate);
}

sub getInLcargo(){
	my ( $self ) = shift;
	return ($InLcargo);
}

sub getInSphere(){
	my ( $self ) = shift;
	return ($InSphere);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}

sub getInSpan(){
	my ( $self ) = shift;
	return ($InSpan);
}

sub getInDensity(){
	my ( $self ) = shift;
	return ($InDensity);
}

sub getTxTime(){
	my ( $self ) = shift;
	return ($TxTime);
}

sub getFkWeatherIdx(){
	my ( $self ) = shift;
	return ($FkWeatherIdx);
}

sub getInTemp(){
	my ( $self ) = shift;
	return ($InTemp);
}

sub getInPres(){
	my ( $self ) = shift;
	return ($InPres);
}

sub getInRh(){
	my ( $self ) = shift;
	return ($InRh);
}

sub getInElevation(){
	my ( $self ) = shift;
	return ($InElevation);
}

sub getInColonist(){
	my ( $self ) = shift;
	return ($InColonist);
}

sub getInHabitat(){
	my ( $self ) = shift;
	return ($InHabitat);
}

sub getInWater(){
	my ( $self ) = shift;
	return ($InWater);
}

sub getInEmpty(){
	my ( $self ) = shift;
	return ($InEmpty);
}

sub getInPenMinor(){
	my ( $self ) = shift;
	return ($InPenMinor);
}

sub getInPenLanding(){
	my ( $self ) = shift;
	return ($InPenLanding);
}

sub getInDamage(){
	my ( $self ) = shift;
	return ($InDamage);
}

sub getInSbDamage(){
	my ( $self ) = shift;
	return ($InSbDamage);
}

sub getInLbDamage(){
	my ( $self ) = shift;
	return ($InLbDamage);
}

sub getClNotes(){
	my ( $self ) = shift;
	return ($ClNotes);
}

sub getInLarge(){
	my ( $self ) = shift;
	return ($InLarge);
}

sub getInSmall(){
	my ( $self ) = shift;
	return ($InSmall);
}

sub getInTof(){
	my ( $self ) = shift;
	return ($InTof);
}

sub getInDistance(){
	my ( $self ) = shift;
	return ($InDistance);
}

sub getBoInzone(){
	my ( $self ) = shift;
	return ($BoInzone);
}

sub getBoApada(){
	my ( $self ) = shift;
	return ($BoApada);
}

sub getBoAgtv(){
	my ( $self ) = shift;
	return ($BoAgtv);
}

sub getInWaterFlt(){
	my ( $self ) = shift;
	return ($InWaterFlt);
}

sub getInWatreDev(){
	my ( $self ) = shift;
	return ($InWatreDev);
}


#------- BUILDING SETTERS------

sub setPkFlightIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkFlightIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkTodoIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTodoIdx = $value;
	return ($field);
}

sub setInRound(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRound = $value;
	return ($field);
}

sub setTxStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxStatus = $value;
	return ($field);
}

sub setTxColor(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxColor = $value;
	return ($field);
}

sub setInStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InStatus = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setTsUpdate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsUpdate = $value;
	return ($field);
}

sub setInLcargo(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLcargo = $value;
	return ($field);
}

sub setInSphere(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSphere = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}

sub setInSpan(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSpan = $value;
	return ($field);
}

sub setInDensity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDensity = $value;
	return ($field);
}

sub setTxTime(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTime = $value;
	return ($field);
}

sub setFkWeatherIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkWeatherIdx = $value;
	return ($field);
}

sub setInTemp(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTemp = $value;
	return ($field);
}

sub setInPres(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPres = $value;
	return ($field);
}

sub setInRh(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRh = $value;
	return ($field);
}

sub setInElevation(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InElevation = $value;
	return ($field);
}

sub setInColonist(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InColonist = $value;
	return ($field);
}

sub setInHabitat(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InHabitat = $value;
	return ($field);
}

sub setInWater(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWater = $value;
	return ($field);
}

sub setInEmpty(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InEmpty = $value;
	return ($field);
}

sub setInPenMinor(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPenMinor = $value;
	return ($field);
}

sub setInPenLanding(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPenLanding = $value;
	return ($field);
}

sub setInDamage(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDamage = $value;
	return ($field);
}

sub setInSbDamage(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSbDamage = $value;
	return ($field);
}

sub setInLbDamage(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLbDamage = $value;
	return ($field);
}

sub setClNotes(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClNotes = $value;
	return ($field);
}

sub setInLarge(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLarge = $value;
	return ($field);
}

sub setInSmall(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InSmall = $value;
	return ($field);
}

sub setInTof(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTof = $value;
	return ($field);
}

sub setInDistance(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDistance = $value;
	return ($field);
}

sub setBoInzone(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoInzone = $value;
	return ($field);
}

sub setBoApada(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoApada = $value;
	return ($field);
}

sub setBoAgtv(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoAgtv = $value;
	return ($field);
}

sub setInWaterFlt(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWaterFlt = $value;
	return ($field);
}

sub setInWatreDev(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWatreDev = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTodoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where FK_TODO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRound(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_ROUND=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where TX_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxColor(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where TX_COLOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLcargo(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_LCARGO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSphere(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_SPHERE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSpan(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_SPAN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDensity(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_DENSITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTime(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where TX_TIME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkWeatherIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where FK_WEATHER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTemp(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_TEMP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPres(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_PRES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRh(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_RH=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InElevation(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_ELEVATION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InColonist(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_COLONIST=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InHabitat(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_HABITAT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWater(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_WATER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InEmpty(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_EMPTY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPenMinor(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_PEN_MINOR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPenLanding(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_PEN_LANDING=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDamage(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_DAMAGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSbDamage(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_SB_DAMAGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLbDamage(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_LB_DAMAGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClNotes(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where CL_NOTES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLarge(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_LARGE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InSmall(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_SMALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTof(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_TOF=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDistance(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_DISTANCE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoInzone(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where BO_INZONE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoApada(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where BO_APADA=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoAgtv(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where BO_AGTV=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWaterFlt(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_WATER_FLT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWatreDev(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FLIGHT_IDX from TB_FLIGHT where IN_WATRE_DEV=?";
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

	my $SQL = "UPDATE TB_FLIGHT set FK_EVENT_IDX=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set FK_TEAM_IDX=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTodoIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set FK_TODO_IDX=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRound_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_ROUND=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set TX_STATUS=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxColor_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set TX_COLOR=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_STATUS=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set TS_CREATE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsUpdate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set TS_UPDATE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLcargo_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_LCARGO=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSphere_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_SPHERE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_WEIGHT=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSpan_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_SPAN=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDensity_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_DENSITY=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTime_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set TX_TIME=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkWeatherIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set FK_WEATHER_IDX=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTemp_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_TEMP=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPres_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_PRES=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRh_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_RH=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInElevation_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_ELEVATION=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInColonist_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_COLONIST=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInHabitat_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_HABITAT=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWater_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_WATER=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInEmpty_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_EMPTY=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPenMinor_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_PEN_MINOR=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPenLanding_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_PEN_LANDING=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDamage_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_DAMAGE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSbDamage_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_SB_DAMAGE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLbDamage_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_LB_DAMAGE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClNotes_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set CL_NOTES=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLarge_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_LARGE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInSmall_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_SMALL=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTof_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_TOF=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDistance_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_DISTANCE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoInzone_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set BO_INZONE=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoApada_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set BO_APADA=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoAgtv_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set BO_AGTV=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWaterFlt_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_WATER_FLT=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWatreDev_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT set IN_WATRE_DEV=? where PK_FLIGHT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkFlightIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET PK_FLIGHT_IDX=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET FK_EVENT_IDX=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET FK_TEAM_IDX=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTodoIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET FK_TODO_IDX=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRound_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_ROUND=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET TX_STATUS=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxColor_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET TX_COLOR=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_STATUS=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTsUpdate_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET TS_UPDATE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLcargo_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_LCARGO=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSphere_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_SPHERE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWeight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_WEIGHT=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSpan_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_SPAN=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDensity_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_DENSITY=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTime_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET TX_TIME=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkWeatherIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET FK_WEATHER_IDX=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTemp_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_TEMP=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPres_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_PRES=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRh_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_RH=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInElevation_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_ELEVATION=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInColonist_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_COLONIST=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInHabitat_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_HABITAT=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWater_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_WATER=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInEmpty_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_EMPTY=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPenMinor_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_PEN_MINOR=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPenLanding_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_PEN_LANDING=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDamage_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_DAMAGE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSbDamage_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_SB_DAMAGE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLbDamage_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_LB_DAMAGE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClNotes_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET CL_NOTES=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLarge_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_LARGE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInSmall_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_SMALL=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTof_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_TOF=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDistance_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_DISTANCE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoInzone_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET BO_INZONE=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoApada_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET BO_APADA=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoAgtv_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET BO_AGTV=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWaterFlt_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_WATER_FLT=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInWatreDev_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FLIGHT SET IN_WATRE_DEV=? where PK_FLIGHT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);
