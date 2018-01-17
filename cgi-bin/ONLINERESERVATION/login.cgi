#!/usr/bin/perl
package login;
#use strict;
use modules;

#DECLARE VARs
my( $elem, $tocateg, $new_cat, $cgi, $user, $pw, $password, $id );

$cgi = CGI->new;

$user = $cgi->param('user');
$pw = $cgi->param('pw');
$password = $cgi->param('password');
$id = $cgi->param('id');

####ACCESSORS
our $accIns_el = sub {
                # make plausibility check with sprintf ...
                my ( $ref, $sql ) = ( shift, shift );
                $ins_post = $sql if $sql ne "";
                $ins_post;
};

####CONSTRUCTOR 
sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}

my $id_sess = $DB_DATA::inst -> sel_query( $DB_DATA::dbh, $DB_DATA::check_credentials, [ $user, $pw ] );

( $myrand = `date +%T` ) =~ s/\n//i;

my @listOfList = ();
if( $id_sess->[0][0] =~ /\s*.*1\s*.*/i && $id_sess->[0][1] == 0 ){
	$DB_DATA::inst -> db_crud ( $DB_DATA::dbh, $DB_DATA::set_random, [ 1, $myrand ] );
	@listOfList = ( $id, $myrand );
}

print "Content-type: application/json\n\n";
print JSON->new->utf8->encode(\@listOfList);
