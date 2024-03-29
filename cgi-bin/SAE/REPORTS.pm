package SAE::REPORTS;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );

use Number::Format;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;

use URI::Escape;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ===================== 2023 ==================================================
sub _getSectionAssessment (){
    my ($self, $teamIDX, $inCardType) = @_;
    my %POINTS = (1=>35, 2=>5, 3=>5, 4=>5);
    my $SQL          = "SELECT SEC.IN_WEIGHT AS SEC_WEIGHT, SUB.* FROM TB_SUBSECTION AS SUB JOIN TB_SECTION AS SEC ON SUB.FK_SECTION_IDX=SEC.PK_SECTION_IDX WHERE SEC.FK_CARDTYPE_IDX=?";
    my $select       = $dbi->prepare( $SQL );
       $select->execute($inCardType);
    my %SUBSECTION   = %{$select->fetchall_hashref(['FK_SECTION_IDX', 'PK_SUBSECTION_IDX'])};
    my $SQL_SCORE    = "SELECT P.FK_SUBSECTION_IDX, P.IN_VALUE FROM TB_PAPER AS P JOIN TB_CARD AS C ON P.FK_CARD_IDX=C.PK_CARD_IDX WHERE (C.FK_TEAM_IDX = ? AND C.FK_CARDTYPE_IDX=?)";
    my $value        = $dbi->prepare( $SQL_SCORE );
       $value->execute($teamIDX, $inCardType);
    my %VALUE        = %{$value->fetchall_hashref('FK_SUBSECTION_IDX')};
    my $score        = 0;
    foreach $sectionIDX (keys %SUBSECTION) {    
        my @SECSCORE = ();
        my $sectionWeight;
        foreach $subIDX (sort {$a <=> $b} keys %{$SUBSECTION{$sectionIDX}}) {
            $sectionWeight = $SUBSECTION{$sectionIDX}{$subIDX}{SEC_WEIGHT};
            # printf "%d, %d\t", $sectionWeight, $sectionIDX;
            if (exists $VALUE{$subIDX}){
                # printf "%10d%10.2f\n", $subIDX, $VALUE{$subIDX}{IN_VALUE};
                push(@SECSCORE, $VALUE{$subIDX}{IN_VALUE});
            } else {
                # printf "%10d%10.2f\n",  $subIDX, 0;
                push(@SECSCORE, $VALUE{$subIDX}{IN_VALUE});
            }
        }
        $score += (&_getAverage(@SECSCORE)/100) * (($POINTS{$inCardType}) * ($sectionWeight/100));
    }
    # printf "Total Score = %2.2f\n\n", $score;
    return ($score);
    }

sub _getTeamReportStd (){
    my ($self, $list) = @_;
    my $str;

    return ();
    }
# my $stat = new Statistics::PointEstimation;
#     $stat->set_significance(95); #set the significance(confidence) level to 95%
sub _getTeamDesignCard (){
    my ($self, $teamIDX, $inCardType) = @_;
    my $SQL    = "SELECT CARD.*, USER.TX_FIRST_NAME, USER.TX_LAST_NAME FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX = USER.PK_USER_IDX where FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($teamIDX, $inCardType);
    my %HASH   = %{$select->fetchall_hashref('PK_CARD_IDX')};
    return (\%HASH);
    }
sub _getJudgeInformation (){
    my ($self, $userIDX) = @_;
    my $SQL    = "SELECT * FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($userIDX);
    my %HASH   = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getJudgeCardScore (){
    my ($self, $cardIDX) = @_;
    my $score  = 0;
    my %POINTS = (1=>35, 2=>5, 3=>5, 4=>5);
    my $SQL    = "SELECT C.FK_CARDTYPE_IDX,(AVG(P.IN_VALUE)*((SEC.IN_WEIGHT)/100))/100 AS IN_PERCENT FROM TB_PAPER AS P 
        JOIN TB_SUBSECTION AS SUB ON P.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
        JOIN TB_SECTION AS SEC ON SUB.FK_SECTION_IDX=SEC.PK_SECTION_IDX 
        JOIN TB_CARD AS C ON P.FK_CARD_IDX = C.PK_CARD_IDX 
        WHERE C.PK_CARD_IDX=?
        GROUP BY C.FK_CARDTYPE_IDX, C.PK_CARD_IDX, SEC.PK_SECTION_IDX";
    my $select = $dbi->prepare( $SQL );
       $select->execute($cardIDX);
    while (my ($inCardType, $inWeight) = $select->fetchrow_array()) {
        $score += $inWeight * $POINTS{$inCardType};
    }
    return ( $score );
    }
sub _getAllCardScores (){
    my ($self, $eventIDX) = @_;
    my %POINTS = (1=>35, 2=>5, 3=>5, 4=>5);
    my $SQL = "SELECT C.FK_CARDTYPE_IDX, C.PK_CARD_IDX, SEC.PK_SECTION_IDX, (AVG(P.IN_VALUE)*((SEC.IN_WEIGHT)/100))/100 AS IN_PERCENT FROM TB_PAPER AS P 
        JOIN TB_SUBSECTION AS SUB ON P.FK_SUBSECTION_IDX=SUB.PK_SUBSECTION_IDX 
        JOIN TB_SECTION AS SEC ON SUB.FK_SECTION_IDX=SEC.PK_SECTION_IDX 
        JOIN TB_CARD AS C ON P.FK_CARD_IDX = C.PK_CARD_IDX 
        WHERE C.FK_EVENT_IDX=? 
        GROUP BY C.FK_CARDTYPE_IDX, C.PK_CARD_IDX, SEC.PK_SECTION_IDX";
    my $select = $dbi->prepare( $SQL ) || die "$_";
       $select->execute($eventIDX);
    my %CARDS  = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','PK_CARD_IDX','PK_SECTION_IDX'])};
    my %HASH;
    foreach $inType (sort {$a<=>$b} keys %CARDS) {
        foreach $cardIDX (sort {$a<=>$b} keys %{$CARDS{$inType}}) {
            my $score = 0;
            foreach $sectionIDX (keys %{$CARDS{$inType}{$cardIDX}}) {
                $score += $CARDS{$inType}{$cardIDX}{$sectionIDX}{IN_PERCENT}*$POINTS{$inType};
            }
            $HASH{$cardIDX} = $score;
        }
    }
    return (\%HASH);
    }
sub _calculateDesignScore (){
    my ($self, $inCardType, $classIDX, $cardIDX) = @_;
    my %MAXSCORE = (1=>35, 2=>5, 3=>5, 4=>5);
    my $maxScore = 35;
    my %WEIGHT   = ();
    my %SUB      = ();
    my $SQL      = "SELECT FK_SUBSECTION_IDX,IN_VALUE FROM TB_PAPER  WHERE FK_CARD_IDX=?";
    my $select   = $dbi->prepare( $SQL );
       $select->execute($cardIDX);
    my %PAPER    = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')};
    $SQL = "SELECT SEC.PK_SECTION_IDX, SEC.IN_WEIGHT, SUB.PK_SUBSECTION_IDX FROM TB_SUBSECTION AS SUB 
            JOIN TB_SECTION AS SEC ON SUB.FK_SECTION_IDX=SEC.PK_SECTION_IDX 
            WHERE FK_CARDTYPE_IDX=? AND (IN_CLASS=? OR IN_CLASS=?)";
       $select = $dbi->prepare( $SQL );
       $select->execute($inCardType, 0, $classIDX);
    while (($secIDX, $inWeight, $subIDX ) = $select->fetchrow_array()) {
        $WEIGHT{$secIDX} = $inWeight;
        $SUB{$secIDX}{$subIDX}{IN_SCORE} = 0;
        if (exists $PAPER{$subIDX}){
            $SUB{$secIDX}{$subIDX}{IN_SCORE} = $PAPER{$subIDX}{IN_VALUE};
            } 
    }
    my $finalScore = 0;
    foreach $sectionIDX (sort keys %SUB) {
        my @SECTION_SCORE = ();
        foreach $subIDX (sort keys %{$SUB{$sectionIDX}}) {
            push (@SECTION_SCORE , $SUB{$sectionIDX}{$subIDX}{IN_SCORE});
        }
        my $score = &_getAverage(@SECTION_SCORE) * ($WEIGHT{$sectionIDX}/100) * ($MAXSCORE{$inCardType}/100);
        $finalScore += $score;
    }
    return ($finalScore);
    }
sub _getAverage(){
    if ((scalar @_)==0){
        return(0);
    } else {
        return (sum(@_)/@_);
    }
    }
sub _getMyTemplates (){
    my ($self, $userIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEMPLATE WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($userIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEMPLATE_IDX')};
    return (\%HASH);
    }
sub _getCommentById (){
    my ($self, $commentIDX) = @_;
    my $SQL = "SELECT CL_COMMENT FROM TB_COMMENTS WHERE (PK_COMMENTS_IDX=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute($commentIDX);
    my ($comment) = $select->fetchrow_array();

    return ($comment);
    }
sub _getSubSectionComments (){
    my ($self, $cardIDX, $subIDX) = @_;
    my $SQL = "SELECT * FROM TB_COMMENTS WHERE (FK_CARD_IDX=? AND FK_SUBSECTION_IDX=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute($cardIDX, $subIDX);
    my %HASH = %{$select->fetchall_hashref('PK_COMMENTS_IDX')};

    return (\%HASH);
    }
sub _setAssessmentStatus (){
    my ($self, $cardIDX, $inStatus) = @_;
    my $SQL = "UPDATE TB_CARD SET IN_STATUS=? WHERE PK_CARD_IDX=?";
    my $update = $dbi->prepare( $SQL );
       $update->execute($inStatus, $cardIDX);
    &createFullCardEntry($cardIDX);
    return ();
    }
sub createFullCardEntry (){
    my ($cardIDX) = @_;
    my $SQL_CARDTYPE = "SELECT FK_CARDTYPE_IDX FROM TB_CARD WHERE PK_CARD_IDX=?";
    my $select_cardType = $dbi->prepare( $SQL_CARDTYPE );
       $select_cardType->execute($cardIDX);
    my ($inCardType) = $select_cardType->fetchrow_array();

    my $SQL          = "SELECT SUB.PK_SUBSECTION_IDX FROM TB_SUBSECTION AS SUB JOIN TB_SECTION AS SEC ON SUB.FK_SECTION_IDX=SEC.PK_SECTION_IDX WHERE SEC.FK_CARDTYPE_IDX=?";
    my $select       = $dbi->prepare( $SQL );
       $select->execute($inCardType);
    my %SUBSECTION   = %{$select->fetchall_hashref('PK_SUBSECTION_IDX')};

    my $SQL_PAPER    = "SELECT FK_SUBSECTION_IDX FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $select_paper = $dbi->prepare( $SQL_PAPER );
       $select_paper->execute($cardIDX);
    my %PAPER        = %{$select_paper->fetchall_hashref('FK_SUBSECTION_IDX')};

    my $SQL_INSERT   = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?, ?, ?)";
    my $insert       = $dbi->prepare($SQL_INSERT);
    foreach $subSectionIDX (sort {$a <=> $b} keys %SUBSECTION ) {
        if (!exists $PAPER{$subSectionIDX}){
            $insert->execute($cardIDX, $subSectionIDX, 0);
        }
    }
    return ($str);
    }
sub _setSubmitCardScore (){
    my ($self, $cardIDX, $subIDX, $inValue) = @_;
    my $str;
    my $SQL = "SELECT * FROM TB_PAPER WHERE (FK_CARD_IDX=? AND FK_SUBSECTION_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $cardIDX, $subIDX );
    my $rows = $select->rows;
    if ($rows == 0){
        $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?, ?, ?)";
        my $insert = $dbi->prepare($SQL);
           $insert->execute($cardIDX, $subIDX, $inValue);
        } else {
        $SQL = "UPDATE TB_PAPER SET IN_VALUE=? WHERE (FK_CARD_IDX=? AND FK_SUBSECTION_IDX=?)";
        my $update = $dbi->prepare($SQL);
           $update->execute($inValue, $cardIDX, $subIDX);
        }
    return ();
    }
sub _getCardScores (){
    my ($self, $cardIDX) = @_;
    my $SQL = "SELECT * FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')};
    return (\%HASH);
    }
sub _getSubSectionDetails (){
    my ($self, $subIDX) = @_;
    my $SQL = "SELECT * FROM TB_SUBSECTION WHERE PK_SUBSECTION_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($subIDX);
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getPaperSubSection (){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_SUBSECTION";
    my $select = $dbi->prepare( $SQL );
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['FK_SECTION_IDX', 'PK_SUBSECTION_IDX'])};
    # print "number = ".scalar(keys %HASH);
    return (\%HASH);
    }
sub _getPaperSection (){
    my ($self, $inCardType, $classIDX) = @_;
    my $SQL = "SELECT * FROM TB_SECTION WHERE FK_CARDTYPE_IDX=? AND (IN_CLASS=? OR IN_CLASS=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute($inCardType, 0, $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_SECTION_IDX')};
    # print "number = ".scalar(keys %HASH);
    return (\%HASH);
    }
sub _getAssignedPapers (){
    my ($self, $eventIDX, $userIDX, $cardType) = @_;
    my $SQL = "SELECT TYPE.TX_TYPE, CARD.*, TEAM.FK_CLASS_IDX, TEAM.TX_SCHOOL, TEAM.IN_NUMBER, TEAM.PK_TEAM_IDX FROM TB_CARD AS CARD 
            JOIN TB_CARDTYPE AS TYPE ON CARD.FK_CARDTYPE_IDX = TYPE.PK_CARDTYPE_IDX
            JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE (TEAM.FK_EVENT_IDX=? AND CARD.FK_USER_IDX=? AND CARD.FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare( $SQL );
       $select->execute($eventIDX, $userIDX, $cardType);
    my %HASH = %{$select->fetchall_hashref('PK_CARD_IDX')};
    return (\%HASH);
    }
sub _getCardAndTreamDetails (){
    my ($self, $cardIDX) = @_;
    my $SQL = "SELECT CARD.*, TEAM.IN_NUMBER, TEAM.FK_CLASS_IDX, TEAM.TX_SCHOOL FROM TB_CARD AS CARD 
        JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE CARD.PK_CARD_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($cardIDX);
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
# ===================== 2023 ==================================================
sub _getTeamDocuments(){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_UPLOAD WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('IN_PAPER')};
    return (\%HASH);
}


# ===================== 2021 ==================================================


sub _getJudgesToDos(){
    my $self = shift;
    my $userIDX = shift;
    my $cardtypeIDX = shift;
    my $location = shift;
    my $SQL = "SELECT CARD.PK_CARD_IDX, TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, TEAM.FK_CLASS_IDX, CARD.IN_STATUS
        FROM TB_CARD AS CARD JOIN TB_TEAM AS TEAM ON TEAM.PK_TEAM_IDX=CARD.FK_TEAM_IDX 
        WHERE ((CARD.FK_USER_IDX=?) AND (CARD.FK_CARDTYPE_IDX=?) AND (CARD.FK_EVENT_IDX=?))";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX, $cardtypeIDX, $location);
    my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_CARD_IDX'])};
    return (\%HASH);
}
# TEMPLATE & COMMENTS
sub _loadTeamplate(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, CL_COMMENT FROM TB_TEMPLATE WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEMPLATE_IDX')};
    return (\%HASH);
}
sub _loadTeamplateItem(){
    my $self = shift;
    my $templateIDX = shift;
    my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, CL_COMMENT FROM TB_TEMPLATE WHERE PK_TEMPLATE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($templateIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEMPLATE_IDX')};
    return (\%HASH);
}
sub _saveToTemplate(){
    my $self = shift;
    my $txTitle = shift;
    my $userIDX = shift;
    my $comments = shift;
    my $SQL = "INSERT INTO TB_TEMPLATE (TX_TITLE, FK_USER_IDX, CL_COMMENT) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($txTitle, $userIDX, uri_unescape($comments));
    my $templateIDX =  $insert->{q{mysql_insertid}};
    return ($templateIDX);
}
sub _deleteTemplate(){
    my $self = shift;
    my $templateIDX = shift;
    my $SQL = "DELETE FROM TB_TEMPLATE WHERE PK_TEMPLATE_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($templateIDX);
}
sub _updateTemplate(){
    my $self = shift;
    my $txTitle = shift;
    my $comments = shift;
    my $templateIDX = shift;
    my $SQL = "UPDATE TB_TEMPLATE SET TX_TITLE=?, CL_COMMENT=? WHERE PK_TEMPLATE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($txTitle, uri_unescape($comments), $templateIDX);
    return ();
}
sub _loadComments(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, TS_CREATE, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS 
        WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_SUBSECTION_IDX','PK_COMMENTS_IDX'])};
    return (\%HASH);
}
sub _loadAllComments(){
    my $self = shift;
    my $teamIDX = shift;
    my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, TS_CREATE, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS 
        WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_SUBSECTION_IDX','PK_COMMENTS_IDX'])};
    return (\%HASH);
}
sub _postComments(){
    my $self = shift;
    my $cardIDX = shift;
    my $subSectionIDX = shift;
    my $userIDX = shift;
    my $comments = shift;
    my $teamIDX = shift;
    my $SQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_USER_IDX, CL_COMMENT, FK_TEAM_IDX) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subSectionIDX, $userIDX, uri_unescape($comments), $teamIDX) || die "Cannot Add $_";
    my $commentIDX =  $insert->{q{mysql_insertid}};
    return ($commentIDX);
}
sub _loadCommentsToEdit(){
    my $self = shift;
    my $commentIDX = shift;
    my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, TS_CREATE, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS 
        WHERE PK_COMMENTS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($commentIDX);
    my %HASH = %{$select->fetchall_hashref('PK_COMMENTS_IDX')};
    return (\%HASH);
}
sub _updateComments(){
    my $self = shift;
    my $comments = shift;
    my $commentIDX = shift;
    my $SQL = "UPDATE TB_COMMENTS SET CL_COMMENT=? WHERE PK_COMMENTS_IDX=?";
    my $insert = $dbi->prepare($SQL);
       $insert->execute(uri_unescape($comments), $commentIDX);
    return ();
}
sub _deleteComment(){
    my $self = shift;
    my $commentIDX = shift;
    my $SQL = "DELETE FROM TB_COMMENTS WHERE PK_COMMENTS_IDX=?";
    my $delete = $dbi->prepare($SQL) || die "Cannot Delete @_";
       $delete->execute($commentIDX);
}
sub _insertPaperScore(){
    my $self=shift;
    my $cardIDX = shift;
    my $subSectionIDX = shift;
    my $inValue = shift;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subSectionIDX, $inValue);
    return;
}
sub _getCardRecords(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')};
    return (\%HASH);
}
sub _isBinaryInputs(){
    my $self = shift;
    # my $cardIDX = shift;
    my $SQL = "SELECT FK_SECTION_IDX FROM TB_SUBSECTION WHERE IN_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(1);
    my %HASH = %{$select->fetchall_hashref('FK_SECTION_IDX')};
    return (\%HASH);
}
return (1);