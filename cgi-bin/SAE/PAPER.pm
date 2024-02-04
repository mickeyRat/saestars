package SAE::PAPER;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;

use SAE::PROFILE;
use SAE::GRADE;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ==== 2024 ===============================================
sub _getLateScore (){
    my ($self, $teamIDX) = @_;
    my $SQL         = "SELECT IN_DAYS FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select      = $dbi->prepare($SQL);
       $select -> execute( $teamIDX );
    my ($inDays)    = $select->fetchrow_array();
    my $inLateScore = $inDays * 5;
    return ($inLateScore);
    }
sub getCards(){ #Keep 2024
    my ($teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX<=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX, 4 );
    my %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX', 'PK_CARD_IDX'])};
    return (\%HASH);
    }
sub calculateDesignScores(){
    my ($teamIDX) = @_;
    my $Grade  = new SAE::GRADE();
    my %TYPE   = (1=>'Assessment', 2=>'TDS', 3=>'Drawing', 4=>'Requirement');
    my %CARDS  = %{&getCards($teamIDX)};
    my $inValue = 0;
    foreach $cardTypeIDX (sort keys %CARDS){
        my @SCORES = ();
        foreach $cardIDX (sort keys %{$CARDS{$cardTypeIDX}}) {
            # my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $TYPE{$cardTypeIDX});
            my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $teamIDX);
            push(@SCORES, $score);
        }
        $inValue += mean(@SCORES);
    }
    return ($inValue);
    }
sub _generateDesignScores (){
    my ($self, $eventIDX, $teamIDX) = @_;
    my $inValue = &calculateDesignScores($teamIDX);
    return ($inValue);
    }
sub _autoAssign (){
    my ($self, $eventIDX, $classIDX, $inLimit, $inCardType) = @_;
    my %TEAMS      = %{&getTeamByClass($eventIDX, $classIDX)};
    my $Profile    = new SAE::PROFILE();
    my $User       = new SAE::USER();

    my %JUDGES     = %{$Profile->_getVolunteerList($eventIDX, $classIDX, $inCardType)}; #1 = InType which is Design Assessment.  This is only time we will do auto assign.  Other times, it will be batch assign
    my %COUNT      = %{$Profile->_getVolunteerAssignmentCount($eventIDX, $inCardType, $classIDX)};
    my %INIT       = %{$User->_getUserFirstInitialAndLastName()};
    my %ASSIGN     = ();
    my @LIST_ORG   = ();
    my %BUTTON     = ();
    my $SQL        = "SELECT FK_TEAM_IDX, COUNT(FK_TEAM_IDX) AS IN_COUNT FROM TB_CARD WHERE (FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?) GROUP BY FK_TEAM_IDX";
    my $select     = $dbi->prepare($SQL);
       $select->execute($eventIDX, $inCardType);
    my %CARDCOUNT  = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    # print "inCardType = $inCardType\n";
    # print "Count of COUNT = ".%COUNT."\n";
    # print "Count of JUDGES = ".%JUDGES."\n";


    foreach $userIDX (sort {$a <=> $b} keys %JUDGES) {
        # print "$userIDX LIMIT = $JUDGES{$userIDX}{IN_LIMIT}; COUNT= $COUNT{$userIDX}{IN_COUNT}\n";
        my $count = $JUDGES{$userIDX}{IN_LIMIT} - $COUNT{$userIDX}{IN_COUNT};
        for ($i=1; $i<=$count; $i++){
            push (@LIST_ORG, $userIDX);
        }
    }
    # print "Count of LIST_ORG = ".%LIST_ORG."\n";
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS){
        my @LIST    = @LIST_ORG;                 # Reset Array with all the name of the judges
        my $x = 0;
        do {
            my $index   = int rand(scalar (@LIST));  # Getting Random number based on the count in the array
            my $userIDX = splice(@LIST, $index, 1);  # Get the UserID from the Array.  Use this value to strip the array
            if (!exists $ASSIGN{$teamIDX}{$userIDX}) {
                $ASSIGN{$teamIDX}{$userIDX}=1;
                $CARDCOUNT{$teamIDX}{IN_COUNT}++;
                $COUNT{$userIDX}{IN_COUNT}++;
                # printf "%d\t%d = %d\n", $teamIDX, $index, $userIDX;
            } 
            my @LIST  = @{&stripArray($userIDX, \@LIST)};
            if ($COUNT{$userIDX}{IN_COUNT} >= $JUDGES{$userIDX}{IN_LIMIT}){
                @LIST_ORG = @{&stripArray($userIDX, \@LIST_ORG)};
            }
            $x++;
        } while ($x<3);
    }
    # return;
    my $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_CARDTYPE_IDX, FK_CLASS_IDX) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
    foreach $teamIDX (sort keys %TEAMS) {
        foreach $userIDX (sort keys %{$ASSIGN{$teamIDX}}) {
            if ($userIDX>0){
                $insert->execute($userIDX, $teamIDX, $eventIDX, $inCardType, $classIDX);
                my $newCardIDX = $insert->{q{mysql_insertid}} ;
                my $volName    = $INIT{$userIDX};
                # $BUTTON{$teamIDX}{BUTTON} = &paper_templateJudgeButton(1, $classIDX, $teamIDX, $inCardType, $volName, 0);
                $BUTTON{$teamIDX}{$newCardIDX} = &paper_templateJudgeButton($newCardIDX, $classIDX, $teamIDX, $inCardType, $volName, 0);
            }
        }
    }
    return (\%BUTTON);
    }

sub stripArray(){
    my ($remove, $string) = @_;
    @STRING = @$string;
    @FINAL = grep { $_ != $remove } @STRING;
    return (\@FINAL);
}

sub _getTemplateJudgeButton (){
    my ($self, $cardIDX, $classIDX, $teamIDX, $inType, $volName, $inStatus) = @_;
    my $str = &paper_templateJudgeButton($cardIDX, $classIDX, $teamIDX, $inType, $volName, $inStatus);

    return ($str);
    }
sub paper_templateJudgeButton (){
    my ($cardIDX, $classIDX, $teamIDX, $inType, $volName, $inStatus) = @_;
    my %COLOR      = (0=>'w3-light-grey', 1=>'w3-yellow', 2=>'w3-blue');
    my $bgColor    = $COLOR{$inStatus};
    my $str;
    $str = sprintf '<button ID="JUDGE_BUTTON_%d" class="judgeButton_%d w3-border w3-small w3-button w3-round w3-margin-left %s" onclick="paper_openAssessment(this, %d, %d, %d, %d);">',$cardIDX, $classIDX, $bgColor, $cardIDX, $classIDX, $teamIDX, $inType;
    $str .= sprintf '%s', $volName;
    $str .= sprintf '</button>';
    return ($str);
    }
sub _batchAssign (){
    my ($self, $eventIDX, $classIDX, $userIDX, $inType, $volName) = @_;
    # print "$eventIDX, $classIDX, $userIDX, $inType, $volName\n";
    my $SQL      = "SELECT * FROM TB_CARD WHERE (FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select   = $dbi->prepare($SQL);
       $select->execute($eventIDX, $inType);
    my %ASSIGN   = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    my %BUTTON   = ();
    my $str;
    if ($userIDX == 0) {
            my $SQL = "DELETE FROM TB_CARD WHERE (FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=? AND FK_CLASS_IDX=?)";
            my $delete   = $dbi->prepare($SQL);
               $delete->execute($eventIDX, $inType, $classIDX);
        } else {
            my %TEAMS    = %{&getTeamByClass( $eventIDX, $classIDX )};
            my $SQL         = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_CARDTYPE_IDX, FK_CLASS_IDX) VALUES (?, ?, ?, ?, ?)";
            my $insert   = $dbi->prepare($SQL);
            foreach $teamIDX (sort keys %TEAMS){
                # print "$userIDX, $teamIDX, $eventIDX, \$inType = $inType\n";
                if (exists $ASSIGN{$teamIDX}){next}
                $insert->execute($userIDX, $teamIDX, $eventIDX, $inType, $classIDX);
                my $newCardIDX = $insert->{q{mysql_insertid}} ;
                # print "$newCardIDX\n";
                $BUTTON{$teamIDX}{$newCardIDX} = &paper_templateJudgeButton($newCardIDX, $classIDX, $teamIDX, $inType, $volName, 0);
            }
            return (\%BUTTON);
        }
    }
sub removeFromArray(){
    my ($remove, $string) = @_;
    @STRING = @$string;
    @FINAL = grep { $_ != $remove } @STRING;
    return (\@FINAL);
    }
sub _assignTeamToJudge (){ #keep 2024
    my ($self, $userIDX, $teamIDX, $eventIDX, $inCardType, $classIDX) = @_;
    my $str;
    my $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_CARDTYPE_IDX, FK_CLASS_IDX) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($userIDX, $teamIDX, $eventIDX, $inCardType, $classIDX);
    my $newIDX = $insert->{q{mysql_insertid}} ;
    return ($newIDX);
    }
sub _setAutoAssignVolunteerJudge (){
    my ($self, $eventIDX) = @_;
    # 1. get list of teams for in the class.
    # 2. get list of scoring cards created for the team.
    # 3. push into array of teams that have judges assigned
    # 4. loop through the teams again, and count how many judges are assigned.  
    #    if number of judges is less then the limit for the team, assign new judges until they reach the max limit.
    # 5. Create list of avaialble judges.
    my $Profile    = new SAE::PROFILE();
    my @tm         = localtime();
    my $txYear     = ($tm[5] + 1900);
    my %EVENT      = %{$Profile->_getEventDetails( $eventIDX )};
    my $site       = $EVENT{TX_EVENT}; 
    my %JUDGES     = %{$Profile->_getAvailableJudges($inCardType, $txYear, $site, $classIDX)};
    my $str;

    return ();
    }
sub _getVolunteerStatistics (){
    my ($self, $eventIDX, $userIDX, $classIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.FK_USER_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, REPORT.IN_SEC, REPORT.IN_SUB, PAPER.IN_VALUE, CARD.FK_TEAM_IDX FROM TB_CARD AS CARD
    JOIN TB_PAPER AS PAPER ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX
    JOIN TB_REPORT AS REPORT ON REPORT.PK_REPORT_IDX=PAPER.FK_REPORT_IDX
    JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE CARD.FK_EVENT_IDX=? AND CARD.FK_USER_IDX=? AND TEAM.FK_CLASS_IDX=? AND CARD.FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare( $SQL);
       $select->execute( $eventIDX, $userIDX, $classIDX, 1);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX', 'IN_SEC','IN_SUB'])};
    return (\%HASH);

    return ();
    }
sub _getCardSCcores (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, REPORT.PK_REPORT_IDX, PAPER.PK_PAPER_IDX, PAPER.IN_VALUE, PAPER.CL_FEEDBACK, REPORT.IN_SEC, REPORT.IN_SUB, 
        (CT.IN_POINTS * (PAPER.IN_VALUE/10) * (REPORT.IN_SEC_WEIGHT/100) * (REPORT.IN_SUB_WEIGHT/100)) AS IN_SCORE
        FROM TB_CARD AS CARD 
        JOIN TB_PAPER AS PAPER ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
        JOIN TB_REPORT AS REPORT ON PAPER.FK_REPORT_IDX=REPORT.PK_REPORT_IDX
        JOIN TB_CARDTYPE AS CT ON REPORT.TX_TYPE=CT.TX_TYPE  
    WHERE CARD.FK_TEAM_IDX=?";
    my $select = $dbi->prepare( $SQL);
       $select->execute( $teamIDX );
    my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX','IN_SEC','IN_SUB'])};
    return (\%HASH);
    }

sub _getAllTeamAssessmentStatistics (){
    my ($self, $txType) = @_;
    my $SQL = "SELECT C.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(CARD.IN_POINTS * (PAPER.IN_VALUE/10) * (REPORT.IN_SEC_WEIGHT/100) * (REPORT.IN_SUB_WEIGHT/100)) AS IN_SCORE 
    FROM TB_PAPER AS PAPER
            JOIN TB_REPORT AS REPORT ON REPORT.PK_REPORT_IDX=PAPER.FK_REPORT_IDX
            JOIN TB_CARDTYPE AS CARD ON REPORT.TX_TYPE=CARD.TX_TYPE
            JOIN TB_CARD AS C ON C.PK_CARD_IDX = PAPER.FK_CARD_IDX
        WHERE (CARD.TX_TYPE=?) 
        GROUP BY C.FK_TEAM_IDX, PAPER.FK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType);
    my %SCORES = ();
    while (my ($teamIDX, $cardIDX, $inScore) = $select->fetchrow_array()) {
        $SCORES{$teamIDX}{INIT} = 0;
        push (@{$teamIDX}, $inScore);
    }
    foreach $teamIDX (sort keys %SCORES){
        $SCORES{$teamIDX}{IN_AVG} = sprintf "%2.20f", mean(@{$teamIDX});
        $SCORES{$teamIDX}{IN_STD} = sprintf "%2.20f", stddev(@{$teamIDX});
        $SCORES{$teamIDX}{IN_MIN} = sprintf "%2.20f", min(@{$teamIDX});
        $SCORES{$teamIDX}{IN_MAX} = sprintf "%2.20f", max(@{$teamIDX});
    } 
    return (\%SCORES);
    }
sub getTeamScore_Event (){
    my $eventIDX= $q->param('eventIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;

    return ($str);
    }
sub _getTeamAssessmentStatistics(){
    my ($self, $teamIDX) = @_;
    my @SCORES = ();
    # 1. get team's score card scores
    # 2. add the scores to Array
    # 3. perform statics and return Highm Low, Std, and Mean
    my $Grade   = new SAE::GRADE();
    my $SQL     = "SELECT PK_CARD_IDX FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select  = $dbi->prepare($SQL);
       $select  -> execute($teamIDX, 1);
    while (my ($cardIDX) = $select->fetchrow_array()) {
        my $score = $Grade->_getAssessmentScore_byCard($cardIDX, 'Assessment');
        push(@SCORES, $score);
    }
    my %STAT;
    my $std = sprintf "%2.15f", stddev(@SCORES);
    my $mean = sprintf "%2.15f", mean(@SCORES);
    my $min  = sprintf "%2.2f", min(@SCORES);
    my $max  = sprintf "%2.2f", max(@SCORES);
    $STAT{IN_STD}  = $std;
    $STAT{IN_MEAN}  = $mean;
    $STAT{IN_MIN}  = $min ;
    $STAT{IN_MAX}  = $max;
    return (\%STAT);
    }
sub getEventData (){
    my ($eventIDX) = @_;
    my $SQL = "SELECT TX_EVENT, IN_YEAR FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX );
    my ($txEvent, $inYear) = $select->fetchrow_array();
    return ($txEvent, $inYear);
    }
sub _getOtherVolunteerList (){
    my ($self, $eventIDX, $inType) = @_;
    my $SQL = "SELECT USER.PK_USER_IDX, USER.TX_FIRST_NAME, USER.TX_LAST_NAME, concat(LEFT(USER.TX_FIRST_NAME,1), '. ',  USER.TX_LAST_NAME) AS TX_INIT
        FROM TB_PROFILE AS PREF JOIN TB_USER AS USER ON PREF.FK_USER_IDX=USER.PK_USER_IDX 
        WHERE PREF.FK_EVENT_IDX=? AND PREF.IN_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $inType );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
    }
sub _getVolunteerJudges (){
    my ($self, $eventIDX, $classIDX) = @_;
    # my ($txEvent, $inYear) = &getEventData($eventIDX);
    # my $SQL = "SELECT PREF.*, USER.TX_FIRST_NAME, USER.TX_LAST_NAME 
    #     FROM TB_PROFILE AS PREF JOIN TB_USER AS USER ON PREF.FK_USER_IDX=USER.PK_USER_IDX 
    #     WHERE PREF.TX_YEAR=?";
    my $SQL = "SELECT PREF.*, USER.TX_FIRST_NAME, USER.TX_LAST_NAME, concat(LEFT(USER.TX_FIRST_NAME,1), '. ',  USER.TX_LAST_NAME) AS TX_INIT
        FROM TB_PROFILE AS PREF JOIN TB_USER AS USER ON PREF.FK_USER_IDX=USER.PK_USER_IDX 
        WHERE PREF.FK_EVENT_IDX=? AND PREF.FK_CLASS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $classIDX );
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')};
    return (\%HASH);
    }
sub _getAssignedVolunteerList (){
    my ($self, $eventIDX, $inType) = @_;
    my $SQL = "SELECT CARD.*, USER.TX_FIRST_NAME, USER.TX_LAST_NAME 
            FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX 
            WHERE (FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare( $SQL);
       $select->execute( $eventIDX, $inType );
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_CARD_IDX'])};
    return (\%HASH);
    }
sub _getAssignedToTeam (){
    my ($self, $teamIDX, $inCardType) = @_;
    my $SQL = "SELECT * FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX, $inCardType );
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')};
    return (\%HASH);
    }
sub _saveDaysLate (){
    my ($self, $inDays, $teamIDX ) = @_;
    my $SQL = "UPDATE TB_TEAM SET IN_DAYS=? WHERE PK_TEAM_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($inDays, $teamIDX);
    return ();
    }
# ==== 2023 ===============================================
sub _getDocuments (){
    my ($self, $eventIDX) = @_;
    my $SQL="SELECT FK_TEAM_IDX, TX_KEYS, TX_PAPER, IN_PAPER FROM TB_UPLOAD WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','IN_PAPER'])}; 
    return (\%HASH);
    }
sub _getEmailList (){
    my ($self, $eventIDX, $inCardType) = @_;
    my $SQL = "SELECT DISTINCT U.TX_EMAIL FROM TB_CARD AS C 
		JOIN TB_USER AS U ON C.FK_USER_IDX=U.PK_USER_IDX
		WHERE (C.FK_EVENT_IDX=? AND C.FK_CARDTYPE_IDX=? AND C.IN_STATUS<?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $eventIDX, $inCardType, 2 );
	my %HASH = %{$select->fetchall_hashref('TX_EMAIL')};
    return (\%HASH);
    }
sub _getOutstandingPaperStatistics (){
    my ($self, $eventIDX, $inCardType) = @_;
    my $SQL = "SELECT PK_CARD_IDX FROM TB_CARD AS C WHERE (C.FK_EVENT_IDX=? AND C.FK_CARDTYPE_IDX=? AND IN_STATUS=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $eventIDX, $inCardType, 2 );
	my $complete = $select->rows();
	   $SQL = "SELECT PK_CARD_IDX FROM TB_CARD AS C WHERE (C.FK_EVENT_IDX=? AND C.FK_CARDTYPE_IDX=? AND IN_STATUS<?)";
	   $select = $dbi->prepare($SQL);
	   $select->execute( $eventIDX, $inCardType, 2 );
	my $pending = $select->rows();  
	my $percent = ($complete/($complete + $pending));
    return ($percent);
    }
sub _getUserAssignedPapers (){
    my ($self, $eventIDX, $userIDX, $inCardType) = @_;
    my $SQL = "SELECT C.*, T.IN_NUMBER, T.TX_SCHOOL FROM TB_CARD AS C JOIN TB_TEAM AS T ON C.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE (C.FK_EVENT_IDX=? AND C.FK_USER_IDX=? AND FK_CARDTYPE_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $eventIDX, $userIDX, $inCardType );
	my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')};
    return (\%HASH);
    }
sub _getUserDetails (){
    my ($self, $inCardType, $eventIDX, $userIDX) = @_;
    my $SQL = "SELECT * FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select ->execute( $userIDX );
	my %HASH = %{$select->fetchrow_hashref()};
	   $SQL = "SELECT COUNT(FK_USER_IDX) AS IN_COUNT FROM TB_CARD WHERE (FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=? AND FK_USER_IDX=?) GROUP BY FK_USER_IDX";
       $select = $dbi->prepare( $SQL );
	   $select->execute( $inCardType, $eventIDX, $userIDX);
	   $HASH{IN_COUNT} = $select->fetchrow_array();
    return (\%HASH);
    }
sub _getUserDetailsFromCard (){
    my ($self, $cardIDX) = @_;
    my $SQL = "SELECT CARD.FK_CARDTYPE_IDX, USER.* FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE CARD.PK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select ->execute( $cardIDX );
	my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getAssignmentCount(){
    my ($self, $inCardType, $eventIDX) = @_;
    my $SQL = "SELECT FK_USER_IDX, COUNT(FK_USER_IDX) AS IN_TOTAL FROM TB_CARD WHERE (FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=?) GROUP BY FK_USER_IDX";
    my $select = $dbi->prepare($SQL);
	   $select->execute( $inCardType, $eventIDX );
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getAllJudges (){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE>?";
    my $select = $dbi->prepare($SQL);
	   $select->execute( 0 );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getJudgeAssignmentByTeam (){
    my ($self, $inCardType, $teamIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.IN_STATUS, USER.* FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE (CARD.FK_CARDTYPE_IDX=? AND CARD.FK_TEAM_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $inCardType, $teamIDX );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getJudgeAssignmentByTeam_cardIDX (){
    my ($self, $inCardType, $teamIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.IN_STATUS, USER.* FROM TB_CARD AS CARD 
        JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE (CARD.FK_CARDTYPE_IDX=? AND CARD.FK_TEAM_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $inCardType, $teamIDX );
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')}; 
    return (\%HASH);
    }
sub _getJudgeAssignment (){
    my ($self, $eventIDX) = @_;
    # my $SQL = "SELECT * FROM TB_CARD WHERE FK_EVENT_IDX=?";
    my $SQL = "SELECT USER.TX_LAST_NAME, USER.TX_FIRST_NAME, CARD.* FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE CARD.FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_TEAM_IDX','FK_USER_IDX'])}; 
    return (\%HASH);
    }

sub _getTeamDetails (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select ->execute( $teamIDX );
	my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getTeamList (){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
    } 
sub _getTeamListByClass (){
    my ($self, $eventIDX, $classIDX) = @_;
    my %HASH = %{&getTeamByClass($eventIDX, $classIDX)};
    return (\%HASH);
    }
sub getTeamByClass(){
	my ($eventIDX, $classIDX) = @_;
	my $SQL = "SELECT * FROM TB_TEAM WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX, $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}

sub _batchRemoval (){
    my ($self, $eventIDX, $classIDX, $inCardType) = @_;
    my %TEAMS = %{&getTeamByClass($eventIDX, $classIDX)};
    my $SQL = "DELETE FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=? AND IN_STATUS=?)";
    my $delete = $dbi->prepare($SQL);
    foreach $teamIDX (sort keys %TEAMS){
    	$delete->execute( $teamIDX, $inCardType, $eventIDX, 0);
    }
    # my $str;
    return ();
    }




return (1);