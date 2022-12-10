package SAE::TB_USER_TEAM

use DBI
use SAE::SDB

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
sub getTbUserTeamRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_TEAM_IDX, FK_USER_IDX, FK_TEAM_IDX
		FROM `saestars_DB`.`TB_USER_TEAM`
		WHERE PK_USER_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkUserTeamIdx 		 => 	$HASH{PK_USER_TEAM_IDX}
		,FkUserIdx 		 => 	$HASH{FK_USER_IDX}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkUserTeamIdx(){
	my ( $self ) = shift;
	return ($self->{PkUserTeamIdx});
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($self->{FkUserIdx});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}


#------- BUILDING SETTERS------

sub setPkUserTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkUserTeamIdx} = $value;
	return ($self->{PkUserTeamIdx});
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkUserIdx} = $value;
	return ($self->{FkUserIdx});
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}



return (1);

