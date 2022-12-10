#!/usr/bin/perl
use cPanelUserConfig;
use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Cwd 'abs_path';
use DateTime;
use DBI;

use SAE::AUTO;
use SAE::Auth;
use SAE::REFERENCE;
use SAE::SCORE;
use SAE::ECR;
use SAE::WEATHER;
use SAE::FLIGHT;
use SAE::CARD;
use SAE::MICRO;



my $q = new CGI;
my $qs = new CGI($ENV{'QUERY_STRING'});
my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $Auth = new SAE::Auth();
my $Auto = new SAE::AUTO();
# &_welcome();
# &_register();
# &_testLogin();
# &_getMenuItem();
# &autoAssign(24);
# &idJudges();
# &testScore();
# &testAvailableAssessments();
my $teamIDX = $ARGV[0];
my $inRound = $ARGV[1];

&test($teamIDX, $inRound);

sub template(){
    print "\n***********************************\n\n";
    print "test template\n";


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

