package SAE::WEATHER;

use DBI;
use SAE::SDB;
use Math::BigFloat;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ===============================================================
# GET
# ===============================================================
sub _getWeatherByHours(){
    my $self = shift;
    my $location = shift;
    my $hours = shift;
    my $limit = $hours * 12;
    my $SQL = "SELECT * FROM TB_WEATHER WHERE FK_EVENT_IDX=? order by PK_WEATHER_IDX DESC LIMIT ?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location, $limit);
    my %HASH = %{$select->fetchall_hashref('PK_WEATHER_IDX')}; 
    return (\%HASH);
}
sub _getDensityAltitude(){
    my $self = shift;
    my $temp = shift;
    my $press = shift;
    my $DenAlt = &_calculateDensityAltitude($temp, $press);
    # my $Ps = 29.92126;
    # my $Ta = 459.7;
    # my $Tr = 518.7;
    # my $Patm = 145857.04;
    # my $log10 = log(($press / $Ps)/(($temp + $Ta)/$Tr))/log(10);
    # my $DenAlt = sprintf '%5.4f', $Patm * (1 - exp($log10 / 4.24117));
    # $str .= "pressure = ".($press / $Ps)."<br>";
    # $str .= "temp = ".(($temp + $Ta)/$Tr)."<br>";
    # $str .= "log = ".log(($press / $Ps)/(($temp + $Ta)/$Tr))/log(10)."<br>";
    # $str .= "Density = $DenAlt";
    return ($DenAlt);
}
sub _calculateDensityAltitude(){
    my $temp = shift;
    my $press = shift;
    # my  ($temp, $press) = @_;
    my $Ps = 29.92126;
    my $Ta = 459.7;
    my $Tr = 518.7;
    my $Patm = 145857.04;
    my $log10 = log(($press / $Ps)/(($temp + $Ta)/$Tr))/log(10);
    my $DenAlt = sprintf '%5.4f', $Patm * (1 - exp($log10 / 4.24117));
    return ($DenAlt);
}
sub _getEventDataById(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('PK_EVENT_IDX')}; 
    return (\%HASH);
}
# ===============================================================
# INSERT
# ===============================================================
sub _saveData(){
    my $self = shift;
    my $temp = shift;
    my $press = shift;
    my $time = shift;
    my $elev = shift;
    my $eventIDX = shift;
    my $den = &_calculateDensityAltitude($temp, $press);
    print " \$temp=$temp\t\$press=$press\t  \$time=$time\t  \$elev=$elev\t \$den=$den\t";
    my $SQL = "INSERT INTO TB_WEATHER (FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_DENSITY, IN_ELEVATION, TS_LOCAL) VALUES (?,?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($eventIDX, $temp, $press, $den, $elev, $time);

}
# ===============================================================
# UPDATE
# ===============================================================

# ===============================================================
# DELETE
# ===============================================================