/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"

//==============================================================================
/**
*/
class FAUST2JUCEAudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    FAUST2JUCEAudioProcessorEditor (FAUST2JUCEAudioProcessor&);
    ~FAUST2JUCEAudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    juce::Slider freqSlider;
    juce::Slider a0Slider;
    juce::Slider a1Slider;
    juce::Slider a2Slider;
    juce::Slider a3Slider;
    juce::Slider a4Slider;
    juce::Slider a5Slider;
    juce::ToggleButton onOffButton;
    
    juce::Label freqLabel;
    juce::Label onOffLabel;
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    FAUST2JUCEAudioProcessor& audioProcessor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (FAUST2JUCEAudioProcessorEditor)
};
