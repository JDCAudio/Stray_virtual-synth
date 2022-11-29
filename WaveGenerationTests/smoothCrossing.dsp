import("stdfaust.lib");

/*MODULATION SECTION:
Each group of four modulation parameters controls a single variable within the ampList
Variables modW0-modW3 are used to select the oscillating waveform (sin, tri, saw)
Variables modA0-modA3 determine the amplitude of said waves
Variables modF0-modF3 determine the frequency of oscillation for that particular amplitude value
The modulation section results in 4 seperate oscillating values*/

//Amp List Modulation Frequency 
modF0 = vslider("h:Wave Point Control/h:[0]Point Oscillation Frequency/[0]P0",0.001,0.001,20,0.001);
modF1 = vslider("h:Wave Point Control/h:[0]Point Oscillation Frequency/[1]P1",0.001,0.001,20,0.001);
modF2 = vslider("h:Wave Point Control/h:[0]Point Oscillation Frequency/[2]P2",0.001,0.001,20,0.001);
modF3 = vslider("h:Wave Point Control/h:[0]Point Oscillation Frequency/[3]P3",0.001,0.001,20,0.001);

//Amp List Modulation Amplitude, turn on and off points
modA0 = checkbox("h:Wave Point Control/v:[1]Point LFO/h:[2]On | Off/[0]P0");
modA1 = checkbox("h:Wave Point Control/v:[1]Point LFO/h:[2]On | Off/[1]P1");
modA2 = checkbox("h:Wave Point Control/v:[1]Point LFO/h:[2]On | Off/[2]P2");
modA3 = checkbox("h:Wave Point Control/v:[1]Point LFO/h:[2]On | Off/[3]P3");

//Amp List Modulation waveform (0 = sin, 1 = triangle, 2 = saw, 3 = smooth random, 4 = random)
modW0 = nentry("h:Wave Point Control/v:[1]Point LFO/h:[3]LFO Waveform/[0]P0[style:menu{'Sine':0;'Triangle':1;'Sawtooth':2'Smooth Rand':3;'Coarse Rand':4}]",0,0,4,1);
modW1 = nentry("h:Wave Point Control/v:[1]Point LFO/h:[3]LFO Waveform/[1]P1[style:menu{'Sine':0;'Triangle':1;'Sawtooth':2'Smooth Rand':3;'Coarse Rand':4}]",0,0,4,1);
modW2 = nentry("h:Wave Point Control/v:[1]Point LFO/h:[3]LFO Waveform/[2]P2[style:menu{'Sine':0;'Triangle':1;'Sawtooth':2'Smooth Rand':3;'Coarse Rand':4}]",0,0,4,1);
modW3 = nentry("h:Wave Point Control/v:[1]Point LFO/h:[3]LFO Waveform/[3]P3[style:menu{'Sine':0;'Triangle':1;'Sawtooth':2'Smooth Rand':3;'Coarse Rand':4}]",0,0,4,1);

/*RANDOM LFO SECTION:
In this region, all necessary variables for interpolation are declared and random LFO waves are
generated, one set of 4 smooth random and one set of 4 random*/

//These variables are consistent and can be used for all iterations of the random
nRand = 2;
iRand = nRand + 1;
xRandList = par(i,iRand,int(i));

//Assign modulation frequency variables to new random frequency variables for readability
fRand0 = modF0;
fRand1 = modF1;
fRand2 = modF2;
fRand3 = modF3;

//Seperate "Read Point" X values for each iteration of the random
xRand0 = os.phasor(iRand, fRand0);
xRand1 = os.phasor(iRand, fRand1);
xRand2 = os.phasor(iRand, fRand2);
xRand3 = os.phasor(iRand, fRand3);

//Create 4 seperate lists (parallel) of smooth noise
aSmNoise0 = par(i,iRand,(no.lfnoise(fRand0)));
aSmNoise1 = par(i,iRand,(no.lfnoise(fRand1)));
aSmNoise2 = par(i,iRand,(no.lfnoise(fRand2)));
aSmNoise3 = par(i,iRand,(no.lfnoise(fRand3)));

//Create 4 seperate lists (parallel) of noise
aNoise0 = par(i,iRand,(no.lfnoise0(fRand0)));
aNoise1 = par(i,iRand,(no.lfnoise0(fRand1)));
aNoise2 = par(i,iRand,(no.lfnoise0(fRand2)));
aNoise3 = par(i,iRand,(no.lfnoise0(fRand3)));

//Use lagrange interpolation to connect the random points from previous blocks
lfoSmInterp0 = xRand0, aSmNoise0 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp0 = xRand0, aNoise0 : it.lagrangeInterpolation(nRand, xRandList);
lfoSmInterp1 = xRand1, aSmNoise1 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp1 = xRand1, aNoise1 : it.lagrangeInterpolation(nRand, xRandList);
lfoSmInterp2 = xRand2, aSmNoise2 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp2 = xRand2, aNoise2 : it.lagrangeInterpolation(nRand, xRandList);
lfoSmInterp3 = xRand3, aSmNoise3 : it.lagrangeInterpolation(nRand, xRandList);
lfoInterp3 = xRand3, aNoise3 : it.lagrangeInterpolation(nRand, xRandList);

//Clip the LFO's to a -1 to 1 range
lfoSmRand0 = ba.if(lfoSmInterp0 > 1.0, 1.0, ba.if(lfoSmInterp0 < -1.0, -1.0, lfoSmInterp0));
lfoRand0 = ba.if(lfoInterp0 > 1.0, 1.0, ba.if(lfoInterp0 < -1.0, -1.0, lfoInterp0));
lfoSmRand1 = ba.if(lfoSmInterp1 > 1.0, 1.0, ba.if(lfoSmInterp1 < -1.0, -1.0, lfoSmInterp1));
lfoRand1 = ba.if(lfoInterp1 > 1.0, 1.0, ba.if(lfoInterp1 < -1.0, -1.0, lfoInterp1));
lfoSmRand2 = ba.if(lfoSmInterp2 > 1.0, 1.0, ba.if(lfoSmInterp2 < -1.0, -1.0, lfoSmInterp2));
lfoRand2 = ba.if(lfoInterp2 > 1.0, 1.0, ba.if(lfoInterp2 < -1.0, -1.0, lfoInterp2));
lfoSmRand3 = ba.if(lfoSmInterp3 > 1.0, 1.0, ba.if(lfoSmInterp3 < -1.0, -1.0, lfoSmInterp3));
lfoRand3 = ba.if(lfoInterp3 > 1.0, 1.0, ba.if(lfoInterp3 < -1.0, -1.0, lfoInterp3));

/*AMP LIST SECTION:
a0-a3 are assigned to the proper group of modulation parameters, a series of if statements are used to
determine what wave has been selected with the variables modW0-modW3
The amp list section takes the 4 oscillating values from before and puts them all into parrallel
composition, which for my purposes is being viewed as a list*/

//List of Amplitudes to be sent to interpolator
//aC1 and aC2 provide consistent Zero-crossing points
ampList = (aC1, a0, a1, a2, a3, aC2)
  with{
      //Nested if/else statements to pick the correct wave for each amplitude point
  aC1 = 0;
  a0 = ba.if(modW0 == 0, os.osc(modF0), ba.if(modW0 == 1, os.triangle(modF0), ba.if(modW0 == 2, si.smoo(os.sawtooth(modF0)), ba.if(modW0 == 3, lfoSmRand0, ba.if(modW0 == 4, lfoRand0))))) * modA0;
  a1 = ba.if(modW1 == 0, os.osc(modF1), ba.if(modW1 == 1, os.triangle(modF1), ba.if(modW1 == 2, si.smoo(os.sawtooth(modF1)), ba.if(modW1 == 3, lfoSmRand1, ba.if(modW1 == 4, lfoRand1))))) * modA1;
  a2 = ba.if(modW2 == 0, os.osc(modF2), ba.if(modW2 == 1, os.triangle(modF2), ba.if(modW2 == 2, si.smoo(os.sawtooth(modF2)), ba.if(modW2 == 3, lfoSmRand2, ba.if(modW2 == 4, lfoRand2))))) * modA2; 
  a3 = ba.if(modW3 == 0, os.osc(modF3), ba.if(modW3 == 1, os.triangle(modF3), ba.if(modW3 == 2, si.smoo(os.sawtooth(modF3)), ba.if(modW3 == 3, lfoSmRand3, ba.if(modW3 == 4, lfoRand3))))) * modA3;
  aC2 = 0;
};

//Using the paralell composition again, create a "list" for the integer X values of each amplitude
xCoords = par(i,I,int(i));

/*INTERPOLATION SECTION:
This is where the waveform for the synthesizer is determined. I am using the langrangeInterpolation
object to calculate the values in between the ampList values. xCoords for our integer X values, and
ampList determines the Y values for each point in xCoords. 'x', a phasor object will ramp from 0 to N and
is typically used to read through tables, we are using it to calculate the in-between values with
lagrangeInterpolation.
N refers to the order of interpolation, which has larger implications, but for our purposes, it
determines how many values the interpolator is expecting*/

//Order of Interpolation
N = 5;
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

process = result, result;
			