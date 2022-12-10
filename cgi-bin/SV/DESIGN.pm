package SV::DESIGN;

use DBI;
use SV::CONNECT;
use JSON;

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
sub _getListOfJudges(){
    my $self = shift;
    my $eventIDX = shift;
    my $SQL = "SELECT U.PK_USER_IDX, U.TX_FIRST_NAME, U.TX_LAST_NAME, P.BO_REG, P.BO_ADV, P.BO_MIC, P.BO_EXTRA FROM TB_USER AS U 
	JOIN TB_PREF AS P ON U.PK_USER_IDX=P.FK_USER_IDX 
    JOIN TB_SETUP AS S ON P.FK_SETUP_IDX = S.PK_SETUP_IDX
    WHERE S.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
      $select->execute( $eventIDX );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
}
sub _getDesignAssignmentCount(){
    my $self = shift;
    my $eventIDX = shift;
    my $SQL = "SELECT FK_USER_IDX, COUNT(FK_USER_IDX) AS IN_COUNT FROM TB_DESIGN WHERE FK_EVENT_IDX=? GROUP BY FK_USER_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute( $eventIDX );
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')}; 
    return (\%HASH);
}

sub _getDesignReportAssignmentCount(){
    my $self = shift;
    my $eventIDX = shift;
    my $SQL = "SELECT FK_TEAM_IDX, COUNT(FK_TEAM_IDX) AS IN_COUNT FROM TB_DESIGN WHERE FK_EVENT_IDX=? AND IN_TYPE<? GROUP BY FK_TEAM_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute( $eventIDX, 4 );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    return (\%HASH);
}

sub _getTeamReportAssignedToJudge(){
    my $self = shift;
    my $eventIDX = shift;
    my $SQL = "SELECT D.PK_DESIGN_IDX, D.FK_TEAM_IDX, D.FK_USER_IDX, D.IN_TYPE, T.IN_NUMBER, T.TX_SCHOOL, D.BO_STATUS FROM TB_DESIGN AS D JOIN TB_TEAM AS T ON D.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE D.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX );
    my %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','PK_DESIGN_IDX'])}; 
    return (\%HASH);
}
sub _getJudgeAssignmentList(){
    my $self = shift;
    my $eventIDX = shift;
    my $SQL = "SELECT FK_TEAM_IDX, FK_USER_IDX, IN_TYPE FROM TB_DESIGN WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX);
    my %HASH = %{$select->fetchall_hashref(['IN_TYPE','FK_TEAM_IDX','FK_USER_IDX'])}; 
    return (\%HASH);
}
sub _getJudgeAssginmentCount(){
    my $self = shift;
    my $eventIDX = shift;
    my $userIDX = shift;
    my $SQL = "SELECT COUNT(FK_USER_IDX) AS IN_COUNT FROM TB_DESIGN WHERE (FK_EVENT_IDX=? AND IN_TYPE < ? AND FK_USER_IDX=?) GROUP BY FK_USER_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute( $eventIDX, 4, $userIDX );
    my $inCount = $select->fetchrow_array();
    return ($inCount);
}
sub _getJudgeDesignSlot(){
    my $self = shift;
    my $teamIDX = shift;
    my $eventIDX = shift;
    my $SQL = "SELECT IN_TYPE FROM TB_DESIGN WHERE FK_TEAM_IDX=? and IN_TYPE<? AND FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX , 4, $eventIDX);
    my %HASH = %{$select->fetchall_hashref('IN_TYPE')}; 
    return (\%HASH);
}
sub _getAssessmentList(){
    my $self = shift;
    my $txType = shift;
    my $eventIDX = shift;
    # print $txType.", ".$eventIDX;
    my $SQL = "SELECT D.PK_DESIGN_IDX, T.IN_NUMBER, T.TX_SCHOOL, D.BO_STATUS, T.FK_CLASS_IDX FROM TB_DESIGN AS D 
        JOIN TB_TEAM AS T ON D.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE D.TX_TYPE=? AND T.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txType, $eventIDX);
    my %HASH = %{$select->fetchall_hashref('PK_DESIGN_IDX')}; 
    # print join("<br>", keys %HASH);
    return (\%HASH);
}
return (1);

