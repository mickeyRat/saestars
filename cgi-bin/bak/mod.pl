#!/usr/bin/perl
use File::Copy;

my @files = glob("*.pl");
# print join ('\n',@files);
# print "\n\n";

foreach $file (@files){
    print "\n$file\n\n";
    copy($file, 'bak/'.$file) or die "copy failed: $!";
    # rename($file, $file".'.bak');
    open(IN, '<' . 'bak/'.$file) or die $!;
    open(OUT, '>' . $file) or die $!;
    while(<IN>)
    {
        $_ =~ s/cPanelUserConfig/cPanelUserConfig\;\nuse FindBin\;\nuse lib \"\$FindBin\:\:Bin\/\"/g;
        print OUT $_;
    }
    close(IN);
    close(OUT);
}