package SAE::PAPER;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ==== 2023 ===============================================

sub _getUserDetails (){
    my ($self, $inCardType, $eventIDX, $userIDX) = @_;
    my $SQL = "SELECT * FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select ->execute( $userIDX );
	my %HASH = %{$select->fetchrow_hashref()};
	   $SQL = "SELECT COUNT(FK_USER_IDX) AS IN_COUNT FROM TB_CARD WHERE (FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=? AND FK_USER_IDX=?) GROUP BY FK_USER_IDX";
       $select = $dbi->prepare( $SQL );
	   $select->execute( $inCardType, $eventIDX, $userIDX);
	   $HASH{IN_COUNT} = $select->fetchrow_array();
    return (\%HASH);
    }
sub _getUserDetailsFromCard (){
    my ($self, $cardIDX) = @_;
    my $SQL = "SELECT CARD.FK_CARDTYPE_IDX, USER.* FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE CARD.PK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select ->execute( $cardIDX );
	my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getAssignmentCount(){
    my ($self, $inCardType, $eventIDX) = @_;
    my $SQL = "SELECT FK_USER_IDX, COUNT(FK_USER_IDX) AS IN_TOTAL FROM TB_CARD WHERE (FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=?) GROUP BY FK_USER_IDX";
    my $select = $dbi->prepare($SQL);
	   $select->execute( $inCardType, $eventIDX );
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getAllJudges (){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE>?";
    my $select = $dbi->prepare($SQL);
	   $select->execute( 0 );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getJudgeAssignmentByTeam (){
    my ($self, $inCardType, $teamIDX) = @_;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.IN_STATUS, USER.* FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE (CARD.FK_CARDTYPE_IDX=? AND CARD.FK_TEAM_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $inCardType, $teamIDX );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getJudgeAssignment (){
    my ($self, $eventIDX) = @_;
    # my $SQL = "SELECT * FROM TB_CARD WHERE FK_EVENT_IDX=?";
    my $SQL = "SELECT USER.TX_LAST_NAME, USER.TX_FIRST_NAME, CARD.* FROM TB_CARD AS CARD JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX WHERE CARD.FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_TEAM_IDX','FK_USER_IDX'])}; 
    return (\%HASH);
    }
sub _getListOfJudges (){
    my ($self, $eventIDX, $classIDX) = @_;
    my $SQL = "SELECT USER.* FROM TB_PREF AS JUDGE JOIN TB_USER AS USER ON JUDGE.FK_USER_IDX=USER.PK_USER_IDX WHERE (JUDGE.FK_EVENT_IDX=? AND JUDGE.FK_CLASS_IDX =?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX, $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
    }
sub _getTeamDetails (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select ->execute( $teamIDX );
	my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getTeamList (){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
    } 
sub _getTeamListByClass (){
    my ($self, $eventIDX, $classIDX) = @_;
    my %HASH = %{&getTeamByClass($eventIDX, $classIDX)};
    return (\%HASH);
    }
sub getTeamByClass(){
	my ($eventIDX, $classIDX) = @_;
	my $SQL = "SELECT * FROM TB_TEAM WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX, $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}

sub getListOfJudges(){
	my ($eventIDX, $classIDX) = @_;
	my $SQL = "SELECT USER.* FROM TB_PREF AS JUDGE JOIN TB_USER AS USER ON JUDGE.FK_USER_IDX=USER.PK_USER_IDX WHERE (JUDGE.FK_EVENT_IDX=? AND JUDGE.FK_CLASS_IDX IN (?, ?))";
	my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX, 0, $classIDX);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')}; 
    return (\%HASH);
}
sub _batchRemoval (){
    my ($self, $eventIDX, $classIDX, $inCardType) = @_;
    my %TEAMS = %{&getTeamByClass($eventIDX, $classIDX)};
    my $SQL = "DELETE FROM TB_CARD WHERE (FK_TEAM_IDX=? AND FK_CARDTYPE_IDX=? AND FK_EVENT_IDX=? AND IN_STATUS=?)";
    my $delete = $dbi->prepare($SQL);
    foreach $teamIDX (sort keys %TEAMS){
    	$delete->execute( $teamIDX, $inCardType, $eventIDX, 0);
    }
    # my $str;
    return ();
    }
sub _batchAssign (){
    my ($self, $eventIDX, $classIDX, $userIDX, $inCardType) = @_;
    my $SQL = "SELECT * FROM TB_CARD WHERE (FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?)";
    my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX, ($inCardType/10));
	my %ASSIGN = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    my $str;
    my %TEAMS = %{&getTeamByClass( $eventIDX, $classIDX )};
    $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_CARDTYPE_IDX) VALUES (?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
	foreach $teamIDX (sort keys %TEAMS){
		if (exists $ASSIGN{$teamIDX}){next}
		$insert->execute($userIDX, $teamIDX, $eventIDX, ($inCardType/10));
	}
    return ();
    }
sub _autoAssign (){
    my ($self, $eventIDX, $classIDX, $inLimit, $inCardType) = @_;
    my %TEAMS = %{&getTeamByClass($eventIDX, $classIDX)};
    my %JUDGES = %{&getListOfJudges($eventIDX, $classIDX)};
    my %ASSIGN = ();
    my @LIST = ();
    my $SQL = "SELECT FK_TEAM_IDX, COUNT(FK_TEAM_IDX) AS IN_COUNT FROM TB_CARD WHERE (FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?) GROUP BY FK_TEAM_IDX";
    my $select = $dbi->prepare($SQL);
	   $select->execute($eventIDX, $inCardType);
    my %COUNT = %{$select->fetchall_hashref('FK_TEAM_IDX')}; 
    for (my $x=0; $x<$inLimit; $x++){
    	foreach $userIDX (sort keys %JUDGES) {
    		push (@LIST, $userIDX);
    	}
    }
    for($x=0; $x<3; $x++){
	    foreach $teamIDX (sort keys %TEAMS) {
	    	if ($COUNT{$teamIDX}{IN_COUNT}>=$inLimit) {next}
	    	if (scalar (@LIST)>0){
		    	my $index = int rand(scalar (@LIST));
		    	$userIDX = splice(@LIST, $index, 1);
		    	if (!exists $ASSIGN{$teamIDX}{$userIDX}) {
		    		$ASSIGN{$teamIDX}{$userIDX}=1;
		    	} else {
		    		push (@LIST, $userIDX);
		    		$COUNT{$teamIDX}{IN_COUNT}++;
		    	}
	    	}
	    }
    }
    my $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_EVENT_IDX, FK_CARDTYPE_IDX) VALUES (?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
	foreach $teamIDX (sort keys %TEAMS) {
		# if ($COUNT{$teamIDX}{IN_COUNT}>=$inLimit) {next}
		foreach $userIDX (sort keys %{$ASSIGN{$teamIDX}}) {
			# if ($COUNT{$teamIDX}{IN_COUNT}>=$inLimit) {next}
			$insert->execute($userIDX, $teamIDX, $eventIDX, $inCardType);
			# $COUNT{$teamIDX}{IN_COUNT}++;
		}
	}
    return ();
    }
return (1);