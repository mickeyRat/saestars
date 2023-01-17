package SAE::MAIL;

use DBI;
use SAE::SDB;
use Mail::Sendmail;
use MIME::Lite;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub _sendMail_HTML(){
    my ($self, $to, $from, $subject, $message) = @_;
    if ($to eq $from){$from = 'reports@saestars.com'}
    $msg = MIME::Lite->new(
                 From     => $from,
                 To       => $to,
                 Subject  => $subject,
                 Data     => $message
                 );
  $msg->attr("content-type" => "text/html"); 
  $msg->send('smtp','mail.saestars.com', AuthUser=>'reports@saestars.com', AuthPass=>'reports@saestars.com');
  return ("Email Sent Successfully to $to\n");

}

sub _sendMail_TEXT(){
    my ($self, $to, $from, $subject, $message) = @_;
    if ($to eq $from){$from = 'reports@saestars.com'}
    $msg = MIME::Lite->new(
                 From     => $from,
                 To       => $to,
                 Subject  => $subject,
                 Data     => $message
                 );
  $msg->send('smtp','mail.saestars.com', AuthUser=>'reports@saestars.com', AuthPass=>'reports@saestars.com');
  return ("Email Sent Successfully to $to\n");

}

sub _sendMail (){
    my ($self, $to, $from, $subject, $message) = @_;
    # $to = $u;
    # $from = 'aerogeek@saestars.com';
    # $subject = 'Test Email 2';
    # $message = '<html><body><h1>This is test email sent by Perl Script</h1></body></html>';
     
    open(MAIL, "|/usr/sbin/sendmail -t");
     
    # Email Header
    print MAIL "To: $to\n";
    print MAIL "From: $from\n";
    print MAIL "Subject: $subject\n";
    print MAIL "MIME-Version: 1.0\n";
    print (MAIL "Content-Type: text/html\n\n");
    # Email Body
    print MAIL $message;
    close(MAIL);
    $str .= "$to\n$from\n$subject\n$message\n";
    return ($str."\n\nEmail Sent Successfully\n");
}

sub _getWelcomeEmailText(){
	my ($self, $txFirstName, $email, $txPassword) = @_;
	my $str;
	my $password = substr($txPassword,0,2)."*" x 6;
	$str = qq(<!DOCTYPE html>
<html>
<style>
.w3-container, .w3-panel {padding: 0.01em 16px;}
.w3-center, .w3-bar {display: inline-block; width: auto;}
.w3-border-0 {border: 0 !important;}
.w3-border {border: 1px solid #ccc !important;}
.w3-border-top {border-top: 1px solid #ccc !important;}
.w3-border-bottom {border-bottom: 1px solid #ccc !important;}
.w3-border-left {border-left: 1px solid #ccc !important;}
.w3-border-right {border-right: 1px solid #ccc !important;}
.w3-round-small {border-radius: 2px;}
.w3-round, .w3-round-medium {border-radius: 4px;}
.w3-round-large {border-radius: 8px;}
.w3-round-xlarge {border-radius: 16px;}
.w3-round-xxlarge {border-radius: 32px;}
.w3-card,.w3-card-2 {box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.16), 0 2px 10px 0 rgba(0, 0, 0, 0.12);}
.w3-card-4,.w3-hover-shadow:hover {box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);}
.w3-light-grey, .w3-hover-light-grey:hover, .w3-light-gray, .w3-hover-light-gray:hover {  color: #000 !important;
  background-color: #f1f1f1 !important;
}
.w3-white,
.w3-hover-white:hover {
  color: #000 !important;
  background-color: #fff !important;
}
</style>
  <body class="w3-light-grey" >
    <img src="https://www.saestars.com/images/aero_r_blu_spot.png" height="75"><br><br> 
    <div class="w3-container w3-border w3-round w3-card w3-white" style="font-size: 1.25em;">

      <h1>Welcome to SAE-STARS</h1>
      <h3>$txFirstName, thank you for signing up for an account</h3>
      <p>STARS (<b>S</b>core <b>T</b>racking <b>A</b>nd <b>R</b>ecording <b>S</b>ystem) is a web-application used to record real-time scoring information and team feedback for the SAE Aero-Design Competition!</br></p> 
      <p>SAE <a href="https://www.saestars.com">saestars.com</a> was developed to help teams work together on a 
      whole different level.  Over the years, the AERO-DESIGN Rules Committee has worked around the clock to improve the Aero-Design experience.  This tool has evolved to provide competition participants with real-time scoring statistics, flight status, and valuable feedback from the Judges around the country.</p>
      <p>This web application will help you focus on a winning strategy for your team while keeping a close eye on your team’s progress and standings.  Set and track your event scores by obtaining your personalized team code from the SAE Competition Scoring Judge.</p>

    <ol>NEXT STEP<br>
    <li><b>Obtain Team Code from the SAE Competition Scoring Judge</b></li>
    <li>Login to your account at <a href="https://www.saestars.com">saestars.com</a>
    <ol><li>Enter your email: $email</li>
    <li>Enter your password: $password</li>
    <li>Click on the <b>event</b> from the drop-down selection</li>
    <li>Click [ Sign-In ]</li>
    </ol></li>
    <li>Enter Subscription Code provided by your SAE Competition Scoring Judge</li></ol>
    <li>Click on [ <b>Subscribe +</b> ]</li>
    </ol>
    <h4>That's it!... You're In!</h4> 

      <p>All the best,<br>Aero Design Scoring Judge</p>
    </div>
  </body>
</html>
);
}

sub _getPasswordResetText (){
	my ($self, $userLogin, $userPassword) = @_;
    my $str;
    $str = qq( <!DOCTYPE html>
<html>
<style>
.w3-container, .w3-panel {padding: 0.01em 16px;}
.w3-center, .w3-bar {display: inline-block; width: auto;}
.w3-border-0 {border: 0 !important;}
.w3-border {border: 1px solid #ccc !important;}
.w3-border-top {border-top: 1px solid #ccc !important;}
.w3-border-bottom {border-bottom: 1px solid #ccc !important;}
.w3-border-left {border-left: 1px solid #ccc !important;}
.w3-border-right {border-right: 1px solid #ccc !important;}
.w3-round-small {border-radius: 2px;}
.w3-round, .w3-round-medium {border-radius: 4px;}
.w3-round-large {border-radius: 8px;}
.w3-round-xlarge {border-radius: 16px;}
.w3-round-xxlarge {border-radius: 32px;}
.w3-card,.w3-card-2 {box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.16), 0 2px 10px 0 rgba(0, 0, 0, 0.12);}
.w3-card-4,.w3-hover-shadow:hover {box-shadow: 0 4px 10px 0 rgba(0, 0, 0, 0.2), 0 4px 20px 0 rgba(0, 0, 0, 0.19);}
.w3-light-grey,
.w3-hover-light-grey:hover,
.w3-light-gray,
.w3-hover-light-gray:hover {
  color: #000 !important;
  background-color: #f1f1f1 !important;
}
.w3-white,
.w3-hover-white:hover {
  color: #000 !important;
  background-color: #fff !important;
}
</style>
  <body class="w3-light-grey">
  <img src="https://www.saestars.com/images/aero_r_blu_spot.png" height="75"><br><br> 
    <div class="w3-container w3-border w3-round w3-card w3-white w3-center">
      <h1>Password Reset</h1>
      <p>Someone has requested a password reset. If you didn't make this change or if you believe an unauthorized person has accessed your account, please see an SAE Scoring Judge immediately.</p>
      <p>Your Login ID is:  <b>$userLogin</b></p>
      <p>Your Temporaty Password is: <b>$userPassword</b> </p>
      <p>Please goto: <a href="https://www.saestars.com">https://www.saestars.com</a><br><br><i>Upon Sign-In, you will be prompted to change your temporary password.  Please select a password that you will remember.</i></p>
      <p>Best,<br>Aero Design Scoring Judge</p>
    </div>
  </body>
</html>
	);
    return ($str);
}