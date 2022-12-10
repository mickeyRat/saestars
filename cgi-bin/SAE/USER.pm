package SAE::USER;

use DBI;
use SAE::SDB;
use SAE::JSONDB;
use SAE::SECURE;
use CGI::Session;
use CGI::Cookie;
# use URI::Escape;
# use SAE::TB_TEAM;
# use SAE::TB_COUNTRY;
# use DateTime;

my $dbi = new SAE::Db();
my %USER;


sub new{
	my $className = shift;
	my $self = {};
	my $idx = shift;
	if ($idx) {
        my $SQL = "SELECT * FROM TB_USER WHERE PK_USER_IDX=?";
        my $select = $dbi->prepare($SQL);
           $select->execute($idx);
        %USER = %{$select->fetchrow_hashref()};
	}
	bless($self, $className);
	return $self;
}
sub _register(){ 
    # developed in 2022 to take advantage of JSON data structure 
    my ($self, $jsonData) = @_;
    my $DB = new SAE::JSONDB();
    my %DATA = %$jsonData;
    my $txPassword = $DATA{TX_PASSWORD};
    my $Secure = new SAE::SECURE();
    my $securePassword = $Secure->_getSaltedPassword($txPassword);
       $DATA{TX_PASSWORD} = $securePassword;
    my $newIDX = $DB->_insert('TB_USER',\%DATA);
    return $newIDX;
}
sub _updateAccessTime(){
    my ($self, $userIDX) = @_;
    my $SQL = "UPDATE TB_USER SET TS_ACCESS=CURRENT_TIME() WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
    $update->execute($userIDX) || die "Error $_<br>";
    return;
}
sub _login(){
    my ($self, $login, $txPassword) = @_;
    my $Secure = new SAE::SECURE();
    my %DATA = %{&getLoginData($login)};
    my $saltedPassword;
    if ($DATA{PK_USER_IDX}) {
        my $firstFour = substr($DATA{TX_PASSWORD},0,4);
        my $salt = substr($firstFour,0,2); # getting the first 2 characters of a string
        my $last = substr($firstFour,-2);  # getting the last 2 characters of a string
        # print $salt;

        if ($salt eq $last) {
            $saltedPassword = $salt.crypt($txPassword, $salt);
            # $DATA{SALT} = qq(OLD salt=$salt\nlast = $last\n \$txPassword=$txPassword\n $saltedPassword == $DATA{TX_PASSWORD});
        } else {
            $saltedPassword = crypt($txPassword, $salt);
            # $DATA{SALT} = qq(NEW salt=$salt\nlast = $last\n \$txPassword=$txPassword\n $saltedPassword == $DATA{TX_PASSWORD});
        }
        if ($saltedPassword eq $DATA{TX_PASSWORD}){
            $DATA{STATUS} = 1;
            $session = CGI::Session->new();
            $sid = $session->id();
            $CGISESSID = $session->id();
            $DATA{SESSION_ID} = $sid;
        } else {
            $DATA{STATUS} = 0;
            $DATA{SESSION_ID} = '';
        }
    } else {
        $DATA{STATUS} = -1;
        $DATA{SESSION_ID} = '';
    }
    return (\%DATA);
}

sub getLoginData (){
    my $txEmail = shift;
    my $SQL = "SELECT * FROM TB_USER WHERE TX_EMAIL=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($txEmail);
    my %USERDATA = %{$select->fetchrow_hashref()};
    my $rows = $select->rows;
    if ($rows == 0) {
        return ;
    } else {
        return (\%USERDATA);
    }
}

#-------- 2021 ---------
sub _getUserData(){
    my $self = shift;
    return (\%USER);
}
sub _getAdminStatus(){
    my ($self, $userIDX) = @_;
    my $SQL = "SELECT IN_USER_TYPE FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
      $select->execute($userIDX);
    my ($inUserType) = $select->fetchrow_array();
    if ($inUserType>1) {
        return (1);
    } else {
        return (0);
    }
}
sub _getUserById(){
    my ($self, $userIDX) = @_;
    my $SQL = "SELECT CONCAT(TX_FIRST_NAME, ' ', TX_LAST_NAME) AS TX_USERNAME FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
      $select->execute($userIDX);
    my ($txUserName) = $select->fetchrow_array();
    return ($txUserName);
}
sub _getAllUsers(){
    my $self = shift;
    my $SQL = "SELECT * FROM TB_USER";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
}
sub _getJudges(){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE>=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( 1 );
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
}
sub _registerNewUser(){
    my ($self, $txFirst, $txLast, $txEmail, $txPassword) = @_;
    my $SQL = "INSERT INTO TB_USER (TX_FIRST_NAME, TX_LAST_NAME, TX_LOGIN, TX_EMAIL, TX_PASSWORD, IN_USER_TYPE, IN_LIMIT) VALUES (?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($txFirst, $txLast, $txEmail, $txEmail, $txPassword, 0, 0);
    my $userIDX = $insert->{q{mysql_insertid}};
    return ($userIDX);
}
sub _saveField(){
    my ($self, $txField, $txValue, $idx) = @_;
    my $SQL = "UPDATE TB_USER SET $txField=? WHERE PK_USER_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($txValue, $idx);
    return();
}
sub _addUserAccess(){
    my ($self, $tileIDX, $userIDX) = @_;
    my $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($tileIDX, $userIDX);
    #   print "$tileIDX, $userIDX";
    return;
}
sub _createNewStudentAccess(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) SELECT PK_TILES_IDX, $userIDX FROM TB_TILES WHERE BO_NEW=?";
    my $insert = $dbi->prepare($SQL);
       $insert->execute(1);
    return ($userIDX);
}
sub _removeUserAccess(){
    my ($self, $tileIDX, $userIDX) = @_;
    my $SQL = "DELETE FROM TB_ACCESS WHERE (FK_TILES_IDX=? AND FK_USER_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($tileIDX, $userIDX);
    #   print "$tileIDX, $userIDX";
    return;
}
sub _addUserTeam(){
    my ($self, $teamIDX, $userIDX) = @_;
    my $SQL = "INSERT INTO TB_USER_TEAM (FK_TEAM_IDX, FK_USER_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($teamIDX, $userIDX);
    return;
}

sub _removeUserTeam(){
    my ($self, $teamIDX, $userIDX) = @_;
    my $SQL = "DELETE FROM TB_USER_TEAM WHERE (FK_TEAM_IDX=? AND FK_USER_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($teamIDX, $userIDX) ;
    return;
}
sub _deleteUser(){
    my ($self, $userIDX) = @_;
    my $SQL = "DELETE FROM TB_USER WHERE (PK_USER_IDX=?)";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($userIDX) ;
    return;
}
sub _getUserAccess(){
    my $self = shift;
    my $inType = shift;
    my $SQL = "SELECT AC.* FROM TB_USER AS U JOIN TB_ACCESS AS AC ON U.PK_USER_IDX=AC.FK_USER_IDX WHERE U.IN_USER_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($inType);
    my %HASH = %{$select->fetchall_hashref(['FK_USER_IDX','FK_TILES_IDX'])};
    return (\%HASH);
}
sub _getUserByType(){
    my $self = shift;
    my $inType = shift;
    my $SQL = "SELECT * FROM TB_USER WHERE IN_USER_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($inType);
    my %HASH = %{$select->fetchall_hashref('PK_USER_IDX')};
    return (\%HASH);
}

return (1);