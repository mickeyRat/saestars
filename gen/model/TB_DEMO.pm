package SAE::TB_DEMO;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkDemoIdx;
my $FkTeamIdx;
my $FkEventIdx;
my $InTime1;
my $InTime2;
my $BoPass1;
my $BoPass2;
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

	my $SQL = "INSERT INTO TB_DEMO (FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2) values (?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTeamIdx, $FkEventIdx, $InTime1, $InTime2, $BoPass1, $BoPass2);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2, TS_CREATE
		FROM TB_DEMO
		WHERE PK_DEMO_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkDemoIdx 		 = 	$HASH{PK_DEMO_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InTime1 		 = 	$HASH{IN_TIME1};
	$InTime2 		 = 	$HASH{IN_TIME2};
	$BoPass1 		 = 	$HASH{BO_PASS1};
	$BoPass2 		 = 	$HASH{BO_PASS2};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkDemoIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE PK_DEMO_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTime1(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE IN_TIME1=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InTime2(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE IN_TIME2=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoPass1(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE BO_PASS1=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoPass2(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO WHERE BO_PASS2=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_DEMO_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_DEMO_IDX, FK_TEAM_IDX, FK_EVENT_IDX, IN_TIME1, IN_TIME2, BO_PASS1, BO_PASS2 FROM TB_DEMO";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
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

sub deleteRecordBy_PkDemoIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where PK_DEMO_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTime1(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where IN_TIME1=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InTime2(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where IN_TIME2=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoPass1(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where BO_PASS1=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoPass2(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_DEMO where BO_PASS2=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkDemoIdx(){
	my ( $self ) = shift;
	return ($PkDemoIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInTime1(){
	my ( $self ) = shift;
	return ($InTime1);
}

sub getInTime2(){
	my ( $self ) = shift;
	return ($InTime2);
}

sub getBoPass1(){
	my ( $self ) = shift;
	return ($BoPass1);
}

sub getBoPass2(){
	my ( $self ) = shift;
	return ($BoPass2);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkDemoIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkDemoIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setInTime1(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTime1 = $value;
	return ($field);
}

sub setInTime2(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InTime2 = $value;
	return ($field);
}

sub setBoPass1(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoPass1 = $value;
	return ($field);
}

sub setBoPass2(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoPass2 = $value;
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
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTime1(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where IN_TIME1=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InTime2(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where IN_TIME2=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoPass1(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where BO_PASS1=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoPass2(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_DEMO_IDX from TB_DEMO where BO_PASS2=?";
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
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set FK_EVENT_IDX=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTime1_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set IN_TIME1=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInTime2_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set IN_TIME2=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoPass1_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set BO_PASS1=? where PK_DEMO_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoPass2_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO set BO_PASS2=? where PK_DEMO_IDX=?";
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
sub updatePkDemoIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET PK_DEMO_IDX=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET FK_TEAM_IDX=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET FK_EVENT_IDX=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTime1_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET IN_TIME1=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInTime2_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET IN_TIME2=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoPass1_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET BO_PASS1=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoPass2_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_DEMO SET BO_PASS2=? where PK_DEMO_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

