#!perl -w
use vcfw;
GenDTG();
$Drive = "m:\\";
$f1 = $DTG2;
$f1 = $Drive.$f1.".wipe";
print "Ouput file = $f1\n";
open (OUT,">$f1") || die "choke on open $f1:$!";
#$Max = 5 822 000 000;
#Max = 100000;
$Step=1024*1024;
$L = localtime();
print "$L Start Gen\n";
srand;
for ($x = 0;$x<$Step;$x++) {
  $r = int(rand(255));
  $Chr = chr($r);
  $Chr = "A" if ($Chr eq "\x0A");
  $Chr = "D" if ($Chr eq "\x0D");
  $String .= $Chr;
}
#print "$String";
$L = localtime();
print "$L End Gen\n";
$OutMsg = " Wipe File written $L. |\n";
while (1) {
  $L1 = localtime();
  if ($L1 ne $L) {
    $L = $L1;
    $TotLen1=Commify($TotLen);
    $OutMsg = " Wipe File written $L. | $TotLen1\n";
	print $OutMsg;
}

  print OUT $String  || die "Choke on print $f1:$!";
  $TotLen += $Step;

}
close OUT;
system "dir  $f1";
