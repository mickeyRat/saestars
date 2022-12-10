package SAE::TB_FEED;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkFeedIdx;
my $TxTitle;
my $TxFeed;
my $FkTeamIdx;
my $TsCreate;
my $InLike;
my $BoPublic;
my $FkPublishIdx;
my $FkEventIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_FEED (TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX) values (?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxTitle, $TxFeed, $FkTeamIdx, $InLike, $BoPublic, $FkPublishIdx, $FkEventIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, TS_CREATE, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX
		FROM TB_FEED
		WHERE PK_FEED_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkFeedIdx 		 = 	$HASH{PK_FEED_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxFeed 		 = 	$HASH{TX_FEED};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$InLike 		 = 	$HASH{IN_LIKE};
	$BoPublic 		 = 	$HASH{BO_PUBLIC};
	$FkPublishIdx 		 = 	$HASH{FK_PUBLISH_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	return $self;

;}
sub getAllRecordBy_PkFeedIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE PK_FEED_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFeed(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE TX_FEED=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLike(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE IN_LIKE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoPublic(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE BO_PUBLIC=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE FK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FEED_IDX, TX_TITLE, TX_FEED, FK_TEAM_IDX, IN_LIKE, BO_PUBLIC, FK_PUBLISH_IDX, FK_EVENT_IDX FROM TB_FEED";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_FEED_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where PK_FEED_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkFeedIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where PK_FEED_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFeed(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where TX_FEED=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLike(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where IN_LIKE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoPublic(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where BO_PUBLIC=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkPublishIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where FK_PUBLISH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FEED where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkFeedIdx(){
	my ( $self ) = shift;
	return ($PkFeedIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxFeed(){
	my ( $self ) = shift;
	return ($TxFeed);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getInLike(){
	my ( $self ) = shift;
	return ($InLike);
}

sub getBoPublic(){
	my ( $self ) = shift;
	return ($BoPublic);
}

sub getFkPublishIdx(){
	my ( $self ) = shift;
	return ($FkPublishIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}


#------- BUILDING SETTERS------

sub setPkFeedIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkFeedIdx = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setTxFeed(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFeed = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setInLike(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLike = $value;
	return ($field);
}

sub setBoPublic(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoPublic = $value;
	return ($field);
}

sub setFkPublishIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkPublishIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxFeed(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where TX_FEED=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLike(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where IN_LIKE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoPublic(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where BO_PUBLIC=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where FK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FEED_IDX from TB_FEED where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set TX_TITLE=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxFeed_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set TX_FEED=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set FK_TEAM_IDX=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set TS_CREATE=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLike_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set IN_LIKE=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoPublic_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set BO_PUBLIC=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkPublishIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set FK_PUBLISH_IDX=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED set FK_EVENT_IDX=? where PK_FEED_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkFeedIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET PK_FEED_IDX=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET TX_TITLE=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFeed_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET TX_FEED=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET FK_TEAM_IDX=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLike_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET IN_LIKE=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoPublic_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET BO_PUBLIC=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkPublishIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET FK_PUBLISH_IDX=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FEED SET FK_EVENT_IDX=? where PK_FEED_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

