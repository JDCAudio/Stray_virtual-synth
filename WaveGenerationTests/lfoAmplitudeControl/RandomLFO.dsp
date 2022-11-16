import("stdfaust.lib");

N = 2;
I = N + 1;
xList = par(i,I,int(i));
f = hslider("Frequency", 5, 0, 20, 0.01);
x = os.phasor(I, f);
aList = par(i,I,(no.lfnoise(5) * 0.1));

interpResult = x, aList : it.lagrangeInterpolation(N, xList);

clipResult = ba.if(interpResult>1.0, 1.0, (ba.if(interpResult<-1.0, -1.0, interpResult)));

process = clipResult;