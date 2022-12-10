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
use Spreadsheet::ParseXLSX;
use SAE::PRESO;


my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});
print $q->header();
my $userIDX = $q->param('userIDX');
my $eventIDX = $q->param('eventIDX');
my $Team = new SAE::TEAM();
my $Auth = new SAE::Auth();
my %TEAM = %{$Team->_getTeamNumberReference($eventIDX)};
my $inYear = $Team->_getEventYear($eventIDX);
# print "\$userIDX = $userIDX<br>";
# print "\$eventIDX = $eventIDX<br>";
# foreach $inNumber (sort keys %TEAM){
#     print "$inNumber<br>";
# }

$Team->_deleteUploadedFile($teamIDX, $inPaper);
    my $filename = $q->param('filename');
    my $type = $q->uploadInfo($filename)->{'Content-Type'};
    my $file_handle = $q->upload('filename');
    my $regex = qr/[\{\(\)#]/mp;
    my $subst = '-';
    my $newfileName = $filename =~ s/$regex/$subst/rg;

    my $newDirectory = sprintf "../uploads/%d/presoScores/%d", $inYear, $userIDX;
    if (!-e $newDirectory){
        mkdir($newDirectory, 0755) || die $_;
        print "Does not exist... Making Directory<br>";
    }
    my $newPath = "$newDirectory/$newfileName";
    open (OUTFILE,">$newPath");
    while(<$file_handle>) {              
        print OUTFILE $_;
    }
    close($file_handle);                        
    close(OUTFILE); 

# print $newDirectory
my $Preso = new SAE::PRESO();

    my $filename = $newPath;
    my $str;
    my $parser = Spreadsheet::ParseXLSX->new();
    my $workbook = $parser->parse("$filename");
    my $worksheet_count = $workbook->worksheet_count();
    # print "\$worksheet_count =$worksheet_count\n";
    # my $worksheet = $workbook->worksheet(0);
    @ROW = (2,4,6,8,10, 12, 14, 16, 18, 19, 20);
    for my $worksheet ( $workbook->worksheets() ) {
        my $worksheetName = $worksheet->get_name();
        my $inNumber = $worksheet->get_cell(0,2)->value();
        my $teamIDX = $TEAM{$inNumber}{PK_TEAM_IDX};
        $str .= "-" x 50;
        $str .= "<br>";
        $str .= sprintf "Team Number = %03d<br>", $inNumber;
        $str .= sprintf "Team IDX = %d<br>", $teamIDX;
        my $cardIDX=$Preso->_addPresentationScoreCard($userIDX, $teamIDX, 5, $eventIDX);
        foreach $row (@ROW){
            my $key = $worksheet->get_cell( $row, 0)->value();
            my $value = $worksheet->get_cell( $row, 2)->value();
            my $comments = $worksheet->get_cell( $row, 3)->value();
            if ($value == 'Yes'){$value = 1} 
            $Preso->_saveAssessmentLineItem($cardIDX, $key, $value*10);
            if ($comments){
              $Preso->_saveAssessmentLineComment($cardIDX, $key, $teamIDX, $userIDX, $comments);
              $str .= "comments: $comments<br>";
            }
            $str .= sprintf "%d =\t %2.1f:\t%s<br>", $key, $value, $comments;

        }
    
    }


print $str;
