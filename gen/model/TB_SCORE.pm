package SAE::TB_SCORE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreIdx;
my $FkTeamIdx;
my $FkPublishIdx;
my $TxFile;
my $InFlight;
my $InDesign;
my $InRaw;
my $InLate;
my $InPreso;
my $InPayload;
my $InPada;
my $InPenalty;
my $InOverall;
my $InRatio;
my $InBall;
my $InDistance;
my $InVolume;
my $InTime;
my $TsCreate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SCORE (FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $FkPublishIdx, $TxFile, $InFlight, $InDesign, $InRaw, $InLate, $InPreso, $InPayload, $InPada, $InPenalty, $InOverall, $InRatio, $InBall, $InDistance, $InVolume, $InTime);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME, TS_CREATE
		FROM TB_SCORE
		WHERE PK_SCORE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreIdx 		 = 	$HASH{PK_SCORE_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkPublishIdx 		 = 	$HASH{FK_PUBLISH_IDX};
	$TxFile 		 = 	$HASH{TX_FILE};
	$InFlight 		 = 	$HASH{IN_FLIGHT};
	$InDesign 		 = 	$HASH{IN_DESIGN};
	$InRaw 		 = 	$HASH{IN_RAW};
	$InLate 		 = 	$HASH{IN_LATE};
	$InPreso 		 = 	$HASH{IN_PRESO};
	$InPayload 		 = 	$HASH{IN_PAYLOAD};
	$InPada 		 = 	$HASH{IN_PADA};
	$InPenalty 		 = 	$HASH{IN_PENALTY};
	$InOverall 		 = 	$HASH{IN_OVERALL};
	$InRatio 		 = 	$HASH{IN_RATIO};
	$InBall 		 = 	$HASH{IN_BALL};
	$InDistance 		 = 	$HASH{IN_DISTANCE};
	$InVolume 		 = 	$HASH{IN_VOLUME};
	$InTime 		 = 	$HASH{IN_TIME};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkScoreIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE PK_SCORE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InFlight(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_FLIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDesign(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_DESIGN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRaw(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_RAW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLate(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_LATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPreso(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_PRESO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPayload(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_PAYLOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPada(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_PADA=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPenalty(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_PENALTY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOverall(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_OVERALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InRatio(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_RATIO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InBall(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_BALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDistance(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_DISTANCE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InVolume(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_VOLUME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTime(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE WHERE IN_TIME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX, FK_PUBLISH_IDX, TX_FILE, IN_FLIGHT, IN_DESIGN, IN_RAW, IN_LATE, IN_PRESO, IN_PAYLOAD, IN_PADA, IN_PENALTY, IN_OVERALL, IN_RATIO, IN_BALL, IN_DISTANCE, IN_VOLUME, IN_TIME FROM TB_SCORE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where PK_SCORE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkScoreIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where PK_SCORE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkPublishIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where FK_PUBLISH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFile(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where TX_FILE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InFlight(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_FLIGHT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDesign(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_DESIGN=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRaw(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_RAW=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLate(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_LATE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPreso(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_PRESO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPayload(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_PAYLOAD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPada(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_PADA=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPenalty(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_PENALTY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOverall(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_OVERALL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InRatio(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_RATIO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InBall(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_BALL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDistance(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_DISTANCE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InVolume(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_VOLUME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTime(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE where IN_TIME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkScoreIdx(){
	my ( $self ) = shift;
	return ($PkScoreIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkPublishIdx(){
	my ( $self ) = shift;
	return ($FkPublishIdx);
}

sub getTxFile(){
	my ( $self ) = shift;
	return ($TxFile);
}

sub getInFlight(){
	my ( $self ) = shift;
	return ($InFlight);
}

sub getInDesign(){
	my ( $self ) = shift;
	return ($InDesign);
}

sub getInRaw(){
	my ( $self ) = shift;
	return ($InRaw);
}

sub getInLate(){
	my ( $self ) = shift;
	return ($InLate);
}

sub getInPreso(){
	my ( $self ) = shift;
	return ($InPreso);
}

sub getInPayload(){
	my ( $self ) = shift;
	return ($InPayload);
}

sub getInPada(){
	my ( $self ) = shift;
	return ($InPada);
}

sub getInPenalty(){
	my ( $self ) = shift;
	return ($InPenalty);
}

sub getInOverall(){
	my ( $self ) = shift;
	return ($InOverall);
}

sub getInRatio(){
	my ( $self ) = shift;
	return ($InRatio);
}

sub getInBall(){
	my ( $self ) = shift;
	return ($InBall);
}

sub getInDistance(){
	my ( $self ) = shift;
	return ($InDistance);
}

sub getInVolume(){
	my ( $self ) = shift;
	return ($InVolume);
}

sub getInTime(){
	my ( $self ) = shift;
	return ($InTime);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkScoreIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkPublishIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkPublishIdx = $value;
	return ($field);
}

sub setTxFile(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFile = $value;
	return ($field);
}

sub setInFlight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InFlight = $value;
	return ($field);
}

sub setInDesign(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDesign = $value;
	return ($field);
}

sub setInRaw(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRaw = $value;
	return ($field);
}

sub setInLate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLate = $value;
	return ($field);
}

sub setInPreso(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPreso = $value;
	return ($field);
}

sub setInPayload(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPayload = $value;
	return ($field);
}

sub setInPada(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPada = $value;
	return ($field);
}

sub setInPenalty(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InPenalty = $value;
	return ($field);
}

sub setInOverall(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOverall = $value;
	return ($field);
}

sub setInRatio(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InRatio = $value;
	return ($field);
}

sub setInBall(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InBall = $value;
	return ($field);
}

sub setInDistance(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDistance = $value;
	return ($field);
}

sub setInVolume(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InVolume = $value;
	return ($field);
}

sub setInTime(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTime = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFile(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where TX_FILE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InFlight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_FLIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDesign(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_DESIGN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRaw(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_RAW=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLate(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_LATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPreso(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_PRESO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPayload(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_PAYLOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPada(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_PADA=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPenalty(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_PENALTY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOverall(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_OVERALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InRatio(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_RATIO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InBall(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_BALL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDistance(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_DISTANCE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InVolume(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_VOLUME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTime(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where IN_TIME=?";
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

	my $SQL = "UPDATE TB_SCORE set FK_TEAM_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkPublishIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_PUBLISH_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFile_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set TX_FILE=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInFlight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_FLIGHT=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDesign_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_DESIGN=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRaw_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_RAW=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_LATE=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPreso_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_PRESO=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPayload_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_PAYLOAD=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPada_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_PADA=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPenalty_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_PENALTY=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOverall_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_OVERALL=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInRatio_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_RATIO=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInBall_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_BALL=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDistance_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_DISTANCE=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInVolume_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_VOLUME=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTime_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set IN_TIME=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set TS_CREATE=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkScoreIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET PK_SCORE_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_TEAM_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkPublishIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET FK_PUBLISH_IDX=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFile_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET TX_FILE=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInFlight_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_FLIGHT=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDesign_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_DESIGN=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRaw_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_RAW=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLate_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_LATE=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPreso_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_PRESO=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPayload_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_PAYLOAD=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPada_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_PADA=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPenalty_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_PENALTY=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOverall_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_OVERALL=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInRatio_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_RATIO=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInBall_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_BALL=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDistance_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_DISTANCE=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInVolume_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_VOLUME=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTime_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE SET IN_TIME=? where PK_SCORE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

