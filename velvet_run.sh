#!/usr/bin/sh
#usage: sh velvet_run.sh 143A_assembled 17 *fa
outfile=$1
kmer=$2
fqfile=$3

mkdir $outfile

velveth $outfile $kmer -short -fasta $fqfile
velvetg $outfile -read_trkg yes
oases $outfile
