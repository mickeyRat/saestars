#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use CGI::Session;
use CGI::Cookie;
use LWP::Simple;
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Mail::Sendmail;
# use HTML::Entities;

#---- SAE MODULES -------

use SAE::SDB;
use SAE::TB_USER;
use SAE::Auth;
use SAE::TB_EVENT;
use SAE::REFERENCE;
use SAE::EVENT;
use SAE::JSONDB;
use SAE::SECURE;
use SAE::USER;
use SAE::MAIL;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} 
else {
    &{$do= $q->param("do")};
}
exit;

sub __template(){
    print $q->header();
    my $str;

    return ($str);
}
sub testDeleteData (){
    my $IDX= $q->param('IDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $DB = new SAE::JSONDB();
    $DB->_delete('TB_USER', qq(PK_USER_IDX=$IDX));
    my $str;

    return ($str);
}

sub testUpdateData (){
    my $IDX= $q->param('IDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $DB = new SAE::JSONDB();
    $DB->_update('TB_USER', \%DATA, qq(PK_USER_IDX=$IDX));
    my $str;
    return ($str);
}

sub objectTest(){
    my $eventIDX= $q->param('eventIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $User = new SAE::USER();
    my $str;
    $str .= $User->_register(\%DATA);
    return ($str);
}


sub showSetEventLocation(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my $location = $q->param('location');
    my %EVENTS = %{$Ref->_getEventList()};
    my $str = '<div class="w3-margin w3-padding w3-display-container" style="height: 150px;">';
    $str .= '<label for="sae_eventSelection">Choose an Event:</label>';
    $str .= '<select ID="sae_eventSelection" class="w3-select w3-border w3-round w3-padding"> ';
    $str .= '<option value="0" selected disabled>- Select Event Database -</option>';
    foreach $eventIDX (sort {$b <=> $a} keys %EVENTS){
        my $selected = '';
        my $selectedClass='';
        if ($eventIDX == $location){$selected = 'selected'; $selectedClass='w3-pale-yellow'}
        $str .= sprintf '<option class="%s" value="%d" %s>%s</option>', $selectedClass, $eventIDX, $selected, $EVENTS{$eventIDX}{TX_EVENT_NAME};
    }
    $str .= '</select>';
    $str .= '<button class="w3-green w3-hover-blue w3-button w3-border w3-round-large w3-card-2 w3-margin-bottom w3-margin-right w3-display-bottomright" style="width: 120px;" onclick="setEventLocation();">Set Event</button>';
    $str .= '</div>';
    return($str);
}
sub login(){
    print $q->header();
    my $str;
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $User = new SAE::USER();
    my %USER = %{$User->_login($DATA{TX_EMAIL}, $DATA{TX_PASSWORD}, $DATA{FK_EVENT_IDX})};

    # $USER{FK_EVENT_IDX} = $DATA{FK_EVENT_IDX};
    $USER{LOCATION} = $DATA{FK_EVENT_IDX};
    $USER{eventIDX} = $DATA{FK_EVENT_IDX};
    $USER{FK_EVENT_IDX} = $DATA{FK_EVENT_IDX};
    
    $USER{HTML}='';
    if ($USER{STATUS} ==1 ){
        my $userIDX = $USER{PK_USER_IDX};
        $USER{userIDX} = $userIDX;
        $User->_updateAccessTime($userIDX);
        $USER{TEXT_STATUS} = "Successful Login";
        $USER{HTML} = "Successful Login";
        if ($USER{BO_RESET} == 1) {
            $USER{HTML} = &showUpdateTemporaryPassword($USER{PK_USER_IDX}, $DATA{TX_EMAIL}, $DATA{TX_PASSWORD});
        } 
    } elsif ($USER{STATUS} == 0) {
        $USER{TEXT_STATUS} = "Username and password did not match data in the database";
    } else {
        $USER{TEXT_STATUS} = "[$DATA{TX_EMAIL}] Username does not exist.  Did you register?";
    }
    my $json = encode_json \%USER;
    return($json);



    # my $Auth = new SAE::Auth();
    # my $User = new SAE::TB_USER();

    # my %DATA;
    # my $str;
    # my $TxEmail = $q->param('TxEmail');
    # my $TxPassword = $q->param('TxPassword');
    # my $eventIDX = $q->param('eventIDX');
    # my $Event = new SAE::EVENT($eventIDX);
    # my %EVENT = %{$Event->_getEventData()};
    # my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login($TxEmail, $TxPassword);
    # # print "$success, $userIDX, $sid, $boReset, $txFirst, $txLast";
    # $DATA{SID} =  $sid;
    # $DATA{TX_FIRST} = $txFirst;
    # $DATA{TX_LAST} = $txLast;
    # $DATA{DATABASE} = $database;
    # if ($success==1){
    #     $DATA{VALID} = 1;  #Valid Login
    #     $DATA{PK_USER_IDX} = $userIDX;
    #     $DATA{TYPE} = 0;
    #     $DATA{DATABASE} = $EVENT{TX_EVENT_NAME};
    #     $Auth->_updateAccessTime($userIDX);
    #     $Auth->_audit($userIDX, $eventIDX);
    #     if ($boReset==1){
    #         $DATA{RESET} = 1;  #Valid Login
    #         $DATA{HTML} = &showUpdateTemporaryPassword($TxEmail, $TxPassword);
    #     } else {
    #         $DATA{RESET} = 0;  #Valid Login
    #         $DATA{HTML} = "Successful Login";
    #         $DATA{PK_USER_IDX} = $userIDX;
    #     }
    # } else {
    #     $DATA{VALID} = 0;  # Invalid Login
    #     $DATA{RESET} = 0;  # Invalid Login
    #     # $DATA{TYPE} = "";
    #     $DATA{HTML} = "";
    #     $DATA{PK_USER_IDX} = "";
    # }
    # my $json = encode_json \%DATA;
    # return ($json);
}
sub showUpdateTemporaryPassword(){
    my $userIDX = shift;
    my $txEmail = shift;
    my $txPassword = shift;
    my $str = '<div class="w3-container">';
        $str .= sprintf '<div class="w3-padding">';
            $str .= '<form id="form_passwordReset" class="w3-container w3-padding" style="text-align: left;" action="javascript:void(0);" onsubmit="javascript:void(0);">';
            $str .= '<label class="w3-small w3-text-grey w3-margin-bottom">Temporary Password<input   type="password" name="TEMP_PASSWORD"  class="w3-input w3-password w3-border w3-round" ID="TEMP_PASSWORD" /></label>';
            $str .= '<label class="w3-small w3-text-grey w3-margin-bottom">New Password<input         type="password" name="TX_PASSWORD" class="w3-input w3-password w3-border w3-round" ID="TX_PASSWORD" /></label>';
            $str .= '<label class="w3-small w3-text-grey w3-margin-bottom">Confirm New Password<input type="password" name="CON_PASSWORD" class="w3-input w3-password w3-border w3-round" ID="CON_PASSWORD" /></label>';
            # $str .= '<input class="w3-input w3-border w3-round" type="password" ID="TxPassword" name="TX1_PASSWORD" required placeholder="Password" autocomplete="1TxPassword" />';
            $str .= '</form>';
        $str .= '</div>';
        $str .= '<div class="w3-roww3-padding w3-center w3-margin-top">';

            $str .= '<div class="w3-half w3-padding">';
                $str .= sprintf '<button class="w3-button w3-round w3-border w3-small w3-green w3-hover-blue" style="width: 100%;" onclick="changeTemporaryPassword(this, %d, \'%s\', \'%s\');">Update Password</button>', $userIDX, $txEmail, $txPassword;
            $str .= '</div>';
    
            $str .= '<div class="w3-half w3-padding">';
                $str .= '<button class="w3-button w3-round w3-border w3-small w3-margin-left" style="width: 100%;" onclick="sae_cancelChangeTemporaryPassword(this);">Cancel</button>';
            $str .= '</div>';
        $str .= '</div>';
    
    $str .= '</div>';
    return ($str);
}
sub showLoginScreen(){
    print $q->header();
    my $Ref = new SAE::REFERENCE();
    my %EVENTS = %{$Ref->_getEventList()};
    my $str;
    $str .= '<center>';
    $str .= '<div class="w3-border w3-card-2 w3-round-large" style="width: 350px;">';
	$str .= '<div class="w3-container w3-blue-grey" style="border-top-right-radius:8px; border-top-left-radius:8px;">';
    $str .= '<h2>STARS LOGIN</h2>';
    $str .= '</div>';
    # $str .= '<form class="w3-container w3-padding" style="text-align: left;" action="javascript:void(0);" onsubmit="goLogin();">';
    $str .= '<form id="form_login" class="w3-container w3-padding" style="text-align: left;" action="javascript:void(0);" onsubmit="">';
	$str .= '<label class="w3-text-grey w3-small w3-margin-bottom">Username (email)<input class="w3-input w3-border w3-round" type="email" name="TX_EMAIL" ID="TxEmail" required placeholder="Email" autocomplete="TxEmail"  /></label>';
	$str .= '<label class="w3-text-grey w3-small w3-margin-bottom">Password<input class="w3-input w3-border w3-round" type="password" ID="TxPassword" name="TX_PASSWORD" required placeholder="Password" autocomplete="TxPassword" /></label>';
	$str .= '<label class="w3-text-grey w3-small w3-margin-bottom">SAE Aero-Design Event';
    $str .= '<select ID="sae_eventSelection" name="FK_EVENT_IDX" class="w3-select w3-border w3-round w3-padding"> ';
    $str .= '<option value="0" selected disabled>- Select Event -</option>';
    foreach $eventIDX (sort {$b <=> $a} keys %EVENTS){
        my $selected = '';
        my $selectedClass='';
        if ($eventIDX == $location){$selected = 'selected'; $selectedClass='w3-pale-yellow'}
        $str .= sprintf '<option class="%s" value="%d" %s>%s</option>', $selectedClass, $eventIDX, $selected, $EVENTS{$eventIDX}{TX_EVENT_NAME};
    }
    $str .= '</select><label>';
	$str .= '<center class="w3-padding w3-container">';
	$str .= '<div class="w3-container w3-center w3-margin-top w3-margin-bottom">';
	$str .= '<button class="w3-button w3-border w3-round w3-hover-green w3-round-medium w3-mobile w3-margin-bottom" onclick="goLogin(this);">Sign-In</button>';
	$str .= '<br>'x2;
	$str .= '<div class="w3-row w3-center">';
	$str .= '<a class="w3-small w3-mobile" href="javascript:void(0);" onclick="sae_showResetPassword();">Reset Password</a><span class="w3-hide-small"> | </span>';
	$str .= '<a class="w3-small w3-mobile" href="javascript:void(0)" onclick="showRegisterNewUser();" >Create an account</a>';
    $str .= '</div>';
    $str .= '<br>';
    # $str .= '</center>';
	$str .= '</div>';
	$str .= '</form>';
	$str .= '</div>';
    $str .= '</center>';
    return ($str);
}
sub _templateNewUserInput(){
    my ($label, $ID, $fieldName) = @_;
    my $str;

    $str = '<p><label class="w3-small w3-text-grey">'.$label.'</label>';
    $str .= '<input name="'.$fieldName.'" class="w3-input w3-border w3-round" type="text" ID="'.$fieldName.'" required placeholder="'.$label.'"></p>';
    return ($str);
}
sub showRegisterNewUser(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<form id="form_registerNewUser" class="w3-container" action="javascript:void(0);" onsubmit="btn_registerNewUser();">';
    # $str .= '<form id="form_registerNewUser" class="w3-container" action="javascript:void(0);" onsubmit="registerNewUser();">';
    # $str .= '<p><label class="w3-small">Email</label>';
    $str .= '<br><input name="TX_EMAIL" class="w3-input w3-border w3-round" type="email" ID="NewTxEmail" required placeholder="Email Address" onkeyup="validateEmailInDb(this.value);"></p>';
    $str .= '<p ID="emailWarning" class="emailCheckRed"></p>';
    $str .= '<input name="TX_FIRST_NAME" class="w3-input w3-border w3-round" type="text" ID="TX_FIRST_NAME" required placeholder="First Name"></p>';
    $str .= '<input name="TX_LAST_NAME" class="w3-input w3-border w3-round" type="text" ID="TX_LAST_NAME" required placeholder="Last Name"></p>';
    $str .= '<input name="TX_PASSWORD" class="w3-input w3-border w3-round" type="password" ID="TX_PASSWORD" required placeholder="Password"></p>';
    # $str .= &_templateNewUserInput('First Name','NewFirstName','TX_FIRST_NAME');
    # $str .= &_templateNewUserInput('Last Name','NewLastName', 'TX_LAST_NAME');
    
    # $str .= &_templateNewUserInput('Password','NewPassword', 'TX_PASSWORD');
    # $str .= '<p><label class="w3-small w3-text-grey">Confirm Password</label>';
    $str .= '<input class="w3-input w3-border w3-round" type="password" required placeholder="Confirm Password" onblur="sae_comparePassword(this.value);"></p>';
    $str .= '<div id="msg_passwordMismatch" class="w3-red w3-padding" style="display: none;">Password Mismatch</div>';
    $str .= '</p>';
    # $str .= &_templateNewUserInput('Confirm Password','ConPassword', 'TX_CONFIRM');
    # $str .= '<br>';
    $str .= '<center>';
    $str .= '<input ID="btn_register" type="submit" class="w3-button w3-border w3-round w3-margin w3-green w3-hover-blue" value="Register">';
    $str .= '<button class="w3-button w3-margin w3-round w3-border" onclick="$(this).close();">Cancel</button>';
    
    # $str .= '<button onclick="btn_objectTest();">Test</button><br>';
    # $str .= '<button onclick="btn_testUpdateData();">Test Update</button><br>';
    # $str .= '<button onclick="btn_testDeleteData();">Test Delete</button><br>';
    $str .= '</center>';
    $str .= '</form>';
    return ($str);
}
sub registerNewUser(){
    my $eventIDX= $q->param('eventIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $to = $DATA{TX_EMAIL};
    $DATA{TX_LOGIN} = $DATA{TX_EMAIL};
    print $q->header();
    my $User = new SAE::USER();
    my $str;
    my $userIDX .= $User->_register(\%DATA);
    $str = $User->_createNewStudentAccess($userIDX);
    $User->_updateAccessTime($userIDX);
    my $Mail = new SAE::MAIL();
    my $from = 'aerogeek@saestars.com';
    my $subject = 'SAE-STARS: Welcome';
    my $message = $Mail->_getWelcomeEmailText($DATA{TX_FIRST_NAME}, $to, $DATA{TX_PASSWORD});
       $Mail->_sendMail_HTML($to, $from, $subject, $message);
       # $Mail->_sendMail($to, $from, $subject, $message);
    return ($message);
}
sub checkEmailAddress(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $str;
    my @EMAILS = ();
    my $SQL = "SELECT TX_EMAIL FROM TB_USER";
    my $select = $dbi->prepare($SQL);
    $select->execute();
    while (my ($email) = $select->fetchrow_array()) {
        $DATA{$email}=1;
    }
    my $json = encode_json \%DATA;
    return ($json);
}
sub showResetPassword(){
    print $q->header();
    my $txEmail = $q->param('txEmail');
    my $str;
    $str .= '<div class="w3-container w3-card w3-padding-16 w3-round">';
    $str .= '<p>Provide the email address foor your account.</p>';
    $str .= '<p>';
    if ($txEmail){
        $str .= sprintf '<input class="w3-input w3-round w3-border w3-text-blue" required type="email" autocomplete="NewTxEmail" ID="NewTxEmail" value="%s" required placeholder="Enter e-mail address here"></p>', $txEmail; 
    } else {
        $str .= '<input class="w3-input w3-round w3-border w3-text-blue" required type="email" autocomplete="NewTxEmail" ID="NewTxEmail" required placeholder="Enter e-mail address here"></p>';     
    }
    
    $str .= '</p>';
    $str .= '<div class="w3-row">';
        $str .= '<div class="w3-content w3-center w3-margin-bottom">';
        $str .= '<button class="w3-button w3-card w3-border w3-round w3-green w3-hover-blue" style="width: 100%;" onclick="resetPassword();">Request Temporary Password</button>';
        $str .= '</div>';
        $str .= '<div class="w3-content w3-center w3-margin-top w3-small">';
        $str .= '<a class="w3-text-blue" href="javascript:void(0);" onclick="$(this).close();">Back To Login</a>';
        $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
}
sub resetPassword(){
    print $q->header();
    my $txEmail = $q->param('txEmail');
    my $User = new SAE::USER();
    my $Secure = new SAE::SECURE();
    my $JsonDB = new SAE::JSONDB();
    my $Mail = new SAE::MAIL();
    my %DATA;
    my $tp   = $Secure->_getTemporaryPassword(8);
    my $salt = $Secure->_getTemporaryPassword(2);
    my $saltedPassword = crypt($tp,$salt);
    $DATA{TX_PASSWORD} = $saltedPassword;
    $DATA{BO_RESET} = 1;
    $JsonDB->_update('TB_USER',\%DATA,qq(TX_EMAIL='$txEmail'));
    my $User = new SAE::TB_USER();
    my $userIDX = $User->getIdBy_TxEmail($txEmail);

    my $str;
    # $str .= '<div class="w3-container">';
    if ($userIDX){
        my $to = $txEmail;
        my $from = 'aerogeek@saestars.com';
        my $subject = 'SAE-STARS: Password Reset';
        my $message = $Mail->_getPasswordResetText($to, $tp);
        $Mail->_sendMail_HTML($to, $from, $subject, $message);
        # $Mail->_sendMail($to, $from, $subject, $message);

        $str .= '<p>';
        $str .= 'A new temporary password will be sent to the email address provided ['.$txEmail.']';
        $str .= '</p>';
        $str .= '<p>Be sure to check your <i>Junk Folder</i> for an email with Subject as: <b>SAE-STARS: Password Reset</b>';
        # $str .= $body;
        $str .= '</p>';
        $str .= '</div>';
        $str .= '<div class="w3-container w3-blue">';
        $str .= '</div>';
    } else {
        $str .= '<div class="w3-container w3-padding">';
        $str .= '<p>';
        $str .= sprintf 'The email address provide [ <span class="w3-text-blue">%s</span> ] did not match a registered user in our database.</p>', $txEmail;
        $str .= '<p>Please&nbsp;<a class="w3-text-blue" href="javascript:void(0);" onclick="$(this).close();sae_showResetPassword();">try again</a></p>';
        $str .= '<div class="w3-center">';
        $str .= '<br><br><a class="w3-text-blue w3-small" href="javascript:void(0);" onclick="$(this).close();">Back To Login</a>';
        $str .= '</div>';
        $str .= '</div>';
    }
    return ($str);
}
sub changeTemporaryPassword (){
    my $userIDX= $q->param('userIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $Secure = new SAE::SECURE();
    my $salt = $Secure->getSalt();
       $DATA{TX_PASSWORD} = crypt($DATA{TX_PASSWORD}, $salt);
    my $JsonDB = new SAE::JSONDB();
    print $q->header();
    my $str;
    $str .= $JsonDB->_update('TB_USER', \%DATA, qq(PK_USER_IDX=$userIDX));

    return ($str);
}
sub updateTempPassword(){
    print $q->header();
    my $txEmail = $q->param('TxEmail');
    my $txPassword = $q->param('TxPassword');
    my $User = new SAE::TB_USER();
    my $Auth = new SAE::Auth();
    my $pkUserIdx = $User->getIdBy_TxEmail($txEmail);
    my $salt = $Auth->getTemporaryPassword(2);
    my $userPassword = $salt.crypt($txPassword, $salt);
    $User->updateTxPassword_byId($userPassword, $pkUserIdx);
    $User->updateBoReset_byId(0, $pkUserIdx);
    $str = "Password Reset Complete.";
    return ($str);
}
sub _tiles(){
    my ($label, $image, $click) = @_;
    my $str;
    $str .= '<div class="w3-third w3-center">';
    $str .= '<div class="w3-card w3-container" style="min-height:260px; margin-top: 1.0em;">';
    $str .= '<h3>'.$label.'</h3><br>';
    $str .= '<a onclick="'.$click.'" href="javascript:void(0);" class="'.$image.' w3-margin-bottom w3-text-theme" style="font-size:110px; text-decoration: none;"></a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub _eventTiles(){
    my ($title, $eventIDX) = @_;
    my $str;
    $str = '<div class="w3-quarter w3-button w3-margin-top" onclick="setEventLocation('.$eventIDX.');">';
    $str .= '<div class="w3-container w3-blue-grey w3-padding-16 ">';
    $str .= '<div class="w3-left"><i class="fa fa-database w3-xxxlarge"></i></div>';
    $str .= '<div class="w3-right">';
    $str .= '</div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= '<h4>'.$title.'</h4>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}