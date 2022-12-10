#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
use CGI qw/:standard/;
use Data::Dumper;
use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $eventIDX = 28;
my $SQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX);
	my %TEAMS = %{$select->fetchall_hashref(['IN_NUMBER'])};
my $start_dir = ".";
opendir(DIR, $start_dir) 
    or die "Could not open $start_dir\n";

my @files = grep(/\.xlsx/, readdir DIR);
closedir DIR;

print join("\n",@files);
print "\n\n";
# print "\nHello World!!!\n\n";
my $cardSQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_STATUS) VALUES (?, ?, ?, ?, ?)";
my $cardInsert = $dbi->prepare($cardSQL);
   
my $scoreSQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?, ?, ?)";
my $scoreInsert = $dbi->prepare($scoreSQL);

my $commentSQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT) VALUES (?, ?, ?, ?, ?)";
my $commentInsert = $dbi->prepare($commentSQL);


use Spreadsheet::Reader::ExcelXML;
foreach $file (@files){
    print "\n$file:\n";
    my $workbook =  Spreadsheet::Reader::ExcelXML->new( file => $file, group_return_type => 'value');
    if ( !$workbook->file_opened ) {die $workbook->error(), ".\n"}

    for my $worksheet ( $workbook->worksheets ) {
        my $sheet_name = $worksheet->get_name;
        my $worksheet = $workbook->worksheet( $sheet_name );
        my $value;
        my $cardIDX = 0;
        my $teamIDX = 0;
        while( !$value or $value ne 'EOF' or $data[0]){
            $value = $worksheet->fetchrow_arrayref;
            my @data = @$value;   
            # print value."\n";
            
            if ($data[0]){
                if ($data[0]eq 'x') {
                    print "\n";
                    print "-"x80;
                    print "\n$sheet_name\n";
                    print "-"x80;
                    print "\n";
                    print $TEAMS{$data[2]}{PK_TEAM_IDX}."\n";
                    $teamIDX = $TEAMS{$data[2]}{PK_TEAM_IDX};
                    $cardInsert->execute(1, $teamIDX, 5, 28, 2);
                    $cardIDX = $cardInsert->{q{mysql_insertid}};
                }
                print "data = $data[0]\t$data[2]\t$data[3]\n";
                if ($data[0]>0){
                    my $dataValue = 100;
                    if ($data[0] == 91 || $data[0]==92 || $data[0]==93) {
                        $dataValue = 100;
                        if (lc($data[2]) eq 'no'){
                            $dataValue = 0;
                        }
                    } else {
                        if ($data[2]>10){
                            $dataValue = $data[2];
                        } else {
                            $dataValue = $data[2] * 10;
                        }
                    }
                    $scoreInsert->execute($cardIDX, $data[0], $dataValue);
                    if ($data[3]){
                        $commentInsert->execute($cardIDX, $data[0], $teamIDX, 1, $data[3]);
                    }
                }
                
            } else {
                next
            }
    
        }
    }
    print "-"x30;
    print "\n\n";
}