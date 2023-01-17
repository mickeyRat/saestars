#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

#---- SAE MODULES -------
use SAE::USER;
use SAE::PROFILE;
$q = new CGI;
$qs = new CGI({'QUERY_STRING'});
my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
sub export_allEmailExcel (){
	my $eventIDX= $q->param('eventIDX');
	# my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header(-type=>'application/vnd.ms-excel',
                 -'Content-Disposition'=>'attachment; filename="allEmail.csv"'
                 # -'Content-Transfer-Encoding' => "binary"
                 );
    my $str;
    my $Profile  = new SAE::PROFILE();
    my %USERS    = %{$Profile ->_getUsers()};
    $str .= " First Name, Last Name, Email, Exp. Level, School Affiliation\n";
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME}) } keys %USERS) {
    	$str .= sprintf "%s,", $USERS{$userIDX}{TX_FIRST_NAME};
		$str .= sprintf "%s,", $USERS{$userIDX}{TX_LAST_NAME};
		$str .= sprintf "%-45s,", $USERS{$userIDX}{TX_EMAIL};
		$str .= sprintf "%d,", $USERS{$userIDX}{TX_YEAR};
		$str .= sprintf "%-75s", $USERS{$userIDX}{TX_SCHOOL};
		$str .= "\n";
    }
    return ($str);
	}
sub export_emailExcel(){
	print $q->header(-type=>'application/vnd.ms-excel',
                 -'Content-Disposition'=>'attachment; filename="volunteerEventEmails.csv"'
                 # -'Content-Transfer-Encoding' => "binary"
                 );
	my %CLASS    = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
	my %STATUS   = (''=>'-', 0=>'-', 1=>'Yes');
	my @tm       = localtime();
    my $txYear   = ($tm[5] + 1900);
	my $eventIDX = $q->param('eventIDX');
	# my $Users    = new SAE::USER();
	my $Profile  = new SAE::PROFILE();
	my %USERS    = %{$Profile ->_getUsers()};
	my %LIST     = %{$Profile->_getJudges($txYear)};

	my $str;
	$str .= " First Name, Last Name, Email, East, West, Regular, Advanced, Micro, Drawing, TDS, Requirements, Presentation\n";
	# $str .= " First Name, Last Name, Email, Regular Class, Advanced Class, Micro Class, Drawings, TDS, REQ, Preso\n";
	foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME}) } keys %USERS) {
		# my %CLASS_PREF = %{$Users->_getClassPreference($userIDX, $eventIDX)};
		if (!exists $LIST{$userIDX}){next}
		$str .= sprintf "%s,", $USERS{$userIDX}{TX_FIRST_NAME};
		$str .= sprintf "%s,", $USERS{$userIDX}{TX_LAST_NAME};
		$str .= sprintf "%s,", $USERS{$userIDX}{TX_EMAIL};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_EAST}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_WEST}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_REGULAR}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_ADVANCE}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_MICRO}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_DRW}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_TDS}};
		$str .= sprintf "%s,", $STATUS{$LIST{$userIDX}{BO_REQ}};
		$str .= sprintf "%s", $STATUS{$LIST{$userIDX}{BO_PRESO}};
		# foreach $classIDX (sort {$a <=> $b} keys %CLASS) {
		# 	if (exists $CLASS_PREF{$classIDX}){$str .= ',Yes'} else {
		# 		$str .= ',---';
		# 	}
		# }
		$str .= "\n";
	}
	return($str);
	}
sub export_volunteerEmailFormat (){
	my	$str;
    print $q->header(-type=>'application/octet-stream',-charset=>'UTF-8',
                 -'Content-Disposition'=>'attachment; filename="volunteerEventEmails.txt"'
                 );
	my @tm       = localtime();
    my $txYear   = ($tm[5] + 1900);
	my $eventIDX = $q->param('eventIDX');
	# my $Users    = new SAE::USER();
	my $Profile  = new SAE::PROFILE();
	my %USERS    = %{$Profile ->_getUsers()};
	my %LIST     = %{$Profile->_getJudges($txYear)};

	foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME}) } keys %USERS) {
		if (!exists $LIST{$userIDX}){next}
		$str .= sprintf '%s; ', $USERS{$userIDX}{TX_EMAIL};
	}
    return ($str);
    }




