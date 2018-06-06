#!/usr/local/bin/perl
# hello.pl - My first CGI program

use strict;
use warnings;

use lib qw(/u/cs/98/9822058/lib/perl5/site_perl/);
use JSON;

print "Content-Type: text/html\n\n";
# Note there is a newline between 
# this header and Data

# Simple HTML code follows

print "<html> <head>\n";
print "<title>Hello, world!</title>";
print "</head>\n";
print "<body>\n";
print "<h1>Hello, world!</h1>\n";

my $filename = '/u/cs/98/9822058/assistantBotFiles/assistantBotFiles/time.json';

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);

for ( @{$data->{arr}} ) {
   print $_->{name}."\n";
}

print "</body> </html>\n";
