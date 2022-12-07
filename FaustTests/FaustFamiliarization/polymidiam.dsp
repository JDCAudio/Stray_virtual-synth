import("stdfaust.lib");

waveGenerator = hgroup("[0]Wave Generator",os.osc(freq),os.triangle(freq),os.square(freq),os.sawtooth(freq) : ba.selectn(4,wave))
  with{
  wave = nentry("[0]Waveform",0,0,3,1);
  freq = hslider("[1]freq",440,50,2000,0.01);
};

envelope = hgroup("[1]Envelope",en.adsr(atk,dcy,sus,rel,gate)*gain*0.3)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain",1,0,1,0.01);
  gate = button("[5]gate");
};

am = hgroup("[2]AM",modulator)
  with{
  modulator = ((1-modDepth) + os.osc(modFreq)*0.5+0.5)*modDepth;
  modFreq = hslider("[0]Modulator Frequency[style:knob]",20,0.01,2000,0.01);
  modDepth = hslider("[1]Modulator Depth[style:knob]",0.5,0,1,0.01);
};

process = vgroup("Synth",(waveGenerator*am) * envelope);
			