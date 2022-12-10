#!/usr/bin/perl
use cPanelUserConfig;

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

use Google::Voice;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

print $q->header();
my $username    = 'lonnie.dong@gmail.com';
my $password    = "ga2TX2013";

my $g = Google::Voice->new->login($username, $password) || die "Test cannot continue Error= $username".$@;

# print $g;

# $g->send_sms(+16785214477 => 'Hello friend!') || print $@;
# print $@ if !$g->send_sms('invalid phone' => 'text message');

print "test";

#
# use Google::Voice;
# use Getopt::Long;
# use strict;

#Set your login info here!


#Do Not Edit Below Here!

# my ($help_opt, $phone_opt, $text_opt);
# GetOptions("h|help"     => \$help_opt,
#        "p|phone=s"  => \$phone_opt,
#            "t|text=s"   => \$text_opt,
#           );
# die <<HELP_MSG
# sendtext.pl -p <phone_number> -t <text message>
#
# usage:  -h     this help message
#         -p     phone number you want to send to
#         -t     text message to send
# HELP_MSG
#     #show help message if user types -h or does not include
#     #phone number or text message text
#     if (! $phone_opt or ! $text_opt or $help_opt);
#
#create Google::Voice object and login
# my $gv_obj = Google::Voice->new->login($username, $password);
#
# #send the text!
# $gv_obj->send_sms($phone_opt => $text_opt);
