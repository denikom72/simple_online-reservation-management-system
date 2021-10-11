#!/usr/bin/perl
package service;
#use strict;
use Data::Dumper;
#use lib '/var/www/cgi-bin/CONFIGURATORCMS';
use modules;
 

####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}

sub printres {
	my $self = shift;
	my $args = shift;
	print "Content-type: text/json\n\n";
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::sel_all, [] );
	
	###PARSE A LIST OF LIST TO A LIST OF HASH-REFERENCES###
	
	my ( $max, $ind, @listOfHash ) = ( 0, 0 );
	
	
	map {
		if( $max < $_->[2] ){
			$max = $_->[2];
		}	
	} @{$res_set};
	
	
	for my $i( 0..$max ){
		my ( %tmphash, @tmplist );
		my $ind = 0;
		map {
			if($_->[2] == $i && $_->[2] != 0){
	
				$tmphash{ $res_set->[$i-1]->[1] }->[$ind] = [ $_->[1], "EUR:".$_->[3] ];
	
				#@tmplist = ( @tmplist, $_->[1] );
				$ind++;
			}
		} @{$res_set};
	
		my @keysnumb = keys %tmphash;
		
		#print Dumper \%tmphash if $#keysnumb > -1; 

		#Avoid adding empty hashes to the @listOfHash
		push( @listOfHash, \%tmphash ) if $#keysnumb > -1;
	}
	
	print JSON->new->utf8->encode(\@listOfHash);
}

1;
