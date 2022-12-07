import("stdfaust.lib");
freq = hslider("freq",440,50,1000,0.01);
gain = hslider("gain",0.5,0,1,0.01);
timbre(f) = os.osc(f)*0.5 + os.osc(f*2)*0.25 + os.osc(f*3)*0.125;
process = gain*timbre(freq);