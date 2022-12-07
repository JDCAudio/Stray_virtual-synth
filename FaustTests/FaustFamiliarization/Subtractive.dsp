import("stdfaust.lib");

waveGenerator = hgroup("[0]Wave Generator",os.osc(freq+fm)*am,os.triangle(freq+fm)*am,os.square(freq+fm)*am,os.sawtooth(freq+fm)*am, no.noise : ba.selectn(5,wave))
  with{
  freq = hslider("[0]freq",440,50,2000,0.01);
  wave = nentry("[1]Waveform",0,0,4,1);
  am = ((1-amDepth) + os.osc(amFreq)*0.5+0.5)*amDepth;
  amFreq = hslider("[2]AM Freq[style:knob]",20,0.01,2000,0.01);
  amDepth = hslider("[3]AM Depth[style:knob]",0.5,0,1,0.01);
  fm = fmMod*fmCheck;
  fmMod = os.osc(fmFreq) * fmDepth;
  fmCheck = checkbox("[4]FM On/Off");
  fmFreq = hslider("[5]FM Freq[style:knob]",20,0.1,2000,0.01);
  fmDepth = hslider("[6]FM Depth[style:knob]",100,0,1000,0.01);
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

subtractive = waveGenerator : hgroup("[2]Filter",fi.resonlp(resFreq,q,1))
  with{
  cutOff = hslider("[0]Cutoff Freq[style:knob]",10,0.1,20,0.01);
  q = hslider("[1]Q[style:knob]",5,1,30,0.1);
  lfoFreq = hslider("[2]LFO Freq[style:knob]",10,0.1,20,0.01);
  lfoDepth = hslider("[3]LFO Depth[style:knob]",500,1,10000,1);
  resFreq = cutOff + os.osc(lfoFreq)*lfoDepth : max(30);
};


process = vgroup("Synth", subtractive * envelope);
			