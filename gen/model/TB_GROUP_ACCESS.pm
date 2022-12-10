package SAE::TB_GROUP_ACCESS;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkGroupAccessIdx;
my $FkTilesIdx;
my $FkGroupIdx;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub addNewRecord(){
	my ($self) = shift;

	my $SQL = "INSERT INTO TB_GROUP_ACCESS (FK_TILES_IDX, FK_GROUP_IDX) values (?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkTilesIdx, $FkGroupIdx);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_GROUP_ACCESS_IDX, FK_TILES_IDX, FK_GROUP_IDX
		FROM TB_GROUP_ACCESS
		WHERE PK_GROUP_ACCESS_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkGroupAccessIdx 		 = 	$HASH{PK_GROUP_ACCESS_IDX};
	$FkTilesIdx 		 = 	$HASH{FK_TILES_IDX};
	$FkGroupIdx 		 = 	$HASH{FK_GROUP_IDX};
	return $self;

;}
sub getAllRecordBy_PkGroupAccessIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_ACCESS_IDX, FK_TILES_IDX, FK_GROUP_IDX FROM TB_GROUP_ACCESS WHERE PK_GROUP_ACCESS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_ACCESS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_ACCESS_IDX, FK_TILES_IDX, FK_GROUP_IDX FROM TB_GROUP_ACCESS WHERE FK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_ACCESS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_ACCESS_IDX, FK_TILES_IDX, FK_GROUP_IDX FROM TB_GROUP_ACCESS WHERE FK_GROUP_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_ACCESS_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_GROUP_ACCESS_IDX, FK_TILES_IDX, FK_GROUP_IDX FROM TB_GROUP_ACCESS";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_GROUP_ACCESS_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP_ACCESS where PK_GROUP_ACCESS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkGroupAccessIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP_ACCESS where PK_GROUP_ACCESS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTilesIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP_ACCESS where FK_TILES_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkGroupIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_GROUP_ACCESS where FK_GROUP_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkGroupAccessIdx(){
	my ( $self ) = shift;
	return ($PkGroupAccessIdx);
}

sub getFkTilesIdx(){
	my ( $self ) = shift;
	return ($FkTilesIdx);
}

sub getFkGroupIdx(){
	my ( $self ) = shift;
	return ($FkGroupIdx);
}


#------- BUILDING SETTERS------

sub setPkGroupAccessIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkGroupAccessIdx = $value;
	return ($field);
}

sub setFkTilesIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTilesIdx = $value;
	return ($field);
}

sub setFkGroupIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkGroupIdx = $value;
	return ($field);
}




#------- BUILDING Getting ID by field Name------

sub getIdBy_FkTilesIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GROUP_ACCESS_IDX from TB_GROUP_ACCESS where FK_TILES_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkGroupIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_GROUP_ACCESS_IDX from TB_GROUP_ACCESS where FK_GROUP_IDX=?";
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

	my $SQL = "UPDATE TB_GROUP_ACCESS set FK_TILES_IDX=? where PK_GROUP_ACCESS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkGroupIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP_ACCESS set FK_GROUP_IDX=? where PK_GROUP_ACCESS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkGroupAccessIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP_ACCESS SET PK_GROUP_ACCESS_IDX=? where PK_GROUP_ACCESS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTilesIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP_ACCESS SET FK_TILES_IDX=? where PK_GROUP_ACCESS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkGroupIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_GROUP_ACCESS SET FK_GROUP_IDX=? where PK_GROUP_ACCESS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

