//split
//a <: b
//merge
//a :> b 
//sequential
//a : b
//Parallel 
//a , b 
//Recursion
//a ~ b
//Wire- connect without manipulation
//a _ b
//!- eliminate
//process = !,_; (eliminates left channel of stereo signal)

//quadraphonic "cable"
//process = _,_,_,_; 

//sliders and numbers in faust are signal generators DEMO:
//process = hslider("sound", 0, -1, 1, 0.01);

//+, -, *, /, %, ^ all work on signals
