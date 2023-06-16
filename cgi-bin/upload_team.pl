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
# use SAE::DESIGN;
# use SAE::REPORTS;
# use SAE::GRADE;


my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});
print $q->header();
# my $userIDX = $q->param('userIDX');
my $eventIDX = $q->param('eventIDX');
my $startRow = $q->param('header');
my $Team = new SAE::TEAM();
my $Auth = new SAE::Auth();


my $inYear = $Team->_getEventYear($eventIDX);

    my $filename = $q->param('filename');
    my $type = $q->uploadInfo($filename)->{'Content-Type'};
    my $file_handle = $q->upload('filename');
    my $regex = qr/[\{\(\)#]/mp;
    my $subst = '-';
    my $newfileName = $filename =~ s/$regex/$subst/rg;

    my $newDirectory = sprintf "../uploads/%d/team/", $inYear;
    
    if (!-e $newDirectory){
        # mkdir($newDirectory, 0755) || die "$!";
        mkdir($newDirectory, 0755) || die $_;
        print "Does not exist... Making Directory<br>";
    }
    my $newPath = "$newDirectory$newfileName";
    open (OUTFILE,">$newPath");
    while(<$file_handle>) {              
        print OUTFILE $_;
    }
    close($file_handle);                        
    close(OUTFILE); 

    print $newDirectory."<br>";

my %COUNTRY = %{$Team->_getListOfCountries()};

    my $filename = $newPath;
    print $newPath."<br>";
    my $str;
    my $parser = Spreadsheet::ParseXLSX->new();
    my $workbook = $parser->parse("$filename");
    if ( !defined $workbook ) {
        die $parser->error(), "<br>";
    }
    my $worksheet = $workbook->worksheet(0);
    my ( $row_min, $row_max ) = $worksheet->row_range();
    # print "\$row_max = $row_max<br>";
    my %DATA;
    for ($row=$startRow; $row<=$row_max; $row++){
        my $class = 1;
        my $inNumber  = $worksheet->get_cell( $row, 0)->value();
        my $txSchool  = $worksheet->get_cell($row,1)->value();
        my $txName    = $worksheet->get_cell($row,2)->value();
        my $txCountry = $worksheet->get_cell($row,3)->value();
        my $countryIDX = $COUNTRY{$txCountry}{PK_COUNTRY_IDX};
        if ($inNumber > 300) {
            $class = 3;
        } elsif ($inNumber > 200) {
            $class = 2;
        } else {
            $class = 1;
        }
        
        if (!$COUNTRY{$txCountry}){
            $countryIDX = $Team->_addCountry($txCountry);
        } 
        $DATA{$inNumber}{IN_NUMBER} = $inNumber;
        $DATA{$inNumber}{TX_SCHOOL} = $txSchool;
        $DATA{$inNumber}{TX_NAME} = $txName;
        $DATA{$inNumber}{FK_CLASS_IDX} = $class;
        $DATA{$inNumber}{FK_COUNTRY_IDX} = $countryIDX;
        $DATA{$inNumber}{TX_COUNTRY} = $txCountry;
        $DATA{$inNumber}{FK_EVENT_IDX} = $eventIDX;
        $DATA{$inNumber}{TX_CODE} = $Auth->_getSubscriptionCode(6);
    }
    foreach $inNumber (keys %DATA) {
        my $teamIDX = $Team->_addNewTeam(\%{$DATA{$inNumber}});
    }
    

print $str;
