#!/usr/bin/perl
use cPanelUserConfig;
use FindBin;
use lib "$FindBin::Bin/";
# use DBI;
# use SV::CONNECT;

my $sDir = "SV";
my @files = glob ($sDir .'/*.pm');
# print "\nFile Listing!\n";
# print '-' x 80 ."\n";
# print "$sDir\n";
# print join("\n", @files);
# print "\n" x 3;


unlink "SV\/object\/service.txt";
# print "Deleted the SV\/object\/service.txt file\n\a";
unless (-e $directory."$sDir/object" or mkdir $directory."$sDir/object"){
    die "Unable to create $sDir/object\n";
}
open (SV, ">>SV\/object\/service.txt");
# print "Creating a new model\/object\/service.txt file\n";
foreach $file (@files){
    print SV '=' x 80 ."\n";
    print SV "File: $file \n";
    
    open (FILE, $file);
    while (<FILE>){
        if ($_ =~ m/^\#begin/){
            print SV '-' x 80 ."\n";
        }
        if ($_ =~ m/^\#\*/){
            $_ =~ s/\#\*\s//sgi;
            print SV $_;
        }
        
    }
    print SV "\n";
}
close (SV);