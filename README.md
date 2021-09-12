# SILK. Building a synth plugin in Faust

SILK is a synthesizer AU/VST plugin written in Faust. This readme covers the Faust code and fundamentals of the algorithms, as well as workflow routines to transfer the Faust code into a playable AU/VST Plugin.

## Introduction
Synth plugins are used for synthesizing sounds with the help of oscillators, different waveforms, filters, modulation and other tools. They usually run within a DAW, and they are very often virtual recreations of real hardware synths. The SILK plugin is the result of our project for the course *Sound Synthesis: Building Instruments* in *Faust* in the summer semester of 2020 at TU Berlin. The main two goals of the project were to develop our own synthesizer in the *Faust* programming language and to take it into a plugin that could be used in a DAW.

\textit{Faust} (Functional Audio Stream) is a functional programming language for sound synthesis and audio processing with a strong focus on the design of synthesizers, musical instruments, audio effects, etc., and it targets high-performance signal processing applications and audio plug-ins for a variety of platforms and standards \cite{FAUST}. Using \textit{Faust} allows us to build complex signal processing algorithms in a simple way: its compiler can ``translate" any \textit{Faust} digital signal processing (DSP) specification to a wide range of non-domain specific languages. We get a very simple syntax and great libraries that contain oscillators, effects, filters, and more ready to use. Finally, code generated in \textit{Faust} can be compiled in a wide variety of objects, such as plugins, standalone apps, or smartphone apps.

The first part of this paper talks about the \textit{Faust} code of our synthesizer. Afterward, the workflow for obtaining a plugin from there is presented.

![silk-gui](https://github.com/yamitarek/silk/blob/main/Images/silk-gui-qt.jpg)

# Faust Project

In this section we explain the code and algorithms of the *Faust*
project for SILK.

## Features Overview

SILK has three wave generators, four waveforms (sine, triangle, square
and sawtooth), a subtractive filter, AM modulation, an ADSR envelope,
reverb, and supports up to 32 simultaneous voices (see Figure [1][]).

<figure>
<img src="Figures/silk-gui-qt.jpg" id="fig:silk_gui_qt" style="width:35.0%" alt="Qt interface of the SILK synthesizer in the Faust IDE" /><figcaption aria-hidden="true">Qt interface of the SILK synthesizer in the <em>Faust IDE</em></figcaption>
</figure>

## Process Line

Before we dive into the individual parts that are involved in the signal
processing of our synthesizer, let’s take a look at the bigger picture.
The most fundamental part of any *Faust* program is the *process* line.
In this part of the code, we pass the desired inputs and outputs to the
target. This is a dynamic system, meaning that we can just type in any
number and arrangement of inputs and outputs at the right side of the
equal sign, and it will adjust to it providing the program with inputs
and outputs as needed .

  [1]: #fig:silk_gui_qt

