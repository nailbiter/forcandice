#!/usr/bin/perl -w

#imports
use strict;
use warnings;
use lib qw(/u/cs/98/9822058/lib/perl5/site_perl/ /u/cs/98/9822058/perl5/lib/perl5/amd64-freebsd-thread-multi/ /u/cs/98/9822058/perl5/lib/perl5);
use JSON;
use Template;
use POSIX qw( strftime );
#use DateTime;
use Date::Manip;

#global var's
my $tt = Template->new({
	INCLUDE_PATH => 'templates',
}) || die "$Template::ERROR\n";

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

	my $apikey = "XuEWY1VwkY9YbKuVmmyueeIvX_HA_28y";
	my $uri = sprintf("https://api.mlab.com/api/1/databases/logistics/collections/time?apiKey=%s",$apikey);
	my $json_text= `curl -L "$uri"`;
	my $json = JSON->new;
	my @data = @{$json->decode($json_text)};
	my @list = ();

	print "Content-Type: text/html\n\n";

	for my $href (@data){
		my %hash = %$href;
		my %date = %{$hash{'date'}};
		my $dateline = $date{'$date'};
		$dateline =~ /([0-9]*)-([0-9]*)-([0-9]*)T([0-9]*):([0-9]*):([0-9]*).([0-9]*)Z/;
		#2018-09-12T13:00:00.001Z
		my $year = $1;
		my $month = $2;
		my $day = $3;
		my $hours = $4 + 9;
		my $minutes = $5;
		my $seconds = $6;

		$day = $day + ($hours/24);
		$hours = $hours % 24;

		my $res = sprintf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>",
			sprintf("%04d-%02d-%02d",$year,$month,$day),
			sprintf("%02d:%02d",$hours,$minutes),
			$hash{'category'});
		push(@list,$res);
	}
	@list = sort(@list);
	@list = @list[-15..-1];
	@list = reverse(@list);

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
