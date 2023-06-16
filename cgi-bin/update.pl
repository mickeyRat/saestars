#!/usr/bin/perlml
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
use JSON;
use Data::Dumper;
use Mail::Sendmail;

use DBI;
use SAE::SDB;
my $dbi = new SAE::Db();

use SAE::Auth;
use SAE::TB_TEAM;
# use Time::Local;
# use Time::Local;
@ARGV;

&_updateAccess($ARGV[0]);


exit;

sub _updateAccess() {
    my ($tileIDX) = @_;
    my $SQL    = "SELECT PK_USER_IDX FROM TB_USER WHERE IN_USER_TYPE>=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(4);
    my %USERS  = %{$select->fetchall_hashref('PK_USER_IDX')};

    my $SQL_ACCESS   = "SELECT FK_USER_IDX FROM TB_ACCESS WHERE FK_TILES_IDX=?";
    my $selectAccess = $dbi->prepare($SQL_ACCESS);
       $selectAccess->execute($tileIDX);
    my %ACCESS       = %{$selectAccess->fetchall_hashref('FK_USER_IDX')};

    my $SQL_ADD = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) VALUES (?, ?)";
    my $insert  = $dbi->prepare($SQL_ADD);

    foreach $userIDX (sort {$a<=>$b} keys %USERS) {
        if (!exists $ACCESS{$userIDX}) {
            $insert->execute($tileIDX, $userIDX);
            printf "Added Access to tile %d for %d\n", $tileIDX, $userIDX;
        } 
    }
    print "\n\n\a";
}

sub _updateSubscriptionCode (){
    my ($eventIDX) = @_;
    my $Auth  = new SAE::Auth();
    my %TEAMS = %{$Auth->_getTeams($eventIDX)};

    my $SQL = "UPDATE TB_TEAM SET TX_CODE=? WHERE PK_TEAM_IDX=?";
    my $update = $dbi->prepare( $SQL );
       
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $code = $Auth->_getSubscriptionCode(6);
        printf "%10d, %03d, %d\n", $teamIDX, $TEAMS{$teamIDX}{IN_NUMBER}, $code;
        $update->execute($code, $teamIDX);
    }
    print "\n\n";
    return;
    }

return;
