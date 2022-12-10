package SAE::TB_TEMPLATE;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkTemplateIdx;
my $TxTitle;
my $FkUserIdx;
my $ClComment;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_TEMPLATE (TX_TITLE, FK_USER_IDX, CL_COMMENT) values (?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($TxTitle, $FkUserIdx, $ClComment);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, FK_USER_IDX, CL_COMMENT
		FROM TB_TEMPLATE
		WHERE PK_TEMPLATE_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkTemplateIdx 		 = 	$HASH{PK_TEMPLATE_IDX};
	$TxTitle 		 = 	$HASH{TX_TITLE};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$ClComment 		 = 	$HASH{CL_COMMENT};
	return $self;

;}
sub getAllRecordBy_PkTemplateIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, FK_USER_IDX, CL_COMMENT FROM TB_TEMPLATE WHERE PK_TEMPLATE_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEMPLATE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, FK_USER_IDX, CL_COMMENT FROM TB_TEMPLATE WHERE TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEMPLATE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, FK_USER_IDX, CL_COMMENT FROM TB_TEMPLATE WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEMPLATE_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, FK_USER_IDX, CL_COMMENT FROM TB_TEMPLATE WHERE CL_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_TEMPLATE_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, FK_USER_IDX, CL_COMMENT FROM TB_TEMPLATE";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_TEMPLATE_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEMPLATE where PK_TEMPLATE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkTemplateIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEMPLATE where PK_TEMPLATE_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_TxTitle(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEMPLATE where TX_TITLE=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEMPLATE where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClComment(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_TEMPLATE where CL_COMMENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkTemplateIdx(){
	my ( $self ) = shift;
	return ($PkTemplateIdx);
}

sub getTxTitle(){
	my ( $self ) = shift;
	return ($TxTitle);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}

sub getClComment(){
	my ( $self ) = shift;
	return ($ClComment);
}


#------- BUILDING SETTERS------

sub setPkTemplateIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkTemplateIdx = $value;
	return ($field);
}

sub setTxTitle(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TxTitle = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}

sub setClComment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$ClComment = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_TxTitle(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEMPLATE_IDX from TB_TEMPLATE where TX_TITLE=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEMPLATE_IDX from TB_TEMPLATE where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_TEMPLATE_IDX from TB_TEMPLATE where CL_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateTxTitle_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE set TX_TITLE=? where PK_TEMPLATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE set FK_USER_IDX=? where PK_TEMPLATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE set CL_COMMENT=? where PK_TEMPLATE_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkTemplateIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE SET PK_TEMPLATE_IDX=? where PK_TEMPLATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateTxTitle_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE SET TX_TITLE=? where PK_TEMPLATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE SET FK_USER_IDX=? where PK_TEMPLATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_TEMPLATE SET CL_COMMENT=? where PK_TEMPLATE_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

