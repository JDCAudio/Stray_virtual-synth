import("stdfaust.lib");

/*MODULATION SECTION:
Each group of four modulation parameters controls a single variable within the ampList
Variables modW0-modW3 are used to select the oscillating waveform (sin, tri, saw)
Variables modA0-modA3 determine the amplitude of said waves
Variables modF0-modF3 determine the frequency of oscillation for that particular amplitude value
The modulation section results in 4 seperate oscillating values*/

//Amp List Modulation Frequency 
modF0 = vslider("h:Modulation/h:[1]Modulation Frequency/[0]mod0[style:knob]",0.001,0,20,0.001);
modF1 = vslider("h:Modulation/h:[1]Modulation Frequency/[1]mod1[style:knob]",0.001,0,20,0.001);
modF2 = vslider("h:Modulation/h:[1]Modulation Frequency/[2]mod2[style:knob]",0.001,0,20,0.001);
modF3 = vslider("h:Modulation/h:[1]Modulation Frequency/[3]mod3[style:knob]",0.001,0,20,0.001);

//Amp List Modulation Amplitude
modA0 = vslider("h:Modulation/h:[2]Modulation Amplitude/[0]modA0[style:knob]",0,0,1,0.01);
modA1 = vslider("h:Modulation/h:[2]Modulation Amplitude/[1]modA1[style:knob]",0,0,1,0.01);
modA2 = vslider("h:Modulation/h:[2]Modulation Amplitude/[2]modA2[style:knob]",0,0,1,0.01);
modA3 = vslider("h:Modulation/h:[2]Modulation Amplitude/[3]modA3[style:knob]",0,0,1,0.01);

//Amp List Modulation waveform (0 = sin, 1 = triangle, 2 = saw, 3 = random)
modW0 = nentry("h:Modulation/h:[3]Modulation Waveform/[0]modWave0",0,0,3,1);
modW1 = nentry("h:Modulation/h:[3]Modulation Waveform/[1]modWave1",0,0,3,1);
modW2 = nentry("h:Modulation/h:[3]Modulation Waveform/[2]modWave2",0,0,3,1);
modW3 = nentry("h:Modulation/h:[3]Modulation Waveform/[3]modWave3",0,0,3,1);

nRand = 2;
iRand = nRand + 1;
xRandList = par(i,iRand,int(i));

fRand0 = modF0;
fRand1 = modF1;
fRand2 = modF2;
fRand3 = modF3;

xRand0 = os.phasor(iRand, fRand0);
xRand1 = os.phasor(iRand, fRand1);
xRand2 = os.phasor(iRand, fRand2);
xRand3 = os.phasor(iRand, fRand3);

aNoise0 = par(i,iRand,(no.lfnoise(fRand0)));
aNoise1 = par(i,iRand,(no.lfnoise(fRand1)));
aNoise2 = par(i,iRand,(no.lfnoise(fRand2)));
aNoise3 = par(i,iRand,(no.lfnoise(fRand3)));

lfoInterp0 = xRand0, aNoise0 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp1 = xRand1, aNoise1 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp2 = xRand2, aNoise2 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp3 = xRand3, aNoise3 : it.lagrangeInterpolation(nRand, xRandList);

lfoRand0 = ba.if(lfoInterp0 > 1.0, 1.0, ba.if(lfoInterp0 < -1.0, -1.0, lfoInterp0));
lfoRand1 = ba.if(lfoInterp1 > 1.0, 1.0, ba.if(lfoInterp1 < -1.0, -1.0, lfoInterp1));
lfoRand2 = ba.if(lfoInterp2 > 1.0, 1.0, ba.if(lfoInterp2 < -1.0, -1.0, lfoInterp2));
lfoRand3 = ba.if(lfoInterp3 > 1.0, 1.0, ba.if(lfoInterp3 < -1.0, -1.0, lfoInterp3));

/*AMP LIST SECTION:
a0-a3 are assigned to the proper group of modulation parameters, a series of if statements are used to
determine what wave has been selected with the variables modW0-modW3
The amp list section takes the 4 oscillating values from before and puts them all into parrallel
composition, which for my purposes is being viewed as a list*/

//List of Amplitudes to be sent to interpolator
ampList = (a0, a1, a2, a3)
  with{
  a0 = ba.if(modW0 == 0, os.osc(modF0), ba.if(modW0 == 1, os.triangle(modF0), ba.if(modW0 == 2, os.sawtooth(modF0), ba.if(modW0 == 3, lfoRand0)))) * modA0;
  a1 = ba.if(modW1 == 0, os.osc(modF1), ba.if(modW1 == 1, os.triangle(modF1), ba.if(modW1 == 2, os.sawtooth(modF1), ba.if(modW1 == 3, lfoRand1)))) * modA1;
  a2 = ba.if(modW2 == 0, os.osc(modF2), ba.if(modW2 == 1, os.triangle(modF2), ba.if(modW2 == 2, os.sawtooth(modF2), ba.if(modW2 == 3, lfoRand2)))) * modA2; 
  a3 = ba.if(modW3 == 0, os.osc(modF3), ba.if(modW3 == 1, os.triangle(modF3), ba.if(modW3 == 2, os.sawtooth(modF3), ba.if(modW3 == 3, lfoRand3)))) * modA3;
};

//Using the paralell composition again, create a "list" for the integer X values of each amplitude
xCoords = par(i,I,int(i));

/*INTERPOLATION SECTION:
This is where the waveform for the synthesizer is determined. I am using the langrangeInterpolation
object to calculate the values in between the ampList values. xCoords for our integer X values, and
ampList determines the Y values for each point in xCoords. 'x', a phasor object will ramp from 0 to N and
is typically used to read through tables, we are using it to calculate the in-between values with
lagrangeInterpolation.
N refers to the order of interpolation, which has larger implications, but for our purposes, it determines how many values the interpolator is expecting*/

//Order of Interpolation
N = 3;
/*I is how many values in the lists (ampList and xCoords) the interpolator is expecting, based off of the
order of interpolation. xCoords is generalized using this variable, the amplist and modulation values are
written out for clarity for now*/
I = N+1;

//Ramps from 0 to I at a speed dependent on the current frequency, used to drive the interpolation
x = os.phasor(I, freq);

//do the interpolation
interpResult = x, ampList : it.lagrangeInterpolation(N,xCoords);

/*POST INTERPOLATION:
At this point, a wave has been drawn that goes through all of our oscillating values, resulting in a
dynamic waveform. The remaining elements are used to "tame" this waveform, and add standard synthesizer
elements to create a playable instrument*/

//clip results between -1 and 1 to ensure the signal will not be clipping the output
clipResult = ba.if(interpResult>1.0, 1.0, (ba.if(interpResult<-1.0, -1.0, interpResult)));

//basic midi integration through frequency slider
freq = hslider("freq",300,20,3000,0.1);

//Creates ADSR envelope, gate variable is automatically connected to a midi key press
//en.adsr expects times in seconds, which is not very readable, so the user controlls are in ms
envelope = hgroup("[0]Envelope",en.adsr(atk,dcy,sus,rel,gate)*gain)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain",1,0,1,0.01) * 0.3;
  gate = button("gate");
};

//High Pass filter for eliminating any DC offset
filResult = clipResult : fi.highpass(16,15);

//Apply the envelope to the sound
result = filResult * envelope;

process = result;
			