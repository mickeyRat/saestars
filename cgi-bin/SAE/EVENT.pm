package SAE::EVENT;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;

# use DateTime;

my $dbi = new SAE::Db();
my %EVENT;

sub new{
	$className = shift;
	my $self = {};
    my $eventIDX = shift;
    my $SQL = "SELECT * FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    %EVENT = %{$select->fetchrow_hashref()};   
    
	bless($self, $className);
	return $self;
}
sub _getEventData(){
    my $self = shift;
    return (\%EVENT);
}
sub _getEventList(){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_EVENT WHERE BO_ARCHIVE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(0);
    my %EVENT = %{$select->fetchall_hashref('PK_EVENT_IDX')};  
    return (\%EVENT);
}
sub _getEvent(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_EVENT WHERE PK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchrow_hashref()};   
    return (\%HASH);
}
sub _updateEventInfo(){
    my $self = shift;
    my $txField = shift;
    my $inValue = shift;
    my $idx = shift;
    my $SQL = "UPDATE TB_EVENT SET $txField=? WHERE PK_EVENT_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute($inValue, $idx);
}
return (1);