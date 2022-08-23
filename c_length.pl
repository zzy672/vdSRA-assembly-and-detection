#!perl
%hash=();
while (<>) {
     if (/>(.*)/) {
        $c=$1;
        $hash{$c}=0;

     }
else {
     chomp($a=$_);
     $n=length($a);
     $hash{$c}+=$n;
}
}
foreach $chr (keys (%hash)) {
        print "$chr\t$hash{$chr}\n";
}
