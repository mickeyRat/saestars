package SAE::GRADE;

use DBI;
use SAE::SDB;
use SAE::TABLE;
use JSON;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;


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
sub getAssessmentScore_byCard(){
    my ($cardIDX, $txType) = @_;
    my $score = 0;
    my $SQL = "SELECT CARD.IN_POINTS AS IN_MAX_SCORE
                , (PAPER.IN_VALUE/10) AS IN_VALUE
                , (REPORT.IN_SEC_WEIGHT/100) AS IN_SEC_WEIGHT
                , (REPORT.IN_SUB_WEIGHT/100) AS IN_SUB_WEIGHT
                ,  REPORT.IN_SUB, REPORT.IN_SEC FROM TB_PAPER AS PAPER
            JOIN TB_REPORT AS REPORT ON REPORT.PK_REPORT_IDX=PAPER.FK_REPORT_IDX
            JOIN TB_CARDTYPE AS CARD ON REPORT.TX_TYPE=CARD.TX_TYPE
        WHERE (FK_CARD_IDX=? AND CARD.TX_TYPE=?)";
    # print "cardIDX = $cardIDX\n\n";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardIDX, $txType);
    while (my ($maxScore, $inValue, $inSecWeight, $inSubWeight, $inSub, $inSec) = $select->fetchrow_array()) {
        # print " $inSec.$inSub = $maxScore, $inValue, $inSecWeight, $inSubWeight\n";
        $score += ($inValue * $inSecWeight * $inSubWeight * $maxScore);
    }
    return ($score);
}

sub _getAssessmentScore_byCard() {
    my ($self, $cardIDX, $txType) = @_;
    my $score = &getAssessmentScore_byCard($cardIDX, $txType);
    return ($score);
}
sub _getTeamData(){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    # return ($teamIDX);
    my $select = $dbi->prepare($SQL);
	   $select->execute($teamIDX);
    my %HASH = %{$select->fetchrow_hashref()}; 
    return (\%HASH);
    # return $SQL;
}


sub _getReportRubric(){
    my ($self, $txType, $classIDX) = @_;
    my %DATA = %{&getReportRubric($txType, $classIDX)};
    return (\%DATA);
}
sub getReportRubric(){
    my ($txType, $classIDX) = @_;
    # my $classFilter;
    # if ($inClass==2){
    #     $classFilter = 'BO_ADV';
    # } elsif ($inClass==3) {
    #     $classFilter = 'BO_MIC';
    # } else {
    #     $classFilter = 'BO_REG';
    # }
    my $SQL    = "SELECT * FROM TB_REPORT WHERE (TX_TYPE=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType, $classIDX);

    my %DATA =  %{$select->fetchall_hashref(['IN_SEC','IN_SUB'])};
    # print join(", ", keys %DATA);
    return (\%DATA);
}
sub getReportScores(){
    my ($cardIDX) = @_;
    my $SQL    = "SELECT * FROM TB_PAPER WHERE (FK_CARD_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardIDX);
    my %SCORE =  %{$select->fetchall_hashref('FK_REPORT_IDX')};   
    return (\%SCORE);
}
sub _getReportScores(){
    my ($self, $cardIDX, $txType, $inClass) = @_;
    my $Table = new SAE::TABLE();
    my %RUBRIC = %{&getReportRubric($txType, $inClass)};
    my %SCORE  = %{&getReportScores($cardIDX)};
    foreach $section (sort {$a <=> $b} keys %RUBRIC) {
        foreach $subSection (sort {$a <=> $b} keys %{$RUBRIC{$section}}){
            my $reportIDX = $RUBRIC{$section}{$subSection}{PK_REPORT_IDX};
            if (!exists $SCORE{$reportIDX}){
                # print "DNE\n";
                    my %DATA = ('FK_REPORT_IDX'=>$reportIDX, 'FK_CARD_IDX'=>$cardIDX);
                    my $jsonData = encode_json \%DATA;
                    $newPaperIDX = $Table->_saveAsNew('TB_PAPER', $jsonData);
                    # print "reportIDX = $reportIDX\n";
                    $SCORE{$reportIDX}{PK_PAPER_IDX}=$newPaperIDX;
                }
        }
    }
    return (\%SCORE);
}
sub _getFeedback(){
    my ($self, $teamIDX, $reportIDX) = @_;
    my $SQL = "SELECT PAPER.PK_PAPER_IDX, PAPER.CL_FEEDBACK, CARD.FK_USER_IDX, USER.TX_FIRST_NAME, USER.TX_LAST_NAME, CARD.IN_STATUS FROM TB_PAPER AS PAPER 
            JOIN TB_CARD AS CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX 
            JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX
            WHERE (CARD.FK_TEAM_IDX=? AND PAPER.FK_REPORT_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX, $reportIDX);
    my %FEEDBACK =  %{$select->fetchall_hashref('PK_PAPER_IDX')};   
    return (\%FEEDBACK);
}

sub _getSectionMetric(){
    my ($self, $reportIDX, $cardtypeIDX) = @_;
    my $SQL = "SELECT PAPER.*, CARD.*, USER.TX_FIRST_NAME, USER.TX_LAST_NAME FROM TB_PAPER AS PAPER RIGHT 
        JOIN TB_CARD as CARD ON CARD.PK_CARD_IDX=PAPER.FK_CARD_IDX 
        JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX
        WHERE (PAPER.FK_REPORT_IDX=? AND CARD.FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($reportIDX, $cardtypeIDX);
    my %METRIC =  %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_PAPER_IDX'])};
    return (\%METRIC);
}

# ===============================================================
# SAVES
# ===============================================================

sub _saveImportedGrades(){
    my ($self, $cardIDX, $subIDX, $inValue ) = @_;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subIDX, $inValue);
}
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
sub _clearPreviousGrades(){
    my ($self, $cardIDX) = @_;
    my $SQL = "DELETE FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $delete = $dbi->prepare( $SQL );
       $delete->execute( $cardIDX );
}
return (1);