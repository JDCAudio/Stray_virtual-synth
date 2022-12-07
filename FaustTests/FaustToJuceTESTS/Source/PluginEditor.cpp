/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
FAUST2JUCEAudioProcessorEditor::FAUST2JUCEAudioProcessorEditor (FAUST2JUCEAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
    setSize (800, 130);

        addAndMakeVisible(freqSlider);
        freqSlider.setRange(50.0, 5000.0);
        freqSlider.setSkewFactorFromMidPoint(500.0);
        freqSlider.setValue(300);
        freqSlider.onValueChange = [this] {
            processor.setFreq(freqSlider.getValue());
        };

        addAndMakeVisible(freqLabel);
        freqLabel.setText("Frequency", juce::dontSendNotification);
        freqLabel.attachToComponent(&freqSlider, true);


        addAndMakeVisible(onOffButton);
        onOffButton.onClick = [this] {
            processor.setGate(onOffButton.getToggleState());
        };

        addAndMakeVisible(onOffLabel);
        onOffLabel.setText("On/Off", juce::dontSendNotification);
        onOffLabel.attachToComponent (&onOffButton, true);
}

FAUST2JUCEAudioProcessorEditor::~FAUST2JUCEAudioProcessorEditor()
{
}

//==============================================================================
void FAUST2JUCEAudioProcessorEditor::paint (juce::Graphics& g)
{
    // (Our component is opaque, so we must completely fill the background with a solid colour)
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));

    g.setColour (juce::Colours::white);
    g.setFont (15.0f);
    g.drawFittedText ("Hello World!", getLocalBounds(), juce::Justification::centred, 1);
}

void FAUST2JUCEAudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..
}
