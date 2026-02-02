# EEG time–frequency analysis & alpha lateralisation pipeline for MATLAB FieldTrip

This repository contains selected code from my thesis project investigating the cognitive and neural mechanisms underlying hybrid search. Since hybrid search combines memory search and visual search, the analyses focus on alpha-band power lateralisation, a neural marker associated with visuospatial attention and WM maintenance.

One of the questions was to examine whether reliable alpha lateralisation emerges post-stimulus onset in the absence of explicit spatial cues, and how this lateralisation is modulated by working-memory load and target presence.

The experiment used a 2 × 2 factorial design manipulating memory load (MSS2 vs MSS8) and target presence (target present vs target absent), with two stimuli presented laterally in the left and right visual field. The code implements sensor-level preprocessing, ICA-based artefact rejection, time–frequency decomposition, and computation of contralateral versus ipsilateral alpha power and alpha lateralisation indices across conditions.

