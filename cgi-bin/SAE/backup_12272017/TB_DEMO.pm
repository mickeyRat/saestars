package SAE::TB_DEMO;

use DBI;
use SAE::SDB;

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
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_DEMO (FK_TEAM_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $InLoad, $InUnload, $BoLoad, $BoUnload);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD, TS_CREATE
		FROM TB_DEMO
		WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$PkDemoIdx 		 = 	$HASH{PK_DEMO_IDX};
	$InLoad 		 = 	$HASH{IN_LOAD};
	$InUnload 		 = 	$HASH{IN_UNLOAD};
	$BoLoad 		 = 	$HASH{BO_LOAD};
	$BoUnload 		 = 	$HASH{BO_UNLOAD};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD FROM TB_DEMO WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_PkDemoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD FROM TB_DEMO WHERE PK_DEMO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLoad(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD FROM TB_DEMO WHERE IN_LOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InUnload(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD FROM TB_DEMO WHERE IN_UNLOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoLoad(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD FROM TB_DEMO WHERE BO_LOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoUnload(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT FK_TEAM_IDX, PK_DEMO_IDX, IN_LOAD, IN_UNLOAD, BO_LOAD, BO_UNLOAD FROM TB_DEMO WHERE BO_UNLOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where PK_DEMO_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getPkDemoIdx(){
	my ( $self ) = shift;
	return ($PkDemoIdx);
}

sub getInLoad(){
	my ( $self ) = shift;
	return ($InLoad);
}

sub getInUnload(){
	my ( $self ) = shift;
	return ($InUnload);
}

sub getBoLoad(){
	my ( $self ) = shift;
	return ($BoLoad);
}

sub getBoUnload(){
	my ( $self ) = shift;
	return ($BoUnload);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setPkDemoIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkDemoIdx = $value;
	return ($field);
}

sub setInLoad(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLoad = $value;
	return ($field);
}

sub setInUnload(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InUnload = $value;
	return ($field);
}

sub setBoLoad(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoLoad = $value;
	return ($field);
}

sub setBoUnload(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoUnload = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLoad(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where IN_LOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InUnload(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where IN_UNLOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoLoad(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where BO_LOAD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoUnload(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where BO_UNLOAD=?";
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

	my $SQL = "UPDATE TB_DEMO set FK_TEAM_IDX=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLoad_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set IN_LOAD=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInUnload_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set IN_UNLOAD=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoLoad_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set BO_LOAD=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoUnload_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set BO_UNLOAD=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set TS_CREATE=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

