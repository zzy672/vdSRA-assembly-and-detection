#! /usr/bin/awk -f
  {
   split($5,x,"");
   for(i in x)
   {a[$2"\t"$3"\t"length($5)"\t"x[i]]++}
  }END{
   for(n in a)
     {split(n,m,"\t")
      if(m[1]=="-"){        
        if(m[4]=="A"){print n"\t"a[m[1]"\t"m[2]"\t"m[3]"\t""T"]}
	if(m[4]=="T"){print n"\t"a[m[1]"\t"m[2]"\t"m[3]"\t""A"]}
	if(m[4]=="C"){print n"\t"a[m[1]"\t"m[2]"\t"m[3]"\t""G"]}
	if(m[4]=="G"){print n"\t"a[m[1]"\t"m[2]"\t"m[3]"\t""C"]}
      }
      else
        print n"\t"a[n]
     }  
 }

