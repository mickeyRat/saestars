#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use LWP::Simple;
use Mojo::DOM58;
use POSIX qw(tzset);

use DBI;
use Math::BigFloat;

my $tempC = 78;
my $rh = 84;
my $press = 30.09;


my $esmb = &calcVaporPressure_wobus($tempC);
my $emb  =   $esmb*($rh/100)  ;
# my $den = &calDensity($press, $emb, $tempC);
# my $height = & calAltitude($den);

print "\$esmb=$esmb\n";
# print "Density = " + $den;
# print "\n";
# print "Height = " + $height;
# print "\n";
# print &calcVaporPressure_wobus($tempC)."\n";


exit;
sub calcAs2Press()
// Calculate the actual pressure (mb)from the altimeter setting (mb) and geopotential altitude (m)
{
    my ($As, $h) = @_;
    my $k1=0.190263;
    my $k2=8.417286E-5;
    
    # my $p=Math.pow( (Math.pow($As,$k1)-($k2*$h)),(1/$k1) );
    # my $p=Math.pow( (Math.pow($As,$k1)-($k2*$h)),(1/$k1) );
    my $p1 = $As**$k1;
    my $p = $p1-($k2*$h)**(1/$k1)
	return ($p);
}
sub calAltitude(){
    my $den = shift;
    my $g=9.80665;
    my $Po=101325;
    my $To=288.15;
    my $L=6.5;
    my $R=8.314320;
    my $M=28.9644;
    my $D=$den*1000;
    my $p2=( ($L*$R)/($g*$M-$L*$R) )*log( ($R*$To*$D)/($M*$Po) );
    my $H=-($To/$L)*( exp($p2)-1 );
    my $h=$H*1000;
    return($h);
}
# function calcAltitude(d)
# // Calculate the ISA altitude (meters) for a given density (kg/m3)
# {
#         var g=9.80665;
#         var Po=101325;
#         var To=288.15;
#         var L=6.5;
#         var R=8.314320;
#         var M=28.9644;
        
#         var D=d*1000;
        
#         var p2=( (L*R)/(g*M-L*R) )*Math.log( (R*To*D)/(M*Po) );
        
#         var H=-(To/L)*( Math.exp(p2)-1 );
        
#         var h=H*1000;

#         return(h);
# }
sub calDensity(){
    my ($absPress, $emb, $tc) = @_;
    my $Rv=461.4964;
    my $Rd=287.0531;
    
    my $tk=$tc+273.15;
    my $pv=$emb*100;
    my $pd= ($absPress-$emb)*100;
    my $d = ($pv/($Rv*$tk)) + ($pd/($Rd*$tk));
    return($d);
}

# function calcDensity(abspressmb, e, tc)
# //  Calculate the air density in kg/m3
# {
#         var Rv=461.4964;
#         var Rd=287.0531;
        
#         var tk=tc+273.15;
#         var pv=e*100;
#         var pd= (abspressmb-e)*100;
#         var d= (pv/(Rv*tk)) + (pd/(Rd*tk));
#         return(d);
# }


# var esmb=calcVaporPressure_wobus(tc);
# 	var emb=esmb*rh/100;
sub calcVaporPressure_wobus(){
    my $t =shift;
	my $eso = 6.1078;
	my $es;
	my $c0 = 0.99999683;
	my $c1 = -0.90826951e-02;
	my $c2 = 0.78736169e-04;
	my $c3 = -0.61117958e-06;
	my $c4 = 0.43884187e-08;
	my $c5 = -0.29883885e-10;
	my $c6 = 0.21874425e-12;
	my $c7 = -0.17892321e-14;
	my $c8 = 0.11112018e-16;
	my $c9 = -0.30994571e-19;
	
	my $pol=$c0+$t*($c1+$t*($c2+$t*($c3+$t*($c4+$t*($c5+$t*($c6+$t*($c7+$t*($c8+$t*($c9)))))))));
	
	$es=$eso/($pol**8);

	return ($es);
}