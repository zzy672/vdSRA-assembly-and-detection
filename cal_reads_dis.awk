#! /usr/bin/awk -f
 {
   x[$2"\t"$3"\t"length($5)]++
  }END{
   for(n in x)
      print n"\t"x[n]
      }
