% filtering and epoching 
clear; clc;

run('setup_0.m');

stageFolder = fullfile(preprocessed_folder,'stage01_epoch_preproc');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};

% epoching
cfg                         = [];
cfg.dataset = fullfile(EEG_recording_folder, [participant '.vhdr']);
cfg.trialfun                = 'ft_trialfun_general';
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.prestim        = 2;
cfg.trialdef.poststim       = 2;
cfg.trialdef.eventvalue     = {'S221' 'S222' 'S231' 'S232' 'S241' 'S242' 'S251' 'S252'};
cfg_target                  = ft_definetrial(cfg); clc;
cfg.trialdef.eventvalue     = {'S212' 'S213'};
cfg_correct                 = ft_definetrial(cfg); clc;

% epoched data trial info 

data.trialinfo(:,2)         = ~mod(round((data.trialinfo(:,1)-200)/10),2);
data.trialinfo(:,3)         = data.trialinfo(:,1) - ((round((data.trialinfo(:,1)-200)/10)*10)+200);
data.trialinfo(data.trialinfo(:,1) < 240,4) = 2;
data.trialinfo(data.trialinfo(:,1) > 240,4) = 8;
[rt_vector,correct_vector]  = func_extract_rt(cfg_target,data);
data.trialinfo(:,5:6)       = rt_vector;
data.trialinfo(:,7)         = correct_vector;
data.trialinfo(:,8)         = 1:length(data.trial);
data.trialinfo              = array2table(data.trialinfo,"VariableNames",{'code' 'target' 'side' 'load' 'response' 'rt' 'correct' 'number'});

%filter
cfg.bsfilter             	= 'yes';
cfg.bsfreq               	= [49 51; 99 101; 149 151]; %line noise filter
data                        = ft_preprocessing(cfg_target);

outFile = fullfile(stageFolder, [participant '_stage01.mat']);
save(outFile, 'data', '-v7.3');

end