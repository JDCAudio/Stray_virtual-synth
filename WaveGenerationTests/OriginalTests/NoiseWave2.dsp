import("stdfaust.lib");

freq = hslider("Freq",440,50,2000,0.1);

rand = no.noise : ba.latch(ba.beat(60));
  
envelope = hgroup("[1]Envelope",en.adsr(atk,dcy,sus,rel,gate)*gain*0.3)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain",1,0,1,0.01);
  gate = button("gate");
};

f = freq + rand;

process = os.osc(f) * envelope;
			
