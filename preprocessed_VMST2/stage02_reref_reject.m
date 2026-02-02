% re-referecing and inspecting trials 

clear; clc;

run('00_setup.m');

stageInFolder  = fullfile(preprocessed_folder,'stage01_epoch_preproc');
stageFolder = fullfile(preprocessed_folder,'stage02_reref_reject');
if ~exist(stageFolder,'dir'); mkdir(stageFolder); end

for subjectIndex = 1:numel(subjectlist)
participant = subjectlist{subjectIndex};


inFile = fullfile(stageInFolder, [participant '_stage01.mat']);
loaded = load(inFile, 'data');
data = loaded.data;

% re-referencing to mastoid LM (implicit) and RM mastoid ref electrodes 
cfg                         = [];
cfg.implicitref             = 'LM';
cfg.reref                   = 'yes';
cfg.refchannel              = {'LM','RM'};
data_ref                    = ft_preprocessing(cfg, data);

cfg                         = [];
cfg.channel                 = setdiff(1:65, [9,65]);
data_ref                    = ft_selectdata(cfg, data_ref);

cfg                         = [];
cfg.demean                  = 'yes'; 
cfg.xlim                    = [-1 1];
cfg.viewmode                = 'vertical';
cfg.alim                    = [0 50];
cfg_rej                     = ft_databrowser(cfg,data_ref);
        
cfg_rej                     = rmfield(cfg_rej,'trl');
data_rej                    = ft_rejectartifact(cfg_rej,data_ref);

% visual inspection (and rejection) of trials

cfg = [];
cfg.viewmode = 'butterfly';
cfg.continuous = 'yes';
ft_databrowser(cfg, data_rej);

cfg = [];
cfg.channel = setdiff(data_rej.label, {});
data_rej= ft_selectdata(cfg, data_rej);

outFile = fullfile(stageFolder, [participant '_stage02.mat']);
save(outFile, 'data_rej', '-v7.3');

end
