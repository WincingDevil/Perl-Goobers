#!perl -w
use Time::HiRes qw(time);
use POSIX qw(strftime);
use vcfw;
if (!$ARGV[0]) {
	die "Format: WIPE [drive:]\n";
}
$Drive = $ARGV[0];
chomp($Drive);
GenDTG();
$f1 = $Drive."\\".$DTG2.".wipe";
print "Ouput file = $f1\n";#die;
open (OUT,">$f1") || die "choke on open $f1:$!";
$Loup=0;
$dev=$ino=$mode=$nlink=$uid=$gid=$rdev=$size=$atime=$mtime=$ctime=$blksize=$blocks="";
#for ($Loup=0;$Loup<100;) {
$Result = 1;
while ($Result == 1) {
	my $t = time;
	my $date = strftime "%Y%m%d_%H%M%S", localtime $t;
	$date .= sprintf ".%03d", ($t-int($t))*1000; # without rounding
	#print OUT "Wiping... $Loup: $date\n" || die "Write failed on $f1: $!\n";
	$Result = (print OUT "Wiping... $Loup: $date\n");
	$Loup++;
		if (($Loup/10000) == int($Loup/10000)) {
		($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks)=stat($f1);
		$Size = Commify($size);
		print "($Result) Wiping... $Loup: $date Size=$Size\n";
		}
}
print "Closing...\n";
close OUT;
system "dir $Drive";
