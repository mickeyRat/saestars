package SAE::AUTO;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub _getTeamCount(){
    my $self = shift;
    my $location = shift;
    my ($HASH) = &__getTeamCount($location);
    return (\%{$HASH});
}

sub _getAllJudges(){
    my $self = shift;
    my $location = shift;
    my ($HASH) = &__getAllJudges($location);
    return (\%{$HASH});
}

sub _getAvailableJudges(){
    my $self = shift;
    # my $teamIDX = shift;
    my $location = shift;
    my $limit = 3;
    
    # Getting all the avaialble Judges
    my $SQL = "SELECT DISTINCT USER.PK_USER_IDX FROM TB_USER AS USER 
        JOIN TB_ACCESS AS ACCESS ON USER.PK_USER_IDX=ACCESS.FK_USER_IDX
        JOIN TB_TILES AS TILES ON TILES.PK_TILES_IDX=ACCESS.FK_TILES_IDX
        WHERE TILES.IN_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(1);
    %USERS = %{$select->fetchall_hashref('PK_USER_IDX')};
    @JUDGES = sort {$a <=> $b} keys %USERS;
    my (%{TEAMS}) = %{&__getTeamCount($location)};
    
    # Getting all the avaialble Judges
    my %CARD; # how many Times a Judge was assigned
    my %TCARD; # used for identifying number of judges per team
    
    my ($card, $tcard) = &__getCardCount($location, 1);
    %CARD=%{$card};
    %TCARD=%{$tcard};

    print "# of Available Judges = ".@JUDGES."\n";
    foreach $userIDX (sort keys %USERS) {
        if ($CARD{$userIDX}>=$limit){
            my $index = 0;
            $index++ until $JUDGES[$index] eq $userIDX;
            splice(@JUDGES, $index, 1);
        }
    }
    print "# of Available Judges = ".@JUDGES."\n\n";
    
    $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX) VALUES(?,?,?,?)";
    my $insert = $dbi -> prepare($SQL);
       
    # $pointer = 0;
    foreach $teamIDX (sort {$a <=> $b} keys %TEAMS) {
        # $pointer++;
        my $count = $TCARD{$teamIDX};
        my @TJUDGE = @JUDGES;
        until ($count>=3) {
            my $availableJudges = @TJUDGE;
            $index = int(1+rand($availableJudges));
            my $userIDX = $TJUDGE[$index];
            if ($userIDX){
                $CARD{$userIDX}++;
                $TCARD{$teamIDX}++;
                $insert -> execute($userIDX, $teamIDX, 1, $location) || die "$teamIDX, $userIDX\n";
                splice(@TJUDGE, $index, 1);
                $count = $TCARD{$teamIDX};
                if ( $CARD{$userIDX} > ($limit-1) ){
                    my $i = 0;
                    $i++ until $JUDGES[$i]== $userIDX;
                    splice(@JUDGES, $i, 1);
                }
            }
        }
    }
    return();
}

sub _getAssignedPapers(){
    my $self = shift;
    # my $inType = shift; 
    my $location = shift;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.FK_USER_IDX, CARD.FK_TEAM_IDX, CARD.FK_CARDTYPE_IDX, USER.TX_FIRST_NAME, USER.TX_LAST_NAME, CARD.IN_STATUS
        FROM TB_CARD AS CARD 
        JOIN TB_USER AS USER ON CARD.FK_USER_IDX=USER.PK_USER_IDX 
        WHERE (FK_EVENT_IDX=?)";
    my $select = $dbi -> prepare($SQL);
       $select -> execute($location);
    my %HASH = %{$select -> fetchall_hashref(['FK_CARDTYPE_IDX','FK_TEAM_IDX','PK_CARD_IDX'])};
    return (\%HASH);
}

sub _autoAssignReports(){
    my $self = shift;
    my $location = shift; 
    my $classIDX = shift; #Allows user to auto assign my class
    my $SQL = "SELECT PK_CARD_IDX, FK_TEAM_IDX, FK_USER_IDX FROM TB_CARD WHERE FK_EVENT_IDX=?";

}
sub __getTeamCount(){
    my $location = shift;
    my $SQL = "SELECT PK_TEAM_IDX FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    # my $rows = $select->rows;
    return (\%HASH);
}
sub __getCardCount(){
    my $location = shift;
    my $inType = shift;
    my $SQL = "SELECT FK_TEAM_IDX, FK_USER_IDX FROM TB_CARD WHERE FK_EVENT_IDX=? AND FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location, $inType);
    my %HASH;
    my %THASH;
      
    while (my ($teamIDX, $userIDX) = $select->fetchrow_array()){
        # print "$teamIDX, $userIDX \n";
        $HASH{$userIDX}++;
        $THASH{$teamIDX}++;
    }
    # my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','FK_USER_IDX'])};
    return (\%HASH, \%THASH);
}

sub __getJudgeCount(){
    my $location = shift;
    my $SQL = "SELECT FK_TEAM_IDX, FK_USER_IDX FROM TB_CARD WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')};
    return (\%HASH);
}

sub __getAllJudges(){
    my $location = shift;
    my $SQL = "SELECT DISTINCT ACCESS.FK_USER_IDX, USER.TX_FIRST_NAME, USER.TX_LAST_NAME, USER.TX_EMAIL FROM TB_ACCESS AS ACCESS 
        JOIN TB_USER AS USER ON ACCESS.FK_USER_IDX=USER.PK_USER_IDX 
        JOIN TB_TILES AS TILES ON ACCESS.FK_TILES_IDX=TILES.PK_TILES_IDX
        WHERE TILES.IN_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(1);
    my %HASH = %{$select->fetchall_hashref('FK_USER_IDX')};
    return (\%HASH);
}

return (1);