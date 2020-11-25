import("stdfaust.lib");


// OSCILLATOR SYNTHESIS

// Set of wave generators
oscSynth = vgroup("[0]Oscillator synthesis",waveGenerator1+waveGenerator2+waveGenerator3);

// Wave generators
freq = hslider("[2]freq",440,50,2000,0.01);
waveGenerator(wSel,wGain) = wave*wGain
with{
    wave = sineTimbre,triangleTimbre,squareTimbre,sawTimbre : ba.selectn(4,wSel);
    sineTimbre = os.osc(freq)*0.5 + os.osc(freq*2)*0.25 + os.osc(freq*3)*0.125;
    triangleTimbre = os.triangle(freq)*0.5 + os.triangle(freq*2)*0.25 + os.triangle(freq*3)*0.125;
    squareTimbre = os.square(freq)*0.5;
    sawTimbre = os.sawtooth(freq)*0.5;
};

waveGenerator1 = hgroup("Wave generator 1",waveGenerator(waveSel,waveGain))
with{
    waveSel = nentry("[0]Waveform",0,0,3,1);
    waveGain = hslider("[1]Gain[style:knob]",1,0,1,0.01);
};

waveGenerator2 = hgroup("Wave generator 2",checkbox("[3]Gate")*waveGenerator(waveSel,waveGain))
with{
    waveSel = nentry("[0]Waveform",0,0,3,1);
    waveGain = hslider("[1]Gain[style:knob]",1,0,1,0.01);
};

waveGenerator3 = hgroup("Wave generator 3",checkbox("[3]Gate")*waveGenerator(waveSel,waveGain))
with{
    waveSel = nentry("[0]Waveform",0,0,3,1);
    waveGain = hslider("[1]Gain[style:knob]",1,0,1,0.01);
};


// AM MODULATION

amMod = vgroup("[3]AM Modulation",modulator)
with{
    modulator = ((1-modDepth) + (wave*0.5+0.5)*modDepth);
    wave = os.osc(modFreq),os.triangle(modFreq),os.square(modFreq),os.sawtooth(modFreq) : ba.selectn(4,waveSel);
    waveSel = nentry("[0]Waveform",0,0,3,1);
    modFreq = hslider("[1]Modulator frequency[style:knob]",20,0.1,2000,0.01);
    modDepth = hslider("[2]Modulator depth[style:knob]",0,0,1,0.01);
};


// ENVELOPE

envelope = hgroup("[1]Envelope",en.adsr(attack,decay,sustain,release,gate)*gain) // TODO: scale
with{
    attack = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.0001;
    decay = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.0001;
    sustain = hslider("[2]Sustain[style:knob]",0.8,0.01,1,0.01);
    release = hslider("[3]Release[style:knob]",50,1,2000,1)*0.0001;
    gain = hslider("[4]gain[style:knob]",1,0,1,0.01);
    gate = button("[5]gate");
};

// SUBTRACTIVE FILTER

// vcf
vcf = vgroup("[1]Subtractive", fi.resonlp(resFreq,q,1))
with{
ctFreq = hslider("[0]Cutoff Frequency[style:knob]", 2000, 50, 10000, 0.1);
q = hslider("[1]Q[style:knob]", 5, 1, 30, 0.1);
lfoFreq=hslider("[2]LFO Freq[style:knob]", 10,0.1,20,0.01);
lfoDepth=hslider("[3]Depth[style:knob]", 500,1,10000,1);
resFreq = ctFreq + os.osc(lfoFreq)*lfoDepth : max(30);
};


// PROCESS

synthTypes = hgroup("[0]Synthesis", oscSynth*amMod : ba.bypass1(bypassSwitchSub,vcf));
mySynth = vgroup("Silk", synthTypes*envelope <: _,_);
bypassSwitchSub = checkbox("[2]Subtractive bypass");

process = mySynth;


// EFFECT
effect = dm.zita_light;