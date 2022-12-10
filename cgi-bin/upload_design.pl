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
# use SAE::PRESO;
use SAE::DESIGN;
use SAE::REPORTS;
use SAE::GRADE;


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

$Team->_deleteUploadedFile($teamIDX, $inPaper);
    my $filename = $q->param('filename');
    my $type = $q->uploadInfo($filename)->{'Content-Type'};
    my $file_handle = $q->upload('filename');
    my $regex = qr/[\{\(\)#]/mp;
    my $subst = '-';
    my $newfileName = $filename =~ s/$regex/$subst/rg;

    my $newDirectory = sprintf "../uploads/%d/designScores/%d", $inYear, $userIDX;
    # print $newDirectory."<br>";
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
my $Design = new SAE::DESIGN();

    my $filename = $newPath;
    my $str;
    my $parser = Spreadsheet::ParseXLSX->new();
    my $workbook = $parser->parse("$filename");
    my $worksheet_count = $workbook->worksheet_count();
    my $Reports = new SAE::REPORTS();
    my $Grade = new SAE::GRADE();

    for my $worksheet ( $workbook->worksheets() ) {
        my $worksheetName = $worksheet->get_name();
        my $inNumber = $worksheet->get_cell(1,3)->value();
        if ($inNumber != '' || $inNumber>0){
            my $lastRow = 18;
            if ($inNumber>300){
                $lastRow = 19;
            } elsif ($inNumber>200) {
                $lastRow = 20;
            } else {
                $lastRow = 18
            }
            my $teamIDX = $TEAM{$inNumber}{PK_TEAM_IDX};
            my $cardIDX = $Design->_getCardIDX($teamIDX, $userIDX);
            $Grade->_clearPreviousGrades($cardIDX);
            $str .= "-" x 50;
            $str .= "<br>";
            $str .= sprintf "Team Number = %03d<br>", $inNumber;
            $str .= sprintf "Team IDX = %d<br>", $teamIDX;
            $str .= sprintf "User IDX = %d<br>", $userIDX;
            $str .= sprintf "CARD IDX = %d<br>", $cardIDX;
    
            for ($row=3; $row<=$lastRow; $row++){
                my $key = $worksheet->get_cell( $row, 0)->value();
                my $inValue = $worksheet->get_cell( $row, 3)->value();
                $Grade->_saveImportedGrades($cardIDX, $key, $inValue);
                my $comments = $worksheet->get_cell( $row, 4 )->value();
                if ($comments){
                    my $commentIDX = $Reports->_postComments($cardIDX, $key, $userIDX, $comments, $teamIDX);
                }
                $str .= sprintf "%d =\t %2.1f:\t%s<br>", $key, $inValue, $comments;
            }
            $Grade->_updateCardStatus($cardIDX, 2);
        } else {
            next;
        }
    
    }


print $str;
