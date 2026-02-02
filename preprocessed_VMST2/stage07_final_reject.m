% remove residual trials with excessive variance 

clear; clc;
run('00_setup.m');

stageInFolder  = fullfile(preprocessed_folder,'stage06_heog_trial_reject');
stageFolder = fullfile(preprocessed_folder,'stage07_final_reject');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};

inFile = fullfile(stageInFolder, [participant '_stage06.mat']);
loaded = load(inFile, 'data_no_artifacts');
data_no_artifacts = loaded.data_no_artifacts;

cfg                 = [];
cfg.method          = 'channel';
data_no_artifacts   = ft_rejectvisual(cfg, data_no_artifacts);

cfg                 = [];
cfg.channel         = [1:59];
cfg.method          = 'summary';
configReject.alim   = 0.8;
data_clean          = ft_rejectvisual(cfg, data_no_artifacts);

outFile = fullfile(stageFolder, [participant '_cleaned.mat']);
save(outFile, 'data_clean', '-v7.3');

end
