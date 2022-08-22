###################################################
## key steps for vdSAR assembly and visualization##
###################################################


## de novo assembly to get RTIV contigs 
 sh velvet_run.sh 17 sRNA_reads.fa

## blastx against nr database to get viral contigs
 blastx -db nr -query contigs.fa -outfmt 6 -out contigs_to_nr.blastx

#### further assembly and experiments to get full genome

## get vsiRNAs of contigs of RTIV
 bowtie-build RTIV_sRNA_contigs.fasta RTIV_sRNA_contigs.fasta
 bowtie -a -v 0 -x RTIV_sRNA_contigs.fasta -p 10 -f sRNA_reads.fa sRNA_contigs_reads.bt0mis.out

 awk '{a[$2"\t"$3"\t"$4+1"\t"length($5)]++}END{for(i in a)print i"\t"a[i]}' sRNA_contigs_reads.bt0mis.out >sRNA_contigs_bt.out

 awk '{print $2"\t"$4"\t"$5"\t"$6>$1"_sRNA_reads.txt"}' sRNA_reads_to_contig.out

## map RTIV contigs to RTIV genome 
 blastn -db RTIV_seq.fasta -query contigs.fa -outfmt 6 -out contigs_to_RTIV.blastn

 sort -grk9 contigs_to_RTIV.blastn|\
 awk '{print "contig"NR"\t"$0}'|\
 awk '{if(($9-$8)*($11-$10)>0)a="+";else a="-"}
     {if($10>$11)s=$11;else s=$10}
     {print a"\t"s"\t"$9-$8+1"\t1"}' >sRNA_contigs_plot.txt

### make plot of reads mapping to contigs by using sRNA_reads_mappping_plot.R
 
## get vsiRNA of RTIV and visualize in R

 sh cal_bt_out_info.sh RTIV_ref.fasta bowtie.out sample *.fq.gz 8 no q