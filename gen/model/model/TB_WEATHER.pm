package SAE::TB_WEATHER;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_WEATHER () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_CREATE, TS_LOCAL
		FROM TB_WEATHER
		WHERE PK_WEATHER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkWeatherIdx 		 = 	$HASH{PK_WEATHER_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InTemp 		 = 	$HASH{IN_TEMP};
	$InPres 		 = 	$HASH{IN_PRES};
	$InDensity 		 = 	$HASH{IN_DENSITY};
	$InElevation 		 = 	$HASH{IN_ELEVATION};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$TsLocal 		 = 	$HASH{TS_LOCAL};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkWeatherIdx(){
	my ( $self ) = shift;
	return ($PkWeatherIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInTemp(){
	my ( $self ) = shift;
	return ($InTemp);
}

sub getInPres(){
	my ( $self ) = shift;
	return ($InPres);
}

sub getInDensity(){
	my ( $self ) = shift;
	return ($InDensity);
}

sub getInElevation(){
	my ( $self ) = shift;
	return ($InElevation);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getTsLocal(){
	my ( $self ) = shift;
	return ($TsLocal);
}


#------- BUILDING SETTERS------

sub setPkWeatherIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkWeatherIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
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

sub setInDensity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InDensity = $value;
	return ($field);
}

sub setInElevation(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InElevation = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setTsLocal(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsLocal = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_WEATHER_IDX from TB_WEATHER where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTemp(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_WEATHER_IDX from TB_WEATHER where IN_TEMP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InPres(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_WEATHER_IDX from TB_WEATHER where IN_PRES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InDensity(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_WEATHER_IDX from TB_WEATHER where IN_DENSITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InElevation(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_WEATHER_IDX from TB_WEATHER where IN_ELEVATION=?";
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

	my $SQL = "UPDATE TB_WEATHER set FK_EVENT_IDX=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTemp_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER set IN_TEMP=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInPres_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER set IN_PRES=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInDensity_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER set IN_DENSITY=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInElevation_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER set IN_ELEVATION=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER set TS_CREATE=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsLocal_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER set TS_LOCAL=? where PK_WEATHER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

