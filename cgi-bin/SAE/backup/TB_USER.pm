package SAE::TB_USER

use DBI
use SAE::SDB

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
sub getTbUserRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, BO_DAILY, BO_WEEKLY
		FROM `saestars_DB`.`TB_USER`
		WHERE PK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkUserIdx 		 => 	$HASH{PK_USER_IDX}
		,TxFirstName 		 => 	$HASH{TX_FIRST_NAME}
		,TxLastName 		 => 	$HASH{TX_LAST_NAME}
		,InUserType 		 => 	$HASH{IN_USER_TYPE}
		,FkDefaultEventIdx 		 => 	$HASH{FK_DEFAULT_EVENT_IDX}
		,TxPassword 		 => 	$HASH{TX_PASSWORD}
		,BoReset 		 => 	$HASH{BO_RESET}
		,TxLogin 		 => 	$HASH{TX_LOGIN}
		,TxEmail 		 => 	$HASH{TX_EMAIL}
		,InLimit 		 => 	$HASH{IN_LIMIT}
		,BoDaily 		 => 	$HASH{BO_DAILY}
		,BoWeekly 		 => 	$HASH{BO_WEEKLY}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkUserIdx(){
	my ( $self ) = shift;
	return ($self->{PkUserIdx});
}

sub getTxFirstName(){
	my ( $self ) = shift;
	return ($self->{TxFirstName});
}

sub getTxLastName(){
	my ( $self ) = shift;
	return ($self->{TxLastName});
}

sub getInUserType(){
	my ( $self ) = shift;
	return ($self->{InUserType});
}

sub getFkDefaultEventIdx(){
	my ( $self ) = shift;
	return ($self->{FkDefaultEventIdx});
}

sub getTxPassword(){
	my ( $self ) = shift;
	return ($self->{TxPassword});
}

sub getBoReset(){
	my ( $self ) = shift;
	return ($self->{BoReset});
}

sub getTxLogin(){
	my ( $self ) = shift;
	return ($self->{TxLogin});
}

sub getTxEmail(){
	my ( $self ) = shift;
	return ($self->{TxEmail});
}

sub getInLimit(){
	my ( $self ) = shift;
	return ($self->{InLimit});
}

sub getBoDaily(){
	my ( $self ) = shift;
	return ($self->{BoDaily});
}

sub getBoWeekly(){
	my ( $self ) = shift;
	return ($self->{BoWeekly});
}


#------- BUILDING SETTERS------

sub setPkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkUserIdx} = $value;
	return ($self->{PkUserIdx});
}

sub setTxFirstName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxFirstName} = $value;
	return ($self->{TxFirstName});
}

sub setTxLastName(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxLastName} = $value;
	return ($self->{TxLastName});
}

sub setInUserType(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InUserType} = $value;
	return ($self->{InUserType});
}

sub setFkDefaultEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkDefaultEventIdx} = $value;
	return ($self->{FkDefaultEventIdx});
}

sub setTxPassword(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxPassword} = $value;
	return ($self->{TxPassword});
}

sub setBoReset(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoReset} = $value;
	return ($self->{BoReset});
}

sub setTxLogin(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxLogin} = $value;
	return ($self->{TxLogin});
}

sub setTxEmail(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxEmail} = $value;
	return ($self->{TxEmail});
}

sub setInLimit(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InLimit} = $value;
	return ($self->{InLimit});
}

sub setBoDaily(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoDaily} = $value;
	return ($self->{BoDaily});
}

sub setBoWeekly(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoWeekly} = $value;
	return ($self->{BoWeekly});
}



return (1);

