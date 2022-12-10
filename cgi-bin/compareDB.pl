#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";

use DBI;

my $db1 = $ARGV[0];
my $db2 = $ARGV[1];

# $dbName = "saestars_DEV2";
my $dbi1 = DBI->connect("dbi:mysql:$db1:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect to $db1");
my $dbi2 = DBI->connect("dbi:mysql:$db2:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect tp $db2");

my @tab1 = $dbi1->tables();
my @tab2 = $dbi2->tables();
my %DB1;
my %DB2;


foreach $table (@tables) {
    my $fullTableName = $table;
       $fullTableName =~ s/`//sgi;
    my ($database, $tableName) =split(/\./,$fullTableName);
    print "$database\t$tableName\n";
    my $sth = $dbi1->prepare("DESCRIBE $table");
       $sth->execute();    
    while (my $row = $sth->fetchrow_hashref()) {
        my $type = $row->{'Type'}; ## 'int(12)' for example.
        my $field = $row->{'Field'}; ## 'int(12)' for example.
        $DB1{$tableName}{$field}=$type;
        print "-\t$field\t$type\n";
    }
}

foreach $table (@tab1) {
    my $fullTableName = $table;
       $fullTableName =~ s/`//sgi;
    my ($database, $tableName) =split(/\./,$fullTableName);
    # print "$database\t$tableName\n";
    my $sth = $dbi1->prepare("DESCRIBE $table");
       $sth->execute();    
    while (my $row = $sth->fetchrow_hashref()) {
        my $type = $row->{'Type'}; ## 'int(12)' for example.
        my $field = $row->{'Field'}; ## 'int(12)' for example.
        $DB1{$tableName}{$field}=$type;
        # print "-\t$field\t$type\n";
    }
}
print "-"x80;
print "\n";
foreach $table (@tab2) {
    my $fullTableName = $table;
       $fullTableName =~ s/`//sgi;
    my ($database, $tableName) =split(/\./,$fullTableName);
    # print "$database\t$tableName\n";
    my $sth = $dbi2->prepare("DESCRIBE $table");
       $sth->execute();    
    while (my $row = $sth->fetchrow_hashref()) {
        my $type = $row->{'Type'}; ## 'int(12)' for example.
        my $field = $row->{'Field'}; ## 'int(12)' for example.
        $DB2{$tableName}{$field}=$type;
        # print "-\t$field\t$type\n";
    }
}

&compareDB(\%DB1, \%DB2);
exit;
sub compareDB(){
    my $DB1 = shift;
    my $DB2 = shift;
    my %DEV_DB = %{$DB1};
    my %PROD_DB = %{$DB2};
    foreach $table (keys %DEV_DB){
        foreach $field (keys %{$DEV_DB{$table}}) {
            if (!exists $PROD_DB{$table}{$field}){
                print "$table\t$field\t$DEV_DB{$table}{$field}\n";
            }
        }
    }
}