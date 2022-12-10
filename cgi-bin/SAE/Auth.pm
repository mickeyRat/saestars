package SAE::Auth;

use DBI;
use SAE::SDB;
use CGI::Session;
use CGI::Cookie;
use Mail::Sendmail;

my $dbi = new SAE::Db();
%TEST = $dbi;

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
sub _setProfile(){
    my ($self, $txFirst, $txLast, $txEmail, $userIDX) = @_;
    my $SQL = "UPDATE TB_USER SET TX_FIRST_NAME=?, TX_LAST_NAME=?, TX_EMAIL=?, TX_LOGIN=? WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($txFirst, $txLast, $txEmail, $txEmail, $userIDX) || die "Error $_<br>";
    return;
}
sub _updateAccessTime(){
    my ($self, $userIDX) = @_;
    my $SQL = "UPDATE TB_USER SET TS_ACCESS=CURRENT_TIME() WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($userIDX) || die "Error $_<br>";
    return;
}
sub _login(){
    my ($self, $txEmail, $userPassword) = @_;
    my $sid = '';
    my $SQL = "SELECT PK_USER_IDX, TX_PASSWORD, BO_RESET, TX_FIRST_NAME, TX_LAST_NAME FROM TB_USER WHERE TX_EMAIL=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($txEmail);
    my ($pkUserIdx, $storedPassword, $boReset, $txFirst, $txLast) = $select->fetchrow_array();
    # print "$pkUserIdx, $storedPassword, $boReset, $txFirst, $txLast\n\n";
    my $salt = substr($storedPassword,0,2);
    my $saltedPassword = $salt.crypt($userPassword, $salt);
    # print "$userPassword \t $storedPassword \t $storedPassword\n";
    if ($pkUserIdx && ($storedPassword eq $saltedPassword) ) {
        $session = CGI::Session->new();
        $sid = $session->id();
        
        $CGISESSID = $session->id();
        return (1, $pkUserIdx, $sid, $boReset, $txFirst, $txLast);
    } else {
        return (0, 0, 0, 0);
    }
}
sub _getMenuItem(){
    my $self = shift;
    my $userIDX = shift;
    my %EXCLUDE = (20=>1, 28=>1, 19=>1);
    my $str;
    my $SQL = "SELECT TILES.PK_TILES_IDX, TILES.TX_TITLE, TILES.TX_ICON, TILES.IN_ORDER FROM TB_ACCESS AS ACCESS JOIN TB_TILES AS TILES ON ACCESS.FK_TILES_IDX=TILES.PK_TILES_IDX WHERE ACCESS.FK_USER_IDX=?";
    my $select=$dbi->prepare($SQL);
    $select->execute($userIDX);
    %TILES = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
    $str .= '<a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>&nbsp; Close Menu</a>';
    $str .= '<a ID="MENUITEM_0" href="javascript:void(0);" class="sae-menu_item w3-bar-item w3-button w3-padding w3-blue " onclick="w3_close();sae_loadHomePage(0, this);"><i class="fa fa-users fa-fw"></i>&nbsp; My Page</a>';
    foreach $tileIDX (sort {$TILES{$a}{IN_ORDER} <=> $TILES{$b}{IN_ORDER}} keys %TILES) {
        my $hide = '';
        if (exists $EXCLUDE{$tileIDX}){$hide=' w3-hide-small '}
        # $str .= '<a ID="MENUITEM_'.$pkTilesIdx.'" href="javascript:void(0);" class="sae-menu_item w3-bar-item w3-button w3-padding " onclick="mainMenuItemClick('.$pkTilesIdx.', this);w3_close();"><i class="fa '.$TILES{$pkTilesIdx}{TX_ICON}.'"></i>&nbsp; '.$TILES{$pkTilesIdx}{TX_TITLE}.'</a>'."\n";
        $str .= sprintf '<a ID="MENUITEM_%d" href="javascript:void(0);" class="sae-menu_item w3-bar-item w3-button w3-padding %s" onclick="mainMenuItemClick(%d, this);w3_close();"><i class="fa %s"></i>&nbsp; %s</a>', $tileIDX, $hide, $tileIDX, $TILES{$tileIDX}{TX_ICON}, $TILES{$tileIDX}{TX_TITLE};
    }
    $str .= '<br><a href="javascript:void(0);" style="margin-bottom: 60px;" class="w3-bar-item w3-button w3-padding" onclick="signOutAdmin();"><i class="fa fa-sign-out fa-fw" ></i>Logout</a><br><br>';
    return ($str);
}
sub _register(){
    my ($self) = shift;
    my $txEmail = shift;
    my $txPassword = shift;
    my $txFirst = shift;
    my $txLast = shift;
    my @chars = ("A".."Z", 0..9, "a".."z");
    my $salt;
    $salt .= $chars[rand @chars] for 1..2;
    $userPassword = $salt.crypt($txPassword, $salt);
    my $SQL = "INSERT INTO TB_USER (TX_FIRST_NAME, TX_LAST_NAME, TX_PASSWORD, TX_LOGIN, TX_EMAIL) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($txFirst, $txLast, $userPassword, $txEmail,$txEmail);
    my $userIDX = $insert->{q{mysql_insertid}};
    return ("$userIDX,\t$txPassword,\t$userPassword\n");
}

sub _welcome(){
    my ($self) = shift;
    my $txEmail = shift;
    my $txPassword = shift;
    my $txFirst = shift;
    my $txLast = shift;
    my $str = "Hi $txFirst,<br><br>";
    $str .= "<p>Welcome to STARS [Score Tracking and Recording System], and thank you for registering for the SAE Aero-Design Competition.</p>";
    $str .= "<p>You are now registered to receive real-time online scoring information and team feedback for this year's SAE Aero-Design Competition!</br>";
    $str .= "The SAE Rules Committee is working around the clock to continue to improve the Aero-Design Experience.</p>";

    $str .= "<p>This new real-time scoring web application will help you focus on a winning strategy for your team while keeping a close eye on your team’s progress and standings.  Set and track your event scores by obtaining your personalized team code from the SAE Competition Scoring Judge.</p>";

    $str .= "<ol>NEXT STEP<br>";
    $str .= "<li><b>Obtain Team Code from the SAE Competition Scoring Judge</b></li>";
    $str .= "<li>Login to your account";
    $str .= "<ul><li>Email: [$email]</li>";
    $str .= "<li>Password: [".substr($txPassword,0,2)."**************]</li>";
    $str .= "</ul></li>";
    $str .= "<li>Click on Add a Team</li>";
    $str .= "<li>Enter Team Code provided by your SAE Competition Scoring Judge</li></ol>";

    $str .= "Best,<br><br>";
    $str .= "Aero Design Competition Committee";

    my %mail = (   To      => $txEmail,
                    From    => 'aerogeek@saestars.com',
                    'Content-Type' => 'text/html; charset=UTF-8',
                    Subject => 'New User ['.$txFirst.' '.$txLast.'] - Registration',
                    Message => $str
                );
    sendmail(%mail) or die $Mail::Sendmail::error;
}

sub getTemporaryPassword(){
    my ($self) = shift;
    my ($length) = shift;
    if (!$length){$length = 10}
    my @chars = ("A".."Z", 2..9, "a".."z");
    my $str;
    $str .= $chars[rand @chars] for 1..$length;
    return ($str);
}
sub checkLogin(){
    my ($self) = shift;
    my ($txEmail) = shift;
    my ($userPassword) = shift;
    my $SQL = "SELECT PK_USER_IDX, TX_PASSWORD FROM TB_USER WHERE TX_EMAIL=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($txEmail);
    my ($pkUserIdx, $storedPassword) = $select->fetchrow_array();
    my $salt = substr($storedPassword,0,2);
    my $saltedPassword = $salt.crypt($userPassword, $salt);
    if ($storedPassword eq $saltedPassword) {
        return ($pkUserIdx);
    } else {
        return (0);
    }
}
sub _findTeamCodeMatch(){
    my ($self) = shift;
    my $location = shift;
    my $eCode = shift;
    my $str;
    $str = 0;
    my $SQL = "SELECT PK_TEAM_IDX, TX_CODE FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    %CODE= %{$select->fetchall_hashref(['TX_CODE'])};
    foreach $code (sort keys %CODE){
        if ($eCode eq $code) {
            $str = $CODE{$code}{PK_TEAM_IDX};
        }
    }
    return ( $str );
}

sub decryptTeamIDX(){
    my ($self) = shift;
    my $location = shift;
    my $eIDX = shift;
    my $SQL = "SELECT PK_TEAM_IDX, IN_NUMBER, FK_CLASS_IDX, TX_SCHOOL FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($location);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    @RTN = ();
    foreach $teamIDX (sort keys %TEAM){
        my $temp = crypt($teamIDX, '19');
        if ($temp eq $eIDX) {
            push (@RTN, $teamIDX);
            push (@RTN, $TEAM{$teamIDX}{IN_NUMBER});
            push (@RTN, $TEAM{$teamIDX}{FK_CLASS_IDX});
            push (@RTN, $TEAM{$teamIDX}{TX_SCHOOL});
        }
    }
    return ( \@RTN );
}

# =====================================================================================================
#  UPDATE RECORDS
# =====================================================================================================
sub _updatePassword(){
    my $self = shift;
    my $password = shift;
    my $reset = shift;
    my $userIDX = shift;
    my $SQL = "UPDATE TB_USER SET TX_PASSWORD=?, BO_RESET=? WHERE PK_USER_IDX=?";
    my $update = $dbi -> prepare( $SQL );
       $update -> execute($password, $reset, $userIDX);
       
    return;
}
sub _updateUserGroup(){
    my $self = shift;
    my $groupIDX = shift;
    my $userIDX = shift;
    my $SQL = "UPDATE TB_USER SET FK_GROUP_IDX=? WHERE PK_USER_IDX=?";
    my $update = $dbi -> prepare( $SQL );
       $update -> execute($groupIDX, $userIDX);
}
sub _updateTeamDetails(){
    my $self = shift;
    my $classIDX = shift;
    my $countryIDX = shift;
    my $txCountry = shift;
    my $inNumber = shift;
    my $txName = shift;
    my $txSchool = shift;
    my $location = shift;
    my $txCode = shift;
    my $inSlope = shift;
    my $inInt = shift;
    my $inLcargo = shift;
    my $inPipes = shift;
    my $inWpipes = shift;
    my $teamCode = shift;
    my $teamIDX = shift;
    my $SQL = "UPDATE TB_TEAM SET 
          FK_CLASS_IDX = ?
        , FK_COUNTRY_IDX = ?
        , TX_COUNTRY = ?
        , IN_NUMBER = ?
        , TX_NAME = ?
        , TX_SCHOOL = ?
        , FK_EVENT_IDX = ?
        , TX_CODE = ?
        , IN_SLOPE = ?
        , IN_YINT = ?
        , IN_LCARGO = ?
        , IN_PIPES = ?
        , IN_WPIPES = ?
        , TX_CODE = ?
        WHERE PK_TEAM_IDX=?";
    my $update = $dbi -> prepare( $SQL );
       $update -> execute($classIDX, $countryIDX, $txCountry, $inNumber, $txName, $txSchool, $location, $txCode, $inSlope, $inInt, $inLcargo, $inPipes, $inWpipes, $teamCode, $teamIDX);    
}
# =====================================================================================================
#  ADD RECORDS
# =====================================================================================================
sub _audit(){
    my $self = shift;
    my $userIDX = shift;
    my $eventIDX = shift;
    my $cookie = 'N/A';
    if ($ENV{HTTP_COOKIE}) {$cookie = $ENV{HTTP_COOKIE}}
    my $SQL = "INSERT INTO TB_AUDIT (FK_USER_IDX, TX_REMOTE_ADDR, CL_COOKIE, FK_EVENT_IDX, CL_USER_AGENT) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($userIDX, $ENV{REMOTE_ADDR}, $cookie, $eventIDX, $ENV{HTTP_USER_AGENT});
    return;
}
sub _addGroupAccess(){
    my $self = shift;
    my $tilesIDX = shift;
    my $groupIDX = shift;
    my $SQL = "INSERT INTO TB_GROUP_ACCESS (FK_TILES_IDX, FK_GROUP_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($tilesIDX, $groupIDX);
    return;
}
sub _addUserAccess(){
    my $self = shift;
    my $tilesIDX = shift;
    my $groupIDX = shift;
    my $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($tilesIDX, $groupIDX);
    return;
}
sub _addTeamToUser(){
    my $self = shift;
    my $userIDX = shift;
    my $teamIDX = shift;
    my $SQL = "INSERT INTO TB_USER_TEAM (FK_USER_IDX, FK_TEAM_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($userIDX, $teamIDX);
    my $idx = $insert->{q{mysql_insertid}};
    return ($idx);
}
sub _createNewTeam(){
    my $self = shift;
    my $classIDX = shift;
    my $countryIDX = shift;
    my $txCountry = shift;
    my $inNumber = shift;
    my $txName = shift;
    my $txSchool = shift;
    my $location = shift;
    my $txCode = shift;
    my $SQL = "INSERT INTO TB_TEAM (FK_CLASS_IDX, FK_COUNTRY_IDX, TX_COUNTRY, IN_NUMBER, TX_NAME, TX_SCHOOL, FK_EVENT_IDX, TX_CODE) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($classIDX, $countryIDX, $txCountry, $inNumber, $txName, $txSchool, $location, $txCode );
    my $idx = $insert->{q{mysql_insertid}};
    return ($idx);
}
sub _addCountry(){
    my $self = shift;
    my $txCountry = shift;
    my $SQL = "INSERT INTO TB_COUNTRY (TX_COUNTRY) VALUES (?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($txCountry);
    my $idx = $insert->{q{mysql_insertid}};
    return ($idx);
}
# sub _createNewStudentAccess(){
#     my $self = shift;
#     my $teamIDX = shift;
#     my $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) SELECT PK_TILES_IDX, $teamIDX FROM TB_TILES WHERE BO_NEW=?";
#     my $insert = $dbi->prepare($SQL);
#        $insert->execute(1);
#     return;
# }
# =====================================================================================================
#  DELETE RECORDS
# =====================================================================================================
sub _deleteGroupAccess(){
    my $self = shift;
    my $tilesIDX = shift;
    my $groupIDX = shift;
    my $SQL = "DELETE FROM TB_GROUP_ACCESS WHERE (FK_TILES_IDX=? AND FK_GROUP_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($tilesIDX, $groupIDX);
    return;
}
sub _deleteUserAccess(){
    my $self = shift;
    my $tilesIDX = shift;
    my $groupIDX = shift;
    my $SQL = "DELETE FROM TB_ACCESS WHERE (FK_TILES_IDX=? AND FK_USER_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($tilesIDX, $groupIDX);
    return;
}
sub _deleteUserTeam(){
    my $self = shift;
    my $userTeamIDX = shift;
    my $SQL = "DELETE FROM TB_USER_TEAM WHERE PK_USER_TEAM_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($userTeamIDX);
    return;
}
return(1);