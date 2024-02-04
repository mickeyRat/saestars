#!/usr/bin/perlml
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Cwd 'abs_path';
use CGI::Session;
use SAE::TEAM;
use SAE::Auth;
use File::Path qw(make_path);


my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});
my $Team = new SAE::TEAM();
my $Auth = new SAE::Auth();

my $teamIDX  = $q->param('teamIDX');
my $eventIDX = $q->param('eventIDX');
my $inNumber = $q->param('inNumber');
my $inPaper  = $q->param('paperIDX');
my $inYear   = $Team->_getEventYear($eventIDX);
my $txKeys   = $Auth->getTemporaryPassword(16);
my %PAPER    = (1=>'Design Report', 2=>'TDS', 3=>'Drawing');
$Team->_deleteUploadedFile($teamIDX, $inPaper);
print $q->header();
    my $filename = $q->param('filename');
    my $type = $q->uploadInfo($filename)->{'Content-Type'};
    my $file_handle = $q->upload('filename');
    my $regex = qr/[\{\(\)#]/mp;
    my $subst = '-';
    # my $newfileName = $filename =~ s/$regex/$subst/rg;
    my $newfileName = sprintf "Team_%03d-%s", $inNumber, $PAPER{$inPaper}; # $Auth->getTemporaryPassword(16);
    my $newDirectory = sprintf "../uploads/%d/%d/%d", $inYear, $eventIDX, $inNumber;

    if (!-e $newDirectory){
        make_path($newDirectory);
    }
    my $newPath = "$newDirectory/$newfileName";
    open (OUTFILE,">$newPath");
    
   
    while(<$file_handle>) {              
        print OUTFILE $_;
    }
    close($file_handle);                        
    close(OUTFILE); 

# $self, teamIDX, $inNumber, $eventIDX, $txKeys, $txFilename, $txType, $txPaper, $inPaper, $txFolder

my $str = $Team->_saveUploadData($teamIDX, $inNumber, $eventIDX, $txKeys, $newfileName, $type, $PAPER{$inPaper}, $inPaper, $newPath);
   $str .= sprintf '<a href="read.html?fileID=%s" target="_blank">%s</a>', $txKeys, $newfileName;
# my $str = sprintf '%s has been successfully uploaded... %s', $filename, $newPath;  
# $str .= '<br>';
# $str .="type = $type";
# $str .= '<br>';
# $str .="eventIDX = $eventIDX";
# $str .= '<br>';
# $str .="teamIDX = $teamIDX";
# $str .= '<br>';
# $str .="inNumber = $inNumber";
print $str;

#  use CGI;
#  my $cgi = new CGI;
#  my $dir = 'sub';
#  my $file = $cgi->param('file');
#  $file=~m/^.*(\\|\/)(.*)/;
#  # strip the remote path and keep the filename
#  my $name = $2;
#  open(LOCAL, ">$dir/$name") or print 'error';
#  my $file_handle = $cgi->upload('file');     // get the handle, not just the filename
#  while(<$file_handle>) {               // use that handle
#     print LOCAL $_;
#  }
#  close($file_handle);                        // clean the mess
#  close(LOCAL);                               // 
#  print $cgi->header();
#  print $dir/$name;
#  print "$file has been successfully uploaded... thank you.\n";enter code here