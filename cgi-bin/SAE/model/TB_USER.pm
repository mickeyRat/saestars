package SAE::TB_USER;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkUserIdx;
my $TxFirstName;
my $TxLastName;
my $InUserType;
my $FkDefaultEventIdx;
my $TxPassword;
my $BoReset;
my $TxLogin;
my $TxEmail;
my $InLimit;
my $BoDaily;
my $BoWeekly;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_USER () values ()";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute();
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, BO_DAILY, BO_WEEKLY
		FROM TB_USER
		WHERE PK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUserIdx 		 = 	$HASH{PK_USER_IDX};
	$TxFirstName 		 = 	$HASH{TX_FIRST_NAME};
	$TxLastName 		 = 	$HASH{TX_LAST_NAME};
	$InUserType 		 = 	$HASH{IN_USER_TYPE};
	$FkDefaultEventIdx 		 = 	$HASH{FK_DEFAULT_EVENT_IDX};
	$TxPassword 		 = 	$HASH{TX_PASSWORD};
	$BoReset 		 = 	$HASH{BO_RESET};
	$TxLogin 		 = 	$HASH{TX_LOGIN};
	$TxEmail 		 = 	$HASH{TX_EMAIL};
	$InLimit 		 = 	$HASH{IN_LIMIT};
	$BoDaily 		 = 	$HASH{BO_DAILY};
	$BoWeekly 		 = 	$HASH{BO_WEEKLY};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkUserIdx(){
	my ( $self ) = shift;
	return ($PkUserIdx);
}

sub getTxFirstName(){
	my ( $self ) = shift;
	return ($TxFirstName);
}

sub getTxLastName(){
	my ( $self ) = shift;
	return ($TxLastName);
}

sub getInUserType(){
	my ( $self ) = shift;
	return ($InUserType);
}

sub getFkDefaultEventIdx(){
	my ( $self ) = shift;
	return ($FkDefaultEventIdx);
}

sub getTxPassword(){
	my ( $self ) = shift;
	return ($TxPassword);
}

sub getBoReset(){
	my ( $self ) = shift;
	return ($BoReset);
}

sub getTxLogin(){
	my ( $self ) = shift;
	return ($TxLogin);
}

sub getTxEmail(){
	my ( $self ) = shift;
	return ($TxEmail);
}

sub getInLimit(){
	my ( $self ) = shift;
	return ($InLimit);
}

sub getBoDaily(){
	my ( $self ) = shift;
	return ($BoDaily);
}

sub getBoWeekly(){
	my ( $self ) = shift;
	return ($BoWeekly);
}


#------- BUILDING SETTERS------

sub setPkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUserIdx = $value;
	return ($field);
}

sub setTxFirstName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxFirstName = $value;
	return ($field);
}

sub setTxLastName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxLastName = $value;
	return ($field);
}

sub setInUserType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InUserType = $value;
	return ($field);
}

sub setFkDefaultEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkDefaultEventIdx = $value;
	return ($field);
}

sub setTxPassword(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxPassword = $value;
	return ($field);
}

sub setBoReset(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoReset = $value;
	return ($field);
}

sub setTxLogin(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxLogin = $value;
	return ($field);
}

sub setTxEmail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxEmail = $value;
	return ($field);
}

sub setInLimit(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$InLimit = $value;
	return ($field);
}

sub setBoDaily(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoDaily = $value;
	return ($field);
}

sub setBoWeekly(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoWeekly = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxFirstName(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where TX_FIRST_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxLastName(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where TX_LAST_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InUserType(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where IN_USER_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkDefaultEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where FK_DEFAULT_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxPassword(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where TX_PASSWORD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoReset(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where BO_RESET=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxLogin(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where TX_LOGIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxEmail(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where TX_EMAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_InLimit(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where IN_LIMIT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoDaily(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where BO_DAILY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoWeekly(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where BO_WEEKLY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxFirstName_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TX_FIRST_NAME=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxLastName_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TX_LAST_NAME=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInUserType_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set IN_USER_TYPE=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkDefaultEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set FK_DEFAULT_EVENT_IDX=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxPassword_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TX_PASSWORD=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoReset_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set BO_RESET=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxLogin_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TX_LOGIN=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxEmail_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TX_EMAIL=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateInLimit_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set IN_LIMIT=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoDaily_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set BO_DAILY=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoWeekly_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set BO_WEEKLY=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
return (1);

