package SAE::TB_FINAL;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkFinalIdx;
my $FkEventIdx;
my $FkPublishIdx;
my $TsCreate;
my $TxAward;
my $InOrder;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_FINAL (FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER) values (?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkEventIdx, $FkPublishIdx, $TxAward, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TS_CREATE, TX_AWARD, IN_ORDER
		FROM TB_FINAL
		WHERE PK_FINAL_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkFinalIdx 		 = 	$HASH{PK_FINAL_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$FkPublishIdx 		 = 	$HASH{FK_PUBLISH_IDX};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$TxAward 		 = 	$HASH{TX_AWARD};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkFinalIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER FROM TB_FINAL WHERE PK_FINAL_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FINAL_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER FROM TB_FINAL WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FINAL_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER FROM TB_FINAL WHERE FK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FINAL_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxAward(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER FROM TB_FINAL WHERE TX_AWARD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FINAL_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER FROM TB_FINAL WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_FINAL_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_FINAL_IDX, FK_EVENT_IDX, FK_PUBLISH_IDX, TX_AWARD, IN_ORDER FROM TB_FINAL";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_FINAL_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FINAL where PK_FINAL_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkFinalIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FINAL where PK_FINAL_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FINAL where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkPublishIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FINAL where FK_PUBLISH_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxAward(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FINAL where TX_AWARD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_FINAL where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkFinalIdx(){
	my ( $self ) = shift;
	return ($PkFinalIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getFkPublishIdx(){
	my ( $self ) = shift;
	return ($FkPublishIdx);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getTxAward(){
	my ( $self ) = shift;
	return ($TxAward);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkFinalIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkFinalIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setFkPublishIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkPublishIdx = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setTxAward(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxAward = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FINAL_IDX from TB_FINAL where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkPublishIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FINAL_IDX from TB_FINAL where FK_PUBLISH_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxAward(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FINAL_IDX from TB_FINAL where TX_AWARD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_FINAL_IDX from TB_FINAL where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL set FK_EVENT_IDX=? where PK_FINAL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkPublishIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL set FK_PUBLISH_IDX=? where PK_FINAL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL set TS_CREATE=? where PK_FINAL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxAward_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL set TX_AWARD=? where PK_FINAL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL set IN_ORDER=? where PK_FINAL_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkFinalIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL SET PK_FINAL_IDX=? where PK_FINAL_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL SET FK_EVENT_IDX=? where PK_FINAL_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkPublishIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL SET FK_PUBLISH_IDX=? where PK_FINAL_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxAward_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL SET TX_AWARD=? where PK_FINAL_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_FINAL SET IN_ORDER=? where PK_FINAL_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

