#!/usr/bin/perl
use cPanelUserConfig;
use DBI;
use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

my $dbName = "saestars_PROD";
my $dbi = DBI->connect("dbi:mysql:$dbName:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect");

my $SQL = "SELECT Q.PK_QUESTION_IDX, Q.TX_TITLE, SCORE.IN_ROUND, SCORE.IN_VALUE, TEAM.FK_CLASS_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_SCORE AS SCORE 
JOIN TB_GRADE AS GRADE ON SCORE.FK_GRADE_IDX = GRADE.PK_GRADE_IDX
JOIN TB_QUESTION AS Q ON SCORE.FK_QUESTION_IDX = Q.PK_QUESTION_IDX
JOIN TB_TEAM AS TEAM ON GRADE.FK_TEAM_IDX = TEAM.PK_TEAM_IDX
WHERE TEAM.FK_EVENT_IDX = ? AND GRADE.TX_TYPE=?";
my $select = $dbi->prepare($SQL);
$select->execute(24, 'flight');
%CHECK = %{$select->fetchall_hashref(['FK_CLASS_IDX','IN_NUMBER','IN_ROUND','PK_QUESTION_IDX'])};
$select->execute(24, 'flight');
%ROUND = %{$select->fetchall_hashref(['FK_CLASS_IDX','IN_ROUND','IN_NUMBER','PK_QUESTION_IDX'])};
open (FILE,">log.txt");
$class=1;
# foreach $inRound(sort {$a <=> $b} keys %{$ROUND{1}}){
#     foreach $inNumber (sort {$a <=> $b} keys %{$ROUND{1}{$inRound}}) {
#         print $inRound."\t";
#         print $ROUND{1}{$inRound}{$inNumber}{}
#     }
    
# }



print FILE "-----------------------------------------------\n";
print FILE "---------------- REGULAR CLASS ----------------\n";
print FILE "-----------------------------------------------\n";
print FILE "#\tRnd\tseats\tluggage\n";
foreach $inNumber (sort {$a <=> $b} keys %{$CHECK{$class}}){
    # print "---------------------------------------\n";
    # print "#\tRnd\tseats\tluggage\n";
    foreach $round (sort {$a <=> $b} keys %{$CHECK{$class}{$inNumber}}){
        # print "$inNumber\t$round";
        # print "\t$CHECK{$class}{$inNumber}{$round}{323}{IN_VALUE}";
        # print "\t$CHECK{$class}{$inNumber}{$round}{324}{IN_VALUE}";
        # print "\n";
        print FILE "$inNumber\t$round";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{323}{IN_VALUE}";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{324}{IN_VALUE}";
        print FILE "\n";
    }
    print FILE "------------\n";
}
$class=2;
print FILE "-----------------------------------------------\n";
print FILE "---------------- ADVANCED CLASS ---------------\n";
print FILE "-----------------------------------------------\n";
print FILE "#\tRnd\tfuel\tcol\thab\t\water\n";

foreach $inNumber (sort {$a <=> $b} keys %{$CHECK{$class}}){
    my $totCol = 0;
    my $totHab = 0;
    my $totWat = 0;
    my $totFuel = 0;
    # print "---------------------------------------\n";
    # print "#\tRnd\tcol\thab\t\water\tfuel\n";
    foreach $round (sort {$a <=> $b} keys %{$CHECK{$class}{$inNumber}}){
        $totCol += $CHECK{$class}{$inNumber}{$round}{325}{IN_VALUE};
        $totHab += $CHECK{$class}{$inNumber}{$round}{326}{IN_VALUE};
        $totWat += $CHECK{$class}{$inNumber}{$round}{327}{IN_VALUE};
        $totFuel += $CHECK{$class}{$inNumber}{$round}{328}{IN_VALUE};

        print FILE "$inNumber\t$round";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{328}{IN_VALUE}";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{325}{IN_VALUE}";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{326}{IN_VALUE}";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{327}{IN_VALUE}";
        
        print FILE "\n";
    }
    print FILE "-----------------------------------------------\n";
    print FILE "TOTAL\t-\t$totFuel\t$totCol\t$totHab\t$totWat\n";
    print FILE "-----------------------------------------------\n";
    print FILE "\n";
    # print FILE "\n----------------\n";
}

print FILE "-----------------------------------------------\n";
print FILE "---------------- MICRO CLASS ------------------\n";
print FILE "-----------------------------------------------\n";
print FILE "#\tRnd\tpayload\tEW\n";
$class=3;
foreach $inNumber (sort {$a <=> $b} keys %{$CHECK{$class}}){
    # print "---------------------------------------\n";
    # print "#\tRnd\tpayload\tEW\n";
    foreach $round (sort {$a <=> $b} keys %{$CHECK{$class}{$inNumber}}){
        print FILE "$round\t$inNumber";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{329}{IN_VALUE}";
        print FILE "\t$CHECK{$class}{$inNumber}{$round}{330}{IN_VALUE}";
        print FILE "\n";
    }
    print FILE "\n------------------\n";
}
close (FILE);

# @ARGV;
# my $flight = new SAE::REGULAR();

#     my ($capacity, $passenger, $cargo, $empty, $score) =  $flight->getTeamFlightScoreInRound($ARGV[0], $ARGV[1]);
#     print "ROW = $capacity\t$passenger\t$cargo\t$empty\t$score\n";
#     print "\n\nFinal Score = ".$flight->getRegularFinalFlightScoreUpToRound($ARGV[0], $ARGV[1]);
# print "\n\nComplete\n\n\a";
