package SAE::TB_CLASS;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkClassIdx;
my $TxClass;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_CLASS (TX_CLASS) values (?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxClass);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_CLASS_IDX, TX_CLASS
		FROM TB_CLASS
		WHERE PK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkClassIdx 		 = 	$HASH{PK_CLASS_IDX};
	$TxClass 		 = 	$HASH{TX_CLASS};
	return $self;

;}
sub getAllRecordBy_PkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CLASS_IDX, TX_CLASS FROM TB_CLASS WHERE PK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CLASS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxClass(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_CLASS_IDX, TX_CLASS FROM TB_CLASS WHERE TX_CLASS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_CLASS_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_CLASS where PK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkClassIdx(){
	my ( $self ) = shift;
	return ($PkClassIdx);
}

sub getTxClass(){
	my ( $self ) = shift;
	return ($TxClass);
}


#------- BUILDING SETTERS------

sub setPkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkClassIdx = $value;
	return ($field);
}

sub setTxClass(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxClass = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxClass(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_CLASS_IDX from TB_CLASS where TX_CLASS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxClass_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_CLASS set TX_CLASS=? where PK_CLASS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

