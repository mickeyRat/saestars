package SAE::TB_AUDIT;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkAuditIdx;
my $FkUserIdx;
my $FkEventIdx;
my $TxRemoteAddr;
my $ClUserAgent;
my $TsCreate;
my $ClCookie;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_AUDIT (FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $FkEventIdx, $TxRemoteAddr, $ClUserAgent, $ClCookie);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, TS_CREATE, CL_COOKIE
		FROM TB_AUDIT
		WHERE PK_AUDIT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkAuditIdx 		 = 	$HASH{PK_AUDIT_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$FkEventIdx 		 = 	$HASH{FK_EVENT_IDX};
	$TxRemoteAddr 		 = 	$HASH{TX_REMOTE_ADDR};
	$ClUserAgent 		 = 	$HASH{CL_USER_AGENT};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$ClCookie 		 = 	$HASH{CL_COOKIE};
	return $self;

;}
sub getAllRecordBy_PkAuditIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT WHERE PK_AUDIT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT WHERE FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxRemoteAddr(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT WHERE TX_REMOTE_ADDR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClUserAgent(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT WHERE CL_USER_AGENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClCookie(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT WHERE CL_COOKIE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_AUDIT_IDX, FK_USER_IDX, FK_EVENT_IDX, TX_REMOTE_ADDR, CL_USER_AGENT, CL_COOKIE FROM TB_AUDIT";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_AUDIT_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where PK_AUDIT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkAuditIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where PK_AUDIT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkEventIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where FK_EVENT_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxRemoteAddr(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where TX_REMOTE_ADDR=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClUserAgent(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where CL_USER_AGENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClCookie(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_AUDIT where CL_COOKIE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkAuditIdx(){
	my ( $self ) = shift;
	return ($PkAuditIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getFkEventIdx(){
	my ( $self ) = shift;
	return ($FkEventIdx);
}

sub getTxRemoteAddr(){
	my ( $self ) = shift;
	return ($TxRemoteAddr);
}

sub getClUserAgent(){
	my ( $self ) = shift;
	return ($ClUserAgent);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
}

sub getClCookie(){
	my ( $self ) = shift;
	return ($ClCookie);
}


#------- BUILDING SETTERS------

sub setPkAuditIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkAuditIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setFkEventIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkEventIdx = $value;
	return ($field);
}

sub setTxRemoteAddr(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxRemoteAddr = $value;
	return ($field);
}

sub setClUserAgent(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClUserAgent = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
	return ($field);
}

sub setClCookie(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClCookie = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AUDIT_IDX from TB_AUDIT where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkEventIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AUDIT_IDX from TB_AUDIT where FK_EVENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxRemoteAddr(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AUDIT_IDX from TB_AUDIT where TX_REMOTE_ADDR=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClUserAgent(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AUDIT_IDX from TB_AUDIT where CL_USER_AGENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClCookie(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_AUDIT_IDX from TB_AUDIT where CL_COOKIE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT set FK_USER_IDX=? where PK_AUDIT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkEventIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT set FK_EVENT_IDX=? where PK_AUDIT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxRemoteAddr_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT set TX_REMOTE_ADDR=? where PK_AUDIT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClUserAgent_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT set CL_USER_AGENT=? where PK_AUDIT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT set TS_CREATE=? where PK_AUDIT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClCookie_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT set CL_COOKIE=? where PK_AUDIT_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkAuditIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT SET PK_AUDIT_IDX=? where PK_AUDIT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT SET FK_USER_IDX=? where PK_AUDIT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkEventIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT SET FK_EVENT_IDX=? where PK_AUDIT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxRemoteAddr_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT SET TX_REMOTE_ADDR=? where PK_AUDIT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClUserAgent_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT SET CL_USER_AGENT=? where PK_AUDIT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClCookie_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_AUDIT SET CL_COOKIE=? where PK_AUDIT_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

