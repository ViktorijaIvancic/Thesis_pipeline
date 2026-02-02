% removing ICA components 

clear; clc;
run('00_setup.m');

stageInFolder  = fullfile(preprocessed_folder,'stage04_ica');
stageFolder = fullfile(preprocessed_folder,'stage05_remove_components');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};

inFile = fullfile(stageInFolder, [participant '_stage04.mat']);
loaded = load(inFile, 'ica', 'data_rej', 'layout');
ica = loaded.ica;
data_rej = loaded.data_rej;
layout = loaded.layout;



cfg                 = [];
cfg.keeptrials      = 'yes';
d_ica               = ft_timelockanalysis(cfg, ica);
cfg.channel         = {'EOGv'};
d_eogv              = ft_timelockanalysis(cfg, data_rej);
cfg.channel         = {'EOGh'};
d_eogh              = ft_timelockanalysis(cfg, data_rej);

icaForPlot = ica;

numberOfTrials  = numel(icaForPlot.trial);
samplesPerTrial = numel(icaForPlot.time{1});
newSampleinfo   = zeros(numberOfTrials, 2);

for trialIndex = 1:numberOfTrials
    trialStartSample = (trialIndex - 1) * samplesPerTrial + 1;
    trialEndSample   =  trialIndex      * samplesPerTrial;
    newSampleinfo(trialIndex,:) = [trialStartSample, trialEndSample];
end

icaForPlot.sampleinfo = newSampleinfo;

cfg = [];
cfg.layout   = layout; % your layout
cfg.viewmode = 'component';
ft_databrowser(cfg, icaForPlot); % browse the time-course of bad components 

comp2rem = input('bad components is: '); % insert the bad components values

component_indices_to_remove = comp2rem;

reject_config = [];
reject_config.component = component_indices_to_remove;

data_cleaned = ft_rejectcomponent(reject_config, ica, data_rej);

outFile = fullfile(stageFolder, [participant '_stage05.mat']);
save(outFile, 'data_cleaned', '-v7.3');

end
