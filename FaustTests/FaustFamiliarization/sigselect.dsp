import("stdfaust.lib");
gain = hslider("gain", 0, 0, 1, 0.01);
process = nentry("selector",0,0,2,1), os.osc(220), os.osc(440), os.osc(880) : select3;
