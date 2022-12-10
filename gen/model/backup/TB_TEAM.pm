package SAE::TB_TEAM

use DBI
use SAE::SDB

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

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbTeamRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY
		FROM `saestars_DB`.`TB_TEAM`
		WHERE PK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkTeamIdx 		 => 	$HASH{PK_TEAM_IDX}
		,FkClassIdx 		 => 	$HASH{FK_CLASS_IDX}
		,FkCountryIdx 		 => 	$HASH{FK_COUNTRY_IDX}
		,InNumber 		 => 	$HASH{IN_NUMBER}
		,TxName 		 => 	$HASH{TX_NAME}
		,TxSchool 		 => 	$HASH{TX_SCHOOL}
		,InSlope 		 => 	$HASH{IN_SLOPE}
		,InYint 		 => 	$HASH{IN_YINT}
		,TxCode 		 => 	$HASH{TX_CODE}
		,TxReport 		 => 	$HASH{TX_REPORT}
		,TxTds 		 => 	$HASH{TX_TDS}
		,TxDrawing 		 => 	$HASH{TX_DRAWING}
		,FkEventIdx 		 => 	$HASH{FK_EVENT_IDX}
		,InTubeLength 		 => 	$HASH{IN_TUBE_LENGTH}
		,BoStatus 		 => 	$HASH{BO_STATUS}
		,BoCheckin 		 => 	$HASH{BO_CHECKIN}
		,InCapacity 		 => 	$HASH{IN_CAPACITY}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{PkTeamIdx});
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($self->{FkClassIdx});
}

sub getFkCountryIdx(){
	my ( $self ) = shift;
	return ($self->{FkCountryIdx});
}

sub getInNumber(){
	my ( $self ) = shift;
	return ($self->{InNumber});
}

sub getTxName(){
	my ( $self ) = shift;
	return ($self->{TxName});
}

sub getTxSchool(){
	my ( $self ) = shift;
	return ($self->{TxSchool});
}

sub getInSlope(){
	my ( $self ) = shift;
	return ($self->{InSlope});
}

sub getInYint(){
	my ( $self ) = shift;
	return ($self->{InYint});
}

sub getTxCode(){
	my ( $self ) = shift;
	return ($self->{TxCode});
}

sub getTxReport(){
	my ( $self ) = shift;
	return ($self->{TxReport});
}

sub getTxTds(){
	my ( $self ) = shift;
	return ($self->{TxTds});
}

sub getTxDrawing(){
	my ( $self ) = shift;
	return ($self->{TxDrawing});
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkEventIdx});
}

sub getInTubeLength(){
	my ( $self ) = shift;
	return ($self->{InTubeLength});
}

sub getBoStatus(){
	my ( $self ) = shift;
	return ($self->{BoStatus});
}

sub getBoCheckin(){
	my ( $self ) = shift;
	return ($self->{BoCheckin});
}

sub getInCapacity(){
	my ( $self ) = shift;
	return ($self->{InCapacity});
}


#------- BUILDING SETTERS------

sub setPkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkTeamIdx} = $value;
	return ($self->{PkTeamIdx});
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkClassIdx} = $value;
	return ($self->{FkClassIdx});
}

sub setFkCountryIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkCountryIdx} = $value;
	return ($self->{FkCountryIdx});
}

sub setInNumber(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InNumber} = $value;
	return ($self->{InNumber});
}

sub setTxName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxName} = $value;
	return ($self->{TxName});
}

sub setTxSchool(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxSchool} = $value;
	return ($self->{TxSchool});
}

sub setInSlope(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InSlope} = $value;
	return ($self->{InSlope});
}

sub setInYint(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InYint} = $value;
	return ($self->{InYint});
}

sub setTxCode(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxCode} = $value;
	return ($self->{TxCode});
}

sub setTxReport(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxReport} = $value;
	return ($self->{TxReport});
}

sub setTxTds(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxTds} = $value;
	return ($self->{TxTds});
}

sub setTxDrawing(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxDrawing} = $value;
	return ($self->{TxDrawing});
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkEventIdx} = $value;
	return ($self->{FkEventIdx});
}

sub setInTubeLength(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InTubeLength} = $value;
	return ($self->{InTubeLength});
}

sub setBoStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoStatus} = $value;
	return ($self->{BoStatus});
}

sub setBoCheckin(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoCheckin} = $value;
	return ($self->{BoCheckin});
}

sub setInCapacity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InCapacity} = $value;
	return ($self->{InCapacity});
}



return (1);

