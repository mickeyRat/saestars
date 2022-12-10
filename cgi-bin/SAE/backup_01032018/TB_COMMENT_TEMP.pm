package SAE::TB_COMMENT_TEMP;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCommentTemIdx;
my $FkUserIdx;
my $TxTitle;
my $TxComment;
my $BoPrivate;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_COMMENT_TEMP (FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE) values (?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkUserIdx, $TxTitle, $TxComment, $BoPrivate);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE
		FROM TB_COMMENT_TEMP
		WHERE PK_COMMENT_TEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCommentTemIdx 		 = 	$HASH{PK_COMMENT_TEM_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$TxComment 		 = 	$HASH{TX_COMMENT};
	$BoPrivate 		 = 	$HASH{BO_PRIVATE};
	return $self;

;}
sub getAllRecordBy_PkCommentTemIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE FROM TB_COMMENT_TEMP WHERE PK_COMMENT_TEM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE FROM TB_COMMENT_TEMP WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE FROM TB_COMMENT_TEMP WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE FROM TB_COMMENT_TEMP WHERE TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_BoPrivate(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE FROM TB_COMMENT_TEMP WHERE BO_PRIVATE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENT_TEM_IDX, FK_USER_IDX, TX_TITLE, TX_COMMENT, BO_PRIVATE FROM TB_COMMENT_TEMP";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENT_TEM_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENT_TEMP where PK_COMMENT_TEM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub getPkCommentTemIdx(){
	my ( $self ) = shift;
	return ($PkCommentTemIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getTxComment(){
	my ( $self ) = shift;
	return ($TxComment);
}

sub getBoPrivate(){
	my ( $self ) = shift;
	return ($BoPrivate);
}


#------- BUILDING SETTERS------

sub setPkCommentTemIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCommentTemIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setTxComment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxComment = $value;
	return ($field);
}

sub setBoPrivate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$BoPrivate = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_TEM_IDX from TB_COMMENT_TEMP where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_TEM_IDX from TB_COMMENT_TEMP where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_TxComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_TEM_IDX from TB_COMMENT_TEMP where TX_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_BoPrivate(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENT_TEM_IDX from TB_COMMENT_TEMP where BO_PRIVATE=?";
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

	my $SQL = "UPDATE TB_COMMENT_TEMP set FK_USER_IDX=? where PK_COMMENT_TEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP set TX_TITLE=? where PK_COMMENT_TEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTxComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP set TX_COMMENT=? where PK_COMMENT_TEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateBoPrivate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP set BO_PRIVATE=? where PK_COMMENT_TEM_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCommentTemIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP SET PK_COMMENT_TEM_IDX=? where PK_COMMENT_TEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP SET FK_USER_IDX=? where PK_COMMENT_TEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP SET TX_TITLE=? where PK_COMMENT_TEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP SET TX_COMMENT=? where PK_COMMENT_TEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateBoPrivate_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENT_TEMP SET BO_PRIVATE=? where PK_COMMENT_TEM_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

