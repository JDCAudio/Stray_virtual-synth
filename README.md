# What Is 'Stray'?
A typical wavetable synthesizer will have a table of predetermined amplitude values which are read through at the appropriate speed relative to the frequency of the current note, resulting in an audible signal. Stray functions similarly, reading through a table of values, but the amplitude values are not predefined. Instead, these values are modulated with one of four LFO shapes.

For an in depth explanation of how Stray works, click [here](/HowItWorks.md)

# Downloading Stray
Builds provided in this repository are compatible only with MacOS. For a standalone or VST version compatible with Windows or Linux, see [here](/BuildInfo.md) For guides to [running the .dsp File](/BuildInfo.md#running-the-faust-dsp-file), [building the Juce project](/BuildInfo.md#building-the-juce-project), and [Converting from Faust to Juce](/BuildInfo.md#how-to-get-from-faust-to-juce).

* For MacOS
  * Download the latest release [here](https://github.com/JDCAudio/Stray_virtual-synth/releases/tag/v1.2)
  
# Sound Demo
https://user-images.githubusercontent.com/105126223/206938867-823c1570-6684-4d7a-98ff-3f649ca423b0.mp4
* Sound Demo using Version 1.2 of Stray. Midi coming from Arturia Beatstep. 

# Structure of this Repository
* [FaustTests](/FaustTests)
  * [FaustFamiliarization](/FaustTests/FaustFamiliarization) 
    * An arrangement of various small Faust projects that I created while learning the language. Many of the projects were the result of following along with the online Kadenze [course](https://www.kadenze.com/courses/real-time-audio-signal-processing-in-faust/info)
  * [FaustToJuceTESTS](/FaustTests/FaustToJuceTESTS)
    * My first (unsuccessful) attempt at converting a Faust project to Juce
  * [FaustToJuce_Functional](/FaustTests/FaustToJuce_Functional)
    * My first (successful) attempt at converting a Faust project to Juce
* [Resources](/Resources) 
  * Contains a single file of links used for personal reference while working on this project
* [Stray](/Stray)
  * Contains a folder for each release version of Stray. The structure of the most current version is as follows:
  * [1_2](/Stray/1_2)
    * [FaustDSP](/Stray/1_2/FaustDSP)
      * Contains a single Faust .dsp File
    * [JuceProject](/Stray/1_2/JuceProject)
      * Contains a Juce Project File (.jucer) and the Juce project source code (.cpp)
    * [builds](/Stray/1_2/builds)
      * Contains a standalone (.app) and VST (.vst3) version of Stray
      * These builds are compatible only with MacOS
* [WaveGenerationTests](/WaveGenerationTests)
  * Testing in Faust that led to the Synthesis technique used in Stray
    * [OriginalTests](/Stray/OriginalTests)
    * [lfoAmplitudeControl](/Stray/lfoAmplitudeControl)
    * [smoothCrossing.dsp](/Stray/smoothCrossing.dsp)
* [BuildInfo.md](/BuildInfo.md)
  * Instructions explaining how to run the Faust source code, build the Juce project, and the process of converting a Faust project to Juce
* [HowItWorks.md](/HowItWorks.md)
  * In Depth explanation of the Synthesis technique used in Stray
