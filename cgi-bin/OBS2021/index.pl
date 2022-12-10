#!/usr/bin/perl
use cPanelUserConfig;

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
    my $Event = new SAE::TB_EVENT();
    my %EVENT = %{$Event->getAllRecordBy_BoArchive(0)};
    my $str;

    $str .= '<div class="inner">';
    $str .= '<header>';
    $str .= '<h1>Select Event Database</h1>';
    $str .= '</header>';
    $str .= '</div>';
    $str .= '<div class="w3-row-padding w3-margin-bottom">';
    foreach $eventIDX (sort keys %EVENT) {
        $str .= &_eventTiles($EVENT{$eventIDX}{TX_EVENT_NAME}, $eventIDX);
    }
    $str .= '</div>';
    $str .= '<div class="w3-clear"></div>';
    # $str .= '<a href="javascript:void(0);" onclick="signOutAdmin();">Logout</a>';
    return ($str);
}
sub login(){
    print $q->header();
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();
    my %DATA;
    my $str;
    my $TxEmail = $q->param('TxEmail');
    my $TxPassword = $q->param('TxPassword');
    my ($success, $userIDX, $sid, $boReset, $txFirst, $txLast) = $Auth->_login($TxEmail, $TxPassword);
    $DATA{SID} =  $sid;
    $DATA{TX_FIRST} = $txFirst;
    $DATA{TX_LAST} = $txLast;
    # $DATA{DATABASE} = $database;
    if ($success==1){
        $DATA{VALID} = 1;  #Valid Login
        $DATA{PK_USER_IDX} = $userIDX;
        $DATA{TYPE} = 0;
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
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue w3-padding">';
    $str .= '<h2 style="float: left;">Update Temporary Password</h2>';
    $str .= '</div>';
    $str .= '<form action="javascript:void(0);" onsubmit="updateTempPassword(\''.$txEmail .'\', \''.$txPassword.'\');">';
    $str .= '<p><input class="w3-input" type="Password" ID="TempPassword" required placeholder="Temporary Password"></p>';
    $str .= '<p><input class="w3-input w3-password" type="password" ID="NewPassword" required placeholder="New Password"></p>';
    $str .= '<p><input class="w3-input w3-password" type="password" ID="ConPassword" required placeholder="Confirm Password"></p>';
    $str .= '<br>';
    $str .= '<center class="w3-padding">';
    $str .= '<input type="submit" value="Update Password" class="w3-button w3-card-2 w3-small">';
    $str .= '<button class="w3-button w3-card-2 w3-small w3-margin-left" onclick="showLoginScreen();">Cancel</button>';
    $str .= '</center>';
    $str .= '</form>';
    $str .= '</div>';
    return ($str);
}
sub showLoginScreen(){
    print $q->header();
    my $str;
    $str .= '<center>';
    $str .= '<div class="w3-border w3-card-2 w3-round-large" style="width: 350px;">';
	$str .= '<div class="w3-container w3-blue">';
    $str .= '<h2>STARS LOGIN</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container" action="javascript:void(0);" onsubmit="goLogin();">';
	$str .= '<p><input class="w3-input " type="email" name="TxEmail" ID="TxEmail" required placeholder="Email"  /></p>';
	$str .= '<p><input class="w3-input " type="password" ID="TxPassword" name="TxPassword" required placeholder="Password" /></p>';
	$str .= '<center class="w3-padding w3-container">';
	$str .= '<div class="w3-container w3-center">';
	$str .= '<input type="submit" value="Sign In" class="w3-hide w30green w3-card-4">';
	$str .= '<p><a class="w3-button w3-border w3-card-2 w3-hover-green w3-round-medium"  href="javascript:void(0);" onclick="goLogin();">Log In</a></P>';
	# $str .= '<br>';
	$str .= '<a class="w3-small" href="javascript:void(0);" onclick="showResetPassword();">Reset Password</a> | ';
	$str .= '<a class="w3-small" href="javascript:void(0)" onclick="showRegisterNewUser();" >Create an account</a>';
    $str .= '<br>';
    $str .= '</center>';
	$str .= '</div>';
	$str .= '</form>';
	$str .= '</div>';
    $str .= '</center>';
    return ($str);
}
sub _templateNewUserInput(){
    my ($label, $ID) = @_;
    my $str;

    $str = '<p><label>'.$label.'</label>';
    $str .= '<input class="w3-input" type="text" ID="'.$ID.'" required placeholder="'.$label.'"></p>';
    return ($str);
}
sub showRegisterNewUser(){
    print $q->header();
    my $divName = $q->param('divName');
    my $str;
    $str .= '<form class="w3-container" action="javascript:void(0);" onsubmit="registerNewUser();">';
    $str .= &_templateNewUserInput('First Name','NewFirstName');
    $str .= &_templateNewUserInput('Last Name','NewLastName');
    $str .= '<p><label>Email</label>';
    $str .= '<input class="w3-input" type="email" ID="NewTxEmail" required placeholder="Email Address" onkeyup="validateEmailInDb(this.value);"></p>';
    $str .= '<p ID="emailWarning" class="emailCheckRed"></p>';
    $str .= &_templateNewUserInput('Password','NewPassword');
    $str .= &_templateNewUserInput('Confirm Password','ConPassword');
    $str .= '<br>';
    $str .= '<center>';
    $str .= '<input type="submit" class="w3-button w3-border w3-margin" value="Register">';
    $str .= '<button class="w3-button w3-margin" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
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
    my $User = new SAE::TB_USER();
    my $Auth = new SAE::Auth();
    my $salt = $Auth->getTemporaryPassword(2);
    my $userPassword = $salt.crypt($txPassword, $salt);
    $User->setTxFirstName($txFirstName);
    $User->setTxLastName($txLastName);
    $User->setTxPassword($userPassword);
    $User->setTxEmail($txEmail);
    $User->setTxLogin($txEmail);
    $User->setInUserType(0);
    $User->setFkDefaultEventIdx(0);
    $User->setBoReset(0);
    $User->setInLimit(3);
    $User->setBoDaily(0);
    $User->setBoWeekly(0);
    my $newIDX = $User->addNewRecord();
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
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">Password Reset</h2>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-card w3-padding-16">';
    $str .= '<p>Enter the email address you used to register for an account.</p>';
    $str .= '<p><label>Email Address</label>';
    $str .= '<input class="w3-input" type="email" ID="NewTxEmail" required placeholder="Email Address"></p>';
    $str .= '<center>';
    $str .= '<button class="w3-button w3-card w3-margin" onclick="resetPassword();">Submit</button>';
    $str .= '<button class="w3-button w3-margin" onclick="closeModal(\'id01\');">Cancel</button>';
    $str .= '</center>';
    $str .= '</div>';
    return ($str);
}
sub resetPassword(){
    print $q->header();
    my $txEmail = $q->param('TxEmail');
    my $Auth = new SAE::Auth();
    my $User = new SAE::TB_USER();
    my $pkUserIdx = $User->getIdBy_TxEmail($txEmail);
    my $tempPassword = $Auth->getTemporaryPassword(10);
    my $salt = $Auth->getTemporaryPassword(2);
    my $saltedPassword = $salt.crypt($tempPassword,$salt);
    $User->updateTxPassword_byId($saltedPassword, $pkUserIdx);
    $User->updateBoReset_byId(1, $pkUserIdx);
    $User->getRecordById($pkUserIdx);
    my $txFirstName = $User->getTxFirstName( );
    my $str;
    my $body = &getPasswordResetText($txFirstName, $txEmail, $tempPassword);
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 style="float: left;">Password Reset</h2>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<p>';
    $str .= 'New Password sent to the Email provided ['.$txEmail.']';
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