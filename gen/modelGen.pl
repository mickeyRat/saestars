#!/usr/bin/perl
use cPanelUserConfig;
use DBI;


$dbName = "saestars_DEV2";
$dbi = DBI->connect("dbi:mysql:$dbName:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect");

my $directory = "model";
my @tables = $dbi->tables();
print "\n".join("\n", @tables)."\n\n";
foreach $table (sort @tables){
#     if ($table =~ m/TB_TEAM/sgi){

        my $fullTableName = $table;
        $fullTableName =~ s/`//sgi;
        my ($database, $tableName) =split(/\./,$fullTableName);
        unless(-e $directory or mkdir $directory) {
            die "Unable to create $directory\n";
        }
        open (MODEL, ">model\/".$tableName.".pm");
        # print "$table\n";
        $SQL = "select * from $table";
        $select = $dbi->prepare($SQL);
        $select->execute();
        @fields = @{$select->{NAME}};
        # print &buildAddNewRecord($table, \@fields);
#         exit;
        print MODEL &createHeader($table);
        print MODEL &createPrivateVariables(\@fields);
        print MODEL &buildConstructor(\@fields);
        print MODEL &buildAddNewRecord($table, \@fields);
        print MODEL &buildConstructorById($table , \@fields);
        print MODEL &buildGetAllRecordByField($table , \@fields);
        print MODEL &buildGetAllRecord($table , \@fields);
        print MODEL &buildDeleteRecordById($table, \@fields);
        print MODEL "\n#------- BUILDING GETTERS------\n\n";
        print MODEL &buildDeleteRecordByField($table, \@fields);
        print MODEL &buildGetter(\@fields);
        print MODEL "\n#------- BUILDING SETTERS------\n\n";
        print MODEL &buildSetter(\@fields);
        print MODEL "\n\n";
        print MODEL "\n#------- BUILDING Getting ID by field Name------\n\n";
        print MODEL &buildGetIdByField($table, \@fields);
        print MODEL "\n#------- BUILDING update field by ID------\n\n";
        print MODEL &updateFieldById($table, \@fields);
        print MODEL &buildUpdateFieldById($table, \@fields);
#         print MODEL &buildGetAllRecord_hashref($table, \@fields);
#         print MODEL &buildGetAllRecordByField_hashref($table, \@fields);
        print MODEL "return (1);\n\n";
        close (MODEL);
#     }
}
print "\a---- Completed ----\n\n";
exit;
sub buildGetAllRecord(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
#     foreach $field (@FIELDS) {
    $str .= "sub getAllRecord(){\n";
    $str .= "\tmy (\$self) = shift;\n";
    $str .= "\tmy (\$value) = shift;\n\n";
    $str .= "\tmy \$SQL = \"SELECT ".join (", ", @FIELDS)." FROM $tableName\";\n";
    $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$select->execute();\n";
    $str .= "\tmy \%HASH = \%{\$select->fetchall_hashref(['@primaryKey'])};\n";
    $str .= "\treturn(\\\%HASH);\n}\n\n";
#     }
    return ($str);
}
sub buildGetAllRecord_hashref(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
#     foreach $field (@FIELDS) {
    $str .= "sub getAll_hashref(){\n";
    $str .= "\tmy (\$self) = shift;\n";
    $str .= "\tmy (\$key) = shift;\n\n";
    $str .= "\tmy \$SQL = \"SELECT ".join (", ", @FIELDS)." FROM $tableName\";\n";
    $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$select->execute();\n";
    $str .= "\tmy \%HASH = \%{\$select->fetchall_hashref(['\$key'])};\n";
    $str .= "\treturn(\\\%HASH);\n}\n\n";
#     }
    return ($str);
}

sub buildUpdateFieldById(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    foreach $field (@FIELDS) {
        $str .= "sub update".&stripUnderScore($field)."_ById(){\n";
        $str .= "\tmy (\$self) = shift;\n";
        $str .= "\tmy (\$value) = shift;\n";
        $str .= "\tmy (\$idx) = shift;\n\n";
        $str .= "\tmy \$SQL = \"UPDATE $tableName SET $field=? where @primaryKey = ?\";\n";
        $str .= "\tmy \$update = \$dbi->prepare(\$SQL);\n";
        $str .= "\t   \$update->execute(\$value, \$idx);\n";
        $str .= "\treturn ();\n}\n\n";
    }
    return ($str);
}
sub buildDeleteRecordById(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    $str .= "sub deleteRecordById(){\n";
    $str .= "\tmy (\$self) = shift;\n";
    $str .= "\tmy (\$idx) = shift;\n\n";
    $str .= "\tmy \$SQL = \"DELETE FROM $tableName where @primaryKey=?\";\n";
    $str .= "\tmy \$delete = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$delete->execute(\$idx);\n";
    $str .= "\treturn();\n}\n\n";
    return ($str);
}

sub buildDeleteRecordByField(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    foreach $field (@FIELDS) {
        $str .= "sub deleteRecordBy_".&stripUnderScore($field)."(){\n";
        $str .= "\tmy (\$self) = shift;\n";
        $str .= "\tmy (\$idx) = shift;\n\n";
        $str .= "\tmy \$SQL = \"DELETE FROM $tableName where $field=?\";\n";
        $str .= "\tmy \$delete = \$dbi->prepare(\$SQL);\n";
        $str .= "\t   \$delete->execute(\$idx);\n";
        $str .= "\treturn();\n}\n\n";
    }
    return ($str);
}
sub buildGetAllRecordByField(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    foreach $field (@FIELDS) {
    $str .= "sub getAllRecordBy_".&stripUnderScore($field)."(){\n";
    $str .= "\tmy (\$self) = shift;\n";
    $str .= "\tmy (\$value) = shift;\n\n";
    $str .= "\tmy \$SQL = \"SELECT ".join (", ", @FIELDS)." FROM $tableName WHERE $field=?\";\n";
    $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$select->execute(\$value);\n";
    $str .= "\tmy \%HASH = \%{\$select->fetchall_hashref(['@primaryKey'])};\n";
    $str .= "\treturn(\\\%HASH);\n}\n\n";
    }
    return ($str);
}
sub buildGetAllRecordByField_hashref(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    foreach $field (@FIELDS) {
    $str .= "sub getAllBy".&stripUnderScore($field)."_hashref(){\n";
    $str .= "\tmy (\$self) = shift;\n";
#     $str .= "\tmy (\$field) = shift;\n";
    $str .= "\tmy (\$value) = shift;\n";
    $str .= "\tmy (\$key) = shift;\n\n";
    $str .= "\tmy \$SQL = \"SELECT ".join (", ", @FIELDS)." FROM $tableName WHERE $field=?\";\n";
    $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$select->execute(\$value);\n";
    $str .= "\tmy \%HASH = \%{\$select->fetchall_hashref(['\$key'])};\n";
    $str .= "\treturn(\\\%HASH);\n}\n\n";
    }
    return ($str);
}

sub buildAddNewRecord(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^PK_|^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    my $column = join(", ",map{$_} @FIELDS);
    my $var = join(", ",map{"\$".&stripUnderScore($_)} @FIELDS);
#     $str .= "\n\n";
#     return($str);
#     $str = "\n".join(",", map{"?"} @FIELDS);
    $str .= "sub addNewRecord(){\n";
    $str .= "\tmy (\$self) = shift;\n\n";
    $str .= "\tmy \$SQL = \"INSERT INTO $tableName (".$column.") values (".join(", ", map{"?"} @FIELDS).")\";\n";
    $str .= "\tmy \$insert = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$insert->execute($var);\n";
    $str .= "\tmy \$newIDX = \$insert->{q{mysql_insertid}};\n";
    $str .= "\treturn(\$newIDX);\n\n";
    $str .= "}\n";

#     $str = "\n".join(", ", @FLDS);

    return ($str);
}
sub createHeader(){
    my $str;
    my $table = shift;
    my $fullTableName = $table;
    $fullTableName =~ s/`//sgi;
    my ($database, $tableName) =split(/\./,$fullTableName);
    $str .= "package SAE::$tableName;\n\n";
    $str .= "use DBI;\n";
    $str .= "use SAE::SDB;\n\n";
    $str .= "my \$dbi = new SAE::Db();\n\n";
    return $str;
}
sub createPrivateVariables(){
    my ($fields) = @_;
    my @FIELDS = @{$fields};
    my $str;
    foreach $fields (@FIELDS){
        $str .= "my \$".&stripUnderScore($fields).";\n";
    }
    $str .= "\n";
    return ($str);
}
sub buildConstructor(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my $str;
    $str = "sub new\n{\n";
    $str .= "\t\$className = shift;\n";
    $str .= "\tmy \$self = {};\n";
    $str .= "\tbless(\$self, \$className);\n";
    $str .= "\treturn \$self;\n\n;}\n";
    return ($str);
}
sub buildConstructorById(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @SELF;
    my $str;
    foreach $field (@FIELDS) {
        push(@SELF, "\$".&stripUnderScore($field)." \t\t = \t\$HASH{$field};");
    }
#     my $fullTableName = $table;
#     $fullTableName =~ s/`//sgi;
#     my ($database, $tableName) =split(/\./,$fullTableName);
#     my $methodName = &stripUnderScore($tableName);
#     print "\n$fullTableName\n";
    my $tableName = &getTableName($table);
    $str = "sub get".$methodName."RecordById(){\n";
    $str .= "\tmy (\$self) = shift;\n";
    $str .= "\tmy (\$idx) = shift;\n";
#     $str .= "\t\$className = shift;\n";
    $str .= "\t\$SQL = \"SELECT ".join(", ", @FIELDS)."\n\t\tFROM $tableName\n\t\tWHERE $FIELDS[0]=?\";\n";
    $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t\$select->execute(\$idx);\n";
    $str .= "\t\%HASH = \%{\$select->fetchrow_hashref()};\n";
#     $str .= "\t\$self = {\n\t\t ";
    $str .= "\t ".join("\n\t", @SELF);
#     $str .= "\n\t};\n";
#     $str .= "\tbless(\$self, \$className);\n";
    $str .= "\n\treturn \$self;\n\n;}\n";
    return ($str);
}
sub updateFieldById(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^PK_/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    foreach $field (@FIELDS) {
        $str .= "sub update".&stripUnderScore($field)."_byId(){\n";
        $str .= "\tmy (\$self) = shift;\n";
        $str .= "\tmy (\$value) = shift;\n";
        $str .= "\tmy (\$idx) = shift;\n\n";
        $str .= "\tmy \$SQL = \"UPDATE $tableName set $field=? where @primaryKey=?\";\n";
        $str .= "\tmy \$update = \$dbi->prepare(\$SQL);\n";
        $str .= "\t   \$update->execute(\$value, \$idx);\n";
        $str .= "\treturn(\$value);\n";
        $str .= "\n}\n";
    }


    return ($str);
}

sub __template(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^PK_/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);



    return ($str);
}

sub buildGetIdByField(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^PK_|^TS_/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    foreach $field (@FIELDS){
        $str .= "sub getIdBy_".&stripUnderScore($field)."(){\n";
        $str .= "\tmy (\$self) = shift;\n";
        $str .= "\tmy (\$value) = shift;\n\n";

        $str .= "\t\$SQL = \"SELECT @primaryKey from $tableName where $field=?\";\n";
        $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
        $str .= "\t   \$select->execute(\$value);\n";
        $str .= "\tmy \$idx = \$select->fetchrow_array();\n\n";
        $str .= "\treturn (\$idx);\n";
        $str .= "}\n";
    }
    return ($str);

}
sub buildGetter(){
    my ($fields) = @_;
    my @FIELDS = @{$fields};
    my $str;
    foreach $field (@FIELDS){
        $fieldName = &stripUnderScore($field);
        $str .= "sub get".$fieldName."(){\n";
        $str .= "\tmy ( \$self ) = shift;\n";
        $str .= "\treturn (\$".&stripUnderScore($field).");\n";
        $str .= "}\n\n";
    }
    return ($str);
}
sub buildSetter(){
    my ($fields) = @_;
    my @FIELDS = @{$fields};
    my $str;
    foreach $field (@FIELDS){
        $fieldName = &stripUnderScore($field);
        $str .= "sub set".$fieldName."(){\n";
        $str .= "\tmy ( \$self ) = shift;\n";
        $str .= "\tmy ( \$value ) = shift;\n";
        $str .= "\t\$".&stripUnderScore($field)." = \$value;\n";
        $str .= "\treturn (\$field);\n";
        $str .= "}\n\n";
    }
    return ($str);
}
sub getTableName(){
    my $fullTableName = shift;
    $fullTableName =~ s/`//sgi;
    my ($database, $tableName) =split(/\./,$fullTableName);
    return ($tableName);
}
sub getTeamStatus(){
    my( $self ) = shift;
    return ( $self->{_boStatus} );
}
sub stripUnderScore(){
    my ($field) = shift;
    my $str = '';
    @segment = split("_", $field);
        foreach $seg (@segment){
            $str .= ucfirst(lc($seg));
        }
   return ($str);
}
