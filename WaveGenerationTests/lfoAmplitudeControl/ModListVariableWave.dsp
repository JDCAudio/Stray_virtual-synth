import("stdfaust.lib");




modF0 = vslider("h:Modulation/h:[1]Modulation Frequency/[0]mod0[style:knob]",0,0,20,0.01);
modF1 = vslider("h:Modulation/h:[1]Modulation Frequency/[1]mod1[style:knob]",0,0,20,0.01);
modF2 = vslider("h:Modulation/h:[1]Modulation Frequency/[2]mod2[style:knob]",0,0,20,0.01);
modF3 = vslider("h:Modulation/h:[1]Modulation Frequency/[3]mod3[style:knob]",0,0,20,0.01);
modF4 = vslider("h:Modulation/h:[1]Modulation Frequency/[4]mod4[style:knob]",0,0,20,0.01);
modF5 = vslider("h:Modulation/h:[1]Modulation Frequency/[5]mod5[style:knob]",0,0,20,0.01);



modA0 = vslider("h:Modulation/h:[2]Modulation Amplitude/[0]modA0[style:knob]",0,0,1,0.01);
modA1 = vslider("h:Modulation/h:[2]Modulation Amplitude/[1]modA1[style:knob]",0,0,1,0.01);
modA2 = vslider("h:Modulation/h:[2]Modulation Amplitude/[2]modA2[style:knob]",0,0,1,0.01);
modA3 = vslider("h:Modulation/h:[2]Modulation Amplitude/[3]modA3[style:knob]",0,0,1,0.01);
modA4 = vslider("h:Modulation/h:[2]Modulation Amplitude/[4]modA4[style:knob]",0,0,1,0.01);
modA5 = vslider("h:Modulation/h:[2]Modulation Amplitude/[5]modA5[style:knob]",0,0,1,0.01);

modW0 = nentry("h:Modulation/h:[3]Modulation Waveform/[0]modWave0",0,0,2,1);
modW1 = nentry("h:Modulation/h:[3]Modulation Waveform/[1]modWave1",0,0,2,1);
modW2 = nentry("h:Modulation/h:[3]Modulation Waveform/[2]modWave2",0,0,2,1);
modW3 = nentry("h:Modulation/h:[3]Modulation Waveform/[3]modWave3",0,0,2,1);
modW4 = nentry("h:Modulation/h:[3]Modulation Waveform/[4]modWave4",0,0,2,1);
modW5 = nentry("h:Modulation/h:[3]Modulation Waveform/[5]modWave5",0,0,2,1);


ampList = (a0, a1, a2, a3, a4, a5)
  with{
  a0 = ba.if(modW0 == 0, os.osc(modF0) * modA0, ba.if(modW0 == 1, os.triangle(modF0) * modA0, ba.if(modW0 == 2, os.sawtooth(modF0))));
  a1 = ba.if(modW1 == 0, os.osc(modF1) * modA1, ba.if(modW1 == 1, os.triangle(modF1) * modA1, ba.if(modW1 == 2, os.sawtooth(modF1))));
  a2 = ba.if(modW2 == 0, os.osc(modF2) * modA2, ba.if(modW2 == 1, os.triangle(modF2) * modA2, ba.if(modW2 == 2, os.sawtooth(modF2)))); 
  a3 = ba.if(modW3 == 0, os.osc(modF3) * modA3, ba.if(modW3 == 1, os.triangle(modF3) * modA3, ba.if(modW3 == 2, os.sawtooth(modF3))));
  a4 = ba.if(modW4 == 0, os.osc(modF4) * modA4, ba.if(modW4 == 1, os.triangle(modF4) * modA4, ba.if(modW4 == 2, os.sawtooth(modF4))));
  a5 = ba.if(modW5 == 0, os.osc(modF5) * modA5, ba.if(modW5 == 1, os.triangle(modF5) * modA5, ba.if(modW5 == 2, os.sawtooth(modF5))));
};

xCoords = par(i,I,int(i));

//No lists in faust, use paralell 

//Use interpolation to find in-between values

/*x , yCoords : lagrangeInterpolation(N, xCoordsList) : _
N: order of the interpolator, known at compile-time
xCoordsList: a list of N + 1 elements determining the x-axis spacing of the points, known at compile-time
x: an x-axis position to interpolate between the y-values
yCoords: N + 1 elements determining the values of the interpolation points */

N = 5;
I = N+1;
x = os.phasor(I, freq);

//do the interpolation
interpResult = x, ampList : it.lagrangeInterpolation(N,xCoords);

//clipping
clipResult = ba.if(interpResult>1.0, 1.0, (ba.if(interpResult<-1.0, -1.0, interpResult)));

//basic midi and envelope 
freq = hslider("freq",300,20,3000,0.1);

envelope = hgroup("[0]Envelope",en.adsr(atk,dcy,sus,rel,gate)*gain*0.3)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain",1,0,1,0.01);
  gate = button("gate");
};


process = clipResult * envelope;
			