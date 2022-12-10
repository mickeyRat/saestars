package SAE::DEMO;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# =====================================================================================================
#  GETTERS
# =====================================================================================================
sub _getMicroClassByEvent(){
    my $self = shift;
	my $classIDX = shift;
	my $location = shift;
	my $SQL = "SELECT * FROM TB_TEAM WHERE (FK_CLASS_IDX=? AND FK_EVENT_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $classIDX, $location );
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}

# =====================================================================================================
#  INSERTS
# =====================================================================================================


# =====================================================================================================
#  UPDATES
# =====================================================================================================
sub _updateMicroDemoTime(){
	my $self = shift;
	my $teamIDX = shift;
    my $inSeconds = shift;
	my $SQL = "UPDATE TB_TEAM SET IN_SECONDS=? WHERE PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($inSeconds, $teamIDX);
	return();
}

# =====================================================================================================
#  DELETES
# =====================================================================================================


return (1);