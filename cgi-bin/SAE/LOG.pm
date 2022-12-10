package SAE::LOG;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );
use Number::Format;
use Statistics::Basic qw(:all);
use SAE::Auth();


my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ===============================================================
# GET
# ===============================================================
sub _generateFlightLog(){
    my ($self, $inNumber, $txSchool);
    my @ITEMS = ('L-Wing','V. Stab','Gears','R-Wing','H. Stab','Motor','Fuselage','Controls','Payload','Radio','Battery');
    my $str = '<div class="w3-container">';
    $str .= sprintf '<span class="w3-badge w3-jumbo w3-red w3-padding">%03d</span>', $inNumber;
    $str .= sprintf '<h2>%s</h2>',$txSchool;
    $str .= '<hr>';
    $str .= '<table class="w3-table w3-bordered">';
    $str .= '<tr>';
    $str .= '<th style="width: 5%;">Att</th>';
    $str .= '<th style="width: 5%;">Status</th>';
    $str .= '<th style="width: 90%;">Notes & Watch Items</th>';
    # $str .= '<th style="width: 35%;">Inspect Items</th>';
    $str .= '</tr>';
    my $att = 1;
    for ($x=1; $x<=10; $x++){
        $str .= '<tr style="height: 200px;">';
        $str .= sprintf '<td rowspan="2">%d</td>', $att++;
        $str .= '<td rowspan="2">Good<br>No Fly<br>Crashed<br>DQ\'d</td>';
        $str .= '<td></td>'; 
        $str .= '</tr>';
        $str .= '<tr>'
        $str .= '<td>';
        $str .= '<b>Inspect Items</b>';
        $str .= '<div class="w3-row">';
        foreach $item (@ITEMS){
            $str .= sprintf '<div class="w3-col m1 w3-center">%s</div>', $item;
        }
        $str .= '</div>';
        $str .= '</td>'; 
        $str .= '</tr>';
    }
    $str .= '</div>';
}
return (1);