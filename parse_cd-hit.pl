#!/usr/bin/env perl
use strict;
use warnings;


if(@ARGV+0 < 1 || $ARGV[0] eq "help")
{
    print STDERR "Convert a cd-hit-est .clstr file to a table\n
Usage: perl parse_cd-hit.pl <file.clstr>\n
The Output is a tab separated file called <file.clstr>.tab\n";
	die "no input file specified";
}


my$clsFile = shift(@ARGV);


my%clstr;

open(OUT,'>',$clsFile.".tab") or die $!;
print OUT join("\t", qw(Cluster_ID Sequence_ID Sequence_length Identity Exemplar)),"\n";

open(CLSTR,'<',$clsFile) or die $!;
$/="\n>";
while(<CLSTR>)
{
    chomp;
    my@obj=split(/\n/,$_);
    my$name=shift(@obj);
    (my$id)=$name=~/Cluster\s+(\d+)/;
    my$headID;
    foreach my$line (@obj)
    {
	#loop through sequences in cluster to extract length and IDs
	my($num,$len,$seqID,$aln)=$line=~/(\d+)\s+(\d+\w+),\s+>(.+)\.{3}\s+(.+)/;

	if($aln eq '*'){
	    print OUT join("\t","Cluster_".$id,$seqID,$len,"NA","TRUE"),"\n";
	}
	else
	{
	    print OUT join("\t","Cluster_".$id,$seqID,$len,$aln,"FALSE"),"\n";
	}
    }
}
$/="\n";
close CLSTR or die $!;
close OUT or die $!;
