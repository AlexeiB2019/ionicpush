#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;
use DBI;
require '../Environment.pm';

if (@ARGV != 2) {
	print "Push notification, use: ./send.pl 'title' 'message'\n";
	exit(0);
}


my $token = get_token();
my $title = $ARGV[0];
my $body  = $ARGV[1];

my $response = push_notification($token, $title, $body);
# print Dumper( $response );
print $response->content;
print "\n";


sub push_notification {
	my $token = shift;
	my $title = shift;
	my $body = shift;

	my $lwp = LWP::UserAgent->new;

	my $url = 'https://fcm.googleapis.com/fcm/send';

	my $content =
	qq({
	  "notification": {
	    "title": "$title",
	    "body": "$body"
	  },
	  "to": "$token"
	}
	);

	my $content_length = length $content;

	my $req = HTTP::Request->new( 'POST', $url );
	$req->header( 'Cache-Control'  => 'no-cache',
	              'Content-Type'   => 'application/json',
	              'Content-Length' => $content_length,
	              'Authorization'  => 'key=AAAAzQtAniI:APA91bH7HdM4fvi0EchftKOgf8LtGNLJU0Sk-n9dN9nqoe7bBQ7C-Ew3BtqtGIwakMhtHs80paUJuAKm-VTDq4c2qBIWra83MW6cMZCbYKtVS-WF5OSjCrtPgdw5n7aGIyowuC1CDyDk'
	            );
	$req->content($content);

	my $response = $lwp->request( $req );

	$response
}


sub get_token {
    my ($db_name, $db_user, $db_pass) = Environment::database();

    my $dbh = DBI->connect( "dbi:Pg:dbname=$db_name;host=localhost;port=5432;",
        $db_user, $db_pass, { RaiseError => 0, PrintError => 1 } )
        || warn "Cannot connect to database: $DBI::errstr";

    my $query = "SELECT token
                 FROM push
                 ORDER BY id DESC
                 LIMIT 1
                ";
    my $sth = $dbh->prepare($query);
    my $rv = $sth->execute();
    if (!defined $rv) {
        Utils::db_error_exit($dbh->errstr);
    }
    my $token = 0;
    while (my @array = $sth->fetchrow_array()) {
        $token = $array[0];
    }
    $sth->finish();

    $token
}
