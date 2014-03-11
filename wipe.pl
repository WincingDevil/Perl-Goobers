#!perl -w
use vcfw;
if (!$ARGV[0]) {
	die "Format: WIPE [drive:]\n";
}
$Drive = $ARGV[0];
chomp($Drive);
GenDTG()
$f1 = $Drive."\"$DTG2.".wipe";
print "Ouput file = $f1\n";
open (OUT,">$f1") || die "choke on open $f1:$!";
$OutMsg = "Wipe File Written $DTG2;
$NewLen = length($OutMsg);
while (1) {
  $Now = $DTG2;
  	  
  
  
  f ($L1 ne $L) {
    $L = $L1;
    $OutMsg = " Wipe File written $L. |";
    $NewLen = length($OutMsg);
  }
  print OUT $OutMsg;
  $TotLen += $NewLen;
}
close OUT;
system "dir  $f1";
