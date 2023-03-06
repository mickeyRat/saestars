package SAE::STUDENT;

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
    sub _getListOfSafetyItems (){
        my ($self, $teamIDX, $classIDX, $txType) = @_;
        # my $txType="safetySectionNumber";
        
        # print "$teamIDX, $classIDX\n\n";
        my $SQL;
        if ($classIDX == 3){
           $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND REQ.BO_MICRO=1)";
        } elsif ($classIDX == 2) {
           $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND (REQ.BO_ADVANCE=1 OR REQ.BO_PADA=1))";
        } else {
           $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND REQ.BO_REGULAR=1)";
        }
        my $select = $dbi->prepare($SQL);
           $select->execute( $txType );
        my %HASH = %{$select->fetchall_hashref(['FK_TECH_REQ_SECTION_IDX','PK_TECH_REQ_IDX'])};
            $SQL = "SELECT * FROM TB_TECH_STUDENT WHERE (FK_TEAM_IDX=?)";
        my $tech = $dbi->prepare($SQL);
           $tech->execute( $teamIDX );
        my %TECH = %{$tech->fetchall_hashref('FK_TECH_REQ_IDX')};
        foreach $headingIDX (sort keys %HASH) {
            # print $headingIDX."<br>";
            foreach $itemIDX (sort keys %{$HASH{$headingIDX}}) {
                if (exists $TECH{$itemIDX}){ 
                    $HASH{$headingIDX}{$itemIDX}{BO_CHECK}=1;
                } else {
                    $HASH{$headingIDX}{$itemIDX}{BO_CHECK}=0; 
                }
            }
        }
        return (\%HASH);
        }




# =====================================================================================================
#  SETTERS
    sub _submitTechInspectionStatus (){
        my ($self, $teamIDX, $itemIDX, $inStatus, $userIDX) = @_;
        print "$teamIDX, $itemIDX, $inStatus, $userIDX";
        # my $eventIDX=31;
        my $str;
        my $SQL = "SELECT * FROM TB_TECH_STUDENT WHERE (FK_TEAM_IDX=? AND FK_TECH_REQ_IDX=?)";
        my $select = $dbi->prepare($SQL);
           $select->execute( $teamIDX, $itemIDX );
           $rows = $select->rows;
        if ($inStatus == 0) {
            print "action = Delete Record\n";
            $SQL = "DELETE FROM TB_TECH_STUDENT WHERE (FK_TEAM_IDX=? AND FK_TECH_REQ_IDX=?)";
            my $delete = $dbi->prepare($SQL);
               $delete->execute($teamIDX, $itemIDX);
            } else { 

                if ($rows ==0){
                    print "action = Add Record\n";
                    $SQL = "INSERT INTO TB_TECH_STUDENT (FK_TEAM_IDX, FK_TECH_REQ_IDX, BO_CHECK, FK_USER_IDX) VALUES (?, ?, ?, ?)";
                    my $insert = $dbi->prepare($SQL);
                       $insert->execute($teamIDX, $itemIDX, $inStatus, $userIDX);
                } else {
                    print "action = Update\n";
                    $SQL = "UPDATE TB_TECH_STUDENT SET BO_CHECK=? WHERE (FK_TEAM_IDX=? AND FK_TECH_REQ_IDX=?)";
                    my $update = $dbi->prepare($SQL);
                       $update->execute($inStatus, $teamIDX, $itemIDX);
                }
            }
        return ();
        }

return (1);