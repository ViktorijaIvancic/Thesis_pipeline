# EEG time–frequency analysis & alpha lateralisation pipeline for MATLAB FieldTrip

This repository contains selected analysis scripts from my Research Master’s thesis project, which I conducted as part of an ongoing research project investigating the cognitive and neural mechanisms underlying hybrid search. Since hybrid search combines memory search and visual search, the analyses focus on alpha-band power lateralisation, a neural marker associated with visuospatial attention and WM maintenance.

These scripts address one of the main questions of my thesis: whether reliable alpha lateralisation emerges following stimulus onset in the absence of explicit spatial cues, and how this lateralisation is modulated by memory load and target presence.

The experiment used a 2 × 2 factorial design manipulating memory load (MSS2 vs MSS8) and target presence (target present vs target absent), with two stimuli presented laterally in the left and right visual field. The code implements sensor-level preprocessing, ICA-based artefact rejection, time–frequency decomposition, and computation of contralateral versus ipsilateral alpha power and alpha lateralisation indices across conditions.

## Project structure

```
.
├── preprocessed_VMST2/                   # preprocessing pipeline
│   ├── setup_0.m                         # path setup
│   ├── stage01_epoch_preproc.m           # epoching & initial preprocessing
│   ├── stage02_reref_reject.m            # re-referencing & visual inspection
│   ├── stage03_eog_append.m              # append/create EOG channels
│   ├── stage04_ica.m                     # ICA computation
│   ├── stage05_remove_components.m       # remove artifactual ICs
│   ├── stage06_heog_trial_reject.m       # HEOG-based trial rejection
│   └── stage07_final_reject.m            # final visual trial rejection
│
├── alpha_lateralisation_tfr_VMST2/       # time–frequency & alpha lateralisation analyses
│   ├── computeTF.m                       # time–frequency analysis (1–40 Hz)
│   ├── setup_li_power.m                  # analysis parameters (channels, etc.)
│   ├── stage01_compute_li_and_power.m    # compute contra/ipsi power & LI
│   ├── stage02_topoplots_by_condition.m  # topoplots per condition
│   ├── stage03_TFRmaps_contraipsi.m      # TFR maps (contra vs ipsi)
│   └── stage04_plot_TFR_by_condition.m   # TFR plots per condition
│
└── README.md

```

First, complete the preprocessing steps in the outlined order. Following that, run computeTF.m. Follow the rest of the files in order, outlined above.  

## Requirements
- MATLAB (R2021a or newer)
- FieldTrip toolbox
- Signal Processing Toolbox

## Installation
1. Clone or download this repository.
2. Download FieldTrip and add it to your MATLAB path.
3. Run scripts setup_0.m to configure paths.

## Input Data
Continuous EEG recorded with BrainVision Recorder software (Brain Products, Munich, Germany)
Native BrainVision file: .vhdr (header), .vmrk (marker), .eeg 

Data was imported into MATLAB using FieldTrip and converted to FieldTrip raw structures
Event markers encode:
- Memory load (MSS2, MSS8)
- Target presence (present, absent)
- Target side (left, right)

Note. The preprocessing pipeline converts continuous BrainVision data into clean, epoched FieldTrip .mat files, which are subsequently used for time–frequency and alpha lateralisation analyses.

## Dataset sharing 

Due to participant privacy regulations and data protection agreements, raw and preprocessed EEG data cannot be shared publicly. In addition, the experimental paradigm is part of ongoing work. Finally, the scripts are provided as an example of the analysis approach used in this project. 
Users are expected to modify paths, parameters, and condition definitions to match their own data.
