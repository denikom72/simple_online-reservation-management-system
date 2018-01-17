#!/usr/bin/perl -w
package db_manager;
use DBI;
#use strict;

#my $di = sub {
#	my( $act, $myargv ) = ( shift, shift );	
#	my $inst = $act->new($myargv);
#	
#	$inst->printres();
#};
#
#my %params = (
#
#		#examples of paramRefList
#		#[ "%title%", "%title%", "%title%", "%title%", "%title%", 5, 0]
#		$action => $di
#);	

####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};
	bless $self, $type;
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
		
		#$param1 = ['mu', 'mu'];
		#print Dumper $param;
		#print " ---------___> : ".$query;
	
		#my $sql = sprintf("%s <> %s", $query, $param);print $sql;
		
		my $q = $dbh->prepare($query);
		
		#IF EMPTY [] THEN EXECUTE WORKS FINE		
		if( $#{$param} > -1  ){ 
			#print "\n  ############ query with params \n";
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
