#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
use DBI;
use SV::CONNECT;

my ($dbi, $dbName) = new SV::CONNECT();
 
# $dbName = "saestars_DB";
# $dbi = DBI->connect("dbi:mysql:$dbName:localhost:3306", 'saestars_admin', 'admin@saestars.com') || die ("Cannot Connect");

my $directory = "model";
my @tables = $dbi->tables();
print "\n\n\n". '=' x 100 ."\n";
print "DATABASE = $dbName\n";
print '-' x 100 ."\n";
# print join("\n", @tables)."\n";
# print "\n". '=' x 100 ."\n";
unlink "model\/object\/object.txt";
print "Deleted the model\/object\/object.txt file\n\a";
unless (-e $directory."/object" or mkdir $directory."/object"){
    die "Unable to create $directory/object\n";
}
open (OBJECT, ">>model\/object\/object.txt");
print "Creating a new model\/object\/object.txt file\n";

foreach $table (sort @tables){
        my $fullTableName = $table;
        $fullTableName =~ s/`//sgi;
        my ($database, $tableName) =split(/\./,$fullTableName);
        my $tName = $tableName; 
        $tName =~ s/^TB_//sgi;
        unless(-e $directory or mkdir $directory) {
            die "Unable to create $directory\n";
        }
        open (MODEL, ">model\/".$tName.".pm");
        print "Building Objects for $table\n";
        $SQL = "select * from $table";
        $select = $dbi->prepare($SQL);
        $select->execute();
        @fields = @{$select->{NAME}};
        print OBJECT "\n\n". '=' x 110 ."\n";
        print OBJECT "File: ".$tableName.".pm\n";
        print MODEL &createHeader($table);
        print MODEL &createPrivateVariables(\@fields);
        print MODEL &buildConstructor(\@fields);

        print MODEL "\n#". '-' x 30 ." BUILDING DELETES ". '-' x30 ."\n\n";
        print MODEL &build_deleteRow($table, \@fields);
        print MODEL &build_deleteAll($table, \@fields);
        
        print MODEL "\n#". '-' x 30 ." BUILDING GETTERS ". '-' x30 ."\n\n";
        print MODEL &build_fetchDataById($table , \@fields);
        print MODEL &build_getData();
        print MODEL &build_getData_array();
        print MODEL &build_getData_hash();
        print MODEL &build_getData_hashref($table , \@fields);
        
        # print MODEL &buildGetAllRecordByField($table , \@fields);
        # print MODEL &buildGetAllRecord($table , \@fields);
        # print MODEL &buildGetIdByField($table, \@fields);
        
        print MODEL "\n#". '-' x 30 ." BUILDING SETTERS ". '-' x30 ."\n\n";
        print MODEL &build_setField_json();
        print MODEL &build_setField();
        print MODEL &buildSaveUpdate($table, \@fields);
        print MODEL &build_saveNew($table, \@fields);
        print MODEL "\n\n";
        
        # print MODEL "\n#------- BUILDING SETTERS------\n\n";
        # print MODEL &buildSetter(\@fields);
        # print MODEL &setFieldValue(\@fields);
        # print MODEL &buildGetter(\@fields);
        # print MODEL &buildAddNewRecord($table, \@fields);
        # print MODEL &buildFieldParam();
        # print MODEL &buildConstructorById($table , \@fields);
        # print MODEL "\n#". '-' x 30 ." BUILDING Getting ID by field Name ". '-' x30 ."\n\n";
        # print MODEL "\n#------- BUILDING Getting ID by field Name------\n\n";
        # print MODEL &buildGetIdByField($table, \@fields);
        # print MODEL "\n#------- BUILDING update field by ID------\n\n";
        # print MODEL &updateFieldById($table, \@fields);
        # print MODEL &buildUpdateFieldById($table, \@fields);
        print MODEL "return (1);\n\n";
        close (MODEL);
#     }
}
close (OBJECT);
print "\n\a". '-' x 45 ." Complete " .'-' x45 ."\n\n";
# print "\a---- Completed ----\n\n";
exit;
sub createHeader(){
    my $str;
    my $table = shift;
    my $fullTableName = $table;
    $fullTableName =~ s/`//sgi;
    my ($database, $tableName) =split(/\./,$fullTableName);
    my $tName = $tableName;
    $tName =~ s/^TB_//sgi;
    $str .= "package TB::$tName;\n\n";
    $str .= "use DBI;\n";
    $str .= "use JSON;\n";
    $str .= "use SV::CONNECT;\n\n";
    $str .= "my (\$dbi, \$dbName) = new SV::CONNECT();\n\n";
    return $str;
}
sub createPrivateVariables(){
    my ($fields) = @_;
    my @FIELDS = @{$fields};
    my $str;
    foreach $fields (@FIELDS){
        $str .= "my \$".&stripUnderScore($fields).";\n";
    }
    $str .= "my %DATA = ();\n";
    $str .= "my %FIELDS = ();\n";
    
    $str .= "\n";
    return ($str);
}
sub buildConstructor(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my $tableName = &getTableName($table);
    my $str;
    $str = "sub new{\n";
    $str .= "\t\$className = shift;\n";
    $str .= "\tmy \$self = {};\n";
    $str .= "\tbless(\$self, \$className);\n";
    $str .= "\t\%FIELDS = ();\n";
	$str .= "\t\%DATA= ();\n";
    $str .= "\treturn \$self;\n}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: new()\n";
    print OBJECT "Expected Inputs: None.\n";
    print OBJECT "Expected Output: Defined a new Object\n";
    print OBJECT "Comment: ---\n";
    return ($str);
}

sub build_deleteRow(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my $tableName = &getTableName($table);
    my $str = "sub _deleteRow(){\n";
    $str .= "\tmy \$self   = shift; \n";
    $str .= "\tmy \$where  = shift; \n";
    $str .= "\tmy \$idx    = shift; \n";
    $str .= "\tmy \$SQL = \"DELETE FROM $tableName WHERE \$where=?\";  \n";
    $str .= "\tmy \$delete = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$delete->execute(\$idx);\n";
    $str .= "}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: deleteRow()\n";
    print OBJECT "Inputs: Deleted the record where the fieldName = value Defined.  Syntax: $obj->_deleteRow(fieldName,value).\n";
    print OBJECT "Output: none\n";
    print OBJECT "Comment: none\n";
    return ($str);
}
sub build_deleteAll(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my $tableName = &getTableName($table);
    my $str = "sub _deleteAll(){\n";
    $str .= "\tmy \$self   = shift; \n";
    $str .= "\tmy \$SQL = \"DELETE FROM $tableName\";  \n";
    $str .= "\tmy \$delete = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$delete->execute();\n";
    $str .= "}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: deleteRow()\n";
    print OBJECT "Inputs: Deleted ALL records in the Table. Syntax: $obj->_deleteAll().\n";
    print OBJECT "Output: none\n";
    print OBJECT "Comment: Extremely Dangerous!!! It will clear all Data from the Table.\n";
    return ($str);
}

sub build_fetchDataById(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my $tableName = &getTableName($table);
    my @primaryKey = (grep /^PK_/, @FIELDS);
    my $str = "sub _fetchData(){\n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\tmy \$where  = shift; \n";
    $str .= "\tmy \$idx  = shift; \n";
    # $str .= "\tmy \$SQL = \"SELECT * FROM $tableName WHERE $FIELDS[0]=?\"; \n";
    $str .= "\tmy \$SQL = \"SELECT * FROM $tableName WHERE \$where=?\"; \n";
    $str .= "\tmy \$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$select->execute(\$idx);\n";
    $str .= "\t\%DATA = \%{\$select->fetchrow_hashref()};\n";
    $str .= "\treturn \%DATA;\n}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _fetchData(FieldName, Value)\n";
    print OBJECT "Expected Inputs: Pass in the Record Index.\n";
    print OBJECT "Comment: Once Executed, user can use _getData(TX_FIELDNAME) to return the data from the desired field.\n";
    # print OBJECT "\n";
    return ($str);
}
sub build_getData_hashref(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my $tableName = &getTableName($table);
    # my @primaryKey = (grep /^PK_/, @FIELDS);
    my $str = "sub _getData_hashref(){\n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\tmy \$keys  = shift; \n";
    $str .= "\tmy \$where  = shift; \n";
    $str .= "\tmy \$idx  = shift; \n";
    $str .= "\tmy \$SQL; \n";
    $str .= "\tmy \$select; \n";
    $str .= "\tif (\$where){ \n";
    $str .= "\t\t\$SQL = \"SELECT * FROM $tableName WHERE \$where=?\"; \n";
    $str .= "\t\t\$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t\t\$select->execute(\$idx);\n";
    $str .= "\t} else { \n";
    $str .= "\t\t\$SQL = \"SELECT * FROM $tableName\"; \n";
    $str .= "\t\t\$select = \$dbi->prepare(\$SQL);\n";
    $str .= "\t\t\$select->execute();\n";
    $str .= "\t} \n";
    $str .= "\tmy \%HASH = \%{\$select->fetchall_hashref(\$keys)};\n";
    $str .= "\treturn (\\\%HASH);\n}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _getData_hashref()\n";
    print OBJECT "Inputs: 3 variables.  The first is an array, last two are optional, but if the 2nd variable is used,\n\tyou must have a 3rd variable defined.\n";
    print OBJECT "\tArray is a list of keys to return Hash.  Must put in ['Key1','keys2', 'key3']\n";
    print OBJECT "\tThe last two variable defines the where key and value\n";
    print OBJECT "Output: Returns a HASH with the array as the keys to the hash.\n\tIf array more than 1 key, it will return a nested HASH\n";
    print OBJECT "Comment: none\n";
    return ($str);
}
sub build_getData_hash(){
    my $str = "sub _getData_hash(){ \n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\treturn (\\\%DATA);\n";
    $str .= "} \n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _getData_hash()\n";
    print OBJECT "Inputs: None.\n";
    print OBJECT "Output: Returns a HASH with the fieldNames as the key to the hash. Returns ALL fields\n";
    print OBJECT "Comment: Can only be run after _fetchData().\n";
    return ($str);
}
sub build_getData_array(){
    my $str = "sub _getData_array(){ \n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\tmy \$fields = shift; \n";
    $str .= "\tmy \@RTN = (); \n";
    $str .= "\tforeach \$field (\@\$fields){ \n";
    $str .= "\t\tpush (\@RTN, \$DATA{\$field}); \n";
    $str .= "\t} \n";
    $str .= "\treturn (\\\@RTN); \n";
    # $str .= "\treturn (\$DATA{\$field}); \n";
    $str .= "} \n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _getData_array()\n";
    print OBJECT "Inputs: Pass in an array of fieldNames.  Syntax: my (\$field1, \$field2) =  (['field1','fields']);\n";
    print OBJECT "Output: Returns a list assigned to the Variable Array (\$field1 & \$field2) \n";
    print OBJECT "Comment: Can only be run after _fetchData().\n";
    return ($str);
}
sub build_getData(){
    my $str = "sub _getData(){ \n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\tmy \$fields = shift; \n";
    $str .= "\tif (ref(\$fields) eq 'ARRAY'){ \n";
    $str .= "\t\tmy \@RTN = (); \n";
    $str .= "\t\tforeach \$field (\@\$fields){ \n";
    $str .= "\t\t\tpush (\@RTN, \$DATA{\$field}); \n";
    $str .= "\t\t} \n";
    $str .= "\t\treturn (\\\@RTN); \n";
    $str .= "\t} else { \n";
    $str .= "\t\treturn (\$DATA{\$fields}); \n";
    $str .= "\t} \n";
    # $str .= "\treturn (\$DATA{\$field}); \n";
    $str .= "} \n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _getData()\n";
    print OBJECT "Inputs: Syntax: \$fieldName = \$obj->_getData(fieldName)\n";
    print OBJECT "Output: returns the value of the field requested";
    print OBJECT "Comment: Can only be run after _fetchData().\n";
    print OBJECT "\n";
    return ($str);
}

sub build_setField_json(){
    my $str;
    $str .= "sub _setField_json(){\n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\tmy \$json = shift; \n";
    $str .= "\tmy \%JSON = \%{decode_json(\$json)}; \n";
    $str .= "\tforeach \$field (sort keys \%JSON){ \n";
    $str .= "\t\t\$FIELDS{\$field} = \$JSON{\$field};  \n";
    $str .= "\t} \n";
    $str .= "\treturn; \n";
    $str .= "}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _setField_json()\n";
    print OBJECT "Inputs: pass in the json field/value for the table to be updated.\n";
    print OBJECT "Comment: After _setField_json() complete, run either _saveUpdate(idx) or _saveNew() to commit the fields to the Database.\n";
    # print OBJECT "\n";
    return ($str);  
}
sub build_setField(){
    my $str;
    $str .= "sub _setField(){\n";
    $str .= "\tmy \$self = shift; \n";
    $str .= "\tmy \$field = shift; \n";
    $str .= "\tmy \$value = shift; \n";
    $str .= "\t\$FIELDS{\$field} = \$value; \n";
    $str .= "\treturn (\$value); \n";
    $str .= "}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _setField()\n";
    print OBJECT "Inputs: Field Name and the value for the field to be set. Syntax: \$Object-_setField(TX_FIELD, Values).\n";
    print OBJECT "Comment: After _setField() complete, run either _saveUpdate(idx) or _saveNew() to commit the fields to the Database.\n";
    # print OBJECT "\n";
    return ($str);
}
sub buildSaveUpdate(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    my $tableName = uc(&getTableName($table));
    my $str;
    $str .= "sub _saveUpdate(){\n";
    $str .= "\tmy \$self = shift;\n";
    $str .= "\tmy \$idx = shift;\n";
    $str .= "\tmy \@keys = sort {uc(\$FIELDS{\$a}) cmp uc(\$FIELDS{\$b})} keys \%FIELDS;\n";
    $str .= "\tmy \@setVal;\n";
    $str .= "\tmy \$fields = join(\", \", map{\"\$_=?\"} \@keys); \n";
    $str .= "\tforeach \$key (\@keys){\n";
    $str .= "\t\tpush (\@setVal, \$FIELDS{\$key});\n";
    $str .= "\t}\n";
    $str .= "\tpush (\@setVal, \$idx);\n";
    $str .= "\tmy \$SQL = \"UPDATE $tableName SET \$fields WHERE @primaryKey=?\";\n";
    $str .= "\tmy \$update = \$dbi->prepare(\$SQL);\n";
    $str .= "\t   \$update->execute(\@setVal);\n";
    $str .= "}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _saveUpdate()\n";
    print OBJECT "Inputs: Primary key of the Record to be updated with new values defined by _setField().\n";
    print OBJECT "Comment: After all the _setField(TX_FIELD, Values) are defined, run \$Obj->_saveUpdate(idx)\n\tto update the Record with new values defined by the _setField() Method.\n";
    # print OBJECT "\n";
    return ($str);
}
sub build_saveNew(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^PK_|^TS_C/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    my $column = join(", ",map{$_} @FIELDS);
    my $var = join(", ",map{"\$".&stripUnderScore($_)} @FIELDS);

    $str = "sub _saveNew(){ \n";
    $str .= "\tmy (\$self) = shift; \n";
    $str .= "\tmy \@FIELDS = sort {\$FIELDS{\$a} cmp \$FIELDS{\$b} } keys \%FIELDS; \n";
    $str .= "\tmy \$PARAMS = join(\", \", map{\"?\"} \@FIELDS); \n";
    $str .= "\tmy \@VALUES = ();\n";
    $str .= "\tforeach \$key (\@FIELDS){ \n";
    $str .= "\t\tpush (\@VALUES, \$FIELDS{\$key}); \n";
    $str .= "\t} \n";
    $str .= "\tmy \$SQL = \"INSERT INTO $tableName (\".join(\", \",\@FIELDS).\") values (\".\$PARAMS.\")\"; \n";
    $str .= "\tmy \$insert = \$dbi->prepare(\$SQL); \n";
    $str .= "\t   \$insert->execute(\@VALUES); \n";
    $str .= "\tmy \$newIDX = \$insert->{q{mysql_insertid}}; \n";
    $str .= "\treturn(\$newIDX); \n";
    $str .= "}\n";
    print OBJECT '-' x 110 ."\n";
    print OBJECT "Object: _saveNew()\n";
    print OBJECT "Expected Inputs: None.\n";
    print OBJECT "Comment: After all the _setField(TX_FIELD, Values) are defined, run \$Obj->_saveNew() to create a new Record.\n";
    # print OBJECT "\n";
    # print OBJECT '-' x 110 ."\n\n";
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
sub __template(){
    my ($table, $fields) = @_;
    my @FIELDS = @{$fields};
    my @primaryKey = (grep /^PK_/, @FIELDS);
    @FIELDS = grep ! /^PK_/, @FIELDS;
    my $str;
    my $tableName = &getTableName($table);
    return ($str);
}
