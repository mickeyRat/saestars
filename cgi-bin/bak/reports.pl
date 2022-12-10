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
use SAE::AUTO;
use SAE::REPORTS;
use SAE::REFERENCE;

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
# ***********************************************************************************************************************************
#  REPORT ASSESSMENTS 2019
# ***********************************************************************************************************************************
sub ManageReportAssessments(){
    print $q->header();
    my $dbi = new SAE::Db();
    my $Reports = new SAE::REPORTS();
    my $Ref = new SAE::REFERENCE();
    my $userIDX = $q->param('userIDX');  
    my $inType = $q->param('inType');  
    my $location = $q->param('location');  
    %TODO = %{$Reports->_getJudgesToDos($userIDX, $inType, $location)};
    %CLASS = %{$Ref->_getClassList()};
    %CARDTYPE = %{$Ref->_getCardTypeList()};
    my $str;
    $str .= '<div class="w3-container">';  
    # $str .= scalar(keys %TODO)."<br>";
    $str .= '<h2>To Dos: Grade '.$CARDTYPE{$inType}{TX_TITLE}.'</h2>';
    foreach $classIDX (sort keys %TODO){
        $str .= '<h4>'.$CLASS{$classIDX}{TX_CLASS}.' Class</h4>';
        $str .= '<table class="w3-table-all">';
        $str .= '<thead>';
        $str .= '<tr  class="w3-blue">';
        $str .= '<th style="width: 5%;">#</th>';
        $str .= '<th>School</th>';
        $str .= '<th style="width: 10%;">Download</th>';
        $str .= '<th style="width: 10%;">Score</th>';
        $str .= '<th style="width: 10%;" >Status</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';
        foreach $cardIDX (sort {$TODO{$classIDX}{$a}{IN_NUMBER} <=> $TODO{$classIDX}{$b}{IN_NUMBER}} keys %{$TODO{$classIDX}}){
            $inNumber = substr("000".$TODO{$classIDX}{$cardIDX}{IN_NUMBER},-3,3);
            $str .= '<tr >';
            # $str .= '<td>&nbsp;</td>';
            $str .= '<td>'.$inNumber.'</td>';
            $str .= '<td>'.$TODO{$classIDX}{$cardIDX}{TX_SCHOOL}.'</td>';
            $str .= '<td>...</td>';
            $str .= '<td>0.00</td>';
            $str .= '<td class="w3-right">Start</td>';
            $str .= '</tr>';
        }
        $str .= '</tbody>';
        $str .= '</table>';
    }
    $str .= '</div>';
    return ($str);
}






# ***********************************************************************************************************************************

