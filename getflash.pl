#!perl
$|=1;
use vcfw;
GenDTG();
FindFlash();
if ($Flash eq "AA") {
	die "Can't Find the Flash Drive\n";
}
$Flash.=":";
print "\nI see Flash as $Flash\n";

$SysTemp = $ENV{'TEMP'};
#print "$SysTemp\n\n";
#exit;
$Cmd = "dir $Flash\\*.jpg /s/w";
system $Cmd;
#exit
print "And what shall we call this batch?\n";
$Title = <STDIN>;
chomp $Title;
$Title =~ s/ /_/g;
$NewDir = "$YY-Pix\\$YY$MM$DD-$Title";
system "note Starting Pix Batch $NewDir";
$FullPath = "c:\\pix\\$NewDir";  #$FullPath = "C:\\My Documents\\My Pictures\\$NewDir";
print "md \"$FullPath\"";
print "\n";
print "md \"$FullPath\\tmp\"";
print "\n";
#xit;
system "md \"$FullPath\"";
system "md \"$FullPath\\tmp";
system "md \"$FullPath\\movies";
chdir "$FullPath\\tmp";
$Cmd1 = `cd`;
print "We're in $Cmd1 (Press Enter)\n\a";
#exit;
#$X = <STDIN>;
#ystem "xcopy $Flash\\*.jpg /s";
#ystem "xcopy $Flash\\*.avi /s";
#ystem "xcopy $Flash\\*.thm /s";

system "dir $Flash\\DCIM\\*.jpg /b/s>$SysTemp\\pix.1";
system "dir $Flash\\DCIM\\*.avi /b/s>>$SysTemp\\pix.1";
system "dir $Flash\\DCIM\\*.mov /b/s>>$SysTemp\\pix.1";
system "dir $Flash\\DCIM\\*.thm /b/s>>$SysTemp\\pix.1";
system "type $SysTemp\\pix.1";

print "Above is input (Press Enter)\n\a";
#$X = <STDIN>;
#ystem "grep -v 100CANON $SysTemp\\pix.1>$SysTemp\\pix.1a";
$f1 = "$SysTemp\\pix.1";
open (IN,"$f1") || die "Choke on open $f1: $!\n";
while (<IN>) {
	chomp;
	$D = $_;
	$cmd1 = "copy $D \"$FullPath\\tmp\"";
	system "$cmd1";
    print ">$cmd1<\n";
}
close (IN);
#exit;
system "perl c:\\wv\\renom.pl JPG";
system "call renom1";
system "ren renom1.bat renomJPG.1";

system "if exist *.AVI perl c:\\wv\\renom.pl AVI";
system "if exist *.AVI call renom1";
system "ren renom1.bat renomAVI.1";

system "if exist *.mov perl c:\\wv\\renom.pl mov";
system "if exist *.mov call renom1";
system "ren renom1.bat renomMOV.1";

system "if exist *.THM perl c:\\wv\\renom.pl THM";
system "if exist *.THM call renom1";
system "ren renom1.bat renomTHM.";
system "move *.jpg ..";
system "if exist *.avi move *.avi ..\\movies";
system "if exist *.mov move *.mov ..\\movies";

#system "ren *.thm *.jpg";
system "if exist *.thm move *.thm ..\\movies";
chdir "..";
$Cmd2 = "dir \"$FullPath\\*.jpg\" /on /b|c:\\cygwin\\030621\\bin\\head.exe -1";
print "Cmd2 = $Cmd2\n";
$StartMe=`$Cmd2`;
system "note Finish Pix Batch $NewDir";
print "\a\aStartMe = $StartMe (Press Enter)"; #
#$X=<STDIN>;$X="";

#system "start $StartMe";
system "explorer .";
#system "call slideshow $Title";
exit;
##################################
sub FindFlash {
	$Flash="D";
	for ($X=1; $X < 24; $X++) {
		$Flash++;
		$Check = $Flash.":\\VCFWPixFlash.txt";
		if (-e $Check) {
			$X =25;
		}
	}
}
