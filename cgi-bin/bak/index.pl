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
use SAE::USER;
use SAE::Auth;
use SAE::TB_EVENT;
use SAE::REFERENCE;
use SAE::EVENT;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;

sub __template(){
    print $q->header();
    my $str;

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
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();
    
    my %DATA;
    my $str;
    my $TxEmail = $q->param('TxEmail');
    my $TxPassword = $q->param('TxPassword');
    my $eventIDX = $q->param('eventIDX');
    my $Event = new SAE::EVENT($eventIDX);
    my %EVENT = %{$Event->_getEventData()};
    my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login($TxEmail, $TxPassword);
    $DATA{SID} =  $sid;
    $DATA{TX_FIRST} = $txFirst;
    $DATA{TX_LAST} = $txLast;
    # $DATA{DATABASE} = $database;
    if ($success==1){
        $DATA{VALID} = 1;  #Valid Login
        $DATA{PK_USER_IDX} = $userIDX;
        $DATA{TYPE} = 0;
        $DATA{DATABASE} = $EVENT{TX_EVENT_NAME};
        $Auth->_updateAccessTime($userIDX);
        $Auth->_audit($userIDX, $eventIDX);
        if ($boReset==1){
            $DATA{RESET} = 1;  #Valid Login
            $DATA{HTML} = &showUpdateTemporaryPassword($TxEmail, $TxPassword);
        } else {
            $DATA{RESET} = 0;  #Valid Login
            $DATA{HTML} = "Successful Login";
            $DATA{PK_USER_IDX} = $userIDX;
        }
    } else {
        $DATA{VALID} = 0;  # Invalid Login
        $DATA{RESET} = 0;  # Invalid Login
        # $DATA{TYPE} = "";
        $DATA{HTML} = "";
        $DATA{PK_USER_IDX} = "";
    }
    my $json = encode_json \%DATA;
    return ($json);
}
sub showUpdateTemporaryPassword(){
    $txEmail = shift;
    $txPassword = shift;
    $str = '<div class="w3-container">';
    $str .= sprintf '<div class="w3-padding">';
    $str .= '<label class="w3-small w3-text-grey w3-margin-bottom">Temporary Password<input class="w3-input w3-password w3-border w3-round" type="password" ID="TempPassword" placeholder="Temporary Password"></label>';
    $str .= '<label class="w3-small w3-text-grey w3-margin-bottom">New Password<input class="w3-input w3-password w3-border w3-round" type="password" ID="NewPassword" placeholder="New Password" ></label>';
    $str .= '<label class="w3-small w3-text-grey w3-margin-bottom">Confirm New Password<input class="w3-input w3-password w3-border w3-round" type="password" ID="ConPassword" placeholder="Confirm Password"></label>';
    $str .= '</div>';
    $str .= '<div class="w3-roww3-padding w3-center w3-margin-top">';

    $str .= '<div class="w3-half w3-padding">';
    $str .= sprintf '<button class="w3-button w3-round w3-border w3-small w3-green w3-hover-blue" style="width: 100%;" onclick="updateTempPassword(this, \'%s\', \'%s\');">Update Password</button>', $txEmail, $txPassword;
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
    $str .= '<form class="w3-container w3-padding" style="text-align: left;" action="javascript:void(0);" onsubmit="">';
	$str .= '<label class="w3-text-grey w3-small w3-margin-bottom">Username (email)<input class="w3-input w3-border w3-round" type="email" name="TxEmail" ID="TxEmail" required placeholder="Email" autocomplete="TxEmail"  /></label>';
	$str .= '<label class="w3-text-grey w3-small w3-margin-bottom">Password<input class="w3-input w3-border w3-round" type="password" ID="TxPassword" name="TxPassword" required placeholder="Password" autocomplete="TxPassword" /></label>';
	$str .= '<label class="w3-text-grey w3-small w3-margin-bottom">SAE Aero-Design Event';
    $str .= '<select ID="sae_eventSelection" class="w3-select w3-border w3-round w3-padding"> ';
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
# 	$str .= '<input class="w3-button w3-border w3-round w3-hover-green w3-round-medium" style="width: 100%;" type="submit" value="Sign-In">';
# 	$str .= '<button class="w3-button w3-border w3-round w3-hover-green w3-round-medium" style="width: 100%;" onclick="goLogin();">Log In</button>';
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
    my ($label, $ID) = @_;
    my $str;

    $str = '<p><label class="w3-small w3-text-grey">'.$label.'</label>';
    $str .= '<input class="w3-input w3-border w3-round" type="text" ID="'.$ID.'" required placeholder="'.$label.'"></p>';
    return ($str);
}
sub showRegisterNewUser(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<form class="w3-container" action="javascript:void(0);" onsubmit="registerNewUser();">';
    $str .= '<p><label class="w3-small">Email</label>';
    $str .= '<input class="w3-input w3-border w3-round" type="email" ID="NewTxEmail" required placeholder="Email Address" onkeyup="validateEmailInDb(this.value);"></p>';
    $str .= '<p ID="emailWarning" class="emailCheckRed"></p>';
    $str .= &_templateNewUserInput('First Name','NewFirstName');
    $str .= &_templateNewUserInput('Last Name','NewLastName');
    
    $str .= &_templateNewUserInput('Password','NewPassword');
    $str .= &_templateNewUserInput('Confirm Password','ConPassword');
    $str .= '<br>';
    $str .= '<center>';
    $str .= '<input type="submit" class="w3-button w3-border w3-round w3-margin w3-green w3-hover-blue" value="Register">';
    $str .= '<button class="w3-button w3-margin w3-round w3-border" onclick="$(this).close();">Cancel</button>';
    $str .= '</center>';
    $str .= '</form>';
    return ($str);
}
sub registerNewUser(){
    print $q->header();
    my $txFirstName = $q->param('TxFirstName');
    my $txLastName = $q->param('TxLastName');
    my $txEmail = $q->param('TxEmail');
    my $txPassword = $q->param('TxPassword');
    my $User = new SAE::USER();
    # my $User = new SAE::TB_USER();
    my $Auth = new SAE::Auth();
    my $salt = $Auth->getTemporaryPassword(2);
    my $userPassword = $salt.crypt($txPassword, $salt);
    my $newIDX = $User->_registerNewUser($txFirstName, $txLastName, $txEmail, $userPassword);
    $Auth->_createNewStudentAccess( $newIDX );
    my $body = &getWelcomeText($txFirstName, $txEmail, $txPassword);
    $str .= '<h2>Welcome</h2>';
    my %mail = (   To      => $txEmail,
                    From    => 'donotreply@saestars.com',
                    'Content-Type' => 'text/html; charset=UTF-8',
                    Subject => 'New User ['.$txFirstName.' '.$txLastName.'] ('.$newIDX .') Registration',
                    Message => $body
                );
    sendmail(%mail) or die $Mail::Sendmail::error;
    return ($str.$body);
}
sub getWelcomeText(){
    my ($firstName, $email, $password) = @_;
    my $str;
    $str .= '<div class="w3-small">';
    $str .= "Hi $firstName,<br><br>";
    $str .= "<p>Welcome to STARS [Score Tracking and Recording System], and thank you for registering for the SAE Aero-Design Competition.</p>";
    $str .= "<p>You are now registered to receive real-time online scoring information and team feedback for this year's SAE Aero-Design Competition!</br>";
    $str .= "The SAE Rules Committee is working around the clock to continue to improve the Aero-Design Experience.</p>";

    $str .= "<p>This new real-time scoring web application will help you focus on a winning strategy for your team while keeping a close eye on your team’s progress and standings.  Set and track your event scores by obtaining your personalized team code from the SAE Competition Scoring Judge.</p>";

    $str .= "<ol>NEXT STEP<br>";
    $str .= "<li><b>Obtain Team Code from the SAE Competition Scoring Judge</b></li>";
    $str .= "<li>Login to your account";
    $str .= "<ul><li>Email: [$email]</li>";
    $str .= "<li>Password: [".substr($password,0,2)."**************]</li>";
    $str .= "</ul></li>";
    $str .= "<li>Click on Add a Team</li>";
    $str .= "<li>Enter Team Code provided by your SAE Competition Scoring Judge</li></ol>";

    $str .= "Best,<br><br>";
    $str .= "Aero Design Competition Committee";
    $str .= '</div>';
    return ($str);
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
    $str .= '<p>Please enter the email address you\'d like your temporary password sent.</p>';
    $str .= '<p>';
    if ($txEmail){
        $str .= sprintf '<input class="w3-input w3-round w3-border w3-text-blue" required type="email" autocomplete="NewTxEmail" ID="NewTxEmail" value="%s" required placeholder="Enter e-mail address here"></p>', $txEmail; 
    } else {
        $str .= '<input class="w3-input w3-round w3-border w3-text-blue" required type="email" autocomplete="NewTxEmail" ID="NewTxEmail" required placeholder="Enter e-mail address here"></p>';     
    }
    
    $str .= '</p>';
    $str .= '<div class="w3-row">';
        $str .= '<div class="w3-content w3-center w3-margin-bottom">';
        $str .= '<button class="w3-button w3-card w3-border w3-round w3-blue-grey w3-hover-blue" style="width: 100%;" onclick="resetPassword();">Request temporary password</button>';
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
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();
    my $userIDX = $User->getIdBy_TxEmail($txEmail);
    # my $pkUserIdx = $User->getIdBy_TxEmail($txEmail);
    my $tempPassword = $Auth->getTemporaryPassword(10);
    my $salt = $Auth->getTemporaryPassword(2);
    my $saltedPassword = $salt.crypt($tempPassword,$salt);
    
    my $str;
    
    $str .= '<div class="w3-container">';
    if ($userIDX){
        $User->updateTxPassword_byId($saltedPassword, $userIDX);
        $User->updateBoReset_byId(1, $userIDX);
        $User->getRecordById($userIDX);
        my $txFirstName = $User->getTxFirstName( );
        my $body = &getPasswordResetText($txFirstName, $txEmail, $tempPassword);
        $str = '<p>';
        $str .= 'A new temporary password will be sent to the email address provided ['.$txEmail.']';
        $str .= '</p>';
        $str .= '<p>Be sure to check your <i>Junk Folder</i> for this PASSWORD RESET email.';
        # $str .= $body;
        $str .= '</p>';
        $str .= '</div>';
        $str .= '<div class="w3-container w3-blue">';
        $str .= '</div>';
        # my $body = &getPasswordResetText($txFirstName, $txEmail, $tempPassword);
        my %mail = (   To      => $txEmail,
                        From    => 'aerogeek@saestars.com',
                        'Content-Type' => 'text/html; charset=UTF-8',
                        Subject => 'Password Reset Request',
                        Message => $body
                    );
        sendmail(%mail) or die $Mail::Sendmail::error;
    } else {
        $str = '<div class="w3-container w3-padding">';
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
sub getPasswordResetText(){
    my ($firstName, $email, $password) = @_;
    my $str;
    $str .= "Hi $firstName,<br><br>";
    $str .= "<p>The password for your SAE STARS account (<b>$email</b>) has been successfully reset.</p>";
    $str .= "<p>If you didn't make this change or if you believe an unauthorized person has accessed your account, please see and SAE Scoring Judge immediately.</p>";
    $str .= "<p>Login Email: $email<br />";
    $str .= "Temporary Password: $password<br />";
    $str .= "</p>";
    $str .= "<a href='http://www.saestars.com'>http://www.saestars.com</a>";
    $str .= "<br><br>Best,<br><br>";
    $str .= "Aero Design Scoring Judge";
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