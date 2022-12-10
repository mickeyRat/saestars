package SAE::TB_TODO_TYPE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTodoTypeIdx;
my $TxTodo;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TODO_TYPE (TX_TODO) values (?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxTodo);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TODO_TYPE_IDX, TX_TODO
		FROM TB_TODO_TYPE
		WHERE PK_TODO_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTodoTypeIdx 		 = 	$HASH{PK_TODO_TYPE_IDX};
	$TxTodo 		 = 	$HASH{TX_TODO};
	return $self;

;}
sub getAllRecordBy_PkTodoTypeIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_TYPE_IDX, TX_TODO FROM TB_TODO_TYPE WHERE PK_TODO_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTodo(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_TYPE_IDX, TX_TODO FROM TB_TODO_TYPE WHERE TX_TODO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_TYPE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TODO_TYPE_IDX, TX_TODO FROM TB_TODO_TYPE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TODO_TYPE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_TYPE where PK_TODO_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTodoTypeIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_TYPE where PK_TODO_TYPE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTodo(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TODO_TYPE where TX_TODO=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTodoTypeIdx(){
	my ( $self ) = shift;
	return ($PkTodoTypeIdx);
}

sub getTxTodo(){
	my ( $self ) = shift;
	return ($TxTodo);
}


#------- BUILDING SETTERS------

sub setPkTodoTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTodoTypeIdx = $value;
	return ($field);
}

sub setTxTodo(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTodo = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxTodo(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TODO_TYPE_IDX from TB_TODO_TYPE where TX_TODO=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxTodo_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_TYPE set TX_TODO=? where PK_TODO_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTodoTypeIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_TYPE SET PK_TODO_TYPE_IDX=? where PK_TODO_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTodo_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TODO_TYPE SET TX_TODO=? where PK_TODO_TYPE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

