package SAE::TB_EVENT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkEventIdx;
my $TxEventName;
my $InElevation;
my $TxEventCity;
my $BoArchive;
my $TxWeb;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_EVENT () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_EVENT_IDX, TX_EVENT_NAME, IN_ELEVATION, TX_EVENT_CITY, BO_ARCHIVE, TX_WEB
		FROM TB_EVENT
		WHERE PK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkEventIdx 		 = 	$HASH{PK_EVENT_IDX};
	$TxEventName 		 = 	$HASH{TX_EVENT_NAME};
	$InElevation 		 = 	$HASH{IN_ELEVATION};
	$TxEventCity 		 = 	$HASH{TX_EVENT_CITY};
	$BoArchive 		 = 	$HASH{BO_ARCHIVE};
	$TxWeb 		 = 	$HASH{TX_WEB};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkEventIdx(){
	my ( $self ) = shift;
	return ($PkEventIdx);
}

sub getTxEventName(){
	my ( $self ) = shift;
	return ($TxEventName);
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


#------- BUILDING SETTERS------

sub setPkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkEventIdx = $value;
	return ($field);
}

sub setTxEventName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxEventName = $value;
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




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxEventName(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_EVENT_IDX from TB_EVENT where TX_EVENT_NAME=?";
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

#------- BUILDING update field by ID------

sub updateTxEventName_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_EVENT set TX_EVENT_NAME=? where PK_EVENT_IDX=?";
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
return (1);

