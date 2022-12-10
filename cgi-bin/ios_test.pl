#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# use DateTime;
use Cwd 'abs_path';
use URI::Escape;
use JSON;
use POSIX qw(strftime);
my $now_string = strftime "%H:%M", localtime;
#---- SAE MODULES -------

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});


my $userID = $q->param(userId);
# print "Hello World\n";
# print "the POST userid is $userID\n";

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");
my %STATUS = (1=>"Good Flight", 3=>"Crashed", 2=>"No Fly");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;

sub ios_getTeam(){
    print $q->header();
    use SAE::TEAM;
    my $Team = new SAE::TEAM();
    my %TEAM = %{$Team->_getTeamList(31)};
    my $json = encode_json \%TEAM;
    $str = "in Get Team";
    return ($json)
}