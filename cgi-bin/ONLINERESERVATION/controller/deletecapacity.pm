#!/usr/bin/perl
package deletecapacity;
#use strict;
use Data::Dumper;
use modules;

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

	my $par = param_accessors->new();
	
	@contId = grep{
		$cgi->param($_) =~ m/checked/;
	} $cgi->param;
	
	map {
		$par->checkedContId($_);
		print STDERR $par->checkedContId;

		my $message = $DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::del_container, [$par->checkedContId] );

	} @contId;

	
	print JSON->new->utf8->encode([$message]);
}

1;
