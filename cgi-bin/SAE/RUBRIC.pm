package SAE::RUBRIC;

use DBI;
use SAE::SDB;

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
sub _getPresentationRubric {
    my ($self, $classIDX) = @_;
    my $SQL = "SELECT * FROM TB_REPORT WHERE TX_TYPE=? AND FK_CLASS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute('Presentation', $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_REPORT_IDX')};
    return(\%HASH); 
}
sub _getLastSubSectionNumber() {
    # my ($self, $txType, $inSection) = @_;
    my ($self, $txType, $inSec, $classIDX) = @_;
    my $SQL    = "SELECT MAX(IN_SUB) FROM TB_REPORT WHERE (TX_TYPE=? AND IN_SEC=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType, $inSec, $classIDX);

    my $last = $select->fetchrow_array();
    # my %DATA =  %{$select->fetchall_hashref('IN_SUB')};
    return ($last+1);
}
sub _getSubSectionDetails() {
    my ($self, $reportIDX) = @_;
    my $SQL    = "SELECT * FROM TB_REPORT WHERE (PK_REPORT_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($reportIDX);
    my %HASH = %{$select->fetchrow_hashref()}; 
    return (\%HASH);
}
sub _getRubricWeight_ByType() {
    my ($self, $txType, $inSec, $classIDX) = @_;
    my $SQL    = "SELECT * FROM TB_REPORT WHERE (TX_TYPE=? AND IN_SEC=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType, $inSec, $classIDX);

    my %DATA =  %{$select->fetchall_hashref('PK_REPORT_IDX')};
    return (\%DATA);
}
sub _getRubricSectionListByType() {
    my ($self, $txType, $classIDX) = @_;
    my $SQL    = "SELECT DISTINCT TX_SEC, IN_SEC, IN_SEC_WEIGHT FROM TB_REPORT WHERE (TX_TYPE=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType, $classIDX);
    my %DATA =  %{$select->fetchall_hashref('TX_SEC')};
    return (\%DATA);
}
sub _getRubricBySection() {
    my ($self, $txType, $classIDX) = @_;
    my %DATA = %{&getRubricBySection($txType, $classIDX)};
    return (\%DATA);
    }

sub getRubricBySection(){
    my ($txType, $classIDX) = @_;
    my $SQL    = "SELECT * FROM TB_REPORT WHERE (TX_TYPE=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType, $classIDX);
    my %DATA =  %{$select->fetchall_hashref(['IN_SEC','IN_SUB','PK_REPORT_IDX'])};
    return (\%DATA);
    }
# --- 2023
sub _getSectionList(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_SECTION";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','PK_SECTION_IDX'])};
    return (\%HASH);
}
sub _getSubSectionList(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_SUBSECTION";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['FK_SECTION_IDX','PK_SUBSECTION_IDX'])}; 
    return (\%HASH);
}
sub _getAvailableSections(){
    my $self = shift;
    my $limit = shift;
    my $SQL = "SELECT IN_SECTION FROM TB_SECTION";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('IN_SECTION')};
    my @SEC;
    for ($i=1; $i<=$limit; $i++){
        if (exists $HASH{$i}){
            next;
        } else {
            push(@SEC, $i);
        }
    }
    # print join(" ,", @SEC);
    return (\@SEC);
}
sub _getSubSection(){
    my $self = shift;
    my $sectionIDX = shift;
    # my $SQL = "SELECT PK_SUBSECTION_IDX, FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD 
    # FROM TB_SUBSECTION WHERE FK_SECTION_IDX=?";
    my $SQL = "SELECT * FROM TB_SUBSECTION WHERE FK_SECTION_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($sectionIDX);
    my %HASH = %{$select->fetchall_hashref('PK_SUBSECTION_IDX')}; 
    return (\%HASH);
}
sub _getSubSectionRecord(){
    my $self = shift;
    my $subSectionIDX = shift;
    my $SQL = "SELECT * FROM TB_SUBSECTION WHERE PK_SUBSECTION_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($subSectionIDX);
    my %HASH = %{$select->fetchall_hashref('PK_SUBSECTION_IDX')}; 
    return (\%HASH);
}
sub _getSectionRecord(){
     my $self = shift;
    my $sectionIDX = shift;
    my $SQL = "SELECT * FROM TB_SECTION WHERE PK_SECTION_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($sectionIDX);
    my %HASH = %{$select->fetchall_hashref('PK_SECTION_IDX')}; 
    return (\%HASH);
}
sub _getRubricType(){ #Should return a list of numbers for each type (except flight)
    my $self;
    my $SQL = "SELECT * FROM TB_CARDTYPE;";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_CARDTYPE_IDX')}; 
    return (\%HASH);
}
# =====================================================================================================
#  INSERTS
# =====================================================================================================
sub _createNewSection(){
    my $self = shift;
    my $secNumber = shift;
    my $secTitle = shift;
    my $secWeight = shift;
    my $secClass = shift;
    my $secType = shift;
    my $SQL = "INSERT INTO TB_SECTION (IN_SECTION, TX_SECTION, IN_WEIGHT, IN_CLASS, FK_CARDTYPE_IDX) VALUES (?,?,?,?,?)";
    my $insert = $dbi -> prepare($SQL);
       $insert -> execute($secNumber, $secTitle, $secWeight, $secClass, $secType);
    my $sectionIDX =  $insert->{q{mysql_insertid}};
    return ($sectionIDX);
}
sub _addSubSection(){
    my $self = shift;
    my $sectionIDX = shift;
    my $number = shift;
    my $title = shift;
    my $description = shift;  
    my $inType = shift;
    my $threshold = shift;
    my $inMin = shift;
    my $inMax = shift;
    my $inWeight = shift;
    # print "$sectionIDX<br>$number<br>$title<br>$description<br>$inType<br>$threshold";
    my $SQL = "INSERT INTO TB_SUBSECTION (FK_SECTION_IDX, IN_SUBSECTION, TX_SUBSECTION, CL_DESCRIPTION, IN_TYPE, IN_THRESHOLD, IN_MIN, IN_MAX, IN_WEIGHT) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi -> prepare($SQL);
       $insert -> execute($sectionIDX, $number, $title, $description, $inType, $threshold, $inMin, $inMax, $inWeight );
    my $subSectionIDX =  $insert->{q{mysql_insertid}};
    # print " $sectionIDX, $number, $title, $description, $inType, $threshold, $inMin, $inMax, $inWeight ";
    return ($subSectionIDX);
}
# =====================================================================================================
#  UPDATES
# =====================================================================================================
sub _updateSectionRecord(){
    my ($self, $secNumber, $secTitle, $secWeight, $secClass, $sectionIDX) = @_;
    my $SQL = "UPDATE TB_SECTION SET IN_SECTION=?, TX_SECTION=?, IN_WEIGHT=?, IN_CLASS=? WHERE PK_SECTION_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute( $secNumber, $secTitle, $secWeight, $secClass, $sectionIDX );
    return;
}
sub _updateSubSectionRecord(){
    my ($self, $inNumber, $txSubSection, $clDescription, $inType, $inThreshold, $inMin, $inMax, $inWeight, $subSectionIDX) = @_;
    my $SQL = "UPDATE TB_SUBSECTION SET IN_SUBSECTION=?, TX_SUBSECTION=?, CL_DESCRIPTION=?, IN_TYPE=?, IN_THRESHOLD=?, IN_MIN=?, IN_MAX=?, IN_WEIGHT=? WHERE PK_SUBSECTION_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update -> execute($inNumber, $txSubSection, $clDescription, $inType, $inThreshold, $inMin, $inMax, $inWeight, $subSectionIDX);
    return();
}
# =====================================================================================================
#  DELETES
# =====================================================================================================
return (1);