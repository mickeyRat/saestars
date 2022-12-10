package SAE::TB_SCORE_GROUP;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkScoreGroupIdx;
my $FkScoreEventIdx;
my $FkClassIdx;
my $TxScoreGroup;
my $ClDetails;
my $InMax;
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

	my $SQL = "INSERT INTO TB_SCORE_GROUP (FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER) values (?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkScoreEventIdx, $FkClassIdx, $TxScoreGroup, $ClDetails, $InMax, $InOrder);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER
		FROM TB_SCORE_GROUP
		WHERE PK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkScoreGroupIdx 		 = 	$HASH{PK_SCORE_GROUP_IDX};
	$FkScoreEventIdx 		 = 	$HASH{FK_SCORE_EVENT_IDX};
	$FkClassIdx 		 = 	$HASH{FK_CLASS_IDX};
	$TxScoreGroup 		 = 	$HASH{TX_SCORE_GROUP};
	$ClDetails 		 = 	$HASH{CL_DETAILS};
	$InMax 		 = 	$HASH{IN_MAX};
	$InOrder 		 = 	$HASH{IN_ORDER};
	return $self;

;}
sub getAllRecordBy_PkScoreGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE PK_SCORE_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkScoreEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE FK_SCORE_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxScoreGroup(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE TX_SCORE_GROUP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClDetails(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE CL_DETAILS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP WHERE IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_SCORE_GROUP_IDX, FK_SCORE_EVENT_IDX, FK_CLASS_IDX, TX_SCORE_GROUP, CL_DETAILS, IN_MAX, IN_ORDER FROM TB_SCORE_GROUP";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_SCORE_GROUP_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where PK_SCORE_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkScoreGroupIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where PK_SCORE_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkScoreEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where FK_SCORE_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkClassIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where FK_CLASS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxScoreGroup(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where TX_SCORE_GROUP=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClDetails(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where CL_DETAILS=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InMax(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where IN_MAX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InOrder(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_SCORE_GROUP where IN_ORDER=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkScoreGroupIdx(){
	my ( $self ) = shift;
	return ($PkScoreGroupIdx);
}

sub getFkScoreEventIdx(){
	my ( $self ) = shift;
	return ($FkScoreEventIdx);
}

sub getFkClassIdx(){
	my ( $self ) = shift;
	return ($FkClassIdx);
}

sub getTxScoreGroup(){
	my ( $self ) = shift;
	return ($TxScoreGroup);
}

sub getClDetails(){
	my ( $self ) = shift;
	return ($ClDetails);
}

sub getInMax(){
	my ( $self ) = shift;
	return ($InMax);
}

sub getInOrder(){
	my ( $self ) = shift;
	return ($InOrder);
}


#------- BUILDING SETTERS------

sub setPkScoreGroupIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkScoreGroupIdx = $value;
	return ($field);
}

sub setFkScoreEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkScoreEventIdx = $value;
	return ($field);
}

sub setFkClassIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkClassIdx = $value;
	return ($field);
}

sub setTxScoreGroup(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxScoreGroup = $value;
	return ($field);
}

sub setClDetails(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClDetails = $value;
	return ($field);
}

sub setInMax(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMax = $value;
	return ($field);
}

sub setInOrder(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InOrder = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkScoreEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_GROUP_IDX from TB_SCORE_GROUP where FK_SCORE_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkClassIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_GROUP_IDX from TB_SCORE_GROUP where FK_CLASS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxScoreGroup(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_GROUP_IDX from TB_SCORE_GROUP where TX_SCORE_GROUP=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClDetails(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_GROUP_IDX from TB_SCORE_GROUP where CL_DETAILS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_GROUP_IDX from TB_SCORE_GROUP where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InOrder(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_SCORE_GROUP_IDX from TB_SCORE_GROUP where IN_ORDER=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkScoreEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP set FK_SCORE_EVENT_IDX=? where PK_SCORE_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkClassIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP set FK_CLASS_IDX=? where PK_SCORE_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxScoreGroup_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP set TX_SCORE_GROUP=? where PK_SCORE_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClDetails_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP set CL_DETAILS=? where PK_SCORE_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP set IN_MAX=? where PK_SCORE_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInOrder_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP set IN_ORDER=? where PK_SCORE_GROUP_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkScoreGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET PK_SCORE_GROUP_IDX=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkScoreEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET FK_SCORE_EVENT_IDX=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkClassIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET FK_CLASS_IDX=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxScoreGroup_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET TX_SCORE_GROUP=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClDetails_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET CL_DETAILS=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInMax_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET IN_MAX=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInOrder_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_SCORE_GROUP SET IN_ORDER=? where PK_SCORE_GROUP_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

