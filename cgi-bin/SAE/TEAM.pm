package SAE::TEAM;

use DBI;
use SAE::SDB;
use URI::Escape;
use JSON;
use SAE::TB_TEAM;
use SAE::TB_COUNTRY;

# use DateTime;

my $dbi = new SAE::Db();
my %TEAM;
my %COUNTRY;

sub new{
	$className = shift;
	my $self = {};
	my $teamIDX = shift;
    my $SQL = "SELECT * FROM TB_TEAM WHERE PK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($teamIDX);
    %TEAM = %{$select->fetchrow_hashref()};
    
    $SQL = "SELECT PK_COUNTRY_IDX, TX_COUNTRY FROM TB_COUNTRY";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	%COUNTRY = %{$select->fetchall_hashref(['PK_COUNTRY_IDX'])};

	
	bless($self, $className);
	return $self;
}
sub _getTeamData(){
    my $self = shift;
    return (\%TEAM);
}
sub _getCountryData(){
    my $self = shift;
    return (\%COUNTRY);
}
sub _saveTeamData(){
	my $self = shift;
	my $teamIDX = shift;
    my $hashData = shift;
	my $FIELDS = join("=?, ", keys %$hashData)."=? ";
	my @VALUES = uri_unescape(values %$hashData);
	my $value = join ', ', (split(/ /, "? " x (scalar(keys %$hashData))));
	my $SQL = "UPDATE TB_TEAM SET $FIELDS WHERE PK_TEAM_IDX=?";
	my $insert = $dbi->prepare($SQL);
	for ($i=1; $i <= scalar(@VALUES); $i++) {
		$insert->bind_param($i ,$VALUES[$i-1]) || die "$!";
	}
	$insert->bind_param($i,$teamIDX) ;
	$insert->execute();
	return ($SQL);
}
sub _addNewTeam(){
    my ($self, $hash) = @_;
    my %DATA = %{$hash};
    my @FIELDS = sort keys %DATA;
    my $fields = join (',', sort keys %DATA);
    my $bind = join ', ', (split(/ /, "? " x (scalar(keys %DATA))));
    my $SQL = sprintf "INSERT INTO TB_TEAM (%s) VALUES (%s)",$fields, $bind;
    my $value;
	my $insert = $dbi->prepare($SQL);
	my $i=1;
	foreach $field (@FIELDS){
	    my $bindValue = $DATA{$field};
		$insert->bind_param($i++ ,$bindValue);
	}
	$insert->execute() || die $_;
	my $newIDX = $insert->{q{mysql_insertid}};
	return ($newIDX);
}
sub _getTeamList(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($eventIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    return(\%HASH);
}
sub _getUserTeam(){
    my ($self, $userIDX, $eventIDX) = @_;
    my $SQL = "SELECT UT.* FROM TB_USER_TEAM AS UT JOIN TB_TEAM AS T ON UT.FK_TEAM_IDX=T.PK_TEAM_IDX WHERE UT.FK_USER_IDX=? AND T.FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX, $eventIDX);
    my %HASH = %{$select->fetchall_hashref('FK_TEAM_IDX')};
    return(\%HASH);
}
sub _getTeamDocuments(){
    my ($self, $teamIDX) = @_;
    my $SQL = "SELECT * FROM TB_UPLOAD where FK_TEAM_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $teamIDX,);
    my %HASH = %{$select->fetchall_hashref('IN_PAPER')};
    return(\%HASH);
}
sub _getEventYear(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT IN_YEAR FROM TB_EVENT WHERE PK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute( $eventIDX );
	my ($inYear) = $select->fetchrow_array();
	return($inYear);
}
sub _saveUploadData(){
    my ($self, $teamIDX, $inNumber, $eventIDX, $txKeys, $txFilename, $txType, $txPaper, $inPaper, $txFolder) = @_;
    my $SQL = "INSERT INTO TB_UPLOAD (FK_TEAM_IDX, IN_NUMBER, FK_EVENT_IDX, TX_KEYS, TX_FILENAME, TX_TYPE, TX_PAPER, IN_PAPER, TX_FOLDER) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
        $insert->execute( $teamIDX, $inNumber, $eventIDX, $txKeys, $txFilename, $txType, $txPaper, $inPaper, $txFolder )  || die "Cannot Add @_";
    return;
}
sub _deleteUploadedFile(){
    my ($self, $teamIDX, $inPaper) = @_;
    my $SQL = "DELETE FROM TB_UPLOAD WHERE (FK_TEAM_IDX=? AND IN_PAPER=?)";
    my $delete = $dbi->prepare( $SQL );
       $delete->execute( $teamIDX, $inPaper );
}
sub _getTeamNumberReference(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT IN_NUMBER, PK_TEAM_IDX FROM TB_TEAM WHERE FK_EVENT_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX );
    my %HASH = %{$select->fetchall_hashref('IN_NUMBER')};
    return(\%HASH);
}
# ============== 2022 ==============================
sub _getListOfCountries(){
    my ($self) = @_;
    my $SQL = "SELECT PK_COUNTRY_IDX, TX_COUNTRY FROM TB_COUNTRY";
    my $select = $dbi->prepare($SQL);
       $select->execute();
    my %HASH = %{$select->fetchall_hashref('TX_COUNTRY')};
    return(\%HASH);
}
sub _addCountry(){
    my ($self, $txCountry) = @_;
    my $SQL = "INSERT INTO TB_COUNTRY (TX_COUNTRY) VALUES (?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute( $txCountry );
    my $newIDX = $insert->{q{mysql_insertid}};
    return ($newIDX);
}
sub _getTeamListByClass(){
    my ($self, $eventIDX, $classIDX) = @_;
    my $SQL = "SELECT * FROM TB_TEAM WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $classIDX );
    my %HASH = %{$select->fetchall_hashref('PK_TEAM_IDX')};
    return(\%HASH);
}
return (1);