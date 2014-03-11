#!/usr/bin/perl -w
use Time::HiRes qw(time);
use POSIX qw(strftime);
$t = time;
$DTG2 = strftime "%Y%m%d_%H%M%S", localtime $t;
$Exp = "06";
$Mask = ".%".$Exp."d";
$OUT = $DTG2 . sprintf $Mask, ($t-int($t))*(10**$Exp); # without rounding
print "$OUT\n";
