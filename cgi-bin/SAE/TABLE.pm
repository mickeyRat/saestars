package SAE::TABLE;

use DBI;
use SAE::SDB;
use JSON;
# use SAE::TB_AWARD;

my $dbi = new SAE::Db();

# ******************************************************************************
# 1.11.2024: Created new TABLE transaction (Mostly Setters)

# ******************************************************************************



sub new{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;
}
# ========================= 2022 ===============================================
# ------------------------- GETTERS --------------------------------------------
# sub _getListOfAwards(){
#     my ($self) = @_;
#     my $SQL = "SELECT * FROM TB_AWARD";
#     my $select = $dbi->prepare($SQL);
#        $select->execute();
#     my %HASH = %{$select->fetchall_hashref(['FK_CLASS_IDX','PK_AWARD_IDX'])};
#     return (\%HASH);
# }
# sub _getAwardTitle(){
#     my ($self, $awardIDX) = @_;
#     my $SQL = "SELECT TX_TITLE FROM TB_AWARD WHERE PK_AWARD_IDX=?";
#     my $select = $dbi->prepare($SQL);
#        $select->execute($awardIDX);
#     my ($txTitle) = $select->fetchrow_array();
#     return ($txTitle);
# }
# ------------------------- SETTERS --------------------------------------------
# ====== 2024 ==================================================================

sub _saveAsNew(){
# Save as New will return a table index ID.
   my ($self, $tableName, $data) = @_;
   my $i=1;

   # print $data."\n\n";

   my %DATA = %{decode_json($data)};
   # print join(", ", keys %DATA)."\n\n";
   my @FIELDS = sort {$a cmp $b} keys %DATA;
   my $fields = join(", ", @FIELDS );
   my $value = join ', ', (split(/ /, "? " x (scalar(keys %DATA))));

   # print "\n\n".$value."\n\n";

   my $SQL = "INSERT INTO $tableName ($fields) VALUES ($value)";
   my $insert = $dbi->prepare($SQL);
   # print "\n\n$SQL\n\n";
   foreach $field (@FIELDS){
      $insert->bind_param($i, $DATA{$field});
      # print "$i ".$DATA{$field}."\n";
      $i++;
   } 
   $insert->execute();
   my $newIDX = $insert->{q{mysql_insertid}};

   # print "\n\nNew Index # = $newIDX\n\n";
   return ($newIDX);
}

sub _save(){
   my ($self, $tableName, $data, $condition) = @_;
   my %CONDITION = %{decode_json($condition)};
   my %DATA      = %{decode_json($data)};
   my @FIELDS    = sort {$a cmp $b} keys %DATA;
   my @WHERE     = sort {$a cmp $b} keys %CONDITION;
   my $i         = 1;

   # my %DATA = %{decode_json($data)};
   # print join(", ", keys %DATA)."\n\n";
   # print join(", ", keys %WHERE)."\n\n";
   my $fieldToUpdate = join ("=?, ", @FIELDS)."=?";
   my $condition = join ("=? AND ", @WHERE)."=?";

   # print "\n\n$fieldToUpdate\n\n";
   # print "\n\n$condition\n\n";
   my $SQL    = "UPDATE $tableName  SET $fieldToUpdate WHERE ($condition)";
   my $update = $dbi->prepare($SQL);
   foreach $field (@FIELDS){
      $update->bind_param($i, $DATA{$field});
      # print "\$insert->bind_param($i, $DATA{$field});\n";
      $i++;
   }
   foreach $condition (@WHERE ) {
      $update->bind_param($i, $CONDITION{$condition});
      # print "\$insert->bind_param($i, $CONDITION{$condition});\n";
      $i++;
   }

   $update->execute();
   # print "\n\n$SQL\n\n";
}



# ------------------------- DELETES --------------------------------------------
# ------------------------- OTHERS  --------------------------------------------

return (1);