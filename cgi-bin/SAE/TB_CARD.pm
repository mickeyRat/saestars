package SAE::TB_CARD;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCardIdx;
my $FkUserIdx;
my $FkTeamIdx;
my $FkCardtypeIdx;
my $FkEventIdx;
my $InScore;
my $TsTimestamp;
my $InStatus;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_CARD (FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkTeamIdx, $FkCardtypeIdx, $FkEventIdx, $InScore, $TsTimestamp, $InStatus);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS
		FROM TB_CARD
		WHERE PK_CARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCardIdx 		 = 	$HASH{PK_CARD_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$FkCardtypeIdx 		 = 	$HASH{FK_CARDTYPE_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$InScore 		 = 	$HASH{IN_SCORE};
	$TsTimestamp 		 = 	$HASH{TS_TIMESTAMP};
	$InStatus 		 = 	$HASH{IN_STATUS};
	return $self;

;}
sub getAllRecordBy_PkCardIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE PK_CARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkCardtypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE FK_CARDTYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TsTimestamp(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE TS_TIMESTAMP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD WHERE IN_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CARD_IDX, FK_USER_IDX, FK_TEAM_IDX, FK_CARDTYPE_IDX, FK_EVENT_IDX, IN_SCORE, TS_TIMESTAMP, IN_STATUS FROM TB_CARD";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_CARD_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where PK_CARD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkCardIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where PK_CARD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkCardtypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where FK_CARDTYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InScore(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where IN_SCORE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TsTimestamp(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where TS_TIMESTAMP=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CARD where IN_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkCardIdx(){
	my ( $self ) = shift;
	return ($PkCardIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getFkCardtypeIdx(){
	my ( $self ) = shift;
	return ($FkCardtypeIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getInScore(){
	my ( $self ) = shift;
	return ($InScore);
}

sub getTsTimestamp(){
	my ( $self ) = shift;
	return ($TsTimestamp);
}

sub getInStatus(){
	my ( $self ) = shift;
	return ($InStatus);
}


#------- BUILDING SETTERS------

sub setPkCardIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCardIdx = $value;
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

sub setFkCardtypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkCardtypeIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setInScore(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InScore = $value;
	return ($field);
}

sub setTsTimestamp(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsTimestamp = $value;
	return ($field);
}

sub setInStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InStatus = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARD_IDX from TB_CARD where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARD_IDX from TB_CARD where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkCardtypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARD_IDX from TB_CARD where FK_CARDTYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARD_IDX from TB_CARD where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InScore(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARD_IDX from TB_CARD where IN_SCORE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CARD_IDX from TB_CARD where IN_STATUS=?";
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

	my $SQL = "UPDATE TB_CARD set FK_USER_IDX=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD set FK_TEAM_IDX=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkCardtypeIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD set FK_CARDTYPE_IDX=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD set FK_EVENT_IDX=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInScore_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD set IN_SCORE=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsTimestamp_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD set TS_TIMESTAMP=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD set IN_STATUS=? where PK_CARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCardIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET PK_CARD_IDX=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET FK_USER_IDX=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET FK_TEAM_IDX=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkCardtypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET FK_CARDTYPE_IDX=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET FK_EVENT_IDX=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInScore_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET IN_SCORE=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTsTimestamp_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET TS_TIMESTAMP=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CARD SET IN_STATUS=? where PK_CARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

