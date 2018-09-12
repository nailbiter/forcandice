#!/usr/bin/perl -w

#imports
use strict;
use warnings;
use lib qw(/u/cs/98/9822058/lib/perl5/site_perl/ /u/cs/98/9822058/perl5/lib/perl5/amd64-freebsd-thread-multi/ /u/cs/98/9822058/lib/perl5/ /u/cs/98/9822058/perl5/lib/perl5 /u/cs/98/9822058/lib/perl5/MongoDB/);
#use MongoDB;
use Template;
use POSIX qw( strftime );

#global var's
my $tt = Template->new({
	INCLUDE_PATH => 'templates',
}) || die "$Template::ERROR\n";
my $client     = MongoDB->connect('mongodb://nailbiter:cryuaCSujCio42@ds149672.mlab.com:49672/logistics');

#function declarations
sub querytohash{
	my %data = ();
	my @query  = split(/&/,$ENV{'QUERY_STRING'});
	my $num = 10;
	foreach(@query){
		my @parsed = split(/=/,$_);
		$data{$parsed[0]} = $parsed[1]
	}
	return %data
}
sub candicemain{
	my (%data) = @_;
	#my $collection = $client->ns('logistics.time');
	#my $query_result = $collection->find({},{limit=>15,sort=>{date=>-1}})->result;

	print "Content-Type: text/html\n\n";

	my @list = ();
	#while ( my $next = $query_result->next ) {
	#	my %hash = %$next;
	#	my $formatted = strftime("%Y-%m-%d %H:%M:%S", localtime($hash{'date'}));
	#	push(@list,sprintf("<tr><td>%s</td><td>%s</td></tr>",$formatted,$hash{'category'}));
	#}

	my $vars = {
		CONTENT => join("\n",@list),
	};
	$tt->process('candice.template.html', $vars)|| die $tt->error(), "\n";

	return;
}
sub printsummary{
	my (%data) = @_;
	print "Content-Type: text/html\n\n";

	print "<html> <head>\n";
	print "<meta charset=\"UTF-8\">\n";
	print "<title>唐琳，您好！</title>";
	print "<style>\n";
	printfile('style.css');
	print "</style>\n";
	print "</head>\n";
	print "<body>\n";

	my $filename = 'time.json';
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
