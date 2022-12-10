#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use File::Basename;
use Spreadsheet::Reader::ExcelXML;
use DBI;
use SAE::SDB;

my $q = new CGI;

# *****************************************************************************
print $q->header;
my $eventIDX = 28;
# *****************************************************************************

my $upload_folder = 'uploads/';

my @files = $q->param('multi_files');
my @io_handles=$q->upload('multi_files');

my %file_hash;

foreach my $item(@files){
    my $basename =  basename($item);
    print "basename = $basename"."<br>"x2; 
    my $outputFile = "$upload_folder$basename";
    print "saveAs = $outputFile"."<br>"x2; 
    foreach my $sub_item(@io_handles){
        if($item eq $sub_item){
            open UPLOADFILE, ">$outputFile";
            while (<$sub_item>) {
                print UPLOADFILE $_;
            }
            close UPLOADFILE;
            print "Files uploaded to $upload_folder"."<br>"x2;
            $file_hash{$item} = $outputFile;
        }
    }
}
&processFiles(\%file_hash);


exit;
sub processFiles(){
    my $files = shift;
    my $dbi = new SAE::Db();
    my $teamSQL = "SELECT PK_TEAM_IDX, FK_CLASS_IDX, FK_COUNTRY_IDX, IN_NUMBER, TX_NAME, TX_SCHOOL, IN_SLOPE, IN_YINT, TX_CODE, TX_REPORT, TX_TDS, TX_DRAWING, FK_EVENT_IDX, IN_TUBE_LENGTH, BO_STATUS, BO_CHECKIN, IN_CAPACITY, IN_MAX, IN_FACTOR, IN_LATE FROM TB_TEAM WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($teamSQL);
	   $select->execute($eventIDX);
	my %TEAMS = %{$select->fetchall_hashref(['IN_NUMBER'])};
    
    my $cardSQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_STATUS) VALUES (?, ?, ?, ?, ?)";
    my $cardInsert = $dbi->prepare($cardSQL);
       
    my $scoreSQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?, ?, ?)";
    my $scoreInsert = $dbi->prepare($scoreSQL);
    
    my $commentSQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT) VALUES (?, ?, ?, ?, ?)";
    my $commentInsert = $dbi->prepare($commentSQL);
    
    %FILES = %{$files};
    # foreach $file (sort keys %FILES) {
    #     print $FILES{$file}."<br>";
    # }
    
    foreach $item (sort keys %FILES) {
        my $file = $FILES{$item};
        # print "\n$file:\n";
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
                # print value."<br>";
                
                if ($data[0]){
                    if ($data[0]eq 'x') {
                        # print "<br>";
                        # print "-"x80;
                        # print "<br>$sheet_name<br>";
                        # print "-"x80;
                        # print "<br>";
                        # print $TEAMS{$data[2]}{PK_TEAM_IDX}."<br>";
                        $teamIDX = $TEAMS{$data[2]}{PK_TEAM_IDX};
                        $cardInsert->execute(1, $teamIDX, 5, 28, 2);
                        $cardIDX = $cardInsert->{q{mysql_insertid}};
                    }
                    # print "data = $data[0] - $data[2] - $data[3]<br>";
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
        # print "-"x30;
        # print "<br><br>";
    }
    
    
    
    
    
    
}
