package SAE::EVENT;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;

# use DateTime;

my $dbi = new SAE::Db();
my %EVENT;

sub new{
	$className = shift;
	my $self = {};
    my $eventIDX = shift;
    my $SQL = "SELECT * FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    %EVENT = %{$select->fetchrow_hashref()};   
    
	bless($self, $className);
	return $self;
}
sub _getEventData(){
    my $self = shift;
    return (\%EVENT);
}
sub _getEventList(){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_EVENT WHERE BO_ARCHIVE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(0);
    my %EVENT = %{$select->fetchall_hashref('PK_EVENT_IDX')};  
    return (\%EVENT);
}
sub _getEvent(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchrow_hashref()};   
    return (\%HASH);
}
sub _updateEventInfo(){
    my $self = shift;
    my $txField = shift;
    my $inValue = shift;
    my $idx = shift;
    my $SQL = "UPDATE TB_EVENT SET $txField=? WHERE PK_EVENT_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($inValue, $idx);
}

sub _getListOfTeams(){
    my ($self, $eventIDX) = @_;
    my %HASH = %{&getListOfTeams($eventIDX)};
    return (\%HASH);
    }

sub _getDesignAndPresentation (){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT DISTINCT FK_TEAM_IDX, FK_CARDTYPE_IDX FROM TB_CARD where (FK_EVENT_IDX=? and  FK_CARDTYPE_IDX in (1, 5))";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','FK_CARDTYPE_IDX'])};   
    return (\%HASH);
    }

sub _getTeamDetails (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchrow_hashref()};   
    return (\%HASH); 
    }
sub _getSummary(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT FK_CLASS_IDX, BO_ATTEND, IN_COUNT FROM TB_TEAM where FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my $totalCount = 0;
    my %CLASS = ();
    while (my ($classIDX, $boAttend, $inCount) = $select->fetchrow_array()) {
        $totalCount += $inCount;
        $CLASS{$classIDX}{IN} += $boAttend;
        $CLASS{$classIDX}{COUNT}++;
    }
    my %HASH;
    $HASH{'REG'}     = $CLASS{1}{IN};
    $HASH{'REG_TOT'} = $CLASS{1}{COUNT};
    $HASH{'ADV'}     = $CLASS{2}{IN};  
    $HASH{'ADV_TOT'} = $CLASS{2}{COUNT};
    $HASH{'MIC'}     = $CLASS{3}{IN};
    $HASH{'MIC_TOT'} = $CLASS{3}{COUNT};
    $HASH{'TOT'}     = $totalCount;
    return (\%HASH);
    }
sub _getCertificationStatus (){
    my ($self, $eventIDX) = @_;
    my %TEAMS = %{&getListOfTeams($eventIDX)};
    my %REQ   = %{&getRequirements()};
    my %CERT  = %{&getSelfCert($eventIDX)};
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        if (!exists $CERT{$teamIDX}){
                printf  "($teamIDX):%03d - incomplete\n", $TEAMS{$teamIDX}{IN_NUMBER};
            } else {
                my $certStatus = 1;
                foreach $reqIDX (sort keys %REQ) {
                    if (!exists $CERT{$teamIDX}{$reqIDX}) {$certStatus = 0}
                }
                if ($certStatus == 1) {
                        printf  "($teamIDX):%03d - complete\n", $TEAMS{$teamIDX}{IN_NUMBER};
                    } else {
                        printf  "($teamIDX):%03d - incomplete\n", $TEAMS{$teamIDX}{IN_NUMBER};
                    }
                # printf  "($teamIDX):%03d - complete\n", $TEAMS{$teamIDX}{IN_NUMBER};
            }
        
    }
    return ();
    }
# Internal to Module
sub getSelfCert(){
    my ($eventIDX) = @_;
    my $SQL = "SELECT STUDENT.* FROM TB_TECH_STUDENT AS STUDENT JOIN TB_TEAM AS TEAM ON STUDENT.FK_TEAM_IDX = TEAM.PK_TEAM_IDX WHERE TEAM.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX', 'FK_TECH_REQ_IDX'])};   
    return (\%HASH);
    }
sub getRequirements (){
    # my $eventIDX= $q->param('eventIDX');
    my $txType = 'reqSectionNumber';
    my %HASH;
    my $SQL = "SELECT R.PK_TECH_REQ_IDX, R.BO_REGULAR, R.BO_ADVANCE, R.BO_MICRO, R.BO_PADA 
        FROM TB_TECH_REQ AS R 
        JOIN TB_TECH_REQ_SECTION AS SEC ON R.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX 
        WHERE SEC.TX_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($txType);
    while (my ($reqIDX, $boReg, $boAdv, $boMic, $boPada) = $select->fetchrow_array()) {
        if ($boReg  == 1) {$HASH{1}{$reqIDX} = 1}
        if ($boAdv  == 1) {$HASH{2}{$reqIDX} = 1}
        if ($boMic  == 1) {$HASH{3}{$reqIDX} = 1}
        if ($boPada == 1) {$HASH{4}{$reqIDX} = 1}
    }
    return (\%HASH);
    }
 
sub getListOfTeams(){
    my ($eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};   
    return (\%HASH);
    }
return (1);