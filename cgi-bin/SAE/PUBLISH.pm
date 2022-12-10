package SAE::PUBLISH;

use DBI;
use SAE::SDB;
use List::Util qw( sum min max reduce );
use Number::Format;
use Statistics::Basic qw(:all);
use SAE::Auth();
use SAE::USER();


my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
#====================================== SETTERS ==================================================================
 sub _generateResults(){
    my ($self, $eventIDX, $classIDX, $txTitle, $userIDX) = @_;
    my %CLASS = (1=>'Regular Class', 2=>'Advanced Class', 3=>'Micro Class');
    my $now_string = localtime;
    my $Auth = new SAE::Auth();
    my $User = new SAE::USER();
    my $userName = $User->_getUserById($userIDX);
    my $txFile = $Auth->getTemporaryPassword(64); 
    my $SQL = "INSERT INTO TB_PUBLISH (FK_EVENT_IDX, FK_CLASS_IDX, TX_CLASS, TX_TITLE, TX_FILE, TX_TIME, TX_PUBLISH_BY) 
        VALUES (?, ?, ?, ?, ?, ?, ?)";
    my $insert = $dbi->prepare($SQL);
       $insert->execute($eventIDX, $classIDX, $CLASS{$classIDX}, $txTitle, $txFile, $now_string, $userName);
    my $newIDX = $insert->{q{mysql_insertid}} || die "Error $_";
    return ($newIDX, $txFile, $now_string, $userName);
}
sub _activatePublicView(){
    my ($self, $publishIDX, $checked) = @_;
    my $SQL = "UPDATE TB_PUBLISH SET IN_SHOW=? WHERE PK_PUBLISH_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute( $checked, $publishIDX );
    return;
}
sub _activateIncludeView(){
    my ($self, $publishIDX, $checked) = @_;
    my $SQL = "UPDATE TB_PUBLISH SET IN_INCLUDE=? WHERE PK_PUBLISH_IDX=?";
    my $update = $dbi->prepare($SQL);
       $update->execute( $checked, $publishIDX );
    return;
}
#====================================== GETTERS ==================================================================
sub _getSelectedFinalReportFileID(){
    my ($self, $eventIDX) = @_;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND IN_INCLUDE=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, 1 );
    my %HASH = %{$select->fetchall_hashref(['TX_TITLE', 'FK_CLASS_IDX'])};
    return (\%HASH);
}
sub _getReportHeaders(){
    my ($self, $txFile) = @_;
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE (TX_FILE=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $txFile );
    my %HASH = %{$select->fetchrow_hashref};
    return (\%HASH);
}
sub _getPublishedResults(){
    my ($self, $eventIDX, $classIDX, $txTitle) = @_;
    # print "$eventIDX, $classIDX, $txTitle\n";
    my $SQL = "SELECT * FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=? AND TX_TITLE=?)";
    my $select = $dbi->prepare($SQL);
       $select->execute( $eventIDX, $classIDX, $txTitle );
    my %HASH = %{$select->fetchall_hashref('PK_PUBLISH_IDX')}; 
    my %AWARD = ('Design Report'=>1,'Presentation Scores'=>1,'Mission Performance Scores'=>1,'Overall Performance'=>1);
    my $str;
    foreach $publishIDX (sort keys %HASH) {
        $str .= '<div ID="PUBLISH_'.$publishIDX.'" class="w3-card-2 w3-border w3-round w3-margin-bottom">';
        $str .= '<header class="w3-container w3-light-grey">';
        $str .= sprintf '<h5 class="w3-small">%s - Generated on: %s ( <i>v.%d</i > ) published by: <b>%s</b></h5>', $txTitle, $HASH{$publishIDX}{TX_TIME}, $publishIDX, $HASH{$publishIDX}{TX_PUBLISH_BY};
        $str .= '</header>';
        $str .= '<div class="w3-container w3-white w3-padding">';
        my $checked = '';
        my $include = '';
        if ($HASH{$publishIDX}{IN_SHOW}==1) {$checked = 'checked'}
        if ($HASH{$publishIDX}{IN_INCLUDE}==1) {$include = 'checked'}
        $str .= '<p>';
        if (exists $AWARD{$HASH{$publishIDX}{TX_TITLE}}){
            $str .= sprintf '<input class="w3-check" type="checkbox" %s onclick="sae_includeInFinalScore(this, %d);"><label  class="w3-margin-left">Include this result in the Final Award Presentation</label><br>', $include, $publishIDX, $eventIDX;
        }
        $str .= sprintf '<input class="w3-check" type="checkbox" %s onclick="sae_activatePublicView(this, %d);">', $checked, $publishIDX;
        $str .= sprintf '<label class="w3-margin-left w3-pale-red w3-padding">Public Access</label><span class="w3-margin-left w3-margin-right"><a href="post.html?fileID=%s" target="_blank">View</a></span>',  $HASH{$publishIDX}{TX_FILE};
        $str .= ' | ';
        $str .= sprintf '<span class="w3-margin-left w3-margin-right"><a href="javascript:void(0);" onclick="sae_deletePublishScore(%d);">Delete</a></span>', $publishIDX;
        # $str .= ' | ';
        # $str .= sprintf '<span class="w3-margin-left w3-margin-right"><a href="javascript:void(0);" onclick="sae_includeInFinalScore(%d, %d);">Include In Final</a></span></p>', $publishIDX, $eventIDX;
        $str .= '</div>';
        $str .= '</div>';
    }
    # print $str."\n";
    return ($str);
}
# sub _getPublishedSuperlativeResults(){
#     my ($self, $eventIDX, $classIDX, $txTitle) = @_;
#     # print "$eventIDX, $classIDX, $txTitle\n";
#     my $SQL = "SELECT * FROM TB_PUBLISH WHERE (FK_EVENT_IDX=? AND FK_CLASS_IDX=? AND TX_TITLE=?)";
#     my $select = $dbi->prepare($SQL);
#       $select->execute( $eventIDX, $classIDX, $txTitle );
#     my %HASH = %{$select->fetchall_hashref('PK_PUBLISH_IDX')}; 
#     my $str;
#     foreach $publishIDX (sort keys %HASH) {
#         $str .= '<div ID="PUBLISH_'.$publishIDX.'" class="w3-card-2 w3-border w3-round w3-margin-bottom">';
#         $str .= '<header class="w3-container w3-light-grey">';
#         $str .= sprintf '<h5 class="w3-small">%s - Generated on: %s ( <i>v.%d</i >)</h5>', $txTitle, $HASH{$publishIDX}{TX_TIME}, $publishIDX;
#         $str .= '</header>';
#         $str .= '<div class="w3-container w3-white w3-padding">';
#         my $checked = '';
#         if ($HASH{$publishIDX}{IN_SHOW}==1) {$checked = 'checked'}
#         $str .= sprintf '<p><input class="w3-check" type="checkbox" %s onclick="sae_activatePublicView(this, %d);">', $checked, $publishIDX;
#         $str .= sprintf '<label class="w3-margin-left">Public Access</label><span class="w3-margin-left w3-margin-right"><a href="post.html?fileID=%s" target="_blank">View</a></span>',  $HASH{$publishIDX}{TX_FILE};
#         $str .= ' | ';
#         $str .= sprintf '<span class="w3-margin-left"><a href="javascript:void(0);" onclick="sae_deletePublishScore(%d);">Delete</a></span></p>', $publishIDX;
#         $str .= '</div>';
#         $str .= '</div>';
#     }
#     # print $str."\n";
#     return ($str);
# }
#====================================== DELETE ==================================================================
sub _deletePublishedScore(){
    my ($self, $publishIDX) = @_;
    my $SQL = "DELETE FROM TB_PUBLISH WHERE PK_PUBLISH_IDX=?";
    my $delete = $dbi->prepare($SQL);
       $delete->execute( $publishIDX );
    
    $SQL = "DELETE FROM TB_SCORE WHERE FK_PUBLISH_IDX=?";
    my $deleteScore = $dbi->prepare($SQL);
       $deleteScore->execute( $publishIDX );
    return;
}
return (1);

# <div class="w3-card-4">

# <header class="w3-container w3-light-grey">
#   <h3>John Doe</h3>
# </header>

# <div class="w3-container">
#   <p>1 new friend request</p>
#   <hr>
#   <img src="img_avatar3.png" alt="Avatar" class="w3-left w3-circle">
#   <p>President/CEO at Mighty Schools...</p>
# </div>

# <button class="w3-button w3-block w3-dark-grey">+ Connect</button>

# </div>

