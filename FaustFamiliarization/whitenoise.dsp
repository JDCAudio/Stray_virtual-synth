import("stdfaust.lib");

random = +(12345) ~ *(1103515245);
noise = random/2147483547.0;
process = noise * vslider("volume[style:knob]",0,0,1,0.01);
			