#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI::Session;
use CGI::Cookie;
use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Mail::Sendmail;
# use HTML::Entities;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Common;
# use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::Auth;
use SAE::Tabulate;
use SAE::TB_SCORE;
use SAE::TB_CLASS;
use SAE::TB_PUBLISH;
# use SAE::TB_PENALTY_TEMP;
# use SAE::TB_EVENT;
# use SAE::TB_USER_EVENT;

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
sub __template(){
    print $q->header();
    my $str;
    my $location = $q->param('location');


    return ($str);
}
