/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"
#include "VariableAmpClipped.h"

//==============================================================================
FAUST2JUCEAudioProcessor::FAUST2JUCEAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
                       )
#endif
{
}

FAUST2JUCEAudioProcessor::~FAUST2JUCEAudioProcessor()
{
}

//==============================================================================
const juce::String FAUST2JUCEAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool FAUST2JUCEAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool FAUST2JUCEAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool FAUST2JUCEAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double FAUST2JUCEAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int FAUST2JUCEAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int FAUST2JUCEAudioProcessor::getCurrentProgram()
{
    return 0;
}

void FAUST2JUCEAudioProcessor::setCurrentProgram (int index)
{
}

const juce::String FAUST2JUCEAudioProcessor::getProgramName (int index)
{
    return {};
}

void FAUST2JUCEAudioProcessor::changeProgramName (int index, const juce::String& newName)
{
}

//==============================================================================
void FAUST2JUCEAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
        fDSP = new dsp();
        fDSP->init(sampleRate);
        fUI = new MapUI();
        fDSP->buildUserInterface(fUI);
        outputs = new float*[2];
        for (int channel = 0; channel < 2; ++channel) {
            outputs[channel] = new float[samplesPerBlock];
        }
}

void FAUST2JUCEAudioProcessor::releaseResources()
{
    delete fDSP;
        delete fUI;
        for (int channel = 0; channel < 2; ++channel) {
            delete[] outputs[channel];
        }
        delete [] outputs;
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool FAUST2JUCEAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    juce::ignoreUnused (layouts);
    return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
    // Some plugin hosts, such as certain GarageBand versions, will only
    // load plugins that support stereo bus layouts.
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void FAUST2JUCEAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
        auto totalNumInputChannels = getTotalNumInputChannels();
        auto totalNumOutputChannels = getTotalNumOutputChannels();

        fDSP->compute(buffer.getNumSamples(),NULL,outputs);

        for (int channel = 0; channel < totalNumOutputChannels; ++channel) {
            for (int i = 0; i < buffer.getNumSamples(); i++) {
                *buffer.getWritePointer(channel,i) = outputs[channel][i];
            }
        }
}

//==============================================================================
bool FAUST2JUCEAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* FAUST2JUCEAudioProcessor::createEditor()
{
    return new FAUST2JUCEAudioProcessorEditor (*this);
}

//==============================================================================
void FAUST2JUCEAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
}

void FAUST2JUCEAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
}

void FAUST2JUCEAudioProcessor::setFreq (float freq){
    fUI->setParamValue("freq", freq);
}
void FAUST2JUCEAudioProcessor::setGate (bool gate){
    if(gate)
        fUI->setParamValue("[1]Envelope/gate",1);
    else
        fUI->setParamValue("[1]Envelope/gate", 1);
}
void FAUST2JUCEAudioProcessor::setA0 (float A0){
    fUI->setParamValue("[2]Amplitudes/A0", A0);
}
void FAUST2JUCEAudioProcessor::setA1 (float A1){
    fUI->setParamValue("[2]Amplitudes/A1", A1);
}
void FAUST2JUCEAudioProcessor::setA2 (float A2){
    fUI->setParamValue("[2]Amplitudes/A2", A2);
}
void FAUST2JUCEAudioProcessor::setA3 (float A3){
    fUI->setParamValue("[2]Amplitudes/A3", A3);
}
void FAUST2JUCEAudioProcessor::setA4 (float A4){
    fUI->setParamValue("[2]Amplitudes/A4", A4);
}
void FAUST2JUCEAudioProcessor::setA5 (float A5){
    fUI->setParamValue("[2]Amplitudes/A5", A5);
}


//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new FAUST2JUCEAudioProcessor();
}


