import("stdfaust.lib");

//define samplerate
twopi = 2.0*ma.PI;

//define base waveform in table
tableSize = 1<<16; //size = 65536 samples
time = (+(1) ~ _) , 1 : - ;
sinewave = ((float(time) / float(tableSize)) * twopi) : sin;

//Define index
readIndex = int(os.phasor(tableSize,freq));
writeIndex = readIndex : de.delay(32,32);


writeStream = no.noise;


//read from table
sin_osc(freq) = rwtable(tableSize,sinewave,writeStream,writeIndex,readIndex);


freq = hslider("freq", 100, 0, 1600, 0.001);
switch = button("toggle") : ba.toggle;

process = switch*sin_osc(freq);