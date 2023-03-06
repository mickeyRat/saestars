package SAE::DESIGN;

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
# ===============================================================
# GET
# ===============================================================
sub _deleteDaysLate (){
    my ($self, $teamIDX) = @_;
    my $str;
    my $SQL = "DELETE FROM TB_LATE WHERE FK_TEAM_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($teamIDX);
    return ();
    }
sub _saveDaysLate (){
    my ($self, $eventIDX, $teamIDX, $inDays) = @_;
    my $SQL = "SELECT IN_DAYS FROM TB_LATE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my $row = $select->rows();
    if ($rows>0){
        my $SQL = "UPDATE TB_DAYS SET IN_DAYS=? WHERE FK_TEAM_IDX=?";
        my $update = $dbi->prepare($SQL);
        $update->execute($inDays, $teamIDX);
    } else {
        my $SQL = "INSERT INTO TB_LATE (FK_EVENT_IDX, FK_TEAM_IDX, IN_DAYS) VAlUES (?, ?, ?)";
        my $insert = $dbi->prepare($SQL);
        $insert -> execute($eventIDX, $teamIDX, $inDays);
    }
    return ();
    }
sub _getDaysLate (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT IN_DAYS FROM TB_LATE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my $row = $select->rows();
    my ($inDays) = $select->fetchrow_array();
    return ($inDays);
    }
sub _getCardIDX(){
    my ($self, $teamIDX, $userIDX) = @_;
    my $SQL = "SELECT PK_CARD_IDX FROM TB_CARD WHERE (FK_CARDTYPE_IDX=? AND FK_TEAM_IDX=? AND FK_USER_IDX=?)";
    my $select = $dbi->prepare($SQL);
    $select->execute(1, $teamIDX, $userIDX);
    my $cardIDX = $select->fetchrow_array();
    return ($cardIDX);
}
sub _getOverallPaperByTeam(){
    my $self = shift;
    my $teamIDX = shift;
    my $score   = &_getTeamDesignScore($teamIDX);
    my $late    = &_calculateLatePenalty($teamIDX);
    return ($score, $late);
}
sub _calculateLatePenalty(){
    my $teamIDX = shift;
    my $SQL = "SELECT * FROM TB_LATE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    my $late = $HASH{$teamIDX}{IN_DAYS} * 5;
    if ($late>50){$late=50}
    return ($late);
}
sub _calculateOverallPaperByTeam(){
    my $teamIDX = shift;
    my $inType = shift;
    my $Rubric=new SAE::RUBRIC();
    my $SQL = "SELECT SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
        JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
        WHERE (CARD.FK_TEAM_IDX=? AND CARD.FK_CARDTYPE_IDX=?)
        GROUP BY SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX, $inType);
    my %SCORE = %{$select->fetchall_hashref('FK_SECTION_IDX')};
    my %SECTION = %{$Rubric->_getSectionList()};
    my $SQL = "SELECT * FROM TB_CARDTYPE";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %CARDTYPE = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')}; 
    my $PaperTotal = $CARDTYPE{$inType}{IN_POINTS};
    my $score = 0;
    my $sectionScore = 0;
    foreach $sectionIDX (sort {$a<=>$b} keys %{$SECTION{$inType}}){
        my $inWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
        my $average = $SCORE{$sectionIDX}{IN_AVERAGE};
        my $MaxSectionScore = $PaperTotal * $inWeight /100;
        $sectionScore = ($inWeight/100) * ($average / 100) * $PaperTotal;
        $score += $sectionScore;
        printf "%d\n", $sectionIDX;
    }
    # printf "   Score = %2.4f\n\n", $score;
    return ($score);
}
sub _getTeamDesignScore (){
    my ($teamIDX) = @_;
    my $Rubric=new SAE::RUBRIC();
    my %SECTION = %{$Rubric->_getSectionList()};
    my $SQL    = "SELECT CARD.FK_CARDTYPE_IDX, SUB.FK_SECTION_IDX, AVG(PAPER.IN_VALUE) AS IN_AVERAGE FROM TB_PAPER AS PAPER 
        JOIN TB_CARD AS CARD ON PAPER.FK_CARD_IDX=CARD.PK_CARD_IDX 
        JOIN TB_SUBSECTION AS SUB ON PAPER.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX
        WHERE (CARD.FK_TEAM_IDX=?)
        GROUP BY CARD.FK_CARDTYPE_IDX, SUB.FK_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
       $select -> execute($teamIDX);
    my %SCORE  = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_SECTION_IDX'])};

       $SQL    = "SELECT * FROM TB_CARDTYPE";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %POINTS = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')};
    my $sectionScore = 0;
    for ($inType = 1; $inType<=4; $inType++) {
        # printf "%d\n", $inType;
        my $PaperTotal = $POINTS{$inType}{IN_POINTS};
        my $score = 0;
        foreach $sectionIDX (sort {$a<=>$b} keys %{$SECTION{$inType}}){
            my $inWeight = $SECTION{$inType}{$sectionIDX}{IN_WEIGHT};
            my $average = $SCORE{$inType}{$sectionIDX}{IN_AVERAGE};
            # my $MaxSectionScore = $PaperTotal * $inWeight /100;
            $score += ($inWeight/100) * ($average / 100) * $PaperTotal;
            # printf "%5d, PaperTotal=%2.4f, Weight=%03.1f, Average=%03.4f, Score=%03.4f\n", $sectionIDX, $PaperTotal, $inWeight, $average, $score;
        }
        $sectionScore = $score;
        $inFinalScore += $sectionScore;
        # printf "\n==== SECTION SCORE = %2.4f\n", $sectionScore;
        
    }
    # printf "\n==== FINAL SCORE = %2.4f\n", $inFinalScore;
    # print "\n\n\a";
    return ($inFinalScore);
    }

# ===============================================================
# SAVES
# ===============================================================
sub _saveAssessments(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $inType = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        $insert->execute($cardIDX, $subSectionIDX, $DATA{$subSectionIDX}) || die "Cannot Add @_"; 
    }
    return ();
}
# ===============================================================
# UPDATES
# ===============================================================
sub _updateCardStatus(){
    my $self = shift;
    my $cardIDX = shift;
    my $status = shift; #1= Draft, 2 = Done
    my $SQL = "UPDATE TB_CARD SET IN_STATUS=? WHERE PK_CARD_IDX=?";
    my  $update = $dbi->prepare($SQL);
        $update->execute($status, $cardIDX);
    return;
}
sub _updateCardAssessments(){
    my $self = shift;
    my $cardIDX = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "UPDATE TB_PAPER SET IN_VALUE=? WHERE (FK_CARD_IDX=? AND FK_SUBSECTION_IDX=?)";
    my $update = $dbi->prepare($SQL);
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        $update->execute($DATA{$subSectionIDX}, $cardIDX, $subSectionIDX) || die "Cannot Add @_"; 
    }
    return ();
}

# ===============================================================
# DELETES
# ===============================================================
return (1);