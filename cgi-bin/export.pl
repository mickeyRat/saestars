#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

#---- SAE MODULES -------
use SAE::USER;
$q = new CGI;
$qs = new CGI({'QUERY_STRING'});
my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
sub export_emailExcel(){
	print $q->header(-type=>'application/vnd.ms-excel',
                 -'Content-Disposition'=>'attachment; filename="volunteerEventEmails.csv"'
                 # -'Content-Transfer-Encoding' => "binary"
                 );
	my %CLASS = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
	my $eventIDX= $q->param('eventIDX');
	my $Users = new SAE::USER();
	my %LIST  = %{$Users->_getEventJudges($eventIDX)}; 
	my	$str;
	$str .= " First Name, Last Name, Email, Regular Class, Advanced Class, Micro Class\n";
	foreach $userIDX (sort {lc($LIST{$a}{TX_LAST_NAME}) cmp lc($LIST{$b}{TX_LAST_NAME}) } keys %LIST) {
		my %CLASS_PREF = %{$Users->_getClassPreference($userIDX, $eventIDX)};
		$str .= sprintf "%s,", $LIST{$userIDX}{TX_FIRST_NAME};
		$str .= sprintf "%s,", $LIST{$userIDX}{TX_LAST_NAME};
		$str .= sprintf "%s", $LIST{$userIDX}{TX_EMAIL};
		foreach $classIDX (sort {$a <=> $b} keys %CLASS) {
			if (exists $CLASS_PREF{$classIDX}){$str .= ',Yes'} else {
				$str .= ',---';
			}
		}
		$str .= "\n";
	}
	return($str);
}

sub export_volunteerEmailFormat (){
	my	$str;
    print $q->header(-type=>'application/octet-stream',-charset=>'UTF-8',
                 -'Content-Disposition'=>'attachment; filename="volunteerEventEmails.txt"'
                 );

	my $eventIDX= $q->param('eventIDX');
	my $Users = new SAE::USER();
	my %LIST  = %{$Users->_getEventJudges($eventIDX)}; 
	foreach $userIDX (sort {lc($LIST{$a}{TX_LAST_NAME}) cmp lc($LIST{$b}{TX_LAST_NAME}) } keys %LIST) {
		$str .= sprintf '%s; ', $LIST{$userIDX}{TX_EMAIL};
	}
	# print $str;
    return ($str);
    }




