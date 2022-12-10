package SAE::CARD;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );
use Number::Format;
use Statistics::Basic qw(:all);
use Statistics::PointEstimation;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ==============================================================================
# GETTERS
# ==============================================================================
sub _getQuestionBreakdownStatistics(){
    my $self=shift;
    my $location = shift;
    my $cardTypeIDX=shift;
    my %HASH = ();
    my $SQL = "SELECT P.FK_SUBSECTION_IDX, P.IN_VALUE FROM TB_PAPER AS P JOIN TB_CARD AS C ON P.FK_CARD_IDX=C.PK_CARD_IDX WHERE C.FK_EVENT_IDX=? AND C.FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location, $cardTypeIDX);
    while (my ($subSectionIDX,$inValue) = $select->fetchrow_array()) {
        push (@$subSectionIDX, $inValue);
        $HASH{$subSectionIDX}{FK_SUBSECTION_IDX} = $subSectionIDX;
    }   
    foreach $subSectionIDX (sort keys %HASH) {
        $HASH{$subSectionIDX}{IN_MIN} = min(@$subSectionIDX);
        $HASH{$subSectionIDX}{IN_MAX} = max(@$subSectionIDX);
        $HASH{$subSectionIDX}{IN_AVG} = mean(@$subSectionIDX);
        $HASH{$subSectionIDX}{IN_STD} = stddev(@$subSectionIDX);
        if (stddev(@$subSectionIDX) !=0){
            $HASH{$subSectionIDX}{IN_COV} = mean(@$subSectionIDX) / stddev(@$subSectionIDX);
        } else {
            $HASH{$subSectionIDX}{IN_COV} = 0;
        }
        $HASH{$subSectionIDX}{IN_MED} = median(@$subSectionIDX);
        @$subSectionIDX = ();
    }
    return (\%HASH);
}
sub _getQuestionLists(){
    my $self = shift;
    my $SQL = "SELECT SEC.IN_SECTION, TX_SECTION, SUB.* FROM TB_SECTION AS SEC JOIN TB_SUBSECTION AS SUB ON SEC.PK_SECTION_IDX=SUB.FK_SECTION_IDX WHERE SEC.FK_CARDTYPE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( 1 );
    my %HASH = %{$select->fetchall_hashref(['IN_SECTION','IN_SUBSECTION'])};
    return (\%HASH);  
}
sub _getAvailableTeamsByClass(){
    my $self = shift;
    my $classIDX = shift;
    my $location = shift;
    my $inCardType = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=? AND FK_CLASS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $location , $classIDX );
    my %TEAMS = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    # print "\$classIDX=$classIDX, \$location=$location, \$inCardType=$inCardType\n";
    $SQL = "SELECT FK_CARDTYPE_IDX, FK_TEAM_IDX, COUNT(FK_USER_IDX) AS IN_ASSIGNED FROM TB_CARD WHERE FK_EVENT_IDX=? GROUP BY FK_CARDTYPE_IDX, FK_TEAM_IDX";
    $select = $dbi->prepare($SQL);
    $select->execute($location);
    my %CARD = %{$select->fetchall_hashref(['FK_CARDTYPE_IDX','FK_TEAM_IDX'])};
    foreach $teamIDX (sort keys %TEAMS){
        # print "$teamIDX\n";
        if ($inCardType==1){
            if ($CARD{$inCardType}{$teamIDX}{IN_ASSIGNED}>=3){
                delete $TEAMS{$teamIDX};
            }
        }
    }
    return (\%TEAMS);
}
sub _getClassPreference(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT * FROM TB_PREF WHERE FK_CLASS_IDX>?";
    my $select = $dbi->prepare($SQL);
       $select->execute(0);
    %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','FK_CLASS_IDX'])};
    return(\%HASH);
}
sub _getListOfJudges(){
    my $self =  shift;
    my $location = shift;
    my $SQL = "SELECT U.PK_USER_IDX, U.BO_EXTRA, U.TX_FIRST_NAME, U.TX_LAST_NAME, U.TX_EMAIL, U.TX_YEAR FROM TB_USER AS U JOIN TB_PREF AS P ON U.PK_USER_IDX=P.FK_USER_IDX WHERE P.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
}
sub _getCardList(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT CARD.PK_CARD_IDX, CARD.FK_USER_IDX, CARD.FK_TEAM_IDX, CARD.FK_CARDTYPE_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, CARD.IN_STATUS, TEAM.FK_CLASS_IDX
        FROM TB_CARD AS CARD JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE (CARD.FK_EVENT_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','FK_CARDTYPE_IDX','IN_NUMBER'])};
    return (\%HASH);
}
sub _getAverageCardStatus(){
    my $self = shift;
    my $location = shift;
    my $SQL = "SELECT  CARD.FK_CARDTYPE_IDX, CARD.FK_USER_IDX,  ROUND(AVG(CARD.IN_STATUS),0) AS AVG_STATUS 
        FROM TB_CARD AS CARD JOIN TB_TEAM AS TEAM ON CARD.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
        WHERE (CARD.FK_EVENT_IDX=?)
        GROUP BY CARD.FK_CARDTYPE_IDX, CARD.FK_USER_IDX";
    my $select = $dbi->prepare($SQL);
       $select->execute($location);
    %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','FK_CARDTYPE_IDX'])};
    return (\%HASH);
}
sub _getReportStatisticStatusByEvent(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    my %HASH = ();
    @TOTAL = ();
    my $stat = new Statistics::PointEstimation;
    $stat->set_significance(95); #set the significance(confidence) level to 95%
   
    
    # print "\$cardTypeIDX = $cardTypeIDX\n";
    my $SQL = "SELECT C.FK_USER_IDX, C.PK_CARD_IDX, AVG(P.IN_VALUE) AS IN_AVERAGE 
            FROM TB_CARD AS C JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
        WHERE C.FK_CARDTYPE_IDX=? AND C.FK_EVENT_IDX=? 
        GROUP By C.FK_USER_IDX, C.PK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute($cardTypeIDX, $location);
    while (my ($userIDX, $cardIDX, $inAverage) = $select->fetchrow_array()) {
        push (@$userIDX, $inAverage);
        push (@$cardTypeIDX, $inAverage);
        $HASH{$userIDX}{PK_USER_IDX} = $userIDX;
        # print "$userIDX, $cardIDX, $inAverage\n";
        # print "\$cardTypeIDX = $cardTypeIDX\n";
    }
    foreach $userIDX (sort keys %HASH){
        $HASH{$userIDX}{IN_MIN} = min(@$userIDX);
        $HASH{$userIDX}{IN_MAX} = max(@$userIDX);
        $HASH{$userIDX}{IN_AVG} = mean(@$userIDX);
        $HASH{$userIDX}{IN_STD} = stddev(@$userIDX);
        if (stddev(@$userIDX) !=0){
            $HASH{$userIDX}{IN_COV} = mean(@$userIDX) / stddev(@$userIDX);
        } else {
            $HASH{$userIDX}{IN_COV} = 0;
        }
        $HASH{$userIDX}{IN_MED} = median(@$userIDX);
        # printf "min = %2.4f\n",  min(@$userIDX);
        @$userIDX = ();
        # printf "min = %2.4f\n",  min(@$userIDX);
    } 
    $stat->add_data(@$cardTypeIDX);
    $HASH{$cardTypeIDX}{IN_MIN} = min(@$cardTypeIDX);
    $HASH{$cardTypeIDX}{IN_MAX} = max(@$cardTypeIDX);
    $HASH{$cardTypeIDX}{IN_AVG} = mean(@$cardTypeIDX);
    $HASH{$cardTypeIDX}{IN_STD} = stddev(@$cardTypeIDX);
    if (stddev(@$cardTypeIDX) !=0){
        $HASH{$cardTypeIDX}{IN_COV} = mean(@$cardTypeIDX) / stddev(@$cardTypeIDX);
    } else {
        $HASH{$cardTypeIDX}{IN_COV} = 0;
    }
    $HASH{$cardTypeIDX}{IN_MED} = median(@$cardTypeIDX);
    @$cardTypeIDX = ();
    
    $HASH{$cardTypeIDX}{IN_COUNT}=$stat->count();
    $HASH{$cardTypeIDX}{IN_MEAN} =$stat->mean();
    $HASH{$cardTypeIDX}{IN_UPPER}=$stat->upper_clm();
    $HASH{$cardTypeIDX}{IN_LOWER}=$stat->lower_clm();
    $HASH{$cardTypeIDX}{IN_DOF}  =$stat->df();
    $HASH{$cardTypeIDX}{IN_VAR}=$stat->variance();
    $HASH{$cardTypeIDX}{IN_STDDEV}=$stat->standard_deviation();
    $HASH{$cardTypeIDX}{IN_ERROR}=$stat->standard_error();
    $HASH{$cardTypeIDX}{IN_TSTAT}=$stat->t_statistic();
    $HASH{$cardTypeIDX}{IN_CONFI}=$stat->significance();
    $HASH{$cardTypeIDX}{IN_DELTA}=$stat->delta();
    $HASH{$cardTypeIDX}{IN_PROB} =$stat->t_prob();
    
    # print "\n Sample = ".$stat->count();
    # print "\n Mean = ".$stat->mean().' +/- '.$stat->delta();
    # print "\n Variance = ".$stat->variance();
    # print "\n standard deviation = ".$stat->standard_deviation();
    # print "\n standard error = ".$stat->standard_error();
    # printf "\n confidence = %2.4f%", $stat->significance();
    # printf "\n Upper = %2.4f",$stat->upper_clm();
    # printf "\n Lower = %2.4f",$stat->lower_clm();
    # printf "\n Lower = %2.4f".$stat->lower_clm();
    # printf "\n Lower = %2.4f".$stat->lower_clm();

    # print "\n\n";
# print "Summary  from the observed values of the sample:\n";
# print "\tsample size= ", $stat->count()," , degree of freedom=", $stat->df(), "\n";
# print "\tmean=", $stat->mean()," , variance=", $stat->variance(),"\n";
# print "\tstandard deviation=", $stat->standard_deviation()," , standard error=", $stat->standard_error(),"\n";
# print "\t the estimate of the mean is ", $stat->mean()," +/- ",$stat->delta(),"\n\t",
# " or (",$stat->lower_clm()," to ",$stat->upper_clm," ) with ",$stat->significance," % of confidence\n";
# print "\t t-statistic=T=",$stat->t_statistic()," , Prob >|T|=",$stat->t_prob(),"\n";
    
    return (\%HASH);
}

sub _getReportStatisticStatusByJudge(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $userIDX = shift;
    my %HASH = ();
    # my @TOTAL = ();
    # print "\$cardTypeIDX = $cardTypeIDX\n";
    # my $SQL = "SELECT C.FK_TEAM_IDX, C.PK_CARD_IDX, T.IN_NUMBER, T.TX_SCHOOL, P.IN_VALUE 
    #         FROM TB_CARD AS C 
    #         JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
    #         JOIN TB_TEAM AS T ON C.FK_TEAM_IDX=T.PK_TEAM_IDX
    #     WHERE C.FK_CARDTYPE_IDX=? AND C.FK_USER_IDX=?";
    # # my $SQL = "SELECT C.FK_TEAM_IDX, C.PK_CARD_IDX, T.IN_NUMBER, T.TX_SCHOOL, AVG(P.IN_VALUE) AS IN_AVERAGE 
    # #         FROM TB_CARD AS C 
    # #         JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
    # #         JOIN TB_TEAM AS T ON C.FK_TEAM_IDX=T.PK_TEAM_IDX
    # #     WHERE C.FK_CARDTYPE_IDX=? AND C.FK_USER_IDX=?
    # #     GROUP By C.FK_TEAM_IDX, C.PK_CARD_IDX";
    # my $select = $dbi->prepare($SQL);
    #   $select->execute($cardTypeIDX, $userIDX);
    # while (my ($teamIDX, $cardIDX, $inNumber, $txSchool, $inValue) = $select->fetchrow_array()) {
    #     push (@$teamIDX, $inValue);
    #     # push (@TOTAL, $inAverage);
    #     $HASH{$teamIDX}{PK_TEAM_IDX} = $teamIDX;
    #     $HASH{$teamIDX}{TX_SCHOOL} = $txSchool;
    #     $HASH{$teamIDX}{IN_NUMBER} = $inNumber;
    #     # print "$userIDX, $cardIDX, $inAverage\n";
    #     # print "\$cardTypeIDX = $cardTypeIDX\n";
    # }
    my $SQL = "SELECT C.FK_TEAM_IDX, C.PK_CARD_IDX, T.IN_NUMBER, T.TX_SCHOOL, P.IN_VALUE , E.IN_YEAR, TX_EVENT_CITY
            FROM TB_CARD AS C 
            JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
            JOIN TB_TEAM AS T ON C.FK_TEAM_IDX=T.PK_TEAM_IDX
            JOIN TB_EVENT AS E on T.FK_EVENT_IDX=E.PK_EVENT_IDX
        WHERE C.FK_CARDTYPE_IDX=? AND C.FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardTypeIDX, $userIDX);
    while (my ($teamIDX, $cardIDX, $inNumber, $txSchool, $inValue, $inYear, $txCity) = $select->fetchrow_array()) {
        push (@$teamIDX, $inValue);
        # push (@TOTAL, $inAverage);
        $HASH{$teamIDX}{PK_TEAM_IDX} = $teamIDX;
        $HASH{$teamIDX}{TX_SCHOOL} = $txSchool;
        $HASH{$teamIDX}{IN_NUMBER} = $inNumber;
        $HASH{$teamIDX}{IN_YEAR} = $inYear;
        $HASH{$teamIDX}{TX_CITY} = $txCity;
        # print "$userIDX, $cardIDX, $inAverage\n";
        # print "\$cardTypeIDX = $cardTypeIDX\n";
    }
    foreach $teamIDX (sort keys %HASH){
        $HASH{$teamIDX}{IN_MIN} = min(@$teamIDX);
        $HASH{$teamIDX}{IN_MAX} = max(@$teamIDX);
        $HASH{$teamIDX}{IN_AVG} = mean(@$teamIDX);
        $HASH{$teamIDX}{IN_STD} = stddev(@$teamIDX);
        if (stddev(@$teamIDX) !=0){
            $HASH{$teamIDX}{IN_COV} = mean(@$teamIDX) / stddev(@$teamIDX);
        } else {
            $HASH{$teamIDX}{IN_COV} = 0;
        }
        $HASH{$teamIDX}{IN_MED} = median(@$teamIDX);
        @$teamIDX = ();
    }
    return (\%HASH);
}

sub _getReportStatisticStatusByTeam_2(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $teamIDX = shift;
    my %HASH = ();
    # my @TOTAL = ();
    # print "\$cardTypeIDX = $cardTypeIDX\n";
    my $SQL = "SELECT C.FK_USER_IDX, C.PK_CARD_IDX, U.TX_FIRST_NAME, U.TX_LAST_NAME, P.IN_VALUE, U.TX_YEAR
            FROM TB_CARD AS C 
            JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
            JOIN TB_USER AS U ON C.FK_USER_IDX=U.PK_USER_IDX
        WHERE C.FK_CARDTYPE_IDX=? AND C.FK_TEAM_IDX=?";
    # my $SQL = "SELECT C.FK_USER_IDX, C.PK_CARD_IDX, U.TX_FIRST_NAME, U.TX_LAST_NAME, AVG(P.IN_VALUE) AS IN_AVERAGE 
    #         FROM TB_CARD AS C 
    #         JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
    #         JOIN TB_USER AS U ON C.FK_USER_IDX=U.PK_USER_IDX
    #     WHERE C.FK_CARDTYPE_IDX=? AND C.FK_TEAM_IDX=?
        # GROUP By C.FK_USER_IDX, C.PK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute($cardTypeIDX, $teamIDX);
    while (my ($userIDX, $cardIDX, $firstName, $lastName, $inValue, $txYear) = $select->fetchrow_array()) {
        push (@$userIDX, $inValue);
        # push (@TOTAL, $inAverage);
        $HASH{$userIDX}{PK_TEAM_IDX} = $teamIDX;
        $HASH{$userIDX}{TX_FIRST_NAME} = $firstName;
        $HASH{$userIDX}{TX_LAST_NAME} = $lastName;
        $HASH{$userIDX}{TX_YEAR} = $txYear;
    }
    foreach $userIDX (sort keys %HASH){
        $HASH{$userIDX}{IN_MIN} = min(@$userIDX);
        $HASH{$userIDX}{IN_MAX} = max(@$userIDX);
        $HASH{$userIDX}{IN_AVG} = mean(@$userIDX);
        $HASH{$userIDX}{IN_STD} = stddev(@$userIDX);
        if (stddev(@$userIDX) !=0){
            $HASH{$userIDX}{IN_COV} = mean(@$userIDX) / stddev(@$userIDX);
        } else {
            $HASH{$userIDX}{IN_COV} = 0;
        }
        $HASH{$userIDX}{IN_MED} = median(@$userIDX);
        @$userIDX = ();
    }
    # $HASH{0}{IN_MIN} = min(@TOTAL);
    # $HASH{0}{IN_MAX} = max(@TOTAL);
    # $HASH{0}{IN_AVG} = mean(@TOTAL);
    # $HASH{0}{IN_STD} = stddev(@TOTAL);
    # if (stddev(@TOTAL) !=0){
    #     $HASH{0}{IN_COV} = mean(@TOTAL) / stddev(@TOTAL);
    # } else {
    #     $HASH{0}{IN_COV} = 0;
    # }
    # $HASH{0}{IN_MED} = median(@TOTAL);
    @TOTAL = ();
    return (\%HASH);
}

sub _getReportStatisticStatusByTeam(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $teamIDX = shift;
    my %HASH = ();
    my @TOTAL = ();

    # print "\$cardTypeIDX = $cardTypeIDX\n";
    my $SQL = "SELECT C.FK_USER_IDX, C.PK_CARD_IDX, U.TX_FIRST_NAME, U.TX_LAST_NAME, AVG(P.IN_VALUE) AS IN_AVERAGE 
            FROM TB_CARD AS C 
            JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
            JOIN TB_USER AS U ON C.FK_USER_IDX=U.PK_USER_IDX
        WHERE C.FK_CARDTYPE_IDX=? AND C.FK_TEAM_IDX=?
        GROUP By C.FK_USER_IDX, C.PK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute($cardTypeIDX, $teamIDX);
    while (my ($userIDX, $cardIDX, $firstName, $lastName, $inAverage) = $select->fetchrow_array()) {
        push (@$userIDX, $inAverage);
        push (@TOTAL, $inAverage);
        $HASH{$userIDX}{PK_TEAM_IDX} = $teamIDX;
        $HASH{$userIDX}{TX_FIRST_NAME} = $firstName;
        $HASH{$userIDX}{TX_LAST_NAME} = $lastName;
    }
    foreach $userIDX (sort keys %HASH){
        $HASH{$userIDX}{IN_MIN} = min(@$userIDX);
        $HASH{$userIDX}{IN_MAX} = max(@$userIDX);
        $HASH{$userIDX}{IN_AVG} = mean(@$userIDX);
        $HASH{$userIDX}{IN_STD} = stddev(@$userIDX);
        if (stddev(@$userIDX) !=0){
            $HASH{$userIDX}{IN_COV} = mean(@$userIDX) / stddev(@$userIDX);
        } else {
            $HASH{$userIDX}{IN_COV} = 0;
        }
        $HASH{$userIDX}{IN_MED} = median(@$userIDX);
        @$userIDX = ();
    }
    $HASH{0}{IN_MIN} = min(@TOTAL);
    $HASH{0}{IN_MAX} = max(@TOTAL);
    $HASH{0}{IN_AVG} = mean(@TOTAL);
    $HASH{0}{IN_STD} = stddev(@TOTAL);
    if (stddev(@TOTAL) !=0){
        $HASH{0}{IN_COV} = mean(@TOTAL) / stddev(@TOTAL);
    } else {
        $HASH{0}{IN_COV} = 0;
    }
    $HASH{0}{IN_MED} = median(@TOTAL);
    @TOTAL = ();
    return (\%HASH);
}
sub _getTeamStatisticsByEvent(){
    my $self = shift;
    my $cardTypeIDX = shift;
    my $location = shift;
    my %HASH = ();
    my $stat = new Statistics::PointEstimation;
    $stat->set_significance(95); #set the significance(confidence) level to 95%
    my $SQL = "SELECT C.FK_TEAM_IDX, C.PK_CARD_IDX, AVG(P.IN_VALUE) AS IN_AVERAGE 
            FROM TB_CARD AS C JOIN TB_PAPER AS P ON C.PK_CARD_IDX=P.FK_CARD_IDX 
        WHERE C.FK_CARDTYPE_IDX=? AND C.FK_EVENT_IDX =? 
        GROUP BY C.FK_TEAM_IDX, C.PK_CARD_IDX";
    my $select = $dbi->prepare($SQL);
      $select->execute($cardTypeIDX, $location);
    while (my ($teamIDX, $cardIDX, $inAverage) = $select->fetchrow_array()) {
        push (@$teamIDX, $inAverage);
        push (@$cardTypeIDX, $inAverage);
        
        $HASH{$teamIDX}{PK_TEAM_IDX} = $teamIDX;
        # print "$teamIDX, $cardIDX, $inAverage\n";
    }
    foreach $teamIDX (sort keys %HASH){
        $HASH{$teamIDX}{IN_MIN} = min(@$teamIDX);
        $HASH{$teamIDX}{IN_MAX} = max(@$teamIDX);
        $HASH{$teamIDX}{IN_AVG} = mean(@$teamIDX);
        $HASH{$teamIDX}{IN_STD} = stddev(@$teamIDX);
        if (stddev(@$teamIDX) !=0){
            $HASH{$teamIDX}{IN_COV} = mean(@$teamIDX) / stddev(@$teamIDX);
        } else {
            $HASH{$teamIDX}{IN_COV} = 0;
        }
        $HASH{$teamIDX}{IN_MED} = median(@$teamIDX);
        @$teamIDX = ();
    }
    $stat->add_data(@$cardTypeIDX);
    $HASH{0}{IN_COUNT}=$stat->count();
    $HASH{0}{IN_MEAN} =$stat->mean();
    $HASH{0}{IN_UPPER}=$stat->upper_clm();
    $HASH{0}{IN_LOWER}=$stat->lower_clm();
    $HASH{0}{IN_DOF}  =$stat->df();
    $HASH{0}{IN_VAR}=$stat->variance();
    $HASH{0}{IN_STDDEV}=$stat->standard_deviation();
    $HASH{0}{IN_ERROR}=$stat->standard_error();
    $HASH{0}{IN_TSTAT}=$stat->t_statistic();
    $HASH{0}{IN_CONFI}=$stat->significance();
    $HASH{0}{IN_DELTA}=$stat->delta();
    $HASH{0}{IN_PROB} =$stat->t_prob();
    
    return (\%HASH);
}

# ==============================================================================
# INSERTS
# ==============================================================================
sub _createANewCard(){
    my $self = shift;
    my ($userIDX, $teamIDX, $inType, $location) = @_;
    my $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX) VALUES(?,?,?,?)";
    my $insert = $dbi -> prepare($SQL);
      $insert->execute($userIDX, $teamIDX, $inType, $location);
    my $cardIDX = $insert->{q{mysql_insertid}};
    return ($cardIDX);
}
# ==============================================================================
# UPDATES
# ==============================================================================

# ==============================================================================
# DELETES
# ==============================================================================



return (1);