package SAE::JSONDB;

use DBI;
use SAE::SDB;

my $dbi = new SAE::Db();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}

sub _insert(){
	my ($self, $tableName, $jsonData) = @_;
	my $bind = 1;
    my %DATA = %$jsonData;
    my @FIELDS = (keys %DATA);
    my $fields = join(",", keys %DATA);
    my $values =  join ",", ("?") x scalar (keys %DATA);
    my $SQL = "INSERT INTO $tableName ( $fields ) VALUES ( $values )";
    # print $SQL;
    my $insert = $dbi->prepare($SQL);
    foreach $field (@FIELDS){
        # print "bind_param($bind, $DATA{$field});";
        $insert->bind_param($bind++, $DATA{$field});
    }
    $insert->execute() || die "Error";
    my $newIDX = $insert->{q{mysql_insertid}};

    return ($newIDX);
}

sub _update(){
	my ($self, $tableName, $jsonData, $where) = @_;
	my $bind = 1;
    my %DATA = %$jsonData;
    my @FIELDS = (keys %DATA);
    my $fields = join("=?,", sort @FIELDS)."=?";
    my $SQL = "UPDATE $tableName SET $fields WHERE $where";
    my $update = $dbi->prepare($SQL);
    foreach $field (sort @FIELDS){
        # print "bind_param($bind, $DATA{$field});";
        $update->bind_param($bind++, $DATA{$field});
    }
    
    $update->execute();
   	# $SQL = join("|", values %DATA);
   	# print $SQL;
   	return;
}

sub _delete(){
	my ($self, $tableName, $where) = @_;
	my $SQL = "DELETE FROM $tableName WHERE $where";
	my $delete = $dbi->prepare( $SQL );
       $delete->execute();
    # print $SQL;
    return;
}
return (1);