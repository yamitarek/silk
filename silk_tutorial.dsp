import("stdfaust.lib");
//creators:
//gonzaloggr10
//yamitarek

// OSCILLATOR SYNTHESIS

// Set of wave generators
oscSynth = vgroup("[0]Oscillator Synthesis",checkbox("[0]Gate")*sum(i,4,waveGenerator(i)));

// Wave generator
waveGenerator (x) = hgroup("[%x]Wave Generator %x",wave*waveGain*checkbox("[0]Gate"))
with{
    wave = sineTimbre,triangleTimbre,squareTimbre,sawTimbre : ba.selectn(4,waveSel);
    waveSel = nentry("[1]Waveform",0,0,3,1);
    sineTimbre = os.osc(freq)*0.5 + os.osc(freq*2)*0.25 + os.osc(freq*3)*0.125;
    triangleTimbre = os.triangle(freq); // TODO: Add overtones. How many and how?
    squareTimbre = os.square(freq);
    sawTimbre = os.sawtooth(freq);
    waveGain = hslider("[2]gain[style:knob]",1,0,1,0.01);
    freq = hslider("[3]freq",440,50,2000,0.01); // Metadata label should be exactly "freq"
    // freq = button("[3]freq"); // for simplicity
};


// MODULATION

// Set of AM and FM modulation
modulationSet = vgroup("[1]Modulation",amMod);

// AM Modulation
amMod = hgroup("[0]AM Modulation",modulator)
with{
    modulator = ((1-modDepth) + (wave*0.5+0.5)*modDepth);
    wave = os.osc(modFreq),os.triangle(modFreq),os.square(modFreq),os.sawtooth(modFreq) : ba.selectn(4,waveSel);
    waveSel = nentry("[0]Waveform",0,0,3,1);
    modFreq = hslider("[1]Modulator Frequency[style:knob]",20,0.1,2000,0.01);
    modDepth = hslider("[2]Modulator Depth[style:knob]",0,0,1,0.01);
};


// ENVELOPE

envelope = hgroup("[1]Envelope",en.adsr(attack,decay,sustain,release,gate)*gain*4) // TODO: Multiply by 0.3 to scale the addition of several voices and avoid clicking. But actually is already to quiet... I will in fact increase the output for now with a x4 factor.
with{
    attack = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.0001;
    decay = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.0001;
    sustain = hslider("[2]Sustain[style:knob]",0.8,0.01,1,0.01);
    release = hslider("[3]Release[style:knob]",50,1,1000,1)*0.0001;
    gain = hslider("[4]gain[style:knob]",1,0,1,0.01);
    gate = button("[5]gate");
};

// SUBTRACTIVE FILTER

// vcf
vcf = hgroup("[2]Filter", fi.resonlp(resFreq,q,1))
with{
ctFreq = hslider("[0]Cutoff Frequency[style:knob]", 2000, 50, 10000, 0.1);
q = hslider("[1]Q[style:knob]", 5, 1, 30, 0.1);
lfoFreq=hslider("[2]lfo Freq[style:knob]", 10,0.1,20,0.01);
lfoDepth=hslider("[3]depth[style:knob]", 500,1,10000,1);
resFreq = ctFreq + os.osc(lfoFreq)*lfoDepth : max(30);
};


// PROCESS

synthTypes = hgroup("[0]Synthesis Type", oscSynth*modulationSet);
mySynth = vgroup("My Synth", synthTypes*envelope:vcf <: _,_); 

process = mySynth;


// EFFECT
effect = dm.zita_light;
