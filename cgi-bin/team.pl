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
use SAE::TB_TEAM;
use SAE::TEAM;
use SAE::TB_CLASS;
use SAE::TB_COUNTRY;
use SAE::Auth;
# use SAE::TB_USER_TEAM;
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
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $str;

    return ($str);
}
# -------------------------------------- 2022 ----------------------------------
sub sae_openImportTeam(){
    print $q->header();
    # my $userIDX = $q->param('userIDX');
    my $eventIDX= $q->param('eventIDX');
    my $Event = new SAE::EVENT();
    my %EVENT = %{$Event->_getEventList()};
    my $str;
    
    $str .= '<form class="w3-container w3-padding" action = "javascript:void(0);" method = "post" enctype = "multipart/form-data">';
    $str .= sprintf '<label class="w3-text-grey" >Judge that performed the assessment:</label><br>';
    $str .= '<select ID="EVENT_IDX" class="w3-select w3-border w3-round">';
    foreach $fkEventIDX (sort {lc($EVENT{$a}{TX_EVENT_NAME}) cmp lc($EVENT{$b}{TX_EVENT_NAME})} keys %EVENT) {
        my $selected = '';
        if ($fkEventIDX == $eventIDX){$selected = 'selected'}
     $str .= sprintf '<option value="%d" %s>%s</option>', $fkEventIDX, $selected, $EVENT{$fkEventIDX}{TX_EVENT_NAME};   
    }
    $str .= '</select>';
    $str .= '<br><br><input ID="HEADER" class="w3-check" type="checkbox" checked> First Row is the title Row ';
    $str .= '<div class="w3-center w3-light-grey w3-padding w3-border w3-round w3-margin-top">';
    $str .= sprintf '<label class="w3-text-grey" >Excel Format: Team #, School, Team Name, Country</label><br>';
    # $str .= '<label for="file" class="w3-button w3-border w3-green w3-round" style="display: in-line;">';
    $str .= '<label for="file" class="w3-button w3-border w3-grey w3-round" style="display: inline-block; width: 100%; overflow-hidden">';
    $str .= 'Browse ...';
    $str .= '</label>';
    $str .= sprintf '<input id="file" class="w3-round w3-border" style="display: none;" type="file" name="filename" onchange="getFileName(this);"/>';
    $str .= '</div>';
    $str .= '<div class="w3-panel w3-padding w3-center">';
    $str .= sprintf '<button class="w3-button w3-round w3-border" style="width: 155px;" onclick="sae_uploadTeamList(this);">Upload</button>';
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" style="width: 155px;" onclick="$(this).close();">Cancel</button>';
    $str .= '<div id="uploadedDisplay" class="w3-container w3-padding">';
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</form>';
    return ($str);
}
# -------------------------------------- 2021 ----------------------------------
sub sae_saveTeamProfile(){
    print $q->header();
    my $Team = new SAE::TEAM();
    my $teamIDX = $q->param('teamIDX');
    my %DATA = %{decode_json($q->param('jsonData'))};
    my $str = $Team->_saveTeamData($teamIDX , \%DATA);
    return ('Saved');
}
sub sae_openTeamProfile(){
    print $q->header();
    my $teamIDX = $q->param('teamIDX');
    my $eventIDX = $q->param('location');
    my $Team = new SAE::TEAM($teamIDX);
    my %TEAM = %{$Team->_getTeamData()};
    my %DOCS = %{$Team->_getTeamDocuments($teamIDX)};
    my %COUNTRY = %{$Team->_getCountryData()};
    my %CLASS = (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str;
    $str .= '<fieldset>';
    $str .= '<legend>Team Data</legend>';
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="IN_NUMBER" class="w3-text-grey" >Team #</label>';
    $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="number" onblur="sae_autoSelectClass(this);" inputmode="numeric" value="%03d" data-key="IN_NUMBER" ID="IN_NUMBER">', $TEAM{IN_NUMBER};
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="TX_SCHOOL" class="w3-text-grey" >School</label>';
    $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="text" value="%s" data-key="TX_SCHOOL" ID="TX_SCHOOL">', $TEAM{TX_SCHOOL};
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="TX_COUNTRY" class="w3-text-grey" >Country</label>';
    $str .= '<select ID="TX_COUNTRY" class="w3-select w3-border w3-round">';
    $str .= sprintf '<option value="none" disabled>Country </option>';
    foreach $countryIDX (sort {lc($COUNTRY{$a}{TX_COUNTRY}) cmp lc($COUNTRY{$b}{TX_COUNTRY})} keys %COUNTRY) {
        my $txCountry = $COUNTRY{$countryIDX}{TX_COUNTRY};
        my $selected = '';
        if ($TEAM{TX_COUNTRY} eq $txCountry) {$selected = 'selected'}
        $str .= sprintf '<option value="%s" %s>%s</option>', $txCountry, $selected, $txCountry;
    }
    $str .= '</select>';
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small" >';
    $str .= '<label for="TX_NAME" class="w3-text-grey">Team Name</label>';
    $str .= sprintf'<input class="w3-input w3-border w3-round sae_data" type="text" value="%s" data-key="TX_NAME"ID="TX_NAME">', $TEAM{TX_NAME};
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="FK_CLASS_IDX" class="w3-text-grey" >Class</label>';
    $str .= '<select ID="FK_CLASS_IDX" class="w3-select w3-border w3-round">';
    $str .= sprintf '<option value="none" disabled>Class</option>';
    foreach $classIDX (sort {$a<=>$b} keys %CLASS) {
        my $selected = '';
        if ($classIDX == $TEAM{FK_CLASS_IDX}) {$selected = 'selected'}
        $str .= sprintf '<option value="%d" %s>%s</option>', $classIDX, $selected, $CLASS{$classIDX};
    }
    $str .= '</select>';
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small" >';
    $str .= '<label for="TX_CODE" class="w3-text-grey">Team Access Code</label>';
    $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="password" inputmode="numeric" value="%s" data-key="TX_CODE" ID="TX_CODE">', $TEAM{TX_CODE};
    $str .= sprintf '<input ID="CODE_SHOW" type="checkbox" onchange="sae_changeInputType(this, \'%s\');">', 'TX_CODE';
    $str .= '<label for="CODE_SHOW" class="w3-small w3-text-grey">&nbsp;Show</label>';
    $str .= '</div>';

    
    if ($TEAM{FK_CLASS_IDX}==1){
        $str .= sprintf '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
        $str .= '<label for="IN_SLOPE" class="w3-text-grey" >Slope</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="number" inputmode="numeric" step="0.000001" max="0" value="%2.7f" data-key="IN_SLOPE" ID="IN_SLOPE"></div>', $TEAM{IN_SLOPE};
        $str .= sprintf '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
        $str .= '<label for="IN_YINT" class="w3-text-grey" >y-Intercept</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="number" inputmode="numeric" value="%2.2f" data-key="IN_YINT" ID="IN_YINT" step="0.01" min="0"></div>', $TEAM{IN_YINT};
        $str .= sprintf '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
        $str .= '<label for="IN_LCARGO" class="w3-text-grey" >L-Cargo</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="number" inputmode="numeric" value="%2.2f" data-key="IN_LCARGO" ID="IN_LCARGO" step="0.001" min="0">', $TEAM{IN_LCARGO};
        $str .= '</div><br>';
    }
    if ($TEAM{FK_CLASS_IDX}==2){
        $str .= sprintf '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
        $str .= '<label for="IN_STD" class="w3-text-grey" >Standard Deviation</label>';
        $str .= sprintf '<input class="w3-input w3-border w3-round sae_data" type="number" inputmode="numeric" step="1" min="" value="%2.1f" data-key="IN_STD" ID="IN_STD"></div>', $TEAM{IN_STD};

        $str .= '<br>';
    }
    $str .= '</div>';
    $str .= '</fieldset>';
    $str .= '<fieldset>';
    $str .= '<legend>Documents</legend>';
    my %PAPER = (1=>'Design Report', 2=>'TDS', 3=>'Drawing');
    # foreach $uploadIDX (sort {$DOCS{$a}{TX_PAPER} cmp $DOCS{$b}{TX_PAPER}} keys %DOCS) {
    foreach $paperIDX (sort {$PAPER{$a} cmp $PAPER{$b}} keys %PAPER) {
    $str .= '<div class="w3-row">';
        $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
        $str .= '<form action = "javascript:void(0);" method = "post" enctype = "multipart/form-data">';
        $str .= sprintf '<label class="w3-text-grey" >%s</label><br>', $PAPER{$paperIDX};
        $str .= sprintf '<input id="file" class="w3-round w3-border" style="width: 60%;"type="file" name="filename"/>';
        # $str .= '<input style="width: 25%;" class="w3-button w3-round w3-border" type="submit" name="Submit" value="Upload" />';
        $str .= sprintf '<button class="w3-button w3-round w3-border" onclick="sae_upload(%d, %d, %d, %d);">Upload</button>', $teamIDX, $TEAM{IN_NUMBER}, $eventIDX, $paperIDX;
        $str .= '</form>';
        $str .= '</div>';
        $str .= '<div  class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small" >';
        $str .= sprintf '<label class="w3-text-grey" >Uploaded documents</label><br>';
        $str .= sprintf '<div ID="uploadedDisplay_%d"><a href="read.html?fileID=%s" target="_blank">%s</a></div>', $paperIDX, $DOCS{$paperIDX}{TX_KEYS}, $DOCS{$paperIDX}{TX_FILENAME};       
        # $str .= sprintf '<div ID="uploadedDisplay_%d"><a href="view.html?fileID=%s" target="_blank">%s</a></div>', $paperIDX, $DOCS{$paperIDX}{TX_KEYS}, $DOCS{$paperIDX}{TX_FILENAME};       
        #  $str = sprintf '<a href="read.html?fileID=%s" target="_blank">%s</a>', $txKeys, $newfileName;
        $str .= '</div>';
    $str .= '</div>'; 
    }
    $str .= '</fieldset>';
    $str .= '<div class="w3-row w3-row-padding w3-center">';
    $str .= '<div class="w3-mobile w3-margin-bottom w3-padding  w3-border-top" >';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-green w3-hover-blue w3-margin-right w3-margin-bottom" style="width: 155px;" onclick="sae_saveTeamProfile(this, %d);">Save</button>', $teamIDX;
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-hover-red w3-margin-right w3-margin-bottom" style="width: 155px;" onclick="sae_deleteTeam(this, %d);">Delete</button>', $teamIDX;
    $str .= '<button class="w3-button w3-border w3-round w3-margin-right w3-margin-bottom" style="width: 155px;" onclick="$(this).close();">Cancel</button>';
    $str .= '</div>';
    $str .= '</div>';
    
    return ($str);
}
sub openManageteam(){
    print $q->header();
    my $eventIDX = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    my %TEAM = %{$Team->getAllRecordBy_FkEventIdx($eventIDX)};
    %CLASS = %{$Class->getAllRecord()};
    
    my $height = 45;
    my $str;
    $str .= '<div class=" w3-container w3-margin-top w3-row"><br>';
    $str .= '<span class="w3-bar-item w3-xxlarge">Manage Teams</span>';
    # $str .= '<div class="w3-bar w3-light-grey">';
    
    $str .= '<div class="w3-dropdown-hover w3-blue-grey w3-margin-left" style="height: 40px;">';
    $str .= '<button class="w3-button w3-large">Actions<i class="w3-margin-left fa fa-sort-down"></i></button>';
    $str .= '<div class="w3-dropdown-content w3-bar-block w3-card-4">';
    $str .= sprintf '<a href="javascript:void(0)" class="w3-bar-item w3-button"  onclick="sae_openAddTeam(%d);">Add Team</a>', $eventIDX;
    $str .= '<hr style="margin: 1px; padding: 0px;">';
    $str .= '<a href="javascript:void(0);" class="w3-bar-item w3-button" onclick="sae_openImportTeam();">Import</a>';
    $str .= '</div>';
    $str .= '</div>';
    # $str .= '</div>';
    # $
    # $str .= sprintf '<h3><button class="w3-button w3-border w3-round w3-hover-blue w3-white" onclick="sae_openAddTeam(%d);">+ New</button> TEAM</h3>', $eventIDX;
    # $str .= '<h3>Team</h3>';
    $str .= '<ul ID="UL_TEAM_LIST" class="w3-ul w3-round w3-transparent">';
    foreach $teamIDX (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        $str .= &_teamCardTemplate($teamIDX, $TEAM{$teamIDX}{IN_NUMBER}, $TEAM{$teamIDX}{TX_SCHOOL}, $TEAM{$teamIDX}{TX_COUNTRY});
    }
    $str .= '</ul>';
    $str .= '</div>';
    return ($str);
}
sub _teamCardTemplate(){
    my ($teamIDX, $inNumber, $txSchool, $txCountry) = @_;
    my $height = 45;
    my $str;
    $str .= sprintf '<li ID="TEAM_%d" class="w3-bar w3-button w3-margin-bottom w3-border w3-round w3-white w3-display-container w3-hover-pale-yellow" onclick="sae_openTeamProfile(%d)">', $teamIDX, $teamIDX;
    $str .= '<i class="fa fa-chevron-right fa-2x w3-display-right  w3-margin-right" aria-hidden="true"></i>';
    $str .= sprintf '<span class="w3-bar-item w3-circle w3-border w3-blue-grey w3-display-left w3-margin-left w3-center" style="height: %dpx; width: %dpx;">', $height, $height;
    $str .= sprintf '<div style="margin-left: -7px; margin-top: 4px;">%03d</div>', $inNumber;
    $str .= '</span>';
    $str .= '<div class="w3-bar-item w3-small" style="margin-left: 35px; text-align: left; padding-right: 100px;">';
    $str .= sprintf '<span class="w3-large">%s</span><br>', $txSchool;
    $str .= sprintf '<span>%s</span><br>', $txCountry;
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}
sub sae_deleteTeam(){
    print $q->header();
    $teamIDX = $q->param('teamIDX');
    $Team = new SAE::TB_TEAM();
    $Team->deleteRecordById($teamIDX);
}
sub sae_openAddTeam(){
    print $q->header();
    my $Team = new SAE::TEAM();
    my $eventIDX = $q->param('eventIDX');
    my %COUNTRY = %{$Team->_getCountryData()};
    
    my %CLASS = (1=>"Regular Class", 2=>"Advanced Class", 3=>"Micro Class");
    my $str = '<div class="w3-container w3-row">';
    
    $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="IN_NUMBER" class="w3-text-grey" >Team #</label>';
    $str .= '<input class="w3-input w3-border w3-round sae_data" type="number" onblur="sae_autoSelectClass(this);" inputmode="numeric" data-key="IN_NUMBER" ID="IN_NUMBER">';
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="TX_SCHOOL" class="w3-text-grey" >School</label>';
    $str .= '<input class="w3-input w3-border w3-round sae_data" type="text"  data-key="TX_SCHOOL" ID="TX_SCHOOL">';
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="TX_COUNTRY" class="w3-text-grey" >Country</label>';
    $str .= '<select ID="TX_COUNTRY" class="w3-select w3-border w3-round">';
    $str .= sprintf '<option value="none" disabled selected>--- Country of Origin ---</option>';
    foreach $countryIDX (sort {lc($COUNTRY{$a}{TX_COUNTRY}) cmp lc($COUNTRY{$b}{TX_COUNTRY})} keys %COUNTRY) {
        my $txCountry = $COUNTRY{$countryIDX}{TX_COUNTRY};
        $str .= sprintf '<option value="%s">%s</option>', $countryIDX, $txCountry;
    }
    $str .= '</select>';
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small" >';
    $str .= '<label for="TX_NAME" class="w3-text-grey">Team Name</label>';
    $str .= sprintf'<input class="w3-input w3-border w3-round sae_data" type="text" value="%s" data-key="TX_NAME"ID="TX_NAME">', $TEAM{TX_NAME};
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-quarter w3-margin-bottom w3-padding-small">';
    $str .= '<label for="FK_CLASS_IDX" class="w3-text-grey" >Class</label>';
    $str .= '<select ID="FK_CLASS_IDX" class="w3-select w3-border w3-round">';
    $str .= sprintf '<option value="none" disabled selected>Class</option>';
    foreach $classIDX (sort {$a<=>$b} keys %CLASS) {
        $str .= sprintf '<option value="%d">%s</option>', $classIDX, $CLASS{$classIDX};
    }
    $str .= '</select>';
    $str .= '</div>';
    
    $str .= '<div class="w3-mobile w3-threequarter w3-margin-bottom w3-padding-small" >';
    $str .= '<br>';
    $str .= sprintf '<button class="w3-button w3-border w3-round w3-green w3-hover-blue w3-margin-left" style="width: 100px;" onclick="sae_addNewTeam(this, %d);">Save</button>', $eventIDX;
    $str .= '<button class="w3-button w3-border w3-round w3-margin-left" style="width: 100px;" onclick="$(this).close();">Cancel</button>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);

}
sub sae_addNewTeam(){
    print $q->header();
    my $Team = new SAE::TEAM();
    my $Auth = new SAE::Auth();
    my %DATA = %{decode_json($q->param('jsonData'))};
    $DATA{TX_CODE} = $Auth->getTemporaryPassword(6);
    my $teamIDX = $Team->_addNewTeam(\%DATA);
    $str = &_teamCardTemplate($teamIDX, $DATA{IN_NUMBER}, $DATA{TX_SCHOOL}, $DATA{TX_COUNTRY});
    return ($str);
}
# -------------------------------------- 2021 ----------------------------------
sub generateAllNewCode() {
    print $q->header();
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    %TEAM =  %{$Team->getAllRecordBy_FkEventIdx($location)};
    my $Auth = new SAE::Auth();
    foreach $PkTeamIdx (sort keys %TEAM) {
        $TxCode = $Auth->getTemporaryPassword(6);
        $Team->updateTxCode_ById($TxCode, $PkTeamIdx);
    }

    return ("Updated Team Code for ".scalar (keys %TEAM)." Teams");
}
sub addTeam(){
    print $q->header();
    my $InNumber = $q->param('InNumber');
    my $TxSchool = $q->param('TxSchool');
    my $TxName = $q->param('TxName');
    my $PkCountryIdx = $q->param('PkCountryIdx');
    my $PkClassIdx = $q->param('PkClassIdx');
    my $location = $q->param('location');
    my $dbi = new SAE::Db();
    my $SQL = "INSERT INTO TB_TEAM (IN_NUMBER, TX_SCHOOL, TX_NAME, FK_COUNTRY_IDX, FK_CLASS_IDX, FK_EVENT_IDX)
        VALUES (?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($InNumber, $TxSchool, $TxName, $PkCountryIdx, $PkClassIdx, $location);
    my $PkTeamIdx = $insert->{q{mysql_insertid}};
    $InNumber = substr("000".$InNumber,-3,3);
    $str .= &_templateList($PkTeamIdx, $InNumber, $TxSchool, $TxName);
    return ($str);
}
sub showAddTeam(){
    print $q->header();
    my $location = $q->param('location');
    my $Class = new SAE::TB_CLASS();
    %CLASS = %{$Class->getAllRecord()};
    my $Country = new SAE::TB_COUNTRY();
    %COUNTRY = %{$Country->getAllRecord()};
    my $location = $q->param('location');
    my $str;
    $str = '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2>New Team</h2>';
    $str .= '</div>';
    $str .= '<div class="w3-container">';
    $str .= '<p><label>Team Number</label>';
    $str .= '<input class="w3-number w3-input" type="number" ID="IN_NUMBER"></p>';
    $str .= '<p><label>University</label>';
    $str .= '<input class="w3-input" type="text" ID="TX_SCHOOL"></p>';
    $str .= '<p><label>Name</label>';
    $str .= '<input class="w3-input" type="text" ID="TX_NAME" ></p>';
    $str .= '<p><label>Country</label>';
    $str .= '<select ID="FK_COUNTRY_IDX" class="w3-input">';
     $str .= '<option value="0">--- Country of Origin ---</option>';
    foreach $PkCountryIdx (sort {$COUNTRY{$a}{TX_COUNTRY} cmp $COUNTRY{$b}{TX_COUNTRY}} keys %COUNTRY) {
        $str .= '<option value="'.$PkCountryIdx.'">'.$COUNTRY{$PkCountryIdx}{TX_COUNTRY}.'</option>';
    }
    $str .= '</select>';
    $str .= '</p>';
    $str .= '<p><label>Class</label>';
    $str .= '<select ID="FK_CLASS_IDX" class="w3-input">';
    $str .= '<option value="0">--- Class ---</option>';
    foreach $PkClassIdx (sort {$CLASS{$a}{TX_COUNTRY} cmp $CLASS{$b}{TX_CLASS}} keys %CLASS) {
        $str .= '<option value="'.$PkClassIdx.'">'.$CLASS{$PkClassIdx}{TX_CLASS}.'</option>';
    }
    $str .= '</select>';
    $str .= '</p>';
    $str .= '</div>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<span class="w3-button w3-card-4 w3-margin w3-white" onclick="addTeam();">Add</span>';
    $str .= '<span class="w3-button w3-card-4 w3-margin w3-white" onclick="closeModal(\'id01\');">Cancel</span>';
    $str .= '</div>';
    return ($str);
}
sub deleteTeam(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Team = new SAE::TB_TEAM();
    $Team->deleteRecordById($PkTeamIdx);
    return();
}
sub saveTeamInfo(){
    print $q->header();
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    my %CLASS = %{$Class->getAllRecord()};
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $TxSchool = $q->param('TxSchool');
    my $TxName = $q->param('TxName');
    my $FkClassIdx = $q->param('FkClassIdx');
    my $InNumber = $q->param('InNumber');
    my $InTubeLength = $q->param('InTubeLength');
    my $InCapacity = $q->param('InCapacity');
    $Team->updateTxSchool_ById($TxSchool, $PkTeamIdx);
    $Team->updateTxName_ById($TxName, $PkTeamIdx);
    $Team->updateFkClassIdx_ById($FkClassIdx, $PkTeamIdx);
    $Team->updateInNumber_ById($InNumber, $PkTeamIdx);
    if ($FkClassIdx == 3) {
        $Team->updateInTubeLength_ById($InTubeLength, $PkTeamIdx);
    }
    if ($FkClassIdx == 1) {
        $Team->updateInCapacity_ById($InCapacity, $PkTeamIdx);
    }
    $DATA{TX_SCHOOL}=$TxSchool;
    $DATA{TX_NAME}=$TxName;
    $DATA{TX_CLASS}=$CLASS{$FkClassIdx}{TX_CLASS};
    $InNumber =~ s/^0+//sgi;
    $DATA{IN_NUMBER}=substr("000".$InNumber,-3,3);
    my $json = encode_json \%DATA;
    return ($json);
}
sub _templateTeamDetails(){
    my $fieldName = shift;
    my $fieldValue = shift;
    my $fieldId = shift;
    my $str;
    $str .= '<label class="w3-small">'.$fieldName.'</label>';
    $str .= '<input class="w3-input w3-text-blue" type="text" name="'.$fieldId.'" id="'.$fieldId.'" placeholder="'.$fieldName.'" value="'.$fieldValue.'"/>';

    return ($str);
}
sub showEditTeamInformation(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    %CLASS = %{$Class->getAllRecord()};
    my $str;
    $Team->getRecordById($PkTeamIdx);
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2>Team Information</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container">';
    $str .= &_templateTeamDetails('Team Number',substr("000".$Team->getInNumber(),-3,3),'IN_NUMBER');
    $str .= &_templateTeamDetails('School / University',$Team->getTxSchool(),'TX_SCHOOL');
    $str .= &_templateTeamDetails('Team Name',$Team->getTxName(),'TX_NAME');
#     $str .= '<div class="12u$">';
#     $str .= '<div class="select-wrapper">';
    $str .= '<label class="w3-small">Class</label>';
    $str .= '<select class="w3-input w3-text-blue" name="FK_CLASS_IDX" id="FK_CLASS_IDX">';
    foreach $PkClassIdx (sort keys %CLASS) {
        my $selected = '';
        if ($Team->getFkClassIdx() == $PkClassIdx){$selected = 'selected'}
        $str .= '<option value="'.$PkClassIdx.'" '.$selected.'>'.$CLASS{$PkClassIdx}{TX_CLASS}.'</option>';
    }
    $str .= '</select>';
#     $str .= '<div class="smallLabel">Class</div>';
    if ($Team->getFkClassIdx()==1) {
        $str .= &_templateTeamDetails('Max Seat Capacity' ,$Team->getInCapacity(),'IN_CAPACITY');
    }
    if ($Team->getFkClassIdx()==3) {
        $str .= &_templateTeamDetails('Tube Length' ,$Team->getInTubeLength(),'IN_TUBE_LENGTH');
    }
    $str .= '</form>';
    $str .= '<br>';
    $str .= '<div class="w3-bar w3-padding" style="text-align: center;">';
    $str .= '<a class="w3-button w3-border w3-center" class="button small special" onclick="saveTeamInfo('.$PkTeamIdx.');">Update</a><br><br>';
    $str .= '</div>';
    return ($str);
}
sub resetAccessCode(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    my $TxCode = $q->param('TxCode');
    my $Team = new SAE::TB_TEAM();
    $Team->updateTxCode_ById($TxCode, $PkTeamIdx);
    return ($TxCode);
}
sub showResetAccessCode(){
    print $q->header();
    my $Team = new SAE::TB_TEAM();
    my $PkTeamIdx = $q->param('PkTeamIdx');
    $Team->getRecordById($PkTeamIdx);
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Team Access Code</h2>';
    $str .= '</div>';

#     $str .= '<h2>Team Access Code</h2>';
    $str .= '<form class="w3-container w3-center" >';
    $str .= '<p>Manually assign a team access code by typing a new code in the space provided<br>or<br>click <a href="javascript:void(0);" onclick="generateRandomTeamCode();">Generate Random Code</a></p>';
    $str .= '<p><input class="w3-input" type="text" style="text-align: center;" ID="TX_TEAM_CODE" placeholder="Team Access Code" value="'.$Team->getTxCode().'">';
    $str .= '<label><b>Access Code</label></b></p>';
    $str .= '<a class="w3-button w3-border w3-grey" onclick="resetAccessCode('.$PkTeamIdx.');">Update</a> ';

    $str .= '</form><br>';
    return ($str);
}
sub generateRandomTeamCode(){
    print $q->header();
    my $PkTeamIdx = $q->param('PkTeamIdx');

    my $str;
    my $Auth = new SAE::Auth();
    $str = $Auth->getTemporaryPassword(10);
    return ($str);
}
sub showTeamList(){
    print $q->header();
    my $location = $q->param('location');
    my $Team = new SAE::TB_TEAM();
    my $Class = new SAE::TB_CLASS();
    %TEAM = %{$Team->getAllRecordBy_FkEventIdx($location)};
    %CLASS = %{$Class->getAllRecord()};
    my $str;
    my $c=1;
    $str .= '<span class="w3-button w3-card w3-margin" onclick="loadSetupAndAdministration();">Back</span>';
    $str .= '<span class="w3-button w3-card w3-margin"  onclick="showAddTeam();">Add Team 000</span>';
    $str .= '<span class="w3-button w3-card w3-margin"  onclick="generateAllNewCode();">Generate New Codes</span>';
    $str .= '<ul ID="TeamList" class="w3-ul w3-card-4">';
    foreach $PkTeamIdx (sort {$TEAM{$a}{IN_NUMBER} <=> $TEAM{$b}{IN_NUMBER}} keys %TEAM) {
        $InNumber = substr("000".$TEAM{$PkTeamIdx}{IN_NUMBER},-3,3);
        $TxSchool = $TEAM{$PkTeamIdx}{TX_SCHOOL};
        $TxName = $TEAM{$PkTeamIdx}{TX_NAME};
        $str .= &_templateList($PkTeamIdx, $InNumber, $TxSchool, $TxName);
    }
    $str .= '</ul>';
    return ($str);
}

sub _templateList(){
    my ($PkTeamIdx, $InNumber, $TxSchool, $TxName) = @_;
    my $str;
    $str = '<li ID="LIST_TEAM_'.$PkTeamIdx.'" class="w3-bar">';
    $str .= '<span class="w3-bar-item w3-button w3-white w3-xlarge w3-right" onclick="deleteTeam('.$PkTeamIdx.')">&times;</span>';
#     $str .= '<span class="w3-bar-item w3-button w3-white w3-xxlarge w3-left fa fa-user-secret" onclick="showResetAccessCode('.$PkTeamIdx.')"></span>';
#     $str .= '<span class="w3-bar-item w3-button w3-white w3-xxlarge w3-left fa fa-pencil-square-o" onclick="showEditTeamInformation('.$PkTeamIdx.');"></span>';
    $str .= '<img src="../images/users.png" class="w3-bar-item w3-circle w3-hide-small" style="width:85px" onclick="showEditTeamInformation('.$PkTeamIdx.');">';
    $str .= '<div class="w3-bar-item">';
    $str .= '<span class="w3-medium" ><a ID="SPAN_NUMBER_SCHOOL_'.$PkTeamIdx.'" href="javascript:void(0);" onclick="showEditTeamInformation('.$PkTeamIdx.');">#'.$InNumber.' - '.$TxSchool.'</a></span><br>';
#     $str .= '<span class="w3-small"ID="SPAN_NAME_'.$PkTeamIdx.'" >'.$TxName.'</span><br>';
    $str .= '<span class="fa fa-pencil-square-o" style="cursor: pointer;" onclick="showResetAccessCode('.$PkTeamIdx.')"> Team Code: ******</span>';
    $str .= '</div>';
    $str .= '</li>';
    return ($str);
}

