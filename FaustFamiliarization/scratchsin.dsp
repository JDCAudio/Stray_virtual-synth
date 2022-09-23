import("stdfaust.lib");
phasor(f) = f/ma.SR : (+,1:fmod)~_;
process = phasor(440) * ma.PI*2 : sin;