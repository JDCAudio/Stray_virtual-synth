# How It Works
### The Core Parts
* xCoords
  * Fixed integer values from 0 to 5
* ampList
  * A list of 6 amplitude (y) points, one for each x coordinate
  * The first (0) and last (5) points are fixed at 0 to ensure smooth transitions
  * The remaining four values are controlled by LFO’s
* x
  * The Current location within the waveform
  * This is a Faust phasor `os.phasor(I, freq)`object used to read through tables. It ramps from smoothly from 0 to 'I'

These three elements give us 6 (x, y) pairs of coordinates, and a read point for the current location in the wave. 

### The LFO's
There are four LFO’s, one for each controllable amplitude point. Each LFO has the following parameters:
* Point Oscillation Frequency
  * The oscillation speed (0-20 Hz) of a given point
* LFO On/Off
  * Toggle which LFO’s are active. If unchecked, the point will remain fixed at 0. If checked, the point will be free to oscillate between -1 and 1. At least one LFO must be on in order for the synth to make sound
* LFO Shape
  * The available shapes are Sine, Sawtooth, Triangle, Smooth Random and Course random. This determines the pattern of movement for a given point
    * The Sine `os.osc`, Sawtooth `os.sawtooth` and Triangle  `os.triangle` waves use objects from Faust’s `oscillators.lib`
      * to minimize popping, I am using a smoothed sawtooth waveform `si.smoo(os.sawtooth(F))` where F is frequency
    * The Smooth Random and Course random waves are created using the same lagrange interpolation technique (explained in more detail below) as is used for the Synthesizer’s waveform. There are 3 noise objects representing the Y values. Oscillation frequency determines how often they produce a new random value, and the 2nd order interpolation draws a line to connect the points
      * The Smooth random uses Faust’s `no.lfnoise` object, which is smoothed by a 3rd order Butterworth lowpass filter
      * The Coarse random uses Faust’s `no.lfnoise0` object, whose output is a sample-and-hold style random. Using Coarse random will result in some popping in the signal
      
### The Interpolation
The interpolation section takes our 6 coordinate values and ‘draws’ a smooth line connecting them. This fills in the missing information between the integer values and results in our audible waveform.

This project uses Faust’s `it.lagrangeInterpolation` object. Lagrange interpolation determines the polynomial of the lowest degree that crosses through every point. 

`it.lagrangeInterpolation` has four arguments, X coordinate list, Y coordinate list, X, and N (order of interpolation). The first three arguments can be filled in from our “Core Parts.” The order of interpolation will always be 1 less than the number of points, in the case of this project, N = 5.

Since our X value is a ramping phasor, the output of the interpolation will be a constantly changing value representing the waveform of the synthesizer.

### Post-Interpolation
The interpolation draws a line connecting all of our points, but this signal requires a little bit of taming to be usable as the waveform for the synthesizer.

* Clipping
  * The interpolation draws the polynomial that fits every point, but it does this without any range restrictions. I have chosen to handle this simply by clipping the waveform between -1 and 1 if it exceeds the bounds on either end
* DC Offset
  * Since the amplitude values are allowed to move freely, there is a relatively high chance of unintentional DC offset. Before the output, a high order high-pass filter at 15 Hz is applied to avoid unwanted pops and clicks
* Envelope
  * A Standard ADSR is used to shape the envelope of the sound
  
# Visual Examples
![noLFO1](https://user-images.githubusercontent.com/105126223/206880949-83d40dc1-e005-4520-9294-799fed00107b.png)

* The image above represents the points that make up Stray's waveform. The two red dots represent the beginning and end of the table, which are fixed at 0. The four purple dots are the points that the user has control over (P0 to P3 from left to right). The X coordinates for the user controlled points are 1-4 from left to right. 

![singleLFO1](https://user-images.githubusercontent.com/105126223/206881207-682201bf-87d8-4522-ac07-d7a715c859e0.png)

* The image above is an example snapshot of the waveform created by the interpolation process (the red line) with a single active LFO on P1. P1 will move between -1 and 1 in the pattern of whatever LFO shape is selected. The speed of this motion is determined by the Point Oscillation Frequency. 
* The Resulting waveform will be dependent on the amplitude of the each Point when 'x' (the ramping phasor object) crosses the Point's X value. In this image, when the phasor was outputing a value of 2, P1 had an amplitude value of ~0.8. 
