package SAE::REFERENCE;

use DBI;
use SAE::SDB;
use SAE::RUBRIC;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _getReinspectListByEvent(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT TD.*, T.*, F.IN_ROUND FROM TB_TODO AS TD JOIN TB_TEAM as T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX JOIN TB_FLIGHT AS F ON TD.FK_FLIGHT_IDX=F.PK_FLIGHT_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($location, 4);
    my %HASH = %{$select->fetchall_hashref('PK_TODO_IDX')};   
    return (\%HASH);
}
sub _getEventPreference(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_PREF";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['FK_USER_IDX', 'FK_EVENT_IDX'])}; 
    return (\%HASH);
}
sub _updateUserAttribute(){
    my $self = shift;
    my $userIDX = shift;
    my $field = shift;
    my $val = shift;
    my $SQL = "UPDATE TB_USER SET $field=? WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($val, $userIDX);
}
sub _getClassPreference(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_PREF";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['FK_USER_IDX', 'FK_CLASS_IDX'])}; 
    return (\%HASH);
}
sub _getListofJudges(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE>?";
    my $select = $dbi->prepare($SQL);
       $select->execute(0);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
}
sub _addClassPreference(){
    my $self = shift;
    my $userIDX = shift;
    my $classIDX = shift;
    my $SQL = "INSERT INTO TB_PREF (FK_USER_IDX, FK_CLASS_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($userIDX, $classIDX);
}

sub _removeClassPreference(){
    my $self = shift;
    my $userIDX = shift;
    my $classIDX = shift;
    my $SQL = "DELETE FROM TB_PREF WHERE (FK_USER_IDX=? AND FK_CLASS_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($userIDX, $classIDX);
}

sub _addEventPreference(){
    my $self = shift;
    my $userIDX = shift;
    my $eventIDX = shift;
    my $SQL = "INSERT INTO TB_PREF (FK_USER_IDX, FK_EVENT_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($userIDX, $eventIDX);
}

sub _removeEventPreference(){
    my $self = shift;
    my $userIDX = shift;
    my $eventIDX = shift;
    my $SQL = "DELETE FROM TB_PREF WHERE (FK_USER_IDX=? AND FK_EVENT_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($userIDX, $eventIDX);
}


sub _getUserDataByID(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "SELECT * FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX);
    my %HASH = %{$select->fetchrow_hashref()}; 
    return (\%HASH);
}
sub _getUserAccessById(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "SELECT FK_TILES_IDX FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TILES_IDX')}; 
    return (\%HASH);
}
sub _updateUserLevelById(){
    my $self = shift;
    my $userIDX = shift;
    my $inLevel = shift;
    my $SQL = "UPDATE TB_USER SET IN_USER_TYPE=? WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($inLevel, $userIDX);
    return;
}
sub _getClassList(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_CLASS";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_CLASS_IDX')}; 
    return (\%HASH);
}
sub _getCardTypeList(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_CARDTYPE";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')}; 
    return (\%HASH);
}
sub _deleteRecord(){
    my $self = shift;
    my $table = shift;
    my $key = shift;
    my $idx = shift;
    my $SQL = "DELETE FROM $table WHERE $key=$idx";
    my $delete=$dbi->prepare($SQL);
       $delete->execute() || die "Cannot Delete $SQL";
    return
}
sub _getEventList(){
     my $self = shift;
    my $SQL = "SELECT * FROM TB_EVENT WHERE BO_ARCHIVE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(0);
    my %HASH = %{$select->fetchall_hashref('PK_EVENT_IDX')}; 
    return (\%HASH);
}
sub _getUserRecord(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "SELECT * FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
}
sub _getGroups(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_GROUP";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_GROUP_IDX')}; 
    return (\%HASH);
}
sub _getGroupInAccess(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_GROUP";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('IN_ACCESS')}; 
    return (\%HASH);
}
sub _getTypeTiles(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_TILES";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['IN_TYPE','PK_TILES_IDX'])}; 
    return (\%HASH);
}
sub _getGroupAccess(){
    my $self = shift;
    my $groupIDX = shift;
    my $SQL = "SELECT * FROM TB_GROUP_ACCESS WHERE FK_GROUP_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($groupIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TILES_IDX')}; 
    return (\%HASH);
}
sub _getGroupMembership(){
   my $self = shift;
   my $groupIDX = shift;
   my $SQL = "SELECT * FROM TB_USER WHERE FK_GROUP_IDX=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($groupIDX);
   my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
   return (\%HASH);
}
sub _getListOfTeamsByEventId(){
   my $self = shift;
   my $location = shift;
   my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
   # my $SQL = "SELECT TEAM.PK_TEAM_IDX, IN_NUMBER, TX_SCHOOL FROM TB_TEAM AS TEAM LEFT JOIN TB_USER_TEAM AS UTEAM ON TEAM.PK_TEAM_IDX=UTEAM.FK_TEAM_IDX WHERE (UTEAM.FK_TEAM_IDX IS NULL AND TEAM.FK_EVENT_IDX=?)";
   my $select = $dbi->prepare($SQL);
      $select->execute($location);
   my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
   return (\%HASH);
}
sub _getUserTeamList(){
   my $self = shift;
   my $userIDX = shift;
   my $location = shift;
   
   my $SQL = "SELECT LIST.PK_USER_TEAM_IDX, TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, TEAM.TX_COUNTRY 
    FROM TB_USER_TEAM AS LIST JOIN TB_TEAM AS TEAM ON LIST.FK_TEAM_IDX=TEAM.PK_TEAM_IDX WHERE (LIST.FK_USER_IDX=? AND TEAM.FK_EVENT_IDX=?)";
   my $select = $dbi->prepare($SQL);
      $select->execute( $userIDX, $location );
   my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
   return (\%HASH);
}
sub _getTeamUserList(){
   my $self = shift;
   my $teamIDX = shift;
   my $SQL = "SELECT LIST.PK_USER_TEAM_IDX, USER.PK_USER_IDX, USER.TX_FIRST_NAME, USER.TX_EMAIL, USER.TX_LAST_NAME FROM TB_USER_TEAM AS LIST JOIN TB_USER AS USER ON LIST.FK_USER_IDX=USER.PK_USER_IDX WHERE LIST.FK_TEAM_IDX=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($teamIDX);
   my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
   return (\%HASH);
}
sub _getTeamSubscriptionByID(){
   my $self = shift;
   my $userIDX = shift;
   my $location = shift;
   my $SQL = "SELECT UT.*, T.IN_NUMBER, T.TX_SCHOOL FROM TB_USER_TEAM AS UT 
	JOIN TB_TEAM AS T ON UT.FK_TEAM_IDX=T.PK_TEAM_IDX 
    WHERE UT.FK_USER_IDX=? AND T.FK_EVENT_IDX=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($userIDX, $location);
   my %HASH = %{$select->fetchall_hashref('PK_USER_TEAM_IDX')}; 
   return (\%HASH);
}

sub _getTeamData(){
   my $self = shift;
   my $teamIDX = shift;
   my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($teamIDX);
   my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
   return (\%HASH);
}
sub _getTeamDataByClass(){
    my $self = shift;
    my $location = shift;
    my $classIDX = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location, $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
   return (\%HASH);
    
}
sub _getTeamDataByEvent(){
   my $self = shift;
   my $location = shift;
   my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($location);
   my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
   return (\%HASH);
}
sub _getTeamDataLocation(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('IN_NUMBER')}; 
    return (\%HASH);
}
sub _getTeamIDX_ByNumber(){
    my $self = shift;
    my $inNumber = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE IN_NUMBER=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($inNumber);
    my %HASH = %{$select->fetchall_hashref('IN_NUMBER')}; 
   my $teamIDX = $HASH{$inNumber}{PK_TEAM_IDX};
    return ($teamIDX);
}
sub _getUserList(){
   my $self = shift;
   my $SQL = "SELECT * FROM TB_USER ";
   my $select = $dbi->prepare($SQL);
      $select->execute();
   my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
   return (\%HASH);
}
sub _getTeamIDXByTeamCode(){
   my $self = shift;
   my $teamCode = shift;
   my $SQL = "SELECT PK_TEAM_IDX FROM TB_TEAM WHERE TX_CODE=?";
   my $select = $dbi->prepare($SQL);
      $select->execute($teamCode);
  my $teamIDX = $select->fetchrow_array();
   return ($teamIDX);
}
sub _getCountryListByName(){
   my $self = shift;
   my $SQL = "SELECT * FROM TB_COUNTRY";
   my $select = $dbi->prepare($SQL);
      $select->execute();
   my %HASH = %{$select->fetchall_hashref('TX_COUNTRY')}; 
   return (\%HASH);
}
sub _getCountryList(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_COUNTRY";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_COUNTRY_IDX')}; 
    return (\%HASH);
}
sub _getAvailableAssessments(){
   my $self = shift;
   my $inType=shift;
   my $location=shift;
   my %LIMIT = (1=>3, 2=>1, 3=>1, 4=>1);
   my $SQL = "SELECT PK_TEAM_IDX, IN_NUMBER, TX_SCHOOL FROM TB_TEAM WHERE FK_EVENT_IDX=?";
   my $select = $dbi -> prepare($SQL);
      $select -> execute($location);
   %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};
   # print scalar(keys %TEAMS);
   $SQL = "SELECT CARD.FK_TEAM_IDX, CARD.FK_CARDTYPE_IDX, COUNT(CARD.FK_TEAM_IDX) AS inCount 
      FROM TB_CARD AS CARD WHERE (FK_EVENT_IDX=? AND CARD.FK_CARDTYPE_IDX=?) 
      GROUP BY FK_TEAM_IDX, FK_CARDTYPE_IDX";
   $select = $dbi -> prepare($SQL);
   $select -> execute($location, $inType);
   %SEEN = %{$select->fetchall_hashref('FK_TEAM_IDX')};
   foreach $teamIDX (sort keys %TEAMS){
      if (exists $SEEN{$teamIDX} && $SEEN{$teamIDX}{inCount} >= $LIMIT{$inType}){
         delete $TEAMS{$teamIDX};
      }
   }
   return (\%TEAMS);
}
sub _getListOfAssignedCards(){
   my $self = shift;
   my $location=shift;
   my $userIDX=shift;
   my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.FK_USER_IDX, CARD.FK_TEAM_IDX, CARD.FK_CARDTYPE_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL 
        FROM TB_CARD AS CARD JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE (CARD.FK_EVENT_IDX=?) AND (CARD.FK_USER_IDX=?)";
      #   print $SQL."\n$location, $userIDX\n\n";
   $select = $dbi->prepare($SQL);
   $select->execute($location, $userIDX);
   %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_TEAM_IDX'])};
   return (\%HASH);
}
# =====================================================================================================
#  DELETES
# =====================================================================================================
sub _removeAssignedJudgesByStatus(){
    my $self = shift;
    my $inStatus = shift;
    my $location = shift;
    my $SQL = "DELETE FROM TB_CARD WHERE ((FK_EVENT_IDX=?) AND (IN_STATUS=?) AND (FK_CARDTYPE_IDX=?))";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($location, $inStatus, 1);
    return();
}
# =====================================================================================================
#  Late Reports
# =====================================================================================================
sub _getLateReportListByTeamIDX(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT * FROM TB_LATE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
sub _getLateReportListByEvent(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_LATE WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
}
sub _updateLateReports(){
    my $self = shift;
    my $teamIDX = shift;
    my $inDays = shift;
    my $SQL = "UPDATE TB_LATE SET IN_DAYS=? WHERE FK_TEAM_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($inDays, $teamIDX);
    return;
}
sub _createLateReports(){
    my $self = shift;
    my $teamIDX = shift;
    my $inDays = shift;
    my $location = shift;
    my $SQL = "INSERT INTO TB_LATE (FK_TEAM_IDX, FK_EVENT_IDX, IN_DAYS) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($teamIDX, $location, $inDays);
    return;
}
sub _updateUserInfo(){
    my $self = shift;
    my $txFirstName = shift;
    my $txLastName = shift;
    my $txEmail = shift;
    my $userIDX = shift;
    my $SQL = "UPDATE TB_USER SET TX_FIRST_NAME=?, TX_LAST_NAME=?, TX_LOGIN=?, TX_EMAIL=? WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($txFirstName,$txLastName,$txEmail, $txEmail, $userIDX );
    return;
}

# =====================================================================================================
#  REPORTS
# =====================================================================================================
sub _getDocuments(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_UPLOAD_IDX'])}; 
    return (\%HASH);
}
sub _getTeamDocuments(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT FK_TEAM_IDX, TX_KEYS, TX_PAPER, IN_PAPER FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','IN_PAPER'])}; 
    return (\%HASH);
}
# =====================================================================================================
#  CALCULATION
# =====================================================================================================
# PAPER SCORES
sub _calculatePaperScores(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $inType = shift;
    my $Rubric=new SAE::RUBRIC();
    my $score = 0;
    my $sectionScore = 0;
    my $SQL = "SELECT * FROM TB_CARDTYPE";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %CARDTYPE = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')}; 
    my $PaperTotal = $CARDTYPE{$inType}{IN_POINTS};
    # print "\$teamIDX  = $teamIDX, \$cardIDX=$cardIDX\n ";
    # print "\$inType=$inType, \$PaperTotal=$PaperTotal\n";

    $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
        JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
        WHERE (CARD.FK_TEAM_IDX=? AND CARD.PK_CARD_IDX=?)
        GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $cardIDX);
    %SCORE = %{$select->fetchall_hashref('FK_SECTION_IDX')};
    # print "Total Record = ".scalar(keys %SCORE)."\n";
    %SECTION = %{$Rubric->_getSectionList()};
    foreach $sectionIDX (sort {$a<=>$b} keys %{$SECTION{$inType}}){
        my $inWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
        my $average = $SCORE{$sectionIDX}{IN_AVERAGE};
        my $MaxSectionScore = $PaperTotal * $inWeight /100;
        $sectionScore = ($inWeight/100) * ($average / 100) * $PaperTotal;
        # print "Weight = $inWeight\tAverage Score = $average\tMax Section = $MaxSectionScore \tSection Score = $sectionScore \n";
        $score += $sectionScore;
    }
    return ($score);
}
# Average By Card
sub _getCardSectionAverage(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
            JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
            JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
            WHERE (CARD.FK_TEAM_IDX=? AND CARD.PK_CARD_IDX=?)
            GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $cardIDX);
    %HASH = %{$select->fetchall_hashref(FK_SECTION_IDX)};
    return (\%HASH);
}
#  OVERALL =====
sub _getSectionAverage(){
    my $self = shift;
    my $teamIDX = shift;
    my $inType = shift;
    my $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
            JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
            JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
            WHERE (CARD.FK_TEAM_IDX=? AND CARD.FK_CARDTYPE_IDX=?)
            GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $inType);
    %HASH = %{$select->fetchall_hashref(FK_SECTION_IDX)};
    return (\%HASH);
}

return (1);