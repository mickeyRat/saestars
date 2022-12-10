#!/usr/bin/perl
use cPanelUserConfig;
use DBI;

use SAE::TB_TEAM();
my $eventIDX = $ARGV[0];

my $dbi = new SAE::Db();
# use SAE::MICRO;
# use SAE::REGULAR;
# use SAE::ADVANCED;
# system ('clear');

my $Team = new SAE::TB_TEAM();
my %TEAMS = %{$Team->getAllRecordBy_FkEventIdx($eventIDX)};
my $SQL = "UPDATE TB_TEAM SET TX_CODE=? WHERE PK_TEAM_IDX=?";
my $update = $dbi->prepare($SQL);

foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
    printf "%-5s%-30s%d\n", $TEAMS{$teamIDX}{IN_NUMBER}, substr($TEAMS{$teamIDX}{TX_SCHOOL},0,27), &_codeGen(8);
    my $code = &_codeGen(8);
    $update->execute($code, $teamIDX);
}


sub _codeGen(){
    my ($length) = @_;
    if (!$length){$length = 8}
    my @chars = (1..9);
    my $str;
    $str .= $chars[rand @chars] for 1..$length;
    return ($str);
}
# my $class = substr ($ARGV[0],0,3);
# my $expand = $ARGV[1];
# my $inRound = $ARGV[2];
# if (lc($class) eq 'mic'){
#     print "\n***********************************\n";
#     print "Checking $class Class";
#     print "\n***********************************\n\n";
#     if ($expand eq '-e'){
#         &checkExpand($classIDX, $inRound);
#     } else {
#         &checkCompress($classIDX, $inRound);
#     }
# } elsif (lc($class) eq 'adv') {
#     print "\n***********************************\n";
#     print "Checking $class Class";
#     print "\n***********************************\n\n";
#     if ($expand eq '-e'){
#         &checkExpand_adv($classIDX, $inRound);
#     } else {
#         &checkCompress_adv($classIDX, $inRound);
#     }
# } else {
#     print "\n***********************************\n";
#     print "Checking $class Class Class";
#     print "\n***********************************\n\n";
#     if ($expand eq '-e'){
#         &checkExpand_reg($classIDX, $inRound);
#     } else {
#         &checkCompress_reg($classIDX, $inRound);
#     }
    
# }

# sub template(){
#     print "\n***********************************\n";
#     print "test template\n";


#     print "\n\n***********************************\n\n";
# }
# # MICRO CLASS *****************************************************************
# sub checkExpand(){
#     my ($classIDX, $inRound) = @_;
#     my $Micro = new SAE::MICRO(29);
#     my %TEAM = %{$Micro->_getMicroTeamList()};
#     foreach $teamIDX (sort keys %TEAM) {
#         $TEAM{$teamIDX}{IN_FFS} = $Micro->_getTeamFinalScore($teamIDX, $inRound);
#     }
#     my %STATUS = (0=>"No", 1=>"Yes");
#     print "EXPANDED VIEW\n";
#     foreach $teamIDX (sort {$TEAM{$b}{IN_FFS} <=> $TEAM{$a}{IN_FFS}} keys %TEAM) {
#         my %LOGS = %{$Micro->_getTeamScoreCard($teamIDX)};
#         printf "\n\n%-5s%-30s%20s%5s%10s%10s%10s%10s%10s%10s%10s%10s%10s\n",'No.', 'Team School','Country','Rnd','L-BOX', 'S-BOX', 'PAYLOAD', 'TOF', 'DAMAGE', 'MINOR', 'MAJOR', 'BONUS', 'FS';
#         print '-' x 150;
#         print "\n";
#         for ($rnd=1; $rnd<=$inRound; $rnd++) {
#             printf "%-5s", $TEAM{$teamIDX}{IN_NUMBER};
#             printf "%-30s", substr($TEAM{$teamIDX}{TX_SCHOOL},0,27);
#             printf "%20s", $TEAM{$teamIDX}{TX_COUNTRY};
#             printf "%5s", $rnd;
#             printf "%10d", $LOGS{$rnd}{IN_LARGE};
#             printf "%10d", $LOGS{$rnd}{IN_SMALL};
#             printf "%10.2f", $LOGS{$rnd}{IN_WEIGHT};
#             printf "%10d", $LOGS{$rnd}{IN_TOF};
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_DAMAGE}};
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_PEN_MINOR}};
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_PEN_LANDING}};
#             printf "%10.2f", $LOGS{$rnd}{IN_BONUS};
#             printf "%10.4f", $LOGS{$rnd}{IN_FS};
#             print "\n";
#         }
#         print '-'x150;
#         print "\n";
#         printf "%140s%10.4f", 'SUM OF TOP 3 FLIGHT SCORES', $TEAM{$teamIDX}{IN_FFS};
#         print "\n\n";
#         print '_'x150;
#         print "\n\n";
#     }
#     print "\n\n";
    
# }
# sub checkCompress(){
#     my ($classIDX, $inRound) = @_;
#     my $Micro = new SAE::MICRO(29);
#     my %TEAM = %{$Micro->_getMicroTeamList()};
#     foreach $teamIDX (sort keys %TEAM) {
#         $TEAM{$teamIDX}{IN_FFS} = $Micro->_getTeamFinalScore($teamIDX, $inRound);
#     }
#     printf "\n\n(Round $inRound) - SUMMARY VIEW\n%-5s%-40s%20s%10s\n",'No.', 'Team School','Country','FFS';
#     print '-' x 75;
#     print "\n";
#     foreach $teamIDX (sort {$TEAM{$b}{IN_FFS} <=> $TEAM{$a}{IN_FFS}} keys %TEAM) {
#         printf "%-5s", $TEAM{$teamIDX}{IN_NUMBER};
#         printf "%-40s", substr($TEAM{$teamIDX}{TX_SCHOOL},0,37);
#         printf "%20s", $TEAM{$teamIDX}{TX_COUNTRY};
#         printf "%10.4f", $TEAM{$teamIDX}{IN_FFS};
#         print "\n";
#         # print "$TEAM{$teamIDX}{IN_NUMBER}\t$TEAM{$teamIDX}{TX_SCHOOL}\t$TEAM{$teamIDX}{TX_COUNTRY}\n";
#     }
#     print "\n\n";
    
# }

# # ADVACNED CLASS **************************************************************
# sub checkExpand_adv(){
#     my ($classIDX, $inRound) = @_;
#     my $Advanced = new SAE::ADVANCED(29);
#     my %TEAM = %{$Advanced->_getTeamList()};
#     my %STATUS = (0=>"No", 1=>"Yes", ''=>'--');
#     printf "\n\n%-5s%-30s%20s%5s%10s%10s%10s%10s%10s%10s%10s%10s\n",'No.', 'Team School','Country','Rnd','# Col.', '# Hab.', 'Water', 'Payload', 'MINOR', 'MAJOR', 'SCORE';
#     foreach $teamIDX (sort keys %TEAM) {
#         my %FINAL = %{$Advanced->_getTeamFinalScore($teamIDX, $inRound)};
#         $TEAM{$teamIDX}{IN_DAYS} = $FINAL{$teamIDX}{IN_DAYS};
#         $TEAM{$teamIDX}{IN_FFS} = $FINAL{$teamIDX}{IN_FFS};
#     }
#     # foreach $teamIDX (sort keys %TEAM) {
#         foreach $teamIDX (sort {$TEAM{$b}{IN_FFS} <=> $TEAM{$a}{IN_FFS}} keys %TEAM) {
#         my %LOGS = %{$Advanced->_getTeamScoreCard($teamIDX)};
#         my %FINAL = %{$Advanced->_getTeamFinalScore($teamIDX, $inRound)};
#         for ($rnd=1; $rnd<=$inRound; $rnd++) {
#             printf "%-05d", $TEAM{$teamIDX}{IN_NUMBER};
#             printf "%-30s", substr($TEAM{$teamIDX}{TX_SCHOOL},0,27);
#             printf "%20s", $TEAM{$teamIDX}{TX_COUNTRY};
#             printf "%5s", $rnd;
#             printf "%10.1f", $LOGS{$rnd}{IN_COLONIST};
#             printf "%10.1f", $LOGS{$rnd}{IN_HABITAT};
#             printf "%10.4f"  , $LOGS{$rnd}{IN_WATER};
#             printf "%10.4f", $LOGS{$rnd}{IN_WEIGHT};
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_PEN_MINOR}};
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_PEN_LANDING}};
#             print "\n";
#         }
#         print '-'x130;
#         print "\n";
#         printf "%120s%10.4f\n", 'Total Days of Habitability', $TEAM{$teamIDX}{IN_DAYS};
#         printf "%120s%10.4f\n", 'Final Flight Score', $TEAM{$teamIDX}{IN_FFS};
#         print "\n\n";
#         print '_'x130;
#         print "\n\n";
#     }
    
# }

# sub checkCompress_adv(){
#     my ($classIDX, $inRound) = @_;
#     my $Advanced = new SAE::ADVANCED(29);
#     my %TEAM = %{$Advanced->_getTeamList()};
#     my %STATUS = (0=>"No", 1=>"Yes", ''=>'--');
#     foreach $teamIDX (sort keys %TEAM) {
#         my %FINAL = %{$Advanced->_getTeamFinalScore($teamIDX, $inRound)};
#         $TEAM{$teamIDX}{IN_DAYS} = $FINAL{$teamIDX}{IN_DAYS};
#         $TEAM{$teamIDX}{IN_FFS} = $FINAL{$teamIDX}{IN_FFS};
#     }
#     printf "\n\n(Round $inRound) - SUMMARY VIEW\n%-5s%-40s%20s%10s\n",'No.', 'Team School','Country','FFS';
#     print '-' x 75;
#     print "\n";
#     foreach $teamIDX (sort {$TEAM{$b}{IN_FFS} <=> $TEAM{$a}{IN_FFS}} keys %TEAM) {
#         printf "%-5s", $TEAM{$teamIDX}{IN_NUMBER};
#         printf "%-40s", substr($TEAM{$teamIDX}{TX_SCHOOL},0,37);
#         printf "%20s", $TEAM{$teamIDX}{TX_COUNTRY};
#         printf "%10.4f", $TEAM{$teamIDX}{IN_FFS};
#         print "\n";
#         # print "$TEAM{$teamIDX}{IN_NUMBER}\t$TEAM{$teamIDX}{TX_SCHOOL}\t$TEAM{$teamIDX}{TX_COUNTRY}\n";
#     }
#     print "\n\n";
    
# }

# # REGULAR CLASS ***************************************************************
# sub checkExpand_reg(){
#     my ($classIDX, $inRound) = @_;
#     my $Regular = new SAE::REGULAR(29);
#     my %TEAM = %{$Regular->_getTeamList()};
#     my %STATUS = (0=>"No", 1=>"Yes", ''=>'--');
#     printf "\n\n%-5s%-30s%20s%5s%10s%10s%10s%10s%10s%10s%10s%10s%10s%10s\n",'No.', 'Team School','Country','Rnd','L-CARGO', 'SPAN', '# BALLS', 'PAYLOAD', 'DEN-ALT', 'MINOR', 'MAJOR', 'BONUS', 'FS';
#     foreach $teamIDX (sort keys %TEAM) {
#         my ($ffs, $bonus) = $Regular->_getTeamFinalScore($teamIDX, $inRound);
#         $TEAM{$teamIDX}{IN_FFS} = $ffs + $bonus;
#         $TEAM{$teamIDX}{IN_RAW} = $ffs;
#         $TEAM{$teamIDX}{IN_PPB} = $bonus;
#         $Regular->_getTeamFinalScore($teamIDX,$inRound);
#     }
#     # foreach $teamIDX (sort keys %TEAM) {
#         foreach $teamIDX (sort {$TEAM{$b}{IN_FFS} <=> $TEAM{$a}{IN_FFS}} keys %TEAM) {
#         my %LOGS = %{$Regular->_getTeamScoreCard($teamIDX)};
#         for ($rnd=1; $rnd<=$inRound; $rnd++) {
#             printf "%-05d", $TEAM{$teamIDX}{IN_NUMBER};
#             printf "%-30s", substr($TEAM{$teamIDX}{TX_SCHOOL},0,27);
#             printf "%20s", $TEAM{$teamIDX}{TX_COUNTRY};
#             printf "%5s", $rnd;
#             printf "%10.2f", $LOGS{$rnd}{IN_LCARGO};
#             printf "%10.2f", $LOGS{$rnd}{IN_SPAN};
#             printf "%10d"  , $LOGS{$rnd}{IN_SPHERE};
#             printf "%10.2f", $LOGS{$rnd}{IN_WEIGHT};
#             printf "%10.2f", $LOGS{$rnd}{IN_DENSITY};
            
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_PEN_MINOR}};
#             printf "%10s", $STATUS{$LOGS{$rnd}{IN_PEN_LANDING}};
#             printf "%10.4f", $LOGS{$rnd}{IN_BONUS};
#             printf "%10.4f", $LOGS{$rnd}{IN_FS};
#             print "\n";
#         }
#         print '-'x150;
#         print "\n";
#         printf "%140s%10.4f\n", 'BEST FLIGHTS (RAW)', $TEAM{$teamIDX}{IN_RAW};
#         printf "%140s%10.4f\n", 'HIGHEST BONUS (PPB)', $TEAM{$teamIDX}{IN_PPB};
#         printf "%140s%10.4f", 'OVERALL SCORE (FFS)', $TEAM{$teamIDX}{IN_FFS};
#         print "\n\n";
#         print '_'x150;
#         print "\n\n";
#     }
    
# }

# sub checkCompress_reg(){
#     my ($classIDX, $inRound) = @_;
#     my $Regular = new SAE::REGULAR(29);
#     my %TEAM = %{$Regular->_getTeamList()};
#     foreach $teamIDX (sort keys %TEAM) {
#         # $TEAM{$teamIDX}{IN_FFS} = $Micro->_getTeamFinalScore($teamIDX, $inRound);
#         my ($ffs, $bonus) = $Regular->_getTeamFinalScore($teamIDX, $inRound);
#         $TEAM{$teamIDX}{IN_FFS} = $ffs + $bonus;
#         $TEAM{$teamIDX}{IN_RAW} = $ffs;
#         $TEAM{$teamIDX}{IN_PPB} = $bonus;
#         $Regular->_getTeamFinalScore($teamIDX,$inRound);
#     }
#     printf "\n\n(Round $inRound) - SUMMARY VIEW\n%-5s%-40s%20s%10s\n",'No.', 'Team School','Country','FFS';
#     print '-' x 75;
#     print "\n";
#     foreach $teamIDX (sort {$TEAM{$b}{IN_FFS} <=> $TEAM{$a}{IN_FFS}} keys %TEAM) {
#         printf "%-5s", $TEAM{$teamIDX}{IN_NUMBER};
#         printf "%-40s", substr($TEAM{$teamIDX}{TX_SCHOOL},0,37);
#         printf "%20s", $TEAM{$teamIDX}{TX_COUNTRY};
#         printf "%10.4f", $TEAM{$teamIDX}{IN_FFS};
#         print "\n";
#         # print "$TEAM{$teamIDX}{IN_NUMBER}\t$TEAM{$teamIDX}{TX_SCHOOL}\t$TEAM{$teamIDX}{TX_COUNTRY}\n";
#     }
#     print "\n\n";
    
# }




