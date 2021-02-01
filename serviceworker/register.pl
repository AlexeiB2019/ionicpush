#!/usr/bin/perl 
use warnings;
use strict;
 
use DBI;
require '../Environment.pm';


my %params = get_params();
my $token = $params{'token'};

print("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Cache-Control, Content-Type\n");
print("Access-Control-Allow-Origin: *\n");
print("Cache-Control: no-cache\n");
print("Content-Type: text/html\n\n");
print("token = $token\n");

store_token($token);


sub get_params {
    my $text = '';
    my $request_method = $ENV{'REQUEST_METHOD'};
    if ( $request_method eq "GET" ) {
        $text = $ENV{'QUERY_STRING'};
    } else {    # default to POST
        read( STDIN, $text, $ENV{'CONTENT_LENGTH'} );
    }

    my @value_pairs = split( /&/, $text );

    my %params = ();
    foreach my $pair (@value_pairs) {
        my ( $key, $value ) = split( /=/, $pair );
        $value =~ tr/+/ /;
        $value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;
        # $value =~ tr/A-Za-z0-9\ \,\.\:\/\@\-\!\"\_\{\}//dc;
        $value =~ s/^\s+//g;
        $value =~ s/\s+$//g;

        $params{$key} = $value;    # store the key in the results hash
    }
    return %params;
}


sub store_token {
    my $token = shift;

    my ($db_name, $db_user, $db_pass) = Environment::database();

    my $dbh = DBI->connect( "dbi:Pg:dbname=$db_name;host=localhost;port=5432;",
        $db_user, $db_pass, { RaiseError => 0, PrintError => 1 } )
        || warn "Cannot connect to database: $DBI::errstr";

    my $query = "INSERT INTO push (token)
                 VALUES (?)
                ";
    my $sth = $dbh->prepare($query);
    my $rv = $sth->execute($token);
    if (!defined $rv) {
        print("Database error: " . $dbh->errstr . "\n");
    }
    $sth->finish();
}
