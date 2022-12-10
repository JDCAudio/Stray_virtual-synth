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
  
# Building the Code

Navigate to the [Stray](/Stray/) folder. Select the version of the project you want to build ([Most Recent](/Stray/1_1/)) and navigate to that directory. Each version's directory contains the following:
* FaustDSP
  * A single Faust ([.dsp](/Stray/1_1/FaustDSP/stray_1_1.dsp)) file 
* JuceProject
  * Source code ([.cpp](/Stray/1_1/JuceProject/FaustPluginProcessor.cpp)) and a Juce project ([.jucer](/Stray/1_1/JuceProject/stray_1_1.jucer)) file
* builds
  * Contains Standalone ([.app](/Stray/1_1/builds/stray_1_1.app)) and VST ([.vst3](/Stray/1_1/builds/stray_1_1.vst3)) 
  * Currently the provided files are exclusive to Mac. If you wish to use the VST on a Windows or Linux machine, follow the "Building the Juce Project" instructions below
    
## Running the Faust (.dsp) file
Faust can be used in a variety of ways ([Faust Downloads](https://faust.grame.fr/downloads/)), but the easiest and fastest way is through the [online IDE](https://faustide.grame.fr)
1. Open the [IDE](https://faustide.grame.fr)
   * Chrome is currently the only browser that supports the MIDI functionality 
2. Upload [stray_X_X.dsp](/Stray/1_1/FaustDSP/stray_1_1.dsp)
3. Click Run to compile the code

That's all that is required to run the Faust project! Any connected midi controllers can be chosen from the menu on the top right and the instrument is fully usable within the browser. 

## Building the Juce Project
1. Download BOTH the [.cpp](/Stray/1_1/JuceProject/FaustPluginProcessor.cpp) and [.jucer](/Stray/1_1/JuceProject/stray_1_1.jucer) file, place them in the same folder. 
2. Download [JUCE](https://juce.com/get-juce)
   * Place your JUCE folder in your Home Directory 
3. Open Projucer
4. Setting up Global Paths
   1. On the top left of your screen, click on "Projucer"
   2. From the drop-down menu, select "Global Paths..."
   3. Ensure that your Path to JUCE and JUCE Modules is correct
      * Ex: On my system:
        * Path To JUCE: `/Users/jclark/JUCE`
        * Path To JUCE Modules: `/Users/jclark/JUCE/modules`
5. Click "Open Existing Project" and select [stray_X_X.jucer](/Stray/1_1/JuceProject/stray_1_1.jucer)
6. Navigate to the Modules tab and ensure that for every module "Use Global Path" is selected
7. Select your Exporter and click Open in IDE
8. Choose your build settings, and run the code
9. The auto-generated code does throw some warnings, but the build should succeed, and if you have selected the standalone app version, a window will open for you. 

## How to get from Faust to Juce
The process of converting the Faust project to Juce is actually quite straightforward, however there is no up-to-date documentation on the process.

When set up properly, the code generated by Faust will be entirely functional without the need of any edits. 

1. Open Faust's [Online IDE](https://faustide.grame.fr)
2. Click on the Export button (Truck icon below the save button on the left side of the screen)
3. Select Juce as the Platform 
4. Select plug-in-midi-poly-16 as the Architecture (Or, if this is for a different project, whatever architecture seems appropriate)
5. Click Compile, and then Click Download once the button appears
6. Un-zip the downloaded file and place the folder in your desired location
   * This zip file will contain both a FaustPluginProcessor.cpp file and a .jucer file for the project
7. Open the .jucer File in Projucer
8. Projucer will likely notify you that some of the chosen exporters are no longer available. Simply remove these, and any others that you are not planning on using. 
9. Ensure that JUCE's global paths are set correctly (see step 4 in "Building the Juce Project")
10. Navigate to the Modules tab, click on every individual module and select the "Use Global Path" option
11. In the settings, scroll to Plug-in Formats and ensure that only VST3 and Standalone are selected
12. For Stray, multiple parameter names would be the same when shortened to the AAX format. I am not currently planning on supporting this format, but it does throw some errors in Juce. To avoid this:
    1. Click on the settings icon above the file explorer
    2. Scroll down until you see Preprocessor Definitions 
    3. Add "JUCE_DISABLE_CAUTIOUS_PARAMETER_ID_CHECKING" to the preprocessor definitions 
13. Select your Exporter and click open in IDE
14. Choose your build settings, and run the code
15. The auto-generated code does throw some warnings, but the build should succeed, and if you have selected the standalone app version, a window will open for you. .vst3 and .app files can be found through the created "builds" folder within your project. 

