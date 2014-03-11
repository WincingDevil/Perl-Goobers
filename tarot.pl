#system "cls";
use vcfw;
@Major = ("The Fool",
"The Magician",
"The High Priestess",
"The Empress",
"The Emperor",
"The Hierophant",
"The Lovers",
"The Chariot",
"Fortitude",
"The Hermit",
"Wheel of Fortune",
"Justice",
"The Hanged Man",
"Death",
"Temperance",
"The Devil",
"The Tower",
"The Star",
"The Moon",
"The Sun",
"Judgement",
"The World"
);
@Minor = ("Ace","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Page","Knight","Queen","King");

@Suits = (
"Cups","Pentacles","Wands","Swords"
);

#print "Shuffle Major Arcana\n";
for ($x=1;$x<=22;$x++) {
	$r = int(rand(1)*22);
	if ($MajorRA[$r] eq "") {
		$MajorRA[$r] = $Major[$r];
		$x1 = substr("0".$x,-2);
		$r1 = substr("0".$r,-2);
		# print "$x1:$r1 $Major[$r] \n";
	} else {
		#print "$r:$x ";
		$x--;
	}
}
#print "\nShuffle Minor Arcana\n";
for ($x=1;$x<=56;$x++) {
	$r = int(rand(1)*56);
	if ($MinorRA[$r] eq "") {
		$x1 = substr("0".$x,-2);
		$r1 = substr("0".$r,-2);
		$Face = $r % 14;
		$Suit = int($r / 14);
		$MinorRA[$r] = "$Minor[$Face] of $Suits[$Suit]";
		#print "$x1: $Minor[$Face] of $Suits[$Suit] ($Suits1[$Suit])\n";
		#print "$x1: $Minor[$Face] of $Suits[$Suit]\n";
	} else {
		$x--;
	}
}
# print "\nPrint Whole Shebang\n";
for ($x=1;$x<=78;$x++) {
	$r = int(rand(1)*78);
	if ($MergedRA[$r] eq "") {
		if ($r < 22) {	
			$Card = $MajorRA[$r];
		} else {	
			$Card = $MinorRA[$r-22];
		}
		$MergedRA[$r] = $Card;
		$x1 = substr("0".$x,-2);
		$r1 = substr("0".$r,-2);
		print "$x1:$r1 = $Card\n";
		} else {
		$x--;
	}
}
paws();

