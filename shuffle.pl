use vcfw;
srand;

@Suits1=("Hearts","Diamonds","Clubs","Spades");
@Suits=(chr(3),chr(4),chr(5),chr(6));

@Faces=("Ace","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Jack","Queen","King");

for ($x=1;$x<=52;$x++) {
	$r = int(rand(1)*52);
	if ($RA[$r] eq "") {
		$RA[$r] = $r;
		$x1 = substr("0".$x,-2);
		$r1 = substr("0".$r,-2);
		$Face = $r % 13;
		$Suit = int($r / 13);
		#print "$x1: $Faces[$Face] of $Suits[$Suit] ($Suits1[$Suit])\n";
		print "$x1: $Faces[$Face] of $Suits1[$Suit]\n";
	} else {
		$x--;
	}
}