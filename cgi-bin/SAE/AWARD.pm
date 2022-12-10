package SAE::AWARD;

use DBI;
use SAE::SDB;
# use SAE::TB_AWARD;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ========================= 2022 ===============================================
# ------------------------- GETTERS --------------------------------------------
sub _getListOfAwards(){
    my ($self) = @_;
    my $SQL = "SELECT * FROM TB_AWARD";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_AWARD_IDX'])};
    return (\%HASH);
}
sub _getAwardTitle(){
    my ($self, $awardIDX) = @_;
    my $SQL = "SELECT TX_TITLE FROM TB_AWARD WHERE PK_AWARD_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($awardIDX);
    my ($txTitle) = $select->fetchrow_array();
    return ($txTitle);
}
# ------------------------- SETTERS --------------------------------------------
# ------------------------- DELETES --------------------------------------------
# ------------------------- OTHERS  --------------------------------------------

return (1);