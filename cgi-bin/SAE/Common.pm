package SAE::Common;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub removeBr(){
    my $self = shift;
    my $txt = shift;
    $txt =~ s/<br \/>/\n/g;
    return ($txt);
}
