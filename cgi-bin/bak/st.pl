#!/usr/bin/perl
use cPanelUserConfig;
#
use Google::Voice;
use Getopt::Long;
use strict;
#
# # Set your login info here!
my $username = 'lonnie.dong@gmail.com';
my $password = "ga2TX2013";
#

#Do Not Edit Below Here!
my ($help_opt, $phone_opt, $text_opt);
GetOptions("h|help"     => \$help_opt,
           "p|phone=s"  => \$phone_opt,
           "t|text=s"   => \$text_opt,
          );
die <<HELP_MSG
sendtext.pl -p <phone_number> -t <text message>

usage:  -h     this help message
        -p     phone number you want to send to
        -t     text message to send
HELP_MSG
    #show help message if user types -h or does not include
    #phone number or text message text
    if (! $phone_opt or ! $text_opt or $help_opt);

#create Google::Voice object and login
my $gv_obj = Google::Voice->new->login($username, $password) || die "Failed!!!";

#send the text!
$gv_obj->send_sms($phone_opt => $text_opt);
