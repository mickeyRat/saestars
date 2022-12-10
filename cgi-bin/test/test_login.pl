#!/usr/bin/perl
use cPanelUserConfig;
use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Cwd 'abs_path';

use SAE::Auth;


my $q = new CGI;
my $qs = new CGI($ENV{'QUERY_STRING'});
my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

print "\n\nPath = $path\n\n\a";
