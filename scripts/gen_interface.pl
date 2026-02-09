#!/usr/bin/perl
use strict;
use warnings;

my $input_file=$ARGV[0];
#chomp($input_file);
print "$input_file\n";
my $output_intf_file="interface_ex.sv";

open(FH,"<",$input_file)  or die $!;

print("File $input_file opened successfully!\n");
open(FOUT,">",$output_intf_file);

while(<FH>) {
	if($_=~ /module.*\#.parameter (.*)/) {
		print FOUT "interface intf #(parameter $1 (input logic clk);\n";
	}
	elsif($_ =~ /.*input\s+(\w+),/) {
		print FOUT "logic	$1;\n";
	}
	elsif($_ =~ /.*output\s+(\w+.*),/) {
		print FOUT "logic $1;\n";
	}
	elsif($_ =~ /.*output\s+(\w+.*)\/\//) {
		print FOUT "logic $1;\n";
	}
	elsif($_ =~ /\);/) {
		print FOUT "endinterface\n";
		exit;
	}
	
}
close(FH);
close(FOUT);
		
				
