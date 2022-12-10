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

	my $SQL = "INSERT INTO TB_WEATHER (FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL) values (?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $InTemp, $InPres, $InDensity, $InElevation, $TsLocal);
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
sub getAllRecordBy_PkWeatherIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE PK_WEATHER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTemp(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE IN_TEMP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InPres(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE IN_PRES=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InDensity(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE IN_DENSITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InElevation(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE IN_ELEVATION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TsLocal(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER WHERE TS_LOCAL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_WEATHER_IDX, FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL FROM TB_WEATHER";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_WEATHER_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where PK_WEATHER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkWeatherIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where PK_WEATHER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTemp(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where IN_TEMP=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InPres(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where IN_PRES=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InDensity(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where IN_DENSITY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InElevation(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where IN_ELEVATION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TsLocal(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_WEATHER where TS_LOCAL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

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
sub updatePkWeatherIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET PK_WEATHER_IDX=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET FK_EVENT_IDX=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTemp_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET IN_TEMP=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInPres_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET IN_PRES=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInDensity_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET IN_DENSITY=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInElevation_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET IN_ELEVATION=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTsLocal_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_WEATHER SET TS_LOCAL=? where PK_WEATHER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

