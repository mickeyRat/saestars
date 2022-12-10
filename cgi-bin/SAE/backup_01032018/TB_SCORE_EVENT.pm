package SAE::TB_SCORE_EVENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreEventIdx;
my $TxScoreEvent;
my $InMax;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_SCORE_EVENT (TX_SCORE_EVENT, IN_MAX) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxScoreEvent, $InMax);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_EVENT_IDX, TX_SCORE_EVENT, IN_MAX
		FROM TB_SCORE_EVENT
		WHERE PK_SCORE_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreEventIdx 		 = 	$HASH{PK_SCORE_EVENT_IDX};
	$TxScoreEvent 		 = 	$HASH{TX_SCORE_EVENT};
	$InMax 		 = 	$HASH{IN_MAX};
	return $self;

;}
sub getAllRecordBy_PkScoreEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_EVENT_IDX, TX_SCORE_EVENT, IN_MAX FROM TB_SCORE_EVENT WHERE PK_SCORE_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxScoreEvent(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_EVENT_IDX, TX_SCORE_EVENT, IN_MAX FROM TB_SCORE_EVENT WHERE TX_SCORE_EVENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_EVENT_IDX, TX_SCORE_EVENT, IN_MAX FROM TB_SCORE_EVENT WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_EVENT_IDX, TX_SCORE_EVENT, IN_MAX FROM TB_SCORE_EVENT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_EVENT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_EVENT where PK_SCORE_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkScoreEventIdx(){
	my ( $self ) = shift;
	return ($PkScoreEventIdx);
}

sub getTxScoreEvent(){
	my ( $self ) = shift;
	return ($TxScoreEvent);
}

sub getInMax(){
	my ( $self ) = shift;
	return ($InMax);
}


#------- BUILDING SETTERS------

sub setPkScoreEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreEventIdx = $value;
	return ($field);
}

sub setTxScoreEvent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxScoreEvent = $value;
	return ($field);
}

sub setInMax(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMax = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxScoreEvent(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_EVENT_IDX from TB_SCORE_EVENT where TX_SCORE_EVENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_EVENT_IDX from TB_SCORE_EVENT where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxScoreEvent_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_EVENT set TX_SCORE_EVENT=? where PK_SCORE_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_EVENT set IN_MAX=? where PK_SCORE_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkScoreEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_EVENT SET PK_SCORE_EVENT_IDX=? where PK_SCORE_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxScoreEvent_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_EVENT SET TX_SCORE_EVENT=? where PK_SCORE_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_EVENT SET IN_MAX=? where PK_SCORE_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

