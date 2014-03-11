#!perl
use vcfw;
$F1 = "c:\\wv\\dp.lst";
$F2 = "c:\\wv\\readlatr.out";

open (IN, "$F1") || die "choke on open input $F1:$!\n";
open (OUT, ">$F2") || die "choke on open output $F2:$!\n";
#drwxr-x--- 19 sifadmin sifadmin     4096 Jun 27 08:28 .
$type=$perms=$size=$user=$grp=$perms=$Dat1=$Dat2=$Dat3=$FileName=$x = "X";
$Chk = 16384;
while (<IN>) {
	chomp;
	$Ct++;
	if (($Ct/$Chk) == int($Ct/$Chk)) {
		$x = Commify($TotSiz);
		print "$Ct: $x\n"; 
	}
	$Line = $_;
	if  (substr($Line,0,1) eq "/") { #($Line =~ /^\./) {
		$Path = $Line;
		print "path=$Path\n";
		$Path =~ s/:$//;
	} else {
		if (($Line ne "") and (substr($Line,0,6) ne "total ")) {
		$_=$Line;
#        -rw-r--r--  1 sifadmin sifadmin 1953201 Mar 20 00:00 csv-tables-2012-03-20_00.00.05.tar.gz
    #   ($perms,$type,$user,$grp,$size,$Dat1,$Dat2,$Dat3,$FileName) = split(/\s+/,$Line);
		($perms,$x,$type,$x,$user,$x,$grp,$x,$size,$x,$Dat1,$x,$Dat2,$x,$Dat3,$x,$FileName) =
		m/^(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(.*)/;
	#	($perms,$type,$user,$grp,$perms,$Dat1,$Dat2,$Dat3,$FileName) =~ m/\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+) (\.*)/;
	#	print "$Line\nperms:$perms, type:$type, user:$user,grp:$grp, size:$size, d1:$Dat1, d2:$Dat2, d3:$Dat3, fn:$FileName<\n\n";
		#print "$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$19,$20,$21\n";
		#print "Path:[$Path] perms:[$perms] File:[$FileName]\n";#  *** [$Line]\n";
		if (($FileName ne ".") and ($FileName ne "..") and  !($perms =~ /^d/)) {
			#Jul 6 07:20 ~ 0 ~ ./vcfw.txt
			$Dat2 = substr("0".$Dat2,-2);
			$size = substr("            ".$size,-9);
		#	print OUT "$Dat1 $Dat2 $Dat3 \t $size \t $Path/$FileName\n";
			print OUT "$size \t $Dat1 $Dat2 $Dat3 \t $Path/$FileName\n";
			$TotSiz+=$size
		}
	}
	}
}
close IN;
$TotSiz= Commify($TotSiz);
print OUT "$TotSiz\n";
print "\n\n=====================\n$Ct:$TotSiz\n";

close OUT;
#system ("start c:\\progra~2\\notepad++\\notepad++.exe $F2")
system ("start C:\\Progra~1\\EditPl~1\\editplus.exe $F2");
