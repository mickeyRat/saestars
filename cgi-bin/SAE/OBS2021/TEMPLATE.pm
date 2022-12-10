package SAE::TEMPLATE;

use DBI;
use SAE::SDB;

use URI::Escape;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

return (1);