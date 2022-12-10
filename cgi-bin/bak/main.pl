#!/usr/bin/perl
use cPanelUserConfig;

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Auth;

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
sub updateUserAccess(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $userIDX = $q->param('userIDX');
    my $access = $q->param('access');
    my @data = split(",",$access);
    my $SQL = "DELETE FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $delete = $dbi->prepare($SQL);
    $delete->execute($userIDX);
    $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
    foreach $tilesIDX (sort @data){
        $insert->execute($tilesIDX, $userIDX);
    }
    return (@data);
}

sub getUserAccess(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $userIDX = $q->param('userIDX');
    my $SQL = "SELECT FK_TILES_IDX FROM TB_ACCESS WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($userIDX);
    %DATA = %{$select->fetchall_hashref('FK_TILES_IDX')};
    my $json = encode_json \%DATA;
    return ($json);
}
sub openItem13_ManageUsers(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $str;
    my $SQL = "SELECT PK_USER_IDX, TX_FIRST_NAME, TX_LAST_NAME FROM TB_USER";
    my $select = $dbi->prepare($SQL);
    $select->execute();
    %USERS = %{$select->fetchall_hashref('PK_USER_IDX')};
    $SQL = "SELECT PK_TILES_IDX, TX_TITLE, IN_ORDER, IN_TYPE FROM TB_TILES";
    $select = $dbi->prepare($SQL);
    $select->execute();
    %TILES = %{$select->fetchall_hashref(['IN_TYPE','PK_TILES_IDX'])};
    $str .= '<div class="w3-container w3-blue w3-round-medium w3-padding " style="margin-top: 8px;"> ';
    $str .= '<label>Select User</label>';
    $str .= '<select ID="manageUserDropdown" class="w3-select" name="option" onmousedown="if(this.options.length>15){this.size=15;}"  onchange="this.size=0;getUserAccess(this.value);" onblur="this.size=0;">';
    $str .= '<option value="" disabled selected>Choose your option</option>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $str .= '<option value="'.$userIDX.'">'.$USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME}.'</option>';
    }
    $str .= '</select>';
    $str .= '</div>';
    $str .= '<h4 class="w3-xxlarge w3-margin-left">Grant Access For: <span class="w3-bold w3-text-blue" id="grantAccessName">&lt;Select a Name&gt;</span></h4>';
    $str .= '<div class="w3-row-padding  w3-margin-bottom">';
    $str .= '<div class="w3-third">';
    $str .= '<div class="w3-container w3-green w3-padding-16">';
    $str .= '<div class="w3-left"><i class="fa fa-low-vision w3-xxxlarge"></i></div>';
    $str .= '<div class="w3-right">';
    # $str .= '<h3>Score</h3>';
    $str .= '</div>';
    $str .= '<div class="w3-clear w3-margin-left"></div>';
    $str .= '<h4>Students</h4>';
    $str .= '<div class="w3-white w3-hover-border-blue w3-border w3-padding w3-shadow" style="min-height: 350px;">';
    $str .= '<input id="AllStudentAccess" type="checkbox" value="0" class="w3-check saeAccess" onclick="toggleSelection(\'sae-StudentAccess\', this);"><label for="AllStudentAccess">Select All</label><hr>';
    # $str .= '<input type="checkbox" class="w3-check " check="checked" disabled><label class="w3-disabled">Read Only</label><br>';
    foreach $pkTilesIdx (sort {$TILES{0}{$a}{IN_ORDER} <=> $TILES{0}{$b}{IN_ORDER}} keys %{$TILES{0}}){
        $str .= '<input ID="StudentAccess_'.$pkTilesIdx.'" class="w3-check sae-StudentAccess saeAccess" type="checkbox" value="'.$pkTilesIdx.'"><label for="StudentAccess_'.$pkTilesIdx.'">'.$TILES{0}{$pkTilesIdx}{TX_TITLE}.' (Read Only)</label><br>';
    }
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-third">';
    $str .= '<div class="w3-container w3-green w3-padding-16">';
    $str .= '<div class="w3-left"><i class="fa fa-low-vision  w3-xxxlarge"></i></div>';
    $str .= '<div class="w3-right">';
    # $str .= '<h3>Score</h3>';
    $str .= '</div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= '<h4>Judge</h4>';
    $str .= '<div class="w3-white w3-hover-border-blue w3-border w3-padding" style="min-height: 350px;">';
    $str .= '<input id="AllJudgeAccess" type="checkbox" value="0" class="w3-check saeAccess" onclick="toggleSelection(\'sae-JudgeAccess\', this);"><label for="AllJudgeAccess">Select All</label><hr>';
    foreach $pkTilesIdx (sort {$TILES{1}{$a}{IN_ORDER} <=> $TILES{1}{$b}{IN_ORDER}} keys %{$TILES{1}}){
        $str .= '<input ID="JudgeAccess_'.$pkTilesIdx.'" class="w3-check sae-JudgeAccess saeAccess" type="checkbox" value="'.$pkTilesIdx.'"><label for="JudgeAccess_'.$pkTilesIdx.'">'.$TILES{1}{$pkTilesIdx}{TX_TITLE}.'</label><br>';
    }
    $str .= '</div>';
    $str .= '</div>';

    $str .= '</div>';

    $str .= '<div class="w3-third">';
    $str .= '<div class="w3-container w3-green w3-padding-16">';
    $str .= '<div class="w3-left"><i class="fa fa-low-vision  w3-xxxlarge"></i></div>';
    $str .= '<div class="w3-right">';
    # $str .= '<h3>Score</h3>';
    $str .= '</div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= '<h4>Admin</h4>';
    $str .= '<div class="w3-white w3-border w3-hover-border-blue w3-padding" style="min-height: 350px;">';
    $str .= '<input ID="AllAdminAccess" type="checkbox" value="0" class="w3-check saeAccess" onclick="toggleSelection(\'sae-AdminAccess\', this);"><label for="AllAdminAccess">Select All</label><hr>';
    foreach $pkTilesIdx (sort {$TILES{4}{$a}{IN_ORDER} <=> $TILES{4}{$b}{IN_ORDER}} keys %{$TILES{4}}){
        $str .= '<input ID="AdminAccess_'.$pkTilesIdx.'" class="w3-check sae-AdminAccess saeAccess" type="checkbox" value="'.$pkTilesIdx.'"><label for="AdminAccess_'.$pkTilesIdx.'">'.$TILES{4}{$pkTilesIdx}{TX_TITLE}.'</label><br>';
    }
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '<div class="w3-clear"></div>';
    $str .= '<center class="w3-padding">';
    $str .= '<div class="w3-button w3-round-large w3-border w3-green  w3-margin-left" style="width: 130px;" onclick="updateUserAccess();">Save</div>';
    $str .= '<div class="w3-button w3-round-large w3-border w3-orange w3-margin-left" style="width:130px;" onclick="goHome();">Cancel</div>';
    $str .= '<div class="w3-button w3-round-large w3-border w3-red    w3-margin-left" style="width: 130px;" >Delete User</div>';
    $str .= '</center>';
    $str .= '</div>';
    return ($str);
}
sub loadMenuItems(){
    print $q->header();
    my $userIDX = $q->param('userIDX');
    my $Auth = new SAE::Auth();
    $str = $Auth->_getMenuItem($userIDX );
    return ($str);
}

