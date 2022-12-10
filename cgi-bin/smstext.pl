#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
use Google::Voice;
use Mojo::UserAgent;
use Mojo::JSON;
use IO::Socket::SSL 1.37;
use Mojo::Base - base;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

# $q = new CGI;
# $qs = new CGI($ENV{'QUERY_STRING'});

# print $q->header();

my $email_address = 'lonnie.dong@gmail.com';
my $password = "ga2TX2013";

# print $@ if !$g = Google::Voice->new->login($email_address, $password);
my $g = Google::Voice->new->login('lonnie.dong\@gmail.com', 'ga2TX2013') || die "$@";

$g->send_sms('8176015383'=>'Hello friend!');

# print $@ if !$g->send_sms('invalid phone' => 'text message');



# print $q->header();

# my $g = Google::Voice->new->login($email_address, $password) || die "Test cannot continue Error= $email_address".$@;

# my $message = "Hello World\nThis is a test";
# my $phone_number = "6785214477";

# $sender->send_sms($phone_number => $message);

print "test";