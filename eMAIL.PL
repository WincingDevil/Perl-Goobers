###########################################################################
#
# EMAIL.PL  Rudimentary Command Line/Script callable email tosser
#
# This goober uses SMTP itself (instead of sendmail) to send email.
# You'll neet the "libnet" package to run it.
# This requires access to an SMTP server, though.
# <Many Thanks to Graham Barr for writing Net::smtp!>
#
# Format:
# email [Recipient | !RecipientList ] ["Subject"] ["Message" | !IncludeFile]
#
# If the 1st Character of Recipient is a bang, it's taken as a recipient list
# all of which will be BCC'd.
#
# If the 1st Character of Message is a bang, it's taken as a file to be sent.
#
# If the Message is a Bang, call editor to edit blank message file to send
#
# 2001.01.04 Multiple recipients can be specified on the command line,
#            seprated by commas.
#
# Author:
# Vince Wilding, Web Wrangler, MetaData Maven, Perl Hacker Wannabe
# USGS/BRD/OBIO   Voice: 703-648-4220  Fax: 703-648-4224
# mailto:vince_wilding@usgs.gov  http://vcfw.er.usgs.gov/~vwilding/
# print "Just another Perl hacker wannabe!\n"; #K.I.S.S.!!!!
#
###########################################################################


use Net::SMTP;
use vcfw;

if (!$ARGV[2]) {
   print "Format: email [Recipient | !RecipientList ] [\"Subject\"] [\"Message\" | !include file] \n";
   exit;
}

$tag = `type c:\\data\\sig.txt`;

#print "\nAfter TYPE cmd\n???";
#$X=(<STDIN>);
$IncludeFile = "*";

$Recip = $ARGV[0];
$Subj  = $ARGV[1];
$Mesg  = $ARGV[2];
if (!$ARGV[3]) {
   $From      = "vince\@vincewilding.com (Vince Wilding)"; # Data for "From" line
} else {
   $From = $ARGV[3];
   print "Alternate From = $From\n";
}

$Log = "c:\\data\\email.log";

# Setup the Server Attributes

#$Server    = "mail.speakeasy.net";
#$Server = "70.88.129.89";
#$Server="smtp.earthlink.net";
#$Server="relay-hosting.secureserver.net";
#$Server="smtpauth.earthlink.net";
$Server="smtpout.secureserver.net";

$Username  = "vince\@vincewilding.com";    # Account Name on server"
$From      = "vince\@vincewilding.com (Vince Wilding)"; # Data for "From" line
$RetPath   = $From;
$OrgName   = "Total Lack Thereof!";                      # Organization
$RetPath   = $From;
GenDTG();                  #Generate Time Stamp
$Stamp = substr($loc,0,3).", ".substr($loc,4)." -0400"; #Zeller the Zulu later

open (LOG, ">>$Log") || die "couldn't open $Log: $!\n";
print LOG "$DTG: $Recip; $Subj; $Mesg\n";
close LOG;


if (substr($Mesg,0,1) eq "!") {
   if ($Mesg eq "!") {
      $IncludeFile = "c:\\temp\\mail.in";
      system "Q $IncludeFile";
   } else {
      $IncludeFile = substr($Mesg,1);
   }

   open (INCLU,"$IncludeFile") || die "Can't Open Include file: $IncludeFile: $!\n";
   close (INCLU);
   $Mesg = `type $IncludeFile`;
} else {
   $Mesg =~ s/\\n/\n/g; # Allow \n's on command line
}

$RepTo     = $From;

print "Sending Massage to $Recip via $Server \@ $loc\n";
print "Include file = $IncludeFile\n" if ($IncludeFile ne "*");

$smtp = Net::SMTP->new($Server);       # SMTP does its PFM
print "Sign on = \"$smtp{'domain'}\"\n";
$smtp->mail($Username);                # Identify yourself to Server
#$smtp->auth($Username,"bglss4srel");
#
$Mult = index($Recip,",");

if (substr($Recip,0,1) eq "!") {
   print "Mult Addees via include file ($RecipFile)\n";
   $ToLine = "Multiple.Recipients\@xyzzy.plugh";
   $RecipFile = substr($Recip,1);
   open (RECIP,"$RecipFile") || die "Recip File: Can't Open $RecipFile: $!\n";
   @LINES=<RECIP>;
   close(RECIP);
   $SIZE=@LINES;
   print "# Lines = $SIZE\n\n";
   $SIZE--;
   for ($i=0;$i<=$SIZE;$i++) {
     $Recipx=$LINES[$i];
     chomp ($Recipx);
     print "Recip # $i = $Recipx\n";
     $smtp->to($Recipx);
   }
}  elsif ($Mult != -1) {  #Multiple Recipients on Command Line
   print "Mult Addees on command line\n";
   $ToLine = "Multiple.Recipients\@xyzzy.plugh";
   @Addees = split(/,/, $Recip);
   foreach $Addee (@Addees) {
     $Recipx=$Addee;
     chomp ($Recipx);
     for ($Recipx) { # Trim trailing/leading spaces
       s/^\s+//;
       s/\s+$//;
     }
     $i++;
     print "Recip # $i = $Recipx\n";
     $smtp->to($Recipx);
   }
} else {
   print "Single Addee\n";
   $ToLine = "$Recip";
   $smtp->to($Recip);
}

$smtp->data();
$smtp->datasend("To: $ToLine\n");
$smtp->datasend("From: $From\n");
$smtp->datasend("Return-Path: $RetPath\n");
$smtp->datasend("Reply-to: $RepTo\n");
$smtp->datasend("Date: $Stamp\n");
$smtp->datasend("Organization: $OrgName\n");
#smtp->datasend("Return-receipt-to: Vince_Wilding\@usgs.gov (Vince Wilding)\n");
$smtp->datasend("XYZZY: PLUGH!\n");
$smtp->datasend("X-Mailer: email.pl (PERL RULZ! $DTG)\n");
$smtp->datasend("Subject: $Subj\n");
$smtp->datasend("\n");                          #End of Headers

$smtp->datasend("$Mesg\n");                                                  #Message Data Goes Here
$smtp->datasend("\n======\nMessage sent via email.pl at: $DTG\n\n--\n$tag") if ($IncludeFile eq "*") ;
$smtp->dataend();
$smtp->quit;

$loc = localtime;
print "Send complete \@ $loc\n";
##############################################################################
