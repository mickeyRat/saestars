#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use feature qw(switch);
use Cwd 'abs_path'; 
use JSON;
use URI::Escape;

# #---- SAE MODULES -------
use SAE::READ;

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
sub viewDocument(){
    print $q->header();
    my %DATA;
    my $fileID = $q->param('fileID');
    my $Read = new SAE::READ();
    my ($txFolder, $txPaper, $inNumber)= $Read->_getDocumentData($fileID);
    
    $DATA{TX_FOLDER} = $txFolder;
    $DATA{TX_PAPER} = $txPaper;
    $DATA{IN_NUMBER} = sprintf "%03d", $inNumber;
    
    my $json = encode_json \%DATA;
    return ($json);
    # return ($txFolder);
}