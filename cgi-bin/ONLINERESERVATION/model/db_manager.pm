#!/usr/bin/perl -w
package db_manager;
use DBI;
#use strict;


####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};
	bless $self, $type;

	#TODO define accessor-mutator or getter/setter for it. Functional-Parad. it's important for stable code	
	( $self->{"db_name"}, $self->{"user"}, $self->{"pw"} ) = ( shift, shift, shift );
        $self;
}

####METHODS####


sub con {
	my ( $ref, $db_name, $user, $pw ) = ( shift, shift, shift, shift );
	DBI->connect("DBI:mysql:database=$db_name", $user, $pw) or die ("Connection refused\n");
}

sub sel_query {
		my ( $ref, $dbh, $query, $param ) = ( shift, shift, shift, shift );
		
		
		my $q = $dbh->prepare($query);
		
		if( $#{$param} > -1  ){ 
			$q->execute(@{$param}) or die $DBI::errstr;
		} else {
			$q->execute() or die $DBI::errstr;
		}

		
		$compl_rows = $q -> fetchall_arrayref();
		$q->finish();
		
		$compl_rows;
}

sub db_crud {
                my ( $ref, $dbh, $ins_el, $sql_paramHash ) = ( shift, shift, shift, shift );
                
		my $query = $dbh->prepare($ins_el);
                
		$query->execute(@{$sql_paramHash}) or die $DBI::errstr;
                $query->finish();
}

1;
