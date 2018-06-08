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
sub querytohash{
	my %data = ();
	my @query  = split(/&/,$ENV{'QUERY_STRING'});
	my $num = 10;
	foreach(@query){
		#print "$_<br>\n";
		my @parsed = split(/=/,$_);
		#if($parsed[0]=="num"){
		#	$num = $parsed[1];
		#}
		$data{$parsed[0]} = $parsed[1]
	}
	return %data
}
sub printtable{
	print "<table align=\"center\">\n";
	my @list = @_;
	for my $var (@list) {
		print "<tr>";
		for my $item (@$var){
			print "<td>$item</td>"
		}
		print "</tr>\n";
	}
	print "</table>\n";
}
sub candicemain{
	my (%data) = @_;
	print "Content-Type: text/html\n\n";
	print "<html> <head>\n";
	print "<meta charset=\"UTF-8\">\n";
	print "<title>Hello, world!</title>";
	print "<style>\n";
	printfile('style.css');
	print "</style>\n";
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
	my $num = 15;
	if(exists $data{num}){
		$num = $data{num}
	}

	my @splitted = ();
	for( my $a = 0; $a < $num && $#arr - $a >=0 ; $a = $a + 1 ) {
		$splitted[$a] = [split(/:([^:]+)$/, $arr[$#arr - $a])];
	}
	printtable(@splitted);

	printfile('end.html');
}
sub printsummary{
	my (%data) = @_;
	print "Content-Type: text/html\n\n";
	print "<html> <head>\n";
	print "<meta charset=\"UTF-8\">\n";
	print "<title>Hello, world!</title>";
	print "<style>\n";
	printfile('style.css');
	print "</style>\n";
	print "</head>\n";
	print "<body>\n";
	#printfile('start.html');

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

	my @splitted = ();
	my $unit = $data{unit};
	if($unit ne "day"){
		return;
	}
	#print "$unit<br>\n";
	for( my $a = 0; $a < 15 && $#arr - $a >=0 ; $a = $a + 1 ) {
		$splitted[$a] = [split(/:([^:]+)$/, $arr[$#arr - $a])];
	}
	printtable(@splitted);
}

#main
my %data = querytohash();
if(exists $data{unit}){
	printsummary(%data)
}else{
	candicemain(%data);
}
