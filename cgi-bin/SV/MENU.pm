package SV::MENU;

use DBI;
use SV::CONNECT;
use JSON;

my ($dbi, $dbName) = new SV::CONNECT();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self
#begin
#* Object: new()
#* Inputs: None.
#* Output: Defined a new Object
#* Comment: none.
}
sub _loadMenuItems(){
    my $self = shift;
    my $userIDX = shift;
    my $str;
    my $SQL = "SELECT TILES.PK_TILES_IDX, TILES.TX_TITLE, TILES.TX_ICON, TILES.IN_ORDER FROM TB_ACCESS AS ACCESS JOIN TB_TILES AS TILES ON ACCESS.FK_TILES_IDX=TILES.PK_TILES_IDX WHERE ACCESS.FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
    $select->execute($userIDX);
    my %TILES = %{$select->fetchall_hashref(['PK_TILES_IDX'])};
    $str .= '<a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>&nbsp; Close Menu</a>';
    $str .= '<a ID="MENUITEM_0" href="javascript:void(0);" class="sae-menu_item w3-bar-item w3-button w3-padding w3-blue " onclick="w3_close();sae_loadHomePage(0, this);"><i class="fa fa-users fa-fw"></i>&nbsp; My Page</a>';
    foreach $pkTilesIdx (sort {$TILES{$a}{IN_ORDER} <=> $TILES{$b}{IN_ORDER}} keys %TILES) {
        $str .= '<a ID="MENUITEM_'.$pkTilesIdx.'" href="javascript:void(0);" class="sae-menu_item w3-bar-item w3-button w3-padding " onclick="mainMenuItemClick('.$pkTilesIdx.', this);w3_close();"><i class="fa '.$TILES{$pkTilesIdx}{TX_ICON}.'"></i>&nbsp; '.$TILES{$pkTilesIdx}{TX_TITLE}.'</a>'."\n";
    }
    $str .= '<br><a href="javascript:void(0);" style="margin-bottom: 60px;" class="w3-bar-item w3-button w3-padding" onclick="signOutAdmin();"><i class="fa fa-sign-out fa-fw" ></i>Logout</a><br><br>';
    $str .= '<br>' x 5;
    return ($str);
}