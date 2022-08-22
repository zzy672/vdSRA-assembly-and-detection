#! /usr/bin/awk -f
  {
   for(i=1;i<=length($5);i++)
     x[$2"\t"$3"\t"$4+i"\t"length($5)]++
  }END{
   for(n in x)
      print n"\t"x[n]
      }
