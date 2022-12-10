package SAE::REPORTS;

use DBI;
use SAE::SDB;

use URI::Escape;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub _getJudgesToDos(){
    my $self = shift;
    my $userIDX = shift;
    my $cardtypeIDX = shift;
    my $location = shift;
    my $SQL = "SELECT CARD.PK_CARD_IDX, TEAM.PK_TEAM_IDX, TEAM.IN_NUMBER, TEAM.TX_SCHOOL, TEAM.FK_CLASS_IDX, CARD.IN_STATUS
        FROM TB_CARD AS CARD JOIN TB_TEAM AS TEAM ON TEAM.PK_TEAM_IDX=CARD.FK_TEAM_IDX 
        WHERE ((CARD.FK_USER_IDX=?) AND (CARD.FK_CARDTYPE_IDX=?) AND (CARD.FK_EVENT_IDX=?))";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX, $cardtypeIDX, $location);
    my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_CARD_IDX'])};
    return (\%HASH);
}
# TEMPLATE & COMMENTS
sub _loadTeamplate(){
    my $self = shift;
    my $userIDX = shift;
    my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, CL_COMMENT FROM TB_TEMPLATE WHERE FK_USER_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($userIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEMPLATE_IDX')};
    return (\%HASH);
}
sub _loadTeamplateItem(){
    my $self = shift;
    my $templateIDX = shift;
    my $SQL = "SELECT PK_TEMPLATE_IDX, TX_TITLE, CL_COMMENT FROM TB_TEMPLATE WHERE PK_TEMPLATE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($templateIDX);
    my %HASH = %{$select->fetchall_hashref('PK_TEMPLATE_IDX')};
    return (\%HASH);
}
sub _saveToTemplate(){
    my $self = shift;
    my $txTitle = shift;
    my $userIDX = shift;
    my $comments = shift;
    my $SQL = "INSERT INTO TB_TEMPLATE (TX_TITLE, FK_USER_IDX, CL_COMMENT) VALUES (?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($txTitle, $userIDX, uri_unescape($comments));
    my $templateIDX =  $insert->{q{mysql_insertid}};
    return ($templateIDX);
}
sub _deleteTemplate(){
    my $self = shift;
    my $templateIDX = shift;
    my $SQL = "DELETE FROM TB_TEMPLATE WHERE PK_TEMPLATE_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete->execute($templateIDX);
}
sub _updateTemplate(){
    my $self = shift;
    my $txTitle = shift;
    my $comments = shift;
    my $templateIDX = shift;
    my $SQL = "UPDATE TB_TEMPLATE SET TX_TITLE=?, CL_COMMENT=? WHERE PK_TEMPLATE_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($txTitle, uri_unescape($comments), $templateIDX);
    return ();
}
sub _loadComments(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, TS_CREATE, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS 
        WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref(['FK_SUBSECTION_IDX','PK_COMMENTS_IDX'])};
    return (\%HASH);
}
sub _postComments(){
    my $self = shift;
    my $cardIDX = shift;
    my $subSectionIDX = shift;
    my $userIDX = shift;
    my $comments = shift;
    my $teamIDX = shift;
    my $SQL = "INSERT INTO TB_COMMENTS (FK_CARD_IDX, FK_SUBSECTION_IDX, FK_USER_IDX, CL_COMMENT, FK_TEAM_IDX) VALUES (?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subSectionIDX, $userIDX, uri_unescape($comments), $teamIDX) || die "Cannot Add $_";
    my $commentIDX =  $insert->{q{mysql_insertid}};
    return ($commentIDX);
}
sub _loadCommentsToEdit(){
    my $self = shift;
    my $commentIDX = shift;
    my $SQL = "SELECT PK_COMMENTS_IDX, FK_CARD_IDX, FK_SUBSECTION_IDX, TS_CREATE, FK_USER_IDX, CL_COMMENT FROM TB_COMMENTS 
        WHERE PK_COMMENTS_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($commentIDX);
    my %HASH = %{$select->fetchall_hashref('PK_COMMENTS_IDX')};
    return (\%HASH);
}
sub _updateComments(){
    my $self = shift;
    my $comments = shift;
    my $commentIDX = shift;
    my $SQL = "UPDATE TB_COMMENTS SET CL_COMMENT=? WHERE PK_COMMENTS_IDX=?";
    my $insert = $dbi->prepare($SQL);
       $insert->execute(uri_unescape($comments), $commentIDX);
    return ();
}
sub _deleteComment(){
    my $self = shift;
    my $commentIDX = shift;
    my $SQL = "DELETE FROM TB_COMMENTS WHERE PK_COMMENTS_IDX=?";
    my $delete = $dbi->prepare($SQL) || die "Cannot Delete @_";
       $delete->execute($commentIDX);
}
sub _insertPaperScore(){
    my $self=shift;
    my $cardIDX = shift;
    my $subSectionIDX = shift;
    my $inValue = shift;
    my $SQL = "INSERT INTO TB_PAPER (FK_CARD_IDX, FK_SUBSECTION_IDX, IN_VALUE) VALUES (?,?,?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($cardIDX, $subSectionIDX, $inValue);
    return;
}
sub _getCardRecords(){
    my $self = shift;
    my $cardIDX = shift;
    my $SQL = "SELECT FK_SUBSECTION_IDX, IN_VALUE FROM TB_PAPER WHERE FK_CARD_IDX=?";
    my $select = $dbi->prepare($SQL);
       $select->execute($cardIDX);
    my %HASH = %{$select->fetchall_hashref('FK_SUBSECTION_IDX')};
    return (\%HASH);
}
sub _isBinaryInputs(){
    my $self = shift;
    # my $cardIDX = shift;
    my $SQL = "SELECT FK_SECTION_IDX FROM TB_SUBSECTION WHERE IN_TYPE=?";
    my $select = $dbi->prepare($SQL);
       $select->execute(1);
    my %HASH = %{$select->fetchall_hashref('FK_SECTION_IDX')};
    return (\%HASH);
}
return (1);