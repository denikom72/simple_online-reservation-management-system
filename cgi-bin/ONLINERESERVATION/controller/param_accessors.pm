#!/usr/bin/perl
package param_accessors;
#use strict;
use Data::Dumper;


####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}


# ACCESSORS 
sub persQuantity {
	my ( $self, $persQuantity ) = @_;
	
	if ( @_ == 2 ) 
	{
		$self->{persQuantity} = $persQuantity;
		
		return 1;
	}
	
	$self->{persQuantity};
}


sub checkedContId {
	my ( $self, $contId ) = @_;
	
	if ( @_ == 2 ) 
	{
		$self->{contId} = [ split "_", $contId ] -> [1];
		
		return 1;
	}
	
	$self->{contId};
}


sub date {
	my ( $self, $date ) = @_;
	
	if ( @_ == 2 ) 
	{
		( $self->{date} = $date ) =~ s/\//-/gi;
	        
		my @strtD = split /\-/, $self->{date};
	        
	        if ( length $strtD[1] == 1 ){
	                $strtD[1] = "0".$strtD[1];
	        }
	        
	        if ( length $strtD[0] == 1 ){
	                $strtD[0] = "0".$strtD[0];
	        }       
	                
	        $self->{date} = $strtD[2]."-".$strtD[0]."-".$strtD[1];
	
		
		return 1;
	}
	
	$self->{date};
}


sub time {
	my ( $self, $time ) = @_;
	
	if ( @_ == 2 ) 
	{
		( $self->{time} = $time ) =~ s/(am|pm)/:00/gi;
	
		my @T = split /\:/, $self->{time};
		
		if ( length $T[1] == 1 ){
			$T[1] = "0".$T[1];
		}
	
		if ( length $T[0] == 1 ){
			$T[0] = "0".$T[0];
		}

		$self->{time} = $T[0] . ":" . $T[1] . ":" . $T[2];
		
		return 1;
	}
	
	$self->{time};
}

sub startDate{

	my ( $self, $startDate ) = @_;
	
	if ( @_ == 2 ) 
	{
		$self->date( $startDate );

		$self->{"startDate"} = $self->date();

		return 1;
	}
	
	$self->{startDate};
}

sub endDate{

	my ( $self, $endDate ) = @_;
	
	if ( @_ == 2 ) 
	{
		$self->date( $endDate );
		$self->{"endDate"} = $self->date();

		return 1;
	}
	
	$self->{endDate};
}


sub startTime{

	my ( $self, $startTime ) = @_;
	
	if ( @_ == 2 ) 
	{
		$self->time( $startTime );

		$self->{"startTime"} = $self->time();
		return 1;
	}
	
	$self->{startTime};
}



sub endTime{

	my ( $self, $endTime ) = @_;
	
	if ( @_ == 2 ) 
	{
		$self->time( $endTime );

		$self->{"endTime"} = $self->time();

		return 1;
	}
	
	$self->{endTime};
}


sub start{

	my ( $self, $startDate, $startTime ) = @_;
		
	if ( @_ == 3 ) 
	{
		( $self->{start} = $startDate." ".$startTime ) =~ s/(^\s*|\s*$)//gi;

		return 1;
	} 
	
	$self->{start};
}



sub end {

	my ( $self, $endDate, $endTime ) = @_;
	
	if ( @_ == 3 ) 
	{
		( $self->{end} = $endDate." ".$endTime ) =~ s/(^\s*|\s*$)//gi;

		return 1;
	}
	
	$self->{end};
}

1;
