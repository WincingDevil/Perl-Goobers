#!perl
use vcfw;
GenDTG();
$F1 = $ARGV[0];
$F2 = $ARGV[1];
if ($F1 eq "") {
	$F1 = "C:\\Temp\\rdir-in.txt";
	$F2 = "C:\\Temp\\rdir-in.out";
	#$F1= "c:\\temp\\121119_091900.rf1";
	#$F2= "c:\\temp\\121119_091900.rf2";
}

$LongFiles = "C:\\temp\\longfile_$DTG2.txt";
#$DirsFile  = "C:\\temp\\DirsFile_$DTG2.txt";
$DirsFile  = "C:\\temp\\DirsFile.txt";
$Food = "???"; #$ARGV[2];
#$F3 = "C:\\fixlong.bat";
$DirLine = " Directory of";
#           1234567890123


open (IN,"$F1") || die "choke on open input $F1:$!\n";
open (OUT,">$F2") || die "choke on open output $F2:$!\n";
open (LONG,">$LongFiles") || die "choke on open output $LongFiles:$!\n";
open (DIRZ,">$DirsFile") || die "choke on open output $DirsFile:$!\n";

#open (IN,">$F3") || die "choke on open FIX $F3:$!\n"
$ThisDirSize=0;
$NumFilesThisDir=0;
while (<IN>) {
	chomp;
	$D=$_;
#	print "Processing Line : $D\n";
#	$lc++;
	if (substr($D,0,13)  eq $DirLine) {
		$Dir = substr($D,13);
		$Dir.= "\\" if (substr($D,-1,1) ne "\\");
		$DirCount++;
		$DateLine = <IN>;      #Skip blank line
		$DateLine = <IN>;
		$D = $DateLine;
		chomp($D);
		chomp ($DateLine);
		$Date1= substr($DateLine,6,4).substr($DateLine,0,2).substr($DateLine,3,2);
		if ($DirCount > 1) {
			print DIRZ "\t$ThisDirSize\t$NumFilesThisDir\n";
		}
		$ThisDirSize=0;
		$NumFilesThisDir=0;
		print DIRZ "$Date1\t$Dir";  
	}
#01234567890123456789012345678901234567890
#          1         2         3         4 
#.              <DIR>        07-10-02 10:41p .
#..             <DIR>        07-10-02 10:41p ..
#02/08/2007  08:07 PM    <DIR>
	if ((uc(substr($D,24,5)) ne "<DIR>") && (substr($D,14,1) eq ":")) {
#		print "File: $D\n";
		$Hours = substr($D,12,2);
		$Hours += 12 if ((substr($D,18,1) eq "P") and ($Hours ne "12"));
#		$Hours = "0" .trim($Hours) if ($Hours < 10);
		$Timx = $Hours . substr($D,15,2);
		$LFilNam = substr($D,39);
		$FilSiz = trim(substr($D,21,17));
		$FilSiz =~ s/,//g;
		$TotSiz +=$FilSiz;
		$ThisDirSize += $FilSiz;
		$NumFilesThisDir++;
		$NumFil++;
		$DTG= substr($D,6,4) . substr($D,0,2) . substr($D,3,2) . " " . $Timx;
		$CFS = $Dir . $LFilNam;
		$LenCFS=length($CFS);
		if ($LenCFS > 235) {
		print LONG "$LenCFS ren \"$CFS\" \"$LFilNam\"\n"
		}
		$Outline = $DTG . " " .substr($D,21,17) .  $Dir . $LFilNam ."\n";
		print OUT $Outline;
	}
}
$X=<<EOM;
01234567890123456789012345678901234567890
01/05/2005  05:32 PM               206 audio.log
01/09/2005  08:13 PM                 0 AUTOEXEC.BAT
03/31/2006  11:08 AM    <DIR>          Bank
03/31/2006  09:45 PM    <DIR>          belfry
07/09/2002  09:00 PM    <DIR>          bin
03/30/2006  07:42 PM               209 boot.ini
01/09/2005  06:45 PM    <DIR>          CMPNENTS
EOM

$X = Commify($TotSiz);
$LastLine = "Dirs = $DirCount, Files = $NumFil, Bytes =  $X \n";
print OUT $LastLine;
close OUT;
open (LOG,">>c:\\data\\rdir.log") || die "choke on open LOG $!\n";
write LOG;
close LOG;
print DIRZ "\t$ThisDirSize\t$NumFilesThisDir\n";
close DIRZ;
close LONG;

if ($F2 eq "C:\\Temp\\rdir-in.out") {
	$Ed = "C:\\Progra~2\\notepad++\\notepad++.exe"; 
	system ("$Ed $F1 $F2 $DirsFile $LongFiles");
}
format LOG = 
@<<<<<<<<<<<<<<<<<<<<<<  @<<< @<<<< @>>>>>>>>>>>>>>
$Food, $DirCount, $NumFil, $X
.
#                                   123,456,789,111
# system "c:\\progra~1\\editpl~1\\editplus.exe $F2";

#             12345678901234567890
#BEFL     OBJ         2,239  07-09-02  3:37p BEFL.OBJ
#01234567890123456789012345678901234567890
#          1         2         3         4 
