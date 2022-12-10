package SV::CONNECT;
# $dbName = "saestars_PROD";
# $dbName = "saestars_DB";
my $dbName = "saestars_DEV2";
my $dbi = DBI->connect("dbi:mysql:$dbName:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect");

sub new{
    $className = shift;
    my $self = {};
    bless($self, $className);
    return ($dbi, $dbName);
#begin
#* Object: new()
#* Inputs: None.
#* Output: Defined a new Object and returns he database handle and the database Name
#* Comment: none.
}

return (1);
