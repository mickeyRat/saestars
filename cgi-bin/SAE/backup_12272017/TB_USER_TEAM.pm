package SAE::TB_USER_TEAM;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkUserTeamIdx;
my $FkUserIdx;
my $FkTeamIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_USER_TEAM (FK_USER_IDX, FK_TEAM_IDX) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkTeamIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_TEAM_IDX, FK_USER_IDX, FK_TEAM_IDX
		FROM TB_USER_TEAM
		WHERE PK_USER_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUserTeamIdx 		 = 	$HASH{PK_USER_TEAM_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	return $self;

;}
sub getAllRecordBy_PkUserTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_TEAM_IDX, FK_USER_IDX, FK_TEAM_IDX FROM TB_USER_TEAM WHERE PK_USER_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_TEAM_IDX, FK_USER_IDX, FK_TEAM_IDX FROM TB_USER_TEAM WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_TEAM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_TEAM_IDX, FK_USER_IDX, FK_TEAM_IDX FROM TB_USER_TEAM WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_TEAM_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER_TEAM where PK_USER_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkUserTeamIdx(){
	my ( $self ) = shift;
	return ($PkUserTeamIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}


#------- BUILDING SETTERS------

sub setPkUserTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUserTeamIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_TEAM_IDX from TB_USER_TEAM where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_TEAM_IDX from TB_USER_TEAM where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_TEAM set FK_USER_IDX=? where PK_USER_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER_TEAM set FK_TEAM_IDX=? where PK_USER_TEAM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

