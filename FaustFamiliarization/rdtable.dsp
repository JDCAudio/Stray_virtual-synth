import("stdfaust.lib");

dirac = 1-1';
phase = 1 : +~_ : %(4096); //incremental counter between 0 and 4095
process = 4096,dirac,phase : rdtable;
			