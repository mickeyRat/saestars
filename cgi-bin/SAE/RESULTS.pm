package SAE::RESULTS;

use DBI;
use SAE::SDB;
use SAE::GRADE;
use SAE::TEAM;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ========================= 2022 ===============================================
# ------------------------- GETTERS --------------------------------------------
sub _displayResults (){
   my ($self, $key) = @_;
   my $SQL    = "SELECT PK_PUBLISH_IDX, FK_EVENT_IDX, IN_TYPE, TX_TITLE, FK_CLASS_IDX, TX_CLASS, TX_TIME FROM TB_PUBLISH WHERE TX_FILE=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($key);
   my ($publishIDX, $eventIDX, $inType, $txTitle, $classIDX, $txClass, $txTime) = $select->fetchrow_array();
   my $str;
   # $str .= "$publishIDX, $eventIDX, $inType, $txTitle, $classIDX, $txClass, $txTime";
   $str = &getResults($publishIDX, $eventIDX, $classIDX, $txClass, $txTime, $inType);
   return ($str);
   }
sub getResults (){
   my ($publishIDX, $eventIDX, $classIDX, $txClass, $txTime, $inType) = @_;
   my %TITLE   = (1=>'Design', 2=>'Presentation', 3=>'Mission', 4=>'Overall');
   my $Team    = new SAE::TEAM();
   my %TEAMS   = %{$Team->_getTeamListByClass($eventIDX, $classIDX)};
   my %SCORE   = %{&getTeamList($publishIDX)};
   my $str;
   foreach $teamIDX (sort keys %SCORE) {
         my $inPenalty = $TEAMS{$teamIDX}{IN_DAYS}*5;
         $TEAMS{$teamIDX}{IN_SCORE} = $SCORE{$teamIDX}{IN_SCORE}-$inPenalty;
         $TEAMS{$teamIDX}{IN_PENALTY} = $inPenalty;
         if ($TEAMS{$teamIDX}{IN_SCORE}<0){$TEAMS{$teamIDX}{IN_SCORE} = 0}
      if ($inType == 4) {
         my $inPenalty = $TEAMS{$teamIDX}{IN_DAYS}*5;
         $TEAMS{$teamIDX}{IN_DESIGN}  = $SCORE{$teamIDX}{IN_DESIGN} - $inPenalty;
         $TEAMS{$teamIDX}{IN_PRESO}   = $SCORE{$teamIDX}{IN_PRESO};
         $TEAMS{$teamIDX}{IN_MISSION} = $SCORE{$teamIDX}{IN_MISSION};
         $TEAMS{$teamIDX}{IN_PENALTY} = $SCORE{$teamIDX}{IN_PENALTY};
      }
   }
   if ($inType == 4) {
         $str .= &results_overallTableTemplate($TITLE{$inType}, $txClass, $txTime, $inType, \%TEAMS);
      } else {
         $str .= &results_tableTemplate($TITLE{$inType}, $txClass, $txTime, $inType, \%TEAMS);
      }
   
   return ($str);
   }
sub results_overallTableTemplate (){
   my ($txTitle, $txClass, $txTime, $inType, $teams) = @_;
   my $Team   = new SAE::TEAM();
   my %TEAMS  = %{$teams};
   $str .= sprintf '<h1>%s Results - %s</h1>', $txTitle, $txClass;
   $str .= '<div class="w3-container">';
   $str .= '<div class="w3-responsive">';
   $str .= '<table class="table table-sortable w3-table-all">';
   $str .= '<thead>';
   $str .= '<tr>';
   $str .= '<th data-type="string" style="width: 50px;" >Rank</th>';
   $str .= '<th data-type="int"    style="width: 50px;" >#</th>';
   $str .= '<th data-type="string" style="width: 175px;" >Country</th>';
   $str .= '<th data-type="string" style="             " >University (Team)</th>';
   $str .= '<th data-type="float"  style="width: 100px;" >Design</th>';
   $str .= '<th data-type="float"  style="width: 100px;" >Presentation</th>';
   $str .= '<th data-type="float"  style="width: 100px;" >Mission</th>';
   $str .= '<th data-type="float"  style="width: 100px;" >Penalties</th>';
   $str .= '<th data-type="float"  style="width: 100px; text-align: right;" >Score</th>';
   $str .= '</tr>';
   $str .= '</thead>';
   my $i = 1;
   $str .= '<tbody>';
   foreach $teamIDX (sort {$TEAMS{$b}{IN_SCORE} <=> $TEAMS{$a}{IN_SCORE}} keys %TEAMS) {
      $str .= sprintf '<tr>';
      if ($TEAMS{$teamIDX}{IN_SCORE}){
            $str .= sprintf '<td class="w3-left">%d</td>', $i++;
         } else {
            $str .= sprintf '<td class="w3-left">N/R</td>';
         }
      $str .= sprintf '<td >%003d</td>', $TEAMS{$teamIDX}{IN_NUMBER};
      $str .= sprintf '<td >%s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
      $str .= sprintf '<td >%s (<i>%s</i>)</td>', $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_NAME};
      $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $TEAMS{$teamIDX}{IN_DESIGN};
      $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $TEAMS{$teamIDX}{IN_PRESO};
      $str .= sprintf '<td style="text-align: right;">%2.4f</td>', $TEAMS{$teamIDX}{IN_MISSION};
      $str .= sprintf '<td class="w3-text-red" style="text-align: right; ">%2.1f</td>', $TEAMS{$teamIDX}{IN_PENALTY};
      $str .= sprintf '<td style="text-align: right; font-weight: bold;">%2.4f</td>', $TEAMS{$teamIDX}{IN_SCORE};
      $str .= sprintf '</tr>';
   }
   $str .= '</tbody>';
   $str .= '</table>';
   $str .= sprintf '<span class="w3-small">Generated on: <i>%s</i></span>', $txTime;
   $str .= '</div>';
   $str .= '<p class="w3-small">* N/R = Not Ranked</p>';
   $str .= '</div>';
   return ($str);
   }
sub results_tableTemplate (){
   my ($txTitle, $txClass, $txTime, $inType, $teams) = @_;
   my $Team   = new SAE::TEAM();
   my %TEAMS  = %{$teams};
   $str .= sprintf '<h1>%s Results - %s</h1>', $txTitle, $txClass;
   $str .= '<div class="w3-container">';
   $str .= '<div class="w3-responsive">';
   $str .= '<table class="table table-sortable w3-table-all">';
   $str .= '<thead>';
   $str .= '<tr>';
   $str .= '<th data-type="string" style="width: 50px;" >Rank</th>';
   $str .= '<th data-type="int"    style="width: 50px;" >#</th>';
   $str .= '<th data-type="string" style="width: 175px;" >Country</th>';
   $str .= '<th data-type="string" style="             " >University (Team)</th>';
   if ($inType==1){
      $str .= '<th data-type="float"  style="width: 100px;" >Penalty</th>';
   }
   
   $str .= '<th data-type="float"  style="width: 100px; text-align: right" >Score</th>';
   $str .= '</tr>';
   $str .= '</thead>';
   my $i = 1;
   $str .= '<tbody>';
   foreach $teamIDX (sort {$TEAMS{$b}{IN_SCORE} <=> $TEAMS{$a}{IN_SCORE}} keys %TEAMS) {
      $str .= sprintf '<tr>';
      if ($TEAMS{$teamIDX}{IN_SCORE}){
            $str .= sprintf '<td class="w3-left">%d</td>', $i++;
         } else {
            $str .= sprintf '<td class="w3-left">N/R</td>';
         }
      $str .= sprintf '<td >%003d</td>', $TEAMS{$teamIDX}{IN_NUMBER};
      $str .= sprintf '<td >%s</td>', $TEAMS{$teamIDX}{TX_COUNTRY};
      $str .= sprintf '<td >%s (<i>%s</i>)</td>', $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_NAME};
      if ($inType==1){
         # $str .= '<th data-type="float"  style="width: 100px;" >Penalty</th>';
         $str .= sprintf '<td class="w3-text-red" style="text-align: right;">%2.1f</td>', $TEAMS{$teamIDX}{IN_PENALTY};
      }
      $str .= sprintf '<td style="text-align: right; font-weight: bold;">%2.4f</td>', $TEAMS{$teamIDX}{IN_SCORE};
      $str .= sprintf '</tr>';
   }
   $str .= '</tbody>';
   $str .= '</table>';
   $str .= sprintf '<span class="w3-small">Generated on: <i>%s</i></span>', $txTime;
   $str .= '</div>';
   $str .= '<p class="w3-small">* N/R = Not Ranked</p>';
   $str .= '</div>';
   return ($str);
   }
sub getTeamList(){
   my ($publishIDX) = @_;
   my $SQL = "SELECT * FROM TB_RESULTS WHERE FK_PUBLISH_IDX=?";
   my $select = $dbi->prepare($SQL);
      $select->execute( $publishIDX );
   my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
   return(\%HASH);
   }
# ------------------------- SETTERS --------------------------------------------
# ------------------------- DELETES --------------------------------------------
# ------------------------- OTHERS  --------------------------------------------

return (1);