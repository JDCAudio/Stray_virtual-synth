import("stdfaust.lib");
dirac = 1-1';
//@ is a delay, delaying by the sample rate makes the click happen
//at one second after opening program
process = dirac, ma.SR : @;
			