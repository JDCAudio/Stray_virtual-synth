import("stdfaust.lib");

//use thise variables with myconst.PI or myconst.E
myconst = environment {
  PI = ma.PI;
  E = ma.E;
}

process = myconst.e;
			