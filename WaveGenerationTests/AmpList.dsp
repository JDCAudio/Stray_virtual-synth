import("stdfaust.lib");

//perlin style noise begins with predefined values at set integers

//test waveforms
yCoords1 = (0, 0.5, 1.0, 0.5, 0, -0.5, -1.0, -0.5);
yCoords2 = (0, 1.0, 1.0, 1.0, 0, -1.0, -1.0, -1.0);
yCoords3 = (0, 0.0, 1.0, 0.0, 0, 0.0, -1.0, 0.0);
yCoords4 = (0, 1.0, 0.75, 0.25, 0, -0.25, -0.75, -1.0);
yCoords5 = (0,no.noise,no.noise,no.noise,0,no.noise,no.noise,no.noise);





ampList = hgroup("[2]Amplitudes",a0, a1, a2, a3, a4, a5, a6, a7)
  with{
  a0 = vslider("0",0,-1,1,0.01);
  a1 = vslider("1",0,-1,1,0.01);
  a2 = vslider("2",0,-1,1,0.01); 
  a3 = vslider("3",0,-1,1,0.01);
  a4 = vslider("4",0,-1,1,0.01);
  a5 = vslider("5",0,-1,1,0.01);
  a6 = vslider("6",0,-1,1,0.01);
  a7 = vslider("7",0,-1,1,0.01);
};
//yCoords6 = ampList;

xCoords = (0,1,2,3,4,5,6,7);

//No lists in faust, use paralell 

//Use interpolation to find in-between values

/*x , yCoords : lagrangeInterpolation(N, xCoordsList) : _
N: order of the interpolator, known at compile-time
xCoordsList: a list of N + 1 elements determining the x-axis spacing of the points, known at compile-time
x: an x-axis position to interpolate between the y-values
yCoords: N + 1 elements determining the values of the interpolation points */

N = 7;
x = os.phasor(8, freq);

//do the interpolation
result = x, ampList : it.lagrangeInterpolation(N,xCoords);

//basic midi and envelope 
freq = hslider("freq",300,20,3000,0.1);

envelope = hgroup("[1]Envelope",en.adsr(atk,dcy,sus,rel,gate)*gain*0.3)
  with{
  atk = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  dcy = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sus = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  rel = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain",1,0,1,0.01);
  gate = button("gate");
};


process = result * envelope;
			