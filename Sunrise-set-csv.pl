#!/usr/bin/perl -w
use vcfw;
use Date::Calc 'Add_Delta_Days';
GenDTG();
(@Rise,@Set) ="";
$Junk="";
$ThisYear=$YYYY;
$F1=$ThisYear."sun.txt"; #Massaged data from http://aa.usno.navy.mil/data/docs/RS_OneYear.php: zero pad short months, squeeze, replace spaces with commas.
open (IN,"<",$F1) || die "choke on open $F1:$!\n";
$F2=$ThisYear."-rise-set.csv";
open (OUT,">",$F2) || die "choke on open $F2:$!\n";
print OUT "Date,Rise,Set,Length\n";
for ($Day=1; $Day <= 31; $Day++) {
	$LineIn = <IN>;
	chomp($LineIn);
	($Junk,
	$Rise[1][$Day],$Set[1][$Day],
	$Rise[2][$Day],$Set[2][$Day],
	$Rise[3][$Day],$Set[3][$Day],
	$Rise[4][$Day],$Set[4][$Day],
	$Rise[5][$Day],$Set[5][$Day],
	$Rise[6][$Day],$Set[6][$Day],
	$Rise[7][$Day],$Set[7][$Day],
	$Rise[8][$Day],$Set[8][$Day],
	$Rise[9][$Day],$Set[9][$Day],
	$Rise[10][$Day],$Set[10][$Day],
	$Rise[11][$Day],$Set[11][$Day],
	$Rise[12][$Day],$Set[12][$Day]
	) = split(/,/,$LineIn);

}

for ($Jdate=1;$Jdate<=365;$Jdate++) {
	$Jdate1 = substr(("00".$Jdate),-3,3);
	$yyyy_doy = $ThisYear . $Jdate1;
	($year, $doy) = $yyyy_doy =~ /(....)(...)/;
	($YYYY, $MM, $DD) = Add_Delta_Days ($year, 1, 1, $doy - 1);
#	print OUT "$Jdate1,";
	TimeCalc($Rise[$MM][$DD],$Set[$MM][$DD],$MM,$DD);
	$MM = substr(("0".$MM),-2,2);
	$DD = substr(("0".$DD),-2,2);
	print OUT "$MM/$DD/$ThisYear,$H1:$M1,$H2:$M2,$Hd:$Md\n";
}
close OUT;
system "q $F2";

####################################################################
sub TimeCalc {
my ($T1,$T2,$MM,$DD) = @_;

$T1 = substr(("0000".$T1),-4,4);
$T2 = substr(("0000".$T2),-4,4);

$H1 = substr($T1,0,2);
$M1 = substr($T1,2,2);

$H2 = substr($T2,0,2);
$M2 = substr($T2,2,2);

$S1 = ($H1*3600) + ($M1*60);
$S2 = ($H2*3600) + ($M2*60);

$Diff = $S2 - $S1;  #Seconds of Daylight.
$Hd = int($Diff/3600);  #Hours Difference
$Md = (($Diff - ($Hd*3600))/60); #Minutes Difference
$Hd = substr(("0".$Hd),-2,2);
$Md = substr(("0".$Md),-2,2);
} 