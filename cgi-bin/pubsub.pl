#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Cwd 'abs_path';

use SAE::TECH;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;

sub sae_genCrashReinspectionButton(){
    print $q->header();
    my $Tech = new SAE::TECH();
    my $teamIDX = $q->param('teamIDX');
    my $flightIDX = $q->param('flightIDX');
    my $todoIDX = $q->param('todoIDX');
    my $inStatus = $q->param('inStatus');
    my $btn = $Tech->_generateTechButton($todoIDX, $flightIDX, $teamIDX, $inStatus);
    return($btn);
}