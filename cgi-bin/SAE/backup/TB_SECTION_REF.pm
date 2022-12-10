package SAE::TB_SECTION_REF

use DBI
use SAE::SDB

my $dbi = new SAE::Db();

my $PkSectionIdx;
my $InSectionRef;
my $TxSection;
my $InWeight;

sub new
{
	$className = shift;
	my $self = {};
	bless($self, $className);
	return $self;

;}
sub getTbSectionRefRecordById(){
	my ($self) = shift;
	my ($idx) = shift;
	$SQL = "SELECT PK_SECTION_IDX, IN_SECTION_REF, TX_SECTION, IN_WEIGHT
		FROM `saestars_DB`.`TB_SECTION_REF`
		WHERE PK_SECTION_IDX=?";
	my $select = $dbi->prepare($SQL);
	$select->execute($idx);
	%HASH = %{$select->fetchrow_hashref()};
	$self = {
		 PkSectionIdx 		 => 	$HASH{PK_SECTION_IDX}
		,InSectionRef 		 => 	$HASH{IN_SECTION_REF}
		,TxSection 		 => 	$HASH{TX_SECTION}
		,InWeight 		 => 	$HASH{IN_WEIGHT}
	};
	return $self;

;}

#------- BUILDING GETTERS------

sub getPkSectionIdx(){
	my ( $self ) = shift;
	return ($self->{PkSectionIdx});
}

sub getInSectionRef(){
	my ( $self ) = shift;
	return ($self->{InSectionRef});
}

sub getTxSection(){
	my ( $self ) = shift;
	return ($self->{TxSection});
}

sub getInWeight(){
	my ( $self ) = shift;
	return ($self->{InWeight});
}


#------- BUILDING SETTERS------

sub setPkSectionIdx(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{PkSectionIdx} = $value;
	return ($self->{PkSectionIdx});
}

sub setInSectionRef(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InSectionRef} = $value;
	return ($self->{InSectionRef});
}

sub setTxSection(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{TxSection} = $value;
	return ($self->{TxSection});
}

sub setInWeight(){
	my ( $self ) = shift;
	my ( $value ) = shift;
	$self->{InWeight} = $value;
	return ($self->{InWeight});
}



return (1);

