package SAE::TB_DEMO

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $FkTeamIdx;
my $PkDemoIdx;
my $InLoad;
my $InUnload;
my $BoLoad;
my $BoUnload;
my $TsCreate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbDemoRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD, TS_CREATE
		FROM `saestars_DB`.`TB_DEMO`
		WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
		,PkDemoIdx 		 => 	$HASH{PK_DEMO_IDX}
		,InLoad 		 => 	$HASH{IN_LOAD}
		,InUnload 		 => 	$HASH{IN_UNLOAD}
		,BoLoad 		 => 	$HASH{BO_LOAD}
		,BoUnload 		 => 	$HASH{BO_UNLOAD}
		,TsCreate 		 => 	$HASH{TS_CREATE}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}

sub getPkDemoIdx(){
	my ( $self ) = shift;
	return ($self->{PkDemoIdx});
}

sub getInLoad(){
	my ( $self ) = shift;
	return ($self->{InLoad});
}

sub getInUnload(){
	my ( $self ) = shift;
	return ($self->{InUnload});
}

sub getBoLoad(){
	my ( $self ) = shift;
	return ($self->{BoLoad});
}

sub getBoUnload(){
	my ( $self ) = shift;
	return ($self->{BoUnload});
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($self->{TsCreate});
}


#------- BUILDING SETTERS------

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}

sub setPkDemoIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkDemoIdx} = $value;
	return ($self->{PkDemoIdx});
}

sub setInLoad(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InLoad} = $value;
	return ($self->{InLoad});
}

sub setInUnload(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InUnload} = $value;
	return ($self->{InUnload});
}

sub setBoLoad(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoLoad} = $value;
	return ($self->{BoLoad});
}

sub setBoUnload(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoUnload} = $value;
	return ($self->{BoUnload});
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsCreate} = $value;
	return ($self->{TsCreate});
}



return (1);

