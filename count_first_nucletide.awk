#! /usr/bin/awk -f
  {
   split($5,m,"");
   if($2=="-"){
     if(m[length(m)]=="A"){a[$2"\t"$3"\t"length($5)"\tT"]++}
     if(m[length(m)]=="T"){a[$2"\t"$3"\t"length($5)"\tA"]++}
     if(m[length(m)]=="C"){a[$2"\t"$3"\t"length($5)"\tG"]++}
     if(m[length(m)]=="G"){a[$2"\t"$3"\t"length($5)"\tC"]++}
   }
   else{
     a[$2"\t"$3"\t"length($5)"\t"m[1]]++
   }
  }END{
   for(n in a)
      print n"\t"a[n]
     }  


