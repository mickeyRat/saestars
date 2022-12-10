package SV::QUESTION;

use DBI;
use SV::CONNECT;
use JSON;
use TB::ACCESS;

my ($dbi, $dbName) = new SV::CONNECT();
my @studentAccount = (22, 23); 

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
sub _getSectionQuestions(){
    my $self = shift;
    my $rubricIDX = shift;
    my $SQL = "SELECT RQ.*, Q.* FROM TB_RUBRIC_QUESTION AS RQ 
    	JOIN TB_QUESTION AS Q ON RQ.FK_QUESTION_IDX=Q.PK_QUESTION_IDX 
        JOIN TB_RUBRIC_SECTION AS RS ON RQ.FK_RUBRIC_SECTION_IDX=RS.PK_RUBRIC_SECTION_IDX
        WHERE RS.FK_RUBRIC_IDX=?";
    my $select = $dbi->prepare($SQL);
      $select->execute( $rubricIDX );
    my %HASH = %{$select->fetchall_hashref(['FK_RUBRIC_SECTION_IDX','PK_RUBRIC_QUESTION_IDX'])}; 
    return (\%HASH);
}
sub _getQuestionWeightTotal(){
    my $self = shift;
    my $rubricIDX = shift;
    
    my $SQL = "SELECT FK_RUBRIC_SECTION_IDX, SUM(IN_WEIGHT) AS IN_TOTAL FROM TB_RUBRIC_QUESTION AS RQ
        JOIN TB_RUBRIC_SECTION AS RS ON RQ.FK_RUBRIC_SECTION_IDX=RS.PK_RUBRIC_SECTION_IDX 
        WHERE RS.FK_RUBRIC_IDX=?
        GROUP BY FK_RUBRIC_SECTION_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute( $rubricIDX );
    my %HASH = %{$select->fetchall_hashref(['FK_RUBRIC_SECTION_IDX'])}; 
    return (\%HASH);
}
return (1);

