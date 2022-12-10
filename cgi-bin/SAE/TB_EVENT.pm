package SAE::TB_EVENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkEventIdx;
my $TxEvent;
my $TxEventName;
my $InYear;
my $InElevation;
my $TxEventCity;
my $BoArchive;
my $TxWeb;
my $InMaxTicket;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_EVENT (TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET) values (?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxEvent, $TxEventName, $InYear, $InElevation, $TxEventCity, $BoArchive, $TxWeb, $InMaxTicket);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET
		FROM TB_EVENT
		WHERE PK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkEventIdx 		 = 	$HASH{PK_EVENT_IDX};
	$TxEvent 		 = 	$HASH{TX_EVENT};
	$TxEventName 		 = 	$HASH{TX_EVENT_NAME};
	$InYear 		 = 	$HASH{IN_YEAR};
	$InElevation 		 = 	$HASH{IN_ELEVATION};
	$TxEventCity 		 = 	$HASH{TX_EVENT_CITY};
	$BoArchive 		 = 	$HASH{BO_ARCHIVE};
	$TxWeb 		 = 	$HASH{TX_WEB};
	$InMaxTicket 		 = 	$HASH{IN_MAX_TICKET};
	return $self;

;}
sub getAllRecordBy_PkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE PK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxEvent(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE TX_EVENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxEventName(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE TX_EVENT_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InYear(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE IN_YEAR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InElevation(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE IN_ELEVATION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxEventCity(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE TX_EVENT_CITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoArchive(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE BO_ARCHIVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxWeb(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE TX_WEB=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMaxTicket(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT WHERE IN_MAX_TICKET=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_EVENT_IDX, TX_EVENT, TX_EVENT_NAME, IN_YEAR, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB, IN_MAX_TICKET FROM TB_EVENT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_EVENT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where PK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where PK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxEvent(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where TX_EVENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxEventName(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where TX_EVENT_NAME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InYear(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where IN_YEAR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InElevation(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where IN_ELEVATION=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxEventCity(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where TX_EVENT_CITY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoArchive(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where BO_ARCHIVE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxWeb(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where TX_WEB=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMaxTicket(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_EVENT where IN_MAX_TICKET=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkEventIdx(){
	my ( $self ) = shift;
	return ($PkEventIdx);
}

sub getTxEvent(){
	my ( $self ) = shift;
	return ($TxEvent);
}

sub getTxEventName(){
	my ( $self ) = shift;
	return ($TxEventName);
}

sub getInYear(){
	my ( $self ) = shift;
	return ($InYear);
}

sub getInElevation(){
	my ( $self ) = shift;
	return ($InElevation);
}

sub getTxEventCity(){
	my ( $self ) = shift;
	return ($TxEventCity);
}

sub getBoArchive(){
	my ( $self ) = shift;
	return ($BoArchive);
}

sub getTxWeb(){
	my ( $self ) = shift;
	return ($TxWeb);
}

sub getInMaxTicket(){
	my ( $self ) = shift;
	return ($InMaxTicket);
}


#------- BUILDING SETTERS------

sub setPkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkEventIdx = $value;
	return ($field);
}

sub setTxEvent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxEvent = $value;
	return ($field);
}

sub setTxEventName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxEventName = $value;
	return ($field);
}

sub setInYear(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InYear = $value;
	return ($field);
}

sub setInElevation(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InElevation = $value;
	return ($field);
}

sub setTxEventCity(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxEventCity = $value;
	return ($field);
}

sub setBoArchive(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoArchive = $value;
	return ($field);
}

sub setTxWeb(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxWeb = $value;
	return ($field);
}

sub setInMaxTicket(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMaxTicket = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxEvent(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where TX_EVENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxEventName(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where TX_EVENT_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InYear(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where IN_YEAR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InElevation(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where IN_ELEVATION=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxEventCity(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where TX_EVENT_CITY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoArchive(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where BO_ARCHIVE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxWeb(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where TX_WEB=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMaxTicket(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where IN_MAX_TICKET=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxEvent_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set TX_EVENT=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxEventName_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set TX_EVENT_NAME=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInYear_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set IN_YEAR=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInElevation_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set IN_ELEVATION=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxEventCity_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set TX_EVENT_CITY=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoArchive_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set BO_ARCHIVE=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxWeb_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set TX_WEB=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMaxTicket_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set IN_MAX_TICKET=? where PK_EVENT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET PK_EVENT_IDX=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxEvent_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET TX_EVENT=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxEventName_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET TX_EVENT_NAME=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInYear_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET IN_YEAR=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInElevation_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET IN_ELEVATION=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxEventCity_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET TX_EVENT_CITY=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoArchive_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET BO_ARCHIVE=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxWeb_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET TX_WEB=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMaxTicket_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT SET IN_MAX_TICKET=? where PK_EVENT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

