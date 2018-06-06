#!/usr/local/bin/perl -w

#imports
use strict;
use warnings;
use lib qw(/u/cs/98/9822058/lib/perl5/site_perl/);
use JSON;

#function declarations
sub printfile{
	my $fn = $_[0];
	 
	open(FH, '<', $fn) or die $!;
	 
	while(<FH>){
	   print $_;
	}
	 
	close(FH);
}

#main
print "Content-Type: text/html\n\n";
print "<html> <head>\n";
print "<meta charset=\"UTF-8\">\n";
print "<title>Hello, world!</title>";
print "<style>";
printfile('style.css');
print "</style>";
print "</head>\n";
print "<body>\n";
printfile('start.html');

my $filename = '/u/cs/98/9822058/assistantBotFiles/assistantBotFiles/time.json';
my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};
my $json = JSON->new;
my $data = $json->decode($json_text);
my @arr = @{$data->{arr}};

my @query  = split(/&/,$ENV{'QUERY_STRING'});
my $num = 10;
foreach(@query){
	#print "$_<br>\n";
	my @parsed = split(/=/,$_);
	if($parsed[0]=="num"){
		$num = $parsed[1];
	}
}

print "<table align=\"center\">";
for( $a = 0; $a < $num && $#arr - $a >=0 ; $a = $a + 1 ) {
	my $line = $arr[$#arr - $a];
	my @dat = split(/:([^:]+)$/, $line);
	print "<tr><td>$dat[0]</td><td>$dat[1]</td></tr>\n";
}
print "</table>";

printfile('end.html');

