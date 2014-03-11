#!c:/perl/bin/perl.exe -w
$F1 = "C:\\data\\newquips.txt";
open (QUIPS, "$F1") || die "choke on open $F1:$!\n";
@QUIP = (<QUIPS>);
srand;
$number_of_QUIP = $#QUIP;
$random = int (rand ($number_of_QUIP));
$random_QUIP = $QUIP[$random];
#$SigFile = "C:\\sig";
print "$random_QUIP\n";
$SigIn = "c:\\data\\sig.htm";
$SigOut = "c:\\sig.htm";
open (SIGIN,"$SigIn") || die "choke on open $SigIn: $!\n";
open (SIGOUT,">$SigOut") || die "choke on open $SigOut: $!\n";
while (<SIGIN>) {
	print SIGOUT;
}
print SIGOUT "<i>$random_QUIP</i><br>\n";
close SIGIN;
close SIGOUT;
exit (0);
