package SAE::TB_COMMENT

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkCommentIdx;
my $FkTeamIdx;
my $FkAssessmentOptIdx;
my $TxComment;
my $TsCreate;
my $FkUserIdx;
my $BoShow;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbCommentRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_COMMENT_IDX, FK_TEAM_IDX, FK_ASSESSMENT_OPT_IDX, TX_COMMENT, TS_CREATE, FK_USER_IDX, BO_SHOW
		FROM `saestars_DB`.`TB_COMMENT`
		WHERE PK_COMMENT_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkCommentIdx 		 => 	$HASH{PK_COMMENT_IDX}
		,FkTeamIdx 		 => 	$HASH{FK_TEAM_IDX}
		,FkAssessmentOptIdx 		 => 	$HASH{FK_ASSESSMENT_OPT_IDX}
		,TxComment 		 => 	$HASH{TX_COMMENT}
		,TsCreate 		 => 	$HASH{TS_CREATE}
		,FkUserIdx 		 => 	$HASH{FK_USER_IDX}
		,BoShow 		 => 	$HASH{BO_SHOW}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkCommentIdx(){
	my ( $self ) = shift;
	return ($self->{PkCommentIdx});
}

sub getFkTeamIdx(){
	my ( $self ) = shift;
	return ($self->{FkTeamIdx});
}

sub getFkAssessmentOptIdx(){
	my ( $self ) = shift;
	return ($self->{FkAssessmentOptIdx});
}

sub getTxComment(){
	my ( $self ) = shift;
	return ($self->{TxComment});
}

sub getTsCreate(){
	my ( $self ) = shift;
	return ($self->{TsCreate});
}

sub getFkUserIdx(){
	my ( $self ) = shift;
	return ($self->{FkUserIdx});
}

sub getBoShow(){
	my ( $self ) = shift;
	return ($self->{BoShow});
}


#------- BUILDING SETTERS------

sub setPkCommentIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkCommentIdx} = $value;
	return ($self->{PkCommentIdx});
}

sub setFkTeamIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkTeamIdx} = $value;
	return ($self->{FkTeamIdx});
}

sub setFkAssessmentOptIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkAssessmentOptIdx} = $value;
	return ($self->{FkAssessmentOptIdx});
}

sub setTxComment(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxComment} = $value;
	return ($self->{TxComment});
}

sub setTsCreate(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TsCreate} = $value;
	return ($self->{TsCreate});
}

sub setFkUserIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{FkUserIdx} = $value;
	return ($self->{FkUserIdx});
}

sub setBoShow(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{BoShow} = $value;
	return ($self->{BoShow});
}



return (1);

