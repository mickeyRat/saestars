#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use JSON::XS;
use Try::Tiny;
use LWP::Simple;
use Mojo::DOM58;
use POSIX qw(tzset strftime);
use Data::Dump qw(dump);
use Data::Dumper::Concise;

use DBI;
# use SAE::WEATHER;[]
use Math::BigFloat;
use JSON qw(decode_json);;
use JSON::Parse 'assert_valid_json';
 


$dbName = "saestars_PROD";
$dbi = DBI->connect("dbi:mysql:$dbName:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect");

@ARGV;
my $pressure = 0;
my $station = $ARGV[1];
my $eventIDX = $ARGV[0];

my $in_per_mb = (1/33.86389);		
my $mb_per_in = 33.86389;
my $cp='067,111,112,121,114,105,103,104,116,032,049,057,057,056,045,050,048,049,050,032,082,105,099,104,097,114,100,032,083,104,101,108,113,117,105,115,116';			
my $m_per_ft = 0.304800;
my $ft_per_m = (1/0.304800);

my $elevation, $temp, $pressure, $humidity, $station, $windDir; 

%DATA = ();
%LOC = ('KTXFORTW400'=>'Fort Worth, TX', 'KCALOSAN310'=>'Van Nuys, CA','KFLLAKEL44'=>'Lakeland, FL');
%EVENT = ('KTXFORTW400'=>23, 'KCALOSAN310'=>24,'KFLLAKEL44'=>25);
%ELEV=('KTXFORTW400'=>705.4, 'KCALOSAN310'=>689.0,'KFLLAKEL44'=>121.4,'KCAVANNU14'=>689.0);
%TZONE=('KTXFORTW400'=>'America/Chicago', 'KCASHERM48'=>'America/Los_Angeles','KFLLAKEL44'=>'America/New_York');
# print $q->header;
# $URL = get("http://fuelgaugereport.aaa.com/import/display.php?lt=state&ls=");
# $URL = get("http://www.fortworthgasprices.com/Prices_Nationally.aspx");
# $URL = get("http://www.wunderground.com/q/zmw:76109.2.99999?MR=1");
# $URL = get("https://www.wunderground.com/personal-weather-station/dashboard?ID=KTXCROWL6"); # Benbrook

# $URL = get("https://www.wunderground.com/us/fl/lakeland/zmw:33811.6.99999");  #lakeland, FL

# $URL = get("https://www.wunderground.com/personal-weather-station/dashboard?ID=KTXFORTW400"); # Benbrook 
# $URL = get("https://www.wunderground.com/personal-weather-station/dashboard?ID=KCALOSAN310"); # Van Nuys
# $URL = get("https://www.wunderground.com/personal-weather-station/dashboard?ID=KCAVANNU14"); # Van Nuys
# $URL = get("https://www.wunderground.com/personal-weather-station/dashboard?ID=KFLLAKEL44"); # Lakeland
$URL = get("https://www.wunderground.com/personal-weather-station/dashboard?ID=KCASHERM48"); # Van Nuys

# nice -n19 ionice -c2 -n7 php /home/saeadmin/public_html/cron/benbrook.php
# perl /home/mysaesta/public_html/dev/cgi-bin/benbrook.pl

my $dom = Mojo::DOM58->new($URL);
# open(FH, '>./debug4.txt') or die $!;
# print "=" x 80 ."\n";
foreach $element ($dom->find('script[id="app-root-state"]')->each) {
    my $span = $element->at('span[class="wu-unit-pressure"]');
    # dump($element);
    # my $text = '\''.$element->text.'\'';
    my $text = $element->text;
    $text =~ s/\&q\;/\"/sgi;
    # print Dumper ($text);
    eval {assert_valid_json ($text)};
    # if ($@) {
    #     # print "Your JSON was invalid: $@\n";
    #     print "Your JSON was invalid: \n";
    # } else {
    #     print "Your JSON is VALID\n\n";
    # }
    try {$decoded = JSON::XS::decode_json($text)} catch {warn "Caught JSON::XS decode error $_\n$@\n\n"};
    # print FH JSON->new->ascii->pretty->encode(decode_json join '', $text);
    # print FH $text;
    my %DATA = %{$decoded};
    foreach $key (keys %{$DATA{'wu-next-state-key'}}){
        $url = $DATA{'wu-next-state-key'}{$key}{'url'};
        if ($url =~ m/current/){
            # print '=' x 80 ."\n";
            # print "key=$key\n";
            # print "URL: ".$DATA{'wu-next-state-key'}{$key}{'url'}."\n";
            $OBSERVATION = $DATA{'wu-next-state-key'}{$key}{'value'}{'observations'};
            # print "OBSERVATION: ".$OBSERVATION."\n";
            for my $hashref (@{$OBSERVATION}) {
                $windDir   = $hashref->{imperial}->{windSpeed}.'mph '.&_getDirection($hashref->{winddir});
                $elevation = $hashref->{imperial}->{elev};
                $temp      = $hashref->{imperial}->{temp};
                $pressure  = $hashref->{imperial}->{pressure};
                $humidity  = $hashref->{humidity};
                $station   = $hashref->{stationID};
                $epoch  = $hashref->{epoch};
                # printf "wind-dir: %s\n", $windDir;
                # print 'stationID: '.$station."\n";
                # printf "temperature: %2.2f deg F\n",$temp;
                # printf "pressure: %2.3f\n",$pressure;
                # printf "evevation: %2.3f\n",$elevation;
                # printf "humidity: %2.2f%\n", $humidity;
                # print 'epoch: '.$epoch."\n";
                # # printf "%d-%m-%Y-%H:%M:%S", ($epoch);
                # # print strftime("%m/%d/%Y %H:%M:%S",gmtime($epoch));
                # print strftime("%m/%d/%Y %H:%M:%S",localtime($epoch));
                # print "\n";
            }
            # print '_' x 80 ."\n\n\n";
        }
    }


    # print "\n===\n";
}

#print FH dump($dom->find('script[id="app-root-state"]')), ";\n";
# my $main = $dom->find('script[id="app-root-state"]');
# print $main->find('div["class=main-temp"]');
# print FH dump($dom->find('lib-tile-current-conditions')), ";\n";
# print FH $dom->find('script'), ";\n";

# close (FH);
# exit;
# print $spans."\n\n";
# my @stuff = ();
# for my $element ($dom->find('span[data-variable*=is-degree-visible')->each){
#     my $span = $element->at('span[class*=wu-value wu-value-to]');
#     if ($span){
#         push (@stuff,  $span->text);
#         # print $span->text."\n";
#     }
# }
# print "Temperature = $stuff[0]\n";
# print "Pressure = $stuff[6]\n";
# print "relative Humidity = $stuff[7]\n";
# exit;
$ENV{TZ} = $TZONE{$station};
tzset;
# my $now = localtime;
my ($sec, $min, $hr, $day, $mon, $year) = localtime;
# if ($hr>12){$hr=$hr-12}
my $now = sprintf("%04d-%02d-%02d %02d:%02d:%02d", 1900 + $year, $mon + 1, $day, $hr, $min, $sec);
printf "%25s = %-30s\n","Location",$station;
printf "%25s = %-20s\n", "Time is",$now;
# print "It is now $now\n";
# print "----\n";
my ($da) = &_densityAltitude($elevation, $temp, $pressure, $humidity);
# print "Density Altitude = $da\n";
printf "%25s = %-20.4f\n", "Density Altitude (ft)",$da;
printf "%25s = %-20s\n", "Database",$dbName;
# print "\$dbName = $dbName\n";

&_saveData($temp, $pressure, $humidity, $now, $elevation, $eventIDX, $da, $station, $windDir);

print "\ndone\n\n";
exit;
sub _getDirection(){
    my $dir = shift;
    if ($dir <= 22.5){
        return ('N');
    } elsif ($dir > 22.5  || $dir <= 67.5) {
        return ('NE');
    } elsif ($dir > 67.5  || $dir <= 112.5) {
        return ('E');
    } elsif ($dir >112.5 || $dir<=157.5) {
        return ('SE');
    } elsif ($dir >157.5 || $dir<=202.5) {
        return ('S');
    } elsif ($dir >202.5 || $dir<=247.5) {
        return ('SW');
    } elsif ($dir >247.5 || $dir<=292.5) {
        return ('W');
    } elsif ($dir >292.5 || $dir<=337.5) {
        return ('NW');
    } else {
        return ('N');
    }
}
sub _densityAltitude(){
    my ($ev, $tf, $p, $h) = @_;
    my $tc = (5/9) * ( $tf - 32 );
    # print "\n\n";
    # printf "-" x 75;
    # printf "\n%15s%15s%15s%15s%15s\n", 'Elev', 'temp','press','rh','den-Alt (ft)';
    # printf "-" x 75;

    my $esmb=&calcVaporPressure_wobus($tc);
    my $emb=$esmb*$h/100;
    my $zm = $ev*$m_per_ft;
    my $hm = &clacH($zm);
    my $actpressmb = &calcAs2Press(($p*$mb_per_in), $hm);
    my $density= &calcDensity($actpressmb, $emb, $tc);
    my $relden=100*($density/1.225);
    my $densaltm = &calcAltitude($density);
    my $densaltzm = &calcZ($densaltm);
    my $actpress=$actpressmb*$in_per_mb;    
	my $densaltz=$densaltzm*$ft_per_m;
# 	printf "\n%15.2f%15.2f%15.2f%15.2f%15.2f", $ev, $tf, $p, $h, $densaltz;
# 	print "\n\n";
#     printf "-" x 75;
#     print "\n";
    # print "\$esmb = $esmb\n";
    # print "\$emb = $emb\n";
    # print "\$hm = $hm\n";
    # print "\$actpressmb = $actpressmb\n";
    # print "\$density = $density\n";
    # print "\$relden = $relden\n";
    # print "\$densaltm = $densaltm\n";
    # print "\$densaltzm = $densaltzm\n";
    # print "\$actpress = $actpress\n";
    # print "\$densaltz = $densaltz\n";
    # print "\n\n";   
    return($densaltz);
}
# /usr/bin/perl /home/saestars/public_html/cgi-bin/w_dev.pl 29 KFLLAKEL44 >/dev/null 2>&1
# /usr/bin/perl /home/saestars/public_html/cgi-bin/weather.pl 29 KFLLAKEL44 >/dev/null 2>&1
# sub _getDensityAltitude(){
#     my $temp = shift;
#     my $press = shift;
#     my $DenAlt = &_calculateDensityAltitude($temp, $press);
#     return ($DenAlt);
# }
# sub _calculateDensityAltitude(){
#     my $temp = shift;
#     my $press = shift;
#     my $mult = 3.1459;
#     # my  ($temp, $press) = @_;
#     my $Ps = 29.92126;
#     my $Ta = 459.7;
#     my $Tr = 518.7;
#     my $Patm = 145857.04;
#     my $log10 = log(($press / $Ps)/(($temp + $Ta)/$Tr))/log(10);
#     my $DenAlt = sprintf '%5.4f', $Patm * (1 - exp($log10 / 4.24117));
#     return ($DenAlt*$mult);
# }

sub _saveData(){
    my $temp = shift;
    my $press = shift;
    my $rh = shift;
    my $time = shift;
    my $elev = shift;
    my $eventIDX = shift;
    my $den = shift;
    my $station = shift;
    my $wdir = shift;
    # my $den = &_calculateDensityAltitude($temp, $press);
    # print "\n\n";
    printf "-" x 111;
    printf "\n%15s%15s%15s%20s%15s%15s%15s\n", 'Temp', 'Pres','RH', 'Time','Elev','den-Alt (ft)','Wind Dir';
    printf "-" x 111;
    printf "\n%15.2f%15.2f%15.2f%20s%15.2f%15.2f%12s\n", $temp, $press, $rh, $time, $elev, $den, $wdir;
    # print " \$temp=$temp\t\$press=$press\t  \$time=$time\t  \$elev=$elev\t \$den=$den\t";
    my $SQL = "INSERT INTO TB_WEATHER (FK_EVENT_IDX, IN_TEMP, IN_PRES, IN_RH, IN_DENSITY, IN_ELEVATION, TS_LOCAL, TX_KEY, TX_WINDDIR) VALUES (?,?,?,?,?,?,?, ?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($eventIDX, $temp, $press, $rh, $den, $elev, $time, $station, $wdir);

}

sub calcAs2Press(){
    #  Calculate the actual pressure (mb)from the altimeter setting (mb) and geopotential altitude (m)
    my ($As, $h) = @_;
	my $k1=0.190263;
	my $k2=8.417286E-5;
    my $term1 = ($As**$k1) - ($k2*$h);
    my $term2 = 1/$k1;
    my $p = $term1**$term2;
	return ($p);
}
sub calcVaporPressure_wobus{
    # Calculate the saturation vapor pressure given the temperature(celsius)
    # Polynomial from Herman Wobus 
    my $t = shift;
    my $eso=6.1078;
	my $c0=0.99999683;
	my $c1=-0.90826951E-02;
	my $c2=0.78736169E-04;
	my $c3=-0.61117958E-06;
	my $c4=0.43884187E-08;
	my $c5=-0.29883885E-10;
	my $c6=0.21874425E-12;
	my $c7=-0.17892321E-14;
	my $c8=0.11112018E-16;
	my $c9=-0.30994571E-19;
	my $pol=$c0+$t*($c1+$t*($c2+$t*($c3+$t*($c4+$t*($c5+$t*($c6+$t*($c7+$t*($c8+$t*($c9)))))))));
	
	my $es=$eso/($pol**8);

	return ($es);
}
sub calcDensity() {
    # Calculate the air density in kg/m3
    my ($abspressmb, $e, $tc) = @_;
    my $Rv=461.4964;
	my $Rd=287.0531;
	
	my $tk=$tc+273.15;
	my $pv=$e*100;
	my $pd= ($abspressmb-$e)*100;
	my $d= ($pv/($Rv*$tk)) + ($pd/($Rd*$tk));
	
	return($d);
}
sub calcAltitude(){
    # Calculate the ISA altitude (meters) for a given density (kg/m3)
    my $d = shift;
	$g=9.80665;
	$Po=101325;
	$To=288.15;
	$L=6.5;
	$R=8.314320;
	$M=28.9644;
	
	$D=$d*1000;
	
	$p2=( ($L*$R)/($g*$M-$L*$R) )*log( ($R*$To*$D)/($M*$Po) );
	
	$H=-($To/$L)*( exp($p2)-1 );
	
	$h=$H*1000;

	return($h);
}
sub clacH(){
    # Calculate the H altitude (meters), given the Z altitide (meters)
    my $z = shift;
    my $r=6369E3;
	return (($r*$z)/($r+$z));
}
sub calcZ(h){
# // Calculate the Z altitude (meters), given the H altitide (meters)
    my $h = shift;
	my $r=6369E3;
	
	return (($r*$h)/($r-$h));
}
