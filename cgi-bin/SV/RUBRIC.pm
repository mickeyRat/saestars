package SV::RUBRIC;

use DBI;
use SV::CONNECT;
use JSON;
use TB::RUBRIC_SECTION;
# use TB::RUBRIC_QUESTION;

my ($dbi, $dbName) = new SV::CONNECT();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self
#begin
#* Object: new()
#* Inputs: None.
#* Output: Defined a new Object
#* Comment: none.
}
sub _cloneRubric(){
    my $self = shift;
    my $rubricIDX = shift;
    my $txRubric = shift;
    my $SQL = "INSERT INTO TB_RUBRIC (FK_EVENT_IDX, FK_CLASS_IDX, TX_RUBRIC, IN_VALUE) 
        SELECT FK_EVENT_IDX, FK_CLASS_IDX, ?, IN_VALUE FROM TB_RUBRIC WHERE PK_RUBRIC_IDX=?";
    my $insert = $dbi->prepare($SQL);
      $insert->execute( $txRubric, $rubricIDX);
    my $newRubricIDX = $insert->{q{mysql_insertid}};
    my $Rs = new TB::RUBRIC_SECTION();
    my %RS = %{$Rs->_getData_hashref('PK_RUBRIC_SECTION_IDX', 'FK_RUBRIC_IDX', $rubricIDX)};
    # my $str;
    foreach $rsIDX (sort {$RS{$a}{IN_ORDER} <=> $RS{$b}{IN_ORDER}} keys %RS) {
        my $rsSQL = "INSERT INTO TB_RUBRIC_SECTION (FK_RUBRIC_IDX, FK_RSECTION_IDX, IN_SCORE, IN_ORDER) 
            SELECT ?, FK_RSECTION_IDX, IN_SCORE, IN_ORDER FROM TB_RUBRIC_SECTION WHERE PK_RUBRIC_SECTION_IDX=?";
        my $cloneRS = $dbi->prepare($rsSQL);
           $cloneRS->execute( $newRubricIDX, $rsIDX);
        my $newRsIDX = $cloneRS->{q{mysql_insertid}};
        # $str .= "$newRsIDX ($rsIDX),";
        my $rqSQL = "INSERT INTO TB_RUBRIC_QUESTION (FK_RUBRIC_SECTION_IDX, FK_QUESTION_IDX, IN_WEIGHT, IN_ORDER) 
            SELECT ?, FK_QUESTION_IDX, IN_WEIGHT, IN_ORDER FROM TB_RUBRIC_QUESTION WHERE FK_RUBRIC_SECTION_IDX=?";
        my $cloneRQ = $dbi->prepare($rqSQL);
           $cloneRQ->execute( $newRsIDX, $rsIDX);
    }
    return ($newRubricIDX);
}
sub _getSumOfAllocatedPoints(){
    my $self = shift;
    my $rubricIDX = shift;
    my $SQL = "SELECT sum(IN_SCORE) AS IN_ALLOCATED FROM TB_RUBRIC_SECTION WHERE FK_RUBRIC_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $rubricIDX );
    my $inTotal = $select->fetchrow_array(); 
    return ($inTotal);
}

return (1);

