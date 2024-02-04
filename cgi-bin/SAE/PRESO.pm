package SAE::PRESO;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;
use List::Util qw( sum min max reduce );
# use Statistics::Basic qw(:all);
# use Number::Format;
use SAE::GRADE;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;
use List::Util qw( min max );

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _getAverage(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
}
# =====================================================================================================
#  GETTERS
# =====================================================================================================
sub _getListofTeamsJudgedScores (){
    my ($self, $userIDX, $eventIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, PAPER.IN_VALUE, REPORT.IN_SEC, REPORT.IN_SUB, PAPER.IN_VALUE, REPORT.IN_SUB_WEIGHT
        FROM TB_CARD AS CARD
        JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        JOIN TB_PAPER AS PAPER ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX
        JOIN TB_REPORT AS REPORT ON REPORT.PK_REPORT_IDX=PAPER.FK_REPORT_IDX
        WHERE CARD.FK_CARDTYPE_IDX=? AND CARD.FK_USER_IDX=? AND CARD.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute( 5, $userIDX, $eventIDX );
    my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX','IN_SEC','IN_SUB'])}; 
    return (\%HASH);
    }
sub _getListofTeamsJudged (){
    my ($self, $userIDX, $eventIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_CARD AS CARD
        JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
        WHERE CARD.FK_CARDTYPE_IDX=? AND CARD.FK_USER_IDX=? AND CARD.FK_EVENT_IDX=?";;
    my $select = $dbi->prepare($SQL);
        $select->execute( 5, $userIDX, $eventIDX );
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')}; 
    return (\%HASH);
    }
sub _getTeamPresoStatistics(){
    my ($self, $teamIDX) = @_;
    my @SCORES = ();
    # 1. get team's score card scores
    # 2. add the scores to Array
    # 3. perform statics and return Highm Low, Std, and Mean
    my $Grade   = new SAE::GRADE();
    my $SQL     = "SELECT PK_CARD_IDX FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select  = $dbi->prepare($SQL);
       $select  -> execute($teamIDX, 5);
    while (my ($cardIDX) = $select->fetchrow_array()) {
        # my $score = $Grade->_getAssessmentScore_byCard($cardIDX, 'Presentation');
        my $score = $Grade->_getAssessmentScore_byCard($cardIDX, $teamIDX);
        push(@SCORES, $score);
    }
    my %STAT;
    # my $std = sprintf "%2.15f", stddev(@SCORES);
    # my $mean = sprintf "%2.15f", mean(@SCORES);
    # $STAT{IN_STD}  = $std;
    # $STAT{IN_MEAN}  = $mean;
    # $STAT{IN_MIN}  = min(@SCORES);
    # $STAT{IN_MAX}  = max(@SCORES);
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
sub _getPresoRubric (){
    my ($self, $txType, $classIDX) = @_;
    # my $txType = 'Presentation';
    my $SQL = "SELECT * FROM TB_REPORT WHERE (TX_TYPE=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
        $select->execute( $txType, $classIDX );
    my %HASH = %{$select->fetchall_hashref(['IN_SEC','IN_SUB'])}; 
    return (\%HASH);
    }
sub _getPresentationJudges (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, USER.TX_FIRST_NAME, USER.TX_LAST_NAME, USER.PK_USER_IDX FROM TB_CARD AS CARD 
        JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX
        WHERE CARD.FK_TEAM_IDX=? AND CARD.FK_CARDTYPE_IDX=?";
        my $select = $dbi->prepare($SQL);
        $select->execute($teamIDX, 5);
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')}; 
    return (\%HASH);
    }
sub _getTeamPresoScores (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, PAPER.PK_PAPER_IDX, REPORT.PK_REPORT_IDX, REPORT.IN_SEC, REPORT.TX_SEC, REPORT.IN_SUB, REPORT.TX_SUB, REPORT.CL_DESCRIPTION, REPORT.BO_BIN, PAPER.IN_VALUE, REPORT.IN_SUB_WEIGHT, PAPER.CL_FEEDBACK FROM TB_PAPER AS PAPER 
        JOIN TB_REPORT AS REPORT ON PAPER.FK_REPORT_IDX=REPORT.PK_REPORT_IDX
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX
        WHERE CARD.FK_TEAM_IDX=? AND CARD.FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($teamIDX, 5);
    my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX','IN_SEC','IN_SUB'])}; 
    return (\%HASH);
    }
sub _getPresoCardDetails {
    my ($self, $cardIDX) = @_;
    my $SQL = "SELECT PAPER.PK_PAPER_IDX, REPORT.PK_REPORT_IDX, REPORT.IN_SEC, REPORT.TX_SEC, REPORT.IN_SUB, REPORT.TX_SUB, REPORT.CL_DESCRIPTION, REPORT.BO_BIN, PAPER.IN_VALUE, PAPER.CL_FEEDBACK FROM TB_PAPER AS PAPER 
    JOIN TB_REPORT AS REPORT ON PAPER.FK_REPORT_IDX=REPORT.PK_REPORT_IDX
    WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref(['IN_SEC','IN_SUB'])}; 
    return (\%HASH);
    }
sub getInitials(){
    my %HASH;
    my $SQL = "SELECT PK_USER_IDX, LEFT(TX_FIRST_NAME,1) AS TX_FIRST, LEFT(TX_LAST_NAME,1) AS TX_LAST FROM TB_USER";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    while (($userIDX, $txFirst, $txLast) = $select->fetchrow_array()) {
        my $txInitials = sprintf '%s%s', uc($txFirst), uc($txLast);
        $HASH{$userIDX} = $txInitials;
    }
    return (\%HASH);
    }
sub _getBatchPresoScore() {
    # 1. Get a list of all the cards by Team.  Hash = HASH{teamIDX}{cardIX} 
    # 2. Loop through the Hash and get score for each card
    # 3. return hash with Score  

    my ($self, $eventIDX) = @_;
    my $Grade    = new SAE::GRADE();
    my %HASH;

    my %INIT     = %{&getInitials()};
    my $TEAM_SQL = "SELECT FK_TEAM_IDX, PK_CARD_IDX, FK_USER_IDX FROM TB_CARD AS CARD JOIN TB_TEAM AS TEAM ON TEAM.PK_TEAM_IDX=CARD.FK_TEAM_IDX WHERE (TEAM.FK_EVENT_IDX=? AND CARD.FK_CARDTYPE_IDX=?)";
    my $select   = $dbi->prepare( $TEAM_SQL );
       $select->execute($eventIDX, 5);
    while (my ($teamIDX, $cardIDX, $userIDX) = $select->fetchrow_array())  {
        my $score = 0;
           $score = $Grade->_getAssessmentScore_byCard($cardIDX,$teamIDX); 
           # $score = $Grade->_getAssessmentScore_byCard($cardIDX,'Presentation'); 
        $HASH{$teamIDX}{$cardIDX}{IN_SCORE}    = $score;
        $HASH{$teamIDX}{$cardIDX}{TX_INIT}     = $INIT{$userIDX};
        $HASH{$teamIDX}{$cardIDX}{FK_USER_IDX} = $userIDX;
    }
    return (\%HASH);
    }
sub _getCardBinary (){
    my ($self, $cardIDX) = @_;
    my $SQL = "SELECT C.*, P.* FROM TB_CARD AS C JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX WHERE (P.FK_SUBSECTION_IDX in (?,?,?) AND PK_CARD_IDX=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute(91, 92, 93, $cardIDX);
    my %HASH = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')};
    return (\%HASH);
    }
sub _getPresoScoreByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my $score = &_calculatePresoScoreByTeam($teamIDX, $cardTypeIDX);
    return ($score);
    }
sub _calculatePresoScoreByTeam(){
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my @SCORES = ();
    my $SQL = "SELECT CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX, SUM(((PAPER.IN_VALUE/100) * SUB.IN_WEIGHT)/2) AS IN_POINTS 
    FROM TB_PAPER AS PAPER JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
    JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX
    JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX
    WHERE (SECTION.FK_CARDTYPE_IDX=? AND CARD.FK_TEAM_IDX=?)
    GROUP BY CARD.FK_TEAM_IDX, PAPER.FK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($cardTypeIDX, $teamIDX);
    while (my ($teamIDX, $cardIDX, $inPoints) = $select->fetchrow_array()) {
        push (@SCORES, $inPoints);
    }
    my $averageScore = &_getAverage(@SCORES);
    return ($averageScore);
    }
sub _getOverallPresoResults(){
    my $self=shift;
    my $location = shift;
    my $classIDX = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($location, $classIDX);
    my %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    foreach $teamIDX (sort keys %TEAMS){
        my $score = &_calculatePresoScoreByTeam($teamIDX,5);
        $TEAMS{$teamIDX}{IN_OVERALL} = $score;
        # print "\$teamIDX = $teamIDX, \$score=$TEAMS{$teamIDX}{IN_OVERALL} \n";
    }
    return(\%TEAMS) ;
    }






# =====================================================================================================





sub _getRoomList(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT DISTINCT TX_ROOM FROM `TB_TODO` WHERE FK_EVENT_IDX=? AND FK_TODO_TYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location, 1 );
    my %HASH = %{$select->fetchall_hashref('TX_ROOM')}; 
    return (\%HASH);
}
sub _getPresoComments(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT FK_SUBSECTION_IDX, CL_COMMENT FROM TB_COMMENTS WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')}; 
    return (\%HASH);
}
sub _getPresoLocationList(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_TODO_ROOM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('TX_ROOM')}; 
    # print scalar keys %HASH;
    return (\%HASH);
}
sub _getToDo(){
    my $self = shift;
    my $location = shift;
    my $toType = shift;
    my $SQL = "SELECT * FROM TB_TODO WHERE (FK_EVENT_IDX=? AND FK_TODO_TYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
        $select->execute($location, $toType );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getPresentationQuestions(){
    my $self = shift;
    my $inType = shift;
    my $SQL = "SELECT SUB.* FROM TB_SUBSECTION AS SUB JOIN TB_SECTION AS SECTION ON SUB.FK_SECTION_IDX=SECTION.PK_SECTION_IDX WHERE SECTION.FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($inType);
    my %HASH = %{$select->fetchall_hashref('PK_SUBSECTION_IDX')}; 
    return (\%HASH);
}
sub _getCardScores(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT * FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')}; 
    return (\%HASH);
}
sub _getScoreCardsByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my $SQL = "SELECT * FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
        $select->execute($teamIDX,$cardTypeIDX );
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')}; 
    return (\%HASH);
}
sub _getValidatedScoreCards(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    my $SQL = "SELECT CARD.*, PAPER.* FROM `TB_CARD` AS CARD JOIN TB_PAPER AS PAPER ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX where CARD.FK_CARDTYPE_IDX=? and CARD.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($cardTypeIDX, $location );
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX', 'PK_CARD_IDX','FK_SUBSECTION_IDX'])}; 
    return (\%HASH);
}
# =====================================================================================================
#  INSERTS
# =====================================================================================================
sub _saveAssessmentLineItem(){
    my ($self, $cardIDX, $subIDX, $inValue) = @_;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subIDX, $inValue);
    return;
}
sub _saveAssessmentLineComment(){
    my ($self, $cardIDX, $subIDX, $teamIDX, $userIDX, $comments) = @_;
    my $SQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT) VALUES (?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL) || die "$!";
       $insert->execute($cardIDX, $subIDX, $teamIDX, $userIDX, uri_unescape($comments));
    return;
}
sub _setSchedule(){
    my $self = shift;
    my $toDoType = shift;
    my $teamIDX = shift;
    my $location = shift;
    my $toDoRoom = shift;
    my $toDoTime = shift;
    my $SQL = "INSERT INTO TB_TODO (FK_TEAM_IDX, FK_TODO_TYPE_IDX, FK_EVENT_IDX, TX_TIME, TX_ROOM) VALUES (?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($teamIDX, $toDoType, $location, $toDoTime, $toDoRoom);
    my $idx = $insert->{q{mysql_insertid}};
    return ($idx);
}
sub _addRoomTo_TODO_ROOM(){
    my $self = shift;
    my $toDoRoom = shift;
    my $location = shift;
    my $SQL = "INSERT INTO TB_TODO_ROOM (TX_ROOM, FK_EVENT_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($toDoRoom, $location);
    my $idx = $insert->{q{mysql_insertid}};
    return ($idx);
}
sub _addPresentationScoreCard(){
    my $self = shift;
    my $userIDX = shift;
    my $teamIDX = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    my $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_STATUS) VALUES (?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($userIDX, $teamIDX, $cardTypeIDX, $location, 2);
    my $cardIDX = $insert->{q{mysql_insertid}};
    return ($cardIDX);
}
sub _saveAssessments(){
    my $self = shift;
    my $cardIDX = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        # print " $DATA{$subSectionIDX}<br>";
        $insert->execute($cardIDX, $subSectionIDX, $DATA{$subSectionIDX}) || die "Cannot Add @_"; 
    }
    return ();
}
sub _saveComment(){
    my $self = shift;
    my $cardIDX = shift;
    my $teamIDX = shift;
    my $userIDX = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT) VALUES (?,?,?,?,?)";
    my $insert = $dbi->prepare($SQL);
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        if ($DATA{$subSectionIDX} eq ""){next}
        $insert->execute($cardIDX, $subSectionIDX, $teamIDX, $userIDX, uri_unescape($DATA{$subSectionIDX})) || die "Cannot Add @_"; 
        
    }
    return ();
}

sub _updateComment(){
    my $self = shift;
    my $cardIDX = shift;
    my $teamIDX = shift;
    my $userIDX = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    # my $SQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT) VALUES (?,?,?,?,?)";
    my $SQL = "UPDATE TB_COMMENTS SET CL_COMMENT=? WHERE ( FK_CARD_IDX=? AND FK_SUBSECTION_IDX=? ) ";
    my $update = $dbi->prepare($SQL);
    open (DEBUG, ">degub.txt");
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        if ($DATA{$subSectionIDX} eq ""){next}
        $update->execute(uri_unescape($DATA{$subSectionIDX}),$cardIDX,$subSectionIDX);
        print DEBUG uri_unescape($DATA{$subSectionIDX})."\n---\$cardIDX=$cardIDX\n---\$subSectionIDX=$subSectionIDX\n\n";
        # $insert->execute($cardIDX, $subSectionIDX, $teamIDX, $userIDX, uri_unescape($DATA{$subSectionIDX})) || die "Cannot Add @_"; 
        
    }
    close (DEBUG);
    return ();
}

# =====================================================================================================
#  UPDATES
# =====================================================================================================
sub _updateAssessment(){
    my $self = shift;
    my $cardIDX = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "UPDATE TB_PAPER SET IN_VALUE=? WHERE ((FK_CARD_IDX=?) AND (FK_SUBSECTION_IDX=?))";
    my $update = $dbi->prepare($SQL);
    foreach $subIDX (sort keys %DATA){
        $update->execute($DATA{$subIDX}, $cardIDX, $subIDX) || die "$!";
    }
    return ();
}
sub _updatePresoToDo(){
    my $self = shift;
    my $teamIDX = shift;
    my $location = shift;
    my $todoTypeIDX = shift;
    my $txStatus = shift;
    my $SQL = "UPDATE TB_TODO SET TX_STATUS=? WHERE (FK_TEAM_IDX=? AND FK_EVENT_IDX=? AND FK_TODO_TYPE_IDX=?)";
    my $update = $dbi->prepare($SQL);  
       $update->execute($txStatus, $teamIDX , $location , $todoTypeIDX );
    return();
}
sub _updatePaperScore(){
    my $self = shift;
    my $paperIDX = shift;
    my $inValue = shift;
    my $SQL = "UPDATE TB_PAPER SET IN_VALUE=? WHERE (PK_PAPER_IDX=?)";
    my $update = $dbi->prepare($SQL);  
       $update->execute( $inValue , $paperIDX );
    return();
}

# =====================================================================================================
#  DELETES
# =====================================================================================================
sub _resetComments(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "DELETE FROM TB_COMMENTS WHERE FK_CARD_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute($cardIDX);
    return;
}
sub _deleteSchedule(){
    my $self = shift;
    my $toDoType = shift;
    my $teamIDX = shift;
    my $location = shift;
    my $SQL = "DELETE FROM TB_TODO WHERE (FK_TODO_TYPE_IDX=? AND FK_TEAM_IDX=? AND FK_EVENT_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute($toDoType, $teamIDX, $location);
    return;
}
sub _deletePresoScoreCard(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "DELETE FROM TB_CARD WHERE PK_CARD_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute($cardIDX);
    return;
}
sub _deletePresoScoreCard_Paper(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "DELETE FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute($cardIDX);
    return;
}
return (1);