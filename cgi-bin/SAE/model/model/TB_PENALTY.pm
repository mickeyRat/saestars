package SAE::TB_PENALTY;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkPenaltyIdx;
my $FkTeamIdx;
my $TxType;
my $TxDetails;
my $TsCreate;
my $InValue;
my $TxCategory;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_PENALTY () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_PENALTY_IDX, FK_TEAM_IDX, TX_TYPE, TX_DETAILS, TS_CREATE, IN_VALUE, TX_CATEGORY
		FROM TB_PENALTY
		WHERE PK_PENALTY_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkPenaltyIdx 		 = 	$HASH{PK_PENALTY_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$TxDetails 		 = 	$HASH{TX_DETAILS};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$InValue 		 = 	$HASH{IN_VALUE};
	$TxCategory 		 = 	$HASH{TX_CATEGORY};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkPenaltyIdx(){
	my ( $self ) = shift;
	return ($PkPenaltyIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getTxDetails(){
	my ( $self ) = shift;
	return ($TxDetails);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getInValue(){
	my ( $self ) = shift;
	return ($InValue);
}

sub getTxCategory(){
	my ( $self ) = shift;
	return ($TxCategory);
}


#------- BUILDING SETTERS------

sub setPkPenaltyIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkPenaltyIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setTxDetails(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxDetails = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setInValue(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InValue = $value;
	return ($field);
}

sub setTxCategory(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxCategory = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_IDX from TB_PENALTY where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_IDX from TB_PENALTY where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetails(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_IDX from TB_PENALTY where TX_DETAILS=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InValue(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_IDX from TB_PENALTY where IN_VALUE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxCategory(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_PENALTY_IDX from TB_PENALTY where TX_CATEGORY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY set FK_TEAM_IDX=? where PK_PENALTY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY set TX_TYPE=? where PK_PENALTY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetails_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY set TX_DETAILS=? where PK_PENALTY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY set TS_CREATE=? where PK_PENALTY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInValue_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY set IN_VALUE=? where PK_PENALTY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxCategory_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_PENALTY set TX_CATEGORY=? where PK_PENALTY_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

