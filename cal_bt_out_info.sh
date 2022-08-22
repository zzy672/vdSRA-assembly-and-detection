# 

#usage: sh cal_bt_out_info.sh ref.fasta bowtie.out sample *.fq.gz 8 no q 
# sRNA reads count and make plot for uniq file or raw file

ref=$1 # /data1/wulab234/zhuyu/WildRice_Project/all_virus_ref/novel_known_virus/ref
bt_out=$2 # 143_bowtie_2mis.out
sample=$3 # 143
input=$4 # ../Raw.143A_clean.fq.gz

t=$5 # 8 threads
adapter=$6 # adapter seq /no
format=$7 ## f ## fasta/fastq


### ref_length.txt
if [ -f "${ref%/*}"/ref_length.txt ];then
########################################################################################################################################
   s_path=/data1/wulab234/zhuyu/WildRice_Project/2021_CYDV_data_0401/Reads/bt_cat_scripts

   mkdir "$sample"_bt_summary
   cd "$sample"_bt_summary

   # cutadapt
   if [ "$adapter" != "no" ];then
      /home/opt/biosoft/miniconda2/envs/qiime2-2019.7/bin/cutadapt -a "$adapter" -m 18 -M 28 -j 10 -o "$sample"_18_28nt.fastq.gz "$input"
      zcat "$sample"_18_28nt.fastq.gz|cut -f1 -d" " >"$sample"_18_28nt.fastq
      input="$sample"_18_28nt.fastq
   else
     /home/opt/biosoft/miniconda2/envs/qiime2-2019.7/bin/cutadapt -m 18 -M 28 -j 10 -o "$sample"_18_28nt.fastq.gz "$input"
      gunzip "$sample"_18_28nt.fastq.gz
      input="$sample"_18_28nt.fastq
   fi
   # bowtie
   bowtie -a -v 2 "$ref" -p 10 -"$format" "$input" "$bt_out" 2>bt_align.log

   # cal coverage and count NUC
   sh c/bt_cal_cov.sh "$bt_out" "$t"

   awk -f "$s_path"/cal_virus_covered_length.awk sRNA_reads_cov.txt >sRNA_reads_covered_length.txt

   awk '{a[$2]+=$5}END{for(i in a)print i"\t"a[i]}' sRNA_reads_cov.txt >sRNA_reads_cov_total_cov.txt
   awk '{a[$2]+=$4}END{for(i in a)print i"\t"a[i]}' sRNA_reads_dis.txt >sRNA_reads_counts.txt

   # merge
   echo -e "ref_id\tlength\treads_counts\tdepth\tcovered_length\tcoverage" >bt_out_info.txt
   awk 'NR==FNR{a[$1]=$2}NR>FNR{if($1 in a)print $0"\t"a[$1];else print $0"\t0"}' sRNA_reads_counts.txt "${ref%/*}"/ref_length.txt |\
   awk 'NR==FNR{a[$1]=$2}NR>FNR{if($1 in a)print $0"\t"a[$1]/$2;else print $0"\t0"}' sRNA_reads_cov_total_cov.txt -|\
   awk 'NR==FNR{a[$1]=$2}NR>FNR{if($1 in a)print $0"\t"a[$1]"\t"a[$1]/$2;else print $0"\t0\t0"}' sRNA_reads_covered_length.txt -|sort -rgk6 >>bt_out_info.txt
   
   # plot
   mkdir plot 
   cd plot

   awk 'NR>1 && $6>0.6{print $1}' ../bt_out_info.txt|while read i;do

      awk -v k="$i" '$2==k{print $1$5"\t"$3"\t"$4 > k"_covered.txt"}' ../sRNA_reads_cov.txt
      grep -w "$i" "${ref%/*}"/ref_length.txt|awk '{for(a=1;a<=$2;a++)print $1"\t"a}'>depth
      awk 'NR==FNR{a[$2]=$0}NR>FNR{if($2 in a);else {print "+0""\t"$2"\t""18"}}' "$i"_covered.txt depth >>"$i"_covered.txt
 
      awk -v k="$i" '$2==k{print $3"\t"$1$4}' ../sRNA_reads_dis.txt >"$i"_reads_dis.txt

      /opt/biosoft/R-4.0.2/bin/Rscript "$s_path"/sRNA_depth_withPara.R "$i"_covered.txt "$sample"
      /opt/biosoft/R-4.0.2/bin/Rscript "$s_path"/sRNA_dis_plot_withPara_cc.R "$i"_reads_dis.txt "$sample"
      ##

      ## mononucletide cal



   done

   cd ..
   cd ..
######################################################################################################################
else 
  echo "no ref_length.txt!!"
fi




