package SAE::PRESO;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;


my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# =====================================================================================================
#  GETTERS
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
    my $SQL = "DELETE FROM TB_COMMENTS WHERE PK_CARD_IDX=?";
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