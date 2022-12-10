package SAE::TB_SCORE;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SCORE () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_IDX, FK_TEAM_IDX
		FROM TB_SCORE
		WHERE PK_SCORE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreIdx 		 = 	$HASH{PK_SCORE_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkScoreIdx(){
	my ( $self ) = shift;
	return ($PkScoreIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}


#------- BUILDING SETTERS------

sub setPkScoreIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_IDX from TB_SCORE where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE set FK_TEAM_IDX=? where PK_SCORE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

