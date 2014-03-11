# VCFW.PM My Favorite Goobers

##############################################################################
# I know this is deprecated by DTGhr, but it's every-freaking-where
sub GenDTG {
    ($tym) = @_;
    if (!$tym) {
      $loc = localtime();
    } else {
      $loc = localtime($tym);
    }

%MONTHS=('Jan','01','Feb','02','Mar','03','Apr','04','May','05','Jun','06',
         'Jul','07','Aug','08','Sep','09','Oct','10','Nov','11','Dec','12');

$MONTH = substr($loc,4,3);
$MM = $MONTHS{$MONTH};
substr($loc,8,1) = "0" if (substr($loc,8,1) eq " ");
$DD = substr($loc,8,2);

$YY = substr($loc,22,2);
$YYYY = substr($loc,20,4);

$HH = substr($loc,11,2);
$MN = substr($loc,14,2);
$SS = substr($loc,17,2);

$DTG = $YY.$MM.$DD." ".$HH.$MN.$SS;
$DTG2 = $YY.$MM.$DD."_".$HH.$MN.$SS;

}
##############################################################################

sub GenTemp {              # Generate a Unique File name
  GenDTG();                # based on update type, a counter, DTG & Process #
  $TmpIdx++;
  $TmpFilNam = $TmpIdx."_".$DTG2."_".$$;
}
##############################################################################

sub zeller  {

#Returns Day of week given Month, Day and 4 digit year
#i.e.:
#%DAYS=(0,'Sunday',1,'Monday',2,'Tuesday',3,'Wednesday',4,'Thursday',5,'Friday',6,'Saturday');
#$Z = zeller($MM, $DD, $YYYY);
#print "$MM/$DD/$YYYY is a $DAYS{$Z}\n";

  my $zMM = shift(@_);
  my $zDD = shift(@_);
  my $zYY = shift(@_);
  if ($zMM >= 3){
    $zMM -= 2;
  }
  else {
    $zMM += 10;
  }

  if( ($zMM == 11) || ($zMM == 12) ){
    $zYY--;
  }

  $Century = int($zYY / 100);
  $YearOfCent = $zYY % 100;

  $zeller = int(2.6 * $zMM - .2);

  $zeller +=  int($zDD + $YearOfCent);
  $zeller += $YearOfCent / 4;
  $zeller = int($zeller);
  $zeller += int($Century / 4);
  $zeller -= int(2 * $Century);
  $zeller %= 7;

  if($zeller < 0){     #Y2K Fix
    $zeller += 7;
  }

  return $zeller;

}
##############################################################################

sub FireWall {
my $Msg1 = shift;
$Msg1 = $0 if (Msg1 eq "");
GenDTG();

my $rh = $ENV{REMOTE_HOST};
my $ra = $ENV{REMOTE_ADDR};
my $hr = $ENV{HTTP_REFERER};


open (FIRELOG,">>d:\\apache\\logs\\firewall.log") ||die "Couldn't open submit log: $!\n";

print FIRELOG "$DTG $Msg1 ";
print FIRELOG "RH: $rh " if ($rh ne "");
print FIRELOG "RA: $ra " if ($ra ne "");
print FIRELOG "HR: $hr " if ($hr ne "");

@GOOD = (
"130.11.*",                 #BRD HQ
"159.189.27.25",            #
);
$NumGood = $#GOOD;
$IP = "BAD";

for ($i=0;$i <= $NumGood;$i++) {
   $ra1 = $ra;
   $This = $GOOD[$i];
   $x = index($This,"*");
   if ($x ne -1) {
     $ra1 = substr($ra1,0,$x);
     $This = substr($This,0,$x);
   }
#   print "Checking RA = \"$ra1\"  Against Table Entry \"$This\"\n";
   $IP = "GOOD" if ($ra1 eq $This);
}

if ($IP eq "BAD") {

   print FIRELOG "(deny)\n";
   close FIRELOG;
   print <<EOM;
Content-type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<title>Authorization Failure</title>
<h1>Authorization Failure</h1>
This server could not verify that you are authorized to access the
document requested.  Either you supplied the wrong credentials (e.g.,
bad password), your browser doesn't understand how to supply the
credentials required, or your computer's address may not be in the list of allowable addresses.<P>
<b>If you believe that you have recieved this message in error</b>, please
<A HREF="http://vcfw.er.usgs.gov/cgi-bin/comments.pl?to=vince_wilding\@usgs.gov&subj=Auth+Fail+IP+$ra+Host+$rh">Click Here</A>.
</BODY></HTML>
EOM
   exit;
}
print FIRELOG "(OK)\n";
close FIRELOG;
}
##############################################################################

sub URLit {
## dont forget to "use URI::Escape;"
#  $foo = URLit($bar);
   @U = @_;
   for (@U) {
     $U = uri_escape($_,"^A-Za-z\-\.0-9");    #Urlencode that Puppy!
     $U =~ s/\%20/\+/g;
   }
   return $U;
}

#############################################################################

sub Garner {
    ($buffer) = @_;
    if ($buffer eq "") {
      read(STDIN, $bufPost, $ENV{'CONTENT_LENGTH'});  #Snarf STDIN ASAP
      $bufGet = $ENV{'QUERY_STRING'};

      if ($bufGet ne "") {
       chomp($bufGet);
       $buffer = $bufGet;
      }

      if ($bufPost ne "") {
       chomp($bufPost);
       $buffer = $bufPost;
      }

      if (($bufGet ne "") && ($bufPost ne "")) {
         $buffer = $bufGet."&".$bufPost;
      }
    }

$VCFWDBG=0;
if ($VCFWDBG eq 1) {
print<<EOM;
Content-type: text/html

<hr>
bufGet: $bufGet<br>
bufPost: $bufPost<br>
buffer: $buffer<br>
<hr>
EOM
}


    @pairs = split(/&/, $buffer);
    %FORM = ();  # Clear out any old stuff
    foreach $pair (@pairs) {
       ($name, $value) = split(/=/, $pair);
       # Un-Webify plus signs and %-encoding
       $value = "" if (!$value);
       $value =~ tr/+/ /;
       $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
       $value =~ s/<!--(.|\n)*-->//g;
       $value =~ s/</&lt;/g;
       $value =~ s/>/&gt;/g;

       $FORM{$name} = $value;
    }
}

##############################################################################
sub xGarner {
    ($buffer) = @_;
    my $Bar = chr(186);
    if ($buffer eq "") {
      read(STDIN, $bufPost, $ENV{'CONTENT_LENGTH'});  #Snarf STDIN ASAP
      $bufGet = $ENV{'QUERY_STRING'};

      if ($bufGet ne "") {
       chomp($bufGet);
       $buffer = $bufGet;
      }

      if ($bufPost ne "") {
       chomp($bufPost);
       $buffer = $bufPost;
      }

      if (($bufGet ne "") && ($bufPost ne "")) {
         $buffer = $bufGet."&".$bufPost;
      }
    }

$VCFWDBG=0;
if ($VCFWDBG eq 1) {
print<<EOM;
Content-type: text/html

<hr>
bufGet: $bufGet<br>
bufPost: $bufPost<br>
buffer: $buffer<br>
<hr>
EOM
}


    @pairs = split(/&/, $buffer);
    %FORM = ();  # Clear out any old stuff
    foreach $pair (@pairs) {
       ($name, $value) = split(/=/, $pair);
       # Un-Webify plus signs and %-encoding
       $value = "" if (!$value);
       $value =~ tr/+/ /;
       $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
       $value =~ s/<!--(.|\n)*-->//g;
       $value =~ s/</&lt;/g;
       $value =~ s/>/&gt;/g;
       if (!($FORM{$name})) {
         $FORM{$name} = $value;
       } else {
         $FORM{$name} = $FORM{$name}.$Bar.$value;
       }
    }
}

##############################################################################

sub GetPlumVar {

  ($PlumRaw) = @_;
  if ($PlumRaw eq "") {
  $PlumRaw=$ENV{'HTTP_CSP_GATEWAY_SPECIFIC_CONFIG'};
  }
  if ($PlumRaw ne "") {
   @PlumPairs = split(/,/, $PlumRaw);
        %PLUMVAR = ();  # Clear out any old stuff
        foreach $pair (@PlumPairs) {
           $i = index($pair,"=");
           $name = substr($pair,0,$i);
           $value = substr($pair,$i+1);
           $PLUMVAR{$name} = $value;

        }
   $PLUMVAR{'VCFW-MT'} = 0;
  } else {
   %PLUMVAR = ();  # Clear out any old stuff
   $PLUMVAR{'VCFW-MT'} = 1;
  }
}
###################################################################

sub trim {
  my $TrimMe = shift;
  for ($TrimMe) { # Trim trailing/leading spaces
    s/^\s+//;
    s/\s+$//;
  }
  return $TrimMe;
}

###############################################################

sub nCrypt {

   my $Clear = shift;
   my $Bump = 0;
   my $Cloudy = "";
   my $l = length($Clear);
   for ($x=0;$x < $l;$x++) {
     $p = substr($Clear,$x,1);
     $i = index($A,$p);
     if ($i < 0) {die "$p is an invalid character\n"};
     $i += $FIB[$Bump++];
     $Bump = 0 if ($Bump == $NumFIB);
     $p = substr($A,$i,1);
     $Cloudy = $Cloudy.$p;
   }
   return $Cloudy;
}

###############################################################

sub dCrypt {
   my $Cloudy = shift;
   my $Bump = 0;
   my $Clear2 = "";
   my $l = length($Cloudy);
   for ($x=0;$x < $l;$x++) {
     $p = substr($Cloudy,$x,1);
     $i = index($A,$p,$La1+1);
     $i -= $FIB[$Bump++];
     $Bump = 0 if ($Bump == $NumFIB);
     $p = substr($A,$i,1);
     $Clear2 = $Clear2.$p;
   }
   return $Clear2;
}
sub crSetup {
   $A = "";
   for ($x=32;$x < 127;$x++) {
      $A = $A.chr($x);
   }
   $La1 = length($A);
   $A = $A.$A;
   @FIB=(1,2,3,5,8,13,21,34,55,89);
   $NumFIB = $#FIB;
}
##################################################################
sub Commify {
    my $Cm = shift;
    $_ = $Cm;
    1 while s/^(-?\d+)(\d{3})/$1,$2/;
    $Cm = $_;
    return $Cm;
}

##################################################################
sub	paws {
	print "???\n";
	$x=<STDIN>;
}

##################################################################
sub rot13 {
    while ($_[0] =~ /(.)/g) {
      $c = $1;
      $c =~ tr/a-zA-Z/n-za-mN-ZA-M/;
      $c =~ tr/0-9/5-90-4/;                 
      $bable .= $c;
    }
    return $bable;
}
##################################################################
sub DTGhr { #Hi Res Time: returns YYYYMMDD_HHMMSS.TTTTTT
	use Time::HiRes qw(time);
	use POSIX qw(strftime);
	my $t = time;
	return (strftime "%Y%m%d_%H%M%S", localtime($t)) . sprintf (".%06d", ($t-int($t))*(10**6));
}

##################################################################
1;

