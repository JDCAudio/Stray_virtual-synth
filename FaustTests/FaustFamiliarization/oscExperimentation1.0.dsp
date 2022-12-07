import("stdfaust.lib");

//define samplerate
sr = ma.SR;
twopi = 2.0*ma.PI;

//define waveform in table
ts = 1<<16; //size = 65536 samples
time = (+(1) ~ _) , 1 : - ;
sinewave = ((float(time) / float(ts)) * twopi) : sin;

phase = os.phasor(ts,freq);


//read from table
sin_osc(freq) = rdtable(ts,sinewave,int(phase));

//generate a one sample impulse from the gate 
trig = pm.impulseExcitation(reset);

freq = hslider("freq", 100, 0, 1600, 0.001);

process = sin_osc(freq);