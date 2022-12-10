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

#---- TABLES   -------
use TB::QUESTION;

#---- SERVICES -------
use SV::UTIL;

$q = new CGI;
$qs = new CGI($ENV{'QUERY_STRING'});

my $path = abs_path($0);
$path =~ s/\\[^\\]+$//;
$path =~ s/\/[^\/]+$//;

my $act = $q->param("act");
my %ROLE = (0=>'Student', 1=>'Judge', 4=>'Superuser', 99=>'Admin');

if ($act eq "print"){
    print &{$do= $q->param("do")};
} else {
    &{$do= $q->param("do")};
}
exit;
sub sae_openManageQuestion(){
    print $q->header();
    my $eventIDX = $q->param('eventIDX');
    my $Question = new TB::QUESTION();
    my %QUESTIONS = %{$Question->_getData_hashref('PK_QUESTION_IDX')};
    my $str;
    $str = '<br>';
    $str .= '<div class="w3-display-container w3-margin">';
    $str .= '<h2 style="text-align: center;">Rubric Question Library</h2>';
    $str .= '<span class=" w3-display-topleft"><button class="w3-button w3-border w3-green w3-round" onclick="sae_openAddRubrucQuestion();">+ Add Question</button></span>';
    $str .= '<div class="w3-container">';
    $str .= '<table ID="TABLE_QUESTIONS" class="w3-table-all w3-small w3-hoverable">';
    $str .= '<thead>';
    $str .= '<tr class="w3-black">';
    $str .= '<th style="width: 25%">Title</th>';
    $str .= '<th>Descriptions</th>';
    $str .= '<th style="width: 10%">Input Type</th>';
    $str .= '<th style="width: 15%">&nbsp;</th>';
    $str .= '</tr>';
    $str .= '</thead>';
    $str .= '<tbody>';
    foreach $questionIDX (sort {lc($QUESTIONS{$a}{TX_TITLE}) cmp lc($QUESTIONS{$b}{TX_TITLE})} keys %QUESTIONS) {
        $str .= &_templateQuestionRow($questionIDX, $QUESTIONS{$questionIDX}{TX_TITLE}, $QUESTIONS{$questionIDX}{CL_DESCRIPTION}, $QUESTIONS{$questionIDX}{IN_TYPE});
    }
    $str .= '</tbody>';
    $str .= '</table>';
    $str .= '</div>';
    $str .= '</div>';
    return ($str);
}
sub sae_openAddRubrucQuestion(){
    print $q->header();
    my $eventIDX = $q->param('eventIDX');
    my $divName = $q->param('divName');
    my $str;
    $str .= sprintf '<form class="w3-container w3-small" action="javascript:void(0);" onsubmit="sae_saveQuestion(\'%s\');">', $divName;
    $str .= '<label>Title of Question</label>';
    $str .= '<input type="text" ID="TX_TITLE" class="w3-input w3-round w3-border " placeholder="Title of Question">';
    $str .= '<br><label class=" w3-margin-top">Objective(s) of this Question</label>';
    $str .= '<textarea ID="CL_DESCRIPTION" class="w3-input w3-round w3-border" style="height: 110px; max-width: 100%; min-width: 100%;" placeholder="Objective of this Question"></textarea>';
    $str .= '<br><label class=" w3-margin-top">Scoring Criteria for this Question</label>';
    $str .= '<textarea ID="CL_CRITERIA" class="w3-input w3-round  w3-border" style="height: 110px; max-width: 100%;  min-width: 100%;" placeholder="Provide a description on what a judge should consider when scoring this question."></textarea>';
    $str .= '<br><lable class=" w3-margin-top">Input Type</label><br>';
    $str .= '&nbsp;' x 5;
    $str .= '<input type="radio" class="w3-radio" name="IN_TYPE" value="1" checked> Numeric Value (0 - 100%)<br>';
    $str .= '&nbsp;' x 5;
    $str .= '<input type="radio" class="w3-radio" name="IN_TYPE" value="0"> Pass/Fail; Yes/No; True/False<br>';
    $str .= '<hr>';
    $str .= '<center>';
    $str .= '<input type="submit" class="w3-button w3-border w3-margin w3-green w3-round w3-hover-blue" value="Save">';
    $str .= '<button class="w3-button w3-margin w3-border w3-round" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    $str .= '</form>';
    return ($str);
}
sub _templateQuestionRow(){
    my $questionIDX = shift;
    my $title = shift;
    my $description = shift;
    my $inType = shift;

    my %INTYPE = (1=>'Numeric', 0=>'Pass/Fail');
    my $str;
    # $str .= sprintf '<td ondblclick="sae_updateUserEdits(this, \'TX_LAST_NAME\', '.$userIDX.');">%s</td>', $lastName;
    $str = sprintf '<tr ID="TR_QUESTION_IDX_%d" class="w3-hover-pale-yellow">', $questionIDX;
    $str .= sprintf '<td >%s</td>', $title;
    $str .= sprintf '<td >%s</td>', $description;
    $str .= sprintf '<td >%s</td>', $INTYPE{$inType};
    $str .= '<td class="w3-display-container">';
    $str .= '<span class="w3-display-right">';
    $str .= sprintf '<i class="fa fa-pencil" aria-hidden="true" style="cursor: pointer;" onclick="sae_editQuestion(%d)"></i>', $questionIDX;
    $str .= '&nbsp;' x 5;
    $str .= sprintf '<i class="fa fa-trash-o" aria-hidden="true" style="cursor: pointer;" onclick="sae_deleteQuestion(%d);"></i>', $questionIDX;
    $str .= '&nbsp;' x 5;
    $str .= '</span>';
    $str .= '</td>';
    $str .= '</tr>';
    return ($str);
}
sub sae_saveQuestion(){
    print $q->header();
    # my $teamIDX = $q->param('teamIDX');
    my $jsonData = $q->param('jsonData');
    my $Question = new TB::QUESTION(); 
    $Question->_setField_json($jsonData);
    my %DATA=%{decode_json($jsonData)};
    my $questionIDX = $Question->_saveNew();
    my $str;
    $str = &_templateQuestionRow($questionIDX, $DATA{TX_TITLE}, $DATA{CL_DESCRIPTION}, $DATA{IN_TYPE});
    
    return ($str);
}
sub sae_deleteQuestion(){
    print $q->header();
    my $questionIDX = $q->param('questionIDX');
    my $Question = new TB::QUESTION(); 
       $Question->_deleteRow('PK_QUESTION_IDX', $questionIDX);
    return();
}
sub sae_editQuestion(){
    print $q->header();
    my $questionIDX = $q->param('questionIDX');
    my $Question = new TB::QUESTION(); 
       $Question->_fetchData('PK_QUESTION_IDX', $questionIDX);
    my $Util = new SV::UTIL();
    my $divName = $q->param('divName');
    my $str;
    $str .= sprintf '<form class="w3-container w3-small" action="javascript:void(0);" onsubmit="sae_saveEditQuestion(this, %d, \'%s\');">', $questionIDX, $divName;
    $str .= '<label>Title of Question</label>';
    $str .= sprintf '<input type="text" ID="TX_TITLE" class="w3-input w3-round w3-border " value="%s" placeholder="Title of Question">', $Util->_removeBr($Question->_getData('TX_TITLE'));
    $str .= '<br><label class=" w3-margin-top">Objective(s) of this Question</label>';
    $str .= sprintf '<textarea ID="CL_DESCRIPTION" class="w3-input w3-round w3-border" style="height: 110px; max-width: 100%; min-width: 100%;" placeholder="Objective of this Question">%s</textarea>', $Util->_removeBr($Question->_getData('CL_DESCRIPTION'));
    $str .= '<br><label class=" w3-margin-top">Scoring Criteria for this Question</label>';
    $str .= sprintf '<textarea ID="CL_CRITERIA" class="w3-input w3-round  w3-border" style="height: 110px; max-width: 100%; min-width: 100%;" placeholder="Provide a description on what a judge should consider when scoring this question.">%s</textarea>', $Util->_removeBr($Question->_getData('CL_CRITERIA'));
    $str .= '<br><lable class=" w3-margin-top">Input Type</label><br>';
    $str .= '&nbsp;' x 5;
    my $checked = '';
    if ($Question->_getData('IN_TYPE') == 1) {
        $str .= '<input type="radio" class="w3-radio" name="IN_TYPE" value="1" checked> Numeric Value (0 - 100%)<br>';
        $str .= '&nbsp;' x 5;
        $str .= '<input type="radio" class="w3-radio" name="IN_TYPE" value="0"> Pass/Fail; Yes/No; True/False<br>';
    } else {
        $str .= '<input type="radio" class="w3-radio" name="IN_TYPE" value="1" > Numeric Value (0 - 100%)<br>';
        $str .= '&nbsp;' x 5;
        $str .= '<input type="radio" class="w3-radio" name="IN_TYPE" value="0" checked> Pass/Fail; Yes/No; True/False<br>';
    }
    $str .= '<hr>';
    $str .= '<center>';
    $str .= '<input type="submit" class="w3-button w3-border w3-margin w3-green w3-round w3-hover-blue" value="Update">';
    $str .= '<button class="w3-button w3-margin w3-border w3-round" onclick="$(\'#'.$divName.'\').remove();">Cancel</button>';
    $str .= '</center>';
    $str .= '</form>';
    return ($str);
}
sub sae_saveEditQuestion(){
    print $q->header();
    my $questionIDX = $q->param('questionIDX');
    my $jsonData = $q->param('jsonData');
    my $Question = new TB::QUESTION(); 
    $Question->_setField_json($jsonData);
    my %DATA=%{decode_json($jsonData)};
    $Question->_saveUpdate($questionIDX);
    my $str;
    $str = &_templateQuestionRow($questionIDX, $DATA{TX_TITLE}, $DATA{CL_DESCRIPTION}, $DATA{IN_TYPE});
}
sub __template(){
    print $q->header();
    my $location = $q->param('location');
    my $str;

    return ($str);
}