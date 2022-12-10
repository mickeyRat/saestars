package SAE::TB_COMMENTS;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

my $PkCommentsIdx;
my $FkCardIdx;
my $FkSubsectionIdx;
my $FkTeamIdx;
my $TsCreate;
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

	my $SQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT) values (?, ?, ?, ?, ?)";
	my $insert = $dbi->prepare($SQL);
	   $insert->execute($FkCardIdx, $FkSubsectionIdx, $FkTeamIdx, $FkUserIdx, $ClComment);
	my $newIDX = $insert->{q{mysql_insertid}};
	return($newIDX);

}
sub getRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, TS_CREATE, FK_USER_IDX, CL_COMMENT
		FROM TB_COMMENTS
		WHERE PK_COMMENTS_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	 $PkCommentsIdx 		 = 	$HASH{PK_COMMENTS_IDX};
	$FkCardIdx 		 = 	$HASH{FK_CARD_IDX};
	$FkSubsectionIdx 		 = 	$HASH{FK_SUBSECTION_IDX};
	$FkTeamIdx 		 = 	$HASH{FK_TEAM_IDX};
	$TsCreate 		 = 	$HASH{TS_CREATE};
	$FkUserIdx 		 = 	$HASH{FK_USER_IDX};
	$ClComment 		 = 	$HASH{CL_COMMENT};
	return $self;

;}
sub getAllRecordBy_PkCommentsIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS WHERE PK_COMMENTS_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkCardIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS WHERE FK_CARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkSubsectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS WHERE FK_SUBSECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS WHERE FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS WHERE FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub getAllRecordBy_ClComment(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS WHERE CL_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub getAllRecord(){
	my ($self) = shift;
	my ($value) = shift;

	my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, FK_TEAM_IDX, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS";
	my $select = $dbi->prepare($SQL);
	   $select->execute();
	my %HASH = %{$select->fetchall_hashref(['PK_COMMENTS_IDX'])};
	return(\%HASH);
}

sub deleteRecordById(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where PK_COMMENTS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}


#------- BUILDING GETTERS------

sub deleteRecordBy_PkCommentsIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where PK_COMMENTS_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkCardIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where FK_CARD_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkSubsectionIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where FK_SUBSECTION_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkTeamIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where FK_TEAM_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_FkUserIdx(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where FK_USER_IDX=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub deleteRecordBy_ClComment(){
	my ($self) = shift;
	my ($idx) = shift;

	my $SQL = "DELETE FROM TB_COMMENTS where CL_COMMENT=?";
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
	return();
}

sub getPkCommentsIdx(){
	my ( $self ) = shift;
	return ($PkCommentsIdx);
}

sub getFkCardIdx(){
	my ( $self ) = shift;
	return ($FkCardIdx);
}

sub getFkSubsectionIdx(){
	my ( $self ) = shift;
	return ($FkSubsectionIdx);
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($FkTeamIdx);
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($TsCreate);
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

sub setPkCommentsIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$PkCommentsIdx = $value;
	return ($field);
}

sub setFkCardIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkCardIdx = $value;
	return ($field);
}

sub setFkSubsectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkSubsectionIdx = $value;
	return ($field);
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$FkTeamIdx = $value;
	return ($field);
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$TsCreate = $value;
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

sub getIdBy_FkCardIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENTS_IDX from TB_COMMENTS where FK_CARD_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkSubsectionIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENTS_IDX from TB_COMMENTS where FK_SUBSECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkTeamIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENTS_IDX from TB_COMMENTS where FK_TEAM_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_FkUserIdx(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENTS_IDX from TB_COMMENTS where FK_USER_IDX=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}
sub getIdBy_ClComment(){
	my ($self) = shift;
	my ($value) = shift;

	$SQL = "SELECT PK_COMMENTS_IDX from TB_COMMENTS where CL_COMMENT=?";
	my $select = $dbi->prepare($SQL);
	   $select->execute($value);
	my $idx = $select->fetchrow_array();

	return ($idx);
}

#------- BUILDING update field by ID------

sub updateFkCardIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS set FK_CARD_IDX=? where PK_COMMENTS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkSubsectionIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS set FK_SUBSECTION_IDX=? where PK_COMMENTS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkTeamIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS set FK_TEAM_IDX=? where PK_COMMENTS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateTsCreate_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS set TS_CREATE=? where PK_COMMENTS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateFkUserIdx_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS set FK_USER_IDX=? where PK_COMMENTS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updateClComment_byId(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS set CL_COMMENT=? where PK_COMMENTS_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return($value);

}
sub updatePkCommentsIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS SET PK_COMMENTS_IDX=? where PK_COMMENTS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkCardIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS SET FK_CARD_IDX=? where PK_COMMENTS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkSubsectionIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS SET FK_SUBSECTION_IDX=? where PK_COMMENTS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkTeamIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS SET FK_TEAM_IDX=? where PK_COMMENTS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateFkUserIdx_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS SET FK_USER_IDX=? where PK_COMMENTS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

sub updateClComment_ById(){
	my ($self) = shift;
	my ($value) = shift;
	my ($idx) = shift;

	my $SQL = "UPDATE TB_COMMENTS SET CL_COMMENT=? where PK_COMMENTS_IDX = ?";
	my $update = $dbi->prepare($SQL);
	   $update->execute($value, $idx);
	return ();
}

return (1);

