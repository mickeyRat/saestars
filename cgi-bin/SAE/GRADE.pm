package SAE::GRADE;

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
sub _getTeamData(){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    # return ($teamIDX);
    my $select = $dbi->prepare($SQL);
	   $select->execute($teamIDX);
    my %HASH = %{$select->fetchrow_hashref()}; 
    return (\%HASH);
    # return $SQL;
}


# ===============================================================
# SAVES
# ===============================================================

sub _saveImportedGrades(){
    my ($self, $cardIDX, $subIDX, $inValue ) = @_;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subIDX, $inValue);
}
sub _saveAssessments(){
    my $self = shift;
    my $teamIDX = shift;
    my $cardIDX = shift;
    my $inType = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        $insert->execute($cardIDX, $subSectionIDX, $DATA{$subSectionIDX}) || die "Cannot Add @_"; 
    }
    return ();
}
# ===============================================================
# UPDATES
# ===============================================================
sub _updateCardStatus(){
    my $self = shift;
    my $cardIDX = shift;
    my $status = shift; #1= Draft, 2 = Done
    my $SQL = "UPDATE TB_CARD SET IN_STATUS=? WHERE PK_CARD_IDX=?";
    my  $update = $dbi->prepare($SQL);
        $update->execute($status, $cardIDX);
    return;
}
sub _updateCardAssessments(){
    my $self = shift;
    my $cardIDX = shift;
    my $hashData = shift;
    my %DATA = %$hashData;
    my $SQL = "UPDATE TB_PAPER SET IN_VALUE=? WHERE (FK_CARD_IDX=? AND FK_SUBSECTION_IDX=?)";
    my $update = $dbi->prepare($SQL);
    foreach $subSectionIDX (sort {$a <=> $b} keys %DATA) {
        $update->execute($DATA{$subSectionIDX}, $cardIDX, $subSectionIDX) || die "Cannot Add @_"; 
    }
    return ();
}

# ===============================================================
# DELETES
# ===============================================================
sub _clearPreviousGrades(){
    my ($self, $cardIDX) = @_;
    my $SQL = "DELETE FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $delete = $dbi->prepare( $SQL );
       $delete->execute( $cardIDX );
}
return (1);