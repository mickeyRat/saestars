package SAE::TB_WEATHER

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkWeatherIdx;
my $FkEventIdx;
my $InTemp;
my $InPres;
my $InDensity;
my $InElevation;
my $TsCreate;
my $TsLocal;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbWeatherRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_CREATE, TS_LOCAL
		FROM `saestars_DB`.`TB_WEATHER`
		WHERE PK_WEATHER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkWeatherIdx 		 => 	$HASH{PK_WEATHER_IDX}
		,FkEventIdx 		 => 	$HASH{FK_EVENT_IDX}
		,InTemp 		 => 	$HASH{IN_TEMP}
		,InPres 		 => 	$HASH{IN_PRES}
		,InDensity 		 => 	$HASH{IN_DENSITY}
		,InElevation 		 => 	$HASH{IN_ELEVATION}
		,TsCreate 		 => 	$HASH{TS_CREATE}
		,TsLocal 		 => 	$HASH{TS_LOCAL}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkWeatherIdx(){
	my ( $self ) = shift;
	return ($self->{PkWeatherIdx});
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkEventIdx});
}

sub getInTemp(){
	my ( $self ) = shift;
	return ($self->{InTemp});
}

sub getInPres(){
	my ( $self ) = shift;
	return ($self->{InPres});
}

sub getInDensity(){
	my ( $self ) = shift;
	return ($self->{InDensity});
}

sub getInElevation(){
	my ( $self ) = shift;
	return ($self->{InElevation});
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($self->{TsCreate});
}

sub getTsLocal(){
	my ( $self ) = shift;
	return ($self->{TsLocal});
}


#------- BUILDING SETTERS------

sub setPkWeatherIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkWeatherIdx} = $value;
	return ($self->{PkWeatherIdx});
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkEventIdx} = $value;
	return ($self->{FkEventIdx});
}

sub setInTemp(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InTemp} = $value;
	return ($self->{InTemp});
}

sub setInPres(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InPres} = $value;
	return ($self->{InPres});
}

sub setInDensity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InDensity} = $value;
	return ($self->{InDensity});
}

sub setInElevation(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InElevation} = $value;
	return ($self->{InElevation});
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsCreate} = $value;
	return ($self->{TsCreate});
}

sub setTsLocal(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsLocal} = $value;
	return ($self->{TsLocal});
}



return (1);

