package SAE::TECH;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;
use SAE::TEAM;
use SAE::FLIGHT;


my $dbi = new SAE::Db();
my %TECH;
my %COUNTRY;

sub new{
    my $className = shift;
    my $self = {};
    bless($self, $className);   
    return $self;
    }

# -------------- 2023 --------------
sub _getTechItemDescriptions (){
    my ($self, $classIDX) = @_;
    my %FIELD = (1=>'R.BO_REGULAR', 2=>'R.BO_ADVANCE', 3=>'R.BO_MICRO',4=>'R.BO_PADA');
    my $field = $FIELD{$classIDX};
    my $SQL;
    if ($classIDX==2) {
        $SQL = qq(SELECT CONCAT(S.IN_SECTION,".",R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
                FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
                WHERE (R.BO_ADVANCE=? or R.BO_PADA=1));
        } else {
            $SQL = qq(SELECT CONCAT(S.IN_SECTION,".",R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
                FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
                WHERE ($field=?));
        }
    my $select = $dbi->prepare($SQL);
       $select->execute(1);
       # print $SQL;
    my %HASH = %{$select->fetchall_hashref('PK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getPenalizedItems (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT DISTINCT T.FK_TECH_REQ_IDX, R.IN_POINTS 
        FROM TB_TECH AS T JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX 
        WHERE (T.FK_TEAM_IDX=? AND T.IN_STATUS=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX , 2);
    my %HASH = %{$select->fetchall_hashref('FK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getTechPenalties (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT DISTINCT T.FK_TECH_REQ_IDX, R.IN_POINTS 
        FROM TB_TECH AS T JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX 
        WHERE (T.FK_TEAM_IDX=? AND T.IN_STATUS=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX , 2);
    my $inTotal = 0;
    while(my ($reqIDX, $inPoint) = $select->fetchrow_array()) {
        $inTotal += $inPoint;
    }
    # my %HASH = %{$select->fetchall_hashref('FK_TECH_REQ_IDX')};
    return ($inTotal);
    }
sub _getTeamCheckStatus (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT IN_COMPLETE, IN_SAFETY FROM TB_TECH_PLANE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my $totalRow = $select->rows();
    my $reqCount = 0;
    my $safCount = 0;
    my $reqStatus = 0;
    my $safStatus = 0;
    while (my ($inComplete, $inSafety) = $select->fetchrow_array()) {
        $reqCount += $inComplete;
        $safCount += $inSafety;
    }
    if ($totalRow == $reqCount){$reqStatus = 1}
    if ($totalRow == $safCount){$safStatus = 1}
    return ($reqStatus, $safStatus);
    }
sub _getTeamDataFromPlane (){
    my ($self, $planeIDX) = @_;
    my $SQL ="SELECT P.*, T.IN_NUMBER, T.FK_CLASS_IDX FROM TB_TECH_PLANE AS P JOIN TB_TEAM AS T ON P.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE P.PK_TECH_PLANE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $planeIDX );
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _setCompleteSafetyInspection (){
    my ($self, $planeIDX) = @_;
    my $SQL = "UPDATE TB_TECH_PLANE SET IN_SAFETY=? WHERE PK_TECH_PLANE_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute(1, $planeIDX);
    return ();
    }
sub _setInprogressSafetyInspection (){
    my ($self, $planeIDX) = @_;
    my $SQL = "UPDATE TB_TECH_PLANE SET IN_SAFETY=? WHERE PK_TECH_PLANE_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute(0, $planeIDX);
    return ();
    }
sub _setCompleteInspection (){
    my ($self, $planeIDX) = @_;
    my $SQL = "UPDATE TB_TECH_PLANE SET IN_COMPLETE=? WHERE PK_TECH_PLANE_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute(1, $planeIDX);
    return ();
    }
sub _setInprogressInspection (){
    my ($self, $planeIDX) = @_;
    my $SQL = "UPDATE TB_TECH_PLANE SET IN_COMPLETE=? WHERE PK_TECH_PLANE_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute(0, $planeIDX);
    return ();
    }
sub _getCompleteConfirmation (){
    my ($self, $planeIDX, $txType) = @_;
    # my $SQL = "SELECT T.PK_TECH_IDX, T.IN_STATUS, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS FROM TB_TECH AS T JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX WHERE FK_TECH_PLANE_IDX=?";
    my $SQL = "SELECT S.PK_TECH_REQ_IDX, T.PK_TECH_IDX, T.IN_STATUS, S.TX_REQUIREMENT, S.TX_SECTION, S.IN_POINTS, R.IN_SECTION AS IN_SECTION, S.IN_SECTION AS IN_SUBSECTION, 
        R.TX_SECTION AS TX_TITLE FROM TB_TECH AS T 
    JOIN TB_TECH_REQ AS S ON T.FK_TECH_REQ_IDX=S.PK_TECH_REQ_IDX 
    JOIN TB_TECH_REQ_SECTION AS R ON R.PK_TECH_REQ_SECTION_IDX=S.FK_TECH_REQ_SECTION_IDX 
    WHERE (FK_TECH_PLANE_IDX=? AND TX_TYPE=?)";
    # print $SQL;
    # print $planeIDX;
    my $select = $dbi->prepare($SQL);
       $select->execute( $planeIDX, $txType );
    my %HASH = %{$select->fetchall_hashref('PK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getTeamCertificationStatus (){
    my ($self, $teamIDX) = @_;
    my $str;

    return ();
    }
# sub _getCertStatus (){
#     my ($self, $teamIDX) = @_;
#     my $str;

#     return ();
#     }
sub _getCertificationStatus (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TECH_STUDENT WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getTechSafetyCheckStatus(){
    # my ($self, $teamIDX, $inSafetyStatus, $classIDX) = @_;
    # my $txSafety = 'Safety Check<br>Not Started';
    # if ($inSafetyStatus == 1) {      # Inspection has begun (no Failed)
    #     $colorSafetyStatus = 'w3-yellow';
    #     $txSafety = 'Safety Check<br>In-Progress';
    # } elsif ($inSafetyStatus == 2) { # Inspection has begun, and the team needs to be reinspected
    #     $colorSafetyStatus = 'w3-pale-red';
    #     $txSafety = 'Safety Check: <b class="w3-text-red">Failed</b><br>Re-Check Required';
    # } elsif ($inSafetyStatus == 3) { # Passed
    #     $colorSafetyStatus = 'w3-light-blue';
    #     $txSafety = 'Safety Check<br>Complete';
    # } else {                           # Have not attempted inspection yet
    #     $colorSafetyStatus = 'w3-white';
    #     $txSafety = 'Safety Check<br>Not Started';
    # }
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT  SUM(P.IN_SAFETY) AS IN_SAFETY, COUNT(T.FK_CLASS_IDX) AS IN_ROW
        FROM TB_TECH_PLANE AS P JOIN TB_TEAM AS T ON P.FK_TEAM_IDX=T.PK_TEAM_IDX
        WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my ($inComplete, $totalRow) = $select->fetchrow_array();
    my $colorSafetyStatus = 'w3-white';
    my $txSafety = 'Safety Check<br>Not Started';
    if ($totalRow > 0 && $totalRow != $inComplete){
        $colorSafetyStatus = 'w3-yellow';
        $txSafety = 'Safety Check<br>in-Progress';
    } elsif ($totalRow > 0 && $totalRow == $inComplete) {
        $colorSafetyStatus = 'w3-light-blue';
        $txSafety = 'Safety Check<br>Complete';
    } else {
        $colorSafetyStatus = 'w3-white';
        $txSafety = 'Safety Check<br>Not Started';
    }
    $SQL = "SELECT FK_CLASS_IDX FROM TB_TEAM WHERE PK_TEAM_IDX=?";
       $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my ($classIDX) = $select->fetchrow_array();
    my $str;
    $str .= sprintf '<div ID="TeamSafetyCheck_%d" class="w3-container '.$colorSafetyStatus.' w3-padding-16 w3-border w3-card-2 w3-round" style="cursor: pointer" onclick="student_openSafetyChecks(this, %d, %d)">', $teamIDX, $teamIDX, $classIDX;
    $str .= '<div class="w3-left">';
    $str .= sprintf '<i class="fa fa-medkit fa-fw fa-2x"><span class="w3-margin-left w3-large">Safety</span></i>';
    $str .= '</div>';
    $str .= sprintf '<div class="w3-right"><i class="fa fa-chevron-right fa-3x w3-margin-left" aria-hidden="true"></i></div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= sprintf '<h5>%s</h5>', $txSafety;
    # $str .= sprintf '<h4>Re-Inspection Required after flight attempt # %02d</h4>', $TECH{$inspectIDX}{IN_ROUND};
    $str .= '</div>';
    return ($str );
    }
sub _getTechRequirementsCheckStatus(){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT  SUM(P.IN_COMPLETE) AS IN_COMPLETE, COUNT(T.FK_CLASS_IDX) AS IN_ROW
        FROM TB_TECH_PLANE AS P JOIN TB_TEAM AS T ON P.FK_TEAM_IDX=T.PK_TEAM_IDX
        WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my ($inComplete, $totalRow) = $select->fetchrow_array();
    my $colorReqStatus = 'w3-white';
    my $txReq = 'Requirements Check<br>Not Started';
    if ($totalRow > 0 && $totalRow != $inComplete){
        $colorReqStatus = 'w3-yellow';
        $txReq = 'Requirements Check<br>in-Progress';
    } elsif ($totalRow > 0 && $totalRow == $inComplete) {
        $colorReqStatus = 'w3-light-blue';
        $txReq = 'Requirements Check<br>Complete';
    } else {
        $colorReqStatus = 'w3-white';
        $txReq = 'Requirements Check<br>Not Started';
    }
    $SQL = "SELECT FK_CLASS_IDX FROM TB_TEAM WHERE PK_TEAM_IDX=?";
       $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my ($classIDX) = $select->fetchrow_array();
    my $str;
    # $str .= qq($totalRow, $inComplete);
    $str .= sprintf '<div ID="TeamRequirementsCheck_%d" class="w3-container '.$colorReqStatus.' w3-padding-16 w3-border w3-card-2 w3-round" style="cursor: pointer" onclick="student_openRequirementsChecks(this, %d, %d)">', $teamIDX, $teamIDX, $classIDX;
    $str .= '<div class="w3-left">';
    $str .= sprintf '<i class="fa fa-check-square-o fa-fw fa-2x"><span class="w3-margin-left w3-large">Requirements</span></i>';
    $str .= '</div>';
    $str .= sprintf '<div class="w3-right"><i class="fa fa-chevron-right fa-3x w3-margin-left" aria-hidden="true"></i></div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= sprintf '<h5>%s</h5>', $txReq;
    # $str .= sprintf '<h4>Re-Inspection Required after flight attempt # %02d</h4>', $TECH{$inspectIDX}{IN_ROUND};
    $str .= '</div>';
    return ($str);
    }
sub getInspectionPenalties(){
    my ($teamIDX) = @_;
    my $SQL = "SELECT SUM(REQ.IN_POINTS) AS IN_TOTAL 
        FROM TB_TECH AS TECH JOIN TB_TECH_REQ AS REQ ON TECH.FK_TECH_REQ_IDX=REQ.PK_TECH_REQ_IDX 
        WHERE (TECH.BO_PENALTY=? AND TECH.FK_TEAM_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( 1, $teamIDX );
    my $inPenalty = $select->fetchrow_array();
    return  ($inPenalty);
    }   
sub _getTeamInspectionPenalties (){
    my ($self, $teamIDX) = @_;
    my $str = &getInspectionPenalties($teamIDX);
    return ($str);
    }
sub _getTeamInspectionStatus (){
    my ($self, $teamIDX, $classIDX) = @_;
    my $str;
    $str = &getInsptectionStatus($teamIDX, $classIDX);
    return ($str);
    }
sub getTeamSafetyStatus(){
    my ($teamIDX, $classIDX) = @_;
    my $txType="safetySectionNumber";
    my %FIELD = (1=>'REQ.BO_REGULAR', 2=>'REQ.BO_ADVANCE', 3=>'REQ.BO_MICRO',4=>'REQ.BO_PADA');
    my $field = $FIELD{$classIDX};
    my $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND $field=?)";
    # if ($classIDX == 3){
    #    $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND REQ.BO_MICRO=?)";
    # } elsif ($classIDX == 2) {
    #    $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND REQ.BO_ADVANCE=?)";
    # } else {
    #    $SQL = "SELECT REQ.* FROM TB_TECH_REQ AS REQ JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX WHERE (SEC.TX_TYPE=? AND REQ.BO_REGULAR=?)";
    # }
    my $select = $dbi->prepare($SQL);
       $select->execute( $txType, 1 );
    my $required = $select->rows;
    my %STATUS;
    $SQL = "SELECT TECH.IN_STATUS FROM TB_TECH AS TECH 
        JOIN TB_TECH_REQ AS REQ ON TECH.FK_TECH_REQ_IDX=REQ.PK_TECH_REQ_IDX 
        JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX
        WHERE (SEC.TX_TYPE=? AND TECH.FK_TEAM_IDX=?)";
    my $req = $dbi->prepare($SQL);
       $req->execute( $txType,$teamIDX );
    while (my ($inStatus)= $req->fetchrow_array()) {
        $STATUS{$inStatus}++;
    }
    # print "Required Safety Inspections = $required\n";
    # print "PASSED Safety Inspection   = $STATUS{3}\n";
    # print "FAILED Safety Inspection   = $STATUS{2}\n";
    my $inSafetyStatus = 0;
    if ($STATUS{3} == $required) {
        $inSafetyStatus = 3; # All Passed 
    } elsif ($STATUS{3} > 0 && $STATUS{2} == 0) {
        $inSafetyStatus = 1; # Safety Inspection in Progress with no failures
    } elsif ($STATUS{2} > 0) {
        $inSafetyStatus = 2; # Safety Inspection in Progress; Some failure and reinspection is required
    } else {
        $inSafetyStatus = 0; # not started
    }
    return ($inSafetyStatus);
    }
sub _getTeamSafetyStatus(){
    my ($self, $teamIDX, $classIDX) = @_;
    my $str;
    $str = &getTeamSafetyStatus($teamIDX, $classIDX);
    return ($str);
    }
sub _getPlaneInspectionStatus (){
    my ($self, $planeIDX) = @_;
    my $SQL = "SELECT IN_COMPLETE, IN_SAFETY FROM TB_TECH_PLANE WHERE PK_TECH_PLANE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $planeIDX );
    my ($reqStatus, $safetyStatus) = $select->fetchrow_array();
    return ($reqStatus, $safetyStatus);
    }

sub getPlaneInspectionStatus (){
    # my ($planeIDX) = @_;
    # my $SQL = "SELECT IN_COMPLETE, IN_SAFETY FROM TB_TECH_PLANE WHERE PK_TECH_PLANE_IDX=?";
    # my $select = $dbi->prepare($SQL);
    #    $select->execute( $planeIDX );
    # my ($reqStatus, $safetyStatus) = $select->fetchrow_array()
    # return ($reqStatus, $safetyStatus);
    # my $str;
    # # print "$planeIDX, $classIDX\n\n"; 
    # my $SQL;
    # my $boClass;
    # my %REQ_LIST;
    # my %REQ_REQ;
    # my $boStatus = 0; # Not started
    # my $txType = 'reqSectionNumber';
    # if ($classIDX == 1){
    #     $boClass = 'BO_REGULAR'
    # } elsif ($classIDX == 2) {
    #     $boClass = 'BO_ADVANCE'
    # } else {
    #     $boClass = 'BO_MICRO';
    # }
    # # Creating a list of all requirement check items and create two hashes for complete list and required list.
    # my $SQL = "SELECT R.PK_TECH_REQ_IDX, S.BO_CHECK FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX WHERE  ($boClass=? AND S.TX_TYPE=? AND S.BO_CHECK=?)";
    # my $select = $dbi->prepare($SQL);
    #    $select->execute( 1, $txType, 1 );
    # my $reqTotal = $select->rows();
    

    # $SQL    = "SELECT COUNT(T.IN_STATUS) AS IN_COUNT FROM TB_TECH AS T 
    #  JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX
    #  JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX
    #  WHERE (T.FK_TECH_PLANE_IDX=? AND S.TX_TYPE=? AND S.BO_CHECK=?)";
    # $select = $dbi->prepare($SQL);
    # $select ->execute( $planeIDX, $txType, 1);
    # my ($checkedTotal) = $select->fetchrow_array();

    # $SQL = "SELECT COUNT(T.IN_STATUS) AS IN_COUNT FROM TB_TECH AS T 
    #  JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX
    #  JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX
    #  WHERE (T.FK_TECH_PLANE_IDX=? AND S.TX_TYPE=? and S.BO_CHECK=? and T.IN_STATUS=?)";
    # $select = $dbi->prepare($SQL);
    # $select ->execute( $planeIDX , $txType, 1, 0);
    # my ($failedTotal) = $select->fetchrow_array();

    # if ( $checkedTotal> 0 )  {$boStatus = 1} #In Progress
    # if ( $failedTotal > 0 && $checkedTotal == $reqTotal)  {$boStatus = 2} # FAILED
    # if ( $failedTotal ==0 && $checkedTotal == $reqTotal) { $boStatus = 3 } # PASSED
    # if ( $checkedTotal==0)  {$boStatus = 0} # Not started

    # # printf "reqTotal     = %10d\n", $reqTotal;
    # # printf "checkedTotal = %10d\n", $checkedTotal;
    # # printf "failedTotal  = %10d\n", $failedTotal;
    # # printf "boStatus     = %10d\n", $boStatus;
    # return ($boStatus);
    }
sub getInsptectionStatus (){
    my ($teamIDX, $classIDX) = @_;
    my $SQL;
    my $boClass;
    my %REQ_LIST;
    my %REQ_REQ;
    my $boStatus = 0; # Not started
    my $txType = 'reqSectionNumber';
    # if ($classIDX == 1){
    #     $boClass = 'BO_REGULAR'
    # } elsif ($classIDX == 2) {
    #     $boClass = 'BO_ADVANCE'
    # } else {
    #     $boClass = 'BO_MICRO';
    # }
    my %FIELD = (1=>'BO_REGULAR', 2=>'BO_ADVANCE', 3=>'BO_MICRO',4=>'BO_PADA');
    my $boClass = $FIELD{$classIDX};
    # Creating a list of all requirement check items and create two hashes for complete list and required list.
    my $SQL = "SELECT R.PK_TECH_REQ_IDX, S.BO_CHECK FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX WHERE  ($boClass=? AND S.TX_TYPE=? AND S.BO_CHECK=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( 1, $txType, 1 );
    my $reqTotal = $select->rows();

    $SQL    = "SELECT COUNT(T.IN_STATUS) AS IN_COUNT FROM TB_TECH AS T 
     JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX
     JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX
     WHERE (T.FK_TEAM_IDX=? AND S.TX_TYPE=? AND S.BO_CHECK=?)";
    $select = $dbi->prepare($SQL);
    $select ->execute( $teamIDX, $txType, 1);
    my ($checkedTotal) = $select->fetchrow_array();

    $SQL = "SELECT COUNT(T.IN_STATUS) AS IN_COUNT FROM TB_TECH AS T 
     JOIN TB_TECH_REQ AS R ON T.FK_TECH_REQ_IDX=R.PK_TECH_REQ_IDX
     JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX
     WHERE (T.FK_TEAM_IDX=? AND S.TX_TYPE=? and S.BO_CHECK=? and T.IN_STATUS=?)";
    $select = $dbi->prepare($SQL);
    $select ->execute( $teamIDX , $txType, 1, 0);
    my ($failedTotal) = $select->fetchrow_array();


    if ( $checkedTotal> 0 )  {$boStatus = 1} #In Progress
    if ( $failedTotal > 0 && $checkedTotal == $reqTotal)  {$boStatus = 2} # FAILED
    if ( $failedTotal ==0 && $checkedTotal == $reqTotal) { $boStatus = 3 } # PASSED
    if ( $checkedTotal==0)  {$boStatus = 0} # Not started
    return ($boStatus);

    }
sub _getInsptectionStatus (){
    my ($self, $hash) = @_;
    my %TEAMS = %$hash;
    my $str;
    foreach $teamIDX (sort {$a<=>$b} keys %TEAMS) {
        my $classIDX = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        $TEAMS{$teamIDX}{BO_INSPECTED} = &getInsptectionStatus($teamIDX, $classIDX);
    }
    return (\%TEAMS);
    }
sub _getItemDetails (){
    my ($self, $teamIDX, $itemIDX) = @_;
    my $SQL = "SELECT TECH.*, SEC.TX_SECTION AS TX_TITLE, SEC.IN_SECTION AS IN_HEAD, REQ.* FROM TB_TECH_REQ AS REQ 
        JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX  
        JOIN TB_TECH AS TECH ON REQ.PK_TECH_REQ_IDX = TECH.FK_TECH_REQ_IDX
        WHERE TECH.FK_TEAM_IDX=? AND TECH.FK_TECH_REQ_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX, $itemIDX );
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);
    }
sub _getTeamList (){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX );
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    return (\%HASH);
    }
sub _getTeamTechList (){
    # my ($self, $teamIDX) = @_;
    # my $SQL = "SELECT * FROM TB_TECH WHERE FK_TEAM_IDX=?";
    # my $select = $dbi->prepare($SQL);
    #    $select->execute( $teamIDX );
    # my %HASH = %{$select->fetchall_hashref('FK_TECH_REQ_IDX')};
    # return (\%HASH);
    my ($self, $planeIDX) = @_;
    my $SQL = "SELECT * FROM TB_TECH WHERE FK_TECH_PLANE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $planeIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getStudentTechList (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TECH_STUDENT WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX );
    my %HASH = %{$select->fetchall_hashref('FK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getRequiredTechList (){
    my ($self, $classIDX) = @_;
    my %FIELD = (1=>'R.BO_REGULAR', 2=>'R.BO_ADVANCE', 3=>'R.BO_MICRO',4=>'R.BO_PADA');
    my $field = $FIELD{$classIDX};
    my $SQL = qq(SELECT CONCAT(S.IN_SECTION,".",R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
                FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
                WHERE ($field=? AND S.BO_CHECK=?));
    # if ($classIDX == 3){
    #         # $SQL = "SELECT R.* FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX WHERE (R.BO_MICRO=? AND S.BO_CHECK=?)";
    #         $SQL = qq(SELECT CONCAT(S.IN_SECTION,".",R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
    #             FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
    #             WHERE (R.BO_MICRO=? AND S.BO_CHECK=?));
    #     } elsif ($classIDX == 2) {
    #         # $SQL = "SELECT R.* FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX WHERE (R.BO_ADVANCE=? AND S.BO_CHECK=?)";
    #         $SQL = qq(SELECT CONCAT(S.IN_SECTION,".",R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
    #             FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
    #             WHERE (R.BO_ADVANCE=? AND S.BO_CHECK=?));
    #     } else {
    #         # $SQL = "SELECT R.* FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX WHERE (R.BO_REGULAR=? AND S.BO_CHECK=?)";
    #         $SQL = qq(SELECT CONCAT(S.IN_SECTION,".",R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
    #             FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
    #             WHERE (R.BO_REGULAR=? AND S.BO_CHECK=?));
    #         # $SQL = "SELECT S.IN_SECTION AS SECTION, R.IN_SECTION AS SUBSECTION, R.PK_TECH_REQ_IDX, R.FK_CLASS_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_POINTS 
    #         #     FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
    #         #     WHERE (R.BO_REGULAR=? AND S.BO_CHECK=?)";

    #     }
    # print "<br><br>$SQL";
    my $select = $dbi->prepare($SQL);
       $select->execute(1,1) || die "Did not work $0";
    my %HASH = %{$select->fetchall_hashref('PK_TECH_REQ_IDX')};
    # print join(", ", keys %HASH);
    return (\%HASH);
    }
sub _getSafetyList (){
    my ($self, $classIDX, $txType) = @_;
    my $str;
    my %FIELD = (1=>'BO_REGULAR', 2=>'BO_ADVANCE', 3=>'BO_MICRO',4=>'BO_PADA');
    my $field = $FIELD{$classIDX};
    my $SQL = qq(SELECT CONCAT(S.IN_SECTION,".", R.IN_SECTION) AS IN_SECTION, R.PK_TECH_REQ_IDX, R.TX_REQUIREMENT, R.TX_SECTION, R.IN_SECTION AS IN_ORDER
            FROM TB_TECH_REQ AS R JOIN TB_TECH_REQ_SECTION AS S ON R.FK_TECH_REQ_SECTION_IDX=S.PK_TECH_REQ_SECTION_IDX 
            WHERE (S.TX_TYPE=? AND $field=?));
    my $select = $dbi->prepare($SQL);
       $select->execute( $txType, 1 );
       # print $SQL;
    my %HASH = %{$select->fetchall_hashref('PK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getReqList (){
    my ($self, $classIDX) = @_;
    # my $SQL = "SELECT SEC.TX_SECTION AS TX_TITLE, SEC.IN_SECTION AS IN_HEAD, REQ.* FROM TB_TECH_REQ AS REQ 
    #     JOIN TB_TECH_REQ_SECTION AS SEC ON REQ.FK_TECH_REQ_SECTION_IDX=SEC.PK_TECH_REQ_SECTION_IDX  
    #     WHERE SEC.TX_TYPE=?";
    my %FIELD = (1=>'BO_REGULAR', 2=>'BO_ADVANCE', 3=>'BO_MICRO',4=>'BO_PADA');
    my $field = $FIELD{$classIDX};
    my $SQL = "SELECT * FROM TB_TECH_REQ WHERE $field=?";;
    # if ($classIDX == 3){
    #         $SQL = "SELECT * FROM TB_TECH_REQ WHERE BO_MICRO=?";
    #     } elsif ($classIDX == 2) {
    #         $SQL = "SELECT * FROM TB_TECH_REQ WHERE BO_ADVANCE=?";
    #     } else {
    #         $SQL = "SELECT * FROM TB_TECH_REQ WHERE BO_REGULAR=?";
    #     }
    # print $SQL;
    my $select = $dbi->prepare($SQL);
       $select->execute( 1 );
    my %HASH = %{$select->fetchall_hashref(['FK_TECH_REQ_SECTION_IDX','PK_TECH_REQ_IDX'])};
    return (\%HASH);
    }
sub _getSectionHeading (){
    my ($self, $txType, $classIDX) = @_;
    my %FIELD = (1=>'BO_REGULAR', 2=>'BO_ADVANCE', 3=>'BO_MICRO',4=>'BO_PADA');
    my $field = $FIELD{$classIDX};
    # my $SQL = "SELECT * FROM TB_TECH_REQ_SECTION WHERE TX_TYPE=?";
    my $SQL;
    if ($classIDX==2){
            $SQL = "SELECT S.* FROM TB_TECH_REQ_SECTION AS S JOIN TB_TECH_REQ AS R ON S.PK_TECH_REQ_SECTION_IDX=R.FK_TECH_REQ_SECTION_IDX WHERE (TX_TYPE=? AND (BO_ADVANCE=1 or BO_PADA=1))";
        } else {
            $SQL = "SELECT S.* FROM TB_TECH_REQ_SECTION AS S JOIN TB_TECH_REQ AS R ON S.PK_TECH_REQ_SECTION_IDX=R.FK_TECH_REQ_SECTION_IDX WHERE (TX_TYPE=? AND $field=1)";
        }
    my $select = $dbi->prepare($SQL);
       $select->execute( $txType);
    my %HASH = %{$select->fetchall_hashref('PK_TECH_REQ_SECTION_IDX')};
    # print $SQL;
    # print $classIDX;
    return (\%HASH);
    }
sub _submitTechInspectionStatus (){
    my ($self, $teamIDX, $itemIDX, $inStatus, $eventIDX, $userIDX, $planeIDX) = @_;
    # my $eventIDX=31;
    my $str;
    my $SQL = "SELECT * FROM TB_TECH WHERE (FK_TECH_PLANE_IDX=? AND FK_TECH_REQ_IDX=?)";
    # my $SQL = "SELECT * FROM TB_TECH WHERE (FK_TEAM_IDX=? AND FK_TECH_REQ_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $planeIDX, $itemIDX );
       $rows = $select->rows;
    if ($rows ==0 ){
        $SQL = "INSERT INTO TB_TECH (FK_TEAM_IDX, FK_TECH_REQ_IDX, FK_EVENT_IDX, IN_STATUS, FK_USER_IDX, FK_TECH_PLANE_IDX) VALUES (?, ?, ?, ?, ?, ?)";
        my $insert = $dbi->prepare($SQL);
           $insert->execute($teamIDX, $itemIDX, $eventIDX, $inStatus, $userIDX, $planeIDX);
    } else {
        $SQL = "UPDATE TB_TECH SET IN_STATUS=?, FK_USER_IDX=? WHERE (FK_TEAM_IDX=? AND FK_TECH_REQ_IDX=?)";
        my $update = $dbi->prepare($SQL);
           $update->execute($inStatus, $userIDX, $teamIDX, $itemIDX);
    }
    return ($str);
    }

sub _getTechItemDetails (){
    my ($self, $itemIDX) = @_;
    my $SQL = "SELECT * FROM TB_TECH_REQ WHERE PK_TECH_REQ_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $itemIDX );
    my %HASH = %{$select->fetchrow_hashref()};
    return (\%HASH);

    }
sub _getTechSectionCheckItems (){
    my ($self, $sectionIDX) = @_;
    my $SQL = "SELECT * FROM TB_TECH_REQ WHERE FK_TECH_REQ_SECTION_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $sectionIDX );
    my %HASH = %{$select->fetchall_hashref('PK_TECH_REQ_IDX')};
    return (\%HASH);
    }
sub _getTechSection (){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_TECH_REQ_SECTION";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %TECH = %{$select->fetchall_hashref(['TX_TYPE','PK_TECH_REQ_SECTION_IDX'])}; 
    return (\%TECH);
    }
sub _getMyReinspection (){
    my ($self, $teamIDX) = @_;
    # my $str = &getMyReinspection($teamIDX);
    # print $teamIDX."\n\n";
    return (&getMyReinspection($teamIDX));
    }
sub getInspectionItemDetails (){
    my ($inspectIDX) = @_;
    my $SQL = "SELECT FLIGHT.CL_NOTES AS ATTEMPT_NOTES, TEAM.TX_SCHOOL, TEAM.TX_NAME, TEAM.TX_COUNTRY, TEAM.FK_CLASS_IDX, INSPECT.* FROM TB_REINSPECT AS INSPECT 
            JOIN TB_TEAM AS TEAM ON INSPECT.FK_TEAM_IDX = TEAM.PK_TEAM_IDX 
            JOIN TB_FLIGHT AS FLIGHT ON INSPECT.FK_FLIGHT_IDX = FLIGHT.PK_FLIGHT_IDX 
        WHERE (INSPECT.PK_REINSPECT_IDX=?)";
    my $select = $dbi->prepare($SQL);
        $select->execute( $inspectIDX );
    my %HASH = %{$select->fetchrow_hashref()}; 
    return (\%HASH);
    }
sub _getInspectionItemDetails (){
    my ($self, $inspectIDX) = @_;
    my %HASH = %{&getInspectionItemDetails($inspectIDX)}; 
    return (\%HASH);
    }
sub _getTechButton(){
    my ($self, $inspectIDX) = @_;
    my %TECH = %{&getInspectionItemDetails($inspectIDX)}; 
    my $cleared = $TECH{BO_STATUS};
    my $str;
    if ($cleared == 0){ # 1=Not cleared; 0=Cleared
            $str = sprintf '<li ID="REINSPECT_%d" class="w3-bar w3-margin-top w3-card w3-round w3-border w3-hide w3-green inspectionItem inspectionItemCleared" onclick="reviewClearedInspectionDetails(this, %d);">', $inspectIDX, $inspectIDX;
        } else {
            $str = sprintf '<li ID="REINSPECT_%d" class="w3-bar w3-white w3-margin-top w3-card w3-round w3-border inspectionItem" onclick="reviewInspectionDetails(this, %d);">', $inspectIDX, $inspectIDX;
        }
    $str .= '<div class="w3-bar-item">';
    $str .= sprintf '<span class="w3-large">%03d - <b>%s</b></span><br>', $TECH{IN_NUMBER}, $TECH{TX_SCHOOL};
    $str .= sprintf '<i>Reinspection requested after Attempt <span class="w3-yellow w3-border w3-padding-left w3-padding-right">';
    $str .= sprintf '&nbsp;&nbsp;#%s&nbsp;&nbsp;</span></i>', $TECH{IN_ROUND};
    $str .= '</div>';
    $str .= '</li>';

    return ($str);
    }
sub _getListToBeReinspected (){
    my ($self, $eventIDX) = @_;
    # my $SQL = "SELECT TEAM.TX_SCHOOL, 
    #     TEAM.TX_NAME, TEAM.TX_COUNTRY, TEAM.FK_CLASS_IDX, INSPECT.* FROM TB_REINSPECT AS INSPECT 
    #     JOIN TB_TEAM AS TEAM ON INSPECT.FK_TEAM_IDX = TEAM.PK_TEAM_IDX WHERE (INSPECT.FK_EVENT_IDX=?)";
    my $SQL = "SELECT * FROM TB_REINSPECT WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
            $select->execute( $eventIDX );
        my %HASH = %{$select->fetchall_hashref('PK_REINSPECT_IDX')}; 
        return (\%HASH);
    }
sub getMyReinspection (){
    my ($teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_REINSPECT WHERE (FK_TEAM_IDX=? AND BO_STATUS=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX , 1);
    my %TECH = %{$select->fetchall_hashref('PK_REINSPECT_IDX')}; 
    my $str;
    if (keys %TECH){   
        foreach $inspectIDX (keys %TECH) {
            $str .= sprintf '<div ID="TeamReInspection_%d" class="w3-container w3-red w3-padding-16 w3-border w3-card-2 w3-round" style="cursor: pointer" onclick="viewTeamReinspection(this, %d);">', $teamIDX, $inspectIDX;
            $str .= '<div class="w3-left">';
            $str .= sprintf '<i class="fa fa-minus-circle w3-xxlarge"></i>';
            $str .= '</div>';
            $str .= sprintf '<div class="w3-right"><i class="fa fa-chevron-right fa-3x w3-margin-left" aria-hidden="true"></i></div>';
            $str .= '<div class="w3-clear"></div>';
            $str .= sprintf '<h4>Re-Inspection Required after flight attempt # %02d</h4>', $TECH{$inspectIDX}{IN_ROUND};
            $str .= '</div>';
            }
        }
    return ($str);
    }
sub _addPlane (){
    my ($self, $teamIDX, $inSequence) = @_;
    my $str;
    my $SQL = "INSERT INTO TB_TECH_PLANE (FK_TEAM_IDX, IN_SEQUENCE) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
        $insert->execute($teamIDX, $inSequence);
    my $newIDX = $insert->{q{mysql_insertid}} ;
    return ($newIDX);
    }
sub _addPada (){
    my ($self, $teamIDX, $inSequence) = @_;
    my $str;
    my $SQL = "INSERT INTO TB_TECH_PLANE (FK_TEAM_IDX, IN_SEQUENCE, BO_PADA) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
        $insert->execute($teamIDX, $inSequence, 1);
    my $newIDX = $insert->{q{mysql_insertid}} ;
    return ($newIDX);
    }
sub _getPlaneCount (){
    my ($self, $teamIDX, $Pada) = @_;
    my $SQL = "SELECT MAX(IN_SEQUENCE) AS IN_COUNT FROM TB_TECH_PLANE WHERE FK_TEAM_IDX=? AND BO_PADA=?";
    my $select = $dbi->prepare($SQL);

       $select->execute($teamIDX, $Pada);
    my ($inCount) = $select->fetchrow_array();
    # if ($inCount){
    #     return($inCount);
    # } else {
    #     return (0);
    # }
    return ($inCount);
    }
sub _getTechPlanes (){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TECH_PLANE WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TECH_PLANE_IDX')}; 
    return (\%HASH);
    }
# -------------- 2023 --------------


# sub new{
# 	$className = shift;
# 	my $self = {};
#     my $location = shift;
#     # my $SQL = "SELECT TD.*, T.*, F.IN_ROUND FROM TB_TODO AS TD JOIN TB_TEAM as T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX JOIN TB_FLIGHT AS F ON TD.FK_FLIGHT_IDX=F.PK_FLIGHT_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=?)";
#     my $SQL = "SELECT TD.*, T.IN_NUMBER FROM TB_TODO AS TD JOIN TB_TEAM AS T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=?)";
#     my $select = $dbi->prepare($SQL);
#        $select->execute($location, 4);
#     %TECH = %{$select->fetchall_hashref('PK_TODO_IDX')};   
    
# 	bless($self, $className);
# 	return $self;
# }


sub _checkIfReInspectIsNeeded(){
    my ($self, $eventIDX, $teamIDX) = @_;
    my $SQL = "SELECT TD.*, T.IN_NUMBER FROM TB_TODO AS TD JOIN TB_TEAM AS T ON TD.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE (T.FK_EVENT_IDX=? AND TD.FK_TODO_TYPE_IDX=? AND FK_TEAM_IDX=? AND IN_CLEAR=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX, 4, $teamIDX, 0);
    my %TECH = %{$select->fetchall_hashref('PK_TODO_IDX')};   
    if (scalar(keys %TECH)>0){
        return 1;
    } else {
        return 0;
    }
}
sub _getTechListData(){
    my $self = shift;
    return (\%TECH);
}
sub genTechButton(){
    my ($todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    my %ARCHIVE = (0=>'',       1=>'sae-archive w3-light-grey w3-hide');
    my %CHECKED = (0=>'',       1=>'checked');
    my %COLOR   = (0=>'w3-red', 1=>'w3-green');
    my %STATUS = (1=>'w3-green', 2=>'w3-yellow', 3=>'w3-red', ''=>'w3-green', 0=>'w3-green');
    my $height  = 45;
    my $Team    = new SAE::TEAM($teamIDX);
    my $Flight    = new SAE::FLIGHT($flightIDX);
    my %TEAM    = %{$Team->_getTeamData()};
    my %FLIGHT    = %{$Flight->_getFlightData()};
    my $techBtn = sprintf '<li ID="TODO_IDX_%d"  class="%s w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-white w3-display-container w3-hover-yellow sae_inspectionItems" onclick="sae_openReinspectionDetails(%d, %d, %d, \'%s\');">', $flightIDX, $ARCHIVE{$boArchive}, $todoIDX, $teamIDX, $flightIDX, $COLOR{$boArchive};
    $techBtn .= '<i class="fa fa-chevron-right fa-2x w3-display-right  w3-margin-right" aria-hidden="true"></i>';
    $techBtn .= sprintf '<span class="w3-bar-item w3-circle w3-border %s w3-display-left w3-margin-left w3-center" style="height: %dpx; width: %dpx;">', $COLOR{$boArchive}, $height, $height;
    $techBtn .= sprintf '<div style="margin-left: -7px; margin-top: 4px;">%03d</div>', $TEAM{IN_NUMBER};
    $techBtn .= '</span>';
    $techBtn .= '<div class="w3-bar-item w3-small" style="margin-left: 35px; text-align: left; padding-right: 100px;">';
    $techBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_SCHOOL};
    $techBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_COUNTRY};
    $techBtn .= sprintf '<span>Crashed Attempt #%d: - Reinspection Required</span><br>', $FLIGHT{IN_ROUND};
    $techBtn .= '</li>';
    return ($techBtn);
}
sub _generateTechButton(){
    my ($self, $todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    my $str = &genTechButton($todoIDX, $flightIDX, $teamIDX, $boArchive);
    return ($str);

    # my %DATA;
    # $DATA{techBtn} = $techBtn;
    # $DATA{logBtn} = $logBtn;
    # my $json = encode_json \%DATA;
    # return ($techBtn);
    # return($str);
}
sub _generateLogButton(){
    my ($self, $todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    my $str = genLogButton($todoIDX, $flightIDX, $teamIDX, $boArchive);
    return ($str);
}

sub genLogButton(){
    my ($todoIDX, $flightIDX, $teamIDX, $boArchive) = @_;
    # my %STATUS = (1=>'w3-green', 2=>'w3-yellow', 3=>'w3-red', ''=>'w3-green', 0=>'w3-green');
    my $height  = 45;
    my $Team    = new SAE::TEAM($teamIDX);
    my $Flight    = new SAE::FLIGHT($flightIDX);
    my %TEAM    = %{$Team->_getTeamData()};
    my %FLIGHT    = %{$Flight->_getFlightData()};
    my $logBtn = sprintf '<li ID="TEAM_%d" class="w3-bar w3-button w3-card-2 w3-margin-bottom w3-border w3-round w3-display-container w3-white" onclick="sae_openClearCrash(this, %d, \'%03d\', %d, %d);" >', $teamIDX, $teamIDX, $TEAM{IN_NUMBER}, $TEAM{FK_CLASS_IDX}, $flightIDX;
    $logBtn .= '<i class="fa fa-chevron-right fa-2x w3-display-right w3-text-grey w3-margin-right" aria-hidden="true"></i>';                                                                         
    $logBtn .= sprintf '<span class="w3-bar-item w3-circle w3-border w3-display-left w3-margin-left w3-center w3-red" style="height: %dpx; width: %dpx;">', $height, $height;
    $logBtn .= sprintf '<div style="margin-left: -7px; margin-top: 4px;">%03d</div>', $TEAM{IN_NUMBER};
    $logBtn .= '</span>';
    $logBtn .= '<div class="w3-bar-item w3-small" style="margin-left: 35px; text-align: left; padding-right: 100px;">';
    $logBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_SCHOOL};
    $logBtn .= sprintf '<span>%s</span><br>', $TEAM{TX_COUNTRY};
    $logBtn .= sprintf '<span>Crashed Rnd %d: - Reinspection Required</span><br>', $FLIGHT{IN_ROUND};
    $logBtn .= '</div>';
    $logBtn .= '</li>';
    return ($logBtn);
}
return (1);