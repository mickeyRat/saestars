package SAE::TB_USER;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkUserIdx;
my $FkGroupIdx;
my $TxFirstName;
my $TxLastName;
my $InUserType;
my $FkDefaultEventIdx;
my $TxPassword;
my $BoReset;
my $TxLogin;
my $TxEmail;
my $InLimit;
my $TxYear;
my $BoVolAlum;
my $BoStuAlum;
my $BoExtra;
my $BoDaily;
my $BoWeekly;
my $TsCreate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_USER (FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkGroupIdx, $TxFirstName, $TxLastName, $InUserType, $FkDefaultEventIdx, $TxPassword, $BoReset, $TxLogin, $TxEmail, $InLimit, $TxYear, $BoVolAlum, $BoStuAlum, $BoExtra, $BoDaily, $BoWeekly);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY, TS_CREATE
		FROM TB_USER
		WHERE PK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkUserIdx 		 = 	$HASH{PK_USER_IDX};
	$FkGroupIdx 		 = 	$HASH{FK_GROUP_IDX};
	$TxFirstName 		 = 	$HASH{TX_FIRST_NAME};
	$TxLastName 		 = 	$HASH{TX_LAST_NAME};
	$InUserType 		 = 	$HASH{IN_USER_TYPE};
	$FkDefaultEventIdx 		 = 	$HASH{FK_DEFAULT_EVENT_IDX};
	$TxPassword 		 = 	$HASH{TX_PASSWORD};
	$BoReset 		 = 	$HASH{BO_RESET};
	$TxLogin 		 = 	$HASH{TX_LOGIN};
	$TxEmail 		 = 	$HASH{TX_EMAIL};
	$InLimit 		 = 	$HASH{IN_LIMIT};
	$TxYear 		 = 	$HASH{TX_YEAR};
	$BoVolAlum 		 = 	$HASH{BO_VOL_ALUM};
	$BoStuAlum 		 = 	$HASH{BO_STU_ALUM};
	$BoExtra 		 = 	$HASH{BO_EXTRA};
	$BoDaily 		 = 	$HASH{BO_DAILY};
	$BoWeekly 		 = 	$HASH{BO_WEEKLY};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	return $self;

;}
sub getAllRecordBy_PkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE PK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE FK_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxFirstName(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE TX_FIRST_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxLastName(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE TX_LAST_NAME=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InUserType(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE IN_USER_TYPE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkDefaultEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE FK_DEFAULT_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxPassword(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE TX_PASSWORD=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoReset(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE BO_RESET=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxLogin(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE TX_LOGIN=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxEmail(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE TX_EMAIL=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_InLimit(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE IN_LIMIT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxYear(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE TX_YEAR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoVolAlum(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE BO_VOL_ALUM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoStuAlum(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE BO_STU_ALUM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoExtra(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE BO_EXTRA=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoDaily(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE BO_DAILY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoWeekly(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER WHERE BO_WEEKLY=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_USER_IDX, FK_GROUP_IDX, TX_FIRST_NAME, TX_LAST_NAME, IN_USER_TYPE, FK_DEFAULT_EVENT_IDX, TX_PASSWORD, BO_RESET, TX_LOGIN, TX_EMAIL, IN_LIMIT, TX_YEAR, BO_VOL_ALUM, BO_STU_ALUM, BO_EXTRA, BO_DAILY, BO_WEEKLY FROM TB_USER";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_USER_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where PK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where PK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkGroupIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where FK_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxFirstName(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where TX_FIRST_NAME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxLastName(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where TX_LAST_NAME=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InUserType(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where IN_USER_TYPE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkDefaultEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where FK_DEFAULT_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxPassword(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where TX_PASSWORD=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoReset(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where BO_RESET=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxLogin(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where TX_LOGIN=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxEmail(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where TX_EMAIL=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_InLimit(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where IN_LIMIT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxYear(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where TX_YEAR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoVolAlum(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where BO_VOL_ALUM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoStuAlum(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where BO_STU_ALUM=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoExtra(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where BO_EXTRA=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoDaily(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where BO_DAILY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_BoWeekly(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_USER where BO_WEEKLY=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkUserIdx(){
	my ( $self ) = shift;
	return ($PkUserIdx);
}

sub getFkGroupIdx(){
	my ( $self ) = shift;
	return ($FkGroupIdx);
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

sub getTxYear(){
	my ( $self ) = shift;
	return ($TxYear);
}

sub getBoVolAlum(){
	my ( $self ) = shift;
	return ($BoVolAlum);
}

sub getBoStuAlum(){
	my ( $self ) = shift;
	return ($BoStuAlum);
}

sub getBoExtra(){
	my ( $self ) = shift;
	return ($BoExtra);
}

sub getBoDaily(){
	my ( $self ) = shift;
	return ($BoDaily);
}

sub getBoWeekly(){
	my ( $self ) = shift;
	return ($BoWeekly);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}


#------- BUILDING SETTERS------

sub setPkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkUserIdx = $value;
	return ($field);
}

sub setFkGroupIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkGroupIdx = $value;
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

sub setTxYear(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxYear = $value;
	return ($field);
}

sub setBoVolAlum(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoVolAlum = $value;
	return ($field);
}

sub setBoStuAlum(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoStuAlum = $value;
	return ($field);
}

sub setBoExtra(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoExtra = $value;
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

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where FK_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
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
sub getIdBy_TxYear(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where TX_YEAR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoVolAlum(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where BO_VOL_ALUM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoStuAlum(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where BO_STU_ALUM=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoExtra(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_USER_IDX from TB_USER where BO_EXTRA=?";
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

sub updateFkGroupIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set FK_GROUP_IDX=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
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
sub updateTxYear_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TX_YEAR=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoVolAlum_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set BO_VOL_ALUM=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoStuAlum_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set BO_STU_ALUM=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoExtra_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set BO_EXTRA=? where PK_USER_IDX=?";
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
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER set TS_CREATE=? where PK_USER_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET PK_USER_IDX=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET FK_GROUP_IDX=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxFirstName_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET TX_FIRST_NAME=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxLastName_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET TX_LAST_NAME=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInUserType_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET IN_USER_TYPE=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkDefaultEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET FK_DEFAULT_EVENT_IDX=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxPassword_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET TX_PASSWORD=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoReset_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET BO_RESET=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxLogin_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET TX_LOGIN=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxEmail_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET TX_EMAIL=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateInLimit_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET IN_LIMIT=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxYear_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET TX_YEAR=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoVolAlum_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET BO_VOL_ALUM=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoStuAlum_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET BO_STU_ALUM=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoExtra_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET BO_EXTRA=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoDaily_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET BO_DAILY=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoWeekly_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_USER SET BO_WEEKLY=? where PK_USER_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

