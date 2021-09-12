# SILK. Building a synth plugin in Faust

SILK is a synthesizer AU/VST plugin written in Faust. This readme covers the Faust code and fundamentals of the algorithms, as well as workflow routines to transfer the Faust code into a playable AU/VST Plugin.

## Introduction
Synth plugins are used for synthesizing sounds with the help of oscillators, different waveforms, filters, modulation and other tools. They usually run within a DAW, and they are very often virtual recreations of real hardware synths. The SILK plugin is the result of our project for the course *Sound Synthesis: Building Instruments* in *Faust* in the summer semester of 2020 at TU Berlin. The main two goals of the project were to develop our own synthesizer in the *Faust* programming language and to take it into a plugin that could be used in a DAW.


## Faust Project
### Features Overview

