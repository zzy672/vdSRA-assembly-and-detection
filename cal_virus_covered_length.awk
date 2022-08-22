#! /usr/bin/awk -f
 {if(!a[$2"\t"$3]++)s[$2]++}END{for(i in s)print i"\t"s[i]}
