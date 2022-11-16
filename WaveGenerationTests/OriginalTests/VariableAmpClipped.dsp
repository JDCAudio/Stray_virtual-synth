import("stdfaust.lib");

//N = order of interpolation
N = 5;
//I = number of iterations for various parameters
I = N+1;
//x used to calculate current location in waveform
x = os.phasor(I, freq);
//initialize list of inteeger x values
xCoords = par(i,I,int(i));
//Sliders for all amplitudes of integer values
ampList = hgroup("[2]Amplitudes",par(i,I,vslider("A%i",0,-1,1,0.01)));

//do the interpolation
interpResult = x, ampList : it.lagrangeInterpolation(N,xCoords);

result = ba.if(interpResult>1.0, 1.0, (ba.if(interpResult<-1.0, -1.0, interpResult)));

//basic midi and envelope 
freq = hslider("freq",300,20,3000,0.1);

envelope = hgroup("[1]Envelope",en.adsr(atk,dcy,sus,rel,gate)*0.3)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  //gain = hslider("[4]gain",1,0,1,0.01);
  gate = button("gate");
};


process = result * envelope;
			
