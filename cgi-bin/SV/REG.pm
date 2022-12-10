package SV::REG;

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
sub _calculateFlightScore(){
    my ($self, $Sphere, $Weight, $span, $Length) = @_;
    my $num = (3 * $Sphere) + $Weight;
    my $den = $span + $Length;
    my $fs = 120 * ($num/$den);
    return ($fs);
#begin
#* Object: _calculateFlightScore()
#* Inputs: Number of Balls (S), Payload Weight (W), Aircraft span (b), and Length of Cargo Bay (L).
#* Output: Defined a new Object
#* Comment: none.
}