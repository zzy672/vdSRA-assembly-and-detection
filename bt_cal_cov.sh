
bt_out=$1
thread=$2
s_path=/data1/wulab234/zhuyu/WildRice_Project/2021_CYDV_data_0401/Reads/bt_cat_scripts/

## thread
if [ $thread -gt 0 ];then
   echo "thread="$thread
   else
     thread=4
   echo "no thread,thread=8"
fi   

# get uniq mapped results and split file
rm bt_tmp*
awk '!a[$1"\t"$3]++ && NF>5' $bt_out|split -l 1000000 - bt_tmp

# cal_cov
echo "cal coverage!!"
date
n=1
for i in bt_tmp*;do
    if [ $n -le $thread ];then
       echo $i;
       awk -f $s_path/cal_reads_cov.awk "$i" >"$i"_cov &
       let n=$n+1;
    else
       wait
       echo "wait!"
       echo $i;
       awk -f $s_path/cal_reads_cov.awk "$i" >"$i"_cov &
       n=2
    fi
done
date
## merged results
wait
cat bt_tmp*_cov|awk '{a[$1"\t"$2"\t"$3"\t"$4]+=$5}END{for(i in a)print i"\t"a[i]}' >sRNA_reads_cov.txt
rm bt_tmp*_cov

# cal_dis

echo "cal length dis!!"
date
n=1
for i in bt_tmp*;do
    if [ $n -le $thread ];then
       echo $i;
       awk -f $s_path/cal_reads_dis.awk "$i" >"$i"_dis &
       let n=$n+1;
    else
       wait
       echo "wait!"
       echo $i;
       awk -f $s_path/cal_reads_dis.awk "$i" >"$i"_dis &
       n=2
    fi
done
date
## merge 
wait
cat bt_tmp*_dis|awk '{a[$1"\t"$2"\t"$3]+=$4}END{for(i in a)print i"\t"a[i]}' >sRNA_reads_dis.txt
rm bt_tmp*_dis

# cal_nuc
echo "count nuc !!"
date
n=1
for i in bt_tmp*;do
    if [ $n -le $thread ];then
       echo $i;
       awk -f $s_path/count_nucletide.awk "$i" >"$i"_nuc &
       let n=$n+1;
    else
       wait
       echo "wait!"
       echo $i;
       awk -f $s_path/count_nucletide.awk "$i" >"$i"_nuc &
       n=2
    fi
done
date
## merge
wait
cat bt_tmp*_nuc|awk '{a[$1"\t"$2"\t"$3"\t"$4]+=$5}END{for(i in a)print i"\t"a[i]}' >sRNA_reads_nuc.txt
rm bt_tmp*_nuc

# cal_5_nuc
echo "count first nuc !!"
date
n=1
for i in bt_tmp*;do
    if [ $n -le $thread ];then
       echo $i;
       awk -f $s_path/count_first_nucletide.awk "$i" >"$i"_5_nuc &
       let n=$n+1;
    else
       wait
       echo "wait!"
       echo $i;
       awk -f $s_path/count_first_nucletide.awk "$i" >"$i"_5_nuc &
       n=2
    fi
done
date
## merge
wait
cat bt_tmp*_5_nuc|awk '{a[$1"\t"$2"\t"$3"\t"$4]+=$5}END{for(i in a)print i"\t"a[i]}' >sRNA_reads_5_nuc.txt
rm bt_tmp*

