use vcfw;
$x = 0;
while (1) {
	if ($x ==1) {
		$x=0;
		GenDTG();
		print "$DTG2: Tock\n";
	} else {
		$x=1;
		GenDTG();
		print "$DTG2: Tick\n";
	}
	sleep 2;
}
