package SAE::PROFILE;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );

use URI::Escape;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _getListofJudgesBySite (){
    my ($self, $field, $txYear) = @_;
    my $SQL= "SELECT U.TX_EMAIL FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE ($field=? AND P.TX_YEAR=?)";
    my $select = $dbi->prepare($SQL);
	    $select->execute( 1, $txYear);
	my %HASH = %{$select->fetchall_hashref('TX_EMAIL')};
    return (\%HASH);
    }
sub _getEventDetails (){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getAvailableJudges (){
    my ($self, $inCardType, $txYear, $site, $classIDX) = @_;
    my %TITLE = (1=>'Design', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    my $boSite, $boClass;
    if ($classIDX == 3){
    	$boClass = 'BO_MICRO';
    	} elsif ($classIDX == 2) {
    		$boClass = 'BO_ADVANCE';
    		} else {
    			$boClass = 'BO_REGULAR';
    			}
    if (lc($site) eq 'east'){
		$boSite  = 'BO_EAST';
    	} else {
    		$boSite  = 'BO_WEST';
    		} 
    if ($inCardType == 2){
    	$boType = 'BO_TDS';
    	} elsif ($inCardType == 3) {
    		$boType = 'BO_DRW';
    		} else {
    			$boType = 'BO_REQ';
    			}
   	my %HASH;
   	# print "$TITLE{$inCardType} Report \n";
    if ($inCardType == 1){
	    my $SQL = "SELECT U.* FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE (P.TX_YEAR=? AND $boSite=? AND $boClass=?)";
	    my $select = $dbi->prepare($SQL);
	       $select->execute( $txYear, 1, 1 );
	       %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    } else {
    	# print "Other Report \n";
    	my $SQL = "SELECT U.* FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE (P.TX_YEAR=? AND $boType=?)";
    	my $select = $dbi->prepare($SQL);
       	   $select->execute( $txYear, 1);
       	   %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    }
    
    return (\%HASH);
    }
sub _getPaperAssignmentCount (){
    my ($self, $eventIDX, $inCardType) = @_;
    my %HASH;
    my $SQL = "SELECT FK_TEAM_IDX, COUNT(FK_TEAM_IDX) AS IN_COUNT  FROM TB_CARD WHERE FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=? GROUP BY FK_TEAM_IDX";
	my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $inCardType );
    while (my ($teamIDX, $inCount) = $select->fetchrow_array()) {
    	$HASH{$teamIDX} = $inCount;
    }
    # my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    return (\%HASH);
    }
sub _getListOfTeams (){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX );
    my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX', 'PK_TEAM_IDX'])};
    return (\%HASH);
    }
sub _getPapersAssignedToUser (){
    my ($self, $eventIDX, $userIDX, $inCardType) = @_;
    # my %HASH;
    my $SQL = "SELECT FK_TEAM_IDX, IN_STATUS, PK_CARD_IDX FROM TB_CARD WHERE (FK_EVENT_IDX=? AND FK_USER_IDX=? AND FK_CARDTYPE_IDX=?)";
	my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $userIDX, $inCardType );
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    # while (my ($teamIDX, $inStatus) = $select->fetchrow_array() ){
    # 	$HASH{$teamIDX}{IN_STATUS} = $inStatus
    # }
    # = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return (\%HASH);
    }
sub _getAssignment(){
    my ($self, $eventIDX, $inCardType) = @_;
    my $SQL = "SELECT U.TX_LAST_NAME, U.TX_FIRST_NAME, T.IN_NUMBER, T.FK_CLASS_IDX, T.TX_SCHOOL, C.* FROM TB_CARD AS C 
		JOIN TB_USER AS U ON C.FK_USER_IDX=U.PK_USER_IDX 
	    JOIN TB_TEAM AS T ON C.FK_TEAM_IDX=T.PK_TEAM_IDX
	    WHERE (C.FK_EVENT_IDX=? AND C.FK_CARDTYPE_IDX=?)";
	my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $inCardType);
    my %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','PK_CARD_IDX'])};
    return (\%HASH);
    }
sub _getJudgePreferenceDetails (){
    my ($self, $userIDX, $txYear) = @_;
    my $SQL = "SELECT U.TX_FIRST_NAME, U.TX_LAST_NAME, U.TX_SCHOOL, U.TX_YEAR, P.IN_LIMIT, P.BO_REGULAR, P.BO_ADVANCE, P.BO_MICRO, P.BO_DRW, P.BO_TDS, P.BO_REQ FROM TB_PROFILE AS P
		JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX
	    WHERE (P.FK_USER_IDX=? AND P.TX_YEAR=?)";
   	my $select = $dbi->prepare($SQL);
       $select->execute( $userIDX, $txYear);
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getDesignJudges (){
    my ($self, $txYear) = @_;
    my $SQL = "SELECT U.* FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE (P.TX_YEAR=? AND (P.BO_REGULAR=? or P.BO_ADVANCE=? or P.BO_MICRO=?))";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txYear, 1, 1, 1);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
    }
sub _getTdsJudges (){
    my ($self, $txYear) = @_;
    my $SQL = "SELECT U.* FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE (P.TX_YEAR=? AND P.BO_TDS=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txYear, 1);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
    }
sub _getDrwJudges (){
    my ($self, $txYear) = @_;
    my $SQL = "SELECT U.* FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE (P.TX_YEAR=? AND P.BO_DRW=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txYear, 1);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
    }
sub _getReqJudges (){
    my ($self, $txYear) = @_;
    my $SQL = "SELECT U.* FROM TB_PROFILE AS P JOIN TB_USER AS U ON P.FK_USER_IDX=U.PK_USER_IDX WHERE (P.TX_YEAR=? AND P.BO_REQ=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txYear, 1);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
    }
sub _getJudges (){
    my ($self, $txYear) = @_;
    my $SQL = "SELECT * FROM TB_PROFILE WHERE TX_YEAR=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txYear );
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')};
    return (\%HASH);
    }
sub _getUsers (){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE>=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( 1 );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);

    }
sub _getEvents (){
    my ($self, $txYear) = @_;
    my $SQL = "SELECT * FROM TB_EVENT WHERE IN_YEAR=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txYear );
    my %HASH = %{$select->fetchall_hashref('PK_EVENT_IDX')};
    return (\%HASH);
    }
sub _getUserEventPreferences (){
    my ($self, $profileIDX) = @_;
    my $SQL = "SELECT * FROM TB_PROFILE WHERE PK_PROFILE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $profileIDX );
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getUserPreferenceHistory (){
    my ($self, $userIDX) = @_;
    my $SQL = "SELECT * FROM TB_PROFILE WHERE (FK_USER_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $userIDX );
    my %HASH = %{$select->fetchall_hashref('PK_PROFILE_IDX')};

    return (\%HASH);
    }
sub _checkForCurrentProfile (){
    my ($self, $userIDX) = @_;
    my @tm = localtime();
    my $txYear = ($tm[5] + 1900);
    my $SQL = "SELECT * FROM TB_PROFILE WHERE (FK_USER_IDX=? AND TX_YEAR=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $userIDX, $txYear );
    my $row = $select->rows();
    return ($row);
    }

sub _save (){
    my ($self, $userIDX, $field, $value, $txYear) = @_;
    # my @tm = localtime();
    # my $txYear = ($tm[5] + 1900);
    #Check to see if a prfile exists.  If not exist, (row=0), create a new entry,  If row=1, update field with entry.
    my $SQL    = "SELECT * FROM TB_PROFILE WHERE (FK_USER_IDX=? AND TX_YEAR=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $userIDX, $txYear );
    my $row    = $select->rows();
	if ($row==0){
		$SQL       = "INSERT INTO TB_PROFILE (FK_USER_IDX, TX_YEAR, $field) VALUES (?, ?, ?)";
		my $insert = $dbi->prepare($SQL);
		   $insert->execute($userIDX, $txYear, $value);
	} else {
		$SQL       = "UPDATE TB_PROFILE SET $field=? WHERE (FK_USER_IDX=? AND TX_YEAR=?)";
		my $update = $dbi->prepare($SQL);
		   $update->execute( $value, $userIDX, $txYear);
	}
	if ($field eq "IN_SINCE" || $field eq "TX_SCHOOL") {
		if ($value ne ""){
			&saveUserHistory($userIDX, $field, $value);
		}
	}
	$SQL    = "SELECT PK_PROFILE_IDX, BO_EAST, BO_WEST FROM TB_PROFILE WHERE (FK_USER_IDX=? AND TX_YEAR=?)";
    $select = $dbi->prepare($SQL);
    $select->execute( $userIDX, $txYear );
    my ($profileIDX, $boEast, $boWest) = $select->fetchrow_array();
    if ($boEast==0 && $boWest==0){
    	$SQL = "DELETE FROM TB_PROFILE WHERE PK_PROFILE_IDX=?";
    	my $delete = $dbi->prepare($SQL);
		   $delete->execute($profileIDX);
    }
    return ();
    }

sub saveUserHistory (){
    my ($userIDX, $field, $value) = @_;
    if ($field eq "IN_SINCE"){$field = "TX_YEAR"}
    my $SQL = "UPDATE TB_USER SET $field=? WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
	   $update->execute( $value, $userIDX);

    return ();
    }