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
use Number::Format 'format_price';
# use HTML::Entities;

#---- SAE MODULES -------
use SAE::SDB;
use SAE::Common;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::TB_PAPER;
use SAE::TB_COMMENT;
use SAE::TB_COMMENT_TEMP;
use SAE::TB_UPLOAD;
use SAE::TB_SCORE_GROUP;
use SAE::TB_SCORE;
use SAE::TB_USER_TEAM;
use SAE::REGULAR;
use SAE::Auth;
use SAE::Tabulate;
use SAE::STUDENT;
use SAE::TECH;

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
# ================= 2022 ==============================
sub student_updateCheckItem (){
    print $q->header();
    my $teamIDX= $q->param('teamIDX');
    my $userIDX= $q->param('userIDX');
    my $inStatus= $q->param('inStatus');
    my $itemIDX= $q->param('itemIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Student = new SAE::STUDENT();
    my $str = $Student->_submitTechInspectionStatus($teamIDX, $itemIDX, $inStatus, $userIDX);
    return ($str);
    }
sub student_openSafetyChecks (){
    my $userIDX   = $q->param('userIDX');
    my $teamIDX   = $q->param('teamIDX');
    my $classIDX  = $q->param('classIDX');
    my $txType="safetySectionNumber";
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Student     = new SAE::STUDENT();
    my $Tech        = new SAE::TECH();
    my %HEAD        = %{$Tech->_getSectionHeading($txType)};
    my %LIST        = %{$Student->_getListOfSafetyItems($teamIDX, $classIDX, $txType)};
    my %TECH        = %{$Tech->_getTeamTechList($teamIDX)};
    my %STATUS     = (''=>'Not Started', 0=>'Not Started', 1=>'Pending', 2=>'Failed', 3=>'Passed');
    # my %COLOR       = (''=>'w3-text-black', 0=>'w3-text-black', 1=>'w3-text-black', 2=>'w3-text-red', 3=>'w3-text-blue');
    my %BGCOLOR     = (''=>'w3-light-grey', 0=>'w3-light-grey', 1=>'w3-light-grey', 2=>'w3-red', 3=>'w3-blue');
    my $str;
    $str .= '<div class="w3-container" style="overflow-y: auto;">';
    $str .= '<h5 class="w3-container w3-border w3-round w3-border-red w3-pale-yellow w3-padding"><b>Self-Certification</b> means the team has certified that the safety and air-worthiness is in compliance with established guidelines</h5>';
    $str .= '<ul class="w3-ul">';
    foreach $headingIDX (sort {$HEAD{$a}{IN_SECTION} <=> $HEAD{$b}{IN_SECTION}} keys %HEAD) {
        $str .= '<div class="w3-container w3-light-grey w3-card w3-margin-bottom">';
            my $inHeading = $HEAD{$headingIDX}{IN_SECTION};
            $str .= sprintf '<h4 class="w3-strong">';
            $str .= sprintf '<b>%d - %s</b>', $HEAD{$headingIDX}{IN_SECTION}, $HEAD{$headingIDX}{TX_SECTION};
            $str .= '</h4>';
            foreach $itemIDX (sort {$LIST{$headingIDX}{$a}{IN_SECTION} <=> $LIST{$headingIDX}{$b}{IN_SECTION}} keys %{$LIST{$headingIDX}}) {
                my $checked = '';
                if ($LIST{$headingIDX}{$itemIDX}{BO_CHECK} == 1){$checked = 'checked'}
                $str .= '<label for="ITEM_'.$itemIDX.'" >';
                $str .= '<li class="w3-bar w3-display-container w3-border w3-white w3-round w3-margin-bottom w3-hover-pale-yellow">';
                $str .= '<div class="w3-container">';
                $str .= sprintf '<label>%d.%s - %s</label><br>',$inHeading, $LIST{$headingIDX}{$itemIDX}{IN_SECTION},$LIST{$headingIDX}{$itemIDX}{TX_SECTION};
                $str .= '<input ID="ITEM_'.$itemIDX.'" '.$checked.' class="w3-check " data-field="BO_CHECK" data-index="'.$itemIDX.'" type="checkbox" onchange="student_updateCheckItem(this, '.$teamIDX.');">';
                $str .= '<label class="w3-margin-left">Student Reviewed & Inspected</label><br>';
                $str .= '</div>';
                $str .= sprintf '<div class="w3-container %s w3-border w3-round  w3-margin-top w3-padding" >Official Assessment by SAE Inspectors: <b>%s</b></div>', $BGCOLOR{$TECH{$itemIDX}{IN_STATUS}}, $STATUS{$TECH{$itemIDX}{IN_STATUS}};
                $str .= '</li>';
                $str .= '</label>';
            }
        $str .= '</div>';
    }
    $str .= '</ul>';
    $str .= '<br>'x 5;
    $str .= '</div>';
    return ($str);
    }
sub student_openRequirementsChecks (){
    my $userIDX   = $q->param('userIDX');
    my $teamIDX   = $q->param('teamIDX');
    my $classIDX  = $q->param('classIDX');
    my $txType="reqSectionNumber";
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Student     = new SAE::STUDENT();
    my $Tech        = new SAE::TECH();
    my %HEAD        = %{$Tech->_getSectionHeading($txType)};
    my %LIST        = %{$Student->_getListOfSafetyItems($teamIDX, $classIDX, $txType)};
    my %TECH        = %{$Tech->_getTeamTechList($teamIDX)};
    my %STATUS     = (''=>'Not Started', 0=>'Not Started', 1=>'Pending', 2=>'Failed', 3=>'Passed');
    # my %COLOR       = (''=>'w3-text-black', 0=>'w3-text-black', 1=>'w3-text-black', 2=>'w3-text-red', 3=>'w3-text-blue');
    my %BGCOLOR     = (''=>'w3-light-grey', 0=>'w3-light-grey', 1=>'w3-light-grey', 2=>'w3-red', 3=>'w3-blue');
    my $str;
    $str .= '<div class="w3-container" style="overflow-y: auto;">';
    $str .= '<h5 class="w3-container w3-border w3-round w3-border-red w3-pale-yellow w3-padding"><b>Self-Certification</b> means the team has certified that the requirement line-item is in compliance with the rules</h5>';
    $str .= '<ul class="w3-ul">';
    foreach $headingIDX (sort {$HEAD{$a}{IN_SECTION} <=> $HEAD{$b}{IN_SECTION}} keys %HEAD) {
        $str .= '<div class="w3-container w3-light-grey w3-card w3-margin-bottom">';
            my $inHeading = $HEAD{$headingIDX}{IN_SECTION};
            $str .= sprintf '<h4 class="w3-strong">';
            $str .= sprintf '<b>%d - %s</b>', $HEAD{$headingIDX}{IN_SECTION}, $HEAD{$headingIDX}{TX_SECTION};
            $str .= '</h4>';
            foreach $itemIDX (sort {$LIST{$headingIDX}{$a}{IN_SECTION} <=> $LIST{$headingIDX}{$b}{IN_SECTION}} keys %{$LIST{$headingIDX}}) {
                my $checked = '';
                if ($LIST{$headingIDX}{$itemIDX}{BO_CHECK} == 1){$checked = 'checked'}
                $str .= '<label for="ITEM_'.$itemIDX.'" >';
                $str .= '<li class="w3-bar w3-display-container w3-border w3-white w3-round w3-margin-bottom w3-hover-pale-yellow">';
                $str .= '<div class="w3-container">';
                $str .= sprintf '<label>%d.%s - %s</label><br>',$inHeading, $LIST{$headingIDX}{$itemIDX}{IN_SECTION},$LIST{$headingIDX}{$itemIDX}{TX_SECTION};
                $str .= '<input ID="ITEM_'.$itemIDX.'" '.$checked.' class="w3-check " data-field="BO_CHECK" data-index="'.$itemIDX.'" type="checkbox" onchange="student_updateCheckItem(this, '.$teamIDX.');">';
                $str .= '<label class="w3-margin-left">In Compliance</label><br>';
                $str .= '</div>';
                $str .= sprintf '<div class="w3-container %s w3-border w3-round w3-margin-top w3-padding" >Official Assessment by SAE Inspectors: <b>%s</b></div>', $BGCOLOR{$TECH{$itemIDX}{IN_STATUS}}, $STATUS{$TECH{$itemIDX}{IN_STATUS}};
                $str .= '</li>';
                $str .= '</label>';
            }
        $str .= '</div>';
    }
    $str .= '</ul>';
    $str .= '<br>'x 5;
    $str .= '</div>';
    return ($str);
    }
# ================= 2022 ==============================
sub __template(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $str;
    $location = $q->param('location');
    my $str;

    return ($str);
}
sub submitTeamCode(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $auth = new SAE::Auth();
    my $str;
    my %DATA;
    $location = $q->param('location');
    $PkUserIdx = $q->param('PkUserIdx');
    $txTeamCode = $q->param('txTeamCode');
    $teamIDX = $auth->_findTeamCodeMatch($location, $txTeamCode);
    $DATA{TEAM} = $teamIDX;
    if ( $teamIDX  != 0){
        $SQL = "INSERT INTO TB_USER_TEAM (FK_USER_IDX, FK_TEAM_IDX) VALUES (?, ?)";
        my $insert = $dbi->prepare($SQL);
        $insert->execute($PkUserIdx, $teamIDX);
#         $DATA{TEAM} = 1;
        $DATA{DATA} = &_templateMembershipList($PkUserIdx);
        $DATA{OVERVIEW} = &_templateTeamMembershipOverview($PkUserIdx, $location);
    } else {
        $DATA{DATA} = 'Invalid Team Code';
    }
    my $json = encode_json \%DATA;
    return ($json);
}
sub _templateMembershipList(){
    my $PkUserIdx = shift;
    my $dbi = new SAE::Db();
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_NAME, TEAM.TX_SCHOOL FROM TB_USER_TEAM AS UT JOIN TB_TEAM AS TEAM ON TEAM.PK_TEAM_IDX=UT.FK_TEAM_IDX WHERE UT.FK_USER_IDX=?";
    $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    my $str;
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        $str .= '&nbsp;<span class="w3-tag w3-small subscription_'.$teamIDX.'"><a class="w3-link" href="#TEAM_'.$teamIDX.'">#'.substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'</a></span>';
    }
    return ($str);
}
sub unsubscribeTeam(){
    print $q->header();
    $PkUserIdx = $q->param('PkUserIdx');
    $PkTeamIdx = $q->param('PkTeamIdx');
    my $dbi = new SAE::Db();
    my $SQL = "DELETE FROM TB_USER_TEAM WHERE (FK_TEAM_IDX=? AND FK_USER_IDX=?)";
    my $delete = $dbi->prepare($SQL);
    $delete->execute($PkTeamIdx, $PkUserIdx);
    return ($delete->rows());
}
sub _templateTeamMembershipOverview(){
    $PkUserIdx = shift;
    $PkEventIdx = shift;
    my $str;
    my $dbi = new SAE::Db();
    $SQL = "SELECT TEAM.PK_TEAM_IDX, TEAM.FK_CLASS_IDX, TEAM.TX_SCHOOL, TEAM.IN_NUMBER FROM TB_USER_TEAM AS UT JOIN TB_TEAM AS TEAM ON TEAM.PK_TEAM_IDX=UT.FK_TEAM_IDX WHERE UT.FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    my %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

#     $str .= "--- $PkUserIdx, $PkEventIdx<br>$SQL<br>";

    $SQL = "SELECT FK_CLASS_IDX, max(IN_ROUND) AS MAX_ROUND FROM TB_PUBLISH WHERE FK_EVENT_IDX=? AND IN_SHOW=? AND FK_SCORE_EVENT_IDX=? GROUP BY FK_CLASS_IDX";
    $select = $dbi->prepare($SQL);
    $select->execute($PkEventIdx, 1, 3);
    %ROUND = %{$select->fetchall_hashref(['FK_CLASS_IDX'])};
    my $tab = new SAE::Tabulate();
    my $reg = new SAE::REGULAR();
#     $str .= scalar(keys %TEAM);

    foreach $teamIDX (sort keys %TEAM) {
        $teamNumber = substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3);
        $teamSchool = $TEAM{$teamIDX}{TX_SCHOOL};
        $teamClass = $TEAM{$teamIDX}{FK_CLASS_IDX};
        $maxRound = $ROUND{$teamClass}{MAX_ROUND};
        $desginScore = $tab->getDesignScoreByTeam($teamIDX, $teamClass, $PkEventIdx);
        $presoScore = $tab->getPresentationScoreByTeam($teamIDX, $teamClass, $PkEventIdx);
        $demoScore = $tab->getDemoScoreByTeam($teamIDX, $teamClass, $PkEventIdx);
        $penaltyScore = $tab->getPenaltyByTeam($teamIDX, $teamClass, $PkEventIdx);
        $flightScore = $reg->getRegularFinalFlightScoreUpToRound($teamIDX, $maxRound);
#         $flightScore = $tab->getFlightScoreByTeam($teamIDX, $teamClass, $PkEventIdx, $maxRound);
        if ($teamClass == 1){
            $maxDemo = 3;
        } elsif ($teamClass == 2) {
            $maxDemo = 1;
        } elsif ($teamClass == 3) {
            $maxDemo = 40;
        }
#         $str .= $teamIDX.'<br>';
        $eIDX = crypt($teamIDX,'19');
        $str .= '<a name="TEAM_'.$teamIDX.'"></a><div class="w3-card w3-round w3-white subscription_'.$teamIDX.'">';
        $str .= '<div class="w3-container w3-display-container">';
        $str .= '<a class="w3-button w3-display-topright" onclick="unsubscribeTeam('.$teamIDX.','.$PkUserIdx.');">&times;</a>';
        $str .= '<p class="w3-large"><b><i class="fa fa-asterisk fa-fw w3-margin-right w3-text-teal"></i>Team #'.$teamNumber.'</b><br><span class="w3-small">'.$teamSchool.'</span></p>';
        $str .= &_templateLeftPanel('<a class="w3-link" href="score.html?teamIDX='.$eIDX.'&doc=requirements,tds,drawing,report&rnd=0" target="_blank">Design Reports</a>',$desginScore,50,0);
        if ($teamClass  == 1) {
            $str .= &_templateLeftPanel('<a class="w3-link" href="score.html?teamIDX='.$eIDX.'&doc=presentation,demo&rnd=0" target="_blank">Presentations</a>',$presoScore,50,0);
        } else {
            $str .= &_templateLeftPanel('<a class="w3-link" href="score.html?teamIDX='.$eIDX.'&doc=presentation&rnd=0" target="_blank">Presentations</a>',$presoScore,50,0);
        }
        $str .= &_templateLeftPanel('<a class="w3-link" href="score.html?teamIDX='.$eIDX.'&doc=demo&rnd=0" target="_blank">Demo</a>',$demoScore,$maxDemo,$teamClass);
        $str .= &_templateLeftPanel('<a class="w3-link" href="score.html?teamIDX='.$eIDX.'&doc=flight&rnd='.$maxRound.'" target="_blank">Flight (after Round '.$maxRound.')</a>',$flightScore,250,0);
        $str .= &_templateLeftPanel('<a class="w3-link" href="score.html?teamIDX='.$eIDX.'&doc=penalty&rnd=0" target="_blank">Penalties</a>',$penaltyScore,50,0);
        $str .= '<br>';
        $str .= '</div>';
    $str .= '</div><br class="subscription_'.$teamIDX.'">';
    }

    return ($str);
}
sub loadLeftPanel(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $str;
    $location = $q->param('location');
    $PkUserIdx = $q->param('PkUserIdx');
    my $SQL = "SELECT TX_FIRST_NAME, TX_LAST_NAME FROM TB_USER WHERE PK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    my ($firstName, $lastName) = $select->fetchrow_array();

    my $str;
    $str = '<div class="w3-card w3-round w3-white w3-margin-top">';
        $str .= '<div class="w3-container">';
        $str .= '<h4 class="w3-center">'.$firstName.' '.$lastName.'</h4>';
        $str .= '<p class="w3-center"><img src="images/avatar_plane2.png" class="w3-circle" style="height:106px;width:106px" alt="Avatar"></p>';
        $str .= '<hr>';
            $str .= 'My Teams<br>';
            $str .= '<div ID="teamMembershipList" class="w3-container">';
            $str .= &_templateMembershipList($PkUserIdx);
            $str .= '</div>';
        $str .= '<br>';
        $str .= '<span class="w3-button w3-border fa fa-plus" style="width: 100%;" onclick="showAddTeamCodeEntry();">&nbsp;Join Team</span>';
        $str .= '<hr>';
            $str .= '<div ID="teamCodeEntry" style="display: none;" class="teamCodeEntry w3-card w3-round w3-white w3-display-container">';
                $str .= '<div class="w3-container">';
                $str .= '<p class="w3-large"><b>Team Code</b>';
                $str .= '<div style="positoin: relative;">';
                $str .= '<input ID="myTeamCode" class="w3-card-2" type="password" style="width: 100%; padding-right: 30px; text-align: center" placeHolder="Team Code">';
                $str .= '<label for="myTeamCode" class="w3-large fa fa-eye-slash" style="right: 30px; position: absolute; top: 68px;" onclick="toggleViewPassword(this);"></label>';
                $str .= '</div>';
                $str .= '<p class="w3-small">You can join a team by requesting to join a team or by entering a special team code.  Team code can be obtained from the SAE staff</p>';
                    $str .= '<div class="w3-row w3-opacity">';
                        $str .= '<div class="w3-half">';
                        $str .= '<button class="w3-button w3-block w3-green w3-section" title="Add" onclick="submitTeamCode('.$PkUserIdx.');"><i class="fa fa-check"></i></button>';
                        $str .= '</div>';
                        $str .= '<div class="w3-half">';
                        $str .= '<button class="w3-button w3-block w3-red w3-section" title="Cancel" onclick="hideAddTeamCodeEntry();"><i class="fa fa-remove"></i></button>';
                        $str .= '</div>';
                    $str .= '</div>';
                $str .= '</div>';
            $str .= '</div>';
        $str .= '</div>';
    $str .= '</div>';
    $str .= '<br>';

    $str .= '<div ID="teamMembershipOverview" class="w3-margin-top">';
    $str .= &_templateTeamMembershipOverview($PkUserIdx, $location);
    $str .= '</div>';
    $SQL = "SELECT TEAM.PK_TEAM_IDX FROM TB_USER_TEAM AS UT JOIN TB_TEAM AS TEAM ON TEAM.PK_TEAM_IDX=UT.FK_TEAM_IDX WHERE UT.FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};
    my %DATA;
    $DATA{HTML} = $str;
    $DATA{LIST} = join(";",keys %TEAM);
    my $json = encode_json \%DATA;
    return ($json);
#     return ($str);
}
sub loadFeed(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $str;
    $location = $q->param('location');
    $list = $q->param('list');
    @LIST = split(";",$list);
    my $myTeamIDX = join(",",@LIST);
    my $SQL = "SELECT * FROM TB_FEED WHERE FK_TEAM_IDX in ($myTeamIDX) OR (BO_PUBLIC=? AND FK_EVENT_IDX=?)";
#     my $SQL = "SELECT * FROM TB_FEED WHERE FK_TEAM_IDX in (646,544,644) OR BO_PUBLIC=1";
    my $select = $dbi->prepare($SQL);
    $select->execute(1, $location);
    %FEED = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
    $SQL = "SELECT PK_TEAM_IDX, IN_NUMBER FROM TB_TEAM WHERE PK_TEAM_IDX in ($myTeamIDX)";
    $select = $dbi->prepare($SQL);
    $select->execute();
    %TEAM = %{$select->fetchall_hashref(['PK_TEAM_IDX'])};

    my $str;
#     $str .= scalar(keys %FEED);
    foreach $feedIDX (sort {$FEED{$b}{TS_CREATE} cmp $FEED{$a}{TS_CREATE}} keys %FEED){
        $teamIDX = $FEED{$feedIDX}{FK_TEAM_IDX};
        if ($teamIDX==0) {
            $title = $FEED{$feedIDX}{TX_TITLE};
        } else {
            $title = 'Team #'. substr("000".$TEAM{$teamIDX}{IN_NUMBER},-3,3).'- ('.$FEED{$feedIDX}{TX_TITLE}.')';
        }
        $str .= &_templateFeed($feedIDX, $title , $FEED{$feedIDX}{TX_FEED}, $FEED{$feedIDX}{TS_CREATE});
    }
    return ($str);

}
# ==================== TEMPLATES ========================
sub _templateRightPanel(){

}
sub _templateLeftPanel(){
    my $title = shift;
    my $points = shift;
    my $max = shift;
    my $FkClassIdx = shift;
    my $str;
    $str = $title;
    $str .= '<div class="w3-light-grey w3-round-xlarge w3-small w3-margin-bottom">';
    if ($FkClassIdx==2){
        my $status = 'Failed';
        if ($points==1){
            $str .= sprintf '<div class="w3-container w3-center w3-round-xlarge w3-blue w3-text-black" style="width:%2.0f%">Passed</div>', 100*($points/$max), $points;
        } else {
            $str .= sprintf '<div class="w3-container w3-center w3-round-xlarge w3-transparent" style="width:%2.0f%">Failed</div>', 100*($points/$max), $points;
        }

    } else {
        if ($points>0){
            $str .= sprintf '<div class="w3-container w3-center w3-round-xlarge w3-blue w3-text-black" style="width:%2.0f%">%2.4f</div>', 100*($points/$max), $points;
        } else {
            $str .= sprintf '<div class="w3-container w3-center w3-round-xlarge w3-transparent" style="width:0%">%2.4f</div>', $points;
        }
    }
    $str .= '</div>';
    return ($str);
}
sub _templateFeed(){
    my $feedIDX = shift;
    my $textTitle = shift;
    my $textFeed = shift;
    my $tsCreate = shift;
    my $str;

    $str .= '<div class="w3-container w3-card w3-white w3-round w3-margin">';
    $str .= '<header class="w3-container">';
    $str .= '<h3 style="margin-bottom: 0px; padding-bottom: 0px;">'.$textTitle.'</h3>';
    $str .= '<span class="w3-small">'.$tsCreate.'</span>';
    $str .= '</header>';
    $str .= '<div class="w3-container">';
    $str .= '<p>'.$textFeed.'</p>';
    $str .= '</div>';
    $str .= '</div>';

    return ($str);
}
# ===================== 2019 ==============================
# ===================== 2018 ==============================
sub viewRoundResults(){
    print $q->header();
    my $PkClassIdx = $q->param('PkClassIdx');
    my $dbi = new SAE::Db();
    my $SQL = "SELECT PK_PUBLISH_IDX, TX_TITLE, TX_FILE, IN_ROUND FROM TB_PUBLISH WHERE FK_CLASS_IDX=? AND IN_SHOW=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkClassIdx, 1);
    my $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    my %RESULT = %{$select->fetchall_hashref(['PK_PUBLISH_IDX'])};
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 >Published Round Results</h2>';
    $str .= '</div>';
#     $str .= '<div class="w3-container">';
    $str .= '<ul class="w3-ul w3-card-4">';
    foreach $PkPublishIdx (sort {$RESULT{$a}{IN_ROUND} <=> $RESULT{$b}{IN_ROUND}} keys %RESULT) {
        $str .= '<li class="w3-bar">';
        $str .= '<div class="w3-bar-item">';
        if ($RESULT{$PkPublishIdx}{IN_ROUND}==0){
            $str .= '<a href="result.html?fileID='.$RESULT{$PkPublishIdx}{TX_FILE}.'" target="_blank">'.$RESULT{$PkPublishIdx}{TX_TITLE}.'</a>';
        } else {
            $str .= '<a href="result.html?fileID='.$RESULT{$PkPublishIdx}{TX_FILE}.'" target="_blank">ROUND '.$RESULT{$PkPublishIdx}{IN_ROUND}.' '.$RESULT{$PkPublishIdx}{TX_TITLE}.'</a>';
        }

        $str .= '</div>';
        $str .= '</li>';
    }
    $str .= '</ul>';
#     $str .= '</div>';

    return ($str);
}
sub viewFlightCards(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $dbi = new SAE::Db();
    my $Tab = new SAE::Tabulate();
    my $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 >Flight Card Summary</h2>';
    $str .= '</div>';
    my $SQL = "SELECT FK_CLASS_IDX, FK_EVENT_IDX FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkTeamIdx);
    my ($PkClassIdx, $PkEventIdx) = $select->fetchrow_array();

    $str .= &_templateFlightScore($PkTeamIdx, $PkClassIdx);
    return ($str);
}
sub viewCardDetail(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $PkClassIdx = $q->param('PkClassIdx');
    my $InRound = $q->param('InRound');
    my $dbi = new SAE::Db();
    my $Tab = new SAE::Tabulate();
    my $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id02\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue">';
    $str .= '<h2 >Flight Card Details</h2>';
    $str .= '</div>';
    if ($PkClassIdx==1){
        $str .= &showRegularClassCard($InRound, $PkTeamIdx, 11);
    } elsif ($PkClassIdx==2) {
        $str .= &showAdvancedClassCard($InRound, $PkTeamIdx, 12);
    } elsif ($PkClassIdx==3) {
        $str .= &showMicroClassCard($InRound, $PkTeamIdx, 13);
    }

    return ($str);
}
sub showRegularClassCard(){
    my ($InRound, $PkTeamIdx, $PkScoreGroupIdx) = @_;
    my $dbi = new SAE::Db();
    my $CAP = 0;
    my $SQL = "SELECT ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, TEAM.IN_CAPACITY FROM TB_SCORE AS SCORE
	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
    JOIN TB_TEAM AS TEAM ON SCORE.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($InRound, $PkTeamIdx, $PkScoreGroupIdx);
    while (my ($Item, $InScore, $Capacity) = $select->fetchrow_array() ) {
        $CARD{$Item}=$InScore;
        $CAP = $Capacity;
    }
    my $Empty = $CAP - $CARD{Load};
    my $fs = (100 * $CARD{Load}) + (50 * $CARD{Cargo}) - (100 * $Empty);
#     if ($fs <0){$fs = 0;}
    my $str;
    $str .= '<table class="w3-table-all w3-border">';
    $str .= '<tr>';
    $str .= '<th>ROUND</th>';
    $str .= '<th class="w3-right-align">Capacity</th>';
    $str .= '<th class="w3-right-align"># of Passengers</th>';
    $str .= '<th class="w3-right-align">Cargo Weight</th>';
    $str .= '<th class="w3-right-align">Flight Score</th>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>'.$InRound.'</td>';
    $str .= '<td class="w3-right-align">'.$CAP.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Load}.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Cargo}.'</td>';
    if ($fs<0) {
        $str .= sprintf '<td class="w3-border w3-right-align"><span class="w3-text-red">($%2.2f)</span> --&gt; $%2.2f</td>', $fs,0;
    } else {
        $str .= sprintf '<td class="w3-border w3-right-align">$%2.2f</td>', $fs;
    }
    $str .= '</tr>';
    $str .= '</table>';
}
sub showAdvancedClassCard(){
    my ($InRound, $PkTeamIdx, $PkScoreGroupIdx) = @_;
    my $dbi = new SAE::Db();
    my $SQL = "SELECT ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, ITEM.IN_PERCENT FROM TB_SCORE AS SCORE
	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
    WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($InRound, $PkTeamIdx, $PkScoreGroupIdx);
    while (my ($Item, $InScore, $InPercent) = $select->fetchrow_array() ) {
        $CARD{$Item}=$InScore;
        $ZONE{$Item}=$InPercent;
    }
    my $fs = $CARD{Load} + ($CARD{Load} * ($CARD{Zone1} * $ZONE{Zone1} + $CARD{Zone2} * $ZONE{Zone2} + $CARD{Zone3} * $ZONE{Zone3} + $CARD{Zone4} * $ZONE{Zone4}));
    my $str;
    $str .= '<table class="w3-table-all w3-border">';
    $str .= '<tr>';
    $str .= '<th>ROUND</th>';
    $str .= '<th class="w3-right-align">Static<br>Payload</th>';
    $str .= '<th class="w3-right-align">Zone<br>1</th>';
    $str .= '<th class="w3-right-align">Zone<br>2</th>';
    $str .= '<th class="w3-right-align">Zone<br>3</th>';
    $str .= '<th class="w3-right-align">Zone<br>4</th>';
    $str .= '<th class="w3-right-align">Flight Score</th>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>'.$InRound.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Load}.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Zone1}.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Zone2}.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Zone3}.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Zone4}.'</td>';
    $str .= sprintf '<td class="w3-border w3-right-align">%2.4f</td>', $fs;
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
}
sub showMicroClassCard(){
    my ($InRound, $PkTeamIdx, $PkScoreGroupIdx) = @_;
    my $dbi = new SAE::Db();
    my $SQL = "SELECT ITEM.TX_SCORE_ITEM, SCORE.IN_SCORE, ITEM.IN_PERCENT FROM TB_SCORE AS SCORE
	JOIN TB_SCORE_ITEM AS ITEM ON SCORE.FK_SCORE_ITEM_IDX=ITEM.PK_SCORE_ITEM_IDX
    WHERE SCORE.IN_ROUND=? AND SCORE.FK_TEAM_IDX=? AND SCORE.FK_SCORE_GROUP_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($InRound, $PkTeamIdx, $PkScoreGroupIdx);
    while (my ($Item, $InScore, $InPercent) = $select->fetchrow_array() ) {
        $CARD{$Item}=$InScore;
    }
    my $fs = $CARD{Load}/($CARD{Empty}**.5);
    my $str;
    $str .= '<table class="w3-table-all w3-border">';
    $str .= '<tr>';
    $str .= '<th>ROUND</th>';
    $str .= '<th class="w3-right-align">Payload</th>';
    $str .= '<th class="w3-right-align">Empty<br>Weight</th>';
    $str .= '<th class="w3-right-align">Flight Score</th>';
    $str .= '</tr>';
    $str .= '<tr>';
    $str .= '<td>'.$InRound.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Load}.'</td>';
    $str .= '<td class="w3-right-align">'.$CARD{Empty}.'</td>';
    $str .= sprintf '<td class="w3-border w3-right-align">%2.4f</td>', $fs;
    $str .= '</tr>';
    $str .= '</table>';
    return ($str);
}
#=======================
sub _templateFlightScore(){
    my ($PkTeamIdx, $PkClassIdx) = @_;
    my $Tab = new SAE::Tabulate();
    my %LOG;
    my $str;
    $str = '<ul ID="FLIGHT_ROUND_'.$PkTeamIdx.'" class="w3-ul w3-container">';
    if ($PkClassIdx == 1){
        %LOG = %{$Tab->getRegularClassFlightLogs($PkTeamIdx, 11)};
        foreach $InRound(sort {$a <=> $b} keys %LOG){
            $str .= &_templateRegularFlightRoundScore($InRound, $LOG{$InRound}, $PkClassIdx, $PkTeamIdx);
        }
    } elsif ($PkClassIdx == 2) {
        %LOG = %{$Tab->getAdvancedClassFlightLogs($PkTeamIdx, 12)};
        foreach $InRound(sort {$a <=> $b} keys %LOG){
            $str .= &_templateAdvancedFlightRoundScore($InRound, $LOG{$InRound}, $PkClassIdx, $PkTeamIdx);
        }
    } else {
        %LOG = %{$Tab->getMicroClassFlightLogs($PkTeamIdx, 13)};
        foreach $InRound(sort {$a <=> $b} keys %LOG){
            $str .= &_templateMicroFlightRoundScore($InRound, $LOG{$InRound}, $PkClassIdx, $PkTeamIdx);
        }
    }
    $str .= '</ul>';
    return ($str);
}
sub _templateRegularFlightRoundScore(){
    my ($InRound, $InScore, $PkClassIdx, $PkTeamIdx) = @_;
    my $str;
    $str = '<li ID="LOG_'.$PkTeamIdx.'_'.$InRound.'" class="w3-bar w3-border-bottom" >';
    $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-search" onclick="viewCardDetail('.$PkTeamIdx.','.$InRound .','.$PkClassIdx.')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-remove" onclick="deleteFlightScore('.$PkTeamIdx.','.$InRound .')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-edit" onclick="showEditFlightScore('.$PkTeamIdx.', '.$InRound.','.$PkClassIdx.');"></span>';
    $str .= '<div class="w3-bar-item">';
    $str .= sprintf '<span class="">Round '.$InRound.' Flight Score: $%2.2f</span>', $InScore;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub _templateAdvancedFlightRoundScore(){
    my ($InRound, $InScore, $PkClassIdx, $PkTeamIdx) = @_;
    my $str;
    $str = '<li ID="LOG_'.$PkTeamIdx.'_'.$InRound.'" class="w3-bar w3-border-bottom" >';#
    $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-search" onclick="viewCardDetail('.$PkTeamIdx.','.$InRound .','.$PkClassIdx.')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-remove" onclick="deleteFlightScore('.$PkTeamIdx.','.$InRound .')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-edit" onclick="showEditFlightScore('.$PkTeamIdx.', '.$InRound.','.$PkClassIdx.');"></span>';
    $str .= '<div class="w3-bar-item">';
    $str .= sprintf '<span class="">Round '.$InRound.' Flight Score: %2.4f Points</span>', $InScore;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub _templateMicroFlightRoundScore(){
    my ($InRound, $InScore, $PkClassIdx, $PkTeamIdx) = @_;
    my $str;
    $str = '<li ID="LOG_'.$PkTeamIdx.'_'.$InRound.'" class="w3-bar w3-border-bottom">';
    $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-search" onclick="viewCardDetail('.$PkTeamIdx.','.$InRound .','.$PkClassIdx.')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-xlarge w3-right fa fa-edit" onclick="showEditFlightScore('.$PkTeamIdx.', '.$InRound.','.$PkClassIdx.');"></span>';
    $str .= '<div class="w3-bar-item">';
    $str .= sprintf '<span class="">Round '.$InRound.' Flight Score: %2.4f</span>', $InScore;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
#=======================

sub viewPenalty(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $dbi = new SAE::Db();
    my $Tab = new SAE::Tabulate();
    my $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= $Tab->getPenaltyDetails($PkTeamIdx);
    return ($str);
}
sub viewDesignScore(){
    print $q->header();
    $PkTeamIdx = $q->param('PkTeamIdx');
    my $dbi = new SAE::Db();
    my $Tab = new SAE::Tabulate();
    my $SQL = "SELECT PK_PAPER_IDX, FK_SCORE_GROUP_IDX FROM TB_PAPER WHERE FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($PkTeamIdx);
    %PAPER = %{$select->fetchall_hashref(['PK_PAPER_IDX'])};
    my $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';

    foreach $PkPaperIdx (sort {$PAPER{$a}{FK_SCORE_GROUP_IDX} <=> $PAPER{$b}{FK_SCORE_GROUP_IDX}} keys %PAPER) {
        $str .= $Tab->tabulateReview($PkPaperIdx);
    }
    return ($str);
}
sub viewPresoScore(){
    print $q->header();
    $PkTeamIdx = $q->param('PkTeamIdx');
    my $Tab = new SAE::Tabulate();
    my $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= $Tab->getTeamPresoScore($PkTeamIdx);


    return ($str);
}
sub deleteTile(){
    print $q->header();
    my $TileIdx = $q->param('TileIdx');
    my $str;
    my $Tile = new SAE::TB_USER_TEAM();
    $Tile->deleteRecordBy_PkUserTeamIdx($TileIdx);
    return ($str);
}
sub subscribeToATeam(){
    print $q->header();
    my $TxCode = $q->param('TxCode');
    my $PkUserIdx = $q->param('PkUserIdx');
    my $dbi = new SAE::Db();
    my $Team = new SAE::TB_TEAM();
    $PkTeamIdx = $Team->getIdBy_TxCode($TxCode);
    my $SQL = "INSERT INTO TB_USER_TEAM (FK_USER_IDX, FK_TEAM_IDX) VALUES (?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($PkUserIdx, $PkTeamIdx);
    $newRecordIdx = $insert->{q{mysql_insertid}};
    if ($newRecordIdx>0){
         $SQL = "SELECT SUB.PK_USER_TEAM_IDX, TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_NAME, TEAM.TX_SCHOOL, CLASS.TX_CLASS FROM TB_TEAM AS TEAM
        JOIN TB_USER_TEAM AS SUB ON TEAM.PK_TEAM_IDX=SUB.FK_TEAM_IDX
        JOIN TB_CLASS AS CLASS ON CLASS.PK_CLASS_IDX=TEAM.FK_CLASS_IDX
            WHERE SUB.PK_USER_TEAM_IDX=? ";
        $select = $dbi->prepare($SQL);
        $select->execute($newRecordIdx);
        %TEAM = %{$select->fetchrow_hashref()};
        $txt = '#'.substr("000".$TEAM{IN_NUMBER},-3,3);
        $txt .= '<br>'.$TEAM{TX_SCHOOL};
        $txt .= '<br>'.$TEAM{TX_NAME};
        $txt .= '<br>'.$TEAM{TX_CLASS};
        $str .= &_tiles($txt, 'fa fa-send-o', 'setTeam('.$PkTeamIdx.');', $newRecordIdx, 1);
        return ($str);
    } else {
        return ();
    }
}
sub loadSetTeam(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $SQL = "SELECT SUB.PK_USER_TEAM_IDX, TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_NAME, TEAM.TX_SCHOOL, CLASS.TX_CLASS FROM TB_TEAM AS TEAM
        JOIN TB_USER_TEAM AS SUB ON TEAM.PK_TEAM_IDX=SUB.FK_TEAM_IDX
        JOIN TB_CLASS AS CLASS ON CLASS.PK_CLASS_IDX=TEAM.FK_CLASS_IDX
            WHERE SUB.FK_USER_IDX=? ";
    $select = $dbi->prepare($SQL);
    $select->execute($PkUserIdx);
    %TEAM = %{$select->fetchall_hashref(['PK_USER_TEAM_IDX'])};
    my $str;
    my $txt;
    $txt = '<p><label>Team Code:</label>';
    $txt .= '<input type="text" class="w3-input" placeholder="Team Code" ID="TX_TEAM_CODE">';
    $txt .= '</p>';
    $txt .= '<span class="w3-button w3-card-2 w3-border" onclick="subscribeToATeam('.$PkUserIdx.');">Subcribe</span>&nbsp;&nbsp;';
    $txt .= '<span class="w3-button w3-border" onclick="loadMainPage();">Cancel</span>';

    $str .= &_tiles($txt,                  '',      'subscribeToATeam('.$PkUserIdx.');', 0 );
    foreach $recordIDX (sort keys %TEAM) {
        $PkTeamIdx = $TEAM{$recordIDX}{PK_TEAM_IDX};
        $txt = '#'.substr("000".$TEAM{$recordIDX}{IN_NUMBER},-3,3);
        $txt .= '<br>'.$TEAM{$recordIDX}{TX_SCHOOL};
        $txt .= '<br>'.$TEAM{$recordIDX}{TX_NAME};
        $txt .= '<br>'.$TEAM{$recordIDX}{TX_CLASS};
        $str .= &_tiles($txt,                  ' 	fa fa-send-o',      'setTeam('.$PkTeamIdx.');', $recordIDX, 1);
    }

    return ($str);
}
sub loadMainPage(){ #Loading functions from admin.js
    print $q->header();
    my $PkUserIdx = $q->param('PkUserIdx');
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Team = new SAE::TB_TEAM();
    $Team->getRecordById($PkTeamIdx);
    my $Tab = new SAE::Tabulate();
    $DesignScore = sprintf "%2.4f", $Tab->getDesignScoreByTeamIdx( $PkTeamIdx );
    $PresoScore = sprintf "%2.4f", $Tab->getPresoScoreByTeamIdx( $PkTeamIdx );
    $Penalties = sprintf "- %2.4f", $Tab->getPenaltyByTeamIdx( $PkTeamIdx );
    $Flights =  $Tab->getFlightScoreByTeamIdx( $PkTeamIdx );
    my $PkClassIdx = $Team->getFkClassIdx();

    my $str;
    my $title = '<b>Team #'.substr("000".$Team->getInNumber(),-3,3).'</b><br><em>'.$Team->getTxSchool().'</em><br>';
    $str .= &_tiles('Follow a new Team',                  'fa fa-user-plus',      'loadSetTeam();' );
    $str .= &_tiles($title.'Design Report Score<p><span class="w3-border w3-padding w3-card-4">'.$DesignScore.'</span></p>','fa fa-newspaper-o', 'viewDesignScore('.$PkTeamIdx.');' );
    $str .= &_tiles($title.'Presentations Scores<p><span class="w3-border w3-padding w3-card-4">'.$PresoScore.'</span></p>','fa fa-desktop'    , 'viewPresoScore('.$PkTeamIdx.');' );
    $str .= &_tiles($title.'Penalties<p><span class="w3-border w3-padding w3-card-4 w3-text-red">'.$Penalties.'</span></p>','fa fa-warning'    , 'viewPenalty('.$PkTeamIdx.');' );
    $str .= &_tiles($title.'Flight Card Score<p><span class="w3-border w3-padding w3-card-4">'.$Flights.'</span></p>','fa fa-plane','viewFlightCards('.$PkTeamIdx.');' );
    $str .= &_tiles($title.'Round Results',            'fa fa-line-chart',       'viewRoundResults('.$PkClassIdx.');' );
    $str .= &_tiles('Sign Out',                     'fa fa-sign-out',       'signOutAdmin();' );
    return ($str);
}
sub _tiles(){
    my ($label, $image, $click, $recordIDX, $close) = @_;
    my $str;
    $str .= '<div ID="TILE_'.$recordIDX.'"class="w3-third w3-center">';
    $str .= '<div class="w3-card w3-container" style="min-height:340px; margin-top: 1.0em;">';
    if ($close==1) {
        $str .= '<span class="w3-button w3-border" style="position: relative; float: right; margin-right: 0!important" onclick="deleteTile('.$recordIDX.');">&times;</span>';
    }
    $str .= '<h4>'.$label.'</h4>';
    $str .= '<a onclick="'.$click.'" href="javascript:void(0);" class="'.$image.' w3-margin-bottom w3-text-theme" style="font-size:110px; text-decoration: none;"></a>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}


