#!perl -w
use Time::HiRes qw(time);
use POSIX qw(strftime);
$tick=0;
$OldDate = "";
for ($Loup=0;$Loup<10;) {
	$tick++;
	my $t = time;
	my $date = strftime "%y%m%d_%H%M%S", localtime $t;
 	$date .= sprintf ".%06d", ($t-int($t))*1000000; # without rounding
	if ($date ne $OldDate) {
		print "$Loup: $date ($tick)\n";
		$Loup++;
		$tick=0;
		$OldDate=$date;
	}
}

