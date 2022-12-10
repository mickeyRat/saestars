#!/usr/bin/perlml
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
use cPanelUserConfig;

use CGI::Session;
my $session = CGI::Session->new();
print $session->id();
