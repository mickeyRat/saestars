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
# use SAE::TB_USER;
# use SAE::TB_TEAM;
# use SAE::Auth;
# use SAE::TB_USER_TEAM;
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

sub updateEventDetails(){
    print $q->header();
    my %DATA;
    my $PkEventIdx = $q->param('PkEventIdx');
    my $TxEventName = $q->param('TxEventName');
    my $InYear = $q->param('InYear');
    my $TxEventCity = $q->param('TxEventCity');
    my $Event = new SAE::TB_EVENT();
    $Event->updateTxEventName_byId($TxEventName, $PkEventIdx);
    $Event->updateInYear_byId($InYear, $PkEventIdx);
    $Event->updateTxEventCity_byId($TxEventCity, $PkEventIdx);
    $DATA{TX_EVENT_NAME} = $TxEventName;
    $DATA{IN_YEAR} = $InYear;
    $DATA{TX_EVENT_CITY} = $TxEventCity;
    my $json = encode_json \%DATA;
    return ($json);
}

sub deleteEvent(){
    print $q->header();
    my $PkEventIdx = $q->param('PkEventIdx');
    my $Event = new SAE::TB_EVENT();
    $Event->deleteRecordById($PkEventIdx);
    return ();
}
sub editEventDetails(){
    print $q->header();
    my $PkEventIdx = $q->param('PkEventIdx');
    my $Event = new SAE::TB_EVENT();
    $Event->getRecordById($PkEventIdx);
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Edit Event Information</h2>';
    $str .= '</div>';
#     $str .= '<h2>Edit Event Information</h2>';
    $str .= '<form class="w3-container" action="javascript:void(0);" onsubmit="javascript:updateEventDetails('.$PkEventIdx.');">';
    $str .= &_templateEventDetails('Name of Event', $Event->getTxEventName(), 'TX_EVENT_NAME');
    $str .= &_templateEventDetails('Year', $Event->getInYear(), 'IN_YEAR');
    $str .= &_templateEventDetails('City, State', $Event->getTxEventCity(), 'TX_EVENT_CITY');
    $str .= '<br>';
    $str .= '<div class="w3-container w3-text-center" style="">';
    $str .= '<a href="javascript:void(0);" class="w3-button w3-border w3-margin" onclick="updateEventDetails('.$PkEventIdx.');">Update</a> ';
#     $str .= '<a href="javascript:void(0);" class="button small " onclick="deleteEvent('.$PkEventIdx.');">Delete</a> ';
    $str .= '</div>';
    $str .= '</form><br><br>';
    return ($str);
}

sub _templateEventDetails(){
    my $fieldName = shift;
    my $fieldValue = shift;
    my $fieldId = shift;
    my $str;
    $str .= '<label class="w3-small">'.$fieldName.'<label>';
    $str .= '<input class="w3-input" required style="color: blue; padding: 2px;" type="text" name="'.$fieldId.'" id="'.$fieldId.'" placeholder="'.$fieldName.'" value="'.$fieldValue.'"/>';
    return ($str);
}
sub addNewEvent(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $TxEventName = $q->param('TxEventName');
    my $InYear = $q->param('InYear');
    my $TxEventCity = $q->param('TxEventCity');
    my $SQL = "INSERT INTO TB_EVENT (TX_EVENT_NAME, IN_YEAR, TX_EVENT_CITY) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
    $insert->execute($TxEventName,$InYear,$TxEventCity);
    my $newIDX = $insert->{q{mysql_insertid}};
    my $str;
    $str .= &_templateEventDataRow($newIDX, $TxEventName, $InYear, $TxEventCity);
    return ($str);
}
sub showAddNewEvent(){
    print $q->header();
    my $str;
    $str .= '<a class="w3-button w3-border w3-display-topright" onclick="closeModal(\'id01\');">&times;</a>';
    $str .= '<div class="w3-container w3-blue" >';
    $str .= '<h2 style="float: left;">Add New Event</h2>';
    $str .= '</div>';
    $str .= '<form class="w3-container" action="javascript:void(0);" onsubmit="addNewEvent();">';
    $str .= &_templateEventDetails('Name of Event', '', 'TX_EVENT_NAME');
    $str .= &_templateEventDetails('Year', '', 'IN_YEAR');
    $str .= &_templateEventDetails('City, State', '', 'TX_EVENT_CITY');
    $str .= '<br>';
    $str .= '<div class="w3-container" style="text-align: center;">';
    $str .= '<a class="w3-button w3-border" onclick="addNewEvent();">Add</a> ';
    $str .= '</div>';
    $str .= '</form><br><br>';
    return ($str);
}

sub _templateEventDataRow(){
    my ($idx, $name, $year, $city) = @_;
    my $str;
    $str .= '<div ID="TR_EVENT_ROW_'.$idx.'" class="w3-container" style="padding: 7px; border-bottom: 1px solid #eeeeee;">';
        $str .= '<div class="w3-col l2 " >Event #: <span ID="TD_PK_EVENT_IDX_'.$idx.'">'.$idx.'</div>';
        $str .= '<div class="w3-col l2 " >Name: <span ID="TD_TX_EVENT_NAME_'.$idx.'">'.$name.'</div>';
        $str .= '<div class="w3-col l2 " >Year: <span  ID="TD_IN_YEAR_'.$idx.'">'.$year.'</div>';
        $str .= '<div class="w3-col l2 " >City: <span  ID="TD_TX_EVENT_CITY_'.$idx.'">'.$city.'</div>';
        $str .= '<div class="w3-col l3 " >';
        $str .= '<a class="w3-button  fa fa-pencil-square-o " onclick="editEventDetails('.$idx.');"></a> ';
        $str .= ' <a class="w3-button fa fa-check-square-o"  onclick="selectEvent('.$idx.',\''.$name.'\',\''.$year.'\');"></a>';
        $str .= ' <a class="w3-button fa fa-close w3-text-red " style="font-size: 24px;" onclick="deleteEvent('.$idx.');"></a>';
#         $str .= ' <a class="w3-button w3-red w3-round" style="width: 76px; padding: 2px; height: 2.0em;font-size: .8em !important"href="javascript:void(0);" onclick="deleteEvent('.$idx.');">Delete</a>';
        $str .= '</div>';
    $str .= '</div>'; # Container
    return ($str);
}
sub showEventList(){
    print $q->header();
    my $location = $q->param('location');
    my $str;
    my $Event = new SAE::TB_EVENT();
    %EVENT = %{$Event->getAllRecord()};
    my $str;
    $str .= '<a class="fa fa-angle-double-left w3-button" href="javascript:void(0);" onclick="loadSetupAndAdministration();">&nbsp;Back</a>';
    $str .= '<H2 style="border: 1px solid #dedede; border-radius: 8px; text-align: center;">Selected Event: <span ID="CURRENT_LOCATION">'.$EVENT{$location}{TX_EVENT_NAME}.' ('.$EVENT{$location}{IN_YEAR}.')</span></H2>';
    $str .= '<div ID="TABLE_EVENT" class="w3-row w3-border">';
    foreach $PkEventIdx ( sort {$EVENT{$a}{IN_YEAR} <=> $EVENT{$b}{IN_YEAR}} keys %EVENT){
         $str .= &_templateEventDataRow($PkEventIdx, $EVENT{$PkEventIdx}{TX_EVENT_NAME}, $EVENT{$PkEventIdx}{IN_YEAR}, $EVENT{$PkEventIdx}{TX_EVENT_CITY});
    }
    $str .= '</div>';
    $str .= '<div style="text-align: center;"><br>';
    $str .= '<a class="w3-button w3-border" href="javascript:void(0);" onclick="showAddNewEvent();">Add New Event</a>';
    $str .= '</div>';

    return ($str);
}
