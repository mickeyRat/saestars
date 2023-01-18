#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use CGI qw/:standard/;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;
use URI::Escape;
use Cwd 'abs_path';
use JSON;
use Text::CSV;
use Mail::Sendmail;


#---- SAE MODULES -------
use SAE::MAIL;
use SAE::SDB;
use SAE::Auth;
use SAE::AUTO;
use SAE::REPORTS;
use SAE::REFERENCE;
use SAE::TB_USER;
use SAE::TB_TEAM;
use SAE::WEATHER;
use SAE::CARD;
use SAE::TEAM;
use SAE::USER;
use SAE::PAPER;
use SAE::JSONDB;
use SAE::PROFILE;

my %CLASS      = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
my %COLOR      = (0=>'w3-light-grey', 1=>'w3-yellow', 2=>'w3-blue');
$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;
my @tm         = localtime();
my $txYear     = ($tm[5] + 1900);


my $act = $q->param("act");

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
#==============================================================================
sub paper_removeTeamFromJudge (){
    my $cardIDX = $q->param('cardIDX');
    my $JsonDB  = new SAE::JSONDB();
    print $q->header();
    $JsonDB->_delete('TB_CARD',qq(PK_CARD_IDX=$cardIDX));
    return ();
    }
sub paper_assignTeamToJudge (){
    my $eventIDX   = $q->param('eventIDX');
    my $userIDX    = $q->param('userIDX');
    my $inCardType = $q->param('inCardType');
    my $teamIDX    = $q->param('teamIDX');
    my $Paper      = new SAE::PAPER();
    my $Team       = new SAE::TEAM();
    my %TYPE       = (1=>'Design Report', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    # my %DATA       = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my %TEAM       = %{$Team->_getTeamDetails($teamIDX )};
    my $cardIDX    = $Paper->_assignTeamToJudge($userIDX, $teamIDX, $eventIDX, $inCardType);
    my $btn        = sprintf 'Goto %s',$TYPE{$inCardType};
    my $card       = &t_paperCard($cardIDX, 0, $TEAM{IN_NUMBER}, $TEAM{TX_SCHOOL}, $TEAM{FK_CLASS_IDX}, $teamIDX, $inCardType, $userIDX, $btn);
    my %DATA;
    $DATA{CARD}        = $card;
    $DATA{PK_CARD_IDX} = $cardIDX;
    my $json = encode_json \%DATA;
    return ($json);
    # return ("hello");
    }
sub paper_openShowAvailableTeams (){
    my $eventIDX   = $q->param('eventIDX');
    my $userIDX    = $q->param('userIDX');
    my $inCardType = $q->param('inCardType');
    my $Profile    = new SAE::PROFILE();
    my %USER       = %{$Profile->_getJudgePreferenceDetails($userIDX, $txYear)};
    my %ASSIGN     = %{$Profile->_getPapersAssignedToUser($eventIDX, $userIDX, $inCardType)};
    my %TEAMS      = %{$Profile->_getListOfTeams($eventIDX)};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $str;
    $str .= '<div class="w3-container">';
    # $str .= '<fieldset class="w3-panel w3-round-large"><legend> Judge\'s Preferences </legend>';
    $str .= sprintf '<fieldset class="w3-panel w3-round-large"><legend class="w3-xlarge">%s, %s</legend>', $USER{TX_LAST_NAME}, $USER{TX_FIRST_NAME};
    
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-container w3-third">';
    $str .= sprintf '<b>Class Preference:</b>';
    # $str .= '<ul style="w3-margin-left">';
    if ($USER{BO_REGULAR}==1) {$str .= '<div class="w3-text-blue">Regular Class</div>';} else {$str .= '<div>&nbsp;</div>';}
    if ($USER{BO_ADVANCE}==1) {$str .= '<div class="w3-text-blue">Advanced Class</div>';} else {$str .= '<div>&nbsp;</div>';}
    if ($USER{BO_MICRO}==1) {$str   .= '<div class="w3-text-blue">Micro Class</div>';} else {$str .= '<div>&nbsp;</div>';}  
    # $str .= '</ul>';
    $str .= '</div>';

    $str .= '<div class="w3-container w3-third">';
    $str .= '<b>Experience Level</b>';
    $str .= sprintf '<div class="w3-text-blue">Volunteered since: %d</div>', $USER{TX_YEAR};

    $str .= '<b>Number of Paper willing to grade</b>';
    $str .= sprintf '<div class="w3-text-blue">%d</div>', $USER{IN_LIMIT};
    $str .= '</div>';

    $str .= '<div class="w3-container w3-third">';
    $str .= '<b>School Affiliation/Attended</b>';
    if ($USER{TX_SCHOOL}){
        $str .= sprintf '<div class="w3-text-blue">%s</div>', $USER{TX_SCHOOL};

        } else {
        $str .= sprintf '<div class="w3-text-blue">- Not Identified -</div>';
        }
    $str .= '</div>';
    $str .= '</div>';
    $str .= '</fieldset>';

    my %REG = %{$TEAMS{1}};
    my %ADV = %{$TEAMS{2}};
    my %MIC = %{$TEAMS{3}};
    my $height = 30;
    $str .= '<div class="w3-row">';
    $str .= '<div class="w3-container w3-third w3-border w3-round ">';
    $str .= '<h5>Regular Class</h5>';
    foreach $teamIDX (sort {$REG{$a}{IN_NUMBER} <=> $REG{$b}{IN_NUMBER}} keys %REG) {
        $str .= '<div style="height: '.$height.'px; overflow: hidden;">';
        my $disabled = '';
        if ($ASSIGN{$teamIDX}{IN_STATUS} == 2){$disabled = 'disabled'}
        my $checked = '';
        if (exists $ASSIGN{$teamIDX}{PK_CARD_IDX}){$checked = sprintf 'checked data-key="%d"', $ASSIGN{$teamIDX}{PK_CARD_IDX}}
        $str .= sprintf '<input '.$disabled.' type="checkbox" class="w3-check" '.$checked.' onclick="paper_addOrRemove(this, '.$userIDX.', '.$teamIDX.','.$inCardType.');" > <label>%03d-%s</label>', $REG{$teamIDX}{IN_NUMBER}, $REG{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
    }
    $str .= '</div>';

    $str .= '<div class="w3-container w3-third w3-border w3-round ">';
    $str .= '<h5>Advanced Class</h5>';
    foreach $teamIDX (sort {$ADV{$a}{IN_NUMBER} <=> $ADV{$b}{IN_NUMBER}} keys %ADV) {
        $str .= '<div style="height: '.$height.'px; overflow: hidden;">';
        my $disabled = '';
        if ($ASSIGN{$teamIDX}{IN_STATUS} == 2){$disabled = 'disabled'}
        my $checked = '';
        if (exists $ASSIGN{$teamIDX}{PK_CARD_IDX}){$checked = sprintf 'checked data-key="%d"', $ASSIGN{$teamIDX}{PK_CARD_IDX}}
        $str .= sprintf '<input '.$disabled.' type="checkbox" class="w3-check" '.$checked.' onclick="paper_addOrRemove(this, '.$userIDX.', '.$teamIDX.','.$inCardType.');"> <label>%03d-%s</label>', $ADV{$teamIDX}{IN_NUMBER}, $ADV{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
    }
    $str .= '</div>';

    $str .= '<div class="w3-container w3-third w3-border w3-round ">';
    $str .= '<h5>Micro Class</h5>';
    foreach $teamIDX (sort {$MIC{$a}{IN_NUMBER} <=> $MIC{$b}{IN_NUMBER}}keys %MIC) {
        $str .= '<div style="height: '.$height.'px; overflow: hidden;">';
        my $disabled = '';
        if ($ASSIGN{$teamIDX}{IN_STATUS} == 2){$disabled = 'disabled'}
        my $checked = '';
        if (exists $ASSIGN{$teamIDX}{PK_CARD_IDX}){$checked = sprintf 'checked data-key="%d"', $ASSIGN{$teamIDX}{PK_CARD_IDX}}
        $str .= sprintf '<input '.$disabled.' type="checkbox" class="w3-check" '.$checked.' onclick="paper_addOrRemove(this, '.$userIDX.', '.$teamIDX.','.$inCardType.');"> <label>%03d-%s</label>', $MIC{$teamIDX}{IN_NUMBER}, $MIC{$teamIDX}{TX_SCHOOL};
        $str .= '</div>';
    }
    $str .= '</div>';
    $str .= '</div>';


    $str .= '</div>';
    return ($str);
    }
sub paper_sendMail (){
    print $q->header();
    my $to      = $q->param('to');
    my $from    = $q->param('from');
    my $subject = $q->param('subject');
    my $message = $q->param('message');
    my $Mail = new SAE::MAIL();
    $str = $Mail->_sendMail_TEXT($to, $from, $subject, $message);
    return($str);
    }
sub properCase(){
    my $txt  = shift;
    my $case = sprintf '%s%s', uc(substr($txt,0,1)), lc(substr($txt,1));
    return($case);
    }
sub paper_openSendReminderToAll (){
    my $eventIDX     = $q->param('eventIDX');
    my $userIDX      = $q->param('userIDX');
    my $loginUserIDX = $q->param('loginUserIDX');
    my $inCardType   = $q->param('inCardType');
    my $User         = new SAE::USER();
    my $Paper        = new SAE::PAPER();
    my %EMAIL        = %{$Paper->_getEmailList($eventIDX, $inCardType)};
    my %ADMIN        = %{$User->_getUserDetails($loginUserIDX)};
    my $percent      = $Paper->_getOutstandingPaperStatistics($eventIDX, $inCardType);
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my %STATUS       = (0=>'Not Started', 1=>'Draft', 2=>'Completed');
    my %TYPE         = (1=>'Design reports', 2=>'TDS reports', 3=>'Drawings', 4=>'Design requirements');
    print $q->header();

    my $txt = sprintf "Hi Folks,\n\n";
    # $txt .=  "$eventIDX, $userIDX  \n";
    # $txt .= join("; ", keys %PAPER)."\n\n";
    $txt .= "Thank you all again for volunteering your time to grade this year's SAE Aero-Design Student Design Report for the upcoming competition.  ";
    $txt .= "This is just a friendly reminder that the due date to have all the assessments completed is quickly approaching and ";
    $txt .= sprintf "there are still several outstanding %s to complete.\n", $TYPE{$inCardType};
    
    $txt .= sprintf "\n  Current Complete Status = %2.2f%\n", $percent;
    $txt .= "\nWhen complete, make sure to click on [ Save as Final ] to complete and finalize your assessment for each design report.  ";
    $txt .= "Once all your allocated design reports have completed, you will drop off my weekly/daily reminder emails.";
    $txt .= "\n\nThank you again for volunteering to support this event.\n\n";
    $txt .= sprintf "Sincerely,\n\nDesign Report Coordinator\n%s", &properCase($ADMIN{TX_FIRST_NAME});

    my $str;
    $str = '<div class="w3-container">';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-envelope-o"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<input ID="EMAIL_TO" class="w3-input w3-border" name="first" type="text" placeholder="Email" value="%s">', join(", ", keys %EMAIL);
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-pencil" aria-hidden="true"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<input ID="EMAIL_SUBJECT" class="w3-input w3-border" name="first" type="text" placeholder="Email" value="ACTION REQUIRED: SAE %s Assessments are Due Soon">', $TYPE{$inCardType};
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-info-circle"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<textarea ID="EMAIL_MESSAGE" class="w3-padding" style="max-width: 100%; min-width: 100%; min-height: 360px;">%s</textarea>', $txt;
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa " aria-hidden="true"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<button class="w3-button w3-blue w3-border w3-card w3-round w3-padding w3-margin-right" style="width: 150px;" onclick="paper_sendMail(this, \'%s\');"><i class="w3-xlarge fa fa-paper-plane-o w3-margin-right" aria-hidden="true"> </i>Send</button>', $ADMIN{TX_EMAIL};
    $str .= '<button class="w3-button         w3-border w3-card w3-round w3-padding w3-margin-left" onclick="$(this).close();">Cancel</button>';
    $str .= '</div><br><br>';
    $str .= '</div>';

    $str .= '</div>';
    return ($str);
    }
sub paper_openSendReminder (){
    my $eventIDX     = $q->param('eventIDX');
    my $userIDX      = $q->param('userIDX');
    my $loginUserIDX = $q->param('loginUserIDX');
    my $inCardType   = $q->param('inCardType');
    my $User         = new SAE::USER();
    my $Paper        = new SAE::PAPER();
    my %USER         = %{$User->_getUserDetails($userIDX)};
    my %ADMIN        = %{$User->_getUserDetails($loginUserIDX)};
    my %PAPER        = %{$Paper->_getUserAssignedPapers($eventIDX, $userIDX, $inCardType)};
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my %STATUS       = (0=>'Not Started', 1=>'Draft', 2=>'Completed');
    my %TYPE         = (1=>'Design report', 2=>'TDS report', 3=>'Drawing', 4=>'Design Requirement');
    print $q->header();

    my $txt = sprintf "Hi %s,\n\n", &properCase($USER{TX_FIRST_NAME});
    # $txt .=  "$eventIDX, $userIDX  \n";
    # $txt .= join("; ", keys %PAPER)."\n\n";
    $txt .= "Thank you again for volunteering your time to grade this year's SAE Aero-Design Student Design Report for the upcoming competition.  ";
    $txt .= "This is just a friendly reminder that the due date to have all the assessments completed is quickly approaching and ";
    $txt .= sprintf "you still have several outstanding %s assessments to complete.\n\n", $TYPE{$inCardType};
    foreach $cardIDX (sort {$PAPER{$a}{IN_NUMBER} <=> $PAPER{$b}{IN_NUMBER}} keys %PAPER) {
        $txt .= sprintf "  - ( %s ) %03d: %s \n", $STATUS{$PAPER{$cardIDX}{IN_STATUS}}, $PAPER{$cardIDX}{IN_NUMBER}, $PAPER{$cardIDX}{TX_SCHOOL};
    }
    $txt .= "\nWhen complete, make sure to click on [ Save as Final ] to complete and finalize your assessment for each design report.  ";
    $txt .= "Once all your allocated design reports have completed, you will drop off my weekly/daily reminder emails.";
    $txt .= "\n\nThank you again for volunteering to support this event.\n\n";
    $txt .= sprintf "Sincerely,\n\nDesign Report Coordinator\n%s", &properCase($ADMIN{TX_FIRST_NAME});

    my $str;
    $str = '<div class="w3-container">';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-envelope-o"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<input ID="EMAIL_TO" class="w3-input w3-border" name="first" type="text" placeholder="Email" value="%s">', $USER{TX_EMAIL};
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-pencil" aria-hidden="true"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<input ID="EMAIL_SUBJECT" class="w3-input w3-border" name="first" type="text" placeholder="Email" value="ACTION REQUIRED: SAE %s Assessments are Due Soon">', $TYPE{$inCardType};
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-info-circle"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<textarea ID="EMAIL_MESSAGE" class="w3-padding" style="max-width: 100%; min-width: 100%; min-height: 360px;">%s</textarea>', $txt;
    $str .= '</div>';
    $str .= '</div>';

    $str .= '<div class="w3-row w3-section">';
    $str .= '<div class="w3-col" style="width:50px"><i class="w3-xxlarge fa " aria-hidden="true"></i></div>';
    $str .= '<div class="w3-rest">';
    $str .= sprintf '<button class="w3-button w3-blue w3-border w3-card w3-round w3-padding w3-margin-right" style="width: 150px;" onclick="paper_sendMail(this, \'%s\');"><i class="w3-xlarge fa fa-paper-plane-o w3-margin-right" aria-hidden="true"> </i>Send</button>', $ADMIN{TX_EMAIL};
    $str .= '<button class="w3-button         w3-border w3-card w3-round w3-padding w3-margin-left" onclick="$(this).close();">Cancel</button>';
    $str .= '</div><br><br>';
    $str .= '</div>';

    $str .= '</div>';
    return ($str);
    }
sub paper_openJudgeView(){
    print $q->header();
    my $eventIDX   = $q->param('location');
    my $str;
    $str = &view_judgeView($eventIDX);
    return ($str);
    }
sub paper_openTeamView(){
    print $q->header();
    my $eventIDX   = $q->param('location');
    my $str;
    $str = &view_teamView($eventIDX);
    return ($str);
    }
sub paper_batchRemoval (){
    my $eventIDX  = $q->param('eventIDX');
    my $classIDX  = $q->param('classIDX');
    my $inCardType= $q->param('inCardType');
    print $q->header();
    my $Paper = new SAE::PAPER();
    $Paper->_batchRemoval($eventIDX, $classIDX, $inCardType);

    return ($str);
    }
sub paper_batchAssign (){
    my $eventIDX  = $q->param('eventIDX');
    my $classIDX  = $q->param('classIDX');
    my $userIDX   = $q->param('userIDX');
    my $inCardType= $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper = new SAE::PAPER();
    $Paper->_batchAssign($eventIDX, $classIDX, $userIDX, $inCardType);
    my $str;

    return ($str);
    }
sub paper_autoAssign (){
    my $eventIDX= $q->param('eventIDX');
    my $classIDX= $q->param('classIDX');
    my $inLimit= $q->param('inLimit');
    my $inCardType= $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $Paper = new SAE::PAPER();
    my $str   = $Paper->_autoAssign($eventIDX, $classIDX, $inLimit, $inCardType);
    return ($str);
    }
sub paper_openAutoAssign (){
    my $eventIDX   = $q->param('eventIDX');
    my $inCardType = $q->param('inCardType');
    my @tm         = localtime();
    my $txYear     = ($tm[5] + 1900);
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my %CLASS      = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my %TYPE       = (1=>'Design Report', 2=>'TDS', 3=>'3d Drawing', 4=>'Requirements');
    print $q->header();
    # my $Paper      = new SAE::PAPER();
    my $Profile      = new SAE::PROFILE();
    my %EVENT      = %{$Profile->_getEventDetails( $eventIDX )};
    my $site       = lc($EVENT{TX_EVENT});
    my $str;
    $str .= '<div class="w3-container">';
    # my %USERS      = %{$Paper->_getListOfJudges($eventIDX, $inCardType)};
    # $str .= scalar (keys );
    $str .= '<ul class="w3-ul">';
    if ($inCardType == 1) {
        foreach $classIDX (sort keys %CLASS) {
            $str .= '<li class="w3-bar w3-border w3-white w3-round">';
            $str .= '<div class="w3-bar-item w3-right">';
            # $str .= sprintf '<button class="w3-border w3-round w3-button w3-pale-green w3-hover-green" onclick="paper_autoAssign(this, %d, %d);">Auto Assign</button><br>', $classIDX, $inCardType;
            $str .= sprintf '<button class="w3-border w3-round w3-button w3-pale-red w3-hover-red w3-margin-top" onclick="paper_batchRemoval(this, %d, %d);">Bacth Removal</button>', $classIDX, $inCardType;
            $str .= '</div>';
            $str .= '<div class="w3-bar-item" >';
            $str .= sprintf '<h4>%s Class: %s</h4>', $CLASS{$classIDX}, $TYPE{$inCardType};
            $str .= sprintf '<input ID="CLASS_LIMIT_%d" type="number" style="width: 200px; display: inline" class="w3-input w3-border w3-round" placeholder="# or Reports/Judge">', $classIDX;
            $str .= sprintf '<button class="w3-margin-left w3-border w3-round w3-button w3-pale-green w3-hover-green" style="display: inline" onclick="paper_autoAssign(this, %d, %d);">Auto Assign</button>', $classIDX, $inCardType;
            # $str .= '<i>Judges Preferences are defined in the Judge\'s preference menu.</i>';
            $str .= '</div>';
            $str .= '</li>';
        }
    } else {
        foreach $classIDX (sort keys %CLASS) {
            my %USERS = %{$Profile->_getAvailableJudges($inCardType, $txYear, $site, $classIDX)};
            # $str .= "$inCardType, $txYear, $site, $classIDX<br>";
            $str .= '<li class="w3-bar w3-border w3-white w3-round">';
            $str .= '<div class="w3-bar-item w3-right">';
            $str .= sprintf '<button class="w3-border w3-round w3-button w3-pale-red w3-hover-red w3-margin-top" onclick="paper_batchRemoval(this, %d, %d);">Bacth Removal</button>', $classIDX, $inCardType;
            $str .= '</div>';
            $str .= '<div class="w3-bar-item">';
            $str .= sprintf '<h4>%s Class: %s</h4>', $CLASS{$classIDX}, $TYPE{$inCardType};
            $str .= sprintf '<select id="BATCH_%d" style="width: 200px; display: inline;" class="w3-input w3-border w3-round">', $classIDX;
            foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
                $str .= sprintf '<option value="%d">%s, %s</option>', $userIDX, $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
            }
            $str .= '</select>';
            $str .= sprintf '<button class="w3-margin-left w3-border w3-round w3-button w3-pale-green w3-hover-green" onclick="paper_batchAssign(this, %d, %d);">Batch Assign</button><br>', $classIDX, $inCardType;
            $str .= '</div>';
            $str .= '</li>';
        }
    }
    $str .= '</ul>';
    $str .= '</div>';

    return ($str);
    }
sub paper_removeCardFromJudge (){
    my $cardIDX= $q->param('cardIDX');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_delete('TB_CARD', qq(PK_CARD_IDX=$cardIDX));
    my $str;

    return ($str);
    }
sub paper_deleteUserAssignment (){
    my $eventIDX= $q->param('eventIDX');
    my $cardIDX= $q->param('cardIDX');
    my $userIDX= $q->param('userIDX');
    my $teamIDX= $q->param('teamIDX');
    my $inCardType= $q->param('inCardType');
    # my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_delete('TB_CARD', qq(PK_CARD_IDX=$cardIDX));
    my $str;
    $str = &t_nameTagAvailable($inCardType, $eventIDX, $userIDX, $teamIDX);
    return ($str);
    }
sub createList (){
    # my $eventIDX= $q->param('eventIDX');
    my $txName= $q->param('txName');
    my %DATA = %{decode_json($q->param('jsonData'))};
    print $q->header();
    my $JsonDB = new SAE::JSONDB();
    my $newIDX = $JsonDB->_insert('TB_CARD', \%DATA);
    my $Paper = new SAE::PAPER();
    my %TEAM  = %{$Paper->_getTeamDetails($DATA{FK_TEAM_IDX})};
    my $inNumber = $TEAM{IN_NUMBER};
    my $txSchool = $TEAM{TX_SCHOOL};
    my $classIDX = $TEAM{FK_CLASS_IDX};
    my $str = &t_nameTag($newIDX , $txName, 0, $DATA{FK_USER_IDX}, $DATA{FK_TEAM_IDX}, $DATA{FK_CARDTYPE_IDX}, $inNumber, $txSchool, $classIDX );

    return ($str );
    }
sub paper_openAvailableJudges (){
    my $eventIDX   = $q->param('eventIDX');
    my $classIDX   = $q->param('classIDX');
    my $teamIDX    = $q->param('teamIDX');
    my $inCardType = $q->param('inCardType');
    my %CLASS      = (1=>'Regular', 2=>'Advanced', 3=>'Micro');
    my %TYPE       = (1=>'Design Report', 2=>'TDS', 3=>'3d Drawing', 4=>'Requirements');
    my %TARGET     = (1=>'designReport_'.$teamIDX, 2=>'tds_'.$teamIDX, 3=>'3dDrawing_'.$teamIDX, 4=>'Requirements_'.$teamIDX);
    print $q->header();
    my @tm         = localtime();
    my $txYear     = ($tm[5] + 1900);
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $Paper      = new SAE::PAPER();
    my $Profile    = new SAE::PROFILE();
    # my $eventYear  = $Paper->_getEventYear( $eventIDX );
    # my %TEAM       = %{$Profile->_getTeamDetails($teamIDX)};
    my %EVENT      = %{$Profile->_getEventDetails( $eventIDX )};
    my $inNumber   = $TEAM{IN_NUMBER};
    my $txSchool   = $TEAM{TX_SCHOOL};
    my $classIDX   = $TEAM{FK_CLASS_IDX};
    my %USERS      = %{$Profile->_getAvailableJudges($inCardType, $txYear, $EVENT{TX_EVENT}, $classIDX)};
    my %JUDGE      = %{$Paper->_getJudgeAssignmentByTeam($inCardType, $teamIDX)};
    my %COUNT      = %{$Paper->_getAssignmentCount($inCardType, $eventIDX)};
    my $str;
    $str .= '<div class="w3-container w3-light-grey">';
    $str .= sprintf '<h3>%s Judges</h3>', $TYPE{$inCardType};
    $str .= sprintf '<div class="w3-container tag-name %s w3-white" style="min-height: 55px;">', $TARGET{$inCardType};
    foreach $userIDX (sort {lc ($JUDGE{$a}{TX_LAST_NAME}) cmp lc($JUDGE{$b}{TX_LAST_NAME})} keys %JUDGE) {
        my $cardIDX   = $JUDGE{$userIDX}{PK_CARD_IDX};
        my $judgeName = sprintf '%s, %s', $JUDGE{$userIDX}{TX_LAST_NAME}, $JUDGE{$userIDX}{TX_FIRST_NAME};
        my $inStatus  = $JUDGE{$userIDX}{IN_STATUS};
        $str .= &t_nameTag($cardIDX, $judgeName, $inStatus , $userIDX, $teamIDX, $inCardType, $inNumber, $txSchool, $classIDX);
    }
    $str .= '</div>';
    $str .= sprintf '<h3>Judges availalbe for %s Class %s</h3>', $CLASS{$classIDX}, $TYPE{$inCardType};
    $str .= '<div ID="div_available_judges" class="w3-container tag-name w3-white">';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        if (exists $JUDGE{$userIDX}){next}
        my $txName = sprintf '%s, %s', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
        my $assignmentCount = $COUNT{$userIDX}{IN_TOTAL};
        $str .= &t_nameTagAvailable($inCardType, $eventIDX, $userIDX, $teamIDX,);
    }
    $str .= '</div>';
    return ($str);
    }
sub paper_openManagePapers(){
    print $q->header();
	my $eventIDX   = $q->param('location');
    $str .= '<div class="w3-container w3-margin-top">';
    $str .= '<br><h2>Manage Papers</h2>';
    $str .= '<div class="w3-bar w3-black w3-margin-top" style="w3-margin-top: 25px;">';
    $str .= '<button class="w3-bar-item w3-button paperTab w3-red" data-key="TeamView"    onclick="paperOpenTab(this);">Teams</button>';
    $str .= '<button class="w3-bar-item w3-button paperTab"        data-key="JudgeView"   onclick="paperOpenTab(this);">Judges</button>';
    $str .= '<button class="w3-bar-item w3-button paperTab"        data-key="JudgeStats"  onclick="sae_openStatView(this,1);">Judge\'s Statistics View</button>';
    $str .= '<button class="w3-bar-item w3-button paperTab"        data-key="TestStats"   onclick="sae_openStatTeamView(this, 1);">Team\'s Statistics</button>';
    $str .= '<button class="w3-bar-item w3-button paperTab"        data-key="RubricStats" onclick="sae_openStatBreakdown(this, 1);">Rubric Statistics</button>';
    $str .= '</div>';
    $str .= '<div id="tabContent"    class="w3-container w3-white" style="padding: 0px;">';
    $str .= &view_teamView($eventIDX);
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
    }
sub t_nameTagAvailable (){
    # my ($userIDX, $txName, $teamIDX, $inCardType, $inCount) = @_;
    my ($inCardType, $eventIDX, $userIDX, $teamIDX) = @_;
    my $Paper = new SAE::PAPER();
    my %DATA = %{$Paper->_getUserDetails($inCardType, $eventIDX, $userIDX)};
    my $txName = sprintf '%s, %s',$DATA{TX_LAST_NAME}, $DATA{TX_FIRST_NAME};
    my $inCount = $DATA{IN_COUNT};

    my %TARGET = (1=>'designReport_'.$teamIDX, 2=>'tds_'.$teamIDX, 3=>'3dDrawing_'.$teamIDX, 4=>'Requirements_'.$teamIDX);
    my $str;
    $str .= sprintf '<span ID="span_available_'.$userIDX.'" class="tag w3-hover-pale-yellow">';
    $str .= sprintf '<i class="w3-round w3-hover-green w3-button fa fa-plus" style="padding: 3px 5px;" onclick="createList(this, \'%s\',\'%s\', %d, %d, %d);"></i>', $txName, $TARGET{$inCardType}, $userIDX, $teamIDX, $inCardType;
    $str .= sprintf ' %s', $txName;
    my $color = '';
    if ($inCount>5){
       $color = 'w3-pale-red ';
    } elsif ($inCount>2) {
       $color = 'w3-pale-yellow ';
    } else {
       $color = 'w3-pale-green ';
    }
    $str .= sprintf ' <span class="%s w3-margin-left w3-circle w3-border w3-small" style="padding: 2px 7px">%d</span>', $color, $inCount;
    $str .= '</span>';

    return ($str);
    }
sub t_nameTag (){
    my ($cardIDX, $label, $inStatus, $userIDX, $teamIDX, $inCardType, $inNumber, $txSchool, $classIDX) = @_;
    
    my $str;
    $str = sprintf '<span class="tag %s w3-hover-pale-yellow span_assigned_%d" ><u style="cursor: pointer;" onclick="grade_openAssessment(this, %d, %d, \'%s\', %d, %d, %d, %d);">%s</u>',$COLOR{$inStatus}, $cardIDX, $cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $userIDX, $label;
    if ($inStatus<2){
        $str .= sprintf '<i class="w3-round w3-margin-left w3-hover-red w3-button fa fa-close" style="padding: 3px 5px;" onclick="paper_deleteUserAssignment(this, %d, %d, %d, %d);"></i>', $cardIDX, $userIDX, $teamIDX, $inCardType;
    }
    $str .= '</span>';
    return ($str);
    }
sub t_JudgeView (){
    my ($title, $btn, $inCardType, $adminUserIDX, $hash1, $hash2) = @_;
    my %TYPE  = (1=>'Design Report', 2=>'TDS Report', 3=>'Drawing', 4=>'Design Requirement');
    my %USERS = %$hash1;
    my %CARDS = %$hash2;
    my $str;
    $str .= '<h3 class="w3-margin-left w3-border w3-blue-grey w3-round w3-margin-top w3-padding">'.$title;
    $str .= sprintf '<button class="w3-margin-left w3-large w3-button w3-round w3-border w3-light-grey w3-hover-yellow" onclick="paper_openSendReminderToAll(this, '.$inCardType.')">Send Reminder Email to %s Judges</button></h3>', $TYPE{$inCardType};
    $str .= '<div class="w3-container" style="padding: 0px;">';
    $str .= '<table class="w3-table w3-bordered" style="width: 100%;">';
    $str .= '<tr>';
    $str .= '<th style="width: 15%">Judge\'s Name</th>';
    $str .= '<th style="width: 85%">Assigned Teams</th>';
    $str .= '</tr>';
    $str .= '<tbody>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $str .= '<tr>';
        $str .= sprintf '<td class="w3-large">%s, %s<br>', $USERS{$userIDX}{TX_LAST_NAME}, $USERS{$userIDX}{TX_FIRST_NAME};
        $str .= sprintf '<a style="text-decoration: none;" href="javascript:void(0);" onclick="paper_openSendReminder(this, %d, %d);">Send Reminder</a>', $userIDX, $inCardType;
        $str .= '</td>';
        $str .= '<td ID="TD_ASSIGNED_TEAM_'.$inCardType.'_'.$userIDX.'" style="vertical-align: top; display: flex; flex-wrap: wrap;">';
        foreach $cardIDX (sort {$CARDS{$userIDX}{$a}{IN_NUMBER} <=> $CARDS{$userIDX}{$b}{IN_NUMBER}} keys %{$CARDS{$userIDX}}) {
            my $inNumber  = $CARDS{$userIDX}{$cardIDX}{IN_NUMBER};
            my $txSchool  = $CARDS{$userIDX}{$cardIDX}{TX_SCHOOL};
            my $inStatus  = $CARDS{$userIDX}{$cardIDX}{IN_STATUS};
            my $classIDX  = $CARDS{$userIDX}{$cardIDX}{FK_CLASS_IDX};
            my $teamIDX  = $CARDS{$userIDX}{$cardIDX}{FK_TEAM_IDX};
            my $inCardType  = $CARDS{$userIDX}{$cardIDX}{FK_CARDTYPE_IDX};
            $str .= &t_paperCard($cardIDX, $inStatus, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $userIDX, $btn);
        }
        $str .= &t_addTeamButton($userIDX, $inCardType);
        $str .= '</div>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    return ($str);
    }
sub t_paperCard (){
    my ($cardIDX, $inStatus, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $userIDX, $btn) = @_;
    # my %DATA = %{decode_json($q->param('jsonData'))};
    my $str;
    $str .= '<div ID="CARD_'.$cardIDX.'" class="w3-card-4 w3-margin-left w3-margin-bottom w3-white w3-display-container" style="width: 225px;">';
    if ($inStatus <2){
        $str .= '<i class="fa fa-times w3-display-topright w3-transparent w3-button w3-hover-red w3-round" aria-hidden="true" style="margin-top: 5px; margin-right: 5px;" onclick="paper_removeCardFromJudge(this, '.$cardIDX.')"></i>';
    }
    $str .= sprintf '<header class="w3-container %s">', $COLOR{$inStatus};
    $str .= sprintf '<h4>#: %03d</h4>', $inNumber;
    $str .= sprintf '</header>', $inNumber;
    $str .= '<div class="w3-container w3-white" style="height: 43px; overflow-y: hidden">';
    my $cutOff = 35;
    $str .= sprintf '%s', substr($txSchool,0,$cutOff);
    if (length($txSchool)>$cutOff){
        $str .= '...';
    }
    $str .= '</div>';
    $str .= sprintf '<button class="w3-button w3-block w3-dark-grey" style="position: relative; bottom: 0px;" onclick="grade_openAssessment(this, %d, %d, \'%s\', %d, %d, %d, %d);">%s</button>', $cardIDX, $inNumber, $txSchool, $classIDX, $teamIDX, $inCardType, $userIDX, $btn;
    $str .= '</div>';
    return ($str);
    }
sub t_addTeamButton (){
    my ($userIDX, $inCardType) = @_;
    my $str;
    $str .= '<button ID="USER_'.$userIDX.'" class="w3-container w3-margin-left w3-button" style="border: 3px dashed #ddd; width: 225px; height: 125px;" onclick="paper_openShowAvailableTeams(this, '.$userIDX.', '.$inCardType.')">';
    $str .= '<h4 class="w3-center w3-text-light-grey">Add Paper</h4>';
    $str .= '<div class="w3-container w3-center" style="height: 70px; overflow-y: hidden">';
    $str .= '<i class="fa fa-3x fa-plus w3-text-light-grey" aria-hidden="true"></i>';
    $str .= '</button>';
    return ($str);
    }
sub view_judgeView (){
    my $eventIDX   = $q->param('eventIDX');
    my $adminUserIDX   = $q->param('adminUserIDX');
    my $Profile    = new SAE::PROFILE();
    my %USERS      = %{$Profile->_getDesignJudges($txYear)}; 
    my %DESIGN     = %{$Profile->_getAssignment($eventIDX, 1)};
    my %TDS_USER   = %{$Profile->_getTdsJudges($txYear)}; 
    my %TDS        = %{$Profile->_getAssignment($eventIDX, 2)};
    my %DRW_USER   = %{$Profile->_getDrwJudges($txYear)}; 
    my %DRW        = %{$Profile->_getAssignment($eventIDX, 3)};
    my %REQ_USER   = %{$Profile->_getReqJudges($txYear)}; 
    my %REQ        = %{$Profile->_getAssignment($eventIDX, 4)};
    my $str;
    $str .= &t_JudgeView('Design Report Assignments', 'Goto Design Report', 1, $adminUserIDX, \%USERS, \%DESIGN);
    $str .= &t_JudgeView('TDS Report Assignments', 'Goto TDS',  2, $adminUserIDX, \%TDS_USER , \%TDS);
    $str .= &t_JudgeView('Drawing Report Assignments', 'Goto Drawings',  3, $adminUserIDX, \%DRW_USER , \%DRW);
    $str .= &t_JudgeView('Requirement Report Assignments', 'Goto Req\'ts',  4, $adminUserIDX, \%REQ_USER , \%REQ);

    return ($str);
    }
sub view_teamView (){
    my ($eventIDX) = @_; #= $q->param('eventIDX');

    # my %DATA = %{decode_json($q->param('jsonData'))};
    # print $q->header();
    my $str;
    my $Paper      = new SAE::PAPER();
    my %TEAMS      = %{$Paper->_getTeamList($eventIDX)};
    
    # my %JUDGE      = %{$Paper->_getAllJudges()};
    my %ASSIGNMENT = %{$Paper->_getJudgeAssignment($eventIDX)};
    my $str;
    
    # $str .= '<div class="w3-container w3-margin-top w3-padding">';
    # $str .= '<h2 class="w3-margin-top">Manage Paper</h2>';
    $str .= '<table class="w3-table-all w3-bordered w3-white" style="width: 100%; margin: 0px;">';
    $str .= '<tr>';
    $str .= '<th style="vertical-align: middle"># - School</th>';
    $str .= '<th style="width: 400px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 1);">Design: Auto Assignment</button>';
    $str .= '</th>';
    $str .= '<th style="width: 170px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 2);">TDS: Batch</button>';
    $str .= '</th>';    
    $str .= '<th style="width: 170px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 3);">Drawing: Batch</button>';
    $str .= '</th>';    
    $str .= '<th style="width: 170px;">';
    $str .= '<button class="w3-button w3-border w3-round w3-card w3-hover-green" onclick="paper_openAutoAssign(this, 4);">Req.: Batch</button>';
    $str .= '</th>';

    $str .= '</tr>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my %DESIGN     = %{$ASSIGNMENT{1}{$teamIDX}};
        my %TDS        = %{$ASSIGNMENT{2}{$teamIDX}};
        my %DRAWING    = %{$ASSIGNMENT{3}{$teamIDX}};
        my %REQ        = %{$ASSIGNMENT{4}{$teamIDX}};
        my $classIDX   = $TEAMS{$teamIDX}{FK_CLASS_IDX};
        my $title      = "$CLASS{$classIDX} Class Judge Assignment";
        my $inNumber   = $TEAMS{$teamIDX}{IN_NUMBER};
        my %TARGET     = (1=>'designReport_'.$teamIDX, 2=>'tds_'.$teamIDX, 3=>'3dDrawing_'.$teamIDX, 4=>'Requirements_'.$teamIDX);
        my $txSchool = sprintf '<b>%03d</b>-%s<br><i class="w3-small">%s - %s Class</i>',$TEAMS{$teamIDX}{IN_NUMBER}, $TEAMS{$teamIDX}{TX_SCHOOL}, $TEAMS{$teamIDX}{TX_COUNTRY}, $CLASS{$classIDX };
        $str .= '<tr>';
        $str .= sprintf '<td>%s</td>', $txSchool;
        # $str .= sprintf '<td></td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{1};
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 1;
        foreach $userIDX (sort {lc($DESIGN{$a}{TX_LAST_NAME}) cmp lc($DESIGN{$b}{TX_LAST_NAME})} keys %DESIGN) {
            my $cardIDX   = $DESIGN{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $DESIGN{$userIDX}{TX_LAST_NAME}, $DESIGN{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $DESIGN{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 1, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{2};
        # $str .= '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true"></i>';
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 2;
        foreach $userIDX (sort keys %TDS) {
            my $cardIDX = $TDS{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $TDS{$userIDX}{TX_LAST_NAME}, $TDS{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $TDS{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 2, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{3};
        # $str .= '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true"></i>';
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 3;
        foreach $userIDX (sort keys %DRAWING) {
            my $cardIDX = $DRAWING{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $DRAWING{$userIDX}{TX_LAST_NAME}, $DRAWING{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $DRAWING{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 3, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= sprintf '<td nowrap>';
        $str .= sprintf '<div class="w3-container tag-name %s">', $TARGET{4};
        # $str .= '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true"></i>';
        $str .= sprintf '<i class="fa fa-plus w3-button w3-border w3-round w3-green tag" aria-hidden="true" onClick="paper_openAvailableJudges(this, %d, %d, %d);"></i>',$teamIDX, $classIDX, 4;
        foreach $userIDX (sort keys %REQ) {
            my $cardIDX = $REQ{$userIDX}{PK_CARD_IDX};
            my $judgeName = sprintf '%s, %s', $REQ{$userIDX}{TX_LAST_NAME}, $REQ{$userIDX}{TX_FIRST_NAME};
            my $inStatus  = $REQ{$userIDX}{IN_STATUS};
            $str .= &t_nameTag($cardIDX, $judgeName, $inStatus, $userIDX, $teamIDX, 4, $inNumber, $TEAMS{$teamIDX}{TX_SCHOOL}, $classIDX);
        }
        $str .= '</div>';
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</table>';
    # $str .= '</div>';
    return ($str);
    }
sub _templateTeamView(){
    # print $q->header();
    my $location = $q->param('location');
    my $Auto = new SAE::AUTO();
    my $Ref = new SAE::REFERENCE();
    my %STATUS = (0=>"To Do", 1=>"Draft", 2=>"Done");
    my %W3CLASS = (1=>"w3-yellow w3-border", 2=>"w3-blue w3-border");
    my %TYPE = (1=>'Reports', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    my %LATE = %{$Ref->_getLateReportListByEvent($location)};
    my $str;

    %TEAMS = %{$Ref->_getTeamDataByEvent($location)};
    %PAPER = %{$Ref->_getDocuments($location)};
    my %ASSIGNED = %{$Auto->_getAssignedPapers($location)};
    $str .= '<table class="w3-table-all w3-hoverable w3-hover-yellow w3-white  w3-small">';
    $str .= '<thead>';
    $str .= '<tr class="w3-blue-grey w3-hide-small" style="">';
    # $str .= '<th style="width: 5%; text-align: center; vertical-align: text-bottom">#</th>';
    $str .= '<th style="width: 30%; text-align: left; vertical-align: text-bottom" nowrap>School</th>'; 
    $str .= '<th style="width: 4%; text-align: left; vertical-align: text-bottom" nowrap>Days<br>Late</th>'; 
    $str .= '<th style="width: 10%; text-align: left; vertical-align: text-bottom" nowrap>Documents<br><a class="w3-text-white" href="javascript:void(0);" onclick="openFileUpload(\'openUploadDiv\');">Upload</a></th>';
    $str .= '<th style="width: 15%; text-align: center; vertical-align: text-bottom" nowrap>Report Judges<br><a class="w3-text-white" href="javascript:void(0);" onclick="loadAutoAssignPapers();">Batch Auto Assign</a><br><a class="w3-text-white" href="javascript:void(0);" onclick="sae_batchRemoveDesignReportJudges();">Batch Remove</a></th>';
    $str .= '<th style="width: 12%; text-align: center; vertical-align: text-bottom" nowrap>TDS<br><a class="w3-text-white" href="javascript:void(0);"  onclick="loadBatchAssign(2);">Batch Assign</a></th>';
    $str .= '<th style="width: 12%; text-align: center; vertical-align: text-bottom" nowrap>Drawings<br><a class="w3-text-white" href="javascript:void(0);"  onclick="loadBatchAssign(3);">Batch Assign</a></th>';
    $str .= '<th style="width: 12%; text-align: center; vertical-align: text-bottom" nowrap>Requirements<br><a class="w3-text-white" href="javascript:void(0);"  onclick="loadBatchAssign(4);">Batch Assign</a></th>';
    $str .= '<tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $teamIDX (sort {$TEAMS{$a}{IN_NUMBER} <=> $TEAMS{$b}{IN_NUMBER}} keys %TEAMS) {
        my $eIDX = crypt($teamIDX, '20');
        my $teamNumber = substr("000".$TEAMS{$teamIDX}{IN_NUMBER},-3,3);
        my $txSchool = $teamNumber.' - '.$TEAMS{$teamIDX}{TX_SCHOOL};
        $str .= '<tr class="w3-hide-small">';
        # $str .= '<td>'.$teamNumber.'</td>';
        $str .= '<td><a class="w3-link" href="javascript:void(0);" onclick="openAssignmentDetails('.$teamIDX.')">'.$txSchool.'</a></td>';
        my $boLate= 0;
        if (exists $LATE{$teamIDX}){$boLate = 1}
        $str .= sprintf '<td><a href="javascript:void(0);" onclick="sae_updateDaysLate(this, %2d, %2d, %1d);">%2d</a></td>', $teamIDX, $LATE{$teamIDX}{IN_DAYS}, $boLate, $LATE{$teamIDX}{IN_DAYS};
        $str .= '<td>';
        foreach $uploadIDX (sort keys %{$PAPER{$teamIDX}}) {
            # $str .= 'test';
            # $str .= '<i class="fa fa-file-pdf-o fa-fw"></i><a href="view.php?doc='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
            $str .= '<i class="fa fa-file-pdf-o fa-fw"></i><a href="read.html?fileID='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
        }
        $str .= '</td>';
        for ($inType=1; $inType<=4; $inType++){
            $str .= '<td style="; text-align: right;" ID="paper_'.$teamIDX.'">';
            foreach $userIDX (sort {lc($ASSIGNED{1}{$teamIDX}{$a}{TX_LAST_NAME}) cmp lc($ASSIGNED{1}{$teamIDX}{$b}{TX_FIRST_NAME})} keys %{$ASSIGNED{$inType}{$teamIDX}}){
                $name = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_LAST_NAME}.", ".$ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_FIRST_NAME};
                $inStatus = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{IN_STATUS};
                if ($inStatus>0){
                    $str .= '<div class="'.$W3CLASS{$inStatus}.' w3-padding-small w3-round"><a class="w3-text-white" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">'.$name.'</a></div>';
                } else {
                    $str .= '<div class="'.$W3CLASS{$inStatus}.' w3-padding-small w3-round">'.$name.'</div>';
                }
                
            }
            $str .= '</td>';
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td>';
        $str .= sprintf '<span>%s</span><br>', $txSchool ;
        $str .= '<b>Documents:</b><br><span>';
        foreach $uploadIDX (sort keys %{$PAPER{$teamIDX}}) {
            # $str .= '<i class="fa fa-file-pdf-o fa-fw w3-margin-left"></i><a href="view.php?doc='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
            $str .= '<i class="fa fa-file-pdf-o fa-fw w3-margin-left"></i><a href="read.html?fileID='.$PAPER{$teamIDX}{$uploadIDX}{TX_KEYS}.'" target="_blank">'.$PAPER{$teamIDX}{$uploadIDX}{TX_PAPER}.'</a><br>';
        }
        $str .= '</span><br>';
        for ($inType=1; $inType<=4; $inType++){
            $str .= '<b>'.$TYPE{$inType}.' Judges:</b><br><span>';
            foreach $userIDX (sort {lc($ASSIGNED{$inType}{$teamIDX}{$a}{TX_LAST_NAME}) cmp lc($ASSIGNED{$inType}{$teamIDX}{$b}{TX_FIRST_NAME})} keys %{$ASSIGNED{$inType}{$teamIDX}}){
                $name = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_LAST_NAME}.", ".$ASSIGNED{$inType}{$teamIDX}{$userIDX}{TX_FIRST_NAME};
                $inStatus = $ASSIGNED{$inType}{$teamIDX}{$userIDX}{IN_STATUS};
                $str .= '<div class="'.$W3CLASS{$inStatus}.' w3-margin-left  w3-padding-small w3-round">'.$name.'</div>';
            }
            $str .= '</span><br>';
        }
        $str .= '</td>';
        $str .= '</tr>';

    }
    $str .= '</tbody>';
    $str .= '</table>';
    # $str .= '</div>';

    return ($str);
    }
sub _templateJudgeView(){
    my $location = $q->param('location');
    my %W3CLASS = (0=>"w3-white", 1=>"w3-yellow  w3-border", 2=>"w3-blue  w3-border");
    my %TYPE = (1=>'Reports', 2=>'TDS', 3=>'Drawings', 4=>'Requirements');
    my %CLASS = (1=>'Regular',2=>'Advanced',3=>'Micro');
    my $str;
    my $Card = new SAE::CARD();
    %USERS = %{$Card->_getListOfJudges($location)};
    %CARDS = %{$Card->_getCardList($location)};
    %AVGSTATUS = %{$Card->_getAverageCardStatus($location)};
    %CPREF = %{$Card->_getClassPreference($location)};
    
    $str .= '<table class="w3-table-all w3-white w3-small">';
    $str .= '<thead>';
    $str .= '<tr class="w3-blue-grey w3-hide-small">';
    $str .= '<th style="width: 14%">Judge</th>';
    $str .= '<th style="width: 10%">Class<br>Preference</th>';
    $str .= '<th style="width: 20%">Reports</th>';
    $str .= '<th style="width: 13%">TDS</th>';
    $str .= '<th style="width: 13%">Drawings</th>';
    $str .= '<th style="width: 13%">Requirements</th>';
    $str .= '<tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $userIDX (sort {lc($USERS{$a}{TX_LAST_NAME}) cmp lc($USERS{$b}{TX_LAST_NAME})} keys %USERS) {
        $userName = $USERS{$userIDX}{TX_LAST_NAME}.', '.$USERS{$userIDX}{TX_FIRST_NAME};
        $str .= '<tr class="w3-hide-small">';
        $str .= '<td><a href="javascript:void(0);" onclick="openJudgeAssignmentDetails('.$userIDX.',\''.$userName.'\')">'.$userName.'</a></td>';
        $str .= '<td>';
        foreach $classIDX (sort keys %{$CPREF{$userIDX}}){
            $str .= sprintf '<a href="javascript:void(0);" onclick="sae_loadTeamsToAssign(%1d, %1d);">%s</a><br>', $userIDX, $classIDX, $CLASS{$classIDX};
        }
        $str .= '</td>';
        for ($inType=1; $inType<=4; $inType++){
            $str .= '<td class="w3-row">';
            foreach $inNumber (sort {$a<=>$b} keys %{$CARDS{$userIDX}{$inType}}) {
                my $teamIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_TEAM_IDX};
                my $cardIDX = $CARDS{$userIDX}{$inType}{$inNumber}{PK_CARD_IDX};
                my $classIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_CLASS_IDX};
                # my $eIDX = crypt($teamIDX, '20');
                $inStatus = $CARDS{$userIDX}{$inType}{$inNumber}{IN_STATUS};
                $str .= &_templateStatusButton($teamIDX, $W3CLASS{$inStatus}, $inNumber, $cardIDX, $classIDX, $inType);
                # $str .= sprintf '<a class="w3-padding-small w3-button w3-border '.$W3CLASS{$inStatus}.' w3-round w3-margin-right" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">#%03d</a>', $inNumber;
            }
            $str .= '</td>';
        }
        $str .= '</tr>';
        $str .= '<tr></tr>';
        $str .= '<tr class="w3-hide-medium w3-hide-large">';
        $str .= '<td class="w3-row">';
        $str .= '<div class="w3-medium w3-blue-grey w3-container"><a class="w3-text-white" href="javascript:void(0);" onclick="openJudgeAssignmentDetails('.$userIDX.',\''.$userName.'\')">'.$userName.'</a></div>';
        $str .= '<b>Class Preferences:</b><br>';
        foreach $classIDX (sort keys %{$CPREF{$userIDX}}){
            $str .= sprintf '<a class="w3-margin-left" href="javascript:void(0);" onclick="sae_loadTeamsToAssign(%1d, %1d);">%s</a><br>', $userIDX, $classIDX, $CLASS{$classIDX};
        }
        for ($inType=1; $inType<=4; $inType++){
            $str .= sprintf '<b>%s</b>: <br>', $TYPE{$inType};
            $str .= '<div class="w3-margin-left w3-padding-small w3-border-bottom">';
            foreach $inNumber (sort {$a<=>$b} keys %{$CARDS{$userIDX}{$inType}}) {
                my $teamIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_TEAM_IDX};
                my $cardIDX = $CARDS{$userIDX}{$inType}{$inNumber}{PK_CARD_IDX};
                my $classIDX = $CARDS{$userIDX}{$inType}{$inNumber}{FK_CLASS_IDX};
                # my $eIDX = crypt($teamI$inNumberDX, '20');
                $inStatus = $CARDS{$userIDX}{$inType}{$inNumber}{IN_STATUS};
                $str .= &_templateStatusButton($teamIDX, $W3CLASS{$inStatus}, $inNumber, $cardIDX, $classIDX, $inType);
                # $str .= sprintf '<a class="w3-padding-small w3-button w3-border '.$W3CLASS{$inStatus}.' w3-round w3-margin-right" href="score.html?teamIDX='.$eIDX.'&source=14" target="_blank">#%03d</a>', $inNumber;
            }
            $str .= '</div>';
        }
        
        $str .= '</td>';
        $str .= '</tr>';
    }
    $str .= '</tbody>';
    $str .= '</table>';
    return ($str);
}