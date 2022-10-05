import("stdfaust.lib");



triangleWave = waveform{0,0.25,0.5,0.75,1,0.75,0.5,0.25,0,-0.25,-0.5,-0.75,-1,-0.75,-.5,-0.25};
squareWave = waveform{0,1,1,1,1,1,1,0,-1,-1,-1,-1,-1,-1,-1,0};


testOsc(freq) = squareWave,int(os.phasor(16,freq)) : rdtable;
freq = hslider("freq",440,50,2000,0.01);
rIdx = os.phasor(16, freq);
wIdx = ba.period(hslider("writeSpeed",16,1,16,0.01));

envelope = hgroup("[1]Envelope",en.adsr(atk,dcy,sus,rel,gate)*gain*0.3)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain",1,0,1,0.01);
  gate = button("gate");
};

noise = no.lfnoise(freq) * hslider("noiseGain",0.5,0,1,0.01);

process = it.frwtable(1,16,os.sinwaveform(16),wIdx,(testOsc(freq) * noise),rIdx) * envelope;


//process = triangleOsc(freq) * envelope;



			