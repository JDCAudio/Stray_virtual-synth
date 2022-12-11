# What Is 'Stray'?
A typical wavetable synthesizer will have a table of predetermined amplitude values which are read through at the appropriate speed relative to the frequency of the current note, resulting in an audible signal. Stray functions similarly, reading through a table of values, but the amplitude values are not predefined. Instead, these values are modulated with one of four LFO shapes.

For an in depth explanation of how Stray works, click [here](/HowItWorks.md)

# Sound Demo
-- Sound Demo Video to be added here --

# Downloading Stray
Builds provided in this repository are compatible only with MacOS. For a standalone or VST version compatible with Windows or Linux, see directions for [Building the Juce Project](/BuildInfo.md#building-the-juce-project). Alternatively, to run and test the code within a browser, see [here](/BuildInfo.md#running-the-faust-dsp-file) how to run the Faust (.dsp) file.

* For MacOS
  * Download the latest standalone version [here](/Stray/1_1/builds/stray_1_1.app)
  * Download the latest VST3 version [here](/Stray/1_1/builds/stray_1_1.vst3)

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
  * [1_1](/Stray/1_1)
    * [FaustDSP](/Stray/1_1/FaustDSP)
      * Contains a single Faust .dsp File
    * [JuceProject](/Stray/1_1/JuceProject)
      * Contains a Juce Project File (.jucer) and the Juce project source code (.cpp)
    * [builds](/Stray/1_1/builds)
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
