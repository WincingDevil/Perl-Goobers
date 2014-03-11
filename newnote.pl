#!perl -w
use vcfw;
GenDTG();

for ($X=0;$X<@ARGV;$X++) {
	$Msg .= $ARGV[$X] . " ";
}
$Msg = trim($Msg);
print "$DTG $Msg<\n";
open (NOTE,">>C:\\data\\note.pad") || die "Choke on open NotePad: $!\n";
print NOTE "$DTG $Msg<\n";
close NOTE;
