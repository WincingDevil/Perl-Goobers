#!perl -w
use	LWP::UserAgent;
use	vcfw;
$url = "http://www.wincingdevil.com/cgi/stamp.pl";
$f1	= "c:\\data\\stamp.log";
GenDTG();
$DTGone	= $DTG2;
$ua =	new	LWP::UserAgent;
$ua->agent("$0/0.1 " . $ua->agent);
$ua->agent("Vince Wilding's Snarfilator (VCFW/SetClock)");
$req = new HTTP::Request 'GET' =>	"$url";
$req->header('Accept'	=> 'text/html');
#end request
$res = $ua->request($req);
#	check the outcome
GenDTG();
$DTGtwo	= $DTG2;
if ($res->is_success)	{
	$RemoteDTG=$res->content;
	chomp($RemoteDTG);
	print "OK:	$DTGone:$DTGtwo:$RemoteDTG\n";
	$HH1=substr($RemoteDTG,7,2);
	$MN1=substr($RemoteDTG,9,2);
	$SS1=substr($RemoteDTG,11,2);
	$SetTime = "TIME $HH1:$MN1:$SS1";
	$RemoteSecs = $HH1 * 60	*60;
	$RemoteSecs+= $MN1 *60;
	$RemoteSecs+= $SS1;
	$LocalSecs = $HH * 60 *60;
	$LocalSecs+= $MN *60;
	$LocalSecs+= $SS;
	$Diff =	abs($LocalSecs - $RemoteSecs);
	print "($Diff) $SetTime\n";
	$Tag="";
	if ($Diff > 2) {
	$Tag=" (SetClock)";
		print "Setting Time\n";
		system $SetTime;
	}
	open (FILE,">>$f1")	|| die "Couldn't open $f1: $!\n";
	print FILE "$DTGone:$DTGtwo:$RemoteDTG$Tag\n";
	close (FILE);
}	else {
	$X = $res->status_line;
	chomp( $X);
	open (FILE,">>$f1")	|| die "Couldn't open $f1: $!\n";
	print FILE "$DTGone:$DTGtwo:Err($X)\n";
	close (FILE);
	print "Err:	$DTGone:$DTGtwo:Err($X)\n";
	system "grep Err $f1|tail >$f1.err";
	system "perl C:\\Perl\\bin\\eMAIL.PL \"vince\@vincewilding.com"	\"Server Down $DTGone:$DTGtwo:Err($X)\"	!$f1.err";
}

