#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Cwd 'abs_path';

sub usage{
	print <<USAGE;
usage:
	perl $0 [options]
authorj
	bianlianle bianlianle\@novelbio.com
description:
	creat cluster Rscript 
USAGE
}
my ($input,$title,$sheet,$sheetName,$yOrder,$output, $help);
GetOptions(
	"i=s" => \$input,
	"t=s" => \$title,
	"s=s" => \$sheet, 
	"sn=s" => \$sheetName, 
	"y=s" => \$yOrder,
	"o=s" => \$output,
	"h|help" => \$help
);

if ($help || (!$input &&!$title &&!$output)) {
	&usage();
	exit 0;
}
my $pngPath;
my $pngPathPre = $output;
$pngPathPre =~ s/\.sh$//;
my ($prefix, $path, $suffix) = fileparse($input,qr{.xlsx});

my $R_line ="#!/bin/sh\n"."finalOutpath=\$1\n"."finalPDFOutpath=\$2\n";
open (OUTPUT,">$output") || die ("Can't open the file $output!");
my $pre="";
#if ($prefix =~ /All/) {
#	$pre="All";
#}
if ($suffix eq "txt") {
	my $fileName = basename($input);
	$sheet = 0;
	$R_line = "Rscript /media/nbfs/nbCloud/public/task/Rscript/Plot/EnrichmentPlot2.R"." ".$input." ".$yOrder." ".$title." \${finalOutpath} \${finalPDFOutpath}\n";
} else {
	my @sheetArray = split(/;/,$sheet);
	my $sheetCounts = scalar(@sheetArray);
	for (my $i = 0; $i<$sheetCounts ; $i++) {
			if ($sheetArray[$i] == 1) {
				if ($prefix =~ /All/) {
					$pre="All";
				}else {
					$pre="Down";
				}
				$input = $path.".tmptxt/".$prefix."\@".$pre.$title."_Result.txt";
			#}elsif ($sheetArray[$i] == 2) {
			#	$input = $path.".tmptxt/".$prefix."\@".$pre."Down".$title."_Result.txt";
			}elsif ($sheetArray[$i] == 4) {
				$input = $path.".tmptxt/".$prefix."\@".$pre."Up".$title."_Result.txt";
			}
		$R_line .= "Rscript /media/nbfs/nbCloud/public/task/Rscript/Plot/EnrichmentPlot2.R"." ".$input." ".$yOrder." ".$title." \${finalOutpath} \${finalPDFOutpath}\n";
	}
}
print OUTPUT $R_line;
close(OUTPUT);
