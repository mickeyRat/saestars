package SV::MIC;

use DBI;
use SV::CONNECT;
use JSON;

my ($dbi, $dbName) = new SV::CONNECT();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
#begin
#* Object: new()
#* Inputs: None.
#* Output: Defined a new Object
#* Comment: none.
}