#!/usr/bin/perl

use strict;

while (my $line = <>) {
	my $list_ref = csv_data($line);

	print join("\t",@$list_ref) . "\n";
}

################################################################

sub csv_data {
	my ($i,$str,$quote,@ret);
	my $data = shift();

	my $str_len = length($data);

	# Loop through the string character by character
	while ($i < $str_len) {
		my $char = substr($data,$i,1);

		if ($char eq '"') {
			$quote++;
		}

		# If the character is a comma, and we're not in the middle of a string
		if ($char eq "," && $quote % 2 == 0) {
			push(@ret,process_string($str));
			$str = "";
		# Just tack the character on the end until we get to that comma
		} else {
			$str .= $char;
		}
		$i++;
	}

	# Add whatever's left of the string (there is no trailing ,)
	push(@ret,process_string($str));
	return \@ret;
}

sub process_string {
	my $str = shift();

	# Remove leading and trailing quotes from the line
	$str =~ s/^"(.*)"$/$1/g;
	# CSV makes quotes "" so return it as intended
	$str =~ s/""/"/g;
	# If the last char is a \n nuke it
	$str =~ s/\n$//g;

	return $str;
}
