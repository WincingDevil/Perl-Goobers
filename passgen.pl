#!/usr/bin/perl -w

if (exists ($ARGV[0])) { 
     $Max = $ARGV[0];
} else {
	$Max= 12;   
	Usage();
}
if (exists ($ARGV[1])) { 
     $PasLen = $ARGV[1];
} else {
	$PasLen = 12000;   
	#Usage();
}
chomp($Max);
print "\n=== Password Generator ===\n";
@chars = ( "A" .. "Z", 0 .. 9, "a" .. "z", "!", "@", "#", "\$", "\%", "^", "\*", "(", ")", "=", "{", "}", ",", ":",";","\"");
for ($Loop=1;$Loop <= $Max;$Loop++) {
    $password = join( "", @chars[ map { rand @chars } ( 1 .. $PasLen ) ] );
    print "$password \n";
}
if ($Max == 1) {
   $Plural = "password";
} else {
  $Plural = "passwords"
}

print "=== $Max $Plural of $PasLen characters ===\n\n";
exit 0;


sub Usage {
	print<<EOM;

	Usage:  passgen X Y
	X = Number of passwords to generate
	y = Password length
EOM
}
	