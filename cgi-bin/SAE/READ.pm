package SAE::READ;

use DBI;
use SAE::SDB;

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
sub _getDocumentData(){
    my ($self, $txKeys) = @_;
    my $SQL = "SELECT TX_FOLDER, TX_PAPER, IN_NUMBER FROM TB_UPLOAD WHERE TX_KEYS=?";
    my $select = $dbi->prepare( $SQL );
       $select->execute( $txKeys );
    my ($txFolder, $txPaper, $inNumber) = $select->fetchrow_array();
    # print "$txFolder, $txPaper, $inNumber\n";
    return ($txFolder, $txPaper, $inNumber);
}
return (1);