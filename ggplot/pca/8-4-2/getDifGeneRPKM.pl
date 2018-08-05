#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Cwd 'abs_path';
use File::Copy;
use Statistics::Descriptive;

sub usage{
	print <<USAGE;
usage:
	perl $0 [options]
author
	bianlianle bianlianle\@novelbio.com
description:
	get diff gene RPKM 
USAGE
}
my ($gene,$rpkm,$isFilterByPre,$percentage,$isFilterBySD,$sd,$isFilterByAbs,$number,$absvalue,$isFilterByDiffVal,$diffVal, $output, $help);
GetOptions(
	"g=s" => \$gene,
	"r:s" => \$rpkm,
	"ifp=s" => \$isFilterByPre,
	"pre=s" => \$percentage,
	"ifs=s" => \$isFilterBySD,
	"sd=s" => \$sd,
	"ifa=s" => \$isFilterByAbs,
	"num=s" => \$number,
	"abv=s" => \$absvalue,
	"ifd=s" => \$isFilterByDiffVal,
	"dv=s" => \$diffVal,
	"o=s" => \$output,
	"h|help" => \$help
);

if ($help || (!$gene &&!$output)) {
	&usage();
	exit 0;
}



=pod
my $rpkm_flag = 'false';
if ($rpkm) {
	$rpkm_flag = 'true';
} else {
	$rpkm = $gene;
}
=cut
my $FilterByPreFlag = 'true';
my $FilterSDFlag = 'true';
my $FilterAbsFlag = 'true';
my $DiffValFlag = 'true';
my ($sampleName,%geneHash) = &read_gene("$gene");

my @sampleName = split(/\t/,$sampleName);
my %sampleName;
for (my $x=1; $x<scalar(@sampleName) ; $x++) {
$sampleName{$sampleName[$x]} = "";
}
	open (OUTPUT,">$output") || die ("Can't open the file $output!");
	open (RPKM,"<$rpkm") || die ("Can't open the file $rpkm !");
	my @fa_id_array;
	my $rpkm_list = "";
	my @sampleRow;
		while(<RPKM>){
			my $line = $_;
			$line =~ s/\s$//;
			$line =~ s/\n$//;
			$rpkm_list = "";
			@fa_id_array = split(/\t/,$line);
			
		my $newTitle = "GeneID";
			if ($. == 1) {
				for (my $y = 0; $y<scalar(@fa_id_array); $y++) {
					if (exists $sampleName{$fa_id_array[$y]}) {
						
						push @sampleRow, $y;
						$newTitle .= "\t".$fa_id_array[$y];
						#print "$y\n";
					}
				}
				print OUTPUT "$newTitle\n";
			}  else {
				for (my $i = 0 ; $i < scalar(@sampleRow); $i++) {
					$rpkm_list .= "\t".$fa_id_array[$sampleRow[$i]];
				}
				if (exists $geneHash{$fa_id_array[0]}) {
					if ($isFilterByPre  eq "true") {
						$FilterByPreFlag = &getFilterPercentage($rpkm_list,$percentage);
					}
					if ($isFilterBySD  eq "true") {
						$FilterSDFlag = &getFilterSDFlag($rpkm_list,$sd);
					}
					if ($isFilterByAbs  eq "true") {
						$FilterAbsFlag = &getFilterAbsFlag($rpkm_list,$number,$absvalue);
					}
					if ($isFilterByDiffVal eq "true") {
						$DiffValFlag = &getDiffValFlag($rpkm_list,$diffVal);
					}
					if (($FilterByPreFlag eq "false")||($FilterSDFlag eq "false")||($FilterAbsFlag eq "false")||($DiffValFlag eq "false")) {
						next ;
					}

					print OUTPUT "$fa_id_array[0]\t".$rpkm_list."\n";
					$FilterByPreFlag = 'true';
					$FilterSDFlag = 'true';
					$FilterAbsFlag = 'true';
					$DiffValFlag = 'true';
				}
			}
			
		}
	close(RPKM);
	close(OUTPUT);


#=cut
#*****************sub function***************************
sub read_gene{
	my $in_file = shift;
	my $sampleName;
	my %genehash;
	my @id_array;
	open (IN,"<$in_file") || die ("Can't open the file $in_file !");
	while(<IN>){
		if ($. == 1) {
			chomp($_);
			$sampleName = $_;
			$sampleName =~ s/\s$//;
		} else{
			my $line = $_;
			$line =~ s/\s$//;
			@id_array = split(/\s/,$line);
			$genehash{$id_array[0]} = "";
		}
	}
	close(IN);
	return ($sampleName,%genehash);
}

#*********************************************************

sub getFilterPercentage{
	my $input = shift;
	my $percentage = shift;
	chomp($input);
	$input =~ s/\s+$//;
	$input =~ s/^\s+//;
	my @rpkm_array = split("\t",$input);
	my $nullNum = 0;
	my $sampleNum = scalar(@rpkm_array);
	for (my $i = 0; $i<$sampleNum;$i++) {
		if ($rpkm_array[$i]==0) {
			$nullNum += 1;
		}
	}
	
	if (($nullNum/$sampleNum)<=$percentage) {
		return "true";
	} else {
		return "false";
	}
}

sub getFilterSDFlag{
	my $input = shift;
	my $ssd = shift;
	chomp($input);
	$input =~ s/\s+$//;
	$input =~ s/^\s+//;
	my @rpkm_array = split("\t",$input);
	my $stat = Statistics::Descriptive::Full->new();
	$stat->add_data(\@rpkm_array);
	my $standard_deviation=$stat->standard_deviation();
	if ($standard_deviation>=$ssd) {
		return "true";
	}else{
		return "false";
	}
}

sub getFilterAbsFlag{
	my $input = shift;
	my $number= shift;
	my $value = shift;
	chomp($input);
	$input =~ s/\s+$//;
	$input =~ s/^\s+//;
	my @rpkm_array = split("\t",$input);
	my $greaterNum = 0;
	my $sampleNum = scalar(@rpkm_array);
	for (my $i = 0; $i<$sampleNum ;$i++) {
		if ($rpkm_array[$i]>=$value) {
			$greaterNum += 1;
		}
	}
	if ($greaterNum>$number) {
		return "true";
	}else{
		return "false";
	}
}

sub getDiffValFlag{
	my $input = shift;
	my $diff_value = shift;
	chomp($input);
	$input =~ s/\s+$//;
	$input =~ s/^\s+//;
	my @rpkm_array = split("\t",$input);
	my $stat = Statistics::Descriptive::Full->new();
	$stat->add_data(\@rpkm_array);
	my $min=$stat->min();
	my $max=$stat->max();
	if (($max-$min)>=$diff_value) {
		return "true";
	} else {
		return "false";
	}
}
