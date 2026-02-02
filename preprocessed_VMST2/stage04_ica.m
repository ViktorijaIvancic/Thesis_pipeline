% ICA 
clear; clc;
run('00_setup.m');

stageInFolder  = fullfile(preprocessed_folder,'stage03_eog_append');
stageFolder = fullfile(preprocessed_folder,'stage04_ica');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};

inFile = fullfile(stageInFolder, [participant '_stage03.mat']);
loaded = load(inFile, 'data_rej', 'layout');
data_rej = loaded.data_rej;
layout = loaded.layout;

cfg                 = [];
cfg.method          = 'runica';
ica                 = ft_componentanalysis(cfg, data_rej);

cfg                     = [];
cfg.comment             = 'yes';
cfg.marker              = 'on';
cfg.layout              = layout;
cfg.component           = 1:59;
ft_topoplotIC(cfg,ica); clc;

outFile = fullfile(stageFolder, [participant '_stage04.mat']);
save(outFile, 'ica', 'data_rej', 'layout', '-v7.3');

end
