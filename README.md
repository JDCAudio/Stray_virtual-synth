# What Is 'Stray'?
A typical wavetable synthesizer will have a table of predetermined amplitude values which are read through at the appropriate speed relative to the frequency of the current note, resulting in an audible signal. Stray functions similarly, reading through a table of values, but the amplitude values are not predefined. Instead, these values are modulated with one of four LFO shapes.

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
  * This is a Faust phasor object used to read through tables. It ramps from smoothly from 0 to 'N'

These three elements give us 6 (x, y) pairs of coordinates, and a read point for the current location in the wave. 

### The LFO's
There are four LFO’s, one for each controllable amplitude point. Each LFO has the following parameters:
* Point Oscillation Frequency
  * The oscillation speed (0-20 Hz) of a given point
* LFO On/Off
  * Toggle which LFO’s are active. If unchecked, the point will remain fixed at 0. If checked, the point will be free to oscillate between -1 and 1. At least one LFO must be on in order for the synth to make sound
* LFO Shape
  * The available shapes are Sine, Sawtooth, Triangle, Smooth Random and Course random. This determines the pattern of movement for a given point
    * The Sine, Sawtooth and Triangle waves use objects from Faust’s oscillators.lib
    * The Smooth Random and Course random waves are created using the same lagrange interpolation technique (explained in more detail below) as is used for the Synthesizer’s waveform. There are 3 noise objects representing the Y values. Oscillation frequency determines how often they produce a new random value, and the 2nd order interpolation draws a line to connect the points
      * The Smooth random uses Faust’s lfnoise object, which is smoothed by a 3rd order Butterworth lowpass filter
      * The Coarse random uses Faust’s lfnoise0 object, whose output is a sample-and-hold style random. Using Coarse random will result in some popping in the signal
      
### The Interpolation
The interpolation section takes our 6 coordinate values and ‘draws’ a smooth line connecting them. This fills in the missing information between the integer values and results in our audible waveform.

This project uses Faust’s lagrangeInterpolation object. Lagrange interpolation determines the polynomial of the lowest degree that crosses through every point. 

Faust’s it.lagrangeInterpolation object has four arguments, X coordinate list, Y coordinate list, X, and N (order of interpolation). The first three arguments can be filled in from our “Core Parts.” The order of interpolation will always be 1 less than the number of points, in the case of this project, N = 5.

Since our X value is a ramping phasor, the output of the interpolation will be a constantly changing value representing the waveform of the synthesizer.

### Post-Interpolation
The interpolation draws a line connecting all of our points, but this signal requires a little bit of taming to be usable as the waveform for the synthesizer.

* Clipping
  * The interpolation draws the polynomial that fits every point, but it does this without any range restrictions. I have chosen to handle this simply by clipping the waveform between -1 and 1 if it exceeds the bounds on either end
* DC Offset
  * Since the amplitude values are allowed to move freely, there is a relatively high chance of unintentional DC offset. Before the output, a high order high-pass filter at 15 Hz is applied to avoid unwanted pops and clicks
* Envelope
  * A Standard ADSR is used to shape the envelope of the sound
  
# Building the Code

Navigate to the [Stray](/Stray/) folder. Select the version of the project you want to build ([Most Recent](/Stray/1_1/)) and navigate to that directory. Each version's directory contains the following:
* FaustDSP
  * A single Faust (.dsp) file 
* JuceProject
  * Source code (.cpp) and a Juce project (.jucer) file
* builds
  * Contains Standalone (.app) and VST (.vst3) 
  * Currently the provided files are exclusive to Mac. If you wish to use the VST on a Windows or Linux machine, follow the "Building the Juce Project" instructions
    
## Running the Faust (.dsp) file
Faust can be used in a variety of ways ([Faust Downloads](https://faust.grame.fr/downloads/)), but the easiest and fastest way is through the [online IDE](https://faustide.grame.fr)
1. Open the [IDE](https://faustide.grame.fr)
   * Chrome is currently the only browser that supports the MIDI functionality 
2. Upload stray_X_X.dsp
3. Click Run to compile the code

That's all that is required to run the Faust project! Any connected midi controllers can be chosen from the menu on the top right and the instrument is fully usable within the browser. 

## Building the Juce Project
1. Download BOTH the .cpp and .jucer file, place them in the same folder. 
2. Download [JUCE](https://juce.com/get-juce)
3. Open Projucer
4. Click "Open Existing Project" and select stray_X_X.jucer
6. Select your IDE and click Open in IDE
7. Choose your build settings, and run the code
8. The auto-generated code does throw some warnings, but the build should succeed, and if you have selected the standalone app version, a window will open for you. 

## How to get from Faust to Juce
The process of converting the Faust project to Juce is actually quite straightforward, however there is no up-to-date documentation on the process.

When set up properly, the code generated by Faust will be entirely functional without the need of any edits. 

1. Open Faust's [Online IDE](https://faustide.grame.fr)
2. Click on the Export button (Truck icon below the save button on the left side of the screen)
3. Select Juce as the Platform 
4. Select plug-in-midi-poly-16 as the Architecture (Or, if this is for a different project, whatever architecture seems appropriate)
5. Click Compile, and then Click Download once the button appears
6. Un-zip the downloaded file and place the folder in your desired location
7. Open the .jucer File in Projucer
8. Projucer will likely notify you that some of the chosen exporters are no longer available. Simply remove these, and any others that you are not planning on using. 
9. This should not be necessary, but I ran into fewer problems if I ensured that within the "Modules" tab, every module has the "Create Local Copy" option On
10. In the settings, scroll to Plug-in Formats and ensure that only VST3 and Standalone are selected
11. For Stray, multiple parameter names would be the same when shortened to the AAX format. I am not currently planning on supporting this format, but it does throw some errors in Juce. To avoid this:
    1. Click on the settings icon above the file explorer
    2. Scroll down until you see Preprocessor Definitions 
    3. Add "JUCE_DISABLE_CAUTIOUS_PARAMETER_ID_CHECKING" to the preprocessor definitions 
12. Select your IDE and click open in IDE
13. Select your targets and run the code

