package SAE::TB_ACCESS;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkAccessIdx;
my $FkTilesIdx;
my $FkUserIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_ACCESS (FK_TILES_IDX, FK_USER_IDX) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTilesIdx, $FkUserIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_ACCESS_IDX, FK_TILES_IDX, FK_USER_IDX
		FROM TB_ACCESS
		WHERE PK_ACCESS_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkAccessIdx 		 = 	$HASH{PK_ACCESS_IDX};
	$FkTilesIdx 		 = 	$HASH{FK_TILES_IDX};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	return $self;

;}
sub getAllRecordBy_PkAccessIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ACCESS_IDX, FK_TILES_IDX, FK_USER_IDX FROM TB_ACCESS WHERE PK_ACCESS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ACCESS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ACCESS_IDX, FK_TILES_IDX, FK_USER_IDX FROM TB_ACCESS WHERE FK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ACCESS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ACCESS_IDX, FK_TILES_IDX, FK_USER_IDX FROM TB_ACCESS WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_ACCESS_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_ACCESS_IDX, FK_TILES_IDX, FK_USER_IDX FROM TB_ACCESS";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_ACCESS_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ACCESS where PK_ACCESS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkAccessIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ACCESS where PK_ACCESS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTilesIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ACCESS where FK_TILES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_ACCESS where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkAccessIdx(){
	my ( $self ) = shift;
	return ($PkAccessIdx);
}

sub getFkTilesIdx(){
	my ( $self ) = shift;
	return ($FkTilesIdx);
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($FkUserIdx);
}


#------- BUILDING SETTERS------

sub setPkAccessIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkAccessIdx = $value;
	return ($field);
}

sub setFkTilesIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTilesIdx = $value;
	return ($field);
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkUserIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ACCESS_IDX from TB_ACCESS where FK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_ACCESS_IDX from TB_ACCESS where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkTilesIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ACCESS set FK_TILES_IDX=? where PK_ACCESS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ACCESS set FK_USER_IDX=? where PK_ACCESS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkAccessIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ACCESS SET PK_ACCESS_IDX=? where PK_ACCESS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTilesIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ACCESS SET FK_TILES_IDX=? where PK_ACCESS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_ACCESS SET FK_USER_IDX=? where PK_ACCESS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

