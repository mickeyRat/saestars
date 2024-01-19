#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;


my $url = "https://www.wunderground.com/weather/us/tx/colleyville/76034";
my $content = get($url);
if ($content =~ /<span class="wu-value wu-value-to">(\d+)<\/span>/){
	my $temperature = $1;
	print "The temperature = $temperature\n";
} else {
	print "\n $content \n";
}
