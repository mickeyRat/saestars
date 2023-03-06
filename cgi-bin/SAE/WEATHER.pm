package SAE::WEATHER;

use DBI;
use SAE::SDB;
use Math::BigFloat;

my ($dbi, $dbName) = new SAE::Db();

my $in_per_mb = (1/33.86389);		
my $mb_per_in = 33.86389;
my $cp='067,111,112,121,114,105,103,104,116,032,049,057,057,056,045,050,048,049,050,032,082,105,099,104,097,114,100,032,083,104,101,108,113,117,105,115,116';			
my $m_per_ft = 0.304800;
my $ft_per_m = (1/0.304800);

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ===============================================================
# UPDATED DENSITY CALCULATION - Added Relative Humidity
# ===============================================================
# sub saveData(){
    
# }
# sub _densityAltitude(){
#     my ($self, $ev, $tf, $p, $h) = @_;
#     my $tc = (5/9) * ( $tf - 32 );
#     # print "\n\n";
#     # printf "-" x 75;
#     # printf "\n%15s%15s%15s%15s%15s\n", 'Elev', 'temp','press','rh','den-Alt (ft)';
#     # printf "-" x 75;

#     my $esmb=&calcVaporPressure_wobus($tc);
#     my $emb=$esmb*$h/100;
#     my $zm = $ev*$m_per_ft;
#     my $hm = &clacH($zm);
#     my $actpressmb = &calcAs2Press(($p*$mb_per_in), $hm);
#     my $density= &calcDensity($actpressmb, $emb, $tc);
#     my $relden=100*($density/1.225);
#     my $densaltm = &calcAltitude($density);
#     my $densaltzm = &calcZ($densaltm);
#     my $actpress=$actpressmb*$in_per_mb;    
# 	my $densaltz=$densaltzm*$ft_per_m;
# # 	printf "\n%15.2f%15.2f%15.2f%15.2f%15.2f", $ev, $tf, $p, $h, $densaltz;
# # 	print "\n\n";
# #     printf "-" x 75;
# #     print "\n";
#     # print "\$esmb = $esmb\n";
#     # print "\$emb = $emb\n";
#     # print "\$hm = $hm\n";
#     # print "\$actpressmb = $actpressmb\n";
#     # print "\$density = $density\n";
#     # print "\$relden = $relden\n";
#     # print "\$densaltm = $densaltm\n";
#     # print "\$densaltzm = $densaltzm\n";
#     # print "\$actpress = $actpress\n";
#     # print "\$densaltz = $densaltz\n";
#     # print "\n\n";   
#     return($densaltz);
# }

# sub calcAs2Press(){
#     #  Calculate the actual pressure (mb)from the altimeter setting (mb) and geopotential altitude (m)
#     my ($As, $h) = @_;
# 	my $k1=0.190263;
# 	my $k2=8.417286E-5;
#     my $term1 = ($As**$k1) - ($k2*$h);
#     my $term2 = 1/$k1;
#     my $p = $term1**$term2;
# 	return ($p);
# }
# sub calcVaporPressure_wobus{
#     # Calculate the saturation vapor pressure given the temperature(celsius)
#     # Polynomial from Herman Wobus 
#     my $t = shift;
#     my $eso=6.1078;
# 	my $c0=0.99999683;
# 	my $c1=-0.90826951E-02;
# 	my $c2=0.78736169E-04;
# 	my $c3=-0.61117958E-06;
# 	my $c4=0.43884187E-08;
# 	my $c5=-0.29883885E-10;
# 	my $c6=0.21874425E-12;
# 	my $c7=-0.17892321E-14;
# 	my $c8=0.11112018E-16;
# 	my $c9=-0.30994571E-19;
# 	my $pol=$c0+$t*($c1+$t*($c2+$t*($c3+$t*($c4+$t*($c5+$t*($c6+$t*($c7+$t*($c8+$t*($c9)))))))));
	
# 	my $es=$eso/($pol**8);

# 	return ($es);
# }
# sub calcDensity() {
#     # Calculate the air density in kg/m3
#     my ($abspressmb, $e, $tc) = @_;
#     my $Rv=461.4964;
# 	my $Rd=287.0531;
	
# 	my $tk=$tc+273.15;
# 	my $pv=$e*100;
# 	my $pd= ($abspressmb-$e)*100;
# 	my $d= ($pv/($Rv*$tk)) + ($pd/($Rd*$tk));
	
# 	return($d);
# }
# sub calcAltitude(){
#     # Calculate the ISA altitude (meters) for a given density (kg/m3)
#     my $d = shift;
# 	$g=9.80665;
# 	$Po=101325;
# 	$To=288.15;
# 	$L=6.5;
# 	$R=8.314320;
# 	$M=28.9644;
	
# 	$D=$d*1000;
	
# 	$p2=( ($L*$R)/($g*$M-$L*$R) )*log( ($R*$To*$D)/($M*$Po) );
	
# 	$H=-($To/$L)*( exp($p2)-1 );
	
# 	$h=$H*1000;

# 	return($h);
# }
# sub clacH(){
#     # Calculate the H altitude (meters), given the Z altitide (meters)
#     my $z = shift;
#     my $r=6369E3;
# 	return (($r*$z)/($r+$z));
# }
# sub calcZ(h){
# # // Calculate the Z altitude (meters), given the H altitide (meters)
#     my $h = shift;
# 	my $r=6369E3;
	
# 	return (($r*$h)/($r-$h));
# }
# ===============================================================
# GET
# ===============================================================

sub _getSelectedWeather(){
    my $self = shift;
    my $weatherIDX = shift;
    # my $SQL = "SELECT PK_WEATHER_IDX, DATE_FORMAT(TS_CREATE, '%r - %W %c/%e') AS TS_LOCAL FROM TB_WEATHER WHERE PK_WEATHER_IDX=?";
    my $SQL = "SELECT PK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_DENSITY, DATE_FORMAT(TS_LOCAL, '%r - %W %c/%e') AS TS_LOCAL, TS_CREATE FROM TB_WEATHER WHERE PK_WEATHER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($weatherIDX);
    my %HASH = %{$select->fetchall_hashref('PK_WEATHER_IDX')}; 
    return (\%HASH);
}
sub _getWeatherByHours(){
    my $self = shift;
    my $location = shift;
    my $hours = shift;
    my $limit = $hours * 12;
    my $SQL = "SELECT PK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_RH, IN_ELEVATION, IN_DENSITY, DATE_FORMAT(TS_LOCAL, '%r - %W %c/%e') AS TS_LOCAL, TS_CREATE, IN_EPOCH, TX_WINDDIR FROM TB_WEATHER WHERE FK_EVENT_IDX=? ORDER BY PK_WEATHER_IDX DESC LIMIT ?";
    # my $SQL = "SELECT PK_WEATHER_IDX, IN_TEMP, IN_PRES, IN_DENSITY, DATE_FORMAT(TS_LOCAL, '%r - %W %c/%e') AS TS_LOCAL, TS_CREATE FROM TB_WEATHER WHERE FK_EVENT_IDX=? ORDER BY PK_WEATHER_IDX DESC LIMIT ?";
    # my $SQL = "SELECT * FROM (SELECT PK_WEATHER_IDX, TS_LOCAL FROM TB_WEATHER where FK_EVENT_IDX=? ORDER BY PK_WEATHER_IDX DESC LIMIT ?) Q";
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