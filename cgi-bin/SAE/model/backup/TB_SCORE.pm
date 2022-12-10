package SAE::TB_SCORE

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkScoreIdx;
my $FkTeamIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbScoreRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX
		FROM `saestars_DB`.`TB_SCORE`
		WHERE PK_SCORE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkScoreIdx 		 => 	$HASH{PK_SCORE_IDX}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkScoreIdx(){
	my ( $self ) = shift;
	return ($self->{PkScoreIdx});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}


#------- BUILDING SETTERS------

sub setPkScoreIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkScoreIdx} = $value;
	return ($self->{PkScoreIdx});
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}



return (1);

