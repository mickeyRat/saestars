#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use File::Basename;
# use CGI::Session;
# use CGI::Cookie;
# use LWP::Simple;
use DBI;
# use URI::Escape;
use Cwd 'abs_path';
# use JSON;

#---- SAE MODULES -------
use SAE::SDB;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

print $q->header();
my $fileName = $q->param('csvFile');

print "$fileName";
exit;
