#!/usr/bin/perl
package deletecapacity;
#use strict;
use Data::Dumper;
use modules;
 
####DB-LOGIN-DATA
#$modules::DB_DATA::table = "es";

####ACCESSORS
our $accIns_el = sub {
                # make plausibility check with sprintf ...
                my ( $ref, $sql ) = ( shift, shift );
                $ins_post = $sql if $sql ne "";
                $ins_post;
};

####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}

####DB-METHODS###

sub printres {
	my $self = shift;
	my $args = shift;
	print "Content-type: text/json\n\n";
	
	my $cgi = CGI->new;

	# USE PERSON-QUANTITY FIELD FOR CONTAINER-ID FIELD	
	my $container_id = $cgi->param('persQuantity');

		
	my $message = $DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::del_container, [$container_id] );
	
	print JSON->new->utf8->encode([$message]);
}

1;
