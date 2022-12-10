package SAE::TB_PAPER_STATUS;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPaperStatusIdx;
my $TxPaperStatus;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_PAPER_STATUS (TX_PAPER_STATUS) values (?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxPaperStatus);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PAPER_STATUS_IDX, TX_PAPER_STATUS
		FROM TB_PAPER_STATUS
		WHERE PK_PAPER_STATUS_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPaperStatusIdx 		 = 	$HASH{PK_PAPER_STATUS_IDX};
	$TxPaperStatus 		 = 	$HASH{TX_PAPER_STATUS};
	return $self;

;}
sub getAllRecordBy_PkPaperStatusIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_STATUS_IDX, TX_PAPER_STATUS FROM TB_PAPER_STATUS WHERE PK_PAPER_STATUS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_STATUS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxPaperStatus(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_STATUS_IDX, TX_PAPER_STATUS FROM TB_PAPER_STATUS WHERE TX_PAPER_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_STATUS_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_PAPER_STATUS_IDX, TX_PAPER_STATUS FROM TB_PAPER_STATUS";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_PAPER_STATUS_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER_STATUS where PK_PAPER_STATUS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkPaperStatusIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER_STATUS where PK_PAPER_STATUS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxPaperStatus(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_PAPER_STATUS where TX_PAPER_STATUS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkPaperStatusIdx(){
	my ( $self ) = shift;
	return ($PkPaperStatusIdx);
}

sub getTxPaperStatus(){
	my ( $self ) = shift;
	return ($TxPaperStatus);
}


#------- BUILDING SETTERS------

sub setPkPaperStatusIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPaperStatusIdx = $value;
	return ($field);
}

sub setTxPaperStatus(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxPaperStatus = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxPaperStatus(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PAPER_STATUS_IDX from TB_PAPER_STATUS where TX_PAPER_STATUS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxPaperStatus_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER_STATUS set TX_PAPER_STATUS=? where PK_PAPER_STATUS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkPaperStatusIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER_STATUS SET PK_PAPER_STATUS_IDX=? where PK_PAPER_STATUS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxPaperStatus_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PAPER_STATUS SET TX_PAPER_STATUS=? where PK_PAPER_STATUS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

