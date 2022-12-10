package SAE::ECR;

use DBI;
use URI::Escape;
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
sub _getMyTeams(){
	my $self = shift;
	my $userIDX = shift;
	my $location = shift;
	my $SQL = "SELECT TEAM.* FROM TB_USER_TEAM AS UT JOIN TB_TEAM AS TEAM ON UT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX 
		WHERE(UT.FK_USER_IDX=? AND TEAM.FK_EVENT_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $userIDX, $location );
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getTeamsERCS(){
	my $self = shift;
	my $userIDX = shift;
	my $location = shift;
	my $SQL = "SELECT ECR.*, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_ECR AS ECR 
	JOIN TB_USER_TEAM AS UT ON ECR.FK_TEAM_IDX=UT.FK_TEAM_IDX 
    JOIN TB_TEAM AS TEAM ON UT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE (UT.FK_USER_IDX=? AND TEAM.FK_EVENT_IDX=?)";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $userIDX, $location );
    my %HASH = %{$select->fetchall_hashref('PK_ECR_IDX')}; 
    return (\%HASH);
}
sub _getTeamDataById(){
	my $self = shift;
	my $teamIDX = shift;
	 my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
        $select->execute($teamIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')}; 
    return (\%HASH);
}
sub _getECRByID(){
	my $self = shift;
	my $ecrIDX = shift;
	my $SQL = "SELECT * FROM TB_ECR WHERE PK_ECR_IDX=?";
	my $select = $dbi->prepare($SQL);
        $select->execute($ecrIDX);
    my %HASH = %{$select->fetchall_hashref('PK_ECR_IDX')}; 
	return (\%HASH);
}
sub _getECRByEventID(){
	my $self = shift;
	my $location = shift;
	# my $SQL = "SELECT ECR.*, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_ECR AS ECR 
	# JOIN TB_USER_TEAM AS UT ON ECR.FK_TEAM_IDX=UT.FK_TEAM_IDX 
    # JOIN TB_TEAM AS TEAM ON UT.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    # WHERE TEAM.FK_EVENT_IDX=?";
	my $SQL = "SELECT ECR.*, TEAM.IN_NUMBER, TEAM.TX_SCHOOL FROM TB_ECR AS ECR 
    JOIN TB_TEAM AS TEAM ON ECR.FK_TEAM_IDX=TEAM.PK_TEAM_IDX
    WHERE TEAM.FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $location );
    my %HASH = %{$select->fetchall_hashref(['FK_TEAM_IDX','PK_ECR_IDX'])}; 
    return (\%HASH);
}

# ===============================================================
# INSERT
# ===============================================================
sub _submitECR(){
	my $self = shift;
	my $userIDX = shift;
    my $hashData = shift;
	my $FIELDS = join(", ", keys %$hashData);
	my @VALUES = uri_unescape(values %$hashData);
	my $value = join ', ', (split(/ /, "? " x (scalar(keys %$hashData))));
	my $SQL = "INSERT INTO TB_ECR ($FIELDS) VALUES ($value);";
	my $insert = $dbi->prepare($SQL);
	for ($i=1; $i <= scalar(@VALUES); $i++) {
		$insert->bind_param($i ,$VALUES[$i-1]);
	}
	$insert->execute();
	my $ecrIDX = $insert->{q{mysql_insertid}};
	return ($ecrIDX );
}
# ===============================================================
# UPDATES
# ===============================================================
sub _submitECR_Update(){
	my $self = shift;
	my $ecrIDX = shift;
    my $hashData = shift;
	my $FIELDS = join("=?, ", keys %$hashData)."=? ";
	my @VALUES = uri_unescape(values %$hashData);
	my $value = join ', ', (split(/ /, "? " x (scalar(keys %$hashData))));
	my $SQL = "UPDATE TB_ECR SET $FIELDS WHERE PK_ECR_IDX=?";
	my $insert = $dbi->prepare($SQL);
	for ($i=1; $i <= scalar(@VALUES); $i++) {
		$insert->bind_param($i ,$VALUES[$i-1]) || die "$!";
	}
	$insert->bind_param($i,$ecrIDX) ;
	$insert->execute();
	return ();
}
sub _updateCargoLength(){
	my $self = shift;
	my $teamIDX = shift;
    my $inCargo = shift;
	my $SQL = "UPDATE TB_TEAM SET IN_LCARGO=? WHERE PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($inCargo, $teamIDX);
	return();
}
sub _updateVideoDemo(){
	my $self = shift;
	my $teamIDX = shift;
    my $inVideo = shift;
	my $SQL = "UPDATE TB_TEAM SET IN_VIDEO=? WHERE PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($inVideo, $teamIDX);
	return();
}
sub _updateMicroPipes(){
	my $self = shift;
	my $teamIDX = shift;
    my $inPipes = shift;
    my $inWpipes = shift;
	my $SQL = "UPDATE TB_TEAM SET IN_PIPES=?, IN_WPIPES=? WHERE PK_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($inPipes, $inWpipes, $teamIDX);
	return();
}
# ===============================================================
# DELETES
# ===============================================================
sub _deleteERC(){
    my $self = shift;
    my $ecrIDX = shift;
    my $SQL = "DELETE FROM TB_ECR WHERE PK_ECR_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete -> execute($ecrIDX);
    return;
}
return (1);