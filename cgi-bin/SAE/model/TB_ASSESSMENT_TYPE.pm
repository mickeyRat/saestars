package SAE::TB_ASSESSMENT_TYPE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkAssessmentTypeIdx;
my $TxType;
my $TxDetail;
my $InMax;
my $InWeight;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_ASSESSMENT_TYPE () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ASSESSMENT_TYPE_IDX, TX_TYPE, TX_DETAIL, IN_MAX, IN_WEIGHT
		FROM TB_ASSESSMENT_TYPE
		WHERE PK_ASSESSMENT_TYPE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkAssessmentTypeIdx 		 = 	$HASH{PK_ASSESSMENT_TYPE_IDX};
	$TxType 		 = 	$HASH{TX_TYPE};
	$TxDetail 		 = 	$HASH{TX_DETAIL};
	$InMax 		 = 	$HASH{IN_MAX};
	$InWeight 		 = 	$HASH{IN_WEIGHT};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkAssessmentTypeIdx(){
	my ( $self ) = shift;
	return ($PkAssessmentTypeIdx);
}

sub getTxType(){
	my ( $self ) = shift;
	return ($TxType);
}

sub getTxDetail(){
	my ( $self ) = shift;
	return ($TxDetail);
}

sub getInMax(){
	my ( $self ) = shift;
	return ($InMax);
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($InWeight);
}


#------- BUILDING SETTERS------

sub setPkAssessmentTypeIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkAssessmentTypeIdx = $value;
	return ($field);
}

sub setTxType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxType = $value;
	return ($field);
}

sub setTxDetail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxDetail = $value;
	return ($field);
}

sub setInMax(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InMax = $value;
	return ($field);
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InWeight = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_TYPE_IDX from TB_ASSESSMENT_TYPE where TX_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxDetail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_TYPE_IDX from TB_ASSESSMENT_TYPE where TX_DETAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InMax(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_TYPE_IDX from TB_ASSESSMENT_TYPE where IN_MAX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InWeight(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ASSESSMENT_TYPE_IDX from TB_ASSESSMENT_TYPE where IN_WEIGHT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_TYPE set TX_TYPE=? where PK_ASSESSMENT_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxDetail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_TYPE set TX_DETAIL=? where PK_ASSESSMENT_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInMax_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_TYPE set IN_MAX=? where PK_ASSESSMENT_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInWeight_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ASSESSMENT_TYPE set IN_WEIGHT=? where PK_ASSESSMENT_TYPE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

