package SAE::TB_AWARD;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkAwardIdx;
my $FkClassIdx;
my $TxAward;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_AWARD (FK_CLASS_IDX, TX_AWARD) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkClassIdx, $TxAward);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_AWARD_IDX, FK_CLASS_IDX, TX_AWARD
		FROM TB_AWARD
		WHERE PK_AWARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkAwardIdx 		 = 	$HASH{PK_AWARD_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$TxAward 		 = 	$HASH{TX_AWARD};
	return $self;

;}
sub getAllRecordBy_PkAwardIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AWARD_IDX, FK_CLASS_IDX, TX_AWARD FROM TB_AWARD WHERE PK_AWARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AWARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AWARD_IDX, FK_CLASS_IDX, TX_AWARD FROM TB_AWARD WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AWARD_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxAward(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AWARD_IDX, FK_CLASS_IDX, TX_AWARD FROM TB_AWARD WHERE TX_AWARD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AWARD_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AWARD_IDX, FK_CLASS_IDX, TX_AWARD FROM TB_AWARD";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_AWARD_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AWARD where PK_AWARD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkAwardIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AWARD where PK_AWARD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AWARD where FK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxAward(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AWARD where TX_AWARD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkAwardIdx(){
	my ( $self ) = shift;
	return ($PkAwardIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}

sub getTxAward(){
	my ( $self ) = shift;
	return ($TxAward);
}


#------- BUILDING SETTERS------

sub setPkAwardIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkAwardIdx = $value;
	return ($field);
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkClassIdx = $value;
	return ($field);
}

sub setTxAward(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxAward = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AWARD_IDX from TB_AWARD where FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxAward(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AWARD_IDX from TB_AWARD where TX_AWARD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkClassIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AWARD set FK_CLASS_IDX=? where PK_AWARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxAward_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AWARD set TX_AWARD=? where PK_AWARD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkAwardIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AWARD SET PK_AWARD_IDX=? where PK_AWARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkClassIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AWARD SET FK_CLASS_IDX=? where PK_AWARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxAward_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AWARD SET TX_AWARD=? where PK_AWARD_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

