package SV::ACCOUNT;

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
sub _createNewStudentAccount(){
    my $self = shift;
    my $userIDX = shift;
    my $Access = new TB::ACCESS();
    foreach $tileIDX (sort @studentAccount) {
        $Access->_setField(FK_TILES_IDX, $tileIDX);
        $Access->_setField(FK_USER_IDX, $userIDX);
        $Access->_saveNew();
    }
#begin
#* Object: n_createNewStudentAccountew()
#* Inputs: userIDX.
#* Output: Create a Menu list for new users.
#* Comment: none.
}
sub _getSubscriptionList(){
   my $self = shift;
   my $userIDX = shift;
   my $location = shift;
   
   my $SQL = "SELECT LIST.PK_USER_TEAM_IDX, TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, TEAM.TX_COUNTRY 
            FROM TB_USER_TEAM AS LIST 
            JOIN TB_TEAM AS TEAM ON LIST.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
            WHERE (LIST.FK_USER_IDX=? AND TEAM.FK_EVENT_IDX=?)";
   my $select = $dbi->prepare($SQL);
      $select->execute( $userIDX, $location );
   my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
   return (\%HASH);
#begin
#* Object: _getSubscriptionList()
#* Inputs: userIDX and Event Location.; Syntax my %DATA = %{$OBJ->_getSubscriptionList(userIDX, $location)};
#* Output: A list with the PK_TEAM_IDX as the key for the HASH list.
#* Comment: none.
}

sub _getListOfJudges(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE>?";
    my $select = $dbi->prepare($SQL);
      $select->execute( 0 );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
}

sub _getListOfJudgesAssignedToPreference(){
    my $self = shift;
    my $setupIDX = shift;
    my $SQL = "SELECT P.*, U.TX_FIRST_NAME, U.TX_LAST_NAME FROM TB_PREF AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE P.FK_SETUP_IDX=?";
    my $select = $dbi->prepare($SQL);
      $select->execute( $setupIDX );
    my %HASH = %{$select->fetchall_hashref('PK_PREF_IDX')}; 
    return (\%HASH);
}
sub _cloneSetUpEvent(){
    my $self = shift;
    my $setupIDX = shift;
    my $txSetup = shift;
    my $SQL = "INSERT INTO TB_SETUP (FK_EVENT_IDX, TX_SETUP)  SELECT FK_EVENT_IDX, ? FROM TB_SETUP WHERE PK_SETUP_IDX=?";
    my $insert = $dbi->prepare($SQL);
       $insert->execute( $txSetup, $setupIDX);
    my $newSetupIDX = $insert->{q{mysql_insertid}};
    my $SQL = "INSERT INTO TB_PREF (FK_SETUP_IDX, FK_USER_IDX, BO_REG, BO_ADV, BO_MIC, BO_EXTRA) SELECT ?, FK_USER_IDX, BO_REG, BO_ADV, BO_MIC, BO_EXTRA FROM TB_PREF WHERE FK_SETUP_IDX=?";
    my $clone = $dbi->prepare($SQL);
       $clone->execute( $newSetupIDX, $setupIDX);
    return ($newSetupIDX);
}
sub _getUserInitials(){
    my $self = shift;
    my $txFirst = shift;
    my $txLast = shift;
    my $init = substr($txFirst,0,1).substr($txLast,0,1);
    return (uc($init));
}
return (1);

