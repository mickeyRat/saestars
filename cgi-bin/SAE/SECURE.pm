package SAE::SECURE;

use DBI;
use SAE::SDB;


my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub getSalt(){
    my ($self) = shift;
    my ($length) = shift;
    my @chars = ("A".."Z", 2..9, "a".."z");
    my $str;
    $str .= $chars[rand @chars] for 1..2;
    return ($str);
}

sub _getSaltedPassword(){
	my ($self, $txPassword) = @_;
	my $salt = &getSalt();
	my $securePassword = crypt($txPassword, $salt);
	return ($securePassword);
}
sub _getTemporaryPassword(){
    my ($self) = shift;
    my ($length) = shift;
    if (!$length){$length = 10}
    my @chars = ("A".."Z", 2..9, "a".."z");
    my $str;
    $str .= $chars[rand @chars] for 1..$length;
    return ($str);
}


return (1);