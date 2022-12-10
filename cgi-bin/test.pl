#!/usr/bin/perlml
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
use JSON;
use Data::Dumper;
use Mail::Sendmail;

use SAE::USER;
use SAE::SECURE;
use SAE::JSONDB;
use SAE::MAIL;
use SAE::REG_SCORE;
use SAE::ADV_SCORE;
use SAE::MIC_SCORE;
use SAE::TECH;
use Time::Local;
@ARGV;
&testTexhInspection($ARGV[0]);


exit;
sub testTexhInspection(){
    my ($eventIDX) = @_;
    print "\$status = $status\n\n";
    my $Tech = new SAE::TECH();
    my %TECH = %{$Tech->_getListToBeReinspected($eventIDX)};
    print join("\n", keys %TECH);

    print "\n\n***********************************\n\n";
}

sub testMicTeamOverallScore(){
    my ($teamIDX) = @_;
    my $Score = new SAE::MIC_SCORE();
    my %LOGS = %{$Score->_getFlightLogs($teamIDX)};
    my %SCORE;
    # foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
    #     # print "FlightIDX = $flightIDX\n";
    #     %SCORE = (%SCORE, %{$Score->_calculateFlightScore($flightIDX)});
    # }
# return;
    printf "%9s",  'Attempt';
    printf "%7s",  'Large';
    printf "%9s",  'L-Damage';
    printf "%7s", 'Small';
    printf "%9s", 'S-Damage';
    printf "%9s",  'Payload';
    printf "%7s",  'Time';
    printf "%8s", 'Bonus';
    printf "%11s", 'Raw Score';
    printf "%7s",  'Minor';
    printf "%7s",  'Major';
    printf "%14s", 'Flight Score';
    print "\n";
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        %SCORE = (%SCORE, %{$Score->_calculateFlightScore($flightIDX)});
        printf "%9d", $SCORE{$flightIDX}{IN_ROUND};
        printf "%7d", $SCORE{$flightIDX}{IN_LARGE};
        printf "%9d", $SCORE{$flightIDX}{IN_LB_DAMAGE};
        printf "%7d", $SCORE{$flightIDX}{IN_SMALL};
        printf "%9d", $SCORE{$flightIDX}{IN_SB_DAMAGE};
        printf "%9.2f", $SCORE{$flightIDX}{IN_WEIGHT};
        printf "%7.2f", $SCORE{$flightIDX}{IN_TOF};
        printf "%8.4f", $SCORE{$flightIDX}{IN_BONUS};
        printf "%11.4f", $SCORE{$flightIDX}{IN_RAW};
        printf "%7s", $SCORE{$flightIDX}{IN_MINOR};
        printf "%7s", $SCORE{$flightIDX}{IN_MAJOR};
        printf "%14.4f", $SCORE{$flightIDX}{IN_FS};
        print "\n";
    }
    my $t3s = $Score->_getTop3(\%SCORE);
    # print "\n";
    printf "FS1 + FS2 + FS3    = %8.4f\n", $t3s;
    # print "_" x 50;
    print "\n\n***********************************\n\n";
}

sub testAdvTeamOverallScore(){
    my ($teamIDX) = @_;
    my $Score = new SAE::ADV_SCORE();
    my %LOGS = %{$Score->_getFlightLogs($teamIDX)};
    my %SCORE;
    printf "%9s",  'Attempt';
    printf "%5s",  'STD';
    printf "%9s",  'In Zone';
    printf "%11s", 'Zone Type';
    printf "%10s", 'Distance';
    printf "%9s",  'Payload';
    printf "%7s",  'Z_pada';
    printf "%12s", 'B_Pada';
    printf "%11s", 'Raw Score';
    printf "%7s",  'Minor';
    printf "%7s",  'Major';
    printf "%14s", 'Flight Score';
    print "\n";
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        # print "round $LOGS{$flightIDX}{IN_ROUND}\n";
        %SCORE = (%SCORE, %{$Score->_calculateFlightScore($flightIDX)});
        printf "%9d", $SCORE{$flightIDX}{IN_ROUND};
        printf "%5d", $SCORE{$flightIDX}{IN_STD};
        printf "%9s", $SCORE{$flightIDX}{IN_ZONE};
        printf "%11s", $SCORE{$flightIDX}{IN_TYPE};
        printf "%10.1f", $SCORE{$flightIDX}{IN_DISTANCE};
        printf "%9.2f", $SCORE{$flightIDX}{IN_WATER_FLT};
        printf "%7d", $SCORE{$flightIDX}{IN_ZPADA};
        printf "%12.8f", $SCORE{$flightIDX}{IN_BPADA};
        printf "%11.4f", $SCORE{$flightIDX}{IN_RAW};
        printf "%7s", $SCORE{$flightIDX}{IN_MINOR};
        printf "%7s", $SCORE{$flightIDX}{IN_MAJOR};
        printf "%14.4f", $SCORE{$flightIDX}{IN_FS};
        print "\n";
    }
    my $t3s = $Score->_getTop3(\%SCORE);
    print "\n";
    printf "FS1 + FS2 + FS3    = %8.4f\n", $t3s;
    print "_" x 50;
    # printf "\nFFS                = %8.4f\n", $ffs + $maxWs;
    print "\n\n***********************************\n\n";
    # printf "%9s", 'Attempt';
    # printf "%9s", 'Wingspan';
    # printf "%7s", 'Minor';
    # printf "%7s", 'Major';
    # printf "%10s", 'Den-Alt';
    # printf "%10s", 'Payload';
    # printf "%11s", 'Predicted';
    # printf "%10s", 'PP Bonus';
    # printf "%11s", 'Raw Score';
    # printf "%14s", 'Flight Score';
    # printf "%10s", 'WS Score';
    # print "\n";
    # my $maxWs = 0;
    # my $maxWeight = 0;
    # foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
    #     if ($SCORE{$flightIDX}{IN_WEIGHT} > $maxWeight){
    #         $maxWs = $SCORE{$flightIDX}{IN_WS};
    #         $maxWeight = $SCORE{$flightIDX}{IN_WEIGHT};
    #     }
    #     printf "%9d", $SCORE{$flightIDX}{IN_ROUND};
    #     printf "%9s", $SCORE{$flightIDX}{IN_SPAN};
    #     printf "%7d", $SCORE{$flightIDX}{IN_MINOR};
    #     printf "%7d", $SCORE{$flightIDX}{IN_MAJOR};
    #     printf "%10.2f", $SCORE{$flightIDX}{IN_DENSITY};
    #     printf "%10.2f", $SCORE{$flightIDX}{IN_WEIGHT};
    #     printf "%11.2f", $SCORE{$flightIDX}{IN_PREDICTED};
    #     printf "%10.4f", $SCORE{$flightIDX}{IN_BONUS};
    #     printf "%11.4f", $SCORE{$flightIDX}{IN_RAW};
    #     printf "%14.4f", $SCORE{$flightIDX}{IN_FS};
    #     printf "%10.4f", $SCORE{$flightIDX}{IN_WS};
    #     print "\n";
    # }
    # print "\n";
    # my @SORTED = @{$Score->_getTop3(\%SCORE)};
    # my $ffs = 0;
    # for ($x=0; $x<=2; $x++){
    #     $ffs += $SCORE{$SORTED[$x]}{IN_FS};
    #     # print "Top: $SCORE{$SORTED[$x]}{IN_FS}\n";
    # }
    # printf "Max Wingspan Score = %8.4f\n", $maxWs;
    # printf "FS1 + FS2 + FS3    = %8.4f\n", $ffs;
    # print "_" x 50;
    # printf "\nFFS                = %8.4f\n", $ffs + $maxWs;

    print "\n"x3;
}
sub testTeamOverallScore(){
    my ($teamIDX) = @_;
    my $Score = new SAE::REG_SCORE();
    my %LOGS = %{$Score->_getFlightLogs($teamIDX)};
    my %SCORE;
    foreach $flightIDX (sort {$LOGS{$a}{IN_ROUND} <=> $LOGS{$b}{IN_ROUND}} keys %LOGS){
        my $inWeight = $LOGS{$flightIDX}{IN_WEIGHT};
        %SCORE = (%SCORE, %{$Score->_calculateFlightScore($teamIDX, $flightIDX, $inWeight)});
    }

    printf "%9s", 'Attempt';
    printf "%9s", 'Wingspan';
    printf "%7s", 'Minor';
    printf "%7s", 'Major';
    printf "%10s", 'Den-Alt';
    printf "%10s", 'Payload';
    printf "%11s", 'Predicted';
    printf "%10s", 'PP Bonus';
    printf "%11s", 'Raw Score';
    printf "%14s", 'Flight Score';
    printf "%10s", 'WS Score';
    print "\n";
    my $maxWs = 0;
    my $maxWeight = 0;
    foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
        if ($SCORE{$flightIDX}{IN_WEIGHT} > $maxWeight){
            $maxWs = $SCORE{$flightIDX}{IN_WS};
            $maxWeight = $SCORE{$flightIDX}{IN_WEIGHT};
        }
        printf "%9d", $SCORE{$flightIDX}{IN_ROUND};
        printf "%9s", $SCORE{$flightIDX}{IN_SPAN};
        printf "%7d", $SCORE{$flightIDX}{IN_MINOR};
        printf "%7d", $SCORE{$flightIDX}{IN_MAJOR};
        printf "%10.2f", $SCORE{$flightIDX}{IN_DENSITY};
        printf "%10.2f", $SCORE{$flightIDX}{IN_WEIGHT};
        printf "%11.2f", $SCORE{$flightIDX}{IN_PREDICTED};
        printf "%10.4f", $SCORE{$flightIDX}{IN_BONUS};
        printf "%11.4f", $SCORE{$flightIDX}{IN_RAW};
        printf "%14.4f", $SCORE{$flightIDX}{IN_FS};
        printf "%10.4f", $SCORE{$flightIDX}{IN_WS};
        print "\n";
    }
    print "\n";
    my @SORTED = @{$Score->_getTop3(\%SCORE)};
    my $ffs = 0;
    for ($x=0; $x<=2; $x++){
        $ffs += $SCORE{$SORTED[$x]}{IN_FS};
        # print "Top: $SCORE{$SORTED[$x]}{IN_FS}\n";
    }
    printf "Max Wingspan Score = %8.4f\n", $maxWs;
    printf "FS1 + FS2 + FS3    = %8.4f\n", $ffs;
    print "_" x 50;
    printf "\nFFS                = %8.4f\n", $ffs + $maxWs;

    print "\n"x3;
}

sub testRegFlightScore(){
    my ($teamIDX, $flightIDX, $inWeight) = @_;
    print "TeamIDX          = $teamIDX\n";
    print "FlightIDX        = $flightIDX\n";
    print "Payload Weight   = $inWeight\n";
    my $Score = new SAE::REG_SCORE();
    my %FLIGHTSCORE = %{$Score->_calculateFlightScore($teamIDX, $flightIDX, $inWeight)};
    print "Flight Score     = $FLIGHTSCORE{IN_FS}\n\n"; 
    print "\n\n***********************************\n\n";

}
sub testMail(){
    my ($u) = @_;
    my $Mail = new SAE::MAIL();
    my $message = $Mail->_getPasswordResetText('thedongs@live.com', 'adfewdcvac');
    $from = 'aerogeek@saestars.com';
    $subject = 'Test Email 46';
    my $Mail = new SAE::MAIL();
    my $str = $Mail->_sendMail($u, $from, $subject, $message);
    print "$str\n$u\n$from\n$subject\n$message\n";
}

sub saeMail(){
    my ($u) = @_;
    %mail = ( To      => $u,
              From    => 'aerogeek@saestars.com',
              Subject => 'Send Mail Test',
              Message => "This is a very short message"
            );
 
sendmail(%mail) or die $Mail::Sendmail::error;
 
print "OK. Log says:\n", $Mail::Sendmail::log;
}

sub resetPassword(){
    my ($u) = @_;
    print "\n***********************************\n\n";
    my $User = new SAE::USER();
    my $Secure = new SAE::SECURE();
    my $JsonDB = new SAE::JSONDB();
    my %DATA;
    my $tp   = $Secure->_getTemporaryPassword(8);
    my $salt = $Secure->_getTemporaryPassword(2);
    my $saltedPassword = crypt($tp,$salt);
    $DATA{TX_PASSWORD} = $saltedPassword;
    $DATA{BO_RESET} = 1;
    $JsonDB->_update('TB_USER',\%DATA,qq(TX_EMAIL='$u'));
    print "Temporary Password = $tp\n";
    print "Salt  = $salt\n";
    print "Salted Password = $saltedPassword\n";


    print "\n\n***********************************\n\n";
}
sub testLogin(){
    my ($u, $p) = @_;
    print "\n***********************************\n\n";

    my $User = new SAE::USER();
    my %USER = %{$User->_login($u, $p)};
    if ($USER{STATUS} ==1 ){
        print "Successful Login \n";
    } elsif ($USER{STATUS} == 0) {
        print "Username and password did not match data in the database \n";
    } else {
        print "User Does not Exist \n";
    }
    my $json = encode_json \%USER;


    print "\n\n***********************************\n\n";
}


sub template(){
    print "\n***********************************\n\n";
    print "test template\n";

    print "\n\n***********************************\n\n";
}

sub testForXLS (){
    my ( $FileName )    = @_;
    my $signature       = '';
    my $XLSsignature    = 'D0CF11E0A1B11AE10000';
    print "-"x80;
    print "\n";
    
    open(FILE, "<$FileName")||die;
    read(FILE, $buffer, 10, 0);
    close(FILE);
    
    print $FileName."\n\n";
    
    foreach (split(//, $buffer))
        { $signature .= sprintf("%02x", ord($_)); }
    print $signature."\n\n";
    
    $signature =~ tr/a-z/A-Z/;
    
    print $signature."\n\n";
    
    if ( $signature eq $XLSsignature ){ 
        # return 1; 
        print "yes\n";
    } else { 
        # return 0; 
        print "not an Excel File\n";
        
    }

}

sub testImportReader(){
my $filename = "uploads/comments.xlsx";
    print "-"x80;
    print "\n";
    print "path = $path";
    print "\n";
    print "\$filename = $filename";
    print "\n";
    
my $parser = Spreadsheet::ParseXLSX->new();
my $workbook = $parser->parse("$filename");
my $worksheet_count = $workbook->worksheet_count();
print "\$worksheet_count =$worksheet_count\n";
my $worksheet = $workbook->worksheet(0);
@ROW = (2,4,6,8,10, 12, 14, 16, 18, 19, 20);
for my $worksheet ( $workbook->worksheets() ) {
    my $worksheetName = $worksheet->get_name();
    my $inNumber = $worksheet->get_cell(0,2)->value();
    print "-" x 50;
    print "\n";
    printf "Team Number = %03d\n", $inNumber;
    print "-" x 50;
    print "\n";
    
    foreach $row (@ROW){
            my $key = $worksheet->get_cell( $row, 0)->value();
            my $value = $worksheet->get_cell( $row, 2)->value();
            my $comments = $worksheet->get_cell( $row, 3)->value();
            if ($value == 'Yes'){$value = 1} 
            printf "%d =\t %2.1f:\t%s\n", $key, $value, $comments;
            
    }
    # print "-" x 50;
    # print "\n";
}
# print "Value       = ", $cell->value(),       "\n";
# print "Unformatted = ", $cell->unformatted(), "\n";

    
# my $parser   = Spreadsheet::ParseExcel->new();
# my $workbook = $parser->parse($filename);
 
# if ( !defined $workbook ) {
#     die $parser->error(), ".\n";
# }


# for my $worksheet ( $workbook->worksheets() ) {
 
    # my ( $row_min, $row_max ) = $worksheet->row_range();
    # my ( $col_min, $col_max ) = $worksheet->col_range();
 
    # for my $row ( $row_min .. $row_max ) {
    #     for my $col ( $col_min .. $col_max ) {
 
    #         my $cell = $worksheet->get_cell( $row, $col );
    #         next unless $cell;
 
    #         print "Row, Col    = ($row, $col)\n";
    #         print "Value       = ", $cell->value(),       "\n";
    #         print "Unformatted = ", $cell->unformatted(), "\n";
    #         print "\n";
    #     }
    # }
# }




    print "-"x80;
    print "\n";
}
sub testPenalty(){

    my $eventIDX = 30;
    my $classIDX = 3;
    my $publishIDX = 30;


    # printf "rounding 11/4 = %d", POSIX::floor(11/4);
    # my $Obj;
    # if ($classIDX==3) {
    #     $Obj = new SAE::MICRO($eventIDX);
    # } elsif ($classIDX==2) {
    #     $Obj = new SAE::ADVANCED($eventIDX);
    # } else {
    #     $Obj = new SAE::REGULAR($eventIDX);
    # }
    # my $Score = new SAE::SCORE();
    # my %TEAMS = %{$Obj->_getTeamList()};
    # print "-"x80;
    # print "\n";
    
    # foreach $teamIDX (sort keys %TEAMS){
    #     my $inValue = $Score->_generateviewFastestTimeToTurn($eventIDX, $classIDX, $teamIDX, $publishIDX);
    #     printf "%d\t%03d\t%d\n", $teamIDX,  $TEAMS{$teamIDX}{IN_NUMBER}, $inValue;
    # }

    print "-"x80;
    print "\n";
}
sub viewOverallPerformance(){
    my ($eventIDX, $classIDX, $publishIDX) = @_;
    
    my $Obj;
    if ($classIDX==3) {
        $Obj = new SAE::MICRO($eventIDX);
    } elsif ($classIDX==2) {
        $Obj = new SAE::ADVANCED($eventIDX);
    } else {
        $Obj = new SAE::REGULAR($eventIDX);
    }
    my $Score = new SAE::SCORE();
    my %TEAMS = %{$Obj->_getTeamList()};
    my $Ecr = new SAE::ECR();
    foreach $teamIDX (keys %TEAMS) {
        my $inPenalty=0;
        my ($late, $designScore, $sorted) = $Score->_designScores($eventIDX, $classIDX, $teamIDX,$publishIDX);
            $TEAMS{$teamIDX}{IN_DESIGN}   = $designScore;
        my ($presoScore)                  = $Score->_presoScores($eventIDX, $classIDX, $teamIDX,$publishIDX);
            $TEAMS{$teamIDX}{IN_PRESO}    = $presoScore;
        my $flightScore = 0;
        if ($classIDX==3) {
            my ($TOPS, $FLIGHTS) = $Obj->_calcTeamScore($teamIDX);
            my %SCORE = %{$FLIGHTS};
            my @SORTED = @$TOPS;
            $flightScore = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS};
        } elsif ($classIDX==2) {
            my ($inStd, $boAuto, $inWater, $waterFlown, $SCORES) = $Obj->_calcTeamScore($teamIDX);
            my %SCORE = %{$SCORES};
            my $gtvMultiplier = 2.0;
            if ($boAuto<1) {$gtvMultiplier = 1.5}
            my $waterScore = ($waterFlown + $gtvMultiplier*$inWater)/4;
            my $SUM_PADA = 0;
            foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
                my $subScore = ($SCORE{$flightIDX}{APADA} + $SCORE{$flightIDX}{BPADA});
                my $totalAttemptScore = $subScore - ($SCORE{$flightIDX}{IN_MINOR} * $subScore) - ($SCORE{$flightIDX}{IN_MAJOR} * $subScore);
                   $SUM_PADA += $totalAttemptScore;
            }
            $flightScore = ($waterScore + (4*$SUM_PADA));

        } else {
            my ($maxPPB, $TOPS, $SCORES) = $Obj->_calcTeamScore($teamIDX);
            my %SCORE = %{$SCORES};
            my @SORTED = @$TOPS;
            $flightScore = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS} + $maxPPB;

        }
        # my $inPenalty      = $Ecr->_getTotalPenalty($teamIDX);
        my $inOverall      = $designScore + $presoScore + $flightScore - $inPenalty;
        if ($Ecr->_getTotalPenalty($teamIDX)){$inPenalty      = $Ecr->_getTotalPenalty($teamIDX);}
        print "$publishIDX, $teamIDX, $designScore, $presoScore, $flightScore, $inPenalty, $inOverall\n";
        # $Score->_saveOverallScores($publishIDX, $teamIDX, $designScore, $presoScore, $flightScore, $inPenalty, $inOverall );
    }
    return ($str);
}

sub testDesignScore(){
    my $t0 = [gettimeofday];
    my $Rubric=new SAE::RUBRIC();
    my %SECTION = %{$Rubric->_getSectionList()};
    
    my $Reg = new SAE::REGULAR(30);
    my %TEAM = %{$Reg->_getTeamList()};
    
    my $Obj = new SAE::SCORE();
    foreach $teamIDX (sort keys %TEAM) {
        my ($late, $teamScore, $rawScore) = $Obj->_calcDesignScore($teamIDX, \%SECTION);
        $TEAM{$teamIDX}{IN_SCORE} = $teamScore;
        $TEAM{$teamIDX}{IN_LATE} = $late;
        $TEAM{$teamIDX}{IN_SORTED} = $rawScore;
    }
    
   foreach $teamIDX (sort {$TEAM{$b}{IN_SORTED} <=> $TEAM{$a}{IN_SORTED}} keys %TEAM) {
       printf "%03d\t%-50s%\t%10.2f\t%10.4f\n", $TEAM{$teamIDX}{IN_NUMBER}, $TEAM{$teamIDX}{TX_SCHOOL}, $TEAM{$teamIDX}{IN_LATE}, $TEAM{$teamIDX}{IN_SCORE};
   }
    
    ($seconds, $microseconds) = gettimeofday;
    $elapsed = tv_interval ( $t0, [$seconds, $microseconds]);
    printf "Time elapse: %2.7f sec\n", $elapsed;

}
sub testPublish(){
    my $Pub = new SAE::PUBLISH();
    my $links = $Pub->_getPublishedResults(30,1,'Design Report');
    print "\n\n $links \n\n";
}
sub testAdvaceScore(){
    # my $std = 3;
    # my @distance = (15,24,32,11,27,7);
    # my $d = 15;
    # my $Mic=new SAE::MICRO();
    # my ($TOPS, $FLIGHTS) = $Mic->_calcTeamScore(655);
    # my %SCORE = %{$FLIGHTS};
    # my @SORTED = @$TOPS;
    # print "-"x50;
    # print "\n";
    # # IN_LARGE, IN_LB_DAMAGE, IN_SMALL, IN_SB_DAMAGE, IN_WEIGHT, IN_TOF, IN_PEN_MINOR, IN_PEN_LANDING, IN_ROUND
    # foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
    #     printf "%5d\t%5d\t%5d\t%5d\t%5d\t%4.2f\t%5d\t-%2.4f\t-%2.4f\t%2.4f\t%2.4f\n"
    #     ,$SCORE{$flightIDX}{IN_ROUND},$SCORE{$flightIDX}{IN_LARGE},$SCORE{$flightIDX}{IN_LB_DAMAGE},$SCORE{$flightIDX}{IN_SMALL}
    #     ,$SCORE{$flightIDX}{IN_SB_DAMAGE},$SCORE{$flightIDX}{IN_WEIGHT},$SCORE{$flightIDX}{IN_TOF}
    #     ,$SCORE{$flightIDX}{IN_MINOR},$SCORE{$flightIDX}{IN_MAJOR},$SCORE{$flightIDX}{IN_BONUS},$SCORE{$flightIDX}{IN_FFS};
    # }
    # my $top3 = $SCORE{$SORTED[0]}{IN_FFS} + $SCORE{$SORTED[1]}{IN_FFS} + $SCORE{$SORTED[2]}{IN_FFS};
    # printf "Top 3 Scores = %2.4f\n", $top3;
    # print "\n";
    # @SORTED = (sort {$FLIGHT{$b}{IN_FS} <=> $FLIGHT{$a}{IN_FS}} keys %FLIGHT);
    # printf "%10d\t%2.4f\n", $FLIGHT{$SORTED[0]}{IN_ROUND}, $FLIGHT{$SORTED[0]}{IN_FFS};
    # printf "%10d\t%2.4f\n", $FLIGHT{$SORTED[1]}{IN_ROUND}, $FLIGHT{$SORTED[1]}{IN_FFS};
    # printf "%10d\t%2.4f\n", $FLIGHT{$SORTED[2]}{IN_ROUND}, $FLIGHT{$SORTED[2]}{IN_FFS};
    # printf "Max Prediction Bonus = %2.4f\n",$maxPPB;
    # print "\n";
    # foreach $d (@distance){
    #     my $bonus = $adv->_calcLandingBonus($std, $d);
    #     print "for $d, Bonus = ".$bonus."\n";
    # }
    # my ($inStd, $boAuto, $inWater, $waterFlown, $SCORES) = $adv->_calcTeamScore(687);
    # my %SCORE = %{$SCORES};
    # my $gtvMultiplier = 2.0;
    # if ($boAuto<1) {$gtvMultiplier = 1.5}
    # my $waterScore = ($waterFlown + $gtvMultiplier*$inWater)/4;
    # my $SUM_PADA = 0;
    # foreach $flightIDX (sort {$SCORE{$a}{IN_ROUND} <=> $SCORE{$b}{IN_ROUND}} keys %SCORE) {
    #     $SUM_PADA += ($SCORE{$flightIDX}{BPADA} + $SCORE{$flightIDX}{APADA});
    #     printf "%10d\t%2.4e\t%1.2f\t%1.2f\t%1.2f\t%2.4e\t%10.8f\n", $SCORE{$flightIDX}{IN_ROUND}, $SCORE{$flightIDX}{BPADA}, $SCORE{$flightIDX}{APADA}, $SCORE{$flightIDX}{IN_MINOR}, $SCORE{$flightIDX}{IN_MAJOR}, $SCORE{$flightIDX}{BPADA} + $SCORE{$flightIDX}{APADA}, (4*$SUM_PADA);
    # }
    # print "-"x30;
    # print "\nwater flown = $waterFlown\n";
    # print "water trans = $inWater\n";
    # print "\$gtvMultiplier = $gtvMultiplier\n";
    # print "water Score = $waterScore\n";
    # print "-"x30;
    # printf "\nFinal Score = %2.4f\n\n", ($waterScore + (4*$SUM_PADA));
    
    
    print "\n\n";
    

}
sub testUpdates(){
    my ($TxEmail, $TxPassword) = @_;
    my $session = CGI::Session->new();
    
    
    exit;
    my $Auth = new SAE::Auth();
    print "\n***********************************\n\n";
    # print "test template\n";
    print "input = $TxEmail, $TxPassword\n\n";
    my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login($TxEmail, $TxPassword);
    
    print "$success, $userIDX, $sid, $boReset, $txFirst, $txLast\n\n";

    print "\n\n***********************************\n\n";
}

sub test(){
    my ($teamIDX, $inRound) = @_;
    print "\n***********************************\n\n";
    print "testing...\n";
    my $Micro = new SAE::MICRO(29);
    # $Micro->_getTeamFlightScore($teamIDX, $inRound);
    my $finalScore = $Micro->_getTeamFinalScore($teamIDX);
    print "Final Score = $finalScore\n";
    print "\n***********************************\n\n";
    %TEAM = %{$Micro->_getMicroTeamList()};
    printf "%-5s %-40s %-20s %-10s\n",'No.', 'Team School','Country','FS';
    print '-' x 80;
    print "\n";
    foreach $teamIDX (sort keys %TEAM) {
        printf "%-5s %-40s %-20s\n", $TEAM{$teamIDX}{IN_NUMBER}, substr($TEAM{$teamIDX}{TX_SCHOOL},0,35), $TEAM{$teamIDX}{TX_COUNTRY};
        # print "$TEAM{$teamIDX}{IN_NUMBER}\t$TEAM{$teamIDX}{TX_SCHOOL}\t$TEAM{$teamIDX}{TX_COUNTRY}\n";
    }
    print "DONE ***********************************\n\n";
    
    
    
    # $teamIDX = 249;
    # $location = 25;
    # my $Card = new SAE::CARD();
    # %TEAMS = %{$Card->_getAvailableTeamsByClass(1, 25, 1)};
    # print join("\n", keys %TEAMS);
    # my $Ref = new SAE::REFERENCE();
    # $Ref->_createLateReports(248, 3, 25);
    # %LATE = %{$Ref->_getLateReportListByEvent(25)};
    
    # print join("\n", keys %LATE);
    
    
    # $Score->_calculateAdvancedScoresByTeam(259, 25);
    # $Score->_publishRound(1,5,14,25);
#   $Score->_getPublishedFridayResults(1,25,15);
#    %TEAMS =  %{$Score->_getAdvancedFlightsByEvent(25,2, 1)};
#    foreach $teamIDX (sort {$TEAMS{$b}{IN_OVERALL} <=> $TEAMS{$a}{IN_OVERALL}} keys %TEAMS){
#        print $teamIDX."($TEAMS{$teamIDX}{IN_NUMBER}) =$TEAMS{$teamIDX}{IN_OVERALL}\n";
#    }
    # $Score -> _getAdvancedFlightLogs(259);
    print "\n";
    # $Score->_getAdvancedFinalCalculations(259,25, 22.75, 15.5, 137.3375, 37.25);
    # %SCORE = %{$Score->_getMicroFlightLogs(265, 25)};

    # foreach $inRound (sort {$a<=>$b} keys %SCORE){
    #     # print "$inRound\t$SCORE{$inRound}{IN_}";
    #     printf "%2.0f\t%2.2f\t%2.2f\t%2.0f\t%2.0f\t%2.4f\t%2.4f\n",$inRound, $SCORE{$inRound}{IN_PAYLOAD}, $SCORE{$inRound}{IN_EMPTY}, $SCORE{$inRound}{IN_PEN_MINOR}, $SCORE{$inRound}{IN_PEN_LANDING}, $SCORE{$inRound}{IN_RAW}, $SCORE{$inRound}{IN_SCORE};
    # }
    # print "Number of Penalties = ".scalar(keys %PEN);
    # print $Score->_getMicroFlightScoreByTeam(265,25);

    # %RANK = %{$Score->_getAdvancedFlightsByEvent(25, 5, 2)};
    # foreach $teamIDX  (sort {$RANK{$b}{IN_SCORE} <=> $RANK{$a}{IN_SCORE}} keys %RANK) {
    #     printf "$teamIDX = %2.4f\n", $RANK{$teamIDX}{IN_SCORE};
    # }
    # $Score->_getAdvancedScoreByTeam(259,25);
    # $Score->_getAdvancedScoreByTeam(260,25);
    # $Score->_getAdvancedScoreByTeam(261,25);
    # $Score->_getAdvancedScoreByTeam(262,25);
    # $Score->_getAdvancedScoreByTeam(263,25);
    # $Score->_getAdvancedScoreByTeam(264,25);

    # printf "%2.1f", $Score->_getTotalPenaltiesByTeam(265, 25);
    
    # %PEN = %{$Score->_getTotalPenaltiesByEvent(25)};
    # foreach $teamIDX (sort keys %PEN){
    #     print "$teamIDX\t = $PEN{$teamIDX}\n";        
    # }
    # $SCORE{PAPER} = $Score->_getOverallPaperSectionByTeam(265,1);
    # $SCORE{TDS} = $Score->_getOverallPaperSectionByTeam(265,2);
    # $SCORE{DRAW} = $Score->_getOverallPaperSectionByTeam(265,3);
    # $SCORE{REQ} = $Score->_getOverallPaperSectionByTeam(265,4);
    # $SCORE{TOTAL} = $SCORE{PAPER} + $SCORE{TDS} + $SCORE{DRAW} + $SCORE{REQ};
    
    # print "\n\n";
    # printf "OVerall = %2.4f", $Score->_getOverallPaperByTeam(265);
    # print "\n\n";
    
    
    # # print "Team Paper 265 = ".$Score->_getOverallPaperByTeam(265,1)."\n";
    # # print "Team TDS 265 = ".$Score->_getOverallPaperByTeam(265,2)."\n";
    # # print "Team Drawing 265 = ".$Score->_getOverallPaperByTeam(265,3)."\n";
    # # print "Team Requirements 265 = ".$Score->_getOverallPaperByTeam(265,4)."\n";
    
    # foreach $key (sort keys %SCORE){
    #     printf "$key = \t%2.4f\n",$SCORE{$key};
    # }

    # print "\n\n";
    # printf "PRESO = %2.4f", $Score->_getPresoScoreByTeam(265,5);
    
    print "\n\n***********************************\n\n";
}


# sub test(){
#     print "\n***********************************\n\n";

#     my $Score = new SAE::SCORE();
#     %ROUND = %{$Score->_getTeamFlightScore(265)};
#     foreach $round (sort {$a <=> $b} keys %ROUND){
#         print "ROUND $round: $ROUND{$round}{IN_PAYLOAD}\t $ROUND{$round}{IN_EMPTY}\t $ROUND{$round}{IN_FLIGHT}\t $ROUND{$round}{IN_AVG}\t $ROUND{$round}{IN_MAX}\t$ROUND{$round}{IN_DEMO}\t $ROUND{$round}{IN_SCORE}\n";
#     }
#     # for ($i=1; $i<=5; $i++){
#     my $i = 5;
#         print "---ROUND $i --------------\n";
#         my %RANK = ();
#         %RANK = %{$Score->_getTeamFlgihtScoresByClass(25, 3, $i)};
#         foreach $teamIDX (sort {$RANK{$b}{IN_SCORE} <=> $RANK{$a}{IN_SCORE}} keys %RANK) {
#             print "$teamIDX\t".$RANK{$teamIDX}{IN_NUMBER}."\t".$RANK{$teamIDX}{IN_DEMO}."\t".$RANK{$teamIDX}{IN_SCORE}."\n";
#         }
#         print "-----------------\n";
#     # }
#     print "\n\n***********************************\n\n";
# }

sub testAvailableAssessments(){
    print "\n***********************************\n\n";

    my $Score = new SAE::SCORE();

    %SCORES = %{$Score->_getMicroDemoScoreByEvent(25)};



    print "test template\n";
    print "\n\n***********************************\n\n";
}
sub testScore(){
    print "\n***********************************\n\n";
    print "test Score\n";
    my $Ref = new SAE::SCORE();
    print $Ref->_calculatePaperScores(1,2618,2); 
    print "\n-----------------------------------------------\n";
    # print $Ref->_calculatePaperScores(68,2591,1);

    print "\n\n***********************************\n\n";
}


sub idJudges(){
    my $dbi = new SAE::Db();
    my $SQL = "SELECT PK_USER_IDX FROM TB_USER WHERE IN_USER_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(1);
    %USERS = %{$select->fetchall_hashref('PK_USER_IDX')};
    $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) VALUES (?,?)";
    my $insert = $dbi->prepare($SQL);
    foreach $userIDX (sort {$a <=> $b} keys %USERS){
        print "$userIDX\t";
        for ($i=1; $i<=9; $i++){
            $insert->execute($i, $userIDX);
            print "\t$i";
        } 
        print "\n";
    }
    print "Done";


}

sub autoAssign(){
    print "\n***********************************\n";
    print "test AUTO Assigned";
    print "\n***********************************\n";
    # print "Number of team for Event #24 = ".$Auto->_getTeamCount(24)."\n\n";
    # print "Number of team for Event #23 = ".$Auto->_getTeamCount(23)."\n\n";
    my ($HASH) = $Auto->_getTeamCount(23);
    # my ($CARD_COUNT) = $Auto->_getCardCount(23);
    # my ($CARD_JUDGE) = $Auto->_getJudgeCount(23);
    my %TEAMS = %{$HASH};  # Get a list of teams
    my %CARD = %{$CARD_COUNT};  #Check how many Teams have Judges
    
    # For Team  with ID of 1     
    
    
    
    
    # my %JUDGE = %{$CARD_JUDGE};
    # print "Number of team for Event #24 = ".scalar(keys %TEAMS)."\n\n";
    # print join(", ", sort {$a <=> $b} keys %TEAMS);
    # print "\n\n";
    # my $count = keys %{$CARD{1}};
    # print "Team IDX of 1 = ".join(", ", keys %{$CARD{1}})."\n--- Number of judges assigned: $count\n\n";
    
    print $Auto->_getAvailableJudges(23);
    
    # until ($count >=3){
        
    # }
    
    # For team 1



    # foreach $teamIDX (sort {$a <=> $b} keys %TEAMS) {       
    #     my $count = scalar(keys %{$CARD{$teamIDX}});
    #     foreach $userIDX (sort {$1<=>$b} keys %JUDGE) {
    #         until ($count >= 3) {
    #             print "Card Count($count) for Judge $userIDX = ".scalar(keys %{$CARD{$teamIDX}})."\n";
    # #             # print "$teamIDX \t".scalar(keys %{$CARD{$teamIDX}{$userIDX}})."\n";
    # #             if (exists $CARD{$teamIDX}{$userIDX}){next}
    # #                 $CARD{$teamIDX}{$userIDX} = 1;
    # #                 $count = scalar(keys %{$CARD{$teamIDX}{$userIDX}});
    # #                 # print "$teamIDX \t $userIDX \n";
    #         $count++;
    #         }
    #     }
    # }



}

sub _getMenuItem(){
    print "\n***********************************\n\n";
    print $Auth->_getMenuItem(2479);

    print "\n\n***********************************\n\n";
}

sub _welcome(){
    print "\n***********************************\n\n";
    $Auth->_welcome('test1@saestars.com', 'test1', 'test1_firstName','test1_lastName');
    $Auth->_welcome('test2@saestars.com', 'test2', 'test2_firstName','test2_lastName');

    print "\n\n***********************************\n\n";
}

sub _register(){
    # @F = ('Sama','Skylar','Haidar','Nathalie','Janae','Eman','Rita','Viola','Rueben','Iwan');
    # @L = ('Avalos','Clarkson','Huffman','Rawlings','Woodward','Crosby','Mcneill','Sharples','Merritt','Snow');
    print "\n***********************************\n\n";
    # for ($x=0; $x<10; $x++){

        print $Auth->_register('test1@saestars.com', 'test1', 'test1_firstName','test1_lastName')."\n";
        $Auth->_welcome('test1@saestars.com', 'test1', 'test1_firstName','test1_lastName');
        print $Auth->_register('test2@saestars.com', 'test2', 'test2_firstName','test2_lastName')."\n";
        $Auth->_welcome('test2@saestars.com', 'test2', 'test2_firstName','test2_lastName');
    # }
   
    print "\n\n***********************************\n\n";
}
sub _testLogin(){
    # for($x=0; $x<=10; $x++){
        my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login('thedongs@live.com','sae102');
        print "$success \t $userIDX \t $sid \t $boReset \t $txFirst \t $txLast\n\n";
        my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login('test1@saestars.com','test1');
        print "$success \t $userIDX \t $sid \t $boReset \t $txFirst \t $txLast\n\n";
        my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login('test2@saestars.com','test2');
        print "$success \t $userIDX \t $sid \t $boReset \t $txFirst \t $txLast\n\n";
        my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login('test1@saestars.com','test2');
        print "$success \t $userIDX \t $sid \t $boReset \t $txFirst \t $txLast\n\n";
    # }
}

