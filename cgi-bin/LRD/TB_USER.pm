package LRD::TB_USER;

use DBI;
use LRD::CONNECT;

my ($dbi, $dbName) = new LRD::Connect();

my $PkUserIdx;
my $FkGroupIdx;
my $TxFirstName;
my $TxLastName;
my $InUserType;
my $FkDefaultEventIdx;
my $TxPassword;
my $BoReset;
my $TxLogin;
my $TxEmail;
my $InLimit;
my $TxYear;
my $BoVolAlum;
my $BoStuAlum;
my $BoExtra;
my $BoDaily;
my $BoWeekly;
my $TsCreate;
my %DATA = ();
my %FIELDS = ();

sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	%FIELDS = ();
	%DATA= ();
	return $self;
}

#------------------------------ BUILDING DELETES ------------------------------

sub _deleteRow(){
	my $self   = shift; 
	my $where  = shift; 
	my $idx    = shift; 
	my $SQL = "DELETE FROM TB_USER WHERE $where=?";  
	my $delete = $dbi->prepare($SQL);
	   $delete->execute($idx);
}
sub _deleteAll(){
	my $self   = shift; 
	my $SQL = "DELETE FROM TB_USER";  
	my $delete = $dbi->prepare($SQL);
	   $delete->execute();
}

#------------------------------ BUILDING GETTERS ------------------------------

sub _fetchData(){
	my $self = shift; 
	my $where  = shift; 
	my $idx  = shift; 
	my $SQL = "SELECT * FROM TB_USER WHERE $where=?"; 
	my $select = $dbi->prepare($SQL);
	   $select->execute($idx);
	%DATA = %{$select->fetchrow_hashref()};
	return $self;
}
sub _getData(){ 
	my $self = shift; 
	my $fields = shift; 
	if (ref($fields) eq 'ARRAY'){ 
		my @RTN = (); 
		foreach $field (@$fields){ 
			push (@RTN, $DATA{$field}); 
		} 
		return (\@RTN); 
	} else { 
		return ($DATA{$fields}); 
	} 
} 
sub _getData_array(){ 
	my $self = shift; 
	my $fields = shift; 
	my @RTN = (); 
	foreach $field (@$fields){ 
		push (@RTN, $DATA{$field}); 
	} 
	return (\@RTN); 
} 
sub _getData_hash(){ 
	my $self = shift; 
	return (\%DATA);
} 
sub _getData_hashref(){
	my $self = shift; 
	my $keys  = shift; 
	my $where  = shift; 
	my $idx  = shift; 
	my $SQL; 
	my $select; 
	if ($where){ 
		$SQL = "SELECT * FROM TB_USER WHERE $where=?"; 
		$select = $dbi->prepare($SQL);
		$select->execute($idx);
	} else { 
		$SQL = "SELECT * FROM TB_USER"; 
		$select = $dbi->prepare($SQL);
		$select->execute();
	} 
	my %HASH = %{$select->fetchall_hashref($keys)};
	return (\%HASH);
}

#------------------------------ BUILDING SETTERS ------------------------------

sub _setField(){
	my $self = shift; 
	my $field = shift; 
	my $value = shift; 
	$FIELDS{$field} = $value; 
	return ($value); 
}
sub _saveUpdate(){
	my $self = shift;
	my $idx = shift;
	my @keys = sort {uc($FIELDS{$a}) cmp uc($FIELDS{$b})} keys %FIELDS;
	my @setVal;
	my $fields = join(", ", map{"$_=?"} @keys); 
	foreach $key (@keys){
		push (@setVal, $FIELDS{$key});
	}
	push (@setVal, $idx);
	my $SQL = "UPDATE TB_PWD SET $fields WHERE PK_PWD_IDX=?";
	my $update = $dbi->prepare($SQL);
	   $update->execute(@setVal);
}
sub _saveNew(){ 
	my ($self) = shift; 
	my @FIELDS = sort {$FIELDS{$a} cmp $FIELDS{$b} } keys %FIELDS; 
	my $PARAMS = join(", ", map{"?"} @FIELDS); 
	foreach $key (@FIELDS){ 
		push (@VALUES, $FIELDS{$key}); 
	} 
	my $SQL = "INSERT INTO TB_USER (".join(", ",@FIELDS).") values (".$PARAMS.")"; 
	my $insert = $dbi->prepare($SQL); 
	   $insert->execute(@VALUES); 
	my $newIDX = $insert->{q{mysql_insertid}}; 
	return($newIDX); 
}


return (1);

